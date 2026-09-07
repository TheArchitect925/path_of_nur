import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Good Manners in the Masjid. Qur'an 24:36. Keeps the legacy id.
final BedtimeStorySeed masjidBook = kidsPictureBook(
  id: 'story_masjid_manners_v1',
  storyFamilyId: 'masjid_manners',
  title: 'Soft Steps in the Masjid',
  shortTitle: 'Masjid Manners',
  summary:
      'Shoes in a neat row, a walk like a cloud, and a whisper in Allah’s '
      'house.',
  category: BedtimeStoryCategory.dailyLifeDuas,
  collectionType: KidsIslamicStoryCollectionType.dailyLifeDuas,
  storyType: KidsIslamicStoryType.masjid,
  themes: const [KidsIslamicStoryTheme.masjid, KidsIslamicStoryTheme.manners],
  refrain: 'Soft steps, soft voice.',
  lesson: 'The masjid is a place of peace, respect, and remembrance.',
  bedtimeClosing:
      'Now close your eyes. Quiet, like the masjid at night. Good night.',
  quranQuote:
      'In houses which Allah has allowed to be raised, and His name '
      'remembered in them.',
  quranReference: 'Qur’an 24:36',
  quranQuoteRef: const QuranQuoteRef(surah: 24, ayah: 36),
  sourceCategory: KidsIslamicStorySourceCategory.islamicManners,
  sourceNote:
      'A manners story about calm and respect in the masjid, resting on '
      'an-Nur 24:36.',
  tags: const ['masjid', 'manners', 'respect', 'quiet'],
  sortOrder: 260,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_stories/covers/masjid_manners_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/masjid_manners_backdrop.webp',
  audioFileName: 'masjid_manners_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:masjid_manners',
  relatedStoryIds: const [
    'story_bismillah_before_eating_v1',
    'book_first_steps_the_call_v1',
  ],
  quizRefs: const ['quiz_story_masjid_manners_v1'],
  memoryRefs: const ['memory_story_masjid_manners_v1'],
  spreads: const [
    KidsBookSpread([
      'Zayn held Baba’s hand at the masjid door.',
      '"This is Allah’s house," said Baba.',
    ], illustrationAsset: '$_scenes/masjid_shoes.webp'),
    KidsBookSpread([
      'Zayn took off his shoes and set them neatly in the row.',
      'Then he stepped inside with his right foot.',
    ], illustrationAsset: '$_scenes/masjid_shoes.webp'),
    KidsBookSpread(
      ['Inside it was cool and quiet. Soft steps, soft voice.'],
      illustrationAsset: '$_scenes/masjid_inside.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Zayn did not run. He walked like a cloud.',
      'He did not shout. He whispered.',
    ], illustrationAsset: '$_scenes/masjid_inside.webp'),
    KidsBookSpread([
      'A man was reading Qur’an. Zayn sat quietly nearby.',
      'He made room for others.',
    ], illustrationAsset: '$_scenes/masjid_inside.webp'),
    KidsBookSpread(
      ['Allah loves houses where His name is remembered.'],
      atlasScene: KidsBookAtlasScene.masjid,
      quranRef: QuranQuoteRef(surah: 24, ayah: 36),
    ),
    KidsBookSpread([
      'When prayer began, Zayn stood in the line, still and straight.',
    ], illustrationAsset: '$_scenes/steps_salah_kids_standing.webp'),
    KidsBookSpread(
      ['Respect can be soft and beautiful.', 'Soft steps, soft voice.'],
      illustrationAsset: '$_scenes/masjid_inside.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Next time you enter a masjid, remember Zayn.',
        'Soft steps, soft voice.',
      ],
      illustrationAsset: '$_scenes/masjid_shoes.webp',
      isRefrain: true,
    ),
  ],
);
