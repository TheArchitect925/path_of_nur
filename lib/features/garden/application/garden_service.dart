import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey/application/journey_stats_provider.dart';
import '../../journey/drops/application/journey_drops_providers.dart';
import '../../journey/drops/domain/garden_asset_paths.dart';
import '../../journey/drops/domain/garden_milestones.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import '../../journey/xp/domain/journey_xp_models.dart';
import '../../kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import '../../kids/bedtime_stories/domain/bedtime_family_models.dart';
import '../../progression/application/learner_progression_service.dart';
import '../../progression/domain/learner_progression_models.dart';
import '../data/garden_stage_catalog.dart';
import '../domain/garden_models.dart';

final activeGardenStateProvider = Provider<GardenState>((ref) {
  final learner = ref.watch(bedtimeActiveLearnerProvider);
  return ref.watch(gardenStateProvider(learner.learnerId));
});

final gardenStateProvider = Provider.family<GardenState, String>((
  ref,
  learnerId,
) {
  final learner = ref
      .watch(bedtimeAvailableLearnersProvider)
      .firstWhere(
        (item) => item.learnerId == learnerId,
        orElse: () => BedtimeLearnerIdentity(
          learnerId: learnerId,
          displayName: learnerId,
          avatarReference: '',
          ageGroup: ref.watch(bedtimeActiveLearnerProvider).ageGroup,
          guardianProfileId: null,
          isFallbackLearner: true,
          preferences: const BedtimeLearnerPreferences(),
        ),
      );
  final summary = ref.watch(learnerProgressionSummaryProvider(learnerId));
  final state = ref.watch(learnerProgressionControllerProvider(learnerId));
  final journeyStats = ref.watch(journeyStatsSummaryProvider);
  final journeyXp = ref.watch(journeyXpSummaryProvider);
  final journeyDrops = ref.watch(journeyDropSummaryProvider);
  final service = ref.watch(gardenServiceProvider);
  return service.buildState(
    learner: learner,
    summary: summary,
    progressionState: state,
    globalJourneyStats: journeyStats,
    globalJourneyXp: journeyXp,
    globalJourneyDrops: journeyDrops.totalDrops,
  );
});

final gardenServiceProvider = Provider<GardenService>((ref) {
  return const GardenService();
});

class GardenService {
  const GardenService();

