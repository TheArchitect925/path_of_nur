import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Ant and the Hoopoe. Surah an-Naml 27:18–44. Borrows three scenes
/// from the Sulayman book.
final BedtimeStorySeed antHoopoeBook = kidsPictureBook(
  id: 'book_quran_ant_hoopoe_v1',
  storyFamilyId: 'quran_ant_hoopoe',
  title: 'The Ant and the Hoopoe',
  shortTitle: 'Ant and Hoopoe',
  summary:
      'A tiny ant who warned her friends, and a small bird who carried the '
      'truth.',
  category: BedtimeStoryCategory.quranStories,
  collectionType: KidsIslamicStoryCollectionType.quranStories,
  storyType: KidsIslamicStoryType.quranStory,
  themes: const [
    KidsIslamicStoryTheme.compassionForAnimals,
    KidsIslamicStoryTheme.helpingOthers,
  ],
  refrain: 'Even the smallest counts.',
  lesson: 'No one is too small to matter to Allah, or to do something good.',
  bedtimeClosing:
      'Now close your eyes. Allah hears the ant, and He hears you. Good '
      'night.',
  quranQuote:
      'An ant said, "O ants, enter your dwellings, lest you be crushed by '
      'Sulayman and his soldiers while they perceive not."',
  quranReference: 'Qur’an 27:18',
  quranQuoteRef: const QuranQuoteRef(surah: 27, ayah: 18),
  sourceNote: 'Follows an-Naml 27:18–44.',
  tags: const ['quran story', 'ant', 'hoopoe', 'sulayman', 'animals'],
  sortOrder: 407,
  isFeatured: true,
  coverAssetPath: 'assets/images/kids_books/covers/ant_hoopoe_cover.webp',
  relatedStoryIds: const [
    'story_prophet_sulaiman_bedtime_v1',
    'story_kindness_to_animals_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'In a green valley, a tiny ant heard a rumble.',
        'An army was coming: Sulayman’s army.',
      ],
      illustrationAsset: '$_scenes/ant_valley.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 18),
    ),
    KidsBookSpread(
      [
        '"Quick!" she called. "Into your homes, or you’ll be crushed!"',
        'The ants ran.',
      ],
      illustrationAsset: '$_scenes/sulaiman_ants.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 18),
    ),
    KidsBookSpread(
      [
        'Sulayman heard her small voice, and smiled.',
        'Then he thanked Allah, who let him hear it.',
      ],
      illustrationAsset: '$_scenes/sulaiman_ants.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 19),
    ),
    KidsBookSpread(
      [
        'Even the smallest counts.',
        'Allah saw the ant, and put her in the Qur’an.',
      ],
      illustrationAsset: '$_scenes/ant_valley.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Another day, Sulayman looked for a small bird: the hoopoe.',
        'It was gone.',
      ],
      illustrationAsset: '$_scenes/sulaiman_hoopoe.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 20),
    ),
    KidsBookSpread(
      [
        'The hoopoe flew back with news from far away.',
        '"I saw a queen whose people worship the sun!"',
      ],
      illustrationAsset: '$_scenes/hoopoe_flight.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 24),
    ),
    KidsBookSpread(
      [
        '"Take this letter to them," said Sulayman.',
        'The small bird carried a big message.',
      ],
      illustrationAsset: '$_scenes/hoopoe_flight.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 28),
    ),
    KidsBookSpread(
      [
        'The queen read the letter, and came to see for herself.',
        'In the end she believed in Allah.',
      ],
      illustrationAsset: '$_scenes/sulaiman_sun_kingdom.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 44),
    ),
    KidsBookSpread(
      [
        'A tiny ant saved her people. A small bird carried the truth.',
        'Even the smallest counts.',
      ],
      illustrationAsset: '$_scenes/hoopoe_flight.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'You are small too. And you can do big things for Allah.',
        'Even the smallest counts.',
      ],
      illustrationAsset: '$_scenes/sulaiman_ants.webp',
      isRefrain: true,
    ),
  ],
);
