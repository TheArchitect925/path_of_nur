import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_progress_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_phrases_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_words_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_readiness_bridge_provider.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_controller.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('kids progress summary starts calmly with zeroed counts', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final summary = container.read(
      arabicLearningProgressSummaryProvider(ArabicLearningAudience.kids),
    );

    expect(summary.hasStarted, isFalse);
    expect(summary.engagedLetters, 0);
    expect(summary.engagedWords, 0);
    expect(summary.engagedPhrases, 0);
    expect(summary.continuation.intent, ArabicLearningContinuationIntent.start);
  });

  test(
    'kids progress summary reflects learned letters words and phrases',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(kidsArabicProgressProvider.notifier)
          .completeLesson(
            letter: kidsArabicLetters.first,
            traceResult: KidsArabicTraceResult.good,
          );
      container
          .read(kidsArabicWordProgressProvider.notifier)
          .completeWord('bab');
      container
          .read(kidsArabicMiniPhraseProgressProvider.notifier)
          .markPhraseHeard('bismillah');

      final summary = container.read(
        arabicLearningProgressSummaryProvider(ArabicLearningAudience.kids),
      );

      expect(summary.hasStarted, isTrue);
      expect(summary.engagedLetters, 1);
      expect(summary.engagedWords, 1);
      expect(summary.engagedPhrases, 1);
      expect(summary.currentStreakDays, greaterThanOrEqualTo(1));
      expect(summary.recentActivity, isNotNull);
    },
  );

  test('adult progress summary starts with a calm start state', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final summary = container.read(
      arabicLearningProgressSummaryProvider(ArabicLearningAudience.adult),
    );

    expect(summary.hasStarted, isFalse);
    expect(summary.engagedLetters, 0);
    expect(summary.engagedWords, 0);
    expect(summary.engagedPhrases, 0);
    expect(summary.completedLessons, 0);
    expect(summary.continuation.intent, ArabicLearningContinuationIntent.start);
  });

  test(
    'adult progress summary derives lesson word and bridge coverage',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(quranTeachingProgressProvider.notifier)
          .completeLesson('alphabet_letters_1');
      container
          .read(quranTeachingBeginnerWordsProgressProvider.notifier)
          .recordWordOpened('rabb');
      container
          .read(
            quranReadinessBridgeProgressProvider(
              ArabicLearningAudience.adult,
            ).notifier,
          )
          .markSnippetOpened('bismillah_bridge');

      final summary = container.read(
        arabicLearningProgressSummaryProvider(ArabicLearningAudience.adult),
      );

      expect(summary.hasStarted, isTrue);
      expect(summary.engagedLetters, 7);
      expect(summary.engagedWords, 1);
      expect(summary.engagedPhrases, 1);
      expect(summary.completedLessons, 1);
      expect(summary.recentActivity, isNotNull);
    },
  );
}
