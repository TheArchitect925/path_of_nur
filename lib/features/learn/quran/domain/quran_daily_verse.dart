class QuranDailyVerse {
  const QuranDailyVerse({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabic,
    required this.translation,
    required this.transliteration,
    required this.locationLabel,
  });

  final int surahNumber;
  final int ayahNumber;
  final String arabic;
  final String translation;
  final String transliteration;
  final String locationLabel;
}
