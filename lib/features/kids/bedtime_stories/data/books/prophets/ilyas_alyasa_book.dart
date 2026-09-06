import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Ilyas and Alyasa. A short book: Surah as-Saffat 37:123–132, Sad 38:48
/// and al-An'am 6:86. The Qur'an tells little more, and so does this book.
final BedtimeStorySeed ilyasAlyasaBook = kidsPictureBook(
  id: 'story_prophet_ilyas_alyasa_bedtime_v1',
  prophetId: 'ilyas',
  storyFamilyId: 'ilyas_alyasa',
  title: 'Ilyas and Alyasa',
  shortTitle: 'Ilyas and Alyasa',
  summary:
      'A statue called Baal, a prophet who asked who made the mountains, and '
      'the prophet who came after him.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.truthfulness,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  refrain: 'The best of creators.',
  lesson: 'Only Allah made everything. Never bow to anything He made.',
  bedtimeClosing:
      'Now close your eyes. The mountains, the rain and you were made by the '
      'best of creators. Good night.',
  quranQuote: 'Do you call upon Baal and leave the best of creators?',
  quranReference: 'Qur’an 37:125',
  quranQuoteRef: const QuranQuoteRef(surah: 37, ayah: 125),
  sourceNote:
      'Follows as-Saffat 37:123–132, Sad 38:48 and al-An’am 6:86. The '
      'Qur’an tells little more about Alyasa, and so does this book.',
  audioFileName: 'prophet_ilyas_alyasa_bedtime_v1.mp3',
  tags: const ['prophet', 'ilyas', 'alyasa', 'baal', 'creator'],
  sortOrder: 74,
  coverAssetPath:
      '$bedtimeStoryImageCoverAssetDirectory/ilyas_alyasa_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/ilyas_alyasa_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_ibrahim_bedtime_v1',
    'story_prophet_sulaiman_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Long after Musa, people forgot Allah again.',
        'They bowed to a statue they called Baal.',
      ],
      illustrationAsset: '$_scenes/ilyas_baal.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 125),
    ),
    KidsBookSpread(
      [
        'Allah sent them Prophet Ilyas, peace be upon him.',
        '"Will you not fear Allah?" he asked.',
      ],
      illustrationAsset: '$_scenes/ilyas_baal.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 124),
    ),
    KidsBookSpread(
      [
        '"Do you call on Baal and leave the best of creators?"',
        '"Allah is your Lord."',
      ],
      illustrationAsset: '$_scenes/ilyas_mountain_sky.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 37, ayah: 125),
    ),
    KidsBookSpread(
      [
        'Look at the mountains, the rain, the birds.',
        'A statue made none of them. The best of creators did.',
      ],
      illustrationAsset: '$_scenes/ilyas_mountain_sky.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Most people would not listen to Ilyas.',
        'But some did, and Allah kept them safe.',
      ],
      atlasScene: KidsBookAtlasScene.cityNight,
      quranRef: QuranQuoteRef(surah: 37, ayah: 128),
    ),
    KidsBookSpread(
      [
        'Allah says: peace be upon Ilyas.',
        'Allah remembers those who tell the truth.',
      ],
      illustrationAsset: '$_scenes/ilyas_mountain_sky.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 130),
    ),
    KidsBookSpread(
      [
        'After Ilyas came Prophet Alyasa, peace be upon him.',
        'Allah says he was one of the best of people.',
      ],
      illustrationAsset: '$_scenes/alyasa_river.webp',
      quranRef: QuranQuoteRef(surah: 38, ayah: 48),
    ),
    KidsBookSpread(
      ['Two prophets, one message.', 'Worship the best of creators.'],
      illustrationAsset: '$_scenes/alyasa_river.webp',
      isRefrain: true,
    ),
  ],
);
