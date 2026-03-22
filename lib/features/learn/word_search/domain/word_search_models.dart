enum WordSearchMode { kids, adult }

enum WordSearchDirection {
  right,
  left,
  down,
  up,
  diagonalDownRight,
  diagonalUpRight,
}

enum WordSearchHintType { revealFirstLetter, highlightWord }

class WordSearchEntry {
  const WordSearchEntry({
    required this.id,
    required this.answer,
    required this.displayLabel,
    required this.clue,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.sourceType,
    required this.sourceRef,
    this.hint,
    this.imageKey,
    this.audioKey,
    this.isDailyEligible = false,
    this.dailyThemes = const <String>[],
    this.packTags = const <String>[],
    this.levelBandMin = 1,
    this.levelBandMax = 100,
  });

  final String id;
  final String answer;
  final String displayLabel;
  final String clue;
  final WordSearchMode mode;
  final String category;
  final int difficulty;
  final List<String> tags;
  final String sourceType;
  final String sourceRef;
  final String? hint;
  final String? imageKey;
  final String? audioKey;
  final bool isDailyEligible;
  final List<String> dailyThemes;
  final List<String> packTags;
  final int levelBandMin;
  final int levelBandMax;

  String get normalizedAnswer =>
      answer.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
}

class WordSearchPlacement {
  const WordSearchPlacement({
    required this.entryId,
    required this.word,
    required this.startRow,
    required this.startCol,
    required this.endRow,
    required this.endCol,
    required this.direction,
  });

  final String entryId;
  final String word;
  final int startRow;
  final int startCol;
  final int endRow;
  final int endCol;
  final WordSearchDirection direction;

  int get length => word.length;
}

class WordSearchPuzzle {
  const WordSearchPuzzle({
    required this.id,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.gridSize,
    required this.entryIds,
    required this.targetWords,
    required this.letterGrid,
    required this.placements,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.isDailyEligible,
    required this.dailyThemes,
    required this.packIds,
    this.isAssembled = true,
  });

  final String id;
  final WordSearchMode mode;
  final String category;
  final int difficulty;
  final int gridSize;
  final List<String> entryIds;
  final List<String> targetWords;
  final List<List<String>> letterGrid;
  final List<WordSearchPlacement> placements;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final bool isDailyEligible;
  final List<String> dailyThemes;
  final List<String> packIds;
  final bool isAssembled;
}

class WordSearchPuzzleSeed {
  const WordSearchPuzzleSeed({
    required this.id,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.gridSize,
    required this.entryIds,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    this.allowedDirections = const <WordSearchDirection>[
      WordSearchDirection.right,
      WordSearchDirection.down,
    ],
    this.isDailyEligible = false,
    this.dailyThemes = const <String>[],
  });

  final String id;
  final WordSearchMode mode;
  final String category;
  final int difficulty;
  final int gridSize;
  final List<String> entryIds;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final List<WordSearchDirection> allowedDirections;
  final bool isDailyEligible;
  final List<String> dailyThemes;
}

