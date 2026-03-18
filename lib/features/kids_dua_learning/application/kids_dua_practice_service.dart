import 'dart:math';

import '../domain/kids_dua_models.dart';

class KidsDuaBehaviorPrompt {
  const KidsDuaBehaviorPrompt({
    required this.id,
    required this.relatedDuaId,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
  });

  final String id;
  final String relatedDuaId;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int difficulty;
}

const kidsDuaBehaviorPrompts = <KidsDuaBehaviorPrompt>[
  KidsDuaBehaviorPrompt(
    id: 'behavior-when-sad',
    relatedDuaId: 'when-sad',
    prompt: 'You feel sad. What should you do?',
    options: ['Say Hasbiyallahu', 'Ignore it', 'Get angry'],
    correctIndex: 0,
    explanation: 'When hearts feel heavy, we remember Allah first.',
    difficulty: 1,
  ),
  KidsDuaBehaviorPrompt(
    id: 'behavior-thanks',
    relatedDuaId: 'saying-thanks',
    prompt: 'Someone helps you. What should you say?',
    options: ['JazakAllahu khairan', 'Nothing at all', 'Walk away'],
    correctIndex: 0,
    explanation: 'A kind thank-you grows good manners.',
    difficulty: 1,
  ),
  KidsDuaBehaviorPrompt(
    id: 'behavior-before-sleep',
    relatedDuaId: 'before-sleep',
    prompt: 'It is bedtime. What should you do first?',
    options: ['Say the sleep dua', 'Start shouting', 'Hide under the blanket'],
    correctIndex: 0,
    explanation: 'We sleep with calm hearts and trust in Allah.',
    difficulty: 1,
  ),
];

class KidsDuaPracticeService {
  const KidsDuaPracticeService();

  List<KidsDuaPracticeQuestion> generateQuestions({
    required List<KidsDuaLessonContent> lessons,
    required KidsDuaLearningState state,
    required KidsDuaLessonContent? todaysDua,
  }) {
    final unlockedIds = state.progressByLessonId.keys.toSet()
      ..addAll(state.learnedLessonIds);
    final prioritized = <KidsDuaLessonContent>[
      if (todaysDua != null && unlockedIds.contains(todaysDua.id)) todaysDua,
      ...state.recentLessonIds.map((id) {
        for (final lesson in lessons) {
          if (lesson.id == id && unlockedIds.contains(id)) return lesson;
        }
        return null;
      }).whereType<KidsDuaLessonContent>(),
    ];
    final pool = <KidsDuaLessonContent>[];
    for (final lesson in [
      ...prioritized,
      ...lessons.where((lesson) => unlockedIds.contains(lesson.id)),
    ]) {
      if (pool.any((item) => item.id == lesson.id)) continue;
      pool.add(lesson);
    }
    if (pool.length < 2) return const <KidsDuaPracticeQuestion>[];

    final questions = <KidsDuaPracticeQuestion>[];
    final random = Random(pool.length * 53);
    final availableBehavior = kidsDuaBehaviorPrompts
        .where((prompt) => unlockedIds.contains(prompt.relatedDuaId))
        .toList(growable: false);

    if (availableBehavior.isNotEmpty) {
      final prompt = availableBehavior.first;
      questions.add(
        KidsDuaPracticeQuestion(
          id: prompt.id,
          type: KidsDuaPracticeQuestionType.behavior,
          prompt: prompt.prompt,
          options: prompt.options,
          correctIndex: prompt.correctIndex,
          relatedDuaId: prompt.relatedDuaId,
          explanation: prompt.explanation,
          difficulty: prompt.difficulty,
        ),
      );
    }

    final usedForMatch = <String>{
      ...questions.map((question) => question.relatedDuaId),
    };
    for (final lesson in pool) {
      if (questions.length >= 5) break;
      if (!usedForMatch.contains(lesson.id)) {
        questions.add(_buildMatchSituationQuestion(lesson, pool, random));
        usedForMatch.add(lesson.id);
      }
      if (questions.length >= 5) break;
      questions.add(_buildMeaningQuestion(lesson, pool, random));
    }

    return questions.take(5).toList(growable: false);
  }

  KidsDuaPracticeQuestion _buildMatchSituationQuestion(
    KidsDuaLessonContent answer,
    List<KidsDuaLessonContent> pool,
    Random random,
  ) {
    final options = <String>[
      answer.title,
      ...pool
          .where((lesson) => lesson.id != answer.id)
          .map((lesson) => lesson.title)
          .take(2),
    ]..shuffle(random);
    return KidsDuaPracticeQuestion(
      id: 'match-${answer.id}',
      type: KidsDuaPracticeQuestionType.matchSituation,
      prompt: answer.whenToSay,
      options: options,
      correctIndex: options.indexOf(answer.title),
      relatedDuaId: answer.id,
      explanation: answer.miniLesson,
      difficulty: answer.level,
    );
  }

  KidsDuaPracticeQuestion _buildMeaningQuestion(
    KidsDuaLessonContent answer,
    List<KidsDuaLessonContent> pool,
    Random random,
  ) {
    final options = <String>[
      answer.meaning,
      ...pool
          .where((lesson) => lesson.id != answer.id)
          .map((lesson) => lesson.meaning)
          .where((meaning) => meaning != answer.meaning)
          .take(2),
    ]..shuffle(random);
    return KidsDuaPracticeQuestion(
      id: 'meaning-${answer.id}',
      type: KidsDuaPracticeQuestionType.meaning,
      prompt: 'What does ${answer.title} mean?',
      options: options,
      correctIndex: options.indexOf(answer.meaning),
      relatedDuaId: answer.id,
      explanation: answer.miniLesson,
      difficulty: answer.level,
    );
  }
}
