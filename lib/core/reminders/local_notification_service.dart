import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

class LocalNotificationService {
  LocalNotificationService(this._store) {
    _plugin = FlutterLocalNotificationsPlugin();
  }

  static const Color _notificationAccent = Color(0xFFD8C49A);
  static const String _launcherIcon = '@mipmap/ic_launcher';
  final LocalStore _store;
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

    const initSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(),
      android: AndroidInitializationSettings(_launcherIcon),
    );

    await _plugin.initialize(initSettings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> syncWithPlan(ReminderSchedulerState plan) async {
    await ensureInitialized();

    final fingerprint = _fingerprintFor(plan);
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
        _notificationDetails(item),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    if (didChangePlan) {
      await _store.setString(_fingerprintKey, fingerprint);
    }
    await _store.setJsonList(_scheduledPrayerIdsKey, scheduledIds.toList()..sort());

    await _recoverMissedReminders(plan, now);
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
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    await _store.setJsonList(_scheduledGrowthIdsKey, scheduledIds.toList()..sort());
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

  NotificationDetails _notificationDetails(ReminderPlanItem item) {
    final useAdhanSound =
        item.kind == ReminderKind.prayerAtTime &&
        item.notificationMode == PrayerNotificationMode.adhanWithSound;

    final prayerAtTimeSilentChannel = AndroidNotificationDetails(
      'prayer_reminders_notification_only',
      'Prayer Reminders (Notification)',
      channelDescription: 'Prayer reminder notifications without adhan audio',
      importance: Importance.max,
      priority: Priority.high,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      styleInformation: const BigTextStyleInformation(''),
      playSound: true,
    );

    final prayerAtTimeAdhanChannel = AndroidNotificationDetails(
      'prayer_reminders_adhan',
      'Prayer Reminders (Adhan)',
      channelDescription: 'Prayer reminder notifications with adhan audio',
      importance: Importance.max,
      priority: Priority.high,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      styleInformation: const BigTextStyleInformation(''),
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('adhan'),
    );

    final prayerBeforeQazaChannel = AndroidNotificationDetails(
      'prayer_reminders_before_qaza',
      'Prayer Reminders (Before Qaza)',
      channelDescription: 'Prayer reminder notifications before qaza',
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
      'Daily Reminders',
      channelDescription: 'Dhikr, Quran and reflection reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: _launcherIcon,
      color: _notificationAccent,
      colorized: true,
      styleInformation: const BigTextStyleInformation(''),
    );

    final useDefaultPrayerSound =
        item.kind == ReminderKind.prayerAtTime ||
        item.kind == ReminderKind.prayerBeforeQaza;

    final ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: useDefaultPrayerSound,
      sound: useAdhanSound ? 'adhan.caf' : null,
      presentBanner: true,
      presentList: true,
      interruptionLevel:
          item.kind == ReminderKind.prayerAtTime ||
              item.kind == ReminderKind.prayerBeforeQaza
          ? InterruptionLevel.timeSensitive
          : InterruptionLevel.active,
      threadIdentifier: item.prayerId ?? item.kind.name,
      subtitle: 'Path of Nur',
    );

    return NotificationDetails(
      android: switch (item.kind) {
        ReminderKind.prayerAtTime => useAdhanSound
            ? prayerAtTimeAdhanChannel
            : prayerAtTimeSilentChannel,
        ReminderKind.prayerBeforeQaza => prayerBeforeQazaChannel,
        _ => genericChannel,
      },
      iOS: ios,
    );
  }

  String _titleFor(ReminderPlanItem item) {
    switch (item.kind) {
      case ReminderKind.prayerAtTime:
        return '${_prayerName(item.prayerId)} prayer';
      case ReminderKind.prayerBeforeQaza:
        return '${_prayerName(item.prayerId)} reminder';
      case ReminderKind.dhikr:
        return 'Dhikr reminder';
      case ReminderKind.quran:
        return 'Qur\'an reflection';
      case ReminderKind.reflection:
        return 'Daily reflection';
      case ReminderKind.fasting:
        return 'Fasting reminder';
      case ReminderKind.cycleCheck:
        return 'Cycle check-in';
    }
  }

  String _bodyFor(ReminderPlanItem item) {
    switch (item.kind) {
      case ReminderKind.prayerAtTime:
        return 'It is time for ${_prayerName(item.prayerId)}. Stay connected with your prayer.';
      case ReminderKind.prayerBeforeQaza:
        return 'Qaza time is approaching for ${_prayerName(item.prayerId)}.';
      case ReminderKind.dhikr:
        return 'Take a calm moment for dhikr.';
      case ReminderKind.quran:
        return 'Return to your Qur\'an reading with intention.';
      case ReminderKind.reflection:
        return 'Capture a brief reflection before your day ends.';
      case ReminderKind.fasting:
        return 'Prepare your intention for fasting today.';
      case ReminderKind.cycleCheck:
        return 'Review your status and resume prayer reminders when ready.';
    }
  }

  String _prayerName(String? id) {
    switch (id) {
      case 'fajr':
        return 'Fajr';
      case 'dhuhr':
        return 'Dhuhr';
      case 'asr':
        return 'Asr';
      case 'maghrib':
        return 'Maghrib';
      case 'isha':
        return 'Isha';
      case 'tahajjud':
        return 'Tahajjud';
      default:
        return 'Prayer';
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
    final android = AndroidNotificationDetails(
      quietDelivery ? 'growth_gentle_reminders_quiet' : 'growth_gentle_reminders',
      quietDelivery ? 'Growth Reminders (Quiet)' : 'Growth Reminders',
      channelDescription: 'Gentle reminders for Growth habits',
      importance: quietDelivery ? Importance.defaultImportance : Importance.high,
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
      interruptionLevel:
          quietDelivery ? InterruptionLevel.passive : InterruptionLevel.active,
      threadIdentifier: 'growth',
      subtitle: 'Path of Nur',
    );
    return NotificationDetails(android: android, iOS: ios);
  }

  String _fingerprintFor(ReminderSchedulerState plan) {
    final parts = <String>[plan.dayKey];
    for (final item in plan.items) {
      parts.add(
        '${item.id}|${item.when.toIso8601String()}|${item.kind.name}|${item.notificationMode?.name ?? '-'}',
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
        'You missed this reminder earlier. ${_bodyFor(item)}',
        _notificationDetails(item),
      );
      changed = true;
    }

    if (changed) {
      await _store.setJsonList(recoveredKey, recovered.toList()..sort());
    }
  }

  Set<String> _storedNotificationIds(String key) {
    return {
      ...?_store.getJsonList(key)?.map((item) => item.toString()),
    };
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
}

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService(ref.watch(localStoreProvider));
});
