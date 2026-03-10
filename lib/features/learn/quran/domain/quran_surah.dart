class QuranSurah {
  const QuranSurah({
    required this.number,
    required this.arabicName,
    required this.transliteratedName,
    required this.englishName,
    required this.verseCount,
    required this.revelationPlace,
  });

  final int number;
  final String arabicName;
  final String transliteratedName;
  final String englishName;
  final int verseCount;
  final String revelationPlace;
}
