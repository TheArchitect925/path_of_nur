import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/accounts_sync/application/accounts_sync_controller.dart';
import '../../../features/learn/shared/application/learn_system_engine_provider.dart';
import '../../../features/kids/activity/application/kids_activity_log_service.dart';
import '../../../features/kids/activity/domain/kids_activity_models.dart';
import '../../../features/progression/application/learner_progression_service.dart';
import '../../../features/progression/domain/learner_progression_models.dart';
import '../../../shared/persistence/local_store.dart';
import 'kids_dua_active_learner_service.dart';
import '../data/kids_dua_seed_data.dart';
import '../domain/kids_dua_learning_models.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_retention_service.dart';
import 'kids_dua_sticker_service.dart';

const int kidsDuaLessonXp = 8;
const int kidsDuaLessonDrops = 1;
const int kidsDuaPracticeXp = 3;

final kidsDuaNowProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final kidsDuaLearningProvider =
    StateNotifierProvider<KidsDuaLearningNotifier, KidsDuaLearningState>((ref) {
      final controller = KidsDuaLearningNotifier(ref);
      ref.listen<String>(
        kidsDuaActiveLearnerProvider.select((value) => value.learnerId),
        (_, nextLearnerId) => controller.updateActiveLearner(nextLearnerId),
      );
      return controller;
    });

final kidsDuaContinueLessonProvider = Provider<KidsDuaLessonContent?>((ref) {
  final state = ref.watch(kidsDuaLearningProvider);
  for (final lessonId in state.recentLessonIds) {
    for (final lesson in kidsDuaStarterLessons) {
      if (lesson.id == lessonId &&
          state.progressByLessonId[lesson.id]?.status !=
              KidsDuaLessonStatus.learned) {
        return lesson;
      }
    }
  }
  for (final lesson in kidsDuaStarterLessons) {
    if (!state.learnedLessonIds.contains(lesson.id)) return lesson;
  }
  return kidsDuaStarterLessons.isEmpty ? null : kidsDuaStarterLessons.first;
});

final kidsDuaTodayLessonProvider = Provider<KidsDuaLessonContent>((ref) {
  final now = ref.watch(kidsDuaNowProvider)();
  final seed = now.year * 10000 + now.month * 100 + now.day;
  final index = seed % kidsDuaStarterLessons.length;
  return kidsDuaStarterLessons[index];
});

final kidsDuaCategoryCompletionCountsProvider = Provider<Map<String, int>>((
  ref,
) {
  final state = ref.watch(kidsDuaLearningProvider);
  final counts = <String, int>{};
  for (final lesson in kidsDuaStarterLessons) {
    if (state.learnedLessonIds.contains(lesson.id)) {
      counts[lesson.categoryId] = (counts[lesson.categoryId] ?? 0) + 1;
    }
  }
  return counts;
});

class KidsDuaLearningNotifier extends StateNotifier<KidsDuaLearningState> {
  KidsDuaLearningNotifier(this._ref)
    : _store = _ref.read(localStoreProvider),
      _activeLearnerId = _ref.read(kidsDuaActiveLearnerProvider).learnerId,
      super(
        _ref
            .read(kidsDuaRetentionServiceProvider)
            .syncForToday(
              state: KidsDuaLearningState.fromJson(
                _ref.read(localStoreProvider).getJsonMap(
                  kidsDuaLearningStorageKeyForLearner(
                    _ref.read(kidsDuaActiveLearnerProvider).learnerId,
                  ),
                ),
              ),
              now: _ref.read(kidsDuaNowProvider)(),
            ),
      ) {
    _migrateLegacyProgressIfNeeded();
  }

  final Ref _ref;
  final LocalStore _store;
  String _activeLearnerId;

  KidsDuaLessonProgress progressFor(String lessonId) {
    return state.progressByLessonId[lessonId] ??
        KidsDuaLessonProgress(
          lessonId: lessonId,
          openCount: 0,
          timesPracticed: 0,
        );
  }

