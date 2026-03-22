import '../../journey/drops/domain/garden_asset_paths.dart';
import '../../journey/drops/domain/garden_milestones.dart';
import '../domain/garden_models.dart';

final List<GardenVisualStage> gardenVisualStages = <GardenVisualStage>[
  GardenVisualStage(
    stageId: GardenVisualStageId.seed,
    sortOrder: 1,
    minMaturityPercent: 0,
    assetPath: gardenImageAssetPath(gardenMilestones[0].imageAsset),
    imageAssetRef: gardenMilestones[0].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.sprout,
    sortOrder: 2,
    minMaturityPercent: 10,
    assetPath: gardenImageAssetPath(gardenMilestones[1].imageAsset),
    imageAssetRef: gardenMilestones[1].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.smallRoots,
    sortOrder: 3,
    minMaturityPercent: 20,
    assetPath: gardenImageAssetPath(gardenMilestones[2].imageAsset),
    imageAssetRef: gardenMilestones[2].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.youngStem,
    sortOrder: 4,
    minMaturityPercent: 30,
    assetPath: gardenImageAssetPath(gardenMilestones[3].imageAsset),
    imageAssetRef: gardenMilestones[3].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.smallTree,
    sortOrder: 5,
    minMaturityPercent: 40,
    assetPath: gardenImageAssetPath(gardenMilestones[4].imageAsset),
    imageAssetRef: gardenMilestones[4].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.strengtheningTrunk,
    sortOrder: 6,
    minMaturityPercent: 52,
    assetPath: gardenImageAssetPath(gardenMilestones[5].imageAsset),
    imageAssetRef: gardenMilestones[5].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.branchGrowth,
    sortOrder: 7,
    minMaturityPercent: 64,
    assetPath: gardenImageAssetPath(gardenMilestones[6].imageAsset),
    imageAssetRef: gardenMilestones[6].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.leafGrowth,
    sortOrder: 8,
    minMaturityPercent: 76,
    assetPath: gardenImageAssetPath(gardenMilestones[7].imageAsset),
    imageAssetRef: gardenMilestones[7].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.fruitBeginning,
    sortOrder: 9,
    minMaturityPercent: 88,
    assetPath: gardenImageAssetPath(gardenMilestones[8].imageAsset),
    imageAssetRef: gardenMilestones[8].imageAsset,
  ),
  GardenVisualStage(
    stageId: GardenVisualStageId.flourishingTree,
    sortOrder: 10,
    minMaturityPercent: 96,
    assetPath: gardenImageAssetPath(gardenMilestones[9].imageAsset),
    imageAssetRef: gardenMilestones[9].imageAsset,
  ),
];
