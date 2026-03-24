import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_continuity_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_controller.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('kids continuity starts with the first tracing letter', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final summary = container.read(
      arabicLearningContinuationProvider(ArabicLearningAudience.kids),
    );

    expect(summary.intent, ArabicLearningContinuationIntent.start);
    expect(summary.contentType, ArabicLearningContinuationContentType.letter);
    expect(summary.primaryItemId, 'alif');
    expect(summary.primaryTarget.routeName, 'kidsArabicLesson');
    expect(summary.primaryTarget.pathParameters['letterId'], 'alif');
  });

  test(
    'kids continuity resumes the next letter after a completed lesson',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final alif = kidsArabicLetters.firstWhere(
        (letter) => letter.id == 'alif',
      );
      container
          .read(kidsArabicProgressProvider.notifier)
          .completeLesson(
            letter: alif,
            traceResult: KidsArabicTraceResult.good,
          );

      final summary = container.read(
        arabicLearningContinuationProvider(ArabicLearningAudience.kids),
      );

      expect(summary.intent, isNot(ArabicLearningContinuationIntent.start));
      expect(summary.contentType, ArabicLearningContinuationContentType.letter);
      expect(summary.primaryTarget.routeName, 'kidsArabicLesson');
      expect(summary.primaryTarget.pathParameters['letterId'], isNotEmpty);
    },
  );

  test(
    'adult continuity starts with the first lesson for first-time users',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(
        arabicLearningContinuationProvider(ArabicLearningAudience.adult),
      );

      expect(summary.intent, ArabicLearningContinuationIntent.start);
      expect(summary.contentType, ArabicLearningContinuationContentType.lesson);
      expect(summary.primaryItemId, 'alphabet_letters_1');
      expect(
        summary.primaryTarget.kind,
        ArabicLearningRouteTargetKind.adultLesson,
      );
      expect(summary.primaryTarget.lessonId, 'alphabet_letters_1');
    },
  );

  test(
    'adult continuity resumes an unfinished lesson before other options',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(quranTeachingProgressProvider.notifier)
          .markLessonStarted('alphabet_letters_1');

      final summary = container.read(
        arabicLearningContinuationProvider(ArabicLearningAudience.adult),
      );

      expect(summary.intent, ArabicLearningContinuationIntent.resume);
      expect(summary.contentType, ArabicLearningContinuationContentType.lesson);
      expect(
        summary.primaryTarget.kind,
        ArabicLearningRouteTargetKind.adultLesson,
      );
      expect(summary.primaryTarget.lessonId, 'alphabet_letters_1');
    },
  );

  test('adult continuity continues forward after lesson completion', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container
        .read(quranTeachingProgressProvider.notifier)
        .completeLesson('alphabet_letters_1');

    final summary = container.read(
      arabicLearningContinuationProvider(ArabicLearningAudience.adult),
    );

    expect(summary.intent, ArabicLearningContinuationIntent.continueForward);
    expect(summary.contentType, ArabicLearningContinuationContentType.lesson);
    expect(
      summary.primaryTarget.kind,
      ArabicLearningRouteTargetKind.adultLesson,
    );
    expect(summary.primaryTarget.lessonId, 'alphabet_letters_2');
  });

  test(
    'adult continuity resumes the most recent beginner word when it is newer than lessons',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(quranTeachingBeginnerWordsProgressProvider.notifier)
          .recordWordOpened('noor');

      final summary = container.read(
        arabicLearningContinuationProvider(ArabicLearningAudience.adult),
      );

      expect(summary.intent, ArabicLearningContinuationIntent.resume);
      expect(summary.contentType, ArabicLearningContinuationContentType.word);
      expect(
        summary.primaryTarget.kind,
        ArabicLearningRouteTargetKind.adultBeginnerWords,
      );
      expect(summary.primaryTarget.wordId, 'noor');
      expect(summary.primaryArabicText, 'نُور');
    },
  );
}
