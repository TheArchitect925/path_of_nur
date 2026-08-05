import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

@immutable
class MoonPhaseVisualData {
  const MoonPhaseVisualData({
    required this.label,
    required this.emoji,
    required this.illuminationPercent,
  });

  final String label;
  final String emoji;
  final int illuminationPercent;
}

MoonPhaseVisualData moonPhaseVisualForDate(
  DateTime date,
  AppLocalizations l10n,
) {
  final normalized = DateTime(date.year, date.month, date.day);
  final epoch = DateTime.utc(2000, 1, 6);
  final days = normalized.toUtc().difference(epoch).inHours / 24;
  const synodic = 29.53058867;
  final age = (days % synodic + synodic) % synodic;
  final illumination = ((1 - math.cos((2 * math.pi * age) / synodic)) / 2 * 100)
      .round()
      .clamp(0, 100);
  if (age < 1.84566) {
    return MoonPhaseVisualData(
      label: l10n.worshipPrayerMoonPhaseNewMoon,
      emoji: '🌑',
      illuminationPercent: illumination,
    );
  }
  if (age < 5.53699) {
    return MoonPhaseVisualData(
      label: l10n.worshipPrayerMoonPhaseWaxingCrescent,
      emoji: '🌒',
      illuminationPercent: illumination,
    );
  }
  if (age < 9.22831) {
    return MoonPhaseVisualData(
      label: l10n.worshipPrayerMoonPhaseFirstQuarter,
      emoji: '🌓',
      illuminationPercent: illumination,
    );
  }
  if (age < 12.91963) {
    return MoonPhaseVisualData(
      label: l10n.worshipPrayerMoonPhaseWaxingGibbous,
      emoji: '🌔',
      illuminationPercent: illumination,
    );
  }
  if (age < 16.61096) {
    return MoonPhaseVisualData(
      label: l10n.worshipPrayerMoonPhaseFullMoon,
      emoji: '🌕',
      illuminationPercent: illumination,
    );
  }
  if (age < 20.30228) {
    return MoonPhaseVisualData(
      label: l10n.worshipPrayerMoonPhaseWaningGibbous,
      emoji: '🌖',
      illuminationPercent: illumination,
    );
  }
  if (age < 23.99361) {
    return MoonPhaseVisualData(
      label: l10n.worshipPrayerMoonPhaseLastQuarter,
      emoji: '🌗',
      illuminationPercent: illumination,
    );
  }
  if (age < 27.68493) {
    return MoonPhaseVisualData(
      label: l10n.worshipPrayerMoonPhaseWaningCrescent,
      emoji: '🌘',
      illuminationPercent: illumination,
    );
  }
  return MoonPhaseVisualData(
    label: l10n.worshipPrayerMoonPhaseNewMoon,
    emoji: '🌑',
    illuminationPercent: illumination,
  );
}

class MoonPhaseVisual extends StatelessWidget {
  const MoonPhaseVisual({super.key, required this.moon, this.size = 136});

  final MoonPhaseVisualData moon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: moon.label,
      child: Text(moon.emoji, style: TextStyle(fontSize: size)),
    );
  }
}
