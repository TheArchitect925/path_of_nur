import '../../../../l10n/app_localizations.dart';
import '../domain/quran_guided_learning_path_models.dart';

String localizedQuranLearningPathTitle(AppLocalizations l10n, String pathId) {
  switch (pathId) {
    case 'patience-in-the-quran':
      return l10n.quranPathwayPatienceTitle;
    case 'tawhid-foundations':
      return l10n.quranPathwayTawhidTitle;
    case 'mercy-and-hope':
      return l10n.quranPathwayMercyTitle;
    case 'stories-of-musa':
      return l10n.quranPathwayMusaTitle;
    case 'signs-of-creation':
      return l10n.quranPathwayCreationTitle;
    case 'reflection-on-the-hereafter':
      return l10n.quranPathwayHereafterTitle;
    case 'gratitude-and-blessings':
      return l10n.quranPathwayGratitudeTitle;
    case 'character-and-adab':
      return l10n.quranPathwayCharacterTitle;
    case 'dua-and-reliance':
      return l10n.quranPathwayDuaTitle;
    case 'verses-for-hard-times':
      return l10n.quranPathwayHardTimesTitle;
    default:
      return l10n.quranLearningPathsTitle;
  }
}

String localizedQuranLearningPathSubtitle(
  AppLocalizations l10n,
  String pathId,
) {
  switch (pathId) {
    case 'patience-in-the-quran':
      return l10n.quranPathwayPatienceSubtitle;
    case 'tawhid-foundations':
      return l10n.quranPathwayTawhidSubtitle;
    case 'mercy-and-hope':
      return l10n.quranPathwayMercySubtitle;
    case 'stories-of-musa':
      return l10n.quranPathwayMusaSubtitle;
    case 'signs-of-creation':
      return l10n.quranPathwayCreationSubtitle;
    case 'reflection-on-the-hereafter':
      return l10n.quranPathwayHereafterSubtitle;
    case 'gratitude-and-blessings':
      return l10n.quranPathwayGratitudeSubtitle;
    case 'character-and-adab':
      return l10n.quranPathwayCharacterSubtitle;
    case 'dua-and-reliance':
      return l10n.quranPathwayDuaSubtitle;
    case 'verses-for-hard-times':
      return l10n.quranPathwayHardTimesSubtitle;
    default:
      return l10n.quranLearningPathsSubtitle;
  }
}

String localizedQuranLearningPathDescription(
  AppLocalizations l10n,
  String pathId,
) {
  switch (pathId) {
    case 'patience-in-the-quran':
      return l10n.quranPathwayPatienceDescription;
    case 'tawhid-foundations':
      return l10n.quranPathwayTawhidDescription;
    case 'mercy-and-hope':
      return l10n.quranPathwayMercyDescription;
    case 'stories-of-musa':
      return l10n.quranPathwayMusaDescription;
    case 'signs-of-creation':
      return l10n.quranPathwayCreationDescription;
    case 'reflection-on-the-hereafter':
      return l10n.quranPathwayHereafterDescription;
    case 'gratitude-and-blessings':
      return l10n.quranPathwayGratitudeDescription;
    case 'character-and-adab':
      return l10n.quranPathwayCharacterDescription;
    case 'dua-and-reliance':
      return l10n.quranPathwayDuaDescription;
    case 'verses-for-hard-times':
      return l10n.quranPathwayHardTimesDescription;
    default:
      return l10n.quranLearningPathsSubtitle;
  }
}

