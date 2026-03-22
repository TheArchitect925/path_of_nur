import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/data/historical_calendar_repository.dart';
import '../../history/domain/historical_event_models.dart';
import '../../learn/hadith/application/hadith_foundation_repository.dart';
import '../../learn/hadith/domain/hadith_foundation_models.dart';
import '../../learn/journey/data/learning_journey_registry.dart';
import '../../learn/journey/domain/learning_journey_models.dart';
import '../../learn/presentation/application/learn_hub_providers.dart';
import '../../learn/presentation/models/learn_hub_models.dart';
import '../domain/contextual_linking_models.dart';
import 'contextual_linking_service.dart';

final contextualLinkingServiceProvider = Provider<ContextualLinkingService>(
  (_) => const ContextualLinkingService(),
);

final contextualLinkCandidateNodesProvider =
    FutureProvider<List<ContextualLinkNode>>((ref) async {
      final events = await ref
          .watch(historicalCalendarRepositoryProvider)
          .getAllEvents();
      final hadithEntries = ref.watch(hadithEntriesProvider);
      final learnIndex = ref.watch(learnHubKnowledgeIndexProvider);

      return [
        ...events.map(_nodeFromHistoricalEvent),
        ...LearningJourneyRegistry.journeys
            .where((journey) => journey.isPublished)
            .map(_nodeFromJourney),
        ...hadithEntries.map(_nodeFromHadithEntry),
        ...learnIndex
            .where(_isEligibleLearnItemForContextualLinks)
            .map(_nodeFromLearnItem),
      ];
    });

final contextualLinksForHistoricalEventProvider =
    FutureProvider.family<List<ContextualLinkResult>, String>((ref, slug) async {
      final event = await ref
          .watch(historicalCalendarRepositoryProvider)
          .getEventBySlug(slug);
      if (event == null) return const <ContextualLinkResult>[];

      final candidates = await ref.watch(contextualLinkCandidateNodesProvider.future);
      final service = ref.watch(contextualLinkingServiceProvider);
      return service.findRelated(
        current: _nodeFromHistoricalEvent(event),
        candidates: candidates,
        manualIncludeIds: event.relatedContentIds,
      );
    });

final contextualLinksForHadithEntryProvider =
    FutureProvider.family<List<ContextualLinkResult>, String>((ref, entryId) async {
      final entry = ref.watch(hadithEntryByIdProvider(entryId));
      if (entry == null) return const <ContextualLinkResult>[];

      final candidates = await ref.watch(contextualLinkCandidateNodesProvider.future);
      final service = ref.watch(contextualLinkingServiceProvider);
      return service.findRelated(
        current: _nodeFromHadithEntry(entry),
        candidates: candidates,
        manualIncludeIds: entry.relatedHadithIds,
      );
    });

final contextualLinksForLearningJourneyStageProvider = FutureProvider.family<
    List<ContextualLinkResult>,
    ({String journeyId, String stageId})>((ref, args) async {
  final journey = LearningJourneyRegistry.journeyById(args.journeyId);
  final stage = LearningJourneyRegistry.stageById(args.stageId);
  if (journey == null || stage == null || stage.journeyId != journey.id) {
    return const <ContextualLinkResult>[];
  }

  final candidates = await ref.watch(contextualLinkCandidateNodesProvider.future);
  final service = ref.watch(contextualLinkingServiceProvider);
  final filteredCandidates = candidates.where(
    (candidate) => candidate.id != journey.id,
  );
  return service.findRelated(
    current: _nodeFromJourneyStage(journey, stage),
    candidates: filteredCandidates,
    manualIncludeIds: const <String>[],
  );
});

ContextualLinkNode _nodeFromHistoricalEvent(HistoricalEvent event) {
  return ContextualLinkNode(
    id: event.id,
    uniqueKey: 'learnHistoricalEventDetail|${event.slug}',
    type: ContextualContentType.historicalEvent,
    title: event.title,
    subtitle: event.location.name,
    summary: event.summaryShort,
    tags: event.tags,
    categories: event.categories.map(historicalEventCategoryKey).toList(),
    entities: event.relatedEntities,
    routeName: 'learnHistoricalEventDetail',
    pathParameters: {'slug': event.slug},
  );
}

