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
    this.watchRoute,
  });

  final String route;
  final String? prayerId;
  final String? logicalDate;
  final String? watchRoute;

  bool get isPrayerReminder =>
      prayerId != null && prayerId!.isNotEmpty && logicalDate != null;

  String encode() => jsonEncode(<String, Object?>{
    'route': route,
    'prayerId': prayerId,
    'logicalDate': logicalDate,
    'watchRoute': watchRoute,
  });

  static ReminderNotificationPayload routeOnly(String route) {
    return ReminderNotificationPayload._(route: route);
  }

  static ReminderNotificationPayload prayer({
    required String route,
    required String prayerId,
    required String logicalDate,
    String? watchRoute,
  }) {
    return ReminderNotificationPayload._(
      route: route,
      prayerId: prayerId,
      logicalDate: logicalDate,
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
  static const String markPrayedActionId = 'MARK_PRAYED';
  static const String markPrayedLateActionId = 'MARK_PRAYED_LATE';
  static const String snoozeActionId = 'SNOOZE';
  static const String openAppActionId = 'OPEN_APP';
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
        payload: '/journey/growth/today',
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
          _prayerName(l10n, item.prayerId),
        );
      case ReminderKind.prayerFollowUp:
        return l10n.notificationsPrayerAtTimeTitle(
          _prayerName(l10n, item.prayerId),
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
      case ReminderKind.cycleCheck:
        return l10n.notificationsCycleCheckTitle;
    }
  }

  String _bodyFor(ReminderPlanItem item) {
    final l10n = _l10n;
    switch (item.kind) {
      case ReminderKind.prayerAtTime:
        return l10n.notificationsPrayerAtTimeBody(
          _prayerName(l10n, item.prayerId),
          _prayerName(l10n, item.prayerId),
        );
      case ReminderKind.prayerFollowUp:
        return l10n.notificationsPrayerAtTimeBody(
          _prayerName(l10n, item.prayerId),
          _prayerName(l10n, item.prayerId),
        );
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
      case ReminderKind.cycleCheck:
        return l10n.notificationsCycleCheckBody;
    }
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
      case snoozeActionId:
        await _snoozePrayerReminder(payload);
        return;
      case openAppActionId:
        PlatformRouteDispatcher.dispatch(payload.route);
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
        watchRoute: 'pathofnurwatch://prayer?prayerId=${item.prayerId}',
      ).encode(),
      ReminderKind.dhikr => ReminderNotificationPayload.routeOnly(
        '/worship',
      ).encode(),
      ReminderKind.quran => ReminderNotificationPayload.routeOnly(
        '/quran',
      ).encode(),
      ReminderKind.reflection => ReminderNotificationPayload.routeOnly(
        '/journey/growth/reflection',
      ).encode(),
      ReminderKind.fasting => ReminderNotificationPayload.routeOnly(
        '/worship',
      ).encode(),
      ReminderKind.cycleCheck => ReminderNotificationPayload.routeOnly(
        '/settings',
      ).encode(),
    };
  }

  String? _categoryIdentifierFor(ReminderPlanItem item) {
    return switch (item.kind) {
      ReminderKind.prayerAtTime => prayerReminderCategoryId,
      ReminderKind.prayerBeforeQaza => prayerReminderCategoryId,
      ReminderKind.prayerFollowUp => prayerReminderCategoryId,
      _ => null,
    };
  }

  List<DarwinNotificationCategory> _darwinNotificationCategories(
    AppLocalizations l10n,
  ) {
    return <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        prayerReminderCategoryId,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            markPrayedActionId,
            l10n.notificationsPrayerActionMarkPrayed,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            markPrayedLateActionId,
            l10n.notificationsPrayerActionMarkPrayedLate,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            snoozeActionId,
            l10n.notificationsPrayerActionSnooze,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            openAppActionId,
            l10n.notificationsPrayerActionOpen,
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        ],
        options: const <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      ),
    ];
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
    await _cancelPrayerReminderSnooze(prayerId, logicalDate);
    await _cancelPrayerReminderFollowUp(prayerId);
  }

  Future<void> _snoozePrayerReminder(
    ReminderNotificationPayload payload,
  ) async {
    if (!payload.isPrayerReminder) {
      PlatformRouteDispatcher.dispatch(payload.route);
      return;
    }

    final profileSettings = _ref.read(profileSettingsProvider);
    final prayerId = payload.prayerId!;
    final logicalDate = payload.logicalDate!;
    final scheduledAt = DateTime.now().add(
      Duration(minutes: profileSettings.prayerReminderSnoozeMinutes),
    );
    final reminder = ReminderPlanItem(
      id: _snoozeToken(prayerId, logicalDate),
      kind: ReminderKind.prayerAtTime,
      prayerId: prayerId,
      when: scheduledAt,
      notificationMode: PrayerNotificationMode.notificationOnly,
    );
    await _cancelPrayerReminderSnooze(prayerId, logicalDate);
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
              'minutes': profileSettings.prayerReminderSnoozeMinutes,
            },
            sourceVersion: '1',
          ),
        );
  }

  Future<void> _cancelPrayerReminderSnooze(
    String prayerId,
    String logicalDate,
  ) async {
    await _plugin.cancel(_notificationId(_snoozeToken(prayerId, logicalDate)));
  }

  Future<void> _cancelPrayerReminderFollowUp(String prayerId) async {
    await _plugin.cancel(_notificationId(_followUpToken(prayerId)));
  }

  String _snoozeToken(String prayerId, String logicalDate) {
    return 'prayer.$prayerId.snooze.$logicalDate';
  }

  String _followUpToken(String prayerId) {
    return 'prayer.$prayerId.followUp';
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
