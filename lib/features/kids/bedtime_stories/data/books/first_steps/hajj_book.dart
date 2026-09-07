import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Big Journey. Surah Al Imran 3:97 and al-Hajj 22:26–29; coming home
/// forgiven is in Sahih al-Bukhari 1521. Ends in the qibla finder.
final BedtimeStorySeed hajjBook = kidsPictureBook(
  id: 'book_first_steps_hajj_v1',
  storyFamilyId: 'first_steps_hajj',
  title: 'The Big Journey',
  shortTitle: 'Hajj',
  summary:
      'Baba packs two white cloths for the big journey, and Safa and Zayn '
      'learn what happens at Hajj.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'Labbayk, here I am.',
  lesson:
      'Hajj is the journey to Allah\'s House, once in a life for those who '
      'can. Everyone equal, everyone saying: here I am.',
  bedtimeClosing:
      'Now close your eyes. The Kaʿbah stands in Makkah, and your heart can '
      'face it from here. Good night.',
  quranQuote:
      'And due to Allah from the people is a pilgrimage to the House, for '
      'whoever is able to find a way.',
  quranReference: 'Qur’an 3:97',
  quranQuoteRef: const QuranQuoteRef(surah: 3, ayah: 97),
  sourceNote:
      'Follows Al Imran 3:97 and al-Hajj 22:26–29; coming home forgiven '
      'like a newborn is in Sahih al-Bukhari 1521.',
  tags: const ['first steps', 'hajj', 'kaaba', 'makkah', 'qibla'],
  sortOrder: 309,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/hajj_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_five_pillars_v1',
    'story_prophet_ismail_bedtime_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Die große Reise',
    shortTitle: 'Haddsch',
    summary:
        'Baba packt zwei weiße Tücher für die große Reise, und Safa und Zayn lernen, was beim Haddsch passiert.',
    lesson:
        'Der Haddsch ist die Reise zu Allahs Haus, einmal im Leben für die, die können. Alle gleich, alle sagen: Hier bin ich.',
    refrain: 'Labbaik, hier bin ich.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Die Kaaba steht in Mekka, und dein Herz kann sich von hier aus zu ihr wenden. Gute Nacht.',
    spreads: [
      [
        'Baba packte eine kleine Tasche: zwei weiße Tücher und Sandalen.',
        '„Ich fahre nach Mekka“, sagte er. „Zum Haddsch.“',
      ],
      [
        'Der Haddsch ist die große Reise zur Kaaba, dem Haus Allahs.',
        'Jeder Muslim, der kann, geht einmal hin.',
      ],
      [
        'Alle tragen dasselbe einfache Weiß.',
        'Könige und Bauern, Seite an Seite. Alle gleich vor Allah.',
      ],
      [
        'Und alle sagen dieselben Worte: Labbaik Allahumma labbaik.',
        'Labbaik, hier bin ich.',
      ],
      [
        'Sie gehen siebenmal um die Kaaba herum.',
        'Wie ein Fluss aus Menschen, alle zu Allah gewandt.',
      ],
      [
        'Sie gehen zwischen zwei Hügeln hin und her, wie Hadschar, als sie Wasser suchte.',
        'Und trinken Zamzam, das Wasser, das Allah ihr gab.',
      ],
      [
        'Am Tag von Arafat stehen sie auf einer weiten Ebene und beten den ganzen Tag.',
        'Labbaik, hier bin ich.',
      ],
      [
        'Sie werfen kleine Steine und denken an Ibrahim.',
        'Und sie teilen Fleisch mit Menschen, die es brauchen.',
      ],
      [
        'Baba kam mit einem neuen Herzen und einer Tasche Zamzam nach Hause.',
        '„Allah hat mir alles vergeben“, sagte er.',
      ],
      [
        'Eines Tages, wenn Allah will, gehst du auch.',
        'Labbaik, hier bin ich.',
      ],
      [
        'Wo du auch bist, du kannst dich jetzt zur Kaaba wenden.',
        'Suchen wir die Richtung.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'Baba packed a small bag: two white cloths and sandals.',
      '"I am going to Makkah," he said. "For Hajj."',
    ], illustrationAsset: '$_scenes/steps_hajj_ihram.webp'),
    KidsBookSpread(
      [
        'Hajj is the big journey to the Kaʿbah, the House of Allah.',
        'Every Muslim who can goes once.',
      ],
      illustrationAsset: '$_scenes/pillars_kaaba.webp',
      quranRef: QuranQuoteRef(surah: 3, ayah: 97),
    ),
    KidsBookSpread([
      'Everyone wears the same simple white.',
      'Kings and farmers, side by side. All the same before Allah.',
    ], illustrationAsset: '$_scenes/steps_hajj_ihram.webp'),
    KidsBookSpread(
      [
        'And everyone says the same words: Labbayk Allahumma labbayk.',
        'Labbayk, here I am.',
      ],
      illustrationAsset: '$_scenes/steps_hajj_tawaf.webp',
      isRefrain: true,
      arabicLine: 'لَبَّيْكَ ٱللَّٰهُمَّ لَبَّيْكَ',
      quranRef: QuranQuoteRef(surah: 22, ayah: 27),
    ),
    KidsBookSpread(
      [
        'They walk around the Kaʿbah seven times.',
        'Like a river of people, all turning to Allah.',
      ],
      illustrationAsset: '$_scenes/steps_hajj_tawaf.webp',
      quranRef: QuranQuoteRef(surah: 22, ayah: 29),
    ),
    KidsBookSpread([
      'They walk between two hills, like Hajar did looking for water.',
      'And drink Zamzam, the water Allah gave her.',
    ], atlasScene: KidsBookAtlasScene.desertRoad),
    KidsBookSpread(
      [
        'On the day of Arafat, they stand on a wide plain and make duʿā all day.',
        'Labbayk, here I am.',
      ],
      illustrationAsset: '$_scenes/steps_hajj_arafat.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'They throw small stones, remembering Ibrahim.',
        'And they share meat with people who need it.',
      ],
      illustrationAsset: '$_scenes/steps_hajj_pebbles.webp',
      quranRef: QuranQuoteRef(surah: 22, ayah: 28),
    ),
    KidsBookSpread([
      'Baba came home with a new heart and a bag of Zamzam.',
      '"Allah forgave me everything," he said.',
    ], illustrationAsset: '$_scenes/steps_hajj_ihram.webp'),
    KidsBookSpread(
      ['One day, if Allah wills, you will go too.', 'Labbayk, here I am.'],
      illustrationAsset: '$_scenes/pillars_kaaba.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Wherever you are, you can turn to the Kaʿbah right now.',
        'Let\'s find the way.',
      ],
      illustrationAsset: '$_scenes/steps_hajj_tawaf.webp',
      tryItRoute: '/qibla-finder',
    ),
  ],
);
