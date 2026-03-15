import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ocean/application/ocean_drops_provider.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../data/prayer_log_repository.dart';
import '../domain/daily_prayer_record.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import '../domain/prayer_summary.dart';

class PrayerController extends StateNotifier<List<DailyPrayerRecord>> {
  PrayerController(this._repository, this._oceanDrops)
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
  final OceanDropService _oceanDrops;
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
      _oceanDrops.awardDrop(
        actionType: oceanActionPrayerCompleted,
        sourceModule: oceanSourcePrayer,
        referenceId: prayer.name,
        metadata: {'timestamp': '${_activeDayKey}T12:00:00'},
      );
    }
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
        ref.read(oceanDropServiceProvider),
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
