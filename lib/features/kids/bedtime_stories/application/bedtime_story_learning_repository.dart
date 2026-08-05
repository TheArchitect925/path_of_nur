import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/bedtime_story_learning_seed.dart';
import '../data/kids_islamic_story_learning_seed.dart';
import '../domain/bedtime_story_learning_models.dart';
import 'bedtime_story_learning_progress_service.dart';
import 'bedtime_story_repository.dart';

final bedtimeStoryLearningRepositoryProvider =
    Provider<BedtimeStoryLearningRepository>((ref) {
      return BedtimeStoryLearningRepository(ref);
    });

final bedtimeStoryQuizByStoryIdProvider =
    Provider.family<BedtimeStoryQuizSeed?, String>((ref, storyId) {
      return ref
          .watch(bedtimeStoryLearningRepositoryProvider)
          .quizForStory(storyId);
    });

final bedtimeStoryMemoryDeckByStoryIdProvider =
    Provider.family<BedtimeStoryMemoryDeckSeed?, String>((ref, storyId) {
      return ref
          .watch(bedtimeStoryLearningRepositoryProvider)
          .memoryDeckForStory(storyId);
    });

class BedtimeStoryLearningRepository {
  BedtimeStoryLearningRepository(this._ref);

  final Ref _ref;

  List<BedtimeStoryQuizSeed> get quizzes =>
      [...kBedtimeStoryQuizzes, ...kKidsIslamicStoryQuizzes]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<BedtimeStoryMemoryDeckSeed> get memoryDecks =>
      [...kBedtimeStoryMemoryDecks, ...kKidsIslamicStoryMemoryDecks]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  BedtimeStoryQuizSeed? quizForStory(String storyId) {
    final story = _ref.watch(bedtimeStoryByIdProvider(storyId));
    if (story != null && story.quizRefs.isNotEmpty) {
      for (final quizId in story.quizRefs) {
        final quiz = quizById(quizId);
        if (quiz != null) {
          return quiz;
        }
      }
    }
    for (final quiz in quizzes) {
      if (quiz.storyId == storyId) {
        return quiz;
      }
    }
    return null;
  }

  BedtimeStoryMemoryDeckSeed? memoryDeckForStory(String storyId) {
    final story = _ref.watch(bedtimeStoryByIdProvider(storyId));
    if (story != null && story.memoryRefs.isNotEmpty) {
      for (final deckId in story.memoryRefs) {
        final deck = memoryDeckById(deckId);
        if (deck != null) {
          return deck;
        }
      }
    }
    for (final deck in memoryDecks) {
      if (deck.storyId == storyId) {
        return deck;
      }
    }
    return null;
  }

  BedtimeStoryLearningSuggestion? tonightSuggestion() {
    final story =
        _ref.watch(continueBedtimeStoryProvider) ??
        _ref.watch(tonightBedtimeStoryProvider);
    if (story == null) {
      return null;
    }
    return firstPendingSuggestionForStory(story.id);
  }

  BedtimeStoryLearningSuggestion? continueSuggestion() {
    final learningState = _ref.watch(bedtimeStoryLearningProgressProvider);
    for (final activityId in learningState.recentActivityIds) {
      final progress = learningState.progressByActivityId[activityId];
      if (progress == null ||
          progress.completionState !=
              BedtimeStoryLearningCompletionState.inProgress) {
        continue;
      }
      final quiz = quizById(activityId);
      if (quiz != null) {
        return BedtimeStoryLearningSuggestion(
          activityId: quiz.quizId,
          storyId: quiz.storyId,
          mode: BedtimeStoryLearningMode.quiz,
          title: quiz.title,
          subtitle: quiz.shortDescription,
        );
      }
      final deck = memoryDeckById(activityId);
      if (deck != null) {
        return BedtimeStoryLearningSuggestion(
          activityId: deck.deckId,
          storyId: deck.storyId,
          mode: BedtimeStoryLearningMode.memoryCards,
          title: deck.title,
          subtitle: deck.shortDescription,
        );
      }
    }
    return null;
  }

  BedtimeStoryLearningSuggestion? firstPendingSuggestionForStory(
    String storyId,
  ) {
    final learningState = _ref.watch(bedtimeStoryLearningProgressProvider);
    final quiz = quizForStory(storyId);
    if (quiz != null) {
      final progress = learningState.progressByActivityId[quiz.quizId];
      if (!(progress?.isCompleted ?? false)) {
        return BedtimeStoryLearningSuggestion(
          activityId: quiz.quizId,
          storyId: quiz.storyId,
          mode: BedtimeStoryLearningMode.quiz,
          title: quiz.title,
          subtitle: quiz.shortDescription,
        );
      }
    }
    final deck = memoryDeckForStory(storyId);
    if (deck != null) {
      final progress = learningState.progressByActivityId[deck.deckId];
      if (!(progress?.isCompleted ?? false)) {
        return BedtimeStoryLearningSuggestion(
          activityId: deck.deckId,
          storyId: deck.storyId,
          mode: BedtimeStoryLearningMode.memoryCards,
          title: deck.title,
          subtitle: deck.shortDescription,
        );
      }
    }
    return null;
  }

  BedtimeStoryQuizSeed? quizById(String quizId) {
    for (final quiz in quizzes) {
      if (quiz.quizId == quizId) {
        return quiz;
      }
    }
    return null;
  }

  BedtimeStoryMemoryDeckSeed? memoryDeckById(String deckId) {
    for (final deck in memoryDecks) {
      if (deck.deckId == deckId) {
        return deck;
      }
    }
    return null;
  }
}