  void openLesson(String lessonId) {
    final current = progressFor(lessonId);
    final lesson = _lessonById(lessonId);
    final nowIso = _ref.read(kidsDuaNowProvider)().toIso8601String();
    final updated = current.copyWith(
      openCount: current.openCount + 1,
      startedAtIso: current.startedAtIso ?? nowIso,
    );
    final progressByLessonId = Map<String, KidsDuaLessonProgress>.from(
      state.progressByLessonId,
    )..[lessonId] = updated;
    final recent = List<String>.from(state.recentLessonIds)
      ..remove(lessonId)
      ..insert(0, lessonId);
    if (recent.length > 12) {
      recent.removeRange(12, recent.length);
    }
    state = state.copyWith(
      progressByLessonId: progressByLessonId,
      recentLessonIds: recent,
    );
    _persist();
    _ref.read(kidsActivityLogProvider.notifier).log(
      type: KidsActivityType.duaLessonOpened,
      domain: KidsActivityDomain.duas,
      sourceRef: 'kids_dua_open:$lessonId',
      contentId: lessonId,
      titleSnapshot: lesson?.title,
      subtitleSnapshot: lesson?.miniLesson,
      occurredAt: DateTime.parse(nowIso),
      dedupeWindow: const Duration(minutes: 2),
      metadata: <String, Object?>{
        'feature': 'kids_dua_learning',
        'lessonId': lessonId,
      },
    );
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markStarted(_itemId(lessonId));
  }

  KidsDuaCompletionResult completeLesson(String lessonId) {
    final lesson = _lessonById(lessonId);
    if (lesson == null) {
      return const KidsDuaCompletionResult(
        xpAwarded: 0,
        oceanDropsAwarded: 0,
        newRewardIds: <String>[],
        newStickerIds: <String>[],
        firstCompletion: false,
      );
    }
    final current = progressFor(lessonId);
    final firstCompletion = current.status != KidsDuaLessonStatus.learned;
    final updated = current.copyWith(
      openCount: current.openCount + 1,
      startedAtIso: current.startedAtIso ?? _nowIso(),
      completedAtIso: current.completedAtIso ?? _nowIso(),
    );
    final progressByLessonId = Map<String, KidsDuaLessonProgress>.from(
      state.progressByLessonId,
    )..[lessonId] = updated;
    final nextRewards = _unlockRewards(
      progressByLessonId,
      state.totalPracticeSessions,
    );
    final nextStickers = _ref
        .read(kidsDuaStickerServiceProvider)
        .checkAndUnlock(
          lessons: kidsDuaStarterLessons,
          progressByLessonId: progressByLessonId,
          unlockedAtById: state.stickerUnlockedAtById,
          unlockedAtIso: _nowIso(),
        );
    final reward = firstCompletion
        ? _ref
              .read(learnerProgressionControllerProvider(_activeLearnerId).notifier)
              .award(
                sourceRef: 'kids_dua_lesson:$lessonId:complete',
                activityType:
                    LearnerProgressionActivityType.duaLessonCompletion,
                sourceModule: 'kids_dua_learning',
                xp: kidsDuaLessonXp,
                drops: kidsDuaLessonDrops,
                occurredAt: _ref.read(kidsDuaNowProvider)(),
                metadata: <String, Object?>{
                  'feature': 'kids_dua_learning',
                  'lessonId': lessonId,
                },
                mirrorToJourney: _shouldMirrorRewardsToJourney(),
                incrementLearningStageCompletion: _shouldMirrorRewardsToJourney(),
              )
        : const LearnerProgressionAwardResult(
            awardedXp: 0,
            awardedDrops: 0,
            wasDuplicate: false,
            newBadgeIds: <String>[],
            newMilestoneIds: <String>[],
            leveledUp: false,
          );
    if (firstCompletion) {
      _ref.read(kidsActivityLogProvider.notifier).log(
        type: KidsActivityType.duaLessonCompleted,
        domain: KidsActivityDomain.duas,
        sourceRef: 'kids_dua_lesson_complete:$lessonId',
        contentId: lessonId,
        titleSnapshot: lesson.title,
        subtitleSnapshot: lesson.miniLesson,
        occurredAt: _ref.read(kidsDuaNowProvider)(),
        metadata: <String, Object?>{
          'feature': 'kids_dua_learning',
          'lessonId': lessonId,
        },
      );
      _registerDailyActivity(KidsDuaDailyActivityType.lessonCompleted);
      state = state.copyWith(
        activityLog: _nextActivityLog(
          type: KidsDuaActivityLogType.lessonCompleted,
          duaId: lessonId,
        ),
      );
      _ref
          .read(learnUnifiedProgressProvider.notifier)
          .markCompleted(_itemId(lessonId));
    }
    state = state.copyWith(
      progressByLessonId: progressByLessonId,
      unlockedRewardIds: nextRewards.all,
      stickerUnlockedAtById: nextStickers.unlockedAtById,
      recentLessonIds: _nextRecent(lessonId),
      totalFeatureXpAwarded:
          state.totalFeatureXpAwarded + reward.awardedXp,
      totalFeatureDropsAwarded:
          state.totalFeatureDropsAwarded + reward.awardedDrops,
    );
    _persist();
    return KidsDuaCompletionResult(
      xpAwarded: reward.awardedXp,
      oceanDropsAwarded: reward.awardedDrops,
      newRewardIds: nextRewards.newlyUnlocked,
      newStickerIds: nextStickers.newlyUnlockedIds,
      firstCompletion: firstCompletion,
    );
  }