  GardenState buildState({
    required BedtimeLearnerIdentity learner,
    required LearnerProgressionSummary summary,
    required LearnerProgressionState progressionState,
    required JourneyStatsSummary globalJourneyStats,
    required XpSummary globalJourneyXp,
    required int globalJourneyDrops,
  }) {
    final usesJourneyFallback = learner.isFallbackLearner;
    final totalXp = usesJourneyFallback
        ? math.max(summary.metrics.totalXp, globalJourneyXp.totalXp)
        : summary.metrics.totalXp;
    final totalDrops = usesJourneyFallback
        ? math.max(summary.metrics.totalDrops, globalJourneyDrops)
        : summary.metrics.totalDrops;

    final prayerFoundationScore = _buildPrayerFoundationScore(
      metrics: summary.metrics,
      globalJourneyStats: globalJourneyStats,
      usesJourneyFallback: usesJourneyFallback,
    );
    final learningGrowthScore = _buildLearningGrowthScore(summary.metrics);
    final remembranceLightScore = _buildRemembranceLightScore(
      metrics: summary.metrics,
      globalJourneyStats: globalJourneyStats,
      usesJourneyFallback: usesJourneyFallback,
    );
    final consistencyScore = _buildConsistencyScore(
      metrics: summary.metrics,
      globalJourneyStats: globalJourneyStats,
      usesJourneyFallback: usesJourneyFallback,
    );
    final wisdomFruitScore = _buildWisdomFruitScore(
      metrics: summary.metrics,
      badgeCount: summary.unlockedBadges.length,
      milestoneCount: summary.unlockedMilestones.length,
    );
    final waterScore = _progressFromThreshold(totalDrops, 1000);

    final stageMaturity = _buildMaturityPercent(
      level: summary.xpSummary.currentLevel,
      waterScore: waterScore,
      prayerFoundationScore: prayerFoundationScore,
      learningGrowthScore: learningGrowthScore,
      remembranceLightScore: remembranceLightScore,
      consistencyScore: consistencyScore,
      wisdomFruitScore: wisdomFruitScore,
    );
    final stage = _resolveStage(stageMaturity);
    final nextStage = _resolveNextStage(stage);

    final dimensions = <GardenDimensionState>[
      GardenDimensionState(
        dimension: GardenGrowthDimension.prayerFoundation,
        score: prayerFoundationScore,
        emphasisPercent: _percent(prayerFoundationScore),
        summaryValue: usesJourneyFallback
            ? globalJourneyStats.totalSalahOffered
            : summary.metrics.bedtimeRoutineCompletions,
      ),
      GardenDimensionState(
        dimension: GardenGrowthDimension.learningGrowth,
        score: learningGrowthScore,
        emphasisPercent: _percent(learningGrowthScore),
        summaryValue:
            summary.metrics.storyCompletions +
            summary.metrics.quizCompletions +
            summary.metrics.memoryCompletions +
            summary.metrics.seerahNodeCompletions +
            summary.metrics.seerahStageCompletions +
            summary.metrics.seerahJourneyCompletions,
      ),
      GardenDimensionState(
        dimension: GardenGrowthDimension.remembranceLight,
        score: remembranceLightScore,
        emphasisPercent: _percent(remembranceLightScore),
        summaryValue: usesJourneyFallback
            ? globalJourneyStats.totalAdhkarCompletedLifetime
            : summary.metrics.duaLessonCompletions +
                  summary.metrics.duaPracticeSessions +
                  summary.metrics.duaMyDayCompletions,
      ),
      GardenDimensionState(
        dimension: GardenGrowthDimension.mercyWater,
        score: waterScore,
        emphasisPercent: _percent(waterScore),
        summaryValue: totalDrops,
      ),
      GardenDimensionState(
        dimension: GardenGrowthDimension.wisdomFruit,
        score: wisdomFruitScore,
        emphasisPercent: _percent(wisdomFruitScore),
        summaryValue:
            summary.unlockedBadges.length + summary.unlockedMilestones.length,
      ),
      GardenDimensionState(
        dimension: GardenGrowthDimension.consistencyBloom,
        score: consistencyScore,
        emphasisPercent: _percent(consistencyScore),
        summaryValue: summary.metrics.currentLearningStreakDays,
      ),
    ];

    final milestones = gardenMilestones
        .map(
          (milestone) => GardenMilestoneVisual(
            milestone: milestone,
            unlocked: milestone.isUnlocked(totalDrops),
            assetPath: gardenImageAssetPath(milestone.imageAsset),
          ),
        )
        .toList(growable: false);

    final recentGrowth = progressionState.entriesBySourceRef.values.toList(
      growable: false,
    )..sort((a, b) => b.occurredAtIso.compareTo(a.occurredAtIso));
    final recentItems = recentGrowth
        .take(4)
        .map(
          (entry) => GardenRecentGrowthItem(
            sourceRef: entry.sourceRef,
            activityType: entry.activityType,
            occurredAtIso: entry.occurredAtIso,
            xpAwarded: entry.xpAwarded,
            dropsAwarded: entry.oceanDropsAwarded,
          ),
        )
        .toList(growable: false);

    return GardenState(
      learnerId: learner.learnerId,
      isFallbackLearner: learner.isFallbackLearner,
      currentGardenLevel: summary.xpSummary.currentLevel,
      currentVisualStage: stage,
      nextVisualStage: nextStage,
      totalXp: totalXp,
      totalOceanDrops: totalDrops,
      prayerFoundationScore: prayerFoundationScore,
      learningGrowthScore: learningGrowthScore,
      remembranceLightScore: remembranceLightScore,
      consistencyScore: consistencyScore,
      wisdomFruitScore: wisdomFruitScore,
      lastUpdatedIso:
          progressionState.lastUpdatedAtIso ??
          globalJourneyXp.updatedAt.toIso8601String(),
      lastVisualRefreshAtIso:
          progressionState.lastUpdatedAtIso ??
          globalJourneyXp.updatedAt.toIso8601String(),
      unlockedVisualIds: milestones
          .where((item) => item.unlocked)
          .map((item) => item.milestone.id)
          .toList(growable: false),
      ambientState: _resolveAmbientState(
        stageMaturity: stageMaturity,
        remembranceLightScore: remembranceLightScore,
      ),
      progressToNextStage: _progressToNextStage(
        stageMaturity: stageMaturity,
        stage: stage,
        nextStage: nextStage,
      ),
      maturityPercent: stageMaturity,
      xpSummary: summary.xpSummary,
      metrics: summary.metrics,
      dimensions: dimensions,
      insights: _buildInsights(dimensions),
      recentGrowth: recentItems,
      milestones: milestones,
    );
  }

