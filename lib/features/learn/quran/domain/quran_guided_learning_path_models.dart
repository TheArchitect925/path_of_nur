enum QuranGuidedLearningPathType {
  beginnerUnderstanding,
  themeStudy,
  memorizationSupport,
  reflectionJourney,
  surahStudy,
}

enum QuranGuidedLearningPathIntensity { gentle, guided, deeper }

enum QuranGuidedLearningStepKind {
  reader,
  thematicMap,
  memorizationReview,
  reflections,
  surahInsights,
  ownerSurface,
}

class QuranGuidedLearningPathStep {
  const QuranGuidedLearningPathStep({
    required this.id,
    required this.kind,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String id;
  final QuranGuidedLearningStepKind kind;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class QuranGuidedLearningPath {
  const QuranGuidedLearningPath({
    required this.id,
    required this.type,
    required this.intensity,
    required this.steps,
    this.themeId,
    this.surahNumber,
    this.ayahNumber,
  });

  final String id;
  final QuranGuidedLearningPathType type;
  final QuranGuidedLearningPathIntensity intensity;
  final List<QuranGuidedLearningPathStep> steps;
  final String? themeId;
  final int? surahNumber;
  final int? ayahNumber;
}
