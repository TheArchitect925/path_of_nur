import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Getting Ready to Pray. Surah al-Ma'idah 5:6; the mistakes that wash away
/// are in Sahih Muslim 244. Ends in the wuḍūʾ trainer.
final BedtimeStorySeed wuduBook = kidsPictureBook(
  id: 'book_first_steps_wudu_v1',
  storyFamilyId: 'first_steps_wudu',
  title: 'Getting Ready to Pray',
  shortTitle: 'Getting Ready',
  summary:
      'Zayn rolls up his sleeves: hands, mouth, nose, face, arms, head, ears '
      'and feet, and he\'s ready to pray.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.manners],
  refrain: 'Clean and ready.',
  lesson:
      'Wash before you pray, the way the Prophet ﷺ taught. Clean outside, '
      'calm inside.',
  bedtimeClosing:
      'Now close your eyes, clean and ready for tomorrow. Good night.',
  quranQuote:
      'O you who have believed, when you rise to prayer, wash your faces '
      'and your forearms to the elbows and wipe over your heads and wash '
      'your feet to the ankles.',
  quranReference: 'Qur’an 5:6',
  quranQuoteRef: const QuranQuoteRef(surah: 5, ayah: 6),
  sourceNote:
      'Follows al-Ma’idah 5:6; the mistakes that wash away with the water '
      'are in Sahih Muslim 244.',
  tags: const ['first steps', 'wudu', 'prayer', 'clean'],
  sortOrder: 305,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/wudu_cover.webp',
  relatedStoryIds: const ['book_first_steps_five_times_a_day_v1'],
  spreads: const [
    KidsBookSpread([
      'Before we pray, we get ready.',
      'Zayn rolls up his sleeves. Water time!',
    ], illustrationAsset: '$_scenes/steps_wudu_tap.webp'),
    KidsBookSpread(
      [
        'This is called wuḍūʾ.',
        'Allah asked us to wash before we stand in front of Him.',
      ],
      illustrationAsset: '$_scenes/steps_wudu_tap.webp',
      quranRef: QuranQuoteRef(surah: 5, ayah: 6),
    ),
    KidsBookSpread([
      'Bismillah. Wash your hands, three times.',
      'Rinse your mouth. Wash your nose.',
    ], illustrationAsset: '$_scenes/steps_wudu_kid_basin.webp'),
    KidsBookSpread([
      'Wash your face, from your forehead to your chin.',
      'Zayn splashes. Safa laughs.',
    ], illustrationAsset: '$_scenes/steps_wudu_kid_basin.webp'),
    KidsBookSpread([
      'Wash your arms up to the elbows.',
      'Wipe your head with wet hands. Wipe your ears.',
    ], illustrationAsset: '$_scenes/steps_wudu_kid_basin.webp'),
    KidsBookSpread(
      ['Last of all, wash your feet, up to the ankles.', 'Clean and ready.'],
      illustrationAsset: '$_scenes/steps_wudu_feet.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'The Prophet ﷺ said: when you wash, your small mistakes wash away with the water.',
      'Even from under your fingernails.',
    ], illustrationAsset: '$_scenes/steps_wudu_feet.webp'),
    KidsBookSpread(
      ['Now Safa stands on the mat, fresh and calm.', 'Clean and ready.'],
      illustrationAsset: '$_scenes/steps_wudu_ready.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Wuḍūʾ stays until you sleep, or go to the toilet, or pass wind.',
      'Then you wash again. That\'s all.',
    ], illustrationAsset: '$_scenes/steps_wudu_ready.webp'),
    KidsBookSpread(
      ['Say Bismillah, and start with the hands.', 'Clean and ready.'],
      illustrationAsset: '$_scenes/steps_wudu_tap.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['Let\'s practise, step by step.', 'Tap on each step as you go.'],
      illustrationAsset: '$_scenes/steps_wudu_kid_basin.webp',
      tryItRoute: '/learn/salah/wudu/trainer',
    ),
  ],
);
