import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../../activity/application/kids_activity_log_service.dart';
import '../../activity/domain/kids_activity_models.dart';
import '../../../progression/application/learner_progression_service.dart';
import '../../../progression/domain/learner_progression_models.dart';
import '../domain/bedtime_story_models.dart';
import 'bedtime_active_learner_service.dart';
import 'bedtime_story_repository.dart';

const legacyBedtimeStoryProgressKey = 'kids.bedtime_stories.progress.v1';

final bedtimeStoryProgressProvider =
    StateNotifierProvider<
      BedtimeStoryProgressController,
      BedtimeStoryLibraryProgress
    >((ref) {
      final controller = BedtimeStoryProgressController(ref);
      ref.listen<String>(
        bedtimeActiveLearnerProvider.select((value) => value.learnerId),
        (_, next) => controller.updateActiveLearner(next),
      );
      return controller;
    });

class BedtimeStoryProgressController
    extends StateNotifier<BedtimeStoryLibraryProgress> {
  BedtimeStoryProgressController(this._ref)
    : _store = _ref.read(localStoreProvider),
      _activeLearnerId = _ref.read(bedtimeActiveLearnerProvider).learnerId,
      super(
        BedtimeStoryLibraryProgress.fromJson(
          _ref.read(localStoreProvider).getJsonMap(
            bedtimeStoryProgressStorageKeyForLearner(
              _ref.read(bedtimeActiveLearnerProvider).learnerId,
            ),
          ),
        ),
      ) {
    _migrateLegacyProgressIfNeeded();
    _ensureEveryStoryHasProgress();
  }

  final Ref _ref;
  final LocalStore _store;
  String _activeLearnerId;

  BedtimeStoryProgress progressFor(String storyId) {
    return state.storyProgressById[storyId] ?? const BedtimeStoryProgress();
  }

  void openStory(String storyId, {DateTime? occurredAt}) {
    final now = occurredAt ?? DateTime.now();
    final current = progressFor(storyId);
    final next = current.copyWith(
      startedAtIso: current.startedAtIso ?? now.toIso8601String(),
      lastAccessedAtIso: now.toIso8601String(),
    );
    _writeStoryProgress(storyId, next);
    final story = _ref.read(bedtimeStoryByIdProvider(storyId));
    _ref.read(kidsActivityLogProvider.notifier).log(
      type: KidsActivityType.storyOpened,
      domain: KidsActivityDomain.stories,
      sourceRef: 'bedtime_story_open:$storyId',
      contentId: storyId,
      titleSnapshot: story?.shortTitle ?? story?.title,
      subtitleSnapshot: story?.lesson,
      occurredAt: now,
      dedupeWindow: const Duration(minutes: 2),
      metadata: <String, Object?>{
        'feature': 'kids_bedtime_story',
        'storyId': storyId,
        'bedtimeLearnerId': _activeLearnerId,
      },
    );
    _persist();
  }

  void recordPlaybackSnapshot({
    required String storyId,
    required Duration currentPosition,
    required Duration totalDuration,
    required BedtimeStoryPlaybackSource source,
    DateTime? occurredAt,
  }) {
    final now = occurredAt ?? DateTime.now();
    final current = progressFor(storyId);
    final previousPositionMs = current.currentPositionMs;
    final currentPositionMs = currentPosition.inMilliseconds.clamp(0, 1 << 31);
    final totalDurationMs = totalDuration.inMilliseconds.clamp(0, 1 << 31);
    final deltaMs = currentPositionMs > previousPositionMs
        ? currentPositionMs - previousPositionMs
        : 0;
    final next = current.copyWith(
      startedAtIso: current.startedAtIso ?? now.toIso8601String(),
      lastAccessedAtIso: now.toIso8601String(),
      lastPlayedAtIso: now.toIso8601String(),
      currentPositionMs: currentPositionMs,
      totalDurationMs: totalDurationMs,
      totalListenedMs: current.totalListenedMs + deltaMs,
      lastPlaybackSource: source,
    );
    _writeStoryProgress(storyId, next);
    _persist();
  }

  BedtimeStoryCompletionOutcome completeStory(
    BedtimeStorySeed story, {
    required String completionSource,
    DateTime? occurredAt,
  }) {
    final now = occurredAt ?? DateTime.now();
    final current = progressFor(story.id);
    final wasCompleted = current.isCompleted;
    final firstRewardGrant = !current.hasCompletionRewardGranted;
    final durationMs = current.totalDurationMs > 0
        ? current.totalDurationMs
        : story.estimatedDuration.inMilliseconds;
    final next = current.copyWith(
      startedAtIso: current.startedAtIso ?? now.toIso8601String(),
      lastAccessedAtIso: now.toIso8601String(),
      lastPlayedAtIso: now.toIso8601String(),
      completedAtIso: current.completedAtIso ?? now.toIso8601String(),
      currentPositionMs: durationMs,
      totalDurationMs: durationMs,
      completionRewardGrantedAtIso: firstRewardGrant
          ? now.toIso8601String()
          : current.completionRewardGrantedAtIso,
    );
    _writeStoryProgress(story.id, next);

    var xpAwarded = 0;
    var dropsAwarded = 0;
    if (!wasCompleted && firstRewardGrant) {
      final award = _ref
          .read(learnerProgressionControllerProvider(_activeLearnerId).notifier)
          .award(
            sourceRef: 'bedtime_story:${story.id}:complete',
            activityType:
                LearnerProgressionActivityType.bedtimeStoryCompletion,
            sourceModule: 'kids_bedtime_story',
            xp: story.xpReward,
            drops: story.oceanDropsReward,
            occurredAt: now,
            metadata: {
              'feature': 'kids_bedtime_story',
              'storyId': story.id,
              'storyFamilyId': story.effectiveStoryFamilyId,
              'prophetId': story.prophetId,
              'multipart': story.isMultipart,
              'partNumber': story.partNumber,
              'completionSource': completionSource,
              'bedtimeLearnerId': _activeLearnerId,
            },
            mirrorToJourney: _shouldMirrorRewardsToJourney(),
            incrementLearningStageCompletion: _shouldMirrorRewardsToJourney(),
          );
      xpAwarded = award.awardedXp;
      dropsAwarded = award.awardedDrops;
    }
    if (!wasCompleted) {
      _ref.read(kidsActivityLogProvider.notifier).log(
        type: KidsActivityType.storyCompleted,
        domain: KidsActivityDomain.stories,
        sourceRef: 'bedtime_story_complete:${story.id}',
        contentId: story.id,
        titleSnapshot: story.shortTitle,
        subtitleSnapshot: story.lesson,
        occurredAt: now,
        metadata: <String, Object?>{
          'feature': 'kids_bedtime_story',
          'storyId': story.id,
          'storyFamilyId': story.effectiveStoryFamilyId,
          'prophetId': story.prophetId,
          'completionSource': completionSource,
        },
      );
    }

    final seriesCompleted = _markSeriesCompletedIfReady(
      storyFamilyId: story.effectiveStoryFamilyId,
    );
    _persist();
    return BedtimeStoryCompletionOutcome(
      firstCompletion: !wasCompleted,
      xpAwarded: xpAwarded,
      dropsAwarded: dropsAwarded,
      seriesCompleted: seriesCompleted,
    );
  }

  void updateActiveLearner(String learnerId) {
    if (learnerId == _activeLearnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = BedtimeStoryLibraryProgress.fromJson(
      _store.getJsonMap(bedtimeStoryProgressStorageKeyForLearner(learnerId)),
    );
    _migrateLegacyProgressIfNeeded();
    _ensureEveryStoryHasProgress();
  }

  bool markSeriesCompleted(String storyFamilyId) {
    if (state.completedSeriesProphetIds.contains(storyFamilyId)) {
      return false;
    }
    state = state.copyWith(
      completedSeriesProphetIds: {
        ...state.completedSeriesProphetIds,
        storyFamilyId,
      },
    );
    _persist();
    return true;
  }

  void _ensureEveryStoryHasProgress() {
    final allStories = _ref.read(kidsIslamicStoriesProvider);
    final nextMap = Map<String, BedtimeStoryProgress>.from(state.storyProgressById);
    var changed = false;
    for (final story in allStories) {
      if (!nextMap.containsKey(story.id)) {
        nextMap[story.id] = const BedtimeStoryProgress();
        changed = true;
      }
    }
    if (changed) {
      state = state.copyWith(storyProgressById: nextMap);
      _persist();
    }
  }

  void _writeStoryProgress(String storyId, BedtimeStoryProgress progress) {
    final nextMap = Map<String, BedtimeStoryProgress>.from(state.storyProgressById)
      ..[storyId] = progress;
    final nextRecent = List<String>.from(state.recentStoryIds)
      ..remove(storyId)
      ..insert(0, storyId);
    if (nextRecent.length > 20) {
      nextRecent.removeRange(20, nextRecent.length);
    }
    state = state.copyWith(
      storyProgressById: nextMap,
      recentStoryIds: nextRecent,
    );
  }

  bool _markSeriesCompletedIfReady({required String storyFamilyId}) {
    final seriesStories = _ref
        .read(bedtimeStoryRepositoryProvider)
        .storiesForFamily(storyFamilyId);
    if (seriesStories.length <= 1) {
      return false;
    }
    final isComplete = seriesStories.every(
      (story) => progressFor(story.id).isCompleted,
    );
    if (!isComplete) {
      return false;
    }
    return markSeriesCompleted(storyFamilyId);
  }

  void _persist() {
    _store.setJsonMap(
      bedtimeStoryProgressStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void _migrateLegacyProgressIfNeeded() {
    final scopedKey = bedtimeStoryProgressStorageKeyForLearner(_activeLearnerId);
    final scoped = _store.getJsonMap(scopedKey);
    if (scoped != null) {
      state = BedtimeStoryLibraryProgress.fromJson(scoped);
      return;
    }
    final legacy = _store.getJsonMap(legacyBedtimeStoryProgressKey);
    if (legacy == null) {
      return;
    }
    state = BedtimeStoryLibraryProgress.fromJson(legacy);
    _store.setJsonMap(scopedKey, state.toJson());
    _store.remove(legacyBedtimeStoryProgressKey);
  }

  bool _shouldMirrorRewardsToJourney() {
    final learner = _ref.read(bedtimeActiveLearnerProvider);
    final accounts = _ref.read(accountsSyncControllerProvider);
    return learner.isLinkedChildProfile &&
        accounts.activeProfileId == learner.linkedChildProfileId;
  }
}