String localizedQuranLearningPathStepTitle(
  AppLocalizations l10n,
  String stepId,
) {
  switch (stepId) {
    case 'patience-theme-overview':
      return l10n.quranPathwayPatienceStepThemeTitle;
    case 'patience-yusuf-summary':
      return l10n.quranPathwayPatienceStepYusufTitle;
    case 'patience-reader-hardship':
      return l10n.quranPathwayPatienceStepReaderTitle;
    case 'patience-guided-reflection':
      return l10n.quranPathwayPatienceStepReflectTitle;
    case 'tawhid-theme-overview':
      return l10n.quranPathwayTawhidStepThemeTitle;
    case 'tawhid-ikhlas-summary':
      return l10n.quranPathwayTawhidStepIkhlasTitle;
    case 'tawhid-reader-kursi':
      return l10n.quranPathwayTawhidStepKursiTitle;
    case 'tawhid-guided-reflection':
      return l10n.quranPathwayTawhidStepReflectTitle;
    case 'mercy-theme-overview':
      return l10n.quranPathwayMercyStepThemeTitle;
    case 'mercy-reader-zumar':
      return l10n.quranPathwayMercyStepZumarTitle;
    case 'mercy-rahman-summary':
      return l10n.quranPathwayMercyStepRahmanTitle;
    case 'mercy-repentance-reflection':
      return l10n.quranPathwayMercyStepRepentanceTitle;
    case 'musa-theme-overview':
      return l10n.quranPathwayMusaStepThemeTitle;
    case 'musa-taha-summary':
      return l10n.quranPathwayMusaStepTahaTitle;
    case 'musa-reader-dua':
      return l10n.quranPathwayMusaStepDuaTitle;
    case 'musa-prophet-anchor':
      return l10n.quranPathwayMusaStepAnchorTitle;
    case 'creation-theme-overview':
      return l10n.quranPathwayCreationStepThemeTitle;
    case 'creation-reader-imran':
      return l10n.quranPathwayCreationStepImranTitle;
    case 'creation-mulk-summary':
      return l10n.quranPathwayCreationStepMulkTitle;
    case 'creation-guided-reflection':
      return l10n.quranPathwayCreationStepReflectTitle;
    case 'hereafter-theme-overview':
      return l10n.quranPathwayHereafterStepThemeTitle;
    case 'hereafter-naba-summary':
      return l10n.quranPathwayHereafterStepNabaTitle;
    case 'hereafter-reader-zalzalah':
      return l10n.quranPathwayHereafterStepZalzalahTitle;
    case 'hereafter-resurrection-reflection':
      return l10n.quranPathwayHereafterStepReflectTitle;
    case 'gratitude-theme-overview':
      return l10n.quranPathwayGratitudeStepThemeTitle;
    case 'gratitude-reader-ibrahim':
      return l10n.quranPathwayGratitudeStepIbrahimTitle;
    case 'gratitude-nahl-summary':
      return l10n.quranPathwayGratitudeStepNahlTitle;
    case 'gratitude-guided-reflection':
      return l10n.quranPathwayGratitudeStepReflectTitle;
    case 'character-hujurat-summary':
      return l10n.quranPathwayCharacterStepHujuratTitle;
    case 'character-reader-hujurat':
      return l10n.quranPathwayCharacterStepReaderTitle;
    case 'character-community-theme':
      return l10n.quranPathwayCharacterStepCommunityTitle;
    case 'character-guided-reflection':
      return l10n.quranPathwayCharacterStepReflectTitle;
    case 'dua-theme-overview':
      return l10n.quranPathwayDuaStepThemeTitle;
    case 'dua-reader-baqarah':
      return l10n.quranPathwayDuaStepBaqarahTitle;
    case 'dua-trust-theme':
      return l10n.quranPathwayDuaStepTrustTitle;
    case 'dua-reader-tawakkul':
      return l10n.quranPathwayDuaStepRelianceTitle;
    case 'hard-times-reader-inshirah':
      return l10n.quranPathwayHardTimesStepInshirahTitle;
    case 'hard-times-reader-baqarah':
      return l10n.quranPathwayHardTimesStepBaqarahTitle;
    case 'hard-times-theme-patience':
      return l10n.quranPathwayHardTimesStepPatienceTitle;
    case 'hard-times-ash-sharh-summary':
      return l10n.quranPathwayHardTimesStepSharhTitle;
    default:
      return l10n.quranLearningPathsOpenStepAction;
  }
}

