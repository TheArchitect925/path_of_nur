import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../divine_life_lessons/data/divine_life_lessons_data.dart';
import '../../divine_life_lessons/domain/divine_life_models.dart';
import '../../hadith/application/hadith_foundation_repository.dart';
import '../../hadith/domain/hadith_foundation_models.dart';
import '../../journey/data/learning_journey_quran_integration.dart';
import '../../journey/data/learning_journey_registry.dart';
import '../../journey/data/learning_journey_theme_mapping.dart';
import '../../prophets/application/prophets_repository.dart';
import '../../prophets/domain/prophet_entry.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';
import '../data/quran_reference_graph_data.dart';
import '../data/quran_thematic_map_data.dart';
import '../data/seeded_quran_learning_data.dart';
import '../domain/quran_learning_models.dart';
import '../domain/quran_reference_models.dart';
import 'quran_ayah_enrichment_provider.dart';

class QuranReferenceSearchHit {
  const QuranReferenceSearchHit({
    required this.reference,
    required this.matchedOn,
    required this.score,
  });

  final QuranReference reference;
  final String matchedOn;
  final int score;
}

class QuranRelatedKnowledgeLink {
  const QuranRelatedKnowledgeLink({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.knowledgeType,
    required this.connectionStrength,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.relationReason,
  });

  final String id;
  final String title;
  final String subtitle;
  final QuranRelatedKnowledgeCategory category;
  final QuranKnowledgeType knowledgeType;
  final QuranConnectionStrength connectionStrength;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final String? relationReason;
}

enum QuranRelatedKnowledgeCategory {
  quranInsight,
  worldLesson,
  worshipLesson,
  characterLesson,
  hadith,
  divineLife,
  prophet,
  learningPath,
  learningJourney,
}

class QuranReferenceKnowledgeBundle {
  const QuranReferenceKnowledgeBundle({
    required this.references,
    required this.enrichmentEntries,
    required this.displayItems,
    required this.lifeLessons,
    required this.hadithEntries,
    required this.prophets,
    required this.journeys,
  });

  final List<QuranReference> references;
  final List<QuranAyahEnrichmentEntry> enrichmentEntries;
  final List<QuranAyahDisplayItem> displayItems;
  final List<QuranRelatedKnowledgeLink> lifeLessons;
  final List<QuranRelatedKnowledgeLink> hadithEntries;
  final List<QuranRelatedKnowledgeLink> prophets;
  final List<QuranRelatedKnowledgeLink> journeys;
}

final quranContextualKnowledgeLinksForVerseProvider =
    Provider.family<
      List<QuranRelatedKnowledgeLink>,
      (int surahNumber, int ayahNumber)
    >((ref, input) {
      final bundle = ref.watch(quranKnowledgeForVerseProvider(input));
      final links = <QuranRelatedKnowledgeLink>[];
      final seenKeys = <String>{};

      void addLink(QuranRelatedKnowledgeLink link) {
        final key =
            '${link.routeName}|${link.pathParameters}|${link.queryParameters}';
        if (!seenKeys.add(key)) return;
        links.add(link);
      }

      for (final item in bundle.displayItems) {
        if (item.sourceRouteName == null) continue;
        addLink(
          QuranRelatedKnowledgeLink(
            id: item.id,
            title: item.title,
            subtitle: item.summary,
            category: _categoryForDisplayItem(item.type),
            knowledgeType: _knowledgeTypeForDisplayItem(item.type),
            connectionStrength: _connectionStrengthForAyahLink(
              item.linkStrength,
              type: item.type,
            ),
            routeName: item.sourceRouteName!,
            pathParameters: item.pathParameters,
            queryParameters: item.queryParameters,
            relationReason: item.relatedReason,
          ),
        );
      }

      for (final item in bundle.hadithEntries) {
        addLink(item);
      }
      for (final item in bundle.lifeLessons) {
        addLink(item);
      }
      for (final item in _learningJourneyLinksForVerse(input.$1, input.$2)) {
        addLink(item);
      }

      final primaryLinks = List<QuranRelatedKnowledgeLink>.of(links);
      final prioritized = <QuranRelatedKnowledgeLink>[...primaryLinks.take(3)];
      final prioritizedSeen = <String>{
        for (final item in prioritized)
          '${item.routeName}|${item.pathParameters}|${item.queryParameters}',
      };

      for (final item in bundle.journeys) {
        final key =
            '${item.routeName}|${item.pathParameters}|${item.queryParameters}';
        if (prioritizedSeen.contains(key)) continue;
        prioritized.add(item);
        prioritizedSeen.add(key);
        break;
      }

      for (final item in bundle.prophets) {
        final key =
            '${item.routeName}|${item.pathParameters}|${item.queryParameters}';
        if (!prioritizedSeen.add(key)) continue;
        prioritized.add(item);
        if (prioritized.length >= 4) break;
      }

      for (final item in primaryLinks.skip(3)) {
        final key =
            '${item.routeName}|${item.pathParameters}|${item.queryParameters}';
        if (!prioritizedSeen.add(key)) continue;
        prioritized.add(item);
        if (prioritized.length >= 4) break;
      }

      return prioritized.take(4).toList(growable: false);
    });