  KidsDuaPracticeResult recordPracticeSession({
    required List<String> practicedLessonIds,
    required int correctAnswers,
    required int totalQuestions,
  }) {
    final uniqueIds = practicedLessonIds.toSet().toList(growable: false);
    final nextMap = Map<String, KidsDuaLessonProgress>.from(
      state.progressByLessonId,
    );
    for (final lessonId in uniqueIds) {
      final current = progressFor(lessonId);
      nextMap[lessonId] = current.copyWith(
        timesPracticed: current.timesPracticed + 1,
        startedAtIso: current.startedAtIso ?? _nowIso(),
      );
      _ref
          .read(learnUnifiedProgressProvider.notifier)
          .markPracticed(_itemId(lessonId));
    }
    final nextTotalPractice = state.totalPracticeSessions + 1;
    final nextRewards = _unlockRewards(nextMap, nextTotalPractice);
    final nextState = state.copyWith(
      progressByLessonId: nextMap,
      unlockedRewardIds: nextRewards.all,
      totalPracticeSessions: nextTotalPractice,
      totalFeatureXpAwarded: state.totalFeatureXpAwarded,
    );
    state = nextState;
    if (correctAnswers > 0) {
      final practiceAward = _ref
          .read(learnerProgressionControllerProvider(_activeLearnerId).notifier)
          .award(
            sourceRef:
                'kids_dua_practice:${LocalStore.todayKey(_ref.read(kidsDuaNowProvider)())}',
            activityType:
                LearnerProgressionActivityType.duaPracticeCompletion,
            sourceModule: 'kids_dua_learning',
            xp: kidsDuaPracticeXp,
            drops: 0,
            occurredAt: _ref.read(kidsDuaNowProvider)(),
            metadata: <String, Object?>{
              'feature': 'kids_dua_learning',
              'lessonIds': uniqueIds,
            },
            mirrorToJourney: _shouldMirrorRewardsToJourney(),
          );
      state = state.copyWith(
        totalFeatureXpAwarded:
            state.totalFeatureXpAwarded + practiceAward.awardedXp,
      );
    }
    if (correctAnswers > 0) {
      final lesson = uniqueIds.isEmpty ? null : _lessonById(uniqueIds.first);
      _ref.read(kidsActivityLogProvider.notifier).log(
        type: KidsActivityType.duaPracticeCompleted,
        domain: KidsActivityDomain.duas,
        sourceRef:
            'kids_dua_practice:${LocalStore.todayKey(_ref.read(kidsDuaNowProvider)())}',
        contentId: uniqueIds.isEmpty ? null : uniqueIds.first,
        titleSnapshot: lesson?.title,
        subtitleSnapshot: lesson?.miniLesson,
        occurredAt: _ref.read(kidsDuaNowProvider)(),
        dedupeWindow: const Duration(minutes: 1),
        metadata: <String, Object?>{
          'feature': 'kids_dua_learning',
          'lessonIds': uniqueIds,
        },
      );
      _registerDailyActivity(KidsDuaDailyActivityType.practiceCorrect);
      state = state.copyWith(
        activityLog: _nextActivityLog(
          type: KidsDuaActivityLogType.practiceCorrect,
          duaId: uniqueIds.isEmpty ? null : uniqueIds.first,
        ),
      );
    }
    _persist();
    return KidsDuaPracticeResult(
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      practicedLessonIds: uniqueIds,
      newRewardIds: nextRewards.newlyUnlocked,
    );
  }

