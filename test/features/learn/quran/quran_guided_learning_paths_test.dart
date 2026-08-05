import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_guided_learning_paths_provider.dart';
import 'package:path_of_nur/features/learn/quran/data/seeded_quran_guided_learning_paths_data.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_guided_learning_path_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('seeded quran guided learning paths stay curated and non-empty', () {
    expect(seededQuranGuidedLearningPaths, hasLength(10));
    for (final path in seededQuranGuidedLearningPaths) {
      expect(path.id, isNotEmpty);
      expect(path.steps, isNotEmpty);
    }
  });

  test('guided learning path steps target canonical route-backed surfaces', () {
    final routeNames = seededQuranGuidedLearningPaths
        .expand((path) => path.steps)
        .map((step) => step.routeName)
        .toSet();

    expect(
      routeNames,
      unorderedEquals(<String>{
        'quranReader',
        'quranTopicDetail',
        'quranSummaryDetailPage',
      }),
    );
  });

  test(
    'guided learning continuity stores continue-path state safely',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      expect(container.read(quranGuidedContinuePathProvider), isNull);

      container
          .read(quranGuidedLearningContinuityProvider.notifier)
          .markStepOpened(
            pathId: 'verses-for-hard-times',
            stepId: 'hard-times-reader-inshirah',
          );

      final continuity = container.read(quranGuidedLearningContinuityProvider);
      final continuePath = container.read(quranGuidedContinuePathProvider);

      expect(continuity.lastPathId, 'verses-for-hard-times');
      expect(continuity.lastStepId, 'hard-times-reader-inshirah');
      expect(continuity.updatedAtIso, isNotEmpty);
      expect(continuePath?.id, 'verses-for-hard-times');
    },
  );

  test('guided path type and intensity coverage stay balanced', () {
    final pathTypes = seededQuranGuidedLearningPaths
        .map((path) => path.type)
        .toSet();
    final intensities = seededQuranGuidedLearningPaths
        .map((path) => path.intensity)
        .toSet();

    expect(pathTypes, containsAll(QuranGuidedLearningPathType.values));
    // The current curated set intentionally sticks to the gentle and guided
    // intensities; the deeper intensity is not seeded yet.
    expect(
      intensities,
      containsAll(<QuranGuidedLearningPathIntensity>{
        QuranGuidedLearningPathIntensity.gentle,
        QuranGuidedLearningPathIntensity.guided,
      }),
    );
  });
}
