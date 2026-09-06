import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Adam and the Garden. Surah al-Baqarah 2:30–38, al-A'raf 7:19–25. The
/// pictures are the K3 scenes this story already had.
final BedtimeStorySeed adamBook = kidsPictureBook(
  id: 'story_prophet_adam_bedtime_v1',
  prophetId: 'adam',
  title: 'Adam and the Garden',
  shortTitle: 'Prophet Adam',
  summary:
      'The first human, one tree, one mistake, and the sorry that Allah '
      'accepted.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.forgiveness,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  refrain: 'Say sorry, and try again.',
  lesson:
      'Everyone makes mistakes, but Allah loves those who turn back to Him '
      'and try again.',
  bedtimeClosing:
      'Now close your eyes. Allah forgave Adam, and Allah loves you. Good '
      'night.',
  quranQuote:
      'Then Adam received words from his Lord, and He accepted his '
      'repentance. Indeed, He is the Accepting of repentance, the Most '
      'Merciful.',
  quranReference: 'Qur’an 2:37',
  quranQuoteRef: const QuranQuoteRef(surah: 2, ayah: 37),
  sourceNote: 'Follows al-Baqarah 2:30–38 and al-A’raf 7:19–25.',
  audioFileName: 'prophet_adam_bedtime_v1.mp3',
  tags: const ['prophet', 'adam', 'forgiveness', 'beginning', 'jannah'],
  sortOrder: 10,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/adam_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/adam_backdrop.webp',
  relatedStoryIds: const ['story_prophet_nuh_bedtime_v1'],
  spreads: const [
    KidsBookSpread([
      'Before there were people, the world was quiet.',
      'Allah made the sky, the stars, the mountains and the seas.',
    ], illustrationAsset: '$_scenes/adam_creation.webp'),
    KidsBookSpread(
      [
        'Then Allah made the first human being.',
        'His name was Adam, peace be upon him.',
      ],
      illustrationAsset: '$_scenes/adam_creation.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 30),
    ),
    KidsBookSpread(
      [
        'Allah taught Adam the names of everything.',
        'The angels were amazed at what Adam knew.',
      ],
      atlasScene: KidsBookAtlasScene.daySky,
      quranRef: QuranQuoteRef(surah: 2, ayah: 31),
    ),
    KidsBookSpread([
      'Allah gave Adam a garden called Jannah.',
      'Trees, rivers, sweet fruit and peace.',
    ], illustrationAsset: '$_scenes/adam_jannah.webp'),
    KidsBookSpread([
      'Adam was alone, so Allah made Hawwa.',
      'Now there were two, and they were happy.',
    ], illustrationAsset: '$_scenes/adam_jannah.webp'),
    KidsBookSpread(
      [
        '"Enjoy everything," Allah told them.',
        '"But do not go near this one tree."',
      ],
      illustrationAsset: '$_scenes/adam_one_tree.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 35),
    ),
    KidsBookSpread(
      [
        'Iblis did not like Adam.',
        'He whispered, and whispered, until they forgot.',
      ],
      illustrationAsset: '$_scenes/adam_one_tree.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 20),
    ),
    KidsBookSpread(
      ['They ate from the tree.', 'Then they felt it. They had done wrong.'],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 7, ayah: 22),
    ),
    KidsBookSpread(
      [
        'Adam and Hawwa did not hide.',
        'They said sorry to Allah.',
        'Say sorry, and try again.',
      ],
      illustrationAsset: '$_scenes/adam_forgiveness.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 7, ayah: 23),
    ),
    KidsBookSpread(
      [
        'Allah forgave them.',
        'Allah always forgives those who turn back to Him.',
        'Say sorry, and try again.',
      ],
      illustrationAsset: '$_scenes/adam_forgiveness.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 2, ayah: 37),
    ),
    KidsBookSpread(
      [
        'Then it was time to live on Earth.',
        'Adam became the first prophet, and taught his children about Allah.',
      ],
      illustrationAsset: '$_scenes/adam_earth.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 38),
    ),
    KidsBookSpread(
      [
        'Everyone makes mistakes. Even the first man did.',
        'Say sorry, and try again.',
      ],
      illustrationAsset: '$_scenes/adam_earth.webp',
      isRefrain: true,
    ),
  ],
);
