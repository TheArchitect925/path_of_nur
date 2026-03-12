import '../domain/quran_ayah.dart';
import '../domain/quran_daily_verse.dart';
import '../domain/quran_surah.dart';

const List<QuranSurah> stagedSurahList = [
  QuranSurah(
    number: 1,
    arabicName: 'الفاتحة',
    transliteratedName: 'Al-Fatihah',
    englishName: 'The Opening',
    verseCount: 7,
    revelationPlace: 'Makkah',
  ),
  QuranSurah(
    number: 2,
    arabicName: 'البقرة',
    transliteratedName: 'Al-Baqarah',
    englishName: 'The Cow',
    verseCount: 286,
    revelationPlace: 'Madinah',
  ),
  QuranSurah(
    number: 3,
    arabicName: 'آل عمران',
    transliteratedName: 'Ali Imran',
    englishName: 'Family of Imran',
    verseCount: 200,
    revelationPlace: 'Madinah',
  ),
  QuranSurah(
    number: 18,
    arabicName: 'الكهف',
    transliteratedName: 'Al-Kahf',
    englishName: 'The Cave',
    verseCount: 110,
    revelationPlace: 'Makkah',
  ),
  QuranSurah(
    number: 36,
    arabicName: 'يس',
    transliteratedName: 'Ya-Sin',
    englishName: 'Ya-Sin',
    verseCount: 83,
    revelationPlace: 'Makkah',
  ),
  QuranSurah(
    number: 55,
    arabicName: 'الرحمن',
    transliteratedName: 'Ar-Rahman',
    englishName: 'The Most Merciful',
    verseCount: 78,
    revelationPlace: 'Madinah',
  ),
  QuranSurah(
    number: 67,
    arabicName: 'الملك',
    transliteratedName: 'Al-Mulk',
    englishName: 'The Sovereignty',
    verseCount: 30,
    revelationPlace: 'Makkah',
  ),
  QuranSurah(
    number: 94,
    arabicName: 'الشرح',
    transliteratedName: 'Ash-Sharh',
    englishName: 'The Expansion',
    verseCount: 8,
    revelationPlace: 'Makkah',
  ),
  QuranSurah(
    number: 96,
    arabicName: 'العلق',
    transliteratedName: 'Al-Alaq',
    englishName: 'The Clot',
    verseCount: 19,
    revelationPlace: 'Makkah',
  ),
  QuranSurah(
    number: 112,
    arabicName: 'الإخلاص',
    transliteratedName: 'Al-Ikhlas',
    englishName: 'Sincerity',
    verseCount: 4,
    revelationPlace: 'Makkah',
  ),
  QuranSurah(
    number: 113,
    arabicName: 'الفلق',
    transliteratedName: 'Al-Falaq',
    englishName: 'Daybreak',
    verseCount: 5,
    revelationPlace: 'Makkah',
  ),
  QuranSurah(
    number: 114,
    arabicName: 'الناس',
    transliteratedName: 'An-Nas',
    englishName: 'Mankind',
    verseCount: 6,
    revelationPlace: 'Makkah',
  ),
];

