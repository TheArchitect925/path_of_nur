import '../../quran/domain/quran_reference_models.dart';

class LearningJourneyThemeMapping {
  const LearningJourneyThemeMapping({
    required this.journeyId,
    required this.stageId,
    required this.quranTopicIds,
    required this.surahNumber,
    required this.ayahNumber,
    this.endAyahNumber,
    this.suggestedReaderMode = QuranReaderStudyMode.theme,
    this.suggestedLearningPathId,
    this.connectionStrength = QuranConnectionStrength.strong,
    this.enableReverseJourneyLink = true,
  });

  final String journeyId;
  final String stageId;
  final List<String> quranTopicIds;
  final int surahNumber;
  final int ayahNumber;
  final int? endAyahNumber;
  final QuranReaderStudyMode suggestedReaderMode;
  final String? suggestedLearningPathId;
  final QuranConnectionStrength connectionStrength;
  final bool enableReverseJourneyLink;

  String? get primaryTopicId {
    if (quranTopicIds.isEmpty) return null;
    return quranTopicIds.first;
  }

  bool containsVerse(int surahNumber, int ayahNumber) {
    if (surahNumber != this.surahNumber) return false;
    final effectiveEnd = endAyahNumber ?? this.ayahNumber;
    return ayahNumber >= this.ayahNumber && ayahNumber <= effectiveEnd;
  }
}

const List<LearningJourneyThemeMapping> learningJourneyThemeMappings = [
  LearningJourneyThemeMapping(
    journeyId: 'beautiful-character',
    stageId: 'character-sabr',
    quranTopicIds: ['patience'],
    surahNumber: 2,
    ayahNumber: 153,
    suggestedReaderMode: QuranReaderStudyMode.theme,
    suggestedLearningPathId: 'memorization-support',
  ),
  LearningJourneyThemeMapping(
    journeyId: 'beautiful-character',
    stageId: 'character-shukr',
    quranTopicIds: ['gratitude'],
    surahNumber: 14,
    ayahNumber: 7,
    suggestedReaderMode: QuranReaderStudyMode.theme,
    suggestedLearningPathId: 'theme-study-gratitude',
  ),
  LearningJourneyThemeMapping(
    journeyId: 'beautiful-character',
    stageId: 'character-humility',
    quranTopicIds: ['humility'],
    surahNumber: 25,
    ayahNumber: 63,
    suggestedReaderMode: QuranReaderStudyMode.theme,
  ),
  LearningJourneyThemeMapping(
    journeyId: 'daily-dhikr',
    stageId: 'dhikr-what-is',
    quranTopicIds: ['remembrance'],
    surahNumber: 13,
    ayahNumber: 28,
    suggestedReaderMode: QuranReaderStudyMode.theme,
  ),
  LearningJourneyThemeMapping(
    journeyId: 'daily-dhikr',
    stageId: 'dhikr-istighfar',
    quranTopicIds: ['repentance'],
    surahNumber: 11,
    ayahNumber: 3,
    suggestedReaderMode: QuranReaderStudyMode.reflection,
  ),
  LearningJourneyThemeMapping(
    journeyId: 'seerah-journey',
    stageId: 'seerah-hijrah',
    quranTopicIds: ['trust-in-allah'],
    surahNumber: 9,
    ayahNumber: 40,
    suggestedReaderMode: QuranReaderStudyMode.study,
  ),
  LearningJourneyThemeMapping(
    journeyId: 'seerah-journey',
    stageId: 'seerah-leadership-character',
    quranTopicIds: ['mercy', 'trust-in-allah'],
    surahNumber: 3,
    ayahNumber: 159,
    suggestedReaderMode: QuranReaderStudyMode.study,
  ),
];

LearningJourneyThemeMapping? learningJourneyThemeMappingForStage(
  String stageId,
) {
  for (final mapping in learningJourneyThemeMappings) {
    if (mapping.stageId == stageId) return mapping;
  }
  return null;
}

List<LearningJourneyThemeMapping> learningJourneyThemeMappingsForTopic(
  String topicId,
) {
  return learningJourneyThemeMappings
      .where((mapping) => mapping.quranTopicIds.contains(topicId))
      .toList(growable: false);
}

List<LearningJourneyThemeMapping> learningJourneyThemeMappingsForVerse(
  int surahNumber,
  int ayahNumber,
) {
  return learningJourneyThemeMappings
      .where(
        (mapping) =>
            mapping.enableReverseJourneyLink &&
            mapping.containsVerse(surahNumber, ayahNumber),
      )
      .toList(growable: false);
}
