import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_assessment_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_controller.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('kids mini assessment starts with one calm letter question', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final session = container.read(
      arabicLearningMiniAssessmentSessionProvider(ArabicLearningAudience.kids),
    );

    expect(session.questions, isNotEmpty);
    final question = session.questions.first;
    expect(
      question.contentType,
      ArabicLearningContinuationContentType.letter,
    );
    expect(question.options.length, greaterThanOrEqualTo(3));
    expect(
      question.options.any((option) => option.id == question.correctOptionId),
      isTrue,
    );
    expect(session.continueTarget.routeName, 'kidsArabicLesson');
  });

  test('kids mini assessment can pull in recent word work', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container.read(kidsArabicProgressProvider.notifier).completeLesson(
          letter: kidsArabicLetters.first,
          traceResult: KidsArabicTraceResult.good,
        );

    final session = container.read(
      arabicLearningMiniAssessmentSessionProvider(ArabicLearningAudience.kids),
    );

    expect(session.questions, isNotEmpty);
    expect(
      session.questions.any(
        (question) =>
            question.contentType ==
                ArabicLearningContinuationContentType.letter &&
            question.options.any(
              (option) => option.id == question.correctOptionId,
            ),
      ),
      isTrue,
    );
  });

  test('adult mini assessment resumes recent beginner words safely', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container
        .read(quranTeachingBeginnerWordsProgressProvider.notifier)
        .recordWordOpened('noor');

    final session = container.read(
      arabicLearningMiniAssessmentSessionProvider(ArabicLearningAudience.adult),
    );

    expect(session.questions, isNotEmpty);
    final question = session.questions.first;
    expect(question.itemId, 'noor');
    expect(
      question.contentType,
      ArabicLearningContinuationContentType.word,
    );
    expect(
      question.followUpTarget.kind,
      ArabicLearningRouteTargetKind.adultBeginnerWords,
    );
    expect(
      question.options.any((option) => option.id == question.correctOptionId),
      isTrue,
    );
  });
}
