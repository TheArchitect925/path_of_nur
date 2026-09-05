import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_repository.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BedtimeStoryRepository', () {
    test('seed contains the full V1 prophet bedtime catalog', () {
      expect(kBedtimeProphetStories.length, 14);
      expect(
        kBedtimeProphetStories.map((story) => story.prophetId),
        containsAll(<String>{
          'adam',
          'nuh',
          'ibrahim',
          'ismail',
          'yusuf',
          'musa',
          'yunus',
          'dawud',
          'isa',
          'sulaiman',
          'muhammad',
        }),
      );
    });

    test('muhammad series is complete and ordered as four parts', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final series = container.read(bedtimeStorySeriesProvider('muhammad'));
      expect(series.length, 4);
      expect(series.every((story) => story.isMultipart), isTrue);
      expect(
        series.map((story) => story.partNumber),
        orderedEquals([1, 2, 3, 4]),
      );
      expect(series.every((story) => story.totalParts == 4), isTrue);
    });

    test('featured and tonight stories remain stable and valid', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final featured = container.read(featuredBedtimeStoryProvider);
      final tonight = container.read(tonightBedtimeStoryProvider);

      expect(featured, isNotNull);
      expect(featured!.isFeatured, isTrue);
      expect(tonight, isNotNull);
      expect(
        tonight!.recommendedForTonight || tonight.id == featured.id,
        isTrue,
      );
    });

    test(
      'library includes the new non-prophet stories without breaking bedtime',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        final libraryStories = container.read(kidsIslamicStoriesProvider);
        final bedtimeStories = container.read(bedtimeStoriesProvider);

        // 14 prophet books, 10 manners stories, 3 companions, 1 First Steps.
        expect(libraryStories.length, 28);
        expect(libraryStories.any((story) => !story.isProphetStory), isTrue);
        expect(
          libraryStories.any(
            (story) => story.id == 'book_first_steps_five_pillars_v1',
          ),
          isTrue,
        );
        expect(
          libraryStories.any(
            (story) => story.id == 'story_companion_khadijah_support_v1',
          ),
          isTrue,
        );
        expect(
          bedtimeStories.any(
            (story) => story.id == 'story_sharing_with_others_v1',
          ),
          isTrue,
        );
        expect(
          bedtimeStories.any(
            (story) => story.id == 'story_bismillah_before_eating_v1',
          ),
          isFalse,
        );
      },
    );

    test('library can browse non-prophet collections cleanly', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final characterStories = container.read(
        kidsStoriesByCollectionProvider(
          KidsIslamicStoryCollectionType.characterAdab,
        ),
      );

      expect(characterStories, isNotEmpty);
      expect(
        characterStories.map((story) => story.storyType),
        contains(KidsIslamicStoryType.honesty),
      );
      expect(
        characterStories.map((story) => story.storyType),
        contains(KidsIslamicStoryType.patience),
      );

      final companionStories = container.read(
        kidsStoriesByCollectionProvider(
          KidsIslamicStoryCollectionType.companions,
        ),
      );
      expect(companionStories, isNotEmpty);
      expect(
        companionStories.map((story) => story.storyType),
        everyElement(KidsIslamicStoryType.companion),
      );
    });
  });
}
