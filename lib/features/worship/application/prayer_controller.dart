import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ocean/application/ocean_drops_provider.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../domain/daily_prayer_record.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import '../domain/prayer_summary.dart';

class PrayerController extends StateNotifier<List<DailyPrayerRecord>> {
  PrayerController(this._store, this._oceanDrops)
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

  final LocalStore _store;
  final OceanDropService _oceanDrops;
  late String _activeDayKey;

  void cycleStatus(PrayerName prayer) {
    _syncDayIfNeeded();
    PrayerStatus? nextStatus;
    state = state
        .map(
          (record) => record.prayer == prayer
              ? (() {
                  nextStatus = record.status.next;
                  return record.copyWith(status: nextStatus);
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
    state = const [
      DailyPrayerRecord(prayer: PrayerName.fajr),
      DailyPrayerRecord(prayer: PrayerName.dhuhr),
      DailyPrayerRecord(prayer: PrayerName.asr),
      DailyPrayerRecord(prayer: PrayerName.maghrib),
      DailyPrayerRecord(prayer: PrayerName.isha),
    ];
    final data = _store.getJsonMap('worship.prayer.$dayKey');
    if (data == null) return;

    state = state.map((record) {
      final statusName = data[record.prayer.name] as String?;
      PrayerStatus restored = record.status;
      for (final value in PrayerStatus.values) {
        if (value.name == statusName) {
          restored = value;
          break;
        }
      }
      return record.copyWith(status: restored);
    }).toList();
  }

  void _saveForDay(String dayKey) {
    _store.setJsonMap('worship.prayer.$dayKey', {
      for (final record in state) record.prayer.name: record.status.name,
    });
  }
}

final prayerControllerProvider =
    StateNotifierProvider<PrayerController, List<DailyPrayerRecord>>((ref) {
      final notifier = PrayerController(
        ref.watch(localStoreProvider),
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
