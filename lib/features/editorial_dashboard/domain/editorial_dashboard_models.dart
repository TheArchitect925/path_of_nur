enum EditorialDashboardDomain {
  quran,
  hadith,
  stories,
  duasDhikr,
  learningPaths,
  kidsContent,
  actionsDrops,
  recommendations,
  localization,
}

enum EditorialDashboardItemType {
  system,
  coverage,
  pack,
  collection,
  contentSet,
  journeySet,
  pathSet,
  actionSet,
  engine,
  localeSet,
}

enum EditorialDashboardItemStatus { draft, partial, reviewed, verified, info }

enum EditorialDashboardMetricType {
  entries,
  total,
  covered,
  missing,
  reviewed,
  verified,
  kidsReady,
  localized,
  routes,
  completed,
  sessions,
  deep,
}

enum EditorialPriorityLevel { critical, high, medium, low }

enum EditorialReadinessState {
  notStarted,
  draft,
  reviewed,
  verified,
  launchReady,
  needsRevision,
}

enum EditorialIssueCode {
  missingContent,
  missingKids,
  missingSourceRef,
  missingLocalization,
  needsReview,
  draftOnly,
  incompleteRouteMetadata,
  weakPackCoverage,
  missingActionMapping,
  missingRecommendationTags,
  lowCoverage,
  staleContent,
  infoOnly,
}

enum EditorialTriageCategory {
  criticalIssues,
  needsReview,
  kidsSafetyGaps,
  missingLocalization,
  missingSourceMetadata,
  incompleteContentPacks,
  lowQuality,
  readyForVerification,
  recentlyUpdated,
  staleContent,
}

enum EditorialScoreBand { excellent, healthy, weak }

class EditorialDashboardMetric {
  const EditorialDashboardMetric({required this.type, required this.value});

  final EditorialDashboardMetricType type;
  final int value;
}

class EditorialDashboardItem {
  const EditorialDashboardItem({
    required this.domain,
    required this.id,
    required this.type,
    required this.status,
    this.metrics = const <EditorialDashboardMetric>[],
    this.kidsSafe = false,
    this.kidsExpected = false,
    this.hasSources = false,
    this.sourcesExpected = false,
    this.localizationReady = true,
    this.localizationExpected = true,
    this.missingContent = false,
    this.needsReview = false,
    this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.notes = const <String>[],
    this.searchKeywords = const <String>[],
    this.packId,
    this.lastUpdatedIso,
  });

  final EditorialDashboardDomain domain;
  final String id;
  final EditorialDashboardItemType type;
  final EditorialDashboardItemStatus status;
  final List<EditorialDashboardMetric> metrics;
  final bool kidsSafe;
  final bool kidsExpected;
  final bool hasSources;
  final bool sourcesExpected;
  final bool localizationReady;
  final bool localizationExpected;
  final bool missingContent;
  final bool needsReview;
  final String? routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final List<String> notes;
  final List<String> searchKeywords;
  final String? packId;
  final String? lastUpdatedIso;

  int metricValue(EditorialDashboardMetricType type) {
    for (final metric in metrics) {
      if (metric.type == type) return metric.value;
    }
    return 0;
  }

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return <String>[
      id,
      domain.name,
      type.name,
      status.name,
      packId ?? '',
      ...notes,
      ...searchKeywords,
    ].any((value) => value.toLowerCase().contains(normalized));
  }
}

class EditorialDashboardDomainSection {
  const EditorialDashboardDomainSection({
    required this.domain,
    required this.items,
  });

  final EditorialDashboardDomain domain;
  final List<EditorialDashboardItem> items;

  int get itemCount => items.length;

  int get missingCount => items.where((item) => item.missingContent).length;

  int get needsReviewCount => items.where((item) => item.needsReview).length;

  int get kidsMissingCount =>
      items.where((item) => item.kidsExpected && !item.kidsSafe).length;

  int get localizedCount =>
      items.where((item) => item.localizationReady).length;

  int get reviewedCount => items
      .where(
        (item) =>
            item.status == EditorialDashboardItemStatus.reviewed ||
            item.status == EditorialDashboardItemStatus.verified,
      )
      .length;

  int get verifiedCount => items
      .where((item) => item.status == EditorialDashboardItemStatus.verified)
      .length;
}

class EditorialIssue {
  const EditorialIssue({
    required this.code,
    required this.priority,
    required this.penalty,
    required this.detail,
  });

