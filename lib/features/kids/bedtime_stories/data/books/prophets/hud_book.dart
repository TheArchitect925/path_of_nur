import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Hud and the Wind. Surah Hud 11:50–58, Fussilat 41:15–16, al-Ahqaf
/// 46:21–25 and al-Haqqah 69:6–8.
final BedtimeStorySeed hudBook = kidsPictureBook(
  id: 'story_prophet_hud_bedtime_v1',
  prophetId: 'hud',
  title: 'Hud and the Wind',
  shortTitle: 'Prophet Hud',
  summary:
      'A proud people with tall towers, a cloud that was not rain, and a '
      'prophet who was kept safe.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.gratitude,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  refrain: 'Allah is stronger.',
  lesson:
      'Being strong is a gift from Allah. Thank Him for it, and never be '
      'proud.',
  bedtimeClosing:
      'Now close your eyes. The wind has passed, and Allah keeps you safe. '
      'Good night.',
  quranQuote:
      'Did they not see that Allah, who created them, was greater than them '
      'in strength?',
  quranReference: 'Qur’an 41:15',
  quranQuoteRef: const QuranQuoteRef(surah: 41, ayah: 15),
  sourceNote:
      'Follows Hud 11:50–58, Fussilat 41:15–16, al-Ahqaf 46:21–25 and '
      'al-Haqqah 69:6–8.',
  audioFileName: 'prophet_hud_bedtime_v1.mp3',
  tags: const ['prophet', 'hud', 'ad', 'wind', 'pride', 'gratitude'],
  sortOrder: 25,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/hud_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/hud_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_nuh_bedtime_v1',
    'story_prophet_salih_bedtime_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Hud und der Wind',
    shortTitle: 'Prophet Hud',
    summary:
        'Ein stolzes Volk mit hohen Türmen, eine Wolke, die kein Regen war, und ein Prophet, der beschützt wurde.',
    lesson:
        'Stark zu sein ist ein Geschenk von Allah. Dank Ihm dafür, und sei niemals stolz.',
    refrain: 'Allah ist stärker.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Der Wind ist vorbei, und Allah beschützt dich. Gute Nacht.',
    spreads: [
      [
        'Nach Nuh lebte ein Volk namens Ad.',
        'Sie bauten hohe Türme und starke Häuser aus Stein.',
      ],
      ['Sie waren stolz.', '„Wer ist stärker als wir?“, sagten sie.'],
      [
        'Allah schickte ihnen den Propheten Hud, Friede sei mit ihm.',
        '„Betet Allah allein an“, sagte er. „Er hat euch stark gemacht.“',
      ],
      [
        '„Bittet Allah um Vergebung, und Er schickt euch Regen“, sagte Hud.',
        'Allah ist stärker.',
      ],
      [
        'Aber die Leute lachten.',
        '„Wir lassen unsere Götter nicht für dich“, sagten sie.',
      ],
      [
        'Der Regen blieb aus.',
        'Das Land wurde trocken, und trotzdem hörten sie nicht.',
      ],
      [
        'Dann kam eines Tages eine dunkle Wolke über das Tal.',
        '„Endlich Regen!“, jubelten sie.',
      ],
      [
        'Es war kein Regen. Es war ein Wind.',
        'Ein Wind, der sieben Nächte und acht Tage blies.',
      ],
      ['Die Türme von Ad fielen wie leere Dattelpalmen.', 'Allah ist stärker.'],
      [
        'Hud und die Gläubigen waren in Sicherheit.',
        'Allah beschützt die, die Ihm vertrauen.',
      ],
      [
        'Wenn jemand sagt „Niemand ist stärker als ich“, denk an Ad.',
        'Allah ist stärker.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'After Nuh, there lived a people called Ad.',
        'They built tall towers and strong houses of stone.',
      ],
      illustrationAsset: '$_scenes/hud_pillars.webp',
      quranRef: QuranQuoteRef(surah: 89, ayah: 7),
    ),
    KidsBookSpread(
      ['They were proud.', '"Who is stronger than us?" they said.'],
      illustrationAsset: '$_scenes/hud_pillars.webp',
      quranRef: QuranQuoteRef(surah: 41, ayah: 15),
    ),
    KidsBookSpread(
      [
        'Allah sent them Prophet Hud, peace be upon him.',
        '"Worship Allah alone," he said. "He made you strong."',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      quranRef: QuranQuoteRef(surah: 11, ayah: 50),
    ),
    KidsBookSpread(
      [
        '"Ask Allah to forgive you, and He will send you rain," said Hud.',
        'Allah is stronger.',
      ],
      illustrationAsset: '$_scenes/hud_dry_land.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 11, ayah: 52),
    ),
    KidsBookSpread(
      [
        'But the people laughed.',
        '"We will not leave our gods for you," they said.',
      ],
      illustrationAsset: '$_scenes/hud_pillars.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 53),
    ),
    KidsBookSpread([
      'The rain stopped coming.',
      'The land grew dry, and still they would not listen.',
    ], illustrationAsset: '$_scenes/hud_dry_land.webp'),
    KidsBookSpread(
      [
        'Then one day a dark cloud came over the valley.',
        '"Rain at last!" they cheered.',
      ],
      illustrationAsset: '$_scenes/hud_cloud.webp',
      quranRef: QuranQuoteRef(surah: 46, ayah: 24),
    ),
    KidsBookSpread(
      [
        'It was not rain. It was a wind.',
        'A wind that blew for seven nights and eight days.',
      ],
      illustrationAsset: '$_scenes/hud_wind.webp',
      quranRef: QuranQuoteRef(surah: 69, ayah: 7),
    ),
    KidsBookSpread(
      ['The towers of Ad fell like empty date palms.', 'Allah is stronger.'],
      illustrationAsset: '$_scenes/hud_wind.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 69, ayah: 7),
    ),
    KidsBookSpread(
      ['Hud and the believers were safe.', 'Allah keeps those who trust Him.'],
      illustrationAsset: '$_scenes/hud_calm.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 58),
    ),
    KidsBookSpread(
      [
        'When someone says "nobody is stronger than me", remember Ad.',
        'Allah is stronger.',
      ],
      illustrationAsset: '$_scenes/hud_calm.webp',
      isRefrain: true,
    ),
  ],
);
