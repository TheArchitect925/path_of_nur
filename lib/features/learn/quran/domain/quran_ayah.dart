class QuranAyah {
  const QuranAyah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabic,
    required this.translation,
    this.transliteration,
  });

  final int surahNumber;
  final int ayahNumber;
  final String arabic;
  final String translation;
  final String? transliteration;
}
