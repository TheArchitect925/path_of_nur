import '../domain/kids_dua_models.dart';

class KidsDuaGlobalProgress {
  const KidsDuaGlobalProgress({
    required this.totalDuas,
    required this.totalLearned,
    required this.categoriesCompleted,
  });

  final int totalDuas;
  final int totalLearned;
  final int categoriesCompleted;
}

class KidsDuaCategoryProgressSnapshot {
  const KidsDuaCategoryProgressSnapshot({
    required this.categoryId,
    required this.totalCount,
    required this.learnedCount,
  });

  final String categoryId;
  final int totalCount;
  final int learnedCount;

  double get progressPercentage =>
      totalCount == 0 ? 0 : learnedCount / totalCount;
}

class KidsDuaProgressService {
  const KidsDuaProgressService();

  KidsDuaLessonProgress getDuaProgress({
    required KidsDuaLearningState state,
    required String duaId,
  }) {
    return state.progressByLessonId[duaId] ??
        KidsDuaLessonProgress(lessonId: duaId, openCount: 0, timesPracticed: 0);
  }

  KidsDuaCategoryProgressSnapshot getCategoryProgress({
    required List<KidsDuaLessonContent> lessons,
    required KidsDuaLearningState state,
    required String categoryId,
  }) {
    final categoryLessons = lessons
        .where((lesson) => lesson.categoryId == categoryId)
        .toList(growable: false);
    final learnedCount = categoryLessons
        .where((lesson) => state.learnedLessonIds.contains(lesson.id))
        .length;
    return KidsDuaCategoryProgressSnapshot(
      categoryId: categoryId,
      totalCount: categoryLessons.length,
      learnedCount: learnedCount,
    );
  }

  KidsDuaGlobalProgress getGlobalProgress({
    required List<KidsDuaLessonContent> lessons,
    required List<KidsDuaCategory> categories,
    required KidsDuaLearningState state,
  }) {
    var categoriesCompleted = 0;
    for (final category in categories) {
      final progress = getCategoryProgress(
        lessons: lessons,
        state: state,
        categoryId: category.id,
      );
      if (progress.totalCount > 0 &&
          progress.learnedCount == progress.totalCount) {
        categoriesCompleted += 1;
      }
    }
    return KidsDuaGlobalProgress(
      totalDuas: lessons.length,
      totalLearned: state.learnedLessonIds.length,
      categoriesCompleted: categoriesCompleted,
    );
  }
}
