import '../../quran/domain/quran_content_refs.dart';

enum AyahCompletionMode { kids, adult }

enum AyahCompletionHintType { revealBlank }

class AyahCompletionPuzzleSeed {
  const AyahCompletionPuzzleSeed({
    required this.id,
    required this.ref,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.blankWordIndexes,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    this.isDailyEligible = false,
    this.dailyThemes = const <String>[],
  });

  final String id;
  final QuranQuoteRef ref;
  final AyahCompletionMode mode;
  final String category;
  final int difficulty;
  final List<int> blankWordIndexes;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final bool isDailyEligible;
  final List<String> dailyThemes;
}

class AyahCompletionBlank {
  const AyahCompletionBlank({
    required this.blankIndex,
    required this.wordIndex,
    required this.correctWord,
    required this.options,
  });

  final int blankIndex;
  final int wordIndex;
  final String correctWord;
  final List<String> options;
}

class AyahCompletionPuzzle {
  const AyahCompletionPuzzle({
    required this.id,
    required this.ref,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.arabicWords,
    required this.fullArabicText,
    required this.translation,
    required this.blanks,
    required this.tags,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.isDailyEligible,
    required this.dailyThemes,
    required this.packIds,
  });

  final String id;
  final QuranQuoteRef ref;
  final AyahCompletionMode mode;
  final String category;
  final int difficulty;
  final List<String> arabicWords;
  final String fullArabicText;
  final String translation;
  final List<AyahCompletionBlank> blanks;
  final List<String> tags;
  final int levelBandMin;
  final int levelBandMax;
  final bool isDailyEligible;
  final List<String> dailyThemes;
  final List<String> packIds;

  int get surahNumber => ref.surah;
  int get ayahNumber => ref.ayah;
}

