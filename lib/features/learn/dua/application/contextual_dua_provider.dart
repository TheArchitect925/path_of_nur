import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../domain/dua_models.dart';
import 'dua_repository.dart';

/// Ranks the seeded duas against the present moment using the orchestration
/// metadata authored on every [DuaItem] (time/date/prayer contexts,
/// surface eligibility, priority score).
class ContextualDuaSuggestion {
  const ContextualDuaSuggestion({required this.item, required this.score});

  final DuaItem item;
  final int score;
}

const _maxContextualDuas = 3;

/// Time-of-day context ids active for [now], mirroring the seed data's
/// allowed time contexts (morning, afternoon, evening, night, before_sleep,
/// upon_waking).
Set<String> activeTimeContexts(DateTime now) {
  final hour = now.hour;
  final contexts = <String>{};
  if (hour >= 4 && hour < 12) {
    contexts.add('morning');
    if (hour < 9) contexts.add('upon_waking');
  } else if (hour >= 12 && hour < 17) {
    contexts.add('afternoon');
  } else if (hour >= 17 && hour < 21) {
    contexts.add('evening');
  } else {
    contexts.add('night');
    if (hour >= 21 || hour < 1) contexts.add('before_sleep');
  }
  return contexts;
}

Set<String> _activeDateContexts(DateTime now) {
  return <String>{if (now.weekday == DateTime.friday) 'friday'};
}

Set<String> _activePrayerContexts({
  required DateTime now,
  String? currentPrayerId,
  String? nextPrayerId,
}) {
  return <String>{
    if (currentPrayerId == 'fajr' || nextPrayerId == 'fajr') 'fajr_window',
    if (now.weekday == DateTime.friday) 'jumuah',
  };
}

int scoreDuaForContext(
  DuaItem item, {
  required Set<String> timeContexts,
  required Set<String> dateContexts,
  required Set<String> prayerContexts,
}) {
  var score = item.priorityScore;
  if (item.timeContexts.any(timeContexts.contains)) {
    score += 40;
  } else if (item.timeContexts.contains('any')) {
    score += 10;
  } else if (item.timeContexts.isNotEmpty) {
    // Authored for a different moment of the day; push it out of the row.
    score -= 100;
  }
  if (item.prayerContexts.any(prayerContexts.contains)) score += 30;
  if (item.dateContexts.any(dateContexts.contains)) score += 25;
  if (item.isCore) score += 5;
  return score;
}

final contextualDuaSuggestionsProvider =
    Provider<AsyncValue<List<ContextualDuaSuggestion>>>((ref) {
      final datasetAsync = ref.watch(duaDatasetProvider);
      final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
      final scheduleContext = ref.watch(prayerScheduleContextProvider);

      return datasetAsync.whenData((dataset) {
        final timeContexts = activeTimeContexts(now);
        final dateContexts = _activeDateContexts(now);
        final prayerContexts = _activePrayerContexts(
          now: now,
          currentPrayerId: scheduleContext.currentPrayerId,
          nextPrayerId: scheduleContext.nextPrayerId,
        );

        final suggestions =
            dataset.verifiedItems
                .where(
                  (item) =>
                      item.surfaceEligibility.contains('in_app') ||
                      item.surfaceEligibility.contains('daily_card'),
                )
                .map(
                  (item) => ContextualDuaSuggestion(
                    item: item,
                    score: scoreDuaForContext(
                      item,
                      timeContexts: timeContexts,
                      dateContexts: dateContexts,
                      prayerContexts: prayerContexts,
                    ),
                  ),
                )
                .toList()
              ..sort((a, b) {
                final byScore = b.score.compareTo(a.score);
                if (byScore != 0) return byScore;
                return a.item.title.compareTo(b.item.title);
              });

        return List<ContextualDuaSuggestion>.unmodifiable(
          suggestions.take(_maxContextualDuas),
        );
      });
    });
