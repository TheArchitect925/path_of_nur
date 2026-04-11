import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../navigation/platform_route_dispatcher.dart';
import '../../core/localization/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import '../../features/watch_companion/application/watch_sync_contract.dart';
import '../../features/worship/application/prayer_controller.dart';
import 'adhan_audio_service.dart';
import 'adhan_options.dart';
import '../prayer/prayer_preferences.dart';
import '../../shared/persistence/local_store.dart';
import 'reminder_scheduler.dart';

class GrowthNotificationRequest {
  const GrowthNotificationRequest({
    required this.id,
    required this.habitId,
    required this.when,
    required this.title,
    required this.body,
    required this.quietDelivery,
  });

  final String id;
  final String habitId;
  final DateTime when;
  final String title;
  final String body;
  final bool quietDelivery;
}

class ReminderNotificationPayload {
  const ReminderNotificationPayload._({
    required this.route,
    this.prayerId,
    this.logicalDate,
    this.reminderKind,
    this.snoozeCount = 0,
    this.watchRoute,
  });

  final String route;
  final String? prayerId;
  final String? logicalDate;
  final String? reminderKind;
  final int snoozeCount;
  final String? watchRoute;

  bool get isPrayerReminder =>
      prayerId != null && prayerId!.isNotEmpty && logicalDate != null;

  String encode() => jsonEncode(<String, Object?>{
    'route': route,
    'prayerId': prayerId,
    'logicalDate': logicalDate,
    'reminderKind': reminderKind,
    'snoozeCount': snoozeCount,
    'watchRoute': watchRoute,
  });

  static ReminderNotificationPayload routeOnly(String route) {
    return ReminderNotificationPayload._(route: route);
  }

  static ReminderNotificationPayload routeReminder({
    required String route,
    String? logicalDate,
    String? reminderKind,
    int snoozeCount = 0,
  }) {
    return ReminderNotificationPayload._(
      route: route,
      logicalDate: logicalDate,
      reminderKind: reminderKind,
      snoozeCount: snoozeCount,
    );
  }

  static ReminderNotificationPayload prayer({
    required String route,
    required String prayerId,
    required String logicalDate,
    required String reminderKind,
    int snoozeCount = 0,
    String? watchRoute,
  }) {
    return ReminderNotificationPayload._(
      route: route,
      prayerId: prayerId,
      logicalDate: logicalDate,
      reminderKind: reminderKind,
      snoozeCount: snoozeCount,
      watchRoute: watchRoute,
    );
  }

  static ReminderNotificationPayload? decode(String? raw) {
    final payload = raw?.trim();
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        final route = decoded['route']?.toString().trim();
        if (route == null || route.isEmpty) return null;
        return ReminderNotificationPayload._(
          route: route,
          prayerId: decoded['prayerId']?.toString(),
          logicalDate: decoded['logicalDate']?.toString(),
          reminderKind: decoded['reminderKind']?.toString(),
          snoozeCount: (decoded['snoozeCount'] as num?)?.toInt() ?? 0,
          watchRoute: decoded['watchRoute']?.toString(),
        );
      }
    } catch (_) {
      return ReminderNotificationPayload._(route: payload);
    }
    return null;
  }
}

class LocalNotificationService {
  LocalNotificationService(this._ref, this._store, this._adhanRepository) {
    _plugin = FlutterLocalNotificationsPlugin();
  }

  static const String prayerReminderCategoryId = 'PRAYER_REMINDER';
  static const String prayerReminderFinalCategoryId = 'PRAYER_REMINDER_FINAL';
  static const String reflectionReminderCategoryId = 'REFLECTION_REMINDER';
  static const String markPrayedActionId = 'MARK_PRAYED';
  static const String markPrayedLateActionId = 'MARK_PRAYED_LATE';
  static const String snooze5ActionId = 'SNOOZE_5';
  static const String snooze10ActionId = 'SNOOZE_10';
  static const String writeReflectionActionId = 'WRITE_REFLECTION';
  static const String remindReflection10ActionId = 'REFLECTION_REMIND_10';
  static const String dismissActionId = 'DISMISS';
  static const int _maxPrayerReminderSnoozes = 2;
  static const Color _notificationAccent = Color(0xFFD8C49A);
  static const String _launcherIcon = '@mipmap/ic_launcher';
  final Ref _ref;
  final LocalStore _store;
  final AdhanRepository _adhanRepository;
  late final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  static const _fingerprintKey = 'reminders.lastFingerprint';
  static const _growthFingerprintKey = 'growth.reminders.lastFingerprint';
  static const _scheduledPrayerIdsKey = 'reminders.scheduled.prayer.ids';
  static const _scheduledGrowthIdsKey = 'reminders.scheduled.growth.ids';
  static const _timezoneKey = 'reminders.timezone';

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    await _initializeLocalTimezone();

