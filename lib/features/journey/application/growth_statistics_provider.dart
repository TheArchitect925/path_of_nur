import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../learn/quran/application/quran_providers.dart';
import '../../journey/drops/data/journey_drops_repository.dart';
import '../../journey/drops/domain/journey_drops_models.dart';
import '../../journey/xp/data/journey_xp_repository.dart';
import '../../journey/xp/domain/journey_xp_models.dart';
import '../../worship/data/dhikr_repository.dart';
import '../../worship/data/prayer_log_repository.dart';
import 'journey_progression_provider.dart';
import 'journey_stats_provider.dart';

class GrowthStatsDailyRollup {
  const GrowthStatsDailyRollup({
    required this.dayKey,
    this.prayersCompleted = 0,
    this.dhikrSessions = 0,
    this.dhikrCount = 0,
    this.quranReadingSeconds = 0,
    this.quranListeningSeconds = 0,
    this.reflectionEntries = 0,
    this.learningCompletions = 0,
    this.xpGained = 0,
    this.dropsGained = 0,
    this.dayScore = 0,
  });

  final String dayKey;
  final int prayersCompleted;
  final int dhikrSessions;
  final int dhikrCount;
  final int quranReadingSeconds;
  final int quranListeningSeconds;
  final int reflectionEntries;
  final int learningCompletions;
  final int xpGained;
  final int dropsGained;
  final double dayScore;

  int get quranTotalSeconds => quranReadingSeconds + quranListeningSeconds;

  bool get hasActivity =>
      prayersCompleted > 0 ||
      dhikrSessions > 0 ||
      dhikrCount > 0 ||
      quranTotalSeconds > 0 ||
      reflectionEntries > 0 ||
      learningCompletions > 0 ||
      xpGained > 0 ||
      dropsGained > 0 ||
      dayScore > 0;

  GrowthStatsDailyRollup copyWith({
    int? prayersCompleted,
    int? dhikrSessions,
    int? dhikrCount,
    int? quranReadingSeconds,
    int? quranListeningSeconds,
    int? reflectionEntries,
    int? learningCompletions,
    int? xpGained,
    int? dropsGained,
    double? dayScore,
  }) {
    return GrowthStatsDailyRollup(
      dayKey: dayKey,
      prayersCompleted: prayersCompleted ?? this.prayersCompleted,
      dhikrSessions: dhikrSessions ?? this.dhikrSessions,
      dhikrCount: dhikrCount ?? this.dhikrCount,
      quranReadingSeconds: quranReadingSeconds ?? this.quranReadingSeconds,
      quranListeningSeconds:
          quranListeningSeconds ?? this.quranListeningSeconds,
      reflectionEntries: reflectionEntries ?? this.reflectionEntries,
      learningCompletions: learningCompletions ?? this.learningCompletions,
      xpGained: xpGained ?? this.xpGained,
      dropsGained: dropsGained ?? this.dropsGained,
      dayScore: dayScore ?? this.dayScore,
    );
  }
}

class GrowthStatsPeriodSummary {
  const GrowthStatsPeriodSummary({
    required this.start,
    required this.end,
    required this.prayersCompleted,
    required this.dhikrSessions,
    required this.dhikrCount,
    required this.quranSeconds,
    required this.reflectionEntries,
    required this.learningCompletions,
    required this.xpGained,
    required this.dropsGained,
    required this.activeDays,
    required this.averageDayScore,
  });

  final DateTime start;
  final DateTime end;
  final int prayersCompleted;
  final int dhikrSessions;
  final int dhikrCount;
  final int quranSeconds;
  final int reflectionEntries;
  final int learningCompletions;
  final int xpGained;
  final int dropsGained;
  final int activeDays;
  final double averageDayScore;

  bool get hasActivity =>
      prayersCompleted > 0 ||
      dhikrSessions > 0 ||
      dhikrCount > 0 ||
      quranSeconds > 0 ||
      reflectionEntries > 0 ||
      learningCompletions > 0 ||
      xpGained > 0 ||
      dropsGained > 0;
}

class GrowthStatsChartPoint {
  const GrowthStatsChartPoint({
    required this.start,
    required this.end,
    required this.value,
    required this.prayersCompleted,
    required this.dhikrCount,
    required this.quranSeconds,
    required this.xpGained,
    required this.dropsGained,
  });

  final DateTime start;
  final DateTime end;
  final double value;
  final int prayersCompleted;
  final int dhikrCount;
  final int quranSeconds;
  final int xpGained;
  final int dropsGained;
}

