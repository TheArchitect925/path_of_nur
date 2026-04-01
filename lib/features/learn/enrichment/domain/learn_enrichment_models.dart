enum LearningMilestoneType {
  firstPathStarted,
  firstStepCompleted,
  firstPathCompleted,
  foundationsCompleted,
  firstQuranStepCompleted,
  firstKidsPathCompleted,
  storiesPathCompleted,
  consistencyThreeStepsWeek,
  returnAfterBreak,
}

class LearningMilestoneDefinition {
  const LearningMilestoneDefinition({
    required this.id,
    required this.type,
    required this.iconCodePoint,
  });

  final String id;
  final LearningMilestoneType type;
  final int iconCodePoint;
}

const List<LearningMilestoneDefinition> kLearningMilestoneDefinitions =
    <LearningMilestoneDefinition>[
      LearningMilestoneDefinition(
        id: 'learn_milestone_first_path_started',
        type: LearningMilestoneType.firstPathStarted,
        iconCodePoint: 0xe80c, // auto_stories_rounded
      ),
      LearningMilestoneDefinition(
        id: 'learn_milestone_first_step_completed',
        type: LearningMilestoneType.firstStepCompleted,
        iconCodePoint: 0xe86c, // check_circle_outline_rounded
      ),
      LearningMilestoneDefinition(
        id: 'learn_milestone_first_path_completed',
        type: LearningMilestoneType.firstPathCompleted,
        iconCodePoint: 0xe876, // task_alt_rounded
      ),
      LearningMilestoneDefinition(
        id: 'learn_milestone_foundations_completed',
        type: LearningMilestoneType.foundationsCompleted,
        iconCodePoint: 0xe80c, // auto_stories_rounded
      ),
      LearningMilestoneDefinition(
        id: 'learn_milestone_first_quran_step_completed',
        type: LearningMilestoneType.firstQuranStepCompleted,
        iconCodePoint: 0xe865, // menu_book_rounded
      ),
      LearningMilestoneDefinition(
        id: 'learn_milestone_first_kids_path_completed',
        type: LearningMilestoneType.firstKidsPathCompleted,
        iconCodePoint: 0xeb97, // child_friendly_rounded
      ),
      LearningMilestoneDefinition(
        id: 'learn_milestone_stories_completed',
        type: LearningMilestoneType.storiesPathCompleted,
        iconCodePoint: 0xe865, // menu_book_rounded
      ),
      LearningMilestoneDefinition(
        id: 'learn_milestone_three_steps_week',
        type: LearningMilestoneType.consistencyThreeStepsWeek,
        iconCodePoint: 0xe8b5, // schedule_rounded
      ),
      LearningMilestoneDefinition(
        id: 'learn_milestone_return_after_break',
        type: LearningMilestoneType.returnAfterBreak,
        iconCodePoint: 0xe5d5, // refresh_rounded
      ),
    ];

class LearningMemoryRecord {
  const LearningMemoryRecord({
    required this.id,
    required this.milestoneId,
    required this.occurredAtIso,
    this.pathId,
  });

  final String id;
  final String milestoneId;
  final String occurredAtIso;
  final String? pathId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'milestoneId': milestoneId,
    'occurredAtIso': occurredAtIso,
    'pathId': pathId,
  };

  static LearningMemoryRecord? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final milestoneId = raw['milestoneId']?.toString();
    final occurredAtIso = raw['occurredAtIso']?.toString();
    if (id == null || milestoneId == null || occurredAtIso == null) {
      return null;
    }
    return LearningMemoryRecord(
      id: id,
      milestoneId: milestoneId,
      occurredAtIso: occurredAtIso,
      pathId: raw['pathId']?.toString(),
    );
  }
}

class LearnEnrichmentState {
  const LearnEnrichmentState({
    required this.unlockedAtByMilestoneId,
    required this.acknowledgedAtByMilestoneId,
    required this.memories,
    required this.recentStepCompletedAtIsos,
  });

