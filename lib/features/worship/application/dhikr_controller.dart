import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/dhikr_preset.dart';
import '../domain/dhikr_session.dart';
import '../domain/dhikr_summary.dart';

class DhikrSessionState {
  const DhikrSessionState({
    required this.selectedPreset,
    required this.target,
    required this.currentCount,
    required this.recentSessions,
  });

  final DhikrPreset selectedPreset;
  final int target;
  final int currentCount;
  final List<DhikrSession> recentSessions;

  bool get hasTargetReached => currentCount >= target;

  DhikrSummary get summary {
    final totals =
        recentSessions.fold<int>(0, (acc, session) => acc + session.count);
    final top = _favoriteLabel();
    return DhikrSummary(
      totalCount: totals,
      sessionsCompleted: recentSessions.length,
      favoritePhrase: top,
    );
  }

  String _favoriteLabel() {
    if (recentSessions.isEmpty) {
      return 'Alhamdulillah';
    }
    final counts = <String, int>{};
    for (final session in recentSessions) {
      counts.update(session.phraseLabel, (value) => value + session.count,
          ifAbsent: () => session.count);
    }
    return counts.entries
        .reduce(
          (left, right) => left.value >= right.value ? left : right,
        )
        .key;
  }

  DhikrSessionState copyWith({
    DhikrPreset? selectedPreset,
    int? target,
    int? currentCount,
    List<DhikrSession>? recentSessions,
  }) {
    return DhikrSessionState(
      selectedPreset: selectedPreset ?? this.selectedPreset,
      target: target ?? this.target,
      currentCount: currentCount ?? this.currentCount,
      recentSessions: recentSessions ?? this.recentSessions,
    );
  }

  factory DhikrSessionState.initial() {
    return DhikrSessionState(
      selectedPreset: DhikrPreset.defaults.first,
      target: 33,
      currentCount: 0,
      recentSessions: const [],
    );
  }
}

class DhikrController extends StateNotifier<DhikrSessionState> {
  DhikrController() : super(DhikrSessionState.initial());

  void selectPreset(DhikrPreset preset) {
    state = state.copyWith(selectedPreset: preset);
  }

  void setTarget(int target) {
    if (target <= 0) return;
    state = state.copyWith(target: target, currentCount: 0);
  }

  void increment() {
    state = state.copyWith(currentCount: state.currentCount + 1);
  }

  void undo() {
    if (state.currentCount <= 0) return;
    state = state.copyWith(currentCount: state.currentCount - 1);
  }

  void reset() {
    state = state.copyWith(currentCount: 0);
  }

  void finishSession() {
    if (state.currentCount <= 0) return;

    final now = DateTime.now();
    final completed = DhikrSession(
      phraseLabel: state.selectedPreset.label,
      count: state.currentCount,
      target: state.target,
      startedAt: now.subtract(
        Duration(seconds: state.currentCount),
      ),
      finishedAt: now,
    );

    state = state.copyWith(
      currentCount: 0,
      recentSessions: [completed, ...state.recentSessions],
    );
  }
}

final dhikrControllerProvider =
    StateNotifierProvider<DhikrController, DhikrSessionState>(
      (ref) => DhikrController(),
    );
