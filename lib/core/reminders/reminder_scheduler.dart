import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/application/profile_settings_provider.dart';
import '../../features/worship/application/sister_cycle_provider.dart';
import '../../shared/state/user_profile_state.dart';
import '../../shared/application/daily_clock_provider.dart';
import '../../shared/persistence/local_store.dart';
import '../prayer/prayer_preferences.dart';
import 'local_notification_service.dart';

enum ReminderKind {
  prayerAtTime,
  prayerBeforeQaza,
  dhikr,
  quran,
  reflection,
  fasting,
  cycleCheck,
}

class ReminderPlanItem {
  const ReminderPlanItem({
    required this.id,
    required this.kind,
    required this.prayerId,
    required this.when,
    required this.notificationMode,
  });

  final String id;
  final ReminderKind kind;
  final String? prayerId;
  final DateTime when;
  final PrayerNotificationMode? notificationMode;
}

class ReminderSchedulerState {
  const ReminderSchedulerState({required this.dayKey, required this.items});

  final String dayKey;
  final List<ReminderPlanItem> items;
}

final reminderSchedulerProvider = Provider<ReminderSchedulerState>((ref) {
  final profileSettings = ref.watch(profileSettingsProvider);
  final prayerSettings = ref.watch(prayerSettingsProvider);
  final sisterCycle = ref.watch(sisterCycleProvider);
  final userProfile = ref.watch(userProfileProvider);
  final schedule = ref.watch(prayerScheduleProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final dayKey = LocalStore.todayKey(now);

  final items = <ReminderPlanItem>[];
  final isSisterCycleActive =
      sisterCycle.active && userProfile.sex == UserSex.sister;
  final shouldAutoAdjustForCycle =
      isSisterCycleActive && sisterCycle.autoAdjustReminders;

  for (final prayer in schedule) {
    final mode =
        prayerSettings.notificationModes[prayer.id] ??
        PrayerNotificationMode.none;
    if (!profileSettings.prayerReminders ||
        shouldAutoAdjustForCycle ||
        mode == PrayerNotificationMode.none) {
      continue;
    }

    if (mode == PrayerNotificationMode.notificationOnly ||
        mode == PrayerNotificationMode.adhanWithSound) {
      final reminderAt = _effectiveReminderTime(
        prayer: prayer,
        settings: prayerSettings.preferences,
      );
      final modeSuffix = mode == PrayerNotificationMode.adhanWithSound
          ? 'adhan'
          : 'notification';
      items.add(
        ReminderPlanItem(
          id: 'prayer.${prayer.id}.at.$modeSuffix',
          kind: ReminderKind.prayerAtTime,
          prayerId: prayer.id,
          when: reminderAt,
          notificationMode: mode,
        ),
      );
    }

    if (mode == PrayerNotificationMode.reminderBeforeQaza) {
      items.add(
        ReminderPlanItem(
          id: 'prayer.${prayer.id}.beforeQaza',
          kind: ReminderKind.prayerBeforeQaza,
          prayerId: prayer.id,
          when: prayer.overdueDateTime.subtract(const Duration(minutes: 20)),
          notificationMode: mode,
        ),
      );
    }
  }

  if (profileSettings.dhikrReminders) {
    items.add(
      ReminderPlanItem(
        id: shouldAutoAdjustForCycle ? 'dhikr.daily.cycle' : 'dhikr.daily',
        kind: ReminderKind.dhikr,
        prayerId: null,
        when: DateTime(
          now.year,
          now.month,
          now.day,
          shouldAutoAdjustForCycle ? 11 : 10,
          0,
        ),
        notificationMode: null,
      ),
    );
  }

  if (profileSettings.quranReminders) {
    items.add(
      ReminderPlanItem(
        id: shouldAutoAdjustForCycle ? 'quran.daily.cycle' : 'quran.daily',
        kind: ReminderKind.quran,
        prayerId: null,
        when: DateTime(
          now.year,
          now.month,
          now.day,
          shouldAutoAdjustForCycle ? 20 : 20,
          shouldAutoAdjustForCycle ? 0 : 30,
        ),
        notificationMode: null,
      ),
    );
  }

  if (profileSettings.reflectionReminders) {
    items.add(
      ReminderPlanItem(
        id: shouldAutoAdjustForCycle
            ? 'reflection.daily.cycle'
            : 'reflection.daily',
        kind: ReminderKind.reflection,
        prayerId: null,
        when: DateTime(
          now.year,
          now.month,
          now.day,
          shouldAutoAdjustForCycle ? 21 : 21,
          shouldAutoAdjustForCycle ? 30 : 0,
        ),
        notificationMode: null,
      ),
    );
  }

  if (profileSettings.fastingReminders && !shouldAutoAdjustForCycle) {
    final fajr = schedule
        .where((item) => item.id == 'fajr')
        .map((item) => item.offerDateTime)
        .firstOrNull;
    final time =
        fajr?.subtract(const Duration(minutes: 40)) ??
        DateTime(now.year, now.month, now.day, 4, 30);
    items.add(
      ReminderPlanItem(
        id: 'fasting.daily',
        kind: ReminderKind.fasting,
        prayerId: null,
        when: time,
        notificationMode: null,
      ),
    );
  }

  if (shouldAutoAdjustForCycle &&
      sisterCycle.sendPurityCheckReminder &&
      sisterCycle.startedAtIso != null) {
    final startedAt = DateTime.tryParse(sisterCycle.startedAtIso!);
    if (startedAt != null) {
      final checkAt = DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day,
      ).add(Duration(days: sisterCycle.expectedDurationDays, hours: 9));
      items.add(
        ReminderPlanItem(
          id: 'cycle.check',
          kind: ReminderKind.cycleCheck,
          prayerId: null,
          when: checkAt,
          notificationMode: null,
        ),
      );
    }
  }

  final sorted = [...items]..sort((a, b) => a.when.compareTo(b.when));

  return ReminderSchedulerState(dayKey: dayKey, items: sorted);
});

