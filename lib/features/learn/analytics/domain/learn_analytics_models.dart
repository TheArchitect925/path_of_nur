enum LearnAnalyticsAudience { beginner, general, kids }

enum LearnAnalyticsQueryKind {
  empty,
  quran,
  salah,
  dhikr,
  stories,
  character,
  kids,
  games,
  foundations,
  general,
}

class LearnAnalyticsEventRecord {
  const LearnAnalyticsEventRecord({
    required this.name,
    required this.at,
    required this.metadata,
  });

  final String name;
  final DateTime at;
  final Map<String, Object?> metadata;
}

class LearnAnalyticsSummary {
  const LearnAnalyticsSummary({
    required this.totalEvents,
    required this.pathStartsById,
    required this.pathCompletionsById,
    required this.pathStepCompletionsByPathId,
    required this.legacyRouteHitsByRoute,
    required this.aliasHitsByRoute,
    required this.searchQueriesByKind,
    required this.searchResultOpensByType,
    required this.recommendedActionOpens,
    required this.recommendedPathStarts,
    required this.exploreSectionOpensBySection,
  });

  final int totalEvents;
  final Map<String, int> pathStartsById;
  final Map<String, int> pathCompletionsById;
  final Map<String, int> pathStepCompletionsByPathId;
  final Map<String, int> legacyRouteHitsByRoute;
  final Map<String, int> aliasHitsByRoute;
  final Map<String, int> searchQueriesByKind;
  final Map<String, int> searchResultOpensByType;
  final int recommendedActionOpens;
  final int recommendedPathStarts;
  final Map<String, int> exploreSectionOpensBySection;
}

class LearnRetirementCandidateSignal {
  const LearnRetirementCandidateSignal({
    required this.routeKey,
    required this.aliasHitsLast30Days,
    required this.directLegacyOpensLast30Days,
    required this.safeToReviewForRetirement,
  });

  final String routeKey;
  final int aliasHitsLast30Days;
  final int directLegacyOpensLast30Days;
  final bool safeToReviewForRetirement;
}
