import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../prayer/prayer_preferences.dart';

class PrayerLiveActivityService {
  static const MethodChannel _channel = MethodChannel(
    'path_of_nur/live_activities',
  );

  Future<bool> isSupported() async {
    if (!Platform.isIOS) return false;
    try {
      final value = await _channel.invokeMethod<bool>('isSupported');
      return value ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> updatePrayerCountdown({
    required PrayerScheduleItem prayer,
    required Duration remaining,
  }) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('updatePrayerCountdown', {
        'prayerId': prayer.id,
        'prayerName': prayer.name,
        'prayerArabicName': prayer.arabicName,
        'startAtIso': prayer.windowStartDateTime.toIso8601String(),
        'endAtIso': prayer.windowEndDateTime.toIso8601String(),
        'remainingSeconds': remaining.inSeconds,
      });
    } catch (_) {
      // Ignore failures when ActivityKit is unavailable or not configured.
    }
  }

  Future<void> endPrayerCountdown() async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('endPrayerCountdown');
    } catch (_) {
      // Ignore failures when ActivityKit is unavailable or not configured.
    }
  }
}

final prayerLiveActivityServiceProvider = Provider<PrayerLiveActivityService>((
  ref,
) {
  return PrayerLiveActivityService();
});

final prayerLiveActivityBootstrapProvider = Provider<void>((ref) {
  final service = ref.read(prayerLiveActivityServiceProvider);

  ref.listen<PrayerScheduleContext>(prayerScheduleContextProvider, (
    _,
    context,
  ) {
    Future<void>.microtask(() async {
      if (!await service.isSupported()) return;
      if (context.nextPrayerId == null) {
        await service.endPrayerCountdown();
        return;
      }
      final nextPrayer = context.items
          .where((item) => item.id == context.nextPrayerId)
          .firstOrNull;
      if (nextPrayer == null) {
        await service.endPrayerCountdown();
        return;
      }
      await service.updatePrayerCountdown(
        prayer: nextPrayer,
        remaining: context.remainingToNext,
      );
    });
  }, fireImmediately: true);
});
