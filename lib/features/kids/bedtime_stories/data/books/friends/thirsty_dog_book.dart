import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Man and the Thirsty Dog. Bukhari 2363 (also Muslim 2244) and
/// Bukhari 2466 (a reward for every living creature).
final BedtimeStorySeed thirstyDogBook = kidsPictureBook(
  id: 'story_companion_thirsty_dog_v1',
  storyFamilyId: 'companion_thirsty_dog',
  title: 'The Man and the Thirsty Dog',
  shortTitle: 'The Thirsty Dog',
  summary:
      'A hot road, a deep well, a panting dog, and a shoe full of water '
      'carried up in a man’s teeth.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [
    KidsIslamicStoryTheme.compassionForAnimals,
    KidsIslamicStoryTheme.kindness,
  ],
  refrain: 'Allah saw his kindness.',
  lesson: 'Kindness to any living creature is seen by Allah and rewarded.',
  bedtimeClosing:
      'Now close your eyes. Every kind thing you did today, Allah saw. '
      'Good night.',
  hadithQuote:
      'He filled his shoe with water, held it in his mouth, climbed up and '
      'gave the dog to drink. Allah thanked him and forgave him.',
  hadithReference: 'Sahih al-Bukhari 2363',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'A story the Prophet ﷺ told: Sahih al-Bukhari 2363 (also Sahih '
      'Muslim 2244) and 2466.',
  tags: const ['hadith story', 'dog', 'kindness', 'animals', 'water'],
  sortOrder: 251,
  isFeatured: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/companion_thirsty_dog_cover.webp',
  relatedStoryIds: const [
    'story_kindness_to_animals_v1',
    'story_companion_three_in_cave_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Der Mann und der durstige Hund',
    shortTitle: 'Der durstige Hund',
    summary:
        'Eine heiße Straße, ein tiefer Brunnen, ein hechelnder Hund und ein Schuh voll Wasser, in den Zähnen hinaufgetragen.',
    lesson: 'Güte zu jedem Lebewesen wird von Allah gesehen und belohnt.',
    refrain: 'Allah sah seine Güte.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Jede gute Tat von heute hat Allah gesehen. Gute Nacht.',
    spreads: [
      [
        'Der Prophet ﷺ erzählte diese Geschichte.',
        'Ein Mann ging auf einer heißen Straße, und er war sehr durstig.',
      ],
      ['Er fand einen Brunnen. Er stieg hinab, trank und stieg wieder hinauf.'],
      [
        'Am Brunnen saß ein Hund und hechelte.',
        'Seine Zunge hing heraus. Er leckte den nassen Schlamm.',
      ],
      ['„Dieser Hund ist so durstig, wie ich es war“, dachte der Mann.'],
      [
        'Er stieg noch einmal hinab. Er füllte seinen Schuh mit Wasser.',
        'Er hielt ihn mit den Zähnen und kletterte hinauf.',
      ],
      [
        'Er gab dem Hund das Wasser, und der Hund trank.',
        'Allah sah seine Güte.',
      ],
      [
        'Allah dankte dem Mann und vergab ihm alle seine Sünden.',
        'Allah sah seine Güte.',
      ],
      [
        'Die Freunde fragten: „Bekommen wir auch für Tiere einen Lohn?“',
        '„Für jedes Lebewesen gibt es einen Lohn.“',
      ],
      [
        'Ein Napf Wasser für eine Katze. Körner für die Vögel.',
        'Allah sah seine Güte. Er sieht deine.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'The Prophet ﷺ told this story.',
      'A man was walking on a hot road, and he was very thirsty.',
    ], atlasScene: KidsBookAtlasScene.desertRoad),
    KidsBookSpread([
      'He found a well. He climbed down, drank, and climbed out.',
    ], illustrationAsset: '$_scenes/dog_desert_well.webp'),
    KidsBookSpread([
      'By the well sat a dog, panting.',
      'Its tongue hung out. It was licking the wet mud.',
    ], illustrationAsset: '$_scenes/dog_desert_well.webp'),
    KidsBookSpread([
      '"This dog is as thirsty as I was," the man thought.',
    ], illustrationAsset: '$_scenes/dog_desert_well.webp'),
    KidsBookSpread([
      'He climbed down again. He filled his shoe with water.',
      'He held it in his teeth and climbed up.',
    ], illustrationAsset: '$_scenes/dog_shoe_water.webp'),
    KidsBookSpread(
      [
        'He gave the water to the dog, and the dog drank.',
        'Allah saw his kindness.',
      ],
      illustrationAsset: '$_scenes/dog_drinking.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Allah thanked the man, and forgave him all his sins.',
        'Allah saw his kindness.',
      ],
      illustrationAsset: '$_scenes/steps_allah_sky.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'The friends asked: "Do we get a reward for animals too?"',
      '"For every living creature, there is a reward."',
    ], illustrationAsset: '$_scenes/muhammad_mercy_doves.webp'),
    KidsBookSpread(
      [
        'A bowl of water for a cat. Seeds for the birds.',
        'Allah saw his kindness. He sees yours.',
      ],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
    ),
  ],
);
