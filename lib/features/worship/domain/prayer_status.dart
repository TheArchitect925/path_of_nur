import '../../../l10n/app_localizations.dart';

enum PrayerStatus { pending, completed, missed }

extension PrayerStatusX on PrayerStatus {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case PrayerStatus.pending:
        return l10n.worshipPrayerStatusPending;
      case PrayerStatus.completed:
        return l10n.worshipPrayerStatusCompleted;
      case PrayerStatus.missed:
        return l10n.worshipPrayerStatusMissed;
    }
  }

  @Deprecated('Use localizedLabel(AppLocalizations) for user-visible text.')
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
