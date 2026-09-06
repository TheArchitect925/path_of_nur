import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Who Is Allah? Surah al-Ikhlas 112, Ayat al-Kursi 2:255, al-Mulk 67:13.
/// Ends in the 99 Names.
final BedtimeStorySeed whoIsAllahBook = kidsPictureBook(
  id: 'book_first_steps_who_is_allah_v1',
  storyFamilyId: 'first_steps_who_is_allah',
  title: 'Who Is Allah?',
  shortTitle: 'Who Is Allah?',
  summary:
      'Zayn asks who made the sun, and Safa knows: Allah, who made it all, '
      'and who never sleeps.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'Allah made it all.',
  lesson:
      'Allah is One. He made everything, He sees everything, and He loves '
      'you.',
  bedtimeClosing:
      'Now close your eyes. Allah does not sleep, so you can. Good night.',
  quranQuote:
      'Say, "He is Allah, One. Allah, the Eternal Refuge. He neither '
      'begets nor is born, nor is there to Him any equivalent."',
  quranReference: 'Qur’an 112:1–4',
  quranQuoteRef: const QuranQuoteRef(surah: 112, ayah: 1),
  sourceNote: 'Follows al-Ikhlas 112, Ayat al-Kursi 2:255 and al-Mulk 67:13.',
  tags: const ['first steps', 'allah', 'tawhid', 'names of allah'],
  sortOrder: 300,
  isFeatured: true,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/who_is_allah_cover.webp',
  relatedStoryIds: const ['book_first_steps_shahada_v1'],
  spreads: const [
    KidsBookSpread([
      '"Who made the sun?" asked Zayn.',
      '"Allah made it," said Safa. "And the moon. And the stars."',
    ], illustrationAsset: '$_scenes/steps_allah_sky.webp'),
    KidsBookSpread(
      [
        'Allah made the sea and the mountains.',
        'The birds, the flowers, the cat next door.',
        'Allah made it all.',
      ],
      illustrationAsset: '$_scenes/steps_allah_garden.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Allah made you too. Your eyes, your hands, your heart.',
      'And Allah made your mother and father.',
    ], atlasScene: KidsBookAtlasScene.home),
    KidsBookSpread(
      ['Allah is One.', 'There is no one like Him, and He needs no one.'],
      illustrationAsset: '$_scenes/steps_allah_sky.webp',
      quranRef: QuranQuoteRef(surah: 112, ayah: 1),
    ),
    KidsBookSpread(
      [
        'Allah does not sleep and does not get tired.',
        'Day and night, He looks after everything.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 2, ayah: 255),
    ),
    KidsBookSpread(
      [
        'Allah sees you when no one else does.',
        'In the dark, in a whisper, in your heart.',
      ],
      illustrationAsset: '$_scenes/steps_allah_night_lamp.webp',
      quranRef: QuranQuoteRef(surah: 67, ayah: 13),
    ),
    KidsBookSpread([
      'Allah loves you.',
      'He gave you everything you have, and He forgives when you say sorry.',
    ], illustrationAsset: '$_scenes/steps_allah_garden.webp'),
    KidsBookSpread(
      [
        'Allah has beautiful names.',
        'The Merciful. The Kind. The One Who Hears. The One Who Sees.',
      ],
      illustrationAsset: '$_scenes/steps_allah_names.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 180),
    ),
    KidsBookSpread(
      ['Look up tonight and count the stars.', 'Allah made it all.'],
      illustrationAsset: '$_scenes/steps_allah_sky.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Say it with me: Allah made it all.',
        'Now, let\'s learn some of His beautiful names.',
      ],
      illustrationAsset: '$_scenes/steps_allah_names.webp',
      isRefrain: true,
      tryItRoute: '/quran/names-of-allah',
    ),
  ],
);
