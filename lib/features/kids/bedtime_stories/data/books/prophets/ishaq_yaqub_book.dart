import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Ishaq and Yaqub, a Family of Prophets. Surah Hud 11:69–73, as-Saffat
/// 37:112, Maryam 19:49, Yusuf 12:4–96 and al-Baqarah 2:133.
final BedtimeStorySeed ishaqYaqubBook = kidsPictureBook(
  id: 'story_prophet_ishaq_yaqub_bedtime_v1',
  prophetId: 'ishaq',
  storyFamilyId: 'ishaq_yaqub',
  title: 'Ishaq and Yaqub, a Family of Prophets',
  shortTitle: 'Ishaq and Yaqub',
  summary:
      'Good news for an old couple, a son and a grandson who became '
      'prophets, and a father’s beautiful patience.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [KidsIslamicStoryTheme.family, KidsIslamicStoryTheme.patience],
  refrain: 'Allah’s promises come true.',
  lesson:
      'Allah keeps His promises. Be patient, like Yaqub, and keep trusting '
      'Him.',
  bedtimeClosing:
      'Now close your eyes. Allah kept every promise to this family, and He '
      'keeps His promises to you. Good night.',
  quranQuote:
      'So patience is most fitting. Perhaps Allah will bring them to me all '
      'together.',
  quranReference: 'Qur’an 12:83',
  quranQuoteRef: const QuranQuoteRef(surah: 12, ayah: 83),
  sourceNote:
      'Follows Hud 11:69–73, as-Saffat 37:112, Maryam 19:49, Yusuf 12:4–96 '
      'and al-Baqarah 2:133.',
  audioFileName: 'prophet_ishaq_yaqub_bedtime_v1.mp3',
  tags: const ['prophet', 'ishaq', 'yaqub', 'family', 'promise', 'patience'],
  sortOrder: 45,
  coverAssetPath:
      '$bedtimeStoryImageCoverAssetDirectory/ishaq_yaqub_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/ishaq_yaqub_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_ibrahim_bedtime_v1',
    'story_prophet_yusuf_bedtime_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'Ibrahim and his wife Sarah were old, and had no children.',
        'Then guests came with good news.',
      ],
      illustrationAsset: '$_scenes/ishaq_tent_lamp.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 69),
    ),
    KidsBookSpread(
      [
        '"You will have a son called Ishaq," said the angels.',
        'Sarah laughed. A baby, now?',
      ],
      illustrationAsset: '$_scenes/ishaq_tent_lamp.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 71),
    ),
    KidsBookSpread(
      [
        'But Allah’s promises come true.',
        'Ishaq, peace be upon him, was born, and grew into a prophet.',
      ],
      illustrationAsset: '$_scenes/ishaq_flocks.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 37, ayah: 112),
    ),
    KidsBookSpread(
      [
        'Ishaq had a son called Yaqub, peace be upon him.',
        'He became a prophet too. Three prophets in one family.',
      ],
      illustrationAsset: '$_scenes/ishaq_flocks.webp',
      quranRef: QuranQuoteRef(surah: 19, ayah: 49),
    ),
    KidsBookSpread(
      [
        'Yaqub had twelve sons.',
        'One of them was Yusuf, the boy with the dream.',
      ],
      illustrationAsset: '$_scenes/yaqub_twelve.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 4),
    ),
    KidsBookSpread(
      [
        'When Yusuf was lost, Yaqub cried until his eyes turned white.',
        'But he never stopped trusting Allah.',
      ],
      illustrationAsset: '$_scenes/yaqub_waiting.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 84),
    ),
    KidsBookSpread(
      [
        '"Beautiful patience," he said. "Allah will bring them all back to me."',
        'Allah’s promises come true.',
      ],
      illustrationAsset: '$_scenes/yaqub_waiting.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 12, ayah: 83),
    ),
    KidsBookSpread(
      [
        'Years later, Yusuf’s shirt was laid over his father’s face.',
        'And Yaqub could see again.',
      ],
      illustrationAsset: '$_scenes/yaqub_waiting.webp',
      quranRef: QuranQuoteRef(surah: 12, ayah: 96),
    ),
    KidsBookSpread(
      [
        'Before he died, Yaqub asked: what will you worship after me?',
        '"Allah alone," said his sons.',
      ],
      atlasScene: KidsBookAtlasScene.homeEvening,
      quranRef: QuranQuoteRef(surah: 2, ayah: 133),
    ),
    KidsBookSpread(
      [
        'A grandfather, a father, and a son, all prophets.',
        'Allah’s promises come true.',
      ],
      illustrationAsset: '$_scenes/yaqub_twelve.webp',
      isRefrain: true,
    ),
  ],
);
