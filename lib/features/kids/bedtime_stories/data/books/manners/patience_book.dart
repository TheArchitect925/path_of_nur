import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// A Story About Patience. Qur'an 2:153. Keeps the legacy id.
final BedtimeStorySeed patienceBook = kidsPictureBook(
  id: 'story_patience_v1',
  storyFamilyId: 'patience_story',
  title: 'Amina’s Seed',
  shortTitle: 'Amina’s Seed',
  summary:
      'A seed in a cup, mornings with nothing to see, and the green shoot '
      'that came when it was ready.',
  category: BedtimeStoryCategory.characterAdab,
  collectionType: KidsIslamicStoryCollectionType.characterAdab,
  storyType: KidsIslamicStoryType.patience,
  themes: const [KidsIslamicStoryTheme.patience],
  refrain: 'Good things grow slowly.',
  lesson:
      'Patience means trusting Allah while we wait for good things to grow.',
  bedtimeClosing:
      'Now close your eyes. Something good is growing in you, even while '
      'you sleep. Good night.',
  quranQuote: 'Indeed, Allah is with the patient.',
  quranReference: 'Qur’an 2:153',
  quranQuoteRef: const QuranQuoteRef(surah: 2, ayah: 153),
  sourceCategory: KidsIslamicStorySourceCategory.quran,
  sourceNote: 'Follows al-Baqarah 2:153, Allah is with the patient.',
  tags: const ['patience', 'waiting', 'growth', 'trust'],
  sortOrder: 290,
  recommendedForTonight: true,
  coverAssetPath: 'assets/images/kids_stories/covers/patience_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/patience_backdrop.webp',
  audioFileName: 'patience_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:patience',
  relatedStoryIds: const [
    'story_saying_sorry_and_forgiving_v1',
    'story_prophet_ayyub_bedtime_v1',
  ],
  quizRefs: const ['quiz_story_patience_v1'],
  memoryRefs: const ['memory_story_patience_v1'],
  spreads: const [
    KidsBookSpread([
      'Amina planted a seed in a cup of soil.',
      'She put it on the windowsill.',
    ], illustrationAsset: '$_scenes/patience_soil_cup.webp'),
    KidsBookSpread([
      'The next morning she ran to look. A flower?',
      'Nothing yet.',
    ], illustrationAsset: '$_scenes/patience_soil_cup.webp'),
    KidsBookSpread([
      'The day after: still nothing. Amina frowned.',
      '"Maybe the seed is broken."',
    ], illustrationAsset: '$_scenes/patience_soil_cup.webp'),
    KidsBookSpread(
      [
        '"It is not broken," said Grandpa. "It is working, down in the dark."',
        '"Good things grow slowly."',
      ],
      illustrationAsset: '$_scenes/patience_night_window.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'So Amina watered the cup every day. And waited.',
      'Waiting is hard when you are four.',
    ], illustrationAsset: '$_scenes/patience_night_window.webp'),
    KidsBookSpread(
      ['Allah is with the patient ones.'],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 2, ayah: 153),
    ),
    KidsBookSpread([
      'One quiet morning, there it was: a tiny green shoot.',
    ], illustrationAsset: '$_scenes/patience_sprout.webp'),
    KidsBookSpread(
      [
        'Amina clapped, softly, so she would not scare it.',
        'Good things grow slowly.',
      ],
      illustrationAsset: '$_scenes/patience_sprout.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Something else had been growing too, inside Amina.',
      'Patience.',
    ], illustrationAsset: '$_scenes/patience_sprout.webp'),
    KidsBookSpread(
      ['When you have to wait, remember the seed.', 'Good things grow slowly.'],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
    ),
  ],
);
