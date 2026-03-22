import '../../../../l10n/app_localizations.dart';
import '../domain/ayah_completion_models.dart';

String ayahCompletionLocalizedCategory(AppLocalizations l10n, String category) {
  switch (category) {
    case 'short_surahs':
      return l10n.ayahCompletionCategoryShortSurahs;
    case 'daily_duas_ayahs':
      return l10n.ayahCompletionCategoryDailyDuaAyahs;
    case 'mercy':
      return l10n.ayahCompletionCategoryMercy;
    case 'patience':
      return l10n.ayahCompletionCategoryPatience;
    case 'gratitude':
      return l10n.ayahCompletionCategoryGratitude;
    case 'memorization':
      return l10n.ayahCompletionCategoryMemorization;
    case 'quran':
      return l10n.ayahCompletionCategoryQuran;
    case 'mixed':
    default:
      return l10n.ayahCompletionCategoryMixed;
  }
}

String ayahCompletionDifficultyLabel(AppLocalizations l10n, int difficulty) {
  if (difficulty <= 12) return l10n.ayahCompletionDifficultyGentle;
  if (difficulty <= 30) return l10n.ayahCompletionDifficultySteady;
  if (difficulty <= 36) return l10n.ayahCompletionDifficultyReflective;
  return l10n.ayahCompletionDifficultyDeep;
}

String ayahCompletionPuzzleTitle(
  AppLocalizations l10n,
  AyahCompletionPuzzle puzzle,
) {
  return puzzle.mode == AyahCompletionMode.kids
      ? l10n.ayahCompletionPuzzleTitleKids(
          puzzle.ref.surah.toString(),
          puzzle.ref.ayah.toString(),
        )
      : l10n.ayahCompletionPuzzleTitleAdult(
          puzzle.ref.surah.toString(),
          puzzle.ref.ayah.toString(),
        );
}

String ayahCompletionPackTitle(
  AppLocalizations l10n,
  AyahCompletionPuzzlePack pack,
) {
  switch (pack.titleKey) {
    case 'ayahCompletionPackKidsShortSurahsTitle':
      return l10n.ayahCompletionPackKidsShortSurahsTitle;
    case 'ayahCompletionPackKidsMemorizationTitle':
      return l10n.ayahCompletionPackKidsMemorizationTitle;
    case 'ayahCompletionPackAdultShortSurahsTitle':
      return l10n.ayahCompletionPackAdultShortSurahsTitle;
    case 'ayahCompletionPackAdultDailyDuasTitle':
      return l10n.ayahCompletionPackAdultDailyDuasTitle;
    case 'ayahCompletionPackAdultMercyTitle':
      return l10n.ayahCompletionPackAdultMercyTitle;
    case 'ayahCompletionPackAdultPatienceTitle':
      return l10n.ayahCompletionPackAdultPatienceTitle;
    case 'ayahCompletionPackAdultGratitudeTitle':
      return l10n.ayahCompletionPackAdultGratitudeTitle;
    case 'ayahCompletionPackAdultMemorizationTitle':
      return l10n.ayahCompletionPackAdultMemorizationTitle;
    case 'ayahCompletionPackDailyMixedTitle':
    default:
      return l10n.ayahCompletionPackDailyMixedTitle;
  }
}

String ayahCompletionPackSubtitle(
  AppLocalizations l10n,
  AyahCompletionPuzzlePack pack,
) {
  switch (pack.descriptionKey) {
    case 'ayahCompletionPackKidsShortSurahsSubtitle':
      return l10n.ayahCompletionPackKidsShortSurahsSubtitle;
    case 'ayahCompletionPackKidsMemorizationSubtitle':
      return l10n.ayahCompletionPackKidsMemorizationSubtitle;
    case 'ayahCompletionPackAdultShortSurahsSubtitle':
      return l10n.ayahCompletionPackAdultShortSurahsSubtitle;
    case 'ayahCompletionPackAdultDailyDuasSubtitle':
      return l10n.ayahCompletionPackAdultDailyDuasSubtitle;
    case 'ayahCompletionPackAdultMercySubtitle':
      return l10n.ayahCompletionPackAdultMercySubtitle;
    case 'ayahCompletionPackAdultPatienceSubtitle':
      return l10n.ayahCompletionPackAdultPatienceSubtitle;
    case 'ayahCompletionPackAdultGratitudeSubtitle':
      return l10n.ayahCompletionPackAdultGratitudeSubtitle;
    case 'ayahCompletionPackAdultMemorizationSubtitle':
      return l10n.ayahCompletionPackAdultMemorizationSubtitle;
    case 'ayahCompletionPackDailyMixedSubtitle':
    default:
      return l10n.ayahCompletionPackDailyMixedSubtitle;
  }
}
