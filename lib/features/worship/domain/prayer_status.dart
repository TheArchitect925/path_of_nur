enum PrayerStatus {
  pending,
  completed,
  missed,
}

extension PrayerStatusX on PrayerStatus {
  String get label {
    switch (this) {
      case PrayerStatus.pending:
        return 'Pending';
      case PrayerStatus.completed:
        return 'Completed';
      case PrayerStatus.missed:
        return 'Missed';
    }
  }

  PrayerStatus get next {
    switch (this) {
      case PrayerStatus.pending:
        return PrayerStatus.completed;
      case PrayerStatus.completed:
        return PrayerStatus.missed;
      case PrayerStatus.missed:
        return PrayerStatus.pending;
    }
  }
}

