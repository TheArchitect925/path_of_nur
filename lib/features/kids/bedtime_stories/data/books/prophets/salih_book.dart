import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Salih and the Camel. Surah al-A'raf 7:73–79, ash-Shu'ara 26:141–159
/// and Hud 11:61–68.
final BedtimeStorySeed salihBook = kidsPictureBook(
  id: 'story_prophet_salih_bedtime_v1',
  prophetId: 'salih',
  title: 'Salih and the Camel',
  shortTitle: 'Prophet Salih',
  summary:
      'A she-camel sent as a sign, a well shared by turns, and a warning that '
      'was not heard.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.compassionForAnimals,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  refrain: 'Do not harm her.',
  lesson:
      'Be kind to animals and listen to good advice. Allah’s signs deserve '
      'care, not harm.',
  bedtimeClosing:
      'Now close your eyes. Be gentle with every animal, and Allah is gentle '
      'with you. Good night.',
  quranQuote:
      'This is the she-camel of Allah, a sign for you. So leave her to eat '
      'in Allah’s land and do not touch her with harm.',
  quranReference: 'Qur’an 7:73',
  quranQuoteRef: const QuranQuoteRef(surah: 7, ayah: 73),
  sourceNote:
      'Follows al-A’raf 7:73–79, ash-Shu’ara 26:141–159 and Hud 11:61–68.',
  audioFileName: 'prophet_salih_bedtime_v1.mp3',
  tags: const ['prophet', 'salih', 'thamud', 'camel', 'animals', 'signs'],
  sortOrder: 27,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/salih_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/salih_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_hud_bedtime_v1',
    'story_prophet_ibrahim_bedtime_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Salih und die Kamelstute',
    shortTitle: 'Prophet Salih',
    summary:
        'Eine Kamelstute als Zeichen, ein Brunnen, den man sich abwechselnd teilte, und eine Warnung, die keiner hörte.',
    lesson:
        'Sei gut zu Tieren und hör auf guten Rat. Allahs Zeichen verdienen Sorgfalt, nicht Schaden.',
    refrain: 'Tut ihr nichts.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Sei sanft mit jedem Tier, und Allah ist sanft mit dir. Gute Nacht.',
    spreads: [
      [
        'Nach Ad kam das Volk von Thamud.',
        'Sie hauten ihre Häuser in die Berge.',
      ],
      [
        'Allah schickte ihnen den Propheten Salih, Friede sei mit ihm.',
        '„Betet Allah allein an“, sagte er ihnen.',
      ],
      [
        '„Zeig uns ein Zeichen“, sagten die Leute.',
        'Also schickte Allah ihnen ein Zeichen: eine Kamelstute.',
      ],
      [
        '„Dieses Kamel ist von Allah“, sagte Salih.',
        '„Lasst sie fressen und trinken. Tut ihr nichts.“',
      ],
      [
        'An einem Tag trank das Kamel aus dem Brunnen.',
        'Am nächsten tranken die Leute. Alle hatten genug.',
      ],
      [
        'Manche Leute glaubten Salih.',
        'Aber andere waren wütend, dass ein Kamel ihr Wasser teilte.',
      ],
      ['Salih warnte sie noch einmal: Tut ihr nichts.', 'Allah schaut zu.'],
      [
        'Aber sie taten dem Kamel weh.',
        'Dann tat es ihnen leid, aber es war zu spät.',
      ],
      [
        'Allah schickte ein großes Beben, und ihre starken Häuser konnten sie nicht retten.',
        'Salih und die Gläubigen waren in Sicherheit.',
      ],
      [
        'Salih sagte: Ich habe euch guten Rat gegeben, aber ihr wolltet ihn nicht.',
        'Und er ging traurig fort.',
      ],
      [
        'Allahs Geschöpfe sind uns anvertraut.',
        'Tut ihr nichts, und keinem von ihnen.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'After Ad came the people of Thamud.',
        'They carved their houses into the mountains.',
      ],
      illustrationAsset: '$_scenes/salih_rock_houses.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 74),
    ),
    KidsBookSpread(
      [
        'Allah sent them Prophet Salih, peace be upon him.',
        '"Worship Allah alone," he told them.',
      ],
      illustrationAsset: '$_scenes/salih_rock_houses.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 73),
    ),
    KidsBookSpread(
      [
        '"Show us a sign," the people said.',
        'So Allah sent them a sign: a she-camel.',
      ],
      illustrationAsset: '$_scenes/salih_camel.webp',
      quranRef: QuranQuoteRef(surah: 26, ayah: 155),
    ),
    KidsBookSpread(
      [
        '"This camel is from Allah," said Salih.',
        '"Let her eat and drink. Do not harm her."',
      ],
      illustrationAsset: '$_scenes/salih_camel.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 7, ayah: 73),
    ),
    KidsBookSpread(
      [
        'The camel drank from the well one day.',
        'The people drank the next. Everyone had enough.',
      ],
      illustrationAsset: '$_scenes/salih_well.webp',
      quranRef: QuranQuoteRef(surah: 26, ayah: 155),
    ),
    KidsBookSpread([
      'Some people believed Salih.',
      'But others were angry that a camel shared their water.',
    ], illustrationAsset: '$_scenes/salih_well.webp'),
    KidsBookSpread(
      ['Salih warned them again: do not harm her.', 'Allah is watching.'],
      illustrationAsset: '$_scenes/salih_camel.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'But they hurt the camel.',
        'Then they were sorry, but it was too late.',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      quranRef: QuranQuoteRef(surah: 7, ayah: 77),
    ),
    KidsBookSpread(
      [
        'Allah sent a great shaking, and their strong houses could not save them.',
        'Salih and the believers were safe.',
      ],
      illustrationAsset: '$_scenes/salih_quake.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 66),
    ),
    KidsBookSpread(
      [
        'Salih said: I gave you good advice, but you did not like it.',
        'And he walked away, sad.',
      ],
      illustrationAsset: '$_scenes/salih_after.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 79),
    ),
    KidsBookSpread(
      [
        'Allah’s creatures are in our care.',
        'Do not harm her, or any of them.',
      ],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
    ),
  ],
);
