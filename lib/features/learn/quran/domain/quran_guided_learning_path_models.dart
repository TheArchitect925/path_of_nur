enum QuranGuidedLearningPathType {
  beginnerUnderstanding,
  themeStudy,
  memorizationSupport,
  reflectionJourney,
  surahStudy,
}

enum QuranGuidedLearningPathIntensity { gentle, guided, deeper }

enum QuranGuidedLearningPathCategory {
  foundations,
  spiritualSupport,
  prophetStories,
  reflection,
  characterAndAdab,
  signsAndCreation,
  hereafter,
}

enum QuranGuidedLearningStepKind {
  surahSummary,
  themeDetail,
  ayahReflection,
  guidedReflection,
  readerEntry,
  prophetStoryAnchor,
}

class QuranGuidedLearningAyahReference {
  const QuranGuidedLearningAyahReference({
    required this.surahNumber,
    required this.ayahNumber,
    this.endAyahNumber,
    required this.label,
    this.subtitle,
  });

  final int surahNumber;
  final int ayahNumber;
  final int? endAyahNumber;
  final String label;
  final String? subtitle;
}

class QuranGuidedLearningPathStep {
  const QuranGuidedLearningPathStep({
    required this.id,
    required this.kind,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.relatedSurahNumber,
    this.relatedThemeId,
    this.ayahReferences = const <QuranGuidedLearningAyahReference>[],
    this.reflectionPrompt,
    this.estimatedMinutes = 3,
  });

  final String id;
  final QuranGuidedLearningStepKind kind;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final int? relatedSurahNumber;
  final String? relatedThemeId;
  final List<QuranGuidedLearningAyahReference> ayahReferences;
  final String? reflectionPrompt;
  final int estimatedMinutes;
}

class QuranGuidedLearningPath {
  const QuranGuidedLearningPath({
    required this.id,
    required this.type,
    required this.category,
    required this.intensity,
    required this.steps,
    this.themeId,
    this.surahNumber,
    this.ayahNumber,
    this.featured = false,
    this.sortOrder = 0,
    this.estimatedMinutes = 15,
    this.relatedThemeIds = const <String>[],
    this.relatedPathIds = const <String>[],
  });

  final String id;
  final QuranGuidedLearningPathType type;
  final QuranGuidedLearningPathCategory category;
  final QuranGuidedLearningPathIntensity intensity;
  final List<QuranGuidedLearningPathStep> steps;
  final String? themeId;
  final int? surahNumber;
  final int? ayahNumber;
  final bool featured;
  final int sortOrder;
  final int estimatedMinutes;
  final List<String> relatedThemeIds;
  final List<String> relatedPathIds;
}

class QuranGuidedLearningPathProgressEntry {
  const QuranGuidedLearningPathProgressEntry({
    required this.pathId,
    this.startedAtIso,
    this.lastOpenedStopId,
    this.completedStopIds = const <String>{},
    this.lastAccessedAtIso,
    this.completedAtIso,
  });

  final String pathId;
  final String? startedAtIso;
  final String? lastOpenedStopId;
  final Set<String> completedStopIds;
  final String? lastAccessedAtIso;
  final String? completedAtIso;

  bool get isStarted => (startedAtIso ?? '').isNotEmpty;
  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;

  double completionRatio(int totalStops) {
    if (totalStops <= 0) return 0;
    return completedStopIds.length / totalStops;
  }

  QuranGuidedLearningPathProgressEntry copyWith({
    String? startedAtIso,
    String? lastOpenedStopId,
    Set<String>? completedStopIds,
    String? lastAccessedAtIso,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
  }) {
    return QuranGuidedLearningPathProgressEntry(
      pathId: pathId,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      lastOpenedStopId: lastOpenedStopId ?? this.lastOpenedStopId,
      completedStopIds: completedStopIds ?? this.completedStopIds,
      lastAccessedAtIso: lastAccessedAtIso ?? this.lastAccessedAtIso,
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'pathId': pathId,
    'startedAtIso': startedAtIso,
    'lastOpenedStopId': lastOpenedStopId,
    'completedStopIds': completedStopIds.toList(growable: false),
    'lastAccessedAtIso': lastAccessedAtIso,
    'completedAtIso': completedAtIso,
  };

  static QuranGuidedLearningPathProgressEntry fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const QuranGuidedLearningPathProgressEntry(pathId: '');
    }
    return QuranGuidedLearningPathProgressEntry(
      pathId: json['pathId']?.toString() ?? '',
      startedAtIso: json['startedAtIso']?.toString(),
      lastOpenedStopId: json['lastOpenedStopId']?.toString(),
      completedStopIds: {
        for (final item in (json['completedStopIds'] as List? ?? const []))
          item.toString(),
      },
      lastAccessedAtIso: json['lastAccessedAtIso']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
    );
  }
}

class QuranGuidedLearningProgressState {
  const QuranGuidedLearningProgressState({
    required this.entriesByPath,
    this.lastPathId,
    this.lastStepId,
    this.updatedAtIso,
  });

  final Map<String, QuranGuidedLearningPathProgressEntry> entriesByPath;
  final String? lastPathId;
  final String? lastStepId;
  final String? updatedAtIso;

  QuranGuidedLearningProgressState copyWith({
    Map<String, QuranGuidedLearningPathProgressEntry>? entriesByPath,
    String? lastPathId,
    String? lastStepId,
    String? updatedAtIso,
  }) {
    return QuranGuidedLearningProgressState(
      entriesByPath: entriesByPath ?? this.entriesByPath,
      lastPathId: lastPathId ?? this.lastPathId,
      lastStepId: lastStepId ?? this.lastStepId,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  static const initial = QuranGuidedLearningProgressState(
    entriesByPath: <String, QuranGuidedLearningPathProgressEntry>{},
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'entriesByPath': entriesByPath.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'lastPathId': lastPathId,
    'lastStepId': lastStepId,
    'updatedAtIso': updatedAtIso,
  };

  static QuranGuidedLearningProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial;
    final rawEntries = json['entriesByPath'];
    final entries = <String, QuranGuidedLearningPathProgressEntry>{};
    if (rawEntries is Map) {
      for (final entry in rawEntries.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          entries[key] = QuranGuidedLearningPathProgressEntry.fromJson(value);
        } else if (value is Map) {
          entries[key] = QuranGuidedLearningPathProgressEntry.fromJson(
            value.map((k, v) => MapEntry(k.toString(), v)),
          );
        }
      }
    }

    return QuranGuidedLearningProgressState(
      entriesByPath: entries,
      lastPathId: json['lastPathId']?.toString(),
      lastStepId: json['lastStepId']?.toString(),
      updatedAtIso: json['updatedAtIso']?.toString(),
    );
  }
}
