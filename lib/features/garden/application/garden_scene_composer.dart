import '../../journey/application/growth_garden.dart';
import '../data/garden_scene_catalog.dart';
import '../domain/garden_models.dart';
import '../domain/garden_scene_models.dart';

/// Pure translator from a learner's [GardenState] to the living-vista scene.
/// No clock, no I/O: everything derives from the state plus the last
/// acknowledged memento, so it is unit-testable exactly like [GardenService].
class GardenSceneComposer {
  const GardenSceneComposer();

  GardenSceneSpec compose({
    required GardenState garden,
    required GardenSceneMemento? lastSeen,
  }) {
    final drops = garden.totalOceanDrops;
    final dimensionScores = <GardenGrowthDimension, double>{
      for (final dimension in garden.dimensions) dimension.dimension: dimension.score,
    };
    double scoreFor(GardenGrowthDimension dimension) {
      final fromState = dimensionScores[dimension];
      if (fromState != null) {
        return fromState;
      }
      return switch (dimension) {
        GardenGrowthDimension.prayerFoundation => garden.prayerFoundationScore,
        GardenGrowthDimension.learningGrowth => garden.learningGrowthScore,
        GardenGrowthDimension.remembranceLight => garden.remembranceLightScore,
        GardenGrowthDimension.consistencyBloom => garden.consistencyScore,
        GardenGrowthDimension.wisdomFruit => garden.wisdomFruitScore,
        GardenGrowthDimension.mercyWater =>
          (drops / gardenOceanFullDrops).clamp(0, 1).toDouble(),
      };
    }

    final elements = <GardenSceneElementSpec>[];
    final newlyAppeared = <GardenSceneElementId>[];
    final newlyGrown = <GardenSceneElementId>[];
    for (final rule in gardenSceneElementRules) {
      final value = switch (rule.driver) {
        GardenSceneDriver.dimensionScore => scoreFor(rule.dimension!),
        GardenSceneDriver.maturityPercent => garden.maturityPercent.toDouble(),
        GardenSceneDriver.lifetimeDrops => drops.toDouble(),
      };
      final variant = rule.variantFor(value);
      final previous = lastSeen?.variantFor(rule.id);
      final isNew = previous != null && previous == 0 && variant > 0;
      if (isNew) {
        newlyAppeared.add(rule.id);
      } else if (previous != null && previous > 0 && variant > previous) {
        newlyGrown.add(rule.id);
      }
      elements.add(
        GardenSceneElementSpec(
          id: rule.id,
          kind: rule.kind,
          dimension: rule.dimension,
          variantLevel: variant,
          isNewSinceLastVisit: isNew,
        ),
      );
    }

    final streamTier = gardenStreamTierForDrops(drops);
    final water = GardenSceneWaterSpec(
      streamTier: streamTier,
      oceanHorizonVisible: drops >= gardenOceanGlimpseDrops,
      oceanHorizonFull: drops >= gardenOceanFullDrops,
    );
    if (lastSeen != null) {
      if (lastSeen.streamTier > 0 && streamTier > lastSeen.streamTier) {
        newlyGrown.add(GardenSceneElementId.stream);
      }
      if (water.oceanHorizonVisible && !lastSeen.oceanHorizonVisible) {
        newlyAppeared.add(GardenSceneElementId.oceanHorizon);
      }
    }

    final treeStage = garden.currentVisualStage.stageId;
    final lastStageOrder = _stageOrderForName(lastSeen?.treeStageId);
    final treeStageAdvanced =
        lastStageOrder != null && treeStage.index > lastStageOrder;

    return GardenSceneSpec(
      learnerId: garden.learnerId,
      treeStage: treeStage,
      treeProgress: garden.progressToNextStage,
      maturityPercent: garden.maturityPercent,
      ambient: garden.ambientState,
      elements: List.unmodifiable(elements),
      water: water,
      newlyAppeared: List.unmodifiable(newlyAppeared),
      newlyGrown: List.unmodifiable(newlyGrown),
      treeStageAdvanced: treeStageAdvanced,
      revision: _buildRevision(treeStage, water, elements),
    );
  }

  int? _stageOrderForName(String? name) {
    if (name == null || name.isEmpty) {
      return null;
    }
    for (final stage in GardenVisualStageId.values) {
      if (stage.name == name) {
        return stage.index;
      }
    }
    return null;
  }

  String _buildRevision(
    GardenVisualStageId stage,
    GardenSceneWaterSpec water,
    List<GardenSceneElementSpec> elements,
  ) {
    final parts = elements
        .map((element) => '${element.id.name}:${element.variantLevel}')
        .join(',');
    final ocean = '${water.oceanHorizonVisible ? 1 : 0}${water.oceanHorizonFull ? 1 : 0}';
    return '${stage.name}|t${water.streamTier}|o$ocean|$parts';
  }
}

/// Display-only bridge from canonical maturity to the legacy five-stage
/// vocabulary. Never use this for unlockable gating: the unlockables keep
/// evaluating the original gardenScore so unlock timing never shifts.
GrowthGardenStage legacyGrowthStageForMaturity(int maturityPercent) {
  if (maturityPercent >= 88) {
    return GrowthGardenStage.lightUponLight;
  }
  if (maturityPercent >= 64) {
    return GrowthGardenStage.flourishing;
  }
  if (maturityPercent >= 40) {
    return GrowthGardenStage.rooted;
  }
  if (maturityPercent >= 20) {
    return GrowthGardenStage.sprout;
  }
  return GrowthGardenStage.seed;
}
