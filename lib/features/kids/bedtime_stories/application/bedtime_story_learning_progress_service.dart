import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../../activity/application/kids_activity_log_service.dart';
import '../../activity/domain/kids_activity_models.dart';
import '../../../progression/application/learner_progression_service.dart';
import '../../../progression/domain/learner_progression_models.dart';
import '../domain/bedtime_story_learning_models.dart';
import 'bedtime_active_learner_service.dart';
import 'bedtime_story_repository.dart';

const legacyBedtimeStoryLearningProgressKey =
    'kids.bedtime_stories.learning_progress.v1';

final bedtimeStoryLearningProgressProvider =
    StateNotifierProvider<
      BedtimeStoryLearningProgressController,
      BedtimeStoryLearningProgressState
    >((ref) {
      final controller = BedtimeStoryLearningProgressController(ref);
      ref.listen<String>(
        bedtimeActiveLearnerProvider.select((value) => value.learnerId),
        (_, next) => controller.updateActiveLearner(next),
      );
      return controller;
    });

class BedtimeStoryLearningProgressController
    extends StateNotifier<BedtimeStoryLearningProgressState> {
  BedtimeStoryLearningProgressController(this._ref)
    : _store = _ref.read(localStoreProvider),
      _activeLearnerId = _ref.read(bedtimeActiveLearnerProvider).learnerId,
      super(
        BedtimeStoryLearningProgressState.fromJson(
          _ref
              .read(localStoreProvider)
              .getJsonMap(
                bedtimeStoryLearningProgressStorageKeyForLearner(
                  _ref.read(bedtimeActiveLearnerProvider).learnerId,
                ),
              ),
        ),
      ) {
    _migrateLegacyProgressIfNeeded();
  }

  final Ref _ref;
  final LocalStore _store;
  String _activeLearnerId;

  BedtimeStoryLearningActivityProgress progressFor(String activityId) {
    return state.progressByActivityId[activityId] ??
        const BedtimeStoryLearningActivityProgress(
          storyId: '',
          mode: BedtimeStoryLearningMode.quiz,
        );
  }

  void openActivity({
    required String activityId,
    required String storyId,
    required BedtimeStoryLearningMode mode,
    required int totalSteps,
    DateTime? occurredAt,
  }) {
    final now = occurredAt ?? DateTime.now();
    final current = progressFor(activityId);
    final next = current.copyWith(
      storyId: storyId,
      mode: mode,
      totalSteps: totalSteps,
      startedAtIso: current.startedAtIso ?? now.toIso8601String(),
      lastAccessedAtIso: now.toIso8601String(),
    );
    _writeProgress(activityId, next);
    _persist();
  }

  void recordStepProgress({
    required String activityId,
    required String storyId,
    required BedtimeStoryLearningMode mode,
    required int currentStepIndex,
    required int totalSteps,
    String? completedStepId,
    bool answeredCorrectly = false,
    DateTime? occurredAt,
  }) {
    final now = occurredAt ?? DateTime.now();
    final current = progressFor(activityId);
    final completedStepIds = List<String>.from(current.completedStepIds);
    var correctCount = current.correctCount;
    if (completedStepId != null && completedStepId.isNotEmpty) {
      final isNewCompletion = !completedStepIds.contains(completedStepId);
      if (isNewCompletion) {
        completedStepIds.add(completedStepId);
        if (answeredCorrectly) {
          correctCount += 1;
        }
      }
    }
    final next = current.copyWith(
      storyId: storyId,
      mode: mode,
      currentStepIndex: currentStepIndex,
      totalSteps: totalSteps,
      correctCount: correctCount,
      completedStepIds: completedStepIds,
      startedAtIso: current.startedAtIso ?? now.toIso8601String(),
      lastAccessedAtIso: now.toIso8601String(),
    );
    _writeProgress(activityId, next);
    _persist();
  }

  BedtimeStoryLearningCompletionOutcome completeActivity({
    required String activityId,
    required String storyId,
    required BedtimeStoryLearningMode mode,
    required int totalSteps,
    required int xpReward,
    required String sourceRef,
    required Map<String, Object?> metadata,
    DateTime? occurredAt,
  }) {
    final now = occurredAt ?? DateTime.now();
    final current = progressFor(activityId);
    final wasCompleted = current.isCompleted;
    final firstRewardGrant = !current.hasRewardGranted;
    final next = current.copyWith(
      storyId: storyId,
      mode: mode,
      currentStepIndex: totalSteps,
      totalSteps: totalSteps,
      startedAtIso: current.startedAtIso ?? now.toIso8601String(),
      lastAccessedAtIso: now.toIso8601String(),
      firstCompletedAtIso: current.firstCompletedAtIso ?? now.toIso8601String(),
      rewardGrantedAtIso: firstRewardGrant
          ? now.toIso8601String()
          : current.rewardGrantedAtIso,
    );
    _writeProgress(activityId, next);
    if (!wasCompleted && firstRewardGrant && _shouldMirrorRewardsToJourney()) {
      _ref
          .read(learnerProgressionControllerProvider(_activeLearnerId).notifier)
          .award(
            sourceRef: sourceRef,
            activityType: mode == BedtimeStoryLearningMode.quiz
                ? LearnerProgressionActivityType.bedtimeQuizCompletion
                : LearnerProgressionActivityType.bedtimeMemoryCompletion,
            sourceModule: 'kids_bedtime_story_learning',
            xp: xpReward,
            drops: 0,
            occurredAt: now,
            metadata: {...metadata, 'bedtimeLearnerId': _activeLearnerId},
            mirrorToJourney: true,
          );
    } else if (!wasCompleted && firstRewardGrant) {
      _ref
          .read(learnerProgressionControllerProvider(_activeLearnerId).notifier)
          .award(
            sourceRef: sourceRef,
            activityType: mode == BedtimeStoryLearningMode.quiz
                ? LearnerProgressionActivityType.bedtimeQuizCompletion
                : LearnerProgressionActivityType.bedtimeMemoryCompletion,
            sourceModule: 'kids_bedtime_story_learning',
            xp: xpReward,
            drops: 0,
            occurredAt: now,
            metadata: {...metadata, 'bedtimeLearnerId': _activeLearnerId},
          );
    }
    if (!wasCompleted) {
      final story = _ref.read(bedtimeStoryByIdProvider(storyId));
      _ref
          .read(kidsActivityLogProvider.notifier)
          .log(
            type: mode == BedtimeStoryLearningMode.quiz
                ? KidsActivityType.quizCompleted
                : KidsActivityType.memoryCompleted,
            domain: KidsActivityDomain.stories,
            sourceRef: sourceRef,
            contentId: storyId,
            titleSnapshot: story?.shortTitle ?? story?.title,
            subtitleSnapshot: story?.lesson,
            occurredAt: now,
            metadata: <String, Object?>{
              ...metadata,
              'feature': 'kids_bedtime_story_learning',
              'storyId': storyId,
              'mode': mode.name,
            },
          );
    }
    _persist();
    return BedtimeStoryLearningCompletionOutcome(
      firstCompletion: !wasCompleted,
      xpAwarded: !wasCompleted && firstRewardGrant ? xpReward : 0,
    );
  }

  void updateActiveLearner(String learnerId) {
    if (learnerId == _activeLearnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = BedtimeStoryLearningProgressState.fromJson(
      _store.getJsonMap(
        bedtimeStoryLearningProgressStorageKeyForLearner(learnerId),
      ),
    );
    _migrateLegacyProgressIfNeeded();
  }

  void _writeProgress(
    String activityId,
    BedtimeStoryLearningActivityProgress progress,
  ) {
    final nextMap = Map<String, BedtimeStoryLearningActivityProgress>.from(
      state.progressByActivityId,
    )..[activityId] = progress;
    final recent = List<String>.from(state.recentActivityIds)
      ..remove(activityId)
      ..insert(0, activityId);
    if (recent.length > 24) {
      recent.removeRange(24, recent.length);
    }
    state = state.copyWith(
      progressByActivityId: nextMap,
      recentActivityIds: recent,
    );
  }

  void _persist() {
    _store.setJsonMap(
      bedtimeStoryLearningProgressStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void _migrateLegacyProgressIfNeeded() {
    final scopedKey = bedtimeStoryLearningProgressStorageKeyForLearner(
      _activeLearnerId,
    );
    final scoped = _store.getJsonMap(scopedKey);
    if (scoped != null) {
      state = BedtimeStoryLearningProgressState.fromJson(scoped);
      return;
    }
    final legacy = _store.getJsonMap(legacyBedtimeStoryLearningProgressKey);
    if (legacy == null) {
      return;
    }
    state = BedtimeStoryLearningProgressState.fromJson(legacy);
    _store.setJsonMap(scopedKey, state.toJson());
    _store.remove(legacyBedtimeStoryLearningProgressKey);
  }

  bool _shouldMirrorRewardsToJourney() {
    final learner = _ref.read(bedtimeActiveLearnerProvider);
    final accounts = _ref.read(accountsSyncControllerProvider);
    return learner.isLinkedChildProfile &&
        accounts.activeProfileId == learner.linkedChildProfileId;
  }
}
