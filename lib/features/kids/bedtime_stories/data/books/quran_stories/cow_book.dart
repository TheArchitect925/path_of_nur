import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Cow of Bani Israil. Surah al-Baqarah 2:67–73.
final BedtimeStorySeed cowBook = kidsPictureBook(
  id: 'book_quran_cow_v1',
  storyFamilyId: 'quran_cow',
  title: 'The Cow of Bani Israil',
  shortTitle: 'The Cow',
  summary:
      'A simple command, question after question, and the yellow cow they '
      'finally found.',
  category: BedtimeStoryCategory.quranStories,
  collectionType: KidsIslamicStoryCollectionType.quranStories,
  storyType: KidsIslamicStoryType.quranStory,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'Just do what Allah says.',
  lesson:
      'When Allah asks something, do it, and do not make it harder with '
      'excuses.',
  bedtimeClosing:
      'Now close your eyes. Simple things are simple when we just do them. '
      'Good night.',
  quranQuote: 'Now you have come with the truth.',
  quranReference: 'Qur’an 2:71',
  quranQuoteRef: const QuranQuoteRef(surah: 2, ayah: 71),
  sourceNote: 'Follows al-Baqarah 2:67–73.',
  tags: const ['quran story', 'cow', 'musa', 'obedience'],
  sortOrder: 406,
  coverAssetPath: 'assets/images/kids_books/covers/cow_cover.webp',
  relatedStoryIds: const [
    'story_prophet_musa_bedtime_v1',
    'story_prophet_harun_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Long ago, someone in Musa’s town was hurt, and nobody knew who did it.',
        'Everyone blamed everyone.',
      ],
      atlasScene: KidsBookAtlasScene.cityMorning,
      quranRef: QuranQuoteRef(surah: 2, ayah: 72),
    ),
    KidsBookSpread(
      [
        'Allah told Musa: "Tell them to sacrifice a cow."',
        'Any cow. It was that simple.',
      ],
      illustrationAsset: '$_scenes/cow_field.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 67),
    ),
    KidsBookSpread(
      [
        'But the people asked: "What kind of cow? How old?"',
        'Allah said: not old, not young, in between.',
      ],
      illustrationAsset: '$_scenes/cow_question.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 68),
    ),
    KidsBookSpread(
      [
        '"What colour?" they asked.',
        '"Bright yellow," Allah said, "a cow that pleases whoever sees it."',
      ],
      illustrationAsset: '$_scenes/cow_yellow.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 69),
    ),
    KidsBookSpread(
      [
        '"Which yellow cow?" they asked. Still more questions!',
        '"One that has not worked the fields, and has no marks."',
      ],
      illustrationAsset: '$_scenes/cow_yellow.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 71),
    ),
    KidsBookSpread(
      [
        'At last they found her, and they did what Allah said.',
        'All that asking had made it hard.',
      ],
      illustrationAsset: '$_scenes/cow_yellow.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 71),
    ),
    KidsBookSpread(
      [
        'Then Allah showed them the truth about the man who was hurt.',
        'Just do what Allah says.',
      ],
      atlasScene: KidsBookAtlasScene.daySky,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 2, ayah: 73),
    ),
    KidsBookSpread(
      ['The first cow would have been enough.', 'Just do what Allah says.'],
      illustrationAsset: '$_scenes/cow_field.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'When Allah asks something small of you, do it right away.',
        'Just do what Allah says.',
      ],
      illustrationAsset: '$_scenes/cow_field.webp',
      isRefrain: true,
    ),
  ],
);
