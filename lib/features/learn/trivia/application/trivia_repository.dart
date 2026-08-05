import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/trivia_knowledge_paths.dart';
import '../data/trivia_question_registry.dart';
import 'trivia_content_validation.dart';
import '../domain/trivia_models.dart';

final triviaRepositoryProvider = Provider<TriviaRepository>((ref) {
  return TriviaRepository(
    categories: TriviaQuestionRegistry.categories,
    questions: TriviaQuestionRegistry.allQuestions,
    knowledgePaths: triviaKnowledgePaths,
  );
});

class TriviaRepository {
  TriviaRepository({
    required List<TriviaCategory> categories,
    required List<TriviaQuestion> questions,
    required List<TriviaKnowledgePath> knowledgePaths,
  }) : _categories = List<TriviaCategory>.unmodifiable(
         [...categories]
           ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
       ),
       _questions = List<TriviaQuestion>.unmodifiable(questions),
       _knowledgePaths = List<TriviaKnowledgePath>.unmodifiable(
         knowledgePaths,
       ) {
    assert(() {
      _validate();
      return true;
    }());
  }

  final List<TriviaCategory> _categories;
  final List<TriviaQuestion> _questions;
  final List<TriviaKnowledgePath> _knowledgePaths;

  List<TriviaCategory> get categories =>
      _categories.where((item) => item.isVisible).toList(growable: false);

  List<TriviaQuestion> get questions =>
      _questions.where((item) => item.isActive).toList(growable: false);

  List<TriviaKnowledgePath> get knowledgePaths =>
      _knowledgePaths.toList(growable: false);

  List<TriviaQuestion> filterQuestions({
    String? categoryId,
    TriviaDifficulty? difficulty,
    TriviaMode? mode,
    Set<String>? tags,
    bool activeOnly = true,
    bool dailyEligibleOnly = false,
    bool featuredOnly = false,
  }) {
    return _questions
        .where((question) {
          if (activeOnly && !question.isActive) return false;
          if (categoryId != null && question.categoryId != categoryId)
            return false;
          if (difficulty != null && question.difficulty != difficulty)
            return false;
          if (mode != null && !question.modeEligibility.contains(mode))
            return false;
          if (dailyEligibleOnly && !question.dailyEligible) return false;
          if (featuredOnly && !question.featured) return false;
          if (tags != null && tags.isNotEmpty) {
            final questionTags = question.tags.toSet();
            if (!tags.any(questionTags.contains)) return false;
          }
          return true;
        })
        .toList(growable: false)
      ..sort((a, b) {
        final pack = (a.packId ?? '').compareTo(b.packId ?? '');
        if (pack != 0) return pack;
        final sort = a.sortOrder.compareTo(b.sortOrder);
        if (sort != 0) return sort;
        return a.id.compareTo(b.id);
      });
  }

  TriviaCategory? categoryById(String id) {
    for (final category in _categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  TriviaQuestion? questionById(String id) {
    for (final question in _questions) {
      if (question.id == id) return question;
    }
    return null;
  }

  TriviaKnowledgePath? knowledgePathById(String id) {
    for (final path in _knowledgePaths) {
      if (path.id == id) return path;
    }
    return null;
  }

  int questionCountForCategory(String categoryId) {
    return questions.where((item) => item.categoryId == categoryId).length;
  }

  List<TriviaQuestion> playableQuestions({
    TriviaMode? mode,
    String? categoryId,
    bool dailyEligibleOnly = false,
    Set<String> excludeIds = const <String>{},
  }) {
    return filterQuestions(
          mode: mode,
          categoryId: categoryId,
          dailyEligibleOnly: dailyEligibleOnly,
        )
        .where((question) {
          if (excludeIds.contains(question.id)) return false;
          return true;
        })
        .toList(growable: false);
  }

  List<TriviaQuestion> pickRandomQuestions({
    required TriviaMode mode,
    String? categoryId,
    int? desiredCount,
    Random? random,
    Set<String> excludeIds = const <String>{},
  }) {
    final pool = playableQuestions(
      mode: mode,
      categoryId: categoryId,
      dailyEligibleOnly: mode == TriviaMode.dailyQuiz,
      excludeIds: excludeIds,
    );
    if (pool.isEmpty) return const <TriviaQuestion>[];
    final rng = random ?? Random();
    final picked = [...pool]..shuffle(rng);
    final count = (desiredCount ?? mode.suggestedQuestionCount).clamp(
      1,
      picked.length,
    );
    return picked.take(count).toList(growable: false);
  }

  List<TriviaQuestion> questionsForIds(List<String> ids) {
    final byId = {for (final question in _questions) question.id: question};
    return ids
        .map((id) => byId[id])
        .whereType<TriviaQuestion>()
        .where((question) => question.isActive)
        .toList(growable: false);
  }

  List<TriviaQuestion> buildDailyQuiz({
    required DateTime day,
    String? categoryId,
    int count = 5,
  }) {
    final dayKey = '${day.year}-${day.month}-${day.day}';
    final pool = playableQuestions(
      mode: TriviaMode.dailyQuiz,
      categoryId: categoryId,
      dailyEligibleOnly: true,
    );
    if (pool.isEmpty) return const <TriviaQuestion>[];
    final scored =
        pool
            .map((question) {
              final seed = '$dayKey:${question.id}'.hashCode;
              return (score: seed, question: question);
            })
            .toList(growable: false)
          ..sort((a, b) => a.score.compareTo(b.score));
    return scored
        .take(count.clamp(1, scored.length))
        .map((item) => item.question)
        .toList(growable: false);
  }

  List<TriviaQuestion> reviewQuestions({
    required List<TriviaReviewItem> reviewItems,
    int count = 6,
  }) {
    if (reviewItems.isEmpty) return const <TriviaQuestion>[];
    final byId = {for (final question in questions) question.id: question};
    final ordered = [...reviewItems]
      ..sort((a, b) {
        final priority = b.priority.compareTo(a.priority);
        if (priority != 0) return priority;
        return b.timesIncorrect.compareTo(a.timesIncorrect);
      });
    final selected = <TriviaQuestion>[];
    for (final item in ordered) {
      final question = byId[item.questionId];
      if (question != null) selected.add(question);
      if (selected.length >= count) break;
    }
    return selected;
  }

  void _validate() {
    final report = TriviaContentValidator.validate(
      categories: _categories,
      questions: _questions,
    );
    TriviaContentValidator.debugLogReport(report);
    if (!report.isValid) {
      throw FlutterError(
        'Islamic Trivia content validation failed with ${report.issues.length} issue(s).',
      );
    }
    final seenPathIds = <String>{};
    final knownQuestions = {for (final question in _questions) question.id};
    for (final path in _knowledgePaths) {
      if (!seenPathIds.add(path.id)) {
        throw FlutterError('Duplicate trivia knowledge path id: ${path.id}');
      }
      final seenStageIds = <String>{};
      for (final stage in path.stages) {
        if (!seenStageIds.add(stage.id)) {
          throw FlutterError(
            'Duplicate stage id "${stage.id}" inside path "${path.id}".',
          );
        }
        for (final questionId in stage.questionIds) {
          if (!knownQuestions.contains(questionId)) {
            throw FlutterError(
              'Trivia knowledge path "${path.id}" references missing question "$questionId".',
            );
          }
        }
      }
    }
  }
}
