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
    DhikrPreset(
      id: 'subhanallahiWaBihamdihi',
      label: 'SubhanAllahi wa bihamdihi',
      phrase: 'سُبْحَانَ ٱللَّهِ وَبِحَمْدِهِ',
      transliteration: 'SubhanAllahi wa bihamdihi',
      translation: 'Glory be to الله and praise Him',
    ),
    DhikrPreset(
      id: 'laHawla',
      label: 'La hawla wa la quwwata illa billah',
      phrase: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِٱللَّهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      translation: 'There is no power nor strength except through الله',
    ),
    DhikrPreset(
      id: 'hasbunallah',
      label: 'Hasbunallahu wa ni\'mal wakil',
      phrase: 'حَسْبُنَا ٱللَّهُ وَنِعْمَ ٱلْوَكِيلُ',
      transliteration: 'Hasbunallahu wa ni\'mal wakil',
      translation:
          'الله is sufficient for us, and He is the best disposer of affairs',
    ),
  ];

  static DhikrPreset? byId(String id) {
    for (final preset in defaults) {
      if (preset.id == id) return preset;
    }
    return null;
  }
}
