import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learn/dua/application/dua_repository.dart';
import '../../learn/dua/domain/dua_models.dart';
import '../../learn/hadith/application/hadith_foundation_repository.dart';
import '../../learn/presentation/application/learn_hub_providers.dart';
import '../../learn/presentation/models/learn_hub_models.dart';
import '../../learn/quran/application/quran_reference_graph_provider.dart';
import '../../learn/quran/domain/quran_reference_models.dart';
import '../../learn/world/data/world_creation_data.dart';
import '../data/editorial_relation_data.dart';
import '../domain/editorial_relation_models.dart';

final seededEditorialRelationEntriesProvider =
    Provider<List<EditorialRelationEntry>>(
      (_) => seededEditorialRelationEntries,
    );

final editorialRelationEntriesProvider =
    FutureProvider<List<EditorialRelationEntry>>((ref) async {
      final graph = ref.watch(quranReferenceGraphProvider);
      final duaDataset = await ref.watch(duaDatasetProvider.future);
      final seeded = ref.watch(seededEditorialRelationEntriesProvider);

      final deduped = <String, EditorialRelationEntry>{};

      void addEntry(EditorialRelationEntry entry) {
        deduped.putIfAbsent(entry.id, () => entry);
      }

      for (final entry in seeded) {
        addEntry(entry);
      }

      for (final entry in _buildQuranHadithRelations(graph)) {
        addEntry(entry);
      }
      for (final entry in _buildQuranDuaRelations(graph, duaDataset)) {
        addEntry(entry);
      }
      for (final entry in _buildQuranWorldRelations(graph)) {
        addEntry(entry);
      }

      final result = deduped.values.toList(growable: false)
        ..sort((a, b) => a.id.compareTo(b.id));
      return result;
    });

final editorialRelationsForNodeProvider =
    FutureProvider.family<
      List<EditorialRelationEntry>,
      EditorialRelationContentRef
    >((ref, node) async {
      final entries = await ref.watch(editorialRelationEntriesProvider.future);
      return entries
          .where((entry) => entry.connects(node))
          .toList(growable: false);
    });

final editorialResolvedLinksForNodeProvider =
    FutureProvider.family<
      List<EditorialResolvedRelationLink>,
      EditorialRelationContentRef
    >((ref, node) async {
      final relations = await ref.watch(
        editorialRelationsForNodeProvider(node).future,
      );
      final results = <EditorialResolvedRelationLink>[];

      for (final relation in relations) {
        final counterpart = relation.counterpartFor(node);
        if (counterpart == null) continue;
        final resolved = await _resolveRelationCounterpart(
          ref,
          relation: relation,
          counterpart: counterpart,
        );
        if (resolved != null) {
          results.add(resolved);
        }
      }

      results.sort((a, b) {
        final domainCompare = a.domain.index.compareTo(b.domain.index);
        if (domainCompare != 0) return domainCompare;
        return a.title.compareTo(b.title);
      });
      return results;
    });

final editorialResolvedLinksForQuranVerseProvider =
    FutureProvider.family<
      List<EditorialResolvedRelationLink>,
      ({int surahNumber, int ayahNumber})
    >((ref, input) async {
      final references = ref.watch(
        quranReferencesForVerseProvider((input.surahNumber, input.ayahNumber)),
      );
      if (references.isEmpty) {
        return const <EditorialResolvedRelationLink>[];
      }

      final results = <EditorialResolvedRelationLink>[];
      final seen = <String>{};
      for (final reference in references) {
        final links = await ref.watch(
          editorialResolvedLinksForNodeProvider(
            EditorialRelationContentRef.quran(reference.id),
          ).future,
        );
        for (final link in links) {
          final key =
              '${link.domain.name}:${link.targetId}:${link.relationType.name}';
          if (!seen.add(key)) continue;
          results.add(link);
        }
      }

      results.sort((a, b) {
        final domainCompare = a.domain.index.compareTo(b.domain.index);
        if (domainCompare != 0) return domainCompare;
        final relationCompare = a.relationType.index.compareTo(
          b.relationType.index,
        );
        if (relationCompare != 0) return relationCompare;
        return a.title.compareTo(b.title);
      });
      return results;
    });

