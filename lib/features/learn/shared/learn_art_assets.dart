import '../journey/domain/learning_path_models.dart';

/// Central mapping of the learn_art scene set onto the things they illustrate.
/// Every consumer goes through these helpers so a renamed asset breaks in one
/// place — and the widgets they feed all carry icon fallbacks regardless.
const _artRoot = 'assets/images/learn_art';

String levelArtAsset(LearningPathLevel level) {
  return switch (level) {
    LearningPathLevel.beginner => '$_artRoot/level_new_to_islam.webp',
    LearningPathLevel.practicing =>
      '$_artRoot/level_building_consistency.webp',
    LearningPathLevel.seeker => '$_artRoot/level_deepening_knowledge.webp',
    LearningPathLevel.advanced => '$_artRoot/level_refinement.webp',
  };
}

/// Scene for a guided learning path card; null when a path has no art yet.
String? guidedPathArtAsset(String pathId) {
  return switch (pathId) {
    'foundations-starter' => '$_artRoot/path_foundations.webp',
    'salah-starter' => '$_artRoot/path_salah.webp',
    'quran-beginner-starter' => '$_artRoot/path_quran_beginner.webp',
    'daily-dhikr-starter' => '$_artRoot/path_daily_dhikr.webp',
    'character-starter' => '$_artRoot/path_character.webp',
    'stories-starter' => '$_artRoot/path_stories.webp',
    'kids-starter' => '$_artRoot/path_kids_starter.webp',
    _ => null,
  };
}
