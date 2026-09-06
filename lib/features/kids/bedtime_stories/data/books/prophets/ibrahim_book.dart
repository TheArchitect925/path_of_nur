import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Ibrahim and the Cool Fire. Surah al-An'am 6:74–79 and al-Anbiya
/// 21:51–70, on the K3 scenes this story already had.
final BedtimeStorySeed ibrahimBook = kidsPictureBook(
  id: 'story_prophet_ibrahim_bedtime_v1',
  prophetId: 'ibrahim',
  title: 'Ibrahim and the Cool Fire',
  shortTitle: 'Prophet Ibrahim',
  summary:
      'A boy who asked who made the stars, and a fire that Allah made cool.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.truthfulness,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  refrain: 'Allah made them all.',
  lesson:
      'Always stand for the truth. Allah protects those who believe in Him.',
  bedtimeClosing:
      'Now close your eyes. The fire was cool for Ibrahim, and Allah keeps '
      'you safe. Good night.',
  quranQuote: 'We said, "O fire, be coolness and safety upon Ibrahim."',
  quranReference: 'Qur’an 21:69',
  quranQuoteRef: const QuranQuoteRef(surah: 21, ayah: 69),
  sourceNote: 'Follows al-An’am 6:74–79 and al-Anbiya 21:51–70.',
  audioFileName: 'prophet_ibrahim_bedtime_v1.mp3',
  tags: const ['prophet', 'ibrahim', 'truth', 'fire', 'idols', 'courage'],
  sortOrder: 30,
  isFeatured: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/ibrahim_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/ibrahim_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_ismail_bedtime_v1',
    'story_prophet_adam_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Prophet Ibrahim, peace be upon him, grew up in a city of statues.',
        'People bowed to stone they carved themselves.',
      ],
      illustrationAsset: '$_scenes/ibrahim_idols.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 52),
    ),
    KidsBookSpread([
      'Ibrahim looked at the sky and wondered.',
      'Who made all of this?',
    ], atlasScene: KidsBookAtlasScene.nightSky),
    KidsBookSpread(
      [
        'At night he saw a bright star.',
        '"Is this my Lord?" But the star went away.',
      ],
      illustrationAsset: '$_scenes/ibrahim_star.webp',
      quranRef: QuranQuoteRef(surah: 6, ayah: 76),
    ),
    KidsBookSpread(
      [
        'Then the moon rose, big and beautiful.',
        '"Is this my Lord?" But the moon went away too.',
      ],
      illustrationAsset: '$_scenes/ibrahim_moon.webp',
      quranRef: QuranQuoteRef(surah: 6, ayah: 77),
    ),
    KidsBookSpread(
      [
        'In the morning the sun came up, shining.',
        '"This must be my Lord!" But the sun set.',
      ],
      illustrationAsset: '$_scenes/ibrahim_sunrise.webp',
      quranRef: QuranQuoteRef(surah: 6, ayah: 78),
    ),
    KidsBookSpread(
      [
        '"I will not worship things that go away," said Ibrahim.',
        '"Allah made them all."',
      ],
      illustrationAsset: '$_scenes/ibrahim_sunrise.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 6, ayah: 79),
    ),
    KidsBookSpread(
      [
        'Ibrahim told his people: statues cannot hear or help you.',
        'Allah made them all.',
      ],
      illustrationAsset: '$_scenes/ibrahim_idols.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 21, ayah: 66),
    ),
    KidsBookSpread(
      [
        'One day he broke the statues, all but the biggest.',
        '"Ask the big one what happened!"',
      ],
      illustrationAsset: '$_scenes/ibrahim_broken_idols.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 63),
    ),
    KidsBookSpread(
      [
        'The people were angry.',
        'They built a huge fire and threw Ibrahim in.',
      ],
      illustrationAsset: '$_scenes/ibrahim_cool_fire.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 68),
    ),
    KidsBookSpread(
      [
        'Allah said: "O fire, be cool and safe for Ibrahim."',
        'And the fire did not burn him.',
      ],
      illustrationAsset: '$_scenes/ibrahim_cool_fire.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 69),
    ),
    KidsBookSpread(
      [
        'Ibrahim walked out of the fire, safe.',
        'The people had seen the truth with their own eyes.',
      ],
      illustrationAsset: '$_scenes/ibrahim_cool_fire.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 70),
    ),
    KidsBookSpread(
      ['Ibrahim became the friend of Allah.', 'Allah made them all.'],
      atlasScene: KidsBookAtlasScene.daySky,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 4, ayah: 125),
    ),
  ],
);
