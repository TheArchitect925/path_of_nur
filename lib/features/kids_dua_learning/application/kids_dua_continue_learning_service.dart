import '../domain/kids_dua_models.dart';

class KidsDuaContinueLearningService {
  const KidsDuaContinueLearningService();

  KidsDuaLessonContent? getContinueDua({
    required List<KidsDuaLessonContent> lessons,
    required KidsDuaLearningState state,
  }) {
    for (final lessonId in state.recentLessonIds) {
      final progress = state.progressByLessonId[lessonId];
      if (progress != null &&
          progress.status == KidsDuaLessonStatus.inProgress) {
        for (final lesson in lessons) {
          if (lesson.id == lessonId) return lesson;
        }
      }
    }
    for (final lesson in lessons) {
      if (!state.learnedLessonIds.contains(lesson.id)) return lesson;
    }
    return null;
  }
}
