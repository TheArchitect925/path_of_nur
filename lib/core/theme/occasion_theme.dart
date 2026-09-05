import '../../shared/utils/hijri_date_utils.dart';
import 'app_theme.dart';

/// Resolves the effective theme for sacred time — the Occasion Engine.
///
/// The ladder, highest first: Laylat al-Qadr (the odd last-ten nights of
/// Ramadan, night hours only) > Eid (al-Fitr and al-Adha) > Ramadan >
/// Jumu'ah Fridays > the user's base theme. Each rung only fires when its
/// dress-up consent is on; the consent sheet on Home offers each occasion
/// once as it arrives.
AppThemeMode resolveOccasionThemeMode({
  required AppThemeMode baseMode,
  required bool dressUpFridays,
  required DateTime now,
  bool dressUpRamadan = false,
  bool isRamadan = false,
  bool dressUpQadrNights = false,
  bool isQadrNight = false,
  bool dressUpEid = false,
  bool isEid = false,
}) {
  if (dressUpQadrNights && isQadrNight) {
    return AppThemeMode.laylatAlQadr;
  }
  if (dressUpEid && isEid) {
    return AppThemeMode.eid;
  }
  if (dressUpRamadan && isRamadan) {
    return AppThemeMode.ramadan;
  }
  if (dressUpFridays && now.weekday == DateTime.friday) {
    return AppThemeMode.jummah;
  }
  return baseMode;
}

// Calendar-day arithmetic runs on UTC dates: local midnights are not a
// whole number of days apart across a DST change, which truncates inDays.
DateTime? _parseDay(String? iso) {
  if (iso == null) return null;
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return null;
  return DateTime.utc(parsed.year, parsed.month, parsed.day);
}

DateTime _dayOf(DateTime now) => DateTime.utc(now.year, now.month, now.day);

/// 1-based day of Ramadan for [now]'s date, from the user's saved start
/// date when available, otherwise the tabular hijri calendar. Null outside
/// the month.
int? ramadanDayAt({
  String? ramadanStartIso,
  String? ramadanEndIso,
  required DateTime now,
}) {
  final start = _parseDay(ramadanStartIso);
  final today = _dayOf(now);
  if (start != null) {
    final end = _parseDay(ramadanEndIso);
    final totalDays = end == null ? 30 : end.difference(start).inDays + 1;
    final day = today.difference(start).inDays + 1;
    if (day < 1 || day > totalDays) return null;
    return day;
  }
  final hijri = toHijriDate(today);
  if (hijri.month != 9) return null;
  return hijri.day;
}

/// The Ramadan night that [now] falls inside, or null during daytime or
/// outside the month. A night runs from the evening before its day (from
/// 18:00) until dawn (before 06:00) — so the evening of day 26 is night 27.
int? ramadanNightAt({
  String? ramadanStartIso,
  String? ramadanEndIso,
  required DateTime now,
}) {
  final int night;
  if (now.hour >= 18) {
    final day = ramadanDayAt(
      ramadanStartIso: ramadanStartIso,
      ramadanEndIso: ramadanEndIso,
      now: now,
    );
    if (day == null) return null;
    night = day + 1;
  } else if (now.hour < 6) {
    final day = ramadanDayAt(
      ramadanStartIso: ramadanStartIso,
      ramadanEndIso: ramadanEndIso,
      now: now,
    );
    if (day == null) return null;
    night = day;
  } else {
    return null;
  }
  if (night < 1 || night > 30) return null;
  return night;
}

const Set<int> laylatAlQadrNights = <int>{21, 23, 25, 27, 29};

/// True during the odd nights of the last ten of Ramadan (night hours only).
bool isLaylatAlQadrNightAt({
  String? ramadanStartIso,
  String? ramadanEndIso,
  required DateTime now,
}) {
  final night = ramadanNightAt(
    ramadanStartIso: ramadanStartIso,
    ramadanEndIso: ramadanEndIso,
    now: now,
  );
  return night != null && laylatAlQadrNights.contains(night);
}

/// Eid al-Fitr: the three days after the user's saved Ramadan end date, or
/// 1–3 Shawwal by the tabular hijri calendar when no dates are saved.
bool isEidAlFitrAt({String? ramadanEndIso, required DateTime now}) {
  final end = _parseDay(ramadanEndIso);
  final today = _dayOf(now);
  if (end != null) {
    final sinceEnd = today.difference(end).inDays;
    return sinceEnd >= 1 && sinceEnd <= 3;
  }
  final hijri = toHijriDate(today);
  return hijri.month == 10 && hijri.day <= 3;
}

/// Eid al-Adha: 10–12 Dhul-Hijjah by the tabular hijri calendar. The
/// tabular date can sit a day off the sighted moon; dress-up is a consent
/// the user can decline or end early.
bool isEidAlAdhaAt(DateTime now) {
  final hijri = toHijriDate(DateTime(now.year, now.month, now.day));
  return hijri.month == 12 && hijri.day >= 10 && hijri.day <= 12;
}
