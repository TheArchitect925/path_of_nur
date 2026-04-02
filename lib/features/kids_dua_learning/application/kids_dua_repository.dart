import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../editorial_dashboard/application/editorial_content_versions_provider.dart';
import '../data/kids_dua_seed_data.dart';
import '../domain/kids_dua_models.dart';

final kidsDuaCategoriesProvider = Provider<List<KidsDuaCategory>>((ref) {
  return List<KidsDuaCategory>.from(kidsDuaCategories)
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
});

final kidsDuaLessonsProvider = Provider<List<KidsDuaLessonContent>>((ref) {
  return ref.watch(editorialKidsDuaLessonsProvider);
});

final kidsDuaRewardsProvider = Provider<List<KidsDuaRewardItem>>((ref) {
  return kidsDuaRewardItems;
});

final kidsDuaLessonByIdProvider =
    Provider.family<KidsDuaLessonContent?, String>((ref, lessonId) {
      for (final lesson in ref.watch(kidsDuaLessonsProvider)) {
        if (lesson.id == lessonId) return lesson;
      }
      return null;
    });

final kidsDuaLessonBySlugProvider =
    Provider.family<KidsDuaLessonContent?, String>((ref, slug) {
      for (final lesson in ref.watch(kidsDuaLessonsProvider)) {
        if (lesson.slug == slug) return lesson;
      }
      return null;
    });

final kidsDuaCategoryByIdProvider = Provider.family<KidsDuaCategory?, String>((
  ref,
  categoryId,
) {
  for (final category in ref.watch(kidsDuaCategoriesProvider)) {
    if (category.id == categoryId) return category;
  }
  return null;
});

final kidsDuaLessonsForCategoryProvider =
    Provider.family<List<KidsDuaLessonContent>, String>((ref, categoryId) {
      return ref
          .watch(kidsDuaLessonsProvider)
          .where((lesson) => lesson.categoryId == categoryId)
          .toList(growable: false);
    });

final kidsDuaFeaturedLessonsProvider = Provider<List<KidsDuaLessonContent>>((
  ref,
) {
  return ref.watch(kidsDuaLessonsProvider).take(3).toList(growable: false);
});
