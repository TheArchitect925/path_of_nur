import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey/application/learning_journey_progress_provider.dart';
import '../domain/quran_daily_companion_models.dart';
import '../domain/quran_hub_recommendation_models.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_user_intent_models.dart';
import 'quran_daily_reflection_provider.dart';
import 'quran_guided_learning_paths_provider.dart';
import 'quran_learning_system_service.dart';
import 'quran_providers.dart';
import 'quran_reference_graph_provider.dart';
import 'quran_user_intent_provider.dart';

final quranHubRecommendationsProvider = Provider<List<QuranHubRecommendation>>((
  ref,
) {
  final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
  final dailySummary = ref.watch(quranDailyCompanionSummaryProvider);
  final intentSummary = ref.watch(quranUserIntentSummaryProvider);
  final memorizationDue = ref.watch(quranMemorizationDueProvider);
  final memorizationStartedCount = ref.watch(quranMemorizationStartedCountProvider);
  final continuePath = ref.watch(quranGuidedContinuePathProvider);
  final journeyContinue = ref.watch(learningJourneyContinueProvider);

  final candidates = <QuranHubRecommendation>[
    if (continuePath != null)
      QuranHubRecommendation(
        id: 'continue-path:${continuePath.id}',
        type: QuranHubRecommendationType.continuePath,
        source: QuranHubRecommendationSource.path,
        priority: 120,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': continuePath.id},
        pathId: continuePath.id,
      ),
    if (dailySummary.journeyContext != null &&
        journeyContinue.journey != null &&
        journeyContinue.stage != null)
      QuranHubRecommendation(
        id: 'journey-daily:${journeyContinue.journey!.id}:${journeyContinue.stage!.id}',
        type: QuranHubRecommendationType.journeyLinkedStudy,
        source: QuranHubRecommendationSource.journey,
        priority: 112,
        routeName: 'quranDailyCompanion',
        topicId:
            dailySummary.journeyContext!.primaryTopicId ??
            (dailySummary.themes.isEmpty ? null : dailySummary.themes.first.id),
        journeyId: journeyContinue.journey!.id,
        stageId: journeyContinue.stage!.id,
        surahNumber: dailySummary.reflection.assignment.entry.ref.surah,
        ayahNumber: dailySummary.reflection.assignment.entry.ref.ayah,
      ),
    if (memorizationDue.isNotEmpty)
      QuranHubRecommendation(
        id: 'review-memorization:${memorizationDue.length}',
        type: QuranHubRecommendationType.reviewMemorization,
        source: QuranHubRecommendationSource.review,
        priority: 108,
        routeName: 'quranMemorizationReview',
        dueCount: memorizationDue.length,
      )
    else if (intentSummary.selectedIntent == QuranUserIntent.memorize &&
        memorizationStartedCount > 0)
      QuranHubRecommendation(
        id: 'review-memorization-started',
        type: QuranHubRecommendationType.reviewMemorization,
        source: QuranHubRecommendationSource.intent,
        priority: 96,
        routeName: 'quranMemorizationReview',
        dueCount: 0,
      ),
    QuranHubRecommendation(
      id: 'daily-reflection:${dailySummary.reflection.assignment.entry.id}',
      type: QuranHubRecommendationType.dailyReflection,
      source: dailySummary.selectionSource ==
              QuranDailyLoopSelectionSource.journeyTheme
          ? QuranHubRecommendationSource.journey
          : QuranHubRecommendationSource.daily,
      priority: dailySummary.selectionSource ==
              QuranDailyLoopSelectionSource.journeyTheme
          ? 106
          : 100,
      routeName: 'quranDailyCompanion',
      topicId: dailySummary.themes.isEmpty ? null : dailySummary.themes.first.id,
      surahNumber: dailySummary.reflection.assignment.entry.ref.surah,
      ayahNumber: dailySummary.reflection.assignment.entry.ref.ayah,
    ),
    QuranHubRecommendation(
      id: 'continue-surah:${continueSummary.surahNumber}:${continueSummary.ayahNumber}',
      type: QuranHubRecommendationType.continueSurah,
      source: QuranHubRecommendationSource.recent,
      priority: 94,
      routeName: 'quranReader',
      pathParameters: {
        'surahNumber': continueSummary.surahNumber.toString(),
      },
      queryParameters: {'ayah': continueSummary.ayahNumber.toString()},
      surahNumber: continueSummary.surahNumber,
      ayahNumber: continueSummary.ayahNumber,
    ),
    if (_preferredThemeTopicId(
          dailySummary: dailySummary,
          intent: intentSummary.selectedIntent,
        ) !=
        null)
      QuranHubRecommendation(
        id: 'explore-theme:${_preferredThemeTopicId(dailySummary: dailySummary, intent: intentSummary.selectedIntent)}',
        type: QuranHubRecommendationType.exploreTheme,
        source: dailySummary.themes.isNotEmpty
            ? QuranHubRecommendationSource.daily
            : dailySummary.journeyContext != null
            ? QuranHubRecommendationSource.journey
            : QuranHubRecommendationSource.intent,
        priority: 92,
        routeName: 'quranTopicDetail',
        pathParameters: {
          'topicId':
              _preferredThemeTopicId(
                dailySummary: dailySummary,
                intent: intentSummary.selectedIntent,
              )!,
        },
        topicId: _preferredThemeTopicId(
          dailySummary: dailySummary,
          intent: intentSummary.selectedIntent,
        ),
      ),
    if (continuePath == null && intentSummary.suggestedPath != null)
      QuranHubRecommendation(
        id: 'suggested-path:${intentSummary.suggestedPath!.id}',
        type: QuranHubRecommendationType.continuePath,
        source: QuranHubRecommendationSource.intent,
        priority: 90,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': intentSummary.suggestedPath!.id},
        pathId: intentSummary.suggestedPath!.id,
      ),
    QuranHubRecommendation(
      id: 'fallback-paths',
      type: QuranHubRecommendationType.continuePath,
      source: QuranHubRecommendationSource.fallback,
      priority: 40,
      routeName: 'quranLearningPaths',
      isFallback: true,
    ),
    QuranHubRecommendation(
      id: 'fallback-daily',
      type: QuranHubRecommendationType.dailyReflection,
      source: QuranHubRecommendationSource.fallback,
      priority: 39,
      routeName: 'quranDailyCompanion',
      isFallback: true,
    ),
    QuranHubRecommendation(
      id: 'fallback-topics',
      type: QuranHubRecommendationType.exploreTheme,
      source: QuranHubRecommendationSource.fallback,
      priority: 38,
      routeName: 'quranTopicExplorer',
      isFallback: true,
    ),
  ];

  final unique = <QuranHubRecommendation>[];
  final routeKeys = <String>{};
  final ids = <String>{};

  final sorted = candidates.toList(growable: false)
    ..sort((a, b) {
      final priority = b.priority.compareTo(a.priority);
      if (priority != 0) return priority;
      return a.id.compareTo(b.id);
    });

  for (final candidate in sorted) {
    if (!ids.add(candidate.id)) continue;
    if (!routeKeys.add(candidate.routeKey)) continue;
    unique.add(candidate);
    if (unique.length >= 3) break;
  }

  if (unique.isEmpty) {
    return const <QuranHubRecommendation>[];
  }
  return unique;
});

String? _preferredThemeTopicId({
  required QuranDailyCompanionSummary dailySummary,
  required QuranUserIntent? intent,
}) {
  if (dailySummary.themes.isNotEmpty) {
    return dailySummary.themes.first.id;
  }
  final journeyTopic = dailySummary.journeyContext?.primaryTopicId;
  if (journeyTopic != null && journeyTopic.isNotEmpty) {
    return journeyTopic;
  }
  if (intent == QuranUserIntent.themes) {
    return 'gratitude';
  }
  return 'gratitude';
}

final quranHubPrimaryRecommendationProvider =
    Provider<QuranHubRecommendation?>((ref) {
      final items = ref.watch(quranHubRecommendationsProvider);
      if (items.isEmpty) return null;
      return items.first;
    });

final quranHubSecondaryRecommendationsProvider =
    Provider<List<QuranHubRecommendation>>((ref) {
      final items = ref.watch(quranHubRecommendationsProvider);
      if (items.length <= 1) return const <QuranHubRecommendation>[];
      return items.skip(1).toList(growable: false);
    });

final quranHubRecommendationTopicProvider =
    Provider.family<QuranTopic?, String>((ref, topicId) {
      return ref.watch(quranTopicByIdProvider(topicId));
    });
