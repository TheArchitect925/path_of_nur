import '../../../../l10n/app_localizations.dart';
import '../domain/hadith_reflection_models.dart';

String hadithReflectionLocalizedCategory(AppLocalizations l10n, String value) {
  switch (value) {
    case 'kindness':
      return l10n.hadithReflectionCategoryKindness;
    case 'honesty':
      return l10n.hadithReflectionCategoryHonesty;
    case 'patience':
      return l10n.hadithReflectionCategoryPatience;
    case 'anger':
      return l10n.hadithReflectionCategoryAnger;
    case 'family':
      return l10n.hadithReflectionCategoryFamily;
    case 'community':
      return l10n.hadithReflectionCategoryCommunity;
    case 'repentance':
      return l10n.hadithReflectionCategoryRepentance;
    case 'speech':
      return l10n.hadithReflectionCategorySpeech;
    case 'sincerity':
      return l10n.hadithReflectionCategorySincerity;
    case 'respect':
      return l10n.hadithReflectionCategoryRespect;
    case 'justice':
      return l10n.hadithReflectionCategoryJustice;
    case 'accountability':
      return l10n.hadithReflectionCategoryAccountability;
    case 'integrity':
      return l10n.hadithReflectionCategoryIntegrity;
    case 'service':
      return l10n.hadithReflectionCategoryService;
    case 'focus':
      return l10n.hadithReflectionCategoryFocus;
    case 'resilience':
      return l10n.hadithReflectionCategoryResilience;
    case 'mixed':
    default:
      return l10n.hadithReflectionCategoryMixed;
  }
}

String hadithReflectionDifficultyLabel(AppLocalizations l10n, int difficulty) {
  if (difficulty <= 12) return l10n.hadithReflectionDifficultyGentle;
  if (difficulty <= 24) return l10n.hadithReflectionDifficultySteady;
  if (difficulty <= 34) return l10n.hadithReflectionDifficultyReflective;
  return l10n.hadithReflectionDifficultyDeep;
}

String hadithReflectionPuzzleTitle(
  AppLocalizations l10n,
  HadithReflectionPuzzle puzzle,
) {
  return puzzle.mode == HadithReflectionMode.kids
      ? l10n.hadithReflectionPuzzleTitleKids
      : l10n.hadithReflectionPuzzleTitleAdult;
}

String hadithReflectionPackTitle(
  AppLocalizations l10n,
  HadithReflectionPuzzlePack pack,
) {
  switch (pack.id) {
    case 'hadith_reflection_kids_kindness':
      return l10n.hadithReflectionPackKidsKindnessTitle;
    case 'hadith_reflection_honesty_trust':
      return l10n.hadithReflectionPackHonestyTitle;
    case 'hadith_reflection_patience_gratitude':
      return l10n.hadithReflectionPackPatienceTitle;
    case 'hadith_reflection_anger_control':
      return l10n.hadithReflectionPackAngerTitle;
    case 'hadith_reflection_family_respect':
      return l10n.hadithReflectionPackFamilyTitle;
    case 'hadith_reflection_community_service':
      return l10n.hadithReflectionPackCommunityTitle;
    case 'hadith_reflection_forgiveness_mercy':
      return l10n.hadithReflectionPackRepentanceTitle;
    case 'hadith_reflection_adab_speech':
      return l10n.hadithReflectionPackSpeechTitle;
    case 'hadith_reflection_daily_mixed':
      return l10n.hadithReflectionPackDailyTitle;
    default:
      return hadithReflectionLocalizedCategory(l10n, pack.category);
  }
}

String hadithReflectionPackSubtitle(
  AppLocalizations l10n,
  HadithReflectionPuzzlePack pack,
) {
  switch (pack.id) {
    case 'hadith_reflection_kids_kindness':
      return l10n.hadithReflectionPackKidsKindnessSubtitle;
    case 'hadith_reflection_honesty_trust':
      return l10n.hadithReflectionPackHonestySubtitle;
    case 'hadith_reflection_patience_gratitude':
      return l10n.hadithReflectionPackPatienceSubtitle;
    case 'hadith_reflection_anger_control':
      return l10n.hadithReflectionPackAngerSubtitle;
    case 'hadith_reflection_family_respect':
      return l10n.hadithReflectionPackFamilySubtitle;
    case 'hadith_reflection_community_service':
      return l10n.hadithReflectionPackCommunitySubtitle;
    case 'hadith_reflection_forgiveness_mercy':
      return l10n.hadithReflectionPackRepentanceSubtitle;
    case 'hadith_reflection_adab_speech':
      return l10n.hadithReflectionPackSpeechSubtitle;
    case 'hadith_reflection_daily_mixed':
      return l10n.hadithReflectionPackDailySubtitle;
    default:
      return hadithReflectionLocalizedCategory(l10n, pack.category);
  }
}

String hadithReflectionOutcomeLabel(
  AppLocalizations l10n,
  HadithReflectionOutcome outcome,
) {
  switch (outcome) {
    case HadithReflectionOutcome.bestAligned:
      return l10n.hadithReflectionOutcomeBest;
    case HadithReflectionOutcome.acceptable:
      return l10n.hadithReflectionOutcomeAcceptable;
    case HadithReflectionOutcome.needsReflection:
      return l10n.hadithReflectionOutcomeNeedsReflection;
  }
}
