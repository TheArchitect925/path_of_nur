import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../../shared/persistence/app_database.dart';
import '../../../shared/persistence/structured_data_scope.dart';
import '../../learn/content/application/learn_progress_provider.dart';
import '../../learn/quran/application/quran_providers.dart';
import '../../worship/data/dhikr_repository.dart';
import '../../worship/data/prayer_log_repository.dart';
import 'journey_progression_provider.dart';

const _journeyInstallStartedAtKey = 'journey.installStartedAtIso';

class JourneyStatsSummary {
  const JourneyStatsSummary({
    required this.installStartedAt,
    required this.timeSinceInstallSeconds,
    required this.totalTrackedWorshipGrowthSeconds,
    required this.trackedShareOfInstallTime,
    required this.otherUntrackedSeconds,
    required this.totalSalahOffered,
    required this.totalAdhkarCompletedLifetime,
    required this.totalPostSalahAdhkarCompleted,
    required this.totalDhikrSeconds,
    required this.totalQuranReadingSeconds,
    required this.todayQuranReadingSeconds,
    required this.totalQuranReadingSessions,
    required this.totalQuranListeningSeconds,
    required this.todayQuranListeningSeconds,
    required this.totalQuranListeningSessions,
    required this.dhikrCompletedSessions,
    required this.lessonsCompleted,
    required this.activeDays,
    required this.currentStreakDays,
    required this.bestStreakDays,
  });

  final DateTime installStartedAt;
  final int timeSinceInstallSeconds;
  final int totalTrackedWorshipGrowthSeconds;
  final double trackedShareOfInstallTime;
  final int otherUntrackedSeconds;
  final int totalSalahOffered;
  final int totalAdhkarCompletedLifetime;
  final int totalPostSalahAdhkarCompleted;
  final int totalDhikrSeconds;
  final int totalQuranReadingSeconds;
  final int todayQuranReadingSeconds;
  final int totalQuranReadingSessions;
  final int totalQuranListeningSeconds;
  final int todayQuranListeningSeconds;
  final int totalQuranListeningSessions;
  final int dhikrCompletedSessions;
  final int lessonsCompleted;
  final int activeDays;
  final int currentStreakDays;
  final int bestStreakDays;
}

final journeyStatsNowProvider = Provider<DateTime>((ref) => DateTime.now());

final journeyInstallStartedAtProvider = Provider<DateTime>((ref) {
  final store = ref.watch(localStoreProvider);
  final now = ref.watch(journeyStatsNowProvider);
  final raw = store.getString(_journeyInstallStartedAtKey);
  final parsed = raw == null ? null : DateTime.tryParse(raw);
  if (parsed != null) {
    return parsed;
  }
  final fallback = now.toIso8601String();
  unawaited(store.setString(_journeyInstallStartedAtKey, fallback));
  return now;
});

