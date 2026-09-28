import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Angels All Around. Surah al-Infitar 82:10–12, ar-Ra'd 13:11, at-Tahrim
/// 66:6; angels created from light is in Sahih Muslim 2996. Ends in the
/// Duʿās door, with the duʿā before sleep.
final BedtimeStorySeed angelsBook = kidsPictureBook(
  id: 'book_first_steps_angels_v1',
  storyFamilyId: 'first_steps_angels',
  title: 'Angels All Around',
  shortTitle: 'Angels',
  summary:
      'Made of light, never tired: the angels who bring, who guard, who '
      'write, and who say ameen.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'Angels all around.',
  lesson:
      'Angels are all around you, doing what Allah says. Do kind things; '
      'they are writing.',
  bedtimeClosing:
      'Now close your eyes. The angels are keeping watch tonight. Good night.',
  quranQuote: 'And indeed, over you are keepers, noble and recording.',
  quranReference: 'Qur’an 82:10–11',
  quranQuoteRef: const QuranQuoteRef(surah: 82, ayah: 10),
  hadithQuote: 'The angels were created from light.',
  hadithReference: 'Sahih Muslim 2996',
  sourceNote:
      'Follows al-Infitar 82:10–12, ar-Ra’d 13:11 and at-Tahrim 66:6; '
      'angels created from light is in Sahih Muslim 2996.',
  tags: const ['first steps', 'angels', 'jibreel', 'iman'],
  sortOrder: 311,
  bedtimeEligible: true,
  coverAssetPath: 'assets/images/kids_books/covers/angels_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_what_we_believe_v1',
    'story_prophet_muhammad_part2_bedtime_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Engel überall',
    shortTitle: 'Engel',
    summary:
        'Aus Licht gemacht, nie müde: die Engel, die bringen, die beschützen, die schreiben und die Amin sagen.',
    lesson:
        'Engel sind überall um dich, und sie tun, was Allah sagt. Tu gute Dinge; sie schreiben mit.',
    refrain: 'Engel überall.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Die Engel halten heute Nacht Wache. Gute Nacht.',
    spreads: [
      ['Du kannst sie nicht sehen, aber sie sind da.', 'Engel überall.'],
      [
        'Allah hat die Engel aus Licht gemacht.',
        'Sie werden nie müde, und sie tun immer, was Allah sagt.',
      ],
      [
        'Dschibril brachte dem Propheten ﷺ den Quran.',
        'Er ist der größte der Engel.',
      ],
      [
        'Mikail kümmert sich um den Regen und die Pflanzen.',
        'Israfil wartet mit einer Trompete auf den Letzten Tag.',
      ],
      [
        'Zwei Engel sitzen bei dir, einer auf jeder Seite.',
        'Sie schreiben die guten Dinge auf, die du tust, und die unguten.',
      ],
      [
        'Wenn du etwas Gutes tust, schreibt der Engel rechts es auf.',
        'Engel überall.',
      ],
      [
        'Engel beschützen dich, vorne und hinten, auf Allahs Befehl.',
        'Amina schläft, und sie ist nicht allein.',
      ],
      [
        'Engel kommen und hören zu, wenn Menschen den Quran lesen.',
        'Und sie sagen Amin zu deinem Bittgebet.',
      ],
      [
        'Sag Bismillah, wenn du hineingehst, sag Alhamdulillah, wenn du isst.',
        'Die Engel schreiben mit. Engel überall.',
      ],
      [
        'Lass uns das Bittgebet vor dem Schlafen lernen.',
        'Die Engel werden es hören.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      ['You cannot see them, but they are there.', 'Angels all around.'],
      illustrationAsset: '$_scenes/steps_angels_light.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Allah made the angels from light.',
        'They never get tired, and they always do what Allah says.',
      ],
      illustrationAsset: '$_scenes/steps_angels_light.webp',
      quranRef: QuranQuoteRef(surah: 66, ayah: 6),
    ),
    KidsBookSpread([
      'Jibreel brought the Qur’an to the Prophet ﷺ.',
      'He is the greatest of the angels.',
    ], illustrationAsset: '$_scenes/muhammad_cave_light.webp'),
    KidsBookSpread([
      'Mikail looks after the rain and the plants.',
      'Israfil waits with a trumpet for the Last Day.',
    ], illustrationAsset: '$_scenes/steps_angels_rain.webp'),
    KidsBookSpread(
      [
        'Two angels sit with you, one on each side.',
        'They write down the kind things you do, and the unkind.',
      ],
      illustrationAsset: '$_scenes/steps_angels_scrolls.webp',
      quranRef: QuranQuoteRef(surah: 82, ayah: 11),
    ),
    KidsBookSpread(
      [
        'When you do something kind, the angel on the right writes it down.',
        'Angels all around.',
      ],
      illustrationAsset: '$_scenes/steps_angels_scrolls.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Angels guard you, in front and behind, by Allah’s command.',
        'Amina sleeps, and she is not alone.',
      ],
      illustrationAsset: '$_scenes/steps_angels_sleep.webp',
      quranRef: QuranQuoteRef(surah: 13, ayah: 11),
    ),
    KidsBookSpread([
      'Angels come to listen when people read the Qur’an.',
      'And they say ameen to your duʿā.',
    ], illustrationAsset: '$_scenes/steps_quran_stand.webp'),
    KidsBookSpread(
      [
        'Say Bismillah when you go in, say Alhamdulillah when you eat.',
        'The angels are writing. Angels all around.',
      ],
      atlasScene: KidsBookAtlasScene.home,
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Let’s learn the duʿā to say before you sleep.',
        'The angels will hear it.',
      ],
      illustrationAsset: '$_scenes/steps_angels_sleep.webp',
      tryItRoute: '/learn/kids/dua',
    ),
  ],
);
