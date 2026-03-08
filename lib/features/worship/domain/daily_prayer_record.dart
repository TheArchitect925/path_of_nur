import 'prayer_name.dart';
import 'prayer_status.dart';

class DailyPrayerRecord {
  const DailyPrayerRecord({
    required this.prayer,
    this.status = PrayerStatus.pending,
  });

  final PrayerName prayer;
  final PrayerStatus status;

  DailyPrayerRecord copyWith({PrayerStatus? status}) {
    return DailyPrayerRecord(
      prayer: prayer,
      status: status ?? this.status,
    );
  }
}

