enum MatchingMode { kids, adult }

enum MatchingItemType { text, image, audio }

enum MatchingHintType { revealPair, removeOneWrongOption }

class MatchingPair {
  const MatchingPair({
    required this.id,
    required this.leftItem,
    required this.rightItem,
    this.leftType = MatchingItemType.text,
    this.rightType = MatchingItemType.text,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.sourceType,
    required this.sourceReference,
    this.hint,
    this.mode = MatchingMode.adult,
    this.isDailyEligible = false,
    this.dailyThemes = const <String>[],
  });

  final String id;
  final String leftItem;
  final String rightItem;
  final MatchingItemType leftType;
  final MatchingItemType rightType;
  final String category;
  final int difficulty;
  final List<String> tags;
  final String sourceType;
  final String sourceReference;
  final String? hint;
  final MatchingMode mode;
  final bool isDailyEligible;
  final List<String> dailyThemes;
}

class MatchingPuzzleSeed {
  const MatchingPuzzleSeed({
    required this.id,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.pairIds,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    this.isDailyEligible = false,
    this.dailyThemes = const <String>[],
  });

  final String id;
  final MatchingMode mode;
  final String category;
  final int difficulty;
  final List<String> pairIds;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final bool isDailyEligible;
  final List<String> dailyThemes;
}

class MatchingPuzzle {
  const MatchingPuzzle({
    required this.id,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.pairs,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.isDailyEligible,
    required this.dailyThemes,
    required this.packIds,
  });

  final String id;
  final MatchingMode mode;
  final String category;
  final int difficulty;
  final List<MatchingPair> pairs;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final bool isDailyEligible;
  final List<String> dailyThemes;
  final List<String> packIds;
}

