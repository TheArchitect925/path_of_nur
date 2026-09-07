import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Saying Sorry and Forgiving. Qur'an 24:22. Keeps the legacy id.
final BedtimeStorySeed sorryBook = kidsPictureBook(
  id: 'story_saying_sorry_and_forgiving_v1',
  storyFamilyId: 'saying_sorry_and_forgiving',
  title: 'The Tower That Fell',
  shortTitle: 'Sorry and Forgiving',
  summary:
      'A tower of blocks, a bump, hot cheeks, and the two small sentences '
      'that built it again.',
  category: BedtimeStoryCategory.characterAdab,
  collectionType: KidsIslamicStoryCollectionType.characterAdab,
  storyType: KidsIslamicStoryType.forgiveness,
  themes: const [
    KidsIslamicStoryTheme.forgiveness,
    KidsIslamicStoryTheme.kindness,
  ],
  refrain: 'I forgive you.',
  lesson: 'Saying sorry and forgiving each other brings hearts back together.',
  bedtimeClosing:
      'Now close your eyes. If anything is still heavy, say sorry in your '
      'heart, and forgive. Good night.',
  quranQuote:
      'Let them pardon and overlook. Would you not like Allah to forgive '
      'you?',
  quranReference: 'Qur’an 24:22',
  quranQuoteRef: const QuranQuoteRef(surah: 24, ayah: 22),
  sourceCategory: KidsIslamicStorySourceCategory.islamicManners,
  sourceNote:
      'A manners story about apology and mercy, resting on an-Nur 24:22.',
  tags: const ['sorry', 'forgiveness', 'siblings', 'mercy'],
  sortOrder: 300,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/saying_sorry_and_forgiving_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/saying_sorry_and_forgiving_backdrop.webp',
  audioFileName: 'saying_sorry_and_forgiving_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:saying_sorry_and_forgiving',
  relatedStoryIds: const ['story_telling_the_truth_v1', 'story_patience_v1'],
  quizRefs: const ['quiz_story_saying_sorry_and_forgiving_v1'],
  memoryRefs: const ['memory_story_saying_sorry_and_forgiving_v1'],
  de: const KidsBookTranslation(
    title: 'Der Turm, der umfiel',
    shortTitle: 'Entschuldigen und verzeihen',
    summary:
        'Ein Turm aus Bauklötzen, ein Rums, heiße Wangen und die zwei kleinen Sätze, die ihn wieder aufbauten.',
    lesson:
        'Sich zu entschuldigen und einander zu verzeihen bringt Herzen wieder zusammen.',
    refrain: 'Ich verzeihe dir.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Wenn noch etwas schwer ist, sag im Herzen Entschuldigung, und verzeih. Gute Nacht.',
    spreads: [
      [
        'Safa baute einen Turm aus Klötzen. Hoch. Höher. Am höchsten.',
        'Zayn kam angerannt.',
      ],
      ['Rums! Der Turm fiel um, alles auf einmal.', 'Safas Gesicht fiel auch.'],
      ['Zayn wollte weglaufen. Seine Wangen wurden heiß.'],
      [
        'Aber ihm fiel etwas Besseres ein als Weglaufen.',
        '„Es tut mir leid, Safa“, sagte er.',
      ],
      ['Er hob einen Klotz auf. Dann noch einen. Und noch einen.'],
      ['Safa schaute ihm zu. Dann lächelte sie. „Ich verzeihe dir.“'],
      [
        'Allah sagt: Verzeiht und lasst los. Wollt ihr nicht, dass Allah euch verzeiht?',
      ],
      [
        'Zusammen bauten sie den Turm wieder auf, höher als vorher.',
        'Entschuldigung, und dann: Ich verzeihe dir.',
      ],
      [
        'Entschuldigung ist ein kleines Wort, das große Dinge repariert.',
        'Und genauso: Ich verzeihe dir.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'Safa built a tower of blocks. Tall. Taller. Tallest.',
      'Zayn came running.',
    ], illustrationAsset: '$_scenes/sorry_fallen_blocks.webp'),
    KidsBookSpread([
      'Bump! The tower fell, all at once.',
      'Safa’s face fell too.',
    ], illustrationAsset: '$_scenes/sorry_fallen_blocks.webp'),
    KidsBookSpread([
      'Zayn wanted to run away. His cheeks felt hot.',
    ], illustrationAsset: '$_scenes/sorry_fallen_blocks.webp'),
    KidsBookSpread([
      'But he remembered something better than running.',
      '"I am sorry, Safa," he said.',
    ], atlasScene: KidsBookAtlasScene.home),
    KidsBookSpread([
      'He picked up a block. Then another. And another.',
    ], illustrationAsset: '$_scenes/sorry_rebuilt.webp'),
    KidsBookSpread(
      ['Safa watched him. Then she smiled. "I forgive you."'],
      illustrationAsset: '$_scenes/sorry_rebuilt.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['Allah says: forgive and let go. Don’t you want Allah to forgive you?'],
      atlasScene: KidsBookAtlasScene.home,
      quranRef: QuranQuoteRef(surah: 24, ayah: 22),
    ),
    KidsBookSpread(
      [
        'Together they built the tower again, taller than before.',
        'Sorry, then: I forgive you.',
      ],
      illustrationAsset: '$_scenes/sorry_rebuilt.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Sorry is a small word that fixes big things.',
        'And so is: I forgive you.',
      ],
      illustrationAsset: '$_scenes/sorry_rebuilt.webp',
      isRefrain: true,
    ),
  ],
);
