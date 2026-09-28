/// Milestone scenes for the drops gallery, rendered by
/// tooling/art_src/garden_art/generate_garden_art.mjs from the same layers as
/// the living vista — so a milestone thumbnail and the garden itself can
/// never drift apart. Ten scenes for ten milestones; no reuse, no gaps.
const _gardenLevelArt = <int, String>{
  1: 'assets/images/garden_art/garden_milestone_m01.webp',
  2: 'assets/images/garden_art/garden_milestone_m02.webp',
  3: 'assets/images/garden_art/garden_milestone_m03.webp',
  4: 'assets/images/garden_art/garden_milestone_m04.webp',
  5: 'assets/images/garden_art/garden_milestone_m05.webp',
  6: 'assets/images/garden_art/garden_milestone_m06.webp',
  7: 'assets/images/garden_art/garden_milestone_m07.webp',
  8: 'assets/images/garden_art/garden_milestone_m08.webp',
  9: 'assets/images/garden_art/garden_milestone_m09.webp',
  10: 'assets/images/garden_art/garden_milestone_m10.webp',
};

const Map<String, String> gardenImageAssetPaths = <String, String>{
  'garden/first_seed': 'assets/images/garden_art/garden_milestone_m01.webp',
  'garden/gentle_rain': 'assets/images/garden_art/garden_milestone_m02.webp',
  'garden/olive_shoot': 'assets/images/garden_art/garden_milestone_m03.webp',
  'garden/morning_path': 'assets/images/garden_art/garden_milestone_m04.webp',
  'garden/quiet_fountain': 'assets/images/garden_art/garden_milestone_m05.webp',
  'garden/olive_courtyard':
      'assets/images/garden_art/garden_milestone_m06.webp',
  'garden/lamp_walk': 'assets/images/garden_art/garden_milestone_m07.webp',
  'garden/mercy_rain': 'assets/images/garden_art/garden_milestone_m08.webp',
  'garden/star_reflection':
      'assets/images/garden_art/garden_milestone_m09.webp',
  'garden/path_of_nur': 'assets/images/garden_art/garden_milestone_m10.webp',
};

String gardenImageAssetPath(String imageAsset) {
  final explicit = gardenImageAssetPaths[imageAsset];
  if (explicit != null) {
    return explicit;
  }
  final levelMatch = RegExp(
    r'glv(\d+)',
    caseSensitive: false,
  ).firstMatch(imageAsset);
  if (levelMatch != null) {
    final level = int.tryParse(levelMatch.group(1) ?? '');
    if (level != null) {
      return _gardenLevelArt[level] ?? _nearestAvailableGardenLevelPath(level);
    }
  }
  return 'assets/images/$imageAsset.png';
}

String _nearestAvailableGardenLevelPath(int level) {
  final lowerOrEqual =
      _gardenLevelArt.keys.where((value) => value <= level).toList()..sort();
  if (lowerOrEqual.isNotEmpty) {
    return _gardenLevelArt[lowerOrEqual.last]!;
  }
  final sortedLevels = _gardenLevelArt.keys.toList()..sort();
  return _gardenLevelArt[sortedLevels.first]!;
}
