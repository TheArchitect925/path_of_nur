import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/worship/application/dhikr_now_suggestion.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_catalog.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_day_total.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_routine.dart';

void main() {
  final day = DateTime(2026, 9, 4);
  final windows = DhikrDayWindows(
    fajr: day.add(const Duration(hours: 5, minutes: 3)),
    noon: day.add(const Duration(hours: 13, minutes: 30)),
    asr: day.add(const Duration(hours: 16, minutes: 55)),
    maghrib: day.add(const Duration(hours: 19, minutes: 48)),
    isha: day.add(const Duration(hours: 21, minutes: 22)),
  );
  const all = {
    kDhikrRoutineAfterSalahId,
    kDhikrRoutineMorningId,
    kDhikrRoutineEveningId,
    kDhikrRoutineSleepId,
  };

  DhikrNowSuggestion resolve({
    required DateTime now,
    DhikrDayTotal? today,
    DhikrRoutineProgress? active,
    String? prayerId,
    DateTime? prayerAt,
    Set<String> available = all,
  }) {
    return resolveDhikrNowSuggestion(
      now: now,
      windows: windows,
      availableRoutineIds: available,
      today: today,
      active: active,
      lastCompletedPrayerId: prayerId,
      lastCompletedPrayerAt: prayerAt,
    );
  }

  test('an active routine always wins', () {
    final suggestion = resolve(
      now: day.add(const Duration(hours: 8)),
      active: DhikrRoutineProgress(
        routineId: kDhikrRoutineEveningId,
        stepIndex: 2,
        stepCount: 1,
        startedAt: day,
      ),
    );
    expect(suggestion.kind, DhikrNowKind.continueRoutine);
    expect(suggestion.routineId, kDhikrRoutineEveningId);
  });

  test('a prayer marked minutes ago suggests the after-salah tasbih', () {
    final now = day.add(const Duration(hours: 17, minutes: 20));
    final suggestion = resolve(
      now: now,
      prayerId: 'asr',
      prayerAt: now.subtract(const Duration(minutes: 10)),
    );
    expect(suggestion.kind, DhikrNowKind.afterSalah);
    expect(suggestion.prayerId, 'asr');
  });

  test('after-salah already done for that prayer falls through', () {
    final now = day.add(const Duration(hours: 17, minutes: 20));
    final suggestion = resolve(
      now: now,
      prayerId: 'asr',
      prayerAt: now.subtract(const Duration(minutes: 10)),
      today: const DhikrDayTotal(
        dateKey: '2026-09-04',
        count: 100,
        sessions: 1,
        routineEntries: ['after-salah:asr'],
      ),
    );
    expect(suggestion.kind, DhikrNowKind.evening);
    expect(suggestion.doneToday, isFalse);
  });

  test('a prayer marked an hour ago no longer counts as just now', () {
    final now = day.add(const Duration(hours: 9));
    final suggestion = resolve(
      now: now,
      prayerId: 'fajr',
      prayerAt: now.subtract(const Duration(hours: 1)),
    );
    expect(suggestion.kind, DhikrNowKind.morning);
  });

  test('morning window runs from Fajr to noon and remembers completion', () {
    expect(
      resolve(now: day.add(const Duration(hours: 4))).kind,
      DhikrNowKind.sleep,
    );
    final morning = resolve(now: day.add(const Duration(hours: 6)));
    expect(morning.kind, DhikrNowKind.morning);
    expect(morning.doneToday, isFalse);
    final done = resolve(
      now: day.add(const Duration(hours: 6)),
      today: const DhikrDayTotal(
        dateKey: '2026-09-04',
        count: 9,
        sessions: 1,
        routineEntries: ['morning'],
      ),
    );
    expect(done.kind, DhikrNowKind.morning);
    expect(done.doneToday, isTrue);
  });

  test('evening window runs from Asr to Isha', () {
    expect(
      resolve(now: day.add(const Duration(hours: 15))).kind,
      DhikrNowKind.afterSalah,
    );
    expect(
      resolve(now: day.add(const Duration(hours: 18))).kind,
      DhikrNowKind.evening,
    );
    expect(
      resolve(now: day.add(const Duration(hours: 22))).kind,
      DhikrNowKind.sleep,
    );
  });

  test('night window runs from Isha until Fajr and remembers completion', () {
    final late = resolve(now: day.add(const Duration(hours: 23)));
    expect(late.kind, DhikrNowKind.sleep);
    expect(late.doneToday, isFalse);
    expect(
      resolve(now: day.add(const Duration(hours: 2))).kind,
      DhikrNowKind.sleep,
    );
    expect(
      resolve(now: day.add(const Duration(hours: 4, minutes: 30))).kind,
      DhikrNowKind.sleep,
    );
    expect(
      resolve(now: day.add(const Duration(hours: 5, minutes: 30))).kind,
      DhikrNowKind.morning,
    );
    final done = resolve(
      now: day.add(const Duration(hours: 23)),
      today: const DhikrDayTotal(
        dateKey: '2026-09-04',
        count: 7,
        sessions: 1,
        routineEntries: ['sleep'],
      ),
    );
    expect(done.doneToday, isTrue);
    final without = resolve(
      now: day.add(const Duration(hours: 23)),
      available: const {kDhikrRoutineAfterSalahId, kDhikrRoutineEveningId},
    );
    expect(without.kind, DhikrNowKind.afterSalah);
  });

  test('without any routine the card offers free count', () {
    final suggestion = resolve(
      now: day.add(const Duration(hours: 18)),
      available: const <String>{},
    );
    expect(suggestion.kind, DhikrNowKind.free);
  });

  test('missing prayer times fall back to clock-hour windows', () {
    const fallback = DhikrDayWindows();
    expect(fallback.isMorning(day.add(const Duration(hours: 7))), isTrue);
    expect(fallback.isMorning(day.add(const Duration(hours: 13))), isFalse);
    expect(fallback.isEvening(day.add(const Duration(hours: 18))), isTrue);
    expect(fallback.isEvening(day.add(const Duration(hours: 22))), isFalse);
    expect(fallback.isNight(day.add(const Duration(hours: 22))), isTrue);
    expect(fallback.isNight(day.add(const Duration(hours: 3))), isTrue);
    expect(fallback.isNight(day.add(const Duration(hours: 7))), isFalse);
  });
}
