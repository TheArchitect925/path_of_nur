import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Luqman Talks to His Son. Surah Luqman 31:12–19.
final BedtimeStorySeed luqmanBook = kidsPictureBook(
  id: 'book_quran_luqman_v1',
  storyFamilyId: 'quran_luqman',
  title: 'Luqman Talks to His Son',
  shortTitle: 'Luqman',
  summary:
      'A wise father, a son under a tree, and the advice Allah kept in the '
      'Qur’an for all of us.',
  category: BedtimeStoryCategory.quranStories,
  collectionType: KidsIslamicStoryCollectionType.quranStories,
  storyType: KidsIslamicStoryType.quranStory,
  themes: const [KidsIslamicStoryTheme.manners, KidsIslamicStoryTheme.family],
  refrain: 'O my son.',
  lesson:
      'Worship Allah alone, honor your parents, pray, be patient, and walk '
      'gently.',
  bedtimeClosing:
      'Now close your eyes. Walk gently, speak softly, and sleep well. Good '
      'night.',
  quranQuote:
      'O my son, do not associate anything with Allah. Indeed, association '
      'with Him is great injustice.',
  quranReference: 'Qur’an 31:13',
  quranQuoteRef: const QuranQuoteRef(surah: 31, ayah: 13),
  sourceNote: 'Follows Luqman 31:12–19.',
  tags: const ['quran story', 'luqman', 'wisdom', 'parents', 'manners'],
  sortOrder: 402,
  coverAssetPath: 'assets/images/kids_books/covers/luqman_cover.webp',
  relatedStoryIds: const ['story_helping_parents_v1', 'story_patience_v1'],
  de: const KidsBookTranslation(
    title: 'Luqman spricht mit seinem Sohn',
    shortTitle: 'Luqman',
    summary:
        'Ein weiser Vater, ein Sohn unter einem Baum und der Rat, den Allah im Quran für uns alle aufbewahrt hat.',
    lesson:
        'Bete Allah allein an, ehre deine Eltern, bete, sei geduldig und geh sanft.',
    refrain: 'O mein Sohn.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Geh sanft, sprich leise, und schlaf gut. Gute Nacht.',
    spreads: [
      [
        'Luqman war ein weiser Mann. Allah hatte ihm Weisheit geschenkt.',
        'Eines Tages saß er mit seinem Sohn unter einem Baum.',
      ],
      [
        '„O mein Sohn“, sagte er, „stell niemals etwas Allah gleich.“',
        '„Allah ist Einer.“',
      ],
      [
        '„Sei gut zu deiner Mutter und deinem Vater.',
        'Deine Mutter trug dich und wurde schwach, um dir das Leben zu schenken.“',
      ],
      [
        '„O mein Sohn, selbst eine Tat so klein wie ein Senfkorn,',
        'versteckt in einem Felsen, bringt Allah ans Licht.“',
      ],
      [
        '„Bete. Sag den Menschen, Gutes zu tun. Halt auf, was falsch ist.',
        'Und sei geduldig, wenn schwere Dinge passieren.“',
      ],
      [
        '„Dreh den Menschen nicht die Wange weg, und geh nicht stolz umher.',
        'Allah liebt keine Angeber.“',
      ],
      [
        '„Geh sanft. Sprich leise.',
        'Die lauteste Stimme von allen ist die des Esels.“',
      ],
      [
        'Der Sohn hörte auf jedes Wort.',
        'Und Allah schrieb Luqmans Worte in den Quran, für uns alle.',
      ],
      [
        'Geh sanft. Sprich leise. Bete. Sei geduldig.',
        'O mein Sohn, o meine Tochter: Das ist auch für dich.',
      ],
      ['Welches von Luqmans Worten nimmst du heute mit?', 'Such dir eins aus.'],
    ],
  ),
  spreads: const [
    KidsBookSpread(
      [
        'Luqman was a wise man. Allah gave him wisdom.',
        'One day he sat with his son under a tree.',
      ],
      illustrationAsset: '$_scenes/luqman_tree_shade.webp',
      quranRef: QuranQuoteRef(surah: 31, ayah: 12),
    ),
    KidsBookSpread(
      [
        '"O my son," he said, "never make anything equal to Allah."',
        '"Allah is One."',
      ],
      illustrationAsset: '$_scenes/luqman_tree_shade.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 31, ayah: 13),
    ),
    KidsBookSpread(
      [
        '"Be good to your mother and father.',
        'Your mother carried you, and grew weak, to give you life."',
      ],
      atlasScene: KidsBookAtlasScene.home,
      quranRef: QuranQuoteRef(surah: 31, ayah: 14),
    ),
    KidsBookSpread(
      [
        '"O my son, even a deed as small as a mustard seed,',
        'hidden in a rock, Allah brings it out."',
      ],
      illustrationAsset: '$_scenes/luqman_mustard_seed.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 31, ayah: 16),
    ),
    KidsBookSpread(
      [
        '"Pray. Tell people to do good. Stop what is wrong.',
        'And be patient when hard things happen."',
      ],
      atlasScene: KidsBookAtlasScene.masjid,
      quranRef: QuranQuoteRef(surah: 31, ayah: 17),
    ),
    KidsBookSpread(
      [
        '"Do not turn your cheek away from people, and do not walk proudly.',
        'Allah does not love show-offs."',
      ],
      illustrationAsset: '$_scenes/luqman_mountain.webp',
      quranRef: QuranQuoteRef(surah: 31, ayah: 18),
    ),
    KidsBookSpread(
      [
        '"Walk gently. Speak softly.',
        'The loudest voice of all is the donkey’s."',
      ],
      illustrationAsset: '$_scenes/luqman_donkey.webp',
      quranRef: QuranQuoteRef(surah: 31, ayah: 19),
    ),
    KidsBookSpread([
      'The son listened to every word.',
      'And Allah put Luqman’s words in the Qur’an, for all of us.',
    ], illustrationAsset: '$_scenes/luqman_tree_shade.webp'),
    KidsBookSpread(
      [
        'Walk gently. Speak softly. Pray. Be patient.',
        'O my son, O my daughter: this is for you too.',
      ],
      illustrationAsset: '$_scenes/luqman_mountain.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Which of Luqman’s words will you keep today?',
      'Pick one.',
    ], illustrationAsset: '$_scenes/luqman_mustard_seed.webp'),
  ],
);
