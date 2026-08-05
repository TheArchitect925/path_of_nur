import '../../../learn/journey/domain/learning_path_models.dart';

enum BedtimeLearnerDifficultyPreference { gentle, growing }

class BedtimeLearnerPreferences {
  const BedtimeLearnerPreferences({
    this.nickname,
    this.favoriteProphetIds = const <String>[],
    this.bedtimeLanguageTag,
    this.bedtimeMinutesPreference,
    this.difficultyPreference = BedtimeLearnerDifficultyPreference.gentle,
    this.prefersBedtimeDuaFirst = true,
    this.alwaysResumeBedtimeStory = true,
    this.preferTranscriptWhenAudioMissing = true,
    this.simplifiedBedtimeRoutine = false,
  });

  final String? nickname;
  final List<String> favoriteProphetIds;
  final String? bedtimeLanguageTag;
  final int? bedtimeMinutesPreference;
  final BedtimeLearnerDifficultyPreference difficultyPreference;
  final bool prefersBedtimeDuaFirst;
  final bool alwaysResumeBedtimeStory;
  final bool preferTranscriptWhenAudioMissing;
  final bool simplifiedBedtimeRoutine;

  BedtimeLearnerPreferences copyWith({
    String? nickname,
    bool clearNickname = false,
    List<String>? favoriteProphetIds,
    String? bedtimeLanguageTag,
    bool clearBedtimeLanguageTag = false,
    int? bedtimeMinutesPreference,
    bool clearBedtimeMinutesPreference = false,
    BedtimeLearnerDifficultyPreference? difficultyPreference,
    bool? prefersBedtimeDuaFirst,
    bool? alwaysResumeBedtimeStory,
    bool? preferTranscriptWhenAudioMissing,
    bool? simplifiedBedtimeRoutine,
  }) {
    return BedtimeLearnerPreferences(
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      favoriteProphetIds: favoriteProphetIds ?? this.favoriteProphetIds,
      bedtimeLanguageTag: clearBedtimeLanguageTag
          ? null
          : (bedtimeLanguageTag ?? this.bedtimeLanguageTag),
      bedtimeMinutesPreference: clearBedtimeMinutesPreference
          ? null
          : (bedtimeMinutesPreference ?? this.bedtimeMinutesPreference),
      difficultyPreference: difficultyPreference ?? this.difficultyPreference,
      prefersBedtimeDuaFirst:
          prefersBedtimeDuaFirst ?? this.prefersBedtimeDuaFirst,
      alwaysResumeBedtimeStory:
          alwaysResumeBedtimeStory ?? this.alwaysResumeBedtimeStory,
      preferTranscriptWhenAudioMissing:
          preferTranscriptWhenAudioMissing ??
          this.preferTranscriptWhenAudioMissing,
      simplifiedBedtimeRoutine:
          simplifiedBedtimeRoutine ?? this.simplifiedBedtimeRoutine,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nickname': nickname,
    'favoriteProphetIds': favoriteProphetIds,
    'bedtimeLanguageTag': bedtimeLanguageTag,
    'bedtimeMinutesPreference': bedtimeMinutesPreference,
    'difficultyPreference': difficultyPreference.name,
    'prefersBedtimeDuaFirst': prefersBedtimeDuaFirst,
    'alwaysResumeBedtimeStory': alwaysResumeBedtimeStory,
    'preferTranscriptWhenAudioMissing': preferTranscriptWhenAudioMissing,
    'simplifiedBedtimeRoutine': simplifiedBedtimeRoutine,
  };

  factory BedtimeLearnerPreferences.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeLearnerPreferences();
    }
    return BedtimeLearnerPreferences(
      nickname: json['nickname']?.toString(),
      favoriteProphetIds: ((json['favoriteProphetIds'] as List?) ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      bedtimeLanguageTag: json['bedtimeLanguageTag']?.toString(),
      bedtimeMinutesPreference: (json['bedtimeMinutesPreference'] as num?)
          ?.toInt(),
      difficultyPreference: _difficultyFromString(
        json['difficultyPreference']?.toString(),
      ),
      prefersBedtimeDuaFirst: json['prefersBedtimeDuaFirst'] as bool? ?? true,
      alwaysResumeBedtimeStory:
          json['alwaysResumeBedtimeStory'] as bool? ?? true,
      preferTranscriptWhenAudioMissing:
          json['preferTranscriptWhenAudioMissing'] as bool? ?? true,
      simplifiedBedtimeRoutine:
          json['simplifiedBedtimeRoutine'] as bool? ?? false,
    );
  }