List<QuranRelatedKnowledgeLink> _learningJourneyLinksForVerse(
  int surahNumber,
  int ayahNumber,
) {
  return learningJourneyQuranReverseLinksForVerse(surahNumber, ayahNumber)
      .map((entry) {
        final stage = LearningJourneyRegistry.stageById(entry.stageId);
        final journey = LearningJourneyRegistry.journeyById(entry.journeyId);
        final mapping = learningJourneyThemeMappingForStage(entry.stageId);
        if (stage == null || journey == null) return null;
        return QuranRelatedKnowledgeLink(
          id: 'learning-journey:${entry.stageId}',
          title: stage.title,
          subtitle: journey.title,
          category: QuranRelatedKnowledgeCategory.learningJourney,
          knowledgeType: QuranKnowledgeType.journey,
          connectionStrength:
              mapping?.connectionStrength ??
              entry.connectionStrength ??
              QuranConnectionStrength.related,
          routeName: 'learnJourneyStage',
          pathParameters: {'journeyId': journey.id, 'stageId': stage.id},
          relationReason:
              'This journey lesson studies the same Qur’an passage through a guided learning path.',
        );
      })
      .whereType<QuranRelatedKnowledgeLink>()
      .toList(growable: false);
}

final quranReferenceGraphProvider = Provider<QuranReferenceGraph>((ref) {
  return buildQuranReferenceGraph();
});

final quranReferenceByIdProvider = Provider.family<QuranReference?, String>((
  ref,
  referenceId,
) {
  return ref.watch(quranReferenceGraphProvider).referenceById[referenceId];
});

final quranReferencesForVerseProvider =
    Provider.family<List<QuranReference>, (int surahNumber, int ayahNumber)>((
      ref,
      input,
    ) {
      final graph = ref.watch(quranReferenceGraphProvider);
      final ids = graph.referenceIdsBySurah[input.$1] ?? const <String>[];
      return ids
          .map((id) => graph.referenceById[id])
          .whereType<QuranReference>()
          .where((item) => item.containsAyah(input.$2))
          .toList(growable: false)
        ..sort((a, b) => b.displayPriority.compareTo(a.displayPriority));
    });

