import 'package:flutter/material.dart';

import '../domain/creation_explorer_models.dart';

const creationExplorerCategories = <CreationCategory>[
  CreationCategory(
    id: CreationCategoryId.animals,
    name: 'Animals',
    icon: Icons.pets_rounded,
    parentCategory: CreationParentCategory.animals,
    description:
        'Living creatures moving through the earth are signs of care, order, and dependence on Allah.',
    verseIds: <String>['creation_animals_638', 'creation_animals_451'],
    tags: <String>['animals', 'creation', 'mercy'],
    colorTheme: Color(0xFF73A77E),
  ),
  CreationCategory(
    id: CreationCategoryId.birds,
    name: 'Birds',
    icon: Icons.flutter_dash_rounded,
    parentCategory: CreationParentCategory.animals,
    description:
        'Birds remind the heart of movement, balance, and praise in the open sky.',
    verseIds: <String>['creation_birds_2441', 'creation_birds_1679'],
    tags: <String>['birds', 'flight', 'sky'],
    colorTheme: Color(0xFF7AA8C5),
  ),
  CreationCategory(
    id: CreationCategoryId.insects,
    name: 'Insects',
    icon: Icons.bug_report_rounded,
    parentCategory: CreationParentCategory.animals,
    description:
        'Small creatures carry precise roles in creation and invite humility in observation.',
    verseIds: <String>['creation_bees_1668', 'creation_animals_638'],
    tags: <String>['insects', 'bees', 'creation'],
    colorTheme: Color(0xFFB7904A),
  ),
  CreationCategory(
    id: CreationCategoryId.plants,
    name: 'Plants',
    icon: Icons.local_florist_rounded,
    parentCategory: CreationParentCategory.plants,
    description:
        'Vegetation grows quietly through rain, soil, and decree, renewing the earth again and again.',
    verseIds: <String>['creation_plants_699', 'creation_plants_5024'],
    tags: <String>['plants', 'vegetation', 'growth'],
    colorTheme: Color(0xFF6F9D73),
  ),
  CreationCategory(
    id: CreationCategoryId.trees,
    name: 'Trees',
    icon: Icons.park_rounded,
    parentCategory: CreationParentCategory.plants,
    description:
        'Trees stand as lasting signs of provision, shade, beauty, and measured growth.',
    verseIds: <String>['creation_trees_801', 'creation_plants_5024'],
    tags: <String>['trees', 'shade', 'provision'],
    colorTheme: Color(0xFF4F7B55),
  ),
  CreationCategory(
    id: CreationCategoryId.water,
    name: 'Water',
    icon: Icons.water_drop_rounded,
    parentCategory: CreationParentCategory.water,
    description:
        'Water sustains life and turns reflection toward dependence, renewal, and mercy.',
    verseIds: <String>['creation_water_2130', 'creation_water_2563'],
    tags: <String>['water', 'life', 'rain'],
    colorTheme: Color(0xFF5A94C9),
  ),
  CreationCategory(
    id: CreationCategoryId.mountains,
    name: 'Mountains',
    icon: Icons.landscape_rounded,
    parentCategory: CreationParentCategory.landscape,
    description:
        'Mountains evoke steadiness, scale, and the weight of the earth beneath human lives.',
    verseIds: <String>['creation_mountains_7867', 'creation_mountains_885'],
    tags: <String>['mountains', 'earth', 'steadiness'],
    colorTheme: Color(0xFF8B7B68),
  ),
  CreationCategory(
    id: CreationCategoryId.landscape,
    name: 'Landscape',
    icon: Icons.terrain_rounded,
    parentCategory: CreationParentCategory.landscape,
    description:
        'Wide scenes of land, rock, and horizon call the heart to look, consider, and remember.',
    verseIds: <String>['creation_landscape_881720', 'creation_landscape_507'],
    tags: <String>['landscape', 'earth', 'reflection'],
    colorTheme: Color(0xFF92745C),
  ),
  CreationCategory(
    id: CreationCategoryId.sky,
    name: 'Sky',
    icon: Icons.wb_twilight_rounded,
    parentCategory: CreationParentCategory.sky,
    description:
        'The sky above invites awe, order, and awareness of signs greater than ourselves.',
    verseIds: <String>['creation_sky_673', 'creation_sky_3190'],
    tags: <String>['sky', 'heavens', 'signs'],
    colorTheme: Color(0xFF6A82C8),
  ),
];

