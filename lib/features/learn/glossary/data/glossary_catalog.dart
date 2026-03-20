import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';
import '../domain/glossary_models.dart';

class GlossaryCatalog {
  static const entries = <GlossaryEntry>[
    GlossaryEntry(id: GlossaryEntryId.salah, category: GlossaryCategory.practice),
    GlossaryEntry(
      id: GlossaryEntryId.ibadah,
      category: GlossaryCategory.practice,
    ),
    GlossaryEntry(id: GlossaryEntryId.dhikr, category: GlossaryCategory.practice),
    GlossaryEntry(id: GlossaryEntryId.masjid, category: GlossaryCategory.places),
    GlossaryEntry(id: GlossaryEntryId.quran, category: GlossaryCategory.sources),
    GlossaryEntry(
      id: GlossaryEntryId.hadith,
      category: GlossaryCategory.sources,
    ),
    GlossaryEntry(
      id: GlossaryEntryId.sunnah,
      category: GlossaryCategory.sources,
    ),
  ];

  static GlossaryEntry? entryById(GlossaryEntryId id) {
    for (final entry in entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  static List<LocalizedGlossaryEntry> localizedEntries(BuildContext context) {
    return entries.map((entry) => localizedEntry(context, entry.id)).toList(
      growable: false,
    );
  }

  static LocalizedGlossaryEntry localizedEntry(
    BuildContext context,
    GlossaryEntryId id,
  ) {
    final l10n = AppLocalizations.of(context);
    final entry = entryById(id)!;
    return LocalizedGlossaryEntry(
      id: entry.id,
      category: entry.category,
      transliteration: entry.transliteration,
      term: localizedTerm(l10n, id),
      shortDefinition: localizedShortDefinition(l10n, id),
      expandedExplanation: localizedExpandedExplanation(l10n, id),
      kidsShortDefinition: localizedKidsShortDefinition(l10n, id),
      kidsExpandedExplanation: localizedKidsExpandedExplanation(l10n, id),
    );
  }

  static LocalizedGlossaryEntry? findLocalizedEntry(
    BuildContext context, {
    GlossaryEntryId? id,
    String? term,
  }) {
    if (id != null) {
      return localizedEntry(context, id);
    }
    final normalizedTerm = _normalizeGlossaryLookup(term);
    if (normalizedTerm == null) return null;
    for (final entry in entries) {
      final localized = localizedEntry(context, entry.id);
      final termMatches =
          _normalizeGlossaryLookup(localized.term) == normalizedTerm;
      final transliterationMatches =
          _normalizeGlossaryLookup(localized.transliteration) == normalizedTerm;
      if (termMatches || transliterationMatches) {
        return localized;
      }
    }
    return null;
  }
}

String? _normalizeGlossaryLookup(String? value) {
  final trimmed = value?.trim().toLowerCase();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed.replaceAll(RegExp(r'[^a-z0-9\u0600-\u06FF]+'), '');
}

String localizedGlossaryCategoryLabel(
  BuildContext context,
  GlossaryCategory? category,
) {
  final l10n = AppLocalizations.of(context);
  return switch (category) {
    null => l10n.learnGlossaryCategoryAll,
    GlossaryCategory.practice => l10n.learnGlossaryCategoryPractice,
    GlossaryCategory.sources => l10n.learnGlossaryCategorySources,
    GlossaryCategory.places => l10n.learnGlossaryCategoryPlaces,
  };
}

String localizedTerm(AppLocalizations l10n, GlossaryEntryId id) {
  return switch (id) {
    GlossaryEntryId.salah => l10n.glossaryEntrySalahTerm,
    GlossaryEntryId.ibadah => l10n.glossaryEntryIbadahTerm,
    GlossaryEntryId.dhikr => l10n.glossaryEntryDhikrTerm,
    GlossaryEntryId.masjid => l10n.glossaryEntryMasjidTerm,
    GlossaryEntryId.quran => l10n.glossaryEntryQuranTerm,
    GlossaryEntryId.hadith => l10n.glossaryEntryHadithTerm,
    GlossaryEntryId.sunnah => l10n.glossaryEntrySunnahTerm,
  };
}

String localizedShortDefinition(AppLocalizations l10n, GlossaryEntryId id) {
  return switch (id) {
    GlossaryEntryId.salah => l10n.glossaryEntrySalahShort,
    GlossaryEntryId.ibadah => l10n.glossaryEntryIbadahShort,
    GlossaryEntryId.dhikr => l10n.glossaryEntryDhikrShort,
    GlossaryEntryId.masjid => l10n.glossaryEntryMasjidShort,
    GlossaryEntryId.quran => l10n.glossaryEntryQuranShort,
    GlossaryEntryId.hadith => l10n.glossaryEntryHadithShort,
    GlossaryEntryId.sunnah => l10n.glossaryEntrySunnahShort,
  };
}

String localizedExpandedExplanation(
  AppLocalizations l10n,
  GlossaryEntryId id,
) {
  return switch (id) {
    GlossaryEntryId.salah => l10n.glossaryEntrySalahExpanded,
    GlossaryEntryId.ibadah => l10n.glossaryEntryIbadahExpanded,
    GlossaryEntryId.dhikr => l10n.glossaryEntryDhikrExpanded,
    GlossaryEntryId.masjid => l10n.glossaryEntryMasjidExpanded,
    GlossaryEntryId.quran => l10n.glossaryEntryQuranExpanded,
    GlossaryEntryId.hadith => l10n.glossaryEntryHadithExpanded,
    GlossaryEntryId.sunnah => l10n.glossaryEntrySunnahExpanded,
  };
}

String localizedKidsShortDefinition(AppLocalizations l10n, GlossaryEntryId id) {
  return switch (id) {
    GlossaryEntryId.salah => l10n.glossaryEntrySalahKidsShort,
    GlossaryEntryId.ibadah => l10n.glossaryEntryIbadahKidsShort,
    GlossaryEntryId.dhikr => l10n.glossaryEntryDhikrKidsShort,
    GlossaryEntryId.masjid => l10n.glossaryEntryMasjidKidsShort,
    GlossaryEntryId.quran => l10n.glossaryEntryQuranKidsShort,
    GlossaryEntryId.hadith => l10n.glossaryEntryHadithKidsShort,
    GlossaryEntryId.sunnah => l10n.glossaryEntrySunnahKidsShort,
  };
}

String localizedKidsExpandedExplanation(
  AppLocalizations l10n,
  GlossaryEntryId id,
) {
  return switch (id) {
    GlossaryEntryId.salah => l10n.glossaryEntrySalahKidsExpanded,
    GlossaryEntryId.ibadah => l10n.glossaryEntryIbadahKidsExpanded,
    GlossaryEntryId.dhikr => l10n.glossaryEntryDhikrKidsExpanded,
    GlossaryEntryId.masjid => l10n.glossaryEntryMasjidKidsExpanded,
    GlossaryEntryId.quran => l10n.glossaryEntryQuranKidsExpanded,
    GlossaryEntryId.hadith => l10n.glossaryEntryHadithKidsExpanded,
    GlossaryEntryId.sunnah => l10n.glossaryEntrySunnahKidsExpanded,
  };
}