class MatchingPuzzlePack {
  const MatchingPuzzlePack({
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

class MatchingDailyPuzzle {
  const MatchingDailyPuzzle({
    required this.puzzle,
    required this.dateKey,
    required this.weekdayTheme,
    required this.targetDifficulty,
  });

  final MatchingPuzzle puzzle;
  final String dateKey;
  final String weekdayTheme;
  final int targetDifficulty;
}

class MatchingPuzzleProgress {
  const MatchingPuzzleProgress({
    this.matchedPairIds = const <String>{},
    this.hiddenRightItemIds = const <String>{},
    this.revealedPairIds = const <String>{},
    this.selectedLeftPairId,
    this.selectedRightPairId,
    this.startedAtIso,
    this.lastPlayedAtIso,
    this.completedAtIso,
    this.perfectCompletedAtIso,
    this.completionRewardGrantedAtIso,
    this.perfectRewardGrantedAtIso,
    this.hadMistake = false,
    this.revealPairUses = 0,
    this.removeWrongOptionUses = 0,
  });

  final Set<String> matchedPairIds;
  final Set<String> hiddenRightItemIds;
  final Set<String> revealedPairIds;
  final String? selectedLeftPairId;
  final String? selectedRightPairId;
  final String? startedAtIso;
  final String? lastPlayedAtIso;
  final String? completedAtIso;
  final String? perfectCompletedAtIso;
  final String? completionRewardGrantedAtIso;
  final String? perfectRewardGrantedAtIso;
  final bool hadMistake;
  final int revealPairUses;
  final int removeWrongOptionUses;

  bool get isStarted => (startedAtIso ?? '').isNotEmpty;
  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;
  bool get isPerfect => (perfectCompletedAtIso ?? '').isNotEmpty;
  bool get usedAnyHint => revealPairUses > 0 || removeWrongOptionUses > 0;

  MatchingPuzzleProgress copyWith({
    Set<String>? matchedPairIds,
    Set<String>? hiddenRightItemIds,
    Set<String>? revealedPairIds,
    String? selectedLeftPairId,
    bool clearSelectedLeftPairId = false,
    String? selectedRightPairId,
    bool clearSelectedRightPairId = false,
    String? startedAtIso,
    bool clearStartedAtIso = false,
    String? lastPlayedAtIso,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
    String? perfectCompletedAtIso,
    bool clearPerfectCompletedAtIso = false,
    String? completionRewardGrantedAtIso,
    bool clearCompletionRewardGrantedAtIso = false,
    String? perfectRewardGrantedAtIso,
    bool clearPerfectRewardGrantedAtIso = false,
    bool? hadMistake,
    int? revealPairUses,
    int? removeWrongOptionUses,
  }) {
    return MatchingPuzzleProgress(
      matchedPairIds: matchedPairIds ?? this.matchedPairIds,
      hiddenRightItemIds: hiddenRightItemIds ?? this.hiddenRightItemIds,
      revealedPairIds: revealedPairIds ?? this.revealedPairIds,
      selectedLeftPairId: clearSelectedLeftPairId
          ? null
          : (selectedLeftPairId ?? this.selectedLeftPairId),
      selectedRightPairId: clearSelectedRightPairId
          ? null
          : (selectedRightPairId ?? this.selectedRightPairId),
      startedAtIso: clearStartedAtIso
          ? null
          : (startedAtIso ?? this.startedAtIso),
      lastPlayedAtIso: lastPlayedAtIso ?? this.lastPlayedAtIso,
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
      perfectCompletedAtIso: clearPerfectCompletedAtIso
          ? null
          : (perfectCompletedAtIso ?? this.perfectCompletedAtIso),
      completionRewardGrantedAtIso: clearCompletionRewardGrantedAtIso
          ? null
          : (completionRewardGrantedAtIso ?? this.completionRewardGrantedAtIso),
      perfectRewardGrantedAtIso: clearPerfectRewardGrantedAtIso
          ? null
          : (perfectRewardGrantedAtIso ?? this.perfectRewardGrantedAtIso),
      hadMistake: hadMistake ?? this.hadMistake,
      revealPairUses: revealPairUses ?? this.revealPairUses,
      removeWrongOptionUses:
          removeWrongOptionUses ?? this.removeWrongOptionUses,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'matchedPairIds': matchedPairIds.toList(growable: false),
    'hiddenRightItemIds': hiddenRightItemIds.toList(growable: false),
    'revealedPairIds': revealedPairIds.toList(growable: false),
    'selectedLeftPairId': selectedLeftPairId,
    'selectedRightPairId': selectedRightPairId,
    'startedAtIso': startedAtIso,
    'lastPlayedAtIso': lastPlayedAtIso,
    'completedAtIso': completedAtIso,
    'perfectCompletedAtIso': perfectCompletedAtIso,
    'completionRewardGrantedAtIso': completionRewardGrantedAtIso,
    'perfectRewardGrantedAtIso': perfectRewardGrantedAtIso,
    'hadMistake': hadMistake,
    'revealPairUses': revealPairUses,
    'removeWrongOptionUses': removeWrongOptionUses,
  };

  factory MatchingPuzzleProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return MatchingPuzzleProgress(
      matchedPairIds: _stringSet(source['matchedPairIds']),
      hiddenRightItemIds: _stringSet(source['hiddenRightItemIds']),
      revealedPairIds: _stringSet(source['revealedPairIds']),
      selectedLeftPairId: source['selectedLeftPairId']?.toString(),
      selectedRightPairId: source['selectedRightPairId']?.toString(),
      startedAtIso: source['startedAtIso']?.toString(),
      lastPlayedAtIso: source['lastPlayedAtIso']?.toString(),
      completedAtIso: source['completedAtIso']?.toString(),
      perfectCompletedAtIso: source['perfectCompletedAtIso']?.toString(),
      completionRewardGrantedAtIso: source['completionRewardGrantedAtIso']
          ?.toString(),
      perfectRewardGrantedAtIso: source['perfectRewardGrantedAtIso']
          ?.toString(),
      hadMistake: source['hadMistake'] == true,
      revealPairUses: (source['revealPairUses'] as num?)?.toInt() ?? 0,
      removeWrongOptionUses:
          (source['removeWrongOptionUses'] as num?)?.toInt() ?? 0,
    );
  }
}

class MatchingDailyProgress {
  const MatchingDailyProgress({
    required this.dateKey,
    required this.puzzleId,
    this.weekdayTheme,
    this.startedAtIso,
    this.completedAtIso,
    this.perfectCompletedAtIso,
    this.dailyRewardGrantedAtIso,
    this.timeTakenSeconds,
  });

  final String dateKey;
  final String puzzleId;
  final String? weekdayTheme;
  final String? startedAtIso;
  final String? completedAtIso;
  final String? perfectCompletedAtIso;
  final String? dailyRewardGrantedAtIso;
  final int? timeTakenSeconds;

  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;
  bool get isPerfect => (perfectCompletedAtIso ?? '').isNotEmpty;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dateKey': dateKey,
    'puzzleId': puzzleId,
    'weekdayTheme': weekdayTheme,
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
    'perfectCompletedAtIso': perfectCompletedAtIso,
    'dailyRewardGrantedAtIso': dailyRewardGrantedAtIso,
    'timeTakenSeconds': timeTakenSeconds,
  };

  factory MatchingDailyProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return MatchingDailyProgress(
      dateKey: source['dateKey']?.toString() ?? '',
      puzzleId: source['puzzleId']?.toString() ?? '',
      weekdayTheme: source['weekdayTheme']?.toString(),
      startedAtIso: source['startedAtIso']?.toString(),
      completedAtIso: source['completedAtIso']?.toString(),
      perfectCompletedAtIso: source['perfectCompletedAtIso']?.toString(),
      dailyRewardGrantedAtIso: source['dailyRewardGrantedAtIso']?.toString(),
      timeTakenSeconds: (source['timeTakenSeconds'] as num?)?.toInt(),
    );
  }
}

class MatchingProgressState {
  const MatchingProgressState({
    required this.progressByPuzzleId,
    required this.dailyProgressByDateKey,
  });

  final Map<String, MatchingPuzzleProgress> progressByPuzzleId;
  final Map<String, MatchingDailyProgress> dailyProgressByDateKey;

