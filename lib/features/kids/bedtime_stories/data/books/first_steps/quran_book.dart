import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Allah's Own Words. Surah al-Alaq 96:1, al-Hijr 15:9 and al-Isra 17:9;
/// the best of you learn the Qur'an (Sahih al-Bukhari 5027). Ends in the
/// kids Qur'an page.
final BedtimeStorySeed quranBook = kidsPictureBook(
  id: 'book_first_steps_quran_v1',
  storyFamilyId: 'first_steps_quran',
  title: 'Allah\'s Own Words',
  shortTitle: 'The Qur\'an',
  summary:
      'The most special book in the house: where it came from, why it never '
      'changed, and how Safa reads it.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'Allah\'s own words.',
  lesson:
      'The Qur\'an is Allah\'s own words. Read it, learn it, and let it '
      'guide you.',
  bedtimeClosing:
      'Now close your eyes. Allah\'s words are on the shelf, waiting for you '
      'tomorrow. Good night.',
  quranQuote: 'Indeed, this Qur\'an guides to that which is most suitable.',
  quranReference: 'Qur’an 17:9',
  quranQuoteRef: const QuranQuoteRef(surah: 17, ayah: 9),
  hadithQuote: 'The best of you are those who learn the Qur\'an and teach it.',
  hadithReference: 'Sahih al-Bukhari 5027',
  sourceNote:
      'Follows al-Alaq 96:1, al-Hijr 15:9 and al-Isra 17:9; the best of you '
      'learn the Qur\'an is in Sahih al-Bukhari 5027.',
  tags: const ['first steps', 'quran', 'reading', 'hifz'],
  sortOrder: 310,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/quran_cover.webp',
  relatedStoryIds: const [
    'story_prophet_muhammad_part2_bedtime_v1',
    'book_first_steps_what_we_believe_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Allahs eigene Worte',
    shortTitle: 'Der Quran',
    summary:
        'Das besonderste Buch im Haus: woher es kam, warum es sich nie verändert hat und wie Safa darin liest.',
    lesson:
        'Der Quran sind Allahs eigene Worte. Lies ihn, lern ihn und lass ihn dich leiten.',
    refrain: 'Allahs eigene Worte.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Allahs Worte liegen im Regal und warten morgen auf dich. Gute Nacht.',
    spreads: [
      [
        'Im Regal, in ein Tuch gehüllt, liegt das besonderste Buch im Haus.',
        'Der Quran.',
      ],
      [
        'Er ist nicht wie andere Bücher. Niemand hat ihn geschrieben.',
        'Allah hat ihn gesandt, Wort für Wort. Allahs eigene Worte.',
      ],
      [
        'Der Engel Dschibril brachte ihn dem Propheten ﷺ in einer Höhle.',
        'Das erste Wort war: Lies.',
      ],
      [
        'Er kam über dreiundzwanzig Jahre, Stück für Stück.',
        'Der Prophet ﷺ lehrte jeden Teil seine Freunde.',
      ],
      [
        'Heute ist der Quran genau so wie damals.',
        'Kein einziges Wort hat sich verändert.',
      ],
      [
        'Safa liest jeden Tag ein bisschen, mit dem Finger unter der Zeile.',
        'Zayn hört zu und spricht die Worte nach.',
      ],
      [
        'Der Prophet ﷺ sagte: Die Besten von euch lernen den Quran und lehren ihn.',
        'Allahs eigene Worte.',
      ],
      [
        'Manche Kinder lernen den ganzen Quran auswendig.',
        'Eine Sure nach der anderen, angefangen mit den kurzen.',
      ],
      ['Wenn du ihn liest, spricht Allah zu dir.', 'Allahs eigene Worte.'],
      ['Öffnen wir zusammen eine kurze Sure.', 'Fang mit al-Fatiha an.'],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'On the shelf, wrapped in a cloth, is the most special book in the house.',
      'The Qur\'an.',
    ], illustrationAsset: '$_scenes/steps_quran_shelf.webp'),
    KidsBookSpread(
      [
        'It is not like other books. Nobody wrote it.',
        'Allah sent it, word by word. Allah\'s own words.',
      ],
      illustrationAsset: '$_scenes/steps_quran_stand.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'The angel Jibreel brought it to the Prophet ﷺ in a cave.',
        'The first word was: Read.',
      ],
      illustrationAsset: '$_scenes/muhammad_cave_light.webp',
      quranRef: QuranQuoteRef(surah: 96, ayah: 1),
    ),
    KidsBookSpread([
      'It came over twenty-three years, a little at a time.',
      'The Prophet ﷺ taught every part to his friends.',
    ], atlasScene: KidsBookAtlasScene.cityNight),
    KidsBookSpread(
      [
        'Today the Qur\'an is exactly the same as it was then.',
        'Not one word has changed.',
      ],
      illustrationAsset: '$_scenes/steps_quran_stand.webp',
      quranRef: QuranQuoteRef(surah: 15, ayah: 9),
    ),
    KidsBookSpread([
      'Safa reads a little every day, with her finger under the line.',
      'Zayn listens, and says the words after her.',
    ], illustrationAsset: '$_scenes/steps_quran_kids_reading.webp'),
    KidsBookSpread(
      [
        'The Prophet ﷺ said: the best of you learn the Qur\'an and teach it.',
        'Allah\'s own words.',
      ],
      illustrationAsset: '$_scenes/steps_quran_kids_reading.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Some children learn the whole Qur\'an by heart.',
      'One surah at a time, starting with the short ones.',
    ], illustrationAsset: '$_scenes/steps_quran_sunrise.webp'),
    KidsBookSpread(
      ['When you read it, Allah is speaking to you.', 'Allah\'s own words.'],
      illustrationAsset: '$_scenes/steps_quran_stand.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['Let\'s open a short surah together.', 'Start with al-Fatihah.'],
      illustrationAsset: '$_scenes/steps_quran_kids_reading.webp',
      tryItRoute: '/learn/kids/quran',
    ),
  ],
);
