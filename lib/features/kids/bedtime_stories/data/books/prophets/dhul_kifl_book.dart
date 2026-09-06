import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Dhul-Kifl Kept His Promise. A short book: Surah al-Anbiya 21:85–86 and
/// Sad 38:48; the three promises are from the classical Stories of the
/// Prophets, and the source note says so.
final BedtimeStorySeed dhulKiflBook = kidsPictureBook(
  id: 'story_prophet_dhul_kifl_bedtime_v1',
  prophetId: 'dhul_kifl',
  title: 'Dhul-Kifl Kept His Promise',
  shortTitle: 'Prophet Dhul-Kifl',
  summary:
      'A prophet the Qur’an calls patient and good, and the promise he kept '
      'every day.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [KidsIslamicStoryTheme.patience, KidsIslamicStoryTheme.honesty],
  refrain: 'He kept his promise.',
  lesson:
      'Keep your promises, even when it is hard. Allah counts those who do '
      'among the good.',
  bedtimeClosing:
      'Now close your eyes. A promise kept is a good day done. Good night.',
  quranQuote: 'And Ismail and Idris and Dhul-Kifl; all were of the patient.',
  quranReference: 'Qur’an 21:85',
  quranQuoteRef: const QuranQuoteRef(surah: 21, ayah: 85),
  sourceNote:
      'Follows al-Anbiya 21:85–86 and Sad 38:48. The three promises are '
      'from the classical Stories of the Prophets, not the Qur’an.',
  audioFileName: 'prophet_dhul_kifl_bedtime_v1.mp3',
  tags: const ['prophet', 'dhul kifl', 'promise', 'patience'],
  sortOrder: 58,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/dhul_kifl_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/dhul_kifl_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_ayyub_bedtime_v1',
    'story_prophet_idris_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Allah tells of a prophet called Dhul-Kifl, peace be upon him.',
        'His name means: the one who took it on.',
      ],
      illustrationAsset: '$_scenes/dhulkifl_scroll.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 85),
    ),
    KidsBookSpread(
      ['The Qur’an says he was patient.', 'And that he was among the good.'],
      illustrationAsset: '$_scenes/dhulkifl_scroll.webp',
      quranRef: QuranQuoteRef(surah: 38, ayah: 48),
    ),
    KidsBookSpread([
      'Long ago, people say, he promised to do three things:',
      'pray at night, fast by day, and judge without anger.',
    ], illustrationAsset: '$_scenes/dhulkifl_dawn.webp'),
    KidsBookSpread(
      ['It was hard. But he kept his promise.', 'Every day, and every night.'],
      illustrationAsset: '$_scenes/dhulkifl_dawn.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'We do not know many stories about him.',
        'But Allah named him in the Qur’an, next to Ismail and Idris.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 21, ayah: 85),
    ),
    KidsBookSpread(
      [
        'Allah says: We brought them into Our mercy. They were among the good.',
        'He kept his promise.',
      ],
      atlasScene: KidsBookAtlasScene.daySky,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 21, ayah: 86),
    ),
    KidsBookSpread([
      'When you say you will do something, do it.',
      'Even when it is hard.',
    ], atlasScene: KidsBookAtlasScene.home),
    KidsBookSpread(
      ['Be like Dhul-Kifl.', 'He kept his promise.'],
      illustrationAsset: '$_scenes/dhulkifl_scroll.webp',
      isRefrain: true,
    ),
  ],
);
