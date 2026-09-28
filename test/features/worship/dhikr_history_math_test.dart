import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/worship/application/dhikr_history_math.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_day_total.dart';

void main() {
  final today = DateTime(2026, 9, 4);

  Map<String, DhikrDayTotal> totalsFor(Map<int, int> countsByDaysAgo) {
    var totals = <String, DhikrDayTotal>{};
    for (final entry in countsByDaysAgo.entries) {
      totals = dhikrTotalsWithSession(
        totals,
        finishedAt: today.subtract(Duration(days: entry.key)),
        count: entry.value,
      );
    }
    return totals;
  }

  test('day keys round-trip', () {
    expect(dhikrDayKey(DateTime(2026, 1, 7, 23, 59)), '2026-01-07');
    expect(dhikrDateFromKey('2026-01-07'), DateTime(2026, 1, 7));
    expect(dhikrDateFromKey('nonsense'), isNull);
  });

  test('streak counts back from today', () {
    final totals = totalsFor({0: 33, 1: 10, 2: 5, 4: 99});
    expect(dhikrStreakDays(totals, today), 3);
  });

  test('a quiet today does not break the streak', () {
    final totals = totalsFor({1: 10, 2: 5, 3: 7});
    expect(dhikrStreakDays(totals, today), 3);
    expect(dhikrStreakDays(<String, DhikrDayTotal>{}, today), 0);
  });

  test('best streak scans the whole history', () {
    final totals = totalsFor({0: 1, 10: 1, 11: 1, 12: 1, 13: 1, 20: 1});
    expect(dhikrBestStreakDays(totals), 4);
  });

  test('daily values end on today, oldest first', () {
    final totals = totalsFor({0: 3, 2: 7});
    expect(dhikrDailyValues(totals, today, days: 4), [0, 7, 0, 3]);
  });

  test('sums, lifetime, active days and best week', () {
    final totals = totalsFor({0: 100, 1: 50, 6: 25, 7: 1000, 30: 4});
    expect(dhikrSumOverDays(totals, today, days: 7), 175);
    expect(dhikrLifetimeCount(totals), 1179);
    expect(dhikrActiveDays(totals, today, days: 7), 3);
    expect(dhikrBestWeekCount(totals), 1075);
    expect(dhikrEarliestDateKey(totals), '2026-08-05');
  });

  test('routine entries record days and runs', () {
    var totals = <String, DhikrDayTotal>{};
    totals = dhikrTotalsWithSession(
      totals,
      finishedAt: today,
      count: 100,
      routineEntry: 'after-salah:fajr',
    );
    totals = dhikrTotalsWithSession(
      totals,
      finishedAt: today,
      count: 100,
      routineEntry: 'after-salah:asr',
    );
    totals = dhikrTotalsWithSession(
      totals,
      finishedAt: today.subtract(const Duration(days: 1)),
      count: 9,
      routineEntry: 'morning',
    );
    final day = totals[dhikrDayKey(today)]!;
    expect(day.sessions, 2);
    expect(day.count, 200);
    expect(day.hasRoutine('after-salah'), isTrue);
    expect(day.hasRoutineEntry('after-salah:asr'), isTrue);
    expect(day.hasRoutine('morning'), isFalse);
    expect(
      dhikrRoutineRunsInWindow(
        totals,
        today,
        routineId: 'after-salah',
        days: 7,
      ),
      2,
    );
    expect(
      dhikrRoutineDaysInWindow(totals, today, routineId: 'morning', days: 7),
      1,
    );
  });
}