  void awardMyDayBonus({required int xp, required int drops}) {
    state = state.copyWith(
      totalFeatureXpAwarded: state.totalFeatureXpAwarded + xp,
      totalFeatureDropsAwarded: state.totalFeatureDropsAwarded + drops,
    );
    _persist();
  }

  ({int xpAwarded, int oceanDropsAwarded}) awardEmbeddedPracticeBonus({
    required int xp,
    required int drops,
    required String referenceId,
  }) {
    final reward = _ref
        .read(learnerProgressionControllerProvider(_activeLearnerId).notifier)
        .award(
          sourceRef: 'kids_dua_embedded:$referenceId',
          activityType: LearnerProgressionActivityType.duaPracticeCompletion,
          sourceModule: 'kids_dua_learning',
          xp: xp,
          drops: drops,
          occurredAt: _ref.read(kidsDuaNowProvider)(),
          metadata: <String, Object?>{
            'feature': 'kids_dua_my_day_practice',
            'referenceId': referenceId,
          },
          mirrorToJourney: _shouldMirrorRewardsToJourney(),
        );
    state = state.copyWith(
      totalFeatureXpAwarded: state.totalFeatureXpAwarded + reward.awardedXp,
      totalFeatureDropsAwarded:
          state.totalFeatureDropsAwarded + reward.awardedDrops,
    );
    if (xp > 0 || drops > 0) {
      _registerDailyActivity(KidsDuaDailyActivityType.practiceCorrect);
    }
    _persist();
    return (
      xpAwarded: reward.awardedXp,
      oceanDropsAwarded: reward.awardedDrops,
    );
  }

  void registerMeaningfulActivity(KidsDuaDailyActivityType activityType) {
    _registerDailyActivity(activityType);
    _persist();
  }

  void openStory(String storyId) {
    final current =
        state.storyProgressById[storyId] ??
        KidsDuaStoryProgress(
          storyId: storyId,
          viewedSceneCount: 0,
          completed: false,
        );
    state = state.copyWith(
      storyProgressById:
          Map<String, KidsDuaStoryProgress>.from(state.storyProgressById)
            ..[storyId] = current.copyWith(
              viewedSceneCount: current.viewedSceneCount == 0
                  ? 1
                  : current.viewedSceneCount,
              lastViewedAt: _nowIso(),
            ),
      recentStoryIds: _nextRecentStories(storyId),
    );
    _persist();
  }

  void viewStoryScene({
    required String storyId,
    required int viewedSceneCount,
  }) {
    final current =
        state.storyProgressById[storyId] ??
        KidsDuaStoryProgress(
          storyId: storyId,
          viewedSceneCount: 0,
          completed: false,
        );
    if (viewedSceneCount <= current.viewedSceneCount &&
        current.lastViewedAt != null) {
      return;
    }
    state = state.copyWith(
      storyProgressById:
          Map<String, KidsDuaStoryProgress>.from(state.storyProgressById)
            ..[storyId] = current.copyWith(
              viewedSceneCount: viewedSceneCount,
              lastViewedAt: _nowIso(),
            ),
      recentStoryIds: _nextRecentStories(storyId),
    );
    _persist();
  }

  void completeStory(String storyId) {
    final completed = Set<String>.from(state.completedStoryIds)..add(storyId);
    final current =
        state.storyProgressById[storyId] ??
        KidsDuaStoryProgress(
          storyId: storyId,
          viewedSceneCount: 0,
          completed: false,
        );
    state = state.copyWith(
      completedStoryIds: completed,
      storyProgressById: Map<String, KidsDuaStoryProgress>.from(
        state.storyProgressById,
      )..[storyId] = current.copyWith(completed: true, lastViewedAt: _nowIso()),
      recentStoryIds: _nextRecentStories(storyId),
      activityLog: _nextActivityLog(
        type: KidsDuaActivityLogType.storyCompleted,
      ),
    );
    _persist();
  }

