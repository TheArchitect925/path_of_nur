import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_practice_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_words_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'practice plan starts with today focus and surfaces continue word safely',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final initialFocus = container.read(
        kidsArabicPracticePrimaryFocusProvider,
      );
      expect(initialFocus?.type, KidsArabicPracticeFocusType.dailyNewLetter);
      expect(initialFocus?.letter?.id, 'alif');

      final letterNotifier = container.read(
        kidsArabicProgressProvider.notifier,
      );
      for (final id in const ['alif', 'ba']) {
        letterNotifier.completeLesson(
          letter: kidsArabicLetters.firstWhere((item) => item.id == id),
          traceResult: KidsArabicTraceResult.good,
        );
      }

      final continueWord = container.read(kidsArabicContinueWordProvider);
      expect(continueWord?.id, 'bab');
    },
  );

  test('practice plan surfaces review letters and completed words', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final letterNotifier = container.read(kidsArabicProgressProvider.notifier);
    final wordNotifier = container.read(
      kidsArabicWordProgressProvider.notifier,
    );

    for (final id in const ['alif', 'ba', 'noon']) {
      letterNotifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == id),
        traceResult: KidsArabicTraceResult.good,
      );
    }
    letterNotifier.recordReviewAnswer(letterId: 'alif', correct: false);
    wordNotifier.completeWord('bab');

    final plan = container.read(kidsArabicPracticePlanProvider);
    expect(plan.reviewLetters.map((item) => item.id), contains('alif'));
    expect(plan.reviewWords.map((item) => item.id), contains('bab'));
  });
}
