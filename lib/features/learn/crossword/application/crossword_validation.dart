import 'package:flutter/foundation.dart';

import '../domain/crossword_models.dart';

enum CrosswordValidationSeverity { warning, error }

class CrosswordValidationIssue {
  const CrosswordValidationIssue({
    required this.severity,
    required this.code,
    required this.subjectId,
    required this.message,
  });

  final CrosswordValidationSeverity severity;
  final String code;
  final String subjectId;
  final String message;
}

class CrosswordValidationReport {
  const CrosswordValidationReport({required this.issues});

  final List<CrosswordValidationIssue> issues;

  bool get isValid => issues
      .where((item) => item.severity == CrosswordValidationSeverity.error)
      .isEmpty;
}

class CrosswordValidation {
  const CrosswordValidation._();

  static CrosswordValidationReport validateCatalog(CrosswordCatalog catalog) {
    final issues = <CrosswordValidationIssue>[
      ..._validateEntries(catalog.entries),
      ..._validateTemplates(catalog.templates),
      ..._validatePuzzles(catalog.puzzles),
      ..._validatePacks(catalog.packs, catalog.puzzlesById),
    ];
    return CrosswordValidationReport(issues: issues);
  }

  static void debugReport(CrosswordValidationReport report) {
    assert(() {
      if (report.issues.isEmpty) {
        return true;
      }
      for (final issue in report.issues) {
        debugPrint(
          'Crossword validation ${issue.severity.name}: '
          '${issue.code} [${issue.subjectId}] ${issue.message}',
        );
      }
      return true;
    }());
  }

  static List<CrosswordValidationIssue> _validateEntries(
    List<CrosswordEntry> entries,
  ) {
    final issues = <CrosswordValidationIssue>[];
    for (final entry in entries) {
      if (entry.normalizedAnswer.isEmpty) {
        issues.add(
          CrosswordValidationIssue(
            severity: CrosswordValidationSeverity.error,
            code: 'entry_empty_answer',
            subjectId: entry.id,
            message: 'Normalized answer is empty.',
          ),
        );
      }
      if (entry.clue.trim().isEmpty) {
        issues.add(
          CrosswordValidationIssue(
            severity: CrosswordValidationSeverity.error,
            code: 'entry_missing_clue',
            subjectId: entry.id,
            message: 'Clue text is empty.',
          ),
        );
      }
      if (entry.levelBandMin > entry.levelBandMax) {
        issues.add(
          CrosswordValidationIssue(
            severity: CrosswordValidationSeverity.error,
            code: 'entry_invalid_level_band',
            subjectId: entry.id,
            message: 'Minimum level is greater than maximum level.',
          ),
        );
      }
      if (entry.isDailyEligible &&
          !<String>{
            entry.category,
            entry.theme ?? '',
            ...entry.tags,
          }.contains('jummah') &&
          !<String>{
            entry.category,
            entry.theme ?? '',
            ...entry.tags,
          }.contains('quran') &&
          !<String>{
            entry.category,
            entry.theme ?? '',
            ...entry.tags,
          }.contains('hadith') &&
          !<String>{
            entry.category,
            entry.theme ?? '',
            ...entry.tags,
          }.contains('prophets') &&
          !<String>{
            entry.category,
            entry.theme ?? '',
            ...entry.tags,
          }.contains('duas') &&
          !<String>{
            entry.category,
            entry.theme ?? '',
            ...entry.tags,
          }.contains('mixed')) {
        issues.add(
          CrosswordValidationIssue(
            severity: CrosswordValidationSeverity.warning,
            code: 'entry_daily_theme_unclear',
            subjectId: entry.id,
            message: 'Daily-eligible entry has no obvious weekday theme tag.',
          ),
        );
      }
    }
    return issues;
  }

  static List<CrosswordValidationIssue> _validateTemplates(
    List<CrosswordLayoutTemplate> templates,
  ) {
    final issues = <CrosswordValidationIssue>[];
    for (final template in templates) {
      if (template.slots.isEmpty) {
        issues.add(
          CrosswordValidationIssue(
            severity: CrosswordValidationSeverity.error,
            code: 'template_empty_slots',
            subjectId: template.id,
            message: 'Template has no crossword slots.',
          ),
        );
      }
      for (final slot in template.slots) {
        if (slot.length <= 1) {
          issues.add(
            CrosswordValidationIssue(
              severity: CrosswordValidationSeverity.error,
              code: 'template_invalid_slot_length',
              subjectId: template.id,
              message: 'Template contains a slot shorter than 2 letters.',
            ),
          );
        }
        final endRow = slot.row + (slot.isAcross ? 0 : slot.length - 1);
        final endCol = slot.col + (slot.isAcross ? slot.length - 1 : 0);
        if (slot.row < 0 ||
            slot.col < 0 ||
            endRow >= template.gridSize ||
            endCol >= template.gridSize) {
          issues.add(
            CrosswordValidationIssue(
              severity: CrosswordValidationSeverity.error,
              code: 'template_slot_overflow',
              subjectId: template.id,
              message: 'Template slot exceeds grid bounds.',
            ),
          );
        }
      }
    }
    return issues;
  }

