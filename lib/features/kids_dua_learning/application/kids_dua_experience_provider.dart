import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'kids_dua_continue_learning_service.dart';
import 'kids_dua_daily_service.dart';
import 'kids_dua_practice_service.dart';
import 'kids_dua_retention_service.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_progress_provider.dart';
import 'kids_dua_progress_service.dart';
import 'kids_dua_repository.dart';
import 'kids_dua_sticker_service.dart';

class KidsDuaProgressSummary {
  const KidsDuaProgressSummary({
    required this.totalLessons,
    required this.learnedLessons,
    required this.startedCategories,
    required this.completedCategories,
    required this.unlockedRewards,
  });

  final int totalLessons;
  final int learnedLessons;
  final int startedCategories;
  final int completedCategories;
  final int unlockedRewards;
}

class KidsDuaCategoryProgress {
  const KidsDuaCategoryProgress({
    required this.category,
    required this.learnedCount,
    required this.totalCount,
  });

  final KidsDuaCategory category;
  final int learnedCount;
  final int totalCount;
}

class KidsDuaLightSummary {
  const KidsDuaLightSummary({
    required this.lightLevel,
    required this.lightLabelKey,
    required this.lightDescriptionKey,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.todayCompleted,
    required this.reminderPrompt,
  });

  final KidsDuaLightLevel lightLevel;
  final String lightLabelKey;
  final String lightDescriptionKey;
  final int currentStreakDays;
  final int longestStreakDays;
  final bool todayCompleted;
  final KidsDuaReminderPrompt reminderPrompt;
}

final kidsDuaDailyDuaServiceProvider = Provider<KidsDuaDailyDuaService>(
  (ref) => const KidsDuaDailyDuaService(),
);

final kidsDuaContinueLearningServiceProvider =
    Provider<KidsDuaContinueLearningService>(
      (ref) => const KidsDuaContinueLearningService(),
    );

final kidsDuaProgressServiceProvider = Provider<KidsDuaProgressService>(
  (ref) => const KidsDuaProgressService(),
);

final kidsDuaPracticeServiceProvider = Provider<KidsDuaPracticeService>(
  (ref) => const KidsDuaPracticeService(),
);

final kidsDuaLightSummaryProvider = Provider<KidsDuaLightSummary>((ref) {
  final state = ref.watch(kidsDuaLearningProvider);
  final now = ref.watch(kidsDuaNowProvider)();
  final retention = ref.watch(kidsDuaRetentionServiceProvider);
  final synced = retention.syncForToday(state: state, now: now);
  final level = retention.getCurrentLightLevel(synced);
  final reminder = retention.getSuggestedReminderForContext(
    retention.reminderContextFor(now: now, state: synced),
  );
  return KidsDuaLightSummary(
    lightLevel: level,
    lightLabelKey: retention.lightLabelKey(level),
    lightDescriptionKey: retention.lightDescriptionKey(
      state: synced,
      level: level,
    ),
    currentStreakDays: synced.currentStreakDays,
    longestStreakDays: synced.longestStreakDays,
    todayCompleted: synced.todayCompleted,
    reminderPrompt: reminder,
  );
});

final kidsDuaProgressSummaryProvider = Provider<KidsDuaProgressSummary>((ref) {
  final state = ref.watch(kidsDuaLearningProvider);
  final lessons = ref.watch(kidsDuaLessonsProvider);
  final categories = ref.watch(kidsDuaCategoriesProvider);
  var startedCategories = 0;
  var completedCategories = 0;

  for (final category in categories) {
    final categoryLessons = lessons
        .where((lesson) => lesson.categoryId == category.id)
        .toList(growable: false);
    final started = categoryLessons.any(
      (lesson) => state.progressByLessonId.containsKey(lesson.id),
    );
    final learned = categoryLessons
        .where((lesson) => state.learnedLessonIds.contains(lesson.id))
        .length;
    if (started) startedCategories += 1;
    if (categoryLessons.isNotEmpty && learned == categoryLessons.length) {
      completedCategories += 1;
    }
  }

  return KidsDuaProgressSummary(
    totalLessons: lessons.length,
    learnedLessons: state.learnedLessonIds.length,
    startedCategories: startedCategories,
    completedCategories: completedCategories,
    unlockedRewards: state.unlockedRewardIds.length,
  );
});