class WordSearchPuzzlePack {
  const WordSearchPuzzlePack({
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

class WordSearchDailyPuzzle {
  const WordSearchDailyPuzzle({
    required this.puzzle,
    required this.dateKey,
    required this.weekdayTheme,
    required this.targetDifficulty,
  });

  final WordSearchPuzzle puzzle;
  final String dateKey;
  final String weekdayTheme;
  final int targetDifficulty;
}

class WordSearchPuzzleProgress {
  const WordSearchPuzzleProgress({
    this.foundWordIds = const <String>{},
    this.highlightedWordIds = const <String>{},
    this.revealedFirstLetterWordIds = const <String>{},
    this.recentSelectionCellKeys = const <String>[],
    this.selectedStartCellKey,
    this.selectedEndCellKey,
    this.startedAtIso,
    this.lastPlayedAtIso,
    this.completedAtIso,
    this.perfectCompletedAtIso,
    this.completionRewardGrantedAtIso,
    this.perfectRewardGrantedAtIso,
    this.hadMistake = false,
    this.revealFirstLetterUses = 0,
    this.highlightWordUses = 0,
  });

  final Set<String> foundWordIds;
  final Set<String> highlightedWordIds;
  final Set<String> revealedFirstLetterWordIds;
  final List<String> recentSelectionCellKeys;
  final String? selectedStartCellKey;
  final String? selectedEndCellKey;
  final String? startedAtIso;
  final String? lastPlayedAtIso;
  final String? completedAtIso;
  final String? perfectCompletedAtIso;
  final String? completionRewardGrantedAtIso;
  final String? perfectRewardGrantedAtIso;
  final bool hadMistake;
  final int revealFirstLetterUses;
  final int highlightWordUses;

  bool get isStarted => (startedAtIso ?? '').isNotEmpty;
  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;
  bool get isPerfect => (perfectCompletedAtIso ?? '').isNotEmpty;
  bool get usedAnyHint => revealFirstLetterUses > 0 || highlightWordUses > 0;

  WordSearchPuzzleProgress copyWith({
    Set<String>? foundWordIds,
    Set<String>? highlightedWordIds,
    Set<String>? revealedFirstLetterWordIds,
    List<String>? recentSelectionCellKeys,
    String? selectedStartCellKey,
    bool clearSelectedStartCellKey = false,
    String? selectedEndCellKey,
    bool clearSelectedEndCellKey = false,
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
    int? revealFirstLetterUses,
    int? highlightWordUses,
  }) {
    return WordSearchPuzzleProgress(
      foundWordIds: foundWordIds ?? this.foundWordIds,
      highlightedWordIds: highlightedWordIds ?? this.highlightedWordIds,
      revealedFirstLetterWordIds:
          revealedFirstLetterWordIds ?? this.revealedFirstLetterWordIds,
      recentSelectionCellKeys:
          recentSelectionCellKeys ?? this.recentSelectionCellKeys,
      selectedStartCellKey: clearSelectedStartCellKey
          ? null
          : (selectedStartCellKey ?? this.selectedStartCellKey),
      selectedEndCellKey: clearSelectedEndCellKey
          ? null
          : (selectedEndCellKey ?? this.selectedEndCellKey),
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
      revealFirstLetterUses:
          revealFirstLetterUses ?? this.revealFirstLetterUses,
      highlightWordUses: highlightWordUses ?? this.highlightWordUses,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'foundWordIds': foundWordIds.toList(growable: false),
    'highlightedWordIds': highlightedWordIds.toList(growable: false),
    'revealedFirstLetterWordIds': revealedFirstLetterWordIds.toList(
      growable: false,
    ),
    'recentSelectionCellKeys': recentSelectionCellKeys,
    'selectedStartCellKey': selectedStartCellKey,
    'selectedEndCellKey': selectedEndCellKey,
    'startedAtIso': startedAtIso,
    'lastPlayedAtIso': lastPlayedAtIso,
    'completedAtIso': completedAtIso,
    'perfectCompletedAtIso': perfectCompletedAtIso,
    'completionRewardGrantedAtIso': completionRewardGrantedAtIso,
    'perfectRewardGrantedAtIso': perfectRewardGrantedAtIso,
    'hadMistake': hadMistake,
    'revealFirstLetterUses': revealFirstLetterUses,
    'highlightWordUses': highlightWordUses,
  };

  factory WordSearchPuzzleProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return WordSearchPuzzleProgress(
      foundWordIds: _stringSet(source['foundWordIds']),
      highlightedWordIds: _stringSet(source['highlightedWordIds']),
      revealedFirstLetterWordIds: _stringSet(
        source['revealedFirstLetterWordIds'],
      ),
      recentSelectionCellKeys: _stringList(source['recentSelectionCellKeys']),
      selectedStartCellKey: source['selectedStartCellKey']?.toString(),
      selectedEndCellKey: source['selectedEndCellKey']?.toString(),
      startedAtIso: source['startedAtIso']?.toString(),
      lastPlayedAtIso: source['lastPlayedAtIso']?.toString(),
      completedAtIso: source['completedAtIso']?.toString(),
      perfectCompletedAtIso: source['perfectCompletedAtIso']?.toString(),
      completionRewardGrantedAtIso: source['completionRewardGrantedAtIso']
          ?.toString(),
      perfectRewardGrantedAtIso: source['perfectRewardGrantedAtIso']
          ?.toString(),
      hadMistake: source['hadMistake'] == true,
      revealFirstLetterUses:
          (source['revealFirstLetterUses'] as num?)?.toInt() ?? 0,
      highlightWordUses: (source['highlightWordUses'] as num?)?.toInt() ?? 0,
    );
  }
}

class WordSearchDailyProgress {
  const WordSearchDailyProgress({
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

  factory WordSearchDailyProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return WordSearchDailyProgress(
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

class WordSearchProgressState {
  const WordSearchProgressState({
    required this.progressByPuzzleId,
    required this.dailyProgressByDateKey,
  });

  final Map<String, WordSearchPuzzleProgress> progressByPuzzleId;
  final Map<String, WordSearchDailyProgress> dailyProgressByDateKey;

  factory WordSearchProgressState.initial() => const WordSearchProgressState(
    progressByPuzzleId: <String, WordSearchPuzzleProgress>{},
    dailyProgressByDateKey: <String, WordSearchDailyProgress>{},
  );

  WordSearchPuzzleProgress progressFor(String puzzleId) =>
      progressByPuzzleId[puzzleId] ?? const WordSearchPuzzleProgress();

  WordSearchDailyProgress? dailyProgressFor(String dateKey) =>
      dailyProgressByDateKey[dateKey];

  WordSearchProgressState copyWith({
    Map<String, WordSearchPuzzleProgress>? progressByPuzzleId,
    Map<String, WordSearchDailyProgress>? dailyProgressByDateKey,
  }) {
    return WordSearchProgressState(
      progressByPuzzleId: progressByPuzzleId ?? this.progressByPuzzleId,
      dailyProgressByDateKey:
          dailyProgressByDateKey ?? this.dailyProgressByDateKey,
    );
  }

  WordSearchDailyStreakSummary dailyStreakSummary(DateTime now) {
    if (dailyProgressByDateKey.isEmpty) {
      return const WordSearchDailyStreakSummary(
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
    return WordSearchDailyStreakSummary(
      currentStreak: current,
      longestStreak: longest,
    );
  }

  List<WordSearchDailyProgress> recentDailyHistory({int limit = 7}) {
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

  factory WordSearchProgressState.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    final progressRaw =
        source['progressByPuzzleId'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    final dailyRaw =
        source['dailyProgressByDateKey'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return WordSearchProgressState(
      progressByPuzzleId: {
        for (final entry in progressRaw.entries)
          entry.key: WordSearchPuzzleProgress.fromJson(
            entry.value as Map<String, dynamic>?,
          ),
      },
      dailyProgressByDateKey: {
        for (final entry in dailyRaw.entries)
          entry.key: WordSearchDailyProgress.fromJson(
            entry.value as Map<String, dynamic>?,
          ),
      },
    );
  }
}

class WordSearchDailyStreakSummary {
  const WordSearchDailyStreakSummary({
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;
}

class WordSearchPackProgressSummary {
  const WordSearchPackProgressSummary({
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

class WordSearchCatalog {
  const WordSearchCatalog({
    required this.entries,
    required this.puzzles,
    required this.packs,
  });

  final List<WordSearchEntry> entries;
  final List<WordSearchPuzzle> puzzles;
  final List<WordSearchPuzzlePack> packs;

  Map<String, WordSearchEntry> get entriesById => {
    for (final entry in entries) entry.id: entry,
  };

  Map<String, WordSearchPuzzle> get puzzlesById => {
    for (final puzzle in puzzles) puzzle.id: puzzle,
  };

  Map<String, WordSearchPuzzlePack> get packsById => {
    for (final pack in packs) pack.id: pack,
  };

  List<WordSearchPuzzle> get kidsPuzzles => puzzles
      .where((puzzle) => puzzle.mode == WordSearchMode.kids)
      .toList(growable: false);

  List<WordSearchPuzzle> get adultPuzzles => puzzles
      .where((puzzle) => puzzle.mode == WordSearchMode.adult)
      .toList(growable: false);

  WordSearchPackProgressSummary progressForPack(
    String packId,
    WordSearchProgressState progress,
  ) {
    final pack = packsById[packId];
    if (pack == null) {
      return const WordSearchPackProgressSummary(
        totalPuzzles: 0,
        completedPuzzles: 0,
        perfectPuzzles: 0,
        inProgressPuzzles: 0,
        nextPuzzleId: null,
      );
    }
    final items = pack.puzzleIds
        .map((id) => puzzlesById[id])
        .whereType<WordSearchPuzzle>()
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
    return WordSearchPackProgressSummary(
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

List<String> _stringList(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList(growable: false);
  }
  return const <String>[];
}
