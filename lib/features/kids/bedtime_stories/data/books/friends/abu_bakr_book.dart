import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Abu Bakr, the Friend in the Cave. Qur'an 9:40 and Bukhari 3653. Keeps
/// the legacy id.
final BedtimeStorySeed abuBakrBook = kidsPictureBook(
  id: 'story_companion_abu_bakr_friendship_v1',
  storyFamilyId: 'companion_abu_bakr',
  title: 'Abu Bakr, the Friend in the Cave',
  shortTitle: 'Abu Bakr',
  summary:
      'A best friend, a night escape, a cave with a spider’s web, and the '
      'words: Allah is with us.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.kindness,
  ],
  refrain: 'Allah is with us.',
  lesson: 'A true friend stays when things get scary, and trusts Allah.',
  bedtimeClosing:
      'Now close your eyes. Wherever you are, Allah is with you. Good '
      'night.',
  quranQuote: 'Do not grieve; indeed Allah is with us.',
  quranReference: 'Qur’an 9:40',
  quranQuoteRef: const QuranQuoteRef(surah: 9, ayah: 40),
  hadithQuote: 'What do you think of two, the third of whom is Allah?',
  hadithReference: 'Sahih al-Bukhari 3653',
  sourceCategory: KidsIslamicStorySourceCategory.quran,
  sourceNote:
      'Follows at-Tawbah 9:40 and Sahih al-Bukhari 3653. The spider and '
      'the dove are from the seerah.',
  tags: const ['companion', 'abu bakr', 'hijrah', 'friendship', 'seerah'],
  sortOrder: 246,
  isFeatured: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/companion_abu_bakr_cover.webp',
  relatedStoryIds: const [
    'story_prophet_muhammad_part3_bedtime_v1',
    'story_companion_bilal_patience_v1',
    'story_companion_ali_bed_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'Abu Bakr was the Prophet’s ﷺ closest friend.',
      'When he heard the message, he believed at once.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_morning.webp'),
    KidsBookSpread([
      'He spent his money to free people who were treated badly.',
      'Bilal was one of them.',
    ], illustrationAsset: '$_scenes/bilal_desert_rock.webp'),
    KidsBookSpread([
      'Then Makkah grew dangerous. The Prophet ﷺ had to leave.',
      '"Take me with you," said Abu Bakr.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_night.webp'),
    KidsBookSpread([
      'They slipped away at night to a cave on Mount Thawr.',
      'Abu Bakr went in first, to check it.',
    ], illustrationAsset: '$_scenes/muhammad_thawr_cave.webp'),
    KidsBookSpread([
      'Soon the men hunting them stood right outside.',
      'Abu Bakr whispered: "If they look down, they will see us!"',
    ], illustrationAsset: '$_scenes/friends_cave_inside.webp'),
    KidsBookSpread(
      [
        'The Prophet ﷺ said: "Do not be sad. Allah is with us."',
        'What of two, when Allah is the third?',
      ],
      illustrationAsset: '$_scenes/friends_cave_inside.webp',
      isRefrain: true,
      arabicLine: 'لَا تَحْزَنْ إِنَّ ٱللَّهَ مَعَنَا',
      quranRef: QuranQuoteRef(surah: 9, ayah: 40),
    ),
    KidsBookSpread([
      'A spider had spun a web across the door.',
      'A dove sat on her nest. The men walked away.',
    ], illustrationAsset: '$_scenes/muhammad_thawr_cave.webp'),
    KidsBookSpread(
      [
        'Three days later they set off across the desert to Madinah.',
        'Allah is with us.',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      isRefrain: true,
    ),
    KidsBookSpread([
      'Madinah welcomed them with songs.',
      'Abu Bakr had kept his friend safe, and Allah had kept them both.',
    ], illustrationAsset: '$_scenes/muhammad_madinah_welcome.webp'),
    KidsBookSpread(
      [
        'A true friend stays when things get scary.',
        'And whoever trusts Allah can say: Allah is with us.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
    ),
  ],
);
