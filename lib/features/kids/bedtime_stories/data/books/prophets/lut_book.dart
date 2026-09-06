import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Lut and the Night Journey. Surah Hud 11:77–83, al-Ankabut 29:26–35 and
/// ash-Shu'ara 26:160–175. For the plus band; what the city did wrong is
/// left to the parents.
final BedtimeStorySeed lutBook = kidsPictureBook(
  id: 'story_prophet_lut_bedtime_v1',
  prophetId: 'lut',
  title: 'Lut and the Night Journey',
  shortTitle: 'Prophet Lut',
  summary:
      'A city that did wrong, guests who were angels, and a family that '
      'walked away in the night.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.truthfulness,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  ageGroup: BedtimeStoryAgeGroup.kidsPlus,
  refrain: 'Do not look back.',
  lesson:
      'Stay away from what is wrong, even if everyone around you does it. '
      'Allah saves those who do.',
  bedtimeClosing:
      'Now close your eyes. Lut walked into the night and Allah led him to '
      'safety. Good night.',
  quranQuote:
      'So set out with your family during a portion of the night and let '
      'not any among you look back.',
  quranReference: 'Qur’an 11:81',
  quranQuoteRef: const QuranQuoteRef(surah: 11, ayah: 81),
  sourceNote:
      'Follows Hud 11:77–83, al-Ankabut 29:26–35 and ash-Shu’ara '
      '26:160–175. What the city did wrong is left to the parents to '
      'explain.',
  audioFileName: 'prophet_lut_bedtime_v1.mp3',
  tags: const ['prophet', 'lut', 'angels', 'night', 'courage'],
  sortOrder: 35,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/lut_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/lut_backdrop.webp',
  relatedStoryIds: const ['story_prophet_ibrahim_bedtime_v1'],
  spreads: const [
    KidsBookSpread(
      [
        'Prophet Lut, peace be upon him, was Ibrahim’s nephew.',
        'Allah sent him to a city where people did wrong.',
      ],
      illustrationAsset: '$_scenes/lut_city.webp',
      quranRef: QuranQuoteRef(surah: 29, ayah: 26),
    ),
    KidsBookSpread(
      [
        'They were unkind to travellers and proud of bad things.',
        'Lut told them: stop, and fear Allah.',
      ],
      illustrationAsset: '$_scenes/lut_city.webp',
      quranRef: QuranQuoteRef(surah: 26, ayah: 161),
    ),
    KidsBookSpread(
      [
        '"If you do not like it, leave!" they said.',
        'Only Lut’s family listened to him.',
      ],
      illustrationAsset: '$_scenes/lut_city.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 56),
    ),
    KidsBookSpread(
      [
        'One evening, guests came to Lut’s house.',
        'They were angels, sent by Allah, though Lut did not know.',
      ],
      illustrationAsset: '$_scenes/lut_guests.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 77),
    ),
    KidsBookSpread(
      [
        'The people of the city came to the door, shouting.',
        'Lut was afraid for his guests.',
      ],
      illustrationAsset: '$_scenes/lut_guests.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 78),
    ),
    KidsBookSpread(
      [
        '"Do not fear," said the angels. "We are from Allah."',
        '"Leave tonight with your family. Do not look back."',
      ],
      illustrationAsset: '$_scenes/lut_guests.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 11, ayah: 81),
    ),
    KidsBookSpread(
      ['So Lut and his family walked out into the night.', 'Do not look back.'],
      illustrationAsset: '$_scenes/lut_night_road.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 15, ayah: 65),
    ),
    KidsBookSpread(
      [
        'By morning, the city was gone.',
        'Allah had turned it over, and Lut’s family was far away and safe.',
      ],
      illustrationAsset: '$_scenes/lut_morning.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 82),
    ),
    KidsBookSpread(
      [
        'Lut had told the truth even when nobody wanted it.',
        'Allah saved him.',
      ],
      illustrationAsset: '$_scenes/lut_morning.webp',
      quranRef: QuranQuoteRef(surah: 29, ayah: 33),
    ),
    KidsBookSpread(
      [
        'When you leave something bad behind, keep walking.',
        'Do not look back.',
      ],
      illustrationAsset: '$_scenes/lut_night_road.webp',
      isRefrain: true,
    ),
  ],
);
