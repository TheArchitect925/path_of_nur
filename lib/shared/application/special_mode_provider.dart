import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/application/profile_settings_provider.dart';

enum AppSpecialMode { none, ramadan, loss, gentle }

class SpecialModeState {
  const SpecialModeState({
    required this.activeMode,
    required this.kidsModeEnabled,
    required this.ramadanStart,
    required this.ramadanEnd,
    required this.ramadanDateWindowActive,
  });

  final AppSpecialMode activeMode;
  final bool kidsModeEnabled;
  final DateTime? ramadanStart;
  final DateTime? ramadanEnd;
  final bool ramadanDateWindowActive;

  bool get isRamadan => activeMode == AppSpecialMode.ramadan;
  bool get isLoss => activeMode == AppSpecialMode.loss;
  bool get isGentle => activeMode == AppSpecialMode.gentle;
  bool get isKids => kidsModeEnabled;
}

final specialModeProvider = Provider<SpecialModeState>((ref) {
  final settings = ref.watch(profileSettingsProvider);

  final activeMode = settings.ramadanModeEnabled
      ? AppSpecialMode.ramadan
      : settings.lossModeEnabled
      ? AppSpecialMode.loss
      : settings.gentleModeEnabled
      ? AppSpecialMode.gentle
      : AppSpecialMode.none;

  final start = _parseDate(settings.ramadanStartDateIso);
  final end = _parseDate(settings.ramadanEndDateIso);

  bool inRange = false;
  if (start != null && end != null) {
    final now = DateTime.now();
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    final nowDay = DateTime(now.year, now.month, now.day);
    inRange = !nowDay.isBefore(startDay) && !nowDay.isAfter(endDay);
  }

  return SpecialModeState(
    activeMode: activeMode,
    kidsModeEnabled: settings.kidsModeEnabled,
    ramadanStart: start,
    ramadanEnd: end,
    ramadanDateWindowActive: inRange,
  );
});

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

String formatDateYmd(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
