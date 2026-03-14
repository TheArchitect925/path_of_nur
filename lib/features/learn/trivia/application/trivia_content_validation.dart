import 'package:flutter/foundation.dart';

import '../domain/trivia_models.dart';

@immutable
class TriviaValidationIssue {
  const TriviaValidationIssue({
    required this.code,
    required this.message,
    this.questionId,
  });

  final String code;
  final String message;
  final String? questionId;
}

@immutable
class TriviaValidationReport {
  const TriviaValidationReport({
    required this.issues,
    required this.totalQuestions,
    required this.totalCategories,
  });

  final List<TriviaValidationIssue> issues;
  final int totalQuestions;
  final int totalCategories;

  bool get isValid => issues.isEmpty;
}

class TriviaContentValidator {
  const TriviaContentValidator._();

  static TriviaValidationReport validate({
    required List<TriviaCategory> categories,
    required List<TriviaQuestion> questions,
  }) {
    final issues = <TriviaValidationIssue>[];
    final questionIds = <String>{};
    final prompts = <String>{};
    final categoryIds = categories.map((item) => item.id).toSet();

    for (final question in questions) {
      if (!questionIds.add(question.id)) {
        issues.add(
          TriviaValidationIssue(
            code: 'duplicate_id',
            message: 'Duplicate trivia question id: ${question.id}',
            questionId: question.id,
          ),
        );
      }
      final normalizedPrompt = question.prompt.trim().toLowerCase();
      if (normalizedPrompt.isEmpty) {
        issues.add(
          TriviaValidationIssue(
            code: 'empty_prompt',
            message: 'Question prompt is empty.',
            questionId: question.id,
          ),
        );
      } else if (!prompts.add(normalizedPrompt)) {
        issues.add(
          TriviaValidationIssue(
            code: 'duplicate_prompt',
            message: 'Duplicate trivia prompt detected: ${question.prompt}',
            questionId: question.id,
          ),
        );
      }
      if (!categoryIds.contains(question.categoryId)) {
        issues.add(
          TriviaValidationIssue(
            code: 'invalid_category',
            message:
                'Question ${question.id} uses unknown category ${question.categoryId}.',
            questionId: question.id,
          ),
        );
      }
      if (question.explanation.trim().isEmpty) {
        issues.add(
          TriviaValidationIssue(
            code: 'missing_explanation',
            message: 'Question ${question.id} is missing explanation text.',
            questionId: question.id,
          ),
        );
      }
      if (question.options.length < 2) {
        issues.add(
          TriviaValidationIssue(
            code: 'too_few_options',
            message: 'Question ${question.id} has too few answer options.',
            questionId: question.id,
          ),
        );
      }
      final optionIds = <String>{};
      for (final option in question.options) {
        if (option.label.trim().isEmpty) {
          issues.add(
            TriviaValidationIssue(
              code: 'empty_option_label',
              message: 'Question ${question.id} contains an empty option label.',
              questionId: question.id,
            ),
          );
        }
        if (!optionIds.add(option.id)) {
          issues.add(
            TriviaValidationIssue(
              code: 'duplicate_option_id',
              message:
                  'Question ${question.id} contains duplicate option id ${option.id}.',
              questionId: question.id,
            ),
          );
        }
      }
      if (!optionIds.contains(question.correctOptionId)) {
        issues.add(
          TriviaValidationIssue(
            code: 'missing_correct_option',
            message:
                'Question ${question.id} has a correct option id that is not present.',
            questionId: question.id,
          ),
        );
      }
      if (question.type == TriviaQuestionType.trueFalse &&
          (optionIds.length != 2 ||
              !optionIds.contains('true') ||
              !optionIds.contains('false'))) {
        issues.add(
          TriviaValidationIssue(
            code: 'invalid_true_false',
            message:
                'True/false question ${question.id} must use true/false options.',
            questionId: question.id,
          ),
        );
      }
    }

    return TriviaValidationReport(
      issues: issues,
      totalQuestions: questions.length,
      totalCategories: categories.length,
    );
  }

  static void debugLogReport(TriviaValidationReport report) {
    if (report.isValid) {
      debugPrint(
        'Islamic Trivia content OK: ${report.totalQuestions} questions across ${report.totalCategories} categories.',
      );
      return;
    }
    debugPrint('Islamic Trivia content issues: ${report.issues.length}');
    for (final issue in report.issues) {
      debugPrint(' - [${issue.code}] ${issue.message}');
    }
  }
}
