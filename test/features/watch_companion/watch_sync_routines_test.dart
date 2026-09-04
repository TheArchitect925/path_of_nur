import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/watch_companion/application/watch_sync_contract.dart';
import 'package:path_of_nur/features/watch_companion/application/watch_sync_validation.dart';
import 'package:path_of_nur/features/worship/application/dhikr_controller.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_catalog.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_day_total.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const permissionChannel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );
  const geolocatorChannel = MethodChannel('flutter.baseflow.com/geolocator');

  // Registered once for the whole file and never removed: the prayer
  // location notifier keeps refreshing asynchronously after a test ends,
  // and a per-test teardown would leave those late calls without a mock.
  setUpAll(() {
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

  Future<ProviderContainer> makeContainer() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'app.onboardingCompleted': true,
    });
    final prefs = await SharedPreferences.getInstance();
    // Not disposed on purpose: the prayer location notifier the snapshot
    // builder wakes up refreshes asynchronously and would throw after a
    // teardown dispose, exactly as in watch_sync_contract_test.
    return ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
  }

  WatchActionEnvelope routineAction({
    required String actionId,
    String routineId = kDhikrRoutineAfterSalahId,
    String startedAt = '2026-03-14T14:00:00',
    String createdAt = '2026-03-14T14:03:40',
    Map<String, dynamic> extra = const <String, dynamic>{},
  }) {
    return WatchActionEnvelope(
      actionId: actionId,
      deviceType: WatchDeviceType.appleWatch,
      actionType: WatchActionType.dhikrRoutineCompleted,
      createdAt: DateTime.parse(createdAt),
      logicalDate: '2026-03-14',
      payload: <String, dynamic>{
        'routineId': routineId,
        'routineLabel': 'After-salah tasbih',
        'count': '100',
        'startedAt': startedAt,
        'prayerId': 'asr',
        ...extra,
      },
    );
  }

  test(
    'snapshot lists routines with steps and marks today\'s completions',
    () async {
      final container = await makeContainer();
      final snapshot = container
          .read(watchDailySnapshotBuilderProvider)
          .build();
      final routines = snapshot.dhikrRoutines;
      expect(
        routines.map((routine) => routine.id),
        contains(kDhikrRoutineAfterSalahId),
      );
      final afterSalah = routines.firstWhere(
        (routine) => routine.id == kDhikrRoutineAfterSalahId,
      );
      expect(afterSalah.kind, 'afterSalah');
      expect(afterSalah.totalCount, 100);
      expect(afterSalah.steps.map((step) => step.count), [33, 33, 33, 1]);
      expect(afterSalah.steps.first.arabic, isNotEmpty);
      expect(afterSalah.sessionLabel, 'After-salah tasbih');
      expect(snapshot.completedRoutineEntriesToday, isEmpty);
      expect(validateWatchDailySnapshot(snapshot), isEmpty);

      final json = snapshot.toJson();
      expect(json['dhikrRoutines'], isA<List<dynamic>>());
      expect(json['completedRoutineEntriesToday'], isA<List<dynamic>>());
    },
  );

  test('a routine finished on the watch is logged once on the phone', () async {
    final container = await makeContainer();
    final reconciler = container.read(watchActionReconcilerProvider);

    final action = routineAction(actionId: 'routine-1');
    expect(validateWatchActionEnvelope(action), isEmpty);

    final first = await reconciler.reconcile(action);
    expect(first.resultType, WatchAckResultType.applied);

    final dhikr = container.read(dhikrControllerProvider);
    expect(dhikr.recentSessions, hasLength(1));
    expect(dhikr.recentSessions.single.phraseLabel, 'After-salah tasbih');
    expect(dhikr.recentSessions.single.count, 100);
    expect(
      dhikr.recentSessions.single.duration,
      const Duration(minutes: 3, seconds: 40),
    );
    final day = dhikr.dailyTotals[dhikrDayKey(DateTime.parse('2026-03-14'))];
    expect(day?.count, 100);
    expect(day?.routineEntries, ['after-salah:asr']);

    final replay = await reconciler.reconcile(
      routineAction(actionId: 'routine-2'),
    );
    expect(replay.resultType, WatchAckResultType.ignoredDuplicate);
    expect(
      container.read(dhikrControllerProvider).recentSessions,
      hasLength(1),
    );

    final snapshot = container.read(watchDailySnapshotBuilderProvider).build();
    expect(
      snapshot.completedRoutineEntriesToday,
      isEmpty,
      reason: 'the fixture day is not today; today has no completions',
    );
  });

  test(
    'a custom routine the phone no longer knows still logs by label',
    () async {
      final container = await makeContainer();
      final reconciler = container.read(watchActionReconcilerProvider);
      final ack = await reconciler.reconcile(
        routineAction(
          actionId: 'routine-custom-1',
          routineId: 'custom-abc',
          extra: <String, dynamic>{
            'routineLabel': 'Walk home',
            'count': '10',
            'prayerId': '',
          },
        ),
      );
      expect(ack.resultType, WatchAckResultType.applied);
      final dhikr = container.read(dhikrControllerProvider);
      expect(dhikr.recentSessions.single.phraseLabel, 'Walk home');
      expect(dhikr.recentSessions.single.count, 10);
      expect(
        dhikr
            .dailyTotals[dhikrDayKey(DateTime.parse('2026-03-14'))]
            ?.routineEntries,
        ['custom-abc'],
      );
    },
  );

  test('a routine action without id or count fails validation', () async {
    final container = await makeContainer();
    final reconciler = container.read(watchActionReconcilerProvider);
    final bad = routineAction(
      actionId: 'routine-bad',
      extra: <String, dynamic>{'routineId': '', 'count': '0'},
    );
    expect(validateWatchActionEnvelope(bad), isNotEmpty);
    final ack = await reconciler.reconcile(bad);
    expect(ack.resultType, WatchAckResultType.failedValidation);
  });
}
