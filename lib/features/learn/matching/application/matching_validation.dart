import 'package:flutter/foundation.dart';

import '../domain/matching_models.dart';

enum MatchingValidationSeverity { warning, error }

class MatchingValidationIssue {
  const MatchingValidationIssue({
    required this.severity,
    required this.scope,
    required this.message,
  });

  final MatchingValidationSeverity severity;
  final String scope;
  final String message;
}

class MatchingValidationReport {
  const MatchingValidationReport(this.issues);

  final List<MatchingValidationIssue> issues;

  bool get hasErrors =>
      issues.any((issue) => issue.severity == MatchingValidationSeverity.error);
}

class MatchingValidation {
  const MatchingValidation._();

  static MatchingValidationReport validateCatalog(MatchingCatalog catalog) {
    final issues = <MatchingValidationIssue>[];
    final pairIds = catalog.pairsById.keys.toSet();
    final puzzleIds = catalog.puzzlesById.keys.toSet();

    for (final puzzle in catalog.puzzles) {
      final seen = <String>{};
      if (puzzle.pairs.isEmpty) {
        issues.add(
          MatchingValidationIssue(
            severity: MatchingValidationSeverity.error,
            scope: 'puzzle:${puzzle.id}',
            message: 'Puzzle has no pairs.',
          ),
        );
      }
      for (final pair in puzzle.pairs) {
        if (!pairIds.contains(pair.id)) {
          issues.add(
            MatchingValidationIssue(
              severity: MatchingValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Missing pair ${pair.id}.',
            ),
          );
        }
        if (!seen.add(pair.id)) {
          issues.add(
            MatchingValidationIssue(
              severity: MatchingValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Duplicate pair ${pair.id}.',
            ),
          );
        }
        if (pair.leftItem.trim().isEmpty || pair.rightItem.trim().isEmpty) {
          issues.add(
            MatchingValidationIssue(
              severity: MatchingValidationSeverity.error,
              scope: 'puzzle:${puzzle.id}',
              message: 'Pair ${pair.id} has empty content.',
            ),
          );
        }
      }
    }

    for (final pack in catalog.packs) {
      if (pack.puzzleIds.isEmpty) {
        issues.add(
          MatchingValidationIssue(
            severity: MatchingValidationSeverity.warning,
            scope: 'pack:${pack.id}',
            message: 'Pack has no puzzles.',
          ),
        );
      }
      for (final puzzleId in pack.puzzleIds) {
        if (!puzzleIds.contains(puzzleId)) {
          issues.add(
            MatchingValidationIssue(
              severity: MatchingValidationSeverity.error,
              scope: 'pack:${pack.id}',
              message: 'Missing puzzle reference $puzzleId.',
            ),
          );
        }
      }
    }

    return MatchingValidationReport(issues);
  }

  static void debugReport(MatchingValidationReport report) {
    assert(() {
      for (final issue in report.issues) {
        debugPrint(
          '[MatchingValidation][${issue.severity.name}] ${issue.scope}: ${issue.message}',
        );
      }
      return true;
    }());
  }
}
