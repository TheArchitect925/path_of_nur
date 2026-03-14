import 'prayer_name.dart';
import 'prayer_status.dart';

class DailyPrayerRecord {
  const DailyPrayerRecord({
    required this.prayer,
    this.status = PrayerStatus.pending,
    this.completedAtIso,
  });

  final PrayerName prayer;
  final PrayerStatus status;
  final String? completedAtIso;

  DateTime? get completedAt =>
      completedAtIso == null ? null : DateTime.tryParse(completedAtIso!);

  DailyPrayerRecord copyWith({
    PrayerStatus? status,
    String? completedAtIso,
    bool clearCompletedAtIso = false,
  }) {
    return DailyPrayerRecord(
      prayer: prayer,
      status: status ?? this.status,
      completedAtIso: clearCompletedAtIso
          ? null
          : completedAtIso ?? this.completedAtIso,
    );
  }
}
