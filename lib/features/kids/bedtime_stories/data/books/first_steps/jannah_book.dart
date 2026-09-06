import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Jannah. Surah as-Sajdah 32:17, Muhammad 47:15, al-Waqi'ah 56:28–33,
/// al-Qiyamah 75:22–23 and al-Baqarah 2:201; what no eye has seen is in
/// Sahih al-Bukhari 3244; the four beloved words in Sahih Muslim 2137.
/// Ends in the dhikr counter.
final BedtimeStorySeed jannahBook = kidsPictureBook(
  id: 'book_first_steps_jannah_v1',
  storyFamilyId: 'first_steps_jannah',
  title: 'Jannah',
  shortTitle: 'Jannah',
  summary:
      'Amina asks what Jannah is like, and Safa tells her: rivers, fruit, '
      'no goodbyes, and seeing Allah.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.gratitude,
  ],
  refrain: 'Better than anything.',
  lesson:
      'Jannah is Allah\'s reward for those who believe and do good. Ask Him '
      'for it every day.',
  bedtimeClosing:
      'Now close your eyes. Jannah is waiting, better than anything. Good '
      'night.',
  quranQuote:
      'And no soul knows what has been hidden for them of comfort for eyes '
      'as reward for what they used to do.',
  quranReference: 'Qur’an 32:17',
  quranQuoteRef: const QuranQuoteRef(surah: 32, ayah: 17),
  hadithQuote:
      'Allah said: I have prepared for My righteous servants what no eye '
      'has seen, no ear has heard, and no human heart has imagined.',
  hadithReference: 'Sahih al-Bukhari 3244',
  sourceNote:
      'Follows as-Sajdah 32:17, Muhammad 47:15, al-Waqi’ah 56:28–33, '
      'al-Qiyamah 75:22–23 and al-Baqarah 2:201; what no eye has seen is in '
      'Sahih al-Bukhari 3244; the four beloved words are in Sahih Muslim '
      '2137.',
  tags: const ['first steps', 'jannah', 'paradise', 'dhikr'],
  sortOrder: 313,
  bedtimeEligible: true,
  recommendedForTonight: true,
  coverAssetPath: 'assets/images/kids_books/covers/jannah_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_who_is_allah_v1',
    'story_prophet_adam_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        '"What is Jannah like?" asked Amina.',
        '"Better than anything," said Safa.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_kids.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Jannah is the garden Allah has made for the people who love Him.',
      'It is waiting.',
    ], illustrationAsset: '$_scenes/adam_jannah.webp'),
    KidsBookSpread(
      [
        'Rivers run through it. Rivers of water, of milk, of honey.',
        'Sweet, and cool, and clear.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_rivers.webp',
      quranRef: QuranQuoteRef(surah: 47, ayah: 15),
    ),
    KidsBookSpread(
      [
        'Trees full of fruit, always ripe, always in reach.',
        'No thorns, and no waiting.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_fruit.webp',
      quranRef: QuranQuoteRef(surah: 56, ayah: 28),
    ),
    KidsBookSpread(
      [
        'Nobody is ever sick there. Nobody is ever sad.',
        'Nobody ever has to say goodbye.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_kids.webp',
      quranRef: QuranQuoteRef(surah: 35, ayah: 34),
    ),
    KidsBookSpread(
      [
        'The Prophet ﷺ said: it has what no eye has seen and no ear has heard.',
        'Better than anything.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_door.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'The best thing of all: the people there see Allah.',
        'And He is pleased with them.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_door.webp',
      quranRef: QuranQuoteRef(surah: 75, ayah: 22),
    ),
    KidsBookSpread(
      [
        'How do we get there? Believe in Allah, and do good.',
        'Pray, share, tell the truth, be kind.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_fruit.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 25),
    ),
    KidsBookSpread(
      [
        'Ask Allah for it every day: Rabbana atina fil-akhirati hasanah.',
        'Better than anything.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_rivers.webp',
      isRefrain: true,
      arabicLine: 'رَبَّنَا آتِنَا فِي ٱلْآخِرَةِ حَسَنَةً',
      quranRef: QuranQuoteRef(surah: 2, ayah: 201),
    ),
    KidsBookSpread(
      [
        'Say SubhanAllah, Alhamdulillah, La ilaha illallah, Allahu Akbar.',
        'The Prophet ﷺ loved these words. Let\'s say them now.',
      ],
      illustrationAsset: '$_scenes/steps_jannah_kids.webp',
      tryItRoute: '/worship/dhikr',
    ),
  ],
);
