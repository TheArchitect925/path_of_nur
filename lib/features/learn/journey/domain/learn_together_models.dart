class LearnTogetherPromptSet {
  const LearnTogetherPromptSet({
    required this.discussionPrompts,
    required this.parentGuidance,
    required this.familyPrompt,
  });

  final List<String> discussionPrompts;
  final String parentGuidance;
  final String familyPrompt;
}

class LearnTogetherSessionRecord {
  const LearnTogetherSessionRecord({
    required this.childProfileId,
    required this.journeyId,
    required this.stageId,
    required this.startedAtIso,
    this.completedAtIso,
  });

  final String childProfileId;
  final String journeyId;
  final String stageId;
  final String startedAtIso;
  final String? completedAtIso;

  String get id => '$childProfileId::$stageId';

  LearnTogetherSessionRecord copyWith({String? completedAtIso}) {
    return LearnTogetherSessionRecord(
      childProfileId: childProfileId,
      journeyId: journeyId,
      stageId: stageId,
      startedAtIso: startedAtIso,
      completedAtIso: completedAtIso ?? this.completedAtIso,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'childProfileId': childProfileId,
    'journeyId': journeyId,
    'stageId': stageId,
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
  };

  factory LearnTogetherSessionRecord.fromJson(Map<String, dynamic> json) {
    return LearnTogetherSessionRecord(
      childProfileId: json['childProfileId']?.toString() ?? '',
      journeyId: json['journeyId']?.toString() ?? '',
      stageId: json['stageId']?.toString() ?? '',
      startedAtIso: json['startedAtIso']?.toString() ?? '',
      completedAtIso: json['completedAtIso']?.toString(),
    );
  }
}

class LearnTogetherState {
  const LearnTogetherState({
    required this.sessions,
    required this.learnedTogetherStageIds,
  });

  final Map<String, LearnTogetherSessionRecord> sessions;
  final Map<String, List<String>> learnedTogetherStageIds;

  factory LearnTogetherState.initial() {
    return const LearnTogetherState(
      sessions: <String, LearnTogetherSessionRecord>{},
      learnedTogetherStageIds: <String, List<String>>{},
    );
  }

  LearnTogetherState copyWith({
    Map<String, LearnTogetherSessionRecord>? sessions,
    Map<String, List<String>>? learnedTogetherStageIds,
  }) {
    return LearnTogetherState(
      sessions: sessions ?? this.sessions,
      learnedTogetherStageIds:
          learnedTogetherStageIds ?? this.learnedTogetherStageIds,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'sessions': sessions.map((key, value) => MapEntry(key, value.toJson())),
    'learnedTogetherStageIds': learnedTogetherStageIds,
  };

  factory LearnTogetherState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LearnTogetherState.initial();
    }
    return LearnTogetherState(
      sessions: ((json['sessions'] as Map?) ?? const <String, dynamic>{}).map(
        (key, value) => MapEntry(
          key.toString(),
          LearnTogetherSessionRecord.fromJson(
            (value as Map).map((k, v) => MapEntry(k.toString(), v)),
          ),
        ),
      ),
      learnedTogetherStageIds:
          ((json['learnedTogetherStageIds'] as Map?) ??
                  const <String, dynamic>{})
              .map(
                (key, value) => MapEntry(
                  key.toString(),
                  ((value as List?) ?? const <dynamic>[])
                      .map((item) => item.toString())
                      .toList(growable: false),
                ),
              ),
    );
  }
}
