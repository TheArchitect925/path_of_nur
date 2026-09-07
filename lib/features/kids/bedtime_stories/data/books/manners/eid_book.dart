import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// An Eid Gratitude Story. Qur'an 14:7. Keeps the legacy id.
final BedtimeStorySeed eidBook = kidsPictureBook(
  id: 'story_eid_gratitude_v1',
  storyFamilyId: 'eid_gratitude',
  title: 'Eid Morning',
  shortTitle: 'Eid Morning',
  summary:
      'New clothes, sweet smells, a boy who cannot stand still, and one '
      'breath of thanks before the fun.',
  category: BedtimeStoryCategory.ramadanEid,
  collectionType: KidsIslamicStoryCollectionType.ramadanEid,
  storyType: KidsIslamicStoryType.eid,
  themes: const [KidsIslamicStoryTheme.eid, KidsIslamicStoryTheme.gratitude],
  refrain: 'Alhamdulillah for this day.',
  lesson:
      'Eid joy becomes more beautiful when it is filled with gratitude to '
      'Allah.',
  bedtimeClosing:
      'Now close your eyes. Alhamdulillah for this day, whatever kind of day '
      'it was. Good night.',
  quranQuote: 'If you are grateful, I will surely give you more.',
  quranReference: 'Qur’an 14:7',
  quranQuoteRef: const QuranQuoteRef(surah: 14, ayah: 7),
  sourceCategory: KidsIslamicStorySourceCategory.quran,
  sourceNote: 'Follows Ibrahim 14:7, more for the grateful.',
  tags: const ['eid', 'gratitude', 'celebration', 'thankfulness'],
  sortOrder: 280,
  recommendedForTonight: true,
  coverAssetPath: 'assets/images/kids_stories/covers/eid_gratitude_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/eid_gratitude_backdrop.webp',
  audioFileName: 'eid_gratitude_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:eid_gratitude',
  relatedStoryIds: const [
    'story_ramadan_kindness_v1',
    'book_first_steps_ramadan_v1',
  ],
  quizRefs: const ['quiz_story_eid_gratitude_v1'],
  memoryRefs: const ['memory_story_eid_gratitude_v1'],
  spreads: const [
    KidsBookSpread([
      'Eid morning! The house was bright and busy.',
      'Sweet smells came from the kitchen.',
    ], illustrationAsset: '$_scenes/eid_kitchen.webp'),
    KidsBookSpread([
      'New clothes hung by the window, crisp and clean.',
      'Zayn could not stand still.',
    ], illustrationAsset: '$_scenes/eid_window_clothes.webp'),
    KidsBookSpread([
      'He ran to the window. He ran to the kitchen.',
      'Sweets! Gifts! Cousins coming!',
    ], illustrationAsset: '$_scenes/eid_kitchen.webp'),
    KidsBookSpread([
      'Grandma called softly: "Zayn. Before the fun, remember Who gave this day."',
    ], illustrationAsset: '$_scenes/eid_window_clothes.webp'),
    KidsBookSpread([
      'Zayn stood still. He looked around the room.',
      'New clothes. Warm food. His family.',
    ], illustrationAsset: '$_scenes/eid_window_clothes.webp'),
    KidsBookSpread(
      ['"Alhamdulillah for this day," he said.'],
      illustrationAsset: '$_scenes/eid_kitchen.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['Allah says: if you are thankful, I will give you more.'],
      atlasScene: KidsBookAtlasScene.home,
      quranRef: QuranQuoteRef(surah: 14, ayah: 7),
    ),
    KidsBookSpread([
      'Then Zayn ran outside with Safa: Eid Mubarak!',
      'The joy was still there, but fuller now.',
    ], illustrationAsset: '$_scenes/steps_ramadan_eid.webp'),
    KidsBookSpread(
      [
        'Gratitude is like sugar in the tea. It makes everything sweeter.',
        'Alhamdulillah for this day.',
      ],
      illustrationAsset: '$_scenes/eid_kitchen.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'On your next happy day, stop for one breath and say it:',
        'Alhamdulillah for this day.',
      ],
      illustrationAsset: '$_scenes/steps_ramadan_eid.webp',
      isRefrain: true,
    ),
  ],
);