  factory MatchingProgressState.initial() => const MatchingProgressState(
    progressByPuzzleId: <String, MatchingPuzzleProgress>{},
    dailyProgressByDateKey: <String, MatchingDailyProgress>{},
  );

  MatchingPuzzleProgress progressFor(String puzzleId) =>
      progressByPuzzleId[puzzleId] ?? const MatchingPuzzleProgress();

  MatchingDailyProgress? dailyProgressFor(String dateKey) =>
      dailyProgressByDateKey[dateKey];

  MatchingProgressState copyWith({
    Map<String, MatchingPuzzleProgress>? progressByPuzzleId,
    Map<String, MatchingDailyProgress>? dailyProgressByDateKey,
  }) {
    return MatchingProgressState(
      progressByPuzzleId: progressByPuzzleId ?? this.progressByPuzzleId,
      dailyProgressByDateKey:
          dailyProgressByDateKey ?? this.dailyProgressByDateKey,
    );
  }

  MatchingDailyStreakSummary dailyStreakSummary(DateTime now) {
    if (dailyProgressByDateKey.isEmpty) {
      return const MatchingDailyStreakSummary(
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
    return MatchingDailyStreakSummary(
      currentStreak: current,
      longestStreak: longest,
    );
  }

  List<MatchingDailyProgress> recentDailyHistory({int limit = 7}) {
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

  factory MatchingProgressState.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    final progressRaw =
        source['progressByPuzzleId'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    final dailyRaw =
        source['dailyProgressByDateKey'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return MatchingProgressState(
      progressByPuzzleId: {
        for (final entry in progressRaw.entries)
          entry.key: MatchingPuzzleProgress.fromJson(
            entry.value as Map<String, dynamic>?,
          ),
      },
      dailyProgressByDateKey: {
        for (final entry in dailyRaw.entries)
          entry.key: MatchingDailyProgress.fromJson(
            entry.value as Map<String, dynamic>?,
          ),
      },
    );
  }
}

class MatchingDailyStreakSummary {
  const MatchingDailyStreakSummary({
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;
}

class MatchingPackProgressSummary {
  const MatchingPackProgressSummary({
    required this.totalPuzzles,
    required this.completedPuzzles,
    required this.perfectPuzzles,
    required this.inProgressPuzzles,
    required this.nextPuzzleId,
  });

  final int totalPuzzles;
  final int completedPuzzles;
  final int perfectPuzzles;
  final int inProgressPuzzles;
  final String? nextPuzzleId;

  double get completionFraction =>
      totalPuzzles == 0 ? 0 : completedPuzzles / totalPuzzles;
}

class MatchingCatalog {
  const MatchingCatalog({
    required this.pairs,
    required this.puzzles,
    required this.packs,
  });

  final List<MatchingPair> pairs;
  final List<MatchingPuzzle> puzzles;
  final List<MatchingPuzzlePack> packs;

  Map<String, MatchingPair> get pairsById => {
    for (final pair in pairs) pair.id: pair,
  };

  Map<String, MatchingPuzzle> get puzzlesById => {
    for (final puzzle in puzzles) puzzle.id: puzzle,
  };

  Map<String, MatchingPuzzlePack> get packsById => {
    for (final pack in packs) pack.id: pack,
  };

  List<MatchingPuzzle> get kidsPuzzles => puzzles
      .where((puzzle) => puzzle.mode == MatchingMode.kids)
      .toList(growable: false);

  List<MatchingPuzzle> get adultPuzzles => puzzles
      .where((puzzle) => puzzle.mode == MatchingMode.adult)
      .toList(growable: false);

  MatchingPackProgressSummary progressForPack(
    String packId,
    MatchingProgressState progress,
  ) {
    final pack = packsById[packId];
    if (pack == null) {
      return const MatchingPackProgressSummary(
        totalPuzzles: 0,
        completedPuzzles: 0,
        perfectPuzzles: 0,
        inProgressPuzzles: 0,
        nextPuzzleId: null,
      );
    }
    final items = pack.puzzleIds
        .map((id) => puzzlesById[id])
        .whereType<MatchingPuzzle>()
        .toList(growable: false);
    var completed = 0;
    var perfect = 0;
    var inProgress = 0;
    String? nextPuzzleId;
    for (final puzzle in items) {
      final item = progress.progressFor(puzzle.id);
      if (item.isCompleted) {
        completed += 1;
      } else if (item.isStarted) {
        inProgress += 1;
      }
      if (item.isPerfect) {
        perfect += 1;
      }
      nextPuzzleId ??= item.isCompleted ? null : puzzle.id;
    }
    return MatchingPackProgressSummary(
      totalPuzzles: items.length,
      completedPuzzles: completed,
      perfectPuzzles: perfect,
      inProgressPuzzles: inProgress,
      nextPuzzleId: nextPuzzleId,
    );
  }
}

Set<String> _stringSet(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toSet();
  }
  return const <String>{};
}
