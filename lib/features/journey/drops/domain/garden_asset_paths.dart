const Map<String, String> gardenImageAssetPaths = <String, String>{
  'garden/first_seed': 'assets/images/garden/first_seed.png',
  'garden/gentle_rain': 'assets/images/garden/gentle_rain.png',
  'garden/olive_shoot': 'assets/images/garden/olive_shoot.png',
  'garden/morning_path': 'assets/images/garden/morning_path.png',
  'garden/quiet_fountain': 'assets/images/garden/quiet_fountain.png',
  'garden/olive_courtyard': 'assets/images/garden/olive_courtyard.png',
  'garden/lamp_walk': 'assets/images/garden/lamp_walk.png',
  'garden/mercy_rain': 'assets/images/garden/mercy_rain.png',
  'garden/star_reflection': 'assets/images/garden/star_reflection.png',
  'garden/path_of_nur': 'assets/images/garden/path_of_nur.png',
};

String gardenImageAssetPath(String imageAsset) {
  return gardenImageAssetPaths[imageAsset] ?? 'assets/images/$imageAsset.png';
}
