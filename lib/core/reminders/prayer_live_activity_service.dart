import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../prayer/prayer_preferences.dart';
import 'local_notification_service.dart';
import '../../features/worship/application/prayer_controller.dart';
import '../../features/worship/application/fasting_controller.dart';
import '../../features/worship/domain/daily_prayer_record.dart';
import '../../features/worship/domain/fasting_status.dart';
import '../../features/worship/domain/fasting_type.dart';
import '../../features/worship/domain/prayer_status.dart';
import '../../shared/application/special_mode_provider.dart';
import '../../shared/persistence/local_store.dart';

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
    required bool useStableDynamicIsland,
    required bool useStableLockScreenWidget,
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
        'useStableDynamicIsland': useStableDynamicIsland,
        'useStableLockScreenWidget': useStableLockScreenWidget,
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

  Future<void> updateFastingCard({
    required String title,
    required String arabicTitle,
    required String metricLabel,
    required Duration remaining,
    required DateTime targetTime,
    required String targetRoute,
    required bool showDua,
    required String duaTitle,
    required String duaArabic,
    required String duaTranslation,
  }) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('updateFastingCountdown', {
        'title': title,
        'arabicTitle': arabicTitle,
        'metricLabel': metricLabel,
        'remainingSeconds': remaining.inSeconds,
        'targetAtIso': targetTime.toIso8601String(),
        'targetRoute': targetRoute,
        'showDua': showDua,
        'duaTitle': duaTitle,
        'duaArabic': duaArabic,
        'duaTranslation': duaTranslation,
      });
    } catch (_) {
      // Ignore failures when ActivityKit is unavailable or not configured.
    }
  }

  Future<void> endFastingCountdown() async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('endFastingCountdown');
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
  final store = ref.read(localStoreProvider);
  final notifications = ref.read(localNotificationServiceProvider);
  Timer? boundaryRefreshTimer;

  Future<void> syncLiveActivity({
    required PrayerScheduleContext context,
    required List<DailyPrayerRecord> records,
  }) async {
    Future<void>.microtask(() async {
      if (!await service.isSupported()) return;
      if (context.nextPrayerId == null) {
        boundaryRefreshTimer?.cancel();
        boundaryRefreshTimer = null;
        await service.endPrayerCountdown();
        await service.endFastingCountdown();
        return;
      }
      final now = DateTime.now();
      final nextPrayer = _findPrayerById(context.items, context.nextPrayerId!);
      if (nextPrayer == null) {
        boundaryRefreshTimer?.cancel();
        boundaryRefreshTimer = null;
        await service.endPrayerCountdown();
        return;
      }
      final nextTargetTime = _resolveNextPrayerStart(nextPrayer, now);
      final nextStartsIn = _nonNegative(nextTargetTime.difference(now));
      _scheduleBoundaryRefresh(
        existingTimer: boundaryRefreshTimer,
        onScheduled: (timer) => boundaryRefreshTimer = timer,
        targetTime: nextTargetTime,
        onBoundary: () {
          final refreshedContext = derivePrayerScheduleContext(
            schedule: ref.read(prayerScheduleProvider),
            now: DateTime.now(),
          );
          final refreshedRecords = ref.read(prayerControllerProvider);
          syncLiveActivity(
            context: refreshedContext,
            records: refreshedRecords,
          );
        },
      );
      final specialMode = ref.read(specialModeProvider);
      final fasting = ref.read(fastingControllerProvider);
      final fastingPresentation = _buildFastingPresentation(
        context: context,
        fasting: fasting,
        specialMode: specialMode,
        now: now,
        store: store,
      );

      if (fastingPresentation != null) {
        await service.endPrayerCountdown();
        await service.updateFastingCard(
          title: fastingPresentation.title,
          arabicTitle: fastingPresentation.arabicTitle,
          metricLabel: fastingPresentation.metricLabel,
          remaining: fastingPresentation.remaining,
          targetTime: fastingPresentation.targetTime,
          targetRoute: fastingPresentation.targetRoute,
          showDua: fastingPresentation.showDua,
          duaTitle: fastingPresentation.duaTitle,
          duaArabic: fastingPresentation.duaArabic,
          duaTranslation: fastingPresentation.duaTranslation,
        );
        await _maybeNotifyFastingMoment(
          store: store,
          notifications: notifications,
          presentation: fastingPresentation,
          now: now,
        );
        return;
      }

      await service.endFastingCountdown();

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

      await service.updatePrayerCard(
        nextPrayer: nextPrayer,
        nextStartsIn: nextStartsIn,
        nextTargetTime: nextTargetTime,
        useStableDynamicIsland: ref
            .read(prayerSettingsProvider)
            .preferences
            .useStableDynamicIsland,
        useStableLockScreenWidget: ref
            .read(prayerSettingsProvider)
            .preferences
            .useStableLockScreenWidget,
        currentPrayer: currentPrayerToShow,
        currentRemaining: currentRemaining,
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

  ref.onDispose(() {
    boundaryRefreshTimer?.cancel();
  });
});

void _scheduleBoundaryRefresh({
  required Timer? existingTimer,
  required void Function(Timer? timer) onScheduled,
  required DateTime targetTime,
  required VoidCallback onBoundary,
}) {
  existingTimer?.cancel();
  final now = DateTime.now();
  final refreshAt = targetTime.add(const Duration(milliseconds: 250));
  final delay = refreshAt.isAfter(now)
      ? refreshAt.difference(now)
      : const Duration(milliseconds: 50);
  final timer = Timer(delay, () {
    onScheduled(null);
    onBoundary();
  });
  onScheduled(timer);
}

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

class _FastingLivePresentation {
  const _FastingLivePresentation({
    required this.title,
    required this.arabicTitle,
    required this.metricLabel,
    required this.remaining,
    required this.targetTime,
    required this.targetRoute,
    required this.showDua,
    required this.duaTitle,
    required this.duaArabic,
    required this.duaTranslation,
    required this.notificationKey,
    required this.notificationTitle,
    required this.notificationBody,
  });

  final String title;
  final String arabicTitle;
  final String metricLabel;
  final Duration remaining;
  final DateTime targetTime;
  final String targetRoute;
  final bool showDua;
  final String duaTitle;
  final String duaArabic;
  final String duaTranslation;
  final String notificationKey;
  final String notificationTitle;
  final String notificationBody;
}

_FastingLivePresentation? _buildFastingPresentation({
  required PrayerScheduleContext context,
  required FastingState fasting,
  required SpecialModeState specialMode,
  required DateTime now,
  required LocalStore store,
}) {
  final l10n = lookupAppLocalizations(
    resolveStoredAppLocale(store) ??
        WidgetsBinding.instance.platformDispatcher.locale,
  );
  final fajr = _findPrayerById(context.items, 'fajr');
  final maghrib = _findPrayerById(context.items, 'maghrib');
  if (fajr == null || maghrib == null) return null;

  final inRamadan =
      specialMode.isRamadan || specialMode.ramadanDateWindowActive;
  final nonRamadanExplicitFast =
      fasting.selectedType != FastingType.ramadan &&
      fasting.todayStatus != FastingStatus.notFasting &&
      fasting.todayStatus != FastingStatus.broken;
  final shouldTrackFast = inRamadan || nonRamadanExplicitFast;
  if (!shouldTrackFast) return null;

  final fajrStart = _resolveSameDayTarget(fajr.offerDateTime, now);
  final maghribStart = _resolveSameDayTarget(maghrib.offerDateTime, now);
  final beforeFajr = now.isBefore(fajrStart);
  final beforeMaghrib = now.isBefore(maghribStart);
  final preStartWindow = now.isAfter(
    fajrStart.subtract(const Duration(minutes: 25)),
  );
  final preIftarWindow = now.isAfter(
    maghribStart.subtract(const Duration(minutes: 20)),
  );
  final postIftarWindow = now.isBefore(
    maghribStart.add(const Duration(minutes: 20)),
  );

  if (beforeFajr && fasting.todayStatus == FastingStatus.intending) {
    return _FastingLivePresentation(
      title: l10n.notificationsFastingLiveFastBeginsTitle,
      arabicTitle: l10n.notificationsFastingLiveFastBeginsArabicTitle,
      metricLabel: l10n.notificationsFastingLiveStartsIn(''),
      remaining: _nonNegative(fajrStart.difference(now)),
      targetTime: fajrStart,
      targetRoute: '/learn/duas/stub_092_special_days_ramadan',
      showDua: preStartWindow,
      duaTitle: l10n.notificationsFastingLiveRenewIntentionTitle,
      duaArabic: l10n.notificationsFastingLiveRenewIntentionArabic,
      duaTranslation: l10n.notificationsFastingLiveRenewIntentionTranslation,
      notificationKey: 'fast_start_${LocalStore.todayKey(now)}',
      notificationTitle: l10n.notificationsFastingBeginsNowTitle,
      notificationBody: l10n.notificationsFastingBeginsNowBody,
    );
  }

  if (beforeMaghrib &&
      fasting.todayStatus != FastingStatus.notFasting &&
      fasting.todayStatus != FastingStatus.broken) {
    return _FastingLivePresentation(
      title: l10n.notificationsFastingLiveFastEndsTitle,
      arabicTitle: l10n.notificationsFastingLiveFastEndsArabicTitle,
      metricLabel: l10n.notificationsFastingLiveEndsIn(''),
      remaining: _nonNegative(maghribStart.difference(now)),
      targetTime: maghribStart,
      targetRoute: '/learn/duas/stub_091_special_days_ramadan',
      showDua: preIftarWindow,
      duaTitle: l10n.notificationsFastingLiveIftarDuaTitle,
      duaArabic: l10n.notificationsFastingLiveIftarDuaArabic,
      duaTranslation: l10n.notificationsFastingLiveIftarDuaTranslation,
      notificationKey: 'iftar_${LocalStore.todayKey(now)}',
      notificationTitle: l10n.notificationsIftarTimeTitle,
      notificationBody: l10n.notificationsIftarTimeBody,
    );
  }

  if (!beforeMaghrib && postIftarWindow) {
    return _FastingLivePresentation(
      title: l10n.notificationsFastingLiveIftarTitle,
      arabicTitle: l10n.notificationsFastingLiveIftarArabicTitle,
      metricLabel: l10n.notificationsFastingLiveJustEntered,
      remaining: Duration.zero,
      targetTime: maghribStart,
      targetRoute: '/learn/duas/stub_091_special_days_ramadan',
      showDua: true,
      duaTitle: l10n.notificationsFastingLiveIftarDuaTitle,
      duaArabic: l10n.notificationsFastingLiveIftarDuaArabic,
      duaTranslation: l10n.notificationsFastingLiveIftarDuaTranslation,
      notificationKey: 'iftar_${LocalStore.todayKey(now)}',
      notificationTitle: l10n.notificationsIftarTimeTitle,
      notificationBody: l10n.notificationsIftarTimeBody,
    );
  }

  return null;
}

Future<void> _maybeNotifyFastingMoment({
  required LocalStore store,
  required LocalNotificationService notifications,
  required _FastingLivePresentation presentation,
  required DateTime now,
}) async {
  final alreadySent =
      store.getBool('fasting.notification.${presentation.notificationKey}') ??
      false;
  if (alreadySent) return;
  final delta = now.difference(presentation.targetTime).abs();
  if (delta > const Duration(minutes: 1)) return;
  await notifications.showFastingMomentNotification(
    id: presentation.notificationKey,
    title: presentation.notificationTitle,
    body: presentation.notificationBody,
  );
  await store.setBool(
    'fasting.notification.${presentation.notificationKey}',
    true,
  );
}
