import '../../../../l10n/app_localizations.dart';
import '../domain/crossword_models.dart';

String crosswordPuzzleTitle(AppLocalizations l10n, CrosswordPuzzle puzzle) {
  final category = crosswordLocalizedCategory(l10n, puzzle.category);
  if (puzzle.mode == CrosswordMode.kids) {
    return l10n.crosswordPuzzleTitleKids(category);
  }
  return l10n.crosswordPuzzleTitleAdult(category);
}

String crosswordDifficultyLabel(AppLocalizations l10n, int difficulty) {
  if (difficulty < 10) return l10n.crosswordDifficultyBeginner;
  if (difficulty < 25) return l10n.crosswordDifficultySteady;
  if (difficulty < 50) return l10n.crosswordDifficultyReflective;
  return l10n.crosswordDifficultyDeep;
}

String crosswordLocalizedCategory(AppLocalizations l10n, String category) {
  switch (category) {
    case 'letters':
      return l10n.crosswordCategoryLetters;
    case 'worship':
      return l10n.crosswordCategoryWorship;
    case 'character':
      return l10n.crosswordCategoryCharacter;
    case 'faith':
      return l10n.crosswordCategoryFaith;
    case 'quran':
      return l10n.crosswordCategoryQuran;
    case 'hadith':
      return l10n.crosswordCategoryHadith;
    case 'prophets':
      return l10n.crosswordCategoryProphets;
    case 'duas':
      return l10n.crosswordCategoryDuas;
    case 'jummah':
      return l10n.crosswordCategoryJummah;
    case 'mixed':
    default:
      return l10n.crosswordCategoryMixed;
  }
}

String crosswordPackTitle(AppLocalizations l10n, CrosswordPuzzlePack pack) {
  switch (pack.titleKey) {
    case 'crosswordPackKidsBasicsTitle':
      return l10n.crosswordPackKidsBasicsTitle;
    case 'crosswordPackAdultFoundationsTitle':
      return l10n.crosswordPackAdultFoundationsTitle;
    case 'crosswordPackDailyTitle':
      return l10n.crosswordPackDailyTitle;
    case 'crosswordPackQuranTitle':
      return l10n.crosswordPackQuranTitle;
    case 'crosswordPackHadithTitle':
      return l10n.crosswordPackHadithTitle;
    case 'crosswordPackProphetsTitle':
      return l10n.crosswordPackProphetsTitle;
    case 'crosswordPackDuasTitle':
      return l10n.crosswordPackDuasTitle;
    case 'crosswordPackWorshipTitle':
      return l10n.crosswordPackWorshipTitle;
    case 'crosswordPackCharacterTitle':
      return l10n.crosswordPackCharacterTitle;
    case 'crosswordPackMixedTitle':
    default:
      return l10n.crosswordPackMixedTitle;
  }
}

String crosswordPackSubtitle(AppLocalizations l10n, CrosswordPuzzlePack pack) {
  switch (pack.descriptionKey) {
    case 'crosswordPackKidsBasicsSubtitle':
      return l10n.crosswordPackKidsBasicsSubtitle;
    case 'crosswordPackAdultFoundationsSubtitle':
      return l10n.crosswordPackAdultFoundationsSubtitle;
    case 'crosswordPackDailySubtitle':
      return l10n.crosswordPackDailySubtitle;
    case 'crosswordPackQuranSubtitle':
      return l10n.crosswordPackQuranSubtitle;
    case 'crosswordPackHadithSubtitle':
      return l10n.crosswordPackHadithSubtitle;
    case 'crosswordPackProphetsSubtitle':
      return l10n.crosswordPackProphetsSubtitle;
    case 'crosswordPackDuasSubtitle':
      return l10n.crosswordPackDuasSubtitle;
    case 'crosswordPackWorshipSubtitle':
      return l10n.crosswordPackWorshipSubtitle;
    case 'crosswordPackCharacterSubtitle':
      return l10n.crosswordPackCharacterSubtitle;
    case 'crosswordPackMixedSubtitle':
    default:
      return l10n.crosswordPackMixedSubtitle;
  }
}
