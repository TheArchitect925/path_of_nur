import '../domain/dhikr_day_total.dart';

/// Pure history arithmetic over the per-day totals. Everything the landing
/// tiles, the heatmap and the insights page show comes through here so it
/// can be tested without a database.

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

int dhikrCountOn(Map<String, DhikrDayTotal> totals, DateTime day) {
  return totals[dhikrDayKey(day)]?.count ?? 0;
}

/// Consecutive days with at least one remembrance, ending today. A quiet
/// today does not break the run: the streak then counts back from yesterday.
int dhikrStreakDays(Map<String, DhikrDayTotal> totals, DateTime today) {
  var cursor = _dateOnly(today);
  if (dhikrCountOn(totals, cursor) <= 0) {
    cursor = cursor.subtract(const Duration(days: 1));
  }
  var streak = 0;
  while (dhikrCountOn(totals, cursor) > 0) {
    streak += 1;
    cursor = cursor.subtract(const Duration(days: 1));
    if (streak > 5000) break;
  }
  return streak;
}

/// Longest run of consecutive active days anywhere in the history.
int dhikrBestStreakDays(Map<String, DhikrDayTotal> totals) {
  final days =
      totals.values
          .where((total) => total.count > 0)
          .map((total) => dhikrDateFromKey(total.dateKey))
          .whereType<DateTime>()
          .toList()
        ..sort();
  var best = 0;
  var run = 0;
  DateTime? previous;
  for (final day in days) {
    if (previous != null && day.difference(previous).inDays == 1) {
      run += 1;
    } else {
      run = 1;
    }
    if (run > best) best = run;
    previous = day;
  }
  return best;
}

/// One value per day, oldest first, ending on [today].
List<double> dhikrDailyValues(
  Map<String, DhikrDayTotal> totals,
  DateTime today, {
  required int days,
}) {
  final end = _dateOnly(today);
  return <double>[
    for (var offset = days - 1; offset >= 0; offset--)
      dhikrCountOn(totals, end.subtract(Duration(days: offset))).toDouble(),
  ];
}

int dhikrSumOverDays(
  Map<String, DhikrDayTotal> totals,
  DateTime end, {
  required int days,
}) {
  final endDay = _dateOnly(end);
  var sum = 0;
  for (var offset = 0; offset < days; offset++) {
    sum += dhikrCountOn(totals, endDay.subtract(Duration(days: offset)));
  }
  return sum;
}

int dhikrLifetimeCount(Map<String, DhikrDayTotal> totals) {
  return totals.values.fold<int>(0, (sum, total) => sum + total.count);
}

int dhikrActiveDays(
  Map<String, DhikrDayTotal> totals,
  DateTime today, {
  required int days,
}) {
  final end = _dateOnly(today);
  var active = 0;
  for (var offset = 0; offset < days; offset++) {
    if (dhikrCountOn(totals, end.subtract(Duration(days: offset))) > 0) {
      active += 1;
    }
  }
  return active;
}

/// Best seven-day window total across the history.
int dhikrBestWeekCount(Map<String, DhikrDayTotal> totals) {
  final days =
      totals.values
          .map((total) => dhikrDateFromKey(total.dateKey))
          .whereType<DateTime>()
          .toList()
        ..sort();
  var best = 0;
  for (final day in days) {
    final window = dhikrSumOverDays(totals, day, days: 7);
    if (window > best) best = window;
  }
  return best;
}

/// Distinct days in the last [days] on which [routineId] was completed.
int dhikrRoutineDaysInWindow(
  Map<String, DhikrDayTotal> totals,
  DateTime today, {
  required String routineId,
  required int days,
}) {
  final end = _dateOnly(today);
  var count = 0;
  for (var offset = 0; offset < days; offset++) {
    final total = totals[dhikrDayKey(end.subtract(Duration(days: offset)))];
    if (total != null && total.hasRoutine(routineId)) count += 1;
  }
  return count;
}

/// Total completions of [routineId] in the last [days] (after-salah can run
/// several times a day, so this counts entries rather than days).
int dhikrRoutineRunsInWindow(
  Map<String, DhikrDayTotal> totals,
  DateTime today, {
  required String routineId,
  required int days,
}) {
  final end = _dateOnly(today);
  var count = 0;
  for (var offset = 0; offset < days; offset++) {
    final total = totals[dhikrDayKey(end.subtract(Duration(days: offset)))];
    if (total == null) continue;
    count += total.routineEntries
        .where((entry) => DhikrDayTotal.routineBaseId(entry) == routineId)
        .length;
  }
  return count;
}

String? dhikrEarliestDateKey(Map<String, DhikrDayTotal> totals) {
  String? earliest;
  for (final total in totals.values) {
    if (total.isEmpty) continue;
    if (earliest == null || total.dateKey.compareTo(earliest) < 0) {
      earliest = total.dateKey;
    }
  }
  return earliest;
}

/// Adds a finished session to the day it ended on and returns the new map.
Map<String, DhikrDayTotal> dhikrTotalsWithSession(
  Map<String, DhikrDayTotal> totals, {
  required DateTime finishedAt,
  required int count,
  String? routineEntry,
}) {
  final key = dhikrDayKey(finishedAt);
  final existing =
      totals[key] ?? DhikrDayTotal(dateKey: key, count: 0, sessions: 0);
  final updated = existing.copyWith(
    count: existing.count + count,
    sessions: existing.sessions + 1,
    routineEntries: routineEntry == null
        ? existing.routineEntries
        : <String>[...existing.routineEntries, routineEntry],
  );
  return <String, DhikrDayTotal>{...totals, key: updated};
}