final quranReferenceSearchHitsProvider =
    Provider.family<List<QuranReferenceSearchHit>, String>((ref, query) {
      final normalized = query.trim().toLowerCase();
      if (normalized.isEmpty) return const <QuranReferenceSearchHit>[];
      final graph = ref.watch(quranReferenceGraphProvider);
      final hits = <QuranReferenceSearchHit>[];

      for (final item in graph.references) {
        var score = 0;
        var matchedOn = '';
        if (item.referenceLabel == normalized) {
          score = 140;
          matchedOn = 'reference';
        } else if (item.referenceLabel.startsWith(normalized)) {
          score = 120;
          matchedOn = 'reference';
        } else if (item.surahName.toLowerCase().contains(normalized)) {
          score = 100;
          matchedOn = 'surah';
        } else if (item.topicTags.any((tag) => tag.contains(normalized))) {
          score = 90;
          matchedOn = 'topic';
        } else if (item.keywords.any(
          (keyword) => keyword.contains(normalized),
        )) {
          score = 80;
          matchedOn = 'keyword';
        } else if (item.contextSummary.toLowerCase().contains(normalized)) {
          score = 70;
          matchedOn = 'summary';
        }
        if (score <= 0) continue;
        hits.add(
          QuranReferenceSearchHit(
            reference: item,
            matchedOn: matchedOn,
            score: score + (item.importanceScore ~/ 10),
          ),
        );
      }

      hits.sort((a, b) => b.score.compareTo(a.score));
      return hits.take(40).toList(growable: false);
    });

final quranTopicsProvider = Provider<List<QuranTopic>>((ref) {
  final graph = ref.watch(quranReferenceGraphProvider);
  final referenceByLabel = {
    for (final item in graph.references) item.referenceLabel: item,
  };
  final topics =
      quranThematicTopicSeeds
          .map((seed) {
            final refs = seed.referenceLabels
                .map((label) => referenceByLabel[label])
                .whereType<QuranReference>()
                .toList(growable: false);
            if (refs.isEmpty) return null;
            return QuranTopic(
              id: seed.id,
              title: seed.title,
              description: seed.description,
              primaryReferenceId: refs
                  .firstWhere(
                    (item) =>
                        item.referenceLabel ==
                        seed.resolvedPrimaryReferenceLabel,
                    orElse: () => refs.first,
                  )
                  .id,
              suggestedReaderMode: seed.suggestedReaderMode,
              verseReferences: refs
                  .map((item) => item.id)
                  .toList(growable: false),
              relatedLessons: refs
                  .expand((item) => item.relatedLessonIds)
                  .toSet()
                  .toList(growable: false),
              relatedHadith: refs
                  .expand((item) => item.relatedHadithIds)
                  .toSet()
                  .toList(growable: false),
              relatedProphets: refs
                  .expand((item) => item.relatedProphetIds)
                  .toSet()
                  .toList(growable: false),
              relatedSurahNumbers: seed.relatedSurahNumbers,
              relatedRoutes: seed.relatedRoutes,
              searchKeywords: seed.searchKeywords,
              suggestedPathId: seed.suggestedPathId,
            );
          })
          .whereType<QuranTopic>()
          .toList(growable: false)
        ..sort((a, b) {
          final byRefs = b.verseReferences.length.compareTo(
            a.verseReferences.length,
          );
          if (byRefs != 0) return byRefs;
          return a.title.compareTo(b.title);
        });
  return topics;
});

final quranTopicByIdProvider = Provider.family<QuranTopic?, String>((
  ref,
  topicId,
) {
  for (final topic in ref.watch(quranTopicsProvider)) {
    if (topic.id == topicId) return topic;
  }
  return null;
});

final quranTopicReferencesProvider =
    Provider.family<List<QuranReference>, String>((ref, topicId) {
      final graph = ref.watch(quranReferenceGraphProvider);
      final topic = ref.watch(quranTopicByIdProvider(topicId));
      if (topic == null) return const <QuranReference>[];
      final refs =
          topic.verseReferences
              .map((id) => graph.referenceById[id])
              .whereType<QuranReference>()
              .toList(growable: false)
            ..sort((a, b) => b.importanceScore.compareTo(a.importanceScore));
      return refs;
    });

final quranThemesForVerseProvider =
    Provider.family<List<QuranTopic>, (int surahNumber, int ayahNumber)>((
      ref,
      input,
    ) {
      final references = ref.watch(quranReferencesForVerseProvider(input));
      if (references.isEmpty) return const <QuranTopic>[];
      final referenceIds = references.map((item) => item.id).toSet();
      final topics = ref.watch(quranTopicsProvider);
      return topics
          .where((topic) => topic.verseReferences.any(referenceIds.contains))
          .take(3)
          .toList(growable: false);
    });

