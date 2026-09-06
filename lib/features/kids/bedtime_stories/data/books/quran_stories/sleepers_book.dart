import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Sleepers in the Cave. Surah al-Kahf 18:9–26.
final BedtimeStorySeed sleepersBook = kidsPictureBook(
  id: 'book_quran_sleepers_v1',
  storyFamilyId: 'quran_sleepers',
  title: 'The Sleepers in the Cave',
  shortTitle: 'The Sleepers',
  summary:
      'Young men who would not bow, a cave, a dog at the door, and a sleep '
      'of three hundred years.',
  category: BedtimeStoryCategory.quranStories,
  collectionType: KidsIslamicStoryCollectionType.quranStories,
  storyType: KidsIslamicStoryType.quranStory,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'Allah kept them safe.',
  lesson: 'Hold on to what you believe. Allah keeps those who trust Him safe.',
  bedtimeClosing:
      'Now close your eyes. Allah watched over the sleepers, and He watches '
      'over you. Good night.',
  quranQuote:
      'Indeed, they were youths who believed in their Lord, and We increased '
      'them in guidance.',
  quranReference: 'Qur’an 18:13',
  quranQuoteRef: const QuranQuoteRef(surah: 18, ayah: 13),
  sourceNote: 'Follows al-Kahf 18:9–26.',
  tags: const ['quran story', 'cave', 'kahf', 'courage', 'dog'],
  sortOrder: 400,
  isFeatured: true,
  coverAssetPath: 'assets/images/kids_books/covers/sleepers_cover.webp',
  relatedStoryIds: const [
    'book_quran_two_gardens_v1',
    'story_prophet_muhammad_part3_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Long ago, in a city full of statues, some young men believed in Allah.',
        'Only Allah.',
      ],
      illustrationAsset: '$_scenes/kahf_city_idols.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 14),
    ),
    KidsBookSpread(
      [
        'The king was angry. "Bow to our gods, or else!"',
        'The young men would not.',
      ],
      illustrationAsset: '$_scenes/kahf_city_idols.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 20),
    ),
    KidsBookSpread(
      [
        'So they ran to the hills and found a cave.',
        'Their dog came too, and lay at the door.',
      ],
      illustrationAsset: '$_scenes/kahf_cave_entrance.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 18),
    ),
    KidsBookSpread(
      ['"Our Lord, give us mercy," they prayed.', 'Allah kept them safe.'],
      illustrationAsset: '$_scenes/kahf_cave_entrance.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 18, ayah: 10),
    ),
    KidsBookSpread(
      [
        'Allah made them sleep. A long, long sleep.',
        'The sun passed the cave, morning and evening, and never woke them.',
      ],
      illustrationAsset: '$_scenes/kahf_sun.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 17),
    ),
    KidsBookSpread(
      [
        'Allah turned them gently, left and right, so they would rest well.',
        'Three hundred years. And nine.',
      ],
      illustrationAsset: '$_scenes/kahf_sleep.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 25),
    ),
    KidsBookSpread(
      [
        'Then they woke up. "How long did we sleep?" "A day, maybe."',
        'One of them went to buy food.',
      ],
      illustrationAsset: '$_scenes/kahf_sleep.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 19),
    ),
    KidsBookSpread(
      [
        'In the market, he held out his coin.',
        'The people stared. It was three hundred years old!',
      ],
      illustrationAsset: '$_scenes/kahf_coin.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 19),
    ),
    KidsBookSpread(
      [
        'The whole city had changed. Now everyone believed in Allah.',
        'Allah kept them safe.',
      ],
      illustrationAsset: '$_scenes/kahf_coin.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 18, ayah: 21),
    ),
    KidsBookSpread(
      [
        'Allah tells their story so we know:',
        'when you hold on to Allah, He holds on to you.',
      ],
      illustrationAsset: '$_scenes/kahf_cave_entrance.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 13),
    ),
    KidsBookSpread(
      [
        'If you are ever scared for what you believe, remember the cave.',
        'Allah kept them safe.',
      ],
      illustrationAsset: '$_scenes/kahf_sun.webp',
      isRefrain: true,
    ),
  ],
);
