import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ocean/application/ocean_drops_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../data/prayer_log_repository.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import '../domain/prayer_tracker_fields.dart';
enum PrayerCalendarMode { gregorian, islamic }

class PrayerTrackerEntry {
  const PrayerTrackerEntry({
    this.status = PrayerStatus.pending,
    this.timing,
    this.place,
    this.notes,
  });

  final PrayerStatus status;
  final PrayerOfferTiming? timing;
  final PrayerOfferPlace? place;
  final String? notes;

  PrayerTrackerEntry copyWith({
    PrayerStatus? status,
    PrayerOfferTiming? timing,
    PrayerOfferPlace? place,
    String? notes,
    bool clearTiming = false,
    bool clearPlace = false,
    bool clearNotes = false,
  }) {
    return PrayerTrackerEntry(
      status: status ?? this.status,
      timing: clearTiming ? null : timing ?? this.timing,
      place: clearPlace ? null : place ?? this.place,
      notes: clearNotes ? null : notes ?? this.notes,
    );
  }
}

class PrayerTrackerState {
  const PrayerTrackerState({
    required this.selectedDate,
    required this.calendarMode,
    required this.records,
    required this.qadaBacklog,
    required this.dailyQadaTarget,
    required this.dailyQadaCompleted,
  });

  final DateTime selectedDate;
  final PrayerCalendarMode calendarMode;
  final Map<PrayerName, PrayerTrackerEntry> records;
  final Map<PrayerName, int> qadaBacklog;
  final int dailyQadaTarget;
  final int dailyQadaCompleted;

  PrayerTrackerState copyWith({
    DateTime? selectedDate,
    PrayerCalendarMode? calendarMode,
    Map<PrayerName, PrayerTrackerEntry>? records,
    Map<PrayerName, int>? qadaBacklog,
    int? dailyQadaTarget,
    int? dailyQadaCompleted,
  }) {
    return PrayerTrackerState(
      selectedDate: selectedDate ?? this.selectedDate,
      calendarMode: calendarMode ?? this.calendarMode,
      records: records ?? this.records,
      qadaBacklog: qadaBacklog ?? this.qadaBacklog,
      dailyQadaTarget: dailyQadaTarget ?? this.dailyQadaTarget,
      dailyQadaCompleted: dailyQadaCompleted ?? this.dailyQadaCompleted,
    );
  }
}

class PrayerTrackerController extends StateNotifier<PrayerTrackerState> {
  PrayerTrackerController(this._store, this._repository, this._oceanDrops)
    : super(
        PrayerTrackerState(
          selectedDate: DateTime.now(),
          calendarMode: PrayerCalendarMode.gregorian,
          records: _defaultRecords(),
          qadaBacklog: _defaultQadaBacklog(),
          dailyQadaTarget: 2,
          dailyQadaCompleted: 0,
        ),
      ) {
    _loadSelectedDay();
    _loadQadaBacklog();
    _ensureDailyQadaProgressFresh();
  }

  final LocalStore _store;
  final PrayerLogRepository _repository;
  final OceanDropService _oceanDrops;

  static Map<PrayerName, PrayerTrackerEntry> _defaultRecords() {
    return {
      PrayerName.fajr: const PrayerTrackerEntry(),
      PrayerName.dhuhr: const PrayerTrackerEntry(),
      PrayerName.asr: const PrayerTrackerEntry(),
      PrayerName.maghrib: const PrayerTrackerEntry(),
      PrayerName.isha: const PrayerTrackerEntry(),
    };
  }

  static Map<PrayerName, int> _defaultQadaBacklog() {
    return {
      PrayerName.fajr: 0,
      PrayerName.dhuhr: 0,
      PrayerName.asr: 0,
      PrayerName.maghrib: 0,
      PrayerName.isha: 0,
    };
  }

  void previousDay() {
    final next = state.selectedDate.subtract(const Duration(days: 1));
    setSelectedDate(next);
  }

  void nextDay() {
    final next = state.selectedDate.add(const Duration(days: 1));
    setSelectedDate(next);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(
      selectedDate: DateTime(date.year, date.month, date.day),
    );
    _loadSelectedDay();
  }

