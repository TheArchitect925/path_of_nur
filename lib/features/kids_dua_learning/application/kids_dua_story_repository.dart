import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/kids_dua_story_seed_data.dart';
import '../domain/kids_dua_models.dart';
import 'kids_dua_progress_provider.dart';

final kidsDuaStoriesProvider = Provider<List<KidsDuaStory>>(
  (ref) => kidsDuaStories,
);

final kidsDuaStoryByIdProvider = Provider.family<KidsDuaStory?, String>((
  ref,
  storyId,
) {
  for (final story in ref.watch(kidsDuaStoriesProvider)) {
    if (story.id == storyId) return story;
  }
  return null;
});

final kidsDuaStoryBySlugProvider = Provider.family<KidsDuaStory?, String>((
  ref,
  slug,
) {
  for (final story in ref.watch(kidsDuaStoriesProvider)) {
    if (story.slug == slug) return story;
  }
  return null;
});

final kidsDuaStoriesForLessonProvider =
    Provider.family<List<KidsDuaStory>, String>((ref, duaId) {
      return ref
          .watch(kidsDuaStoriesProvider)
          .where((story) => story.duaId == duaId)
          .toList(growable: false);
    });

final kidsDuaStoryCategoriesProvider = Provider<List<String>>((ref) {
  final categories = <String>{'all_stories'};
  for (final story in ref.watch(kidsDuaStoriesProvider)) {
    categories.add(story.category);
  }
  return categories.toList(growable: false);
});

final kidsDuaStoriesByCategoryProvider =
    Provider.family<List<KidsDuaStory>, String>((ref, category) {
      final stories = ref.watch(kidsDuaStoriesProvider);
      if (category == 'all_stories') return stories;
      return stories
          .where((story) => story.category == category)
          .toList(growable: false);
    });

final kidsDuaFeaturedStoryProvider = Provider<KidsDuaStory?>((ref) {
  final stories = ref.watch(kidsDuaStoriesProvider);
  final state = ref.watch(kidsDuaLearningProvider);
  for (final story in stories) {
    if (!state.completedStoryIds.contains(story.id)) {
      return story;
    }
  }
  return stories.isEmpty ? null : stories.first;
});

final kidsDuaContinueStoryProvider = Provider<KidsDuaStory?>((ref) {
  final stories = ref.watch(kidsDuaStoriesProvider);
  final state = ref.watch(kidsDuaLearningProvider);
  for (final storyId in state.recentStoryIds) {
    final progress = state.storyProgressById[storyId];
    if (progress != null && !progress.completed) {
      for (final story in stories) {
        if (story.id == storyId) return story;
      }
    }
  }
  return null;
});

final kidsDuaRecentlyViewedStoriesProvider = Provider<List<KidsDuaStory>>((
  ref,
) {
  final stories = ref.watch(kidsDuaStoriesProvider);
  final state = ref.watch(kidsDuaLearningProvider);
  final result = <KidsDuaStory>[];
  for (final storyId in state.recentStoryIds) {
    for (final story in stories) {
      if (story.id == storyId) {
        result.add(story);
        break;
      }
    }
  }
  return result;
});
