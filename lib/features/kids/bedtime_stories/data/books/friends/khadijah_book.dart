import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Khadijah, the First to Believe. Bukhari 3 (the first revelation) and
/// Bukhari 3820 (her house in Jannah). Keeps the legacy id: the seerah
/// journey and the Friends shelf point at it.
final BedtimeStorySeed khadijahBook = kidsPictureBook(
  id: 'story_companion_khadijah_support_v1',
  storyFamilyId: 'companion_khadijah',
  title: 'Khadijah, the First to Believe',
  shortTitle: 'Khadijah',
  summary:
      'A wise woman with caravans, a trustworthy young man, and the night '
      'she wrapped him in a blanket and believed.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [
    KidsIslamicStoryTheme.truthfulness,
    KidsIslamicStoryTheme.family,
    KidsIslamicStoryTheme.kindness,
  ],
  refrain: 'She believed in him.',
  lesson:
      'When someone tells the truth, stand beside them. Khadijah believed '
      'first, and stayed.',
  bedtimeClosing:
      'Now close your eyes. Somebody believes in you, just as Khadijah '
      'believed. Good night.',
  quranQuote: 'Read in the name of your Lord who created.',
  quranReference: 'Qur’an 96:1',
  quranQuoteRef: const QuranQuoteRef(surah: 96, ayah: 1),
  hadithQuote:
      'Never! By Allah, Allah will never disgrace you. You keep good '
      'relations with your family, you carry the weak, you give to the '
      'poor, and you welcome guests.',
  hadithReference: 'Sahih al-Bukhari 3',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'Follows Sahih al-Bukhari 3 (the first revelation) and 3820 (salam '
      'from Allah and a house in Jannah). The caravan and marriage are '
      'from the seerah.',
  tags: const ['companion', 'khadijah', 'seerah', 'support', 'belief'],
  sortOrder: 245,
  isFeatured: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/companion_khadijah_cover.webp',
  relatedStoryIds: const [
    'story_prophet_muhammad_part2_bedtime_v1',
    'story_companion_abu_bakr_friendship_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'In Makkah lived a kind and wise woman called Khadijah.',
      'Her caravans carried goods far and wide.',
    ], illustrationAsset: '$_scenes/muhammad_caravan.webp'),
    KidsBookSpread([
      'She heard of a young man who never lied.',
      'People called him al-Amin, the trustworthy.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_morning.webp'),
    KidsBookSpread([
      'She asked him to take her goods to Syria.',
      'He came back honest, and kind.',
    ], illustrationAsset: '$_scenes/muhammad_caravan.webp'),
    KidsBookSpread([
      'Khadijah married him. She was his best friend.',
      'Later, Allah chose him as His Prophet ﷺ.',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread(
      [
        'One night, in a cave on the mountain, the angel Jibril came.',
        'He said: Read!',
      ],
      illustrationAsset: '$_scenes/muhammad_hira_night.webp',
      quranRef: QuranQuoteRef(surah: 96, ayah: 1),
    ),
    KidsBookSpread([
      'The Prophet ﷺ hurried home, shaking. "Wrap me up!"',
      'Khadijah wrapped him in a blanket.',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread([
      '"Never!" she said. "Allah will never let you down."',
      '"You are good to family, to guests, to the poor."',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread(
      [
        'She believed in him.',
        'Before anyone else in the world, Khadijah believed.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'When the hard years came, she stood beside him.',
        'She believed in him.',
      ],
      illustrationAsset: '$_scenes/muhammad_patience_dawn.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Jibril brought her salam from Allah,',
      'and news of a home in Jannah made of pearl.',
    ], illustrationAsset: '$_scenes/steps_jannah_door.webp'),
    KidsBookSpread(
      [
        'When someone tells the truth, be like Khadijah.',
        'She believed in him.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
    ),
  ],
);
