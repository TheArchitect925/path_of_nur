import '../../../../l10n/app_localizations.dart';
import '../domain/learn_note_category.dart';

extension LearnNotesLocalizations on AppLocalizations {
  String get learnNotesBrowseAllActionText => learnNotesBrowseAllAction;

  String get learnNotesBrowseAllTitleText => learnNotesBrowseAllTitle;

  String get learnNotesBrowseAllSubtitleText => learnNotesBrowseAllSubtitle;

  String get learnNotesCategoriesTitleText => learnNotesCategoriesTitle;

  String get learnNotesCategoriesSubtitleText => learnNotesCategoriesSubtitle;

  String get learnNotesBrowseEmptyText => learnNotesBrowseEmpty;

  String get learnNotesBrowseSearchLabelText => learnNotesBrowseSearchLabel;

  String get learnNotesBrowseSearchHintText => learnNotesBrowseSearchHint;

  String get learnNotesSourceQuranText => learnNotesSourceQuran;

  String get learnNotesSourceJournalText => learnNotesSourceJournal;

  String get learnNotesOpenJournalActionText => learnNotesOpenJournalAction;

  String get learnNotesBrowseActionSubtitleText =>
      learnNotesBrowseActionSubtitle;

  String get learnNotesCategoryAllText => learnNotesCategoryAll;

  String localizedLearnNoteCategory(LearnNoteCategory category) {
    return switch (category) {
      LearnNoteCategory.quran => learnNotesCategoryQuran,
      LearnNoteCategory.hadith => learnNotesCategoryHadith,
      LearnNoteCategory.learning => learnNotesCategoryLearning,
      LearnNoteCategory.reflection => learnNotesCategoryReflection,
      LearnNoteCategory.journal => learnNotesCategoryJournal,
      LearnNoteCategory.dua => learnNotesCategoryDua,
      LearnNoteCategory.worship => learnNotesCategoryWorship,
      LearnNoteCategory.general => learnNotesCategoryGeneral,
    };
  }
}
