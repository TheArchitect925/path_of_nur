import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/drops/application/garden_unlock_service.dart';
import 'package:path_of_nur/features/journey/drops/domain/garden_milestones.dart';

void main() {
  const service = GardenUnlockService();

  test('unlocked count follows milestone thresholds', () {
    expect(service.unlockedCount(gardenMilestones, 0), 0);
    expect(service.unlockedCount(gardenMilestones, 1), 1);
    expect(service.unlockedCount(gardenMilestones, 49), 3);
    expect(service.unlockedCount(gardenMilestones, 1000), 10);
  });

  test('next locked milestone selects the next unmet threshold', () {
    expect(
      service.nextLockedMilestone(gardenMilestones, 0)?.requiredDrops,
      1,
    );
    expect(
      service.nextLockedMilestone(gardenMilestones, 25)?.requiredDrops,
      50,
    );
    expect(service.nextLockedMilestone(gardenMilestones, 1000), isNull);
  });

  test('progress summary computes remaining drops and normalized progress', () {
    final summary = service.buildProgressSummary(
      gardenMilestones,
      totalDrops: 75,
    );

    expect(summary.totalDrops, 75);
    expect(summary.unlockedCount, 4);
    expect(summary.totalMilestones, 10);
    expect(summary.nextRequiredDrops, 100);
    expect(summary.dropsRemaining, 25);
    expect(summary.progressToNext, closeTo(0.5, 0.0001));
  });

  test('progress summary reports completion once all milestones are unlocked', () {
    final summary = service.buildProgressSummary(
      gardenMilestones,
      totalDrops: 1000,
    );

    expect(summary.allUnlocked, isTrue);
    expect(summary.nextRequiredDrops, isNull);
    expect(summary.dropsRemaining, 0);
    expect(summary.progressToNext, 1);
  });
}