class AyahCompletionPuzzlePack {
  const AyahCompletionPuzzlePack({
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

class AyahCompletionDailyPuzzle {
  const AyahCompletionDailyPuzzle({
    required this.puzzle,
    required this.dateKey,
    required this.weekdayTheme,
    required this.targetDifficulty,
  });

  final AyahCompletionPuzzle puzzle;
  final String dateKey;
  final String weekdayTheme;
  final int targetDifficulty;
}

class AyahCompletionPuzzleProgress {
  const AyahCompletionPuzzleProgress({
    this.filledWordsByBlankIndex = const <String, String>{},
    this.revealedBlankIndexes = const <String>{},
    this.selectedBlankIndex,
    this.startedAtIso,
    this.lastPlayedAtIso,
    this.completedAtIso,
    this.perfectCompletedAtIso,
    this.completionRewardGrantedAtIso,
    this.perfectRewardGrantedAtIso,
    this.hadMistake = false,
    this.revealBlankUses = 0,
  });

  final Map<String, String> filledWordsByBlankIndex;
  final Set<String> revealedBlankIndexes;
  final int? selectedBlankIndex;
  final String? startedAtIso;
  final String? lastPlayedAtIso;
  final String? completedAtIso;
  final String? perfectCompletedAtIso;
  final String? completionRewardGrantedAtIso;
  final String? perfectRewardGrantedAtIso;
  final bool hadMistake;
  final int revealBlankUses;

  bool get isStarted => (startedAtIso ?? '').isNotEmpty;
  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;
  bool get isPerfect => (perfectCompletedAtIso ?? '').isNotEmpty;
  bool get usedAnyHint => revealBlankUses > 0;

  AyahCompletionPuzzleProgress copyWith({
    Map<String, String>? filledWordsByBlankIndex,
    Set<String>? revealedBlankIndexes,
    int? selectedBlankIndex,
    bool clearSelectedBlankIndex = false,
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
    int? revealBlankUses,
  }) {
    return AyahCompletionPuzzleProgress(
      filledWordsByBlankIndex:
          filledWordsByBlankIndex ?? this.filledWordsByBlankIndex,
      revealedBlankIndexes: revealedBlankIndexes ?? this.revealedBlankIndexes,
      selectedBlankIndex: clearSelectedBlankIndex
          ? null
          : (selectedBlankIndex ?? this.selectedBlankIndex),
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
      revealBlankUses: revealBlankUses ?? this.revealBlankUses,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'filledWordsByBlankIndex': filledWordsByBlankIndex,
    'revealedBlankIndexes': revealedBlankIndexes.toList(growable: false),
    'selectedBlankIndex': selectedBlankIndex,
    'startedAtIso': startedAtIso,
    'lastPlayedAtIso': lastPlayedAtIso,
    'completedAtIso': completedAtIso,
    'perfectCompletedAtIso': perfectCompletedAtIso,
    'completionRewardGrantedAtIso': completionRewardGrantedAtIso,
    'perfectRewardGrantedAtIso': perfectRewardGrantedAtIso,
    'hadMistake': hadMistake,
    'revealBlankUses': revealBlankUses,
  };

  factory AyahCompletionPuzzleProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    final rawFilled = source['filledWordsByBlankIndex'];
    return AyahCompletionPuzzleProgress(
      filledWordsByBlankIndex: rawFilled is Map
          ? rawFilled.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : const <String, String>{},
      revealedBlankIndexes: _stringSet(source['revealedBlankIndexes']),
      selectedBlankIndex: (source['selectedBlankIndex'] as num?)?.toInt(),
      startedAtIso: source['startedAtIso']?.toString(),
      lastPlayedAtIso: source['lastPlayedAtIso']?.toString(),
      completedAtIso: source['completedAtIso']?.toString(),
      perfectCompletedAtIso: source['perfectCompletedAtIso']?.toString(),
      completionRewardGrantedAtIso: source['completionRewardGrantedAtIso']
          ?.toString(),
      perfectRewardGrantedAtIso: source['perfectRewardGrantedAtIso']
          ?.toString(),
      hadMistake: source['hadMistake'] == true,
      revealBlankUses: (source['revealBlankUses'] as num?)?.toInt() ?? 0,
    );
  }
}

class AyahCompletionDailyProgress {
  const AyahCompletionDailyProgress({
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

  factory AyahCompletionDailyProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return AyahCompletionDailyProgress(
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

class AyahCompletionProgressState {
  const AyahCompletionProgressState({
    required this.progressByPuzzleId,
    required this.dailyProgressByDateKey,
  });

  final Map<String, AyahCompletionPuzzleProgress> progressByPuzzleId;
  final Map<String, AyahCompletionDailyProgress> dailyProgressByDateKey;

  factory AyahCompletionProgressState.initial() =>
      const AyahCompletionProgressState(
        progressByPuzzleId: <String, AyahCompletionPuzzleProgress>{},
        dailyProgressByDateKey: <String, AyahCompletionDailyProgress>{},
      );

  AyahCompletionPuzzleProgress progressFor(String puzzleId) =>
      progressByPuzzleId[puzzleId] ?? const AyahCompletionPuzzleProgress();

  AyahCompletionDailyProgress? dailyProgressFor(String dateKey) =>
      dailyProgressByDateKey[dateKey];

  AyahCompletionProgressState copyWith({
    Map<String, AyahCompletionPuzzleProgress>? progressByPuzzleId,
    Map<String, AyahCompletionDailyProgress>? dailyProgressByDateKey,
  }) {
    return AyahCompletionProgressState(
      progressByPuzzleId: progressByPuzzleId ?? this.progressByPuzzleId,
      dailyProgressByDateKey:
          dailyProgressByDateKey ?? this.dailyProgressByDateKey,
    );
  }

  AyahCompletionDailyStreakSummary dailyStreakSummary(DateTime now) {
    if (dailyProgressByDateKey.isEmpty) {
      return const AyahCompletionDailyStreakSummary(
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
    return AyahCompletionDailyStreakSummary(
      currentStreak: current,
      longestStreak: longest,
    );
  }

  List<AyahCompletionDailyProgress> recentDailyHistory({int limit = 7}) {
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

  factory AyahCompletionProgressState.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    final rawProgress = source['progressByPuzzleId'];
    final rawDaily = source['dailyProgressByDateKey'];
    return AyahCompletionProgressState(
      progressByPuzzleId: rawProgress is Map
          ? rawProgress.map(
              (key, value) => MapEntry(
                key.toString(),
                AyahCompletionPuzzleProgress.fromJson(
                  value is Map<String, dynamic>
                      ? value
                      : Map<String, dynamic>.from(value as Map),
                ),
              ),
            )
          : const <String, AyahCompletionPuzzleProgress>{},
      dailyProgressByDateKey: rawDaily is Map
          ? rawDaily.map(
              (key, value) => MapEntry(
                key.toString(),
                AyahCompletionDailyProgress.fromJson(
                  value is Map<String, dynamic>
                      ? value
                      : Map<String, dynamic>.from(value as Map),
                ),
              ),
            )
          : const <String, AyahCompletionDailyProgress>{},
    );
  }
}

class AyahCompletionDailyStreakSummary {
  const AyahCompletionDailyStreakSummary({
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;
}

class AyahCompletionPackProgressSummary {
  const AyahCompletionPackProgressSummary({
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

class AyahCompletionCatalog {
  const AyahCompletionCatalog({required this.puzzles, required this.packs});

  final List<AyahCompletionPuzzle> puzzles;
  final List<AyahCompletionPuzzlePack> packs;

  Map<String, AyahCompletionPuzzle> get puzzlesById => {
    for (final puzzle in puzzles) puzzle.id: puzzle,
  };

  Map<String, AyahCompletionPuzzlePack> get packsById => {
    for (final pack in packs) pack.id: pack,
  };

  List<AyahCompletionPuzzle> get kidsPuzzles => puzzles
      .where((puzzle) => puzzle.mode == AyahCompletionMode.kids)
      .toList(growable: false);

  List<AyahCompletionPuzzle> get adultPuzzles => puzzles
      .where((puzzle) => puzzle.mode == AyahCompletionMode.adult)
      .toList(growable: false);

  AyahCompletionPackProgressSummary progressForPack(
    String packId,
    AyahCompletionProgressState progress,
  ) {
    final pack = packsById[packId];
    if (pack == null) {
      return const AyahCompletionPackProgressSummary(
        totalPuzzles: 0,
        completedPuzzles: 0,
        perfectPuzzles: 0,
        inProgressPuzzles: 0,
        nextPuzzleId: null,
      );
    }
    final items = pack.puzzleIds
        .map((id) => puzzlesById[id])
        .whereType<AyahCompletionPuzzle>()
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
    return AyahCompletionPackProgressSummary(
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
