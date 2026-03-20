import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/prayer_calendar_mode.dart';

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

bool sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

HijriDateParts toHijriDate(DateTime date) {
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

String formatPrayerDateLabel({
  required BuildContext context,
  required AppLocalizations l10n,
  required DateTime selectedDate,
  required PrayerCalendarMode calendarMode,
  required String todayLabel,
  required String yesterdayLabel,
  required String tomorrowLabel,
  DateTime? relativeTo,
}) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final now = relativeTo ?? DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final selected = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );
  if (sameDay(selected, today)) return todayLabel;
  if (sameDay(selected, today.subtract(const Duration(days: 1)))) {
    return yesterdayLabel;
  }
  if (sameDay(selected, today.add(const Duration(days: 1)))) {
    return tomorrowLabel;
  }

  if (calendarMode == PrayerCalendarMode.islamic) {
    final hijri = toHijriDate(selected);
    final countFormat = NumberFormat.decimalPattern(locale);
    return l10n.worshipPrayerHijriDateValue(
      countFormat.format(hijri.day),
      hijriMonthName(l10n, hijri.month),
      countFormat.format(hijri.year),
    );
  }

  return DateFormat.yMMMd(locale).format(selected);
}

Future<DateTime?> showPrayerDateSelectionSheet({
  required BuildContext context,
  required AppLocalizations l10n,
  required DateTime initialDate,
  ValueChanged<PrayerCalendarMode>? onCalendarModeChanged,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final effectiveFirstDate = firstDate ?? DateTime(2010);
  final effectiveLastDate = lastDate ?? DateTime(2100);

  if (onCalendarModeChanged == null) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: effectiveFirstDate,
      lastDate: effectiveLastDate,
    );
  }

  DateTime? pickedDate;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: Text(l10n.worshipPrayerGregorianCalendarTitle),
            onTap: () async {
              Navigator.of(sheetContext).pop();
              onCalendarModeChanged(PrayerCalendarMode.gregorian);
              pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: effectiveFirstDate,
                lastDate: effectiveLastDate,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.nights_stay_rounded),
            title: Text(l10n.worshipPrayerIslamicCalendarTitle),
            subtitle: Text(l10n.worshipPrayerIslamicCalendarSubtitle),
            onTap: () {
              onCalendarModeChanged(PrayerCalendarMode.islamic);
              Navigator.of(sheetContext).pop();
            },
          ),
        ],
      ),
    ),
  );
  return pickedDate;
}