final quranThemesForSurahProvider = Provider.family<List<QuranTopic>, int>((
  ref,
  surahNumber,
) {
  final topics = ref.watch(quranTopicsProvider);
  final matches = <QuranTopic>[];
  for (final topic in topics) {
    final hasDirectSurahMatch = topic.relatedSurahNumbers.contains(surahNumber);
    final hasReferenceMatch = ref
        .watch(quranTopicReferencesProvider(topic.id))
        .any((reference) => reference.surahNumber == surahNumber);
    if (hasDirectSurahMatch || hasReferenceMatch) {
      matches.add(topic);
    }
    if (matches.length >= 4) break;
  }
  return matches;
});

final quranReferenceKnowledgeBundleProvider =
    Provider.family<QuranReferenceKnowledgeBundle, String>((ref, referenceId) {
      final graph = ref.watch(quranReferenceGraphProvider);
      final reference = graph.referenceById[referenceId];
      if (reference == null) {
        return const QuranReferenceKnowledgeBundle(
          references: <QuranReference>[],
          enrichmentEntries: <QuranAyahEnrichmentEntry>[],
          displayItems: <QuranAyahDisplayItem>[],
          lifeLessons: <QuranRelatedKnowledgeLink>[],
          hadithEntries: <QuranRelatedKnowledgeLink>[],
          prophets: <QuranRelatedKnowledgeLink>[],
          journeys: <QuranRelatedKnowledgeLink>[],
        );
      }

      final hadithById = {
        for (final entry in ref.watch(hadithEntriesProvider)) entry.id: entry,
      };
      final prophetById = {
        for (final prophet in ref.watch(prophetsProvider)) prophet.id: prophet,
      };
      final journeyById = {
        for (final path in seededQuranLearningPaths) path.id: path,
      };

      final enrichmentEntries = ref.watch(
        quranAyahEnrichmentForRangeProvider(
          QuranQuoteRef(
            surah: reference.surahNumber,
            ayah: reference.ayahStart,
            ayahEnd: reference.ayahEnd,
          ),
        ),
      );
      final displayItems = ref.watch(
        quranAyahDisplayItemsForRangeProvider(
          QuranQuoteRef(
            surah: reference.surahNumber,
            ayah: reference.ayahStart,
            ayahEnd: reference.ayahEnd,
          ),
        ),
      );

      final lifeLessons = reference.relatedLessonIds
          .map(divineLifeLessonById)
          .whereType<DivineLifeLesson>()
          .map(
            (lesson) => QuranRelatedKnowledgeLink(
              id: lesson.id,
              title: lesson.title,
              subtitle: lesson.quranReference,
              category: QuranRelatedKnowledgeCategory.divineLife,
              knowledgeType: QuranKnowledgeType.lifeLesson,
              connectionStrength: QuranConnectionStrength.strong,
              routeName: 'lifeLessonDetail',
              pathParameters: {'lessonId': lesson.id},
              relationReason: reference.contextSummary,
            ),
          )
          .toList(growable: false);

      final hadithEntries = reference.relatedHadithIds
          .map((id) => hadithById[id])
          .whereType<HadithEntry>()
          .map(
            (entry) => QuranRelatedKnowledgeLink(
              id: entry.id,
              title: entry.title,
              subtitle: entry.displaySourceCollection,
              category: QuranRelatedKnowledgeCategory.hadith,
              knowledgeType: QuranKnowledgeType.hadith,
              connectionStrength: QuranConnectionStrength.strong,
              routeName: 'hadithLessonDetail',
              pathParameters: {'lessonId': entry.id},
              relationReason: reference.contextSummary,
            ),
          )
          .toList(growable: false);

      final prophets = reference.relatedProphetIds
          .map((id) => prophetById[id])
          .whereType<ProphetEntry>()
          .map(
            (prophet) => QuranRelatedKnowledgeLink(
              id: prophet.id,
              title: prophet.name,
              subtitle: prophet.shortSummary,
              category: QuranRelatedKnowledgeCategory.prophet,
              knowledgeType: QuranKnowledgeType.seerah,
              connectionStrength: QuranConnectionStrength.strong,
              routeName: 'learnProphetsHub',
              queryParameters: {'tab': 'stories', 'prophet': prophet.id},
              relationReason: reference.contextSummary,
            ),
          )
          .toList(growable: false);

      final journeys = reference.relatedJourneyIds
          .map((id) => journeyById[id])
          .whereType<QuranLearningPath>()
          .map(
            (path) => QuranRelatedKnowledgeLink(
              id: path.id,
              title: path.title,
              subtitle: path.description,
              category: QuranRelatedKnowledgeCategory.learningPath,
              knowledgeType: QuranKnowledgeType.journey,
              connectionStrength: QuranConnectionStrength.related,
              routeName: 'quranAyahInsightsPathDetail',
              pathParameters: {'pathId': path.id},
              relationReason: reference.contextSummary,
            ),
          )
          .toList(growable: false);

      return QuranReferenceKnowledgeBundle(
        references: [reference],
        enrichmentEntries: enrichmentEntries,
        displayItems: displayItems,
        lifeLessons: lifeLessons,
        hadithEntries: hadithEntries,
        prophets: prophets,
        journeys: journeys,
      );
    });

