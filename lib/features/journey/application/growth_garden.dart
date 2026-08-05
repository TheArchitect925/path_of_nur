enum GrowthGardenStage { seed, sprout, rooted, flourishing, lightUponLight }

enum GrowthUnlockableType {
  wallpaper,
  gardenElement,
  visualTheme,
  reflectionPack,
  milestoneTitle,
  seasonal,
}

class GrowthUnlockable {
  const GrowthUnlockable({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.previewAssetKey,
    required this.requiredTotalCompletions,
    required this.requiredStreakDays,
    required this.requiredReflections,
    required this.requiredGardenStage,
    this.requiredQuranJuz = 0,
    this.requiredFastCompletions = 0,
    this.requiredMilestoneId,
    this.requiredSeasonTag,
    this.hasRealAsset = false,
  });

  final String id;
  final GrowthUnlockableType type;
  final String title;
  final String subtitle;
  final String description;
  final String previewAssetKey;
  final int requiredTotalCompletions;
  final int requiredStreakDays;
  final int requiredReflections;
  final GrowthGardenStage requiredGardenStage;
  final double requiredQuranJuz;
  final int requiredFastCompletions;
  final String? requiredMilestoneId;
  final String? requiredSeasonTag;
  final bool hasRealAsset;
}

class GrowthGardenVisualState {
  const GrowthGardenVisualState({
    required this.stage,
    required this.stageLabel,
    required this.stageSubtitle,
    required this.progressToNext,
    required this.nextStageLabel,
    required this.recentGrowthLine,
  });

  final GrowthGardenStage stage;
  final String stageLabel;
  final String stageSubtitle;
  final double progressToNext;
  final String? nextStageLabel;
  final String recentGrowthLine;
}