  void recordActivity({required KidsDuaActivityLogType type, String? duaId}) {
    state = state.copyWith(
      activityLog: _nextActivityLog(type: type, duaId: duaId),
    );
    _persist();
  }

  void recordAudioListen(String lessonId) {
    final current = progressFor(lessonId);
    final next = current.copyWith(
      startedAtIso: current.startedAtIso ?? _nowIso(),
      listenCount: current.listenCount + 1,
      lastPracticedAtIso: _nowIso(),
      lastLearningMode: KidsDuaRepeatMode.listen.name,
    );
    final nextMap = Map<String, KidsDuaLessonProgress>.from(state.progressByLessonId)
      ..[lessonId] = next;
    state = state.copyWith(
      progressByLessonId: nextMap,
      recentLessonIds: _nextRecent(lessonId),
    );
    _persist();
  }

  void recordSegmentRepeat({
    required String lessonId,
    required String segmentId,
  }) {
    final current = progressFor(lessonId);
    final next = current.copyWith(
      startedAtIso: current.startedAtIso ?? _nowIso(),
      segmentRepeatCount: current.segmentRepeatCount + 1,
      lastPracticedAtIso: _nowIso(),
      lastLearningMode: KidsDuaRepeatMode.tapToRepeat.name,
    );
    final nextMap = Map<String, KidsDuaLessonProgress>.from(state.progressByLessonId)
      ..[lessonId] = next;
    state = state.copyWith(
      progressByLessonId: nextMap,
      recentLessonIds: _nextRecent(lessonId),
    );
    _persist();
  }

  void recordReadAlongComplete(
    String lessonId, {
    required KidsDuaRepeatMode mode,
  }) {
    final current = progressFor(lessonId);
    final next = current.copyWith(
      startedAtIso: current.startedAtIso ?? _nowIso(),
      timesPracticed: current.timesPracticed + 1,
      readAlongCompletedAtIso:
          current.readAlongCompletedAtIso ?? _nowIso(),
      lastPracticedAtIso: _nowIso(),
      lastLearningMode: mode.name,
    );
    final nextMap = Map<String, KidsDuaLessonProgress>.from(state.progressByLessonId)
      ..[lessonId] = next;
    state = state.copyWith(
      progressByLessonId: nextMap,
      recentLessonIds: _nextRecent(lessonId),
    );
    _persist();
  }

