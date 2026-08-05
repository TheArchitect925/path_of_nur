import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/journey_drops_models.dart';

final gardenUnlockServiceProvider = Provider<GardenUnlockService>((ref) {
  return const GardenUnlockService();
});

class GardenUnlockService {
  const GardenUnlockService();

  bool isUnlocked(GardenMilestone milestone, int totalDrops) {
    return milestone.isUnlocked(totalDrops);
  }

  int unlockedCount(List<GardenMilestone> milestones, int totalDrops) {
    return milestones
        .where((milestone) => isUnlocked(milestone, totalDrops))
        .length;
  }

  GardenMilestone? nextLockedMilestone(
    List<GardenMilestone> milestones,
    int totalDrops,
  ) {
    for (final milestone in milestones) {
      if (!isUnlocked(milestone, totalDrops)) return milestone;
    }
    return null;
  }

  GardenProgressSummary buildProgressSummary(
    List<GardenMilestone> milestones, {
    required int totalDrops,
  }) {
    final unlocked = unlockedCount(milestones, totalDrops);
    final next = nextLockedMilestone(milestones, totalDrops);
    if (next == null) {
      return GardenProgressSummary(
        totalDrops: totalDrops,
        unlockedCount: unlocked,
        totalMilestones: milestones.length,
        nextRequiredDrops: null,
        dropsRemaining: 0,
        progressToNext: 1,
      );
    }

    final nextIndex = milestones.indexOf(next);
    final previousRequiredDrops = nextIndex > 0
        ? milestones[nextIndex - 1].requiredDrops
        : 0;
    final span = (next.requiredDrops - previousRequiredDrops).clamp(1, 1 << 30);
    final progressed = (totalDrops - previousRequiredDrops).clamp(0, span);
    final progress = (progressed / span).clamp(0.0, 1.0);

    return GardenProgressSummary(
      totalDrops: totalDrops,
      unlockedCount: unlocked,
      totalMilestones: milestones.length,
      nextRequiredDrops: next.requiredDrops,
      dropsRemaining: (next.requiredDrops - totalDrops).clamp(0, 1 << 30),
      progressToNext: progress,
    );
  }
}
