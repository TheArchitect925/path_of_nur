import '../domain/arabic_beginner_content_models.dart';

const arabicSharedBeginnerWordOrderIds = <String>[
  'bab',
  'noor',
  'qalam',
  'kitab',
  'rabb',
];

const arabicSharedBeginnerWords = <ArabicBeginnerWordEntry>[
  ArabicBeginnerWordEntry(
    id: 'bab',
    arabicText: 'باب',
    transliteration: 'baab',
    simpleMeaning: 'Door',
    letterIds: <String>['ba', 'alif', 'ba'],
  ),
  ArabicBeginnerWordEntry(
    id: 'noor',
    arabicText: 'نُور',
    transliteration: 'noor',
    simpleMeaning: 'Light',
    letterIds: <String>['noon', 'waw', 'ra'],
    categoryTag: 'quran_word',
    audioLookupId: 'word_noor',
    audioAssetPath: 'assets/audio/quran_teacher/words/noor.mp3',
    sourceReference: 'Qur’an 24:35',
  ),
  ArabicBeginnerWordEntry(
    id: 'qalam',
    arabicText: 'قلم',
    transliteration: 'qalam',
    simpleMeaning: 'Pen',
    letterIds: <String>['qaf', 'lam', 'meem'],
    categoryTag: 'quran_word',
    sourceReference: 'Qur’an 68:1',
  ),
  ArabicBeginnerWordEntry(
    id: 'kitab',
    arabicText: 'كِتَاب',
    transliteration: 'kitab',
    simpleMeaning: 'Book',
    letterIds: <String>['kaf', 'ta', 'alif', 'ba'],
    categoryTag: 'quran_word',
    audioLookupId: 'word_kitab',
    audioAssetPath: 'assets/audio/quran_teacher/words/kitab.mp3',
    sourceReference: 'Qur’an 2:2',
  ),
  ArabicBeginnerWordEntry(
    id: 'rabb',
    arabicText: 'رَبّ',
    transliteration: 'rabb',
    simpleMeaning: 'Lord',
    letterIds: <String>['ra', 'ba'],
    categoryTag: 'quran_word',
    audioLookupId: 'word_rabb',
    audioAssetPath: 'assets/audio/quran_teacher/words/rabb.mp3',
    sourceReference: 'Qur’an 1:2',
  ),
];

const arabicSharedMiniPhraseOrderIds = <String>[
  'bismillah',
  'alhamdulillah',
  'subhanallah',
  'allahu-akbar',
  'assalamu-alaikum',
  'inshaallah',
  'rabbil-alamin',
  'iyyaka-nabudu',
];

const arabicSharedMiniPhrases = <ArabicBeginnerPhraseEntry>[
  ArabicBeginnerPhraseEntry(
    id: 'bismillah',
    arabicText: 'بِسْمِ اللّٰهِ',
    transliteration: 'bismillah',
    simpleMeaning: 'In the name of Allah',
    categoryTag: 'dhikr_phrase',
    audioLookupId: 'phrase_bismillah',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/bismillah.mp3',
    sourceReference: 'Qur’an 1:1',
  ),
  ArabicBeginnerPhraseEntry(
    id: 'alhamdulillah',
    arabicText: 'الْحَمْدُ لِلّٰهِ',
    transliteration: 'alhamdulillah',
    simpleMeaning: 'All praise is for Allah',
    categoryTag: 'dhikr_phrase',
    audioLookupId: 'phrase_alhamdulillah',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/alhamdulillah.mp3',
    sourceReference: 'Qur’an 1:2',
  ),
  ArabicBeginnerPhraseEntry(
    id: 'subhanallah',
    arabicText: 'سُبْحَانَ اللَّهِ',
    transliteration: 'subhanallah',
    simpleMeaning: 'Glory be to Allah',
    categoryTag: 'dhikr_phrase',
  ),
  ArabicBeginnerPhraseEntry(
    id: 'allahu-akbar',
    arabicText: 'اللَّهُ أَكْبَرُ',
    transliteration: 'allahu akbar',
    simpleMeaning: 'Allah is the Greatest',
    categoryTag: 'dhikr_phrase',
  ),
  ArabicBeginnerPhraseEntry(
    id: 'assalamu-alaikum',
    arabicText: 'السَّلَامُ عَلَيْكُمْ',
    transliteration: 'assalamu alaikum',
    simpleMeaning: 'Peace be upon you',
    categoryTag: 'greeting_phrase',
  ),
  ArabicBeginnerPhraseEntry(
    id: 'inshaallah',
    arabicText: 'إِنْ شَاءَ اللَّهُ',
    transliteration: 'in sha Allah',
    simpleMeaning: 'If Allah wills',
    categoryTag: 'daily_phrase',
  ),
  ArabicBeginnerPhraseEntry(
    id: 'rabbil-alamin',
    arabicText: 'رَبِّ الْعَالَمِينَ',
    transliteration: 'rabbil alamin',
    simpleMeaning: 'Lord of the worlds',
    categoryTag: 'quran_phrase',
    audioLookupId: 'phrase_rabb_al_alamin',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/rabb_al_alamin.mp3',
    sourceReference: 'Qur’an 1:2',
  ),
  ArabicBeginnerPhraseEntry(
    id: 'iyyaka-nabudu',
    arabicText: 'إِيَّاكَ نَعْبُدُ',
    transliteration: 'iyyaka nabudu',
    simpleMeaning: 'You alone we worship',
    categoryTag: 'quran_phrase',
    audioLookupId: 'phrase_iyyaka_nabud',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/iyyaka_nabud.mp3',
    sourceReference: 'Qur’an 1:5',
  ),
];

ArabicBeginnerWordEntry? arabicSharedBeginnerWordById(String id) {
  for (final word in arabicSharedBeginnerWords) {
    if (word.id == id) {
      return word;
    }
  }
  return null;
}

ArabicBeginnerPhraseEntry? arabicSharedMiniPhraseById(String id) {
  for (final phrase in arabicSharedMiniPhrases) {
    if (phrase.id == id) {
      return phrase;
    }
  }
  return null;
}
