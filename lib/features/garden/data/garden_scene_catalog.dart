import '../domain/garden_models.dart';
import '../domain/garden_scene_models.dart';

/// How one vista element grows: which number drives it and the ascending
/// thresholds at which it reaches variant 1..N. Threshold units follow the
/// driver: dimension scores are 0-1, maturity is 0-100, drops are raw counts.
class GardenSceneElementRule {
  const GardenSceneElementRule({
    required this.id,
    required this.kind,
    required this.driver,
    required this.variantThresholds,
    this.dimension,
  });

  final GardenSceneElementId id;
  final GardenSceneElementKind kind;
  final GardenSceneDriver driver;
  final List<double> variantThresholds;

  /// The dimension shown as "what grows this" in element detail surfaces.
  /// Drops-driven elements report mercyWater; maturity-driven ones none.
  final GardenGrowthDimension? dimension;

  int variantFor(double value) {
    var level = 0;
    for (final threshold in variantThresholds) {
      if (value >= threshold) {
        level += 1;
      }
    }
    return level;
  }
}

/// The cast of the vista. Pairings: prayer roots the olive of the Verse of
/// Light and Maryam's palm; learning leafs the fig and lands the hoopoe;
/// remembrance grows fragrant rayhan and fills the sky with glorifying birds;
/// the drops-fed stream carries the yaqtin gourd and the fish; wisdom sets
/// pomegranate and vine fruit; consistency is the bee's and the ant's; the
/// sidr appears only near the summit.
const List<GardenSceneElementRule> gardenSceneElementRules = [
  GardenSceneElementRule(
    id: GardenSceneElementId.olive,
    kind: GardenSceneElementKind.plant,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.prayerFoundation,
    variantThresholds: [0.25, 0.50, 0.80],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.datePalm,
    kind: GardenSceneElementKind.plant,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.prayerFoundation,
    variantThresholds: [0.55, 0.75, 0.92],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.fig,
    kind: GardenSceneElementKind.plant,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.learningGrowth,
    variantThresholds: [0.25, 0.50, 0.80],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.hoopoe,
    kind: GardenSceneElementKind.animal,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.learningGrowth,
    variantThresholds: [0.60, 0.85],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.rayhan,
    kind: GardenSceneElementKind.plant,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.remembranceLight,
    variantThresholds: [0.20, 0.45, 0.75],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.songbirds,
    kind: GardenSceneElementKind.animal,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.remembranceLight,
    variantThresholds: [0.55, 0.85],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.gourd,
    kind: GardenSceneElementKind.plant,
    driver: GardenSceneDriver.lifetimeDrops,
    dimension: GardenGrowthDimension.mercyWater,
    variantThresholds: [100, 350, 750],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.fish,
    kind: GardenSceneElementKind.animal,
    driver: GardenSceneDriver.lifetimeDrops,
    dimension: GardenGrowthDimension.mercyWater,
    variantThresholds: [350, 750],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.pomegranate,
    kind: GardenSceneElementKind.plant,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.wisdomFruit,
    variantThresholds: [0.30, 0.55, 0.85],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.grapeVine,
    kind: GardenSceneElementKind.plant,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.wisdomFruit,
    variantThresholds: [0.60, 0.80, 0.95],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.bee,
    kind: GardenSceneElementKind.animal,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.consistencyBloom,
    variantThresholds: [0.35, 0.70],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.ant,
    kind: GardenSceneElementKind.animal,
    driver: GardenSceneDriver.dimensionScore,
    dimension: GardenGrowthDimension.consistencyBloom,
    variantThresholds: [0.65],
  ),
  GardenSceneElementRule(
    id: GardenSceneElementId.loteTree,
    kind: GardenSceneElementKind.tree,
    driver: GardenSceneDriver.maturityPercent,
    variantThresholds: [80, 96],
  ),
];

/// Stream art tiers 2..5 unlock at these lifetime-drop counts; tier 1 (a
/// spring trickle) is always present. Keyed to the garden's 1-1000 milestone
/// ladder, deliberately NOT the ocean feature's personal ladder.
const List<int> gardenStreamTierThresholds = [25, 100, 350, 750];
const int gardenOceanGlimpseDrops = 500;
const int gardenOceanFullDrops = 1000;

int gardenStreamTierForDrops(int totalDrops) {
  var tier = 1;
  for (final threshold in gardenStreamTierThresholds) {
    if (totalDrops >= threshold) {
      tier += 1;
    }
  }
  return tier;
}
