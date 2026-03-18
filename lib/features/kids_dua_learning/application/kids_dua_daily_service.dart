import '../domain/kids_dua_models.dart';

class KidsDuaDailyFocus {
  const KidsDuaDailyFocus({required this.lesson, required this.state});

  final KidsDuaLessonContent lesson;
  final KidsDuaDailyDuaState state;
}

class KidsDuaDailyDuaService {
  const KidsDuaDailyDuaService();

  KidsDuaLessonContent? getTodaysDua({
    required List<KidsDuaLessonContent> lessons,
    required KidsDuaLearningState state,
    required DateTime now,
  }) {
    if (lessons.isEmpty) return null;
    final notLearned = lessons
        .where((lesson) => !state.learnedLessonIds.contains(lesson.id))
        .toList(growable: false);
    final inProgress = lessons
        .where(
          (lesson) =>
              state.progressByLessonId[lesson.id]?.status ==
              KidsDuaLessonStatus.inProgress,
        )
        .toList(growable: false);
    final learned = lessons
        .where((lesson) => state.learnedLessonIds.contains(lesson.id))
        .toList(growable: false);
    final prioritized = <KidsDuaLessonContent>[
      ...notLearned,
      ...inProgress.where((item) => !notLearned.contains(item)),
      ...learned,
    ];
    final dayIndex = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(2026, 1, 1)).inDays;
    return prioritized[dayIndex % prioritized.length];
  }

  KidsDuaDailyDuaState getTodaysDuaState({
    required KidsDuaLessonContent lesson,
    required KidsDuaLearningState state,
  }) {
    final progress = state.progressByLessonId[lesson.id];
    switch (progress?.status) {
      case KidsDuaLessonStatus.learned:
        return KidsDuaDailyDuaState.learned;
      case KidsDuaLessonStatus.inProgress:
        return KidsDuaDailyDuaState.inProgress;
      case KidsDuaLessonStatus.notStarted:
      case null:
        return KidsDuaDailyDuaState.notLearned;
    }
  }

  bool isTodaysDuaLearned({
    required KidsDuaLessonContent lesson,
    required KidsDuaLearningState state,
  }) =>
      getTodaysDuaState(lesson: lesson, state: state) ==
      KidsDuaDailyDuaState.learned;
}
