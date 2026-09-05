enum LearningPathLevel { beginner, practicing, seeker, advanced }

enum LearningAgeGroup { kids, teens, adults }

class LearningPath {
  const LearningPath({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.phases,
  });

  final String id;
  final LearningPathLevel level;
  final String title;
  final String description;
  final List<LearningPathPhase> phases;
}

class LearningPathPhase {
  const LearningPathPhase({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.journeyIds,
    this.guidedPathIds = const <String>[],
    this.triviaPathId,
  });

  final String id;
  final String title;
  final String description;
  final int order;
  final List<String> journeyIds;

  /// Guided learning paths that walk this phase step by step — the "one
  /// spine" merge: guided paths render as steps inside the leveled path.
  final List<String> guidedPathIds;

  /// End-of-phase "test yourself" trivia path, when one fits the material.
  final String? triviaPathId;
}

class UserLearningPathState {
  const UserLearningPathState({
    required this.selectedLevel,
    required this.ageGroup,
    required this.currentPhaseId,
    required this.completedPhaseIds,
    required this.activeJourneyIds,
    this.secondaryExplorationIds = const <String>{},
    this.lastActivityTimestamp,
    this.completionRate = 0,
    this.averageSessionDepth = 0,
  });

  final LearningPathLevel selectedLevel;
  final LearningAgeGroup ageGroup;
  final String currentPhaseId;
  final Set<String> completedPhaseIds;
  final Set<String> activeJourneyIds;
  final Set<String> secondaryExplorationIds;
  final String? lastActivityTimestamp;
  final double completionRate;
  final double averageSessionDepth;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'selectedLevel': selectedLevel.name,
    'ageGroup': ageGroup.name,
    'currentPhaseId': currentPhaseId,
    'completedPhaseIds': completedPhaseIds.toList(growable: false),
    'activeJourneyIds': activeJourneyIds.toList(growable: false),
    'secondaryExplorationIds': secondaryExplorationIds.toList(growable: false),
    'lastActivityTimestamp': lastActivityTimestamp,
    'completionRate': completionRate,
    'averageSessionDepth': averageSessionDepth,
  };

  static UserLearningPathState? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final rawLevel = json['selectedLevel']?.toString();
    final rawAgeGroup = json['ageGroup']?.toString();
    final currentPhaseId = json['currentPhaseId']?.toString();
    if (rawLevel == null || currentPhaseId == null) return null;
    final level = LearningPathLevel.values
        .where((item) => item.name == rawLevel)
        .firstOrNull;
    final ageGroup = LearningAgeGroup.values
        .where((item) => item.name == rawAgeGroup)
        .firstOrNull;
    if (level == null) return null;
    return UserLearningPathState(
      selectedLevel: level,
      ageGroup: ageGroup ?? LearningAgeGroup.adults,
      currentPhaseId: currentPhaseId,
      completedPhaseIds: ((json['completedPhaseIds'] as List?) ?? const [])
          .map((item) => item.toString())
          .toSet(),
      activeJourneyIds: ((json['activeJourneyIds'] as List?) ?? const [])
          .map((item) => item.toString())
          .toSet(),
      secondaryExplorationIds:
          ((json['secondaryExplorationIds'] as List?) ?? const [])
              .map((item) => item.toString())
              .toSet(),
      lastActivityTimestamp: json['lastActivityTimestamp']?.toString(),
      completionRate:
          (json['completionRate'] as num?)?.toDouble() ??
          double.tryParse(json['completionRate']?.toString() ?? '') ??
          0,
      averageSessionDepth:
          (json['averageSessionDepth'] as num?)?.toDouble() ??
          double.tryParse(json['averageSessionDepth']?.toString() ?? '') ??
          0,
    );
  }
}
