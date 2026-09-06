import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Sulayman and the Ant. Surah an-Naml 27:15–44 and Saba 34:12, on the K3
/// scenes this story already had. The seed id keeps the older spelling.
final BedtimeStorySeed sulaymanBook = kidsPictureBook(
  id: 'story_prophet_sulaiman_bedtime_v1',
  prophetId: 'sulaiman',
  title: 'Sulayman and the Ant',
  shortTitle: 'Prophet Sulayman',
  summary:
      'A king who heard an ant, a bird with big news, and a throne that flew.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.gratitude,
    KidsIslamicStoryTheme.compassionForAnimals,
  ],
  refrain: 'Thank You, Allah.',
  lesson:
      'Be grateful for what you have, use your gifts for good, and stay '
      'humble.',
  bedtimeClosing:
      'Now close your eyes. Sulayman heard the ant, and Allah hears you. '
      'Good night.',
  quranQuote:
      'So he smiled, amused at her speech, and said, "My Lord, enable me to '
      'be grateful for Your favour."',
  quranReference: 'Qur’an 27:19',
  quranQuoteRef: const QuranQuoteRef(surah: 27, ayah: 19),
  sourceNote: 'Follows an-Naml 27:15–44 and Saba 34:12.',
  audioFileName: 'prophet_sulaiman_bedtime_v1.mp3',
  tags: const ['prophet', 'sulaiman', 'animals', 'ant', 'hoopoe', 'gratitude'],
  sortOrder: 100,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/sulaiman_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/sulaiman_backdrop.webp',
  relatedStoryIds: const ['story_prophet_dawud_bedtime_v1'],
  spreads: const [
    KidsBookSpread(
      [
        'Sulayman, peace be upon him, was Dawud’s son and a king.',
        'Allah taught him what the birds and animals say.',
      ],
      atlasScene: KidsBookAtlasScene.cityMorning,
      quranRef: QuranQuoteRef(surah: 27, ayah: 16),
    ),
    KidsBookSpread(
      [
        'One day his great army marched through a valley.',
        'A tiny ant saw them coming.',
      ],
      illustrationAsset: '$_scenes/sulaiman_ants.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 18),
    ),
    KidsBookSpread(
      [
        '"O ants, go into your homes," she cried, "so Sulayman’s army does not crush you!"',
      ],
      illustrationAsset: '$_scenes/sulaiman_ants.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 18),
    ),
    KidsBookSpread(
      [
        'Sulayman heard her, and he smiled.',
        'He prayed: "My Lord, help me be thankful." Thank You, Allah.',
      ],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 27, ayah: 19),
    ),
    KidsBookSpread(
      [
        'The wind carried Sulayman wherever he wished.',
        'A morning’s journey was a month’s, an evening’s the same.',
      ],
      illustrationAsset: '$_scenes/sulaiman_wind.webp',
      quranRef: QuranQuoteRef(surah: 34, ayah: 12),
    ),
    KidsBookSpread(
      [
        'One day a small bird was missing: the hoopoe.',
        'Then it came back with big news.',
      ],
      illustrationAsset: '$_scenes/sulaiman_hoopoe.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 22),
    ),
    KidsBookSpread(
      [
        '"I found a land ruled by a queen," said the hoopoe.',
        '"Her people worship the sun instead of Allah."',
      ],
      illustrationAsset: '$_scenes/sulaiman_sun_kingdom.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 24),
    ),
    KidsBookSpread(
      [
        'Sulayman sent the queen a letter: come to Allah.',
        'The queen came, wise and careful.',
      ],
      illustrationAsset: '$_scenes/sulaiman_sun_kingdom.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 31),
    ),
    KidsBookSpread(
      [
        'Before she arrived, her throne stood before Sulayman.',
        'By Allah’s permission, in the blink of an eye.',
      ],
      illustrationAsset: '$_scenes/sulaiman_throne.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 40),
    ),
    KidsBookSpread(
      [
        '"This is from my Lord," said Sulayman, "to test whether I am thankful."',
        'Thank You, Allah.',
      ],
      illustrationAsset: '$_scenes/sulaiman_throne.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 27, ayah: 40),
    ),
    KidsBookSpread(
      [
        'The queen saw the truth and believed in Allah with Sulayman.',
        'The whole kingdom did.',
      ],
      atlasScene: KidsBookAtlasScene.cityNight,
      quranRef: QuranQuoteRef(surah: 27, ayah: 44),
    ),
    KidsBookSpread([
      'With all that power, Sulayman stayed humble.',
      'Every night he remembered Who gave it.',
    ], illustrationAsset: '$_scenes/sulaiman_thankful_night.webp'),
    KidsBookSpread(
      [
        'When Allah gives you something good, do what Sulayman did.',
        'Thank You, Allah.',
      ],
      illustrationAsset: '$_scenes/sulaiman_thankful_night.webp',
      isRefrain: true,
    ),
  ],
);
