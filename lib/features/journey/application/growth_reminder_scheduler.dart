import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/reminders/local_notification_service.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';
import 'growth_models.dart';
import 'growth_providers.dart';

final growthReminderPlanProvider = Provider<List<GrowthNotificationRequest>>((
  ref,
) {
  final state = ref.watch(growthControllerProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final schedule = ref.watch(prayerScheduleProvider);
  final habits = ref.watch(growthAllHabitsProvider);
  final dayLogs = state.habitLogsByDay[LocalStore.todayKey(today)] ?? const {};
  final habitContentById = ref.watch(growthHabitContentByIdProvider);
  final encouragement = ref.watch(growthEncouragementCopyProvider);

  if (!state.globalReminderSettings.remindersEnabled ||
      state.globalReminderSettings.pauseAllReminders) {
    return const [];
  }

  final reminders = <GrowthNotificationRequest>[];
  for (final habit in habits) {
    if (!_isEligibleForReminder(habit)) continue;
    if (habit.reminderDays.isNotEmpty &&
        !habit.reminderDays.contains(today.weekday)) {
      continue;
    }
    if (!isHabitDueOnDate(habit, today, state)) continue;
    final log = dayLogs[habit.id];
    if (log?.status == GrowthHabitStatus.completed && log!.progress >= 0.99) {
      continue;
    }

    final reminderAt = _resolveReminderTime(
      habit: habit,
      onDate: today,
      prayerSchedule: schedule,
    );
    if (reminderAt == null || !reminderAt.isAfter(now)) continue;

    final defaultBody =
        habitContentById[habit.id]?.reminderCopy ??
        encouragement.gentleReminders[(today.day +
                today.month +
                habit.id.length) %
            encouragement.gentleReminders.length];
    reminders.add(
      GrowthNotificationRequest(
        id: 'growth.${habit.id}.${LocalStore.todayKey(today)}.${habit.reminderMode.name}',
        habitId: habit.id,
        when: reminderAt,
        title: 'A gentle reminder for your path',
        body: habit.reminderMessageOverride?.trim().isNotEmpty == true
            ? habit.reminderMessageOverride!.trim()
            : defaultBody,
        quietDelivery:
            state.globalReminderSettings.quietDelivery || habit.quietDelivery,
      ),
    );
  }
  reminders.sort((a, b) => a.when.compareTo(b.when));
  return reminders;
});

final growthReminderBootstrapProvider = Provider<void>((ref) {
  final service = ref.read(localNotificationServiceProvider);
  final store = ref.read(localStoreProvider);

  ref.listen<List<GrowthNotificationRequest>>(growthReminderPlanProvider, (
    _,
    reminders,
  ) {
    Future<void>.microtask(() async {
      final now = ref.read(dailyNowProvider).value ?? DateTime.now();
      final dayKey = LocalStore.todayKey(now);
      final settings = ref
          .read(growthControllerProvider)
          .globalReminderSettings;
      await store.setJsonList(
        'growth.reminders.plan.$dayKey',
        reminders
            .map(
              (item) => {
                'id': item.id,
                'habitId': item.habitId,
                'when': item.when.toIso8601String(),
                'title': item.title,
                'body': item.body,
                'quietDelivery': item.quietDelivery,
              },
            )
            .toList(),
      );
      await service.syncGrowthReminders(
        reminders: reminders,
        pauseAll: !settings.remindersEnabled || settings.pauseAllReminders,
      );
    });
  }, fireImmediately: true);
});

bool _isEligibleForReminder(GrowthHabit habit) {
  if (!habit.reminderEnabled) return false;
  if (!habit.active || habit.paused || habit.archived) return false;
  if (habit.hidden || habit.muted || habit.remindersPaused) return false;
  if (!habit.showInToday) return false;
  return true;
}

DateTime? _resolveReminderTime({
  required GrowthHabit habit,
  required DateTime onDate,
  required List<PrayerScheduleItem> prayerSchedule,
}) {
  switch (habit.reminderMode) {
    case GrowthReminderMode.fixedTime:
      return _atMinutes(onDate, habit.reminderTimeMinutes);
    case GrowthReminderMode.prayerLinked:
      final prayerId = switch (habit.reminderPrayerAnchor) {
        GrowthReminderPrayerAnchor.fajr => 'fajr',
        GrowthReminderPrayerAnchor.dhuhr => 'dhuhr',
        GrowthReminderPrayerAnchor.asr => 'asr',
        GrowthReminderPrayerAnchor.maghrib => 'maghrib',
        GrowthReminderPrayerAnchor.isha => 'isha',
        null => null,
      };
      if (prayerId == null) return null;
      final prayer = prayerSchedule
          .where((item) => item.id == prayerId)
          .firstOrNull;
      if (prayer == null) return null;
      return prayer.offerDateTime.add(
        Duration(minutes: habit.reminderOffsetMinutes),
      );
    case GrowthReminderMode.timeWindow:
      return _timeForWindow(onDate, habit.reminderWindowType);
    case GrowthReminderMode.gentleSuggestion:
      return _gentleSuggestionTime(onDate, habit, prayerSchedule);
  }
}

DateTime _atMinutes(DateTime date, int totalMinutes) {
  final normalized = totalMinutes.clamp(0, 1439);
  final hour = normalized ~/ 60;
  final minute = normalized % 60;
  return DateTime(date.year, date.month, date.day, hour, minute);
}

DateTime _timeForWindow(DateTime date, GrowthReminderWindowType? window) {
  final weekday = date.weekday;
  switch (window ?? GrowthReminderWindowType.evening) {
    case GrowthReminderWindowType.earlyMorning:
      return DateTime(date.year, date.month, date.day, 5, 40);
    case GrowthReminderWindowType.morning:
      return DateTime(date.year, date.month, date.day, 8, 0);
    case GrowthReminderWindowType.midday:
      return DateTime(date.year, date.month, date.day, 12, 30);
    case GrowthReminderWindowType.afternoon:
      return DateTime(date.year, date.month, date.day, 15, 45);
    case GrowthReminderWindowType.evening:
      return DateTime(date.year, date.month, date.day, 18, 45);
    case GrowthReminderWindowType.night:
      return DateTime(date.year, date.month, date.day, 21, 0);
    case GrowthReminderWindowType.beforeSleep:
      return DateTime(date.year, date.month, date.day, 22, 15);
    case GrowthReminderWindowType.fridayMorning:
      final daysToFriday = (DateTime.friday - weekday) % 7;
      final friday = date.add(Duration(days: daysToFriday));
      return DateTime(friday.year, friday.month, friday.day, 10, 0);
    case GrowthReminderWindowType.fridayAfternoon:
      final daysToFriday = (DateTime.friday - weekday) % 7;
      final friday = date.add(Duration(days: daysToFriday));
      return DateTime(friday.year, friday.month, friday.day, 15, 30);
    case GrowthReminderWindowType.weekend:
      final daysToSaturday = (DateTime.saturday - weekday) % 7;
      final saturday = date.add(Duration(days: daysToSaturday));
      return DateTime(saturday.year, saturday.month, saturday.day, 10, 30);
  }
}

DateTime _gentleSuggestionTime(
  DateTime date,
  GrowthHabit habit,
  List<PrayerScheduleItem> schedule,
) {
  if (habit.id == 'h_morning_adhkar') {
    final fajr = schedule.where((item) => item.id == 'fajr').firstOrNull;
    if (fajr != null)
      return fajr.offerDateTime.add(const Duration(minutes: 15));
  }
  if (habit.id == 'h_evening_adhkar') {
    final maghrib = schedule.where((item) => item.id == 'maghrib').firstOrNull;
    if (maghrib != null)
      return maghrib.offerDateTime.add(const Duration(minutes: 20));
  }
  if (habit.id == 'h_day_end_reflection') {
    return DateTime(date.year, date.month, date.day, 22, 0);
  }
  if (habit.id == 'h_read_quran') {
    final fajr = schedule.where((item) => item.id == 'fajr').firstOrNull;
    if (fajr != null)
      return fajr.offerDateTime.add(const Duration(minutes: 35));
    return DateTime(date.year, date.month, date.day, 19, 45);
  }
  return _timeForWindow(date, GrowthReminderWindowType.evening);
}
