class DhikrPreset {
  const DhikrPreset({
    required this.id,
    required this.label,
    required this.phrase,
    required this.transliteration,
    required this.translation,
  });

  final String id;
  final String label;
  final String phrase;
  final String transliteration;
  final String translation;

  static const List<DhikrPreset> defaults = [
    DhikrPreset(
      id: 'subhanallah',
      label: 'SubhanAllah',
      phrase: 'سُبْحَانَ ٱللَّهِ',
      transliteration: 'SubhanAllah',
      translation: 'Glory be to الله',
    ),
    DhikrPreset(
      id: 'alhamdulillah',
      label: 'Alhamdulillah',
      phrase: 'ٱلْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      translation: 'All praise is for الله',
    ),
    DhikrPreset(
      id: 'allahukbar',
      label: 'Allahu Akbar',
      phrase: 'ٱللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      translation: 'الله is Most Great',
    ),
    DhikrPreset(
      id: 'astaghfirullah',
      label: 'Astaghfirullah',
      phrase: 'أَسْتَغْفِرُ ٱللَّهَ',
      transliteration: 'Astaghfirullah',
      translation: 'I seek forgiveness from الله',
    ),
    DhikrPreset(
      id: 'laIlaha',
      label: 'La ilaha illAllah',
      phrase: 'لَا إِلَهَ إِلَّا ٱللَّهُ',
      transliteration: 'La ilaha illAllah',
      translation: 'There is no god except الله',
    ),
    DhikrPreset(
      id: 'salawat',
      label: 'Salawat',
      phrase: 'ٱللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ',
      transliteration: 'Allahumma salli ala Muhammad',
      translation: 'O الله, send blessings upon Muhammad',
    ),
  ];
}