const seededGrowthUnlockables = <GrowthUnlockable>[
  GrowthUnlockable(
    id: 'wall_bee_garden',
    type: GrowthUnlockableType.wallpaper,
    title: 'Bee-Themed',
    subtitle: 'Quiet work, steady sweetness.',
    description: 'A calm reminder that small consistent efforts become honey.',
    previewAssetKey: 'wall_bee_garden',
    requiredTotalCompletions: 12,
    requiredStreakDays: 3,
    requiredReflections: 2,
    requiredGardenStage: GrowthGardenStage.seed,
  ),
  GrowthUnlockable(
    id: 'wall_olive_tree',
    type: GrowthUnlockableType.wallpaper,
    title: 'Olive Tree',
    subtitle: 'Rooted patience and shade.',
    description: 'An olive-inspired scene for steady and rooted growth.',
    previewAssetKey: 'wall_olive_tree',
    requiredTotalCompletions: 28,
    requiredStreakDays: 7,
    requiredReflections: 4,
    requiredGardenStage: GrowthGardenStage.sprout,
  ),
  GrowthUnlockable(
    id: 'wall_mountain_dawn',
    type: GrowthUnlockableType.wallpaper,
    title: 'Mountain Dawn',
    subtitle: 'Morning resolve and clarity.',
    description: 'A dawn palette for renewed intention each day.',
    previewAssetKey: 'wall_mountain_dawn',
    requiredTotalCompletions: 45,
    requiredStreakDays: 10,
    requiredReflections: 6,
    requiredGardenStage: GrowthGardenStage.rooted,
  ),
  GrowthUnlockable(
    id: 'wall_starry_night',
    type: GrowthUnlockableType.wallpaper,
    title: 'Starry Night',
    subtitle: 'Quiet worship under the night sky.',
    description: 'A subtle night wallpaper for reflection and calm.',
    previewAssetKey: 'wall_starry_night',
    requiredTotalCompletions: 70,
    requiredStreakDays: 14,
    requiredReflections: 8,
    requiredGardenStage: GrowthGardenStage.rooted,
  ),
  GrowthUnlockable(
    id: 'wall_rain_mercy',
    type: GrowthUnlockableType.wallpaper,
    title: 'Rain / Mercy',
    subtitle: 'Soft renewal and gratitude.',
    description: 'A gentle rain-inspired visual for mercy and return.',
    previewAssetKey: 'wall_rain_mercy',
    requiredTotalCompletions: 90,
    requiredStreakDays: 18,
    requiredReflections: 10,
    requiredGardenStage: GrowthGardenStage.flourishing,
  ),
  GrowthUnlockable(
    id: 'wall_desert_calm',
    type: GrowthUnlockableType.wallpaper,
    title: 'Desert Calm',
    subtitle: 'Stillness and steady trust.',
    description: 'A minimalist desert scene for serene focus.',
    previewAssetKey: 'wall_desert_calm',
    requiredTotalCompletions: 110,
    requiredStreakDays: 21,
    requiredReflections: 12,
    requiredGardenStage: GrowthGardenStage.flourishing,
  ),
  GrowthUnlockable(
    id: 'wall_river_light',
    type: GrowthUnlockableType.wallpaper,
    title: 'River of Light',
    subtitle: 'Flowing constancy and light.',
    description: 'A symbolic reward for long-term consistency.',
    previewAssetKey: 'wall_river_light',
    requiredTotalCompletions: 150,
    requiredStreakDays: 28,
    requiredReflections: 15,
    requiredGardenStage: GrowthGardenStage.lightUponLight,
    requiredQuranJuz: 8,
  ),
  GrowthUnlockable(
    id: 'theme_dawn_glow',
    type: GrowthUnlockableType.visualTheme,
    title: 'Dawn Glow',
    subtitle: 'Warm early light accents.',
    description: 'A gentle warm accent inspired by morning beginnings.',
    previewAssetKey: 'theme_dawn_glow',
    requiredTotalCompletions: 25,
    requiredStreakDays: 6,
    requiredReflections: 3,
    requiredGardenStage: GrowthGardenStage.sprout,
  ),
  GrowthUnlockable(
    id: 'theme_moonlit_reflection',
    type: GrowthUnlockableType.visualTheme,
    title: 'Moonlit Reflection',
    subtitle: 'Calm evening tones.',
    description: 'A subtle cool accent for night reflection.',
    previewAssetKey: 'theme_moonlit_reflection',
    requiredTotalCompletions: 55,
    requiredStreakDays: 11,
    requiredReflections: 7,
    requiredGardenStage: GrowthGardenStage.rooted,
  ),
  GrowthUnlockable(
    id: 'theme_olive_garden',
    type: GrowthUnlockableType.visualTheme,
    title: 'Olive Grove',
    subtitle: 'Natural greens and stillness.',
    description: 'A grounded palette inspired by stillness and patience.',
    previewAssetKey: 'theme_olive_garden',
    requiredTotalCompletions: 80,
    requiredStreakDays: 16,
    requiredReflections: 10,
    requiredGardenStage: GrowthGardenStage.flourishing,
  ),
  GrowthUnlockable(
    id: 'theme_rain_mercy',
    type: GrowthUnlockableType.visualTheme,
    title: 'Rain of Mercy',
    subtitle: 'Cool, gentle accents.',
    description: 'A quiet rain-themed accent set for reflective moments.',
    previewAssetKey: 'theme_rain_mercy',
    requiredTotalCompletions: 100,
    requiredStreakDays: 20,
    requiredReflections: 12,
    requiredGardenStage: GrowthGardenStage.flourishing,
  ),
  GrowthUnlockable(
    id: 'theme_desert_night',
    type: GrowthUnlockableType.visualTheme,
    title: 'Desert Night',
    subtitle: 'Muted dusk tones.',
    description: 'A minimal palette reflecting stillness and depth.',
    previewAssetKey: 'theme_desert_night',
    requiredTotalCompletions: 130,
    requiredStreakDays: 24,
    requiredReflections: 14,
    requiredGardenStage: GrowthGardenStage.lightUponLight,
  ),
  GrowthUnlockable(
    id: 'reflection_pack_returning_gently',
    type: GrowthUnlockableType.reflectionPack,
    title: 'Returning Gently',
    subtitle: 'Extra reflective prompts.',
    description:
        'A small pack of prompts for calm returns after difficult days.',
    previewAssetKey: 'reflection_pack_returning',
    requiredTotalCompletions: 35,
    requiredStreakDays: 5,
    requiredReflections: 8,
    requiredGardenStage: GrowthGardenStage.sprout,
  ),
  GrowthUnlockable(
    id: 'title_first_light',
    type: GrowthUnlockableType.milestoneTitle,
    title: 'First Light',
    subtitle: 'Milestone title unlocked',
    description: 'A title unlocked through your first steady steps.',
    previewAssetKey: 'title_first_light',
    requiredTotalCompletions: 1,
    requiredStreakDays: 1,
    requiredReflections: 0,
    requiredGardenStage: GrowthGardenStage.seed,
    requiredMilestoneId: 'first_light',
  ),
  GrowthUnlockable(
    id: 'title_quiet_resolve',
    type: GrowthUnlockableType.milestoneTitle,
    title: 'Quiet Resolve',
    subtitle: 'Milestone title unlocked',
    description: 'A title for returning with calm resolve.',
    previewAssetKey: 'title_quiet_resolve',
    requiredTotalCompletions: 35,
    requiredStreakDays: 6,
    requiredReflections: 6,
    requiredGardenStage: GrowthGardenStage.sprout,
    requiredMilestoneId: 'quiet_resolve',
  ),
  GrowthUnlockable(
    id: 'title_light_upon_light',
    type: GrowthUnlockableType.milestoneTitle,
    title: 'Light Upon Light',
    subtitle: 'Milestone title unlocked',
    description: 'A title reflecting sustained, sincere continuity.',
    previewAssetKey: 'title_light_upon_light',
    requiredTotalCompletions: 150,
    requiredStreakDays: 21,
    requiredReflections: 14,
    requiredGardenStage: GrowthGardenStage.lightUponLight,
    requiredMilestoneId: 'light_upon_light',
  ),
  GrowthUnlockable(
    id: 'seasonal_ramadan_lantern',
    type: GrowthUnlockableType.seasonal,
    title: 'Ramadan Lantern',
    subtitle: 'Seasonal Accent',
    description: 'Unlocks when Ramadan journey consistency is established.',
    previewAssetKey: 'seasonal_ramadan_lantern',
    requiredTotalCompletions: 60,
    requiredStreakDays: 10,
    requiredReflections: 6,
    requiredGardenStage: GrowthGardenStage.rooted,
    requiredFastCompletions: 5,
    requiredQuranJuz: 3,
    requiredSeasonTag: 'ramadan',
  ),
];

