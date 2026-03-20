enum GlossaryCategory { practice, sources, places }

enum GlossaryEntryId { salah, ibadah, dhikr, masjid, quran, hadith, sunnah }

class GlossaryEntry {
  const GlossaryEntry({
    required this.id,
    required this.category,
    this.transliteration,
  });

  final GlossaryEntryId id;
  final GlossaryCategory category;
  final String? transliteration;
}

class LocalizedGlossaryEntry {
  const LocalizedGlossaryEntry({
    required this.id,
    required this.term,
    required this.shortDefinition,
    required this.expandedExplanation,
    required this.kidsShortDefinition,
    required this.kidsExpandedExplanation,
    required this.category,
    this.transliteration,
  });

  final GlossaryEntryId id;
  final String term;
  final String shortDefinition;
  final String expandedExplanation;
  final String kidsShortDefinition;
  final String kidsExpandedExplanation;
  final GlossaryCategory category;
  final String? transliteration;

  String shortDefinitionFor(bool kidsMode) {
    return kidsMode ? kidsShortDefinition : shortDefinition;
  }

  String expandedExplanationFor(bool kidsMode) {
    return kidsMode ? kidsExpandedExplanation : expandedExplanation;
  }
}

enum GlossaryTriggerMode { tap, longPress, both }
