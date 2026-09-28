import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// A Ramadan Kindness Story. Qur'an 2:183. Keeps the legacy id.
final BedtimeStorySeed ramadanKindnessBook = kidsPictureBook(
  id: 'story_ramadan_kindness_v1',
  storyFamilyId: 'ramadan_kindness',
  title: 'Dates for the Neighbors',
  shortTitle: 'Ramadan Kindness',
  summary:
      'A gold sky, rumbling tummies, and a tray carried step by careful step '
      'to the neighbors’ door.',
  category: BedtimeStoryCategory.ramadanEid,
  collectionType: KidsIslamicStoryCollectionType.ramadanEid,
  storyType: KidsIslamicStoryType.ramadan,
  themes: const [KidsIslamicStoryTheme.ramadan, KidsIslamicStoryTheme.kindness],
  refrain: 'Ramadan is for giving.',
  lesson:
      'Ramadan teaches us to care for others with generosity and soft '
      'hearts.',
  bedtimeClosing:
      'Now close your eyes. Somewhere a neighbor is smiling because of a '
      'plate. Good night.',
  quranQuote:
      'O you who believe, fasting has been prescribed for you as it was '
      'prescribed for those before you, so that you may become mindful of '
      'Allah.',
  quranReference: 'Qur’an 2:183',
  quranQuoteRef: const QuranQuoteRef(surah: 2, ayah: 183),
  sourceCategory: KidsIslamicStorySourceCategory.quran,
  sourceNote: 'Follows al-Baqarah 2:183, why fasting was given.',
  tags: const ['ramadan', 'kindness', 'iftar', 'giving'],
  sortOrder: 270,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/ramadan_kindness_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/ramadan_kindness_backdrop.webp',
  audioFileName: 'ramadan_kindness_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:ramadan_kindness',
  relatedStoryIds: const [
    'story_eid_gratitude_v1',
    'book_first_steps_ramadan_v1',
  ],
  quizRefs: const ['quiz_story_ramadan_kindness_v1'],
  memoryRefs: const ['memory_story_ramadan_kindness_v1'],
  de: const KidsBookTranslation(
    title: 'Datteln für die Nachbarn',
    shortTitle: 'Ramadan-Güte',
    summary:
        'Ein goldener Himmel, knurrende Bäuche und ein Tablett, Schritt für Schritt zur Tür der Nachbarn getragen.',
    lesson:
        'Ramadan lehrt uns, mit Großzügigkeit und weichen Herzen für andere zu sorgen.',
    refrain: 'Ramadan ist zum Geben da.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Irgendwo lächelt ein Nachbar wegen eines Tellers. Gute Nacht.',
    spreads: [
      [
        'Der Himmel wurde golden. Iftar war fast da.',
        'Safa und Zayn hatten den halben Tag gefastet.',
      ],
      ['Ihre Bäuche knurrten. Aber Mama hatte eine Aufgabe für sie.'],
      [
        '„Legt drei Datteln auf jeden Teller. Gießt das Wasser ein.“',
        '„Die sind für unsere Nachbarn.“',
      ],
      ['Safa zählte Datteln. Zayn goss langsam ein, ohne zu kleckern.'],
      ['Sie trugen das Tablett zur Tür, Schritt für vorsichtigen Schritt.'],
      [
        '„Dschazakallahu khairan!“, sagten die Nachbarn.',
        'Ihre Gesichter leuchteten wie der Himmel.',
      ],
      [
        'Dann kam der Adhan, und es war Zeit zu essen.',
        'Die Datteln schmeckten an diesem Abend süßer.',
      ],
      [
        'Ramadan ist zum Geben da.',
        'Allah gab uns das Fasten, damit wir mit anderen fühlen.',
      ],
      [
        'Der Hunger lehrte sie etwas: Jeder braucht eine gütige Hand.',
        'Ramadan ist zum Geben da.',
      ],
      [
        'Trag in diesem Ramadan jemandem einen Teller hin.',
        'Ramadan ist zum Geben da.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'The sky turned gold. Iftar was almost here.',
      'Safa and Zayn had been fasting half the day.',
    ], illustrationAsset: '$_scenes/ramadan_gold_sky.webp'),
    KidsBookSpread([
      'Their tummies rumbled. But Mama had a job for them.',
    ], illustrationAsset: '$_scenes/steps_ramadan_suhoor.webp'),
    KidsBookSpread([
      '"Put three dates on each plate. Pour the water."',
      '"These are for our neighbors."',
    ], illustrationAsset: '$_scenes/steps_ramadan_suhoor.webp'),
    KidsBookSpread([
      'Safa counted dates. Zayn poured, slowly, no spills.',
    ], illustrationAsset: '$_scenes/ramadan_tray.webp'),
    KidsBookSpread([
      'They carried the tray to the door, step by careful step.',
    ], illustrationAsset: '$_scenes/ramadan_tray.webp'),
    KidsBookSpread([
      '"JazakAllahu khayran!" said the neighbors.',
      'Their faces shone like the sky.',
    ], atlasScene: KidsBookAtlasScene.homeEvening),
    KidsBookSpread([
      'Then the adhan came, and it was time to eat.',
      'The dates tasted sweeter that night.',
    ], illustrationAsset: '$_scenes/ramadan_gold_sky.webp'),
    KidsBookSpread(
      [
        'Ramadan is for giving.',
        'Allah gave us fasting so we would feel for others.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 2, ayah: 183),
    ),
    KidsBookSpread(
      [
        'Being hungry taught them something: everyone needs a kind hand.',
        'Ramadan is for giving.',
      ],
      illustrationAsset: '$_scenes/ramadan_tray.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['This Ramadan, carry a plate to someone.', 'Ramadan is for giving.'],
      atlasScene: KidsBookAtlasScene.homeEvening,
      isRefrain: true,
    ),
  ],
);
