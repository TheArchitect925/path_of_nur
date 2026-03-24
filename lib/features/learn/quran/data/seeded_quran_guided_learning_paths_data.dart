import '../domain/quran_guided_learning_path_models.dart';

const List<QuranGuidedLearningPath> seededQuranGuidedLearningPaths = [
  QuranGuidedLearningPath(
    id: 'beginner-understanding',
    type: QuranGuidedLearningPathType.beginnerUnderstanding,
    intensity: QuranGuidedLearningPathIntensity.gentle,
    surahNumber: 1,
    ayahNumber: 5,
    steps: [
      QuranGuidedLearningPathStep(
        id: 'beginner-open-fatihah',
        kind: QuranGuidedLearningStepKind.reader,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '1'},
        queryParameters: {'ayah': '5', 'mode': 'reading'},
      ),
      QuranGuidedLearningPathStep(
        id: 'beginner-reflect-on-fatihah',
        kind: QuranGuidedLearningStepKind.reader,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '1'},
        queryParameters: {'ayah': '5', 'mode': 'reflection'},
      ),
      QuranGuidedLearningPathStep(
        id: 'beginner-follow-foundations',
        kind: QuranGuidedLearningStepKind.ownerSurface,
        routeName: 'quranAyahInsightsPathDetail',
        pathParameters: {'pathId': 'tawhid-belief-starter'},
      ),
    ],
  ),
  QuranGuidedLearningPath(
    id: 'theme-study-gratitude',
    type: QuranGuidedLearningPathType.themeStudy,
    intensity: QuranGuidedLearningPathIntensity.guided,
    themeId: 'gratitude',
    surahNumber: 55,
    ayahNumber: 13,
    steps: [
      QuranGuidedLearningPathStep(
        id: 'theme-open-gratitude-map',
        kind: QuranGuidedLearningStepKind.thematicMap,
        routeName: 'quranTopicDetail',
        pathParameters: {'topicId': 'gratitude'},
      ),
      QuranGuidedLearningPathStep(
        id: 'theme-read-ar-rahman',
        kind: QuranGuidedLearningStepKind.reader,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '55'},
        queryParameters: {
          'ayah': '13',
          'topicId': 'gratitude',
          'mode': 'theme',
        },
      ),
      QuranGuidedLearningPathStep(
        id: 'theme-open-character-gratitude',
        kind: QuranGuidedLearningStepKind.ownerSurface,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'gratitude'},
      ),
    ],
  ),
  QuranGuidedLearningPath(
    id: 'memorization-support',
    type: QuranGuidedLearningPathType.memorizationSupport,
    intensity: QuranGuidedLearningPathIntensity.guided,
    themeId: 'patience',
    surahNumber: 2,
    ayahNumber: 153,
    steps: [
      QuranGuidedLearningPathStep(
        id: 'memorization-open-review',
        kind: QuranGuidedLearningStepKind.memorizationReview,
        routeName: 'quranMemorizationReview',
      ),
      QuranGuidedLearningPathStep(
        id: 'memorization-study-anchor-ayah',
        kind: QuranGuidedLearningStepKind.reader,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '2'},
        queryParameters: {
          'ayah': '153',
          'topicId': 'patience',
          'review': 'memorization',
          'mode': 'memorization',
        },
      ),
      QuranGuidedLearningPathStep(
        id: 'memorization-open-patience-theme',
        kind: QuranGuidedLearningStepKind.thematicMap,
        routeName: 'quranTopicDetail',
        pathParameters: {'topicId': 'patience'},
      ),
    ],
  ),
  QuranGuidedLearningPath(
    id: 'reflection-journey',
    type: QuranGuidedLearningPathType.reflectionJourney,
    intensity: QuranGuidedLearningPathIntensity.gentle,
    themeId: 'repentance',
    surahNumber: 39,
    ayahNumber: 53,
    steps: [
      QuranGuidedLearningPathStep(
        id: 'reflection-open-ayah',
        kind: QuranGuidedLearningStepKind.reader,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '39'},
        queryParameters: {'ayah': '53', 'mode': 'reflection'},
      ),
      QuranGuidedLearningPathStep(
        id: 'reflection-open-saved-reflections',
        kind: QuranGuidedLearningStepKind.reflections,
        routeName: 'quranReflections',
      ),
      QuranGuidedLearningPathStep(
        id: 'reflection-open-daily-wisdom',
        kind: QuranGuidedLearningStepKind.ownerSurface,
        routeName: 'learnDailyWisdomCompanion',
      ),
    ],
  ),
  QuranGuidedLearningPath(
    id: 'surah-study-starter',
    type: QuranGuidedLearningPathType.surahStudy,
    intensity: QuranGuidedLearningPathIntensity.deeper,
    surahNumber: 31,
    ayahNumber: 12,
    themeId: 'family',
    steps: [
      QuranGuidedLearningPathStep(
        id: 'surah-open-insight',
        kind: QuranGuidedLearningStepKind.surahInsights,
        routeName: 'quranSurahInsights',
        pathParameters: {'surahNumber': '31'},
      ),
      QuranGuidedLearningPathStep(
        id: 'surah-open-reader-study',
        kind: QuranGuidedLearningStepKind.reader,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '31'},
        queryParameters: {'ayah': '12', 'mode': 'study', 'topicId': 'family'},
      ),
      QuranGuidedLearningPathStep(
        id: 'surah-open-family-character',
        kind: QuranGuidedLearningStepKind.ownerSurface,
        routeName: 'learnCharacterCompanion',
        queryParameters: {'focus': 'family'},
      ),
    ],
  ),
];
