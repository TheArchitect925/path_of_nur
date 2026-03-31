import 'quran_surah_summary_models.dart';

enum QuranThemeCategory {
  beliefCore,
  worshipSpiritualLife,
  characterInnerLife,
  storiesAndProphets,
  akhirahAccountability,
  societyEthics,
  signsAndReflection,
}

class QuranThemeDefinition {
  const QuranThemeDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.overview,
    required this.category,
    required this.sortOrder,
    this.searchAliases = const <String>[],
    this.featured = false,
    this.reflectionPrompt,
    this.linkedThemeTags = const <QuranSurahThemeTag>[],
    this.linkedProphetIds = const <String>[],
    this.linkedEventIds = const <String>[],
    this.linkedSurahNumbers = const <int>[],
  });

  final String id;
  final String title;
  final String subtitle;
  final String overview;
  final QuranThemeCategory category;
  final int sortOrder;
  final List<String> searchAliases;
  final bool featured;
  final String? reflectionPrompt;
  final List<QuranSurahThemeTag> linkedThemeTags;
  final List<String> linkedProphetIds;
  final List<String> linkedEventIds;
  final List<int> linkedSurahNumbers;
}

class QuranThemeResolvedTopic {
  const QuranThemeResolvedTopic({
    required this.definition,
    required this.relatedSurahs,
    required this.notableAyat,
    required this.relatedProphets,
    required this.relatedEvents,
    required this.relatedThemes,
  });

  final QuranThemeDefinition definition;
  final List<QuranSurahSummaryEntry> relatedSurahs;
  final List<QuranSurahNotableAyah> notableAyat;
  final List<QuranSurahNamedReference> relatedProphets;
  final List<QuranSurahNamedReference> relatedEvents;
  final List<QuranThemeDefinition> relatedThemes;
}
