import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/features/profile/application/profile_settings_provider.dart';
import 'package:path_of_nur/features/watch_companion/application/watch_sync_contract.dart';
import 'package:path_of_nur/features/watch_companion/application/watch_sync_validation.dart';
import 'package:path_of_nur/features/worship/data/prayer_log_repository.dart';
import 'package:path_of_nur/features/worship/domain/prayer_name.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/core/prayer/prayer_preferences.dart';
import 'package:path_of_nur/core/theme/app_theme.dart';

import 'watch_sync_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const permissionChannel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );
  const geolocatorChannel = MethodChannel('flutter.baseflow.com/geolocator');

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, (call) async {
          switch (call.method) {
            case 'checkPermissionStatus':
              return 1;
            case 'requestPermissions':
              return <int, int>{};
            case 'shouldShowRequestPermissionRationale':
              return false;
          }
          return null;
        });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(geolocatorChannel, (call) async {
          switch (call.method) {
            case 'isLocationServiceEnabled':
              return true;
            case 'checkPermission':
            case 'requestPermission':
              return 1;
            case 'getCurrentPosition':
              return <String, double>{
                'latitude': 43.6532,
                'longitude': -79.3832,
                'accuracy': 5,
                'altitude': 0,
                'heading': 0,
                'speed': 0,
                'speed_accuracy': 0,
              };
            case 'getLastKnownPosition':
              return <String, double>{
                'latitude': 43.6532,
                'longitude': -79.3832,
                'accuracy': 5,
                'altitude': 0,
                'heading': 0,
                'speed': 0,
                'speed_accuracy': 0,
              };
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(geolocatorChannel, null);
  });

  Future<ProviderContainer> makeContainer() async {
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('watch snapshot fixture validates cleanly', () {
    final issues = validateWatchDailySnapshot(buildWatchSnapshotFixture());
    expect(issues, isEmpty);
  });

  test('watch action envelope rejects malformed payload', () {
    final action = WatchActionEnvelope.fromJson(<String, dynamic>{
      'actionId': 'bad-1',
      'deviceType': 'apple_watch',
      'actionType': 'prayer_complete',
      'createdAt': '2026-03-14T13:11:00',
      'logicalDate': 'not-a-date',
      'payload': const <String, dynamic>{},
    });
    expect(action, isNotNull);
    final issues = validateWatchActionEnvelope(action!);
    expect(issues, isNotEmpty);
  });

  test('settings snapshot builder reflects disabled defaults safely', () async {
    final container = await makeContainer();
    final settings = container
        .read(watchSettingsSnapshotBuilderProvider)
        .build();

    expect(settings.prayerNotificationsEnabled, isFalse);
    expect(settings.enabledPrayerIds, isEmpty);
    expect(settings.followUpReminderEnabled, isFalse);
    expect(settings.dhikrReminderEnabled, isTrue);
    expect(settings.quietModeEnabled, isTrue);
    expect(settings.watchThemeMode, AppThemeMode.noorGlass.name);
    expect(settings.followUpDelayMinutes, 20);
    expect(settings.snoozeDurationMinutes, 10);
    expect(validateSettingsSnapshot(settings), isEmpty);
  });

  test(
    'settings snapshot builder uses phone-derived values where available',
    () async {
      final container = await makeContainer();

      container
          .read(prayerSettingsProvider.notifier)
          .updateNotificationMode(
            'fajr',
            PrayerNotificationMode.notificationOnly,
          );
      container.read(profileSettingsProvider.notifier).setPrayerReminders(true);
      container
          .read(profileSettingsProvider.notifier)
          .setPrayerReminderFollowUpEnabled(false);
      container
          .read(profileSettingsProvider.notifier)
          .setPrayerReminderFollowUpDelayMinutes(35);
      container
          .read(profileSettingsProvider.notifier)
          .setPrayerReminderSnoozeMinutes(12);
      container.read(profileSettingsProvider.notifier).setDhikrReminders(false);
      container
          .read(profileSettingsProvider.notifier)
          .setGentleModeEnabled(false);
      container
          .read(profileSettingsProvider.notifier)
          .setAppThemeMode(AppThemeMode.dark);

      final settings = container
          .read(watchSettingsSnapshotBuilderProvider)
          .build();

      expect(settings.prayerNotificationsEnabled, isTrue);
      expect(settings.enabledPrayerIds, orderedEquals(const ['fajr']));
      expect(settings.followUpReminderEnabled, isFalse);
      expect(settings.followUpDelayMinutes, 35);
      expect(settings.snoozeDurationMinutes, 12);
      expect(settings.dhikrReminderEnabled, isFalse);
      expect(settings.quietModeEnabled, isFalse);
      expect(settings.watchThemeMode, AppThemeMode.dark.name);
      expect(validateSettingsSnapshot(settings), isEmpty);
    },
  );

  test(
    'duplicate prayer completion does not duplicate Ocean Drop reward',
    () async {
      final container = await makeContainer();
      final reconciler = container.read(watchActionReconcilerProvider);

      final first = await reconciler.reconcile(
        buildPrayerCompleteAction(actionId: 'prayer-1'),
      );
      final second = await reconciler.reconcile(
        buildPrayerCompleteAction(actionId: 'prayer-2'),
      );

      expect(first.resultType, WatchAckResultType.applied);
      expect(second.resultType, WatchAckResultType.ignoredDuplicate);
      expect(container.read(oceanDropsProvider).totalLocalDrops, 1);
    },
  );

  test(
    'prayer status update supports late completion and persists timing',
    () async {
      final container = await makeContainer();
      final reconciler = container.read(watchActionReconcilerProvider);

      final ack = await reconciler.reconcile(
        buildPrayerStatusAction(actionId: 'prayer-status-late'),
      );

      expect(ack.resultType, WatchAckResultType.applied);
      expect(
        container
            .read(watchSyncAckServiceProvider)
            .prayerTargetState('2026-03-14|dhuhr')?['status'],
        'completed',
      );
      expect(
        container
            .read(watchSyncAckServiceProvider)
            .prayerTargetState('2026-03-14|dhuhr')?['timing'],
        'late',
      );
    },
  );

  test(
    'duplicate dhikr session completion does not duplicate reward',
    () async {
      final container = await makeContainer();
      final reconciler = container.read(watchActionReconcilerProvider);

      final first = await reconciler.reconcile(
        buildDhikrCompletedAction(actionId: 'dhikr-1', sessionId: 'session-a'),
      );
      final second = await reconciler.reconcile(
        buildDhikrCompletedAction(actionId: 'dhikr-2', sessionId: 'session-a'),
      );

      expect(first.resultType, WatchAckResultType.applied);
      expect(second.resultType, WatchAckResultType.ignoredDuplicate);
      expect(container.read(oceanDropsProvider).totalLocalDrops, 1);
    },
  );

  test(
    'dhikr reconciliation accepts string payload counts from native watch',
    () async {
      final container = await makeContainer();
      final reconciler = container.read(watchActionReconcilerProvider);

      final ack = await reconciler.reconcile(
        WatchActionEnvelope(
          actionId: 'auto-dhikr-native-1',
          deviceType: WatchDeviceType.appleWatch,
          actionType: WatchActionType.dhikrSessionCompleted,
          createdAt: DateTime.parse('2026-03-14T14:05:00'),
          logicalDate: '2026-03-14',
          payload: <String, dynamic>{
            'sessionId': 'auto-session-1',
            'mode': 'auto_alhamdulillah',
            'targetCount': '33',
            'count': '33',
            'intervalSeconds': '2.0',
          },
        ),
      );

      expect(ack.resultType, WatchAckResultType.applied);
      expect(container.read(oceanDropsProvider).totalLocalDrops, 1);
    },
  );

  test(
    'ingestion returns failed validation ack for malformed payload',
    () async {
      final container = await makeContainer();
      final adapter = container.read(appleWatchBridgeAdapterProvider);

      final response = await adapter.ingestActionPayload(<String, dynamic>{
        'actionId': 'bad-action',
        'deviceType': 'apple_watch',
        'actionType': 'dhikr_increment',
        'createdAt': '2026-03-14T14:00:00',
        'logicalDate': '2026-03-14',
        'payload': <String, dynamic>{},
      });

      expect(response['ack']['resultType'], 'failed_validation');
      expect(response['snapshot'], isA<Map<String, dynamic>>());
    },
  );

  test(
    'reconcile persists ack and prayer target state deterministically',
    () async {
      final container = await makeContainer();
      final reconciler = container.read(watchActionReconcilerProvider);
      const actionId = 'same-action-id';

      final ack = await reconciler.reconcile(
        buildPrayerCompleteAction(actionId: actionId),
      );

      final storedAck = container
          .read(watchSyncAckServiceProvider)
          .lookupAck(actionId);
      final targetState = container
          .read(watchSyncAckServiceProvider)
          .prayerTargetState('2026-03-14|dhuhr');

      expect(ack.resultType, WatchAckResultType.applied);
      expect(storedAck?.actionId, actionId);
      expect(targetState?['status'], 'completed');
      expect(container.read(oceanDropsProvider).totalLocalDrops, 1);
    },
  );

  test('dhikr increment deduplicates stale or replayed count safely', () async {
    final container = await makeContainer();
    final reconciler = container.read(watchActionReconcilerProvider);

    final first = await reconciler.reconcile(
      WatchActionEnvelope(
        actionId: 'dhikr-inc-1',
        deviceType: WatchDeviceType.appleWatch,
        actionType: WatchActionType.dhikrIncrement,
        createdAt: DateTime.parse('2026-03-14T14:00:00'),
        logicalDate: '2026-03-14',
        payload: const <String, dynamic>{
          'sessionId': 'session-increment',
          'mode': 'free',
          'count': 10,
        },
      ),
    );
    final second = await reconciler.reconcile(
      WatchActionEnvelope(
        actionId: 'dhikr-inc-2',
        deviceType: WatchDeviceType.appleWatch,
        actionType: WatchActionType.dhikrIncrement,
        createdAt: DateTime.parse('2026-03-14T14:01:00'),
        logicalDate: '2026-03-14',
        payload: const <String, dynamic>{
          'sessionId': 'session-increment',
          'mode': 'free',
          'count': 10,
        },
      ),
    );

    expect(first.resultType, WatchAckResultType.applied);
    expect(second.resultType, WatchAckResultType.ignoredDuplicate);
    expect(
      container
          .read(watchSyncAckServiceProvider)
          .dhikrSession('session-increment')?['currentCount'],
      10,
    );
  });

  test(
    'older prayer action is ignored as stale and does not roll state back',
    () async {
      final container = await makeContainer();
      final reconciler = container.read(watchActionReconcilerProvider);

      final first = await reconciler.reconcile(
        buildPrayerCompleteAction(actionId: 'prayer-newer'),
      );
      final second = await reconciler.reconcile(
        WatchActionEnvelope(
          actionId: 'prayer-older',
          deviceType: WatchDeviceType.appleWatch,
          actionType: WatchActionType.prayerUncomplete,
          createdAt: DateTime.parse('2026-03-14T12:59:00'),
          logicalDate: '2026-03-14',
          payload: const <String, dynamic>{'prayerId': 'dhuhr'},
        ),
      );

      expect(first.resultType, WatchAckResultType.applied);
      expect(second.resultType, WatchAckResultType.ignoredStale);
      expect(
        container
            .read(watchSyncAckServiceProvider)
            .prayerTargetState('2026-03-14|dhuhr')?['status'],
        'completed',
      );
    },
  );

  test('stale action rejection leaves persisted prayer state stable', () async {
    final container = await makeContainer();
    final reconciler = container.read(watchActionReconcilerProvider);

    await reconciler.reconcile(
      buildPrayerCompleteAction(actionId: 'latest-prayer'),
    );
    await reconciler.reconcile(
      WatchActionEnvelope(
        actionId: 'stale-prayer',
        deviceType: WatchDeviceType.appleWatch,
        actionType: WatchActionType.prayerUncomplete,
        createdAt: DateTime.parse('2026-03-14T12:59:00'),
        logicalDate: '2026-03-14',
        payload: const <String, dynamic>{'prayerId': 'dhuhr'},
      ),
    );

    final record = container
        .read(prayerLogRepositoryProvider)
        .readDayEntries('2026-03-14')[PrayerName.dhuhr];
    expect(record?.status.name, 'completed');
  });

  test(
    'watch reconciliation stays profile-scoped across profile switches',
    () async {
      final container = await makeContainer();
      final accounts = container.read(accountsSyncControllerProvider.notifier);
      final reconciler = container.read(watchActionReconcilerProvider);

      await accounts.addAccount(
        provider: AccountProviderType.localOnly,
        identifier: 'owner',
        displayName: 'Owner',
      );
      await accounts.createProfile(
        displayName: 'Profile A',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.localOnly,
        avatar: 'A',
      );
      final profileA = container
          .read(accountsSyncControllerProvider)
          .activeProfileId!;
      await reconciler.reconcile(
        buildPrayerCompleteAction(actionId: 'profile-a-prayer'),
      );
      final recordA = container
          .read(prayerLogRepositoryProvider)
          .readDayEntries('2026-03-14')[PrayerName.dhuhr];

      await accounts.createProfile(
        displayName: 'Profile B',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.localOnly,
        avatar: 'B',
      );
      final recordB = container
          .read(prayerLogRepositoryProvider)
          .readDayEntries('2026-03-14')[PrayerName.dhuhr];

      await accounts.switchProfile(profileA);
      final recordAReturn = container
          .read(prayerLogRepositoryProvider)
          .readDayEntries('2026-03-14')[PrayerName.dhuhr];

      expect(recordA?.status.name, 'completed');
      expect(recordB, isNull);
      expect(recordAReturn?.status.name, 'completed');
    },
  );
}
