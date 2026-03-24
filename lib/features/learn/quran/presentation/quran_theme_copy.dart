import '../../../../l10n/app_localizations.dart';
import '../domain/quran_reference_models.dart';
import 'quran_learning_path_copy.dart';

String localizedQuranTopicTitle(AppLocalizations l10n, String topicId) {
  switch (topicId) {
    case 'patience':
      return l10n.quranThemePatienceTitle;
    case 'gratitude':
      return l10n.quranThemeGratitudeTitle;
    case 'mercy':
      return l10n.quranThemeMercyTitle;
    case 'family':
      return l10n.quranThemeFamilyTitle;
    case 'akhirah':
      return l10n.quranThemeAkhirahTitle;
    case 'signs-in-creation':
      return l10n.quranThemeSignsInCreationTitle;
    case 'prophets':
      return l10n.quranThemeProphetsTitle;
    case 'trust-in-allah':
      return l10n.quranThemeTrustInAllahTitle;
    case 'repentance':
      return l10n.quranThemeRepentanceTitle;
    case 'remembrance':
      return l10n.quranThemeRemembranceTitle;
    case 'sincerity':
      return l10n.quranThemeSincerityTitle;
    case 'prayer':
      return l10n.quranThemePrayerTitle;
    case 'charity':
      return l10n.quranThemeCharityTitle;
    case 'justice':
      return l10n.quranThemeJusticeTitle;
    case 'humility':
      return l10n.quranThemeHumilityTitle;
    default:
      return l10n.quranTopicsTitle;
  }
}

String localizedQuranTopicDescription(AppLocalizations l10n, String topicId) {
  switch (topicId) {
    case 'patience':
      return l10n.quranThemePatienceDescription;
    case 'gratitude':
      return l10n.quranThemeGratitudeDescription;
    case 'mercy':
      return l10n.quranThemeMercyDescription;
    case 'family':
      return l10n.quranThemeFamilyDescription;
    case 'akhirah':
      return l10n.quranThemeAkhirahDescription;
    case 'signs-in-creation':
      return l10n.quranThemeSignsInCreationDescription;
    case 'prophets':
      return l10n.quranThemeProphetsDescription;
    case 'trust-in-allah':
      return l10n.quranThemeTrustInAllahDescription;
    case 'repentance':
      return l10n.quranThemeRepentanceDescription;
    case 'remembrance':
      return l10n.quranThemeRemembranceDescription;
    case 'sincerity':
      return l10n.quranThemeSincerityDescription;
    case 'prayer':
      return l10n.quranThemePrayerDescription;
    case 'charity':
      return l10n.quranThemeCharityDescription;
    case 'justice':
      return l10n.quranThemeJusticeDescription;
    case 'humility':
      return l10n.quranThemeHumilityDescription;
    default:
      return l10n.quranHubTopicsSubtitle;
  }
}

String localizedQuranTopicRouteTitle(
  AppLocalizations l10n,
  QuranTopicRouteTarget route,
) {
  switch (route.kind) {
    case QuranTopicRouteKind.characterCompanion:
      return l10n.learnHubCategoryCharacterAdabTitle;
    case QuranTopicRouteKind.seerahCompanion:
      return l10n.historyCategorySeerah;
    case QuranTopicRouteKind.dailyWisdomCompanion:
      return l10n.learnDailyWisdomTodayTitle;
    case QuranTopicRouteKind.dailyCompanion:
      return l10n.quranDailyCompanionTitle;
    case QuranTopicRouteKind.hadith:
      return l10n.learnCategoryHadithTitle;
    case QuranTopicRouteKind.life:
      return l10n.learnCategoryDivineLifeLessonsTitle;
    case QuranTopicRouteKind.world:
      return l10n.learnCategoryWorldCreationTitle;
    case QuranTopicRouteKind.prophets:
      return l10n.learnHubCategoryProphetsStoriesTitle;
    case QuranTopicRouteKind.guidedPath:
      final pathId = route.pathParameters['pathId'];
      return pathId == null
          ? l10n.quranLearningPathsTitle
          : localizedQuranLearningPathTitle(l10n, pathId);
    case QuranTopicRouteKind.memorizationReview:
      return l10n.quranMemorizationReviewTitle;
    case QuranTopicRouteKind.quranTheme:
      return localizedQuranTopicTitle(
        l10n,
        route.pathParameters['topicId'] ?? '',
      );
    case QuranTopicRouteKind.ayahInsightsDomain:
      return route.pathParameters['domainId'] == 'signs-in-creation'
          ? l10n.quranAyahInsightsDomainSignsInCreation
          : route.pathParameters['domainId'] == 'worship-remembrance'
          ? l10n.quranAyahInsightsDomainWorshipRemembrance
          : route.pathParameters['domainId'] == 'character-adab'
          ? l10n.quranAyahInsightsDomainCharacterAdab
          : route.pathParameters['domainId'] == 'akhirah-accountability'
          ? l10n.quranAyahInsightsDomainAkhirahAccountability
          : route.pathParameters['domainId'] == 'prophets-lessons'
          ? l10n.quranAyahInsightsDomainProphetsLessons
          : l10n.quranAyahInsightsDomainGuidanceDailyLife;
    case QuranTopicRouteKind.ayahInsightPath:
      return l10n.quranAyahInsightPathsTitle;
    case QuranTopicRouteKind.surahInsights:
      return l10n.quranSurahInsightsBrowseTitle;
  }
}

