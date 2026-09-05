import '../domain/bedtime_story_illustration_models.dart';
import '../domain/kids_book_models.dart' show KidsBookAtlasScene;

/// Page art for the stories that came before the picture books (K3).
///
/// Each older story lists a few scenes in reading order; the reader spreads
/// them over its pages and the detail page shows them as a gallery. The
/// pictures are drawn by tooling/art_src/kids_story_scenes and live with
/// the picture-book scenes; a plan may borrow an atlas scene where one fits.
List<BedtimeStorySceneIllustration> kidsStoryScenes(String storyId) {
  final plan = _plans[storyId];
  if (plan == null) return const [];
  return [
    for (var i = 0; i < plan.length; i++)
      BedtimeStorySceneIllustration(
        id: 'scene_${storyId}_${i + 1}',
        storyId: storyId,
        sortOrder: i + 1,
        title: plan[i].title,
        description: plan[i].caption,
        imageAssetPath: plan[i].assetPath,
        caption: plan[i].caption,
        useCase: BedtimeStoryIllustrationUseCase.inline,
      ),
  ];
}

/// Every story that has a plan, for the guard test.
Iterable<String> get kidsStoryScenePlanIds => _plans.keys;

const String _scenes = 'assets/images/kids_books/scenes';

class _Scene {
  const _Scene(this.file, this.title, this.caption);

  /// A file stem under the scenes folder, or an atlas scene.
  const _Scene.atlas(KidsBookAtlasScene scene, this.title, this.caption)
    : file = scene;

  final Object file;
  final String title;
  final String caption;

  String get assetPath => file is KidsBookAtlasScene
      ? (file as KidsBookAtlasScene).assetPath
      : '$_scenes/$file.webp';
}

