import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/journey/application/journey_progression_provider.dart';
import '../../../features/learn/journey/application/learning_journey_progress_provider.dart';
import '../../../features/learn/shared/application/learn_system_engine_provider.dart';
import '../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../data/kids_dua_seed_data.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_retention_service.dart';
import 'kids_dua_sticker_service.dart';

const _kidsDuaStateKey = 'kids.dua.learning.v1';
const int kidsDuaLessonXp = 8;
const int kidsDuaLessonDrops = 1;
const int kidsDuaPracticeXp = 3;

final kidsDuaNowProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final kidsDuaLearningProvider =
    StateNotifierProvider<KidsDuaLearningNotifier, KidsDuaLearningState>((ref) {
      return KidsDuaLearningNotifier(ref);
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
      super(
        _ref
            .read(kidsDuaRetentionServiceProvider)
            .syncForToday(
              state: KidsDuaLearningState.fromJson(
                _ref.read(localStoreProvider).getJsonMap(_kidsDuaStateKey),
              ),
              now: _ref.read(kidsDuaNowProvider)(),
            ),
      );

  final Ref _ref;
  final LocalStore _store;

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
    final oceanDropsAwarded = firstCompletion
        ? _ref
              .read(oceanDropServiceProvider)
              .awardDrop(
                actionType: oceanActionLessonCompleted,
                sourceModule: oceanSourceLearn,
                referenceId: 'kids_dua_$lessonId',
                metadata: <String, dynamic>{
                  'timestamp': _nowIso(),
                  'feature': 'kids_dua_learning',
                },
              )
        : 0;
    if (firstCompletion) {
      _registerDailyActivity(KidsDuaDailyActivityType.lessonCompleted);
      state = state.copyWith(
        activityLog: _nextActivityLog(
          type: KidsDuaActivityLogType.lessonCompleted,
          duaId: lessonId,
        ),
      );
      _ref
          .read(journeyProgressUpdateHelperProvider)
          .addLearningStageCompletions(1);
      _ref.read(learningJourneyProgressProvider.notifier).recordActiveDay();
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
          state.totalFeatureXpAwarded + (firstCompletion ? kidsDuaLessonXp : 0),
      totalFeatureDropsAwarded:
          state.totalFeatureDropsAwarded +
          ((firstCompletion && oceanDropsAwarded > 0) ? kidsDuaLessonDrops : 0),
    );
    _persist();
    return KidsDuaCompletionResult(
      xpAwarded: firstCompletion ? kidsDuaLessonXp : 0,
      oceanDropsAwarded: (firstCompletion && oceanDropsAwarded > 0)
          ? kidsDuaLessonDrops
          : 0,
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
      totalFeatureXpAwarded:
          state.totalFeatureXpAwarded +
          (correctAnswers > 0 ? kidsDuaPracticeXp : 0),
    );
    state = nextState;
    if (correctAnswers > 0) {
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
    final oceanDropsAwarded = drops <= 0
        ? 0
        : _ref
              .read(oceanDropServiceProvider)
              .awardDrop(
                actionType: oceanActionLessonCompleted,
                sourceModule: oceanSourceLearn,
                referenceId: referenceId,
                metadata: <String, dynamic>{
                  'timestamp': _nowIso(),
                  'feature': 'kids_dua_my_day_practice',
                },
              );
    state = state.copyWith(
      totalFeatureXpAwarded: state.totalFeatureXpAwarded + xp,
      totalFeatureDropsAwarded:
          state.totalFeatureDropsAwarded +
          ((drops > 0 && oceanDropsAwarded > 0) ? drops : 0),
    );
    if (xp > 0 || drops > 0) {
      _registerDailyActivity(KidsDuaDailyActivityType.practiceCorrect);
    }
    _persist();
    return (
      xpAwarded: xp,
      oceanDropsAwarded: (drops > 0 && oceanDropsAwarded > 0) ? drops : 0,
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
    _store.setJsonMap(_kidsDuaStateKey, state.toJson());
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
