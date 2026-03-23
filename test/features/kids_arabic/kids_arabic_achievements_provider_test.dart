import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_achievements_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_words_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'achievement provider unlocks badges and milestones from real progress',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final letterNotifier = container.read(
        kidsArabicProgressProvider.notifier,
      );
      final wordNotifier = container.read(
        kidsArabicWordProgressProvider.notifier,
      );

      letterNotifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
        traceResult: KidsArabicTraceResult.good,
      );

      expect(
        container.read(kidsArabicUnlockedAchievementIdsProvider),
        contains('first-letter'),
      );
      expect(
        container.read(kidsArabicAchievementCelebrationProvider)?.id,
        'first-letter',
      );

      container
          .read(kidsArabicAchievementsUiProvider.notifier)
          .markCelebrationSeen('first-letter');
      expect(container.read(kidsArabicAchievementCelebrationProvider), isNull);

      for (final id in const ['ba', 'meem', 'noon']) {
        letterNotifier.completeLesson(
          letter: kidsArabicLetters.firstWhere((item) => item.id == id),
          traceResult: KidsArabicTraceResult.good,
        );
      }
      wordNotifier.completeWord('bab');

      final unlocked = container.read(kidsArabicUnlockedAchievementIdsProvider);
      expect(unlocked, contains('three-letters'));
      expect(unlocked, contains('first-word'));
    },
  );

  test(
    'achievement celebration moves forward only when a new achievement unlocks',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final notifier = container.read(kidsArabicProgressProvider.notifier);

      notifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
        traceResult: KidsArabicTraceResult.good,
      );
      expect(
        container.read(kidsArabicAchievementCelebrationProvider)?.id,
        'first-letter',
      );

      container
          .read(kidsArabicAchievementsUiProvider.notifier)
          .markCelebrationSeen('first-letter');
      notifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == 'alif'),
        traceResult: KidsArabicTraceResult.good,
      );
      expect(container.read(kidsArabicAchievementCelebrationProvider), isNull);

      for (final id in const ['ba', 'meem']) {
        notifier.completeLesson(
          letter: kidsArabicLetters.firstWhere((item) => item.id == id),
          traceResult: KidsArabicTraceResult.good,
        );
      }
      expect(
        container.read(kidsArabicAchievementCelebrationProvider)?.id,
        'three-letters',
      );
    },
  );
}
