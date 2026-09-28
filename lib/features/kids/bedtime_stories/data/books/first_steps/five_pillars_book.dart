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
      'Safa and Zayn’s blanket house keeps falling down, until Baba shows '
      'them what holds a house, and what holds Islam, up.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  ageGroup: BedtimeStoryAgeGroup.kids,
  refrain: 'Strong things hold it up.',
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
  sortOrder: 303,
  isFeatured: true,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/five_pillars_cover.webp',
  de: const KidsBookTranslation(
    title: 'Ein Haus mit fünf Säulen',
    shortTitle: 'Fünf Säulen',
    summary:
        'Safas und Zayns Deckenhaus fällt immer wieder um, bis Baba ihnen zeigt, was ein Haus hält und was den Islam hält.',
    lesson:
        'Der Islam steht auf fünf Säulen: Schahada, Gebet, Zakat, Fasten im Ramadan und Haddsch. Starke Dinge halten ihn hoch.',
    refrain: 'Starke Dinge halten es hoch.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Fünf Säulen halten das Haus, und Allah hält dich. Gute Nacht.',
    spreads: [
      [
        'Safa und Zayn bauten ein Haus aus Decken und Kissen.',
        'Es wackelte. Es fiel um.',
      ],
      ['„Es braucht Säulen“, sagte Baba.', '„Starke Dinge halten es hoch.“'],
      [
        '„Der Islam ist wie ein Haus“, sagte Baba.',
        '„Er steht auf fünf Säulen.“',
      ],
      [
        'Die erste Säule sind die Worte, die wir sagen.',
        'La ilaha illallah, Muhammadur rasulullah.',
      ],
      [
        'Die zweite ist das Gebet, fünfmal am Tag.',
        'Safa zählte an ihren Fingern. Fünf.',
      ],
      [
        'Die dritte ist die Zakat: teilen, was Allah uns gab.',
        'Zayn steckte eine Münze in die Dose.',
      ],
      [
        'Die vierte ist der Ramadan, der Monat, in dem wir fasten.',
        'Warten auf die Dattel bei Sonnenuntergang.',
      ],
      [
        'Die fünfte ist der Haddsch, die große Reise zur Kaaba.',
        'Einmal, wenn wir können.',
      ],
      [
        'Safa und Zayn bauten das Haus noch einmal. Fünf Kissen darunter.',
        'Starke Dinge halten es hoch.',
        'Es stand.',
      ],
      [
        'Der Islam steht auf fünf Säulen. Starke Dinge halten es hoch.',
        'Und jetzt: Wann ist das nächste Gebet?',
      ],
    ],
  ),
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
