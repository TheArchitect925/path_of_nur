import '../domain/bedtime_story_illustration_models.dart';
import '../domain/kids_book_models.dart' show KidsBookAtlasScene;

/// Page art for the manners stories that came before the picture books
/// (K3). The prophet stories are picture books now and carry their own.
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

  /// A file stem under the scenes folder, or an atlas scene (the prophet
  /// plans that borrowed the atlas are picture books now).
  final Object file;
  final String title;
  final String caption;

  String get assetPath => file is KidsBookAtlasScene
      ? (file as KidsBookAtlasScene).assetPath
      : '$_scenes/$file.webp';
}

const Map<String, List<_Scene>> _plans = {
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
