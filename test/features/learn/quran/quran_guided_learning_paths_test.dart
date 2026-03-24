import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_guided_learning_paths_provider.dart';
import 'package:path_of_nur/features/learn/quran/data/seeded_quran_guided_learning_paths_data.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_guided_learning_path_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('seeded quran guided learning paths stay curated and non-empty', () {
    expect(seededQuranGuidedLearningPaths, hasLength(5));
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
      containsAll(<String>{
        'quranReader',
        'quranTopicDetail',
        'quranMemorizationReview',
        'quranReflections',
        'quranSurahInsights',
        'quranAyahInsightsPathDetail',
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
            pathId: 'memorization-support',
            stepId: 'memorization-study-anchor-ayah',
          );

      final continuity = container.read(quranGuidedLearningContinuityProvider);
      final continuePath = container.read(quranGuidedContinuePathProvider);

      expect(continuity.lastPathId, 'memorization-support');
      expect(continuity.lastStepId, 'memorization-study-anchor-ayah');
      expect(continuity.updatedAtIso, isNotEmpty);
      expect(continuePath?.id, 'memorization-support');
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
    expect(intensities, containsAll(QuranGuidedLearningPathIntensity.values));
  });
}