final journeyStatsSummaryProvider = Provider<JourneyStatsSummary>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final scopeId = ref.watch(structuredDataScopeProvider);
  final now = ref.watch(journeyStatsNowProvider);
  final installStartedAt = ref.watch(journeyInstallStartedAtProvider);
  final prayerRepository = ref.watch(prayerLogRepositoryProvider);
  final dhikrRepository = ref.watch(dhikrRepositoryProvider);
  final quranStats = ref.watch(quranReadingStatsProvider);
  final quranListeningStats = ref.watch(quranListeningStatsProvider);
  final learnSummary = ref.watch(learnProgressSummaryProvider);
  final journeyProgress = ref.watch(journeyProgressProvider);

  prayerRepository.ensureMigrated();
  dhikrRepository.ensureMigrated();

  final prayerCountRow = database.select(
    '''
    SELECT COUNT(*) AS total
    FROM prayer_records
    WHERE scope_id = ? AND status = ?;
    ''',
    <Object?>[scopeId, 'completed'],
  );
  final dhikrCountRow = database.select(
    '''
    SELECT COUNT(*) AS total
    FROM dhikr_sessions
    WHERE scope_id = ?;
    ''',
    <Object?>[scopeId],
  );
  final postSalahAdhkarCountRow = database.select(
    '''
    SELECT COUNT(*) AS total
    FROM prayer_records
    WHERE scope_id = ? AND post_salah_adhkar_completed_at_iso IS NOT NULL;
    ''',
    <Object?>[scopeId],
  );
  final dhikrDurationRow = database.select(
    '''
    SELECT SUM(
      MAX(
        0,
        CAST(strftime('%s', finished_at_iso) AS INTEGER) -
            CAST(strftime('%s', started_at_iso) AS INTEGER)
      )
    ) AS total
    FROM dhikr_sessions
    WHERE scope_id = ?;
    ''',
    <Object?>[scopeId],
  );

  final activeDays = journeyProgress.dayMetricsByKey.values
      .where(_hasMeaningfulJourneyActivity)
      .length;
  final dhikrCompletedSessions = (dhikrCountRow.first['total'] as int?) ?? 0;
  final totalPostSalahAdhkarCompleted =
      (postSalahAdhkarCountRow.first['total'] as int?) ?? 0;
  final totalDhikrSeconds = (dhikrDurationRow.first['total'] as int?) ?? 0;
  final totalTrackedWorshipGrowthSeconds =
      totalDhikrSeconds +
      quranStats.totalReadingSeconds +
      quranListeningStats.totalListeningSeconds;
  final timeSinceInstallSeconds = now
      .difference(installStartedAt)
      .inSeconds
      .clamp(0, 1 << 31);
  final safeTrackedSeconds = totalTrackedWorshipGrowthSeconds.clamp(
    0,
    timeSinceInstallSeconds,
  );
  final trackedShareOfInstallTime = timeSinceInstallSeconds <= 0
      ? 0.0
      : safeTrackedSeconds / timeSinceInstallSeconds;
  final otherUntrackedSeconds = timeSinceInstallSeconds - safeTrackedSeconds;

  return JourneyStatsSummary(
    installStartedAt: installStartedAt,
    timeSinceInstallSeconds: timeSinceInstallSeconds,
    totalTrackedWorshipGrowthSeconds: totalTrackedWorshipGrowthSeconds,
    trackedShareOfInstallTime: trackedShareOfInstallTime,
    otherUntrackedSeconds: otherUntrackedSeconds,
    totalSalahOffered: (prayerCountRow.first['total'] as int?) ?? 0,
    totalAdhkarCompletedLifetime:
        dhikrCompletedSessions + totalPostSalahAdhkarCompleted,
    totalPostSalahAdhkarCompleted: totalPostSalahAdhkarCompleted,
    totalDhikrSeconds: totalDhikrSeconds,
    totalQuranReadingSeconds: quranStats.totalReadingSeconds,
    todayQuranReadingSeconds: quranStats.secondsForDay(
      LocalStore.todayKey(),
    ),
    totalQuranReadingSessions: quranStats.totalSessions,
    totalQuranListeningSeconds: quranListeningStats.totalListeningSeconds,
    todayQuranListeningSeconds: quranListeningStats.secondsForDay(
      LocalStore.todayKey(),
    ),
    totalQuranListeningSessions: quranListeningStats.totalSessions,
    dhikrCompletedSessions: dhikrCompletedSessions,
    lessonsCompleted: learnSummary.completedCount,
    activeDays: activeDays,
    currentStreakDays: journeyProgress.currentStreakDays,
    bestStreakDays: journeyProgress.bestStreakDays,
  );
});

bool _hasMeaningfulJourneyActivity(JourneyDayMetrics metrics) {
  return metrics.prayerCompleted > 0 ||
      metrics.dhikrSessions > 0 ||
      metrics.quranEngagements > 0 ||
      metrics.reflectionEntries > 0 ||
      metrics.learningStageCompletions > 0 ||
      metrics.fastingCompleted > 0 ||
      metrics.fastingIntending > 0;
}
