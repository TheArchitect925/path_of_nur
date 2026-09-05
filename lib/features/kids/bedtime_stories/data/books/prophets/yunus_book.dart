import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Yunus and the Big Fish. Surah al-Anbiya 21:87–88, as-Saffat 37:139–148,
/// Yunus 10:98. The three darknesses on spread 8 follow the classical
/// explanation of 21:87. Nothing else is imagined: the only speech is what
/// the Qur'an reports.
final BedtimeStorySeed yunusBook = kidsPictureBook(
  id: 'story_prophet_yunus_bedtime_v1',
  prophetId: 'yunus',
  title: 'Yunus and the Big Fish',
  shortTitle: 'Prophet Yunus',
  summary:
      'Yunus leaves his city too soon, is swallowed by a great fish, and '
      'calls on Allah from the dark.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [KidsIslamicStoryTheme.dua, KidsIslamicStoryTheme.forgiveness],
  lesson:
      'If you make a mistake, turn back to Allah. Allah listens and forgives '
      'sincerely.',
  bedtimeClosing:
      'Now close your eyes. Allah hears you in the sea, in the dark, and in '
      'your bed. Good night.',
  quranQuote:
      'There is no god except You; exalted are You. Indeed, I have been of '
      'the wrongdoers.',
  quranReference: 'Qur’an 21:87',
  quranQuoteRef: const QuranQuoteRef(surah: 21, ayah: 87),
  sourceNote:
      'Follows Surah al-Anbiya 21:87–88, as-Saffat 37:139–148 and Yunus '
      '10:98. The three darknesses on the eighth spread follow the classical '
      'explanation of 21:87.',
  audioFileName: 'prophet_yunus_bedtime_v1.mp3',
  tags: const ['prophet', 'yunus', 'dua', 'whale', 'forgiveness'],
  sortOrder: 70,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/yunus_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/yunus_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_yusuf_bedtime_v1',
    'story_prophet_muhammad_part3_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Allah sent Prophet Yunus, peace be upon him, to a big city.',
        '"Worship Allah alone," he told the people.',
      ],
      atlasScene: KidsBookAtlasScene.cityMorning,
      quranRef: QuranQuoteRef(surah: 37, ayah: 139),
    ),
    KidsBookSpread([
      'The people did not listen.',
      'Yunus told them again. And again.',
      'They still did not listen.',
    ], atlasScene: KidsBookAtlasScene.cityMorning),
    KidsBookSpread(
      [
        'Yunus grew tired and sad.',
        'He left the city without waiting for Allah\'s command.',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      quranRef: QuranQuoteRef(surah: 21, ayah: 87),
    ),
    KidsBookSpread(
      [
        'He climbed onto a ship.',
        'The sea was calm and the sky was blue.',
        'Then the wind began to blow.',
      ],
      illustrationAsset: '$_scenes/yunus_ship_calm.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 140),
    ),
    KidsBookSpread([
      'The waves grew tall. The ship rocked and creaked.',
      'It was too heavy.',
      'Someone had to go into the sea.',
    ], illustrationAsset: '$_scenes/yunus_storm.webp'),
    KidsBookSpread(
      [
        'The sailors drew lots.',
        'Yunus\'s name came out. They drew again. Yunus.',
        'And again. Yunus.',
      ],
      illustrationAsset: '$_scenes/yunus_storm.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 141),
    ),
    KidsBookSpread(
      [
        'Yunus went into the dark water.',
        'A great fish opened its mouth and swallowed him whole.',
      ],
      illustrationAsset: '$_scenes/yunus_fish.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 142),
    ),
    KidsBookSpread(
      [
        'Dark inside the fish.',
        'Dark inside the sea. Dark inside the night.',
        'But Allah always hears.',
      ],
      illustrationAsset: '$_scenes/yunus_dark.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Yunus called out:',
        'There is no god but You. Glory be to You.',
        'I was wrong.',
      ],
      illustrationAsset: '$_scenes/yunus_dark.webp',
      highlightPhrase: 'There is no god but You.',
      arabicLine:
          'لَا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
      quranRef: QuranQuoteRef(surah: 21, ayah: 87),
    ),
    KidsBookSpread(
      [
        'Allah heard him. Allah always hears.',
        'The fish swam to the shore and laid Yunus gently on the sand.',
      ],
      illustrationAsset: '$_scenes/yunus_shore.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 37, ayah: 145),
    ),
    KidsBookSpread(
      [
        'Yunus was weak.',
        'Allah grew a leafy plant over him,',
        'to shade him until he was strong again.',
      ],
      illustrationAsset: '$_scenes/yunus_plant.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 146),
    ),
    KidsBookSpread(
      [
        'Then Yunus went back to his city.',
        'This time the people believed.',
        'All of them.',
      ],
      atlasScene: KidsBookAtlasScene.cityNight,
      quranRef: QuranQuoteRef(surah: 37, ayah: 148),
    ),
    KidsBookSpread(
      [
        'When you are in a dark place, do what Yunus did.',
        'Call on Allah.',
        'Allah always hears.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      isRefrain: true,
    ),
  ],
);
