import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Fatimah and the Bedtime Words. Bukhari 5361 (the tasbih before sleep),
/// 3714 (a part of me) and 3624 (leader of the women of Jannah).
final BedtimeStorySeed fatimahBook = kidsPictureBook(
  id: 'story_companion_fatimah_v1',
  storyFamilyId: 'companion_fatimah',
  title: 'Fatimah and the Bedtime Words',
  shortTitle: 'Fatimah',
  summary:
      'Sore hands from the mill, a wish for a helper, and the words her '
      'father gave her instead.',
  category: BedtimeStoryCategory.companions,
  collectionType: KidsIslamicStoryCollectionType.companions,
  storyType: KidsIslamicStoryType.companion,
  themes: const [KidsIslamicStoryTheme.dua, KidsIslamicStoryTheme.family],
  refrain: 'Better than a helper.',
  lesson:
      'Before you sleep, say SubhanAllah, Alhamdulillah and Allahu Akbar. '
      'They make you strong.',
  bedtimeClosing:
      'Now close your eyes and say them: SubhanAllah, Alhamdulillah, Allahu '
      'Akbar. Good night.',
  hadithQuote:
      'Shall I not tell you of something better than a servant? When you '
      'go to bed, say SubhanAllah thirty-three times, Alhamdulillah '
      'thirty-three times and Allahu Akbar thirty-four times.',
  hadithReference: 'Sahih al-Bukhari 5361',
  sourceCategory: KidsIslamicStorySourceCategory.hadith,
  sourceNote:
      'Follows Sahih al-Bukhari 5361 (also Sahih Muslim 2727), 3714 and '
      '3624.',
  tags: const ['companion', 'fatimah', 'dhikr', 'bedtime', 'family'],
  sortOrder: 249,
  recommendedForTonight: true,
  coverAssetPath:
      'assets/images/kids_stories/covers/companion_fatimah_cover.webp',
  relatedStoryIds: const [
    'story_companion_ali_bed_v1',
    'story_companion_khadijah_support_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Fatima und die Worte vor dem Schlafen',
    shortTitle: 'Fatima',
    summary:
        'Wunde Hände von der Mühle, ein Wunsch nach Hilfe und die Worte, die ihr Vater ihr stattdessen gab.',
    lesson:
        'Sag vor dem Schlafen SubhanAllah, Alhamdulillah und Allahu Akbar. Sie machen dich stark.',
    refrain: 'Besser als eine Hilfe.',
    bedtimeClosing:
        'Jetzt mach die Augen zu und sag sie: SubhanAllah, Alhamdulillah, Allahu Akbar. Gute Nacht.',
    spreads: [
      [
        'Fatima war die jüngste Tochter des Propheten ﷺ.',
        'Er liebte sie so sehr, dass er sie ein Stück von sich nannte.',
      ],
      [
        'Fatima arbeitete hart zu Hause.',
        'Sie mahlte Mehl mit der Hand, bis ihre Hände wehtaten.',
      ],
      [
        'Sie trug Wasser in einem Schlauch, bis ihre Schulter schmerzte.',
        'Das Haus war voller Arbeit.',
      ],
      [
        'Eines Tages hörte sie, ihr Vater habe Helfer zu verteilen.',
        'Sie ging hin, um um einen zu bitten.',
      ],
      [
        'Am Abend kam er, als Fatima und Ali im Bett lagen.',
        '„Soll ich euch etwas sagen, das besser als eine Hilfe ist?“',
      ],
      [
        '„Wenn ihr ins Bett geht, sagt dreiunddreißigmal SubhanAllah.“',
        '„Dreiunddreißigmal Alhamdulillah. Vierunddreißigmal Allahu Akbar.“',
      ],
      [
        '„Das ist besser als eine Hilfe für euch.“',
        'Fatima lächelte. Sie vergaß diese Worte nie.',
      ],
      [
        'Jede Nacht sagte sie sie, und jede Nacht fühlte sie sich stark.',
        'Allahs Worte waren ihre Ruhe.',
      ],
      [
        'Fatima ist eine der besten Frauen, die je gelebt haben.',
        'Ihr Vater sagte, sie führt die Frauen im Paradies an.',
      ],
      [
        'Heute Nacht, wenn dein Kopf auf dem Kissen liegt, sag sie auch.',
        'Besser als eine Hilfe.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'Fatimah was the Prophet’s ﷺ youngest daughter.',
      'He loved her so much that he called her a part of himself.',
    ], illustrationAsset: '$_scenes/muhammad_home_comfort.webp'),
    KidsBookSpread([
      'Fatimah worked hard at home.',
      'She ground flour by hand until her hands hurt.',
    ], illustrationAsset: '$_scenes/fatimah_millstone.webp'),
    KidsBookSpread([
      'She carried water in a skin until her shoulder ached.',
      'The house was full of work.',
    ], illustrationAsset: '$_scenes/fatimah_millstone.webp'),
    KidsBookSpread([
      'One day she heard her father had some helpers to share.',
      'She went to ask for one.',
    ], illustrationAsset: '$_scenes/muhammad_madinah_welcome.webp'),
    KidsBookSpread(
      [
        'That evening he came, as Fatimah and Ali lay in bed.',
        '"Shall I tell you something better than a helper?"',
      ],
      illustrationAsset: '$_scenes/fatimah_bedtime_words.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        '"When you go to bed, say SubhanAllah thirty-three times."',
        '"Alhamdulillah thirty-three. Allahu Akbar thirty-four."',
      ],
      illustrationAsset: '$_scenes/fatimah_bedtime_words.webp',
      arabicLine: 'سُبْحَانَ ٱللَّٰهِ · ٱلْحَمْدُ لِلَّٰهِ · ٱللَّٰهُ أَكْبَرُ',
    ),
    KidsBookSpread(
      [
        '"That is better than a helper for you."',
        'Fatimah smiled. She never forgot those words.',
      ],
      illustrationAsset: '$_scenes/fatimah_bedtime_words.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Every night she said them, and every night she felt strong.',
      'Allah’s words were her rest.',
    ], atlasScene: KidsBookAtlasScene.bedroom),
    KidsBookSpread([
      'Fatimah is one of the best women who ever lived.',
      'Her father said she leads the women of Jannah.',
    ], illustrationAsset: '$_scenes/steps_jannah_door.webp'),
    KidsBookSpread(
      [
        'Tonight, when your head is on the pillow, say them too.',
        'Better than a helper.',
      ],
      atlasScene: KidsBookAtlasScene.bedroom,
      isRefrain: true,
      tryItRoute: '/worship/dhikr',
    ),
  ],
);
