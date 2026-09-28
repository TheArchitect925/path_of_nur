import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/application/daily_clock_provider.dart';
import '../domain/dhikr_day_total.dart';
import 'dhikr_controller.dart';
import 'dhikr_history_math.dart';
import 'dhikr_routine_catalog.dart';

/// Consecutive active days ending today (or yesterday when today is quiet).
final dhikrStreakProvider = Provider<int>((ref) {
  final totals = ref.watch(
    dhikrControllerProvider.select((state) => state.dailyTotals),
  );
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return dhikrStreakDays(totals, now);
});

/// Twelve weeks of daily counts, oldest first, for the landing heatmap.
final dhikrHeatmapValuesProvider = Provider<List<double>>((ref) {
  final totals = ref.watch(
    dhikrControllerProvider.select((state) => state.dailyTotals),
  );
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return dhikrDailyValues(totals, now, days: 84);
});

class DhikrRoutineWeekStat {
  const DhikrRoutineWeekStat({
    required this.routineId,
    required this.done,
    required this.possible,
  });

  final String routineId;
  final int done;
  final int possible;

  double get fraction => possible <= 0 ? 0 : (done / possible).clamp(0, 1);
}

class DhikrInsights {
  const DhikrInsights({
    required this.thisWeek,
    required this.lastWeek,
    required this.lifetime,
    required this.bestWeek,
    required this.streak,
    required this.bestStreak,
    required this.activeDaysInWindow,
    required this.weekValues,
    required this.routineStats,
    required this.freeSessionsThisWeek,
    required this.favoritePhrase,
    required this.favoriteCount,
    required this.earliestDateKey,
  });

  final int thisWeek;
  final int lastWeek;
  final int lifetime;
  final int bestWeek;
  final int streak;
  final int bestStreak;
  final int activeDaysInWindow;
  final List<int> weekValues;
  final List<DhikrRoutineWeekStat> routineStats;
  final int freeSessionsThisWeek;
  final String? favoritePhrase;
  final int favoriteCount;
  final String? earliestDateKey;

  bool get isEmpty => lifetime <= 0;

  /// The routine with the lowest completion this week, if any is lagging.
  DhikrRoutineWeekStat? get quietestRoutine {
    DhikrRoutineWeekStat? quietest;
    for (final stat in routineStats) {
      if (stat.possible <= 0) continue;
      if (quietest == null || stat.fraction < quietest.fraction) {
        quietest = stat;
      }
    }
    if (quietest == null || quietest.fraction >= 0.7) return null;
    return quietest;
  }
}

final dhikrInsightsProvider = Provider<DhikrInsights>((ref) {
  final state = ref.watch(dhikrControllerProvider);
  final totals = state.dailyTotals;
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final routines = ref.watch(dhikrRoutinesProvider);

  final thisWeek = dhikrSumOverDays(totals, now, days: 7);
  final lastWeek = dhikrSumOverDays(totals, now, days: 14) - thisWeek;
  final weekValues = dhikrDailyValues(
    totals,
    now,
    days: 7,
  ).map((value) => value.round()).toList(growable: false);

  final routineStats = <DhikrRoutineWeekStat>[
    for (final routine in routines)
      if (routine.id == kDhikrRoutineAfterSalahId)
        DhikrRoutineWeekStat(
          routineId: routine.id,
          done: dhikrRoutineRunsInWindow(
            totals,
            now,
            routineId: routine.id,
            days: 7,
          ),
          possible: 35,
        )
      else
        DhikrRoutineWeekStat(
          routineId: routine.id,
          done: dhikrRoutineDaysInWindow(
            totals,
            now,
            routineId: routine.id,
            days: 7,
          ),
          possible: 7,
        ),
  ];

  var routineSessionsThisWeek = 0;
  var sessionsThisWeek = 0;
  final end = DateTime(now.year, now.month, now.day);
  for (var offset = 0; offset < 7; offset++) {
    final total = totals[dhikrDayKey(end.subtract(Duration(days: offset)))];
    if (total == null) continue;
    sessionsThisWeek += total.sessions;
    routineSessionsThisWeek += total.routineEntries.length;
  }

  String? favorite;
  var favoriteCount = 0;
  for (final entry in state.phraseTotals.entries) {
    if (entry.value > favoriteCount) {
      favorite = entry.key;
      favoriteCount = entry.value;
    }
  }

  return DhikrInsights(
    thisWeek: thisWeek,
    lastWeek: lastWeek < 0 ? 0 : lastWeek,
    lifetime: dhikrLifetimeCount(totals),
    bestWeek: dhikrBestWeekCount(totals),
    streak: dhikrStreakDays(totals, now),
    bestStreak: dhikrBestStreakDays(totals),
    activeDaysInWindow: dhikrActiveDays(totals, now, days: 84),
    weekValues: weekValues,
    routineStats: routineStats,
    freeSessionsThisWeek: (sessionsThisWeek - routineSessionsThisWeek).clamp(
      0,
      1 << 30,
    ),
    favoritePhrase: favorite,
    favoriteCount: favoriteCount,
    earliestDateKey: dhikrEarliestDateKey(totals),
  );
});
