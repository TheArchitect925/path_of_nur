import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../data/seeded_revelation_eras.dart';
import '../domain/revelation_era.dart';
import '../domain/revelation_journey_progress.dart';

class RevelationProgressController
    extends StateNotifier<RevelationJourneyProgress> {
  RevelationProgressController(this._store)
    : super(const RevelationJourneyProgress()) {
    _load();
  }

  final LocalStore _store;

  static const _key = 'learn.prophets.revelation.progress';

  void _load() {
    final raw = _store.getJsonMap(_key);
    if (raw == null) return;

    state = RevelationJourneyProgress(
      startedEraIds: _stringSet(raw['startedEraIds']),
      completedEraIds: _stringSet(raw['completedEraIds']),
      openedProphetIds: _stringSet(raw['openedProphetIds']),
      completedEraQuizIds: _stringSet(raw['completedEraQuizIds']),
      lastVisitedEraId: _stringOrNull(raw['lastVisitedEraId']),
      lastVisitedProphetId: _stringOrNull(raw['lastVisitedProphetId']),
    );
  }

  void _save() {
    _store.setJsonMap(_key, {
      'startedEraIds': state.startedEraIds.toList()..sort(),
      'completedEraIds': state.completedEraIds.toList()..sort(),
      'openedProphetIds': state.openedProphetIds.toList()..sort(),
      'completedEraQuizIds': state.completedEraQuizIds.toList()..sort(),
      'lastVisitedEraId': state.lastVisitedEraId,
      'lastVisitedProphetId': state.lastVisitedProphetId,
    });
  }

  void startJourney() {
    if (seededRevelationEras.isEmpty) return;
    final firstEra = seededRevelationEras.first;
    final started = {...state.startedEraIds, firstEra.id};
    final firstProphet = firstEra.prophetIds.isEmpty
        ? null
        : firstEra.prophetIds.first;
    state = state.copyWith(
      startedEraIds: started,
      lastVisitedEraId: firstEra.id,
      lastVisitedProphetId: firstProphet,
    );
    _save();
  }

  void markEraOpened(String eraId) {
    final started = {...state.startedEraIds, eraId};
    state = state.copyWith(startedEraIds: started, lastVisitedEraId: eraId);
    _save();
  }

  void markProphetOpened({
    required String eraId,
    required String prophetId,
    required List<String> eraProphetIds,
  }) {
    final started = {...state.startedEraIds, eraId};
    final opened = {...state.openedProphetIds, prophetId};

    final completed = {...state.completedEraIds};
    final allOpened =
        eraProphetIds.isNotEmpty &&
        eraProphetIds.every((id) => opened.contains(id));
    if (allOpened) {
      completed.add(eraId);
    }

    state = state.copyWith(
      startedEraIds: started,
      openedProphetIds: opened,
      completedEraIds: completed,
      lastVisitedEraId: eraId,
      lastVisitedProphetId: prophetId,
    );
    _save();
  }

  bool eraCompleted(String eraId) => state.completedEraIds.contains(eraId);

  void markEraQuizCompleted(String eraId) {
    final next = {...state.completedEraQuizIds, eraId};
    state = state.copyWith(completedEraQuizIds: next);
    _save();
  }

  double completionPercent(List<RevelationEra> eras) {
    final total = eras.fold<int>(0, (sum, era) => sum + era.prophetIds.length);
    if (total == 0) return 0;
    return (state.openedProphetIds.length / total).clamp(0.0, 1.0);
  }

  Set<String> _stringSet(Object? raw) {
    final result = <String>{};
    if (raw is List) {
      for (final item in raw) {
        if (item is String && item.trim().isNotEmpty) result.add(item);
      }
    }
    return result;
  }

  String? _stringOrNull(Object? raw) {
    if (raw is String && raw.trim().isNotEmpty) return raw;
    return null;
  }
}

final revelationErasProvider = Provider<List<RevelationEra>>((ref) {
  final list = [...seededRevelationEras]
    ..sort((a, b) => a.order.compareTo(b.order));
  return list;
});

final revelationProgressProvider =
    StateNotifierProvider<
      RevelationProgressController,
      RevelationJourneyProgress
    >((ref) {
      return RevelationProgressController(ref.watch(localStoreProvider));
    });
