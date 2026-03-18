import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_coloring_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'coloring pages unlock when their matching letter is completed',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final before = container.read(kidsArabicColoringPagesProvider);
      expect(before.where((page) => page.isUnlocked), isEmpty);

      container
          .read(kidsArabicProgressProvider.notifier)
          .completeLesson(
            letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
            traceResult: KidsArabicTraceResult.good,
          );

      final after = container.read(kidsArabicColoringPagesProvider);
      expect(
        after.firstWhere((page) => page.letterId == 'alif').isUnlocked,
        isTrue,
      );
      expect(
        after.firstWhere((page) => page.letterId == 'ba').isUnlocked,
        isFalse,
      );
    },
  );
}
