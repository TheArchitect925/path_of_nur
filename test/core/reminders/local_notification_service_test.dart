import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/core/prayer/prayer_preferences.dart';
import 'package:path_of_nur/core/reminders/adhan_options.dart';
import 'package:path_of_nur/core/reminders/local_notification_service.dart';
import 'package:path_of_nur/core/reminders/reminder_scheduler.dart';
import 'package:path_of_nur/features/profile/application/profile_settings_provider.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('prayer reminder payload encodes and decodes prayer metadata', () {
    final payload = ReminderNotificationPayload.prayer(
      route: '/worship?prayerId=dhuhr',
      prayerId: 'dhuhr',
      logicalDate: '2026-03-18',
      reminderKind: 'at_time',
      watchRoute: 'pathofnurwatch://prayer?prayerId=dhuhr',
    );

    final decoded = ReminderNotificationPayload.decode(payload.encode());

    expect(decoded, isNotNull);
    expect(decoded!.route, '/worship?prayerId=dhuhr');
    expect(decoded.prayerId, 'dhuhr');
    expect(decoded.logicalDate, '2026-03-18');
    expect(decoded.watchRoute, 'pathofnurwatch://prayer?prayerId=dhuhr');
    expect(decoded.isPrayerReminder, isTrue);
  });

  test('route-only payload decodes legacy plain route strings', () {
    final decoded = ReminderNotificationPayload.decode('/journey/growth/today');

    expect(decoded, isNotNull);
    expect(decoded!.route, '/journey/growth/today');
    expect(decoded.prayerId, isNull);
    expect(decoded.logicalDate, isNull);
    expect(decoded.isPrayerReminder, isFalse);
  });

  test('reflection reminder payload encodes deep-link reminder metadata', () {
    final payload = ReminderNotificationPayload.routeReminder(
      route: '/journey/reflection',
      logicalDate: '2026-03-20',
      reminderKind: 'reflection',
      snoozeCount: 1,
    );

    final decoded = ReminderNotificationPayload.decode(payload.encode());

    expect(decoded, isNotNull);
    expect(decoded!.route, '/journey/reflection');
    expect(decoded.prayerId, isNull);
    expect(decoded.logicalDate, '2026-03-20');
    expect(decoded.reminderKind, 'reflection');
    expect(decoded.snoozeCount, 1);
    expect(decoded.isPrayerReminder, isFalse);
  });

  group('salah reminder notification details', () {
    const adhanSettings = AdhanSettings.defaults;
    final adhan = AdhanRegistry.byId(AdhanRegistry.defaultRegularId)!;

    ReminderPlanItem item(ReminderKind kind, PrayerNotificationMode? mode) {
      return ReminderPlanItem(
        id: 'prayer.dhuhr.${kind.name}',
        kind: kind,
        prayerId: 'dhuhr',
        when: DateTime(2026, 9, 27, 13, 5),
        notificationMode: mode,
      );
    }

    final atTime = item(
      ReminderKind.prayerAtTime,
      PrayerNotificationMode.adhanWithSound,
    );
    final followUp = item(
      ReminderKind.prayerFollowUp,
      PrayerNotificationMode.notificationOnly,
    );
    final beforeQaza = item(
      ReminderKind.prayerBeforeQaza,
      PrayerNotificationMode.reminderBeforeQaza,
    );

    Future<LocalNotificationService> serviceWithGentleMode(bool enabled) async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      container
          .read(profileSettingsProvider.notifier)
          .setGentleModeEnabled(enabled);
      return container.read(localNotificationServiceProvider);
    }

    test(
      'gentle mode off keeps sound, the adhan and the usual channels',
      () async {
        final service = await serviceWithGentleMode(false);

        final adhanDetails = service.notificationDetailsFor(
          atTime,
          adhanSettings,
        );
        final android = adhanDetails.android!;
        expect(android.channelId, 'prayer_reminders_adhan_${adhan.id}');
        expect(android.playSound, isTrue);
        expect(android.importance, Importance.max);
        expect(
          (android.sound! as RawResourceAndroidNotificationSound).sound,
          adhan.androidRawResourceName,
        );
        expect(adhanDetails.iOS!.presentSound, isTrue);
        expect(adhanDetails.iOS!.sound, adhan.iosSoundFileName);
        expect(
          adhanDetails.iOS!.interruptionLevel,
          InterruptionLevel.timeSensitive,
        );

        final followUpAndroid = service
            .notificationDetailsFor(followUp, adhanSettings)
            .android!;
        expect(followUpAndroid.channelId, 'prayer_reminders_notification_only');
        expect(followUpAndroid.playSound, isTrue);

        final beforeQazaAndroid = service
            .notificationDetailsFor(beforeQaza, adhanSettings)
            .android!;
        expect(beforeQazaAndroid.channelId, 'prayer_reminders_before_qaza');
        expect(beforeQazaAndroid.playSound, isTrue);
      },
    );

    test(
      'gentle mode on sends every salah reminder to the silent channel',
      () async {
        final service = await serviceWithGentleMode(true);

        for (final reminder in [atTime, followUp, beforeQaza]) {
          final details = service.notificationDetailsFor(
            reminder,
            adhanSettings,
          );
          final android = details.android!;
          final reason = reminder.kind.name;
          expect(android.channelId, 'prayer_reminders_gentle', reason: reason);
          expect(android.playSound, isFalse, reason: reason);
          expect(android.enableVibration, isFalse, reason: reason);
          expect(android.sound, isNull, reason: reason);
          expect(
            android.importance,
            Importance.defaultImportance,
            reason: reason,
          );
          expect(android.actions, isNotEmpty, reason: reason);

          expect(details.iOS!.presentSound, isFalse, reason: reason);
          expect(details.iOS!.sound, isNull, reason: reason);
          expect(
            details.iOS!.interruptionLevel,
            InterruptionLevel.active,
            reason: reason,
          );
        }
      },
    );

    test('gentle mode leaves other reminders on their own channels', () async {
      final service = await serviceWithGentleMode(true);

      final dhikr = service
          .notificationDetailsFor(
            ReminderPlanItem(
              id: 'dhikr.evening',
              kind: ReminderKind.dhikr,
              prayerId: null,
              when: DateTime(2026, 9, 27, 18),
              notificationMode: null,
            ),
            adhanSettings,
          )
          .android!;
      expect(dhikr.channelId, 'daily_reminders');
    });
  });
}