class GrowthBestDayInsight {
  const GrowthBestDayInsight({
    required this.dayKey,
    required this.day,
    required this.dayScore,
    required this.prayersCompleted,
    required this.dhikrCount,
    required this.quranSeconds,
    required this.xpGained,
    required this.dropsGained,
  });

  final String dayKey;
  final DateTime day;
  final double dayScore;
  final int prayersCompleted;
  final int dhikrCount;
  final int quranSeconds;
  final int xpGained;
  final int dropsGained;
}

class GrowthRewardsInsight {
  const GrowthRewardsInsight({
    required this.weeklyXp,
    required this.weeklyDrops,
    required this.topXpModule,
    required this.topXpValue,
    required this.topDropSource,
    required this.topDropValue,
  });

  final int weeklyXp;
  final int weeklyDrops;
  final String? topXpModule;
  final int topXpValue;
  final DropSourceType? topDropSource;
  final int topDropValue;

  bool get hasAnyRewardSignal =>
      weeklyXp > 0 ||
      weeklyDrops > 0 ||
      topXpModule != null ||
      topDropSource != null;
}

class GrowthStatisticsDashboardData {
  const GrowthStatisticsDashboardData({
    required this.weeklySummary,
    required this.monthlySummary,
    required this.previousWeeklySummary,
    required this.previousMonthlySummary,
    required this.weeklyTrend,
    required this.monthlyTrend,
    required this.bestDay,
    required this.rewardsInsight,
  });

  final GrowthStatsPeriodSummary weeklySummary;
  final GrowthStatsPeriodSummary monthlySummary;
  final GrowthStatsPeriodSummary? previousWeeklySummary;
  final GrowthStatsPeriodSummary? previousMonthlySummary;
  final List<GrowthStatsChartPoint> weeklyTrend;
  final List<GrowthStatsChartPoint> monthlyTrend;
  final GrowthBestDayInsight? bestDay;
  final GrowthRewardsInsight rewardsInsight;

  bool get hasAnyActivity =>
      weeklySummary.hasActivity ||
      monthlySummary.hasActivity ||
      bestDay != null ||
      rewardsInsight.hasAnyRewardSignal;
}

