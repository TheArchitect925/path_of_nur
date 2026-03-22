import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/seeded_quran_surah_insights_data.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_surah.dart';
import '../domain/quran_surah_insight_models.dart';
import 'quran_ayah_enrichment_provider.dart';
import 'quran_providers.dart';

final quranSurahInsightDefinitionsProvider =
    Provider<List<QuranSurahInsightDefinition>>((ref) {
      return seededQuranSurahInsights;
    });

final quranSurahInsightDefinitionProvider =
    Provider.family<QuranSurahInsightDefinition?, int>((ref, surahNumber) {
      final definitions = ref.watch(quranSurahInsightDefinitionsProvider);
      for (final definition in definitions) {
        if (definition.surahNumber == surahNumber) return definition;
      }
      return null;
    });

final quranSurahInsightsBrowseProvider =
    Provider<List<QuranResolvedSurahInsight>>((ref) {
      final definitions = ref.watch(quranSurahInsightDefinitionsProvider);
      final surahMap = ref.watch(quranSurahMapProvider);
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      final paths = ref.watch(quranAyahInsightPathsProvider);

      final output = <QuranResolvedSurahInsight>[];
      for (final definition in definitions) {
        final surah = surahMap[definition.surahNumber];
        if (surah == null) continue;
        final resolved = _resolveInsight(
          definition: definition,
          surah: surah,
          entries: entries,
          paths: paths,
        );
        if (resolved != null) {
          output.add(resolved);
        }
      }
      return output;
    });

final quranSurahInsightProvider =
    Provider.family<QuranResolvedSurahInsight?, int>((ref, surahNumber) {
      final definition = ref.watch(
        quranSurahInsightDefinitionProvider(surahNumber),
      );
      if (definition == null) return null;

      final surah = ref.watch(quranSurahMapProvider)[surahNumber];
      if (surah == null) return null;

      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      final paths = ref.watch(quranAyahInsightPathsProvider);

      return _resolveInsight(
        definition: definition,
        surah: surah,
        entries: entries,
        paths: paths,
      );
    });

QuranResolvedSurahInsight? _resolveInsight({
  required QuranSurahInsightDefinition definition,
  required QuranSurah surah,
  required List<QuranAyahEnrichmentEntry> entries,
  required List<QuranAyahInsightPath> paths,
}) {
  final clusters = <QuranResolvedSurahInsightCluster>[];
  for (final cluster in definition.clusters) {
    final clusterEntries = _resolveClusterEntries(
      domain: cluster.domain,
      refs: cluster.refs,
      entries: entries,
    );
    if (clusterEntries.isEmpty) continue;
    clusters.add(
      QuranResolvedSurahInsightCluster(
        domain: cluster.domain,
        entries: clusterEntries,
      ),
    );
  }

  if (clusters.isEmpty) return null;

  final suggestedPaths = definition.suggestedPathIds
      .map((id) => _findPath(paths, id))
      .whereType<QuranAyahInsightPath>()
      .toList(growable: false);

  return QuranResolvedSurahInsight(
    surah: surah,
    definition: definition,
    clusters: clusters,
    suggestedPaths: suggestedPaths,
  );
}

List<QuranAyahEnrichmentEntry> _resolveClusterEntries({
  required QuranAyahEnrichmentDomain domain,
  required List<QuranQuoteRef> refs,
  required List<QuranAyahEnrichmentEntry> entries,
}) {
  final matched = <QuranAyahEnrichmentEntry>[];
  final seenIds = <String>{};

  for (final ref in refs) {
    final refEnd = ref.ayahEnd ?? ref.ayah;
    for (final entry in entries) {
      if (entry.domain != domain) continue;
      if (entry.ref.surah != ref.surah) continue;
      final entryEnd = entry.ref.ayahEnd ?? entry.ref.ayah;
      final overlaps = entry.ref.ayah <= refEnd && entryEnd >= ref.ayah;
      if (!overlaps) continue;
      if (!seenIds.add(entry.id)) continue;
      matched.add(entry);
    }
  }

  matched.sort((a, b) => a.displayPriority.compareTo(b.displayPriority));
  return matched;
}

QuranAyahInsightPath? _findPath(List<QuranAyahInsightPath> paths, String id) {
  for (final path in paths) {
    if (path.id == id) return path;
  }
  return null;
}
