import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Bilal, the Voice of the Adhan. Bukhari 604 (the adhan) and 1149 (his
/// footsteps in Jannah); the hot sand and "Ahad" are from the seerah.
/// Keeps the legacy id.
final BedtimeStorySeed bilalBook = kidsPictureBook(
  id: 'story_companion_bilal_patience_v1',
  storyFamilyId: 'companion_bilal',
  title: 'Bilal, the Voice of the Adhan',
  shortTitle: 'Bilal',
  summary:
      'Burning sand, one word said over and over, and the voice that '
      'called a whole city to prayer.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [
    KidsIslamicStoryTheme.patience,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  refrain: 'Allah is One.',
  lesson:
      'Hold on to Allah when people are unkind. Patience for Him has a '
      'reward.',
  bedtimeClosing:
      'Now close your eyes and say it softly, like Bilal: Ahad. Allah is '
      'One. Good night.',
  hadithQuote:
      'I heard the sound of your footsteps in front of me in Paradise.',
  hadithReference: 'Sahih al-Bukhari 1149',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'Follows Sahih al-Bukhari 604 (Bilal is told to call the adhan) and '
      '1149 (his footsteps in Jannah). The burning sand, the rock and '
      '"Ahad, Ahad" are from the seerah.',
  tags: const ['companion', 'bilal', 'patience', 'adhan', 'seerah'],
  sortOrder: 247,
  coverAssetPath:
      'assets/images/kids_stories/covers/companion_bilal_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_the_call_v1',
    'story_companion_abu_bakr_friendship_v1',
    'story_prophet_muhammad_part4_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'Bilal came from Africa, and in Makkah he was a slave.',
      'His master was cruel.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_morning.webp'),
    KidsBookSpread([
      'When Bilal believed in Allah, his master was furious.',
      'He dragged him onto the burning sand.',
    ], illustrationAsset: '$_scenes/bilal_desert_rock.webp'),
    KidsBookSpread(
      [
        'He put a heavy rock on his chest. "Give up your faith!"',
        'Bilal said only: "Ahad, Ahad." Allah is One.',
      ],
      illustrationAsset: '$_scenes/bilal_desert_rock.webp',
      isRefrain: true,
      arabicLine: 'أَحَدٌ أَحَدٌ',
    ),
    KidsBookSpread([
      'Abu Bakr saw. He paid the master and set Bilal free.',
      'Now nobody owned Bilal but Allah.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_morning.webp'),
    KidsBookSpread([
      'In Madinah, the Muslims needed a call to prayer.',
      '"Bilal, you have the finest voice," said the Prophet ﷺ.',
    ], illustrationAsset: '$_scenes/steps_adhan_minaret.webp'),
    KidsBookSpread([
      'Bilal climbed high and called: Allahu Akbar! Allah is the Greatest!',
      'The whole city heard him.',
    ], illustrationAsset: '$_scenes/steps_adhan_walk.webp'),
    KidsBookSpread([
      'Every day, five times, Bilal’s voice filled the sky.',
      'Come to prayer. Come to success.',
    ], illustrationAsset: '$_scenes/steps_adhan_minaret.webp'),
    KidsBookSpread([
      'Years later, the Muslims returned to Makkah in peace.',
      'Bilal climbed onto the Kaʿbah and called the adhan there.',
    ], illustrationAsset: '$_scenes/fil_kaaba_safe.webp'),
    KidsBookSpread([
      'The Prophet ﷺ told him: "I heard your footsteps in Jannah."',
      'Bilal’s patience had a reward.',
    ], illustrationAsset: '$_scenes/steps_jannah_door.webp'),
    KidsBookSpread(
      [
        'When people are unkind because of what you believe, remember Bilal.',
        'Allah is One.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['Say it softly, like him: Ahad. Allah is One.'],
      illustrationAsset: '$_scenes/steps_allah_sky.webp',
      isRefrain: true,
    ),
  ],
);
