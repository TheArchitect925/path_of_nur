import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Sulayman and the Ant. Surah an-Naml 27:15–44 and Saba 34:12, on the K3
/// scenes this story already had. The seed id keeps the older spelling.
final BedtimeStorySeed sulaymanBook = kidsPictureBook(
  id: 'story_prophet_sulaiman_bedtime_v1',
  prophetId: 'sulaiman',
  title: 'Sulayman and the Ant',
  shortTitle: 'Prophet Sulayman',
  summary:
      'A king who heard an ant, a bird with big news, and a throne that flew.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.gratitude,
    KidsIslamicStoryTheme.compassionForAnimals,
  ],
  refrain: 'Thank You, Allah.',
  lesson:
      'Be grateful for what you have, use your gifts for good, and stay '
      'humble.',
  bedtimeClosing:
      'Now close your eyes. Sulayman heard the ant, and Allah hears you. '
      'Good night.',
  quranQuote:
      'So he smiled, amused at her speech, and said, "My Lord, enable me to '
      'be grateful for Your favour."',
  quranReference: 'Qur’an 27:19',
  quranQuoteRef: const QuranQuoteRef(surah: 27, ayah: 19),
  sourceNote: 'Follows an-Naml 27:15–44 and Saba 34:12.',
  audioFileName: 'prophet_sulaiman_bedtime_v1.mp3',
  tags: const ['prophet', 'sulaiman', 'animals', 'ant', 'hoopoe', 'gratitude'],
  sortOrder: 72,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/sulaiman_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/sulaiman_backdrop.webp',
  relatedStoryIds: const ['story_prophet_dawud_bedtime_v1'],
  de: const KidsBookTranslation(
    title: 'Sulayman und die Ameise',
    shortTitle: 'Prophet Sulayman',
    summary:
        'Ein König, der eine Ameise hörte, ein Vogel mit großen Neuigkeiten und ein Thron, der flog.',
    lesson:
        'Sei dankbar für das, was du hast, nutze deine Gaben für Gutes und bleib bescheiden.',
    refrain: 'Danke, Allah.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Sulayman hörte die Ameise, und Allah hört dich. Gute Nacht.',
    spreads: [
      [
        'Sulayman, Friede sei mit ihm, war Dawuds Sohn und ein König.',
        'Allah lehrte ihn, was die Vögel und Tiere sagen.',
      ],
      [
        'Eines Tages zog sein großes Heer durch ein Tal.',
        'Eine winzige Ameise sah sie kommen.',
      ],
      [
        '„O Ameisen, geht in eure Häuser“, rief sie, „damit Sulaymans Heer euch nicht zertritt!“',
      ],
      [
        'Sulayman hörte sie, und er lächelte.',
        'Er betete: „Mein Herr, hilf mir, dankbar zu sein.“ Danke, Allah.',
      ],
      [
        'Der Wind trug Sulayman, wohin er wollte.',
        'Eine Reise am Morgen war so weit wie ein Monat, am Abend genauso.',
      ],
      [
        'Eines Tages fehlte ein kleiner Vogel: der Wiedehopf.',
        'Dann kam er zurück mit großen Neuigkeiten.',
      ],
      [
        '„Ich habe ein Land gefunden, das eine Königin regiert“, sagte der Wiedehopf.',
        '„Ihr Volk betet die Sonne an statt Allah.“',
      ],
      [
        'Sulayman schickte der Königin einen Brief: Komm zu Allah.',
        'Die Königin kam, weise und vorsichtig.',
      ],
      [
        'Bevor sie ankam, stand ihr Thron vor Sulayman.',
        'Mit Allahs Erlaubnis, in einem Augenblick.',
      ],
      [
        '„Das ist von meinem Herrn“, sagte Sulayman, „um zu prüfen, ob ich dankbar bin.“',
        'Danke, Allah.',
      ],
      [
        'Die Königin sah die Wahrheit und glaubte mit Sulayman an Allah.',
        'Das ganze Königreich tat es.',
      ],
      [
        'Bei all dieser Macht blieb Sulayman bescheiden.',
        'Jede Nacht dachte er daran, Wer sie ihm gegeben hatte.',
      ],
      [
        'Wenn Allah dir etwas Gutes gibt, mach es wie Sulayman.',
        'Danke, Allah.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'Sulayman, peace be upon him, was Dawud’s son and a king.',
        'Allah taught him what the birds and animals say.',
      ],
      atlasScene: KidsBookAtlasScene.cityMorning,
      quranRef: QuranQuoteRef(surah: 27, ayah: 16),
    ),
    KidsBookSpread(
      [
        'One day his great army marched through a valley.',
        'A tiny ant saw them coming.',
      ],
      illustrationAsset: '$_scenes/sulaiman_ants.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 18),
    ),
    KidsBookSpread(
      [
        '"O ants, go into your homes," she cried, "so Sulayman’s army does not crush you!"',
      ],
      illustrationAsset: '$_scenes/sulaiman_ants.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 18),
    ),
    KidsBookSpread(
      [
        'Sulayman heard her, and he smiled.',
        'He prayed: "My Lord, help me be thankful." Thank You, Allah.',
      ],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 27, ayah: 19),
    ),
    KidsBookSpread(
      [
        'The wind carried Sulayman wherever he wished.',
        'A morning’s journey was a month’s, an evening’s the same.',
      ],
      illustrationAsset: '$_scenes/sulaiman_wind.webp',
      quranRef: QuranQuoteRef(surah: 34, ayah: 12),
    ),
    KidsBookSpread(
      [
        'One day a small bird was missing: the hoopoe.',
        'Then it came back with big news.',
      ],
      illustrationAsset: '$_scenes/sulaiman_hoopoe.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 22),
    ),
    KidsBookSpread(
      [
        '"I found a land ruled by a queen," said the hoopoe.',
        '"Her people worship the sun instead of Allah."',
      ],
      illustrationAsset: '$_scenes/sulaiman_sun_kingdom.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 24),
    ),
    KidsBookSpread(
      [
        'Sulayman sent the queen a letter: come to Allah.',
        'The queen came, wise and careful.',
      ],
      illustrationAsset: '$_scenes/sulaiman_sun_kingdom.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 31),
    ),
    KidsBookSpread(
      [
        'Before she arrived, her throne stood before Sulayman.',
        'By Allah’s permission, in the blink of an eye.',
      ],
      illustrationAsset: '$_scenes/sulaiman_throne.webp',
      quranRef: QuranQuoteRef(surah: 27, ayah: 40),
    ),
    KidsBookSpread(
      [
        '"This is from my Lord," said Sulayman, "to test whether I am thankful."',
        'Thank You, Allah.',
      ],
      illustrationAsset: '$_scenes/sulaiman_throne.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 27, ayah: 40),
    ),
    KidsBookSpread(
      [
        'The queen saw the truth and believed in Allah with Sulayman.',
        'The whole kingdom did.',
      ],
      atlasScene: KidsBookAtlasScene.cityNight,
      quranRef: QuranQuoteRef(surah: 27, ayah: 44),
    ),
    KidsBookSpread([
      'With all that power, Sulayman stayed humble.',
      'Every night he remembered Who gave it.',
    ], illustrationAsset: '$_scenes/sulaiman_thankful_night.webp'),
    KidsBookSpread(
      [
        'When Allah gives you something good, do what Sulayman did.',
        'Thank You, Allah.',
      ],
      illustrationAsset: '$_scenes/sulaiman_thankful_night.webp',
      isRefrain: true,
    ),
  ],
);