String localizedQuranTopicRouteSubtitle(
  AppLocalizations l10n,
  QuranTopicRouteTarget route,
) {
  switch (route.kind) {
    case QuranTopicRouteKind.characterCompanion:
      return l10n.learnHubSubcategoryCharacterAdabSubtitle;
    case QuranTopicRouteKind.seerahCompanion:
      return l10n.learnSeerahCompanionExploreSubtitle;
    case QuranTopicRouteKind.dailyWisdomCompanion:
      return l10n.learnDailyWisdomTodaySubtitle;
    case QuranTopicRouteKind.dailyCompanion:
      return l10n.quranDailyCompanionSubtitle;
    case QuranTopicRouteKind.hadith:
      return l10n.learnHubSubcategoryHadithSubtitle;
    case QuranTopicRouteKind.life:
      return l10n.learnLifeSectionSubtitle;
    case QuranTopicRouteKind.world:
      return l10n.learnHubSubcategoryWorldCreationSubtitle;
    case QuranTopicRouteKind.prophets:
      return l10n.learnHubSubcategoryProphetsSubtitle;
    case QuranTopicRouteKind.guidedPath:
      final pathId = route.pathParameters['pathId'];
      return pathId == null
          ? l10n.quranLearningPathsSubtitle
          : localizedQuranLearningPathSubtitle(l10n, pathId);
    case QuranTopicRouteKind.memorizationReview:
      return l10n.quranMemorizationReviewSubtitle;
    case QuranTopicRouteKind.quranTheme:
      return localizedQuranTopicDescription(
        l10n,
        route.pathParameters['topicId'] ?? '',
      );
    case QuranTopicRouteKind.ayahInsightsDomain:
      return l10n.quranHubStudySubtitle;
    case QuranTopicRouteKind.ayahInsightPath:
      return l10n.quranAyahInsightPathsSubtitle;
    case QuranTopicRouteKind.surahInsights:
      return l10n.quranSurahInsightsBrowseSubtitle;
  }
}

String localizedQuranTopicWhyItMatters(AppLocalizations l10n, String topicId) {
  switch (topicId) {
    case 'patience':
      return l10n.quranThemePatienceWhyItMatters;
    case 'gratitude':
      return l10n.quranThemeGratitudeWhyItMatters;
    case 'mercy':
      return l10n.quranThemeMercyWhyItMatters;
    case 'family':
      return l10n.quranThemeFamilyWhyItMatters;
    case 'trust-in-allah':
      return l10n.quranThemeTrustInAllahWhyItMatters;
    case 'repentance':
      return l10n.quranThemeRepentanceWhyItMatters;
    case 'remembrance':
      return l10n.quranThemeRemembranceWhyItMatters;
    case 'sincerity':
      return l10n.quranThemeSincerityWhyItMatters;
    default:
      return l10n.quranThemeMapBrowseSubtitle;
  }
}

String localizedQuranTopicStudyFocus(AppLocalizations l10n, String topicId) {
  switch (topicId) {
    case 'patience':
      return l10n.quranThemePatienceStudyFocus;
    case 'gratitude':
      return l10n.quranThemeGratitudeStudyFocus;
    case 'mercy':
      return l10n.quranThemeMercyStudyFocus;
    case 'family':
      return l10n.quranThemeFamilyStudyFocus;
    case 'trust-in-allah':
      return l10n.quranThemeTrustInAllahStudyFocus;
    case 'repentance':
      return l10n.quranThemeRepentanceStudyFocus;
    case 'remembrance':
      return l10n.quranThemeRemembranceStudyFocus;
    case 'sincerity':
      return l10n.quranThemeSincerityStudyFocus;
    default:
      return l10n.quranHubTopicsSubtitle;
  }
}

String localizedQuranTopicModeLabel(
  AppLocalizations l10n,
  QuranReaderStudyMode mode,
) {
  return switch (mode) {
    QuranReaderStudyMode.reading => l10n.quranReaderModeReadingLabel,
    QuranReaderStudyMode.reflection => l10n.quranReaderModeReflectionLabel,
    QuranReaderStudyMode.study => l10n.quranReaderModeStudyLabel,
    QuranReaderStudyMode.memorization => l10n.quranReaderModeMemorizationLabel,
    QuranReaderStudyMode.theme => l10n.quranReaderModeThemeLabel,
  };
}
