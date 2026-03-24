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
  test('hub recommendations prioritize active path, journey-linked daily, and due review', () async {
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
          (ref) => Stream<DateTime>.value(DateTime.parse('2026-03-24T09:00:00')),
        ),
        quranGuidedContinuePathProvider.overrideWith(
          (ref) => seededQuranGuidedLearningPaths.firstWhere(
            (path) => path.id == 'surah-study-starter',
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
        quranMemorizationDueProvider.overrideWith((ref) => <MemorizationProgress>[
              dueProgress,
            ]),
      ],
    );
    addTearDown(container.dispose);

    final recommendations = container.read(quranHubRecommendationsProvider);

    expect(recommendations, hasLength(3));
    expect(recommendations[0].type, QuranHubRecommendationType.continuePath);
    expect(recommendations[1].type, QuranHubRecommendationType.journeyLinkedStudy);
    expect(recommendations[2].type, QuranHubRecommendationType.reviewMemorization);
  });

  test('hub recommendations fall back to stable daily, continue-surah, and theme study suggestions', () async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) => Stream<DateTime>.value(DateTime.parse('2026-03-24T09:00:00')),
        ),
        quranGuidedContinuePathProvider.overrideWith((ref) => null),
        learningJourneyContinueProvider.overrideWithValue(
          const LearningJourneyContinueState(
            hasJourney: false,
            journeyCompleted: false,
          ),
        ),
        quranMemorizationDueProvider.overrideWith((ref) => const <MemorizationProgress>[]),
      ],
    );
    addTearDown(container.dispose);

    final recommendations = container.read(quranHubRecommendationsProvider);

    expect(recommendations, hasLength(3));
    expect(recommendations[0].type, QuranHubRecommendationType.dailyReflection);
    expect(recommendations[1].type, QuranHubRecommendationType.continueSurah);
    expect(recommendations[2].type, QuranHubRecommendationType.exploreTheme);
  });
}
