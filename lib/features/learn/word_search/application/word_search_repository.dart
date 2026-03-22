import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../knowledge_games/adaptive/application/adaptive_learning_engine.dart';
import '../../knowledge_games/adaptive/application/user_learning_profile_provider.dart';
import '../../knowledge_games/adaptive/domain/user_learning_profile_models.dart';
import '../../journey/application/family_learning_provider.dart';
import '../data/word_search_seed_data.dart';
import '../domain/word_search_models.dart';
import 'word_search_progress_provider.dart';
import 'word_search_validation.dart';

String normalizeWordSearchAnswer(String input) {
  return input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
}

class WordSearchRepository {
  const WordSearchRepository();

  static const Map<int, String> weekdayThemes = <int, String>{
    DateTime.monday: 'quran',
    DateTime.tuesday: 'hadith',
    DateTime.wednesday: 'prophets',
    DateTime.thursday: 'duas',
    DateTime.friday: 'jummah',
    DateTime.saturday: 'mixed',
    DateTime.sunday: 'mixed',
  };

  WordSearchCatalog buildCatalog() {
    final entryById = {
      for (final entry in wordSearchSeedEntries) entry.id: entry,
    };
    final packIdsByPuzzleId = <String, List<String>>{};
    for (final pack in wordSearchPuzzlePacks) {
      for (final puzzleId in pack.puzzleIds) {
        packIdsByPuzzleId.update(
          puzzleId,
          (value) => [...value, pack.id],
          ifAbsent: () => <String>[pack.id],
        );
      }
    }

    final puzzles =
        wordSearchPuzzleSeeds
            .map(
              (seed) => _assemblePuzzle(
                seed,
                entryById,
                packIdsByPuzzleId[seed.id] ?? const <String>[],
              ),
            )
            .toList(growable: false)
          ..sort((a, b) {
            final modeCompare = a.mode.index.compareTo(b.mode.index);
            if (modeCompare != 0) return modeCompare;
            return a.difficulty.compareTo(b.difficulty);
          });

    final catalog = WordSearchCatalog(
      entries: wordSearchSeedEntries,
      puzzles: puzzles,
      packs: wordSearchPuzzlePacks,
    );
    WordSearchValidation.debugReport(
      WordSearchValidation.validateCatalog(catalog),
    );
    return catalog;
  }

  String weekdayThemeFor(DateTime date) =>
      weekdayThemes[date.weekday] ?? 'mixed';

  int dailyTargetDifficultyForDate(DateTime date, WordSearchMode mode) {
    final bands = mode == WordSearchMode.kids
        ? const <int>[10, 14, 18, 20]
        : const <int>[28, 34, 40, 46, 50];
    return bands[(_weekOfYear(date) + date.weekday) % bands.length];
  }

  WordSearchDailyPuzzle dailyPuzzleForDate(
    WordSearchCatalog catalog,
    DateTime date, {
    required WordSearchMode mode,
    WordSearchProgressState? progressState,
    UserLearningProfile? adaptiveProfile,
  }) {
    final weekdayTheme = weekdayThemeFor(date);
    final dateKey = LocalStore.todayKey(date);
    final existingDaily = progressState?.dailyProgressFor(dateKey);
    if (existingDaily != null &&
        existingDaily.puzzleId.isNotEmpty &&
        catalog.puzzlesById.containsKey(existingDaily.puzzleId)) {
      final puzzle = catalog.puzzlesById[existingDaily.puzzleId]!;
      return WordSearchDailyPuzzle(
        puzzle: puzzle,
        dateKey: dateKey,
        weekdayTheme: existingDaily.weekdayTheme ?? weekdayTheme,
        targetDifficulty: dailyTargetDifficultyForDate(date, mode),
      );
    }
    final baseTargetDifficulty = dailyTargetDifficultyForDate(date, mode);
    final targetDifficulty = adaptiveProfile == null
        ? baseTargetDifficulty
        : const AdaptiveLearningEngine().personalizedTargetDifficulty(
            profile: adaptiveProfile,
            gameType: 'word_search',
            baseTarget: baseTargetDifficulty,
          );
    final pool = dailyPuzzlePoolForTheme(
      catalog,
      weekdayTheme,
      mode: mode,
      progressState: progressState,
      date: date,
      targetDifficulty: targetDifficulty,
      adaptiveProfile: adaptiveProfile,
    );
    final seed = '$dateKey:$weekdayTheme:${mode.name}:${_weekOfYear(date)}'
        .codeUnits
        .fold<int>(0, (sum, item) => sum + item);
    final puzzle = pool[seed % pool.length];
    return WordSearchDailyPuzzle(
      puzzle: puzzle,
      dateKey: dateKey,
      weekdayTheme: weekdayTheme,
      targetDifficulty: targetDifficulty,
    );
  }

