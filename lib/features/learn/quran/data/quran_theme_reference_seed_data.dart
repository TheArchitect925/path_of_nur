class QuranThemeReferenceSeed {
  const QuranThemeReferenceSeed({
    required this.referenceLabel,
    required this.surahNumber,
    required this.ayahStart,
    required this.ayahEnd,
    required this.contextSummary,
    required this.importanceScore,
    required this.topicTags,
    this.surahName,
    this.relatedProphetIds = const <String>[],
    this.relatedLessonIds = const <String>[],
    this.relatedHadithIds = const <String>[],
    this.relatedJourneyIds = const <String>[],
    this.keywords = const <String>[],
  });

  final String referenceLabel;
  final int surahNumber;
  final int ayahStart;
  final int ayahEnd;
  final String contextSummary;
  final int importanceScore;
  final List<String> topicTags;
  final String? surahName;
  final List<String> relatedProphetIds;
  final List<String> relatedLessonIds;
  final List<String> relatedHadithIds;
  final List<String> relatedJourneyIds;
  final List<String> keywords;

  String get id => 'qr_${surahNumber}_${ayahStart}_$ayahEnd';
}

const List<QuranThemeReferenceSeed> quranThemeReferenceSeeds = [
  QuranThemeReferenceSeed(
    referenceLabel: '2:152',
    surahNumber: 2,
    ayahStart: 152,
    ayahEnd: 152,
    contextSummary:
        'Remembrance and gratitude are joined here so the remembering heart does not become heedless or ungrateful.',
    importanceScore: 88,
    topicTags: ['gratitude', 'remembrance'],
    keywords: ['dhikr', 'gratitude', 'shukr'],
  ),
  QuranThemeReferenceSeed(
    referenceLabel: '11:3',
    surahNumber: 11,
    ayahStart: 3,
    ayahEnd: 3,
    contextSummary:
        'Repentance here is a real return to Allah marked by forgiveness, hope, and renewed obedience.',
    importanceScore: 89,
    topicTags: ['repentance', 'hope', 'mercy'],
    keywords: ['tawbah', 'forgiveness', 'return'],
  ),
  QuranThemeReferenceSeed(
    referenceLabel: '17:23',
    surahNumber: 17,
    ayahStart: 23,
    ayahEnd: 24,
    contextSummary:
        'Family responsibility begins with restraint, honor, and mercy toward parents in everyday speech and conduct.',
    importanceScore: 90,
    topicTags: ['family', 'mercy', 'guidance'],
    relatedLessonIds: ['family-honoring-parents'],
    keywords: ['parents', 'family', 'honor', 'care'],
  ),
  QuranThemeReferenceSeed(
    referenceLabel: '25:62',
    surahNumber: 25,
    ayahStart: 62,
    ayahEnd: 62,
    contextSummary:
        'The alternation of night and day is presented as a sign for remembrance and gratitude, not only observation.',
    importanceScore: 82,
    topicTags: ['remembrance', 'gratitude', 'creation'],
    keywords: ['night', 'day', 'dhikr', 'gratitude'],
  ),
  QuranThemeReferenceSeed(
    referenceLabel: '33:3',
    surahNumber: 33,
    ayahStart: 3,
    ayahEnd: 3,
    contextSummary:
        'Reliance is placed after obedience so tawakkul steadies the heart after sincere effort rather than replacing action.',
    importanceScore: 90,
    topicTags: ['trust-in-allah', 'guidance'],
    keywords: ['tawakkul', 'reliance', 'obedience'],
  ),
  QuranThemeReferenceSeed(
    referenceLabel: '39:11',
    surahNumber: 39,
    ayahStart: 11,
    ayahEnd: 11,
    contextSummary:
        'Sincerity is presented as foundational worship, directing devotion to Allah without divided intention.',
    importanceScore: 88,
    topicTags: ['sincerity', 'faith', 'guidance'],
    keywords: ['ikhlas', 'intention', 'worship'],
  ),
  QuranThemeReferenceSeed(
    referenceLabel: '42:43',
    surahNumber: 42,
    ayahStart: 43,
    ayahEnd: 43,
    contextSummary:
        'Restraint and forgiveness are shown here as signs of real resolve, linking patience to moral steadiness.',
    importanceScore: 86,
    topicTags: ['patience', 'mercy', 'forgiveness'],
    relatedLessonIds: ['community-reconciling-hearts'],
    keywords: ['forgiveness', 'restraint', 'sabr'],
  ),
  QuranThemeReferenceSeed(
    referenceLabel: '98:5',
    surahNumber: 98,
    ayahStart: 5,
    ayahEnd: 5,
    contextSummary:
        'The ayah centers worship on sincere devotion, showing that outward action without ikhlas is incomplete.',
    importanceScore: 92,
    topicTags: ['sincerity', 'worship', 'guidance'],
    relatedHadithIds: ['intentions_core', 'religion_sincerity'],
    keywords: ['ikhlas', 'sincerity', 'devotion'],
  ),
  QuranThemeReferenceSeed(
    referenceLabel: '3:200',
    surahNumber: 3,
    ayahStart: 200,
    ayahEnd: 200,
    contextSummary:
        'Believers are called here to patient endurance, resilience, and God-conscious steadiness instead of collapse under pressure.',
    importanceScore: 91,
    topicTags: ['patience', 'guidance'],
    keywords: ['sabr', 'steadfastness', 'resilience'],
  ),
];
