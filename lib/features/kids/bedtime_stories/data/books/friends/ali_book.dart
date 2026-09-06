import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Ali Sleeps in the Prophet's ﷺ Bed. The hijrah night is from the
/// seerah; the hadith is Bukhari 3706.
final BedtimeStorySeed aliBook = kidsPictureBook(
  id: 'story_companion_ali_bed_v1',
  storyFamilyId: 'companion_ali',
  title: 'Ali Sleeps in the Prophet’s ﷺ Bed',
  shortTitle: 'Ali',
  summary:
      'A green cloak, a night full of danger, and the brave boy who lay '
      'down in his cousin’s bed.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.truthfulness,
  ],
  refrain: 'Ali was not afraid.',
  lesson: 'Doing the right thing can be scary. Trust Allah and do it anyway.',
  bedtimeClosing:
      'Now close your eyes, pull up your blanket, and rest like Ali. '
      'Allah keeps you. Good night.',
  hadithQuote: 'You are to me like Harun was to Musa.',
  hadithReference: 'Sahih al-Bukhari 3706',
  sourceCategory: KidsIslamicStorySourceCategory.seerahInspired,
  sourceNote:
      'The night in the bed and the returned trusts are from the seerah '
      '(Ibn Ishaq). The hadith is Sahih al-Bukhari 3706.',
  tags: const ['companion', 'ali', 'hijrah', 'courage', 'seerah'],
  sortOrder: 248,
  coverAssetPath: 'assets/images/kids_stories/covers/companion_ali_cover.webp',
  relatedStoryIds: const [
    'story_companion_abu_bakr_friendship_v1',
    'story_prophet_muhammad_part3_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'Ali grew up in the Prophet’s ﷺ own home.',
      'He was the first boy to believe.',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread([
      'One night the Prophet ﷺ had to leave Makkah in secret.',
      'Bad men were coming to his door.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_night.webp'),
    KidsBookSpread([
      '"Ali, sleep in my bed tonight," he said, "under my green cloak."',
      '"Nobody will harm you."',
    ], illustrationAsset: '$_scenes/ali_green_cloak_bed.webp'),
    KidsBookSpread([
      'Ali lay down and pulled the cloak up.',
      'Outside, the men waited with swords.',
    ], illustrationAsset: '$_scenes/ali_green_cloak_bed.webp'),
    KidsBookSpread(
      [
        'Ali was not afraid.',
        'He trusted Allah, and he trusted his cousin’s word.',
      ],
      illustrationAsset: '$_scenes/ali_green_cloak_bed.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'In the morning the men burst in. It was Ali!',
      'The Prophet ﷺ was already far away.',
    ], illustrationAsset: '$_scenes/muhammad_thawr_cave.webp'),
    KidsBookSpread([
      'Ali stayed three more days.',
      'He gave back everything people had left with the Prophet ﷺ for safe keeping.',
    ], illustrationAsset: '$_scenes/ali_trusts_shelf.webp'),
    KidsBookSpread(
      ['Then he walked to Madinah alone, all the way.', 'Ali was not afraid.'],
      atlasScene: KidsBookAtlasScene.desertRoad,
      isRefrain: true,
    ),
    KidsBookSpread([
      'The Prophet ﷺ told him: "You are to me like Harun to Musa."',
      'Later, Ali led the Muslims.',
    ], illustrationAsset: '$_scenes/muhammad_madinah_welcome.webp'),
    KidsBookSpread(
      [
        'When a good deed is scary, think of the boy under the cloak.',
        'Ali was not afraid.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
    ),
  ],
);
