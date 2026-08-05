class DailyIntention {
  const DailyIntention({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.theme,
    required this.difficulty,
    required this.audience,
    required this.isDailyEligible,
    required this.tags,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final String theme;
  final int difficulty;
  final String audience;
  final bool isDailyEligible;
  final List<String> tags;
}

class GrowthAction {
  const GrowthAction({
    required this.id,
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
    required this.theme,
    required this.xpValue,
    required this.dropValue,
    this.isManual = false,
  });

  final String id;
  final String type;
  final String titleKey;
  final String descriptionKey;
  final String theme;
  final int xpValue;
  final int dropValue;
  final bool isManual;
}

class ReflectionResponseOption {
  const ReflectionResponseOption({required this.id, required this.labelKey});

  final String id;
  final String labelKey;
}

class SpiritualReflectionPrompt {
  const SpiritualReflectionPrompt({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.theme,
    required this.audience,
    required this.responseOptions,
    required this.tags,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final String theme;
  final String audience;
  final List<ReflectionResponseOption> responseOptions;
  final List<String> tags;
}

class DailyReflectionEntry {
  const DailyReflectionEntry({
    required this.dateKey,
    this.intentionId,
    this.completedActionIds = const <String>[],
    this.moodTag,
    this.reflectionPromptId,
    this.selectedReflectionResponse,
    this.note,
    this.isCompleted = false,
    this.completedAtIso,
  });

  final String dateKey;
  final String? intentionId;
  final List<String> completedActionIds;
  final String? moodTag;
  final String? reflectionPromptId;
  final String? selectedReflectionResponse;
  final String? note;
  final bool isCompleted;
  final String? completedAtIso;

  DailyReflectionEntry copyWith({
    String? intentionId,
    bool clearIntentionId = false,
    List<String>? completedActionIds,
    String? moodTag,
    bool clearMoodTag = false,
    String? reflectionPromptId,
    bool clearReflectionPromptId = false,
    String? selectedReflectionResponse,
    bool clearSelectedReflectionResponse = false,
    String? note,
    bool clearNote = false,
    bool? isCompleted,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
  }) {
    return DailyReflectionEntry(
      dateKey: dateKey,
      intentionId: clearIntentionId ? null : (intentionId ?? this.intentionId),
      completedActionIds: completedActionIds ?? this.completedActionIds,
      moodTag: clearMoodTag ? null : (moodTag ?? this.moodTag),
      reflectionPromptId: clearReflectionPromptId
          ? null
          : (reflectionPromptId ?? this.reflectionPromptId),
      selectedReflectionResponse: clearSelectedReflectionResponse
          ? null
          : (selectedReflectionResponse ?? this.selectedReflectionResponse),
      note: clearNote ? null : (note ?? this.note),
      isCompleted: isCompleted ?? this.isCompleted,
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dateKey': dateKey,
    'intentionId': intentionId,
    'completedActionIds': completedActionIds,
    'moodTag': moodTag,
    'reflectionPromptId': reflectionPromptId,
    'selectedReflectionResponse': selectedReflectionResponse,
    'note': note,
    'isCompleted': isCompleted,
    'completedAtIso': completedAtIso,
  };

  factory DailyReflectionEntry.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return DailyReflectionEntry(
      dateKey: source['dateKey']?.toString() ?? '',
      intentionId: source['intentionId']?.toString(),
      completedActionIds: _stringList(source['completedActionIds']),
      moodTag: source['moodTag']?.toString(),
      reflectionPromptId: source['reflectionPromptId']?.toString(),
      selectedReflectionResponse: source['selectedReflectionResponse']
          ?.toString(),
      note: source['note']?.toString(),
      isCompleted: source['isCompleted'] == true,
      completedAtIso: source['completedAtIso']?.toString(),
    );
  }
}

class SpiritualGrowthState {
  const SpiritualGrowthState({
    required this.selectedIntentionIdByDateKey,
    required this.manualActionIdsByDateKey,
    required this.reflectionEntryByDateKey,
    required this.reflectionRewardGrantedAtIsoByDateKey,
  });

  final Map<String, String> selectedIntentionIdByDateKey;
  final Map<String, Set<String>> manualActionIdsByDateKey;
  final Map<String, DailyReflectionEntry> reflectionEntryByDateKey;
  final Map<String, String> reflectionRewardGrantedAtIsoByDateKey;

  factory SpiritualGrowthState.initial() => const SpiritualGrowthState(
    selectedIntentionIdByDateKey: <String, String>{},
    manualActionIdsByDateKey: <String, Set<String>>{},
    reflectionEntryByDateKey: <String, DailyReflectionEntry>{},
    reflectionRewardGrantedAtIsoByDateKey: <String, String>{},
  );

  String? selectedIntentionFor(String dateKey) =>
      selectedIntentionIdByDateKey[dateKey];

  Set<String> manualActionIdsFor(String dateKey) =>
      manualActionIdsByDateKey[dateKey] ?? const <String>{};

  DailyReflectionEntry? reflectionEntryFor(String dateKey) =>
      reflectionEntryByDateKey[dateKey];

  SpiritualGrowthState copyWith({
    Map<String, String>? selectedIntentionIdByDateKey,
    Map<String, Set<String>>? manualActionIdsByDateKey,
    Map<String, DailyReflectionEntry>? reflectionEntryByDateKey,
    Map<String, String>? reflectionRewardGrantedAtIsoByDateKey,
  }) {
    return SpiritualGrowthState(
      selectedIntentionIdByDateKey:
          selectedIntentionIdByDateKey ?? this.selectedIntentionIdByDateKey,
      manualActionIdsByDateKey:
          manualActionIdsByDateKey ?? this.manualActionIdsByDateKey,
      reflectionEntryByDateKey:
          reflectionEntryByDateKey ?? this.reflectionEntryByDateKey,
      reflectionRewardGrantedAtIsoByDateKey:
          reflectionRewardGrantedAtIsoByDateKey ??
          this.reflectionRewardGrantedAtIsoByDateKey,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'selectedIntentionIdByDateKey': selectedIntentionIdByDateKey,
    'manualActionIdsByDateKey': {
      for (final entry in manualActionIdsByDateKey.entries)
        entry.key: entry.value.toList(growable: false),
    },
    'reflectionEntryByDateKey': {
      for (final entry in reflectionEntryByDateKey.entries)
        entry.key: entry.value.toJson(),
    },
    'reflectionRewardGrantedAtIsoByDateKey':
        reflectionRewardGrantedAtIsoByDateKey,
  };

  factory SpiritualGrowthState.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    final rawManual = source['manualActionIdsByDateKey'];
    final rawEntries = source['reflectionEntryByDateKey'];
    return SpiritualGrowthState(
      selectedIntentionIdByDateKey: _stringMap(
        source['selectedIntentionIdByDateKey'],
      ),
      manualActionIdsByDateKey: rawManual is Map
          ? rawManual.map(
              (key, value) =>
                  MapEntry(key.toString(), _stringList(value).toSet()),
            )
          : const <String, Set<String>>{},
      reflectionEntryByDateKey: rawEntries is Map
          ? rawEntries.map(
              (key, value) => MapEntry(
                key.toString(),
                DailyReflectionEntry.fromJson(
                  value is Map<String, dynamic>
                      ? value
                      : Map<String, dynamic>.from(value as Map),
                ),
              ),
            )
          : const <String, DailyReflectionEntry>{},
      reflectionRewardGrantedAtIsoByDateKey: _stringMap(
        source['reflectionRewardGrantedAtIsoByDateKey'],
      ),
    );
  }
}

class SpiritualGrowthCatalog {
  const SpiritualGrowthCatalog({
    required this.intentions,
    required this.actions,
    required this.reflectionPrompts,
  });

  final List<DailyIntention> intentions;
  final List<GrowthAction> actions;
  final List<SpiritualReflectionPrompt> reflectionPrompts;

  List<GrowthAction> get manualActions =>
      actions.where((item) => item.isManual).toList(growable: false);
}

class SpiritualGrowthProfile {
  const SpiritualGrowthProfile({
    required this.themeAffinity,
    required this.habitConsistency,
    required this.reflectionStreak,
    required this.activeIntentionId,
    required this.completedGrowthActionsToday,
    required this.strongestTheme,
    required this.recommendedTheme,
  });

  final Map<String, int> themeAffinity;
  final Map<String, int> habitConsistency;
  final int reflectionStreak;
  final String? activeIntentionId;
  final List<String> completedGrowthActionsToday;
  final String? strongestTheme;
  final String? recommendedTheme;
}

class GrowthActionStatus {
  const GrowthActionStatus({
    required this.action,
    required this.isCompleted,
    required this.isManual,
  });

  final GrowthAction action;
  final bool isCompleted;
  final bool isManual;
}

class SpiritualGrowthThemeSummary {
  const SpiritualGrowthThemeSummary({
    required this.theme,
    required this.activityCount,
    required this.consistencyCount,
  });

  final String theme;
  final int activityCount;
  final int consistencyCount;
}

class SpiritualGrowthValidationIssue {
  const SpiritualGrowthValidationIssue(this.message);

  final String message;
}

class SpiritualGrowthValidationReport {
  const SpiritualGrowthValidationReport(this.issues);

  final List<SpiritualGrowthValidationIssue> issues;

  bool get isValid => issues.isEmpty;
}

Map<String, String> _stringMap(Object? raw) {
  if (raw is! Map) return const <String, String>{};
  return raw.map((key, value) => MapEntry(key.toString(), value.toString()));
}

List<String> _stringList(Object? raw) {
  if (raw is! List) return const <String>[];
  return raw.map((item) => item.toString()).toList(growable: false);
}
