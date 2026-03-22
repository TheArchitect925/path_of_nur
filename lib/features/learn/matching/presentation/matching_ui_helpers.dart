import '../../../../l10n/app_localizations.dart';
import '../domain/matching_models.dart';

String matchingLocalizedCategory(AppLocalizations l10n, String category) {
  switch (category) {
    case 'kids':
      return l10n.matchingCategoryKids;
    case 'letters':
      return l10n.matchingCategoryLetters;
    case 'quran':
      return l10n.matchingCategoryQuran;
    case 'hadith':
      return l10n.matchingCategoryHadith;
    case 'prophets':
      return l10n.matchingCategoryProphets;
    case 'duas':
      return l10n.matchingCategoryDuas;
    case 'worship':
      return l10n.matchingCategoryWorship;
    case 'character':
      return l10n.matchingCategoryCharacter;
    case 'mixed':
    default:
      return l10n.matchingCategoryMixed;
  }
}

String matchingDifficultyLabel(AppLocalizations l10n, int difficulty) {
  if (difficulty <= 12) return l10n.matchingDifficultyGentle;
  if (difficulty <= 28) return l10n.matchingDifficultySteady;
  if (difficulty <= 36) return l10n.matchingDifficultyFocused;
  return l10n.matchingDifficultyDeep;
}

String matchingPuzzleTitle(AppLocalizations l10n, MatchingPuzzle puzzle) {
  return puzzle.mode == MatchingMode.kids
      ? l10n.matchingPuzzleTitleKids(
          matchingLocalizedCategory(l10n, puzzle.category),
        )
      : l10n.matchingPuzzleTitleAdult(
          matchingLocalizedCategory(l10n, puzzle.category),
        );
}

String matchingPackTitle(AppLocalizations l10n, MatchingPuzzlePack pack) {
  switch (pack.titleKey) {
    case 'matchingPackKidsBasicsTitle':
      return l10n.matchingPackKidsBasicsTitle;
    case 'matchingPackArabicTitle':
      return l10n.matchingPackArabicTitle;
    case 'matchingPackQuranTitle':
      return l10n.matchingPackQuranTitle;
    case 'matchingPackHadithTitle':
      return l10n.matchingPackHadithTitle;
    case 'matchingPackProphetsTitle':
      return l10n.matchingPackProphetsTitle;
    case 'matchingPackDuaTitle':
      return l10n.matchingPackDuaTitle;
    case 'matchingPackAdabTitle':
      return l10n.matchingPackAdabTitle;
    case 'matchingPackDailyTitle':
    default:
      return l10n.matchingPackDailyTitle;
  }
}

String matchingPackSubtitle(AppLocalizations l10n, MatchingPuzzlePack pack) {
  switch (pack.descriptionKey) {
    case 'matchingPackKidsBasicsSubtitle':
      return l10n.matchingPackKidsBasicsSubtitle;
    case 'matchingPackArabicSubtitle':
      return l10n.matchingPackArabicSubtitle;
    case 'matchingPackQuranSubtitle':
      return l10n.matchingPackQuranSubtitle;
    case 'matchingPackHadithSubtitle':
      return l10n.matchingPackHadithSubtitle;
    case 'matchingPackProphetsSubtitle':
      return l10n.matchingPackProphetsSubtitle;
    case 'matchingPackDuaSubtitle':
      return l10n.matchingPackDuaSubtitle;
    case 'matchingPackAdabSubtitle':
      return l10n.matchingPackAdabSubtitle;
    case 'matchingPackDailySubtitle':
    default:
      return l10n.matchingPackDailySubtitle;
  }
}
