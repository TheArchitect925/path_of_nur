import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/hijri_date_utils.dart';
import '../domain/prayer_calendar_mode.dart';

bool sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
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
