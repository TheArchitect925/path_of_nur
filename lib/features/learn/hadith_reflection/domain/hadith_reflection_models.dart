enum HadithReflectionMode { kids, adult }

enum HadithReflectionOutcome { bestAligned, acceptable, needsReflection }

class HadithReflectionChoice {
  const HadithReflectionChoice({
    required this.id,
    required this.label,
    required this.feedbackText,
    this.rationale,
    this.isBestChoice = false,
    this.isAcceptableChoice = false,
  });

  final String id;
  final String label;
  final String feedbackText;
  final String? rationale;
  final bool isBestChoice;
  final bool isAcceptableChoice;

  HadithReflectionOutcome get outcome {
    if (isBestChoice) return HadithReflectionOutcome.bestAligned;
    if (isAcceptableChoice) return HadithReflectionOutcome.acceptable;
    return HadithReflectionOutcome.needsReflection;
  }
}

class HadithReflectionScenarioSeed {
  const HadithReflectionScenarioSeed({
    required this.id,
    required this.hadithId,
    required this.mode,
    required this.category,
    required this.theme,
    required this.difficulty,
    required this.shortTeachingSummary,
    required this.reflectionPrompt,
    required this.scenarioTitle,
    required this.scenarioDescription,
    required this.choices,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    this.followUpReflection,
    this.helpText,
    this.isDailyEligible = false,
    this.dailyThemes = const <String>[],
  });

  final String id;
  final String hadithId;
  final HadithReflectionMode mode;
  final String category;
  final String theme;
  final int difficulty;
  final String shortTeachingSummary;
  final String reflectionPrompt;
  final String scenarioTitle;
  final String scenarioDescription;
  final List<HadithReflectionChoice> choices;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final String? followUpReflection;
  final String? helpText;
  final bool isDailyEligible;
  final List<String> dailyThemes;
}

class HadithReflectionPuzzle {
  const HadithReflectionPuzzle({
    required this.id,
    required this.hadithId,
    required this.mode,
    required this.category,
    required this.theme,
    required this.difficulty,
    required this.hadithTitle,
    required this.hadithTextEnglish,
    required this.hadithTextArabic,
    required this.sourceBook,
    required this.referenceNumber,
    required this.grading,
    required this.shortTeachingSummary,
    required this.reflectionPrompt,
    required this.scenarioTitle,
    required this.scenarioDescription,
    required this.choices,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.packIds,
    required this.isDailyEligible,
    required this.dailyThemes,
    this.followUpReflection,
    this.helpText,
  });

  final String id;
  final String hadithId;
  final HadithReflectionMode mode;
  final String category;
  final String theme;
  final int difficulty;
  final String hadithTitle;
  final String hadithTextEnglish;
  final String? hadithTextArabic;
  final String sourceBook;
  final String referenceNumber;
  final String grading;
  final String shortTeachingSummary;
  final String reflectionPrompt;
  final String scenarioTitle;
  final String scenarioDescription;
  final List<HadithReflectionChoice> choices;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final List<String> packIds;
  final bool isDailyEligible;
  final List<String> dailyThemes;
  final String? followUpReflection;
  final String? helpText;

  HadithReflectionChoice? get bestChoice {
    for (final choice in choices) {
      if (choice.isBestChoice) return choice;
    }
    return null;
  }
}

