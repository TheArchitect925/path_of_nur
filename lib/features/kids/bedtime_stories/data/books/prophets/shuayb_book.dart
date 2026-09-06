import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Shuayb and the Honest Scales. Surah Hud 11:84–95, al-A'raf 7:85–93 and
/// ash-Shu'ara 26:176–191.
final BedtimeStorySeed shuaybBook = kidsPictureBook(
  id: 'story_prophet_shuayb_bedtime_v1',
  prophetId: 'shuayb',
  title: 'Shuayb and the Honest Scales',
  shortTitle: 'Prophet Shuayb',
  summary:
      'A market where people cheated, a prophet who asked for honest '
      'scales, and a town that would not listen.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [KidsIslamicStoryTheme.honesty, KidsIslamicStoryTheme.sharing],
  refrain: 'Weigh it fairly.',
  lesson:
      'Be honest in everything you give and take. Allah loves those who are '
      'fair.',
  bedtimeClosing:
      'Now close your eyes. Be fair tomorrow, and Allah will be pleased with '
      'you. Good night.',
  quranQuote:
      'And O my people, give full measure and weight in justice and do not '
      'deprive the people of their due.',
  quranReference: 'Qur’an 11:85',
  quranQuoteRef: const QuranQuoteRef(surah: 11, ayah: 85),
  sourceNote:
      'Follows Hud 11:84–95, al-A’raf 7:85–93 and ash-Shu’ara 26:176–191.',
  audioFileName: 'prophet_shuayb_bedtime_v1.mp3',
  tags: const ['prophet', 'shuayb', 'madyan', 'honesty', 'scales', 'fairness'],
  sortOrder: 55,
  coverAssetPath: '$bedtimeStoryImageCoverAssetDirectory/shuayb_cover.webp',
  backdropAssetPath:
      '$bedtimeStoryImageBackdropAssetDirectory/shuayb_backdrop.webp',
  relatedStoryIds: const [
    'story_prophet_musa_bedtime_v1',
    'story_telling_the_truth_v1',
  ],
  spreads: const [
    KidsBookSpread(
      [
        'In a town called Madyan, people loved their markets.',
        'But they cheated when they weighed and measured.',
      ],
      illustrationAsset: '$_scenes/shuayb_market.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 85),
    ),
    KidsBookSpread(
      [
        'They gave less than they should, and took more than they should.',
        'They thought nobody noticed.',
      ],
      illustrationAsset: '$_scenes/shuayb_scales.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 84),
    ),
    KidsBookSpread(
      [
        'Allah sent them Prophet Shuayb, peace be upon him.',
        '"Worship Allah alone," he said, "and weigh it fairly."',
      ],
      illustrationAsset: '$_scenes/shuayb_market.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 11, ayah: 85),
    ),
    KidsBookSpread(
      [
        '"Do not cheat people out of their things," said Shuayb.',
        '"What Allah leaves you is better, if you believe."',
      ],
      illustrationAsset: '$_scenes/shuayb_scales.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 86),
    ),
    KidsBookSpread(
      [
        'The rich people laughed.',
        '"Does your prayer tell you what we may do with our money?"',
      ],
      illustrationAsset: '$_scenes/shuayb_trees.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 87),
    ),
    KidsBookSpread(
      [
        'Shuayb stayed gentle and patient.',
        '"I only want to make things right," he said.',
      ],
      illustrationAsset: '$_scenes/shuayb_trees.webp',
      quranRef: QuranQuoteRef(surah: 11, ayah: 88),
    ),
    KidsBookSpread(
      [
        'Some believed him. Most did not.',
        'They said: leave our town, Shuayb!',
      ],
      illustrationAsset: '$_scenes/shuayb_market.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 88),
    ),
    KidsBookSpread(
      [
        'Then a great shaking came, and the cheaters’ town fell silent.',
        'Shuayb and the believers were safe.',
      ],
      illustrationAsset: '$_scenes/shuayb_shade_day.webp',
      quranRef: QuranQuoteRef(surah: 7, ayah: 91),
    ),
    KidsBookSpread(
      [
        'Being fair is not small. Allah cares about every gram.',
        'Weigh it fairly.',
      ],
      illustrationAsset: '$_scenes/shuayb_fair.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 55, ayah: 9),
    ),
    KidsBookSpread(
      [
        'When you share, share fairly. When you trade, trade fairly.',
        'Weigh it fairly.',
      ],
      illustrationAsset: '$_scenes/shuayb_fair.webp',
      isRefrain: true,
    ),
  ],
);
