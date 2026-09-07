import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Kindness to Animals. Bukhari 2363. Keeps the legacy id. This is how the
/// cast's cat, Misk, came to the family.
final BedtimeStorySeed kindnessAnimalsBook = kidsPictureBook(
  id: 'story_kindness_to_animals_v1',
  storyFamilyId: 'kindness_to_animals',
  title: 'The Kitten by the Wall',
  shortTitle: 'The Kitten',
  summary:
      'A tiny voice by the garden wall, an empty bowl, and how Misk came to '
      'live with Safa.',
  category: BedtimeStoryCategory.familyKindness,
  collectionType: KidsIslamicStoryCollectionType.familyKindness,
  storyType: KidsIslamicStoryType.animals,
  themes: const [
    KidsIslamicStoryTheme.compassionForAnimals,
    KidsIslamicStoryTheme.kindness,
  ],
  refrain: 'Allah loves mercy.',
  lesson: 'Mercy toward animals is part of a soft and faithful Muslim heart.',
  bedtimeClosing:
      'Now close your eyes. Every creature is resting now, and Allah is '
      'watching over all of them. Good night.',
  hadithQuote:
      'A man gave water to a thirsty dog, and Allah thanked him and forgave '
      'him.',
  hadithReference: 'Sahih al-Bukhari 2363',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'The thirsty dog is Sahih al-Bukhari 2363 (also Sahih Muslim 2244); '
      'the reward for every living creature is Sahih al-Bukhari 2466.',
  tags: const ['animals', 'mercy', 'kindness', 'care', 'misk'],
  sortOrder: 250,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/kindness_to_animals_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/kindness_to_animals_backdrop.webp',
  audioFileName: 'kindness_to_animals_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:kindness_to_animals',
  relatedStoryIds: const [
    'story_companion_thirsty_dog_v1',
    'story_sharing_with_others_v1',
  ],
  quizRefs: const ['quiz_story_kindness_to_animals_v1'],
  memoryRefs: const ['memory_story_kindness_to_animals_v1'],
  de: const KidsBookTranslation(
    title: 'Das Kätzchen an der Mauer',
    shortTitle: 'Das Kätzchen',
    summary:
        'Eine winzige Stimme an der Gartenmauer, ein leerer Napf, und wie Misk zu Safa kam.',
    lesson:
        'Barmherzigkeit mit Tieren gehört zu einem weichen, gläubigen Herzen.',
    refrain: 'Allah liebt Barmherzigkeit.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Alle Tiere ruhen jetzt, und Allah wacht über sie alle. Gute Nacht.',
    spreads: [
      ['An der Gartenmauer hörte Safa eine winzige Stimme. Miau.'],
      [
        'Ein kleines graues Kätzchen. Sein Napf war leer.',
        'Seine Zunge war trocken.',
      ],
      [
        'Safa lief ins Haus und füllte den Napf mit Wasser.',
        'Sie stellte ihn sanft hin.',
      ],
      ['Das Kätzchen trank und trank. Sein kleiner Schwanz ging hoch.'],
      ['Oma schaute von der Tür zu. „Allah liebt Barmherzigkeit“, sagte sie.'],
      [
        'Der Prophet ﷺ erzählte von einem Mann, der einem durstigen Hund Wasser gab.',
        'Allah vergab ihm dafür.',
      ],
      [
        'Jedes Lebewesen ist Allahs Geschöpf.',
        'Gut zu ihm zu sein ist eine gute Tat.',
      ],
      [
        'Das Kätzchen blieb. Safa nannte es Misk.',
        'Allah liebt Barmherzigkeit.',
      ],
      [
        'Ein Napf Wasser. Eine sanfte Hand. Allah liebt Barmherzigkeit.',
        'Und Er liebt die Barmherzigen.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'By the garden wall, Safa heard a tiny voice. Mew.',
    ], illustrationAsset: '$_scenes/kindness_kitten_wall.webp'),
    KidsBookSpread([
      'A small grey kitten. Its bowl was empty.',
      'Its tongue was dry.',
    ], illustrationAsset: '$_scenes/kindness_kitten_wall.webp'),
    KidsBookSpread([
      'Safa ran inside and filled the bowl with water.',
      'She set it down gently.',
    ], illustrationAsset: '$_scenes/kindness_kitten_drinks.webp'),
    KidsBookSpread([
      'The kitten drank and drank. Its little tail lifted up.',
    ], illustrationAsset: '$_scenes/kindness_kitten_drinks.webp'),
    KidsBookSpread(
      ['Grandma watched from the door. "Allah loves mercy," she said.'],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
    ),
    KidsBookSpread([
      'The Prophet ﷺ told of a man who gave water to a thirsty dog.',
      'Allah forgave him for it.',
    ], illustrationAsset: '$_scenes/dog_drinking.webp'),
    KidsBookSpread([
      'Every living thing is Allah’s creature.',
      'Being kind to it is a good deed.',
    ], atlasScene: KidsBookAtlasScene.garden),
    KidsBookSpread(
      ['The kitten stayed. Safa named her Misk.', 'Allah loves mercy.'],
      illustrationAsset: '$_scenes/kindness_kitten_drinks.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'A bowl of water. A gentle hand. Allah loves mercy.',
        'And He loves the merciful.',
      ],
      illustrationAsset: '$_scenes/steps_allah_garden.webp',
      isRefrain: true,
    ),
  ],
);
