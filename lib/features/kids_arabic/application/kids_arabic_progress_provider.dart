import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/journey/application/journey_progression_provider.dart';
import '../../../features/learn/journey/application/learning_journey_progress_provider.dart';
import '../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../shared/persistence/local_store.dart';
import 'kids_arabic_daily_mission_service.dart';
import 'kids_arabic_progression.dart';
import 'kids_arabic_starter_tracing.dart';
import 'kids_arabic_tracing_engine.dart';
import '../data/kids_arabic_letters_data.dart';
import '../domain/kids_arabic_models.dart';

const kidsArabicProgressStorageKey = 'kids.arabic.progress.v1';

final kidsArabicNowProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});

final kidsArabicLettersProvider = Provider<List<KidsArabicLetter>>((ref) {
  return kidsArabicLetters;
});

final kidsArabicRecommendedLettersProvider = Provider<List<KidsArabicLetter>>((
  ref,
) {
  return kidsArabicStarterReleaseOrderIds
      .map((id) => kidsArabicLetters.firstWhere((letter) => letter.id == id))
      .toList(growable: false);
});

final kidsArabicProgressionLettersProvider = Provider<List<KidsArabicLetter>>((
  ref,
) {
  return kidsArabicProgressionLetters;
});

final kidsArabicDailyMissionServiceProvider =
    Provider<KidsArabicDailyMissionService>((ref) {
      return const KidsArabicDailyMissionService();
    });

final kidsArabicUnlockedLetterIdsProvider = Provider<Set<String>>((ref) {
  final completed = ref.watch(kidsArabicProgressProvider).completedLetterIds;
  return unlockedKidsArabicLetterIds(completed);
});

final kidsArabicDailyMissionProvider = Provider<KidsArabicDailyMission?>((ref) {
  return ref.watch(kidsArabicProgressProvider).dailyMission;
});

final kidsArabicDailyProgressProvider = Provider<KidsArabicDailyProgress>((
  ref,
) {
  return ref.watch(kidsArabicProgressProvider).dailyProgress;
});

final kidsArabicProgressProvider =
    StateNotifierProvider<KidsArabicProgressNotifier, KidsArabicProgressState>((
      ref,
    ) {
      return KidsArabicProgressNotifier(ref);
    });

final kidsArabicWeakLettersProvider = Provider<List<KidsArabicLetter>>((ref) {
  final state = ref.watch(kidsArabicProgressProvider);
  return kidsArabicLetters
      .where((letter) => state.reviewNeededLetterIds.contains(letter.id))
      .toList(growable: false);
});

