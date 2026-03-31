enum QuranHubRecommendationSource {
  path,
  recent,
  intent,
  daily,
  time,
  friday,
  related,
  fallback,
}

enum QuranHubRecommendationType {
  resumePathway,
  continueSurah,
  themeSuggestion,
  pathwaySuggestion,
  reflectionPrompt,
  timeOfDayPick,
  fridayPick,
  relatedFollowUp,
  growthFocusPick,
}

enum QuranHubRecommendationDestinationType {
  surahDetail,
  themeDetail,
  pathwayDetail,
  readerEntry,
  dailyCompanion,
  pathwayLanding,
  themeLanding,
}

enum QuranHubRecommendationReason {
  continueWhereLeftOff,
  forThisMorning,
  forThisAfternoon,
  forThisEvening,
  forTonight,
  basedOnRecentReading,
  basedOnGrowthFocus,
  fridayReflection,
  connectedToYourJourney,
  keepMomentum,
  startHere,
}

enum QuranHubTimeSegment { morning, afternoon, evening, night }

class QuranHubContextSnapshot {
  const QuranHubContextSnapshot({
    required this.now,
    required this.timeSegment,
    required this.isFriday,
    required this.readingStreak,
    required this.readingTimeTodaySeconds,
    required this.listeningTimeTodaySeconds,
    this.selectedIntentWireName,
    this.continueSurahNumber,
    this.continueAyahNumber,
    this.activePathId,
    this.dailyThemeId,
    this.recentSurahNumbers = const <int>[],
    this.recentThemeIds = const <String>[],
    this.recentPathIds = const <String>[],
  });

  final DateTime now;
  final QuranHubTimeSegment timeSegment;
  final bool isFriday;
  final int readingStreak;
  final int readingTimeTodaySeconds;
  final int listeningTimeTodaySeconds;
  final String? selectedIntentWireName;
  final int? continueSurahNumber;
  final int? continueAyahNumber;
  final String? activePathId;
  final String? dailyThemeId;
  final List<int> recentSurahNumbers;
  final List<String> recentThemeIds;
  final List<String> recentPathIds;

  bool get hasActivity =>
      (continueAyahNumber ?? 0) > 1 ||
      recentSurahNumbers.isNotEmpty ||
      recentThemeIds.isNotEmpty ||
      recentPathIds.isNotEmpty ||
      (readingTimeTodaySeconds > 0) ||
      (listeningTimeTodaySeconds > 0) ||
      (readingStreak > 0);
}

class QuranHubRecommendation {
  const QuranHubRecommendation({
    required this.id,
    required this.type,
    required this.source,
    required this.reason,
    required this.destinationType,
    required this.priority,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.surahNumber,
    this.ayahNumber,
    this.topicId,
    this.pathId,
    this.progressCompleted,
    this.progressTotal,
    this.isPrimary = false,
  });

  final String id;
  final QuranHubRecommendationType type;
  final QuranHubRecommendationSource source;
  final QuranHubRecommendationReason reason;
  final QuranHubRecommendationDestinationType destinationType;
  final int priority;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final int? surahNumber;
  final int? ayahNumber;
  final String? topicId;
  final String? pathId;
  final int? progressCompleted;
  final int? progressTotal;
  final bool isPrimary;

  bool get showsProgress =>
      progressCompleted != null &&
      progressTotal != null &&
      progressTotal! > 0 &&
      progressCompleted! >= 0;

  double get progressRatio {
    if (!showsProgress) return 0;
    return (progressCompleted! / progressTotal!).clamp(0.0, 1.0);
  }

  String get routeKey {
    final pathPart = pathParameters.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    final queryPart = queryParameters.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    return '$routeName|$pathPart|$queryPart';
  }
}