final quranKnowledgeForVerseProvider =
    Provider.family<
      QuranReferenceKnowledgeBundle,
      (int surahNumber, int ayahNumber)
    >((ref, input) {
      final refs = ref.watch(quranReferencesForVerseProvider(input));
      if (refs.isEmpty) {
        return const QuranReferenceKnowledgeBundle(
          references: <QuranReference>[],
          enrichmentEntries: <QuranAyahEnrichmentEntry>[],
          displayItems: <QuranAyahDisplayItem>[],
          lifeLessons: <QuranRelatedKnowledgeLink>[],
          hadithEntries: <QuranRelatedKnowledgeLink>[],
          prophets: <QuranRelatedKnowledgeLink>[],
          journeys: <QuranRelatedKnowledgeLink>[],
        );
      }

      final enrichmentEntries = ref.watch(
        quranAyahEnrichmentForVerseProvider((input.$1, input.$2)),
      );
      final displayItems = ref.watch(
        quranAyahDisplayItemsForVerseProvider((input.$1, input.$2)),
      );
      final aggregatedLife = <QuranRelatedKnowledgeLink>[];
      final aggregatedHadith = <QuranRelatedKnowledgeLink>[];
      final aggregatedProphets = <QuranRelatedKnowledgeLink>[];
      final aggregatedJourneys = <QuranRelatedKnowledgeLink>[];
      final seenLife = <String>{};
      final seenHadith = <String>{};
      final seenProphets = <String>{};
      final seenJourneys = <String>{};

      for (final reference in refs) {
        final bundle = ref.watch(
          quranReferenceKnowledgeBundleProvider(reference.id),
        );
        for (final item in bundle.lifeLessons) {
          if (seenLife.add(item.id)) aggregatedLife.add(item);
        }
        for (final item in bundle.hadithEntries) {
          if (seenHadith.add(item.id)) aggregatedHadith.add(item);
        }
        for (final item in bundle.prophets) {
          if (seenProphets.add(item.id)) aggregatedProphets.add(item);
        }
        for (final item in bundle.journeys) {
          if (seenJourneys.add(item.id)) aggregatedJourneys.add(item);
        }
      }

      return QuranReferenceKnowledgeBundle(
        references: refs,
        enrichmentEntries: enrichmentEntries,
        displayItems: displayItems,
        lifeLessons: aggregatedLife,
        hadithEntries: aggregatedHadith,
        prophets: aggregatedProphets,
        journeys: aggregatedJourneys,
      );
    });

final quranReferenceIdsForLifeLessonProvider =
    Provider.family<List<String>, String>((ref, lessonId) {
      final graph = ref.watch(quranReferenceGraphProvider);
      return graph.references
          .where((item) => item.relatedLessonIds.contains(lessonId))
          .map((item) => item.id)
          .toList(growable: false);
    });

