import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../../../shared/utils/hijri_date_utils.dart';
import '../domain/fasting_status.dart';
import 'fasting_controller.dart';

/// What the fasting surfaces suggest today: Ramadan first, then the white
/// days (13th–15th Hijri), then Monday/Thursday sunnah fasts — today, or a
/// nudge for tomorrow.
class FastingSuggestion {
  const FastingSuggestion(this._labelBuilder);

  final String Function(AppLocalizations) _labelBuilder;

  String label(AppLocalizations l10n) => _labelBuilder(l10n);
}

final fastingSuggestionProvider = Provider.autoDispose<FastingSuggestion?>((
  ref,
) {
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final isRamadan = ref.watch(
    specialModeProvider.select((mode) => mode.isRamadan),
  );
  if (isRamadan) {
    return FastingSuggestion((l10n) => l10n.fastingSuggestionRamadan);
  }
  final hijriDay = toHijriDate(DateTime(now.year, now.month, now.day)).day;
  if (hijriDay >= 13 && hijriDay <= 15) {
    return FastingSuggestion((l10n) => l10n.fastingSuggestionWhiteDays);
  }
  if (now.weekday == DateTime.monday || now.weekday == DateTime.thursday) {
    return FastingSuggestion(
      (l10n) => now.weekday == DateTime.monday
          ? l10n.fastingSuggestionMondayToday
          : l10n.fastingSuggestionThursdayToday,
    );
  }
  final tomorrow = now.add(const Duration(days: 1));
  if (tomorrow.weekday == DateTime.monday ||
      tomorrow.weekday == DateTime.thursday) {
    return FastingSuggestion(
      (l10n) => tomorrow.weekday == DateTime.monday
          ? l10n.fastingSuggestionMondayTomorrow
          : l10n.fastingSuggestionThursdayTomorrow,
    );
  }
  return null;
});

class FastingInsights {
  const FastingInsights({
    required this.completedThisMonth,
    required this.streakDays,
  });

  final int completedThisMonth;

  /// Consecutive completed fasting days ending today or yesterday.
  final int streakDays;
}

/// Computed from the per-day fasting records persisted at
/// `worship.fasting.<yyyy-MM-dd>` — the 21-entry display history is not a
/// reliable source for counts.
final fastingInsightsProvider = Provider.autoDispose<FastingInsights>((ref) {
  // Recompute whenever today's fasting state changes.
  ref.watch(fastingControllerProvider);
  final store = ref.watch(localStoreProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();

  bool completedOn(DateTime day) {
    final key = LocalStore.todayKey(day);
    final map = store.getJsonMap('worship.fasting.$key');
    return map?['todayStatus']?.toString() == FastingStatus.completed.name;
  }

  var completedThisMonth = 0;
  for (var day = 1; day <= now.day; day++) {
    if (completedOn(DateTime(now.year, now.month, day))) {
      completedThisMonth += 1;
    }
  }

  var streak = 0;
  var cursor = DateTime(now.year, now.month, now.day);
  if (!completedOn(cursor)) {
    // Today may still be in progress — a streak can end yesterday.
    cursor = cursor.subtract(const Duration(days: 1));
  }
  while (completedOn(cursor)) {
    streak += 1;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return FastingInsights(
    completedThisMonth: completedThisMonth,
    streakDays: streak,
  );
});
