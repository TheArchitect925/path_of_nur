import 'app_theme.dart';

/// Resolves the effective theme for sacred time — v1 of the Occasion Engine.
///
/// With "Dress up Fridays" enabled, the whole app wears the Jumu'ah
/// (Masjid Emerald) theme on Fridays and returns to [baseMode] after.
/// Later occasions (Ramadan, Eid, the last 10 nights) slot in above this.
AppThemeMode resolveOccasionThemeMode({
  required AppThemeMode baseMode,
  required bool dressUpFridays,
  required DateTime now,
}) {
  if (dressUpFridays && now.weekday == DateTime.friday) {
    return AppThemeMode.jummah;
  }
  return baseMode;
}
