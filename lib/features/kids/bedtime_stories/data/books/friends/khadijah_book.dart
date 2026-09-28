import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Khadijah, the First to Believe. Bukhari 3 (the first revelation) and
/// Bukhari 3820 (her house in Jannah). Keeps the legacy id: the seerah
/// journey and the Friends shelf point at it.
final BedtimeStorySeed khadijahBook = kidsPictureBook(
  id: 'story_companion_khadijah_support_v1',
  storyFamilyId: 'companion_khadijah',
  title: 'Khadijah, the First to Believe',
  shortTitle: 'Khadijah',
  summary:
      'A wise woman with caravans, a trustworthy young man, and the night '
      'she wrapped him in a blanket and believed.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [
    KidsIslamicStoryTheme.truthfulness,
    KidsIslamicStoryTheme.family,
    KidsIslamicStoryTheme.kindness,
  ],
  refrain: 'She believed in him.',
  lesson:
      'When someone tells the truth, stand beside them. Khadijah believed '
      'first, and stayed.',
  bedtimeClosing:
      'Now close your eyes. Somebody believes in you, just as Khadijah '
      'believed. Good night.',
  quranQuote: 'Read in the name of your Lord who created.',
  quranReference: 'Qur’an 96:1',
  quranQuoteRef: const QuranQuoteRef(surah: 96, ayah: 1),
  hadithQuote:
      'Never! By Allah, Allah will never disgrace you. You keep good '
      'relations with your family, you carry the weak, you give to the '
      'poor, and you welcome guests.',
  hadithReference: 'Sahih al-Bukhari 3',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'Follows Sahih al-Bukhari 3 (the first revelation) and 3820 (salam '
      'from Allah and a house in Jannah). The caravan and marriage are '
      'from the seerah.',
  tags: const ['companion', 'khadijah', 'seerah', 'support', 'belief'],
  sortOrder: 245,
  isFeatured: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/companion_khadijah_cover.webp',
  relatedStoryIds: const [
    'story_prophet_muhammad_part2_bedtime_v1',
    'story_companion_abu_bakr_friendship_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Khadija, die als Erste glaubte',
    shortTitle: 'Khadija',
    summary:
        'Eine weise Frau mit Karawanen, ein ehrlicher junger Mann und die Nacht, in der sie ihn in eine Decke hüllte und glaubte.',
    lesson:
        'Wenn jemand die Wahrheit sagt, steh ihm zur Seite. Khadija glaubte als Erste, und sie blieb.',
    refrain: 'Sie glaubte an ihn.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Jemand glaubt an dich, so wie Khadija glaubte. Gute Nacht.',
    spreads: [
      [
        'In Mekka lebte eine gütige und weise Frau namens Khadija.',
        'Ihre Karawanen trugen Waren weit und breit.',
      ],
      [
        'Sie hörte von einem jungen Mann, der nie log.',
        'Die Leute nannten ihn al-Amin, den Vertrauenswürdigen.',
      ],
      [
        'Sie bat ihn, ihre Waren nach Syrien zu bringen.',
        'Er kam zurück, ehrlich und gütig.',
      ],
      [
        'Khadija heiratete ihn. Sie war seine beste Freundin.',
        'Später wählte Allah ihn zu Seinem Propheten ﷺ.',
      ],
      [
        'Eines Nachts, in einer Höhle auf dem Berg, kam der Engel Dschibril.',
        'Er sagte: Lies!',
      ],
      [
        'Der Prophet ﷺ eilte zitternd nach Hause. „Hüllt mich ein!“',
        'Khadija wickelte ihn in eine Decke.',
      ],
      [
        '„Niemals!“, sagte sie. „Allah wird dich nie im Stich lassen.“',
        '„Du bist gut zu deiner Familie, zu Gästen, zu den Armen.“',
      ],
      [
        'Sie glaubte an ihn.',
        'Vor allen anderen auf der Welt glaubte Khadija.',
      ],
      [
        'Als die schweren Jahre kamen, stand sie an seiner Seite.',
        'Sie glaubte an ihn.',
      ],
      [
        'Dschibril brachte ihr Salam von Allah,',
        'und die Nachricht von einem Haus im Paradies aus Perlen.',
      ],
      [
        'Wenn jemand die Wahrheit sagt, mach es wie Khadija.',
        'Sie glaubte an ihn.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'In Makkah lived a kind and wise woman called Khadijah.',
      'Her caravans carried goods far and wide.',
    ], illustrationAsset: '$_scenes/muhammad_caravan.webp'),
    KidsBookSpread([
      'She heard of a young man who never lied.',
      'People called him al-Amin, the trustworthy.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_morning.webp'),
    KidsBookSpread([
      'She asked him to take her goods to Syria.',
      'He came back honest, and kind.',
    ], illustrationAsset: '$_scenes/muhammad_caravan.webp'),
    KidsBookSpread([
      'Khadijah married him. She was his best friend.',
      'Later, Allah chose him as His Prophet ﷺ.',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread(
      [
        'One night, in a cave on the mountain, the angel Jibril came.',
        'He said: Read!',
      ],
      illustrationAsset: '$_scenes/muhammad_hira_night.webp',
      quranRef: QuranQuoteRef(surah: 96, ayah: 1),
    ),
    KidsBookSpread([
      'The Prophet ﷺ hurried home, shaking. "Wrap me up!"',
      'Khadijah wrapped him in a blanket.',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread([
      '"Never!" she said. "Allah will never let you down."',
      '"You are good to family, to guests, to the poor."',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread(
      [
        'She believed in him.',
        'Before anyone else in the world, Khadijah believed.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'When the hard years came, she stood beside him.',
        'She believed in him.',
      ],
      illustrationAsset: '$_scenes/muhammad_patience_dawn.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Jibril brought her salam from Allah,',
      'and news of a home in Jannah made of pearl.',
    ], illustrationAsset: '$_scenes/steps_jannah_door.webp'),
    KidsBookSpread(
      [
        'When someone tells the truth, be like Khadijah.',
        'She believed in him.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
    ),
  ],
);
