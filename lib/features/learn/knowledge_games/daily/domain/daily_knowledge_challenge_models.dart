import '../../domain/knowledge_game_variations.dart';

enum DailyKnowledgeGameType {
  crossword,
  wordSearch,
  matching,
  ayahCompletion,
  hadithReflection,
}

class KnowledgeGameRef {
  const KnowledgeGameRef({
    required this.gameType,
    required this.puzzleId,
    required this.routeName,
    required this.category,
    required this.difficulty,
    this.config = const KnowledgeGameConfig.standard(),
  });

  final DailyKnowledgeGameType gameType;
  final String puzzleId;
  final String routeName;
  final String category;
  final int difficulty;
  final KnowledgeGameConfig config;
}

class DailyChallengeBundle {
  const DailyChallengeBundle({
    required this.dateKey,
    required this.games,
    required this.completedGameTypes,
    required this.isCompleted,
    required this.completedCount,
  });

  final String dateKey;
  final List<KnowledgeGameRef> games;
  final Set<DailyKnowledgeGameType> completedGameTypes;
  final bool isCompleted;
  final int completedCount;
}

class DailyChallengeBundleProgress {
  const DailyChallengeBundleProgress({
    required this.dateKey,
    this.startedAtIso,
    this.completedAtIso,
    this.rewardGrantedAtIso,
  });

  final String dateKey;
  final String? startedAtIso;
  final String? completedAtIso;
  final String? rewardGrantedAtIso;

  bool get isCompleted => (completedAtIso ?? '').isNotEmpty;

  DailyChallengeBundleProgress copyWith({
    String? startedAtIso,
    bool clearStartedAtIso = false,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
    String? rewardGrantedAtIso,
    bool clearRewardGrantedAtIso = false,
  }) {
    return DailyChallengeBundleProgress(
      dateKey: dateKey,
      startedAtIso: clearStartedAtIso
          ? null
          : (startedAtIso ?? this.startedAtIso),
      completedAtIso: clearCompletedAtIso
          ? null
          : (completedAtIso ?? this.completedAtIso),
      rewardGrantedAtIso: clearRewardGrantedAtIso
          ? null
          : (rewardGrantedAtIso ?? this.rewardGrantedAtIso),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dateKey': dateKey,
    'startedAtIso': startedAtIso,
    'completedAtIso': completedAtIso,
    'rewardGrantedAtIso': rewardGrantedAtIso,
  };

  factory DailyChallengeBundleProgress.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return DailyChallengeBundleProgress(
      dateKey: source['dateKey']?.toString() ?? '',
      startedAtIso: source['startedAtIso']?.toString(),
      completedAtIso: source['completedAtIso']?.toString(),
      rewardGrantedAtIso: source['rewardGrantedAtIso']?.toString(),
    );
  }
}

class DailyChallengeHubProgressState {
  const DailyChallengeHubProgressState({required this.progressByDateKey});

  final Map<String, DailyChallengeBundleProgress> progressByDateKey;

  factory DailyChallengeHubProgressState.initial() =>
      const DailyChallengeHubProgressState(
        progressByDateKey: <String, DailyChallengeBundleProgress>{},
      );

  DailyChallengeBundleProgress progressFor(String dateKey) =>
      progressByDateKey[dateKey] ??
      DailyChallengeBundleProgress(dateKey: dateKey);

  DailyChallengeHubProgressState copyWith({
    Map<String, DailyChallengeBundleProgress>? progressByDateKey,
  }) {
    return DailyChallengeHubProgressState(
      progressByDateKey: progressByDateKey ?? this.progressByDateKey,
    );
  }

  DailyChallengeBundleStreakSummary streakSummary(DateTime now) {
    if (progressByDateKey.isEmpty) {
      return const DailyChallengeBundleStreakSummary(
        currentStreak: 0,
        longestStreak: 0,
      );
    }
    final completedKeys =
        progressByDateKey.values
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
      final item = progressByDateKey[key];
      if (item?.isCompleted != true) break;
      current += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return DailyChallengeBundleStreakSummary(
      currentStreak: current,
      longestStreak: longest,
    );
  }

  List<DailyChallengeBundleProgress> recentHistory({int limit = 7}) {
    final items = progressByDateKey.values.toList(growable: false)
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return items.take(limit).toList(growable: false);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'progressByDateKey': {
      for (final entry in progressByDateKey.entries)
        entry.key: entry.value.toJson(),
    },
  };

  factory DailyChallengeHubProgressState.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    final raw =
        source['progressByDateKey'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return DailyChallengeHubProgressState(
      progressByDateKey: {
        for (final entry in raw.entries)
          entry.key: DailyChallengeBundleProgress.fromJson(
            entry.value as Map<String, dynamic>?,
          ),
      },
    );
  }
}

class DailyChallengeBundleStreakSummary {
  const DailyChallengeBundleStreakSummary({
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;
}
