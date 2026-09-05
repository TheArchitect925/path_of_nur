import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Yusuf and the Dream. Surah Yusuf (12), from the dream in 12:4 to the
/// family's bowing in 12:100. The speech is the Qur'an's, paraphrased.
final BedtimeStorySeed yusufBook = kidsPictureBook(
  id: 'story_prophet_yusuf_bedtime_v1',
  prophetId: 'yusuf',
  title: 'Yusuf and the Dream',
  shortTitle: 'Prophet Yusuf',
  summary:
      'From a well to a prison to the king\'s storehouses, Yusuf stays '
      'patient and honest, and Allah\'s plan comes true.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.patience,
    KidsIslamicStoryTheme.forgiveness,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  lesson:
      'Be patient and honest, and forgive. Allah is with you in the hard '
      'times and the good ones.',
  bedtimeClosing:
      'Now close your eyes. Allah is with you, in the dark and in the light. '
      'Good night.',
  quranQuote:
      'Indeed, whoever fears Allah and is patient, then indeed, Allah does '
      'not allow to be lost the reward of those who do good.',
  quranReference: 'Qur’an 12:90',
  quranQuoteRef: const QuranQuoteRef(surah: 12, ayah: 90),
  sourceNote:
      'Follows Surah Yusuf (12) from the dream in 12:4 to the family\'s '
      'bowing in 12:100.',
  audioFileName: 'prophet_yusuf_bedtime_v1.mp3',
  tags: const ['prophet', 'yusuf', 'dreams', 'patience', 'forgiveness'],
  sortOrder: 50,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/yusuf_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/yusuf_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_yunus_bedtime_v1',
    'story_prophet_muhammad_part4_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Prophet Yusuf, peace be upon him, was a boy with a dream.',
        'Eleven stars, the sun and the moon bowed.',
      ],
      illustrationAsset: '$_scenes/yusuf_dream.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 4),
    ),
    KidsBookSpread(
      [
        '"Tell no one," said his father Yaqub, who was a prophet too.',
        '"Allah has chosen you for something."',
      ],
      atlasScene: KidsBookAtlasScene.homeEvening,
      quranRef: QuranQuoteRef(surah: 12, ayah: 5),
    ),
    KidsBookSpread(
      [
        'Yusuf\'s brothers were jealous.',
        'They took him far away and dropped him into a deep, dark well.',
      ],
      illustrationAsset: '$_scenes/yusuf_well.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 15),
    ),
    KidsBookSpread(
      [
        'Yusuf was alone at the bottom.',
        'But not really alone.',
        'Allah was with Yusuf.',
      ],
      illustrationAsset: '$_scenes/yusuf_well.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'A caravan stopped for water. Down went the bucket.',
        'Up came Yusuf!',
        'They took him to Egypt.',
      ],
      illustrationAsset: '$_scenes/yusuf_caravan.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 19),
    ),
    KidsBookSpread(
      [
        'Yusuf grew up in a rich man\'s house, far from home.',
        'He stayed honest and kind.',
      ],
      atlasScene: KidsBookAtlasScene.cityMorning,
      quranRef: QuranQuoteRef(surah: 12, ayah: 22),
    ),
    KidsBookSpread(
      [
        'One day he was blamed for something he did not do.',
        'They put him in prison.',
      ],
      illustrationAsset: '$_scenes/yusuf_prison.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 35),
    ),
    KidsBookSpread(
      [
        'Even in prison, Yusuf helped people.',
        'Allah taught him what dreams mean.',
        'Allah was with Yusuf.',
      ],
      illustrationAsset: '$_scenes/yusuf_prison.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 12, ayah: 36),
    ),
    KidsBookSpread(
      [
        'The king had a dream.',
        'Seven thin cows ate seven fat cows.',
        'Nobody could explain it.',
      ],
      illustrationAsset: '$_scenes/yusuf_cows.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 43),
    ),
    KidsBookSpread(
      [
        'Yusuf could.',
        '"Seven good years, then seven hungry years," he said.',
        '"Save the grain!"',
      ],
      illustrationAsset: '$_scenes/yusuf_grain.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 47),
    ),
    KidsBookSpread(
      [
        'The king made Yusuf keeper of all the food in Egypt.',
        'The hungry years came, and there was enough.',
      ],
      illustrationAsset: '$_scenes/yusuf_grain.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 55),
    ),
    KidsBookSpread(
      [
        'Then his brothers came, hungry, from far away.',
        'They did not know him. Yusuf knew them.',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      quranRef: QuranQuoteRef(surah: 12, ayah: 58),
    ),
    KidsBookSpread(
      [
        'Yusuf forgave them.',
        'His whole family came to Egypt, and they bowed.',
        'The dream had come true.',
      ],
      illustrationAsset: '$_scenes/yusuf_bowing.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 100),
    ),
    KidsBookSpread(
      [
        'In a well, in a prison, in a palace:',
        'Allah was with Yusuf.',
        'And Allah is with you.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      isRefrain: true,
    ),
  ],
);
