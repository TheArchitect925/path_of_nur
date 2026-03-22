import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_learning_loop_service.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_learning_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_learning_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_islamic_story_learning_seed.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Bedtime story learning repository', () {
    test('seeds a quiz and memory deck for every bedtime story', () {
      expect(kBedtimeStoryQuizzes.length, 14);
      expect(kBedtimeStoryMemoryDecks.length, 14);
      expect(
        kBedtimeStoryQuizzes.every((quiz) => quiz.questions.length >= 3),
        isTrue,
      );
      expect(
        kBedtimeStoryMemoryDecks.every((deck) => deck.pairs.length >= 4),
        isTrue,
      );
    });

    test('seeds a polished non-prophet quiz and memory subset', () {
      expect(kKidsIslamicStoryQuizzes.length, 5);
      expect(kKidsIslamicStoryMemoryDecks.length, 5);
      expect(
        kKidsIslamicStoryQuizzes.map((quiz) => quiz.storyId),
        contains('story_telling_the_truth_v1'),
      );
      expect(
        kKidsIslamicStoryMemoryDecks.map((deck) => deck.storyId),
        contains('story_kindness_to_animals_v1'),
      );
    });

    test('tonight suggestion resolves to a bedtime learning activity', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final suggestion = container.read(bedtimeStoryTonightLearningSuggestionProvider);
      expect(suggestion, isNotNull);
      expect(
        suggestion!.mode.name,
        anyOf(equals('quiz'), equals('memoryCards')),
      );
    });

    test('non-prophet stories reuse the shared learning repository', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final repo = container.read(bedtimeStoryLearningRepositoryProvider);
      final quiz = repo.quizForStory('story_telling_the_truth_v1');
      final memory = repo.memoryDeckForStory('story_kindness_to_animals_v1');

      expect(quiz, isNotNull);
      expect(quiz!.questions.length, greaterThanOrEqualTo(3));
      expect(memory, isNotNull);
      expect(memory!.pairs.length, greaterThanOrEqualTo(4));
    });
  });
}
