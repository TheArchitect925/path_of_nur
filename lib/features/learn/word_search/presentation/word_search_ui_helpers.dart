import '../../../../l10n/app_localizations.dart';
import '../domain/word_search_models.dart';

String wordSearchLocalizedCategory(AppLocalizations l10n, String category) {
  switch (category) {
    case 'kids':
      return l10n.wordSearchCategoryKids;
    case 'letters':
      return l10n.wordSearchCategoryLetters;
    case 'quran':
      return l10n.wordSearchCategoryQuran;
    case 'hadith':
      return l10n.wordSearchCategoryHadith;
    case 'prophets':
      return l10n.wordSearchCategoryProphets;
    case 'duas':
      return l10n.wordSearchCategoryDuas;
    case 'worship':
      return l10n.wordSearchCategoryWorship;
    case 'character':
      return l10n.wordSearchCategoryCharacter;
    case 'history':
      return l10n.wordSearchCategoryHistory;
    case 'mixed':
    default:
      return l10n.wordSearchCategoryMixed;
  }
}

String wordSearchDifficultyLabel(AppLocalizations l10n, int difficulty) {
  if (difficulty <= 15) return l10n.wordSearchDifficultyGentle;
  if (difficulty <= 30) return l10n.wordSearchDifficultySteady;
  if (difficulty <= 42) return l10n.wordSearchDifficultyFocused;
  return l10n.wordSearchDifficultyDeep;
}

String wordSearchPuzzleTitle(AppLocalizations l10n, WordSearchPuzzle puzzle) {
  return puzzle.mode == WordSearchMode.kids
      ? l10n.wordSearchPuzzleTitleKids(
          wordSearchLocalizedCategory(l10n, puzzle.category),
        )
      : l10n.wordSearchPuzzleTitleAdult(
          wordSearchLocalizedCategory(l10n, puzzle.category),
        );
}

String wordSearchPackTitle(AppLocalizations l10n, WordSearchPuzzlePack pack) {
  switch (pack.titleKey) {
    case 'wordSearchPackKidsStarterTitle':
      return l10n.wordSearchPackKidsStarterTitle;
    case 'wordSearchPackLettersTitle':
      return l10n.wordSearchPackLettersTitle;
    case 'wordSearchPackPrayerTitle':
      return l10n.wordSearchPackPrayerTitle;
    case 'wordSearchPackAdultTitle':
      return l10n.wordSearchPackAdultTitle;
    case 'wordSearchPackQuranTitle':
      return l10n.wordSearchPackQuranTitle;
    case 'wordSearchPackHadithTitle':
      return l10n.wordSearchPackHadithTitle;
    case 'wordSearchPackProphetsTitle':
      return l10n.wordSearchPackProphetsTitle;
    case 'wordSearchPackDuaTitle':
      return l10n.wordSearchPackDuaTitle;
    case 'wordSearchPackCharacterTitle':
      return l10n.wordSearchPackCharacterTitle;
    case 'wordSearchPackDailyTitle':
    default:
      return l10n.wordSearchPackDailyTitle;
  }
}

String wordSearchPackSubtitle(
  AppLocalizations l10n,
  WordSearchPuzzlePack pack,
) {
  switch (pack.descriptionKey) {
    case 'wordSearchPackKidsStarterSubtitle':
      return l10n.wordSearchPackKidsStarterSubtitle;
    case 'wordSearchPackLettersSubtitle':
      return l10n.wordSearchPackLettersSubtitle;
    case 'wordSearchPackPrayerSubtitle':
      return l10n.wordSearchPackPrayerSubtitle;
    case 'wordSearchPackAdultSubtitle':
      return l10n.wordSearchPackAdultSubtitle;
    case 'wordSearchPackQuranSubtitle':
      return l10n.wordSearchPackQuranSubtitle;
    case 'wordSearchPackHadithSubtitle':
      return l10n.wordSearchPackHadithSubtitle;
    case 'wordSearchPackProphetsSubtitle':
      return l10n.wordSearchPackProphetsSubtitle;
    case 'wordSearchPackDuaSubtitle':
      return l10n.wordSearchPackDuaSubtitle;
    case 'wordSearchPackCharacterSubtitle':
      return l10n.wordSearchPackCharacterSubtitle;
    case 'wordSearchPackDailySubtitle':
    default:
      return l10n.wordSearchPackDailySubtitle;
  }
}
