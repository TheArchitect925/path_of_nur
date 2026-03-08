import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/daily_prayer_record.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import '../domain/prayer_summary.dart';

class PrayerController extends StateNotifier<List<DailyPrayerRecord>> {
  PrayerController()
    : super(
        const [
          DailyPrayerRecord(prayer: PrayerName.fajr),
          DailyPrayerRecord(prayer: PrayerName.dhuhr),
          DailyPrayerRecord(prayer: PrayerName.asr, status: PrayerStatus.completed),
          DailyPrayerRecord(prayer: PrayerName.maghrib),
          DailyPrayerRecord(prayer: PrayerName.isha),
        ],
      );

  void cycleStatus(PrayerName prayer) {
    state = state
        .map(
          (record) => record.prayer == prayer
              ? record.copyWith(status: record.status.next)
              : record,
        )
        .toList();
  }
}

final prayerControllerProvider =
    StateNotifierProvider<PrayerController, List<DailyPrayerRecord>>(
      (ref) => PrayerController(),
    );

final prayerSummaryProvider = Provider<PrayerSummary>((ref) {
  final records = ref.watch(prayerControllerProvider);
  return buildPrayerSummary(records);
});

