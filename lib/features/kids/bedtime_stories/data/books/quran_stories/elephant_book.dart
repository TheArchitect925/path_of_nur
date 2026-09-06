import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Year of the Elephant. Surah al-Fil 105; the kneeling elephant and
/// the year of the Prophet's ﷺ birth are from the seerah.
final BedtimeStorySeed elephantBook = kidsPictureBook(
  id: 'book_quran_elephant_v1',
  storyFamilyId: 'quran_elephant',
  title: 'The Year of the Elephant',
  shortTitle: 'The Elephant',
  summary:
      'An army with elephants, a sky full of small birds, and the House that '
      'would not fall.',
  category: BedtimeStoryCategory.quranStories,
  collectionType: KidsIslamicStoryCollectionType.quranStories,
  storyType: KidsIslamicStoryType.quranStory,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'Allah protects His House.',
  lesson:
      'Nothing is stronger than Allah. He protects what is His, and He '
      'protects you.',
  bedtimeClosing:
      'Now close your eyes. The birds came, the House stood, and Allah is '
      'still watching over it. Good night.',
  quranQuote:
      'Have you not considered how your Lord dealt with the companions of '
      'the elephant?',
  quranReference: 'Qur’an 105:1',
  quranQuoteRef: const QuranQuoteRef(surah: 105, ayah: 1),
  sourceNote:
      'Follows al-Fil 105; the kneeling elephant and the year of the '
      'Prophet’s ﷺ birth are from the seerah.',
  tags: const ['quran story', 'elephant', 'kaaba', 'birds', 'makkah'],
  sortOrder: 401,
  coverAssetPath: 'assets/images/kids_books/covers/elephant_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_hajj_v1',
    'story_prophet_muhammad_part1_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'Long ago, a king called Abraha built a huge church.',
      'He wanted people to visit it instead of the Kaʿbah.',
    ], atlasScene: KidsBookAtlasScene.cityMorning),
    KidsBookSpread(
      [
        'But people kept going to Makkah, to the Kaʿbah, the House of Allah.',
        'Allah protects His House.',
      ],
      illustrationAsset: '$_scenes/pillars_kaaba.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'He gathered a great army, with elephants in front.',
        '"I will knock the Kaʿbah down," he said.',
      ],
      illustrationAsset: '$_scenes/fil_army.webp',
      quranRef: QuranQuoteRef(surah: 105, ayah: 1),
    ),
    KidsBookSpread([
      'The people of Makkah could not fight an army like that.',
      'They went up into the hills and prayed.',
    ], illustrationAsset: '$_scenes/fil_army.webp'),
    KidsBookSpread([
      'At the edge of Makkah, the biggest elephant stopped.',
      'It knelt down and would not go on.',
    ], illustrationAsset: '$_scenes/fil_army.webp'),
    KidsBookSpread(
      [
        'Then the sky filled with birds. Small birds, in flocks.',
        'Each one carried tiny stones.',
      ],
      illustrationAsset: '$_scenes/fil_birds.webp',
      quranRef: QuranQuoteRef(surah: 105, ayah: 3),
    ),
    KidsBookSpread(
      [
        'The stones fell on the army like rain.',
        'Abraha’s soldiers ran, and the Kaʿbah stood.',
      ],
      illustrationAsset: '$_scenes/fil_birds.webp',
      quranRef: QuranQuoteRef(surah: 105, ayah: 5),
    ),
    KidsBookSpread(
      [
        'Allah protects His House.',
        'That same year, in Makkah, the Prophet ﷺ was born.',
      ],
      illustrationAsset: '$_scenes/fil_kaaba_safe.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'When something seems too strong to fight, remember the birds.',
        'Allah protects His House. Allah protects you.',
      ],
      illustrationAsset: '$_scenes/fil_kaaba_safe.webp',
      isRefrain: true,
    ),
  ],
);
