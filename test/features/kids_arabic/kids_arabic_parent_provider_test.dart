import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_parent_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parent preferences persist and reload', () async {
    final first = await makeTestContainer();
    addTearDown(first.dispose);

    final notifier = first.read(kidsArabicParentPreferencesProvider.notifier);
    notifier.setGuidedProgressionEnabled(false);
    notifier.setPrioritizeReview(true);
    notifier.setShowTransliteration(false);
    notifier.setAudioAutoplay(true);
    notifier.setAllowParentAssignedFocus(true);
    notifier.setLessonSupportLevel(KidsArabicLessonSupportLevel.extraHelp);
    notifier.assignFocusLetter('alif', validLetterIds: {'alif'});
    notifier.assignReviewLetter('alif', validLetterIds: {'alif'});

    final seed = first
        .read(localStoreProvider)
        .dumpAll()
        .map((key, value) => MapEntry(key, value as Object));
    final second = await makeTestContainer(seed: seed);
    addTearDown(second.dispose);

    final reloaded = second.read(kidsArabicParentPreferencesProvider);
    expect(reloaded.guidedProgressionEnabled, isFalse);
    expect(reloaded.prioritizeReview, isTrue);
    expect(reloaded.showTransliteration, isFalse);
    expect(reloaded.audioAutoplay, isTrue);
    expect(reloaded.allowParentAssignedFocus, isTrue);
    expect(reloaded.parentAssignedLetterId, 'alif');
    expect(reloaded.parentAssignedReviewLetterId, 'alif');
    expect(reloaded.lessonSupportLevel, KidsArabicLessonSupportLevel.extraHelp);
  });

  test('parent summary derives from real progress data', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsArabicNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 9)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(kidsArabicProgressProvider.notifier);
    notifier.completeLesson(
      letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
      traceResult: KidsArabicTraceResult.good,
    );

    final summary = container.read(kidsArabicParentSummaryProvider);
    expect(summary.lettersCompleted, 1);
    expect(summary.lessonsCompleted, 1);
    expect(summary.currentStreak, greaterThanOrEqualTo(1));
    expect(summary.latestCompletedLetterId, 'alif');
    expect(summary.earnedStickerCount, greaterThanOrEqualTo(1));
    expect(summary.weeklyConsistency.length, 7);
  });

  test('parent assigned focus overrides next recommendation', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final notifier = container.read(
      kidsArabicParentPreferencesProvider.notifier,
    );
    notifier.setAllowParentAssignedFocus(true);
    notifier.assignFocusLetter('alif', validLetterIds: {'alif'});

    final target = container.read(kidsArabicParentRecommendedActivityProvider);
    expect(
      target?.source,
      KidsArabicRecommendedActivitySource.parentAssignedFocus,
    );
    expect(target?.letterId, 'alif');
    expect(target?.opensReview, isFalse);
  });

  test(
    'parent assigned review affects review recommendation when enabled',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(kidsArabicProgressProvider.notifier)
          .completeLesson(
            letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
            traceResult: KidsArabicTraceResult.completed,
          );

      final notifier = container.read(
        kidsArabicParentPreferencesProvider.notifier,
      );
      notifier.setPrioritizeReview(true);
      notifier.assignReviewLetter('alif', validLetterIds: {'alif'});

      final target = container.read(
        kidsArabicParentRecommendedActivityProvider,
      );
      expect(
        target?.source,
        KidsArabicRecommendedActivitySource.parentAssignedReview,
      );
      expect(target?.letterId, 'alif');
      expect(target?.opensReview, isTrue);
    },
  );
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
