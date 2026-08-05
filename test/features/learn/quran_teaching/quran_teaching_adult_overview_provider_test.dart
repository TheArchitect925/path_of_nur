import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_adult_overview_provider.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_controller.dart';
import 'package:path_of_nur/features/learn/quran_teaching/domain/quran_teaching_adult_overview_models.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'adult overview starts with calm start state and browse targets',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(quranTeachingAdultOverviewProvider);

      expect(summary.state, QuranTeachingAdultOverviewState.firstTime);
      expect(
        summary.primaryTarget.kind,
        ArabicLearningRouteTargetKind.adultLesson,
      );
      expect(
        summary.browseLettersTarget?.kind,
        ArabicLearningRouteTargetKind.adultModule,
      );
      expect(summary.browseLettersTarget?.moduleId, 'foundations');
      expect(
        summary.browseWordsTarget?.kind,
        ArabicLearningRouteTargetKind.adultBeginnerWords,
      );
    },
  );

  test(
    'adult overview shows in-progress state after lesson completion',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(quranTeachingProgressProvider.notifier)
          .completeLesson('alphabet_letters_1');

      final summary = container.read(quranTeachingAdultOverviewProvider);

      expect(summary.state, QuranTeachingAdultOverviewState.inProgress);
      expect(summary.progress.hasStarted, isTrue);
      expect(summary.progress.completedLessons, greaterThan(0));
      expect(summary.progress.recentActivity?.itemId, 'alphabet_letters_1');
    },
  );

  test(
    'adult overview falls into review state after all lessons are complete',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final catalog = container.read(quranTeachingCatalogProvider);
      container
          .read(quranTeachingBeginnerWordsProgressProvider.notifier)
          .recordWordOpened('bab');
      final notifier = container.read(quranTeachingProgressProvider.notifier);
      for (final lesson in catalog.lessons) {
        notifier.completeLesson(lesson.id);
      }

      final summary = container.read(quranTeachingAdultOverviewProvider);

      expect(summary.state, QuranTeachingAdultOverviewState.completed);
      expect(summary.primaryTarget.canonicalItemId, isNotEmpty);
    },
  );
}