GrowthGardenVisualState gardenVisualForScore({
  required double gardenScore,
  required bool privateMode,
}) {
  final score = gardenScore.clamp(0.0, 1.0);
  if (score < 0.2) {
    return GrowthGardenVisualState(
      stage: GrowthGardenStage.seed,
      stageLabel: 'Seed',
      stageSubtitle: privateMode ? 'Quiet beginnings' : 'Beginnings of light',
      progressToNext: score / 0.2,
      nextStageLabel: 'Sprout',
      recentGrowthLine: privateMode
          ? 'Returning gently is enough for growth.'
          : 'A seed is planted through small sincere acts.',
    );
  }
  if (score < 0.4) {
    return GrowthGardenVisualState(
      stage: GrowthGardenStage.sprout,
      stageLabel: 'Sprout',
      stageSubtitle: privateMode ? 'Quiet progress' : 'Early steady growth',
      progressToNext: (score - 0.2) / 0.2,
      nextStageLabel: 'Rooted',
      recentGrowthLine: privateMode
          ? 'Progress continuing quietly.'
          : 'Consistency is turning intention into growth.',
    );
  }
  if (score < 0.65) {
    return GrowthGardenVisualState(
      stage: GrowthGardenStage.rooted,
      stageLabel: 'Rooted',
      stageSubtitle: privateMode ? 'Steady roots' : 'Stability and resilience',
      progressToNext: (score - 0.4) / 0.25,
      nextStageLabel: 'Flourishing',
      recentGrowthLine: privateMode
          ? 'Light added in quiet ways.'
          : 'Your path has roots and steadier rhythm.',
    );
  }
  if (score < 0.85) {
    return GrowthGardenVisualState(
      stage: GrowthGardenStage.flourishing,
      stageLabel: 'Flourishing',
      stageSubtitle: privateMode ? 'Quiet flourishing' : 'Growth in bloom',
      progressToNext: (score - 0.65) / 0.2,
      nextStageLabel: 'Light Upon Light',
      recentGrowthLine: privateMode
          ? 'Growth continuing with calm continuity.'
          : 'Habits, reflection, and service are flourishing.',
    );
  }
  return GrowthGardenVisualState(
    stage: GrowthGardenStage.lightUponLight,
    stageLabel: 'Light Upon Light',
    stageSubtitle: privateMode ? 'Quiet radiance' : 'Mature luminous growth',
    progressToNext: 1.0,
    nextStageLabel: null,
    recentGrowthLine: privateMode
        ? 'Returning often has become a lasting rhythm.'
        : 'A calm, sustained pattern of growth is now visible.',
  );
}
