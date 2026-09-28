import 'package:flutter/painting.dart';

import 'app_theme.dart';

/// Living Atmosphere — Noor Glass learns the time of day.
///
/// The light theme's sky shifts with the prayer clock: rose-gold dawn from
/// Fajr, a clear cream day, amber from just before Maghrib, and after Isha
/// the starry Midnight sky (and its ink) arrives on its own until Fajr.
/// Hour buckets stand in when no prayer schedule is available yet.
enum NoorSkyPhase { dawn, day, maghrib, night }

NoorSkyPhase noorSkyPhaseAt({
  required DateTime now,
  DateTime? fajrStart,
  DateTime? maghribStart,
  DateTime? ishaStart,
}) {
  if (fajrStart != null && maghribStart != null && ishaStart != null) {
    if (now.isBefore(fajrStart) || !now.isBefore(ishaStart)) {
      return NoorSkyPhase.night;
    }
    if (now.isBefore(fajrStart.add(const Duration(minutes: 90)))) {
      return NoorSkyPhase.dawn;
    }
    if (!now.isBefore(maghribStart.subtract(const Duration(minutes: 45)))) {
      return NoorSkyPhase.maghrib;
    }
    return NoorSkyPhase.day;
  }
  final hour = now.hour + now.minute / 60;
  if (hour >= 21 || hour < 5) return NoorSkyPhase.night;
  if (hour < 8) return NoorSkyPhase.dawn;
  if (hour >= 17.5) return NoorSkyPhase.maghrib;
  return NoorSkyPhase.day;
}

/// After dark, a Noor Glass app wearing the living sky becomes Midnight —
/// sky, moon, and night ink together, so nothing reads dark-on-dark. Every
/// other mode passes through untouched.
AppThemeMode resolveLivingAtmosphereMode({
  required AppThemeMode mode,
  required bool livingAtmosphere,
  required NoorSkyPhase phase,
}) {
  if (livingAtmosphere &&
      mode == AppThemeMode.noorGlass &&
      phase == NoorSkyPhase.night) {
    return AppThemeMode.midnight;
  }
  return mode;
}

/// The painted daytime skies (from the approved Noor Glass OS board);
/// night is carried by the Midnight theme itself, never by this gradient.
Gradient noorSkyGradientFor(NoorSkyPhase phase) {
  switch (phase) {
    case NoorSkyPhase.dawn:
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFFF6E0CE),
          Color(0xFFF3EBDD),
          Color(0xFFEFE7D6),
        ],
        stops: <double>[0.0, 0.55, 1.0],
      );
    case NoorSkyPhase.maghrib:
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFFEFC08A),
          Color(0xFFF2E3CB),
          Color(0xFFEDE3D0),
        ],
        stops: <double>[0.0, 0.60, 1.0],
      );
    case NoorSkyPhase.day:
    case NoorSkyPhase.night:
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFFF8F4EA), Color(0xFFF1EADA)],
      );
  }
}
