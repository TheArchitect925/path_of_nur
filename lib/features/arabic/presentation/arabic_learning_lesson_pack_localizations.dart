import '../../../l10n/app_localizations.dart';
import '../domain/arabic_learning_lesson_pack_models.dart';

String localizedArabicLearningLessonPackTitle(
  AppLocalizations l10n,
  String packId,
) {
  switch (packId) {
    case 'kids_beginner_letters_pack':
      return l10n.arabicLearningPackKidsBeginnerLettersTitle;
    case 'kids_first_words_pack':
      return l10n.arabicLearningPackKidsFirstWordsTitle;
    case 'kids_mini_phrases_pack':
      return l10n.arabicLearningPackKidsMiniPhrasesTitle;
    case 'kids_daily_words_theme_pack':
      return l10n.arabicLearningPackKidsDailyWordsThemeTitle;
    case 'kids_prayer_words_theme_pack':
      return l10n.arabicLearningPackKidsPrayerWordsThemeTitle;
    case 'kids_quran_linked_words_theme_pack':
      return l10n.arabicLearningPackKidsQuranLinkedWordsThemeTitle;
    case 'kids_review_pack':
      return l10n.arabicLearningPackKidsReviewTitle;
    case 'kids_quran_readiness_pack':
      return l10n.arabicLearningPackKidsQuranReadinessTitle;
    case 'adult_beginner_letters_pack':
      return l10n.arabicLearningPackAdultBeginnerLettersTitle;
    case 'adult_first_words_pack':
      return l10n.arabicLearningPackAdultFirstWordsTitle;
    case 'adult_phrase_reading_pack':
      return l10n.arabicLearningPackAdultPhraseReadingTitle;
    case 'adult_daily_words_theme_pack':
      return l10n.arabicLearningPackAdultDailyWordsThemeTitle;
    case 'adult_prayer_words_theme_pack':
      return l10n.arabicLearningPackAdultPrayerWordsThemeTitle;
    case 'adult_quran_linked_words_theme_pack':
      return l10n.arabicLearningPackAdultQuranLinkedWordsThemeTitle;
    case 'adult_review_pack':
      return l10n.arabicLearningPackAdultReviewTitle;
    case 'adult_quran_readiness_pack':
      return l10n.arabicLearningPackAdultQuranReadinessTitle;
    case 'adult_tajweed_support_pack':
      return l10n.arabicLearningPackAdultTajweedSupportTitle;
  }
  return packId;
}

String localizedArabicLearningLessonPackSubtitle(
  AppLocalizations l10n,
  String packId,
) {
  switch (packId) {
    case 'kids_beginner_letters_pack':
      return l10n.arabicLearningPackKidsBeginnerLettersSubtitle;
    case 'kids_first_words_pack':
      return l10n.arabicLearningPackKidsFirstWordsSubtitle;
    case 'kids_mini_phrases_pack':
      return l10n.arabicLearningPackKidsMiniPhrasesSubtitle;
    case 'kids_daily_words_theme_pack':
      return l10n.arabicLearningPackKidsDailyWordsThemeSubtitle;
    case 'kids_prayer_words_theme_pack':
      return l10n.arabicLearningPackKidsPrayerWordsThemeSubtitle;
    case 'kids_quran_linked_words_theme_pack':
      return l10n.arabicLearningPackKidsQuranLinkedWordsThemeSubtitle;
    case 'kids_review_pack':
      return l10n.arabicLearningPackKidsReviewSubtitle;
    case 'kids_quran_readiness_pack':
      return l10n.arabicLearningPackKidsQuranReadinessSubtitle;
    case 'adult_beginner_letters_pack':
      return l10n.arabicLearningPackAdultBeginnerLettersSubtitle;
    case 'adult_first_words_pack':
      return l10n.arabicLearningPackAdultFirstWordsSubtitle;
    case 'adult_phrase_reading_pack':
      return l10n.arabicLearningPackAdultPhraseReadingSubtitle;
    case 'adult_daily_words_theme_pack':
      return l10n.arabicLearningPackAdultDailyWordsThemeSubtitle;
    case 'adult_prayer_words_theme_pack':
      return l10n.arabicLearningPackAdultPrayerWordsThemeSubtitle;
    case 'adult_quran_linked_words_theme_pack':
      return l10n.arabicLearningPackAdultQuranLinkedWordsThemeSubtitle;
    case 'adult_review_pack':
      return l10n.arabicLearningPackAdultReviewSubtitle;
    case 'adult_quran_readiness_pack':
      return l10n.arabicLearningPackAdultQuranReadinessSubtitle;
    case 'adult_tajweed_support_pack':
      return l10n.arabicLearningPackAdultTajweedSupportSubtitle;
  }
  return '';
}

String localizedArabicLearningLessonPackType(
  AppLocalizations l10n,
  ArabicLearningLessonPackType type,
) {
  switch (type) {
    case ArabicLearningLessonPackType.letters:
      return l10n.arabicLearningPackTypeLetters;
    case ArabicLearningLessonPackType.words:
      return l10n.arabicLearningPackTypeWords;
    case ArabicLearningLessonPackType.phrases:
      return l10n.arabicLearningPackTypePhrases;
    case ArabicLearningLessonPackType.theme:
      return l10n.arabicLearningPackTypeTheme;
    case ArabicLearningLessonPackType.reading:
      return l10n.arabicLearningPackTypeReading;
    case ArabicLearningLessonPackType.review:
      return l10n.arabicLearningPackTypeReview;
    case ArabicLearningLessonPackType.bridge:
      return l10n.arabicLearningPackTypeBridge;
    case ArabicLearningLessonPackType.tajweedSupport:
      return l10n.arabicLearningPackTypeTajweed;
  }
}
