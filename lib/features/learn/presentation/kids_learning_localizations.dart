import '../../../l10n/app_localizations.dart';
import '../quran/domain/quran_surah.dart';

extension KidsLearningLocalizations on AppLocalizations {
  String get learnHubSubcategoryKidsQuranTitleText => 'Qur’an for Kids';

  String get learnHubSubcategoryKidsQuranSubtitleText =>
      'Browse every surah in a simpler Qur’an experience for younger learners.';

  String get learnHubSubcategoryKidsHadithTitleText => 'Hadith for Kids';

  String get learnHubSubcategoryKidsHadithSubtitleText =>
      'Short, gentle hadith cards with simple meanings and daily lessons.';

  String get learnHubSubcategoryKidsHadithStoriesTitleText => 'Hadith Stories';

  String get learnHubSubcategoryKidsHadithStoriesSubtitleText =>
      'Open story time inspired by authentic hadith and kind daily moments.';

  String get kidsQuranPageTitleText => 'Qur’an for Kids';

  String get kidsQuranPageSubtitleText =>
      'A calm way to browse every surah with Arabic and translation.';

  String get kidsQuranIntroTitleText => 'Start with any surah';

  String get kidsQuranIntroSubtitleText =>
      'Choose a surah, read gently, and open any ayah in the full reader when you need more detail.';

  String get kidsQuranOpenSurahActionText => 'Open surah';

  String kidsQuranSurahMetaText(QuranSurah surah) {
    return '${surah.verseCount} ayahs • ${_kidsQuranRevelationPlace(surah)}';
  }

  String _kidsQuranRevelationPlace(QuranSurah surah) {
    final normalized = surah.revelationPlace.trim().toLowerCase();
    if (normalized == 'madinah' || normalized == 'medinan') {
      return 'Madinah';
    }
    return 'Makkah';
  }

  String kidsQuranSurahSubtitleText(QuranSurah surah) {
    return '${surah.transliteratedName} • ${surah.englishName}';
  }

  String get kidsQuranOpenAyahHintText =>
      'Open this ayah in the full Qur’an reader';

  String get kidsQuranBackToSurahsActionText => 'All surahs';

  String get kidsQuranSurahMissingText => 'Surah not found.';

  String get kidsHadithPageTitleText => 'Hadith for Kids';

  String get kidsHadithPageSubtitleText =>
      'Short hadith with gentle meanings, simple lessons, and child-friendly reminders.';

  String get kidsHadithIntroTitleText => 'Small hadith, big lessons';

  String get kidsHadithIntroSubtitleText =>
      'These hadith are kept short and easy to revisit, so children can grow in kindness, honesty, mercy, and love of learning.';

  String get kidsHadithStoriesCardTitleText => 'Hadith stories';

  String get kidsHadithStoriesCardSubtitleText =>
      'Open story time shaped by real hadith lessons children can recognize in daily life.';

  String get kidsHadithStoriesOpenActionText => 'Open stories';

  String get kidsHadithMeaningTitleText => 'Simple meaning';

  String get kidsHadithLessonTitleText => 'Little lesson';

  String get kidsHadithStoriesPageTitleText => 'Kids Hadith Stories';

  String get kidsHadithStoriesPageSubtitleText =>
      'Stories shaped by authentic hadith and everyday moments of kindness, adab, and mercy.';

  String get kidsHadithStoriesHeroTitleText =>
      'Stories from real Sunnah lessons';

  String get kidsHadithStoriesHeroSubtitleText =>
      'Each story keeps the meaning gentle while staying tied to an authentic hadith reference.';

  String get kidsHadithStoriesSourceLabelText => 'Hadith source';

  String get kidsHadithStoriesStatusReadyText => 'Ready to read';

  String get kidsHadithStoriesStatusContinueText => 'Continue';

  String get kidsHadithStoriesStatusReadAgainText => 'Read again';

  String get kidsHadithStoriesHadithChipText => 'Hadith';

  String get kidsHadithStoriesEmptyTitleText =>
      'More hadith stories are on the way';

  String get kidsHadithStoriesEmptySubtitleText =>
      'The existing kids story library is ready, and more hadith-based stories can be added safely in later passes.';
}
