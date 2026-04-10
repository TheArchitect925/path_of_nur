import 'daily_prayer_record.dart';
import 'prayer_name.dart';
import 'prayer_status.dart';

class PrayerSummary {
  const PrayerSummary({required this.completed, required this.total});

  final int completed;
  final int total;

  double get progress => total == 0 ? 0 : completed / total;
}

PrayerSummary buildPrayerSummary(List<DailyPrayerRecord> records) {
  final obligatoryRecords = records
      .where((record) => obligatoryPrayerNames.contains(record.prayer))
      .toList(growable: false);
  final completed = obligatoryRecords
      .where((record) => record.status == PrayerStatus.completed)
      .length;
  return PrayerSummary(
    completed: completed,
    total: obligatoryRecords.length,
  );
}