final growthStatisticsDashboardProvider =
    Provider<GrowthStatisticsDashboardData>((ref) {
      final now = ref.watch(journeyStatsNowProvider);
      final prayerRepository = ref.watch(prayerLogRepositoryProvider);
      final dhikrRepository = ref.watch(dhikrRepositoryProvider);
      final quranStats = ref.watch(quranReadingStatsProvider);
      final quranListeningStats = ref.watch(quranListeningStatsProvider);
      final xpRepository = ref.watch(journeyXpRepositoryProvider);
      final dropsRepository = ref.watch(journeyDropsRepositoryProvider);
      final journeyProgress = ref.watch(journeyProgressProvider);

      prayerRepository.ensureMigrated();
      dhikrRepository.ensureMigrated();

      final rollups = <String, GrowthStatsDailyRollup>{};

      for (final entry in journeyProgress.dayMetricsByKey.entries) {
        final key = entry.key;
        final metrics = entry.value;
        rollups[key] = GrowthStatsDailyRollup(
          dayKey: key,
          prayersCompleted: metrics.prayerCompleted,
          dhikrSessions: metrics.dhikrSessions,
          dhikrCount: metrics.dhikrCount,
          reflectionEntries: metrics.reflectionEntries,
          learningCompletions: metrics.learningStageCompletions,
          dayScore: journeyProgress.dayScoreByKey[key] ?? 0,
        );
      }

      for (final entry in quranStats.secondsByDayKey.entries) {
        final current =
            rollups[entry.key] ?? GrowthStatsDailyRollup(dayKey: entry.key);
        rollups[entry.key] = current.copyWith(quranReadingSeconds: entry.value);
      }

      for (final entry in quranListeningStats.secondsByDayKey.entries) {
        final current =
            rollups[entry.key] ?? GrowthStatsDailyRollup(dayKey: entry.key);
        rollups[entry.key] = current.copyWith(
          quranListeningSeconds: entry.value,
        );
      }

      for (final entry in xpRepository.getAllLedgerEntries()) {
        final current =
            rollups[entry.eventDateKey] ??
            GrowthStatsDailyRollup(dayKey: entry.eventDateKey);
        rollups[entry.eventDateKey] = current.copyWith(
          xpGained: current.xpGained + entry.awardedXp,
        );
      }

      for (final entry in dropsRepository.fetchAllDrops()) {
        final current =
            rollups[entry.eventDateKey] ??
            GrowthStatsDailyRollup(dayKey: entry.eventDateKey);
        rollups[entry.eventDateKey] = current.copyWith(
          dropsGained: current.dropsGained + 1,
        );
      }

      final today = DateTime(now.year, now.month, now.day);
      final weeklyDays = _daysInclusive(today, 7);
      final previousWeeklyDays = _daysInclusive(
        today.subtract(const Duration(days: 7)),
        7,
      );
      final monthlyDays = _daysInclusive(today, 28);
      final previousMonthlyDays = _daysInclusive(
        today.subtract(const Duration(days: 28)),
        28,
      );

      final weeklySummary = _buildSummary(rollups, weeklyDays);
      final previousWeeklySummary = _buildSummary(rollups, previousWeeklyDays);
      final monthlySummary = _buildSummary(rollups, monthlyDays);
      final previousMonthlySummary = _buildSummary(
        rollups,
        previousMonthlyDays,
      );

      final weeklyTrend = weeklyDays
          .map((day) {
            final rollup = _rollupForDay(rollups, day);
            return GrowthStatsChartPoint(
              start: day,
              end: day,
              value: _chartValueForRollup(rollup),
              prayersCompleted: rollup.prayersCompleted,
              dhikrCount: rollup.dhikrCount,
              quranSeconds: rollup.quranTotalSeconds,
              xpGained: rollup.xpGained,
              dropsGained: rollup.dropsGained,
            );
          })
          .toList(growable: false);

      final monthlyTrend = <GrowthStatsChartPoint>[];
      for (var index = 0; index < 4; index++) {
        final start = monthlyDays[index * 7];
        final end = monthlyDays[(index * 7) + 6];
        final days = monthlyDays.sublist(index * 7, (index * 7) + 7);
        final summary = _buildSummary(rollups, days);
        monthlyTrend.add(
          GrowthStatsChartPoint(
            start: start,
            end: end,
            value: _chartValueForSummary(summary),
            prayersCompleted: summary.prayersCompleted,
            dhikrCount: summary.dhikrCount,
            quranSeconds: summary.quranSeconds,
            xpGained: summary.xpGained,
            dropsGained: summary.dropsGained,
          ),
        );
      }

      final rewardsWindowStart = today.subtract(const Duration(days: 6));
      final rewardsInsight = _buildRewardsInsight(
        xpRepository.getLedgerEntriesInRange(
          rewardsWindowStart,
          today
              .add(const Duration(days: 1))
              .subtract(const Duration(milliseconds: 1)),
        ),
        dropsRepository.fetchDropsByDateRange(
          rewardsWindowStart,
          today
              .add(const Duration(days: 1))
              .subtract(const Duration(milliseconds: 1)),
        ),
      );

      return GrowthStatisticsDashboardData(
        weeklySummary: weeklySummary,
        monthlySummary: monthlySummary,
        previousWeeklySummary: previousWeeklySummary.hasActivity
            ? previousWeeklySummary
            : null,
        previousMonthlySummary: previousMonthlySummary.hasActivity
            ? previousMonthlySummary
            : null,
        weeklyTrend: weeklyTrend,
        monthlyTrend: monthlyTrend,
        bestDay: _buildBestDayInsight(rollups),
        rewardsInsight: rewardsInsight,
      );
    });

GrowthStatsPeriodSummary _buildSummary(
  Map<String, GrowthStatsDailyRollup> rollups,
  List<DateTime> days,
) {
  var prayersCompleted = 0;
  var dhikrSessions = 0;
  var dhikrCount = 0;
  var quranSeconds = 0;
  var reflectionEntries = 0;
  var learningCompletions = 0;
  var xpGained = 0;
  var dropsGained = 0;
  var activeDays = 0;
  var dayScoreSum = 0.0;

  for (final day in days) {
    final rollup = _rollupForDay(rollups, day);
    prayersCompleted += rollup.prayersCompleted;
    dhikrSessions += rollup.dhikrSessions;
    dhikrCount += rollup.dhikrCount;
    quranSeconds += rollup.quranTotalSeconds;
    reflectionEntries += rollup.reflectionEntries;
    learningCompletions += rollup.learningCompletions;
    xpGained += rollup.xpGained;
    dropsGained += rollup.dropsGained;
    if (rollup.hasActivity) {
      activeDays += 1;
    }
    dayScoreSum += rollup.dayScore;
  }

  return GrowthStatsPeriodSummary(
    start: days.first,
    end: days.last,
    prayersCompleted: prayersCompleted,
    dhikrSessions: dhikrSessions,
    dhikrCount: dhikrCount,
    quranSeconds: quranSeconds,
    reflectionEntries: reflectionEntries,
    learningCompletions: learningCompletions,
    xpGained: xpGained,
    dropsGained: dropsGained,
    activeDays: activeDays,
    averageDayScore: days.isEmpty ? 0 : dayScoreSum / days.length,
  );
}

