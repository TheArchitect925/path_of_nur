import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quran_theme_registry_data.dart';
import '../domain/quran_surah_summary_models.dart';
import '../domain/quran_theme_discovery_models.dart';
import 'quran_surah_summary_provider.dart';

final quranThemeRegistryProvider = Provider<List<QuranThemeDefinition>>((ref) {
  final themes = [...quranThemeRegistry]
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return themes;
});

final quranFeaturedThemesProvider = Provider<List<QuranThemeDefinition>>((ref) {
  return ref
      .watch(quranThemeRegistryProvider)
      .where((theme) => theme.featured)
      .toList(growable: false);
});

final quranThemesByCategoryProvider =
    Provider<Map<QuranThemeCategory, List<QuranThemeDefinition>>>((ref) {
      final grouped = <QuranThemeCategory, List<QuranThemeDefinition>>{};
      for (final theme in ref.watch(quranThemeRegistryProvider)) {
        grouped.putIfAbsent(theme.category, () => <QuranThemeDefinition>[]).add(
          theme,
        );
      }
      return grouped;
    });

final quranThemeByIdProvider =
    Provider.family<QuranThemeDefinition?, String>((ref, themeId) {
      for (final theme in ref.watch(quranThemeRegistryProvider)) {
        if (theme.id == themeId) return theme;
      }
      return null;
    });

final quranResolvedThemesProvider = Provider<List<QuranThemeResolvedTopic>>((ref) {
  final themes = ref.watch(quranThemeRegistryProvider);
  final surahs = ref.watch(quranSurahSummaryListProvider);
  return themes
      .map((theme) => _resolveTheme(theme: theme, surahs: surahs, allThemes: themes))
      .where((theme) => theme.relatedSurahs.isNotEmpty)
      .toList(growable: false);
});

final quranResolvedThemeByIdProvider =
    Provider.family<QuranThemeResolvedTopic?, String>((ref, themeId) {
      for (final theme in ref.watch(quranResolvedThemesProvider)) {
        if (theme.definition.id == themeId) return theme;
      }
      return null;
    });

QuranThemeResolvedTopic _resolveTheme({
  required QuranThemeDefinition theme,
  required List<QuranSurahSummaryEntry> surahs,
  required List<QuranThemeDefinition> allThemes,
}) {
  final matchedSurahs = surahs
      .where((entry) => _matchesTheme(theme, entry))
      .toList(growable: false)
    ..sort((a, b) => a.surahNumber.compareTo(b.surahNumber));

  final notableAyatByKey = <String, QuranSurahNotableAyah>{};
  final prophetById = <String, QuranSurahNamedReference>{};
  final eventById = <String, QuranSurahNamedReference>{};

  for (final surah in matchedSurahs) {
    for (final ayah in surah.notableAyat) {
      final key = '${ayah.surahNumber}:${ayah.ayahNumber}-${ayah.endAyahNumber ?? ayah.ayahNumber}';
      notableAyatByKey.putIfAbsent(key, () => ayah);
    }
    for (final prophet in surah.relatedProphets) {
      prophetById.putIfAbsent(prophet.id, () => prophet);
    }
    for (final event in surah.relatedEvents) {
      eventById.putIfAbsent(event.id, () => event);
    }
  }

  final relatedThemes = allThemes
      .where((candidate) => candidate.id != theme.id)
      .where((candidate) => _sharesSignal(theme, candidate))
      .toList(growable: false)
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  return QuranThemeResolvedTopic(
    definition: theme,
    relatedSurahs: matchedSurahs,
    notableAyat: notableAyatByKey.values.take(8).toList(growable: false),
    relatedProphets: prophetById.values.toList(growable: false),
    relatedEvents: eventById.values.toList(growable: false),
    relatedThemes: relatedThemes.take(4).toList(growable: false),
  );
}

bool _matchesTheme(QuranThemeDefinition theme, QuranSurahSummaryEntry entry) {
  final entryThemeTags = entry.themeTags.toSet();
  final entryProphetIds = entry.relatedProphets.map((item) => item.id).toSet();
  final entryEventIds = entry.relatedEvents.map((item) => item.id).toSet();

  if (theme.linkedThemeTags.any(entryThemeTags.contains)) return true;
  if (theme.linkedProphetIds.any(entryProphetIds.contains)) return true;
  if (theme.linkedEventIds.any(entryEventIds.contains)) return true;
  if (theme.linkedSurahNumbers.contains(entry.surahNumber)) return true;
  return false;
}

bool _sharesSignal(QuranThemeDefinition left, QuranThemeDefinition right) {
  if (left.category == right.category) return true;
  if (left.linkedThemeTags.any(right.linkedThemeTags.contains)) return true;
  if (left.linkedProphetIds.any(right.linkedProphetIds.contains)) return true;
  if (left.linkedEventIds.any(right.linkedEventIds.contains)) return true;
  return false;
}