  void updateActiveLearner(String learnerId) {
    if (learnerId == _activeLearnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = _ref.read(kidsDuaRetentionServiceProvider).syncForToday(
      state: KidsDuaLearningState.fromJson(
        _store.getJsonMap(kidsDuaLearningStorageKeyForLearner(learnerId)),
      ),
      now: _ref.read(kidsDuaNowProvider)(),
    );
    _migrateLegacyProgressIfNeeded();
  }

  ({Set<String> all, List<String> newlyUnlocked}) _unlockRewards(
    Map<String, KidsDuaLessonProgress> progressByLessonId,
    int totalPracticeSessions,
  ) {
    final all = Set<String>.from(state.unlockedRewardIds);
    final newlyUnlocked = <String>[];
    final learnedIds = progressByLessonId.entries
        .where((entry) => entry.value.status == KidsDuaLessonStatus.learned)
        .map((entry) => entry.key)
        .toSet();
    final learnedByCategory = <String, int>{};
    for (final lesson in kidsDuaStarterLessons) {
      if (learnedIds.contains(lesson.id)) {
        learnedByCategory[lesson.categoryId] =
            (learnedByCategory[lesson.categoryId] ?? 0) + 1;
      }
    }
    for (final reward in kidsDuaRewardItems) {
      if (learnedIds.length < reward.requiredCompletedDuas) continue;
      if (totalPracticeSessions < reward.requiredPracticeSessions) continue;
      if (reward.requiredCategoryId != null) {
        final categoryTotal = kidsDuaStarterLessons
            .where((lesson) => lesson.categoryId == reward.requiredCategoryId)
            .length;
        if ((learnedByCategory[reward.requiredCategoryId] ?? 0) <
            categoryTotal) {
          continue;
        }
      }
      if (all.add(reward.id)) {
        newlyUnlocked.add(reward.id);
      }
    }
    return (all: all, newlyUnlocked: newlyUnlocked);
  }

  List<String> _nextRecent(String lessonId) {
    final recent = List<String>.from(state.recentLessonIds)
      ..remove(lessonId)
      ..insert(0, lessonId);
    if (recent.length > 12) {
      recent.removeRange(12, recent.length);
    }
    return recent;
  }

  List<String> _nextRecentStories(String storyId) {
    final recent = List<String>.from(state.recentStoryIds)
      ..remove(storyId)
      ..insert(0, storyId);
    if (recent.length > 8) {
      recent.removeRange(8, recent.length);
    }
    return recent;
  }

  KidsDuaLessonContent? _lessonById(String lessonId) {
    for (final lesson in kidsDuaStarterLessons) {
      if (lesson.id == lessonId) return lesson;
    }
    return null;
  }

  String _itemId(String lessonId) => 'kids_dua:item:$lessonId';
  String _nowIso() => _ref.read(kidsDuaNowProvider)().toIso8601String();

  void _persist() {
    _store.setJsonMap(
      kidsDuaLearningStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }

  void _migrateLegacyProgressIfNeeded() {
    final scopedKey = kidsDuaLearningStorageKeyForLearner(_activeLearnerId);
    final scoped = _store.getJsonMap(scopedKey);
    if (scoped != null) {
      state = _ref.read(kidsDuaRetentionServiceProvider).syncForToday(
        state: KidsDuaLearningState.fromJson(scoped),
        now: _ref.read(kidsDuaNowProvider)(),
      );
      return;
    }
    final legacy = _store.getJsonMap(legacyKidsDuaLearningStateKey);
    if (legacy != null) {
      state = _ref.read(kidsDuaRetentionServiceProvider).syncForToday(
        state: KidsDuaLearningState.fromJson(legacy),
        now: _ref.read(kidsDuaNowProvider)(),
      );
      _store.setJsonMap(scopedKey, state.toJson());
      _store.remove(legacyKidsDuaLearningStateKey);
      return;
    }

    final legacyScopedLearnerId = legacyKidsDuaScopedLearnerIdForCurrent(
      _activeLearnerId,
    );
    if (legacyScopedLearnerId == null) {
      return;
    }
    final legacyScoped = _store.getJsonMap(
      kidsDuaLearningStorageKeyForLearner(legacyScopedLearnerId),
    );
    if (legacyScoped == null) {
      return;
    }
    state = _ref.read(kidsDuaRetentionServiceProvider).syncForToday(
      state: KidsDuaLearningState.fromJson(legacyScoped),
      now: _ref.read(kidsDuaNowProvider)(),
    );
    _store.setJsonMap(scopedKey, state.toJson());
    _store.remove(kidsDuaLearningStorageKeyForLearner(legacyScopedLearnerId));
  }

  void _registerDailyActivity(KidsDuaDailyActivityType activityType) {
    final update = _ref
        .read(kidsDuaRetentionServiceProvider)
        .registerDailyActivity(
          state: state,
          now: _ref.read(kidsDuaNowProvider)(),
          activityType: activityType,
        );
    state = update.state;
  }

  bool _shouldMirrorRewardsToJourney() {
    final accounts = _ref.read(accountsSyncControllerProvider);
    final learner = _ref.read(kidsDuaActiveLearnerProvider);
    return learner.isChildProfile && accounts.activeProfileId == learner.learnerId;
  }

  List<KidsDuaActivityLogEntry> _nextActivityLog({
    required KidsDuaActivityLogType type,
    String? duaId,
  }) {
    final now = _ref.read(kidsDuaNowProvider)();
    final dateKey = now.toIso8601String().split('T').first;
    final next = <KidsDuaActivityLogEntry>[
      KidsDuaActivityLogEntry(
        id: '${type.name}_${now.microsecondsSinceEpoch}',
        type: type,
        dateKey: dateKey,
        timestampIso: now.toIso8601String(),
        duaId: duaId,
      ),
      ...state.activityLog,
    ];
    if (next.length > 40) {
      return next.sublist(0, 40);
    }
    return next;
  }
}
