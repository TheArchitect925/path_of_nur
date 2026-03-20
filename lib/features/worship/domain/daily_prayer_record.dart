import 'prayer_name.dart';
import 'prayer_status.dart';

class DailyPrayerRecord {
  const DailyPrayerRecord({
    required this.prayer,
    this.status = PrayerStatus.pending,
    this.completedAtIso,
    this.postSalahAdhkarCompletedAtIso,
  });

  final PrayerName prayer;
  final PrayerStatus status;
  final String? completedAtIso;
  final String? postSalahAdhkarCompletedAtIso;

  DateTime? get completedAt =>
      completedAtIso == null ? null : DateTime.tryParse(completedAtIso!);
  DateTime? get postSalahAdhkarCompletedAt =>
      postSalahAdhkarCompletedAtIso == null
      ? null
      : DateTime.tryParse(postSalahAdhkarCompletedAtIso!);

  DailyPrayerRecord copyWith({
    PrayerStatus? status,
    String? completedAtIso,
    String? postSalahAdhkarCompletedAtIso,
    bool clearCompletedAtIso = false,
    bool clearPostSalahAdhkarCompletedAtIso = false,
  }) {
    return DailyPrayerRecord(
      prayer: prayer,
      status: status ?? this.status,
      completedAtIso: clearCompletedAtIso
          ? null
          : completedAtIso ?? this.completedAtIso,
      postSalahAdhkarCompletedAtIso: clearPostSalahAdhkarCompletedAtIso
          ? null
          : postSalahAdhkarCompletedAtIso ?? this.postSalahAdhkarCompletedAtIso,
    );
  }
}
