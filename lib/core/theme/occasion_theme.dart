import 'app_theme.dart';

/// Resolves the effective theme for sacred time — v1 of the Occasion Engine.
///
/// With "Dress up for Ramadan" enabled, the whole app wears the Layali theme
/// while Ramadan is active (the user's saved date window, or Ramadan mode
/// switched on). With "Dress up Fridays" enabled, Fridays wear the Jumu'ah
/// (Masjid Emerald) theme. Ramadan outranks Jumu'ah — a Friday in Ramadan
/// stays violet. Later occasions (Eid, the last 10 nights) slot in above.
AppThemeMode resolveOccasionThemeMode({
  required AppThemeMode baseMode,
  required bool dressUpFridays,
  required DateTime now,
  bool dressUpRamadan = false,
  bool isRamadan = false,
}) {
  if (dressUpRamadan && isRamadan) {
    return AppThemeMode.ramadan;
  }
  if (dressUpFridays && now.weekday == DateTime.friday) {
    return AppThemeMode.jummah;
  }
  return baseMode;
}