  List<WordSearchPuzzle> dailyPuzzlePoolForTheme(
    WordSearchCatalog catalog,
    String weekdayTheme, {
    required WordSearchMode mode,
    WordSearchProgressState? progressState,
    DateTime? date,
    int? targetDifficulty,
    UserLearningProfile? adaptiveProfile,
  }) {
    final modePuzzles = catalog.puzzles.where((item) => item.mode == mode);
    final themed = modePuzzles
        .where(
          (puzzle) =>
              puzzle.isDailyEligible &&
              (puzzle.dailyThemes.contains(weekdayTheme) ||
                  puzzle.category == weekdayTheme ||
                  puzzle.tags.contains(weekdayTheme)),
        )
        .toList(growable: false);
    final eligible = themed.isNotEmpty
        ? themed
        : modePuzzles
              .where((puzzle) => puzzle.isDailyEligible)
              .toList(growable: false);
    final fallback = eligible.isNotEmpty
        ? eligible
        : modePuzzles.toList(growable: false);
    final recentIds = progressState == null
        ? const <String>{}
        : _recentDailyPuzzleIds(
            progressState,
            upToDate: date ?? DateTime.now(),
            mode: mode,
            limit: 7,
          );
    final withoutRecent = fallback
        .where((puzzle) => !recentIds.contains(puzzle.id))
        .toList(growable: false);
    final pool = withoutRecent.isNotEmpty ? withoutRecent : fallback;
    final target =
        targetDifficulty ??
        dailyTargetDifficultyForDate(date ?? DateTime.now(), mode);
    final sorted = [...pool]
      ..sort((a, b) {
        if (adaptiveProfile != null) {
          final engine = const AdaptiveLearningEngine();
          final aPriority = engine.selectionPriority(
            profile: adaptiveProfile,
            gameType: 'word_search',
            category: a.category,
            difficulty: a.difficulty,
            targetDifficulty: target,
          );
          final bPriority = engine.selectionPriority(
            profile: adaptiveProfile,
            gameType: 'word_search',
            category: b.category,
            difficulty: b.difficulty,
            targetDifficulty: target,
          );
          if (aPriority != bPriority) {
            return aPriority.compareTo(bPriority);
          }
        }
        final aGap = (a.difficulty - target).abs();
        final bGap = (b.difficulty - target).abs();
        if (aGap != bGap) return aGap.compareTo(bGap);
        return a.id.compareTo(b.id);
      });
    return sorted;
  }

  Set<String> _recentDailyPuzzleIds(
    WordSearchProgressState state, {
    required DateTime upToDate,
    required WordSearchMode mode,
    int limit = 7,
  }) {
    final cutoffKey = LocalStore.todayKey(upToDate);
    final sorted =
        state.dailyProgressByDateKey.values
            .where((item) => item.dateKey.compareTo(cutoffKey) < 0)
            .toList(growable: false)
          ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return sorted
        .take(limit)
        .map((item) => item.puzzleId)
        .where((id) => id.isNotEmpty)
        .where((id) => state.progressByPuzzleId.containsKey(id) || true)
        .toSet();
  }

  WordSearchPuzzle _assemblePuzzle(
    WordSearchPuzzleSeed seed,
    Map<String, WordSearchEntry> entryById,
    List<String> packIds,
  ) {
    final entries = seed.entryIds
        .map((id) => entryById[id])
        .whereType<WordSearchEntry>()
        .toList(growable: false);
    if (entries.length != seed.entryIds.length) {
      throw StateError('Missing word-search entries for ${seed.id}.');
    }
    final words =
        entries
            .map((entry) => entry.normalizedAnswer)
            .where((answer) => answer.isNotEmpty)
            .toSet()
            .toList(growable: false)
          ..sort((a, b) => b.length.compareTo(a.length));
    final placements = _placeWords(
      words: words,
      seed: seed,
      entryByAnswer: {
        for (final entry in entries) entry.normalizedAnswer: entry,
      },
    );
    final grid = List.generate(
      seed.gridSize,
      (_) => List<String>.filled(seed.gridSize, ''),
      growable: false,
    );
    for (final placement in placements) {
      final rowStep = _rowDelta(placement.direction);
      final colStep = _colDelta(placement.direction);
      for (var index = 0; index < placement.word.length; index += 1) {
        final row = placement.startRow + (rowStep * index);
        final col = placement.startCol + (colStep * index);
        grid[row][col] = placement.word[index];
      }
    }
    _fillEmptyCells(grid, seed, words);
    return WordSearchPuzzle(
      id: seed.id,
      mode: seed.mode,
      category: seed.category,
      difficulty: seed.difficulty,
      gridSize: seed.gridSize,
      entryIds: entries.map((entry) => entry.id).toList(growable: false),
      targetWords: words,
      letterGrid: grid,
      placements: placements,
      tags: seed.tags,
      levelBandMin: seed.levelBandMin,
      levelBandMax: seed.levelBandMax,
      isDailyEligible: seed.isDailyEligible,
      dailyThemes: seed.dailyThemes,
      packIds: packIds,
    );
  }

