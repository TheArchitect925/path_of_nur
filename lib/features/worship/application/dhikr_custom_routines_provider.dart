import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../../shared/persistence/structured_data_scope.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../domain/dhikr_custom_routine.dart';

const String _customRoutinesKeyPrefix = 'worship.dhikr.routines.custom.v1';

/// The user's own routines, oldest first, kept per data scope in the local
/// store (they are not part of accounts sync yet).
final dhikrCustomRoutinesProvider =
    NotifierProvider<DhikrCustomRoutinesNotifier, List<DhikrCustomRoutine>>(
      DhikrCustomRoutinesNotifier.new,
    );

class DhikrCustomRoutinesNotifier extends Notifier<List<DhikrCustomRoutine>> {
  String get _key =>
      '$_customRoutinesKeyPrefix.${ref.read(structuredDataScopeProvider)}';

  @override
  List<DhikrCustomRoutine> build() {
    ref.watch(profileScopeVersionProvider);
    ref.watch(structuredDataScopeProvider);
    final raw = ref.watch(localStoreProvider).getJsonList(_key);
    if (raw == null) return const <DhikrCustomRoutine>[];
    return <DhikrCustomRoutine>[
      for (final item in raw)
        if (item is Map)
          ?DhikrCustomRoutine.fromJson(
            item.map((key, value) => MapEntry(key.toString(), value)),
          ),
    ];
  }

  DhikrCustomRoutine? byId(String id) {
    for (final routine in state) {
      if (routine.id == id) return routine;
    }
    return null;
  }

  /// Adds or replaces a routine (matched by id) and persists the list.
  void upsert(DhikrCustomRoutine routine) {
    final next = <DhikrCustomRoutine>[
      for (final existing in state)
        if (existing.id != routine.id) existing,
    ];
    final index = state.indexWhere((existing) => existing.id == routine.id);
    if (index < 0) {
      next.add(routine);
    } else {
      next.insert(index, routine);
    }
    _write(next);
  }

  void delete(String id) {
    _write(<DhikrCustomRoutine>[
      for (final existing in state)
        if (existing.id != id) existing,
    ]);
  }

  void _write(List<DhikrCustomRoutine> routines) {
    state = routines;
    ref.read(localStoreProvider).setJsonList(_key, <Map<String, dynamic>>[
      for (final routine in routines) routine.toJson(),
    ]);
  }
}