const Map<String, List<_Scene>> _plans = {
  'story_prophet_adam_bedtime_v1': [
    _Scene(
      'adam_creation',
      'Before anything',
      'Allah made the sky, the stars, the mountains and the seas.',
    ),
    _Scene(
      'adam_jannah',
      'A garden called Jannah',
      'Trees, rivers and peace, made for the first people.',
    ),
    _Scene(
      'adam_one_tree',
      'One tree',
      'Everything was theirs to enjoy, except this one tree.',
    ),
    _Scene(
      'adam_forgiveness',
      'Sorry, and forgiven',
      'They turned to Allah, and Allah forgave them.',
    ),
    _Scene(
      'adam_earth',
      'Down to Earth',
      'Adam became the first prophet, and our story began.',
    ),
  ],
  'story_prophet_ibrahim_bedtime_v1': [
    _Scene(
      'ibrahim_idols',
      'Made by hands',
      'People bowed to stone and wood they had carved themselves.',
    ),
    _Scene(
      'ibrahim_star',
      'A bright star',
      'Is this my Lord? But the star disappeared.',
    ),
    _Scene(
      'ibrahim_moon',
      'The moon',
      'Bright and beautiful, until it went away too.',
    ),
    _Scene(
      'ibrahim_sunrise',
      'The sun',
      'Big and shining, and then it set. Allah made them all.',
    ),
    _Scene(
      'ibrahim_broken_idols',
      'Ask the big one',
      'The idols could not speak, move or help anyone.',
    ),
    _Scene(
      'ibrahim_cool_fire',
      'Cool and safe',
      'O fire, be cool and safe for Ibrahim.',
    ),
  ],
  'story_prophet_ismail_bedtime_v1': [
    _Scene(
      'ismail_home',
      'A son',
      'Ibrahim loved his kind, gentle, helpful boy.',
    ),
    _Scene(
      'ismail_dream',
      'A dream',
      'Not an ordinary dream: a message from Allah.',
    ),
    _Scene(
      'ismail_walk',
      'Side by side',
      'A father and a son, trusting Allah, step by step.',
    ),
    _Scene(
      'ismail_ram',
      'A ram instead',
      'It was a test, and they had passed.',
    ),
    _Scene(
      'ismail_eid',
      'Eid al-Adha',
      'Every year we remember a moment of trust and love.',
    ),
  ],
  'story_prophet_musa_bedtime_v1': [
    _Scene(
      'musa_river_basket',
      'A basket on the river',
      'Do not be afraid. I will return him to you.',
    ),
    _Scene(
      'musa_palace',
      'The palace',
      'The basket reached the palace, and Musa grew up safe.',
    ),
    _Scene(
      'musa_fire_mountain',
      'A fire on the mountain',
      'When Musa came closer, Allah spoke to him.',
    ),
    _Scene('musa_staff', 'The staff', 'Musa showed Firawn the signs of Allah.'),
    _Scene(
      'musa_sea_split',
      'The sea opens',
      'A path opened in the middle of the sea.',
    ),
    _Scene(
      'musa_safe_shore',
      'Safe on the shore',
      'Allah saved Musa and his people.',
    ),
  ],
  'story_prophet_dawud_bedtime_v1': [
    _Scene(
      'dawud_valley',
      'A giant',
      'Jalut was very strong, and people were afraid.',
    ),
    _Scene('dawud_sling', 'A sling and a stone', 'That was all Dawud took.'),
    _Scene(
      'dawud_stone_flies',
      'One careful throw',
      'With Allah’s help, the giant fell.',
    ),
    _Scene(
      'dawud_mountains_birds',
      'Praising together',
      'The mountains and the birds joined his beautiful voice.',
    ),
    _Scene(
      'dawud_justice',
      'A fair king',
      'He listened, he helped, and he judged with justice.',
    ),
  ],
  'story_prophet_isa_bedtime_v1': [
    _Scene('isa_mihrab', 'Maryam', 'She spent her days worshipping Allah.'),
    _Scene(
      'isa_palm_stream',
      'A palm and a stream',
      'Allah cared for Maryam when the baby came.',
    ),
    _Scene(
      'isa_cradle',
      'From the cradle',
      'Baby Isa spoke: I am the servant of Allah.',
    ),
    _Scene(
      'isa_village_morning',
      'Healing and comfort',
      'By Allah’s permission, Isa helped the sick and the poor.',
    ),
    _Scene(
      'isa_raised',
      'Raised to Allah',
      'Allah protected Isa and raised him.',
    ),
  ],
  'story_prophet_sulaiman_bedtime_v1': [
    _Scene(
      'sulaiman_ants',
      'The ant',
      'O ants, go into your homes so you are not stepped on.',
    ),
    _Scene(
      'sulaiman_wind',
      'Carried by the wind',
      'The wind carried Sulaiman from place to place.',
    ),
    _Scene('sulaiman_hoopoe', 'The hoopoe', 'A small bird brought big news.'),
    _Scene(
      'sulaiman_sun_kingdom',
      'A kingdom of the sun',
      'They worshipped the sun instead of Allah.',
    ),
    _Scene(
      'sulaiman_throne',
      'The queen’s throne',
      'By Allah’s permission, it was brought before Sulaiman.',
    ),
    _Scene(
      'sulaiman_thankful_night',
      'Thankful',
      'With all that power, Sulaiman stayed humble.',
    ),
  ],
  'story_prophet_muhammad_part1_bedtime_v1': [
    _Scene(
      'muhammad_makkah_morning',
      'Makkah',
      'In this city a very special baby was born.',
    ),
    _Scene(
      'muhammad_orphan_home',
      'Never alone',
      'An orphan, but Allah was always with him.',
    ),
    _Scene(
      'muhammad_caravan',
      'Al-Ameen',
      'A trader so honest that people called him the trustworthy one.',
    ),
    _Scene(
      'muhammad_hira_night',
      'A quiet cave',
      'In the cave of Hira he would think and remember Allah.',
    ),
  ],
  'story_prophet_muhammad_part2_bedtime_v1': [
    _Scene(
      'muhammad_cave_light',
      'Read',
      'The first words of the Qur’an came in the cave.',
    ),
    _Scene(
      'muhammad_home_comfort',
      'Cover me',
      'Khadijah comforted him and believed right away.',
    ),
    _Scene(
      'muhammad_makkah_night',
      'Quietly at first',
      'The message was shared with family and close friends.',
    ),
    _Scene(
      'muhammad_patience_dawn',
      'Patient and kind',
      'Slowly, more people believed.',
    ),
  ],
  'story_prophet_muhammad_part3_bedtime_v1': [
    _Scene(
      'muhammad_thawr_cave',
      'Do not be sad',
      'Allah is with us. A web and a nest hid the cave.',
    ),
    _Scene.atlas(
      KidsBookAtlasScene.desertRoad,
      'The Hijrah',
      'The long journey to a new city, Madinah.',
    ),
    _Scene(
      'muhammad_madinah_welcome',
      'Welcome',
      'The people of Madinah were full of joy.',
    ),
    _Scene.atlas(
      KidsBookAtlasScene.masjid,
      'One family',
      'Praying together, helping the poor, caring for everyone.',
    ),
  ],
  'story_prophet_muhammad_part4_bedtime_v1': [
    _Scene(
      'muhammad_return_makkah',
      'Back to Makkah',
      'He returned with strength to the city that had hurt him.',
    ),
    _Scene(
      'muhammad_mercy_doves',
      'You are all free',
      'He forgave them. This was the heart of a true prophet.',
    ),
    _Scene(
      'muhammad_lights_world',
      'Hearts everywhere',
      'His message continues all around the world.',
    ),
  ],
  'story_sharing_with_others_v1': [
    _Scene(
      'sharing_lunchbox',
      'Two dates',
      'Yusuf had two dates left. Harun had forgotten his snack.',
    ),
    _Scene(
      'sharing_plate',
      'We can share',
      'The date was small, but the kindness felt big.',
    ),
  ],
  'story_telling_the_truth_v1': [
    _Scene(
      'truth_spilled_cup',
      'The blue cup',
      'Water slipped across the table.',
    ),
    _Scene(
      'truth_clean_table',
      'Light again',
      'Together they wiped the table clean.',
    ),
  ],
  'story_helping_parents_v1': [
    _Scene(
      'helping_door_bags',
      'I can help',
      'Layth carried the light bag carefully.',
    ),
    _Scene(
      'helping_water',
      'Water for Mama',
      'No one told him to. He just wanted to help.',
    ),
  ],
  'story_kindness_to_animals_v1': [
    _Scene(
      'kindness_kitten_wall',
      'A tiny voice',
      'Huda noticed the empty bowl.',
    ),
    _Scene(
      'kindness_kitten_drinks',
      'Allah loves mercy',
      'The kitten drank, and its little tail lifted.',
    ),
  ],
  'story_masjid_manners_v1': [
    _Scene('masjid_shoes', 'At the door', 'Hasan took off his shoes neatly.'),
    _Scene(
      'masjid_inside',
      'A quiet voice',
      'He walked gently and made room for others.',
    ),
  ],
  'story_ramadan_kindness_v1': [
    _Scene('ramadan_gold_sky', 'The sky turned gold', 'Iftar was almost here.'),
    _Scene(
      'ramadan_tray',
      'For our neighbours',
      'They carried the tray carefully.',
    ),
  ],
  'story_eid_gratitude_v1': [
    _Scene('eid_kitchen', 'Eid morning', 'Sweet smells filled the kitchen.'),
    _Scene(
      'eid_window_clothes',
      'Alhamdulillah',
      'Before the fun, remember Who gave this day.',
    ),
  ],
  'story_patience_v1': [
    _Scene(
      'patience_soil_cup',
      'A seed',
      'Mina planted a seed in a cup of soil.',
    ),
    _Scene(
      'patience_night_window',
      'Nothing yet',
      'Some good things need patient hearts.',
    ),
    _Scene(
      'patience_sprout',
      'A green shoot',
      'Patience had been growing in her too.',
    ),
  ],
  'story_saying_sorry_and_forgiving_v1': [
    _Scene(
      'sorry_fallen_blocks',
      'The tower fell',
      'Hamza wanted to walk away.',
    ),
    _Scene('sorry_rebuilt', 'I forgive you', 'Together they built again.'),
  ],
};
