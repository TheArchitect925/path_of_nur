import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_daily_mission_service.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_journey_progress_provider.dart';
import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'lesson progression records completion, review need, and local streak',
    () async {
      final container = await makeTestContainer(
        overrides: [_journeySnapshotOverride()],
      );
      addTearDown(container.dispose);

      final letter = kidsArabicLetters.firstWhere((item) => item.id == 'alif');
      final result = container
          .read(kidsArabicProgressProvider.notifier)
          .completeLesson(
            letter: letter,
            traceResult: KidsArabicTraceResult.completed,
          );
      final state = container.read(kidsArabicProgressProvider);

      expect(result.firstMeaningfulCompletion, isTrue);
      expect(state.completedLetterIds, contains('alif'));
      expect(state.reviewNeededLetterIds, contains('alif'));
      expect(state.totalLessonsDone, 1);
      expect(state.localCurrentStreakDays, 1);
      expect(state.dailyProgress.todayMissionCompleted, isTrue);
    },
  );

  test(
    'completion reward logic updates journey XP hook and deduplicates drops by letter',
    () async {
      final container = await makeTestContainer(
        overrides: [_journeySnapshotOverride()],
      );
      addTearDown(container.dispose);

      final letter = kidsArabicLetters.firstWhere((item) => item.id == 'ba');
      final notifier = container.read(kidsArabicProgressProvider.notifier);

      final first = notifier.completeLesson(
        letter: letter,
        traceResult: KidsArabicTraceResult.excellent,
      );
      final second = notifier.completeLesson(
        letter: letter,
        traceResult: KidsArabicTraceResult.good,
      );

      final journey = container.read(journeyProgressProvider);
      final learningJourney = container.read(learningJourneyProgressProvider);
      final ocean = container.read(oceanDropsProvider);
      final kids = container.read(kidsArabicProgressProvider);

      expect(first.oceanDropsAwarded, 1);
      expect(second.oceanDropsAwarded, 0);
      expect(journey.totalLearningStageCompletions, 2);
      expect(learningJourney.currentStreakDays, greaterThanOrEqualTo(1));
      expect(ocean.stats.totalDropsLifetime, 1);
      expect(kids.totalFeatureXpAwarded, letter.rewardXp * 2);
      expect(kids.totalFeatureDropsAwarded, letter.rewardDrops);
    },
  );

  test(
    'review answers can clear review-needed letters after correct recovery',
    () async {
      final container = await makeTestContainer(
        overrides: [_journeySnapshotOverride()],
      );
      addTearDown(container.dispose);

      final letter = kidsArabicLetters.firstWhere((item) => item.id == 'ta');
      final notifier = container.read(kidsArabicProgressProvider.notifier);
      notifier.completeLesson(
        letter: letter,
        traceResult: KidsArabicTraceResult.completed,
      );
      notifier.recordReviewAnswer(letterId: letter.id, correct: true);

      final state = container.read(kidsArabicProgressProvider);
      expect(state.reviewNeededLetterIds, isNot(contains(letter.id)));
      expect(state.totalReviewRoundsDone, 1);
    },
  );

  test(
    'progression unlock logic opens starter letters one by one in order',
    () async {
      final container = await makeTestContainer(
        overrides: [_journeySnapshotOverride()],
      );
      addTearDown(container.dispose);

      expect(
        container.read(kidsArabicUnlockedLetterIdsProvider),
        contains('alif'),
      );
      expect(
        container.read(kidsArabicUnlockedLetterIdsProvider),
        isNot(contains('ba')),
      );

      final notifier = container.read(kidsArabicProgressProvider.notifier);
      notifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
        traceResult: KidsArabicTraceResult.good,
      );
      expect(
        container.read(kidsArabicUnlockedLetterIdsProvider),
        contains('ba'),
      );
      expect(
        container.read(kidsArabicUnlockedLetterIdsProvider),
        isNot(contains('meem')),
      );

      notifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == 'ba'),
        traceResult: KidsArabicTraceResult.good,
      );
      expect(
        container.read(kidsArabicUnlockedLetterIdsProvider),
        containsAll(const {'alif', 'ba', 'meem'}),
      );
      expect(
        container.read(kidsArabicUnlockedLetterIdsProvider),
        isNot(contains('noon')),
      );
    },
  );

  test('daily mission reward is not awarded twice on the same day', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsArabicNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 9)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(container.dispose);

    final letter = kidsArabicLetters.firstWhere((item) => item.id == 'alif');
    final notifier = container.read(kidsArabicProgressProvider.notifier);
    notifier.completeLesson(
      letter: letter,
      traceResult: KidsArabicTraceResult.good,
    );
    notifier.completeLesson(
      letter: letter,
      traceResult: KidsArabicTraceResult.good,
    );

    final state = container.read(kidsArabicProgressProvider);
    expect(state.dailyProgress.todayMissionCompleted, isTrue);
    expect(
      state.totalFeatureXpAwarded,
      (letter.rewardXp * 2) + kidsArabicDailyBonusXp,
    );
    expect(
      state.totalFeatureDropsAwarded,
      letter.rewardDrops + kidsArabicDailyBonusDrops,
    );
  });
}

Override _journeySnapshotOverride() {
  final now = DateTime(2026, 3, 18);
  return journeyActivitySnapshotProvider.overrideWith((ref) {
    final journey = ref.watch(journeyProgressProvider);
    final todayKey = LocalStore.todayKey(now);
    final metrics =
        journey.dayMetricsByKey[todayKey] ?? const JourneyDayMetrics();
    return JourneyActivitySnapshot(
      now: now,
      prayerCompletedToday: 0,
      prayerMissedToday: 0,
      fajrCompletedToday: false,
      prayerProgress: 0,
      dhikrSessionsToday: 0,
      dhikrCountToday: 0,
      dhikrProgress: 0,
      fastingStatus: FastingStatus.notFasting,
      quranEngagementsToday: 0,
      quranProgress: 0,
      reflectionEntriesToday: 0,
      reflectionProgress: 0,
      learningStageCompletionsToday: metrics.learningStageCompletions,
    );
  });
}
