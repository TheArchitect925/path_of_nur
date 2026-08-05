import 'dart:math' as math;

import '../../../ayah_completion/domain/ayah_completion_models.dart';
import '../../../crossword/domain/crossword_models.dart';
import '../../../hadith_reflection/domain/hadith_reflection_models.dart';
import '../../../matching/domain/matching_models.dart';
import '../../../word_search/domain/word_search_models.dart';
import '../domain/user_learning_profile_models.dart';

class AdaptiveLearningEngine {
  const AdaptiveLearningEngine();

  UserLearningProfile buildProfile({
    required CrosswordCatalog crosswordCatalog,
    required CrosswordProgressState crosswordProgress,
    required WordSearchCatalog wordSearchCatalog,
    required WordSearchProgressState wordSearchProgress,
    required MatchingCatalog matchingCatalog,
    required MatchingProgressState matchingProgress,
    required AyahCompletionCatalog ayahCompletionCatalog,
    required AyahCompletionProgressState ayahCompletionProgress,
    required HadithReflectionCatalog hadithReflectionCatalog,
    required HadithReflectionProgressState hadithReflectionProgress,
    required DateTime now,
  }) {
    final signals = <_AdaptiveSignal>[
      ..._crosswordSignals(crosswordCatalog, crosswordProgress),
      ..._wordSearchSignals(wordSearchCatalog, wordSearchProgress),
      ..._matchingSignals(matchingCatalog, matchingProgress),
      ..._ayahCompletionSignals(ayahCompletionCatalog, ayahCompletionProgress),
      ..._hadithReflectionSignals(
        hadithReflectionCatalog,
        hadithReflectionProgress,
      ),
    ]..sort((a, b) => _sortIsoDesc(a.activityAtIso, b.activityAtIso));

    if (signals.isEmpty) {
      return UserLearningProfile.initial().copyWith(
        lastUpdatedAtIso: now.toIso8601String(),
      );
    }

    final categoryScores = <String, List<double>>{};
    final gameTypeScores = <String, List<double>>{};
    final comfortScores = <String, List<double>>{};
    final recentPerformance = <String, int>{};

    for (final signal in signals) {
      final score = _scoreSignal(signal);
      categoryScores.putIfAbsent(signal.category, () => <double>[]).add(score);
      gameTypeScores.putIfAbsent(signal.gameType, () => <double>[]).add(score);
      if (signal.completed) {
        comfortScores
            .putIfAbsent(signal.gameType, () => <double>[])
            .add((signal.difficulty / 100).clamp(0.05, 1.0));
      }
    }

    for (final signal in signals.take(12)) {
      if (!signal.completed) continue;
      recentPerformance.update(
        'game:${signal.gameType}',
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      recentPerformance.update(
        'category:${signal.category}',
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    final categoryStrength = {
      for (final entry in categoryScores.entries)
        entry.key: _average(entry.value).clamp(0.2, 0.95),
    };
    final gameTypeStrength = {
      for (final entry in gameTypeScores.entries)
        entry.key: _average(entry.value).clamp(0.2, 0.95),
    };
    final difficultyComfort = {
      for (final entry in comfortScores.entries)
        entry.key: _average(entry.value).clamp(0.1, 1.0),
    };
    final overallSkillLevel = gameTypeStrength.isEmpty
        ? 0.5
        : _average(gameTypeStrength.values);

    final focusCategory = _lowestKey(categoryStrength);
    final strongestCategory = _highestKey(categoryStrength);
    final supportGameType = _lowestKey(gameTypeStrength);
    final challengeGameType = _highestKey(gameTypeStrength);

    return UserLearningProfile(
      categoryStrength: categoryStrength,
      gameTypeStrength: gameTypeStrength,
      overallSkillLevel: overallSkillLevel.clamp(0.2, 0.95),
      recentPerformance: recentPerformance,
      difficultyComfort: difficultyComfort,
      focusCategory: focusCategory,
      strongestCategory: strongestCategory,
      supportGameType: supportGameType,
      challengeGameType: challengeGameType,
      lastUpdatedAtIso: now.toIso8601String(),
    );
  }

  AdaptiveLearningInsight buildInsight(UserLearningProfile profile) {
    final hasAdaptiveData =
        profile.categoryStrength.isNotEmpty ||
        profile.gameTypeStrength.isNotEmpty;
    return AdaptiveLearningInsight(
      hasAdaptiveData: hasAdaptiveData,
      supportGameType: profile.supportGameType,
      challengeGameType: profile.challengeGameType,
      focusCategory: profile.focusCategory,
    );
  }

  int personalizedTargetDifficulty({
    required UserLearningProfile profile,
    required String gameType,
    required int baseTarget,
    int minDifficulty = 1,
    int maxDifficulty = 100,
  }) {
    final strength = profile.gameTypeScore(gameType);
    final comfort = profile.comfortScore(gameType);
    var adjustment = 0;
    if (strength >= 0.74 && comfort >= 0.5) {
      adjustment = 5;
    } else if (strength >= 0.64) {
      adjustment = 3;
    } else if (strength <= 0.36) {
      adjustment = -5;
    } else if (strength <= 0.46) {
      adjustment = -3;
    } else if (comfort <= 0.2) {
      adjustment = -2;
    }
    return (baseTarget + adjustment).clamp(minDifficulty, maxDifficulty);
  }

  double selectionPriority({
    required UserLearningProfile profile,
    required String gameType,
    required String category,
    required int difficulty,
    required int targetDifficulty,
  }) {
    final difficultyGap = (difficulty - targetDifficulty).abs().toDouble();
    final supportBias = (1 - profile.categoryScore(category)) * 3.5;
    final interestBias = math.min(
      profile.recentCount('category:$category') * 0.25,
      1.0,
    );
    final gameBias = (1 - profile.gameTypeScore(gameType)) * 1.2;
    return difficultyGap - supportBias - interestBias - gameBias;
  }

  List<_AdaptiveSignal> _crosswordSignals(
    CrosswordCatalog catalog,
    CrosswordProgressState progress,
  ) {
    final latestTimeByPuzzle = _latestTimeByPuzzle(
      progress.dailyProgressByDateKey.values.map(
        (item) => _TimedDailyProgress(
          puzzleId: item.puzzleId,
          timeTakenSeconds: item.timeTakenSeconds,
        ),
      ),
    );
    return progress.progressByPuzzleId.entries
        .map((entry) {
          final puzzle = catalog.puzzlesById[entry.key];
          if (puzzle == null) return null;
          final item = entry.value;
          return _AdaptiveSignal(
            gameType: 'crossword',
            category: puzzle.category,
            difficulty: puzzle.difficulty,
            started: (item.startedAtIso ?? '').isNotEmpty,
            completed: item.isCompleted,
            perfect: item.isPerfect,
            usedHint: item.usedAnyHint,
            hadMistake: item.hadMistake,
            timeTakenSeconds: latestTimeByPuzzle[puzzle.id],
            activityAtIso:
                item.lastPlayedAtIso ??
                item.completedAtIso ??
                item.startedAtIso,
          );
        })
        .whereType<_AdaptiveSignal>()
        .toList(growable: false);
  }

  List<_AdaptiveSignal> _wordSearchSignals(
    WordSearchCatalog catalog,
    WordSearchProgressState progress,
  ) {
    final latestTimeByPuzzle = _latestTimeByPuzzle(
      progress.dailyProgressByDateKey.values.map(
        (item) => _TimedDailyProgress(
          puzzleId: item.puzzleId,
          timeTakenSeconds: item.timeTakenSeconds,
        ),
      ),
    );
    return progress.progressByPuzzleId.entries
        .map((entry) {
          final puzzle = catalog.puzzlesById[entry.key];
          if (puzzle == null) return null;
          final item = entry.value;
          return _AdaptiveSignal(
            gameType: 'word_search',
            category: puzzle.category,
            difficulty: puzzle.difficulty,
            started: item.isStarted,
            completed: item.isCompleted,
            perfect: item.isPerfect,
            usedHint: item.usedAnyHint,
            hadMistake: item.hadMistake,
            timeTakenSeconds: latestTimeByPuzzle[puzzle.id],
            activityAtIso:
                item.lastPlayedAtIso ??
                item.completedAtIso ??
                item.startedAtIso,
          );
        })
        .whereType<_AdaptiveSignal>()
        .toList(growable: false);
  }

  List<_AdaptiveSignal> _matchingSignals(
    MatchingCatalog catalog,
    MatchingProgressState progress,
  ) {
    final latestTimeByPuzzle = _latestTimeByPuzzle(
      progress.dailyProgressByDateKey.values.map(
        (item) => _TimedDailyProgress(
          puzzleId: item.puzzleId,
          timeTakenSeconds: item.timeTakenSeconds,
        ),
      ),
    );
    return progress.progressByPuzzleId.entries
        .map((entry) {
          final puzzle = catalog.puzzlesById[entry.key];
          if (puzzle == null) return null;
          final item = entry.value;
          return _AdaptiveSignal(
            gameType: 'matching',
            category: puzzle.category,
            difficulty: puzzle.difficulty,
            started: item.isStarted,
            completed: item.isCompleted,
            perfect: item.isPerfect,
            usedHint: item.usedAnyHint,
            hadMistake: item.hadMistake,
            timeTakenSeconds: latestTimeByPuzzle[puzzle.id],
            activityAtIso:
                item.lastPlayedAtIso ??
                item.completedAtIso ??
                item.startedAtIso,
          );
        })
        .whereType<_AdaptiveSignal>()
        .toList(growable: false);
  }

  List<_AdaptiveSignal> _ayahCompletionSignals(
    AyahCompletionCatalog catalog,
    AyahCompletionProgressState progress,
  ) {
    final latestTimeByPuzzle = _latestTimeByPuzzle(
      progress.dailyProgressByDateKey.values.map(
        (item) => _TimedDailyProgress(
          puzzleId: item.puzzleId,
          timeTakenSeconds: item.timeTakenSeconds,
        ),
      ),
    );
    return progress.progressByPuzzleId.entries
        .map((entry) {
          final puzzle = catalog.puzzlesById[entry.key];
          if (puzzle == null) return null;
          final item = entry.value;
          return _AdaptiveSignal(
            gameType: 'ayah_completion',
            category: puzzle.category,
            difficulty: puzzle.difficulty,
            started: item.isStarted,
            completed: item.isCompleted,
            perfect: item.isPerfect,
            usedHint: item.usedAnyHint,
            hadMistake: item.hadMistake,
            timeTakenSeconds: latestTimeByPuzzle[puzzle.id],
            activityAtIso:
                item.lastPlayedAtIso ??
                item.completedAtIso ??
                item.startedAtIso,
          );
        })
        .whereType<_AdaptiveSignal>()
        .toList(growable: false);
  }

  List<_AdaptiveSignal> _hadithReflectionSignals(
    HadithReflectionCatalog catalog,
    HadithReflectionProgressState progress,
  ) {
    return progress.progressByPuzzleId.entries
        .map((entry) {
          final puzzle = catalog.puzzlesById[entry.key];
          if (puzzle == null) return null;
          final item = entry.value;
          return _AdaptiveSignal(
            gameType: 'hadith_reflection',
            category: puzzle.category,
            difficulty: puzzle.difficulty,
            started: item.isStarted,
            completed: item.isCompleted,
            perfect: item.isBestChoice,
            usedHint: item.helpViewed,
            hadMistake: item.selectedChoiceId != null && !item.isBestChoice,
            timeTakenSeconds: null,
            activityAtIso:
                item.lastPlayedAtIso ??
                item.completedAtIso ??
                item.startedAtIso,
          );
        })
        .whereType<_AdaptiveSignal>()
        .toList(growable: false);
  }

  double _scoreSignal(_AdaptiveSignal signal) {
    var score = signal.completed ? 0.72 : 0.38;
    if (signal.perfect) score += 0.18;
    if (signal.usedHint) score -= 0.12;
    if (signal.hadMistake) score -= 0.10;
    if (signal.started && !signal.completed) score -= 0.08;
    if (signal.timeTakenSeconds != null && signal.timeTakenSeconds! > 0) {
      final expected = 120 + (signal.difficulty * 7);
      if (signal.timeTakenSeconds! <= expected) {
        score += 0.05;
      } else if (signal.timeTakenSeconds! >= expected * 2) {
        score -= 0.05;
      }
    }
    return score.clamp(0.2, 1.0);
  }
}

class _AdaptiveSignal {
  const _AdaptiveSignal({
    required this.gameType,
    required this.category,
    required this.difficulty,
    required this.started,
    required this.completed,
    required this.perfect,
    required this.usedHint,
    required this.hadMistake,
    required this.timeTakenSeconds,
    required this.activityAtIso,
  });

  final String gameType;
  final String category;
  final int difficulty;
  final bool started;
  final bool completed;
  final bool perfect;
  final bool usedHint;
  final bool hadMistake;
  final int? timeTakenSeconds;
  final String? activityAtIso;
}

class _TimedDailyProgress {
  const _TimedDailyProgress({
    required this.puzzleId,
    required this.timeTakenSeconds,
  });

  final String puzzleId;
  final int? timeTakenSeconds;
}

Map<String, int?> _latestTimeByPuzzle(Iterable<_TimedDailyProgress> items) {
  final next = <String, int?>{};
  for (final item in items) {
    if (item.puzzleId.isEmpty) continue;
    next[item.puzzleId] = item.timeTakenSeconds;
  }
  return next;
}

double _average(Iterable<double> values) {
  var count = 0;
  var sum = 0.0;
  for (final value in values) {
    sum += value;
    count += 1;
  }
  return count == 0 ? 0.5 : sum / count;
}

String? _lowestKey(Map<String, double> values) {
  String? bestKey;
  double? bestValue;
  for (final entry in values.entries) {
    if (bestValue == null || entry.value < bestValue) {
      bestKey = entry.key;
      bestValue = entry.value;
    }
  }
  return bestKey;
}

String? _highestKey(Map<String, double> values) {
  String? bestKey;
  double? bestValue;
  for (final entry in values.entries) {
    if (bestValue == null || entry.value > bestValue) {
      bestKey = entry.key;
      bestValue = entry.value;
    }
  }
  return bestKey;
}

int _sortIsoDesc(String? left, String? right) {
  final leftValue = left ?? '';
  final rightValue = right ?? '';
  return rightValue.compareTo(leftValue);
}
