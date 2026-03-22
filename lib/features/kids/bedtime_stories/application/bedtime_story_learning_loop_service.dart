import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/bedtime_story_learning_models.dart';
import 'bedtime_story_learning_repository.dart';

final bedtimeStoryTonightLearningSuggestionProvider =
    Provider<BedtimeStoryLearningSuggestion?>((ref) {
      return ref.watch(bedtimeStoryLearningRepositoryProvider).tonightSuggestion();
    });

final bedtimeStoryContinueLearningSuggestionProvider =
    Provider<BedtimeStoryLearningSuggestion?>((ref) {
      return ref
          .watch(bedtimeStoryLearningRepositoryProvider)
          .continueSuggestion();
    });

final bedtimeStoryNextLearningSuggestionByStoryIdProvider =
    Provider.family<BedtimeStoryLearningSuggestion?, String>((ref, storyId) {
      return ref
          .watch(bedtimeStoryLearningRepositoryProvider)
          .firstPendingSuggestionForStory(storyId);
    });
