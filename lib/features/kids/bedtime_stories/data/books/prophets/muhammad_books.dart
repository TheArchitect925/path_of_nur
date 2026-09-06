import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../../bedtime_story_media_manifest.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';
const String _cover =
    '$bedtimeStoryImageCoverAssetDirectory/muhammad_cover.webp';
const String _backdrop =
    '$bedtimeStoryImageBackdropAssetDirectory/muhammad_backdrop.webp';
const String _p1 = 'story_prophet_muhammad_part1_bedtime_v1';
const String _p2 = 'story_prophet_muhammad_part2_bedtime_v1';
const String _p3 = 'story_prophet_muhammad_part3_bedtime_v1';
const String _p4 = 'story_prophet_muhammad_part4_bedtime_v1';

/// Our Prophet ﷺ, in four books for the plus band. The seerah is told
/// through what he saw: Makkah, the cave, the road, the city. He is never
/// drawn. The pictures are the K3 scenes the four parts already had.

/// Part 1: The Trustworthy One. Surah ad-Duha 93:6–8 and the early seerah.
final BedtimeStorySeed muhammadBook1 = kidsPictureBook(
  id: _p1,
  prophetId: 'muhammad',
  title: 'Our Prophet ﷺ: The Trustworthy One',
  shortTitle: 'Muhammad ﷺ Part 1',
  summary:
      'An orphan in Makkah who grew up so honest that everyone called him '
      'the trustworthy one.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [KidsIslamicStoryTheme.honesty, KidsIslamicStoryTheme.kindness],
  ageGroup: BedtimeStoryAgeGroup.kidsPlus,
  refrain: 'Honest and kind, always.',
  lesson: 'Be honest and kind. Even when life is hard, Allah is with you.',
  bedtimeClosing:
      'Now close your eyes. Allah was with the orphan boy, and Allah is '
      'with you. Good night.',
  quranQuote: 'And indeed, you are of a great moral character.',
  quranReference: 'Qur’an 68:4',
  quranQuoteRef: const QuranQuoteRef(surah: 68, ayah: 4),
  sourceNote:
      'Follows ad-Duha 93:6–8 and the seerah of Ibn Hisham; the years as a '
      'shepherd are in Sahih al-Bukhari 2262.',
  audioFileName: 'prophet_muhammad_part1_bedtime_v1.mp3',
  tags: const ['prophet', 'muhammad', 'childhood', 'makkah', 'character'],
  sortOrder: 110,
  isFeatured: true,
  partNumber: 1,
  totalParts: 4,
  coverAssetPath: _cover,
  backdropAssetPath: _backdrop,
  relatedStoryIds: const [_p2],
  spreads: const [
    KidsBookSpread([
      'In the city of Makkah a special baby was born.',
      'His name was Muhammad, peace and blessings be upon him.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_morning.webp'),
    KidsBookSpread(
      [
        'His father died before he was born.',
        'His mother died when he was six.',
        'He was an orphan.',
      ],
      illustrationAsset: '$_scenes/muhammad_orphan_home.webp',
      quranRef: QuranQuoteRef(surah: 93, ayah: 6),
    ),
    KidsBookSpread([
      'But he was never alone. Allah was with him.',
      'His grandfather cared for him, then his uncle Abu Talib.',
    ], illustrationAsset: '$_scenes/muhammad_orphan_home.webp'),
    KidsBookSpread(
      [
        'As a boy he looked after sheep on the hills of Makkah.',
        'Honest and kind, always.',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      isRefrain: true,
    ),
    KidsBookSpread([
      'When he grew up he became a trader.',
      'He never cheated. He never lied.',
    ], illustrationAsset: '$_scenes/muhammad_caravan.webp'),
    KidsBookSpread(
      [
        'People trusted him so much they called him Al-Ameen, the trustworthy one.',
        'Honest and kind, always.',
      ],
      illustrationAsset: '$_scenes/muhammad_caravan.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'A noble woman, Khadijah, asked him to trade for her.',
      'She saw his honesty, and later they were married.',
    ], atlasScene: KidsBookAtlasScene.cityMorning),
    KidsBookSpread([
      'The people of Makkah bowed to statues.',
      'Muhammad ﷺ never did. He loved the truth.',
    ], atlasScene: KidsBookAtlasScene.cityNight),
    KidsBookSpread([
      'He liked to climb to a quiet cave called Hira.',
      'There he sat, thought, and remembered Allah.',
    ], illustrationAsset: '$_scenes/muhammad_hira_night.webp'),
    KidsBookSpread([
      'Allah was preparing him for something very important.',
      'Something the whole world would hear.',
    ], illustrationAsset: '$_scenes/muhammad_hira_night.webp'),
    KidsBookSpread(
      ['Be like him at home and at school.', 'Honest and kind, always.'],
      atlasScene: KidsBookAtlasScene.daySky,
      isRefrain: true,
    ),
  ],
);

/// Part 2: Read. Surah al-Alaq 96:1–5 and Sahih al-Bukhari 3.
final BedtimeStorySeed muhammadBook2 = kidsPictureBook(
  id: _p2,
  prophetId: 'muhammad',
  title: 'Our Prophet ﷺ: Read!',
  shortTitle: 'Muhammad ﷺ Part 2',
  summary: 'A cave, an angel, and the first word of the Qur’an: Read.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.patience,
    KidsIslamicStoryTheme.trustInAllah,
  ],
  ageGroup: BedtimeStoryAgeGroup.kidsPlus,
  refrain: 'Read, in the name of your Lord.',
  lesson: 'Stand for what is right, be patient, and let kindness lead the way.',
  bedtimeClosing:
      'Now close your eyes. The first word was Read, and tomorrow you can '
      'read again. Good night.',
  quranQuote: 'Read in the name of your Lord who created.',
  quranReference: 'Qur’an 96:1',
  quranQuoteRef: const QuranQuoteRef(surah: 96, ayah: 1),
  sourceNote:
      'Follows al-Alaq 96:1–5; the first revelation and Khadijah’s words '
      'are in Sahih al-Bukhari 3.',
  audioFileName: 'prophet_muhammad_part2_bedtime_v1.mp3',
  tags: const ['prophet', 'muhammad', 'revelation', 'quran', 'patience'],
  sortOrder: 120,
  partNumber: 2,
  totalParts: 4,
  coverAssetPath: _cover,
  backdropAssetPath: _backdrop,
  relatedStoryIds: const [_p1, _p3],
  spreads: const [
    KidsBookSpread([
      'Muhammad ﷺ was forty years old.',
      'One night in the cave of Hira, an angel came.',
    ], illustrationAsset: '$_scenes/muhammad_cave_light.webp'),
    KidsBookSpread([
      'It was Jibreel, the angel of Allah.',
      'He said: "Read!"',
    ], illustrationAsset: '$_scenes/muhammad_cave_light.webp'),
    KidsBookSpread(
      [
        '"I cannot read," said Muhammad ﷺ.',
        'The angel held him and said again: "Read, in the name of your Lord."',
      ],
      illustrationAsset: '$_scenes/muhammad_cave_light.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 96, ayah: 1),
    ),
    KidsBookSpread(
      [
        'These were the first words of the Qur’an.',
        'Allah’s own words, sent to the last prophet.',
      ],
      atlasScene: KidsBookAtlasScene.nightSky,
      quranRef: QuranQuoteRef(surah: 96, ayah: 3),
    ),
    KidsBookSpread([
      'He hurried home, shaking. "Cover me, cover me!"',
      'Khadijah wrapped him in a blanket.',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread([
      '"Allah will never let you down," she said. "You are kind to everyone."',
      'She believed in him first.',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread([
      'Quietly, he told his family and his close friends.',
      'Abu Bakr believed. Ali believed. Bilal believed.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_night.webp'),
    KidsBookSpread([
      'Many people in Makkah were angry.',
      'They laughed at him, and hurt the believers.',
    ], illustrationAsset: '$_scenes/muhammad_makkah_night.webp'),
    KidsBookSpread(
      [
        'He stayed patient. He stayed kind.',
        'Slowly, more people believed. Read, in the name of your Lord.',
      ],
      illustrationAsset: '$_scenes/muhammad_patience_dawn.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Year after year the words of the Qur’an came,',
      'and the Prophet ﷺ taught every one of them.',
    ], illustrationAsset: '$_scenes/muhammad_patience_dawn.webp'),
    KidsBookSpread(
      [
        'When you open the Qur’an, remember the cave.',
        'Read, in the name of your Lord.',
      ],
      atlasScene: KidsBookAtlasScene.masjid,
      isRefrain: true,
    ),
  ],
);

/// Part 3: The Journey to Madinah. Surah at-Tawbah 9:40 and the Hijrah in
/// Sahih al-Bukhari 3905.
final BedtimeStorySeed muhammadBook3 = kidsPictureBook(
  id: _p3,
  prophetId: 'muhammad',
  title: 'Our Prophet ﷺ: The Journey to Madinah',
  shortTitle: 'Muhammad ﷺ Part 3',
  summary: 'A cave, a spider’s web, and the journey that made Madinah a home.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.trustInAllah,
    KidsIslamicStoryTheme.helpingOthers,
  ],
  ageGroup: BedtimeStoryAgeGroup.kidsPlus,
  refrain: 'Do not be sad. Allah is with us.',
  lesson: 'Trust Allah in hard times, help others, and be gentle and fair.',
  bedtimeClosing:
      'Now close your eyes. Allah was with them in the cave, and Allah is '
      'with you. Good night.',
  quranQuote: 'Do not grieve; indeed Allah is with us.',
  quranReference: 'Qur’an 9:40',
  quranQuoteRef: const QuranQuoteRef(surah: 9, ayah: 40),
  sourceNote:
      'Follows at-Tawbah 9:40 and the Hijrah in Sahih al-Bukhari 3905; the '
      'spider and the dove are from the seerah, not the Qur’an.',
  audioFileName: 'prophet_muhammad_part3_bedtime_v1.mp3',
  tags: const ['prophet', 'muhammad', 'hijrah', 'madinah', 'community'],
  sortOrder: 130,
  recommendedForTonight: true,
  partNumber: 3,
  totalParts: 4,
  coverAssetPath: _cover,
  backdropAssetPath: _backdrop,
  relatedStoryIds: const [_p2, _p4],
  spreads: const [
    KidsBookSpread([
      'After thirteen years, Makkah was not safe.',
      'Allah told the Prophet ﷺ: go to Madinah.',
    ], atlasScene: KidsBookAtlasScene.cityNight),
    KidsBookSpread([
      'This journey is called the Hijrah.',
      'The Prophet ﷺ left at night with his friend Abu Bakr.',
    ], atlasScene: KidsBookAtlasScene.desertRoad),
    KidsBookSpread([
      'Men from Makkah came looking for them.',
      'So the two friends hid in a cave on Mount Thawr.',
    ], illustrationAsset: '$_scenes/muhammad_thawr_cave.webp'),
    KidsBookSpread([
      'A spider spun a web over the door.',
      'A dove built a nest beside it.',
    ], illustrationAsset: '$_scenes/muhammad_thawr_cave.webp'),
    KidsBookSpread([
      'The men came right up to the cave.',
      'Abu Bakr whispered: they will see us!',
    ], illustrationAsset: '$_scenes/muhammad_thawr_cave.webp'),
    KidsBookSpread(
      [
        'The Prophet ﷺ said: "Do not be sad. Allah is with us."',
        'And the men walked away.',
      ],
      illustrationAsset: '$_scenes/muhammad_thawr_cave.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 9, ayah: 40),
    ),
    KidsBookSpread(
      [
        'They rode across the desert for days.',
        'Do not be sad. Allah is with us.',
      ],
      atlasScene: KidsBookAtlasScene.desertRoad,
      isRefrain: true,
    ),
    KidsBookSpread([
      'The people of Madinah waited on the rooftops.',
      'When they saw him, they sang with joy.',
    ], illustrationAsset: '$_scenes/muhammad_madinah_welcome.webp'),
    KidsBookSpread([
      'Everyone wanted him in their house.',
      '"Let my camel choose," he said. It knelt at Abu Ayyub’s door.',
    ], illustrationAsset: '$_scenes/muhammad_madinah_welcome.webp'),
    KidsBookSpread([
      'They built a masjid together, carrying bricks side by side.',
      'The Prophet ﷺ carried bricks too.',
    ], atlasScene: KidsBookAtlasScene.masjid),
    KidsBookSpread(
      [
        'In Madinah, the believers became one family.',
        'The rich helped the poor, and the strong helped the weak.',
      ],
      atlasScene: KidsBookAtlasScene.masjid,
      quranRef: QuranQuoteRef(surah: 59, ayah: 9),
    ),
    KidsBookSpread(
      [
        'When you feel afraid, say what he said in the cave.',
        'Do not be sad. Allah is with us.',
      ],
      illustrationAsset: '$_scenes/muhammad_thawr_cave.webp',
      isRefrain: true,
    ),
  ],
);

/// Part 4: The City of Mercy. Surah al-Anbiya 21:107, at-Tawbah 9:128, the
/// conquest of Makkah and the farewell sermon (Sahih Muslim 1218).
final BedtimeStorySeed muhammadBook4 = kidsPictureBook(
  id: _p4,
  prophetId: 'muhammad',
  title: 'Our Prophet ﷺ: A Mercy to the Worlds',
  shortTitle: 'Muhammad ﷺ Part 4',
  summary:
      'The return to Makkah, the words "You are all free", and a mercy that '
      'reached the whole world.',
  category: BedtimeStoryCategory.prophets,
  collectionType: KidsIslamicStoryCollectionType.prophets,
  storyType: KidsIslamicStoryType.prophet,
  themes: const [
    KidsIslamicStoryTheme.forgiveness,
    KidsIslamicStoryTheme.kindness,
  ],
  ageGroup: BedtimeStoryAgeGroup.kidsPlus,
  refrain: 'A mercy to the worlds.',
  lesson:
      'Forgive others, be kind, be fair, and follow the beautiful example of '
      'the Prophet ﷺ.',
  bedtimeClosing:
      'Now close your eyes. He forgave, he smiled, and he loved you before '
      'you were born. Good night.',
  quranQuote:
      'There has certainly come to you a Messenger from among yourselves. '
      'Grievous to him is what you suffer; he is concerned over you and to '
      'the believers is kind and merciful.',
  quranReference: 'Qur’an 9:128',
  quranQuoteRef: const QuranQuoteRef(surah: 9, ayah: 128),
  sourceNote:
      'Follows al-Anbiya 21:107 and at-Tawbah 9:128; the conquest of Makkah '
      'and the farewell sermon are in Sahih al-Bukhari and Sahih Muslim '
      '1218; his longing for the believers who would come later is in Sahih '
      'Muslim 249.',
  audioFileName: 'prophet_muhammad_part4_bedtime_v1.mp3',
  tags: const ['prophet', 'muhammad', 'mercy', 'forgiveness', 'makkah'],
  sortOrder: 140,
  partNumber: 4,
  totalParts: 4,
  coverAssetPath: _cover,
  backdropAssetPath: _backdrop,
  relatedStoryIds: const [_p3, 'story_prophet_yusuf_bedtime_v1'],
  spreads: const [
    KidsBookSpread([
      'Years later, the Prophet ﷺ returned to Makkah.',
      'Not with anger. With ten thousand believers, and with peace.',
    ], illustrationAsset: '$_scenes/muhammad_return_makkah.webp'),
    KidsBookSpread([
      'The people who had hurt him waited, afraid.',
      'What would he do to them?',
    ], illustrationAsset: '$_scenes/muhammad_return_makkah.webp'),
    KidsBookSpread(
      [
        'He said: "Go. You are all free."',
        'He forgave them. A mercy to the worlds.',
      ],
      illustrationAsset: '$_scenes/muhammad_mercy_doves.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 21, ayah: 107),
    ),
    KidsBookSpread(
      [
        'He went into the Kaʿbah and took down the statues.',
        'Makkah worshipped Allah alone again.',
      ],
      illustrationAsset: '$_scenes/pillars_kaaba.webp',
      quranRef: QuranQuoteRef(surah: 17, ayah: 81),
    ),
    KidsBookSpread([
      'He was gentle with children and kind to animals.',
      'He smiled more than anyone.',
    ], illustrationAsset: '$_scenes/muhammad_mercy_doves.webp'),
    KidsBookSpread(
      [
        'He said: the best of you are the best to their families.',
        'A mercy to the worlds.',
      ],
      atlasScene: KidsBookAtlasScene.homeEvening,
      isRefrain: true,
    ),
    KidsBookSpread([
      'Near the end, he spoke to everyone at Hajj.',
      '"I leave you the Qur’an. Hold on to it."',
    ], atlasScene: KidsBookAtlasScene.daySky),
    KidsBookSpread([
      '"Your Lord is one. Your father is one.',
      'No one is better than another, except by good deeds."',
    ], atlasScene: KidsBookAtlasScene.daySky),
    KidsBookSpread([
      'Then the Prophet ﷺ died, and Madinah cried.',
      'But his message did not end.',
    ], atlasScene: KidsBookAtlasScene.cityNight),
    KidsBookSpread(
      [
        'Today, all around the world, hearts still say his name with love.',
        'A mercy to the worlds.',
      ],
      illustrationAsset: '$_scenes/muhammad_lights_world.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 21, ayah: 107),
    ),
    KidsBookSpread([
      'Follow him: forgive, be kind, be fair.',
      'Hold on to the Qur’an.',
    ], illustrationAsset: '$_scenes/muhammad_lights_world.webp'),
  ],
);
