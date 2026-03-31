import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quran_surah_enrichment_seed_data.dart';
import '../data/quran_surah_summary_seed_data.dart';
import '../domain/quran_surah_summary_models.dart';
import 'quran_providers.dart';

class QuranSurahSummaryResumeState {
  const QuranSurahSummaryResumeState({
    required this.surahNumber,
    required this.ayahNumber,
    required this.isPrimaryProgress,
  });

  final int surahNumber;
  final int ayahNumber;
  final bool isPrimaryProgress;
}

final quranSurahSummaryListProvider = Provider<List<QuranSurahSummaryEntry>>((
  ref,
) {
  final surahs = ref.watch(quranSurahListProvider);
  final seedBySurah = <int, QuranSurahSummarySeed>{
    for (final seed in seededQuranSurahSummaries) seed.surahNumber: seed,
  };
  final enrichmentBySurah = <int, QuranSurahEnrichmentSeed>{
    for (final seed in seededQuranSurahEnrichments) seed.surahNumber: seed,
  };

  if (seedBySurah.length != surahs.length) {
    throw StateError(
      'Expected ${surahs.length} surah summaries but found ${seedBySurah.length}.',
    );
  }

  return surahs.map((surah) {
    final seed = seedBySurah[surah.number];
    if (seed == null) {
      throw StateError('Missing surah summary seed for ${surah.number}.');
    }
    final enrichment = enrichmentBySurah[surah.number];
    final themeTags = _mergeThemeTags(
      inferred: _inferThemeTags(seed.summary, seed.keywords),
      seeded: enrichment?.themeTags ?? const <QuranSurahThemeTag>[],
    );
    return QuranSurahSummaryEntry(
      surah: surah,
      meaning: surah.englishName,
      revelationType:
          seed.revelationTypeOverride ??
          (surah.revelationClassification == 'Madani'
              ? QuranSurahSummaryRevelationType.madani
              : QuranSurahSummaryRevelationType.makki),
      summary: seed.summary,
      keywords: seed.keywords,
      themeTags: themeTags,
      notableAyat: enrichment?.notableAyat ?? const <QuranSurahNotableAyah>[],
      relatedProphets:
          enrichment?.relatedProphets ?? const <QuranSurahNamedReference>[],
      relatedEvents:
          enrichment?.relatedEvents ?? const <QuranSurahNamedReference>[],
      virtues: enrichment?.virtues ?? const <QuranSurahVirtueNote>[],
      reflections:
          enrichment?.reflections ?? const <QuranSurahReflectionPrompt>[],
      searchAliases: _buildSearchAliases(
        keywords: seed.keywords,
        themeTags: themeTags,
        prophets: enrichment?.relatedProphets ?? const [],
        events: enrichment?.relatedEvents ?? const [],
        explicitAliases: enrichment?.searchAliases ?? const [],
      ),
      detailIntro: enrichment?.detailIntro,
      editorialNotes: enrichment?.editorialNotes ?? const <String>[],
      summaryEvidenceLevel:
          enrichment?.summaryEvidenceLevel ??
          QuranSurahContentEvidenceLevel.editorialSynthesis,
      sortIndex: surah.number,
    );
  }).toList(growable: false);
});

final quranSurahSummaryEntryProvider =
    Provider.family<QuranSurahSummaryEntry?, int>((ref, surahNumber) {
      for (final entry in ref.watch(quranSurahSummaryListProvider)) {
        if (entry.surahNumber == surahNumber) {
          return entry;
        }
      }
      return null;
    });

List<QuranSurahThemeTag> _mergeThemeTags({
  required List<QuranSurahThemeTag> inferred,
  required List<QuranSurahThemeTag> seeded,
}) {
  final merged = <QuranSurahThemeTag>{
    ...inferred,
    ...seeded,
  }.toList(growable: false)
    ..sort((a, b) => a.index.compareTo(b.index));
  return merged;
}

List<String> _buildSearchAliases({
  required List<String> keywords,
  required List<QuranSurahThemeTag> themeTags,
  required List<QuranSurahNamedReference> prophets,
  required List<QuranSurahNamedReference> events,
  required List<String> explicitAliases,
}) {
  return <String>{
    ...keywords,
    ...explicitAliases,
    ...themeTags.expand((tag) => tag.searchAliases),
    ...prophets.map((item) => item.label),
    ...events.map((item) => item.label),
  }.toList(growable: false);
}

