import '../../bedtime_stories/domain/bedtime_story_models.dart';

enum BedtimeRoutineStepType {
  getReadyForBed,
  bedtimeDua,
  storyTime,
  readAlong,
  gratitudeReflection,
  dhikrLight,
  sleepReadyFinish,
}

enum BedtimeRoutineCompletionState {
  notStarted,
  inProgress,
  completed,
  skipped,
}

enum BedtimeRecommendationType {
  resumeStory,
  bedtimeDua,
  featuredStory,
  quietReflection,
}

class SuggestedBedtimeDua {
  const SuggestedBedtimeDua({
    required this.duaId,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.shortMeaning,
    required this.sourceReference,
    required this.bedtimeUseCase,
    required this.ageGroup,
    required this.audioAssetPath,
    required this.tags,
  });

  final String duaId;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String shortMeaning;
  final String sourceReference;
  final String bedtimeUseCase;
  final BedtimeStoryAgeGroup ageGroup;
  final String? audioAssetPath;
  final List<String> tags;
}

class BedtimeRoutineStep {
  const BedtimeRoutineStep({
    required this.stepId,
    required this.titleKey,
    required this.shortDescriptionKey,
    required this.stepType,
    required this.sortOrder,
    required this.isOptional,
    required this.estimatedDurationSeconds,
    this.relatedStoryId,
    this.relatedDuaId,
    this.relatedPlaylistId,
    this.iconName,
    this.learnerAgeSuitability,
  });

  final String stepId;
  final String titleKey;
  final String shortDescriptionKey;
  final BedtimeRoutineStepType stepType;
  final int sortOrder;
  final bool isOptional;
  final int estimatedDurationSeconds;
  final String? relatedStoryId;
  final String? relatedDuaId;
  final String? relatedPlaylistId;
  final String? iconName;
  final BedtimeStoryAgeGroup? learnerAgeSuitability;
}

class BedtimeRoutinePlan {
  const BedtimeRoutinePlan({
    required this.planId,
    required this.titleKey,
    required this.languageCode,
    required this.steps,
    required this.isDefault,
    required this.recommendedAgeGroup,
    this.learnerId,
    this.bedtimeWindowLabel,
    this.narrationPreferenceLabel,
  });

  final String planId;
  final String titleKey;
  final String? learnerId;
  final String languageCode;
  final List<BedtimeRoutineStep> steps;
  final bool isDefault;
  final BedtimeStoryAgeGroup recommendedAgeGroup;
  final String? bedtimeWindowLabel;
  final String? narrationPreferenceLabel;
}

class BedtimeRoutineStepProgress {
  const BedtimeRoutineStepProgress({
    this.state = BedtimeRoutineCompletionState.notStarted,
    this.startedAtIso,
    this.completedAtIso,
    this.selectedChoiceId,
  });

  final BedtimeRoutineCompletionState state;
  final String? startedAtIso;
  final String? completedAtIso;
  final String? selectedChoiceId;

  BedtimeRoutineStepProgress copyWith({
    BedtimeRoutineCompletionState? state,
    String? startedAtIso,
    String? completedAtIso,
    String? selectedChoiceId,
    bool clearSelectedChoiceId = false,
  }) {
    return BedtimeRoutineStepProgress(
      state: state ?? this.state,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      completedAtIso: completedAtIso ?? this.completedAtIso,
      selectedChoiceId: clearSelectedChoiceId
          ? null
          : (selectedChoiceId ?? this.selectedChoiceId),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'state': state.name,
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
    'selectedChoiceId': selectedChoiceId,
  };

  factory BedtimeRoutineStepProgress.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeRoutineStepProgress();
    }
    return BedtimeRoutineStepProgress(
      state: BedtimeRoutineCompletionState.values.firstWhere(
        (item) => item.name == json['state']?.toString(),
        orElse: () => BedtimeRoutineCompletionState.notStarted,
      ),
      startedAtIso: json['startedAtIso']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
      selectedChoiceId: json['selectedChoiceId']?.toString(),
    );
  }
}

class BedtimeRoutineSession {
  const BedtimeRoutineSession({
    required this.sessionId,
    required this.learnerId,
    required this.planId,
    required this.dateKey,
    required this.startedAtIso,
    required this.suggestedStoryId,
    required this.primaryDuaId,
    required this.secondaryDuaIds,
    required this.stepProgressById,
    this.lastUpdatedAtIso,
    this.completedAtIso,
    this.reflectionChoiceId,
  });

  final String sessionId;
  final String learnerId;
  final String planId;
  final String dateKey;
  final String startedAtIso;
  final String? lastUpdatedAtIso;
  final String? completedAtIso;
  final String? suggestedStoryId;
  final String? primaryDuaId;
  final List<String> secondaryDuaIds;
  final Map<String, BedtimeRoutineStepProgress> stepProgressById;
  final String? reflectionChoiceId;

  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;

