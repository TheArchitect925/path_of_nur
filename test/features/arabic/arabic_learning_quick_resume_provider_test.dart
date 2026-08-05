import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_quick_resume_provider.dart';
import 'package:path_of_nur/features/arabic/application/arabic_learning_route_target_helpers.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_quick_resume_models.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_controller.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'kids quick resume starts at the first lesson with a deep-linkable path',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(
        arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.kids),
      );

      expect(
        summary.primaryAction,
        ArabicLearningQuickResumePrimaryAction.start,
      );
      expect(summary.primaryLocation, '/learn/kids/arabic/lesson/alif');
      expect(summary.hasReviewAction, isTrue);
    },
  );

  test(
    'adult quick resume resolves lesson targets into canonical Arabic routes',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(
        arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.adult),
      );

      expect(
        summary.primaryLocation,
        '/quran/arabic/module/foundations/lesson/alphabet_letters_1',
      );
      expect(
        summary.primaryAction,
        ArabicLearningQuickResumePrimaryAction.start,
      );
    },
  );

  test('adult quick resume review points to the shared review route', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container
        .read(quranTeachingProgressProvider.notifier)
        .completeLesson('alphabet_letters_1');

    final summary = container.read(
      arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.adult),
    );

    expect(summary.reviewLocation, '/quran/arabic/review');
  });

  test('route helper maps adult word targets to canonical locations', () {
    const target = ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.adultBeginnerWords,
      contentType: ArabicLearningContinuationContentType.word,
      canonicalItemId: 'noor',
      wordId: 'noor',
    );

    expect(
      arabicLearningRouteLocationForTarget(target),
      '/quran/arabic/words?word=noor',
    );
  });

  test('kids quick resume updates after a completed letter', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final alif = kidsArabicLetters.firstWhere((letter) => letter.id == 'alif');
    container
        .read(kidsArabicProgressProvider.notifier)
        .completeLesson(letter: alif, traceResult: KidsArabicTraceResult.good);

    final summary = container.read(
      arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.kids),
    );

    expect(
      summary.primaryAction,
      ArabicLearningQuickResumePrimaryAction.continueLearning,
    );
    expect(summary.primaryLocation, isNot('/learn/kids/arabic/lesson/alif'));
  });
}
