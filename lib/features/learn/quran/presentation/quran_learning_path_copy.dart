import '../../../../l10n/app_localizations.dart';
import '../domain/quran_guided_learning_path_models.dart';

String localizedQuranLearningPathTitle(AppLocalizations l10n, String pathId) {
  switch (pathId) {
    case 'beginner-understanding':
      return l10n.quranLearningPathBeginnerTitle;
    case 'theme-study-gratitude':
      return l10n.quranLearningPathThemeTitle;
    case 'memorization-support':
      return l10n.quranLearningPathMemorizationTitle;
    case 'reflection-journey':
      return l10n.quranLearningPathReflectionTitle;
    case 'surah-study-starter':
      return l10n.quranLearningPathSurahStudyTitle;
    default:
      return l10n.quranLearningPathsTitle;
  }
}

String localizedQuranLearningPathSubtitle(
  AppLocalizations l10n,
  String pathId,
) {
  switch (pathId) {
    case 'beginner-understanding':
      return l10n.quranLearningPathBeginnerSubtitle;
    case 'theme-study-gratitude':
      return l10n.quranLearningPathThemeSubtitle;
    case 'memorization-support':
      return l10n.quranLearningPathMemorizationSubtitle;
    case 'reflection-journey':
      return l10n.quranLearningPathReflectionSubtitle;
    case 'surah-study-starter':
      return l10n.quranLearningPathSurahStudySubtitle;
    default:
      return l10n.quranLearningPathsSubtitle;
  }
}

String localizedQuranLearningPathDescription(
  AppLocalizations l10n,
  String pathId,
) {
  switch (pathId) {
    case 'beginner-understanding':
      return l10n.quranLearningPathBeginnerDescription;
    case 'theme-study-gratitude':
      return l10n.quranLearningPathThemeDescription;
    case 'memorization-support':
      return l10n.quranLearningPathMemorizationDescription;
    case 'reflection-journey':
      return l10n.quranLearningPathReflectionDescription;
    case 'surah-study-starter':
      return l10n.quranLearningPathSurahStudyDescription;
    default:
      return l10n.quranLearningPathsSubtitle;
  }
}

String localizedQuranLearningPathStepTitle(
  AppLocalizations l10n,
  String stepId,
) {
  switch (stepId) {
    case 'beginner-open-fatihah':
      return l10n.quranLearningPathStepBeginnerReadTitle;
    case 'beginner-reflect-on-fatihah':
      return l10n.quranLearningPathStepBeginnerReflectTitle;
    case 'beginner-follow-foundations':
      return l10n.quranLearningPathStepBeginnerGuidedTitle;
    case 'theme-open-gratitude-map':
      return l10n.quranLearningPathStepThemeMapTitle;
    case 'theme-read-ar-rahman':
      return l10n.quranLearningPathStepThemeReadTitle;
    case 'theme-open-character-gratitude':
      return l10n.quranLearningPathStepThemeCharacterTitle;
    case 'memorization-open-review':
      return l10n.quranLearningPathStepMemorizationReviewTitle;
    case 'memorization-study-anchor-ayah':
      return l10n.quranLearningPathStepMemorizationStudyTitle;
    case 'memorization-open-patience-theme':
      return l10n.quranLearningPathStepMemorizationThemeTitle;
    case 'reflection-open-ayah':
      return l10n.quranLearningPathStepReflectionReadTitle;
    case 'reflection-open-saved-reflections':
      return l10n.quranLearningPathStepReflectionReviewTitle;
    case 'reflection-open-daily-wisdom':
      return l10n.quranLearningPathStepReflectionWisdomTitle;
    case 'surah-open-insight':
      return l10n.quranLearningPathStepSurahInsightsTitle;
    case 'surah-open-reader-study':
      return l10n.quranLearningPathStepSurahReaderTitle;
    case 'surah-open-family-character':
      return l10n.quranLearningPathStepSurahCharacterTitle;
    default:
      return l10n.quranLearningPathsOpenStepAction;
  }
}

String localizedQuranLearningPathStepSubtitle(
  AppLocalizations l10n,
  String stepId,
) {
  switch (stepId) {
    case 'beginner-open-fatihah':
      return l10n.quranLearningPathStepBeginnerReadSubtitle;
    case 'beginner-reflect-on-fatihah':
      return l10n.quranLearningPathStepBeginnerReflectSubtitle;
    case 'beginner-follow-foundations':
      return l10n.quranLearningPathStepBeginnerGuidedSubtitle;
    case 'theme-open-gratitude-map':
      return l10n.quranLearningPathStepThemeMapSubtitle;
    case 'theme-read-ar-rahman':
      return l10n.quranLearningPathStepThemeReadSubtitle;
    case 'theme-open-character-gratitude':
      return l10n.quranLearningPathStepThemeCharacterSubtitle;
    case 'memorization-open-review':
      return l10n.quranLearningPathStepMemorizationReviewSubtitle;
    case 'memorization-study-anchor-ayah':
      return l10n.quranLearningPathStepMemorizationStudySubtitle;
    case 'memorization-open-patience-theme':
      return l10n.quranLearningPathStepMemorizationThemeSubtitle;
    case 'reflection-open-ayah':
      return l10n.quranLearningPathStepReflectionReadSubtitle;
    case 'reflection-open-saved-reflections':
      return l10n.quranLearningPathStepReflectionReviewSubtitle;
    case 'reflection-open-daily-wisdom':
      return l10n.quranLearningPathStepReflectionWisdomSubtitle;
    case 'surah-open-insight':
      return l10n.quranLearningPathStepSurahInsightsSubtitle;
    case 'surah-open-reader-study':
      return l10n.quranLearningPathStepSurahReaderSubtitle;
    case 'surah-open-family-character':
      return l10n.quranLearningPathStepSurahCharacterSubtitle;
    default:
      return '';
  }
}

String localizedQuranLearningPathTypeLabel(
  AppLocalizations l10n,
  QuranGuidedLearningPathType type,
) {
  return switch (type) {
    QuranGuidedLearningPathType.beginnerUnderstanding =>
      l10n.quranLearningPathTypeBeginner,
    QuranGuidedLearningPathType.themeStudy => l10n.quranLearningPathTypeTheme,
    QuranGuidedLearningPathType.memorizationSupport =>
      l10n.quranLearningPathTypeMemorization,
    QuranGuidedLearningPathType.reflectionJourney =>
      l10n.quranLearningPathTypeReflection,
    QuranGuidedLearningPathType.surahStudy => l10n.quranLearningPathTypeSurah,
  };
}

String localizedQuranLearningPathIntensityLabel(
  AppLocalizations l10n,
  QuranGuidedLearningPathIntensity intensity,
) {
  return switch (intensity) {
    QuranGuidedLearningPathIntensity.gentle =>
      l10n.quranLearningPathIntensityGentle,
    QuranGuidedLearningPathIntensity.guided =>
      l10n.quranLearningPathIntensityGuided,
    QuranGuidedLearningPathIntensity.deeper =>
      l10n.quranLearningPathIntensityDeeper,
  };
}