  void setCalendarMode(PrayerCalendarMode mode) {
    state = state.copyWith(calendarMode: mode);
  }

  void cycleStatus(PrayerName prayer) {
    final updated = Map<PrayerName, PrayerTrackerEntry>.from(state.records);
    final current = updated[prayer] ?? const PrayerTrackerEntry();
    final next = current.status.next;
    updated[prayer] = next == PrayerStatus.completed
        ? const PrayerTrackerEntry(
            status: PrayerStatus.completed,
            timing: PrayerOfferTiming.onTime,
            place: PrayerOfferPlace.alone,
          )
        : PrayerTrackerEntry(
            status: next,
          );
    state = state.copyWith(records: updated);
    _syncQadaQueueForTransition(prayer, current.status, next);
    _saveSelectedDay();
    _awardPrayerDropIfNeeded(prayer, previous: current.status, next: next);
  }

  void setStatus(PrayerName prayer, PrayerStatus status) {
    final updated = Map<PrayerName, PrayerTrackerEntry>.from(state.records);
    final current = updated[prayer] ?? const PrayerTrackerEntry();
    updated[prayer] = status == PrayerStatus.completed
        ? const PrayerTrackerEntry(
            status: PrayerStatus.completed,
            timing: PrayerOfferTiming.onTime,
            place: PrayerOfferPlace.alone,
          )
        : PrayerTrackerEntry(status: status);
    state = state.copyWith(records: updated);
    _syncQadaQueueForTransition(prayer, current.status, status);
    _saveSelectedDay();
    _awardPrayerDropIfNeeded(prayer, previous: current.status, next: status);
  }

  void setEntry(
    PrayerName prayer, {
    required PrayerStatus status,
    PrayerOfferTiming? timing,
    PrayerOfferPlace? place,
    String? notes,
  }) {
    final updated = Map<PrayerName, PrayerTrackerEntry>.from(state.records);
    final current = updated[prayer] ?? const PrayerTrackerEntry();
    updated[prayer] = PrayerTrackerEntry(
      status: status,
      timing: status == PrayerStatus.completed ? timing : null,
      place: status == PrayerStatus.completed ? place : null,
      notes: status == PrayerStatus.completed
          ? (notes == null || notes.trim().isEmpty ? null : notes.trim())
          : null,
    );
    state = state.copyWith(records: updated);
    _syncQadaQueueForTransition(prayer, current.status, status);
    _saveSelectedDay();
    _awardPrayerDropIfNeeded(prayer, previous: current.status, next: status);
  }

  void bulkSetRemainingStatus(PrayerStatus status) {
    final updated = Map<PrayerName, PrayerTrackerEntry>.from(state.records);
    for (final prayer in PrayerName.values) {
      final current = updated[prayer] ?? const PrayerTrackerEntry();
      if (current.status != PrayerStatus.pending) continue;
      updated[prayer] = PrayerTrackerEntry(status: status);
      _syncQadaQueueForTransition(prayer, current.status, status);
    }
    state = state.copyWith(records: updated);
    _saveSelectedDay();
  }

  void addQada(PrayerName prayer, int amount) {
    _ensureDailyQadaProgressFresh();
    final updated = Map<PrayerName, int>.from(state.qadaBacklog);
    final current = updated[prayer] ?? 0;
    updated[prayer] = (current + amount).clamp(0, 9999);
    state = state.copyWith(qadaBacklog: updated);
    _saveQadaBacklog();
  }

  void completeOneQada(PrayerName prayer) {
    _ensureDailyQadaProgressFresh();
    final updated = Map<PrayerName, int>.from(state.qadaBacklog);
    final current = updated[prayer] ?? 0;
    if (current <= 0) {
      return;
    }
    final nextCompletedCount = state.dailyQadaCompleted + 1;
    updated[prayer] = current - 1;
    state = state.copyWith(
      qadaBacklog: updated,
      dailyQadaCompleted: nextCompletedCount,
    );
    _saveQadaBacklog();
    _oceanDrops.awardDrop(
      actionType: oceanActionMakeupPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: '${prayer.name}:$nextCompletedCount',
      metadata: {'timestamp': DateTime.now().toIso8601String()},
    );
  }

