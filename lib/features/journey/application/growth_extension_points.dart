import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import 'growth_models.dart';

abstract class GrowthReminderAdapter {
  Future<void> syncHabitReminders(List<GrowthHabit> habits);
}

abstract class GrowthWidgetSyncAdapter {
  Future<void> syncWidgetState(GrowthState state);
}

abstract class GrowthPackRepository {
  Future<List<GrowthHabit>> loadHabitsPack(String packId);
}

abstract class GrowthRewardPackRepository {
  Future<List<Map<String, dynamic>>> loadRewardPack(String packId);
}

abstract class GrowthFamilyEncouragementAdapter {
  Future<void> shareGentleEncouragement({
    required String message,
    required DateTime when,
  });
}

abstract class GrowthCloudSyncAdapter {
  Future<void> pushGrowthState(GrowthState state);
  Future<GrowthState?> pullGrowthState();
}

class NoopGrowthReminderAdapter implements GrowthReminderAdapter {
  @override
  Future<void> syncHabitReminders(List<GrowthHabit> habits) async {}
}

class NoopGrowthWidgetSyncAdapter implements GrowthWidgetSyncAdapter {
  @override
  Future<void> syncWidgetState(GrowthState state) async {}
}

class LocalStoreGrowthWidgetSyncAdapter implements GrowthWidgetSyncAdapter {
  const LocalStoreGrowthWidgetSyncAdapter(this._store);

  final LocalStore _store;

  @override
  Future<void> syncWidgetState(GrowthState state) async {
    await _store.setJsonMap('growth.widget.state.v1', {
      'privateMode': state.privateMode,
      'focusHabitId': state.focusHabitId,
      'updatedAtIso': DateTime.now().toIso8601String(),
    });
  }
}

class NoopGrowthPackRepository implements GrowthPackRepository {
  @override
  Future<List<GrowthHabit>> loadHabitsPack(String packId) async => const [];
}

class NoopGrowthRewardPackRepository implements GrowthRewardPackRepository {
  @override
  Future<List<Map<String, dynamic>>> loadRewardPack(String packId) async =>
      const [];
}

class NoopGrowthFamilyEncouragementAdapter
    implements GrowthFamilyEncouragementAdapter {
  @override
  Future<void> shareGentleEncouragement({
    required String message,
    required DateTime when,
  }) async {}
}

class NoopGrowthCloudSyncAdapter implements GrowthCloudSyncAdapter {
  @override
  Future<GrowthState?> pullGrowthState() async => null;

  @override
  Future<void> pushGrowthState(GrowthState state) async {}
}

final growthReminderAdapterProvider = Provider<GrowthReminderAdapter>(
  (ref) => NoopGrowthReminderAdapter(),
);

final growthWidgetSyncAdapterProvider = Provider<GrowthWidgetSyncAdapter>(
  (ref) => LocalStoreGrowthWidgetSyncAdapter(ref.watch(localStoreProvider)),
);

final growthPackRepositoryProvider = Provider<GrowthPackRepository>(
  (ref) => NoopGrowthPackRepository(),
);

final growthRewardPackRepositoryProvider = Provider<GrowthRewardPackRepository>(
  (ref) => NoopGrowthRewardPackRepository(),
);

final growthFamilyEncouragementAdapterProvider =
    Provider<GrowthFamilyEncouragementAdapter>(
      (ref) => NoopGrowthFamilyEncouragementAdapter(),
    );

final growthCloudSyncAdapterProvider = Provider<GrowthCloudSyncAdapter>(
  (ref) => NoopGrowthCloudSyncAdapter(),
);
