import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/kids_dua_models.dart';

const int kidsDuaMyDayRecapXpBonus = 2;
const int kidsDuaMyDayRecapDropsBonus = 1;

final kidsDuaMyDayPracticeServiceProvider =
    Provider<KidsDuaMyDayPracticeService>(
      (ref) => const KidsDuaMyDayPracticeService(),
    );

const kidsDuaMyDayBehaviorScenarios = <KidsDuaBehaviorScenario>[
  KidsDuaBehaviorScenario(
    id: 'waking-up-ready',
    situation: 'You open your eyes for a new day. What should you say?',
    correctDuaId: 'after-waking-up',
    distractorOptions: <String>['Go back to sleep', 'Run away quietly'],
    message: 'A new day begins with thanks to Allah.',
  ),
  KidsDuaBehaviorScenario(
    id: 'study-time',
    situation: 'It is time to learn something new. What can you ask Allah?',
    correctDuaId: 'rabbi-zidnee-ilma',
    distractorOptions: <String>['I do not need help', 'I will stop trying'],
    message: 'We ask Allah to open learning with goodness.',
  ),
  KidsDuaBehaviorScenario(
    id: 'meal-start',
    situation: 'Food is ready in front of you. What should you say?',
    correctDuaId: 'before-eating',
    distractorOptions: <String>[
      'Start without remembering',
      'Push the plate away',
    ],
    message: 'We begin meals with Allah’s name.',
  ),
  KidsDuaBehaviorScenario(
    id: 'meal-finish',
    situation: 'You finished your meal. What should you say now?',
    correctDuaId: 'after-eating',
    distractorOptions: <String>['Walk away upset', 'Say nothing at all'],
    message: 'A full heart thanks Allah after eating.',
  ),
  KidsDuaBehaviorScenario(
    id: 'going-out-door',
    situation: 'You are about to leave home. What should you say?',
    correctDuaId: 'leaving-home',
    distractorOptions: <String>['Leave in a rush', 'Forget Allah completely'],
    message: 'We step outside with trust in Allah.',
  ),
  KidsDuaBehaviorScenario(
    id: 'bedtime-calm',
    situation: 'It is bedtime. What should you say first?',
    correctDuaId: 'before-sleep',
    distractorOptions: <String>['Start shouting', 'Hide under the blanket'],
    message: 'Night begins with calm remembrance.',
  ),
  KidsDuaBehaviorScenario(
    id: 'mistake-gentle',
    situation: 'You made a mistake. What can you say now?',
    correctDuaId: 'astaghfirullah',
    distractorOptions: <String>['Stay upset forever', 'Blame everyone else'],
    message: 'We turn back to Allah gently after mistakes.',
  ),
];

class KidsDuaMyDayPracticeService {
  const KidsDuaMyDayPracticeService();

  KidsDuaPracticeQuestion? questionAfterLesson({
    required KidsDuaLessonContent lesson,
    required List<KidsDuaLessonContent> lessons,
    required KidsDuaLearningState state,
  }) {
    final scenario = _scenarioFor(lesson.id);
    if (scenario != null) {
      return _buildBehaviorQuestion(scenario, lessons);
    }
    final pool = _unlockedPool(lessons, state);
    if (pool.length < 2) return null;
    final random = Random(lesson.id.hashCode);
    if (lesson.level.isEven) {
      return _buildMeaningQuestion(lesson, pool, random);
    }
    return _buildMatchQuestion(lesson, pool, random);
  }

  List<KidsDuaPracticeQuestion> recapQuestionsForDay({
    required Set<String> completedDuaIds,
    required List<KidsDuaLessonContent> lessons,
    required KidsDuaLearningState state,
    int limit = 3,
  }) {
    final completedLessons = lessons
        .where((lesson) => completedDuaIds.contains(lesson.id))
        .toList(growable: false);
    if (completedLessons.isEmpty) return const <KidsDuaPracticeQuestion>[];

    final pool = _unlockedPool(lessons, state);
    final random = Random(completedLessons.length * 37);
    final questions = <KidsDuaPracticeQuestion>[];

    for (final lesson in completedLessons) {
      final scenario = _scenarioFor(lesson.id);
      if (scenario != null) {
        questions.add(_buildBehaviorQuestion(scenario, lessons));
        break;
      }
    }

    for (final lesson in completedLessons) {
      if (questions.length >= limit) break;
      questions.add(_buildMatchQuestion(lesson, pool, random));
      if (questions.length >= limit) break;
      questions.add(_buildMeaningQuestion(lesson, pool, random));
    }

    final unique = <String, KidsDuaPracticeQuestion>{};
    for (final question in questions) {
      unique.putIfAbsent(question.id, () => question);
      if (unique.length >= limit) break;
    }
    return unique.values.take(limit).toList(growable: false);
  }

  KidsDuaBehaviorScenario? _scenarioFor(String lessonId) {
    for (final scenario in kidsDuaMyDayBehaviorScenarios) {
      if (scenario.correctDuaId == lessonId) return scenario;
    }
    return null;
  }

  List<KidsDuaLessonContent> _unlockedPool(
    List<KidsDuaLessonContent> lessons,
    KidsDuaLearningState state,
  ) {
    final unlockedIds = state.progressByLessonId.keys.toSet()
      ..addAll(state.learnedLessonIds);
    return lessons
        .where((lesson) => unlockedIds.contains(lesson.id))
        .toList(growable: false);
  }

  KidsDuaPracticeQuestion _buildBehaviorQuestion(
    KidsDuaBehaviorScenario scenario,
    List<KidsDuaLessonContent> lessons,
  ) {
    final correctLesson = lessons.firstWhere(
      (lesson) => lesson.id == scenario.correctDuaId,
    );
    return KidsDuaPracticeQuestion(
      id: 'behavior-${scenario.id}',
      type: KidsDuaPracticeQuestionType.behavior,
      prompt: scenario.situation,
      options: <String>[correctLesson.title, ...scenario.distractorOptions],
      correctIndex: 0,
      relatedDuaId: correctLesson.id,
      explanation: scenario.message,
      difficulty: correctLesson.level,
    );
  }

  KidsDuaPracticeQuestion _buildMatchQuestion(
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
      id: 'myday-match-${answer.id}',
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
      id: 'myday-meaning-${answer.id}',
      type: KidsDuaPracticeQuestionType.meaning,
      prompt: answer.title,
      options: options,
      correctIndex: options.indexOf(answer.meaning),
      relatedDuaId: answer.id,
      explanation: answer.miniLesson,
      difficulty: answer.level,
    );
  }
}