  void _awardPrayerDropIfNeeded(
    PrayerName prayer, {
    required PrayerStatus previous,
    required PrayerStatus next,
  }) {
    if (previous == next || next != PrayerStatus.completed) return;
    _oceanDrops.awardDrop(
      actionType: oceanActionPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: prayer.name,
      metadata: {'timestamp': state.selectedDate.toIso8601String()},
    );
  }

  void setDailyQadaTarget(int target) {
    final clamped = target.clamp(1, 12);
    state = state.copyWith(dailyQadaTarget: clamped);
    _saveQadaBacklog();
  }

  int estimateQadaDaysToClear() {
    _ensureDailyQadaProgressFresh();
    final total = state.qadaBacklog.values.fold<int>(0, (a, b) => a + b);
    if (total <= 0) return 0;
    return (total / state.dailyQadaTarget).ceil();
  }

  double qadaDailyTargetProgress() {
    if (state.dailyQadaTarget <= 0) return 0;
    return (state.dailyQadaCompleted / state.dailyQadaTarget).clamp(0.0, 1.0);
  }

  String cadenceRecommendation() {
    final total = state.qadaBacklog.values.fold<int>(0, (a, b) => a + b);
    if (total <= 0) return 'Queue clear. Maintain on-time prayers.';
    if (total <= 20) {
      return 'Light cadence: 1 extra qada after Fajr or Isha.';
    }
    if (total <= 60) {
      return 'Steady cadence: 2 qada daily (one after Fajr, one after Isha).';
    }
    return 'Focused cadence: 3 qada daily in small blocks with consistency.';
  }

