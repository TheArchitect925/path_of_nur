import '../domain/quran_reference_models.dart';

class QuranTopicSeed {
  const QuranTopicSeed({
    required this.id,
    required this.title,
    required this.description,
    this.primaryReferenceLabel,
    required this.referenceLabels,
    this.suggestedReaderMode = QuranReaderStudyMode.theme,
    this.suggestedPathId,
    required this.relatedSurahNumbers,
    required this.relatedRoutes,
    this.searchKeywords = const <String>[],
  });

  final String id;
  final String title;
  final String description;
  final String? primaryReferenceLabel;
  final List<String> referenceLabels;
  final QuranReaderStudyMode suggestedReaderMode;
  final String? suggestedPathId;
  final List<int> relatedSurahNumbers;
  final List<QuranTopicRouteTarget> relatedRoutes;
  final List<String> searchKeywords;

  String? get resolvedPrimaryReferenceLabel {
    final explicit = primaryReferenceLabel?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      return explicit;
    }
    if (referenceLabels.isEmpty) {
      return null;
    }
    return referenceLabels.first;
  }
}

const List<QuranTopicSeed> quranThematicTopicSeeds = [
  QuranTopicSeed(
    id: 'patience',
    title: 'Patience',
    description:
        'Begin with verses that connect hardship to prayer, trust, and a steadier response.',
    primaryReferenceLabel: '2:153',
    referenceLabels: ['2:153', '3:200', '12:87', '42:43', '94:5-6'],
    suggestedReaderMode: QuranReaderStudyMode.study,
    suggestedPathId: 'memorization-support',
    relatedSurahNumbers: [2, 12],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.characterCompanion,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'sabr'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.hadith,
        routeName: 'learnHadithLanding',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.guidedPath,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': 'memorization-support'},
      ),
    ],
    searchKeywords: ['sabr', 'hardship', 'steadfastness', 'trial'],
  ),
  QuranTopicSeed(
    id: 'gratitude',
    title: 'Gratitude',
    description:
        'Follow verses that teach thankfulness as worship, wisdom, and a way of using blessings well.',
    primaryReferenceLabel: '14:7',
    referenceLabels: ['14:7', '31:12', '2:152', '25:62'],
    suggestedReaderMode: QuranReaderStudyMode.reflection,
    suggestedPathId: 'theme-study-gratitude',
    relatedSurahNumbers: [14, 31],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.characterCompanion,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'shukr'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.dailyWisdomCompanion,
        routeName: 'learnDailyWisdomCompanion',
        queryParameters: {'focus': 'gratitude'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.world,
        routeName: 'learnWorldLanding',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.guidedPath,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': 'theme-study-gratitude'},
      ),
    ],
    searchKeywords: ['shukr', 'thankfulness', 'blessings'],
  ),
  QuranTopicSeed(
    id: 'mercy',
    title: 'Mercy',
    description:
        'Explore mercy through gentleness, reconciliation, and the way believers carry other people’s weakness.',
    primaryReferenceLabel: '3:159',
    referenceLabels: ['3:159', '17:23', '25:63', '39:53', '41:34'],
    suggestedReaderMode: QuranReaderStudyMode.reflection,
    relatedSurahNumbers: [3, 25],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.characterCompanion,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'kindness'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.hadith,
        routeName: 'learnHadithLanding',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.dailyWisdomCompanion,
        routeName: 'learnDailyWisdomCompanion',
        queryParameters: {'focus': 'mercy'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.seerahCompanion,
        routeName: 'learnSeerahCompanion',
      ),
    ],
    searchKeywords: ['gentleness', 'reconciliation', 'rahmah'],
  ),
  QuranTopicSeed(
    id: 'family',
    title: 'Family',
    description:
        'Start with verses that place family responsibility, care, and counsel inside the life of faith.',
    primaryReferenceLabel: '17:23',
    referenceLabels: ['17:23', '16:90', '31:18'],
    suggestedReaderMode: QuranReaderStudyMode.study,
    suggestedPathId: 'surah-study-starter',
    relatedSurahNumbers: [17, 31],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.life,
        routeName: 'learnLifeLanding',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.characterCompanion,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'family'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.guidedPath,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': 'surah-study-starter'},
      ),
    ],
    searchKeywords: ['parents', 'home', 'relations', 'care'],
  ),
  QuranTopicSeed(
    id: 'akhirah',
    title: 'Akhirah',
    description:
        'Study accountability, return, and the way the Hereafter reshapes urgency, hope, and moral seriousness.',
    referenceLabels: ['67:2', '99:7-8', '39:53'],
    relatedSurahNumbers: [67, 99, 39],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.ayahInsightsDomain,
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'akhirah-accountability'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.surahInsights,
        routeName: 'quranSurahInsightsBrowse',
      ),
    ],
    searchKeywords: ['hereafter', 'accountability', 'return', 'death'],
  ),
  QuranTopicSeed(
    id: 'signs-in-creation',
    title: 'Signs in Creation',
    description:
        'Gather verses that turn the natural world into reflection, remembrance, and clearer awareness of Allah’s wisdom.',
    referenceLabels: ['3:190-191', '67:2'],
    relatedSurahNumbers: [3, 67],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.world,
        routeName: 'learnWorldLanding',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.ayahInsightsDomain,
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'signs-in-creation'},
      ),
    ],
    searchKeywords: ['creation', 'nature', 'world', 'signs'],
  ),
  QuranTopicSeed(
    id: 'prophets',
    title: 'Prophets',
    description:
        'Use prophetic examples to see how revelation becomes lived patience, da’wah, reliance, and leadership.',
    referenceLabels: ['12:87', '20:14', '3:159'],
    relatedSurahNumbers: [12, 20, 3],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.prophets,
        routeName: 'learnProphetsHub',
        queryParameters: {'tab': 'stories'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.seerahCompanion,
        routeName: 'learnSeerahCompanion',
      ),
    ],
    searchKeywords: ['stories', 'musa', 'yusuf', 'muhammad'],
  ),
  QuranTopicSeed(
    id: 'trust-in-allah',
    title: 'Trust in Allah',
    description:
        'Begin with verses where reliance on Allah appears together with effort, consultation, and patient action.',
    primaryReferenceLabel: '65:3',
    referenceLabels: ['65:3', '33:3', '3:159', '12:87'],
    suggestedReaderMode: QuranReaderStudyMode.study,
    relatedSurahNumbers: [3, 65],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.ayahInsightsDomain,
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'guidance-daily-life'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.characterCompanion,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'sabr'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.seerahCompanion,
        routeName: 'learnSeerahCompanion',
      ),
    ],
    searchKeywords: ['tawakkul', 'reliance', 'dependence'],
  ),
  QuranTopicSeed(
    id: 'repentance',
    title: 'Repentance',
    description:
        'Follow verses that keep the door of return open through hope, reform, and renewed obedience.',
    primaryReferenceLabel: '39:53',
    referenceLabels: ['39:53', '11:3', '66:8'],
    suggestedReaderMode: QuranReaderStudyMode.reflection,
    suggestedPathId: 'reflection-journey',
    relatedSurahNumbers: [39, 66],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.ayahInsightsDomain,
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'akhirah-accountability'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.hadith,
        routeName: 'learnHadithLanding',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.dailyWisdomCompanion,
        routeName: 'learnDailyWisdomCompanion',
        queryParameters: {'focus': 'forgiveness'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.guidedPath,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': 'reflection-journey'},
      ),
    ],
    searchKeywords: ['tawbah', 'return', 'forgiveness', 'hope'],
  ),
  QuranTopicSeed(
    id: 'remembrance',
    title: 'Remembrance',
    description:
        'Trace how dhikr steadies the heart, shapes action, and keeps revelation close during ordinary life.',
    primaryReferenceLabel: '13:28',
    referenceLabels: ['13:28', '20:14', '2:152', '25:62', '3:190-191'],
    suggestedReaderMode: QuranReaderStudyMode.reflection,
    suggestedPathId: 'reflection-journey',
    relatedSurahNumbers: [13, 20],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.ayahInsightsDomain,
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'worship-remembrance'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.dailyWisdomCompanion,
        routeName: 'learnDailyWisdomCompanion',
        queryParameters: {'focus': 'remembrance'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.memorizationReview,
        routeName: 'quranMemorizationReview',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.guidedPath,
        routeName: 'quranLearningPathDetail',
        pathParameters: {'pathId': 'reflection-journey'},
      ),
    ],
    searchKeywords: ['dhikr', 'heart', 'remembering allah'],
  ),
  QuranTopicSeed(
    id: 'sincerity',
    title: 'Sincerity',
    description:
        'Study ayahs that purify worship, intention, and inward devotion so acts belong to Allah alone.',
    primaryReferenceLabel: '98:5',
    referenceLabels: ['98:5', '39:11', '1:5', '67:2'],
    suggestedReaderMode: QuranReaderStudyMode.study,
    relatedSurahNumbers: [1, 39, 67, 98],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.characterCompanion,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'intentions'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.hadith,
        routeName: 'learnHadithLanding',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.dailyCompanion,
        routeName: 'quranDailyCompanion',
      ),
    ],
    searchKeywords: ['ikhlas', 'intention', 'devotion', 'worship'],
  ),
  QuranTopicSeed(
    id: 'prayer',
    title: 'Prayer',
    description:
        'Start with verses that show salah as protection, help in hardship, and an anchor between revelation and daily conduct.',
    referenceLabels: ['2:153', '20:14', '29:45'],
    relatedSurahNumbers: [2, 20, 29],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.ayahInsightsDomain,
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'worship-remembrance'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.ayahInsightPath,
        routeName: 'quranAyahInsightsPathDetail',
        pathParameters: {'pathId': 'worship-remembrance-starter'},
      ),
    ],
    searchKeywords: ['salah', 'prayer', 'worship'],
  ),
  QuranTopicSeed(
    id: 'charity',
    title: 'Charity',
    description:
        'Gather verses that frame spending as sincerity, sacrifice, and care for people in need.',
    referenceLabels: ['2:271', '3:92'],
    relatedSurahNumbers: [2, 3],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.life,
        routeName: 'learnLifeLanding',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.hadith,
        routeName: 'learnHadithLanding',
      ),
    ],
    searchKeywords: ['sadaqah', 'giving', 'spending'],
  ),
  QuranTopicSeed(
    id: 'justice',
    title: 'Justice',
    description:
        'Study fairness, truthful witness, and moral steadiness where pressure could easily push a believer off course.',
    referenceLabels: ['16:90', '4:135', '5:8'],
    relatedSurahNumbers: [16, 4, 5],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.characterCompanion,
        routeName: 'learnCharacterCompanion',
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.hadith,
        routeName: 'learnHadithLanding',
      ),
    ],
    searchKeywords: ['fairness', 'witness', 'truth'],
  ),
  QuranTopicSeed(
    id: 'humility',
    title: 'Humility',
    description:
        'Begin with verses that teach lowliness before Allah and gentleness in conduct with people.',
    referenceLabels: ['25:63', '31:18', '91:9-10'],
    relatedSurahNumbers: [25, 31],
    relatedRoutes: [
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.characterCompanion,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'humility'},
      ),
      QuranTopicRouteTarget(
        kind: QuranTopicRouteKind.hadith,
        routeName: 'learnHadithLanding',
      ),
    ],
    searchKeywords: ['ego', 'gentleness', 'self-accounting'],
  ),
];
