import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_daily_mission_service.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_family_models.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/progression/application/learner_progression_service.dart';
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
    'completion reward logic routes through learner progression and deduplicates rewards by letter',
    () async {
      final container = await makeTestContainer(
        overrides: [
          _journeySnapshotOverride(),
          ..._kidsArabicLearnerOverrides('child_a'),
        ],
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

      final progression = container.read(
        learnerProgressionSummaryProvider('child_a'),
      );
      final kids = container.read(kidsArabicProgressProvider);

      expect(first.oceanDropsAwarded, 1);
      expect(second.oceanDropsAwarded, 0);
      expect(progression.metrics.kidsArabicLessonCompletions, 1);
      expect(progression.metrics.totalDrops, 1);
      expect(progression.metrics.totalXp, letter.rewardXp);
      expect(kids.totalFeatureXpAwarded, letter.rewardXp);
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
      letter.rewardXp + kidsArabicDailyBonusXp,
    );
    expect(
      state.totalFeatureDropsAwarded,
      letter.rewardDrops + kidsArabicDailyBonusDrops,
    );
  });

  test('progress is isolated per learner and legacy global progress migrates once', () async {
    final legacySeed = <String, Object>{
      legacyKidsArabicProgressStorageKey: jsonEncode(<String, Object?>{
        'progressByLetterId': <String, Object?>{
          'alif': <String, Object?>{
            'letterId': 'alif',
            'lessonsCompleted': 1,
            'correctReviews': 0,
            'incorrectReviews': 0,
          },
        },
        'reviewNeededLetterIds': <String>['alif'],
        'earnedStickerIds': <String>['starter_seed'],
        'totalLessonsDone': 1,
        'totalReviewRoundsDone': 0,
        'totalFeatureXpAwarded': 8,
        'totalFeatureDropsAwarded': 1,
        'localCurrentStreakDays': 1,
        'localBestStreakDays': 1,
        'dailyProgress': <String, Object?>{
          'currentStreak': 1,
          'bestStreak': 1,
          'totalActiveDays': 1,
          'weeklyCompletions': 1,
          'graceDaysAvailable': 1,
          'todayMissionCompleted': false,
          'completionDayKeys': <String>['2026-03-18'],
        },
      }),
    };

    final first = await makeTestContainer(
      seed: legacySeed,
      overrides: [
        _journeySnapshotOverride(),
        ..._kidsArabicLearnerOverrides('child_a'),
      ],
    );
    addTearDown(first.dispose);

    final migrated = first.read(kidsArabicProgressProvider);
    final dump = first.read(localStoreProvider).dumpAll();
    expect(migrated.completedLetterIds, contains('alif'));
    expect(
      dump.containsKey(kidsArabicProgressStorageKeyForLearner('child_a')),
      isTrue,
    );
    expect(dump.containsKey(legacyKidsArabicProgressStorageKey), isFalse);

    final second = await makeTestContainer(
      seed: dump.map((key, value) => MapEntry(key, value as Object)),
      overrides: [
        _journeySnapshotOverride(),
        ..._kidsArabicLearnerOverrides('child_b'),
      ],
    );
    addTearDown(second.dispose);

    final isolated = second.read(kidsArabicProgressProvider);
    expect(isolated.completedLetterIds, isEmpty);
  });

  test('scoped progress persists when reopening the app for the same learner', () async {
    final first = await makeTestContainer(
      overrides: [
        _journeySnapshotOverride(),
        ..._kidsArabicLearnerOverrides('child_a'),
      ],
    );
    addTearDown(first.dispose);

    final letter = kidsArabicLetters.firstWhere((item) => item.id == 'jim');
    first.read(kidsArabicProgressProvider.notifier).completeLesson(
      letter: letter,
      traceResult: KidsArabicTraceResult.good,
    );

    final persisted = first.read(localStoreProvider).dumpAll().map(
      (key, value) => MapEntry(key, value as Object),
    );

    final reopened = await makeTestContainer(
      seed: persisted,
      overrides: [
        _journeySnapshotOverride(),
        ..._kidsArabicLearnerOverrides('child_a'),
      ],
    );
    addTearDown(reopened.dispose);

    final state = reopened.read(kidsArabicProgressProvider);
    final progression = reopened.read(
      learnerProgressionSummaryProvider('child_a'),
    );

    expect(state.completedLetterIds, contains('jim'));
    expect(state.totalLessonsDone, 1);
    expect(progression.metrics.kidsArabicLessonCompletions, 1);
    expect(progression.metrics.totalDrops, letter.rewardDrops);
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

List<Override> _kidsArabicLearnerOverrides(String learnerId) {
  final learner = BedtimeLearnerIdentity(
    learnerId: learnerId,
    linkedChildProfileId: learnerId,
    displayName: learnerId,
    avatarReference: 'moon',
    ageGroup: LearningAgeGroup.kids,
    guardianProfileId: 'guardian_1',
    isFallbackLearner: false,
    preferences: const BedtimeLearnerPreferences(),
  );
  return <Override>[
    kidsArabicActiveLearnerProvider.overrideWithValue(learner),
  ];
}
