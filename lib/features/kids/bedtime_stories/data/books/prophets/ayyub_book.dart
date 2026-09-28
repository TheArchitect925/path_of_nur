import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Ayyub, the Patient One. Surah al-Anbiya 21:83–84 and Sad 38:41–44.
final BedtimeStorySeed ayyubBook = kidsPictureBook(
  id: 'story_prophet_ayyub_bedtime_v1',
  prophetId: 'ayyub',
  title: 'Ayyub, the Patient One',
  shortTitle: 'Prophet Ayyub',
  summary:
      'A man who lost everything and stayed thankful, and the cool spring '
      'Allah gave him.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.patience,
    KidsIslamicStoryTheme.gratitude,
  ],
  refrain: 'patient and thankful.',
  lesson:
      'Be patient in hard times and thankful in good times. Allah’s help '
      'always comes.',
  bedtimeClosing:
      'Now close your eyes. Hard days pass, and Allah’s help comes. Good '
      'night.',
  quranQuote:
      'Indeed, We found him patient, an excellent servant. Indeed, he was '
      'one repeatedly turning back to Allah.',
  quranReference: 'Qur’an 38:44',
  quranQuoteRef: const QuranQuoteRef(surah: 38, ayah: 44),
  sourceNote: 'Follows al-Anbiya 21:83–84 and Sad 38:41–44.',
  audioFileName: 'prophet_ayyub_bedtime_v1.mp3',
  tags: const ['prophet', 'ayyub', 'patience', 'illness', 'gratitude'],
  sortOrder: 57,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/ayyub_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/ayyub_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_yusuf_bedtime_v1',
    'story_patience_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Ayyub, der Geduldige',
    shortTitle: 'Prophet Ayyub',
    summary:
        'Ein Mann, der alles verlor und dankbar blieb, und die kühle Quelle, die Allah ihm gab.',
    lesson:
        'Sei geduldig in schweren Zeiten und dankbar in guten. Allahs Hilfe kommt immer.',
    refrain: 'geduldig und dankbar.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Schwere Tage gehen vorbei, und Allahs Hilfe kommt. Gute Nacht.',
    spreads: [
      [
        'Prophet Ayyub, Friede sei mit ihm, hatte alles.',
        'Eine große Familie, grüne Felder, viele Tiere und Gesundheit.',
      ],
      ['Und er dankte Allah für all das.', 'Jeden einzelnen Tag.'],
      [
        'Dann kamen schwere Zeiten.',
        'Seine Tiere starben. Seine Felder vertrockneten. Seine Kinder waren fort.',
      ],
      [
        'Dann wurde Ayyub sehr krank, für eine lange, lange Zeit.',
        'Aber er blieb geduldig und dankbar.',
      ],
      [
        'Er sagte nie: Warum ich?',
        'Er sagte: Mein Herr, Not hat mich berührt, und Du bist der Barmherzigste.',
      ],
      [
        'Seine Frau blieb bei ihm und pflegte ihn.',
        'Auch sie war geduldig und dankbar.',
      ],
      [
        'Allah erhörte ihn.',
        '„Stampf mit dem Fuß auf den Boden“, sagte Allah. „Hier ist kühles Wasser zum Waschen und Trinken.“',
      ],
      [
        'Ayyub wusch sich in der Quelle, und er war wieder gesund.',
        'Allah gab ihm seine Familie zurück, und noch mehr.',
      ],
      [
        'Allah sagt über Ayyub: Wir fanden ihn geduldig. Was für ein guter Diener!',
        'Er war geduldig und dankbar.',
      ],
      [
        'Wenn du krank oder traurig bist, denk an Ayyub.',
        'Sei geduldig und dankbar, und warte auf Allahs Hilfe.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'Prophet Ayyub, peace be upon him, had everything.',
      'A big family, green fields, many animals, and good health.',
    ], illustrationAsset: '$_scenes/ayyub_garden_green.webp'),
    KidsBookSpread([
      'And he was thankful to Allah for all of it.',
      'Every single day.',
    ], illustrationAsset: '$_scenes/ayyub_garden_green.webp'),
    KidsBookSpread([
      'Then hard times came.',
      'His animals died. His fields dried up. His children were gone.',
    ], illustrationAsset: '$_scenes/ayyub_garden_dry.webp'),
    KidsBookSpread(
      [
        'Then Ayyub became very ill, for a long, long time.',
        'But he stayed patient and thankful.',
      ],
      illustrationAsset: '$_scenes/ayyub_garden_dry.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 21, ayah: 83),
    ),
    KidsBookSpread(
      [
        'He never said: why me?',
        'He said: my Lord, hardship has touched me, and You are the most merciful.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 21, ayah: 83),
    ),
    KidsBookSpread(
      [
        'His wife stayed by him and cared for him.',
        'She was patient and thankful too.',
      ],
      atlasScene: KidsBookAtlasScene.homeEvening,
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Allah answered him.',
        '"Strike the ground with your foot," Allah said. "Here is cool water to wash and drink."',
      ],
      illustrationAsset: '$_scenes/ayyub_spring.webp',
      quranRef: QuranQuoteRef(surah: 38, ayah: 42),
    ),
    KidsBookSpread(
      [
        'Ayyub washed in the spring, and he was well again.',
        'Allah gave him back his family, and more.',
      ],
      illustrationAsset: '$_scenes/ayyub_garden_again.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 84),
    ),
    KidsBookSpread(
      [
        'Allah says of Ayyub: We found him patient. What an excellent servant!',
        'He was patient and thankful.',
      ],
      illustrationAsset: '$_scenes/ayyub_garden_again.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 38, ayah: 44),
    ),
    KidsBookSpread(
      [
        'When you are sick or sad, remember Ayyub.',
        'Be patient and thankful, and wait for Allah’s help.',
      ],
      illustrationAsset: '$_scenes/ayyub_spring.webp',
      isRefrain: true,
    ),
  ],
);
