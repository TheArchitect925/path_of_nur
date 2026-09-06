import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Qarun's Treasure. Surah al-Qasas 28:76–82.
final BedtimeStorySeed qarunBook = kidsPictureBook(
  id: 'book_quran_qarun_v1',
  storyFamilyId: 'quran_qarun',
  title: 'Qarun’s Treasure',
  shortTitle: 'Qarun',
  summary:
      'Keys too heavy to carry, a parade of gold, and the ground that '
      'opened.',
  category: BedtimeStoryCategory.quranStories,
  collectionType: KidsIslamicStoryCollectionType.quranStories,
  storyType: KidsIslamicStoryType.quranStory,
  themes: const [
    KidsIslamicStoryTheme.gratitude,
    KidsIslamicStoryTheme.sharing,
  ],
  refrain: 'Do not be proud.',
  lesson:
      'Everything we have comes from Allah. Be thankful, share it, and '
      'never be proud.',
  bedtimeClosing:
      'Now close your eyes. Everything you have is a gift, and the Giver is '
      'watching. Good night.',
  quranQuote: 'And do good as Allah has done good to you.',
  quranReference: 'Qur’an 28:77',
  quranQuoteRef: const QuranQuoteRef(surah: 28, ayah: 77),
  sourceNote: 'Follows al-Qasas 28:76–82.',
  tags: const ['quran story', 'qarun', 'treasure', 'pride', 'gratitude'],
  sortOrder: 405,
  coverAssetPath: 'assets/images/kids_books/covers/qarun_cover.webp',
  relatedStoryIds: const [
    'book_quran_two_gardens_v1',
    'book_first_steps_sharing_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Qarun lived with the people of Musa.',
        'Allah gave him so much treasure that the keys were heavy to carry.',
      ],
      illustrationAsset: '$_scenes/qarun_keys.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 76),
    ),
    KidsBookSpread(
      [
        'Strong men groaned under the weight of his keys.',
        'Room after room of gold and jewels.',
      ],
      illustrationAsset: '$_scenes/qarun_treasure.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 76),
    ),
    KidsBookSpread(
      [
        'They said: "Do not be proud. Allah does not love the proud."',
        '"Do good, as Allah did good to you."',
      ],
      illustrationAsset: '$_scenes/qarun_treasure.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 28, ayah: 77),
    ),
    KidsBookSpread(
      [
        'Qarun laughed. "I earned this myself," he said. "I am clever."',
        'He forgot who gave it.',
      ],
      illustrationAsset: '$_scenes/qarun_treasure.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 78),
    ),
    KidsBookSpread(
      [
        'One day he paraded through the streets in all his gold.',
        '"If only we had that!" some people sighed.',
      ],
      illustrationAsset: '$_scenes/qarun_parade.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 79),
    ),
    KidsBookSpread(
      [
        'But the wise ones said: "Allah’s reward is better."',
        '"It is for those who believe and do good."',
      ],
      illustrationAsset: '$_scenes/qarun_parade.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 80),
    ),
    KidsBookSpread(
      [
        'Then the earth opened under Qarun.',
        'His house, his gold, his keys: all of it sank away.',
      ],
      illustrationAsset: '$_scenes/qarun_earth.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 81),
    ),
    KidsBookSpread(
      [
        'Nobody could help him. Not his gold. Not his friends.',
        'Only Allah could have, and Qarun had turned away.',
      ],
      illustrationAsset: '$_scenes/qarun_earth.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 81),
    ),
    KidsBookSpread(
      [
        'The people who had sighed now said: "Thank Allah we are not like him."',
        'Do not be proud.',
      ],
      illustrationAsset: '$_scenes/qarun_parade.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 28, ayah: 82),
    ),
    KidsBookSpread(
      [
        'When you have something nice, remember who gave it.',
        'Share it. Do not be proud.',
      ],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
    ),
  ],
);