Future<EditorialResolvedRelationLink?> _resolveRelationCounterpart(
  Ref ref, {
  required EditorialRelationEntry relation,
  required EditorialRelationContentRef counterpart,
}) async {
  switch (counterpart.domain) {
    case EditorialRelationDomain.quran:
      final reference = ref.watch(quranReferenceByIdProvider(counterpart.id));
      if (reference == null) return null;
      return _resolvedLinkForQuranReference(relation, reference);
    case EditorialRelationDomain.hadith:
      final entry = ref.watch(hadithEntryByIdProvider(counterpart.id));
      if (entry == null) return null;
      return EditorialResolvedRelationLink(
        relationId: relation.id,
        relationType: relation.type,
        origin: relation.origin,
        domain: EditorialRelationDomain.hadith,
        targetId: entry.id,
        title: entry.title,
        subtitle: entry.displaySourceCollectionTitle,
        routeName: 'hadithLessonDetail',
        pathParameters: {'lessonId': entry.id},
        editorialLabel: relation.editorialLabel,
        editorialNote: relation.editorialNote,
      );
    case EditorialRelationDomain.dua:
      final item = await _duaItemById(ref, counterpart.id);
      if (item == null || !item.isDefaultSurfaceEligible) return null;
      return EditorialResolvedRelationLink(
        relationId: relation.id,
        relationType: relation.type,
        origin: relation.origin,
        domain: EditorialRelationDomain.dua,
        targetId: item.id,
        title: item.title,
        subtitle: item.subcategoryLabel,
        routeName: 'learnDuaDetail',
        pathParameters: {'duaId': item.id},
        editorialLabel: relation.editorialLabel,
        editorialNote: relation.editorialNote,
      );
    case EditorialRelationDomain.worldCreation:
      final lesson = worldCreationLessonById(counterpart.id);
      if (lesson == null) return null;
      return EditorialResolvedRelationLink(
        relationId: relation.id,
        relationType: relation.type,
        origin: relation.origin,
        domain: EditorialRelationDomain.worldCreation,
        targetId: lesson.id,
        title: lesson.title,
        subtitle: lesson.summary,
        routeName: 'worldCreationLessonDetail',
        pathParameters: {'lessonId': lesson.id},
        editorialLabel: relation.editorialLabel,
        editorialNote: relation.editorialNote,
      );
    case EditorialRelationDomain.learnContent:
      final item = _learnItemById(ref, counterpart.id);
      if (item == null) return null;
      return EditorialResolvedRelationLink(
        relationId: relation.id,
        relationType: relation.type,
        origin: relation.origin,
        domain: EditorialRelationDomain.learnContent,
        targetId: item.id,
        title: item.title,
        subtitle: item.subtitle,
        routeName: item.routeTarget.routeName,
        pathParameters: item.routeTarget.pathParameters,
        queryParameters: item.routeTarget.queryParameters,
        editorialLabel: relation.editorialLabel,
        editorialNote: relation.editorialNote,
      );
  }
}

EditorialResolvedRelationLink _resolvedLinkForQuranReference(
  EditorialRelationEntry relation,
  QuranReference reference,
) {
  final queryParameters = <String, String>{
    'ayah': reference.ayahStart.toString(),
  };
  if (reference.ayahEnd > reference.ayahStart) {
    queryParameters['endAyah'] = reference.ayahEnd.toString();
  }
  return EditorialResolvedRelationLink(
    relationId: relation.id,
    relationType: relation.type,
    origin: relation.origin,
    domain: EditorialRelationDomain.quran,
    targetId: reference.id,
    title: reference.referenceLabel,
    subtitle: reference.surahName,
    routeName: 'quranReader',
    pathParameters: {'surahNumber': reference.surahNumber.toString()},
    queryParameters: queryParameters,
    referenceId: reference.id,
    editorialLabel: relation.editorialLabel,
    editorialNote: relation.editorialNote,
  );
}

