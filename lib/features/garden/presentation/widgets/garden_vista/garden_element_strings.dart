import '../../../../../l10n/app_localizations.dart';
import '../../../domain/garden_models.dart';
import '../../../domain/garden_scene_models.dart';

/// Bridges the generated (static) localization getters to the enum-keyed
/// scene catalog. Kept in one place so a new element fails loudly here rather
/// than silently rendering a raw key.
abstract final class GardenElementStrings {
  static String title(AppLocalizations l10n, GardenSceneElementId id) {
    return switch (id) {
      GardenSceneElementId.centralTree => l10n.gardenElementCentralTreeTitle,
      GardenSceneElementId.stream => l10n.gardenElementStreamTitle,
      GardenSceneElementId.oceanHorizon => l10n.gardenElementOceanTitle,
      GardenSceneElementId.olive => l10n.gardenElementOliveTitle,
      GardenSceneElementId.datePalm => l10n.gardenElementDatePalmTitle,
      GardenSceneElementId.fig => l10n.gardenElementFigTitle,
      GardenSceneElementId.pomegranate => l10n.gardenElementPomegranateTitle,
      GardenSceneElementId.grapeVine => l10n.gardenElementGrapeVineTitle,
      GardenSceneElementId.gourd => l10n.gardenElementGourdTitle,
      GardenSceneElementId.loteTree => l10n.gardenElementLoteTreeTitle,
      GardenSceneElementId.rayhan => l10n.gardenElementRayhanTitle,
      GardenSceneElementId.bee => l10n.gardenElementBeeTitle,
      GardenSceneElementId.ant => l10n.gardenElementAntTitle,
      GardenSceneElementId.hoopoe => l10n.gardenElementHoopoeTitle,
      GardenSceneElementId.songbirds => l10n.gardenElementSongbirdsTitle,
      GardenSceneElementId.fish => l10n.gardenElementFishTitle,
    };
  }

  static String meaning(AppLocalizations l10n, GardenSceneElementId id) {
    return switch (id) {
      GardenSceneElementId.centralTree => l10n.gardenElementCentralTreeMeaning,
      GardenSceneElementId.stream => l10n.gardenElementStreamMeaning,
      GardenSceneElementId.oceanHorizon => l10n.gardenElementOceanMeaning,
      GardenSceneElementId.olive => l10n.gardenElementOliveMeaning,
      GardenSceneElementId.datePalm => l10n.gardenElementDatePalmMeaning,
      GardenSceneElementId.fig => l10n.gardenElementFigMeaning,
      GardenSceneElementId.pomegranate =>
        l10n.gardenElementPomegranateMeaning,
      GardenSceneElementId.grapeVine => l10n.gardenElementGrapeVineMeaning,
      GardenSceneElementId.gourd => l10n.gardenElementGourdMeaning,
      GardenSceneElementId.loteTree => l10n.gardenElementLoteTreeMeaning,
      GardenSceneElementId.rayhan => l10n.gardenElementRayhanMeaning,
      GardenSceneElementId.bee => l10n.gardenElementBeeMeaning,
      GardenSceneElementId.ant => l10n.gardenElementAntMeaning,
      GardenSceneElementId.hoopoe => l10n.gardenElementHoopoeMeaning,
      GardenSceneElementId.songbirds => l10n.gardenElementSongbirdsMeaning,
      GardenSceneElementId.fish => l10n.gardenElementFishMeaning,
    };
  }

  static String stageTitle(AppLocalizations l10n, GardenVisualStageId stage) {
    return switch (stage) {
      GardenVisualStageId.seed => l10n.gardenStageSeed,
      GardenVisualStageId.sprout => l10n.gardenStageSprout,
      GardenVisualStageId.smallRoots => l10n.gardenStageRoots,
      GardenVisualStageId.youngStem => l10n.gardenStageStem,
      GardenVisualStageId.smallTree => l10n.gardenStageYoungTree,
      GardenVisualStageId.strengtheningTrunk => l10n.gardenStageTrunk,
      GardenVisualStageId.branchGrowth => l10n.gardenStageBranches,
      GardenVisualStageId.leafGrowth => l10n.gardenStageLeaves,
      GardenVisualStageId.fruitBeginning => l10n.gardenStageFruit,
      GardenVisualStageId.flourishingTree => l10n.gardenStageFlourishing,
    };
  }

  static String dimensionTitle(
    AppLocalizations l10n,
    GardenGrowthDimension dimension,
  ) {
    return switch (dimension) {
      GardenGrowthDimension.prayerFoundation => l10n.gardenDimensionPrayerTitle,
      GardenGrowthDimension.learningGrowth => l10n.gardenDimensionLearningTitle,
      GardenGrowthDimension.remembranceLight => l10n.gardenDimensionLightTitle,
      GardenGrowthDimension.mercyWater => l10n.gardenDimensionWaterTitle,
      GardenGrowthDimension.wisdomFruit => l10n.gardenDimensionFruitTitle,
      GardenGrowthDimension.consistencyBloom =>
        l10n.gardenDimensionConsistencyTitle,
    };
  }
}