    final initSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        notificationCategories: _darwinNotificationCategories(_l10n),
      ),
      macOS: DarwinInitializationSettings(
        notificationCategories: _darwinNotificationCategories(_l10n),
      ),
      android: AndroidInitializationSettings(_launcherIcon),
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> syncWithPlan(
    ReminderSchedulerState plan, {
    required AdhanSettings adhanSettings,
  }) async {
    await ensureInitialized();

    final fingerprint = _fingerprintFor(plan, adhanSettings);
    final previousFingerprint = _store.getString(_fingerprintKey);
    final didChangePlan = fingerprint != previousFingerprint;

    if (didChangePlan) {
      await _cancelStoredNotifications(_scheduledPrayerIdsKey);
    }

    final now = DateTime.now();
    final scheduledIds = <String>{};
    for (final item in plan.items) {
      if (!item.when.isAfter(now)) continue;
      final notificationId = _notificationId(item.id);
      scheduledIds.add(item.id);
      await _plugin.zonedSchedule(
        notificationId,
        _titleFor(item),
        _bodyFor(item),
        tz.TZDateTime.from(item.when, tz.local),
        _notificationDetails(item, adhanSettings),
        payload: _payloadForReminder(item, plan.dayKey),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    if (didChangePlan) {
      await _store.setString(_fingerprintKey, fingerprint);
    }
    await _store.setJsonList(
      _scheduledPrayerIdsKey,
      scheduledIds.toList()..sort(),
    );

    await _recoverMissedReminders(plan, now, adhanSettings);
  }

  Future<void> syncGrowthReminders({
    required List<GrowthNotificationRequest> reminders,
    required bool pauseAll,
  }) async {
    await ensureInitialized();

    if (pauseAll) {
      await _cancelStoredNotifications(_scheduledGrowthIdsKey);
      await _store.remove(_growthFingerprintKey);
      return;
    }

    final fingerprint = _growthFingerprintFor(reminders);
    final previous = _store.getString(_growthFingerprintKey);
    final changed = fingerprint != previous;

    if (changed) {
      await _cancelStoredNotifications(_scheduledGrowthIdsKey);
    }

    final now = DateTime.now();
    final scheduledIds = <String>{};
    for (final item in reminders) {
      if (!item.when.isAfter(now)) continue;
      final idSeed = 'growth.${item.id}';
      final notificationId = _notificationId(idSeed);
      scheduledIds.add(idSeed);
      await _plugin.zonedSchedule(
        notificationId,
        item.title,
        item.body,
        tz.TZDateTime.from(item.when, tz.local),
        _growthNotificationDetails(item.quietDelivery),
        payload: '/journey/today',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    await _store.setJsonList(
      _scheduledGrowthIdsKey,
      scheduledIds.toList()..sort(),
    );
    await _store.setString(_growthFingerprintKey, fingerprint);
  }

  Future<void> cancelGrowthRemindersForHabit(String habitId) async {
    await ensureInitialized();
    final ids = _storedNotificationIds(_scheduledGrowthIdsKey);
    if (ids.isEmpty) return;
    final retained = <String>[];
    for (final id in ids) {
      if (id.contains('.$habitId.')) {
        await _plugin.cancel(_resolveStoredNotificationId(id));
      } else {
        retained.add(id);
      }
    }
    await _store.setJsonList(_scheduledGrowthIdsKey, retained..sort());
  }

  Future<void> showFastingMomentNotification({
    required String id,
    required String title,
    required String body,
  }) async {
    await ensureInitialized();
    final l10n = _l10n;
    await _plugin.show(
      _notificationId('fasting.moment.$id'),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'fasting_moments',
          l10n.notificationsFastingMomentsChannelName,
          channelDescription:
              l10n.notificationsFastingMomentsChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: _launcherIcon,
          color: _notificationAccent,
          colorized: true,
          styleInformation: BigTextStyleInformation(''),
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
          subtitle: l10n.appTitle,
          threadIdentifier: 'fasting_moments',
        ),
      ),
      payload: '/worship',
    );
  }

  NotificationDetails _notificationDetails(
    ReminderPlanItem item,
    AdhanSettings adhanSettings,
  ) {
    final l10n = _l10n;
    final profileSettings = _ref.read(profileSettingsProvider);
    final useAdhanSound =
        item.kind == ReminderKind.prayerAtTime &&
        item.notificationMode == PrayerNotificationMode.adhanWithSound &&
        adhanSettings.enabled;
    final resolvedAdhan = _adhanRepository
        .resolveForPrayer(prayerId: item.prayerId, settings: adhanSettings)
        .option;

    final prayerAtTimeSilentChannel = AndroidNotificationDetails(
      'prayer_reminders_notification_only',
      l10n.notificationsPrayerNotificationOnlyChannelName,
      channelDescription:
          l10n.notificationsPrayerNotificationOnlyChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      styleInformation: const BigTextStyleInformation(''),
      playSound: true,
      actions: _androidPrayerActions(l10n, allowSnooze: _canSnoozeItem(item)),
    );

    final prayerAtTimeAdhanChannel = AndroidNotificationDetails(
      'prayer_reminders_adhan_${resolvedAdhan.id}',
      l10n.notificationsPrayerAdhanChannelName(
        resolvedAdhan.localizedTitle(l10n),
      ),
      channelDescription: l10n.notificationsPrayerAdhanChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      styleInformation: const BigTextStyleInformation(''),
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        resolvedAdhan.androidRawResourceName,
      ),
      actions: _androidPrayerActions(l10n, allowSnooze: _canSnoozeItem(item)),
    );

    final prayerBeforeQazaChannel = AndroidNotificationDetails(
      'prayer_reminders_before_qaza',
      l10n.notificationsPrayerBeforeQazaChannelName,
      channelDescription: l10n.notificationsPrayerBeforeQazaChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      styleInformation: const BigTextStyleInformation(''),
      playSound: true,
      actions: _androidPrayerActions(l10n, allowSnooze: _canSnoozeItem(item)),
    );

    final genericChannel = AndroidNotificationDetails(
      'daily_reminders',
      l10n.notificationsDailyRemindersChannelName,
      channelDescription: l10n.notificationsDailyRemindersChannelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      styleInformation: const BigTextStyleInformation(''),
    );

    final reflectionChannel = AndroidNotificationDetails(
      'reflection_reminders',
      l10n.notificationsDailyRemindersChannelName,
      channelDescription: l10n.notificationsDailyRemindersChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      styleInformation: const BigTextStyleInformation(''),
      actions: _androidReflectionActions(l10n),
    );

    final useDefaultPrayerSound =
        item.kind == ReminderKind.prayerAtTime ||
        item.kind == ReminderKind.prayerFollowUp ||
        item.kind == ReminderKind.prayerBeforeQaza;

    final ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: useDefaultPrayerSound && !profileSettings.gentleModeEnabled,
      sound: useAdhanSound ? resolvedAdhan.iosSoundFileName : null,
      presentBanner: true,
      presentList: true,
      categoryIdentifier: _categoryIdentifierFor(item),
      interruptionLevel:
          item.kind == ReminderKind.prayerAtTime ||
              item.kind == ReminderKind.prayerFollowUp ||
              item.kind == ReminderKind.prayerBeforeQaza
          ? (profileSettings.gentleModeEnabled
                ? InterruptionLevel.active
                : InterruptionLevel.timeSensitive)
          : InterruptionLevel.active,
      threadIdentifier: item.prayerId ?? item.kind.name,
      subtitle: l10n.appTitle,
    );

    return NotificationDetails(
      android: switch (item.kind) {
        ReminderKind.prayerAtTime =>
          useAdhanSound ? prayerAtTimeAdhanChannel : prayerAtTimeSilentChannel,
        ReminderKind.prayerFollowUp => prayerAtTimeSilentChannel,
        ReminderKind.prayerBeforeQaza => prayerBeforeQazaChannel,
        ReminderKind.reflection => reflectionChannel,
        _ => genericChannel,
      },
      iOS: ios,
    );
  }

  String _titleFor(ReminderPlanItem item) {
    final l10n = _l10n;
    switch (item.kind) {
      case ReminderKind.prayerAtTime:
        return l10n.notificationsPrayerAtTimeTitle(
          _prayerName(l10n, item.prayerId),
        );
      case ReminderKind.prayerFollowUp:
        return l10n.notificationsPrayerAtTimeTitle(
          _prayerName(l10n, item.prayerId),
        );
      case ReminderKind.prayerBeforeQaza:
        return l10n.notificationsPrayerBeforeQazaTitle(
          _prayerName(l10n, item.prayerId),
          _prayerName(l10n, item.prayerId),
        );
      case ReminderKind.dhikr:
        return l10n.notificationsDhikrTitle;
      case ReminderKind.quran:
        return l10n.notificationsQuranTitle;
      case ReminderKind.reflection:
        return l10n.notificationsReflectionTitle;
      case ReminderKind.fasting:
        return l10n.notificationsFastingTitle;
      case ReminderKind.onThisDay:
        return l10n.notificationsOnThisDayTitle;
      case ReminderKind.cycleCheck:
        return l10n.notificationsCycleCheckTitle;
      case ReminderKind.moonrise:
        return l10n.notificationsMoonriseTitle;
      case ReminderKind.moonset:
        return l10n.notificationsMoonsetTitle;
    }
  }

  String _bodyFor(ReminderPlanItem item) {
    final l10n = _l10n;
    switch (item.kind) {
      case ReminderKind.prayerAtTime:
        return _prayerBodyFor(l10n, item.prayerId);
      case ReminderKind.prayerFollowUp:
        return _prayerBodyFor(l10n, item.prayerId);
      case ReminderKind.prayerBeforeQaza:
        return l10n.notificationsPrayerBeforeQazaBody(
          _prayerName(l10n, item.prayerId),
          _prayerName(l10n, item.prayerId),
        );
      case ReminderKind.dhikr:
        return l10n.notificationsDhikrBody;
      case ReminderKind.quran:
        return l10n.notificationsQuranBody;
      case ReminderKind.reflection:
        return l10n.notificationsReflectionBody;
      case ReminderKind.fasting:
        return l10n.notificationsFastingBody;
      case ReminderKind.onThisDay:
        return l10n.notificationsOnThisDayBody;
      case ReminderKind.cycleCheck:
        return l10n.notificationsCycleCheckBody;
      case ReminderKind.moonrise:
        return l10n.notificationsMoonriseBody;
      case ReminderKind.moonset:
        return l10n.notificationsMoonsetBody;
    }
  }

  String _prayerBodyFor(AppLocalizations l10n, String? prayerId) {
    final prayerName = _prayerName(l10n, prayerId);
    if (prayerId == 'fajr') {
      return l10n.notificationsPrayerAtTimeFajrBody(prayerName);
    }
    return l10n.notificationsPrayerAtTimeBody(prayerName);
  }

  String _prayerName(AppLocalizations l10n, String? id) {
    switch (id) {
      case 'fajr':
        return l10n.settingsPrayerNameFajr;
      case 'dhuhr':
        return l10n.settingsPrayerNameDhuhr;
      case 'asr':
        return l10n.settingsPrayerNameAsr;
      case 'maghrib':
        return l10n.settingsPrayerNameMaghrib;
      case 'isha':
        return l10n.settingsPrayerNameIsha;
      case 'tahajjud':
        return l10n.notificationsPrayerNameTahajjud;
      default:
        return l10n.notificationsGenericPrayerName;
    }
  }

  int _notificationId(String seed) {
    var hash = 17;
    for (final code in seed.codeUnits) {
      hash = 37 * hash + code;
    }
    return hash & 0x7fffffff;
  }

  String _growthFingerprintFor(List<GrowthNotificationRequest> reminders) {
    final parts = <String>[];
    for (final item in reminders) {
      parts.add(
        '${item.id}|${item.when.toIso8601String()}|${item.quietDelivery}|${item.title}|${item.body}',
      );
    }
    parts.sort();
    return parts.join('||');
  }

  NotificationDetails _growthNotificationDetails(bool quietDelivery) {
    final l10n = _l10n;
    final android = AndroidNotificationDetails(
      quietDelivery
          ? 'growth_gentle_reminders_quiet'
          : 'growth_gentle_reminders',
      quietDelivery
          ? l10n.notificationsGrowthRemindersQuietChannelName
          : l10n.notificationsGrowthRemindersChannelName,
      channelDescription: l10n.notificationsGrowthRemindersChannelDescription,
      importance: quietDelivery
          ? Importance.defaultImportance
          : Importance.high,
      priority: quietDelivery ? Priority.defaultPriority : Priority.high,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      playSound: !quietDelivery,
      styleInformation: const BigTextStyleInformation(''),
    );
    final ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: !quietDelivery,
      presentBanner: true,
      presentList: true,
      interruptionLevel: quietDelivery
          ? InterruptionLevel.passive
          : InterruptionLevel.active,
      threadIdentifier: 'growth',
      subtitle: l10n.appTitle,
    );
    return NotificationDetails(android: android, iOS: ios);
  }

  String _fingerprintFor(
    ReminderSchedulerState plan,
    AdhanSettings adhanSettings,
  ) {
    final parts = <String>[plan.dayKey];
    for (final item in plan.items) {
      final adhanSelection = item.kind == ReminderKind.prayerAtTime
          ? _adhanRepository
                .resolveForPrayer(
                  prayerId: item.prayerId,
                  settings: adhanSettings,
                )
                .option
                .id
          : '-';
      parts.add(
        '${item.id}|${item.when.toIso8601String()}|${item.kind.name}|${item.notificationMode?.name ?? '-'}|$adhanSelection|${adhanSettings.enabled}',
      );
    }
    return parts.join('||');
  }

  Future<void> _initializeLocalTimezone() async {
    String timezoneName = _store.getString(_timezoneKey) ?? '';
    try {
      timezoneName = await FlutterTimezone.getLocalTimezone();
      await _store.setString(_timezoneKey, timezoneName);
    } catch (_) {
      if (kDebugMode) {
        debugPrint('reminders: unable to fetch local timezone, falling back');
      }
    }

    if (timezoneName.isEmpty) return;
    try {
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {
      if (kDebugMode) {
        debugPrint(
          'reminders: timezone `$timezoneName` unavailable in tz db, using default',
        );
      }
    }
  }

  Future<void> _recoverMissedReminders(
    ReminderSchedulerState plan,
    DateTime now,
    AdhanSettings adhanSettings,
  ) async {
    final recoveredKey = 'reminders.recovered.${plan.dayKey}';
    final recovered = <String>{
      ...?_store.getJsonList(recoveredKey)?.map((item) => item.toString()),
    };

    const graceWindow = Duration(minutes: 90);
    var changed = false;

    for (final item in plan.items) {
      if (item.when.isAfter(now)) continue;
      if (now.difference(item.when) > graceWindow) continue;
      if (!recovered.add(item.id)) continue;

      await _plugin.show(
        _notificationId('recovered.${item.id}'),
        _titleFor(item),
        _l10n.notificationsRecoveredReminderBody(_bodyFor(item)),
        _notificationDetails(item, adhanSettings),
        payload: _payloadForReminder(item, plan.dayKey),
      );
      changed = true;
    }

    if (changed) {
      await _store.setJsonList(recoveredKey, recovered.toList()..sort());
    }
  }

  Set<String> _storedNotificationIds(String key) {
    return {...?_store.getJsonList(key)?.map((item) => item.toString())};
  }

  Future<void> _cancelStoredNotifications(String key) async {
    final ids = _storedNotificationIds(key);
    for (final id in ids) {
      await _plugin.cancel(_resolveStoredNotificationId(id));
    }
    await _store.remove(key);
  }

  int _resolveStoredNotificationId(String token) {
    final parsed = int.tryParse(token);
    if (parsed != null) return parsed;
    return _notificationId(token);
  }

  Future<void> _handleNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = ReminderNotificationPayload.decode(response.payload);
    if (payload == null) return;

    final actionId = response.actionId?.trim();
    switch (actionId) {
      case markPrayedActionId:
        await _applyPrayerReminderAction(
          payload,
          status: 'completed',
          timing: 'on_time',
        );
        return;
      case markPrayedLateActionId:
        await _applyPrayerReminderAction(
          payload,
          status: 'completed',
          timing: 'late',
        );
        return;
      case snooze5ActionId:
        await _snoozePrayerReminder(payload, minutes: 5);
        return;
      case snooze10ActionId:
        await _snoozePrayerReminder(payload, minutes: 10);
        return;
      case dismissActionId:
        await _dismissReminder(payload);
        return;
      case writeReflectionActionId:
        await _openReflectionReminder(payload);
        return;
      case remindReflection10ActionId:
        await _snoozeReflectionReminder(payload, minutes: 10);
        return;
      default:
        PlatformRouteDispatcher.dispatch(payload.route);
    }
  }

  String _payloadForReminder(ReminderPlanItem item, String logicalDate) {
    return switch (item.kind) {
      ReminderKind.prayerAtTime ||
      ReminderKind.prayerBeforeQaza ||
      ReminderKind.prayerFollowUp => ReminderNotificationPayload.prayer(
        route: '/worship?prayerId=${item.prayerId}',
        prayerId: item.prayerId!,
        logicalDate: logicalDate,
        reminderKind: item.kind.name,
        snoozeCount: _snoozeCountForItem(item),
        watchRoute: 'pathofnurwatch://prayer?prayerId=${item.prayerId}',
      ).encode(),
      ReminderKind.dhikr => ReminderNotificationPayload.routeOnly(
        '/worship',
      ).encode(),
      ReminderKind.quran => ReminderNotificationPayload.routeOnly(
        '/quran',
      ).encode(),
      ReminderKind.reflection => ReminderNotificationPayload.routeReminder(
        route: '/journey/reflection',
        logicalDate: logicalDate,
        reminderKind: item.kind.name,
      ).encode(),
      ReminderKind.fasting => ReminderNotificationPayload.routeOnly(
        '/worship',
      ).encode(),
      ReminderKind.onThisDay => ReminderNotificationPayload.routeOnly(
        '/learn/history/today',
      ).encode(),
      ReminderKind.cycleCheck => ReminderNotificationPayload.routeOnly(
        '/settings',
      ).encode(),
      ReminderKind.moonrise || ReminderKind.moonset =>
        ReminderNotificationPayload.routeOnly('/home').encode(),
    };
  }

  String? _categoryIdentifierFor(ReminderPlanItem item) {
    return switch (item.kind) {
      ReminderKind.prayerAtTime =>
        _canSnoozeItem(item)
            ? prayerReminderCategoryId
            : prayerReminderFinalCategoryId,
      ReminderKind.prayerBeforeQaza =>
        _canSnoozeItem(item)
            ? prayerReminderCategoryId
            : prayerReminderFinalCategoryId,
      ReminderKind.prayerFollowUp =>
        _canSnoozeItem(item)
            ? prayerReminderCategoryId
            : prayerReminderFinalCategoryId,
      ReminderKind.reflection => reflectionReminderCategoryId,
      _ => null,
    };
  }

  List<DarwinNotificationCategory> _darwinNotificationCategories(
    AppLocalizations l10n,
  ) {
    return <DarwinNotificationCategory>[
      _buildDarwinPrayerCategory(
        prayerReminderCategoryId,
        l10n,
        allowSnooze: true,
      ),
      _buildDarwinPrayerCategory(
        prayerReminderFinalCategoryId,
        l10n,
        allowSnooze: false,
      ),
      _buildDarwinReflectionCategory(l10n),
    ];
  }

  DarwinNotificationCategory _buildDarwinPrayerCategory(
    String identifier,
    AppLocalizations l10n, {
    required bool allowSnooze,
  }) {
    return DarwinNotificationCategory(
      identifier,
      actions: <DarwinNotificationAction>[
        if (allowSnooze)
          DarwinNotificationAction.plain(
            snooze5ActionId,
            l10n.notificationsPrayerActionSnooze5,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        if (allowSnooze)
          DarwinNotificationAction.plain(
            snooze10ActionId,
            l10n.notificationsPrayerActionSnooze10,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        DarwinNotificationAction.plain(
          markPrayedActionId,
          l10n.notificationsPrayerActionMarkOffered,
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          dismissActionId,
          l10n.notificationsPrayerActionDismiss,
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
      ],
      options: const <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    );
  }

  DarwinNotificationCategory _buildDarwinReflectionCategory(
    AppLocalizations l10n,
  ) {
    return DarwinNotificationCategory(
      reflectionReminderCategoryId,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain(
          writeReflectionActionId,
          l10n.notificationsReflectionActionWrite,
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          remindReflection10ActionId,
          l10n.notificationsReflectionActionRemind10,
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          dismissActionId,
          l10n.notificationsReflectionActionDismiss,
        ),
      ],
      options: const <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    );
  }

  List<AndroidNotificationAction> _androidPrayerActions(
    AppLocalizations l10n, {
    required bool allowSnooze,
  }) {
    return <AndroidNotificationAction>[
      if (allowSnooze)
        AndroidNotificationAction(
          snooze5ActionId,
          l10n.notificationsPrayerActionSnooze5,
          showsUserInterface: true,
        ),
      if (allowSnooze)
        AndroidNotificationAction(
          snooze10ActionId,
          l10n.notificationsPrayerActionSnooze10,
          showsUserInterface: true,
        ),
      AndroidNotificationAction(
        markPrayedActionId,
        l10n.notificationsPrayerActionMarkOffered,
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        dismissActionId,
        l10n.notificationsPrayerActionDismiss,
        showsUserInterface: true,
      ),
    ];
  }

  List<AndroidNotificationAction> _androidReflectionActions(
    AppLocalizations l10n,
  ) {
    return <AndroidNotificationAction>[
      AndroidNotificationAction(
        writeReflectionActionId,
        l10n.notificationsReflectionActionWrite,
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        remindReflection10ActionId,
        l10n.notificationsReflectionActionRemind10,
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        dismissActionId,
        l10n.notificationsReflectionActionDismiss,
      ),
    ];
  }

  bool _canSnoozeItem(ReminderPlanItem item) {
    if (item.kind != ReminderKind.prayerAtTime &&
        item.kind != ReminderKind.prayerBeforeQaza &&
        item.kind != ReminderKind.prayerFollowUp) {
      return false;
    }
    return _snoozeCountForItem(item) < _maxPrayerReminderSnoozes;
  }

  int _snoozeCountForItem(ReminderPlanItem item) {
    final match = RegExp(r'\.snooze\.[^.]+\.[^.]+\.(\d+)$').firstMatch(item.id);
    if (match == null) return 0;
    return int.tryParse(match.group(1) ?? '') ?? 0;
  }

  Future<void> _applyPrayerReminderAction(
    ReminderNotificationPayload payload, {
    required String status,
    required String timing,
  }) async {
    if (!payload.isPrayerReminder) {
      PlatformRouteDispatcher.dispatch(payload.route);
      return;
    }

    final prayerId = payload.prayerId!;
    final logicalDate = payload.logicalDate!;
    final action = WatchActionEnvelope(
      actionId:
          'notification.$status.$prayerId.$logicalDate.${DateTime.now().microsecondsSinceEpoch}',
      deviceType: WatchDeviceType.appleWatch,
      actionType: WatchActionType.prayerStatusUpdated,
      createdAt: DateTime.now(),
      logicalDate: logicalDate,
      payload: <String, dynamic>{
        'prayerId': prayerId,
        'status': status,
        'timing': timing,
        'source': 'prayer_notification',
      },
      sourceVersion: '1',
    );
    await _ref.read(watchActionIngestionServiceProvider).ingest(action);
    _ref
        .read(prayerControllerProvider.notifier)
        .onDayChanged(logicalDate, force: true);
    await _cancelPrayerReminderSnoozes(
      prayerId,
      logicalDate,
      _reminderKindFromPayload(payload),
    );
    await _cancelPrayerReminderFollowUp(prayerId);
  }

  Future<void> _snoozePrayerReminder(
    ReminderNotificationPayload payload, {
    required int minutes,
  }) async {
    if (!payload.isPrayerReminder) {
      PlatformRouteDispatcher.dispatch(payload.route);
      return;
    }

    final prayerId = payload.prayerId!;
    final logicalDate = payload.logicalDate!;
    final reminderKind = _reminderKindFromPayload(payload);
    final nextSnoozeCount = payload.snoozeCount + 1;
    if (nextSnoozeCount > _maxPrayerReminderSnoozes) {
      return;
    }
    final scheduledAt = DateTime.now().add(Duration(minutes: minutes));
    final reminder = ReminderPlanItem(
      id: _snoozeToken(prayerId, logicalDate, reminderKind, nextSnoozeCount),
      kind: reminderKind,
      prayerId: prayerId,
      when: scheduledAt,
      notificationMode: PrayerNotificationMode.notificationOnly,
    );
    await _cancelPrayerReminderSnoozes(prayerId, logicalDate, reminderKind);
    await _plugin.zonedSchedule(
      _notificationId(reminder.id),
      _titleFor(reminder),
      _bodyFor(reminder),
      tz.TZDateTime.from(scheduledAt, tz.local),
      _notificationDetails(
        reminder,
        _ref.read(prayerSettingsProvider).adhanSettings,
      ),
      payload: ReminderNotificationPayload.prayer(
        route: payload.route,
        prayerId: prayerId,
        logicalDate: logicalDate,
        reminderKind: reminderKind.name,
        snoozeCount: nextSnoozeCount,
        watchRoute: payload.watchRoute,
      ).encode(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    await _ref
        .read(watchActionIngestionServiceProvider)
        .ingest(
          WatchActionEnvelope(
            actionId:
                'notification.snooze.$prayerId.$logicalDate.${DateTime.now().microsecondsSinceEpoch}',
            deviceType: WatchDeviceType.appleWatch,
            actionType: WatchActionType.snoozeRequested,
            createdAt: DateTime.now(),
            logicalDate: logicalDate,
            payload: <String, dynamic>{
              'prayerId': prayerId,
              'minutes': minutes,
              'reminderKind': reminderKind.name,
              'snoozeCount': nextSnoozeCount,
            },
            sourceVersion: '1',
          ),
        );
  }

  Future<void> _dismissReminder(ReminderNotificationPayload payload) async {
    if (_reminderKindFromPayload(payload) == ReminderKind.reflection) {
      await _cancelReflectionReminderSnoozes(payload);
      return;
    }
    await _dismissPrayerReminder(payload);
  }

  Future<void> _dismissPrayerReminder(
    ReminderNotificationPayload payload,
  ) async {
    if (!payload.isPrayerReminder) return;
    await _cancelPrayerReminderSnoozes(
      payload.prayerId!,
      payload.logicalDate!,
      _reminderKindFromPayload(payload),
    );
  }

  Future<void> _openReflectionReminder(
    ReminderNotificationPayload payload,
  ) async {
    await _cancelReflectionReminderSnoozes(payload);
    PlatformRouteDispatcher.dispatch(payload.route);
  }

  Future<void> _snoozeReflectionReminder(
    ReminderNotificationPayload payload, {
    required int minutes,
  }) async {
    final reminderKind = _reminderKindFromPayload(payload);
    if (reminderKind != ReminderKind.reflection) {
      PlatformRouteDispatcher.dispatch(payload.route);
      return;
    }

    final logicalDate =
        payload.logicalDate ?? LocalStore.todayKey(DateTime.now());
    final snoozeId = _reflectionSnoozeToken(logicalDate, minutes);
    final scheduledAt = DateTime.now().add(Duration(minutes: minutes));
    final reminder = ReminderPlanItem(
      id: snoozeId,
      kind: ReminderKind.reflection,
      prayerId: null,
      when: scheduledAt,
      notificationMode: null,
    );

    await _cancelReflectionReminderSnoozes(payload);
    await _plugin.zonedSchedule(
      _notificationId(snoozeId),
      _titleFor(reminder),
      _bodyFor(reminder),
      tz.TZDateTime.from(scheduledAt, tz.local),
      _notificationDetails(
        reminder,
        _ref.read(prayerSettingsProvider).adhanSettings,
      ),
      payload: ReminderNotificationPayload.routeReminder(
        route: payload.route,
        logicalDate: logicalDate,
        reminderKind: ReminderKind.reflection.name,
        snoozeCount: payload.snoozeCount + 1,
      ).encode(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _cancelReflectionReminderSnoozes(
    ReminderNotificationPayload payload,
  ) async {
    final reminderKind = _reminderKindFromPayload(payload);
    if (reminderKind != ReminderKind.reflection) return;
    final logicalDate =
        payload.logicalDate ?? LocalStore.todayKey(DateTime.now());
    await _plugin.cancel(
      _notificationId(_reflectionSnoozeToken(logicalDate, 10)),
    );
  }

  Future<void> _cancelPrayerReminderSnoozes(
    String prayerId,
    String logicalDate,
    ReminderKind reminderKind,
  ) async {
    for (var count = 1; count <= _maxPrayerReminderSnoozes; count++) {
      await _plugin.cancel(
        _notificationId(
          _snoozeToken(prayerId, logicalDate, reminderKind, count),
        ),
      );
    }
  }

  Future<void> _cancelPrayerReminderFollowUp(String prayerId) async {
    await _plugin.cancel(_notificationId(_followUpToken(prayerId)));
  }

  String _snoozeToken(
    String prayerId,
    String logicalDate,
    ReminderKind reminderKind,
    int snoozeCount,
  ) {
    return 'prayer.$prayerId.snooze.$logicalDate.${reminderKind.name}.$snoozeCount';
  }

  String _followUpToken(String prayerId) {
    return 'prayer.$prayerId.followUp';
  }

  String _reflectionSnoozeToken(String logicalDate, int minutes) {
    // Reflection reminders intentionally stay on the shared route/action path
    // for now. If we later add richer journal-entry context, revisit the
    // token/payload shape in one focused pass.
    return 'reflection.snooze.$logicalDate.$minutes';
  }

  ReminderKind _reminderKindFromPayload(ReminderNotificationPayload payload) {
    final rawKind = payload.reminderKind;
    if (rawKind != null) {
      for (final kind in ReminderKind.values) {
        if (kind.name == rawKind) return kind;
      }
    }
    return ReminderKind.prayerAtTime;
  }

  AppLocalizations get _l10n => lookupAppLocalizations(
    resolveStoredAppLocale(_store) ??
        WidgetsBinding.instance.platformDispatcher.locale,
  );
}

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService(
    ref,
    ref.watch(localStoreProvider),
    ref.watch(adhanRepositoryProvider),
  );
});
