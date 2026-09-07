import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Maryam and the Palm Tree. Surah Al Imran 3:35–42 and Maryam 19:16–30.
/// Borrows three scenes from the Isa book.
final BedtimeStorySeed maryamBook = kidsPictureBook(
  id: 'book_quran_maryam_v1',
  storyFamilyId: 'quran_maryam',
  title: 'Maryam and the Palm Tree',
  shortTitle: 'Maryam',
  summary:
      'A promise before she was born, fruit that came from nowhere, and a '
      'dry palm that gave sweet dates.',
  category: BedtimeStoryCategory.quranStories,
  collectionType: KidsIslamicStoryCollectionType.quranStories,
  storyType: KidsIslamicStoryType.quranStory,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.patience,
  ],
  refrain: 'Allah took care of her.',
  lesson: 'Allah cares for those who trust Him, even when they are alone.',
  bedtimeClosing:
      'Now close your eyes. Allah made a stream for Maryam, and Allah cares '
      'for you. Good night.',
  quranQuote: 'Indeed, Allah provides for whom He wills without account.',
  quranReference: 'Qur’an 3:37',
  quranQuoteRef: const QuranQuoteRef(surah: 3, ayah: 37),
  sourceNote: 'Follows Al Imran 3:35–42 and Maryam 19:16–30.',
  tags: const ['quran story', 'maryam', 'palm', 'trust', 'zakariya'],
  sortOrder: 403,
  coverAssetPath: 'assets/images/kids_books/covers/maryam_cover.webp',
  relatedStoryIds: const [
    'story_prophet_isa_bedtime_v1',
    'story_prophet_zakariya_yahya_bedtime_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Maryam und die Palme',
    shortTitle: 'Maryam',
    summary:
        'Ein Versprechen vor ihrer Geburt, Früchte aus dem Nichts und eine trockene Palme, die süße Datteln gab.',
    lesson:
        'Allah sorgt für die, die Ihm vertrauen, auch wenn sie allein sind.',
    refrain: 'Allah sorgte für sie.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Allah ließ für Maryam einen Bach fließen, und Allah sorgt für dich. Gute Nacht.',
    spreads: [
      [
        'Bevor Maryam geboren wurde, gab ihre Mutter Allah ein Versprechen.',
        '„Dieses Kind wird Dir dienen.“',
      ],
      [
        'Maryam wuchs in Allahs Haus auf, still und rein.',
        'Zakariya kümmerte sich um sie.',
      ],
      [
        'Jedes Mal, wenn Zakariya kam, fand er Früchte an ihrer Seite.',
        'Winterfrüchte im Sommer, Sommerfrüchte im Winter.',
      ],
      ['„Maryam, woher ist das?“ „Von Allah.“', 'Allah sorgte für sie.'],
      [
        'Eines Tages kam ein Engel mit einer Nachricht: ein Sohn, durch Allahs Wort.',
        'Maryam hatte Angst, aber sie vertraute Allah.',
      ],
      [
        'Sie ging weit weg, ganz allein, zu einer trockenen Palme.',
        'Sie war müde und traurig.',
      ],
      [
        'Dann eine Stimme: „Sei nicht traurig. Allah hat einen Bach zu deinen Füßen gemacht.“',
        'Allah sorgte für sie.',
      ],
      [
        '„Schüttel die Palme, und frische Datteln fallen für dich herab.“',
        'Der trockene Baum gab ihr süße Datteln.',
      ],
      [
        'Als sie mit dem Baby nach Hause kam, sagten die Leute unfreundliche Dinge.',
        'Da ließ Allah das Baby für sie sprechen.',
      ],
      [
        'Allah nennt Maryam die beste der Frauen.',
        'Allah sorgte für sie, und Er sorgt für dich.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'Before Maryam was born, her mother made a promise to Allah.',
        '"This child will serve You."',
      ],
      illustrationAsset: '$_scenes/maryam_vow.webp',
      quranRef: QuranQuoteRef(surah: 3, ayah: 35),
    ),
    KidsBookSpread(
      [
        'Maryam grew up in Allah’s house, quiet and pure.',
        'Zakariya looked after her.',
      ],
      illustrationAsset: '$_scenes/isa_mihrab.webp',
      quranRef: QuranQuoteRef(surah: 3, ayah: 37),
    ),
    KidsBookSpread(
      [
        'Every time Zakariya came, he found fruit by her side.',
        'Winter fruit in summer, summer fruit in winter.',
      ],
      illustrationAsset: '$_scenes/isa_mihrab.webp',
      quranRef: QuranQuoteRef(surah: 3, ayah: 37),
    ),
    KidsBookSpread(
      [
        '"Maryam, where is this from?" "From Allah."',
        'Allah took care of her.',
      ],
      illustrationAsset: '$_scenes/isa_mihrab.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 3, ayah: 37),
    ),
    KidsBookSpread(
      [
        'One day an angel came with news: a son, by Allah’s word.',
        'Maryam was afraid, but she trusted Allah.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 19, ayah: 19),
    ),
    KidsBookSpread(
      [
        'She went far away, alone, to a dry palm tree.',
        'She was tired and sad.',
      ],
      illustrationAsset: '$_scenes/isa_palm_stream.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 23),
    ),
    KidsBookSpread(
      [
        'Then a voice: "Do not be sad. Allah has made a stream at your feet."',
        'Allah took care of her.',
      ],
      illustrationAsset: '$_scenes/isa_palm_stream.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 19, ayah: 24),
    ),
    KidsBookSpread(
      [
        '"Shake the palm, and fresh dates will fall for you."',
        'The dry tree gave her sweet dates.',
      ],
      illustrationAsset: '$_scenes/isa_palm_stream.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 25),
    ),
    KidsBookSpread(
      [
        'When she went home with the baby, people said unkind things.',
        'So Allah made the baby speak for her.',
      ],
      illustrationAsset: '$_scenes/isa_cradle.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 30),
    ),
    KidsBookSpread(
      [
        'Allah calls Maryam the best of women.',
        'Allah took care of her, and He cares for you.',
      ],
      illustrationAsset: '$_scenes/isa_mihrab.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 3, ayah: 42),
    ),
  ],
);
