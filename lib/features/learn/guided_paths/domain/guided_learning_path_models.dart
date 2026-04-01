enum GuidedLearningPathAudience { general, kids }

enum GuidedLearningPathStepType {
  lesson,
  reading,
  reflection,
  practice,
  review,
  game,
}

enum GuidedLearningPathCompletionMode { explicit }

class GuidedLearningPathRouteTarget {
  const GuidedLearningPathRouteTarget({
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class GuidedLearningPathStepReward {
  const GuidedLearningPathStepReward({
    this.learningXp = 0,
    this.oceanActionType,
    this.oceanSourceModule,
  });

  final int learningXp;
  final String? oceanActionType;
  final String? oceanSourceModule;
}

class GuidedLearningPathStep {
  const GuidedLearningPathStep({
    required this.id,
    required this.pathId,
    required this.type,
    required this.completionMode,
    required this.routeTarget,
    required this.estimatedMinutes,
    required this.reward,
  });

  final String id;
  final String pathId;
  final GuidedLearningPathStepType type;
  final GuidedLearningPathCompletionMode completionMode;
  final GuidedLearningPathRouteTarget routeTarget;
  final int estimatedMinutes;
  final GuidedLearningPathStepReward reward;
}

class GuidedLearningPath {
  const GuidedLearningPath({
    required this.id,
    required this.audience,
    required this.bucketId,
    required this.iconCodePoint,
    required this.steps,
    this.highlight = false,
    this.tags = const <String>[],
  });

  final String id;
  final GuidedLearningPathAudience audience;
  final String bucketId;
  final int iconCodePoint;
  final List<GuidedLearningPathStep> steps;
  final bool highlight;
  final List<String> tags;
}

class GuidedLearningPathProgress {
  const GuidedLearningPathProgress({
    required this.pathId,
    required this.startedAtIso,
    required this.completedStepIds,
    required this.lastActiveStepId,
    required this.lastUpdatedAtIso,
    this.completedAtIso,
  });

  final String pathId;
  final String? startedAtIso;
  final Set<String> completedStepIds;
  final String? lastActiveStepId;
  final String? lastUpdatedAtIso;
  final String? completedAtIso;

  bool get isStarted => startedAtIso != null;
  bool get isCompleted => completedAtIso != null;

  GuidedLearningPathProgress copyWith({
    String? startedAtIso,
    Set<String>? completedStepIds,
    String? lastActiveStepId,
    String? lastUpdatedAtIso,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
  }) {
    return GuidedLearningPathProgress(
      pathId: pathId,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      completedStepIds: completedStepIds ?? this.completedStepIds,
      lastActiveStepId: lastActiveStepId ?? this.lastActiveStepId,
      lastUpdatedAtIso: lastUpdatedAtIso ?? this.lastUpdatedAtIso,
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'pathId': pathId,
    'startedAtIso': startedAtIso,
    'completedStepIds': completedStepIds.toList(growable: false),
    'lastActiveStepId': lastActiveStepId,
    'lastUpdatedAtIso': lastUpdatedAtIso,
    'completedAtIso': completedAtIso,
  };

  static GuidedLearningPathProgress fromJson(dynamic raw) {
    if (raw is! Map) {
      return const GuidedLearningPathProgress(
        pathId: '',
        startedAtIso: null,
        completedStepIds: <String>{},
        lastActiveStepId: null,
        lastUpdatedAtIso: null,
      );
    }
    return GuidedLearningPathProgress(
      pathId: raw['pathId']?.toString() ?? '',
      startedAtIso: raw['startedAtIso']?.toString(),
      completedStepIds:
          (raw['completedStepIds'] as List<dynamic>? ?? const <dynamic>[])
              .map((item) => item.toString())
              .toSet(),
      lastActiveStepId: raw['lastActiveStepId']?.toString(),
      lastUpdatedAtIso: raw['lastUpdatedAtIso']?.toString(),
      completedAtIso: raw['completedAtIso']?.toString(),
    );
  }
}

class GuidedLearningPathsState {
  const GuidedLearningPathsState({required this.progressByPathId});

  final Map<String, GuidedLearningPathProgress> progressByPathId;

  GuidedLearningPathsState copyWith({
    Map<String, GuidedLearningPathProgress>? progressByPathId,
  }) {
    return GuidedLearningPathsState(
      progressByPathId: progressByPathId ?? this.progressByPathId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'progressByPathId': progressByPathId.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
  };

  static GuidedLearningPathsState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GuidedLearningPathsState(
        progressByPathId: <String, GuidedLearningPathProgress>{},
      );
    }
    final rawMap = json['progressByPathId'];
    if (rawMap is! Map) {
      return const GuidedLearningPathsState(
        progressByPathId: <String, GuidedLearningPathProgress>{},
      );
    }
    final progressByPathId = <String, GuidedLearningPathProgress>{};
    for (final entry in rawMap.entries) {
      final progress = GuidedLearningPathProgress.fromJson(entry.value);
      if (progress.pathId.isEmpty) continue;
      progressByPathId[entry.key.toString()] = progress;
    }
    return GuidedLearningPathsState(progressByPathId: progressByPathId);
  }
}

class GuidedLearningPathResumeSummary {
  const GuidedLearningPathResumeSummary({
    required this.activePath,
    required this.nextStep,
  });

  final GuidedLearningPath? activePath;
  final GuidedLearningPathStep? nextStep;

  bool get hasActivePath => activePath != null && nextStep != null;
}
