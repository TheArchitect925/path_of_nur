enum CrosswordMode { kids, adult, daily }

enum CrosswordDirection { across, down }

enum CrosswordClueType { direct, contextual, conceptual }

enum CrosswordDailyObjectiveType { perfect, hintFree, quickSolve }

class CrosswordEntry {
  const CrosswordEntry({
    required this.id,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.clue,
    required this.answer,
    this.hint,
    this.imageKey,
    this.audioKey,
    required this.sourceType,
    required this.tags,
    this.theme,
    this.clueType = CrosswordClueType.direct,
    this.isDailyEligible = false,
    this.levelBandMin = 1,
    this.levelBandMax = 100,
    this.packTags = const <String>[],
    this.sourceId,
  });

  final String id;
  final CrosswordMode mode;
  final String category;
  final int difficulty;
  final String clue;
  final String answer;
  final String? hint;
  final String? imageKey;
  final String? audioKey;
  final String sourceType;
  final List<String> tags;
  final String? theme;
  final CrosswordClueType clueType;
  final bool isDailyEligible;
  final int levelBandMin;
  final int levelBandMax;
  final List<String> packTags;
  final String? sourceId;

  String get normalizedAnswer =>
      answer.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
}

class CrosswordClue {
  const CrosswordClue({
    required this.id,
    required this.entryId,
    required this.clue,
    required this.answer,
    required this.row,
    required this.col,
    required this.isAcross,
    required this.category,
    required this.sourceType,
    required this.tags,
    this.hint,
    this.imageKey,
    this.audioKey,
    this.theme,
    this.clueType = CrosswordClueType.direct,
  });

  final String id;
  final String entryId;
  final String clue;
  final String answer;
  final int row;
  final int col;
  final bool isAcross;
  final String category;
  final String sourceType;
  final List<String> tags;
  final String? hint;
  final String? imageKey;
  final String? audioKey;
  final String? theme;
  final CrosswordClueType clueType;

  CrosswordDirection get direction =>
      isAcross ? CrosswordDirection.across : CrosswordDirection.down;

  int get length => answer.length;
}

class CrosswordPuzzle {
  const CrosswordPuzzle({
    required this.id,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.gridSize,
    required this.clues,
    required this.solutionGrid,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.clueType,
    required this.dailyThemes,
    required this.isDailyEligible,
    required this.layoutKey,
    this.isAssembled = false,
    this.sourcePackIds = const <String>[],
  });

  final String id;
  final CrosswordMode mode;
  final String category;
  final int difficulty;
  final int gridSize;
  final List<CrosswordClue> clues;
  final List<List<String>> solutionGrid;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final CrosswordClueType clueType;
  final List<String> dailyThemes;
  final bool isDailyEligible;
  final String layoutKey;
  final bool isAssembled;
  final List<String> sourcePackIds;

  int get wordCount => clues.length;

  int get overlapCount {
    final counts = <String, int>{};
    for (final clue in clues) {
      for (var index = 0; index < clue.answer.length; index += 1) {
        final row = clue.row + (clue.isAcross ? 0 : index);
        final col = clue.col + (clue.isAcross ? index : 0);
        final key = '$row:$col';
        counts[key] = (counts[key] ?? 0) + 1;
      }
    }
    return counts.values.where((value) => value > 1).length;
  }
}

class CrosswordContentBundle {
  const CrosswordContentBundle({
    required this.bundleId,
    required this.schemaVersion,
    required this.contentVersion,
    required this.layoutVersion,
  });

  final String bundleId;
  final int schemaVersion;
  final String contentVersion;
  final String layoutVersion;
}

class CrosswordSlot {
  const CrosswordSlot({
    required this.row,
    required this.col,
    required this.length,
    required this.isAcross,
  });

  final int row;
  final int col;
  final int length;
  final bool isAcross;
}

class CrosswordLayoutTemplate {
  const CrosswordLayoutTemplate({
    required this.id,
    required this.gridSize,
    required this.mode,
    required this.difficultyScore,
    required this.tags,
    required this.slots,
  });

