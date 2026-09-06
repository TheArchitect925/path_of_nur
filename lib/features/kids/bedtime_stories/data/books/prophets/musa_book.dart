import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Musa and the Sea That Opened. Surah al-Qasas 28:3–13, Ta-Ha 20:9–24 and
/// ash-Shu'ara 26:52–66, on the K3 scenes this story already had.
final BedtimeStorySeed musaBook = kidsPictureBook(
  id: 'story_prophet_musa_bedtime_v1',
  prophetId: 'musa',
  title: 'Musa and the Sea That Opened',
  shortTitle: 'Prophet Musa',
  summary: 'A baby in a basket, a fire on a mountain, and a sea that opened.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.patience,
  ],
  refrain: 'Allah is with me.',
  lesson:
      'Trust Allah even in scary times, be brave, and stand up for what is '
      'right.',
  bedtimeClosing:
      'Now close your eyes. Allah was with Musa, and Allah is with you. Good '
      'night.',
  quranQuote:
      'Then We inspired Musa: "Strike with your staff the sea," and it '
      'parted, and each portion was like a great towering mountain.',
  quranReference: 'Qur’an 26:63',
  quranQuoteRef: const QuranQuoteRef(surah: 26, ayah: 63),
  sourceNote:
      'Follows al-Qasas 28:3–13, Ta-Ha 20:9–24 and ash-Shu’ara 26:52–66.',
  audioFileName: 'prophet_musa_bedtime_v1.mp3',
  tags: const ['prophet', 'musa', 'sea', 'firawn', 'courage', 'trust'],
  sortOrder: 60,
  isFeatured: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/musa_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/musa_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_nuh_bedtime_v1',
    'story_prophet_yunus_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Long ago in Egypt there was a cruel king, Firawn.',
        'He ordered every baby boy to be taken away.',
      ],
      atlasScene: KidsBookAtlasScene.cityMorning,
      quranRef: QuranQuoteRef(surah: 28, ayah: 4),
    ),
    KidsBookSpread(
      [
        'Musa’s mother hid him as long as she could.',
        'Allah told her: put him in a basket on the river.',
      ],
      illustrationAsset: '$_scenes/musa_river_basket.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 7),
    ),
    KidsBookSpread(
      [
        '"Do not be afraid," Allah said. "I will bring him back to you."',
        'And the basket floated away.',
      ],
      illustrationAsset: '$_scenes/musa_river_basket.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 7),
    ),
    KidsBookSpread(
      [
        'The basket came to Firawn’s palace.',
        'Firawn’s wife loved the baby, and Musa grew up safe.',
      ],
      illustrationAsset: '$_scenes/musa_palace.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 9),
    ),
    KidsBookSpread(
      ['His own mother was found to feed him.', 'Allah had kept His promise.'],
      illustrationAsset: '$_scenes/musa_palace.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 13),
    ),
    KidsBookSpread(
      [
        'When Musa grew up, he saw a fire on a mountain.',
        'He went closer, and Allah spoke to him.',
      ],
      illustrationAsset: '$_scenes/musa_fire_mountain.webp',
      quranRef: QuranQuoteRef(surah: 20, ayah: 10),
    ),
    KidsBookSpread(
      [
        '"Musa, I am Allah. Go to Firawn," said Allah.',
        'Musa said: Allah is with me.',
      ],
      illustrationAsset: '$_scenes/musa_fire_mountain.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 20, ayah: 24),
    ),
    KidsBookSpread(
      [
        'Musa showed Firawn the signs of Allah.',
        'His staff became a snake. His hand shone white.',
      ],
      illustrationAsset: '$_scenes/musa_staff.webp',
      quranRef: QuranQuoteRef(surah: 20, ayah: 20),
    ),
    KidsBookSpread(
      ['Firawn would not listen.', 'So Musa led his people away in the night.'],
      atlasScene: KidsBookAtlasScene.desertRoad,
      quranRef: QuranQuoteRef(surah: 26, ayah: 52),
    ),
    KidsBookSpread(
      [
        'Firawn’s army came after them.',
        'In front, the sea. Behind, the soldiers.',
        'The people cried: we are caught!',
      ],
      atlasScene: KidsBookAtlasScene.sea,
      quranRef: QuranQuoteRef(surah: 26, ayah: 61),
    ),
    KidsBookSpread(
      [
        'Musa said: "No! Allah is with me. He will show me the way."',
        'Then Allah said: strike the sea.',
      ],
      illustrationAsset: '$_scenes/musa_sea_split.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 26, ayah: 62),
    ),
    KidsBookSpread(
      [
        'The sea opened.',
        'A dry path in the middle, with water like mountains on each side.',
      ],
      illustrationAsset: '$_scenes/musa_sea_split.webp',
      quranRef: QuranQuoteRef(surah: 26, ayah: 63),
    ),
    KidsBookSpread(
      [
        'Musa and his people walked through, safe.',
        'The sea closed behind them.',
      ],
      illustrationAsset: '$_scenes/musa_safe_shore.webp',
      quranRef: QuranQuoteRef(surah: 26, ayah: 65),
    ),
    KidsBookSpread(
      ['When you are afraid, say what Musa said.', 'Allah is with me.'],
      illustrationAsset: '$_scenes/musa_safe_shore.webp',
      isRefrain: true,
    ),
  ],
);
