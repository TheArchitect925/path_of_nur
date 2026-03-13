import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/core/prayer/prayer_preferences.dart';
import 'package:path_of_nur/core/reminders/reminder_scheduler.dart';
import 'package:path_of_nur/features/profile/application/profile_settings_provider.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

PrayerScheduleItem _item({
  required String id,
  required String name,
  required DateTime offer,
  required DateTime windowEnd,
  required DateTime qaza,
  DateTime? overdueAt,
}) {
  return PrayerScheduleItem(
    id: id,
    name: name,
    arabicName: name,
    category: 'Fardh',
    offerDateTime: offer,
    windowStartDateTime: offer,
    windowEndDateTime: windowEnd,
    qazaDateTime: qaza,
    overdueAtDateTime: overdueAt,
    totalRakats: 2,
  );
}

void main() {
  test(
    'reminder plan updates daily for prayer and non-prayer reminder types',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final day1 = DateTime(2026, 3, 11, 9, 0);
      final day2 = DateTime(2026, 3, 12, 9, 0);

      final scheduleDay1 = <PrayerScheduleItem>[
        _item(
          id: 'fajr',
          name: 'Fajr',
          offer: DateTime(2026, 3, 11, 6, 0),
          windowEnd: DateTime(2026, 3, 11, 7, 0),
          qaza: DateTime(2026, 3, 11, 7, 0),
        ),
        _item(
          id: 'dhuhr',
          name: 'Dhuhr',
          offer: DateTime(2026, 3, 11, 13, 0),
          windowEnd: DateTime(2026, 3, 11, 16, 0),
          qaza: DateTime(2026, 3, 11, 16, 0),
        ),
        _item(
          id: 'asr',
          name: 'Asr',
          offer: DateTime(2026, 3, 11, 16, 30),
          windowEnd: DateTime(2026, 3, 11, 19, 0),
          qaza: DateTime(2026, 3, 11, 19, 0),
        ),
      ];

      final scheduleDay2 = <PrayerScheduleItem>[
        _item(
          id: 'fajr',
          name: 'Fajr',
          offer: DateTime(2026, 3, 12, 5, 40),
          windowEnd: DateTime(2026, 3, 12, 6, 40),
          qaza: DateTime(2026, 3, 12, 6, 40),
        ),
        _item(
          id: 'dhuhr',
          name: 'Dhuhr',
          offer: DateTime(2026, 3, 12, 13, 10),
          windowEnd: DateTime(2026, 3, 12, 16, 10),
          qaza: DateTime(2026, 3, 12, 16, 10),
        ),
        _item(
          id: 'asr',
          name: 'Asr',
          offer: DateTime(2026, 3, 12, 16, 45),
          windowEnd: DateTime(2026, 3, 12, 19, 10),
          qaza: DateTime(2026, 3, 12, 19, 10),
        ),
      ];

      final day1Container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          dailyNowProvider.overrideWith((ref) => Stream.value(day1)),
          prayerScheduleProvider.overrideWithValue(scheduleDay1),
        ],
      );
      addTearDown(day1Container.dispose);

      await day1Container.read(dailyNowProvider.future);
      day1Container
          .read(profileSettingsProvider.notifier)
          .setQuranReminders(true);
      day1Container
          .read(profileSettingsProvider.notifier)
          .setReflectionReminders(true);
      day1Container
          .read(profileSettingsProvider.notifier)
          .setFastingReminders(true);

      day1Container
          .read(prayerSettingsProvider.notifier)
          .updateNotificationMode(
            'fajr',
            PrayerNotificationMode.notificationOnly,
          );
      day1Container
          .read(prayerSettingsProvider.notifier)
          .updateNotificationMode(
            'dhuhr',
            PrayerNotificationMode.adhanWithSound,
          );
      day1Container
          .read(prayerSettingsProvider.notifier)
          .updateNotificationMode(
            'asr',
            PrayerNotificationMode.reminderBeforeQaza,
          );

      final day1Plan = day1Container.read(reminderSchedulerProvider);
      expect(day1Plan.dayKey, '2026-03-11');
      expect(
        day1Plan.items.any((i) => i.id == 'prayer.fajr.at.notification'),
        isTrue,
      );
      expect(
        day1Plan.items.any((i) => i.id == 'prayer.dhuhr.at.adhan'),
        isTrue,
      );
      expect(
        day1Plan.items.any((i) => i.id == 'prayer.asr.beforeQaza'),
        isTrue,
      );
      expect(day1Plan.items.any((i) => i.id == 'dhikr.daily'), isTrue);
      expect(day1Plan.items.any((i) => i.id == 'quran.daily'), isTrue);
      expect(day1Plan.items.any((i) => i.id == 'reflection.daily'), isTrue);
      expect(day1Plan.items.any((i) => i.id == 'fasting.daily'), isTrue);
      expect(day1Plan.items.every((i) => i.when.day == 11), isTrue);

      final day2Container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          dailyNowProvider.overrideWith((ref) => Stream.value(day2)),
          prayerScheduleProvider.overrideWithValue(scheduleDay2),
        ],
      );
      addTearDown(day2Container.dispose);

      await day2Container.read(dailyNowProvider.future);
      final day2Plan = day2Container.read(reminderSchedulerProvider);

      expect(day2Plan.dayKey, '2026-03-12');
      expect(day2Plan.items.every((i) => i.when.day == 12), isTrue);

      final day1Dhuhr = day1Plan.items
          .where((i) => i.id == 'prayer.dhuhr.at.adhan')
          .first
          .when;
      final day2Dhuhr = day2Plan.items
          .where((i) => i.id == 'prayer.dhuhr.at.adhan')
          .first
          .when;
      expect(day2Dhuhr.isAfter(day1Dhuhr), isTrue);
      expect(day2Dhuhr.hour, 13);
      expect(day2Dhuhr.minute, 10);
    },
  );
}
