import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/worship/application/dhikr_controller.dart';
import '../../../features/worship/application/fasting_controller.dart';
import '../../../features/worship/application/prayer_controller.dart';
import '../../../features/worship/domain/fasting_status.dart';

class HomeDashboardSummary {
  const HomeDashboardSummary({
    required this.prayerCompleted,
    required this.prayerTotal,
    required this.dhikrCount,
    required this.dhikrTarget,
    required this.fastingStatus,
    required this.level,
    required this.xp,
    required this.nextLevelXpRemaining,
    required this.currentStreakDays,
    required this.ringPrayer,
    required this.ringDhikr,
    required this.ringQuran,
    required this.ringReflection,
    required this.ringFasting,
  });

  final int prayerCompleted;
  final int prayerTotal;
  final int dhikrCount;
  final int dhikrTarget;
  final FastingStatus fastingStatus;
  final int level;
  final int xp;
  final int nextLevelXpRemaining;
  final int currentStreakDays;
  final double ringPrayer;
  final double ringDhikr;
  final double ringQuran;
  final double ringReflection;
  final double ringFasting;
}

final homeDashboardSummaryProvider = Provider<HomeDashboardSummary>((ref) {
  final prayerSummary = ref.watch(prayerSummaryProvider);
  final dhikr = ref.watch(dhikrControllerProvider);
  final fasting = ref.watch(fastingControllerProvider);

  return HomeDashboardSummary(
    prayerCompleted: prayerSummary.completed,
    prayerTotal: prayerSummary.total,
    dhikrCount: dhikr.currentCount,
    dhikrTarget: dhikr.target,
    fastingStatus: fasting.todayStatus,
    level: 7,
    xp: 1620,
    nextLevelXpRemaining: 380,
    currentStreakDays: 6,
    ringPrayer: prayerSummary.progress,
    ringDhikr: dhikr.target <= 0
        ? 0
        : (dhikr.currentCount / dhikr.target).clamp(0, 1).toDouble(),
    ringQuran: 0.35,
    ringReflection: 0.28,
    ringFasting: fasting.todayStatus == FastingStatus.completed
        ? 1
        : fasting.todayStatus == FastingStatus.intending
            ? 0.55
            : fasting.todayStatus == FastingStatus.notFasting
                ? 0.12
                : 0.2,
  );
});

