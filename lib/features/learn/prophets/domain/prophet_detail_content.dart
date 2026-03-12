import 'prophet_entry.dart';

class ProphetDetailContent {
  const ProphetDetailContent({
    required this.prophetId,
    required this.name,
    required this.arabicName,
    required this.eraTitle,
    required this.regionLabel,
    required this.shortSummary,
    required this.overview,
    required this.storySections,
    required this.keyLessons,
    required this.quranReferences,
    required this.reflectionPrompts,
    required this.relatedProphetIds,
    required this.relatedLifeLessonIds,
    required this.relatedGrowthHabitIds,
    this.locationLabel,
    this.locationConfidence,
  });

  final String prophetId;
  final String name;
  final String arabicName;
  final String eraTitle;
  final String regionLabel;
  final String shortSummary;
  final String overview;
  final List<ProphetStorySection> storySections;
  final List<ProphetLesson> keyLessons;
  final List<QuranReferenceItem> quranReferences;
  final List<String> reflectionPrompts;
  final List<String> relatedProphetIds;
  final List<String> relatedLifeLessonIds;
  final List<String> relatedGrowthHabitIds;
  final String? locationLabel;
  final ProphetLocationConfidence? locationConfidence;
}

class ProphetStorySection {
  const ProphetStorySection({required this.title, required this.content});

  final String title;
  final String content;
}

class ProphetLesson {
  const ProphetLesson({required this.title, required this.description});

  final String title;
  final String description;
}

class QuranReferenceItem {
  const QuranReferenceItem({
    required this.surahName,
    required this.surahNumber,
    required this.verseRange,
    this.label,
    this.startAyah,
  });

  final String surahName;
  final int surahNumber;
  final String verseRange;
  final String? label;
  final int? startAyah;
}
