import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/core/reminders/adhan_audio_service.dart';
import 'package:path_of_nur/core/reminders/adhan_options.dart';
import 'package:path_of_nur/core/reminders/local_notification_service.dart';
import 'package:path_of_nur/core/prayer/prayer_preferences.dart';
import 'package:path_of_nur/core/reminders/reminder_scheduler.dart';
import 'package:path_of_nur/features/profile/application/profile_settings_provider.dart';
import 'package:path_of_nur/features/worship/application/prayer_controller.dart';
import 'package:path_of_nur/features/worship/data/prayer_log_repository.dart';
import 'package:path_of_nur/features/worship/domain/daily_prayer_record.dart';
import 'package:path_of_nur/features/worship/domain/prayer_name.dart';
import 'package:path_of_nur/features/worship/domain/prayer_status.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

class _FakeLocalNotificationService extends LocalNotificationService {
  _FakeLocalNotificationService(Ref ref, LocalStore store)
    : super(ref, store, const AdhanRepository());

  ReminderSchedulerState? lastPlan;
  AdhanSettings? lastAdhanSettings;

  @override
  Future<void> ensureInitialized() async {}

  @override
  Future<void> syncWithPlan(
    ReminderSchedulerState plan, {
    required AdhanSettings adhanSettings,
  }) async {
    lastPlan = plan;
    lastAdhanSettings = adhanSettings;
  }
}

