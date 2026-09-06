import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Three Men and a Rock. Bukhari 2272 (also Muslim 2743). The third man's
/// deed is told without its detail.
final BedtimeStorySeed threeInCaveBook = kidsPictureBook(
  id: 'story_companion_three_in_cave_v1',
  storyFamilyId: 'companion_three_in_cave',
  title: 'Three Men and a Rock',
  shortTitle: 'Three in a Cave',
  summary:
      'A storm, a cave, a rock across the door, and three good deeds done '
      'only for Allah.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [
    KidsIslamicStoryTheme.family,
    KidsIslamicStoryTheme.truthfulness,
    KidsIslamicStoryTheme.dua,
  ],
  refrain: 'Open the way for us.',
  lesson:
      'A good deed done only for Allah is never wasted. It can even move a '
      'rock.',
  bedtimeClosing:
      'Now close your eyes. Think of one good thing you did today, only '
      'for Allah. Good night.',
  hadithQuote:
      'Three men were shut in a cave by a rock, and each asked Allah by his '
      'best deed until the rock moved away.',
  hadithReference: 'Sahih al-Bukhari 2272',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'A story the Prophet ﷺ told: Sahih al-Bukhari 2272 (also Sahih '
      'Muslim 2743). The third man’s deed is kept general for children.',
  tags: const ['hadith story', 'cave', 'sincerity', 'parents', 'honesty'],
  sortOrder: 252,
  coverAssetPath:
      'assets/images/kids_stories/covers/companion_three_in_cave_cover.webp',
  relatedStoryIds: const [
    'story_companion_thirsty_dog_v1',
    'story_helping_parents_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'The Prophet ﷺ told this story.',
      'Three men were walking when a storm came.',
    ], atlasScene: KidsBookAtlasScene.desertRoad),
    KidsBookSpread([
      'They ran into a cave. Then a great rock rolled down',
      'and shut the door. Dark.',
    ], illustrationAsset: '$_scenes/cave_rock_sealed.webp'),
    KidsBookSpread([
      '"Nothing can move that rock," they said, "except Allah."',
      '"Let us each tell Him our best deed."',
    ], illustrationAsset: '$_scenes/cave_rock_gap.webp'),
    KidsBookSpread([
      'The first said: "My old parents drank their milk before anyone."',
      '"One night I came late. They were asleep."',
    ], illustrationAsset: '$_scenes/cave_milk_bowl.webp'),
    KidsBookSpread(
      [
        '"I stood with the bowl until dawn, and did not wake them."',
        '"Only for You. Open the way for us."',
      ],
      illustrationAsset: '$_scenes/cave_milk_bowl.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'The rock moved a little. Not enough.',
      'The second said: "A worker left without his pay."',
    ], illustrationAsset: '$_scenes/cave_rock_gap.webp'),
    KidsBookSpread([
      '"I made his pay grow into a whole herd."',
      '"When he came back, I gave him everything."',
    ], illustrationAsset: '$_scenes/cave_herd_wages.webp'),
    KidsBookSpread(
      [
        '"Only for You, O Allah. Open the way for us."',
        'The rock moved more. Still not enough.',
      ],
      illustrationAsset: '$_scenes/cave_rock_gap.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'The third had turned away from something wrong, only for Allah.',
        '"Open the way for us," he prayed.',
      ],
      illustrationAsset: '$_scenes/cave_rock_gap.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'The rock rolled away. Sunlight! The men walked out free.',
    ], illustrationAsset: '$_scenes/cave_rock_open.webp'),
    KidsBookSpread(
      [
        'A good deed done only for Allah can move a rock.',
        'Open the way for us.',
      ],
      illustrationAsset: '$_scenes/steps_allah_sky.webp',
      isRefrain: true,
    ),
  ],
);