  final Map<String, String> unlockedAtByMilestoneId;
  final Map<String, String> acknowledgedAtByMilestoneId;
  final List<LearningMemoryRecord> memories;
  final List<String> recentStepCompletedAtIsos;

  LearnEnrichmentState copyWith({
    Map<String, String>? unlockedAtByMilestoneId,
    Map<String, String>? acknowledgedAtByMilestoneId,
    List<LearningMemoryRecord>? memories,
    List<String>? recentStepCompletedAtIsos,
  }) {
    return LearnEnrichmentState(
      unlockedAtByMilestoneId:
          unlockedAtByMilestoneId ?? this.unlockedAtByMilestoneId,
      acknowledgedAtByMilestoneId:
          acknowledgedAtByMilestoneId ?? this.acknowledgedAtByMilestoneId,
      memories: memories ?? this.memories,
      recentStepCompletedAtIsos:
          recentStepCompletedAtIsos ?? this.recentStepCompletedAtIsos,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'unlockedAtByMilestoneId': unlockedAtByMilestoneId,
    'acknowledgedAtByMilestoneId': acknowledgedAtByMilestoneId,
    'memories': memories.map((item) => item.toJson()).toList(growable: false),
    'recentStepCompletedAtIsos': recentStepCompletedAtIsos,
  };

  static LearnEnrichmentState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LearnEnrichmentState(
        unlockedAtByMilestoneId: <String, String>{},
        acknowledgedAtByMilestoneId: <String, String>{},
        memories: <LearningMemoryRecord>[],
        recentStepCompletedAtIsos: <String>[],
      );
    }
    return LearnEnrichmentState(
      unlockedAtByMilestoneId: Map<String, String>.from(
        (json['unlockedAtByMilestoneId'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ) ??
            const <String, String>{},
      ),
      acknowledgedAtByMilestoneId: Map<String, String>.from(
        (json['acknowledgedAtByMilestoneId'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ) ??
            const <String, String>{},
      ),
      memories: (json['memories'] as List<dynamic>? ?? const <dynamic>[])
          .map(LearningMemoryRecord.fromJson)
          .whereType<LearningMemoryRecord>()
          .toList(growable: false),
      recentStepCompletedAtIsos:
          (json['recentStepCompletedAtIsos'] as List<dynamic>? ??
                  const <dynamic>[])
              .map((item) => item.toString())
              .toList(growable: false),
    );
  }
}

class LocalizedLearningMilestoneMoment {
  const LocalizedLearningMilestoneMoment({
    required this.id,
    required this.title,
    required this.body,
    required this.encouragement,
    required this.iconCodePoint,
    required this.pathId,
    required this.occurredAt,
    required this.isKids,
  });

  final String id;
  final String title;
  final String body;
  final String encouragement;
  final int iconCodePoint;
  final String? pathId;
  final DateTime occurredAt;
  final bool isKids;
}

class LocalizedLearningMemoryCard {
  const LocalizedLearningMemoryCard({
    required this.id,
    required this.title,
    required this.body,
    required this.occurredAt,
    required this.iconCodePoint,
    required this.isKids,
  });

  final String id;
  final String title;
  final String body;
  final DateTime occurredAt;
  final int iconCodePoint;
  final bool isKids;
}

class LocalizedLearningPathCompletionEnrichment {
  const LocalizedLearningPathCompletionEnrichment({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.encouragement,
    required this.memoryLine,
    required this.primarySuggestions,
    required this.isKids,
  });

  final String title;
  final String subtitle;
  final String body;
  final String encouragement;
  final String? memoryLine;
  final List<LocalizedLearningPathSuggestion> primarySuggestions;
  final bool isKids;
}

class LocalizedLearningPathSuggestion {
  const LocalizedLearningPathSuggestion({
    required this.pathId,
    required this.title,
  });

  final String pathId;
  final String title;
}
