import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// A House With Five Pillars. The first First Steps book: the hadith of
/// the five pillars (Bukhari 8, Muslim 16) told through Safa and Zayn's
/// blanket house. The children are ours; the pillars are the Prophet's ﷺ.
final BedtimeStorySeed fivePillarsBook = kidsPictureBook(
  id: 'book_first_steps_five_pillars_v1',
  storyFamilyId: 'first_steps_five_pillars',
  title: 'A House With Five Pillars',
  shortTitle: 'Five Pillars',
  summary:
      'Safa and Zayn\'s blanket house keeps falling down, until Baba shows '
      'them what holds a house, and what holds Islam, up.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  ageGroup: BedtimeStoryAgeGroup.kids,
  suitableForYoungerLearners: true,
  lesson:
      'Islam stands on five pillars: the shahada, salah, zakah, fasting '
      'Ramadan, and Hajj. Strong things hold it up.',
  bedtimeClosing:
      'Now close your eyes. Five pillars hold the house up, and Allah holds '
      'you. Good night.',
  hadithQuote:
      'Islam is built on five: testifying that there is no god but Allah and '
      'that Muhammad is the Messenger of Allah, establishing the prayer, '
      'giving zakah, Hajj to the House, and fasting Ramadan.',
  hadithReference: 'Sahih al-Bukhari 8; Sahih Muslim 16',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'The five pillars are the hadith of Ibn Umar in Bukhari and Muslim. '
      'Safa, Zayn and the blanket house are ours.',
  tags: const ['five pillars', 'islam', 'shahada', 'salah', 'first steps'],
  sortOrder: 300,
  isFeatured: true,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/five_pillars_cover.webp',
  spreads: const [
    KidsBookSpread([
      'Safa and Zayn built a house of blankets and cushions.',
      'It wobbled. It fell down.',
    ], illustrationAsset: '$_scenes/pillars_fallen.webp'),
    KidsBookSpread(
      ['"It needs pillars," said Baba.', '"Strong things hold it up."'],
      illustrationAsset: '$_scenes/pillars_cushions.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      '"Islam is like a house," said Baba.',
      '"It stands on five pillars."',
    ], illustrationAsset: '$_scenes/pillars_house.webp'),
    KidsBookSpread(
      [
        'The first pillar is the words we say.',
        'La ilaha illallah, Muhammadur rasulullah.',
      ],
      atlasScene: KidsBookAtlasScene.masjid,
      highlightPhrase: 'La ilaha illallah, Muhammadur rasulullah.',
      arabicLine: 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ مُحَمَّدٌ رَسُولُ ٱللَّٰهِ',
    ),
    KidsBookSpread([
      'The second is salah, five times a day.',
      'Safa counted on her fingers. Five.',
    ], illustrationAsset: '$_scenes/pillars_mat.webp'),
    KidsBookSpread([
      'The third is zakah: sharing what Allah gave us.',
      'Zayn put a coin in the box.',
    ], illustrationAsset: '$_scenes/pillars_coins.webp'),
    KidsBookSpread([
      'The fourth is Ramadan, the month we fast.',
      'Waiting for the date at sunset.',
    ], illustrationAsset: '$_scenes/pillars_dates.webp'),
    KidsBookSpread([
      'The fifth is Hajj, the big journey to the Kaʿbah.',
      'Once, if we can.',
    ], illustrationAsset: '$_scenes/pillars_kaaba.webp'),
    KidsBookSpread(
      [
        'Safa and Zayn built the house again. Five cushions underneath.',
        'Strong things hold it up.',
        'It stood.',
      ],
      illustrationAsset: '$_scenes/pillars_standing.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Islam stands on five pillars. Strong things hold it up.',
        'Now: when is the next prayer?',
      ],
      illustrationAsset: '$_scenes/pillars_house.webp',
      isRefrain: true,
      tryItRoute: '/worship/prayer',
    ),
  ],
);
