import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Month We Wait For. Surah al-Baqarah 2:183–185 and al-Qadr 97. Ends
/// in the fasting page.
final BedtimeStorySeed ramadanBook = kidsPictureBook(
  id: 'book_first_steps_ramadan_v1',
  storyFamilyId: 'first_steps_ramadan',
  title: 'The Month We Wait For',
  shortTitle: 'Ramadan',
  summary:
      'A thin moon on the roof, suhoor before dawn, a date at sunset, and '
      'the month everything is better in.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [
    KidsIslamicStoryTheme.ramadan,
    KidsIslamicStoryTheme.gratitude,
  ],
  refrain: 'The month we wait for.',
  lesson:
      'Ramadan is the month of the Qur’an, of fasting, and of being kind. '
      'Wait for it, and love it.',
  bedtimeClosing:
      'Now close your eyes. The moon is thin tonight, and Ramadan is '
      'coming. Good night.',
  quranQuote:
      'The month of Ramadan is that in which the Qur\'an was revealed, a '
      'guidance for the people.',
  quranReference: 'Qur’an 2:185',
  quranQuoteRef: const QuranQuoteRef(surah: 2, ayah: 185),
  sourceNote: 'Follows al-Baqarah 2:183–185 and al-Qadr 97.',
  tags: const ['first steps', 'ramadan', 'fasting', 'eid', 'laylat al-qadr'],
  sortOrder: 308,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/ramadan_cover.webp',
  relatedStoryIds: const [
    'story_ramadan_kindness_v1',
    'story_eid_gratitude_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Der Monat, auf den wir warten',
    shortTitle: 'Ramadan',
    summary:
        'Eine dünne Mondsichel auf dem Dach, Suhur vor der Dämmerung, eine Dattel bei Sonnenuntergang und der Monat, in dem alles besser ist.',
    lesson:
        'Ramadan ist der Monat des Quran, des Fastens und der Güte. Warte auf ihn, und liebe ihn.',
    refrain: 'Der Monat, auf den wir warten.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Der Mond ist heute Nacht dünn, und der Ramadan kommt. Gute Nacht.',
    spreads: [
      [
        'Safa und Zayn standen bei Sonnenuntergang auf dem Dach und suchten eine dünne neue Mondsichel.',
        '„Da!“, rief Zayn.',
      ],
      ['Der Ramadan war da.', 'Der Monat, auf den wir warten.'],
      [
        'Ramadan ist der Monat, in dem der Quran zum Propheten ﷺ herabkam.',
        'Der beste Monat des ganzen Jahres.',
      ],
      [
        'Im Ramadan fasten die Erwachsenen: kein Essen, kein Trinken, von der Dämmerung bis zum Sonnenuntergang.',
        'Kinder probieren ein bisschen und wachsen hinein.',
      ],
      [
        'Vor der Dämmerung isst die Familie zusammen: Suhur.',
        'Dann beginnt der Tag.',
      ],
      [
        'Bei Sonnenuntergang warten alle auf den Adhan.',
        'Dann eine Dattel und ein Schluck Wasser. Iftar!',
      ],
      [
        'Nachts ist die Moschee voll und hell.',
        'Lange Gebete, der Quran von Anfang bis Ende gelesen.',
      ],
      [
        'Ramadan macht uns gütig. Wir teilen mehr, wir geben mehr, wir beten mehr.',
        'Der Monat, auf den wir warten.',
      ],
      [
        'Gegen Ende kommt eine Nacht, besser als tausend Monate.',
        'Lailat al-Qadr, in den letzten zehn Nächten.',
      ],
      [
        'Dann wieder die neue Mondsichel, und Eid!',
        'Neue Kleider, Süßigkeiten und danke, Allah.',
      ],
      [
        'Zähl mit mir die Tage bis zum Ramadan.',
        'Der Monat, auf den wir warten.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'Safa and Zayn stood on the roof at sunset, looking for a thin new moon.',
      '"There!" cried Zayn.',
    ], illustrationAsset: '$_scenes/steps_ramadan_moon.webp'),
    KidsBookSpread(
      ['Ramadan had come.', 'The month we wait for.'],
      illustrationAsset: '$_scenes/steps_ramadan_moon.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Ramadan is the month the Qur’an came down to the Prophet ﷺ.',
        'The best month of the whole year.',
      ],
      illustrationAsset: '$_scenes/muhammad_cave_light.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 185),
    ),
    KidsBookSpread(
      [
        'In Ramadan, grown-ups fast: no food, no drink, from dawn until sunset.',
        'Children try a little, and grow into it.',
      ],
      illustrationAsset: '$_scenes/steps_ramadan_suhoor.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 183),
    ),
    KidsBookSpread([
      'Before dawn, the family eats together: suhoor.',
      'Then the day begins.',
    ], illustrationAsset: '$_scenes/steps_ramadan_suhoor.webp'),
    KidsBookSpread([
      'At sunset, everyone waits for the adhan.',
      'Then a date and a sip of water. Iftar!',
    ], illustrationAsset: '$_scenes/pillars_dates.webp'),
    KidsBookSpread([
      'At night the masjid is full and bright.',
      'Long prayers, the Qur’an read from beginning to end.',
    ], illustrationAsset: '$_scenes/steps_ramadan_masjid_night.webp'),
    KidsBookSpread(
      [
        'Ramadan makes us kind. We share more, we give more, we pray more.',
        'The month we wait for.',
      ],
      illustrationAsset: '$_scenes/steps_ramadan_masjid_night.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Near the end comes a night better than a thousand months.',
        'Laylat al-Qadr, in the last ten nights.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 97, ayah: 3),
    ),
    KidsBookSpread([
      'Then the new moon again, and Eid!',
      'New clothes, sweets, and thank you, Allah.',
    ], illustrationAsset: '$_scenes/steps_ramadan_eid.webp'),
    KidsBookSpread(
      ['Count the days until Ramadan with me.', 'The month we wait for.'],
      illustrationAsset: '$_scenes/steps_ramadan_moon.webp',
      isRefrain: true,
      tryItRoute: '/worship/fasting',
    ),
  ],
);
