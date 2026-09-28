import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/application/bedtime_story_repository.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/kids_story_pages.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BedtimeStoryRepository', () {
    test('the Prophets shelf holds the whole chain, Adam to Muhammad ﷺ', () {
      // 21 single books, three shared ones, and the four-part ﷺ series.
      expect(kBedtimeProphetStories.length, 25);
      expect(
        kBedtimeProphetStories.map((story) => story.prophetId),
        containsAll(<String>{
          'adam',
          'idris',
          'nuh',
          'hud',
          'salih',
          'ibrahim',
          'lut',
          'ismail',
          'ishaq',
          'yusuf',
          'shuayb',
          'ayyub',
          'dhul_kifl',
          'musa',
          'harun',
          'dawud',
          'sulaiman',
          'ilyas',
          'yunus',
          'zakariya',
          'isa',
          'muhammad',
        }),
      );
      // The shelf reads in the order of the chain.
      final orders = kBedtimeProphetStories.map((s) => s.sortOrder).toList();
      final sorted = [...orders]..sort();
      expect(orders, sorted);
      expect(orders.toSet().length, orders.length, reason: 'sortOrder clash');
      expect(kBedtimeProphetStories.every((s) => s.isPictureBook), isTrue);
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

        // 25 prophet books, 10 manners stories, 8 companions, 14 First
        // Steps, 8 Stories from the Qur'an, 8 Friends of the Prophet ﷺ.
        expect(libraryStories.length, 65);
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

    test('the library reads in German when the app locale is German', () async {
      // C6: the repository resolves the locale once; a book that carries
      // German reads in it, a book that does not reads as written.
      SharedPreferences.setMockInitialValues(<String, Object>{
        'profile.locale': 'de',
      });
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final stories = container.read(kidsIslamicStoriesProvider);
      final yunus = stories.firstWhere(
        (story) => story.id == 'story_prophet_yunus_bedtime_v1',
      );
      expect(yunus.contentLanguage, 'de');
      expect(yunus.title, 'Yunus und der große Fisch');
      expect(yunus.refrain, 'Allah hört immer.');
      expect(yunus.readAloudLanguageCode, 'de-DE');
      expect(
        kidsStoryPagesFor(yunus).first.lines.first,
        startsWith('Allah schickte'),
      );
      expect(
        container.read(bedtimeStoryByIdProvider(yunus.id))?.title,
        'Yunus und der große Fisch',
      );

      // Every book on the shelves carries German now; the English fallback
      // for a language a book lacks is covered by kids_books_content_test.
      expect(stories.every((story) => story.contentLanguage == 'de'), isTrue);
      expect(
        stories.every((story) => story.readAloudLanguageCode == 'de-DE'),
        isTrue,
      );
    });
  });
}
