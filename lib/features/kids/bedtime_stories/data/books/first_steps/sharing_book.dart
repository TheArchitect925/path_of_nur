import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Sharing What Allah Gave. Surah al-Baqarah 2:261; giving does not
/// decrease wealth (Sahih Muslim 2588), every good deed is charity (Sahih
/// al-Bukhari 6021). Ends in the Five Pillars book.
final BedtimeStorySeed sharingBook = kidsPictureBook(
  id: 'book_first_steps_sharing_v1',
  storyFamilyId: 'first_steps_sharing',
  title: 'Sharing What Allah Gave',
  shortTitle: 'Sharing',
  summary:
      'Amina\'s two biscuits, the seed that grows a hundred grains, and why '
      'giving never makes you poorer.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.sharing, KidsIslamicStoryTheme.kindness],
  refrain: 'Sharing makes it grow.',
  lesson:
      'Share what Allah gave you. Zakah for grown-ups, sadaqah for '
      'everyone, and every kind thing counts.',
  bedtimeClosing:
      'Now close your eyes. Every kind thing you did today is growing. Good '
      'night.',
  quranQuote:
      'The example of those who spend their wealth in the way of Allah is '
      'like a seed which grows seven ears; in each ear is a hundred grains.',
  quranReference: 'Qur’an 2:261',
  quranQuoteRef: const QuranQuoteRef(surah: 2, ayah: 261),
  sourceNote:
      'Follows al-Baqarah 2:261; giving does not decrease wealth is in '
      'Sahih Muslim 2588, every good deed is charity in Sahih al-Bukhari '
      '6021.',
  tags: const ['first steps', 'zakah', 'sadaqah', 'sharing'],
  sortOrder: 307,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/sharing_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_five_pillars_v1',
    'story_sharing_with_others_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'Amina had two biscuits.',
      'Zayn had none. Amina thought about it.',
    ], illustrationAsset: '$_scenes/steps_share_give.webp'),
    KidsBookSpread([
      'Then she gave him one. Now they both had one.',
      'And two smiles instead of one.',
    ], illustrationAsset: '$_scenes/steps_share_give.webp'),
    KidsBookSpread([
      'Everything we have, Allah gave us.',
      'Our food, our toys, our coins. Allah asks us to share some of it.',
    ], illustrationAsset: '$_scenes/steps_share_basket.webp'),
    KidsBookSpread([
      'Grown-ups give zakah every year, for people in need.',
      'Children can give sadaqah: anything, any time.',
    ], illustrationAsset: '$_scenes/pillars_coins.webp'),
    KidsBookSpread(
      [
        'Allah says giving is like planting a seed.',
        'One seed grows seven ears, and each ear holds a hundred grains.',
      ],
      illustrationAsset: '$_scenes/steps_share_tree.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 261),
    ),
    KidsBookSpread(
      ['Sharing makes it grow.'],
      illustrationAsset: '$_scenes/steps_share_tree.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'The Prophet ﷺ said: giving never makes you poorer.',
        'Sharing makes it grow.',
      ],
      illustrationAsset: '$_scenes/steps_share_basket.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'The Prophet ﷺ said: every kind thing you do is sadaqah.',
      'A smile. A kind word. A helping hand.',
    ], illustrationAsset: '$_scenes/steps_share_give.webp'),
    KidsBookSpread(
      [
        'Amina\'s biscuit was small. Her sadaqah was big.',
        'Sharing makes it grow.',
      ],
      illustrationAsset: '$_scenes/steps_share_give.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'What can you share today?',
        'Zakah is one of the five pillars. Let\'s see the house again.',
      ],
      illustrationAsset: '$_scenes/pillars_house.webp',
      tryItRoute: '/learn/kids/stories/book_first_steps_five_pillars_v1',
    ),
  ],
);
