import 'quran_ayah_enrichment_models.dart';
import 'quran_content_refs.dart';
import 'quran_surah.dart';

class QuranSurahInsightDefinition {
  const QuranSurahInsightDefinition({
    required this.surahNumber,
    required this.descriptionId,
    required this.themeIds,
    required this.lessonIds,
    required this.clusters,
    this.suggestedPathIds = const <String>[],
  });

  final int surahNumber;
  final String descriptionId;
  final List<String> themeIds;
  final List<String> lessonIds;
  final List<QuranSurahInsightClusterDefinition> clusters;
  final List<String> suggestedPathIds;
}

class QuranSurahInsightClusterDefinition {
  const QuranSurahInsightClusterDefinition({
    required this.domain,
    required this.refs,
  });

  final QuranAyahEnrichmentDomain domain;
  final List<QuranQuoteRef> refs;
}

class QuranResolvedSurahInsight {
  const QuranResolvedSurahInsight({
    required this.surah,
    required this.definition,
    required this.clusters,
    required this.suggestedPaths,
  });

  final QuranSurah surah;
  final QuranSurahInsightDefinition definition;
  final List<QuranResolvedSurahInsightCluster> clusters;
  final List<QuranAyahInsightPath> suggestedPaths;
}

class QuranResolvedSurahInsightCluster {
  const QuranResolvedSurahInsightCluster({
    required this.domain,
    required this.entries,
  });

  final QuranAyahEnrichmentDomain domain;
  final List<QuranAyahEnrichmentEntry> entries;
}