const Map<int, List<QuranAyah>> stagedAyahMap = {
  1: [
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 1,
      arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيمِ',
      translation: 'In the name of الله, the Entirely Merciful, the Especially Merciful.',
      transliteration: 'Bismillahi ar-Rahmani ar-Rahim',
    ),
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 2,
      arabic: 'الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ',
      translation: 'All praise is due to الله, Lord of all worlds.',
      transliteration: 'Alhamdu lillahi rabbil alamin',
    ),
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 5,
      arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      translation: 'You alone we worship, and You alone we ask for help.',
      transliteration: 'Iyyaka naabudu wa iyyaka nastaeen',
    ),
  ],
  2: [
    QuranAyah(
      surahNumber: 2,
      ayahNumber: 45,
      arabic: 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
      translation: 'Seek help through patience and prayer.',
      transliteration: 'Wastaeenu bis-sabri was-salah',
    ),
    QuranAyah(
      surahNumber: 2,
      ayahNumber: 152,
      arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
      translation: 'Remember Me; I will remember you.',
      transliteration: 'Fadhkurooni adhkurkum',
    ),
    QuranAyah(
      surahNumber: 2,
      ayahNumber: 186,
      arabic: 'فَإِنِّي قَرِيبٌ',
      translation: 'Indeed, I am near.',
      transliteration: 'Fa inni qareeb',
    ),
  ],
  3: [
    QuranAyah(
      surahNumber: 3,
      ayahNumber: 159,
      arabic: 'فَبِمَا رَحْمَةٍ مِنَ اللّٰهِ لِنْتَ لَهُمْ',
      translation: 'It is out of الله’s mercy that you were gentle with them.',
      transliteration: 'Fabima rahmatin minallahi linta lahum',
    ),
    QuranAyah(
      surahNumber: 3,
      ayahNumber: 200,
      arabic: 'وَاتَّقُوا اللّٰهَ لَعَلَّكُمْ تُفْلِحُونَ',
      translation: 'Be mindful of الله, so that you may be successful.',
      transliteration: 'Wattaqullaha laallakum tuflihun',
    ),
  ],
  18: [
    QuranAyah(
      surahNumber: 18,
      ayahNumber: 10,
      arabic: 'رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً',
      translation: 'Our Lord, grant us mercy from Yourself.',
      transliteration: 'Rabbana atina min ladunka rahmah',
    ),
  ],
  55: [
    QuranAyah(
      surahNumber: 55,
      ayahNumber: 13,
      arabic: 'فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ',
      translation: 'So which of your Lord’s favors will you both deny?',
      transliteration: 'Fabi ayyi alaa-i rabbikuma tukaththiban',
    ),
  ],
  67: [
    QuranAyah(
      surahNumber: 67,
      ayahNumber: 15,
      arabic: 'هُوَ الَّذِي جَعَلَ لَكُمُ الْأَرْضَ ذَلُولًا',
      translation: 'He is the One Who made the earth manageable for you.',
      transliteration: 'Huwa alladhi jaala lakumu al-arda dhaloolan',
    ),
  ],
  94: [
    QuranAyah(
      surahNumber: 94,
      ayahNumber: 5,
      arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
      translation: 'Indeed, with hardship comes ease.',
      transliteration: 'Fa inna ma al-usri yusra',
    ),
    QuranAyah(
      surahNumber: 94,
      ayahNumber: 6,
      arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      translation: 'Surely, with hardship comes ease.',
      transliteration: 'Inna ma al-usri yusra',
    ),
  ],
  96: [
    QuranAyah(
      surahNumber: 96,
      ayahNumber: 1,
      arabic: 'اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
      translation: 'Read in the name of your Lord who created.',
      transliteration: 'Iqra bismi rabbika alladhi khalaq',
    ),
  ],
  112: [
    QuranAyah(
      surahNumber: 112,
      ayahNumber: 1,
      arabic: 'قُلْ هُوَ اللّٰهُ أَحَدٌ',
      translation: 'Say, He is الله, the One.',
      transliteration: 'Qul huwa Allahu ahad',
    ),
    QuranAyah(
      surahNumber: 112,
      ayahNumber: 2,
      arabic: 'اللّٰهُ الصَّمَدُ',
      translation: 'الله, the Eternal Refuge.',
      transliteration: 'Allahu as-samad',
    ),
  ],
  113: [
    QuranAyah(
      surahNumber: 113,
      ayahNumber: 1,
      arabic: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
      translation: 'Say: I seek refuge in the Lord of daybreak.',
      transliteration: 'Qul aoodhu birabbil falaq',
    ),
  ],
  114: [
    QuranAyah(
      surahNumber: 114,
      ayahNumber: 1,
      arabic: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
      translation: 'Say: I seek refuge in the Lord of mankind.',
      transliteration: 'Qul aoodhu birabbin nas',
    ),
  ],
};

const List<QuranDailyVerse> stagedDailyVersePool = [
  QuranDailyVerse(
    surahNumber: 2,
    ayahNumber: 45,
    arabic: 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
    translation: 'Seek help through patience and prayer.',
    transliteration: 'Wastaeenu bis-sabri was-salah',
    locationLabel: 'Al-Baqarah 2:45',
  ),
  QuranDailyVerse(
    surahNumber: 2,
    ayahNumber: 152,
    arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
    translation: 'Remember Me; I will remember you.',
    transliteration: 'Fadhkurooni adhkurkum',
    locationLabel: 'Al-Baqarah 2:152',
  ),
  QuranDailyVerse(
    surahNumber: 94,
    ayahNumber: 5,
    arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
    translation: 'Indeed, with hardship comes ease.',
    transliteration: 'Fa inna ma al-usri yusra',
    locationLabel: 'Ash-Sharh 94:5',
  ),
  QuranDailyVerse(
    surahNumber: 96,
    ayahNumber: 1,
    arabic: 'اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
    translation: 'Read in the name of your Lord who created.',
    transliteration: 'Iqra bismi rabbika alladhi khalaq',
    locationLabel: 'Al-Alaq 96:1',
  ),
  QuranDailyVerse(
    surahNumber: 3,
    ayahNumber: 159,
    arabic: 'فَبِمَا رَحْمَةٍ مِنَ اللّٰهِ لِنْتَ لَهُمْ',
    translation: 'It is out of الله’s mercy that you were gentle with them.',
    transliteration: 'Fabima rahmatin minallahi linta lahum',
    locationLabel: 'Ali Imran 3:159',
  ),
];

List<QuranAyah> stagedAyahsForSurah(int surahNumber) {
  return stagedAyahMap[surahNumber] ?? const [];
}

QuranSurah? stagedSurahByNumber(int surahNumber) {
  for (final surah in stagedSurahList) {
    if (surah.number == surahNumber) return surah;
  }
  return null;
}
