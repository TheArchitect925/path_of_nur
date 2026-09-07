import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Helping Parents. Qur'an 17:24. Keeps the legacy id.
final BedtimeStorySeed helpingBook = kidsPictureBook(
  id: 'story_helping_parents_v1',
  storyFamilyId: 'helping_parents',
  title: 'I Can Help!',
  shortTitle: 'I Can Help',
  summary:
      'Bags at the door, tired hands, and a boy who did not wait to be '
      'asked.',
  category: BedtimeStoryCategory.familyKindness,
  collectionType: KidsIslamicStoryCollectionType.familyKindness,
  storyType: KidsIslamicStoryType.family,
  themes: const [
    KidsIslamicStoryTheme.family,
    KidsIslamicStoryTheme.helpingOthers,
  ],
  refrain: 'I can help!',
  lesson:
      'Helping our parents with kindness is a beautiful act beloved to '
      'Allah.',
  bedtimeClosing:
      'Now close your eyes. Somebody carried you today, in some way. '
      'Tomorrow, carry something back. Good night.',
  quranQuote: 'And lower to them the wing of humility out of mercy.',
  quranReference: 'Qur’an 17:24',
  quranQuoteRef: const QuranQuoteRef(surah: 17, ayah: 24),
  sourceCategory: KidsIslamicStorySourceCategory.quran,
  sourceNote: 'Follows al-Isra 17:23–24, gentleness with parents.',
  tags: const ['parents', 'helping', 'family', 'kindness'],
  sortOrder: 240,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/helping_parents_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/helping_parents_backdrop.webp',
  audioFileName: 'helping_parents_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:helping_parents',
  relatedStoryIds: const [
    'story_sharing_with_others_v1',
    'book_quran_luqman_v1',
  ],
  quizRefs: const ['quiz_story_helping_parents_v1'],
  memoryRefs: const ['memory_story_helping_parents_v1'],
  spreads: const [
    KidsBookSpread([
      'Zayn heard bags rustle at the door.',
      'Baba looked tired. Mama’s arms were full of fruit.',
    ], illustrationAsset: '$_scenes/helping_door_bags.webp'),
    KidsBookSpread(
      ['Zayn ran over. "I can help!"'],
      illustrationAsset: '$_scenes/helping_door_bags.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'He carried the light bag, carefully, with both hands.',
      'Not the heavy one. The one he could.',
    ], illustrationAsset: '$_scenes/helping_door_bags.webp'),
    KidsBookSpread([
      'Then he brought Mama a glass of water.',
      'Nobody had asked him to.',
    ], illustrationAsset: '$_scenes/helping_water.webp'),
    KidsBookSpread([
      'Baba smiled. Mama smiled.',
      'Zayn felt warm inside, like sunshine.',
    ], illustrationAsset: '$_scenes/helping_water.webp'),
    KidsBookSpread(
      [
        'Allah tells us to be gentle with our parents,',
        'like a bird folding its wing over them.',
      ],
      atlasScene: KidsBookAtlasScene.home,
      quranRef: QuranQuoteRef(surah: 17, ayah: 24),
    ),
    KidsBookSpread([
      'Kindness starts at home. With the people who carry you.',
    ], atlasScene: KidsBookAtlasScene.home),
    KidsBookSpread(
      ['A bag. A glass of water. A hug. Small things count.', 'I can help!'],
      illustrationAsset: '$_scenes/helping_water.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['Tomorrow, when you see tired hands, say it: I can help!'],
      illustrationAsset: '$_scenes/helping_door_bags.webp',
      isRefrain: true,
    ),
  ],
);
