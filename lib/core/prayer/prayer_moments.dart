import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/application/daily_clock_provider.dart';
import '../theme/app_motion.dart';
import 'prayer_preferences.dart';

/// The prayer whose time came in within the last [AppMotion.adhanGlow], or
/// null. Home's hero and strip kindle for it; the clock ticks every thirty
/// seconds, so the glow lasts between thirty and sixty seconds.
final prayerJustArrivedProvider = Provider<String?>((ref) {
  final schedule = ref.watch(prayerScheduleContextProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final currentId = schedule.currentPrayerId;
  if (currentId == null) return null;
  final current = schedule.items
      .where((item) => item.id == currentId)
      .firstOrNull;
  if (current == null) return null;
  final since = now.difference(current.windowStartDateTime);
  if (since.isNegative || since >= AppMotion.adhanGlow) return null;
  return currentId;
});