class HadithReflectionPuzzlePack {
  const HadithReflectionPuzzlePack({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.mode,
    required this.category,
    required this.minDifficulty,
    required this.maxDifficulty,
    required this.puzzleIds,
    required this.tags,
    required this.isDailyEligible,
    required this.isFeatured,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final String mode;
  final String category;
  final int minDifficulty;
  final int maxDifficulty;
  final List<String> puzzleIds;
  final List<String> tags;
  final bool isDailyEligible;
  final bool isFeatured;
}

class HadithReflectionDailyPuzzle {
  const HadithReflectionDailyPuzzle({
    required this.puzzle,
    required this.dateKey,
    required this.weekdayTheme,
    required this.targetDifficulty,
  });

  final HadithReflectionPuzzle puzzle;
  final String dateKey;
  final String weekdayTheme;
  final int targetDifficulty;
}

class HadithReflectionPuzzleProgress {
  const HadithReflectionPuzzleProgress({
    this.selectedChoiceId,
    this.feedbackViewed = false,
    this.helpViewed = false,
    this.startedAtIso,
    this.lastPlayedAtIso,
    this.completedAtIso,
    this.bestChoiceCompletedAtIso,
    this.completionRewardGrantedAtIso,
    this.bestChoiceRewardGrantedAtIso,
  });

  final String? selectedChoiceId;
  final bool feedbackViewed;
  final bool helpViewed;
  final String? startedAtIso;
  final String? lastPlayedAtIso;
  final String? completedAtIso;
  final String? bestChoiceCompletedAtIso;
  final String? completionRewardGrantedAtIso;
  final String? bestChoiceRewardGrantedAtIso;

  bool get isStarted => (startedAtIso ?? '').isNotEmpty;
  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;
  bool get isBestChoice => (bestChoiceCompletedAtIso ?? '').isNotEmpty;

  HadithReflectionPuzzleProgress copyWith({
    String? selectedChoiceId,
    bool clearSelectedChoiceId = false,
    bool? feedbackViewed,
    bool? helpViewed,
    String? startedAtIso,
    bool clearStartedAtIso = false,
    String? lastPlayedAtIso,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
    String? bestChoiceCompletedAtIso,
    bool clearBestChoiceCompletedAtIso = false,
    String? completionRewardGrantedAtIso,
    bool clearCompletionRewardGrantedAtIso = false,
    String? bestChoiceRewardGrantedAtIso,
    bool clearBestChoiceRewardGrantedAtIso = false,
  }) {
    return HadithReflectionPuzzleProgress(
      selectedChoiceId: clearSelectedChoiceId
          ? null
          : (selectedChoiceId ?? this.selectedChoiceId),
      feedbackViewed: feedbackViewed ?? this.feedbackViewed,
      helpViewed: helpViewed ?? this.helpViewed,
      startedAtIso: clearStartedAtIso
          ? null
          : (startedAtIso ?? this.startedAtIso),
      lastPlayedAtIso: lastPlayedAtIso ?? this.lastPlayedAtIso,
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
      bestChoiceCompletedAtIso: clearBestChoiceCompletedAtIso
          ? null
          : (bestChoiceCompletedAtIso ?? this.bestChoiceCompletedAtIso),
      completionRewardGrantedAtIso: clearCompletionRewardGrantedAtIso
          ? null
          : (completionRewardGrantedAtIso ?? this.completionRewardGrantedAtIso),
      bestChoiceRewardGrantedAtIso: clearBestChoiceRewardGrantedAtIso
          ? null
          : (bestChoiceRewardGrantedAtIso ?? this.bestChoiceRewardGrantedAtIso),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'selectedChoiceId': selectedChoiceId,
    'feedbackViewed': feedbackViewed,
    'helpViewed': helpViewed,
    'startedAtIso': startedAtIso,
    'lastPlayedAtIso': lastPlayedAtIso,
    'completedAtIso': completedAtIso,
    'bestChoiceCompletedAtIso': bestChoiceCompletedAtIso,
    'completionRewardGrantedAtIso': completionRewardGrantedAtIso,
    'bestChoiceRewardGrantedAtIso': bestChoiceRewardGrantedAtIso,
  };

  factory HadithReflectionPuzzleProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return HadithReflectionPuzzleProgress(
      selectedChoiceId: source['selectedChoiceId']?.toString(),
      feedbackViewed: source['feedbackViewed'] == true,
      helpViewed: source['helpViewed'] == true,
      startedAtIso: source['startedAtIso']?.toString(),
      lastPlayedAtIso: source['lastPlayedAtIso']?.toString(),
      completedAtIso: source['completedAtIso']?.toString(),
      bestChoiceCompletedAtIso: source['bestChoiceCompletedAtIso']?.toString(),
      completionRewardGrantedAtIso: source['completionRewardGrantedAtIso']
          ?.toString(),
      bestChoiceRewardGrantedAtIso: source['bestChoiceRewardGrantedAtIso']
          ?.toString(),
    );
  }
}

class HadithReflectionDailyProgress {
  const HadithReflectionDailyProgress({
    required this.dateKey,
    required this.puzzleId,
    this.weekdayTheme,
    this.startedAtIso,
    this.completedAtIso,
    this.bestChoiceCompletedAtIso,
    this.dailyRewardGrantedAtIso,
  });

  final String dateKey;
  final String puzzleId;
  final String? weekdayTheme;
  final String? startedAtIso;
  final String? completedAtIso;
  final String? bestChoiceCompletedAtIso;
  final String? dailyRewardGrantedAtIso;

  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;
  bool get isBestChoice => (bestChoiceCompletedAtIso ?? '').isNotEmpty;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dateKey': dateKey,
    'puzzleId': puzzleId,
    'weekdayTheme': weekdayTheme,
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
    'bestChoiceCompletedAtIso': bestChoiceCompletedAtIso,
    'dailyRewardGrantedAtIso': dailyRewardGrantedAtIso,
  };

  factory HadithReflectionDailyProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return HadithReflectionDailyProgress(
      dateKey: source['dateKey']?.toString() ?? '',
      puzzleId: source['puzzleId']?.toString() ?? '',
      weekdayTheme: source['weekdayTheme']?.toString(),
      startedAtIso: source['startedAtIso']?.toString(),
      completedAtIso: source['completedAtIso']?.toString(),
      bestChoiceCompletedAtIso: source['bestChoiceCompletedAtIso']?.toString(),
      dailyRewardGrantedAtIso: source['dailyRewardGrantedAtIso']?.toString(),
    );
  }
}

