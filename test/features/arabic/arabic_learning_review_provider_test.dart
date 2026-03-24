import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_review_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_phrases_provider.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_controller.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'kids review summary starts with the first letter for first-time users',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(
        arabicLearningReviewProvider(ArabicLearningAudience.kids),
      );

      expect(
        summary.primarySuggestion.intent,
        ArabicLearningContinuationIntent.start,
      );
      expect(
        summary.primarySuggestion.contentType,
        ArabicLearningContinuationContentType.letter,
      );
      expect(summary.primarySuggestion.itemId, 'alif');
    },
  );

  test('kids review summary can include a phrase revisit suggestion', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container
        .read(kidsArabicMiniPhraseProgressProvider.notifier)
        .markPhraseHeard('bismillah');

    final summary = container.read(
      arabicLearningReviewProvider(ArabicLearningAudience.kids),
    );

    expect(
      summary.secondarySuggestions.any(
        (suggestion) =>
            suggestion.contentType ==
                ArabicLearningContinuationContentType.phrase &&
            suggestion.intent == ArabicLearningContinuationIntent.review &&
            suggestion.itemId == 'bismillah',
      ),
      isTrue,
    );
  });

  test(
    'adult review summary starts with the first lesson for first-time users',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(
        arabicLearningReviewProvider(ArabicLearningAudience.adult),
      );

      expect(
        summary.primarySuggestion.intent,
        ArabicLearningContinuationIntent.start,
      );
      expect(
        summary.primarySuggestion.contentType,
        ArabicLearningContinuationContentType.lesson,
      );
      expect(summary.primarySuggestion.itemId, 'alphabet_letters_1');
    },
  );

  test('adult review summary resumes unfinished lessons first', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container
        .read(quranTeachingProgressProvider.notifier)
        .markLessonStarted('alphabet_letters_1');

    final summary = container.read(
      arabicLearningReviewProvider(ArabicLearningAudience.adult),
    );

    expect(
      summary.primarySuggestion.intent,
      ArabicLearningContinuationIntent.resume,
    );
    expect(
      summary.primarySuggestion.contentType,
      ArabicLearningContinuationContentType.lesson,
    );
    expect(summary.primarySuggestion.itemId, 'alphabet_letters_1');
  });

  test('adult review summary can resume newer beginner word work', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container
        .read(quranTeachingBeginnerWordsProgressProvider.notifier)
        .recordWordOpened('noor');

    final summary = container.read(
      arabicLearningReviewProvider(ArabicLearningAudience.adult),
    );

    expect(
      summary.primarySuggestion.intent,
      ArabicLearningContinuationIntent.resume,
    );
    expect(
      summary.primarySuggestion.contentType,
      ArabicLearningContinuationContentType.word,
    );
    expect(summary.primarySuggestion.itemId, 'noor');
    expect(summary.secondarySuggestions, isNotEmpty);
  });
}
