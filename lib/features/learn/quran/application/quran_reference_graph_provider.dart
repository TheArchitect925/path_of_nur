import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../divine_life_lessons/data/divine_life_lessons_data.dart';
import '../../divine_life_lessons/domain/divine_life_models.dart';
import '../../hadith/application/hadith_foundation_repository.dart';
import '../../hadith/domain/hadith_foundation_models.dart';
import '../../prophets/application/prophets_repository.dart';
import '../../prophets/domain/prophet_entry.dart';
import '../data/quran_reference_graph_data.dart';
import '../data/seeded_quran_learning_data.dart';
import '../domain/quran_learning_models.dart';
import '../domain/quran_reference_models.dart';

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
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String id;
  final String title;
  final String subtitle;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class QuranReferenceKnowledgeBundle {
  const QuranReferenceKnowledgeBundle({
    required this.references,
    required this.lifeLessons,
    required this.hadithEntries,
    required this.prophets,
    required this.journeys,
  });

  final List<QuranReference> references;
  final List<QuranRelatedKnowledgeLink> lifeLessons;
  final List<QuranRelatedKnowledgeLink> hadithEntries;
  final List<QuranRelatedKnowledgeLink> prophets;
  final List<QuranRelatedKnowledgeLink> journeys;
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
  final topics = [...graph.topics]
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

final quranReferenceKnowledgeBundleProvider =
    Provider.family<QuranReferenceKnowledgeBundle, String>((ref, referenceId) {
      final graph = ref.watch(quranReferenceGraphProvider);
      final reference = graph.referenceById[referenceId];
      if (reference == null) {
        return const QuranReferenceKnowledgeBundle(
          references: <QuranReference>[],
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

      final lifeLessons = reference.relatedLessonIds
          .map(divineLifeLessonById)
          .whereType<DivineLifeLesson>()
          .map(
            (lesson) => QuranRelatedKnowledgeLink(
              id: lesson.id,
              title: lesson.title,
              subtitle: lesson.quranReference,
              routeName: 'lifeLessonDetail',
              pathParameters: {'lessonId': lesson.id},
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
              routeName: 'hadithLessonDetail',
              pathParameters: {'lessonId': entry.id},
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
              routeName: 'learnProphetsHub',
              queryParameters: {'prophet': prophet.id},
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
              routeName: 'quran',
            ),
          )
          .toList(growable: false);

      return QuranReferenceKnowledgeBundle(
        references: [reference],
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
          lifeLessons: <QuranRelatedKnowledgeLink>[],
          hadithEntries: <QuranRelatedKnowledgeLink>[],
          prophets: <QuranRelatedKnowledgeLink>[],
          journeys: <QuranRelatedKnowledgeLink>[],
        );
      }

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
