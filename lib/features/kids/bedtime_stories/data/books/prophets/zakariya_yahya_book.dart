import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Zakariya's Prayer and Yahya. Surah Maryam 19:2–15 and Al Imran 3:37–41.
/// Borrows Maryam's mihrab from the Isa book.
final BedtimeStorySeed zakariyaYahyaBook = kidsPictureBook(
  id: 'story_prophet_zakariya_yahya_bedtime_v1',
  prophetId: 'zakariya',
  storyFamilyId: 'zakariya_yahya',
  title: 'Zakariya’s Prayer and Yahya',
  shortTitle: 'Zakariya and Yahya',
  summary:
      'An old man’s whispered prayer, a sign of three silent nights, and a '
      'gentle boy called Yahya.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [KidsIslamicStoryTheme.dua, KidsIslamicStoryTheme.kindness],
  refrain: 'Allah hears a quiet prayer.',
  lesson:
      'Allah hears every prayer, even a whisper. Ask Him, and be gentle like '
      'Yahya.',
  bedtimeClosing:
      'Now close your eyes. Zakariya whispered, and Allah heard. Whisper, '
      'and He hears you. Good night.',
  quranQuote: 'When he called to his Lord a private supplication.',
  quranReference: 'Qur’an 19:3',
  quranQuoteRef: const QuranQuoteRef(surah: 19, ayah: 3),
  sourceNote: 'Follows Maryam 19:2–15 and Al Imran 3:37–41.',
  audioFileName: 'prophet_zakariya_yahya_bedtime_v1.mp3',
  tags: const ['prophet', 'zakariya', 'yahya', 'dua', 'maryam', 'gentleness'],
  sortOrder: 78,
  coverAssetPath:
      '$bedtimeStoryImageCoverAssetDirectory/zakariya_yahya_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/zakariya_yahya_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_isa_bedtime_v1',
    'story_prophet_yunus_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Prophet Zakariya, peace be upon him, was old, and his hair was white.',
        'He had no children.',
      ],
      illustrationAsset: '$_scenes/isa_mihrab.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 4),
    ),
    KidsBookSpread(
      [
        'He looked after Maryam in the mihrab.',
        'Whenever he visited, he found fruit that no one had brought.',
      ],
      illustrationAsset: '$_scenes/isa_mihrab.webp',
      quranRef: QuranQuoteRef(surah: 3, ayah: 37),
    ),
    KidsBookSpread(
      [
        '"Allah gives to whom He wills," said Maryam.',
        'So Zakariya prayed, quietly.',
      ],
      illustrationAsset: '$_scenes/zakariya_whisper.webp',
      quranRef: QuranQuoteRef(surah: 3, ayah: 38),
    ),
    KidsBookSpread(
      [
        '"My Lord, my bones are weak and my hair is white. Give me a son."',
        'Allah hears a quiet prayer.',
      ],
      illustrationAsset: '$_scenes/zakariya_whisper.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 19, ayah: 4),
    ),
    KidsBookSpread(
      [
        'The angels called: Allah gives you a boy, Yahya.',
        'A name no one had ever had before.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 19, ayah: 7),
    ),
    KidsBookSpread(
      [
        '"How, when I am so old?" asked Zakariya.',
        '"It is easy for Allah," came the answer.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 19, ayah: 9),
    ),
    KidsBookSpread(
      [
        '"Your sign: you will not speak for three nights."',
        'So he thanked Allah with his hands, not his voice.',
      ],
      illustrationAsset: '$_scenes/zakariya_three_nights.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 10),
    ),
    KidsBookSpread(
      [
        'Yahya, peace be upon him, was born.',
        'Allah gave him wisdom while he was still a boy.',
      ],
      illustrationAsset: '$_scenes/yahya_garden.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 12),
    ),
    KidsBookSpread(
      [
        'Yahya was gentle and kind to his parents, and kind to every creature.',
        'Allah hears a quiet prayer.',
      ],
      illustrationAsset: '$_scenes/yahya_garden.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 19, ayah: 14),
    ),
    KidsBookSpread(
      [
        'Whisper your duʿā tonight, like Zakariya.',
        'Allah hears a quiet prayer.',
      ],
      illustrationAsset: '$_scenes/zakariya_whisper.webp',
      isRefrain: true,
    ),
  ],
);
