import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../prayer/prayer_preferences.dart';
import '../../features/worship/application/prayer_controller.dart';
import '../../features/worship/application/fasting_controller.dart';
import '../../features/worship/domain/daily_prayer_record.dart';
import '../../features/worship/domain/fasting_status.dart';
import '../../features/worship/domain/prayer_status.dart';
import '../../shared/application/special_mode_provider.dart';

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

  Future<void> updatePrayerCard({
    required PrayerScheduleItem nextPrayer,
    required Duration nextStartsIn,
    required DateTime nextTargetTime,
    PrayerScheduleItem? currentPrayer,
    Duration? currentRemaining,
    PrayerScheduleItem? ramadanPrayer,
    Duration? ramadanRemaining,
    DateTime? ramadanTargetTime,
  }) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('updatePrayerCountdown', {
        'showCurrentPrayer': currentPrayer != null,
        'currentPrayerId': currentPrayer?.id,
        'currentPrayerName': currentPrayer?.name,
        'currentPrayerArabicName': currentPrayer?.arabicName,
        'currentRemainingSeconds': currentRemaining?.inSeconds,
        'nextPrayerId': nextPrayer.id,
        'nextPrayerName': nextPrayer.name,
        'nextPrayerArabicName': nextPrayer.arabicName,
        'nextRemainingSeconds': nextStartsIn.inSeconds,
        'nextTargetAtIso': nextTargetTime.toIso8601String(),
        'showRamadanCountdown':
            ramadanPrayer != null &&
            ramadanRemaining != null &&
            ramadanTargetTime != null,
        'ramadanPrayerId': ramadanPrayer?.id,
        'ramadanPrayerName': ramadanPrayer?.name,
        'ramadanPrayerArabicName': ramadanPrayer?.arabicName,
        'ramadanRemainingSeconds': ramadanRemaining?.inSeconds,
        'ramadanTargetAtIso': ramadanTargetTime?.toIso8601String(),
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

  Future<void> syncLiveActivity({
    required PrayerScheduleContext context,
    required List<DailyPrayerRecord> records,
  }) async {
    Future<void>.microtask(() async {
      if (!await service.isSupported()) return;
      if (context.nextPrayerId == null) {
        await service.endPrayerCountdown();
        return;
      }
      final now = DateTime.now();
      final nextPrayer = _findPrayerById(context.items, context.nextPrayerId!);
      if (nextPrayer == null) {
        await service.endPrayerCountdown();
        return;
      }
      final nextTargetTime = _resolveNextPrayerStart(nextPrayer, now);
      final nextStartsIn = _nonNegative(nextTargetTime.difference(now));
      final specialMode = ref.read(specialModeProvider);
      final fasting = ref.read(fastingControllerProvider);

      PrayerScheduleItem? currentPrayerToShow;
      Duration? currentRemaining;
      final currentPrayerId = context.currentPrayerId;
      if (currentPrayerId != null) {
        final currentPrayer = _findPrayerById(context.items, currentPrayerId);
        if (currentPrayer != null && _isPrayerActive(currentPrayer, now)) {
          final explicitStatus = _statusForPrayer(records, currentPrayerId);
          final shouldShowCurrent = explicitStatus != PrayerStatus.completed;
          if (shouldShowCurrent) {
            currentPrayerToShow = currentPrayer;
            currentRemaining = nextStartsIn;
          }
        }
      }

      PrayerScheduleItem? ramadanPrayer;
      Duration? ramadanRemaining;
      DateTime? ramadanTargetTime;
      final shouldShowRamadanCountdown =
          (specialMode.isRamadan || specialMode.ramadanDateWindowActive) &&
          fasting.todayStatus != FastingStatus.notFasting;
      if (shouldShowRamadanCountdown) {
        final maghrib = _findPrayerById(context.items, 'maghrib');
        if (maghrib != null) {
          final target = _resolveSameDayTarget(maghrib.offerDateTime, now);
          final remaining = target.difference(now);
          if (!remaining.isNegative) {
            ramadanPrayer = maghrib;
            ramadanRemaining = remaining;
            ramadanTargetTime = target;
          }
        }
      }

      await service.updatePrayerCard(
        nextPrayer: nextPrayer,
        nextStartsIn: nextStartsIn,
        nextTargetTime: nextTargetTime,
        currentPrayer: currentPrayerToShow,
        currentRemaining: currentRemaining,
        ramadanPrayer: ramadanPrayer,
        ramadanRemaining: ramadanRemaining,
        ramadanTargetTime: ramadanTargetTime,
      );
    });
  }

  ref.listen<PrayerScheduleContext>(prayerScheduleContextProvider, (
    _,
    context,
  ) {
    final records = ref.read(prayerControllerProvider);
    syncLiveActivity(context: context, records: records);
  }, fireImmediately: true);

  ref.listen<List<DailyPrayerRecord>>(prayerControllerProvider, (_, records) {
    final context = ref.read(prayerScheduleContextProvider);
    syncLiveActivity(context: context, records: records);
  }, fireImmediately: true);
});

PrayerScheduleItem? _findPrayerById(List<PrayerScheduleItem> items, String id) {
  for (final item in items) {
    if (item.id == id) return item;
  }
  return null;
}

PrayerStatus? _statusForPrayer(
  List<DailyPrayerRecord> records,
  String prayerId,
) {
  for (final record in records) {
    if (record.prayer.name == prayerId) return record.status;
  }
  return null;
}

bool _isPrayerActive(PrayerScheduleItem item, DateTime now) {
  return !now.isBefore(item.windowStartDateTime) &&
      now.isBefore(item.windowEndDateTime);
}

DateTime _resolveNextPrayerStart(PrayerScheduleItem nextPrayer, DateTime now) {
  var target = nextPrayer.windowStartDateTime;
  if (target.isBefore(now)) {
    target = target.add(const Duration(days: 1));
  }
  return target;
}

DateTime _resolveSameDayTarget(DateTime target, DateTime now) {
  var resolved = target;
  if (resolved.year != now.year ||
      resolved.month != now.month ||
      resolved.day != now.day) {
    resolved = DateTime(
      now.year,
      now.month,
      now.day,
      target.hour,
      target.minute,
      target.second,
      target.millisecond,
      target.microsecond,
    );
  }
  return resolved;
}

Duration _nonNegative(Duration value) {
  return value.isNegative ? Duration.zero : value;
}
