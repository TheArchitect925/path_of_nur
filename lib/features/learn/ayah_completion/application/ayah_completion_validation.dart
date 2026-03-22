import 'package:flutter/foundation.dart';

import '../domain/ayah_completion_models.dart';

enum AyahCompletionValidationSeverity { warning, error }

class AyahCompletionValidationIssue {
  const AyahCompletionValidationIssue({
    required this.severity,
    required this.scope,
    required this.message,
  });

  final AyahCompletionValidationSeverity severity;
  final String scope;
  final String message;
}

class AyahCompletionValidationReport {
  const AyahCompletionValidationReport(this.issues);

  final List<AyahCompletionValidationIssue> issues;

  bool get hasErrors => issues.any(
    (issue) => issue.severity == AyahCompletionValidationSeverity.error,
  );
}

class AyahCompletionValidation {
  const AyahCompletionValidation._();

  static AyahCompletionValidationReport validateCatalog(
    AyahCompletionCatalog catalog,
  ) {
    final issues = <AyahCompletionValidationIssue>[];
    final puzzleIds = catalog.puzzlesById.keys.toSet();

    for (final pack in catalog.packs) {
      if (pack.puzzleIds.isEmpty) {
        issues.add(
          AyahCompletionValidationIssue(
            severity: AyahCompletionValidationSeverity.warning,
            scope: 'pack:${pack.id}',
            message: 'Pack has no puzzles.',
          ),
        );
      }
      for (final puzzleId in pack.puzzleIds) {
        if (!puzzleIds.contains(puzzleId)) {
          issues.add(
            AyahCompletionValidationIssue(
              severity: AyahCompletionValidationSeverity.error,
              scope: 'pack:${pack.id}',
              message: 'Missing puzzle reference $puzzleId.',
            ),
          );
        }
      }
    }

    for (final puzzle in catalog.puzzles) {
      if (puzzle.fullArabicText.trim().isEmpty) {
        issues.add(
          AyahCompletionValidationIssue(
            severity: AyahCompletionValidationSeverity.error,
            scope: 'puzzle:${puzzle.id}',
            message: 'Puzzle has empty Arabic text.',
          ),
        );
      }
      if (puzzle.translation.trim().isEmpty) {
        issues.add(
          AyahCompletionValidationIssue(
            severity: AyahCompletionValidationSeverity.warning,
            scope: 'puzzle:${puzzle.id}',
            message: 'Puzzle has empty translation.',
          ),
        );
      }
      if (puzzle.blanks.isEmpty) {
        issues.add(
          AyahCompletionValidationIssue(
            severity: AyahCompletionValidationSeverity.error,
            scope: 'puzzle:${puzzle.id}',
            message: 'Puzzle has no blanks.',
          ),
        );
      }
      final seenBlankIndexes = <int>{};
      final seenWordIndexes = <int>{};
      for (final blank in puzzle.blanks) {
        if (!seenBlankIndexes.add(blank.blankIndex)) {
          issues.add(
            AyahCompletionValidationIssue(
              severity: AyahCompletionValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Duplicate blank index ${blank.blankIndex}.',
            ),
          );
        }
        if (!seenWordIndexes.add(blank.wordIndex)) {
          issues.add(
            AyahCompletionValidationIssue(
              severity: AyahCompletionValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Duplicate word index ${blank.wordIndex}.',
            ),
          );
        }
        if (blank.wordIndex < 0 ||
            blank.wordIndex >= puzzle.arabicWords.length) {
          issues.add(
            AyahCompletionValidationIssue(
              severity: AyahCompletionValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Blank word index ${blank.wordIndex} is out of bounds.',
            ),
          );
          continue;
        }
        if (blank.correctWord != puzzle.arabicWords[blank.wordIndex]) {
          issues.add(
            AyahCompletionValidationIssue(
              severity: AyahCompletionValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Blank word mismatch at ${blank.wordIndex}.',
            ),
          );
        }
        if (blank.correctWord.trim().isEmpty) {
          issues.add(
            AyahCompletionValidationIssue(
              severity: AyahCompletionValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Blank ${blank.blankIndex} has empty correct word.',
            ),
          );
        }
        if (blank.options.length < 2) {
          issues.add(
            AyahCompletionValidationIssue(
              severity: AyahCompletionValidationSeverity.warning,
              scope: 'puzzle:${puzzle.id}',
              message: 'Blank ${blank.blankIndex} has too few options.',
            ),
          );
        }
        if (!blank.options.contains(blank.correctWord)) {
          issues.add(
            AyahCompletionValidationIssue(
              severity: AyahCompletionValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message:
                  'Blank ${blank.blankIndex} options are missing the correct word.',
            ),
          );
        }
      }
    }

    return AyahCompletionValidationReport(issues);
  }

  static void debugReport(AyahCompletionValidationReport report) {
    assert(() {
      for (final issue in report.issues) {
        debugPrint(
          '[AyahCompletionValidation][${issue.severity.name}] ${issue.scope}: ${issue.message}',
        );
      }
      return true;
    }());
  }
}