  BedtimeRoutineSession copyWith({
    String? lastUpdatedAtIso,
    String? completedAtIso,
    String? suggestedStoryId,
    String? primaryDuaId,
    List<String>? secondaryDuaIds,
    Map<String, BedtimeRoutineStepProgress>? stepProgressById,
    String? reflectionChoiceId,
  }) {
    return BedtimeRoutineSession(
      sessionId: sessionId,
      learnerId: learnerId,
      planId: planId,
      dateKey: dateKey,
      startedAtIso: startedAtIso,
      lastUpdatedAtIso: lastUpdatedAtIso ?? this.lastUpdatedAtIso,
      completedAtIso: completedAtIso ?? this.completedAtIso,
      suggestedStoryId: suggestedStoryId ?? this.suggestedStoryId,
      primaryDuaId: primaryDuaId ?? this.primaryDuaId,
      secondaryDuaIds: secondaryDuaIds ?? this.secondaryDuaIds,
      stepProgressById: stepProgressById ?? this.stepProgressById,
      reflectionChoiceId: reflectionChoiceId ?? this.reflectionChoiceId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'sessionId': sessionId,
    'learnerId': learnerId,
    'planId': planId,
    'dateKey': dateKey,
    'startedAtIso': startedAtIso,
    'lastUpdatedAtIso': lastUpdatedAtIso,
    'completedAtIso': completedAtIso,
    'suggestedStoryId': suggestedStoryId,
    'primaryDuaId': primaryDuaId,
    'secondaryDuaIds': secondaryDuaIds,
    'reflectionChoiceId': reflectionChoiceId,
    'stepProgressById': stepProgressById.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
  };

  factory BedtimeRoutineSession.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError.notNull('json');
    }
    final rawSteps = json['stepProgressById'];
    final stepProgress = <String, BedtimeRoutineStepProgress>{};
    if (rawSteps is Map) {
      for (final entry in rawSteps.entries) {
        stepProgress[entry.key
            .toString()] = BedtimeRoutineStepProgress.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : (entry.value as Map?)?.map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
        );
      }
    }
    return BedtimeRoutineSession(
      sessionId: json['sessionId']?.toString() ?? '',
      learnerId: json['learnerId']?.toString() ?? '',
      planId: json['planId']?.toString() ?? '',
      dateKey: json['dateKey']?.toString() ?? '',
      startedAtIso: json['startedAtIso']?.toString() ?? '',
      lastUpdatedAtIso: json['lastUpdatedAtIso']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
      suggestedStoryId: json['suggestedStoryId']?.toString(),
      primaryDuaId: json['primaryDuaId']?.toString(),
      secondaryDuaIds: ((json['secondaryDuaIds'] as List?) ?? const <dynamic>[])
          .map((item) => item.toString())
          .toList(growable: false),
      reflectionChoiceId: json['reflectionChoiceId']?.toString(),
      stepProgressById: stepProgress,
    );
  }
}

class BedtimeCompanionState {
  const BedtimeCompanionState({
    this.activeSession,
    this.recentSessions = const <BedtimeRoutineSession>[],
  });

  final BedtimeRoutineSession? activeSession;
  final List<BedtimeRoutineSession> recentSessions;

  BedtimeCompanionState copyWith({
    BedtimeRoutineSession? activeSession,
    bool clearActiveSession = false,
    List<BedtimeRoutineSession>? recentSessions,
  }) {
    return BedtimeCompanionState(
      activeSession: clearActiveSession
          ? null
          : (activeSession ?? this.activeSession),
      recentSessions: recentSessions ?? this.recentSessions,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'activeSession': activeSession?.toJson(),
    'recentSessions': recentSessions.map((item) => item.toJson()).toList(),
  };

  factory BedtimeCompanionState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeCompanionState();
    }
    final recentRaw = (json['recentSessions'] as List?) ?? const <dynamic>[];
    return BedtimeCompanionState(
      activeSession: (json['activeSession'] as Map?) == null
          ? null
          : BedtimeRoutineSession.fromJson(
              (json['activeSession'] as Map).map(
                (key, value) => MapEntry(key.toString(), value),
              ),
            ),
      recentSessions: recentRaw
          .whereType<Map>()
          .map(
            (item) => BedtimeRoutineSession.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(growable: false),
    );
  }
}

class BedtimeCompanionRecommendation {
  const BedtimeCompanionRecommendation({
    required this.type,
    required this.titleKey,
    required this.subtitle,
    this.storyId,
    this.duaId,
  });

  final BedtimeRecommendationType type;
  final String titleKey;
  final String subtitle;
  final String? storyId;
  final String? duaId;
}
