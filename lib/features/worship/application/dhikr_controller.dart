import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ocean/application/ocean_drops_provider.dart';
import '../../../shared/persistence/local_store.dart';
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
  DhikrController(this._store, this._oceanDrops)
    : super(DhikrSessionState.initial()) {
    _load();
  }

  final LocalStore _store;
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
    final data = _store.getJsonMap('worship.dhikr');
    if (data == null) return;

    final presetId = data['selectedPresetId'] as String?;
    DhikrPreset? preset;
    for (final item in DhikrPreset.defaults) {
      if (item.id == presetId) {
        preset = item;
        break;
      }
    }

    final sessionsRaw = data['recentSessions'];
    final sessions = <DhikrSession>[];
    if (sessionsRaw is List) {
      for (final row in sessionsRaw) {
        if (row is! Map) continue;
        final phraseLabel = row['phraseLabel']?.toString();
        final count = row['count'];
        final target = row['target'];
        final startedAt = row['startedAt']?.toString();
        final finishedAt = row['finishedAt']?.toString();
        if (phraseLabel == null ||
            count is! int ||
            target is! int ||
            startedAt == null ||
            finishedAt == null) {
          continue;
        }
        sessions.add(
          DhikrSession(
            phraseLabel: phraseLabel,
            count: count,
            target: target,
            startedAt: DateTime.tryParse(startedAt) ?? DateTime.now(),
            finishedAt: DateTime.tryParse(finishedAt) ?? DateTime.now(),
          ),
        );
      }
    }

    state = state.copyWith(
      selectedPreset: preset ?? state.selectedPreset,
      target: data['target'] as int? ?? state.target,
      currentCount: data['currentCount'] as int? ?? state.currentCount,
      recentSessions: sessions,
    );
  }

  void _save() {
    _store.setJsonMap('worship.dhikr', {
      'selectedPresetId': state.selectedPreset.id,
      'target': state.target,
      'currentCount': state.currentCount,
      'recentSessions': state.recentSessions
          .take(30)
          .map((session) => {
                'phraseLabel': session.phraseLabel,
                'count': session.count,
                'target': session.target,
                'startedAt': session.startedAt.toIso8601String(),
                'finishedAt': session.finishedAt.toIso8601String(),
              })
          .toList(),
    });
  }
}

final dhikrControllerProvider =
    StateNotifierProvider<DhikrController, DhikrSessionState>(
      (ref) => DhikrController(
        ref.watch(localStoreProvider),
        ref.read(oceanDropServiceProvider),
      ),
    );
