import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Dawud and the Giant. Surah al-Baqarah 2:249–251, Saba 34:10–11,
/// al-Anbiya 21:79 and Sad 38:26, on the K3 scenes this story already had.
final BedtimeStorySeed dawudBook = kidsPictureBook(
  id: 'story_prophet_dawud_bedtime_v1',
  prophetId: 'dawud',
  title: 'Dawud and the Giant',
  shortTitle: 'Prophet Dawud',
  summary: 'A small stone, a giant, and a voice the mountains sang along with.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.gratitude,
  ],
  refrain: 'Strength comes from Allah.',
  lesson:
      'True strength comes from trusting Allah. Be fair, helpful, and use '
      'your gifts for good.',
  bedtimeClosing:
      'Now close your eyes. The giant was big, but Allah is bigger. Good '
      'night.',
  quranQuote:
      'And We certainly gave Dawud from Us bounty. O mountains, repeat '
      'praises with him, and the birds as well.',
  quranReference: 'Qur’an 34:10',
  quranQuoteRef: const QuranQuoteRef(surah: 34, ayah: 10),
  sourceNote:
      'Follows al-Baqarah 2:249–251, Saba 34:10–11, al-Anbiya 21:79 and Sad '
      '38:26.',
  audioFileName: 'prophet_dawud_bedtime_v1.mp3',
  tags: const ['prophet', 'dawud', 'jalut', 'justice', 'voice', 'strength'],
  sortOrder: 70,
  isFeatured: true,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/dawud_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/dawud_backdrop.webp',
  relatedStoryIds: const ['story_prophet_sulaiman_bedtime_v1'],
  de: const KidsBookTranslation(
    title: 'Dawud und der Riese',
    shortTitle: 'Prophet Dawud',
    summary:
        'Ein kleiner Stein, ein Riese und eine Stimme, mit der die Berge mitsangen.',
    lesson:
        'Wahre Stärke kommt vom Vertrauen auf Allah. Sei gerecht, hilfsbereit und nutze deine Gaben für Gutes.',
    refrain: 'Stärke kommt von Allah.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Der Riese war groß, aber Allah ist größer. Gute Nacht.',
    spreads: [
      [
        'Vor langer Zeit machte ein Riese namens Dschalut allen Angst.',
        'Er war groß und stark, und sein Heer war noch größer.',
      ],
      [
        'Ein junger Mann namens Dawud, Friede sei mit ihm, hatte keine Angst.',
        'Er wusste, woher wahre Stärke kommt.',
      ],
      [
        'Dawud nahm nur eine Schleuder und einen kleinen Stein.',
        'Stärke kommt von Allah.',
      ],
      [
        'Er betete: „Unser Herr, gieß Geduld über uns und mach unsere Füße fest.“',
        'Dann warf er.',
      ],
      ['Ein sorgfältiger Wurf.', 'Mit Allahs Hilfe fiel der Riese.'],
      [
        'Allah machte Dawud zum König und zum Propheten.',
        'Er gab ihm eine Stimme, schöner als jede andere.',
      ],
      [
        'Wenn Dawud Allah pries, priesen die Berge mit ihm.',
        'Die Vögel kamen und sangen mit.',
      ],
      [
        'Allah machte Eisen in seinen Händen weich, und er machte Rüstungen daraus.',
        'Er arbeitete mit seinen eigenen Händen.',
      ],
      [
        'Als König hörte er allen zu und urteilte gerecht.',
        'Stärke kommt von Allah.',
      ],
      [
        'Er war stark, und er war gerecht.',
        'Und er vergaß nie, Wer ihn stark gemacht hatte.',
      ],
      [
        'Wenn etwas zu groß für dich aussieht, denk an Dawud.',
        'Stärke kommt von Allah.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'Long ago, a giant called Jalut frightened everyone.',
        'He was big and strong, and his army was bigger.',
      ],
      illustrationAsset: '$_scenes/dawud_valley.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 250),
    ),
    KidsBookSpread([
      'A young man named Dawud, peace be upon him, was not afraid.',
      'He knew where real strength comes from.',
    ], illustrationAsset: '$_scenes/dawud_valley.webp'),
    KidsBookSpread(
      [
        'Dawud took only a sling and a small stone.',
        'Strength comes from Allah.',
      ],
      illustrationAsset: '$_scenes/dawud_sling.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'He prayed: "Our Lord, pour patience on us and make our feet firm."',
        'Then he threw.',
      ],
      illustrationAsset: '$_scenes/dawud_stone_flies.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 250),
    ),
    KidsBookSpread(
      ['One careful throw.', 'With Allah’s help, the giant fell.'],
      illustrationAsset: '$_scenes/dawud_stone_flies.webp',
      quranRef: QuranQuoteRef(surah: 2, ayah: 251),
    ),
    KidsBookSpread(
      [
        'Allah made Dawud a king and a prophet.',
        'He gave him a voice more beautiful than any other.',
      ],
      illustrationAsset: '$_scenes/dawud_mountains_birds.webp',
      quranRef: QuranQuoteRef(surah: 34, ayah: 10),
    ),
    KidsBookSpread(
      [
        'When Dawud praised Allah, the mountains praised with him.',
        'The birds gathered and sang along.',
      ],
      illustrationAsset: '$_scenes/dawud_mountains_birds.webp',
      quranRef: QuranQuoteRef(surah: 21, ayah: 79),
    ),
    KidsBookSpread(
      [
        'Allah made iron soft in his hands, and he made armour from it.',
        'He worked with his own hands.',
      ],
      atlasScene: KidsBookAtlasScene.homeEvening,
      quranRef: QuranQuoteRef(surah: 34, ayah: 11),
    ),
    KidsBookSpread(
      [
        'As a king he listened to everyone, and judged fairly.',
        'Strength comes from Allah.',
      ],
      illustrationAsset: '$_scenes/dawud_justice.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 38, ayah: 26),
    ),
    KidsBookSpread([
      'He was strong, and he was fair.',
      'And he never forgot Who made him strong.',
    ], illustrationAsset: '$_scenes/dawud_justice.webp'),
    KidsBookSpread(
      [
        'When something looks too big for you, remember Dawud.',
        'Strength comes from Allah.',
      ],
      illustrationAsset: '$_scenes/dawud_valley.webp',
      isRefrain: true,
    ),
  ],
);
