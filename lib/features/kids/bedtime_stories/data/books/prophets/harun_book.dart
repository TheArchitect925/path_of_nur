import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Harun, the Brother Who Helped. Surah al-Qasas 28:34–35, Ta-Ha 20:29–36
/// and 20:83–94, al-A'raf 7:142–151. Borrows Musa's palace scene.
final BedtimeStorySeed harunBook = kidsPictureBook(
  id: 'story_prophet_harun_bedtime_v1',
  prophetId: 'harun',
  title: 'Harun, the Brother Who Helped',
  shortTitle: 'Prophet Harun',
  summary:
      'Musa’s big brother, who spoke for him, stood by him, and looked after '
      'the people while he was away.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.helpingOthers,
    KidsIslamicStoryTheme.family,
  ],
  refrain: 'Brothers help each other.',
  lesson:
      'Help the people you love, speak up kindly, and be someone others can '
      'lean on.',
  bedtimeClosing:
      'Now close your eyes. Allah gave Musa a brother, and Allah gives you '
      'people who help. Good night.',
  quranQuote: 'We will strengthen your arm through your brother.',
  quranReference: 'Qur’an 28:35',
  quranQuoteRef: const QuranQuoteRef(surah: 28, ayah: 35),
  sourceNote:
      'Follows al-Qasas 28:34–35, Ta-Ha 20:29–36 and 20:83–94, and al-A’raf '
      '7:142–151.',
  audioFileName: 'prophet_harun_bedtime_v1.mp3',
  tags: const ['prophet', 'harun', 'musa', 'brothers', 'helping'],
  sortOrder: 62,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/harun_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/harun_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_musa_bedtime_v1',
    'story_helping_parents_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Harun, der Bruder, der half',
    shortTitle: 'Prophet Harun',
    summary:
        'Musas großer Bruder, der für ihn sprach, ihm zur Seite stand und sich um das Volk kümmerte, als er fort war.',
    lesson:
        'Hilf den Menschen, die du liebst, sprich freundlich und sei jemand, auf den andere sich stützen können.',
    refrain: 'Brüder helfen einander.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Allah gab Musa einen Bruder, und Allah gibt dir Menschen, die helfen. Gute Nacht.',
    spreads: [
      [
        'Musa hatte einen großen Bruder namens Harun, Friede sei mit ihnen beiden.',
        'Harun sprach klar und ruhig.',
      ],
      [
        'Als Allah Musa zu Firaun schickte, bat Musa:',
        '„Schick meinen Bruder Harun mit mir. Er spricht besser als ich.“',
      ],
      [
        'Allah sagte ja.',
        '„Ich mache dich stark durch deinen Bruder.“ Brüder helfen einander.',
      ],
      [
        'Zusammen gingen sie in den Palast von Firaun.',
        'Zwei Brüder, eine Botschaft: Lass unser Volk gehen.',
      ],
      [
        'Harun stand an jedem schweren Tag neben Musa.',
        'Brüder helfen einander.',
      ],
      [
        'Als sich das Meer geöffnet hatte, ging Musa auf den Berg, um mit Allah zu sprechen.',
        'Harun blieb und kümmerte sich um das Volk.',
      ],
      [
        'Während Musa fort war, machten manche Leute ein Kalb aus Gold.',
        'Sie verbeugten sich davor.',
      ],
      [
        'Harun sagte ihnen: Das ist eine Prüfung! Euer Herr ist Allah. Folgt mir.',
        'Aber sie wollten nicht hören.',
      ],
      [
        'Als Musa zurückkam, war er wütend.',
        'Harun sagte: Mein Bruder, gib nicht mir die Schuld. Ich habe es versucht.',
      ],
      ['Musa betete: Vergib mir und meinem Bruder.', 'Brüder helfen einander.'],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'Musa had a big brother called Harun, peace be upon them both.',
        'Harun spoke clearly and calmly.',
      ],
      illustrationAsset: '$_scenes/harun_two_staffs.webp',
      quranRef: QuranQuoteRef(surah: 28, ayah: 34),
    ),
    KidsBookSpread(
      [
        'When Allah sent Musa to Firawn, Musa asked:',
        '"Send my brother Harun with me. He speaks better than me."',
      ],
      illustrationAsset: '$_scenes/harun_two_staffs.webp',
      quranRef: QuranQuoteRef(surah: 20, ayah: 29),
    ),
    KidsBookSpread(
      [
        'Allah said yes.',
        '"I will make you strong through your brother." Brothers help each other.',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 28, ayah: 35),
    ),
    KidsBookSpread(
      [
        'Together they went to the palace of Firawn.',
        'Two brothers, one message: let our people go.',
      ],
      illustrationAsset: '$_scenes/musa_palace.webp',
      quranRef: QuranQuoteRef(surah: 20, ayah: 47),
    ),
    KidsBookSpread(
      [
        'Harun stood beside Musa through every hard day.',
        'Brothers help each other.',
      ],
      illustrationAsset: '$_scenes/musa_palace.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'After the sea opened, Musa went up the mountain to speak with Allah.',
        'Harun stayed to look after the people.',
      ],
      illustrationAsset: '$_scenes/harun_tents.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 142),
    ),
    KidsBookSpread(
      [
        'While Musa was away, some people made a calf of gold.',
        'They bowed to it.',
      ],
      illustrationAsset: '$_scenes/harun_calf.webp',
      quranRef: QuranQuoteRef(surah: 20, ayah: 88),
    ),
    KidsBookSpread(
      [
        'Harun told them: this is a test! Your Lord is Allah. Follow me.',
        'But they would not listen.',
      ],
      illustrationAsset: '$_scenes/harun_calf.webp',
      quranRef: QuranQuoteRef(surah: 20, ayah: 90),
    ),
    KidsBookSpread(
      [
        'When Musa came back, he was angry.',
        'Harun said: my brother, do not blame me. I tried.',
      ],
      illustrationAsset: '$_scenes/harun_tents.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 150),
    ),
    KidsBookSpread(
      ['Musa prayed: forgive me and my brother.', 'Brothers help each other.'],
      illustrationAsset: '$_scenes/harun_two_staffs.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 7, ayah: 151),
    ),
  ],
);
