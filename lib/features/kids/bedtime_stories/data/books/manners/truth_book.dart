import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Telling the Truth. Qur'an 9:119. Keeps the legacy id.
final BedtimeStorySeed truthBook = kidsPictureBook(
  id: 'story_telling_the_truth_v1',
  storyFamilyId: 'telling_the_truth',
  title: 'Safa and the Blue Cup',
  shortTitle: 'The Blue Cup',
  summary:
      'A spilled cup, a heart that goes thump, and the small sentence that '
      'made everything light again.',
  category: BedtimeStoryCategory.characterAdab,
  collectionType: KidsIslamicStoryCollectionType.characterAdab,
  storyType: KidsIslamicStoryType.honesty,
  themes: const [
    KidsIslamicStoryTheme.honesty,
    KidsIslamicStoryTheme.truthfulness,
  ],
  refrain: 'The truth makes you light.',
  lesson:
      'Truthfulness brings peace to the heart, even when we have made a '
      'mistake.',
  bedtimeClosing:
      'Now close your eyes. Nothing heavy on your heart tonight. Good night.',
  quranQuote:
      'O you who believe, fear Allah and be with those who are truthful.',
  quranReference: 'Qur’an 9:119',
  quranQuoteRef: const QuranQuoteRef(surah: 9, ayah: 119),
  sourceCategory: KidsIslamicStorySourceCategory.quran,
  sourceNote: 'Follows at-Tawbah 9:119, staying with the truthful.',
  tags: const ['truth', 'honesty', 'mistake', 'adab'],
  sortOrder: 230,
  isFeatured: true,
  recommendedForTonight: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/telling_the_truth_cover.webp',
  backdropAssetPath:
      'assets/images/kids_stories/backdrops/telling_the_truth_backdrop.webp',
  audioFileName: 'telling_the_truth_kids_story_en_v1.mp3',
  audioManifestRef: 'kids_story:telling_the_truth',
  relatedStoryIds: const ['story_saying_sorry_and_forgiving_v1'],
  quizRefs: const ['quiz_story_telling_the_truth_v1'],
  memoryRefs: const ['memory_story_telling_the_truth_v1'],
  de: const KidsBookTranslation(
    title: 'Safa und die blaue Tasse',
    shortTitle: 'Die blaue Tasse',
    summary:
        'Eine umgekippte Tasse, ein Herz, das pocht, und der kleine Satz, der alles wieder leicht machte.',
    lesson:
        'Ehrlichkeit bringt dem Herzen Frieden, auch wenn wir einen Fehler gemacht haben.',
    refrain: 'Die Wahrheit macht dich leicht.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Heute Nacht liegt nichts Schweres auf deinem Herzen. Gute Nacht.',
    spreads: [
      [
        'Safa griff nach der blauen Tasse. Rums! Sie kippte um.',
        'Wasser lief über den Tisch.',
      ],
      [
        'Niemand hatte es gesehen. Safas Herz pochte.',
        'Sie könnte sagen: „Ich war das nicht.“',
      ],
      ['Aber eine Lüge ist schwer. Sie liegt auf deinem Herzen wie ein Stein.'],
      ['Safa holte tief Luft. „Mama, ich habe das Wasser verschüttet.“'],
      [
        'Mama kam näher. Sie war nicht böse.',
        '„Danke, dass du die Wahrheit sagst, Safa.“',
      ],
      [
        'Zusammen wischten sie den Tisch sauber.',
        'Der Stein war weg. Die Wahrheit macht dich leicht.',
      ],
      ['Allah sagt: Sei mit denen, die die Wahrheit sagen.'],
      [
        'Ein Fehler ist klein. Eine Lüge macht ihn groß.',
        'Die Wahrheit macht dich leicht.',
      ],
      [
        'Wenn dein Herz pocht, sag, was passiert ist.',
        'Die Wahrheit macht dich leicht.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'Safa reached for the blue cup. Bump! It tipped over.',
      'Water ran across the table.',
    ], illustrationAsset: '$_scenes/truth_spilled_cup.webp'),
    KidsBookSpread([
      'Nobody saw. Safa’s heart went thump.',
      'She could say: "I did not do it."',
    ], illustrationAsset: '$_scenes/truth_spilled_cup.webp'),
    KidsBookSpread([
      'But a lie is heavy. It sits on your heart like a stone.',
    ], atlasScene: KidsBookAtlasScene.home),
    KidsBookSpread([
      'Safa took a breath. "Mama, I spilled the water."',
    ], illustrationAsset: '$_scenes/truth_spilled_cup.webp'),
    KidsBookSpread([
      'Mama came close. She was not angry.',
      '"Thank you for telling the truth, Safa."',
    ], illustrationAsset: '$_scenes/truth_clean_table.webp'),
    KidsBookSpread(
      [
        'Together they wiped the table clean.',
        'The stone was gone. The truth makes you light.',
      ],
      illustrationAsset: '$_scenes/truth_clean_table.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      ['Allah says: be with those who are truthful.'],
      atlasScene: KidsBookAtlasScene.home,
      quranRef: QuranQuoteRef(surah: 9, ayah: 119),
    ),
    KidsBookSpread(
      ['A mistake is small. A lie makes it big.', 'The truth makes you light.'],
      illustrationAsset: '$_scenes/truth_spilled_cup.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'When your heart goes thump, say what happened.',
        'The truth makes you light.',
      ],
      illustrationAsset: '$_scenes/truth_clean_table.webp',
      isRefrain: true,
    ),
  ],
);
