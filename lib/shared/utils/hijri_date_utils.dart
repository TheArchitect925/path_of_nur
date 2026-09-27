import '../../l10n/app_localizations.dart';
import 'umm_al_qura_table.dart';

class HijriDateParts {
  const HijriDateParts({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;
}

/// The Hijri date of the day [date] falls on, in the Umm al-Qura calendar.
///
/// The day is the one on [date]'s own calendar, begun at midnight, whatever
/// the hour: the app does not turn the Hijri day at sunset.
///
/// Umm al-Qura is a table of months as they were observed and announced, and
/// not a rule, so it is carried (`umm_al_qura_table.dart`, copied from the
/// system's calendar by `scripts/verify_hijri_table.sh`). The Apple TV
/// carries the same table. A day outside it, before 1300 AH or after 1600,
/// is named by arithmetic ([civilHijriDate]), as the whole calendar was
/// before: that stands a day or two from Umm al-Qura on four days in nine.
HijriDateParts toHijriDate(DateTime date) {
  final day =
      DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
  return _ummAlQura.date(day) ?? civilHijriDate(date);
}

/// The Hijri date by the arithmetic of the civil calendar: thirty years of
/// 354 and 355 days, in a fixed order.
HijriDateParts civilHijriDate(DateTime date) {
  final y = date.year;
  final m = date.month;
  final d = date.day;
  final a = ((14 - m) / 12).floor();
  final y2 = y + 4800 - a;
  final m2 = m + 12 * a - 3;
  final jd =
      d +
      ((153 * m2 + 2) / 5).floor() +
      365 * y2 +
      (y2 / 4).floor() -
      (y2 / 100).floor() +
      (y2 / 400).floor() -
      32045;

  var l = jd - 1948440 + 10632;
  final n = ((l - 1) / 10631).floor();
  l = l - 10631 * n + 354;
  final j =
      (((10985 - l) / 5316).floor()) * (((50 * l) / 17719).floor()) +
      ((l / 5670).floor()) * (((43 * l) / 15238).floor());
  l =
      l -
      (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
      ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
      29;
  final month = (24 * l / 709).floor();
  final day = l - (709 * month / 24).floor();
  final year = 30 * n + j - 30;
  return HijriDateParts(year: year, month: month, day: day);
}

final _UmmAlQura _ummAlQura = _UmmAlQura();

class _UmmAlQura {
  _UmmAlQura() : _yearStarts = _startsOfYears();

  /// The day each year of the table begins on, and the day after the last
  /// of them ends.
  final List<int> _yearStarts;

  static List<int> _startsOfYears() {
    final starts = <int>[ummAlQuraFirstDay];
    for (final months in ummAlQuraMonths) {
      var length = 0;
      for (var month = 0; month < 12; month++) {
        length += _lengthOf(months, month);
      }
      starts.add(starts.last + length);
    }
    return starts;
  }

  static int _lengthOf(int months, int month) =>
      (months >> month) & 1 == 1 ? 30 : 29;

  /// The date of a day counted from 1 January 1970, or null if the table
  /// does not reach it.
  HijriDateParts? date(int day) {
    if (day < _yearStarts.first || day >= _yearStarts.last) return null;

    // The last year that begins on or before the day.
    var low = 0;
    var high = _yearStarts.length - 2;
    while (low < high) {
      final middle = (low + high + 1) ~/ 2;
      if (_yearStarts[middle] <= day) {
        low = middle;
      } else {
        high = middle - 1;
      }
    }

    var left = day - _yearStarts[low];
    final months = ummAlQuraMonths[low];
    for (var month = 0; month < 12; month++) {
      final length = _lengthOf(months, month);
      if (left < length) {
        return HijriDateParts(
          year: ummAlQuraFirstYear + low,
          month: month + 1,
          day: left + 1,
        );
      }
      left -= length;
    }
    return null;
  }
}

String hijriMonthName(AppLocalizations l10n, int month) {
  switch (month) {
    case 1:
      return l10n.worshipPrayerHijriMonthMuharram;
    case 2:
      return l10n.worshipPrayerHijriMonthSafar;
    case 3:
      return l10n.worshipPrayerHijriMonthRabiAlAwwal;
    case 4:
      return l10n.worshipPrayerHijriMonthRabiAlThani;
    case 5:
      return l10n.worshipPrayerHijriMonthJumadaAlAwwal;
    case 6:
      return l10n.worshipPrayerHijriMonthJumadaAlThani;
    case 7:
      return l10n.worshipPrayerHijriMonthRajab;
    case 8:
      return l10n.worshipPrayerHijriMonthShaban;
    case 9:
      return l10n.worshipPrayerHijriMonthRamadan;
    case 10:
      return l10n.worshipPrayerHijriMonthShawwal;
    case 11:
      return l10n.worshipPrayerHijriMonthDhuAlQidah;
    case 12:
      return l10n.worshipPrayerHijriMonthDhuAlHijjah;
    default:
      return l10n.worshipPrayerHijriMonthMuharram;
  }
}
