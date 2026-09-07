import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Sharing With Others. Qur'an 59:9. Keeps the legacy id.
final BedtimeStorySeed sharingBook = kidsPictureBook(
  id: 'story_sharing_with_others_v1',
  storyFamilyId: 'sharing_with_others',
  title: 'Two Dates Under the Tree',
  shortTitle: 'Two Dates',
  summary:
      'Two dates left in the lunchbox, an empty one next to it, and what '
      'Zayn did about it.',
  category: BedtimeStoryCategory.familyKindness,
  collectionType: KidsIslamicStoryCollectionType.familyKindness,
  storyType: KidsIslamicStoryType.kindness,
  themes: const [KidsIslamicStoryTheme.sharing, KidsIslamicStoryTheme.kindness],
  refrain: 'We can share.',
  lesson: 'Sharing for the sake of Allah fills small moments with kindness.',
  bedtimeClosing:
      'Now close your eyes. Think of one thing you can share tomorrow. Good '
      'night.',
  quranQuote:
      'They give others preference over themselves, even when they are in '
      'need.',
  quranReference: 'Qur’an 59:9',
  quranQuoteRef: const QuranQuoteRef(surah: 59, ayah: 9),
  sourceCategory: KidsIslamicStorySourceCategory.quran,
  sourceNote: 'Follows al-Hashr 59:9, preferring others over yourself.',
  tags: const ['sharing', 'kindness', 'friends', 'generosity'],
  sortOrder: 220,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/sharing_with_others_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/sharing_with_others_backdrop.webp',
  audioFileName: 'sharing_with_others_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:sharing_with_others',
  relatedStoryIds: const [
    'story_helping_parents_v1',
    'story_telling_the_truth_v1',
    'book_first_steps_sharing_v1',
  ],
  quizRefs: const ['quiz_story_sharing_with_others_v1'],
  memoryRefs: const ['memory_story_sharing_with_others_v1'],
  spreads: const [
    KidsBookSpread([
      'Zayn opened his lunchbox under the tree. Two dates left.',
      'He wanted both.',
    ], illustrationAsset: '$_scenes/sharing_lunchbox.webp'),
    KidsBookSpread([
      'Then he saw Amina. Her lunchbox was empty.',
      'She had forgotten her snack.',
    ], illustrationAsset: '$_scenes/sharing_lunchbox.webp'),
    KidsBookSpread([
      'Zayn looked at the dates. He looked at Amina.',
      'Two dates. One for each?',
    ], illustrationAsset: '$_scenes/sharing_lunchbox.webp'),
    KidsBookSpread(
      ['"We can share," said Zayn, and put a date in her hand.'],
      illustrationAsset: '$_scenes/sharing_plate.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Amina smiled a big smile.',
      'The date was small. The kindness felt big.',
    ], illustrationAsset: '$_scenes/sharing_plate.webp'),
    KidsBookSpread([
      'Both said, "Alhamdulillah," and ate together under the tree.',
    ], atlasScene: KidsBookAtlasScene.garden),
    KidsBookSpread(
      ['Allah loves people who give, even when they want it themselves.'],
      illustrationAsset: '$_scenes/steps_share_give.webp',
      quranRef: QuranQuoteRef(surah: 59, ayah: 9),
    ),
    KidsBookSpread(
      [
        'Sharing does not make your food less. We can share,',
        'and our hearts grow bigger.',
      ],
      illustrationAsset: '$_scenes/sharing_plate.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['When you have two of something, remember Zayn.', 'We can share.'],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
    ),
  ],
);
