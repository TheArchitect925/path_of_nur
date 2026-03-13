import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../shared/application/learn_system_engine_provider.dart';

const _duaStateKey = 'learn.dua.progress.v1';

class DuaLearningState {
  const DuaLearningState({required this.savedIds, required this.recentIds});

  final Set<String> savedIds;
  final List<String> recentIds;

  DuaLearningState copyWith({Set<String>? savedIds, List<String>? recentIds}) {
    return DuaLearningState(
      savedIds: savedIds ?? this.savedIds,
      recentIds: recentIds ?? this.recentIds,
    );
  }

  Map<String, dynamic> toJson() => {
    'savedIds': savedIds.toList(growable: false),
    'recentIds': recentIds,
  };

  factory DuaLearningState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DuaLearningState(
        savedIds: <String>{},
        recentIds: <String>[],
      );
    }
    final saved = (json['savedIds'] as List?) ?? const [];
    final recent = (json['recentIds'] as List?) ?? const [];
    return DuaLearningState(
      savedIds: saved.map((entry) => entry.toString()).toSet(),
      recentIds: recent
          .map((entry) => entry.toString())
          .toList(growable: false),
    );
  }
}

class DuaLearningNotifier extends StateNotifier<DuaLearningState> {
  DuaLearningNotifier(this._store, this._ref)
    : super(DuaLearningState.fromJson(_store.getJsonMap(_duaStateKey)));

  final LocalStore _store;
  final Ref _ref;

  void open(String duaId) {
    final recent = [...state.recentIds]..remove(duaId);
    recent.insert(0, duaId);
    if (recent.length > 12) {
      recent.removeRange(12, recent.length);
    }
    state = state.copyWith(recentIds: recent);
    _persist();
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markStarted(_itemId(duaId));
  }

  void toggleSaved(String duaId) {
    final next = {...state.savedIds};
    if (!next.remove(duaId)) {
      next.add(duaId);
    }
    state = state.copyWith(savedIds: next);
    _persist();
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .toggleSaved(_itemId(duaId));
  }

  void markReflected(String duaId) {
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markReflected(_itemId(duaId));
  }

  void _persist() {
    _store.setJsonMap(_duaStateKey, state.toJson());
  }
}

String _itemId(String duaId) => 'dua:item:$duaId';

final duaLearningProvider =
    StateNotifierProvider<DuaLearningNotifier, DuaLearningState>((ref) {
      return DuaLearningNotifier(ref.watch(localStoreProvider), ref);
    });