List<QuranSurahThemeTag> _inferThemeTags(String summary, List<String> keywords) {
  final normalized = '${summary.toLowerCase()} ${keywords.join(' ').toLowerCase()}';
  final tags = <QuranSurahThemeTag>{};

  void addIf(bool condition, QuranSurahThemeTag tag) {
    if (condition) tags.add(tag);
  }

  addIf(
    normalized.contains('tawhid') ||
        normalized.contains('shirk') ||
        normalized.contains('worship allah alone'),
    QuranSurahThemeTag.tawhid,
  );
  addIf(
    normalized.contains('revelation') ||
        normalized.contains('qur’an') ||
        normalized.contains('quran'),
    QuranSurahThemeTag.revelation,
  );
  addIf(normalized.contains('guidance'), QuranSurahThemeTag.guidance);
  addIf(normalized.contains('mercy'), QuranSurahThemeTag.mercy);
  addIf(
    normalized.contains('judgment') ||
        normalized.contains('accountability') ||
        normalized.contains('judge'),
    QuranSurahThemeTag.judgment,
  );
  addIf(
    normalized.contains('patience') ||
        normalized.contains('steadfast') ||
        normalized.contains('endurance'),
    QuranSurahThemeTag.patience,
  );
  addIf(normalized.contains('repent'), QuranSurahThemeTag.repentance);
  addIf(
    normalized.contains('prophet') ||
        normalized.contains('musa') ||
        normalized.contains('yusuf') ||
        normalized.contains('ibrahim') ||
        normalized.contains('isa') ||
        normalized.contains('maryam'),
    QuranSurahThemeTag.prophethood,
  );
  addIf(
    normalized.contains('resurrection') ||
        normalized.contains('hereafter') ||
        normalized.contains('day of resurrection'),
    QuranSurahThemeTag.resurrection,
  );
  addIf(
    normalized.contains('worship') ||
        normalized.contains('prayer') ||
        normalized.contains('remembrance'),
    QuranSurahThemeTag.worship,
  );
  addIf(
    normalized.contains('law') ||
        normalized.contains('lawful') ||
        normalized.contains('unlawful') ||
        normalized.contains('boundaries'),
    QuranSurahThemeTag.law,
  );
  addIf(
    normalized.contains('community') ||
        normalized.contains('communal') ||
        normalized.contains('society'),
    QuranSurahThemeTag.community,
  );
  addIf(
    normalized.contains('gratitude') ||
        normalized.contains('thankfulness') ||
        normalized.contains('grateful'),
    QuranSurahThemeTag.gratitude,
  );
  addIf(normalized.contains('justice'), QuranSurahThemeTag.justice);
  addIf(
    normalized.contains('signs in creation') ||
        normalized.contains('creation') ||
        normalized.contains('created world') ||
        normalized.contains('horizons'),
    QuranSurahThemeTag.signsOfCreation,
  );
  addIf(normalized.contains('hypocrisy'), QuranSurahThemeTag.hypocrisy);
  addIf(
    normalized.contains('charity') ||
        normalized.contains('spending') ||
        normalized.contains('give'),
    QuranSurahThemeTag.charity,
  );
  addIf(
    normalized.contains('family') ||
        normalized.contains('parents') ||
        normalized.contains('marriage'),
    QuranSurahThemeTag.family,
  );
  addIf(
    normalized.contains('struggle') ||
        normalized.contains('sacrifice') ||
        normalized.contains('victory'),
    QuranSurahThemeTag.struggle,
  );
  addIf(
    normalized.contains('paradise') || normalized.contains('hell'),
    QuranSurahThemeTag.paradiseAndHell,
  );

  if (tags.isEmpty) {
    tags.add(QuranSurahThemeTag.guidance);
  }

  return tags.toList(growable: false)
    ..sort((a, b) => a.index.compareTo(b.index));
}

final quranSurahSummaryResumeStateProvider =
    Provider.family<QuranSurahSummaryResumeState?, int>((ref, surahNumber) {
      final progress = ref.watch(quranReadingProgressProvider);
      if (progress.surahNumber == surahNumber && progress.ayahNumber > 1) {
        return QuranSurahSummaryResumeState(
          surahNumber: surahNumber,
          ayahNumber: progress.ayahNumber,
          isPrimaryProgress: true,
        );
      }

      final recentReadings = ref.watch(quranRecentReadingsProvider);
      for (final reading in recentReadings) {
        if (reading.surahNumber == surahNumber && reading.ayahNumber > 1) {
          return QuranSurahSummaryResumeState(
            surahNumber: surahNumber,
            ayahNumber: reading.ayahNumber,
            isPrimaryProgress: false,
          );
        }
      }
      return null;
    });
