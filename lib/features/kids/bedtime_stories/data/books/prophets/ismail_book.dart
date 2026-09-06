import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Ismail and the Ram. Surah as-Saffat 37:100–107; Hajar and Zamzam from
/// Sahih al-Bukhari 3364. On the K3 scenes this story already had.
final BedtimeStorySeed ismailBook = kidsPictureBook(
  id: 'story_prophet_ismail_bedtime_v1',
  prophetId: 'ismail',
  title: 'Ismail and the Ram',
  shortTitle: 'Prophet Ismail',
  summary: 'A father’s dream, a son’s trust, and the ram Allah sent instead.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.patience,
  ],
  refrain: 'We trust Allah.',
  lesson:
      'Trust Allah, even when things feel difficult. Allah rewards those who '
      'are patient and sincere.',
  bedtimeClosing:
      'Now close your eyes. Ismail trusted Allah, and Allah took care of '
      'him. Good night.',
  quranQuote:
      'He said, "O my father, do as you are commanded. You will find me, if '
      'Allah wills, of the patient."',
  quranReference: 'Qur’an 37:102',
  quranQuoteRef: const QuranQuoteRef(surah: 37, ayah: 102),
  sourceNote:
      'Follows as-Saffat 37:100–107; Hajar and the well of Zamzam are in '
      'Sahih al-Bukhari 3364.',
  audioFileName: 'prophet_ismail_bedtime_v1.mp3',
  tags: const ['prophet', 'ismail', 'trust', 'eid', 'obedience', 'sacrifice'],
  sortOrder: 40,
  isFeatured: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/ismail_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/ismail_backdrop.webp',
  relatedStoryIds: const ['story_prophet_ibrahim_bedtime_v1'],
  spreads: const [
    KidsBookSpread([
      'Ibrahim, peace be upon him, had a son called Ismail, peace be upon him.',
      'He was kind, gentle and helpful.',
    ], illustrationAsset: '$_scenes/ismail_home.webp'),
    KidsBookSpread([
      'When Ismail was a baby, Hajar ran between two hills for water.',
      'Water sprang from the sand: Zamzam.',
    ], atlasScene: KidsBookAtlasScene.desertRoad),
    KidsBookSpread(
      [
        'Ismail grew up loving Allah, like his father.',
        'They worked and prayed side by side.',
      ],
      illustrationAsset: '$_scenes/ismail_home.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 127),
    ),
    KidsBookSpread(
      [
        'One night Ibrahim had a dream.',
        'It was not an ordinary dream. It was a message from Allah.',
      ],
      illustrationAsset: '$_scenes/ismail_dream.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 102),
    ),
    KidsBookSpread(
      [
        '"My son, I saw in a dream that I must give you up for Allah."',
        'Ibrahim’s heart was heavy.',
      ],
      illustrationAsset: '$_scenes/ismail_dream.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 102),
    ),
    KidsBookSpread(
      [
        'Ismail said: "Father, do what Allah asks."',
        '"If Allah wills, I will be patient."',
        'We trust Allah.',
      ],
      illustrationAsset: '$_scenes/ismail_walk.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 37, ayah: 102),
    ),
    KidsBookSpread(
      [
        'They walked together, step by step.',
        'Both of them ready. Both of them trusting.',
      ],
      illustrationAsset: '$_scenes/ismail_walk.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 103),
    ),
    KidsBookSpread(
      [
        'Then Allah called out: "O Ibrahim! You have already done it."',
        'It was a test, and they had passed.',
      ],
      illustrationAsset: '$_scenes/ismail_ram.webp',
      quranRef: QuranQuoteRef(surah: 37, ayah: 104),
    ),
    KidsBookSpread(
      ['Allah sent a ram instead.', 'We trust Allah.'],
      illustrationAsset: '$_scenes/ismail_ram.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 37, ayah: 107),
    ),
    KidsBookSpread([
      'Every year, on Eid al-Adha, we remember that day.',
      'A father, a son, and a big trust.',
    ], illustrationAsset: '$_scenes/ismail_eid.webp'),
    KidsBookSpread(
      ['When something is hard, do what Ismail did.', 'We trust Allah.'],
      illustrationAsset: '$_scenes/ismail_eid.webp',
      isRefrain: true,
    ),
  ],
);
