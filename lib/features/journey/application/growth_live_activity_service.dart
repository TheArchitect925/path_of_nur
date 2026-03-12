import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'growth_models.dart';
import 'growth_widget_support.dart';

class GrowthLiveActivityService {
  static const MethodChannel _channel = MethodChannel(
    'path_of_nur/live_activities',
  );

  Future<void> updateGrowthSummary(GrowthWidgetSnapshot snapshot) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('updateGrowthSummary', {
        'todayCompletedCount': snapshot.todayCompletedCount,
        'todayDueCount': snapshot.todayDueCount,
        'todayProgressPercent': snapshot.todayProgressPercent,
        'lightEarnedToday': snapshot.lightEarnedToday,
        'currentStreak': snapshot.currentStreak,
        'nextDueHabitTitle': snapshot.nextDueHabitTitle ?? '',
        'reflectionPromptPreview': snapshot.reflectionPromptPreview,
        'privateModeEnabled': snapshot.privateModeEnabled,
      });
    } catch (_) {
      // Keep failures isolated on unsupported OS versions/configurations.
    }
  }

  Future<void> endGrowthSummary() async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('endGrowthSummary');
    } catch (_) {
      // Ignore if ActivityKit is unavailable.
    }
  }
}

final growthLiveActivityServiceProvider = Provider<GrowthLiveActivityService>((
  ref,
) {
  return GrowthLiveActivityService();
});

final growthLiveActivityBootstrapProvider = Provider<void>((ref) {
  final service = ref.read(growthLiveActivityServiceProvider);
  ref.listen<GrowthWidgetSnapshot>(growthWidgetSnapshotProvider, (_, snapshot) {
    Future<void>.microtask(() async {
      await service.updateGrowthSummary(snapshot);
    });
  }, fireImmediately: true);
});
