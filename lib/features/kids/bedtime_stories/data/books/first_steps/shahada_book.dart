import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Words We Say. Surah Muhammad 47:19 and al-Fath 48:29; the shahada
/// as the first pillar is in Sahih al-Bukhari 8. Ends in the Duʿās door.
final BedtimeStorySeed shahadaBook = kidsPictureBook(
  id: 'book_first_steps_shahada_v1',
  storyFamilyId: 'first_steps_shahada',
  title: 'The Words We Say',
  shortTitle: 'The Words We Say',
  summary:
      'Zayn learns the two sentences every Muslim says, and what each one '
      'means.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'La ilaha illallah.',
  lesson:
      'There is no god but Allah, and Muhammad is His Messenger. Say it, '
      'know it, and live it.',
  bedtimeClosing:
      'Now close your eyes and say the words once more. Good night.',
  quranQuote: 'So know that there is no god but Allah.',
  quranReference: 'Qur’an 47:19',
  quranQuoteRef: const QuranQuoteRef(surah: 47, ayah: 19),
  sourceNote:
      'Follows Muhammad 47:19 and al-Fath 48:29; the shahada as the first '
      'pillar is in Sahih al-Bukhari 8.',
  tags: const ['first steps', 'shahada', 'islam'],
  sortOrder: 301,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/shahada_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_who_is_allah_v1',
    'book_first_steps_five_pillars_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'Every Muslim knows two special sentences.',
      'Safa knows them. Zayn is learning.',
    ], illustrationAsset: '$_scenes/steps_words_kids.webp'),
    KidsBookSpread(
      ['The first: La ilaha illallah.', 'There is no god but Allah.'],
      illustrationAsset: '$_scenes/steps_words_arch.webp',
      isRefrain: true,
      arabicLine: 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ',
      quranRef: QuranQuoteRef(surah: 47, ayah: 19),
    ),
    KidsBookSpread([
      'It means: only Allah made us, only Allah do we worship.',
      'Not the sun, not a statue, not anyone.',
    ], illustrationAsset: '$_scenes/steps_words_arch.webp'),
    KidsBookSpread(
      [
        'The second: Muhammadur rasulullah.',
        'Muhammad is the Messenger of Allah.',
      ],
      illustrationAsset: '$_scenes/steps_words_lantern_heart.webp',
      arabicLine: 'مُحَمَّدٌ رَسُولُ ٱللَّٰهِ',
      quranRef: QuranQuoteRef(surah: 48, ayah: 29),
    ),
    KidsBookSpread([
      'Allah sent him to show us the way, and we follow him.',
      'Peace and blessings be upon him.',
    ], illustrationAsset: '$_scenes/steps_words_lantern_heart.webp'),
    KidsBookSpread([
      'Together, the two sentences are called the shahada.',
      'Say them, and you are a Muslim.',
    ], illustrationAsset: '$_scenes/steps_words_kids.webp'),
    KidsBookSpread(
      [
        'Zayn said it slowly. Then faster. Then with a big smile.',
        'La ilaha illallah.',
      ],
      illustrationAsset: '$_scenes/steps_words_kids.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'We say it when we wake up and when we go to sleep.',
      'We say it with our hearts.',
    ], atlasScene: KidsBookAtlasScene.homeEvening),
    KidsBookSpread(
      [
        'Say it with me, softly: La ilaha illallah, Muhammadur rasulullah.',
        'Now let\'s learn a duʿā to go with it.',
      ],
      illustrationAsset: '$_scenes/steps_words_arch.webp',
      isRefrain: true,
      tryItRoute: '/learn/kids/dua',
    ),
  ],
);
