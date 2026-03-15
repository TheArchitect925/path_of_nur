import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ocean/application/ocean_drops_provider.dart';
import '../data/dhikr_repository.dart';
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
  DhikrController(this._repository, this._oceanDrops)
    : super(DhikrSessionState.initial()) {
    _load();
  }

  final DhikrRepository _repository;
  final OceanDropService _oceanDrops;

  void selectPreset(DhikrPreset preset) {
    state = state.copyWith(selectedPreset: preset);
    _save();
  }

  void setTarget(int target) {
    if (target <= 0) return;
    state = state.copyWith(target: target, currentCount: 0);
    _save();
  }

  void increment() {
    state = state.copyWith(currentCount: state.currentCount + 1);
    _save();
    if (state.target >= 100) {
      _oceanDrops.awardDrop(
        actionType: oceanActionDhikrFreeHundredReached,
        sourceModule: oceanSourceDhikr,
        referenceId: 'free_dhikr',
        metadata: {
          'countDelta': 1,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  void addManualCount(int count) {
    if (count <= 0) return;
    state = state.copyWith(currentCount: state.currentCount + count);
    _save();
    if (state.target >= 100) {
      _oceanDrops.awardDrop(
        actionType: oceanActionDhikrFreeHundredReached,
        sourceModule: oceanSourceDhikr,
        referenceId: 'free_dhikr',
        metadata: {
          'countDelta': count,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  void undo() {
    if (state.currentCount <= 0) return;
    state = state.copyWith(currentCount: state.currentCount - 1);
    _save();
  }

  void reset() {
    state = state.copyWith(currentCount: 0);
    _save();
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
    _save();
    if (completed.target < 100) {
      _oceanDrops.awardDrop(
        actionType: oceanActionDhikrSetCompleted,
        sourceModule: oceanSourceDhikr,
        referenceId: completed.finishedAt.toIso8601String(),
        metadata: {
          'target': completed.target,
          'phraseLabel': completed.phraseLabel,
          'timestamp': completed.finishedAt.toIso8601String(),
        },
      );
    }
  }

  void reloadFromStorage() {
    state = DhikrSessionState.initial();
    _load();
  }

  void _load() {
    final data = _repository.load();
    final presetId = data.selectedPresetId;
    DhikrPreset? preset;
    for (final item in DhikrPreset.defaults) {
      if (item.id == presetId) {
        preset = item;
        break;
      }
    }

    state = state.copyWith(
      selectedPreset: preset ?? state.selectedPreset,
      target: data.target,
      currentCount: data.currentCount,
      recentSessions: data.recentSessions,
    );
  }

  void _save() {
    _repository.saveState(
      selectedPresetId: state.selectedPreset.id,
      target: state.target,
      currentCount: state.currentCount,
    );
    _repository.replaceRecentSessions(state.recentSessions);
  }
}

final dhikrControllerProvider =
    StateNotifierProvider<DhikrController, DhikrSessionState>(
      (ref) => DhikrController(
        ref.watch(dhikrRepositoryProvider),
        ref.read(oceanDropServiceProvider),
      ),
    );