final kidsDuaCategoryProgressListProvider =
    Provider<List<KidsDuaCategoryProgress>>((ref) {
      final categories = ref.watch(kidsDuaCategoriesProvider);
      final lessons = ref.watch(kidsDuaLessonsProvider);
      final state = ref.watch(kidsDuaLearningProvider);
      return categories
          .map((category) {
            final categoryLessons = lessons
                .where((lesson) => lesson.categoryId == category.id)
                .toList(growable: false);
            final learnedCount = categoryLessons
                .where((lesson) => state.learnedLessonIds.contains(lesson.id))
                .length;
            return KidsDuaCategoryProgress(
              category: category,
              learnedCount: learnedCount,
              totalCount: categoryLessons.length,
            );
          })
          .toList(growable: false);
    });

final kidsDuaFeaturedLessonProvider = Provider<KidsDuaLessonContent?>((ref) {
  final lessons = ref.watch(kidsDuaLessonsProvider);
  final state = ref.watch(kidsDuaLearningProvider);
  final remaining = lessons
      .where((lesson) => !state.learnedLessonIds.contains(lesson.id))
      .toList(growable: false);
  final pool = remaining.isEmpty ? lessons : remaining;
  if (pool.isEmpty) return null;
  final now = ref.watch(kidsDuaNowProvider)();
  final seed = now.year * 10000 + now.month * 100 + now.day;
  return pool[seed % pool.length];
});

final kidsDuaTodayFocusProvider = Provider<KidsDuaDailyFocus?>((ref) {
  final lessons = ref.watch(kidsDuaLessonsProvider);
  final state = ref.watch(kidsDuaLearningProvider);
  final now = ref.watch(kidsDuaNowProvider)();
  final service = ref.watch(kidsDuaDailyDuaServiceProvider);
  final today = service.getTodaysDua(lessons: lessons, state: state, now: now);
  if (today == null) return null;
  return KidsDuaDailyFocus(
    lesson: today,
    state: service.getTodaysDuaState(lesson: today, state: state),
  );
});

final kidsDuaContinueLessonItemProvider = Provider<KidsDuaLessonContent?>((
  ref,
) {
  final lessons = ref.watch(kidsDuaLessonsProvider);
  final state = ref.watch(kidsDuaLearningProvider);
  final service = ref.watch(kidsDuaContinueLearningServiceProvider);
  return service.getContinueDua(lessons: lessons, state: state);
});

final kidsDuaNextLessonByIdProvider =
    Provider.family<KidsDuaLessonContent?, String>((ref, lessonId) {
      final lessons = ref.watch(kidsDuaLessonsProvider);
      final state = ref.watch(kidsDuaLearningProvider);
      final currentIndex = lessons.indexWhere(
        (lesson) => lesson.id == lessonId,
      );
      if (currentIndex == -1) return null;
      for (var i = currentIndex + 1; i < lessons.length; i += 1) {
        final next = lessons[i];
        if (!state.learnedLessonIds.contains(next.id)) return next;
      }
      return null;
    });

final kidsDuaPracticeQuestionsProvider =
    Provider<List<KidsDuaPracticeQuestion>>((ref) {
      final lessons = ref.watch(kidsDuaLessonsProvider);
      final state = ref.watch(kidsDuaLearningProvider);
      final today = ref.watch(kidsDuaTodayFocusProvider)?.lesson;
      return ref
          .watch(kidsDuaPracticeServiceProvider)
          .generateQuestions(lessons: lessons, state: state, todaysDua: today);
    });

final kidsDuaAllStickersProvider = Provider<List<KidsDuaSticker>>((ref) {
  return ref.watch(kidsDuaStickerServiceProvider).getAllStickers();
});

final kidsDuaUnlockedStickersProvider = Provider<List<KidsDuaSticker>>((ref) {
  final state = ref.watch(kidsDuaLearningProvider);
  return ref
      .watch(kidsDuaAllStickersProvider)
      .where((sticker) => state.stickerUnlockedAtById.containsKey(sticker.id))
      .toList(growable: false);
});

final kidsDuaLockedStickersProvider = Provider<List<KidsDuaSticker>>((ref) {
  final state = ref.watch(kidsDuaLearningProvider);
  return ref
      .watch(kidsDuaAllStickersProvider)
      .where((sticker) => !state.stickerUnlockedAtById.containsKey(sticker.id))
      .toList(growable: false);
});