DateTime _effectiveReminderTime({
  required PrayerScheduleItem prayer,
  required PrayerPreferences settings,
}) {
  final isFriday = prayer.offerDateTime.weekday == DateTime.friday;
  if (prayer.id == 'dhuhr' &&
      isFriday &&
      settings.jumuahOverrideEnabled &&
      settings.fridayReminderMode == FridayReminderMode.customJumuah &&
      settings.jumuahTimeMinutes != null) {
    final minutes = settings.jumuahTimeMinutes!;
    return DateTime(
      prayer.offerDateTime.year,
      prayer.offerDateTime.month,
      prayer.offerDateTime.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }
  return prayer.offerDateTime;
}

final reminderSchedulerBootstrapProvider = Provider<void>((ref) {
  final service = ref.read(localNotificationServiceProvider);
  final store = ref.read(localStoreProvider);
  Future<void> syncReminders() async {
    final plan = ref.read(reminderSchedulerProvider);
    final prayerState = ref.read(prayerSettingsProvider);
    await store.setJsonList(
      'reminders.plan.${plan.dayKey}',
      plan.items
          .map(
            (e) => {
              'id': e.id,
              'kind': e.kind.name,
              'prayerId': e.prayerId,
              'when': e.when.toIso8601String(),
              'notificationMode': e.notificationMode?.name,
            },
          )
          .toList(),
    );
    await service.syncWithPlan(plan, adhanSettings: prayerState.adhanSettings);
  }

  ref.listen<ReminderSchedulerState>(reminderSchedulerProvider, (_, nextPlan) {
    Future<void>.microtask(syncReminders);
  }, fireImmediately: true);
  ref.listen<PrayerSettingsState>(prayerSettingsProvider, (_, nextSettings) {
    Future<void>.microtask(syncReminders);
  });
});
