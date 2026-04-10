import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/journey/application/journey_progression_provider.dart';
import '../../../features/learn/journey/application/learning_journey_progress_provider.dart';
import '../../../features/worship/data/prayer_log_repository.dart';
import '../../../features/worship/domain/prayer_name.dart';
import '../../../features/worship/domain/prayer_status.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';

final homePrayerSelectedDateProvider = StateProvider.autoDispose<DateTime>((
  ref,
) {
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final homePrayerHistoryEditVersionProvider = StateProvider.autoDispose<int>((
  ref,
) {
  return 0;
});

enum HomeDayProgressLevel { empty, partial, complete }

class HomeDayProgressSummary {
  const HomeDayProgressSummary({
    required this.salah,
    required this.dhikr,
    required this.reading,
    required this.learning,
  });

  final HomeDayProgressLevel salah;
  final HomeDayProgressLevel dhikr;
  final HomeDayProgressLevel reading;
  final HomeDayProgressLevel learning;

  bool get hasAnyProgress =>
      salah != HomeDayProgressLevel.empty ||
      dhikr != HomeDayProgressLevel.empty ||
      reading != HomeDayProgressLevel.empty ||
      learning != HomeDayProgressLevel.empty;
}

final homeCalendarMonthProgressProvider =
    Provider.family<Map<DateTime, HomeDayProgressSummary>, DateTime>((
      ref,
      month,
    ) {
      ref.watch(homePrayerHistoryEditVersionProvider);
      final repository = ref.watch(prayerLogRepositoryProvider);
      final journeyProgress = ref.watch(journeyProgressProvider);
      final learningProgress = ref.watch(learningJourneyProgressProvider);
      final firstDay = DateTime(month.year, month.month, 1);
      final nextMonth = DateTime(month.year, month.month + 1, 1);
      final dayCount = nextMonth.difference(firstDay).inDays;
      final result = <DateTime, HomeDayProgressSummary>{};

      for (var day = 1; day <= dayCount; day += 1) {
        final date = DateTime(month.year, month.month, day);
        final dayKey = LocalStore.todayKey(date);
        final prayerEntries = repository.readDayEntries(dayKey);
        final journeyMetrics =
            journeyProgress.dayMetricsByKey[dayKey] ?? const JourneyDayMetrics();
        final learningCompletionsFromJourney =
            journeyMetrics.learningStageCompletions;
        final learningCompletionsFromProgress = learningProgress
            .completedStageDateKeys
            .values
            .where((value) => value == dayKey)
            .length;
        final touchedLearning =
            learningProgress.activeDayKeys.contains(dayKey) ||
            learningProgress.todayLightOpenedDayKeys.contains(dayKey);

        final summary = HomeDayProgressSummary(
          salah: _resolveSalahLevel(prayerEntries),
          dhikr: _resolveDhikrLevel(journeyMetrics),
          reading: _resolveReadingLevel(journeyMetrics),
          learning: _resolveLearningLevel(
            journeyMetrics: journeyMetrics,
            completedStageCount:
                learningCompletionsFromJourney + learningCompletionsFromProgress,
            touchedLearning: touchedLearning,
          ),
        );

        if (summary.hasAnyProgress) {
          result[date] = summary;
        }
      }

      return result;
    });

HomeDayProgressLevel _resolveSalahLevel(
  Map<PrayerName, PrayerLogDayEntry> entries,
) {
  var completed = 0;
  for (final prayer in obligatoryPrayerNames) {
    if ((entries[prayer]?.status ?? PrayerStatus.pending) ==
        PrayerStatus.completed) {
      completed += 1;
    }
  }
  if (completed >= obligatoryPrayerNames.length) {
    return HomeDayProgressLevel.complete;
  }
  if (completed > 0) {
    return HomeDayProgressLevel.partial;
  }
  return HomeDayProgressLevel.empty;
}

HomeDayProgressLevel _resolveDhikrLevel(JourneyDayMetrics metrics) {
  if (metrics.dhikrCount >= 500) {
    return HomeDayProgressLevel.complete;
  }
  if (metrics.dhikrCount > 0 || metrics.dhikrSessions > 0) {
    return HomeDayProgressLevel.partial;
  }
  return HomeDayProgressLevel.empty;
}

HomeDayProgressLevel _resolveReadingLevel(JourneyDayMetrics metrics) {
  if (metrics.quranEngagements >= 1) {
    return HomeDayProgressLevel.complete;
  }
  return HomeDayProgressLevel.empty;
}

HomeDayProgressLevel _resolveLearningLevel({
  required JourneyDayMetrics journeyMetrics,
  required int completedStageCount,
  required bool touchedLearning,
}) {
  if (completedStageCount > 0) {
    return HomeDayProgressLevel.complete;
  }
  if (journeyMetrics.learningStageCompletions > 0 || touchedLearning) {
    return HomeDayProgressLevel.partial;
  }
  return HomeDayProgressLevel.empty;
}
