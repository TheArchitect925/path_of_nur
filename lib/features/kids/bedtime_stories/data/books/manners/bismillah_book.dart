import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';
const String _legacy = 'assets/images/kids_stories/scenes';

/// Bismillah Before Eating. Bukhari 5376 (also Muslim 2022). Keeps the
/// legacy id; its quiz and memory deck point at it.
final BedtimeStorySeed bismillahBook = kidsPictureBook(
  id: 'story_bismillah_before_eating_v1',
  storyFamilyId: 'bismillah_before_eating',
  title: 'Bismillah Before Eating',
  shortTitle: 'Bismillah Before Eating',
  summary:
      'Warm soup, a hungry hand that stops in the air, and the words we say '
      'first.',
  category: BedtimeStoryCategory.dailyLifeDuas,
  collectionType: KidsIslamicStoryCollectionType.dailyLifeDuas,
  storyType: KidsIslamicStoryType.duaLesson,
  themes: const [KidsIslamicStoryTheme.dua, KidsIslamicStoryTheme.manners],
  ageGroup: BedtimeStoryAgeGroup.kidsEarly,
  refrain: 'First, Bismillah.',
  lesson:
      'We begin with Allah’s name before eating and thank Him after we '
      'finish.',
  bedtimeClosing:
      'Now close your eyes. Alhamdulillah for today’s food, and for you. '
      'Good night.',
  hadithQuote:
      'O young boy, mention Allah’s name, eat with your right hand, and eat '
      'from what is near you.',
  hadithReference: 'Sahih al-Bukhari 5376',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'Follows Sahih al-Bukhari 5376 (also Sahih Muslim 2022): the name of '
      'Allah, the right hand, and what is near you.',
  tags: const ['bismillah', 'eating', 'dua', 'daily life', 'manners'],
  sortOrder: 210,
  isFeatured: true,
  bedtimeEligible: false,
  coverAssetPath:
      'assets/images/kids_stories/covers/bismillah_before_eating_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/bismillah_before_eating_backdrop.webp',
  audioFileName: 'bismillah_before_eating_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:bismillah_before_eating',
  relatedStoryIds: const [
    'story_sharing_with_others_v1',
    'book_first_steps_sharing_v1',
  ],
  quizRefs: const ['quiz_story_bismillah_before_eating_v1'],
  memoryRefs: const ['memory_story_bismillah_before_eating_v1'],
  spreads: const [
    KidsBookSpread([
      'Amina sat at the table. Warm soup! Soft bread!',
      'Her tummy growled.',
    ], illustrationAsset: '$_scenes/manners_amina_soup.webp'),
    KidsBookSpread([
      'Her little hand reached out fast.',
      'Then it stopped in the air.',
    ], illustrationAsset: '$_scenes/manners_amina_soup.webp'),
    KidsBookSpread(
      [
        '"What do we say first?" asked Mama.',
        'Amina smiled. "First, Bismillah."',
      ],
      illustrationAsset: '$_legacy/bismillah_before_eating_scene_1.webp',
      isRefrain: true,
      arabicLine: 'بِسْمِ ٱللَّٰهِ',
    ),
    KidsBookSpread(
      ['In the name of Allah. He gave us this food.', 'First, Bismillah.'],
      illustrationAsset: '$_legacy/bismillah_before_eating_scene_1.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Now Amina ate slowly, with her right hand.',
      'She took what was near her.',
    ], illustrationAsset: '$_scenes/manners_amina_soup.webp'),
    KidsBookSpread([
      'She broke her bread and gave half to Zayn.',
      '"Thank you, Amina!"',
    ], atlasScene: KidsBookAtlasScene.table),
    KidsBookSpread([
      'When the bowl was empty, she said, "Alhamdulillah."',
      'All thanks to Allah.',
    ], illustrationAsset: '$_scenes/manners_amina_thanks.webp'),
    KidsBookSpread([
      'The soup was simple. But it tasted like a blessing.',
    ], illustrationAsset: '$_scenes/manners_amina_thanks.webp'),
    KidsBookSpread(
      ['Next time you sit to eat, be like Amina.', 'First, Bismillah.'],
      atlasScene: KidsBookAtlasScene.table,
      isRefrain: true,
    ),
  ],
);
