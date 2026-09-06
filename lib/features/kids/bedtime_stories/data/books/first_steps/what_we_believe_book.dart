import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// What Muslims Believe. The hadith of Jibreel (Sahih Muslim 8) and
/// al-Baqarah 2:285. Ends on the Prophets shelf.
final BedtimeStorySeed whatWeBelieveBook = kidsPictureBook(
  id: 'book_first_steps_what_we_believe_v1',
  storyFamilyId: 'first_steps_what_we_believe',
  title: 'What Muslims Believe',
  shortTitle: 'What We Believe',
  summary:
      'The angel who came dressed in white, and the six things every Muslim '
      'believes.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'We believe.',
  lesson:
      'Believe in Allah, His angels, His books, His prophets, the Last Day, '
      'and that Allah plans everything.',
  bedtimeClosing:
      'Now close your eyes. Six lanterns, all lit, and Allah watching over '
      'you. Good night.',
  quranQuote:
      'The Messenger has believed in what was revealed to him from his '
      'Lord, and so have the believers. All of them have believed in Allah '
      'and His angels and His books and His messengers.',
  quranReference: 'Qur’an 2:285',
  quranQuoteRef: const QuranQuoteRef(surah: 2, ayah: 285),
  hadithQuote:
      'Iman is to believe in Allah, His angels, His books, His messengers, '
      'the Last Day, and to believe in the decree, the good of it and the '
      'bad of it.',
  hadithReference: 'Sahih Muslim 8',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'Follows the hadith of Jibreel in Sahih Muslim 8 and al-Baqarah 2:285.',
  tags: const ['first steps', 'iman', 'belief', 'angels', 'books', 'prophets'],
  sortOrder: 302,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/what_we_believe_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_angels_v1',
    'book_first_steps_quran_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'One day a man in white asked the Prophet ﷺ: what is iman?',
      'Iman means what we believe.',
    ], illustrationAsset: '$_scenes/steps_iman_lanterns.webp'),
    KidsBookSpread([
      'The Prophet ﷺ said there are six things.',
      'Six lanterns, Safa calls them.',
    ], illustrationAsset: '$_scenes/steps_iman_lanterns.webp'),
    KidsBookSpread(
      ['One: we believe in Allah.', 'One God, who made it all. We believe.'],
      illustrationAsset: '$_scenes/steps_allah_sky.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Two: we believe in the angels.',
      'Made of light, doing what Allah tells them.',
    ], illustrationAsset: '$_scenes/steps_angels_light.webp'),
    KidsBookSpread([
      'Three: we believe in Allah\'s books.',
      'The Tawrah, the Zabur, the Injil, and the Qur\'an.',
    ], illustrationAsset: '$_scenes/steps_iman_books.webp'),
    KidsBookSpread([
      'Four: we believe in the prophets.',
      'From Adam to Muhammad ﷺ, one chain of messengers.',
    ], illustrationAsset: '$_scenes/steps_iman_path.webp'),
    KidsBookSpread([
      'Five: we believe in the Last Day.',
      'One day everyone will stand before Allah, and He will be fair.',
    ], illustrationAsset: '$_scenes/shuayb_fair.webp'),
    KidsBookSpread([
      'Six: we believe that Allah plans everything.',
      'The good and the hard. Nothing happens without Him.',
    ], illustrationAsset: '$_scenes/ilyas_mountain_sky.webp'),
    KidsBookSpread(
      ['Six lanterns, all lit. We believe.'],
      illustrationAsset: '$_scenes/steps_iman_lanterns.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'The man in white was the angel Jibreel.',
      'He came to teach us.',
    ], illustrationAsset: '$_scenes/muhammad_cave_light.webp'),
    KidsBookSpread(
      ['Now meet the prophets, one by one.', 'We believe.'],
      illustrationAsset: '$_scenes/steps_iman_path.webp',
      isRefrain: true,
      tryItRoute: '/learn/kids/stories?collection=prophets',
    ),
  ],
);