PrayerLocationNotifier _testPrayerLocationNotifier(LocalStore store) {
  return PrayerLocationNotifier(
    store,
    const PrayerPreferences(
      location: 'Toronto, Canada',
      madhab: PrayerMadhab.shafii,
      calculationMethod: PrayerCalculationMethod.muslimWorldLeague,
      useDeviceLocation: false,
      manualLatitude: 43.6532,
      manualLongitude: -79.3832,
    ),
  );
}

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
  TestWidgetsFlutterBinding.ensureInitialized();

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
          prayerLocationProvider.overrideWith((ref) {
            return _testPrayerLocationNotifier(LocalStore(prefs));
          }),
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
        day1Plan.items.any((i) => i.id == 'prayer.dhuhr.followUp'),
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
      expect(day1Plan.items.any((i) => i.id == 'celestial.moonrise'), isTrue);
      expect(day1Plan.items.any((i) => i.id == 'celestial.moonset'), isTrue);
      expect(day1Plan.items.every((i) => i.when.day == 11), isTrue);

      final day2Container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          dailyNowProvider.overrideWith((ref) => Stream.value(day2)),
          prayerScheduleProvider.overrideWithValue(scheduleDay2),
          prayerLocationProvider.overrideWith((ref) {
            return _testPrayerLocationNotifier(LocalStore(prefs));
          }),
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

  test('moonrise and moonset reminders respect profile notification toggles', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime(2026, 3, 11, 9, 0);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        dailyNowProvider.overrideWith((ref) => Stream.value(now)),
        prayerScheduleProvider.overrideWithValue(const <PrayerScheduleItem>[]),
        prayerLocationProvider.overrideWith((ref) {
          return _testPrayerLocationNotifier(LocalStore(prefs));
        }),
      ],
    );
    addTearDown(container.dispose);

    await container.read(dailyNowProvider.future);

    final defaultPlan = container.read(reminderSchedulerProvider);
    expect(defaultPlan.items.any((i) => i.id == 'celestial.moonrise'), isTrue);
    expect(defaultPlan.items.any((i) => i.id == 'celestial.moonset'), isTrue);

    container.read(profileSettingsProvider.notifier).setMoonriseReminders(false);
    final moonsetOnlyPlan = container.read(reminderSchedulerProvider);
    expect(
      moonsetOnlyPlan.items.any((i) => i.id == 'celestial.moonrise'),
      isFalse,
    );
    expect(
      moonsetOnlyPlan.items.any((i) => i.id == 'celestial.moonset'),
      isTrue,
    );

    container.read(profileSettingsProvider.notifier).setMoonsetReminders(false);
    final noCelestialPlan = container.read(reminderSchedulerProvider);
    expect(
      noCelestialPlan.items.any((i) => i.id == 'celestial.moonrise'),
      isFalse,
    );
    expect(
      noCelestialPlan.items.any((i) => i.id == 'celestial.moonset'),
      isFalse,
    );
  });

  test(
    'reminder bootstrap stays safe with sparse defaults and empty schedule',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final now = DateTime(2026, 3, 14, 9, 0);
      late final _FakeLocalNotificationService fakeService;

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          localNotificationServiceProvider.overrideWith((ref) {
            fakeService = _FakeLocalNotificationService(ref, store);
            return fakeService;
          }),
          dailyNowProvider.overrideWith((ref) => Stream.value(now)),
          prayerScheduleProvider.overrideWithValue(
            const <PrayerScheduleItem>[],
          ),
          prayerLocationProvider.overrideWith((ref) {
            return _testPrayerLocationNotifier(store);
          }),
        ],
      );
      addTearDown(container.dispose);

      container.read(reminderSchedulerBootstrapProvider);
      await Future<void>.delayed(Duration.zero);

      final storedPlan = store.getJsonList('reminders.plan.2026-03-14');
      expect(container.read(reminderSchedulerProvider).dayKey, '2026-03-14');
      expect(fakeService.lastPlan, isNotNull);
      expect(storedPlan, isNotNull);
    },
  );

  test('completed Friday Jumu‘ah suppresses Dhuhr reminders for that day', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final friday = DateTime(2026, 3, 20, 9, 0);
    final dayKey = LocalStore.todayKey(friday);

    final fridaySchedule = <PrayerScheduleItem>[
      _item(
        id: 'fajr',
        name: 'Fajr',
        offer: DateTime(2026, 3, 20, 6, 0),
        windowEnd: DateTime(2026, 3, 20, 7, 0),
        qaza: DateTime(2026, 3, 20, 7, 0),
      ),
      _item(
        id: 'dhuhr',
        name: 'Dhuhr',
        offer: DateTime(2026, 3, 20, 13, 30),
        windowEnd: DateTime(2026, 3, 20, 16, 0),
        qaza: DateTime(2026, 3, 20, 16, 0),
      ),
      _item(
        id: 'asr',
        name: 'Asr',
        offer: DateTime(2026, 3, 20, 16, 30),
        windowEnd: DateTime(2026, 3, 20, 19, 0),
        qaza: DateTime(2026, 3, 20, 19, 0),
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(database),
        dailyNowProvider.overrideWith((ref) => Stream.value(friday)),
        prayerScheduleProvider.overrideWithValue(fridaySchedule),
        prayerLocationProvider.overrideWith((ref) {
          return _testPrayerLocationNotifier(LocalStore(prefs));
        }),
      ],
    );
    addTearDown(container.dispose);

    await container.read(dailyNowProvider.future);
    container.read(prayerLogRepositoryProvider).saveDailyRecords(dayKey, const [
      DailyPrayerRecord(prayer: PrayerName.fajr),
      DailyPrayerRecord(
        prayer: PrayerName.dhuhr,
        status: PrayerStatus.completed,
        completedAtIso: '2026-03-20T13:35:00.000',
      ),
      DailyPrayerRecord(prayer: PrayerName.asr),
      DailyPrayerRecord(prayer: PrayerName.maghrib),
      DailyPrayerRecord(prayer: PrayerName.isha),
    ]);
    container.read(prayerControllerProvider.notifier).onDayChanged(dayKey, force: true);
    container
        .read(prayerSettingsProvider.notifier)
        .updateNotificationMode(
          'dhuhr',
          PrayerNotificationMode.notificationOnly,
        );

    final plan = container.read(reminderSchedulerProvider);

    expect(plan.items.any((item) => item.prayerId == 'dhuhr'), isFalse);
  });

  test(
    'reminder bootstrap resyncs when prayer notification settings change',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final now = DateTime(2026, 3, 14, 9, 0);
      late final _FakeLocalNotificationService fakeService;

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          localNotificationServiceProvider.overrideWith((ref) {
            fakeService = _FakeLocalNotificationService(ref, store);
            return fakeService;
          }),
          dailyNowProvider.overrideWith((ref) => Stream.value(now)),
          prayerScheduleProvider.overrideWithValue(<PrayerScheduleItem>[
            _item(
              id: 'fajr',
              name: 'Fajr',
              offer: DateTime(2026, 3, 14, 5, 30),
              windowEnd: DateTime(2026, 3, 14, 6, 30),
              qaza: DateTime(2026, 3, 14, 6, 30),
            ),
          ]),
          prayerLocationProvider.overrideWith((ref) {
            return _testPrayerLocationNotifier(store);
          }),
        ],
      );
      addTearDown(container.dispose);

      container.read(reminderSchedulerBootstrapProvider);
      await Future<void>.delayed(Duration.zero);

      expect(
        fakeService.lastPlan?.items.any((item) => item.prayerId == 'fajr'),
        isFalse,
      );

      container
          .read(prayerSettingsProvider.notifier)
          .updateNotificationMode(
            'fajr',
            PrayerNotificationMode.notificationOnly,
          );
      await Future<void>.delayed(Duration.zero);

      expect(
        fakeService.lastPlan?.items.any(
          (item) => item.id == 'prayer.fajr.at.notification',
        ),
        isTrue,
      );
    },
  );
}
