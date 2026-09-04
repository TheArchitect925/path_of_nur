import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/prayer/prayer_preferences.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../domain/dhikr_day_total.dart';
import '../domain/dhikr_routine.dart';
import '../domain/prayer_status.dart';
import 'dhikr_controller.dart';
import 'dhikr_routine_catalog.dart';
import 'dhikr_routine_controller.dart';
import 'prayer_controller.dart';

enum DhikrNowKind { continueRoutine, afterSalah, morning, evening, sleep, free }

/// What the dhikr landing puts in its "Now" card.
class DhikrNowSuggestion {
  const DhikrNowSuggestion({
    required this.kind,
    this.routineId,
    this.prayerId,
    this.doneToday = false,
  });

  final DhikrNowKind kind;
  final String? routineId;

  /// For after-salah: the prayer this run would follow, when one was just
  /// marked.
  final String? prayerId;
  final bool doneToday;

  static const free = DhikrNowSuggestion(kind: DhikrNowKind.free);
}

/// Prayer-window inputs the resolver needs, kept as plain values so the rule
/// can be tested without the schedule provider.
class DhikrDayWindows {
  const DhikrDayWindows({
    this.fajr,
    this.noon,
    this.asr,
    this.maghrib,
    this.isha,
  });

  final DateTime? fajr;
  final DateTime? noon;
  final DateTime? asr;
  final DateTime? maghrib;
  final DateTime? isha;

  bool isMorning(DateTime now) {
    final start = fajr ?? DateTime(now.year, now.month, now.day, 4);
    final end = noon ?? DateTime(now.year, now.month, now.day, 12);
    return !now.isBefore(start) && now.isBefore(end);
  }

  bool isEvening(DateTime now) {
    final start = asr ?? DateTime(now.year, now.month, now.day, 15);
    final end = isha ?? DateTime(now.year, now.month, now.day, 21);
    return !now.isBefore(start) && now.isBefore(end);
  }

  /// From ʿIsha until Fajr: the hours one goes to sleep in.
  bool isNight(DateTime now) {
    final start = isha ?? DateTime(now.year, now.month, now.day, 21);
    final dawn = fajr ?? DateTime(now.year, now.month, now.day, 4);
    return !now.isBefore(start) || now.isBefore(dawn);
  }
}

const Duration kDhikrAfterSalahGrace = Duration(minutes: 45);

DhikrNowSuggestion resolveDhikrNowSuggestion({
  required DateTime now,
  required DhikrDayWindows windows,
  required Set<String> availableRoutineIds,
  required DhikrDayTotal? today,
  required DhikrRoutineProgress? active,
  required String? lastCompletedPrayerId,
  required DateTime? lastCompletedPrayerAt,
}) {
  if (active != null && availableRoutineIds.contains(active.routineId)) {
    return DhikrNowSuggestion(
      kind: DhikrNowKind.continueRoutine,
      routineId: active.routineId,
      prayerId: active.prayerId,
    );
  }

  final hasAfterSalah = availableRoutineIds.contains(kDhikrRoutineAfterSalahId);
  if (hasAfterSalah &&
      lastCompletedPrayerId != null &&
      lastCompletedPrayerAt != null &&
      !now.isBefore(lastCompletedPrayerAt) &&
      now.difference(lastCompletedPrayerAt) <= kDhikrAfterSalahGrace &&
      !(today?.hasRoutineEntry(
            '$kDhikrRoutineAfterSalahId:$lastCompletedPrayerId',
          ) ??
          false)) {
    return DhikrNowSuggestion(
      kind: DhikrNowKind.afterSalah,
      routineId: kDhikrRoutineAfterSalahId,
      prayerId: lastCompletedPrayerId,
    );
  }

  final morningDone = today?.hasRoutine(kDhikrRoutineMorningId) ?? false;
  if (availableRoutineIds.contains(kDhikrRoutineMorningId) &&
      windows.isMorning(now)) {
    return DhikrNowSuggestion(
      kind: DhikrNowKind.morning,
      routineId: kDhikrRoutineMorningId,
      doneToday: morningDone,
    );
  }

  final eveningDone = today?.hasRoutine(kDhikrRoutineEveningId) ?? false;
  if (availableRoutineIds.contains(kDhikrRoutineEveningId) &&
      windows.isEvening(now)) {
    return DhikrNowSuggestion(
      kind: DhikrNowKind.evening,
      routineId: kDhikrRoutineEveningId,
      doneToday: eveningDone,
    );
  }

  final sleepDone = today?.hasRoutine(kDhikrRoutineSleepId) ?? false;
  if (availableRoutineIds.contains(kDhikrRoutineSleepId) &&
      windows.isNight(now)) {
    return DhikrNowSuggestion(
      kind: DhikrNowKind.sleep,
      routineId: kDhikrRoutineSleepId,
      doneToday: sleepDone,
    );
  }

  if (hasAfterSalah) {
    return const DhikrNowSuggestion(
      kind: DhikrNowKind.afterSalah,
      routineId: kDhikrRoutineAfterSalahId,
    );
  }
  return DhikrNowSuggestion.free;
}

DhikrDayWindows dhikrWindowsFromSchedule(List<PrayerScheduleItem> items) {
  DateTime? at(Set<String> ids) {
    for (final item in items) {
      if (ids.contains(item.id)) return item.offerDateTime;
    }
    return null;
  }

  return DhikrDayWindows(
    fajr: at(const {'fajr'}),
    noon: at(const {'dhuhr', 'jumuah'}),
    asr: at(const {'asr'}),
    maghrib: at(const {'maghrib'}),
    isha: at(const {'isha'}),
  );
}

final dhikrNowSuggestionProvider = Provider<DhikrNowSuggestion>((ref) {
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final schedule = ref.watch(prayerScheduleContextProvider);
  final routines = ref.watch(dhikrRoutinesProvider);
  final totals = ref.watch(
    dhikrControllerProvider.select((state) => state.dailyTotals),
  );
  final active = ref.watch(dhikrRoutineControllerProvider);
  final records = ref.watch(prayerControllerProvider);

  String? lastPrayerId;
  DateTime? lastPrayerAt;
  for (final record in records) {
    if (record.status != PrayerStatus.completed) continue;
    final completedAt = DateTime.tryParse(record.completedAtIso ?? '');
    if (completedAt == null) continue;
    if (lastPrayerAt == null || completedAt.isAfter(lastPrayerAt)) {
      lastPrayerAt = completedAt;
      lastPrayerId = record.prayer.name;
    }
  }

  return resolveDhikrNowSuggestion(
    now: now,
    windows: dhikrWindowsFromSchedule(schedule.items),
    availableRoutineIds: routines.map((routine) => routine.id).toSet(),
    today: totals[dhikrDayKey(now)],
    active: active,
    lastCompletedPrayerId: lastPrayerId,
    lastCompletedPrayerAt: lastPrayerAt,
  );
});