ContextualLinkNode _nodeFromJourney(LearningJourney journey) {
  return ContextualLinkNode(
    id: journey.id,
    uniqueKey: 'learnJourneyDetail|${journey.id}',
    type: ContextualContentType.journey,
    title: journey.title,
    subtitle: journey.subtitle,
    summary: journey.description,
    tags: journey.tags,
    categories: <String>[
      journey.islandId,
      journey.difficulty.name,
      'journey',
    ],
    entities: const <String>[],
    routeName: 'learnJourneyDetail',
    pathParameters: {'journeyId': journey.id},
  );
}

ContextualLinkNode _nodeFromJourneyStage(
  LearningJourney journey,
  LearningJourneyStage stage,
) {
  return ContextualLinkNode(
    id: stage.id,
    uniqueKey: 'learnJourneyStage|${journey.id}|${stage.id}',
    type: ContextualContentType.journey,
    title: stage.title,
    subtitle: journey.title,
    summary: stage.summary,
    tags: <String>[
      ...journey.tags,
      ...stage.tags,
      stage.title,
    ],
    categories: <String>[
      journey.islandId,
      journey.difficulty.name,
      'journey_lesson',
    ],
    entities: const <String>[],
    routeName: 'learnJourneyStage',
    pathParameters: {'journeyId': journey.id, 'stageId': stage.id},
  );
}

ContextualLinkNode _nodeFromHadithEntry(HadithEntry entry) {
  return ContextualLinkNode(
    id: entry.id,
    uniqueKey: 'hadithLessonDetail|${entry.id}',
    type: ContextualContentType.hadith,
    title: entry.title,
    subtitle: entry.themeTag ?? entry.sourceLabel,
    summary: entry.excerpt,
    tags: entry.tags,
    categories: <String>[
      'hadith',
      entry.themeId,
      ...entry.collectionIds,
    ],
    entities: <String>[
      if (entry.narrator != null && entry.narrator!.trim().isNotEmpty)
        entry.narrator!,
    ],
    routeName: 'hadithLessonDetail',
    pathParameters: {'lessonId': entry.id},
  );
}

ContextualLinkNode _nodeFromLearnItem(LearnHubKnowledgeItem item) {
  return ContextualLinkNode(
    id: item.id,
    uniqueKey:
        '${item.routeTarget.routeName}|${item.routeTarget.pathParameters}|${item.routeTarget.queryParameters}',
    type: ContextualContentType.learnContent,
    title: item.title,
    subtitle: item.subtitle,
    summary: item.summary,
    tags: <String>[
      ...item.searchKeywords,
      item.title,
      item.subtitle,
      if (item.subcategoryTitle != null) item.subcategoryTitle!,
    ],
    categories: <String>[
      item.categoryId.name,
      item.contentType.name,
      if (item.subcategoryId != null) item.subcategoryId!,
    ],
    entities: const <String>[],
    routeName: item.routeTarget.routeName,
    pathParameters: item.routeTarget.pathParameters,
    queryParameters: item.routeTarget.queryParameters,
  );
}

bool _isEligibleLearnItemForContextualLinks(LearnHubKnowledgeItem item) {
  if (item.routeTarget.routeName == 'learnHistoryArchive') return false;
  switch (item.contentType) {
    case LearnHubContentType.category:
    case LearnHubContentType.subcategory:
    case LearnHubContentType.journey:
      return false;
    case LearnHubContentType.lesson:
    case LearnHubContentType.story:
    case LearnHubContentType.quiz:
    case LearnHubContentType.challenge:
    case LearnHubContentType.tool:
    case LearnHubContentType.note:
    case LearnHubContentType.faq:
      return true;
  }
}
