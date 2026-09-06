import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Anas, the Boy Who Helped. Bukhari 6038 (ten years, never "uff") and
/// Bukhari 6334 (the du'a for Anas).
final BedtimeStorySeed anasBook = kidsPictureBook(
  id: 'story_companion_anas_v1',
  storyFamilyId: 'companion_anas',
  title: 'Anas, the Boy Who Helped',
  shortTitle: 'Anas',
  summary:
      'A ten-year-old helper, an errand that turned into a game, and the '
      'gentlest hand on his shoulder.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [
    KidsIslamicStoryTheme.kindness,
    KidsIslamicStoryTheme.helpingOthers,
  ],
  refrain: 'He never said uff.',
  lesson:
      'Kindness teaches more than shouting. Be patient with people who are '
      'slow or get it wrong.',
  bedtimeClosing:
      'Now close your eyes. Whoever helped you today, and whoever you '
      'helped, Allah saw it. Good night.',
  hadithQuote:
      'I served the Prophet ﷺ for ten years, and he never said to me '
      '"uff".',
  hadithReference: 'Sahih al-Bukhari 6038',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'Follows Sahih al-Bukhari 6038 and 6334 (the du’a for Anas). The '
      'errand and the boys at play are in Sahih Muslim 2310.',
  tags: const ['companion', 'anas', 'kindness', 'helping', 'children'],
  sortOrder: 250,
  coverAssetPath: 'assets/images/kids_stories/covers/companion_anas_cover.webp',
  relatedStoryIds: const [
    'story_helping_parents_v1',
    'story_companion_fatimah_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'When the Prophet ﷺ came to Madinah, a mother brought her son.',
      '"This is Anas. Let him help you."',
    ], illustrationAsset: '$_scenes/anas_door_basket.webp'),
    KidsBookSpread([
      'Anas was ten years old.',
      'From that day he ran errands, carried water, and opened the door.',
    ], illustrationAsset: '$_scenes/muhammad_madinah_welcome.webp'),
    KidsBookSpread(
      [
        'Sometimes Anas got things wrong. Sometimes he was slow.',
        'He never said uff.',
      ],
      illustrationAsset: '$_scenes/anas_door_basket.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'One day Anas was sent on an errand, and saw boys playing.',
      'He stopped to play too.',
    ], illustrationAsset: '$_scenes/anas_street_play.webp'),
    KidsBookSpread([
      'A gentle hand touched his shoulder. The Prophet ﷺ was smiling.',
      '"Anas, did you go where I sent you?"',
    ], illustrationAsset: '$_scenes/anas_street_play.webp'),
    KidsBookSpread(
      [
        '"I am going now, O Messenger of Allah!"',
        'No shouting. No anger. He never said uff.',
      ],
      illustrationAsset: '$_scenes/anas_street_play.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Ten years Anas served him. "He never asked me why I did a thing,"',
      '"or why I did not."',
    ], illustrationAsset: '$_scenes/muhammad_madinah_welcome.webp'),
    KidsBookSpread([
      'The Prophet ﷺ made duʿā for Anas: a long life, many children, and Jannah.',
      'Every one came true.',
    ], illustrationAsset: '$_scenes/muhammad_mercy_doves.webp'),
    KidsBookSpread([
      'Anas grew old and told the world what he had seen.',
      'Kindness taught him more than shouting ever could.',
    ], atlasScene: KidsBookAtlasScene.cityMorning),
    KidsBookSpread(
      [
        'When someone is slow, or gets it wrong, be like him.',
        'He never said uff.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
    ),
  ],
);