  final EditorialIssueCode code;
  final EditorialPriorityLevel priority;
  final int penalty;
  final String detail;
}

class EditorialQualityScore {
  const EditorialQualityScore({
    required this.score,
    required this.priority,
    required this.readiness,
    required this.positiveReasons,
    required this.penaltyReasons,
    required this.issues,
  });

  final int score;
  final EditorialPriorityLevel priority;
  final EditorialReadinessState readiness;
  final List<String> positiveReasons;
  final List<String> penaltyReasons;
  final List<EditorialIssue> issues;

  EditorialScoreBand get band {
    if (score >= 90) return EditorialScoreBand.excellent;
    if (score >= 70) return EditorialScoreBand.healthy;
    return EditorialScoreBand.weak;
  }
}

class EditorialDashboardMetadataEntry {
  const EditorialDashboardMetadataEntry({
    this.readinessOverride,
    this.note,
    this.updatedAtIso,
  });

  final EditorialReadinessState? readinessOverride;
  final String? note;
  final String? updatedAtIso;

  EditorialDashboardMetadataEntry copyWith({
    EditorialReadinessState? readinessOverride,
    String? note,
    String? updatedAtIso,
    bool clearReadinessOverride = false,
    bool clearNote = false,
  }) {
    return EditorialDashboardMetadataEntry(
      readinessOverride: clearReadinessOverride
          ? null
          : readinessOverride ?? this.readinessOverride,
      note: clearNote ? null : note ?? this.note,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'readinessOverride': readinessOverride?.name,
    'note': note,
    'updatedAtIso': updatedAtIso,
  };

  static EditorialDashboardMetadataEntry fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EditorialDashboardMetadataEntry();
    }
    final readinessName = json['readinessOverride']?.toString();
    EditorialReadinessState? readiness;
    if (readinessName != null) {
      for (final value in EditorialReadinessState.values) {
        if (value.name == readinessName) {
          readiness = value;
          break;
        }
      }
    }
    return EditorialDashboardMetadataEntry(
      readinessOverride: readiness,
      note: json['note']?.toString(),
      updatedAtIso: json['updatedAtIso']?.toString(),
    );
  }
}

class EditorialScoredItem {
  const EditorialScoredItem({
    required this.item,
    required this.quality,
    required this.readiness,
    this.note,
    this.lastUpdatedIso,
  });

  final EditorialDashboardItem item;
  final EditorialQualityScore quality;
  final EditorialReadinessState readiness;
  final String? note;
  final String? lastUpdatedIso;

  bool get hasNote => note != null && note!.trim().isNotEmpty;
}

class EditorialReviewQueueItem {
  const EditorialReviewQueueItem({
    required this.category,
    required this.scoredItem,
  });

  final EditorialTriageCategory category;
  final EditorialScoredItem scoredItem;
}

class EditorialReviewQueue {
  const EditorialReviewQueue({required this.category, required this.items});

  final EditorialTriageCategory category;
  final List<EditorialReviewQueueItem> items;

  int get count => items.length;
}

class EditorialPackHealth {
  const EditorialPackHealth({
    required this.domain,
    required this.packId,
    required this.totalItems,
    required this.reviewedItems,
    required this.verifiedItems,
    required this.missingRequiredFieldsCount,
    required this.kidsSafeCoveragePercent,
    required this.sourceCoveragePercent,
    required this.localizationCoveragePercent,
    required this.readiness,
    required this.overallScore,
  });

  final EditorialDashboardDomain domain;
  final String packId;
  final int totalItems;
  final int reviewedItems;
  final int verifiedItems;
  final int missingRequiredFieldsCount;
  final int kidsSafeCoveragePercent;
  final int sourceCoveragePercent;
  final int localizationCoveragePercent;
  final EditorialReadinessState readiness;
  final int overallScore;
}

class EditorialTriageSummary {
  const EditorialTriageSummary({
    required this.criticalIssuesCount,
    required this.highPriorityCount,
    required this.kidsSafetyGapCount,
    required this.missingSourceCount,
    required this.localizationGapCount,
    required this.incompletePackCount,
    required this.readyForVerificationCount,
    required this.recentlyUpdatedCount,
    required this.staleCount,
  });

  final int criticalIssuesCount;
  final int highPriorityCount;
  final int kidsSafetyGapCount;
  final int missingSourceCount;
  final int localizationGapCount;
  final int incompletePackCount;
  final int readyForVerificationCount;
  final int recentlyUpdatedCount;
  final int staleCount;
}
