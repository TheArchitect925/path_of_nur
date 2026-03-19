import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey/drops/application/journey_drops_providers.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../data/prayer_log_repository.dart';
import '../domain/daily_prayer_record.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import '../domain/prayer_summary.dart';

class PrayerController extends StateNotifier<List<DailyPrayerRecord>> {
  PrayerController(this._repository, this._dropController, this._xpController)
    : super(const [
        DailyPrayerRecord(prayer: PrayerName.fajr),
        DailyPrayerRecord(prayer: PrayerName.dhuhr),
        DailyPrayerRecord(prayer: PrayerName.asr),
        DailyPrayerRecord(prayer: PrayerName.maghrib),
        DailyPrayerRecord(prayer: PrayerName.isha),
      ]) {
    _activeDayKey = LocalStore.todayKey();
    _loadForDay(_activeDayKey);
  }

  final PrayerLogRepository _repository;
  final JourneyDropController _dropController;
  final JourneyXpController _xpController;
  late String _activeDayKey;

  void cycleStatus(PrayerName prayer) {
    _syncDayIfNeeded();
    PrayerStatus? nextStatus;
    final changedAt = DateTime.now();
    state = state
        .map(
          (record) => record.prayer == prayer
              ? (() {
                  nextStatus = record.status.next;
                  return record.copyWith(
                    status: nextStatus,
                    completedAtIso: nextStatus == PrayerStatus.completed
                        ? changedAt.toIso8601String()
                        : null,
                    clearCompletedAtIso: nextStatus != PrayerStatus.completed,
                  );
                })()
              : record,
        )
        .toList();
    _saveForDay(_activeDayKey);
    if (nextStatus == PrayerStatus.completed) {
      _dropController.awardPrayerDrop(
        prayerId: prayer.name,
        dayKey: _activeDayKey,
        occurredAt: changedAt,
        metadata: <String, Object?>{'timestamp': changedAt.toIso8601String()},
      );
      _xpController.awardPrayerXp(
        prayerId: prayer.name,
        occurredAt: changedAt,
        sourceRef: 'prayer:$_activeDayKey:${prayer.name}',
        dayKey: _activeDayKey,
        allFiveCompleted: state.every(
          (record) => record.status == PrayerStatus.completed,
        ),
      );
    }
  }

  void markCompleted(PrayerName prayer) {
    _syncDayIfNeeded();
    final alreadyCompleted = state.any(
      (record) =>
          record.prayer == prayer && record.status == PrayerStatus.completed,
    );
    if (alreadyCompleted) return;

    final changedAt = DateTime.now();
    state = state
        .map(
          (record) => record.prayer == prayer
              ? record.copyWith(
                  status: PrayerStatus.completed,
                  completedAtIso: changedAt.toIso8601String(),
                )
              : record,
        )
        .toList();
    _saveForDay(_activeDayKey);
    _dropController.awardPrayerDrop(
      prayerId: prayer.name,
      dayKey: _activeDayKey,
      occurredAt: changedAt,
      metadata: <String, Object?>{'timestamp': changedAt.toIso8601String()},
    );
    _xpController.awardPrayerXp(
      prayerId: prayer.name,
      occurredAt: changedAt,
      sourceRef: 'prayer:$_activeDayKey:${prayer.name}',
      dayKey: _activeDayKey,
      allFiveCompleted: state.every(
        (record) => record.status == PrayerStatus.completed,
      ),
    );
  }

  void toggleCompleted(PrayerName prayer) {
    _syncDayIfNeeded();
    final current = state
        .where((record) => record.prayer == prayer)
        .firstOrNull;
    if (current == null) return;
    if (current.status == PrayerStatus.completed) {
      state = state
          .map(
            (record) => record.prayer == prayer
                ? record.copyWith(
                    status: PrayerStatus.pending,
                    clearCompletedAtIso: true,
                  )
                : record,
          )
          .toList();
      _saveForDay(_activeDayKey);
      return;
    }
    markCompleted(prayer);
  }

  void onDayChanged(String dayKey, {bool force = false}) {
    if (!force && dayKey == _activeDayKey) return;
    _activeDayKey = dayKey;
    _loadForDay(dayKey);
  }

  void _syncDayIfNeeded() {
    final today = LocalStore.todayKey();
    if (today != _activeDayKey) {
      onDayChanged(today);
    }
  }

  void _loadForDay(String dayKey) {
    state = _repository.readDailyRecords(dayKey);
  }

  void _saveForDay(String dayKey) {
    _repository.saveDailyRecords(dayKey, state);
  }
}

final prayerControllerProvider =
    StateNotifierProvider<PrayerController, List<DailyPrayerRecord>>((ref) {
      final notifier = PrayerController(
        ref.watch(prayerLogRepositoryProvider),
        ref.read(journeyDropSummaryProvider.notifier),
        ref.read(journeyXpSummaryProvider.notifier),
      );
      ref.listen<String>(dailyKeyProvider, (_, next) {
        notifier.onDayChanged(next);
      });
      return notifier;
    });

final prayerSummaryProvider = Provider<PrayerSummary>((ref) {
  final records = ref.watch(prayerControllerProvider);
  return buildPrayerSummary(records);
});
