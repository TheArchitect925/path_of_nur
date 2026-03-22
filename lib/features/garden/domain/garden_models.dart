import '../../journey/drops/domain/journey_drops_models.dart';
import '../../journey/xp/domain/journey_xp_models.dart';
import '../../progression/domain/learner_progression_models.dart';

enum GardenGrowthDimension {
  prayerFoundation,
  learningGrowth,
  remembranceLight,
  mercyWater,
  wisdomFruit,
  consistencyBloom,
}

enum GardenVisualStageId {
  seed,
  sprout,
  smallRoots,
  youngStem,
  smallTree,
  strengtheningTrunk,
  branchGrowth,
  leafGrowth,
  fruitBeginning,
  flourishingTree,
}

enum GardenAmbientState { quietDawn, gentleMorning, warmLight, eveningGlow }

class GardenVisualStage {
  const GardenVisualStage({
    required this.stageId,
    required this.sortOrder,
    required this.minMaturityPercent,
    required this.assetPath,
    required this.imageAssetRef,
  });

  final GardenVisualStageId stageId;
  final int sortOrder;
  final double minMaturityPercent;
  final String assetPath;
  final String imageAssetRef;
}

class GardenDimensionState {
  const GardenDimensionState({
    required this.dimension,
    required this.score,
    required this.emphasisPercent,
    required this.summaryValue,
  });

  final GardenGrowthDimension dimension;
  final double score;
  final int emphasisPercent;
  final int summaryValue;
}

class GardenInsightMessage {
  const GardenInsightMessage({
    required this.dimension,
    required this.messageKey,
  });

  final GardenGrowthDimension dimension;
  final String messageKey;
}

class GardenRecentGrowthItem {
  const GardenRecentGrowthItem({
    required this.sourceRef,
    required this.activityType,
    required this.occurredAtIso,
    required this.xpAwarded,
    required this.dropsAwarded,
  });

  final String sourceRef;
  final LearnerProgressionActivityType activityType;
  final String occurredAtIso;
  final int xpAwarded;
  final int dropsAwarded;
}

class GardenMilestoneVisual {
  const GardenMilestoneVisual({
    required this.milestone,
    required this.unlocked,
    required this.assetPath,
  });

  final GardenMilestone milestone;
  final bool unlocked;
  final String assetPath;
}

class GardenState {
  const GardenState({
    required this.learnerId,
    required this.isFallbackLearner,
    required this.currentGardenLevel,
    required this.currentVisualStage,
    required this.nextVisualStage,
    required this.totalXp,
    required this.totalOceanDrops,
    required this.prayerFoundationScore,
    required this.learningGrowthScore,
    required this.remembranceLightScore,
    required this.consistencyScore,
    required this.wisdomFruitScore,
    required this.lastUpdatedIso,
    required this.lastVisualRefreshAtIso,
    required this.unlockedVisualIds,
    required this.ambientState,
    required this.progressToNextStage,
    required this.maturityPercent,
    required this.xpSummary,
    required this.metrics,
    required this.dimensions,
    required this.insights,
    required this.recentGrowth,
    required this.milestones,
  });

  final String learnerId;
  final bool isFallbackLearner;
  final int currentGardenLevel;
  final GardenVisualStage currentVisualStage;
  final GardenVisualStage? nextVisualStage;
  final int totalXp;
  final int totalOceanDrops;
  final double prayerFoundationScore;
  final double learningGrowthScore;
  final double remembranceLightScore;
  final double consistencyScore;
  final double wisdomFruitScore;
  final String? lastUpdatedIso;
  final String? lastVisualRefreshAtIso;
  final List<String> unlockedVisualIds;
  final GardenAmbientState ambientState;
  final double progressToNextStage;
  final int maturityPercent;
  final XpSummary xpSummary;
  final LearnerProgressionMetrics metrics;
  final List<GardenDimensionState> dimensions;
  final List<GardenInsightMessage> insights;
  final List<GardenRecentGrowthItem> recentGrowth;
  final List<GardenMilestoneVisual> milestones;
}
