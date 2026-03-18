import '../../../l10n/app_localizations.dart';
import '../domain/kids_arabic_models.dart';

String localizedKidsArabicChildLine(AppLocalizations l10n, String letterId) {
  switch (letterId) {
    case 'alif':
      return l10n.kidsArabicLetterAlifChildLine;
    case 'ba':
      return l10n.kidsArabicLetterBaChildLine;
    case 'ta':
      return l10n.kidsArabicLetterTaChildLine;
    case 'tha':
      return l10n.kidsArabicLetterThaChildLine;
    case 'jim':
      return l10n.kidsArabicLetterJimChildLine;
    case 'ha':
      return l10n.kidsArabicLetterHaChildLine;
    case 'kha':
      return l10n.kidsArabicLetterKhaChildLine;
    case 'dal':
      return l10n.kidsArabicLetterDalChildLine;
    case 'dhal':
      return l10n.kidsArabicLetterDhalChildLine;
    case 'ra':
      return l10n.kidsArabicLetterRaChildLine;
    case 'zay':
      return l10n.kidsArabicLetterZayChildLine;
    case 'seen':
      return l10n.kidsArabicLetterSeenChildLine;
    case 'sheen':
      return l10n.kidsArabicLetterSheenChildLine;
    case 'sad':
      return l10n.kidsArabicLetterSadChildLine;
    case 'dad':
      return l10n.kidsArabicLetterDadChildLine;
    case 'taa':
      return l10n.kidsArabicLetterTaaChildLine;
    case 'zaa':
      return l10n.kidsArabicLetterZaaChildLine;
    case 'ain':
      return l10n.kidsArabicLetterAinChildLine;
    case 'ghain':
      return l10n.kidsArabicLetterGhainChildLine;
    case 'fa':
      return l10n.kidsArabicLetterFaChildLine;
    case 'qaf':
      return l10n.kidsArabicLetterQafChildLine;
    case 'kaf':
      return l10n.kidsArabicLetterKafChildLine;
    case 'lam':
      return l10n.kidsArabicLetterLamChildLine;
    case 'meem':
      return l10n.kidsArabicLetterMeemChildLine;
    case 'noon':
      return l10n.kidsArabicLetterNoonChildLine;
    case 'ha2':
      return l10n.kidsArabicLetterHa2ChildLine;
    case 'waw':
      return l10n.kidsArabicLetterWawChildLine;
    case 'ya':
      return l10n.kidsArabicLetterYaChildLine;
    default:
      return '';
  }
}

String localizedKidsArabicTraceResult(
  AppLocalizations l10n,
  KidsArabicTraceResult value,
) {
  switch (value) {
    case KidsArabicTraceResult.completed:
      return l10n.kidsArabicTraceResultCompleted;
    case KidsArabicTraceResult.good:
      return l10n.kidsArabicTraceResultGood;
    case KidsArabicTraceResult.excellent:
      return l10n.kidsArabicTraceResultExcellent;
  }
}

String localizedKidsArabicTraceEncouragement(
  AppLocalizations l10n,
  KidsArabicTraceMetrics metrics,
  KidsArabicTraceResult result,
) {
  if (!metrics.minimumEffortMet) {
    return l10n.kidsArabicTraceEncouragementStart;
  }
  switch (result) {
    case KidsArabicTraceResult.completed:
      return l10n.kidsArabicTraceEncouragementNice;
    case KidsArabicTraceResult.good:
      return l10n.kidsArabicTraceEncouragementGreat;
    case KidsArabicTraceResult.excellent:
      return l10n.kidsArabicTraceEncouragementBeautiful;
  }
}

String localizedKidsArabicStickerTitle(AppLocalizations l10n, String id) {
  switch (id) {
    case 'first-letter':
      return l10n.kidsArabicStickerFirstLetterTitle;
    case 'first-five':
      return l10n.kidsArabicStickerFirstFiveTitle;
    case 'ten-letters':
      return l10n.kidsArabicStickerTenLettersTitle;
    case 'full-alphabet':
      return l10n.kidsArabicStickerFullAlphabetTitle;
    default:
      return id;
  }
}

String localizedKidsArabicStickerSubtitle(AppLocalizations l10n, String id) {
  switch (id) {
    case 'first-letter':
      return l10n.kidsArabicStickerFirstLetterSubtitle;
    case 'first-five':
      return l10n.kidsArabicStickerFirstFiveSubtitle;
    case 'ten-letters':
      return l10n.kidsArabicStickerTenLettersSubtitle;
    case 'full-alphabet':
      return l10n.kidsArabicStickerFullAlphabetSubtitle;
    default:
      return '';
  }
}

String localizedKidsArabicColoringTitle(AppLocalizations l10n, String key) {
  switch (key) {
    case 'kidsArabicColoringPageAlifTitle':
      return l10n.kidsArabicColoringPageAlifTitle;
    case 'kidsArabicColoringPageBaTitle':
      return l10n.kidsArabicColoringPageBaTitle;
    case 'kidsArabicColoringPageMeemTitle':
      return l10n.kidsArabicColoringPageMeemTitle;
    case 'kidsArabicColoringPageNoonTitle':
      return l10n.kidsArabicColoringPageNoonTitle;
    case 'kidsArabicColoringPageSeenTitle':
      return l10n.kidsArabicColoringPageSeenTitle;
    default:
      return key;
  }
}

String localizedKidsArabicDailyMissionTitle(
  AppLocalizations l10n,
  KidsArabicDailyMission mission,
  KidsArabicLetter letter,
) {
  switch (mission.type) {
    case KidsArabicDailyMissionType.newLetter:
      return l10n.kidsArabicDailyMissionNewLetterTitle(letter.nameAr);
    case KidsArabicDailyMissionType.review:
      return l10n.kidsArabicDailyMissionReviewTitle(letter.nameAr);
    case KidsArabicDailyMissionType.tracePractice:
      return l10n.kidsArabicDailyMissionTraceTitle(letter.nameAr);
  }
}

String localizedKidsArabicDailyMissionDescription(
  AppLocalizations l10n,
  KidsArabicDailyMission mission,
  KidsArabicLetter letter,
) {
  switch (mission.type) {
    case KidsArabicDailyMissionType.newLetter:
      return l10n.kidsArabicDailyMissionNewLetterDescription(letter.nameAr);
    case KidsArabicDailyMissionType.review:
      return l10n.kidsArabicDailyMissionReviewDescription(letter.nameAr);
    case KidsArabicDailyMissionType.tracePractice:
      return l10n.kidsArabicDailyMissionTraceDescription(letter.nameAr);
  }
}