final quranReferenceIdsForHadithProvider =
    Provider.family<List<String>, String>((ref, hadithId) {
      final graph = ref.watch(quranReferenceGraphProvider);
      return graph.references
          .where((item) => item.relatedHadithIds.contains(hadithId))
          .map((item) => item.id)
          .toList(growable: false);
    });

final quranReferenceIdsForProphetProvider =
    Provider.family<List<String>, String>((ref, prophetId) {
      final graph = ref.watch(quranReferenceGraphProvider);
      return graph.references
          .where((item) => item.relatedProphetIds.contains(prophetId))
          .map((item) => item.id)
          .toList(growable: false);
    });

QuranRelatedKnowledgeCategory _categoryForDisplayItem(
  QuranAyahDisplayItemType type,
) {
  switch (type) {
    case QuranAyahDisplayItemType.hadithReference:
      return QuranRelatedKnowledgeCategory.hadith;
    case QuranAyahDisplayItemType.signsInCreation:
    case QuranAyahDisplayItemType.scientificReflection:
    case QuranAyahDisplayItemType.worldCreationLesson:
      return QuranRelatedKnowledgeCategory.worldLesson;
    case QuranAyahDisplayItemType.worshipLesson:
      return QuranRelatedKnowledgeCategory.worshipLesson;
    case QuranAyahDisplayItemType.characterLesson:
      return QuranRelatedKnowledgeCategory.characterLesson;
    case QuranAyahDisplayItemType.prophetConnection:
      return QuranRelatedKnowledgeCategory.prophet;
    case QuranAyahDisplayItemType.ayahInsight:
    case QuranAyahDisplayItemType.relatedAyah:
    case QuranAyahDisplayItemType.reflectionPrompt:
    case QuranAyahDisplayItemType.interpretationNote:
      return QuranRelatedKnowledgeCategory.quranInsight;
  }
}

QuranKnowledgeType _knowledgeTypeForDisplayItem(QuranAyahDisplayItemType type) {
  switch (type) {
    case QuranAyahDisplayItemType.hadithReference:
      return QuranKnowledgeType.hadith;
    case QuranAyahDisplayItemType.signsInCreation:
    case QuranAyahDisplayItemType.scientificReflection:
    case QuranAyahDisplayItemType.worldCreationLesson:
      return QuranKnowledgeType.signsWorld;
    case QuranAyahDisplayItemType.worshipLesson:
      return QuranKnowledgeType.worship;
    case QuranAyahDisplayItemType.characterLesson:
      return QuranKnowledgeType.character;
    case QuranAyahDisplayItemType.prophetConnection:
      return QuranKnowledgeType.seerah;
    case QuranAyahDisplayItemType.relatedAyah:
      return QuranKnowledgeType.quranDirect;
    case QuranAyahDisplayItemType.reflectionPrompt:
    case QuranAyahDisplayItemType.interpretationNote:
    case QuranAyahDisplayItemType.ayahInsight:
      return QuranKnowledgeType.reflection;
  }
}

QuranConnectionStrength _connectionStrengthForAyahLink(
  QuranAyahLinkStrength strength, {
  required QuranAyahDisplayItemType type,
}) {
  switch (strength) {
    case QuranAyahLinkStrength.direct:
      return type == QuranAyahDisplayItemType.reflectionPrompt
          ? QuranConnectionStrength.reflective
          : QuranConnectionStrength.direct;
    case QuranAyahLinkStrength.strongThematic:
      return type == QuranAyahDisplayItemType.reflectionPrompt ||
              type == QuranAyahDisplayItemType.interpretationNote ||
              type == QuranAyahDisplayItemType.ayahInsight
          ? QuranConnectionStrength.reflective
          : QuranConnectionStrength.related;
    case QuranAyahLinkStrength.contextual:
      return type == QuranAyahDisplayItemType.relatedAyah
          ? QuranConnectionStrength.related
          : QuranConnectionStrength.reflective;
  }
}