  static List<CrosswordValidationIssue> _validatePuzzles(
    List<CrosswordPuzzle> puzzles,
  ) {
    final issues = <CrosswordValidationIssue>[];
    for (final puzzle in puzzles) {
      final seenAnswers = <String>{};
      final gridLetters = <String, String>{};
      for (final clue in puzzle.clues) {
        if (clue.clue.trim().isEmpty) {
          issues.add(
            CrosswordValidationIssue(
              severity: CrosswordValidationSeverity.error,
              code: 'puzzle_missing_clue_text',
              subjectId: puzzle.id,
              message: 'A clue is missing text.',
            ),
          );
        }
        if (clue.answer.trim().isEmpty) {
          issues.add(
            CrosswordValidationIssue(
              severity: CrosswordValidationSeverity.error,
              code: 'puzzle_missing_answer',
              subjectId: puzzle.id,
              message: 'A clue is missing an answer.',
            ),
          );
        }
        if (!seenAnswers.add(clue.answer)) {
          issues.add(
            CrosswordValidationIssue(
              severity: CrosswordValidationSeverity.warning,
              code: 'puzzle_duplicate_answer',
              subjectId: puzzle.id,
              message: 'Puzzle contains duplicate answer "${clue.answer}".',
            ),
          );
        }
        for (var index = 0; index < clue.answer.length; index += 1) {
          final row = clue.row + (clue.isAcross ? 0 : index);
          final col = clue.col + (clue.isAcross ? index : 0);
          if (row >= puzzle.gridSize || col >= puzzle.gridSize) {
            issues.add(
              CrosswordValidationIssue(
                severity: CrosswordValidationSeverity.error,
                code: 'puzzle_slot_overflow',
                subjectId: puzzle.id,
                message: 'Clue "${clue.id}" exceeds puzzle bounds.',
              ),
            );
            break;
          }
          final key = '$row:$col';
          final letter = clue.answer[index];
          final existing = gridLetters[key];
          if (existing != null && existing != letter) {
            issues.add(
              CrosswordValidationIssue(
                severity: CrosswordValidationSeverity.error,
                code: 'puzzle_conflicting_overlap',
                subjectId: puzzle.id,
                message: 'Conflicting letters found at $key.',
              ),
            );
          } else {
            gridLetters[key] = letter;
          }
          if (puzzle.solutionGrid[row][col] != letter) {
            issues.add(
              CrosswordValidationIssue(
                severity: CrosswordValidationSeverity.error,
                code: 'puzzle_grid_mismatch',
                subjectId: puzzle.id,
                message: 'Solution grid mismatch for clue "${clue.id}".',
              ),
            );
          }
        }
      }
      if (puzzle.isDailyEligible && puzzle.dailyThemes.isEmpty) {
        issues.add(
          CrosswordValidationIssue(
            severity: CrosswordValidationSeverity.warning,
            code: 'puzzle_missing_daily_theme',
            subjectId: puzzle.id,
            message: 'Daily-eligible puzzle has no daily themes.',
          ),
        );
      }
    }
    return issues;
  }

  static List<CrosswordValidationIssue> _validatePacks(
    List<CrosswordPuzzlePack> packs,
    Map<String, CrosswordPuzzle> puzzlesById,
  ) {
    final issues = <CrosswordValidationIssue>[];
    for (final pack in packs) {
      if (pack.puzzleIds.isEmpty) {
        issues.add(
          CrosswordValidationIssue(
            severity: CrosswordValidationSeverity.warning,
            code: 'pack_empty',
            subjectId: pack.id,
            message: 'Pack has no linked puzzles.',
          ),
        );
      }
      for (final puzzleId in pack.puzzleIds) {
        if (!puzzlesById.containsKey(puzzleId)) {
          issues.add(
            CrosswordValidationIssue(
              severity: CrosswordValidationSeverity.error,
              code: 'pack_missing_puzzle',
              subjectId: pack.id,
              message: 'Pack references missing puzzle "$puzzleId".',
            ),
          );
        }
      }
    }
    return issues;
  }
}
