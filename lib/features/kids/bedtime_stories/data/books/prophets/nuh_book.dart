import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Nuh and the Ship. Surah Nuh (71), Hud 11:36–48, al-Qamar 54:9–15. The
/// speech is the Qur'an's, paraphrased for a child; Judi is named in 11:44.
final BedtimeStorySeed nuhBook = kidsPictureBook(
  id: 'story_prophet_nuh_bedtime_v1',
  prophetId: 'nuh',
  title: 'Nuh and the Ship',
  shortTitle: 'Prophet Nuh',
  summary:
      'Nuh builds a ship on dry land because Allah told him to, and the '
      'flood proves him right.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.patience,
  ],
  lesson:
      'Keep doing what is right, even when people laugh. Allah helps those '
      'who obey Him and keep going.',
  bedtimeClosing:
      'Now close your eyes. The rain has stopped, the ship is resting, and '
      'you are safe. Good night.',
  quranQuote:
      'And We carried him on a vessel of planks and nails, sailing under Our '
      'eyes.',
  quranReference: 'Qur’an 54:13–14',
  quranQuoteRef: const QuranQuoteRef(surah: 54, ayah: 13),
  sourceNote:
      'Follows Surah Nuh (71), Hud 11:36–48 and al-Qamar 54:9–15. The '
      'mountain Judi is named in 11:44.',
  audioFileName: 'prophet_nuh_bedtime_v1.mp3',
  tags: const ['prophet', 'nuh', 'ark', 'patience', 'trust'],
  sortOrder: 20,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/nuh_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/nuh_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_adam_bedtime_v1',
    'story_prophet_ibrahim_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Long after Adam, people forgot Allah.',
        'They bowed to statues they had made with their own hands.',
      ],
      illustrationAsset: '$_scenes/nuh_idols.webp',
      quranRef: QuranQuoteRef(surah: 71, ayah: 23),
    ),
    KidsBookSpread(
      [
        'Allah sent them Prophet Nuh, peace be upon him.',
        '"Worship Allah alone," he said. "He made you."',
      ],
      atlasScene: KidsBookAtlasScene.cityMorning,
      quranRef: QuranQuoteRef(surah: 71, ayah: 3),
    ),
    KidsBookSpread(
      [
        'Nuh spoke by day. Nuh spoke by night.',
        'Year after year after year.',
        'Most people laughed at him.',
      ],
      illustrationAsset: '$_scenes/nuh_day_and_night.webp',
      quranRef: QuranQuoteRef(surah: 71, ayah: 5),
    ),
    KidsBookSpread(
      ['Nuh did not stop.', 'Allah told him what to do, and Nuh did it.'],
      atlasScene: KidsBookAtlasScene.desertRoad,
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Then Allah told Nuh to build a ship.',
        'A great ship of planks and nails,',
        'far from any water.',
      ],
      illustrationAsset: '$_scenes/nuh_ark_dry.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 37),
    ),
    KidsBookSpread(
      [
        'People laughed harder. A ship on dry land!',
        'But Nuh hammered, and sawed, and built.',
      ],
      illustrationAsset: '$_scenes/nuh_ark_dry.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 38),
    ),
    KidsBookSpread(
      [
        '"Bring two of every animal," Allah said.',
        'Two sheep, two birds, two of everything.',
      ],
      illustrationAsset: '$_scenes/nuh_animals.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 40),
    ),
    KidsBookSpread(
      [
        'Up the plank they went, two by two.',
        'Allah told him what to do, and Nuh did it.',
      ],
      illustrationAsset: '$_scenes/nuh_animals.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'The rain began. The springs burst from the ground.',
        'The water rose, and rose, and rose.',
      ],
      illustrationAsset: '$_scenes/nuh_flood.webp',
      quranRef: QuranQuoteRef(surah: 54, ayah: 11),
    ),
    KidsBookSpread(
      [
        'The ship floated on waves as high as mountains.',
        'Inside, Nuh\'s family and the animals were safe.',
      ],
      illustrationAsset: '$_scenes/nuh_flood.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 42),
    ),
    KidsBookSpread(
      [
        'Then Allah said: O earth, swallow your water. O sky, hold back.',
        'And the flood stopped.',
      ],
      illustrationAsset: '$_scenes/nuh_calm.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 44),
    ),
    KidsBookSpread(
      [
        'The ship came to rest on a mountain called Judi.',
        'Nuh stepped out into a clean new world.',
      ],
      illustrationAsset: '$_scenes/nuh_judi.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 48),
    ),
    KidsBookSpread(
      [
        'Keep going like Nuh, even when people laugh.',
        'Allah told him what to do, and Nuh did it.',
      ],
      illustrationAsset: '$_scenes/nuh_judi.webp',
      isRefrain: true,
    ),
  ],
);
