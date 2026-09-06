import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Man with Two Gardens. Surah al-Kahf 18:32–44.
final BedtimeStorySeed twoGardensBook = kidsPictureBook(
  id: 'book_quran_two_gardens_v1',
  storyFamilyId: 'quran_two_gardens',
  title: 'The Man with Two Gardens',
  shortTitle: 'Two Gardens',
  summary:
      'Two beautiful gardens, a man who boasted, and the words he forgot to '
      'say.',
  category: BedtimeStoryCategory.quranStories,
  collectionType: KidsIslamicStoryCollectionType.quranStories,
  storyType: KidsIslamicStoryType.quranStory,
  themes: const [KidsIslamicStoryTheme.gratitude],
  refrain: 'as Allah wills.',
  lesson:
      'Everything good comes from Allah. Say ma sha Allah, and never be '
      'proud.',
  bedtimeClosing:
      'Now close your eyes. Everything good is from Allah, as Allah wills. '
      'Good night.',
  quranQuote:
      'Why did you not say, when you entered your garden, "What Allah '
      'willed; there is no power except in Allah"?',
  quranReference: 'Qur’an 18:39',
  quranQuoteRef: const QuranQuoteRef(surah: 18, ayah: 39),
  sourceNote: 'Follows al-Kahf 18:32–44.',
  tags: const ['quran story', 'gardens', 'gratitude', 'pride', 'ma sha allah'],
  sortOrder: 404,
  coverAssetPath: 'assets/images/kids_books/covers/two_gardens_cover.webp',
  relatedStoryIds: const ['book_quran_qarun_v1', 'book_quran_sleepers_v1'],
  spreads: const [
    KidsBookSpread(
      [
        'A man had two gardens, full of grapes and dates, with a river between.',
        'Everything grew, and nothing failed.',
      ],
      illustrationAsset: '$_scenes/gardens_rich.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 32),
    ),
    KidsBookSpread(
      [
        'He walked through them with his friend, and he boasted.',
        '"I have more than you! I am greater than you!"',
      ],
      illustrationAsset: '$_scenes/gardens_rich.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 34),
    ),
    KidsBookSpread(
      [
        '"This will never end," he said.',
        '"And if there is a Last Day, I will get even more."',
      ],
      illustrationAsset: '$_scenes/gardens_boast.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 36),
    ),
    KidsBookSpread(
      [
        'His friend said: "Do you forget who made you from dust?"',
        '"As for me, Allah is my Lord."',
      ],
      illustrationAsset: '$_scenes/gardens_boast.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 37),
    ),
    KidsBookSpread(
      [
        '"When you enter your garden, say: as Allah wills.',
        'There is no power except with Allah."',
      ],
      illustrationAsset: '$_scenes/gardens_rich.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 18, ayah: 39),
    ),
    KidsBookSpread(
      ['The man laughed. He did not say it.', 'That night, a storm came.'],
      illustrationAsset: '$_scenes/gardens_ruined.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 42),
    ),
    KidsBookSpread(
      [
        'In the morning, the vines lay on the ground.',
        'The fruit was gone. The river was dry.',
      ],
      illustrationAsset: '$_scenes/gardens_ruined.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 42),
    ),
    KidsBookSpread(
      [
        'The man wrung his hands. "I wish I had not made anything equal to Allah."',
        'But it was too late.',
      ],
      illustrationAsset: '$_scenes/gardens_regret.webp',
      quranRef: QuranQuoteRef(surah: 18, ayah: 42),
    ),
    KidsBookSpread(
      [
        'Everything good comes from Allah. Not from us.',
        'So when something is good, say: as Allah wills.',
      ],
      illustrationAsset: '$_scenes/gardens_regret.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 18, ayah: 44),
    ),
    KidsBookSpread(
      [
        'Your toys, your home, your garden.',
        'Say it with me: as Allah wills. Ma sha Allah.',
      ],
      illustrationAsset: '$_scenes/gardens_rich.webp',
      isRefrain: true,
      arabicLine: 'مَا شَاءَ ٱللَّٰهُ',
    ),
  ],
);
