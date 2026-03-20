const _gardenLevelArt = <int, String>{
  1: 'assets/images/backgrounds/glv1.PNG',
  3: 'assets/images/backgrounds/glv3.PNG',
  4: 'assets/images/backgrounds/glv4.PNG',
  5: 'assets/images/backgrounds/glv5.PNG',
  6: 'assets/images/backgrounds/glv6.PNG',
  7: 'assets/images/backgrounds/glv7.PNG',
};

const Map<String, String> gardenImageAssetPaths = <String, String>{
  'garden/first_seed': 'assets/images/backgrounds/glv1.PNG',
  'garden/gentle_rain': 'assets/images/backgrounds/glv1.PNG',
  'garden/olive_shoot': 'assets/images/backgrounds/glv3.PNG',
  'garden/morning_path': 'assets/images/backgrounds/glv4.PNG',
  'garden/quiet_fountain': 'assets/images/backgrounds/glv5.PNG',
  'garden/olive_courtyard': 'assets/images/backgrounds/glv6.PNG',
  'garden/lamp_walk': 'assets/images/backgrounds/glv7.PNG',
  'garden/mercy_rain': 'assets/images/backgrounds/glv7.PNG',
  'garden/star_reflection': 'assets/images/backgrounds/glv7.PNG',
  'garden/path_of_nur': 'assets/images/backgrounds/glv7.PNG',
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
