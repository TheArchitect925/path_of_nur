import '../journey/domain/learning_path_models.dart';

/// Central mapping of the learn_art scene set onto the things they illustrate.
/// Every consumer goes through these helpers so a renamed asset breaks in one
/// place — and the widgets they feed all carry icon fallbacks regardless.
const _artRoot = 'assets/images/learn_art';

String levelArtAsset(LearningPathLevel level) {
  return switch (level) {
    LearningPathLevel.beginner => '$_artRoot/level_new_to_islam.webp',
    LearningPathLevel.practicing => '$_artRoot/level_building_consistency.webp',
    LearningPathLevel.seeker => '$_artRoot/level_deepening_knowledge.webp',
    LearningPathLevel.advanced => '$_artRoot/level_refinement.webp',
  };
}

/// Scene for a learning island. Journeys inherit their island's scene as a
/// card thumbnail, so every journey in the app carries art.
String? journeyIslandArtAsset(String islandId) {
  return switch (islandId) {
    'core-knowledge' => '$_artRoot/journey_core_knowledge.webp',
    'practice-worship' => '$_artRoot/journey_practice_worship.webp',
    'understanding-islam' => '$_artRoot/journey_understanding_islam.webp',
    'arabic-learning' => '$_artRoot/journey_arabic_learning.webp',
    'discovery' => '$_artRoot/journey_discovery.webp',
    'kids-learning' => '$_artRoot/journey_kids_learning.webp',
    'browse-all' => '$_artRoot/journey_browse_all.webp',
    'tools-other' => '$_artRoot/journey_tools_other.webp',
    _ => null,
  };
}

/// Scene tile for a kids-learning subcategory; null when it has no art yet.
String? kidsSubcategoryArtAsset(String subcategoryId) {
  return switch (subcategoryId) {
    'kids-quran' => '$_artRoot/kids_quran.webp',
    'kids-arabic-learning' => '$_artRoot/kids_arabic.webp',
    'kids-stories' => '$_artRoot/kids_story_library.webp',
    'kids-prophet-stories' => '$_artRoot/kids_prophet_stories.webp',
    'kids-dua-learning' => '$_artRoot/kids_duas.webp',
    'kids-hadith' => '$_artRoot/kids_hadith.webp',
    'kids-hadith-stories' => '$_artRoot/kids_hadith_stories.webp',
    'kids-seerah-journeys' => '$_artRoot/kids_seerah.webp',
    'kids-fun-learning' => '$_artRoot/kids_fun_learning.webp',
    'kids-games' => '$_artRoot/kids_games.webp',
    _ => null,
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
