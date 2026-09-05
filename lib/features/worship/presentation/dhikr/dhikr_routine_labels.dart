import 'package:flutter/material.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../domain/dhikr_routine.dart';

/// Title for any routine: built-in kinds from the localizations, custom
/// routines from their own name.
String dhikrRoutineDisplayTitle(AppLocalizations l10n, DhikrRoutine routine) {
  if (routine.isCustom) {
    final name = routine.customName?.trim() ?? '';
    return name.isEmpty ? l10n.dhikrCustomRoutineFallbackName : name;
  }
  return dhikrRoutineTitle(l10n, routine.kind);
}

String dhikrRoutineTitle(AppLocalizations l10n, DhikrRoutineKind kind) {
  switch (kind) {
    case DhikrRoutineKind.afterSalah:
      return l10n.dhikrRoutineAfterSalahTitle;
    case DhikrRoutineKind.morning:
      return l10n.dhikrRoutineMorningTitle;
    case DhikrRoutineKind.evening:
      return l10n.dhikrRoutineEveningTitle;
    case DhikrRoutineKind.sleep:
      return l10n.dhikrRoutineSleepTitle;
    case DhikrRoutineKind.custom:
      return l10n.dhikrCustomRoutineFallbackName;
  }
}

String dhikrRoutineSubtitle(AppLocalizations l10n, DhikrRoutine routine) {
  switch (routine.kind) {
    case DhikrRoutineKind.afterSalah:
      return l10n.dhikrRoutineAfterSalahSubtitle(routine.estimatedMinutes);
    case DhikrRoutineKind.morning:
      return l10n.dhikrRoutineMorningSubtitle(routine.steps.length);
    case DhikrRoutineKind.evening:
      return l10n.dhikrRoutineEveningSubtitle(routine.steps.length);
    case DhikrRoutineKind.sleep:
      return l10n.dhikrRoutineSleepSubtitle(routine.steps.length);
    case DhikrRoutineKind.custom:
      return l10n.dhikrNowMeta(routine.steps.length, routine.estimatedMinutes);
  }
}

IconData dhikrRoutineIcon(DhikrRoutineKind kind) {
  switch (kind) {
    case DhikrRoutineKind.afterSalah:
      return IslamicIcons.prayer;
    case DhikrRoutineKind.morning:
      return Icons.wb_sunny_rounded;
    case DhikrRoutineKind.evening:
      return Icons.nights_stay_rounded;
    case DhikrRoutineKind.sleep:
      return Icons.bedtime_rounded;
    case DhikrRoutineKind.custom:
      return Icons.favorite_border_rounded;
  }
}

/// Sessions store a canonical English label; known routine labels come back
/// localized, anything else (the six presets, older rows) is shown as is.
String localizedDhikrSessionLabel(AppLocalizations l10n, String label) {
  switch (label) {
    case 'After-salah tasbih':
      return l10n.dhikrRoutineAfterSalahTitle;
    case 'Morning adhkar':
      return l10n.dhikrRoutineMorningTitle;
    case 'Evening adhkar':
      return l10n.dhikrRoutineEveningTitle;
    case 'Before-sleep adhkar':
      return l10n.dhikrRoutineSleepTitle;
    case 'Post-Salah Dhikr':
      return l10n.dhikrSessionLabelPostSalah;
    default:
      return label;
  }
}

String dhikrPrayerLabel(
  AppLocalizations l10n,
  String prayerId, {
  DateTime? date,
}) {
  return localizedPrayerNameForDate(
    prayerId: prayerId,
    l10n: l10n,
    date: date ?? DateTime.now(),
  );
}