  List<WordSearchPlacement> _placeWords({
    required List<String> words,
    required WordSearchPuzzleSeed seed,
    required Map<String, WordSearchEntry> entryByAnswer,
  }) {
    final placements = <WordSearchPlacement>[];
    final board = List.generate(
      seed.gridSize,
      (_) => List<String?>.filled(seed.gridSize, null),
    );
    final directions = seed.allowedDirections;
    final hash = seed.id.codeUnits.fold<int>(0, (sum, item) => sum + item);

    bool placeWord(int index) {
      if (index >= words.length) return true;
      final word = words[index];
      final candidates = <(int, int, WordSearchDirection)>[];
      for (var row = 0; row < seed.gridSize; row += 1) {
        for (var col = 0; col < seed.gridSize; col += 1) {
          for (final direction in directions) {
            candidates.add((row, col, direction));
          }
        }
      }
      candidates.sort((a, b) {
        final aSeed = (a.$1 * 31) + (a.$2 * 13) + a.$3.index + hash;
        final bSeed = (b.$1 * 31) + (b.$2 * 13) + b.$3.index + hash;
        return aSeed.compareTo(bSeed);
      });

      for (final candidate in candidates) {
        if (!_canPlaceWord(
          board: board,
          word: word,
          row: candidate.$1,
          col: candidate.$2,
          direction: candidate.$3,
          gridSize: seed.gridSize,
        )) {
          continue;
        }
        _writeWord(
          board: board,
          word: word,
          row: candidate.$1,
          col: candidate.$2,
          direction: candidate.$3,
        );
        placements.add(
          WordSearchPlacement(
            entryId: entryByAnswer[word]!.id,
            word: word,
            startRow: candidate.$1,
            startCol: candidate.$2,
            endRow:
                candidate.$1 + (_rowDelta(candidate.$3) * (word.length - 1)),
            endCol:
                candidate.$2 + (_colDelta(candidate.$3) * (word.length - 1)),
            direction: candidate.$3,
          ),
        );
        if (placeWord(index + 1)) return true;
        placements.removeLast();
        _rebuildBoardFromPlacements(board, placements);
      }
      return false;
    }

    if (placeWord(0)) {
      return placements.toList(growable: false);
    }
    return _fallbackPlacements(
      words: words,
      seed: seed,
      entryByAnswer: entryByAnswer,
    );
  }

  void _rebuildBoardFromPlacements(
    List<List<String?>> board,
    List<WordSearchPlacement> placements,
  ) {
    for (var row = 0; row < board.length; row += 1) {
      for (var col = 0; col < board[row].length; col += 1) {
        board[row][col] = null;
      }
    }
    for (final placement in placements) {
      _writeWord(
        board: board,
        word: placement.word,
        row: placement.startRow,
        col: placement.startCol,
        direction: placement.direction,
      );
    }
  }

  List<WordSearchPlacement> _fallbackPlacements({
    required List<String> words,
    required WordSearchPuzzleSeed seed,
    required Map<String, WordSearchEntry> entryByAnswer,
  }) {
    final placements = <WordSearchPlacement>[];
    var row = 0;
    for (final word in words) {
      if (row >= seed.gridSize) {
        throw StateError('Unable to place fallback puzzle ${seed.id}.');
      }
      final maxStartCol = seed.gridSize - word.length;
      final startCol = math.max(0, maxStartCol ~/ 2);
      placements.add(
        WordSearchPlacement(
          entryId: entryByAnswer[word]!.id,
          word: word,
          startRow: row,
          startCol: startCol,
          endRow: row,
          endCol: startCol + word.length - 1,
          direction: WordSearchDirection.right,
        ),
      );
      row += 1;
    }
    return placements;
  }

