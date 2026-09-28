import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Idris, the First to Write. A short book: Surah Maryam 19:56–57 and
/// al-Anbiya 21:85; the pen and the needle are from the classical Stories
/// of the Prophets, and the source note says so.
final BedtimeStorySeed idrisBook = kidsPictureBook(
  id: 'story_prophet_idris_bedtime_v1',
  prophetId: 'idris',
  title: 'Idris, the First to Write',
  shortTitle: 'Prophet Idris',
  summary:
      'The prophet who loved to learn: the first to write, the first to sew, '
      'raised high by Allah.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.truthfulness,
    KidsIslamicStoryTheme.patience,
  ],
  refrain: 'truthful and patient.',
  lesson:
      'Love learning, tell the truth, and be patient. Allah raises those who '
      'do.',
  bedtimeClosing:
      'Now close your eyes. Idris looked at the stars, and the same stars '
      'are over you. Good night.',
  quranQuote: 'And We raised him to a high station.',
  quranReference: 'Qur’an 19:57',
  quranQuoteRef: const QuranQuoteRef(surah: 19, ayah: 57),
  sourceNote:
      'Follows Maryam 19:56–57 and al-Anbiya 21:85. The pen and the needle '
      'are from the classical Stories of the Prophets, not the Qur’an.',
  audioFileName: 'prophet_idris_bedtime_v1.mp3',
  tags: const ['prophet', 'idris', 'learning', 'truth', 'stars'],
  sortOrder: 15,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/idris_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/idris_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_adam_bedtime_v1',
    'story_prophet_nuh_bedtime_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Idris, der als Erster schrieb',
    shortTitle: 'Prophet Idris',
    summary:
        'Der Prophet, der das Lernen liebte: der Erste, der schrieb, der Erste, der nähte, von Allah hoch erhoben.',
    lesson:
        'Liebe das Lernen, sag die Wahrheit und sei geduldig. Allah erhebt die, die das tun.',
    refrain: 'ehrlich und geduldig.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Idris schaute zu den Sternen, und dieselben Sterne stehen über dir. Gute Nacht.',
    spreads: [
      [
        'Vor langer Zeit, nach Adam, lebte ein Prophet namens Idris, Friede sei mit ihm.',
        'Er war ehrlich und geduldig.',
      ],
      [
        'Idris liebte das Lernen.',
        'Nachts schaute er zu den Sternen und staunte über das, was Allah gemacht hatte.',
      ],
      [
        'Man sagt, Idris war der Erste, der mit einem Stift schrieb.',
        'Er schrieb auf, was er lernte.',
      ],
      [
        'Er war der Erste, der Kleider mit einer Nadel nähte.',
        'Er machte Dinge mit seinen eigenen Händen.',
      ],
      [
        'Er sagte seinem Volk: Betet Allah allein an.',
        'Seid ehrlich und geduldig, wie Idris.',
      ],
      [
        'Allah sagt, Idris war ein Mann der Wahrheit und ein Prophet.',
        'Allah erhob ihn an einen hohen Ort.',
      ],
      [
        'Wir wissen nicht alles über Idris.',
        'Aber wir wissen, dass Allah seine Wahrheit liebte.',
      ],
      [
        'Lern heute etwas Neues und schreib es auf.',
        'Sei wie Idris: ehrlich und geduldig.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'Long ago, after Adam, lived a prophet called Idris, peace be upon him.',
        'He was truthful and patient.',
      ],
      atlasScene: KidsBookAtlasScene.cityMorning,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 19, ayah: 56),
    ),
    KidsBookSpread([
      'Idris loved to learn.',
      'At night he watched the stars and wondered at what Allah had made.',
    ], illustrationAsset: '$_scenes/idris_stars.webp'),
    KidsBookSpread([
      'People say Idris was the first to write with a pen.',
      'He wrote down what he learned.',
    ], illustrationAsset: '$_scenes/idris_pen.webp'),
    KidsBookSpread([
      'He was the first to sew clothes with a needle.',
      'He made things with his own hands.',
    ], illustrationAsset: '$_scenes/idris_needle.webp'),
    KidsBookSpread(
      [
        'He told his people: worship Allah alone.',
        'Be truthful and patient, like Idris.',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Allah says Idris was a man of truth, and a prophet.',
        'Allah raised him to a high place.',
      ],
      illustrationAsset: '$_scenes/idris_high.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 57),
    ),
    KidsBookSpread(
      [
        'We do not know everything about Idris.',
        'But we know Allah loved his truth.',
      ],
      illustrationAsset: '$_scenes/idris_high.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 85),
    ),
    KidsBookSpread(
      [
        'Learn something new today, and write it down.',
        'Be like Idris: truthful and patient.',
      ],
      illustrationAsset: '$_scenes/idris_pen.webp',
      isRefrain: true,
    ),
  ],
);