  double _buildPrayerFoundationScore({
    required LearnerProgressionMetrics metrics,
    required JourneyStatsSummary globalJourneyStats,
    required bool usesJourneyFallback,
  }) {
    if (usesJourneyFallback) {
      final prayerScore = _progressFromThreshold(
        globalJourneyStats.totalSalahOffered,
        400,
      );
      final streakScore = _progressFromThreshold(
        globalJourneyStats.currentStreakDays,
        30,
      );
      return ((prayerScore * 0.7) + (streakScore * 0.3)).clamp(0, 1);
    }
    final routineScore = _progressFromThreshold(
      metrics.bedtimeRoutineCompletions,
      30,
    );
    final streakScore = _progressFromThreshold(
      metrics.currentLearningStreakDays,
      30,
    );
    final activeRhythmScore = _progressFromThreshold(
      metrics.activeDayKeys.length,
      45,
    );
    return ((routineScore * 0.45) +
            (streakScore * 0.35) +
            (activeRhythmScore * 0.2))
        .clamp(0, 1);
  }

  double _buildLearningGrowthScore(LearnerProgressionMetrics metrics) {
    final storyScore = _progressFromThreshold(metrics.storyCompletions, 40);
    final arabicScore = _progressFromThreshold(
      metrics.kidsArabicLessonCompletions +
          metrics.kidsArabicDailyMissionCompletions,
      35,
    );
    final quizScore = _progressFromThreshold(metrics.quizCompletions, 24);
    final memoryScore = _progressFromThreshold(metrics.memoryCompletions, 20);
    final seerahScore = _progressFromThreshold(
      metrics.seerahNodeCompletions +
          (metrics.seerahStageCompletions * 2) +
          (metrics.seerahJourneyCompletions * 4),
      30,
    );
    return ((storyScore * 0.3) +
            (arabicScore * 0.15) +
            (quizScore * 0.18) +
            (memoryScore * 0.15) +
            (seerahScore * 0.22))
        .clamp(0, 1);
  }

  double _buildRemembranceLightScore({
    required LearnerProgressionMetrics metrics,
    required JourneyStatsSummary globalJourneyStats,
    required bool usesJourneyFallback,
  }) {
    final duaScore = _progressFromThreshold(
      metrics.duaLessonCompletions + metrics.duaMyDayCompletions,
      20,
    );
    final practiceScore = _progressFromThreshold(
      metrics.duaPracticeSessions,
      50,
    );
    final fallbackDhikrScore = usesJourneyFallback
        ? _progressFromThreshold(
            globalJourneyStats.totalAdhkarCompletedLifetime,
            300,
          )
        : 0;
    return ((duaScore * 0.5) +
            (practiceScore * 0.3) +
            (fallbackDhikrScore * 0.2))
        .clamp(0, 1);
  }

  double _buildConsistencyScore({
    required LearnerProgressionMetrics metrics,
    required JourneyStatsSummary globalJourneyStats,
    required bool usesJourneyFallback,
  }) {
    final currentStreakScore = _progressFromThreshold(
      metrics.currentLearningStreakDays,
      30,
    );
    final longestStreakScore = _progressFromThreshold(
      math.max(
        metrics.longestLearningStreakDays,
        globalJourneyStats.bestStreakDays,
      ),
      45,
    );
    final activeDaysScore = _progressFromThreshold(
      metrics.activeDayKeys.length,
      60,
    );
    final fallbackActiveDaysScore = usesJourneyFallback
        ? _progressFromThreshold(globalJourneyStats.activeDays, 90)
        : 0;
    return ((currentStreakScore * 0.35) +
            (longestStreakScore * 0.3) +
            (activeDaysScore * 0.25) +
            (fallbackActiveDaysScore * 0.1))
        .clamp(0, 1);
  }

