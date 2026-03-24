enum QuranHubRecommendationType {
  continuePath,
  dailyReflection,
  reviewMemorization,
  continueSurah,
  exploreTheme,
  journeyLinkedStudy,
}

enum QuranHubRecommendationSource {
  path,
  daily,
  review,
  recent,
  intent,
  journey,
  fallback,
}

class QuranHubRecommendation {
  const QuranHubRecommendation({
    required this.id,
    required this.type,
    required this.source,
    required this.priority,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.pathId,
    this.topicId,
    this.journeyId,
    this.stageId,
    this.surahNumber,
    this.ayahNumber,
    this.dueCount,
    this.isFallback = false,
  });

  final String id;
  final QuranHubRecommendationType type;
  final QuranHubRecommendationSource source;
  final int priority;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final String? pathId;
  final String? topicId;
  final String? journeyId;
  final String? stageId;
  final int? surahNumber;
  final int? ayahNumber;
  final int? dueCount;
  final bool isFallback;

  String get routeKey {
    final path = pathParameters.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
    final query = queryParameters.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
    return '$routeName|$path|$query';
  }
}