class HadithReflectionProgressState {
  const HadithReflectionProgressState({
    required this.progressByPuzzleId,
    required this.dailyProgressByDateKey,
  });

  final Map<String, HadithReflectionPuzzleProgress> progressByPuzzleId;
  final Map<String, HadithReflectionDailyProgress> dailyProgressByDateKey;

  factory HadithReflectionProgressState.initial() =>
      const HadithReflectionProgressState(
        progressByPuzzleId: <String, HadithReflectionPuzzleProgress>{},
        dailyProgressByDateKey: <String, HadithReflectionDailyProgress>{},
      );

  HadithReflectionPuzzleProgress progressFor(String puzzleId) =>
      progressByPuzzleId[puzzleId] ?? const HadithReflectionPuzzleProgress();

  HadithReflectionDailyProgress? dailyProgressFor(String dateKey) =>
      dailyProgressByDateKey[dateKey];

  HadithReflectionProgressState copyWith({
    Map<String, HadithReflectionPuzzleProgress>? progressByPuzzleId,
    Map<String, HadithReflectionDailyProgress>? dailyProgressByDateKey,
  }) {
    return HadithReflectionProgressState(
      progressByPuzzleId: progressByPuzzleId ?? this.progressByPuzzleId,
      dailyProgressByDateKey:
          dailyProgressByDateKey ?? this.dailyProgressByDateKey,
    );
  }