  final String id;
  final int gridSize;
  final CrosswordMode mode;
  final int difficultyScore;
  final List<String> tags;
  final List<CrosswordSlot> slots;
}

class CrosswordPuzzlePack {
  const CrosswordPuzzlePack({
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

class CrosswordPackProgressSummary {
  const CrosswordPackProgressSummary({
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

class CrosswordCollectionProgressSummary {
  const CrosswordCollectionProgressSummary({
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

class CrosswordCatalog {
  const CrosswordCatalog({
    required this.entries,
    required this.puzzles,
    required this.packs,
    required this.templates,
  });

  final List<CrosswordEntry> entries;
  final List<CrosswordPuzzle> puzzles;
  final List<CrosswordPuzzlePack> packs;
  final List<CrosswordLayoutTemplate> templates;

  Map<String, CrosswordEntry> get entriesById => {
    for (final entry in entries) entry.id: entry,
  };

  Map<String, CrosswordPuzzle> get puzzlesById => {
    for (final puzzle in puzzles) puzzle.id: puzzle,
  };

  Map<String, CrosswordPuzzlePack> get packsById => {
    for (final pack in packs) pack.id: pack,
  };

  List<CrosswordPuzzle> get kidsPuzzles => puzzles
      .where((puzzle) => puzzle.mode == CrosswordMode.kids)
      .toList(growable: false);

  List<CrosswordPuzzle> get adultPuzzles => puzzles
      .where((puzzle) => puzzle.mode == CrosswordMode.adult)
      .toList(growable: false);

  CrosswordCollectionProgressSummary progressForMode(
    CrosswordMode mode,
    CrosswordProgressState progress,
  ) {
    final visiblePuzzles = puzzles
        .where((puzzle) => puzzle.mode == mode)
        .toList(growable: false);
    var completed = 0;
    var perfect = 0;
    var inProgress = 0;
    String? nextPuzzleId;
    for (final puzzle in visiblePuzzles) {
      final item = progress.progressFor(puzzle.id);
      if (item.isCompleted) {
        completed += 1;
        if (item.isPerfect) {
          perfect += 1;
        }
      } else if ((item.startedAtIso ?? '').isNotEmpty) {
        inProgress += 1;
        nextPuzzleId ??= puzzle.id;
      } else {
        nextPuzzleId ??= puzzle.id;
      }
    }
    return CrosswordCollectionProgressSummary(
      totalPuzzles: visiblePuzzles.length,
      completedPuzzles: completed,
      perfectPuzzles: perfect,
      inProgressPuzzles: inProgress,
      nextPuzzleId: nextPuzzleId,
    );
  }

  CrosswordPackProgressSummary progressForPack(
    String packId,
    CrosswordProgressState progress,
  ) {
    final pack = packsById[packId];
    if (pack == null) {
      return const CrosswordPackProgressSummary(
        totalPuzzles: 0,
        completedPuzzles: 0,
        perfectPuzzles: 0,
        inProgressPuzzles: 0,
        nextPuzzleId: null,
      );
    }
    var completed = 0;
    var perfect = 0;
    var inProgress = 0;
    String? nextPuzzleId;
    for (final puzzleId in pack.puzzleIds) {
      final item = progress.progressFor(puzzleId);
      if (item.isCompleted) {
        completed += 1;
        if (item.isPerfect) {
          perfect += 1;
        }
      } else if ((item.startedAtIso ?? '').isNotEmpty) {
        inProgress += 1;
        nextPuzzleId ??= puzzleId;
      } else {
        nextPuzzleId ??= puzzleId;
      }
    }
    return CrosswordPackProgressSummary(
      totalPuzzles: pack.puzzleIds.length,
      completedPuzzles: completed,
      perfectPuzzles: perfect,
      inProgressPuzzles: inProgress,
      nextPuzzleId: nextPuzzleId,
    );
  }
}

class CrosswordDailyPuzzle {
  const CrosswordDailyPuzzle({
    required this.puzzle,
    required this.weekdayTheme,
    required this.dateKey,
    required this.objectives,
    required this.targetDifficulty,
  });

  final CrosswordPuzzle puzzle;
  final String weekdayTheme;
  final String dateKey;
  final List<CrosswordDailyObjective> objectives;
  final int targetDifficulty;
}

class CrosswordDailyObjective {
  const CrosswordDailyObjective({
    required this.id,
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
    this.targetSeconds,
  });

  final String id;
  final CrosswordDailyObjectiveType type;
  final String titleKey;
  final String descriptionKey;
  final int? targetSeconds;
}

class CrosswordPuzzleProgress {
  const CrosswordPuzzleProgress({
    required this.puzzleId,
    this.solvedClueIds = const <String>{},
    this.enteredLettersByCell = const <String, String>{},
    this.revealedCellKeys = const <String>{},
    this.revealedClueIds = const <String>{},
    this.extraHintViewedClueIds = const <String>{},
    this.startedAtIso,
    this.completedAtIso,
    this.perfectCompletedAtIso,
    this.completionRewardGrantedAtIso,
    this.perfectRewardGrantedAtIso,
    this.lastPlayedAtIso,
    this.selectedCellKey,
    this.selectedDirection,
    this.revealLetterUses = 0,
    this.revealWordUses = 0,
    this.extraHintUses = 0,
    this.usedAnyHint = false,
    this.hadMistake = false,
  });

  final String puzzleId;
  final Set<String> solvedClueIds;
  final Map<String, String> enteredLettersByCell;
  final Set<String> revealedCellKeys;
  final Set<String> revealedClueIds;
  final Set<String> extraHintViewedClueIds;
  final String? startedAtIso;
  final String? completedAtIso;
  final String? perfectCompletedAtIso;
  final String? completionRewardGrantedAtIso;
  final String? perfectRewardGrantedAtIso;
  final String? lastPlayedAtIso;
  final String? selectedCellKey;
  final String? selectedDirection;
  final int revealLetterUses;
  final int revealWordUses;
  final int extraHintUses;
  final bool usedAnyHint;
  final bool hadMistake;

  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;
  bool get isPerfect => (perfectCompletedAtIso ?? '').isNotEmpty;

  CrosswordPuzzleProgress copyWith({
    Set<String>? solvedClueIds,
    Map<String, String>? enteredLettersByCell,
    Set<String>? revealedCellKeys,
    Set<String>? revealedClueIds,
    Set<String>? extraHintViewedClueIds,
    String? startedAtIso,
    String? completedAtIso,
    String? perfectCompletedAtIso,
    String? completionRewardGrantedAtIso,
    String? perfectRewardGrantedAtIso,
    String? lastPlayedAtIso,
    String? selectedCellKey,
    String? selectedDirection,
    int? revealLetterUses,
    int? revealWordUses,
    int? extraHintUses,
    bool? usedAnyHint,
    bool? hadMistake,
  }) {
    return CrosswordPuzzleProgress(
      puzzleId: puzzleId,
      solvedClueIds: solvedClueIds ?? this.solvedClueIds,
      enteredLettersByCell: enteredLettersByCell ?? this.enteredLettersByCell,
      revealedCellKeys: revealedCellKeys ?? this.revealedCellKeys,
      revealedClueIds: revealedClueIds ?? this.revealedClueIds,
      extraHintViewedClueIds:
          extraHintViewedClueIds ?? this.extraHintViewedClueIds,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      completedAtIso: completedAtIso ?? this.completedAtIso,
      perfectCompletedAtIso:
          perfectCompletedAtIso ?? this.perfectCompletedAtIso,
      completionRewardGrantedAtIso:
          completionRewardGrantedAtIso ?? this.completionRewardGrantedAtIso,
      perfectRewardGrantedAtIso:
          perfectRewardGrantedAtIso ?? this.perfectRewardGrantedAtIso,
      lastPlayedAtIso: lastPlayedAtIso ?? this.lastPlayedAtIso,
      selectedCellKey: selectedCellKey ?? this.selectedCellKey,
      selectedDirection: selectedDirection ?? this.selectedDirection,
      revealLetterUses: revealLetterUses ?? this.revealLetterUses,
      revealWordUses: revealWordUses ?? this.revealWordUses,
      extraHintUses: extraHintUses ?? this.extraHintUses,
      usedAnyHint: usedAnyHint ?? this.usedAnyHint,
      hadMistake: hadMistake ?? this.hadMistake,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'puzzleId': puzzleId,
    'solvedClueIds': solvedClueIds.toList(growable: false),
    'enteredLettersByCell': enteredLettersByCell,
    'revealedCellKeys': revealedCellKeys.toList(growable: false),
    'revealedClueIds': revealedClueIds.toList(growable: false),
    'extraHintViewedClueIds': extraHintViewedClueIds.toList(growable: false),
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
    'perfectCompletedAtIso': perfectCompletedAtIso,
    'completionRewardGrantedAtIso': completionRewardGrantedAtIso,
    'perfectRewardGrantedAtIso': perfectRewardGrantedAtIso,
    'lastPlayedAtIso': lastPlayedAtIso,
    'selectedCellKey': selectedCellKey,
    'selectedDirection': selectedDirection,
    'revealLetterUses': revealLetterUses,
    'revealWordUses': revealWordUses,
    'extraHintUses': extraHintUses,
    'usedAnyHint': usedAnyHint,
    'hadMistake': hadMistake,
  };

  static CrosswordPuzzleProgress fromJson(Map<String, dynamic> json) {
    final rawSolved = json['solvedClueIds'];
    final solved = <String>{};
    if (rawSolved is List) {
      for (final item in rawSolved) {
        final value = item.toString().trim();
        if (value.isNotEmpty) {
          solved.add(value);
        }
      }
    }
    final enteredLetters = <String, String>{};
    final rawCells = json['enteredLettersByCell'];
    if (rawCells is Map) {
      for (final entry in rawCells.entries) {
        final key = entry.key.toString();
        final value = entry.value.toString().trim();
        if (key.isNotEmpty && value.isNotEmpty) {
          enteredLetters[key] = value;
        }
      }
    }
    return CrosswordPuzzleProgress(
      puzzleId: json['puzzleId']?.toString() ?? '',
      solvedClueIds: solved,
      enteredLettersByCell: enteredLetters,
      revealedCellKeys: _readStringSet(json['revealedCellKeys']),
      revealedClueIds: _readStringSet(json['revealedClueIds']),
      extraHintViewedClueIds: _readStringSet(json['extraHintViewedClueIds']),
      startedAtIso: json['startedAtIso']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
      perfectCompletedAtIso: json['perfectCompletedAtIso']?.toString(),
      completionRewardGrantedAtIso: json['completionRewardGrantedAtIso']
          ?.toString(),
      perfectRewardGrantedAtIso: json['perfectRewardGrantedAtIso']?.toString(),
      lastPlayedAtIso: json['lastPlayedAtIso']?.toString(),
      selectedCellKey: json['selectedCellKey']?.toString(),
      selectedDirection: json['selectedDirection']?.toString(),
      revealLetterUses: _asInt(json['revealLetterUses']),
      revealWordUses: _asInt(json['revealWordUses']),
      extraHintUses: _asInt(json['extraHintUses']),
      usedAnyHint: json['usedAnyHint'] == true,
      hadMistake: json['hadMistake'] == true,
    );
  }
}

class CrosswordDailyProgress {
  const CrosswordDailyProgress({
    required this.dateKey,
    required this.puzzleId,
    this.weekdayTheme,
    this.startedAtIso,
    this.completedAtIso,
    this.perfectCompletedAtIso,
    this.bonusCompletedObjectiveIds = const <String>{},
    this.timeTakenSeconds,
    this.dailyRewardGrantedAtIso,
    this.dailyBonusRewardGrantedAtIso,
  });

  final String dateKey;
  final String puzzleId;
  final String? weekdayTheme;
  final String? startedAtIso;
  final String? completedAtIso;
  final String? perfectCompletedAtIso;
  final Set<String> bonusCompletedObjectiveIds;
  final int? timeTakenSeconds;
  final String? dailyRewardGrantedAtIso;
  final String? dailyBonusRewardGrantedAtIso;

  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;
  bool get hasBonusCompletion => bonusCompletedObjectiveIds.isNotEmpty;

  CrosswordDailyProgress copyWith({
    String? weekdayTheme,
    String? startedAtIso,
    String? completedAtIso,
    String? perfectCompletedAtIso,
    Set<String>? bonusCompletedObjectiveIds,
    int? timeTakenSeconds,
    String? dailyRewardGrantedAtIso,
    String? dailyBonusRewardGrantedAtIso,
  }) {
    return CrosswordDailyProgress(
      dateKey: dateKey,
      puzzleId: puzzleId,
      weekdayTheme: weekdayTheme ?? this.weekdayTheme,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      completedAtIso: completedAtIso ?? this.completedAtIso,
      perfectCompletedAtIso:
          perfectCompletedAtIso ?? this.perfectCompletedAtIso,
      bonusCompletedObjectiveIds:
          bonusCompletedObjectiveIds ?? this.bonusCompletedObjectiveIds,
      timeTakenSeconds: timeTakenSeconds ?? this.timeTakenSeconds,
      dailyRewardGrantedAtIso:
          dailyRewardGrantedAtIso ?? this.dailyRewardGrantedAtIso,
      dailyBonusRewardGrantedAtIso:
          dailyBonusRewardGrantedAtIso ?? this.dailyBonusRewardGrantedAtIso,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'dateKey': dateKey,
    'puzzleId': puzzleId,
    'weekdayTheme': weekdayTheme,
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
    'perfectCompletedAtIso': perfectCompletedAtIso,
    'bonusCompletedObjectiveIds': bonusCompletedObjectiveIds.toList(
      growable: false,
    ),
    'timeTakenSeconds': timeTakenSeconds,
    'dailyRewardGrantedAtIso': dailyRewardGrantedAtIso,
    'dailyBonusRewardGrantedAtIso': dailyBonusRewardGrantedAtIso,
  };

  static CrosswordDailyProgress fromJson(Map<String, dynamic> json) {
    return CrosswordDailyProgress(
      dateKey: json['dateKey']?.toString() ?? '',
      puzzleId: json['puzzleId']?.toString() ?? '',
      weekdayTheme: json['weekdayTheme']?.toString(),
      startedAtIso: json['startedAtIso']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
      perfectCompletedAtIso: json['perfectCompletedAtIso']?.toString(),
      bonusCompletedObjectiveIds: _readStringSet(
        json['bonusCompletedObjectiveIds'],
      ),
      timeTakenSeconds: _readNullableInt(json['timeTakenSeconds']),
      dailyRewardGrantedAtIso: json['dailyRewardGrantedAtIso']?.toString(),
      dailyBonusRewardGrantedAtIso: json['dailyBonusRewardGrantedAtIso']
          ?.toString(),
    );
  }
}

class CrosswordDailyStreakSummary {
  const CrosswordDailyStreakSummary({
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompletedDays,
  });

  final int currentStreak;
  final int bestStreak;
  final int totalCompletedDays;
}

class CrosswordProgressState {
  const CrosswordProgressState({
    required this.progressByPuzzleId,
    required this.dailyProgressByDateKey,
  });

  final Map<String, CrosswordPuzzleProgress> progressByPuzzleId;
  final Map<String, CrosswordDailyProgress> dailyProgressByDateKey;

  CrosswordPuzzleProgress progressFor(String puzzleId) {
    return progressByPuzzleId[puzzleId] ??
        CrosswordPuzzleProgress(puzzleId: puzzleId);
  }

  CrosswordDailyProgress? dailyProgressFor(String dateKey) {
    return dailyProgressByDateKey[dateKey];
  }

  CrosswordDailyStreakSummary dailyStreakSummary(DateTime now) {
    final completed = dailyProgressByDateKey.values
        .where((item) => item.isCompleted)
        .map((item) => item.dateKey)
        .toSet();
    final sorted = completed.toList(growable: false)..sort();
    var best = 0;
    var running = 0;
    DateTime? previous;
    for (final key in sorted) {
      final date = DateTime.tryParse('${key}T00:00:00');
      if (date == null) continue;
      if (previous != null && previous.add(const Duration(days: 1)) == date) {
        running += 1;
      } else {
        running = 1;
      }
      if (running > best) {
        best = running;
      }
      previous = date;
    }

    var current = 0;
    var cursor = DateTime(now.year, now.month, now.day);
    while (completed.contains(_dateKey(cursor))) {
      current += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return CrosswordDailyStreakSummary(
      currentStreak: current,
      bestStreak: best,
      totalCompletedDays: completed.length,
    );
  }

  List<CrosswordDailyProgress> recentDailyHistory({
    int limit = 7,
    bool completedOnly = false,
  }) {
    final items =
        dailyProgressByDateKey.values
            .where((item) => !completedOnly || item.isCompleted)
            .toList(growable: false)
          ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    if (items.length <= limit) {
      return items;
    }
    return items.take(limit).toList(growable: false);
  }

  CrosswordProgressState copyWith({
    Map<String, CrosswordPuzzleProgress>? progressByPuzzleId,
    Map<String, CrosswordDailyProgress>? dailyProgressByDateKey,
  }) {
    return CrosswordProgressState(
      progressByPuzzleId: progressByPuzzleId ?? this.progressByPuzzleId,
      dailyProgressByDateKey:
          dailyProgressByDateKey ?? this.dailyProgressByDateKey,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'progressByPuzzleId': progressByPuzzleId.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'dailyProgressByDateKey': dailyProgressByDateKey.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
  };

  static CrosswordProgressState initial() => const CrosswordProgressState(
    progressByPuzzleId: {},
    dailyProgressByDateKey: {},
  );

  static CrosswordProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial();
    final raw = json['progressByPuzzleId'];
    final next = <String, CrosswordPuzzleProgress>{};
    if (raw is Map) {
      for (final entry in raw.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          final progress = CrosswordPuzzleProgress.fromJson(value);
          if (progress.puzzleId.isNotEmpty) {
            next[progress.puzzleId] = progress;
          }
        } else if (value is Map) {
          final mapped = value.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          final progress = CrosswordPuzzleProgress.fromJson(mapped);
          if (progress.puzzleId.isNotEmpty) {
            next[progress.puzzleId] = progress;
          }
        }
      }
    }
    final rawDaily = json['dailyProgressByDateKey'];
    final daily = <String, CrosswordDailyProgress>{};
    if (rawDaily is Map) {
      for (final entry in rawDaily.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          final progress = CrosswordDailyProgress.fromJson(value);
          if (progress.dateKey.isNotEmpty) {
            daily[progress.dateKey] = progress;
          }
        } else if (value is Map) {
          final mapped = value.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          final progress = CrosswordDailyProgress.fromJson(mapped);
          if (progress.dateKey.isNotEmpty) {
            daily[progress.dateKey] = progress;
          }
        }
      }
    }
    return CrosswordProgressState(
      progressByPuzzleId: next,
      dailyProgressByDateKey: daily,
    );
  }
}

Set<String> _readStringSet(Object? raw) {
  final out = <String>{};
  if (raw is List) {
    for (final item in raw) {
      final value = item.toString().trim();
      if (value.isNotEmpty) {
        out.add(value);
      }
    }
  }
  return out;
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _readNullableInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

String _dateKey(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  return '${normalized.year.toString().padLeft(4, '0')}-'
      '${normalized.month.toString().padLeft(2, '0')}-'
      '${normalized.day.toString().padLeft(2, '0')}';
}
