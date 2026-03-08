import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../domain/daily_prayer_record.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import '../domain/prayer_summary.dart';

class PrayerController extends StateNotifier<List<DailyPrayerRecord>> {
  PrayerController(this._store)
    : super(
        const [
          DailyPrayerRecord(prayer: PrayerName.fajr),
          DailyPrayerRecord(prayer: PrayerName.dhuhr),
          DailyPrayerRecord(prayer: PrayerName.asr, status: PrayerStatus.completed),
          DailyPrayerRecord(prayer: PrayerName.maghrib),
          DailyPrayerRecord(prayer: PrayerName.isha),
        ],
      ) {
    _loadToday();
  }

  final LocalStore _store;

  void cycleStatus(PrayerName prayer) {
    state = state
        .map(
          (record) => record.prayer == prayer
              ? record.copyWith(status: record.status.next)
              : record,
        )
        .toList();
    _saveToday();
  }

  void _loadToday() {
    final dayKey = LocalStore.todayKey();
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

  void _saveToday() {
    final dayKey = LocalStore.todayKey();
    _store.setJsonMap('worship.prayer.$dayKey', {
      for (final record in state) record.prayer.name: record.status.name,
    });
  }
}

final prayerControllerProvider =
    StateNotifierProvider<PrayerController, List<DailyPrayerRecord>>(
      (ref) => PrayerController(ref.watch(localStoreProvider)),
    );

final prayerSummaryProvider = Provider<PrayerSummary>((ref) {
  final records = ref.watch(prayerControllerProvider);
  return buildPrayerSummary(records);
});