  double _buildWisdomFruitScore({
    required LearnerProgressionMetrics metrics,
    required int badgeCount,
    required int milestoneCount,
  }) {
    final badgeScore = _progressFromThreshold(badgeCount, 8);
    final milestoneScore = _progressFromThreshold(milestoneCount, 8);
    final maturityScore = _progressFromThreshold(
      metrics.storyCompletions +
          metrics.duaLessonCompletions +
          metrics.seerahJourneyCompletions * 3,
      35,
    );
    return ((badgeScore * 0.35) +
            (milestoneScore * 0.35) +
            (maturityScore * 0.3))
        .clamp(0, 1);
  }

  int _buildMaturityPercent({
    required int level,
    required double waterScore,
    required double prayerFoundationScore,
    required double learningGrowthScore,
    required double remembranceLightScore,
    required double consistencyScore,
    required double wisdomFruitScore,
  }) {
    final levelScore = _progressFromThreshold(level, 100);
    final blended =
        (((levelScore * 0.28) +
                    (waterScore * 0.18) +
                    (prayerFoundationScore * 0.16) +
                    (learningGrowthScore * 0.16) +
                    (remembranceLightScore * 0.1) +
                    (consistencyScore * 0.07) +
                    (wisdomFruitScore * 0.05))
                .clamp(0, 1))
            .toDouble();
    return _percent(blended);
  }

  GardenVisualStage _resolveStage(int maturityPercent) {
    return gardenVisualStages.lastWhere(
      (stage) => maturityPercent >= stage.minMaturityPercent,
      orElse: () => gardenVisualStages.first,
    );
  }

  GardenVisualStage? _resolveNextStage(GardenVisualStage stage) {
    final currentIndex = gardenVisualStages.indexWhere(
      (item) => item.stageId == stage.stageId,
    );
    if (currentIndex < 0 || currentIndex >= gardenVisualStages.length - 1) {
      return null;
    }
    return gardenVisualStages[currentIndex + 1];
  }

  double _progressToNextStage({
    required int stageMaturity,
    required GardenVisualStage stage,
    required GardenVisualStage? nextStage,
  }) {
    if (nextStage == null) {
      return 1;
    }
    final span = nextStage.minMaturityPercent - stage.minMaturityPercent;
    if (span <= 0) {
      return 1;
    }
    return ((stageMaturity - stage.minMaturityPercent) / span).clamp(0, 1);
  }

  GardenAmbientState _resolveAmbientState({
    required int stageMaturity,
    required double remembranceLightScore,
  }) {
    if (remembranceLightScore >= 0.72) {
      return GardenAmbientState.warmLight;
    }
    if (stageMaturity >= 76) {
      return GardenAmbientState.eveningGlow;
    }
    if (stageMaturity >= 36) {
      return GardenAmbientState.gentleMorning;
    }
    return GardenAmbientState.quietDawn;
  }

  List<GardenInsightMessage> _buildInsights(
    List<GardenDimensionState> dimensions,
  ) {
    final strongest = dimensions.toList(growable: false)
      ..sort((a, b) => b.score.compareTo(a.score));
    return strongest
        .take(3)
        .map((dimension) {
          final key = switch (dimension.dimension) {
            GardenGrowthDimension.prayerFoundation => 'gardenInsightPrayer',
            GardenGrowthDimension.learningGrowth => 'gardenInsightLearning',
            GardenGrowthDimension.remembranceLight => 'gardenInsightLight',
            GardenGrowthDimension.mercyWater => 'gardenInsightWater',
            GardenGrowthDimension.wisdomFruit => 'gardenInsightFruit',
            GardenGrowthDimension.consistencyBloom =>
              'gardenInsightConsistency',
          };
          return GardenInsightMessage(
            dimension: dimension.dimension,
            messageKey: key,
          );
        })
        .toList(growable: false);
  }

  double _progressFromThreshold(int value, int threshold) {
    if (threshold <= 0) {
      return 1;
    }
    return (value / threshold).clamp(0, 1).toDouble();
  }

  int _percent(double value) => (value * 100).round().clamp(0, 100);
}
