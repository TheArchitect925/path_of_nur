import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';

const _sisterCycleKey = 'worship.sisterCycle';

class SisterCycleState {
  const SisterCycleState({
    required this.active,
    required this.startedAtIso,
    required this.notes,
    required this.expectedDurationDays,
    required this.autoAdjustReminders,
    required this.sendPurityCheckReminder,
  });

  final bool active;
  final String? startedAtIso;
  final String notes;
  final int expectedDurationDays;
  final bool autoAdjustReminders;
  final bool sendPurityCheckReminder;

  SisterCycleState copyWith({
    bool? active,
    String? startedAtIso,
    String? notes,
    int? expectedDurationDays,
    bool? autoAdjustReminders,
    bool? sendPurityCheckReminder,
  }) {
    return SisterCycleState(
      active: active ?? this.active,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      notes: notes ?? this.notes,
      expectedDurationDays: expectedDurationDays ?? this.expectedDurationDays,
      autoAdjustReminders: autoAdjustReminders ?? this.autoAdjustReminders,
      sendPurityCheckReminder:
          sendPurityCheckReminder ?? this.sendPurityCheckReminder,
    );
  }

  Map<String, dynamic> toJson() => {
    'active': active,
    'startedAtIso': startedAtIso,
    'notes': notes,
    'expectedDurationDays': expectedDurationDays,
    'autoAdjustReminders': autoAdjustReminders,
    'sendPurityCheckReminder': sendPurityCheckReminder,
  };

  static SisterCycleState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SisterCycleState(
        active: false,
        startedAtIso: null,
        notes: '',
        expectedDurationDays: 7,
        autoAdjustReminders: true,
        sendPurityCheckReminder: true,
      );
    }
    return SisterCycleState(
      active: json['active'] == true,
      startedAtIso: json['startedAtIso']?.toString(),
      notes: json['notes']?.toString() ?? '',
      expectedDurationDays:
          (json['expectedDurationDays'] as num?)?.toInt().clamp(3, 12) ?? 7,
      autoAdjustReminders: json['autoAdjustReminders'] != false,
      sendPurityCheckReminder: json['sendPurityCheckReminder'] != false,
    );
  }
}

class SisterCycleNotifier extends StateNotifier<SisterCycleState> {
  SisterCycleNotifier(this._store)
    : super(SisterCycleState.fromJson(_store.getJsonMap(_sisterCycleKey)));

  final LocalStore _store;

  void setActive(bool active) {
    state = state.copyWith(
      active: active,
      startedAtIso: active ? DateTime.now().toIso8601String() : null,
    );
    _save();
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes.trim());
    _save();
  }

  void setExpectedDurationDays(int days) {
    state = state.copyWith(expectedDurationDays: days.clamp(3, 12));
    _save();
  }

  void setAutoAdjustReminders(bool enabled) {
    state = state.copyWith(autoAdjustReminders: enabled);
    _save();
  }

  void setSendPurityCheckReminder(bool enabled) {
    state = state.copyWith(sendPurityCheckReminder: enabled);
    _save();
  }

  void _save() {
    _store.setJsonMap(_sisterCycleKey, state.toJson());
  }
}

final sisterCycleProvider =
    StateNotifierProvider<SisterCycleNotifier, SisterCycleState>(
      (ref) => SisterCycleNotifier(ref.watch(localStoreProvider)),
    );

class SisterCycleGuidance {
  const SisterCycleGuidance({
    required this.dayNumber,
    required this.summary,
    required this.recommendedFocus,
  });

  final int dayNumber;
  final String summary;
  final List<String> recommendedFocus;
}

final sisterCycleGuidanceProvider = Provider<SisterCycleGuidance>((ref) {
  final state = ref.watch(sisterCycleProvider);
  if (!state.active || state.startedAtIso == null) {
    return const SisterCycleGuidance(
      dayNumber: 0,
      summary: 'Regular worship tracking is active.',
      recommendedFocus: [
        'Maintain prayer on time.',
        'Keep dhikr and Qur\'an reflection steady.',
      ],
    );
  }

  final startedAt = DateTime.tryParse(state.startedAtIso!);
  final now = DateTime.now();
  final dayNumber = startedAt == null
      ? 1
      : now
                .difference(
                  DateTime(startedAt.year, startedAt.month, startedAt.day),
                )
                .inDays +
            1;
  final nearingEnd = dayNumber >= state.expectedDurationDays - 1;

  return SisterCycleGuidance(
    dayNumber: dayNumber.clamp(1, 99),
    summary: nearingEnd
        ? 'Near expected end. Prepare to resume regular salah routine when pure.'
        : 'Salah and fasting are paused for this period. Keep ibadah through alternatives.',
    recommendedFocus: const [
      'Morning/evening dhikr',
      'Du\'a and gratitude journaling',
      'Qur\'an listening and tafsir reflection',
      'Sadaqah and service intention',
    ],
  );
});
