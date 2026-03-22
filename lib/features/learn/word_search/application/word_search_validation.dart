import 'package:flutter/foundation.dart';

import '../domain/word_search_models.dart';

enum WordSearchValidationSeverity { warning, error }

class WordSearchValidationIssue {
  const WordSearchValidationIssue({
    required this.severity,
    required this.scope,
    required this.message,
  });

  final WordSearchValidationSeverity severity;
  final String scope;
  final String message;
}

class WordSearchValidationReport {
  const WordSearchValidationReport(this.issues);

  final List<WordSearchValidationIssue> issues;

  bool get hasErrors => issues.any(
    (issue) => issue.severity == WordSearchValidationSeverity.error,
  );
}

class WordSearchValidation {
  const WordSearchValidation._();

  static WordSearchValidationReport validateCatalog(WordSearchCatalog catalog) {
    final issues = <WordSearchValidationIssue>[];
    final puzzleIds = catalog.puzzlesById.keys.toSet();
    for (final pack in catalog.packs) {
      if (pack.puzzleIds.isEmpty) {
        issues.add(
          WordSearchValidationIssue(
            severity: WordSearchValidationSeverity.warning,
            scope: 'pack:${pack.id}',
            message: 'Pack has no puzzles.',
          ),
        );
      }
      for (final puzzleId in pack.puzzleIds) {
        if (!puzzleIds.contains(puzzleId)) {
          issues.add(
            WordSearchValidationIssue(
              severity: WordSearchValidationSeverity.error,
              scope: 'pack:${pack.id}',
              message: 'Missing puzzle reference $puzzleId.',
            ),
          );
        }
      }
    }

    for (final puzzle in catalog.puzzles) {
      issues.addAll(validatePuzzle(catalog, puzzle));
    }
    return WordSearchValidationReport(issues);
  }

  static List<WordSearchValidationIssue> validatePuzzle(
    WordSearchCatalog catalog,
    WordSearchPuzzle puzzle,
  ) {
    final issues = <WordSearchValidationIssue>[];
    final occupied = <String, String>{};
    final seenWords = <String>{};
    for (final placement in puzzle.placements) {
      if (placement.word.isEmpty) {
        issues.add(
          WordSearchValidationIssue(
            severity: WordSearchValidationSeverity.error,
            scope: 'puzzle:${puzzle.id}',
            message: 'Empty placement word.',
          ),
        );
        continue;
      }
      if (!seenWords.add(placement.word)) {
        issues.add(
          WordSearchValidationIssue(
            severity: WordSearchValidationSeverity.error,
            scope: 'puzzle:${puzzle.id}',
            message: 'Duplicate target word ${placement.word}.',
          ),
        );
      }
      if (!catalog.entriesById.containsKey(placement.entryId)) {
        issues.add(
          WordSearchValidationIssue(
            severity: WordSearchValidationSeverity.error,
            scope: 'puzzle:${puzzle.id}',
            message: 'Missing entry ${placement.entryId}.',
          ),
        );
      }
      final cells = _cellsForPlacement(placement);
      if (cells.length != placement.word.length) {
        issues.add(
          WordSearchValidationIssue(
            severity: WordSearchValidationSeverity.error,
            scope: 'puzzle:${puzzle.id}',
            message: 'Placement length mismatch for ${placement.entryId}.',
          ),
        );
      }
      for (var index = 0; index < cells.length; index += 1) {
        final row = cells[index].$1;
        final col = cells[index].$2;
        if (row < 0 ||
            col < 0 ||
            row >= puzzle.gridSize ||
            col >= puzzle.gridSize) {
          issues.add(
            WordSearchValidationIssue(
              severity: WordSearchValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Placement out of bounds for ${placement.entryId}.',
            ),
          );
          continue;
        }
        final expected = placement.word[index];
        final gridValue = puzzle.letterGrid[row][col];
        if (gridValue != expected) {
          issues.add(
            WordSearchValidationIssue(
              severity: WordSearchValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Grid mismatch at $row,$col for ${placement.entryId}.',
            ),
          );
        }
        final key = '$row:$col';
        final previous = occupied[key];
        if (previous != null && previous != expected) {
          issues.add(
            WordSearchValidationIssue(
              severity: WordSearchValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message:
                  'Conflicting overlap at $row,$col between letters $previous and $expected.',
            ),
          );
        }
        occupied[key] = expected;
      }
    }
    if (puzzle.targetWords.toSet().length != puzzle.targetWords.length) {
      issues.add(
        WordSearchValidationIssue(
          severity: WordSearchValidationSeverity.error,
          scope: 'puzzle:${puzzle.id}',
          message: 'Puzzle has duplicate target words list.',
        ),
      );
    }
    return issues;
  }

  static void debugReport(WordSearchValidationReport report) {
    assert(() {
      if (report.issues.isEmpty) return true;
      for (final issue in report.issues) {
        debugPrint(
          '[WordSearchValidation][${issue.severity.name}] ${issue.scope}: ${issue.message}',
        );
      }
      return true;
    }());
  }

  static List<(int, int)> _cellsForPlacement(WordSearchPlacement placement) {
    final result = <(int, int)>[];
    final rowStep = switch (placement.direction) {
      WordSearchDirection.right || WordSearchDirection.left => 0,
      WordSearchDirection.down => 1,
      WordSearchDirection.up => -1,
      WordSearchDirection.diagonalDownRight => 1,
      WordSearchDirection.diagonalUpRight => -1,
    };
    final colStep = switch (placement.direction) {
      WordSearchDirection.right => 1,
      WordSearchDirection.left => -1,
      WordSearchDirection.down || WordSearchDirection.up => 0,
      WordSearchDirection.diagonalDownRight => 1,
      WordSearchDirection.diagonalUpRight => 1,
    };
    for (var index = 0; index < placement.word.length; index += 1) {
      result.add((
        placement.startRow + (rowStep * index),
        placement.startCol + (colStep * index),
      ));
    }
    return result;
  }
}
