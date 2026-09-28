import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_journey_progress_provider.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_registry.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_guided_learning_paths_provider.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_hub_recommendations_provider.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_learning_system_service.dart';
import 'package:path_of_nur/features/learn/quran/data/seeded_quran_guided_learning_paths_data.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_hub_recommendation_models.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_learning_models.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'hub recommendations prioritize active path and current daily companion context',
    () async {
      final journey = LearningJourneyRegistry.journeyById('daily-dhikr')!;
      final stage = LearningJourneyRegistry.stageById('dhikr-what-is')!;
      final dueProgress = MemorizationProgress(
        verseId: 'q_2_153',
        stage: MemorizationStage.repeating,
        addedAt: DateTime.parse('2026-03-20T09:00:00Z'),
        lastReviewed: DateTime.parse('2026-03-21T09:00:00Z'),
        nextReview: DateTime.parse('2026-03-23T09:00:00Z'),
        reviewCount: 2,
        lastReviewSuccessful: true,
      );

      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-24T09:00:00')),
          ),
          quranGuidedContinuePathProvider.overrideWith(
            (ref) => seededQuranGuidedLearningPaths.firstWhere(
              (path) => path.id == 'tawhid-foundations',
            ),
          ),
          learningJourneyContinueProvider.overrideWithValue(
            LearningJourneyContinueState(
              hasJourney: true,
              journey: journey,
              stage: stage,
              journeyCompleted: false,
            ),
          ),
          quranMemorizationDueProvider.overrideWith(
            (ref) => <MemorizationProgress>[dueProgress],
          ),
        ],
      );
      addTearDown(container.dispose);

      // Let the seeded clock stream deliver before the provider computes —
      // otherwise its `?? DateTime.now()` fallback reads the real clock and
      // these tests change behaviour on Fridays.
      await container.read(dailyNowProvider.future);
      final recommendations = container.read(quranHubRecommendationsProvider);
      final recommendationTypes = recommendations
          .map((item) => item.type)
          .toList(growable: false);

      expect(recommendations, hasLength(4));
      expect(recommendations[0].type, QuranHubRecommendationType.resumePathway);
      expect(
        recommendationTypes,
        contains(QuranHubRecommendationType.continueSurah),
      );
      expect(
        recommendationTypes,
        contains(QuranHubRecommendationType.timeOfDayPick),
      );
      expect(
        recommendationTypes,
        contains(QuranHubRecommendationType.relatedFollowUp),
      );
    },
  );

  test(
    'hub recommendations fall back to stable daily, pathway, and theme suggestions',
    () async {
      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-24T09:00:00')),
          ),
          quranGuidedContinuePathProvider.overrideWith((ref) => null),
          learningJourneyContinueProvider.overrideWithValue(
            const LearningJourneyContinueState(
              hasJourney: false,
              journeyCompleted: false,
            ),
          ),
          quranMemorizationDueProvider.overrideWith(
            (ref) => const <MemorizationProgress>[],
          ),
        ],
      );
      addTearDown(container.dispose);

      // Let the seeded clock stream deliver before the provider computes —
      // otherwise its `?? DateTime.now()` fallback reads the real clock and
      // these tests change behaviour on Fridays.
      await container.read(dailyNowProvider.future);
      final recommendations = container.read(quranHubRecommendationsProvider);
      final recommendationTypes = recommendations
          .map((item) => item.type)
          .toList(growable: false);

      expect(recommendations, hasLength(4));
      expect(recommendationTypes[0], QuranHubRecommendationType.continueSurah);
      expect(
        recommendationTypes,
        contains(QuranHubRecommendationType.timeOfDayPick),
      );
      expect(
        recommendationTypes,
        contains(QuranHubRecommendationType.pathwaySuggestion),
      );
      expect(
        recommendationTypes,
        contains(QuranHubRecommendationType.relatedFollowUp),
      );
    },
  );
}
