import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/features/watch_companion/application/watch_sync_contract.dart';
import 'package:path_of_nur/features/watch_companion/application/watch_sync_validation.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import 'watch_sync_fixtures.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
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

  test('settings snapshot builder provides safe defaults', () async {
    final container = await makeContainer();
    final settings = container.read(watchSettingsSnapshotBuilderProvider).build();

    expect(settings.prayerNotificationsEnabled, isTrue);
    expect(
      settings.enabledPrayerIds,
      orderedEquals(const ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha']),
    );
    expect(settings.followUpDelayMinutes, 20);
    expect(settings.snoozeDurationMinutes, 10);
  });

  test('duplicate prayer completion does not duplicate Ocean Drop reward', () async {
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
    expect(container.read(oceanDropServiceProvider).getDropsToday(), 1);
  });

  test('duplicate dhikr session completion does not duplicate reward', () async {
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
    expect(container.read(oceanDropServiceProvider).getDropsToday(), 1);
  });

  test('ingestion returns failed validation ack for malformed payload', () async {
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

    expect(
      response['ack']['resultType'],
      'failed_validation',
    );
    expect(response['snapshot'], isA<Map<String, dynamic>>());
  });
}