List<EditorialRelationEntry> _buildQuranHadithRelations(
  QuranReferenceGraph graph,
) {
  final results = <EditorialRelationEntry>[];
  for (final reference in graph.references) {
    for (final hadithId in reference.relatedHadithIds) {
      results.add(
        EditorialRelationEntry(
          source: EditorialRelationContentRef.quran(reference.id),
          target: EditorialRelationContentRef.hadith(hadithId),
          type: EditorialRelationType.reinforces,
          origin: EditorialRelationOrigin.quranGraph,
          editorialLabel: reference.referenceLabel,
          editorialNote:
              'This Qur’an reference and hadith are already linked in the canonical Qur’an knowledge graph.',
          editorialConfidence: 1,
        ),
      );
    }
  }
  return results;
}

List<EditorialRelationEntry> _buildQuranDuaRelations(
  QuranReferenceGraph graph,
  DuaDataset dataset,
) {
  final referenceIdsByLabel = <String, String>{
    for (final reference in graph.references)
      reference.referenceLabel: reference.id,
  };
  final results = <EditorialRelationEntry>[];
  for (final item in dataset.items) {
    if (!item.isQuran || !item.isDefaultSurfaceEligible) continue;
    final verseRef = _extractPrimaryQuranReferenceLabel(item.sourceRef);
    if (verseRef == null) continue;
    final referenceId = referenceIdsByLabel[verseRef];
    if (referenceId == null) continue;
    results.add(
      EditorialRelationEntry(
        source: EditorialRelationContentRef.quran(referenceId),
        target: EditorialRelationContentRef.dua(item.id),
        type: EditorialRelationType.relatedDua,
        origin: EditorialRelationOrigin.duaSourceAnchor,
        editorialLabel: verseRef,
        editorialNote:
            'This dua is directly anchored to the same Qur’anic reference in the canonical dua dataset.',
        editorialConfidence: 1,
      ),
    );
  }
  return results;
}

List<EditorialRelationEntry> _buildQuranWorldRelations(
  QuranReferenceGraph graph,
) {
  final referenceIdsByLabel = <String, String>{
    for (final reference in graph.references)
      reference.referenceLabel: reference.id,
  };
  final results = <EditorialRelationEntry>[];
  for (final lesson in worldCreationLessons) {
    for (final verse in lesson.quranVerses) {
      final referenceLabel = verse.referenceLabel;
      final referenceId = referenceIdsByLabel[referenceLabel];
      if (referenceId == null) continue;
      results.add(
        EditorialRelationEntry(
          source: EditorialRelationContentRef.quran(referenceId),
          target: EditorialRelationContentRef.worldCreation(lesson.id),
          type: EditorialRelationType.relatedCreationSign,
          origin: EditorialRelationOrigin.worldVerseAnchor,
          editorialLabel: referenceLabel,
          editorialNote:
              'This world lesson already teaches from the same Qur’anic verse in the canonical world content dataset.',
          editorialConfidence: 1,
        ),
      );
    }
  }
  return results;
}

Future<DuaItem?> _duaItemById(Ref ref, String duaId) async {
  final dataset = await ref.watch(duaDatasetProvider.future);
  for (final item in dataset.items) {
    if (item.id == duaId) return item;
  }
  return null;
}

LearnHubKnowledgeItem? _learnItemById(Ref ref, String itemId) {
  final items = ref.watch(learnHubKnowledgeIndexProvider);
  for (final item in items) {
    if (item.id == itemId) return item;
  }
  return null;
}

String? _extractPrimaryQuranReferenceLabel(String raw) {
  final match = RegExp(r'(\d+:\d+(?:-\d+)?)').firstMatch(raw);
  return match?.group(1);
}