const creationExplorerVerses = <CreationVerse>[
  CreationVerse(
    id: 'creation_animals_638',
    ayahReference: 'Qur’an 6:38',
    arabicText:
        'وَمَا مِنْ دَابَّةٍ فِي الْأَرْضِ وَلَا طَائِرٍ يَطِيرُ بِجَنَاحَيْهِ إِلَّا أُمَمٌ أَمْثَالُكُمْ',
    translation:
        'There is no creature on earth nor bird flying with its wings except that they are communities like you.',
    reflection:
        'Animals are not random background to human life. They live with patterns, needs, and communities known to their Creator.',
    categoryTags: <String>['animals', 'birds'],
  ),
  CreationVerse(
    id: 'creation_animals_451',
    ayahReference: 'Qur’an 45:4',
    translation:
        'And in your own creation, and whatever living creatures He has scattered, are signs for people of sure faith.',
    reflection:
        'A simple encounter with an animal can become a reminder that life itself is a sign, not only a familiar routine.',
    categoryTags: <String>['animals'],
  ),
  CreationVerse(
    id: 'creation_birds_2441',
    ayahReference: 'Qur’an 24:41',
    translation:
        'Do you not see that Allah is glorified by whoever is in the heavens and the earth, and by the birds with wings outspread?',
    reflection:
        'Bird flight is not only movement. It can also call the heart to remember praise, order, and dependence on Allah.',
    categoryTags: <String>['birds', 'sky'],
  ),
  CreationVerse(
    id: 'creation_birds_1679',
    ayahReference: 'Qur’an 16:79',
    translation:
        'Do they not see the birds controlled in the atmosphere of the sky? None holds them up except Allah.',
    reflection:
        'Even what seems ordinary in the sky becomes remarkable when seen as a sustained sign rather than a passing sight.',
    categoryTags: <String>['birds', 'sky'],
  ),
  CreationVerse(
    id: 'creation_bees_1668',
    ayahReference: 'Qur’an 16:68-69',
    translation:
        'And your Lord inspired the bee: take for yourself among the mountains, trees, and what they build... from its bellies comes a drink of varying colors in which there is healing for people.',
    reflection:
        'Small creation can carry wisdom, benefit, and order far beyond what the eye first notices.',
    categoryTags: <String>['insects', 'bees', 'trees'],
  ),
  CreationVerse(
    id: 'creation_plants_699',
    ayahReference: 'Qur’an 6:99',
    translation:
        'It is He who sends down rain from the sky, and We bring forth thereby the growth of all things.',
    reflection:
        'Leaves, stems, and flowers are reminders that quiet growth often begins with unseen mercy.',
    categoryTags: <String>['plants', 'trees', 'water'],
  ),
  CreationVerse(
    id: 'creation_plants_5024',
    ayahReference: 'Qur’an 50:9-11',
    translation:
        'And We sent down blessed water from the sky and caused gardens and grain to grow by it, and lofty palm trees with layered fruit, as provision for the servants.',
    reflection:
        'Provision is not abstract. It appears in the living world around us through measured growth and repeated mercy.',
    categoryTags: <String>['plants', 'trees', 'water'],
  ),
  CreationVerse(
    id: 'creation_trees_801',
    ayahReference: 'Qur’an 80:24-32',
    translation:
        'Let man look at his food... We split the earth open and caused grain, grapes, herbage, olives, palm trees, gardens, fruit, and pasture to grow.',
    reflection:
        'Trees and crops invite gratitude by linking daily sustenance to the Creator’s ordering of the earth.',
    categoryTags: <String>['trees', 'plants'],
  ),
  CreationVerse(
    id: 'creation_water_2130',
    ayahReference: 'Qur’an 21:30',
    translation: 'And We made from water every living thing.',
    reflection:
        'Water is ordinary in use yet extraordinary in meaning. Life itself is tied to it by Allah’s design.',
    categoryTags: <String>['water'],
  ),
  CreationVerse(
    id: 'creation_water_2563',
    ayahReference: 'Qur’an 25:48-49',
    translation:
        'And We send down pure water from the sky so that We may bring life to a dead land and give it as drink to many of what We created.',
    reflection:
        'Water revives what seems lifeless. It teaches renewal, mercy, and dependence all at once.',
    categoryTags: <String>['water', 'plants'],
  ),
  CreationVerse(
    id: 'creation_mountains_7867',
    ayahReference: 'Qur’an 78:6-7',
    translation:
        'Have We not made the earth a resting place, and the mountains as stakes?',
    reflection:
        'Mountains call attention to stability and scale, showing that the earth is not without measure or structure.',
    categoryTags: <String>['mountains', 'landscape'],
  ),
  CreationVerse(
    id: 'creation_mountains_885',
    ayahReference: 'Qur’an 88:17-20',
    translation:
        'Do they not look at the camels, how they were created; and at the sky, how it was raised; and at the mountains, how they were set up; and at the earth, how it was spread out?',
    reflection:
        'The Qur’an directs attention to what is visible, familiar, and easily ignored. Looking carefully is itself part of reflection.',
    categoryTags: <String>['mountains', 'landscape', 'sky', 'animals'],
  ),
  CreationVerse(
    id: 'creation_landscape_881720',
    ayahReference: 'Qur’an 88:17-20',
    translation:
        'Do they not look... at the mountains, how they were set up, and at the earth, how it was spread out?',
    reflection:
        'Open land and distant horizons can slow the heart enough to notice what was always there.',
    categoryTags: <String>['landscape', 'mountains'],
  ),
  CreationVerse(
    id: 'creation_landscape_507',
    ayahReference: 'Qur’an 50:7',
    translation:
        'And the earth, We spread it out and cast therein firmly set mountains, and caused to grow in it of every beautiful kind.',
    reflection:
        'Landscape holds both firmness and beauty. The earth is not only functional; it is also filled with signs that invite gratitude.',
    categoryTags: <String>['landscape', 'mountains', 'plants'],
  ),
  CreationVerse(
    id: 'creation_sky_673',
    ayahReference: 'Qur’an 67:3',
    translation:
        'He who created seven heavens in layers. You do not see in the creation of the Most Merciful any inconsistency.',
    reflection:
        'The sky invites a kind of looking that moves from surface beauty to deeper trust in order and wisdom.',
    categoryTags: <String>['sky'],
  ),
  CreationVerse(
    id: 'creation_sky_3190',
    ayahReference: 'Qur’an 3:190',
    translation:
        'Indeed, in the creation of the heavens and the earth and the alternation of the night and the day are signs for people of understanding.',
    reflection:
        'Creation becomes more than scenery when it is received as a sign that calls for thought, remembrance, and humility.',
    categoryTags: <String>['sky', 'landscape', 'reflection'],
  ),
];

final Map<CreationCategoryId, CreationCategory> creationCategoryById = {
  for (final category in creationExplorerCategories) category.id: category,
};

final Map<String, CreationVerse> creationVerseById = {
  for (final verse in creationExplorerVerses) verse.id: verse,
};
