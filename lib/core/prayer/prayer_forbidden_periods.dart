import '../../l10n/app_localizations.dart';
import 'prayer_preferences.dart';

/// The three daily windows in which voluntary salah is not offered.
enum ForbiddenPeriodKind { sunrise, zenith, sunset }

class ForbiddenPrayerPeriod {
  const ForbiddenPrayerPeriod({required this.kind, required this.untilTime});

  final ForbiddenPeriodKind kind;

  /// Formatted clock time at which the window ends.
  final String untilTime;
}

String forbiddenPrayerPeriodLabel(
  AppLocalizations l10n,
  ForbiddenPrayerPeriod period,
) {
  switch (period.kind) {
    case ForbiddenPeriodKind.sunrise:
      return l10n.homePrayerForbiddenSunrise;
    case ForbiddenPeriodKind.zenith:
      return l10n.homePrayerForbiddenZenith;
    case ForbiddenPeriodKind.sunset:
      return l10n.homePrayerForbiddenSunset;
  }
}

const Duration _zenithForbiddenLead = Duration(minutes: 5);
const Duration _sunsetForbiddenLead = Duration(minutes: 20);

/// Returns the active forbidden-salah window at [now], if any — shared by
/// Home's hero chip and the Ibadah Prayer Room. Extracted from the Home page
/// so the two surfaces can never drift.
ForbiddenPrayerPeriod? activeForbiddenPrayerPeriod(
  List<PrayerScheduleItem> items,
  DateTime now,
) {
  PrayerScheduleItem? itemById(String id) =>
      items.where((item) => item.id == id).firstOrNull;

  final fajr = itemById('fajr');
  if (fajr != null) {
    final sunriseStart = fajr.overdueDateTime;
    final sunriseEnd = fajr.makeUpFromDateTime;
    if (!now.isBefore(sunriseStart) && now.isBefore(sunriseEnd)) {
      return ForbiddenPrayerPeriod(
        kind: ForbiddenPeriodKind.sunrise,
        untilTime: fajr.makeUpFrom,
      );
    }
  }

  final dhuhr = itemById('dhuhr');
  if (dhuhr != null) {
    final zenithStart = dhuhr.windowStartDateTime.subtract(
      _zenithForbiddenLead,
    );
    final zenithEnd = dhuhr.windowStartDateTime;
    if (!now.isBefore(zenithStart) && now.isBefore(zenithEnd)) {
      return ForbiddenPrayerPeriod(
        kind: ForbiddenPeriodKind.zenith,
        untilTime: dhuhr.windowStart,
      );
    }
  }

  final maghrib = itemById('maghrib');
  if (maghrib != null) {
    final sunsetStart = maghrib.windowStartDateTime.subtract(
      _sunsetForbiddenLead,
    );
    final sunsetEnd = maghrib.windowStartDateTime;
    if (!now.isBefore(sunsetStart) && now.isBefore(sunsetEnd)) {
      return ForbiddenPrayerPeriod(
        kind: ForbiddenPeriodKind.sunset,
        untilTime: maghrib.windowStart,
      );
    }
  }

  return null;
}