GrowthStatsDailyRollup _rollupForDay(
  Map<String, GrowthStatsDailyRollup> rollups,
  DateTime day,
) {
  return rollups[LocalStore.todayKey(day)] ??
      GrowthStatsDailyRollup(dayKey: LocalStore.todayKey(day));
}

List<DateTime> _daysInclusive(DateTime endInclusive, int count) {
  final start = endInclusive.subtract(Duration(days: count - 1));
  return List<DateTime>.generate(
    count,
    (index) => DateTime(start.year, start.month, start.day + index),
    growable: false,
  );
}

double _chartValueForRollup(GrowthStatsDailyRollup rollup) {
  if (!rollup.hasActivity) return 0;
  return (rollup.dayScore * 100) +
      rollup.xpGained.toDouble() +
      (rollup.dropsGained * 12) +
      rollup.prayersCompleted.toDouble() +
      (rollup.dhikrCount / 10) +
      (rollup.quranTotalSeconds / 60);
}

double _chartValueForSummary(GrowthStatsPeriodSummary summary) {
  if (!summary.hasActivity) return 0;
  return (summary.averageDayScore * 100) +
      summary.xpGained.toDouble() +
      (summary.dropsGained * 12) +
      summary.prayersCompleted.toDouble() +
      (summary.dhikrCount / 10) +
      (summary.quranSeconds / 60);
}

GrowthBestDayInsight? _buildBestDayInsight(
  Map<String, GrowthStatsDailyRollup> rollups,
) {
  final candidates = rollups.values.where((item) => item.hasActivity).toList();
  if (candidates.isEmpty) return null;

  candidates.sort((left, right) {
    final byScore = right.dayScore.compareTo(left.dayScore);
    if (byScore != 0) return byScore;
    final byXp = right.xpGained.compareTo(left.xpGained);
    if (byXp != 0) return byXp;
    final byDrops = right.dropsGained.compareTo(left.dropsGained);
    if (byDrops != 0) return byDrops;
    return right.dayKey.compareTo(left.dayKey);
  });

  final best = candidates.first;
  return GrowthBestDayInsight(
    dayKey: best.dayKey,
    day: DateTime.parse('${best.dayKey}T00:00:00'),
    dayScore: best.dayScore,
    prayersCompleted: best.prayersCompleted,
    dhikrCount: best.dhikrCount,
    quranSeconds: best.quranTotalSeconds,
    xpGained: best.xpGained,
    dropsGained: best.dropsGained,
  );
}

GrowthRewardsInsight _buildRewardsInsight(
  List<XpLedgerEntry> xpEntries,
  List<DropEvent> dropEvents,
) {
  final xpByModule = <String, int>{};
  for (final entry in xpEntries) {
    xpByModule.update(
      entry.sourceModule,
      (value) => value + entry.awardedXp,
      ifAbsent: () => entry.awardedXp,
    );
  }

  final dropsBySource = <DropSourceType, int>{};
  for (final entry in dropEvents) {
    dropsBySource.update(
      entry.sourceType,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  final topXp = xpByModule.entries.isEmpty
      ? null
      : xpByModule.entries.reduce((left, right) {
          return right.value > left.value ? right : left;
        });
  final topDrops = dropsBySource.entries.isEmpty
      ? null
      : dropsBySource.entries.reduce((left, right) {
          return right.value > left.value ? right : left;
        });

  return GrowthRewardsInsight(
    weeklyXp: xpEntries.fold<int>(0, (sum, item) => sum + item.awardedXp),
    weeklyDrops: dropEvents.length,
    topXpModule: topXp?.key,
    topXpValue: topXp?.value ?? 0,
    topDropSource: topDrops?.key,
    topDropValue: topDrops?.value ?? 0,
  );
}