  bool _canPlaceWord({
    required List<List<String?>> board,
    required String word,
    required int row,
    required int col,
    required WordSearchDirection direction,
    required int gridSize,
  }) {
    final rowStep = _rowDelta(direction);
    final colStep = _colDelta(direction);
    for (var index = 0; index < word.length; index += 1) {
      final nextRow = row + (rowStep * index);
      final nextCol = col + (colStep * index);
      if (nextRow < 0 ||
          nextCol < 0 ||
          nextRow >= gridSize ||
          nextCol >= gridSize) {
        return false;
      }
      final current = board[nextRow][nextCol];
      if (current != null && current != word[index]) {
        return false;
      }
    }
    return true;
  }

  void _writeWord({
    required List<List<String?>> board,
    required String word,
    required int row,
    required int col,
    required WordSearchDirection direction,
  }) {
    final rowStep = _rowDelta(direction);
    final colStep = _colDelta(direction);
    for (var index = 0; index < word.length; index += 1) {
      board[row + (rowStep * index)][col + (colStep * index)] = word[index];
    }
  }

  void _fillEmptyCells(
    List<List<String>> grid,
    WordSearchPuzzleSeed seed,
    List<String> words,
  ) {
    final pool = words
        .join()
        .split('')
        .where((item) => item.trim().isNotEmpty)
        .toList();
    final fallback = seed.mode == WordSearchMode.kids
        ? 'NOORSALAHDUA'
        : 'RAHMAHNOORHUDA';
    var cursor = 0;
    for (var row = 0; row < grid.length; row += 1) {
      for (var col = 0; col < grid[row].length; col += 1) {
        if (grid[row][col].isNotEmpty) continue;
        final source = pool.isNotEmpty ? pool : fallback.split('');
        grid[row][col] = source[cursor % source.length];
        cursor += 1;
      }
    }
  }

  int _rowDelta(WordSearchDirection direction) {
    switch (direction) {
      case WordSearchDirection.right:
      case WordSearchDirection.left:
        return 0;
      case WordSearchDirection.down:
        return 1;
      case WordSearchDirection.up:
        return -1;
      case WordSearchDirection.diagonalDownRight:
        return 1;
      case WordSearchDirection.diagonalUpRight:
        return -1;
    }
  }

  int _colDelta(WordSearchDirection direction) {
    switch (direction) {
      case WordSearchDirection.right:
      case WordSearchDirection.down:
      case WordSearchDirection.up:
        return direction == WordSearchDirection.right ? 1 : 0;
      case WordSearchDirection.left:
        return -1;
      case WordSearchDirection.diagonalDownRight:
      case WordSearchDirection.diagonalUpRight:
        return 1;
    }
  }

  int _weekOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    final offset = start.weekday - DateTime.monday;
    final firstMonday = start.subtract(Duration(days: offset));
    return ((date.difference(firstMonday).inDays) ~/ 7) + 1;
  }
}

final wordSearchRepositoryProvider = Provider<WordSearchRepository>(
  (_) => const WordSearchRepository(),
);

final wordSearchCatalogProvider = FutureProvider<WordSearchCatalog>((
  ref,
) async {
  final repository = ref.watch(wordSearchRepositoryProvider);
  return repository.buildCatalog();
});

final wordSearchValidationReportProvider =
    FutureProvider<WordSearchValidationReport>((ref) async {
      final catalog = await ref.watch(wordSearchCatalogProvider.future);
      return WordSearchValidation.validateCatalog(catalog);
    });

final wordSearchPuzzleByIdProvider =
    FutureProvider.family<WordSearchPuzzle?, String>((ref, puzzleId) async {
      final catalog = await ref.watch(wordSearchCatalogProvider.future);
      return catalog.puzzlesById[puzzleId];
    });

final wordSearchPackByIdProvider =
    FutureProvider.family<WordSearchPuzzlePack?, String>((ref, packId) async {
      final catalog = await ref.watch(wordSearchCatalogProvider.future);
      return catalog.packsById[packId];
    });

final wordSearchDailyPuzzleProvider = FutureProvider<WordSearchDailyPuzzle>((
  ref,
) async {
  final catalog = await ref.watch(wordSearchCatalogProvider.future);
  final repository = ref.watch(wordSearchRepositoryProvider);
  final progress = ref.watch(wordSearchProgressProvider);
  final adaptiveProfile = ref.watch(userLearningProfileProvider);
  final isChildProfile = ref.watch(
    activeFamilyLearningContextProvider.select(
      (value) => value.visibilityPolicy.isChildProfile,
    ),
  );
  return repository.dailyPuzzleForDate(
    catalog,
    DateTime.now(),
    mode: isChildProfile ? WordSearchMode.kids : WordSearchMode.adult,
    progressState: progress,
    adaptiveProfile: adaptiveProfile,
  );
});
