import 'package:flutter/foundation.dart';

import '../domain/hadith_reflection_models.dart';

class HadithReflectionValidationIssue {
  const HadithReflectionValidationIssue({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;
}

class HadithReflectionValidationReport {
  const HadithReflectionValidationReport({required this.issues});

  final List<HadithReflectionValidationIssue> issues;

  bool get isValid => issues.isEmpty;
}

class HadithReflectionValidation {
  const HadithReflectionValidation._();

  static HadithReflectionValidationReport validateCatalog(
    HadithReflectionCatalog catalog,
  ) {
    final issues = <HadithReflectionValidationIssue>[];
    final puzzleIds = catalog.puzzlesById.keys.toSet();
    for (final puzzle in catalog.puzzles) {
      if (puzzle.hadithId.trim().isEmpty) {
        issues.add(
          HadithReflectionValidationIssue(
            code: 'missing_hadith_id',
            message: 'Puzzle ${puzzle.id} is missing a hadith reference.',
          ),
        );
      }
      if (puzzle.sourceBook.trim().isEmpty ||
          puzzle.referenceNumber.trim().isEmpty) {
        issues.add(
          HadithReflectionValidationIssue(
            code: 'missing_source',
            message: 'Puzzle ${puzzle.id} is missing source fields.',
          ),
        );
      }
      if (puzzle.scenarioDescription.trim().isEmpty ||
          puzzle.reflectionPrompt.trim().isEmpty ||
          puzzle.shortTeachingSummary.trim().isEmpty) {
        issues.add(
          HadithReflectionValidationIssue(
            code: 'missing_teaching_copy',
            message:
                'Puzzle ${puzzle.id} is missing scenario or teaching copy.',
          ),
        );
      }
      if (puzzle.choices.length < 2) {
        issues.add(
          HadithReflectionValidationIssue(
            code: 'too_few_choices',
            message: 'Puzzle ${puzzle.id} needs at least two choices.',
          ),
        );
      }
      final choiceIds = <String>{};
      var bestChoiceCount = 0;
      for (final choice in puzzle.choices) {
        if (!choiceIds.add(choice.id)) {
          issues.add(
            HadithReflectionValidationIssue(
              code: 'duplicate_choice',
              message: 'Puzzle ${puzzle.id} contains duplicate choice ids.',
            ),
          );
        }
        if (choice.label.trim().isEmpty || choice.feedbackText.trim().isEmpty) {
          issues.add(
            HadithReflectionValidationIssue(
              code: 'empty_choice_copy',
              message:
                  'Puzzle ${puzzle.id} has a choice with missing label or feedback.',
            ),
          );
        }
        if (choice.isBestChoice) {
          bestChoiceCount += 1;
        }
      }
      if (bestChoiceCount != 1) {
        issues.add(
          HadithReflectionValidationIssue(
            code: 'invalid_best_choice_count',
            message: 'Puzzle ${puzzle.id} must have exactly one best choice.',
          ),
        );
      }
      if (puzzle.isDailyEligible && puzzle.dailyThemes.isEmpty) {
        issues.add(
          HadithReflectionValidationIssue(
            code: 'missing_daily_theme',
            message: 'Puzzle ${puzzle.id} is daily eligible without themes.',
          ),
        );
      }
    }
    for (final pack in catalog.packs) {
      if (pack.puzzleIds.isEmpty) {
        issues.add(
          HadithReflectionValidationIssue(
            code: 'empty_pack',
            message: 'Pack ${pack.id} has no puzzles.',
          ),
        );
      }
      for (final puzzleId in pack.puzzleIds) {
        if (!puzzleIds.contains(puzzleId)) {
          issues.add(
            HadithReflectionValidationIssue(
              code: 'missing_pack_puzzle',
              message: 'Pack ${pack.id} references missing puzzle $puzzleId.',
            ),
          );
        }
      }
    }
    return HadithReflectionValidationReport(issues: issues);
  }

  static void debugReport(HadithReflectionValidationReport report) {
    assert(() {
      if (!report.isValid) {
        for (final issue in report.issues) {
          debugPrint(
            '[HadithReflectionValidation] ${issue.code}: ${issue.message}',
          );
        }
      }
      return true;
    }());
  }
}
