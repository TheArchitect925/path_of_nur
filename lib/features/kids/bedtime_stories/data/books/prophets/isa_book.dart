import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Isa, the Baby Who Spoke. Surah Al Imran 3:37–59, Maryam 19:16–36 and
/// al-Ma'idah 5:110, on the K3 scenes this story already had.
final BedtimeStorySeed isaBook = kidsPictureBook(
  id: 'story_prophet_isa_bedtime_v1',
  prophetId: 'isa',
  title: 'Isa, the Baby Who Spoke',
  shortTitle: 'Prophet Isa',
  summary:
      'Maryam, a palm tree by a stream, and a baby who spoke from the cradle.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.kindness,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  refrain: 'Allah can do anything.',
  lesson: 'Be kind, help others, and trust Allah. He can do all things.',
  bedtimeClosing:
      'Now close your eyes. Allah took care of Maryam and Isa, and Allah '
      'takes care of you. Good night.',
  quranQuote:
      'Indeed, the example of Isa to Allah is like that of Adam. He created '
      'him from dust; then He said to him, "Be," and he was.',
  quranReference: 'Qur’an 3:59',
  quranQuoteRef: const QuranQuoteRef(surah: 3, ayah: 59),
  sourceNote:
      'Follows Al Imran 3:37–59 and Maryam 19:16–36; the bird of clay is in '
      'al-Ma’idah 5:110.',
  audioFileName: 'prophet_isa_bedtime_v1.mp3',
  tags: const ['prophet', 'isa', 'maryam', 'miracles', 'compassion'],
  sortOrder: 80,
  isFeatured: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/isa_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/isa_backdrop.webp',
  relatedStoryIds: const ['story_prophet_muhammad_part1_bedtime_v1'],
  de: const KidsBookTranslation(
    title: 'Isa, das Baby, das sprach',
    shortTitle: 'Prophet Isa',
    summary:
        'Maryam, eine Palme an einem Bach und ein Baby, das aus der Wiege sprach.',
    lesson: 'Sei gütig, hilf anderen und vertrau Allah. Er kann alles.',
    refrain: 'Allah kann alles.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Allah sorgte für Maryam und Isa, und Allah sorgt für dich. Gute Nacht.',
    spreads: [
      [
        'Maryam, Friede sei mit ihr, verbrachte ihre Tage damit, Allah anzubeten.',
        'Wenn Zakariya kam, fand er Früchte, die niemand gebracht hatte.',
      ],
      [
        'Eines Tages kam ein Engel zu Maryam.',
        '„Allah schenkt dir einen reinen Sohn“, sagte er.',
      ],
      [
        '„Wie kann ich einen Sohn haben?“, fragte sie.',
        'Der Engel sagte: Für Allah ist das leicht.',
        'Allah kann alles.',
      ],
      [
        'Maryam ging fort zu einer Palme an einem Bach.',
        'Dort wurde das Baby geboren: Isa, Friede sei mit ihm.',
      ],
      [
        'Allah sagte: Schüttel die Palme, und Datteln fallen. Trink aus dem Bach.',
        'Allah sorgte für beide.',
      ],
      [
        'Als Maryam nach Hause kam, stellten die Leute Fragen.',
        'Da zeigte sie auf das Baby.',
      ],
      [
        'Und das Baby sprach!',
        '„Ich bin der Diener Allahs. Er hat mich zum Propheten gemacht.“',
      ],
      [
        'Isa wuchs auf. Mit Allahs Erlaubnis heilte er Kranke und Blinde.',
        'Allah kann alles.',
      ],
      [
        'Er formte einen Vogel aus Lehm, und mit Allahs Erlaubnis flog er.',
        'Er gab den Armen zu essen und tröstete die Traurigen.',
      ],
      [
        'Manche Menschen wollten Isa etwas tun.',
        'Aber Allah beschützte ihn und erhob ihn zu Sich.',
      ],
      [
        'Isa war ein Prophet Allahs, wie Adam, erschaffen durch Allahs Wort: Sei.',
        'Allah kann alles.',
      ],
      [
        'Sei gütig und hilf Menschen, wie Isa es tat.',
        'Allah hat ihn gemacht, und Allah hat dich gemacht.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'Maryam, peace be upon her, spent her days worshipping Allah.',
        'Whenever Zakariya visited, he found fruit no one had brought.',
      ],
      illustrationAsset: '$_scenes/isa_mihrab.webp',
      quranRef: QuranQuoteRef(surah: 3, ayah: 37),
    ),
    KidsBookSpread(
      [
        'One day an angel came to Maryam.',
        '"Allah gives you a pure son," he said.',
      ],
      illustrationAsset: '$_scenes/isa_mihrab.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 19),
    ),
    KidsBookSpread(
      [
        '"How can I have a son?" she asked.',
        'The angel said: for Allah it is easy.',
        'Allah can do anything.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 19, ayah: 21),
    ),
    KidsBookSpread(
      [
        'Maryam went away to a palm tree by a stream.',
        'There the baby was born: Isa, peace be upon him.',
      ],
      illustrationAsset: '$_scenes/isa_palm_stream.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 23),
    ),
    KidsBookSpread(
      [
        'Allah said: shake the palm and dates will fall. Drink from the stream.',
        'Allah took care of them both.',
      ],
      illustrationAsset: '$_scenes/isa_palm_stream.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 25),
    ),
    KidsBookSpread(
      [
        'When Maryam came home, people asked questions.',
        'So she pointed at the baby.',
      ],
      illustrationAsset: '$_scenes/isa_cradle.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 29),
    ),
    KidsBookSpread(
      [
        'And the baby spoke!',
        '"I am the servant of Allah. He made me a prophet."',
      ],
      illustrationAsset: '$_scenes/isa_cradle.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 30),
    ),
    KidsBookSpread(
      [
        'Isa grew up. By Allah’s permission, he healed the sick and the blind.',
        'Allah can do anything.',
      ],
      illustrationAsset: '$_scenes/isa_village_morning.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 3, ayah: 49),
    ),
    KidsBookSpread(
      [
        'He made a bird from clay and, by Allah’s permission, it flew.',
        'He fed the poor and comforted the sad.',
      ],
      illustrationAsset: '$_scenes/isa_village_morning.webp',
      quranRef: QuranQuoteRef(surah: 5, ayah: 110),
    ),
    KidsBookSpread(
      [
        'Some people wanted to hurt Isa.',
        'But Allah protected him and raised him up to Himself.',
      ],
      illustrationAsset: '$_scenes/isa_raised.webp',
      quranRef: QuranQuoteRef(surah: 4, ayah: 158),
    ),
    KidsBookSpread(
      [
        'Isa was a prophet of Allah, like Adam, made by Allah’s word: Be.',
        'Allah can do anything.',
      ],
      illustrationAsset: '$_scenes/isa_raised.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 3, ayah: 59),
    ),
    KidsBookSpread([
      'Be kind and help people, like Isa did.',
      'Allah made him, and Allah made you.',
    ], atlasScene: KidsBookAtlasScene.garden),
  ],
);