String localizedQuranLearningPathStepSubtitle(
  AppLocalizations l10n,
  String stepId,
) {
  switch (stepId) {
    case 'patience-theme-overview':
      return l10n.quranPathwayPatienceStepThemeSubtitle;
    case 'patience-yusuf-summary':
      return l10n.quranPathwayPatienceStepYusufSubtitle;
    case 'patience-reader-hardship':
      return l10n.quranPathwayPatienceStepReaderSubtitle;
    case 'patience-guided-reflection':
      return l10n.quranPathwayPatienceStepReflectSubtitle;
    case 'tawhid-theme-overview':
      return l10n.quranPathwayTawhidStepThemeSubtitle;
    case 'tawhid-ikhlas-summary':
      return l10n.quranPathwayTawhidStepIkhlasSubtitle;
    case 'tawhid-reader-kursi':
      return l10n.quranPathwayTawhidStepKursiSubtitle;
    case 'tawhid-guided-reflection':
      return l10n.quranPathwayTawhidStepReflectSubtitle;
    case 'mercy-theme-overview':
      return l10n.quranPathwayMercyStepThemeSubtitle;
    case 'mercy-reader-zumar':
      return l10n.quranPathwayMercyStepZumarSubtitle;
    case 'mercy-rahman-summary':
      return l10n.quranPathwayMercyStepRahmanSubtitle;
    case 'mercy-repentance-reflection':
      return l10n.quranPathwayMercyStepRepentanceSubtitle;
    case 'musa-theme-overview':
      return l10n.quranPathwayMusaStepThemeSubtitle;
    case 'musa-taha-summary':
      return l10n.quranPathwayMusaStepTahaSubtitle;
    case 'musa-reader-dua':
      return l10n.quranPathwayMusaStepDuaSubtitle;
    case 'musa-prophet-anchor':
      return l10n.quranPathwayMusaStepAnchorSubtitle;
    case 'creation-theme-overview':
      return l10n.quranPathwayCreationStepThemeSubtitle;
    case 'creation-reader-imran':
      return l10n.quranPathwayCreationStepImranSubtitle;
    case 'creation-mulk-summary':
      return l10n.quranPathwayCreationStepMulkSubtitle;
    case 'creation-guided-reflection':
      return l10n.quranPathwayCreationStepReflectSubtitle;
    case 'hereafter-theme-overview':
      return l10n.quranPathwayHereafterStepThemeSubtitle;
    case 'hereafter-naba-summary':
      return l10n.quranPathwayHereafterStepNabaSubtitle;
    case 'hereafter-reader-zalzalah':
      return l10n.quranPathwayHereafterStepZalzalahSubtitle;
    case 'hereafter-resurrection-reflection':
      return l10n.quranPathwayHereafterStepReflectSubtitle;
    case 'gratitude-theme-overview':
      return l10n.quranPathwayGratitudeStepThemeSubtitle;
    case 'gratitude-reader-ibrahim':
      return l10n.quranPathwayGratitudeStepIbrahimSubtitle;
    case 'gratitude-nahl-summary':
      return l10n.quranPathwayGratitudeStepNahlSubtitle;
    case 'gratitude-guided-reflection':
      return l10n.quranPathwayGratitudeStepReflectSubtitle;
    case 'character-hujurat-summary':
      return l10n.quranPathwayCharacterStepHujuratSubtitle;
    case 'character-reader-hujurat':
      return l10n.quranPathwayCharacterStepReaderSubtitle;
    case 'character-community-theme':
      return l10n.quranPathwayCharacterStepCommunitySubtitle;
    case 'character-guided-reflection':
      return l10n.quranPathwayCharacterStepReflectSubtitle;
    case 'dua-theme-overview':
      return l10n.quranPathwayDuaStepThemeSubtitle;
    case 'dua-reader-baqarah':
      return l10n.quranPathwayDuaStepBaqarahSubtitle;
    case 'dua-trust-theme':
      return l10n.quranPathwayDuaStepTrustSubtitle;
    case 'dua-reader-tawakkul':
      return l10n.quranPathwayDuaStepRelianceSubtitle;
    case 'hard-times-reader-inshirah':
      return l10n.quranPathwayHardTimesStepInshirahSubtitle;
    case 'hard-times-reader-baqarah':
      return l10n.quranPathwayHardTimesStepBaqarahSubtitle;
    case 'hard-times-theme-patience':
      return l10n.quranPathwayHardTimesStepPatienceSubtitle;
    case 'hard-times-ash-sharh-summary':
      return l10n.quranPathwayHardTimesStepSharhSubtitle;
    default:
      return '';
  }
}

String localizedQuranLearningPathCategoryLabel(
  AppLocalizations l10n,
  QuranGuidedLearningPathCategory category,
) {
  return switch (category) {
    QuranGuidedLearningPathCategory.foundations =>
      l10n.quranPathwayCategoryFoundations,
    QuranGuidedLearningPathCategory.spiritualSupport =>
      l10n.quranPathwayCategorySpiritualSupport,
    QuranGuidedLearningPathCategory.prophetStories =>
      l10n.quranPathwayCategoryProphetStories,
    QuranGuidedLearningPathCategory.reflection =>
      l10n.quranPathwayCategoryReflection,
    QuranGuidedLearningPathCategory.characterAndAdab =>
      l10n.quranPathwayCategoryCharacterAdab,
    QuranGuidedLearningPathCategory.signsAndCreation =>
      l10n.quranPathwayCategorySignsCreation,
    QuranGuidedLearningPathCategory.hereafter =>
      l10n.quranPathwayCategoryHereafter,
  };
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

String localizedQuranLearningPathStatusLabel(
  AppLocalizations l10n,
  bool isStarted,
  bool isCompleted,
) {
  if (isCompleted) return l10n.quranPathwayStatusCompleted;
  if (isStarted) return l10n.quranPathwayStatusInProgress;
  return l10n.quranPathwayStatusNotStarted;
}

String localizedQuranLearningPathStepReflectionPrompt(
  AppLocalizations l10n,
  String stepId,
) {
  switch (stepId) {
    case 'patience-guided-reflection':
      return l10n.quranPathwayPatienceStepReflectPrompt;
    case 'tawhid-guided-reflection':
      return l10n.quranPathwayTawhidStepReflectPrompt;
    case 'mercy-repentance-reflection':
      return l10n.quranPathwayMercyStepRepentancePrompt;
    case 'musa-prophet-anchor':
      return l10n.quranPathwayMusaStepAnchorPrompt;
    case 'creation-guided-reflection':
      return l10n.quranPathwayCreationStepReflectPrompt;
    case 'hereafter-resurrection-reflection':
      return l10n.quranPathwayHereafterStepReflectPrompt;
    case 'gratitude-guided-reflection':
      return l10n.quranPathwayGratitudeStepReflectPrompt;
    case 'character-guided-reflection':
      return l10n.quranPathwayCharacterStepReflectPrompt;
    case 'dua-reader-tawakkul':
      return l10n.quranPathwayDuaStepReliancePrompt;
    case 'hard-times-ash-sharh-summary':
      return l10n.quranPathwayHardTimesStepSharhPrompt;
    default:
      return '';
  }
}
