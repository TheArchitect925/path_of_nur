import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_words_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('beginner words unlock from completed letter progress', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final letterNotifier = container.read(kidsArabicProgressProvider.notifier);

    letterNotifier.completeLesson(
      letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
      traceResult: KidsArabicTraceResult.good,
    );
    letterNotifier.completeLesson(
      letter: kidsArabicLetters.firstWhere((item) => item.id == 'ba'),
      traceResult: KidsArabicTraceResult.good,
    );

    final statuses = container.read(kidsArabicWordStatusesProvider);
    final bab = statuses.firstWhere((item) => item.word.id == 'bab');

    expect(bab.unlocked, isTrue);
    expect(container.read(kidsArabicNextRecommendedWordProvider)?.id, 'bab');
  });

  test(
    'completed word progress persists and advances next recommendation',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final letterNotifier = container.read(
        kidsArabicProgressProvider.notifier,
      );
      final wordNotifier = container.read(
        kidsArabicWordProgressProvider.notifier,
      );

      for (final id in const ['alif', 'ba', 'noon']) {
        letterNotifier.completeLesson(
          letter: kidsArabicLetters.firstWhere((item) => item.id == id),
          traceResult: KidsArabicTraceResult.good,
        );
      }

      wordNotifier.completeWord('bab');

      expect(
        container.read(kidsArabicWordProgressProvider).completedWordIds,
        contains('bab'),
      );
      expect(container.read(kidsArabicNextRecommendedWordProvider)?.id, 'noor');
    },
  );
}
