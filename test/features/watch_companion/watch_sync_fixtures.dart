import 'package:path_of_nur/features/watch_companion/application/watch_sync_contract.dart';

final watchPrayerFixture = <WatchPrayerStatusContract>[
  WatchPrayerStatusContract(
    prayerId: 'fajr',
    displayName: 'Fajr',
    scheduledTime: DateTime.parse('2026-03-14T05:10:00'),
    status: 'completed',
    completedAt: DateTime.parse('2026-03-14T05:12:00'),
    source: 'phone',
  ),
  WatchPrayerStatusContract(
    prayerId: 'dhuhr',
    displayName: 'Dhuhr',
    scheduledTime: DateTime.parse('2026-03-14T13:10:00'),
    status: 'pending',
    completedAt: null,
    source: 'phone',
  ),
  WatchPrayerStatusContract(
    prayerId: 'asr',
    displayName: 'Asr',
    scheduledTime: DateTime.parse('2026-03-14T16:42:00'),
    status: 'pending',
    completedAt: null,
    source: 'phone',
  ),
  WatchPrayerStatusContract(
    prayerId: 'maghrib',
    displayName: 'Maghrib',
    scheduledTime: DateTime.parse('2026-03-14T19:18:00'),
    status: 'pending',
    completedAt: null,
    source: 'phone',
  ),
  WatchPrayerStatusContract(
    prayerId: 'isha',
    displayName: 'Isha',
    scheduledTime: DateTime.parse('2026-03-14T20:47:00'),
    status: 'pending',
    completedAt: null,
    source: 'phone',
  ),
];

WatchDailySnapshot buildWatchSnapshotFixture() {
  return WatchDailySnapshot(
    snapshotId: 'fixture-snapshot',
    generatedAt: DateTime.parse('2026-03-14T10:00:00'),
    date: '2026-03-14',
    timezone: 'America/Toronto',
    nextPrayerId: 'dhuhr',
    nextPrayerTime: DateTime.parse('2026-03-14T13:10:00'),
    currentPrayerId: 'fajr',
    completedPrayerCount: 1,
    totalPrayerCount: 5,
    dhikrTodayCount: 64,
    xpToday: 24,
    oceanDropsToday: 1,
    streakDays: 12,
    prayers: watchPrayerFixture,
    activeDhikrSession: WatchDhikrSessionSnapshot(
      sessionId: 'session-1',
      mode: 'preset_33',
      targetCount: 33,
      currentCount: 12,
      startedAt: DateTime.parse('2026-03-14T09:50:00'),
      updatedAt: DateTime.parse('2026-03-14T09:55:00'),
      completed: false,
      rewardEligible: false,
      source: 'phone',
    ),
    lastSyncAt: DateTime.parse('2026-03-14T09:58:00'),
    sourceVersion: '1',
  );
}

WatchSettingsSnapshot buildWatchSettingsFixture() {
  return WatchSettingsSnapshot(
    prayerNotificationsEnabled: true,
    enabledPrayerIds: const ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'],
    followUpReminderEnabled: true,
    followUpDelayMinutes: 20,
    snoozeDurationMinutes: 10,
    dhikrReminderEnabled: false,
    quietModeEnabled: false,
    watchThemeMode: null,
    lastUpdatedAt: DateTime.parse('2026-03-14T09:58:00'),
  );
}

WatchActionEnvelope buildPrayerCompleteAction({
  String actionId = 'action-prayer-1',
  String logicalDate = '2026-03-14',
}) {
  return WatchActionEnvelope(
    actionId: actionId,
    deviceType: WatchDeviceType.appleWatch,
    actionType: WatchActionType.prayerComplete,
    createdAt: DateTime.parse('2026-03-14T13:11:00'),
    logicalDate: logicalDate,
    payload: const {'prayerId': 'dhuhr'},
  );
}

WatchActionEnvelope buildDhikrCompletedAction({
  String actionId = 'action-dhikr-1',
  String sessionId = 'watch-session-1',
}) {
  return WatchActionEnvelope(
    actionId: actionId,
    deviceType: WatchDeviceType.wearOs,
    actionType: WatchActionType.dhikrSessionCompleted,
    createdAt: DateTime.parse('2026-03-14T14:00:00'),
    logicalDate: '2026-03-14',
    payload: {
      'sessionId': sessionId,
      'mode': 'preset_33',
      'targetCount': 33,
      'count': 33,
    },
  );
}
