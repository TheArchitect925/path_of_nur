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
      translation: 'Glory be to Allah',
    ),
    DhikrPreset(
      id: 'alhamdulillah',
      label: 'Alhamdulillah',
      phrase: 'ٱلْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      translation: 'All praise is for Allah',
    ),
    DhikrPreset(
      id: 'allahukbar',
      label: 'Allahu Akbar',
      phrase: 'ٱللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      translation: 'Allah is Most Great',
    ),
    DhikrPreset(
      id: 'astaghfirullah',
      label: 'Astaghfirullah',
      phrase: 'أَسْتَغْفِرُ ٱللَّهَ',
      transliteration: 'Astaghfirullah',
      translation: 'I seek forgiveness from Allah',
    ),
    DhikrPreset(
      id: 'laIlaha',
      label: 'La ilaha illAllah',
      phrase: 'لَا إِلَهَ إِلَّا ٱللَّهُ',
      transliteration: 'La ilaha illAllah',
      translation: 'There is no god except Allah',
    ),
    DhikrPreset(
      id: 'salawat',
      label: 'Salawat',
      phrase: 'ٱللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ',
      transliteration: 'Allahumma salli ala Muhammad',
      translation: 'O Allah, send blessings upon Muhammad',
    ),
    DhikrPreset(
      id: 'subhanallahiWaBihamdihi',
      label: 'SubhanAllahi wa bihamdihi',
      phrase: 'سُبْحَانَ ٱللَّهِ وَبِحَمْدِهِ',
      transliteration: 'SubhanAllahi wa bihamdihi',
      translation: 'Glory be to Allah and praise Him',
    ),
    DhikrPreset(
      id: 'laHawla',
      label: 'La hawla wa la quwwata illa billah',
      phrase: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِٱللَّهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      translation: 'There is no power nor strength except through Allah',
    ),
    DhikrPreset(
      id: 'hasbunallah',
      // The label keys the phrase's lifetime total (dhikr_phrase_totals).
      label:
          'Hasbunallahu wa ni\'mal wakil', // copy-lint: allow prose-apostrophe
      phrase: 'حَسْبُنَا ٱللَّهُ وَنِعْمَ ٱلْوَكِيلُ',
      transliteration: 'Hasbunallahu wa ni\'mal wakil',
      translation:
          'Allah is sufficient for us, and He is the best disposer of affairs',
    ),
  ];

  static DhikrPreset? byId(String id) {
    for (final preset in defaults) {
      if (preset.id == id) return preset;
    }
    return null;
  }
}
