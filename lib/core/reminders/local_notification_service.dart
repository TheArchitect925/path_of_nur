import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../shared/persistence/local_store.dart';
import 'reminder_scheduler.dart';

class LocalNotificationService {
  LocalNotificationService(this._store) {
    _plugin = FlutterLocalNotificationsPlugin();
  }

  final LocalStore _store;
  late final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  static const _fingerprintKey = 'reminders.lastFingerprint';
  static const _timezoneKey = 'reminders.timezone';

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    await _initializeLocalTimezone();

    const initSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(),
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
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
      await _plugin.cancelAll();
    }

    final now = DateTime.now();
    for (final item in plan.items) {
      if (!item.when.isAfter(now)) continue;
      await _plugin.zonedSchedule(
        _notificationId(item.id),
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

    await _recoverMissedReminders(plan, now);
  }

  NotificationDetails _notificationDetails(ReminderPlanItem item) {
    final prayerChannel = AndroidNotificationDetails(
      'prayer_reminders',
      'Prayer Reminders',
      channelDescription: 'Prayer reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: item.kind == ReminderKind.prayerAtTime,
    );

    const genericChannel = AndroidNotificationDetails(
      'daily_reminders',
      'Daily Reminders',
      channelDescription: 'Dhikr, Quran and reflection reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    final ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: item.kind == ReminderKind.prayerAtTime,
      presentBanner: true,
      presentList: true,
      interruptionLevel:
          item.kind == ReminderKind.prayerAtTime ||
              item.kind == ReminderKind.prayerBeforeQaza
          ? InterruptionLevel.timeSensitive
          : InterruptionLevel.active,
      threadIdentifier: item.prayerId ?? item.kind.name,
    );

    return NotificationDetails(
      android:
          item.kind == ReminderKind.prayerAtTime ||
              item.kind == ReminderKind.prayerBeforeQaza
          ? prayerChannel
          : genericChannel,
      iOS: ios,
    );
  }

  String _titleFor(ReminderPlanItem item) {
    switch (item.kind) {
      case ReminderKind.prayerAtTime:
        return '${_prayerName(item.prayerId)} time';
      case ReminderKind.prayerBeforeQaza:
        return '${_prayerName(item.prayerId)} reminder';
      case ReminderKind.dhikr:
        return 'Dhikr reminder';
      case ReminderKind.quran:
        return 'Qur\'an reminder';
      case ReminderKind.reflection:
        return 'Reflection reminder';
      case ReminderKind.fasting:
        return 'Fasting reminder';
      case ReminderKind.cycleCheck:
        return 'Cycle check-in';
    }
  }

  String _bodyFor(ReminderPlanItem item) {
    switch (item.kind) {
      case ReminderKind.prayerAtTime:
        return 'It is time for ${_prayerName(item.prayerId)}.';
      case ReminderKind.prayerBeforeQaza:
        return 'Qaza time is approaching for ${_prayerName(item.prayerId)}.';
      case ReminderKind.dhikr:
        return 'Take a calm moment for remembrance.';
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

  String _fingerprintFor(ReminderSchedulerState plan) {
    final parts = <String>[plan.dayKey];
    for (final item in plan.items) {
      parts.add('${item.id}|${item.when.toIso8601String()}|${item.kind.name}');
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
}

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService(ref.watch(localStoreProvider));
});
