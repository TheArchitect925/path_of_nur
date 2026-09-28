import '../models/learn_discovery_models.dart';

// Learn discovery flags, by knowledge entry id.
//
// Discovery used to guess these from English words in each entry's copy
// ("start", "basics", "gentle", "deeper", …). The copy it read was localized,
// so German, French, Arabic and Urdu got a different Start here shelf and
// ranking, and every copy edit could move an entry in or out. The sets below
// started as the English result of that guess (2026-09-27), then lost the
// entries where the word was about something else: a hadith's narration
// ("he started reciting"), a du'a's timing ("at the start of the day"), a
// rak'ah count ("the first two"), the salah surahs' memorization tag. A flag
// now changes only when an id is added here or removed. Guided paths carry
// their own flags, and Foundations and Kids entries are beginner-safe by
// category.

/// Knowledge entries on the Start here shelf (difficulty `startHere`).
const Set<String> learnDiscoveryStartHereIds = <String>{
  'faq:clarification_001',
  'faq:clarification_002',
  'faq:foundations_001',
  'faq:foundations_002',
  'faq:foundations_003',
  'faq:foundations_004',
  'faq:foundations_005',
  'faq:foundations_006',
  'faq:foundations_007',
  'faq:misconceptions_001',
  'faq:modern_003',
  'faq:prophets_002',
  'faq:quran_004',
  'hadith:lesson:islam_built_on_five_prayer',
  'kids-dua-category:daily_basics',
  'kids-salah:astaghfirullah',
  'kids-story-library:book_first_steps_angels_v1',
  'kids-story-library:book_first_steps_five_pillars_v1',
  'kids-story-library:book_first_steps_five_times_a_day_v1',
  'kids-story-library:book_first_steps_hajj_v1',
  'kids-story-library:book_first_steps_jannah_v1',
  'kids-story-library:book_first_steps_our_prophet_v1',
  'kids-story-library:book_first_steps_quran_v1',
  'kids-story-library:book_first_steps_ramadan_v1',
  'kids-story-library:book_first_steps_shahada_v1',
  'kids-story-library:book_first_steps_sharing_v1',
  'kids-story-library:book_first_steps_the_call_v1',
  'kids-story-library:book_first_steps_what_we_believe_v1',
  'kids-story-library:book_first_steps_who_is_allah_v1',
  'kids-story-library:book_first_steps_wudu_v1',
  'quiz:hadith:quiz_essential_ch1',
  'quiz:hadith:quiz_essential_ch2',
  'subcategory:arabic-learning',
  'subcategory:core-knowledge',
  'subcategory:glossary',
  'subcategory:understanding-islam',
  'subcategory:who-is-allah',
  'subcategory:world-creation',
  'trivia-path:foundations_of_islam',
  'trivia-stage:foundations_of_islam:fasting_and_dua',
  'trivia-stage:foundations_of_islam:prayer_and_worship',
  'trivia-stage:foundations_of_islam:revelation_and_guidance',
  'trivia-stage:foundations_of_islam:the_prophets',
  'trivia-stage:foundations_of_islam:what_is_islam',
};

/// Knowledge entries outside Foundations and Kids that are beginner-safe.
const Set<String> learnDiscoveryBeginnerIds = <String>{
  'dua:stub_036_prayer_and_worship_wudu',
  'dua:sunnah_before_eating_bismillah',
  'faq:modern_003',
  'faq:quran_004',
  'hadith_reflection:home',
  'history:archive',
  'subcategory:arabic-learning',
  'subcategory:discovery',
  'subcategory:islamic-trivia',
  'subcategory:search-tools',
  'trivia-path:foundations_of_islam',
  'trivia-stage:foundations_of_islam:what_is_islam',
};

/// Knowledge entries marked Deeper (Start here wins when an id is in both).
const Set<String> learnDiscoveryDeeperIds = <String>{
  'ayah_completion:home',
  'ayah_completion:kids',
  'kids-seerah-journey:journey_seerah_muhammad_kids_v1',
  'kids-seerah:hub',
  'quiz:prophets:mixed',
};

/// Tools that open as practice or reflection; every other tool is a tool.
const Map<String, LearnDiscoveryContentType> learnDiscoveryToolContentTypes =
    <String, LearnDiscoveryContentType>{
      'kids_arabic_learning:hub': LearnDiscoveryContentType.practice,
      'world-category:reflectionSigns': LearnDiscoveryContentType.reflection,
    };
