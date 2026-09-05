import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';

const int kDefaultDhikrDailyGoal = 500;
const int kMinDhikrDailyGoal = 33;
const int kMaxDhikrDailyGoal = 5000;
const String _dhikrDailyGoalKey = 'worship.dhikr.dailyGoal.v1';

/// Single source of truth for the daily dhikr goal — previously hardcoded as
/// 500 in three separate widgets. User-configurable from the dhikr page.
final dhikrDailyGoalProvider = NotifierProvider<DhikrDailyGoalNotifier, int>(
  DhikrDailyGoalNotifier.new,
);

class DhikrDailyGoalNotifier extends Notifier<int> {
  @override
  int build() {
    final stored = ref.watch(localStoreProvider).getInt(_dhikrDailyGoalKey);
    if (stored == null) return kDefaultDhikrDailyGoal;
    return stored.clamp(kMinDhikrDailyGoal, kMaxDhikrDailyGoal);
  }

  void setGoal(int goal) {
    final clamped = goal.clamp(kMinDhikrDailyGoal, kMaxDhikrDailyGoal);
    state = clamped;
    ref.read(localStoreProvider).setInt(_dhikrDailyGoalKey, clamped);
  }
}