  List<PrayerName> qadaQueue({int limit = 30}) {
    final queue = <PrayerName>[];
    final ordered = <MapEntry<PrayerName, int>>[...state.qadaBacklog.entries]
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final entry in ordered) {
      for (var i = 0; i < entry.value && queue.length < limit; i += 1) {
        queue.add(entry.key);
      }
      if (queue.length >= limit) break;
    }
    return queue;
  }

  Map<DateTime, Map<PrayerName, PrayerStatus>> loadMonthMap(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    final days = nextMonth.difference(first).inDays;
    final output = <DateTime, Map<PrayerName, PrayerStatus>>{};
    for (var i = 0; i < days; i += 1) {
      final day = first.add(Duration(days: i));
      output[day] = {
        for (final entry in _loadForDate(day).entries) entry.key: entry.value.status,
      };
    }
    return output;
  }

  Map<DateTime, Map<PrayerName, PrayerTrackerEntry>> loadMonthEntryMap(
    DateTime month,
  ) {
    final first = DateTime(month.year, month.month, 1);
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    final days = nextMonth.difference(first).inDays;
    final output = <DateTime, Map<PrayerName, PrayerTrackerEntry>>{};
    for (var i = 0; i < days; i += 1) {
      final day = first.add(Duration(days: i));
      output[day] = _loadForDate(day);
    }
    return output;
  }

  void _loadSelectedDay() {
    state = state.copyWith(records: _loadForDate(state.selectedDate));
  }

  Map<PrayerName, PrayerTrackerEntry> _loadForDate(DateTime date) {
    final key = LocalStore.todayKey(date);
    final data = _repository.readDayEntries(key);
    if (data.isEmpty) return _defaultRecords();
    final restored = _defaultRecords();
    for (final prayer in restored.keys) {
      final raw = data[prayer];
      if (raw == null) continue;
      restored[prayer] = PrayerTrackerEntry(
        status: raw.status,
        timing: raw.status == PrayerStatus.completed ? raw.timing : null,
        place: raw.status == PrayerStatus.completed ? raw.place : null,
        notes: raw.status == PrayerStatus.completed &&
                raw.notes != null &&
                raw.notes!.isNotEmpty
            ? raw.notes
            : null,
      );
    }
    return restored;
  }

  void _saveSelectedDay() {
    final key = LocalStore.todayKey(state.selectedDate);
    final existing = _repository.readDayEntries(key);
    _repository.saveDayEntries(
      key,
      <PrayerName, PrayerLogDayEntry>{
        for (final entry in state.records.entries)
          entry.key: PrayerLogDayEntry(
            status: entry.value.status,
            timing: entry.value.timing,
            place: entry.value.place,
            notes: entry.value.notes,
            completedAtIso: entry.value.status == PrayerStatus.completed
                ? existing[entry.key]?.completedAtIso
                : null,
          ),
      },
    );
  }

  void _loadQadaBacklog() {
    _ensureDailyQadaProgressFresh();
    final data = _store.getJsonMap('worship.prayer.qada');
    if (data == null) return;
    final restored = _defaultQadaBacklog();
    for (final prayer in restored.keys) {
      final raw = data[prayer.name];
      if (raw is num) {
        restored[prayer] = raw.toInt();
      }
    }
    final rawTarget = data['dailyTarget'];
    final target = rawTarget is num ? rawTarget.toInt() : state.dailyQadaTarget;
    final rawProgressDay = data['progressDayKey']?.toString();
    final todayKey = LocalStore.todayKey();
    final rawProgressCompleted = data['progressCompleted'];
    final completed = rawProgressDay == todayKey && rawProgressCompleted is num
        ? rawProgressCompleted.toInt().clamp(0, 99)
        : 0;
    state = state.copyWith(
      qadaBacklog: restored,
      dailyQadaTarget: target.clamp(1, 12),
      dailyQadaCompleted: completed,
    );
  }

  void _saveQadaBacklog() {
    _ensureDailyQadaProgressFresh();
    _store.setJsonMap('worship.prayer.qada', {
      for (final entry in state.qadaBacklog.entries)
        entry.key.name: entry.value,
      'dailyTarget': state.dailyQadaTarget,
      'progressDayKey': LocalStore.todayKey(),
      'progressCompleted': state.dailyQadaCompleted,
    });
  }

  void _syncQadaQueueForTransition(
    PrayerName prayer,
    PrayerStatus previous,
    PrayerStatus next,
  ) {
    if (previous == next) return;
    if (next == PrayerStatus.missed) {
      _ensureDailyQadaProgressFresh();
      final updated = Map<PrayerName, int>.from(state.qadaBacklog);
      updated[prayer] = (updated[prayer] ?? 0) + 1;
      state = state.copyWith(qadaBacklog: updated);
      _saveQadaBacklog();
      return;
    }
  }

  void _ensureDailyQadaProgressFresh() {
    final key = LocalStore.todayKey();
    final data = _store.getJsonMap('worship.prayer.qada');
    if (data == null) {
      return;
    }
    if (data['progressDayKey']?.toString() != key &&
        state.dailyQadaCompleted != 0) {
      state = state.copyWith(dailyQadaCompleted: 0);
    }
  }
}

final prayerTrackerControllerProvider =
    StateNotifierProvider<PrayerTrackerController, PrayerTrackerState>((ref) {
      return PrayerTrackerController(
        ref.watch(localStoreProvider),
        ref.watch(prayerLogRepositoryProvider),
        ref.read(oceanDropServiceProvider),
      );
    });

final prayerMonthlyRecordsProvider =
    Provider.family<Map<DateTime, Map<PrayerName, PrayerStatus>>, DateTime>((
      ref,
      month,
    ) {
      final controller = ref.watch(prayerTrackerControllerProvider.notifier);
      final tick = ref.watch(prayerTrackerControllerProvider);
      final anchor = DateTime(month.year, month.month, 1);
      // Depend on state so this recomputes when records change.
      if (tick.selectedDate.year == -1) {
        return const {};
      }
      return controller.loadMonthMap(anchor);
    });

final prayerMonthlyEntryRecordsProvider = Provider.family<
  Map<DateTime, Map<PrayerName, PrayerTrackerEntry>>,
  DateTime
>((ref, month) {
  final controller = ref.watch(prayerTrackerControllerProvider.notifier);
  final tick = ref.watch(prayerTrackerControllerProvider);
  final anchor = DateTime(month.year, month.month, 1);
  if (tick.selectedDate.year == -1) {
    return const {};
  }
  return controller.loadMonthEntryMap(anchor);
});