class KidsArabicProgressNotifier
    extends StateNotifier<KidsArabicProgressState> {
  KidsArabicProgressNotifier(this._ref)
    : _store = _ref.read(localStoreProvider),
      super(KidsArabicProgressState.initial()) {
    _load();
    ensureDailyMission();
  }

  final Ref _ref;
  final LocalStore _store;
  KidsArabicDailyMissionService get _dailyMissionService =>
      _ref.read(kidsArabicDailyMissionServiceProvider);

  void _load() {
    state = KidsArabicProgressState.fromJson(
      _store.getJsonMap(kidsArabicProgressStorageKey),
    );
  }

  void _save() {
    _store.setJsonMap(kidsArabicProgressStorageKey, state.toJson());
  }

  KidsArabicLetter? letterById(String id) {
    for (final letter in kidsArabicLetters) {
      if (letter.id == id) return letter;
    }
    return null;
  }

  bool isUnlocked(String id) {
    return isKidsArabicLetterUnlocked(
      letterId: id,
      completedLetterIds: state.completedLetterIds,
    );
  }

  void ensureDailyMission() {
    final now = _ref.read(kidsArabicNowProvider)();
    final mission = _dailyMissionService.missionForDay(
      now: now,
      progressState: state,
    );
    final dailyProgress = _dailyMissionService.syncProgressForMissionDay(
      current: state.dailyProgress,
      mission: mission,
    );
    state = state.copyWith(dailyMission: mission, dailyProgress: dailyProgress);
    _save();
  }

  KidsArabicCompletionResult completeLesson({
    required KidsArabicLetter letter,
    required KidsArabicTraceResult traceResult,
  }) {
    final now = _ref.read(kidsArabicNowProvider)();
    final dayKey = LocalStore.todayKey(now);
    final previous =
        state.progressByLetterId[letter.id] ??
        KidsArabicLetterProgress(
          letterId: letter.id,
          lessonsCompleted: 0,
          correctReviews: 0,
          incorrectReviews: 0,
        );
    final firstMeaningfulCompletion = previous.lessonsCompleted == 0;
    final best = _betterTraceResult(previous.bestTraceResult, traceResult);
    final nextProgress = previous.copyWith(
      lessonsCompleted: previous.lessonsCompleted + 1,
      bestTraceResultName: best.name,
      firstCompletedDayKey: previous.firstCompletedDayKey ?? dayKey,
      lastCompletedDayKey: dayKey,
    );

    final nextProgressMap = Map<String, KidsArabicLetterProgress>.from(
      state.progressByLetterId,
    )..[letter.id] = nextProgress;
    final nextReviewNeeded = Set<String>.from(state.reviewNeededLetterIds);
    if (traceResult == KidsArabicTraceResult.completed) {
      nextReviewNeeded.add(letter.id);
    } else {
      nextReviewNeeded.remove(letter.id);
    }

    final completedCount = nextProgressMap.values
        .where((item) => item.lessonsCompleted > 0)
        .length;
    final nextStickers = _unlockStickers(
      completedCount,
      state.earnedStickerIds,
    );
    final streak = _nextStreak(dayKey);

    _ref
        .read(journeyProgressUpdateHelperProvider)
        .addLearningStageCompletions(1);
    _ref.read(learningJourneyProgressProvider.notifier).recordActiveDay();
    final oceanDropsAwarded = _ref
        .read(oceanDropServiceProvider)
        .awardDrop(
          actionType: oceanActionLessonCompleted,
          sourceModule: oceanSourceLearn,
          referenceId: 'kids_arabic_${letter.id}',
          metadata: <String, dynamic>{
            'timestamp': now.toIso8601String(),
            'feature': 'kids_arabic_letters',
            'traceResult': traceResult.name,
          },
        );

    state = state.copyWith(
      progressByLetterId: nextProgressMap,
      reviewNeededLetterIds: nextReviewNeeded,
      earnedStickerIds: nextStickers.all,
      totalLessonsDone: state.totalLessonsDone + 1,
      totalFeatureXpAwarded: state.totalFeatureXpAwarded + letter.rewardXp,
      totalFeatureDropsAwarded:
          state.totalFeatureDropsAwarded +
          (oceanDropsAwarded > 0 ? letter.rewardDrops : 0),
      localCurrentStreakDays: streak.current,
      localBestStreakDays: streak.best,
      lastLessonLetterId: letter.id,
      lastLessonDayKey: dayKey,
    );
    final dailyMissionResult = _completeDailyMissionIfEligible(
      type: firstMeaningfulCompletion
          ? KidsArabicDailyMissionType.newLetter
          : KidsArabicDailyMissionType.tracePractice,
      targetLetterId: letter.id,
    );
    _save();

    return KidsArabicCompletionResult(
      traceResult: traceResult,
      xpAwarded: letter.rewardXp,
      oceanDropsAwarded: oceanDropsAwarded > 0 ? letter.rewardDrops : 0,
      newStickerIds: nextStickers.newlyUnlocked,
      localStreakDays: streak.current,
      firstMeaningfulCompletion: firstMeaningfulCompletion,
      dailyMissionResult: dailyMissionResult,
    );
  }

  void recordReviewAnswer({required String letterId, required bool correct}) {
    final previous =
        state.progressByLetterId[letterId] ??
        KidsArabicLetterProgress(
          letterId: letterId,
          lessonsCompleted: 0,
          correctReviews: 0,
          incorrectReviews: 0,
        );
    final nextProgress = previous.copyWith(
      correctReviews: previous.correctReviews + (correct ? 1 : 0),
      incorrectReviews: previous.incorrectReviews + (correct ? 0 : 1),
    );
    final nextProgressMap = Map<String, KidsArabicLetterProgress>.from(
      state.progressByLetterId,
    )..[letterId] = nextProgress;
    final nextReviewNeeded = Set<String>.from(state.reviewNeededLetterIds);
    if (correct) {
      if (nextProgress.correctReviews >= nextProgress.incorrectReviews) {
        nextReviewNeeded.remove(letterId);
      }
    } else {
      nextReviewNeeded.add(letterId);
    }
    state = state.copyWith(
      progressByLetterId: nextProgressMap,
      reviewNeededLetterIds: nextReviewNeeded,
      totalReviewRoundsDone: state.totalReviewRoundsDone + 1,
    );
    _save();
  }

  KidsArabicDailyMissionCompletionResult? completeDailyReviewMissionIfEligible({
    required String targetLetterId,
  }) {
    final result = _completeDailyMissionIfEligible(
      type: KidsArabicDailyMissionType.review,
      targetLetterId: targetLetterId,
    );
    if (result != null) {
      _save();
    }
    return result;
  }

  KidsArabicTraceResult _betterTraceResult(
    KidsArabicTraceResult? current,
    KidsArabicTraceResult candidate,
  ) {
    if (current == null) return candidate;
    if (candidate.index > current.index) return candidate;
    return current;
  }

  ({Set<String> all, List<String> newlyUnlocked}) _unlockStickers(
    int completedCount,
    Set<String> current,
  ) {
    final all = Set<String>.from(current);
    final newlyUnlocked = <String>[];
    for (final sticker in kidsArabicStickerDefinitions) {
      if (completedCount < sticker.requiredCompletedLetters) continue;
      if (all.add(sticker.id)) {
        newlyUnlocked.add(sticker.id);
      }
    }
    return (all: all, newlyUnlocked: newlyUnlocked);
  }

  ({int current, int best}) _nextStreak(String dayKey) {
    if (state.lastLessonDayKey == null) {
      return (
        current: 1,
        best: state.localBestStreakDays > 0 ? state.localBestStreakDays : 1,
      );
    }
    if (state.lastLessonDayKey == dayKey) {
      final best = state.localBestStreakDays > state.localCurrentStreakDays
          ? state.localBestStreakDays
          : state.localCurrentStreakDays;
      return (
        current: state.localCurrentStreakDays == 0
            ? 1
            : state.localCurrentStreakDays,
        best: best,
      );
    }
    final lastDate = DateTime.tryParse('${state.lastLessonDayKey!}T00:00:00');
    final currentDate = DateTime.tryParse('${dayKey}T00:00:00');
    if (lastDate == null || currentDate == null) {
      return (
        current: 1,
        best: state.localBestStreakDays > 0 ? state.localBestStreakDays : 1,
      );
    }
    final difference = currentDate.difference(lastDate).inDays;
    final current = difference == 1 ? state.localCurrentStreakDays + 1 : 1;
    final best = current > state.localBestStreakDays
        ? current
        : state.localBestStreakDays;
    return (current: current, best: best);
  }

  KidsArabicDailyMissionCompletionResult? _completeDailyMissionIfEligible({
    required KidsArabicDailyMissionType type,
    required String targetLetterId,
  }) {
    final now = _ref.read(kidsArabicNowProvider)();
    final dayKey = LocalStore.todayKey(now);
    final mission = _dailyMissionService.missionForDay(
      now: now,
      progressState: state,
    );
    if (mission.generatedForDate != dayKey ||
        mission.type != type ||
        mission.targetLetterId != targetLetterId) {
      state = state.copyWith(
        dailyMission: mission,
        dailyProgress: _dailyMissionService.syncProgressForMissionDay(
          current: state.dailyProgress,
          mission: mission,
        ),
      );
      return null;
    }

    final update = _dailyMissionService.completeMission(
      current: state.dailyProgress,
      mission: mission,
      now: now,
    );
    if (update.alreadyCompleted) {
      state = state.copyWith(
        dailyMission: mission,
        dailyProgress: update.progress,
      );
      return null;
    }

    final dailyDropsAwarded = _ref
        .read(oceanDropServiceProvider)
        .awardDrop(
          actionType: oceanActionLearningDailyLightCompleted,
          sourceModule: oceanSourceLearn,
          referenceId: 'kids_arabic_daily_$dayKey',
          metadata: <String, dynamic>{
            'timestamp': now.toIso8601String(),
            'feature': 'kids_arabic_letters_daily',
            'missionId': mission.id,
            'missionType': mission.type.name,
            'targetLetterId': mission.targetLetterId,
          },
        );
    _ref.read(learningJourneyProgressProvider.notifier).recordActiveDay();

    final completedMission = mission.copyWith(
      isCompleted: true,
      completedAt: now.toIso8601String(),
    );
    state = state.copyWith(
      dailyMission: completedMission,
      dailyProgress: update.progress,
      totalFeatureXpAwarded:
          state.totalFeatureXpAwarded + kidsArabicDailyBonusXp,
      totalFeatureDropsAwarded:
          state.totalFeatureDropsAwarded +
          (dailyDropsAwarded > 0 ? kidsArabicDailyBonusDrops : 0),
    );
    return KidsArabicDailyMissionCompletionResult(
      missionId: mission.id,
      currentStreak: update.progress.currentStreak,
      bestStreak: update.progress.bestStreak,
      totalActiveDays: update.progress.totalActiveDays,
      weeklyCompletions: update.progress.weeklyCompletions,
      graceUsed: update.graceUsed,
      xpAwarded: kidsArabicDailyBonusXp,
      oceanDropsAwarded: dailyDropsAwarded > 0 ? kidsArabicDailyBonusDrops : 0,
    );
  }
}

KidsArabicTraceResult scoreKidsArabicTrace({
  required KidsArabicLetter letter,
  required KidsArabicTraceMetrics metrics,
}) {
  return scoreKidsArabicTraceWithGuide(
    metrics: metrics,
    guide: kidsArabicTracingGuideFor(letter.id),
  );
}