  static BedtimeLearnerDifficultyPreference _difficultyFromString(
    String? value,
  ) {
    for (final item in BedtimeLearnerDifficultyPreference.values) {
      if (item.name == value) {
        return item;
      }
    }
    return BedtimeLearnerDifficultyPreference.gentle;
  }
}

class BedtimeLearnerIdentity {
  const BedtimeLearnerIdentity({
    required this.learnerId,
    required this.displayName,
    required this.avatarReference,
    required this.ageGroup,
    required this.guardianProfileId,
    required this.isFallbackLearner,
    required this.preferences,
    this.linkedChildProfileId,
    this.createdAtIso,
    this.updatedAtIso,
    this.isArchived = false,
    this.sortOrder = 0,
  });

  final String learnerId;
  final String displayName;
  final String avatarReference;
  final LearningAgeGroup ageGroup;
  final String? guardianProfileId;
  final bool isFallbackLearner;
  final BedtimeLearnerPreferences preferences;
  final String? linkedChildProfileId;
  final String? createdAtIso;
  final String? updatedAtIso;
  final bool isArchived;
  final int sortOrder;

  String get effectiveDisplayName => (preferences.nickname ?? '').trim().isEmpty
      ? displayName
      : preferences.nickname!.trim();

  bool get isLinkedChildProfile =>
      linkedChildProfileId != null && linkedChildProfileId!.isNotEmpty;
}

class BedtimeActiveLearnerSession {
  const BedtimeActiveLearnerSession({
    required this.learnerId,
    required this.selectedAtIso,
    this.guardianProfileId,
  });

  final String learnerId;
  final String selectedAtIso;
  final String? guardianProfileId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'learnerId': learnerId,
    'selectedAtIso': selectedAtIso,
    'guardianProfileId': guardianProfileId,
  };

  factory BedtimeActiveLearnerSession.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeActiveLearnerSession(
        learnerId: '',
        selectedAtIso: '',
      );
    }
    return BedtimeActiveLearnerSession(
      learnerId: json['learnerId']?.toString() ?? '',
      selectedAtIso: json['selectedAtIso']?.toString() ?? '',
      guardianProfileId: json['guardianProfileId']?.toString(),
    );
  }
}

class BedtimeFamilyModeState {
  const BedtimeFamilyModeState({
    this.activeLearnerSessionByGuardianId =
        const <String, BedtimeActiveLearnerSession>{},
    this.archivedLearnerIds = const <String>{},
    this.preferencesByLearnerId = const <String, BedtimeLearnerPreferences>{},
  });

  final Map<String, BedtimeActiveLearnerSession>
  activeLearnerSessionByGuardianId;
  final Set<String> archivedLearnerIds;
  final Map<String, BedtimeLearnerPreferences> preferencesByLearnerId;

  BedtimeFamilyModeState copyWith({
    Map<String, BedtimeActiveLearnerSession>? activeLearnerSessionByGuardianId,
    Set<String>? archivedLearnerIds,
    Map<String, BedtimeLearnerPreferences>? preferencesByLearnerId,
  }) {
    return BedtimeFamilyModeState(
      activeLearnerSessionByGuardianId:
          activeLearnerSessionByGuardianId ??
          this.activeLearnerSessionByGuardianId,
      archivedLearnerIds: archivedLearnerIds ?? this.archivedLearnerIds,
      preferencesByLearnerId:
          preferencesByLearnerId ?? this.preferencesByLearnerId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'activeLearnerSessionByGuardianId': activeLearnerSessionByGuardianId.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'archivedLearnerIds': archivedLearnerIds.toList(growable: false),
    'preferencesByLearnerId': preferencesByLearnerId.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
  };

  factory BedtimeFamilyModeState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BedtimeFamilyModeState();
    }
    final rawSessions = json['activeLearnerSessionByGuardianId'];
    final sessions = <String, BedtimeActiveLearnerSession>{};
    if (rawSessions is Map) {
      for (final entry in rawSessions.entries) {
        sessions[entry.key.toString()] = BedtimeActiveLearnerSession.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : (entry.value as Map?)?.map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
        );
      }
    }
    final rawPreferences = json['preferencesByLearnerId'];
    final preferences = <String, BedtimeLearnerPreferences>{};
    if (rawPreferences is Map) {
      for (final entry in rawPreferences.entries) {
        preferences[entry.key.toString()] = BedtimeLearnerPreferences.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : (entry.value as Map?)?.map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
        );
      }
    }
    return BedtimeFamilyModeState(
      activeLearnerSessionByGuardianId: sessions,
      archivedLearnerIds:
          ((json['archivedLearnerIds'] as List?) ?? const <dynamic>[])
              .map((item) => item.toString())
              .toSet(),
      preferencesByLearnerId: preferences,
    );
  }
}