  HadithReflectionDailyStreakSummary dailyStreakSummary(DateTime now) {
    if (dailyProgressByDateKey.isEmpty) {
      return const HadithReflectionDailyStreakSummary(
        currentStreak: 0,
        longestStreak: 0,
      );
    }
    final completedKeys =
        dailyProgressByDateKey.values
            .where((item) => item.isCompleted)
            .map((item) => item.dateKey)
            .toList(growable: false)
          ..sort();
    var longest = 0;
    var running = 0;
    String? previous;
    for (final key in completedKeys) {
      if (previous != null &&
          DateTime.parse(key).difference(DateTime.parse(previous)).inDays ==
              1) {
        running += 1;
      } else {
        running = 1;
      }
      if (running > longest) longest = running;
      previous = key;
    }
    var current = 0;
    var cursor = now;
    while (true) {
      final key =
          '${cursor.year.toString().padLeft(4, '0')}-${cursor.month.toString().padLeft(2, '0')}-${cursor.day.toString().padLeft(2, '0')}';
      final item = dailyProgressByDateKey[key];
      if (item?.isCompleted != true) break;
      current += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return HadithReflectionDailyStreakSummary(
      currentStreak: current,
      longestStreak: longest,
    );
  }

  List<HadithReflectionDailyProgress> recentDailyHistory({int limit = 7}) {
    final items = dailyProgressByDateKey.values.toList(growable: false)
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return items.take(limit).toList(growable: false);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'progressByPuzzleId': {
      for (final entry in progressByPuzzleId.entries)
        entry.key: entry.value.toJson(),
    },
    'dailyProgressByDateKey': {
      for (final entry in dailyProgressByDateKey.entries)
        entry.key: entry.value.toJson(),
    },
  };

  factory HadithReflectionProgressState.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    final progressRaw =
        source['progressByPuzzleId'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    final dailyRaw =
        source['dailyProgressByDateKey'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return HadithReflectionProgressState(
      progressByPuzzleId: {
        for (final entry in progressRaw.entries)
          entry.key: HadithReflectionPuzzleProgress.fromJson(
            entry.value as Map<String, dynamic>?,
          ),
      },
      dailyProgressByDateKey: {
        for (final entry in dailyRaw.entries)
          entry.key: HadithReflectionDailyProgress.fromJson(
            entry.value as Map<String, dynamic>?,
          ),
      },
    );
  }
}

class HadithReflectionDailyStreakSummary {
  const HadithReflectionDailyStreakSummary({
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;
}

class HadithReflectionPackProgressSummary {
  const HadithReflectionPackProgressSummary({
    required this.totalPuzzles,
    required this.completedPuzzles,
    required this.bestChoicePuzzles,
    required this.inProgressPuzzles,
    required this.nextPuzzleId,
  });

  final int totalPuzzles;
  final int completedPuzzles;
  final int bestChoicePuzzles;
  final int inProgressPuzzles;
  final String? nextPuzzleId;

  double get completionFraction =>
      totalPuzzles == 0 ? 0 : completedPuzzles / totalPuzzles;
}

class HadithReflectionCatalog {
  const HadithReflectionCatalog({required this.puzzles, required this.packs});

  final List<HadithReflectionPuzzle> puzzles;
  final List<HadithReflectionPuzzlePack> packs;

  Map<String, HadithReflectionPuzzle> get puzzlesById => {
    for (final puzzle in puzzles) puzzle.id: puzzle,
  };

  Map<String, HadithReflectionPuzzlePack> get packsById => {
    for (final pack in packs) pack.id: pack,
  };

  List<HadithReflectionPuzzle> get kidsPuzzles => puzzles
      .where((puzzle) => puzzle.mode == HadithReflectionMode.kids)
      .toList(growable: false);

  List<HadithReflectionPuzzle> get adultPuzzles => puzzles
      .where((puzzle) => puzzle.mode == HadithReflectionMode.adult)
      .toList(growable: false);

  HadithReflectionPackProgressSummary progressForPack(
    String packId,
    HadithReflectionProgressState progress,
  ) {
    final pack = packsById[packId];
    if (pack == null) {
      return const HadithReflectionPackProgressSummary(
        totalPuzzles: 0,
        completedPuzzles: 0,
        bestChoicePuzzles: 0,
        inProgressPuzzles: 0,
        nextPuzzleId: null,
      );
    }
    final items = pack.puzzleIds
        .map((id) => puzzlesById[id])
        .whereType<HadithReflectionPuzzle>()
        .toList(growable: false);
    var completed = 0;
    var best = 0;
    var inProgress = 0;
    String? nextPuzzleId;
    for (final puzzle in items) {
      final item = progress.progressFor(puzzle.id);
      if (item.isCompleted) {
        completed += 1;
      } else if (item.isStarted) {
        inProgress += 1;
      }
      if (item.isBestChoice) {
        best += 1;
      }
      nextPuzzleId ??= item.isCompleted ? null : puzzle.id;
    }
    return HadithReflectionPackProgressSummary(
      totalPuzzles: items.length,
      completedPuzzles: completed,
      bestChoicePuzzles: best,
      inProgressPuzzles: inProgress,
      nextPuzzleId: nextPuzzleId,
    );
  }
}
