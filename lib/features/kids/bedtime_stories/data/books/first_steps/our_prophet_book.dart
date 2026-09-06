import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Our Prophet ﷺ, a first meeting. Surah al-Ahzab 33:56 and al-Anbiya
/// 21:107; Anas's ten years with him are in Sahih al-Bukhari 6038. Ends in
/// the first of the four ﷺ books.
final BedtimeStorySeed ourProphetBook = kidsPictureBook(
  id: 'book_first_steps_our_prophet_v1',
  storyFamilyId: 'first_steps_our_prophet',
  title: 'Our Prophet ﷺ',
  shortTitle: 'Our Prophet ﷺ',
  summary:
      'A first meeting with the Prophet ﷺ: who he was, how he lived, and '
      'what we say when we hear his name.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.kindness],
  refrain: 'Peace be upon him.',
  lesson: 'Love the Prophet ﷺ, send blessings on him, and follow how he lived.',
  bedtimeClosing:
      'Now close your eyes and say his name once more, with love. Good '
      'night.',
  quranQuote:
      'Indeed, Allah and His angels send blessings upon the Prophet. O you '
      'who have believed, send blessings upon him and greet him with peace.',
  quranReference: 'Qur’an 33:56',
  quranQuoteRef: const QuranQuoteRef(surah: 33, ayah: 56),
  sourceNote:
      'Follows al-Ahzab 33:56 and al-Anbiya 21:107; Anas ibn Malik’s ten '
      'years with him are in Sahih al-Bukhari 6038.',
  tags: const ['first steps', 'prophet muhammad', 'salawat', 'seerah'],
  sortOrder: 312,
  bedtimeEligible: true,
  coverAssetPath: 'assets/images/kids_books/covers/our_prophet_cover.webp',
  relatedStoryIds: const [
    'story_prophet_muhammad_part1_bedtime_v1',
    'book_first_steps_shahada_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'There is one name we say with love, every single day.',
        'Muhammad. Peace be upon him.',
      ],
      illustrationAsset: '$_scenes/steps_meet_lantern.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'He was born in Makkah, a long time ago.',
        'Allah chose him to be the last prophet.',
      ],
      illustrationAsset: '$_scenes/muhammad_makkah_morning.webp',
      quranRef: QuranQuoteRef(surah: 33, ayah: 40),
    ),
    KidsBookSpread([
      'He was honest, so honest that people called him the trustworthy one.',
      'He was gentle with everyone.',
    ], illustrationAsset: '$_scenes/steps_meet_lantern.webp'),
    KidsBookSpread([
      'He loved children. He played with them, and he never hurt one.',
      'He smiled more than anyone.',
    ], atlasScene: KidsBookAtlasScene.garden),
    KidsBookSpread(
      [
        'He was kind to animals, and to people who were unkind.',
        'Allah calls him a mercy to the worlds.',
      ],
      illustrationAsset: '$_scenes/muhammad_mercy_doves.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 107),
    ),
    KidsBookSpread([
      'He taught us how to pray, how to share, how to be good.',
      'Everything in these books, he taught first.',
    ], illustrationAsset: '$_scenes/steps_meet_books.webp'),
    KidsBookSpread(
      [
        'When we hear his name, we say: sallallahu alayhi wa sallam.',
        'Peace be upon him.',
      ],
      illustrationAsset: '$_scenes/steps_meet_dua.webp',
      isRefrain: true,
      arabicLine: 'صَلَّى ٱللَّٰهُ عَلَيْهِ وَسَلَّمَ',
      quranRef: QuranQuoteRef(surah: 33, ayah: 56),
    ),
    KidsBookSpread(
      ['Allah and the angels send blessings on him.', 'So do we, every day.'],
      illustrationAsset: '$_scenes/steps_meet_dua.webp',
      quranRef: QuranQuoteRef(surah: 33, ayah: 56),
    ),
    KidsBookSpread(
      ['One day, if Allah wills, we will meet him.', 'Peace be upon him.'],
      illustrationAsset: '$_scenes/steps_meet_lantern.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'His whole story is four books long.',
        'Let\'s start at the beginning, in Makkah.',
      ],
      illustrationAsset: '$_scenes/muhammad_makkah_morning.webp',
      tryItRoute: '/learn/kids/stories/story_prophet_muhammad_part1_bedtime_v1',
    ),
  ],
);
