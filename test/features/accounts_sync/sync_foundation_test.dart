import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/accounts_sync/application/sync_foundation.dart';
import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/features/worship/application/prayer_controller.dart';
import 'package:path_of_nur/features/worship/data/dhikr_repository.dart';
import 'package:path_of_nur/features/worship/data/prayer_log_repository.dart';
import 'package:path_of_nur/features/worship/domain/daily_prayer_record.dart';
import 'package:path_of_nur/features/worship/domain/prayer_name.dart';
import 'package:path_of_nur/features/worship/domain/prayer_status.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeSyncTransport extends SyncTransport {
  const _FakeSyncTransport({
    this.inboundChanges = const <SyncInboundChange>[],
  });

  final List<SyncInboundChange> inboundChanges;

  @override
  Future<SyncTransportResponse> sync(SyncTransportRequest request) async {
    return SyncTransportResponse(
      online: true,
      acceptedDedupKeys: request.outboxEntries.map((entry) => entry.dedupKey).toList(),
      inboundChanges: inboundChanges
          .map(
            (change) => SyncInboundChange(
              scopeId: request.scopeId,
              domain: change.domain,
              entityKey: change.entityKey,
              payload: change.payload,
              changedAtIso: change.changedAtIso,
              deviceId: change.deviceId,
              revision: change.revision,
              dedupKey: change.dedupKey,
            ),
          )
          .toList(growable: false),
      nextCursor: 'cursor-1',
    );
  }
}

class _FlakySyncTransport extends SyncTransport {
  _FlakySyncTransport();

  int attempts = 0;

  @override
  Future<SyncTransportResponse> sync(SyncTransportRequest request) async {
    attempts += 1;
    if (attempts == 1) {
      return const SyncTransportResponse(
        online: false,
        acceptedDedupKeys: <String>[],
        inboundChanges: <SyncInboundChange>[],
        errorMessage: 'Temporary failure',
        statusCode: 'transport_error',
        transportLabel: 'Fake cloud',
      );
    }
    return SyncTransportResponse(
      online: true,
      acceptedDedupKeys: request.outboxEntries.map((entry) => entry.dedupKey).toList(),
      inboundChanges: const <SyncInboundChange>[],
      nextCursor: 'cursor-2',
      statusCode: 'ok',
      transportLabel: 'Fake cloud',
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ICloudSyncTransport.channel, null);
  });

  test('auth state supports unauthenticated, local-only, and authenticated sessions', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    expect(container.read(authStateProvider).status, AuthStatus.unauthenticated);

    await container.read(accountsSyncControllerProvider.notifier).addAccount(
          provider: AccountProviderType.localOnly,
          identifier: 'local-user',
          displayName: 'Local User',
        );
    expect(container.read(authStateProvider).status, AuthStatus.localOnly);

    await container.read(accountsSyncControllerProvider.notifier).addAccount(
          provider: AccountProviderType.google,
          identifier: 'user@example.com',
          displayName: 'Signed In User',
          syncMode: ProfileSyncMode.pathOfNurCloud,
        );
    expect(container.read(authStateProvider).status, AuthStatus.authenticated);
    expect(container.read(authStateProvider).session?.account?.provider, AccountProviderType.google);
  });

  test('device identity is stable across containers sharing the same preferences', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{'app.onboardingCompleted': true});
    final prefs = await SharedPreferences.getInstance();
    final dbA = AppDatabase.inMemory();
    final dbB = AppDatabase.inMemory();
    addTearDown(dbA.close);
    addTearDown(dbB.close);

    final containerA = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDatabaseProvider.overrideWithValue(dbA),
    ]);
    final containerB = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDatabaseProvider.overrideWithValue(dbB),
    ]);
    addTearDown(containerA.dispose);
    addTearDown(containerB.dispose);

    final idA = containerA.read(deviceIdentityProvider).deviceId;
    final idB = containerB.read(deviceIdentityProvider).deviceId;

    expect(idA, isNotEmpty);
    expect(idA, idB);
  });

  test('prayer writes enqueue a deduplicated sync outbox record', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.addAccount(
      provider: AccountProviderType.google,
      identifier: 'person@example.com',
      displayName: 'Person',
      syncMode: ProfileSyncMode.pathOfNurCloud,
    );
    await controller.createProfile(
      displayName: 'Traveler',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.pathOfNurCloud,
      avatar: 'T',
    );
    final scopeId = container.read(accountsSyncControllerProvider).activeProfileId!;

    final notifier = container.read(prayerControllerProvider.notifier);
    notifier.cycleStatus(PrayerName.fajr);
    notifier.cycleStatus(PrayerName.fajr);

    final entries = container.read(syncOutboxRepositoryProvider).pendingEntries(scopeId);
    expect(entries.where((entry) => entry.domain == syncDomainPrayerLog), hasLength(1));
  });

  test('sync manager uploads outbox and applies newer remote prayer changes deterministically', () async {
    final dayKey = LocalStore.todayKey();
    final remoteUpdatedAt = DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
    final container = await makeTestContainer(
      overrides: [
        cloudSyncTransportProvider.overrideWithValue(
          _FakeSyncTransport(
            inboundChanges: [
              SyncInboundChange(
                scopeId: 'profile_pending_override',
                domain: syncDomainPrayerLog,
                entityKey: dayKey,
                changedAtIso: remoteUpdatedAt,
                deviceId: 'remote-device',
                revision: 'rev-1',
                payload: {
                  'dayKey': dayKey,
                  'updatedAtIso': remoteUpdatedAt,
                  'records': [
                    {
                      'prayer': PrayerName.fajr.name,
                      'status': PrayerStatus.missed.name,
                      'completedAtIso': null,
                      'updatedAtIso': remoteUpdatedAt,
                    },
                  ],
                },
              ),
            ],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.addAccount(
      provider: AccountProviderType.google,
      identifier: 'cloud@example.com',
      displayName: 'Cloud',
      syncMode: ProfileSyncMode.pathOfNurCloud,
    );
    await controller.createProfile(
      displayName: 'Cloud Profile',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.pathOfNurCloud,
      avatar: 'C',
    );
    final scopeId = container.read(accountsSyncControllerProvider).activeProfileId!;

    container.read(prayerControllerProvider.notifier).cycleStatus(PrayerName.fajr);
    final pending = container.read(syncOutboxRepositoryProvider).pendingEntries(scopeId);
    expect(pending, isNotEmpty);

    final report = await container.read(syncEngineProvider).syncScope(
          scopeId: scopeId,
          accountId: container.read(accountsSyncControllerProvider).activeAccountId,
          deviceId: container.read(deviceIdentityProvider).deviceId,
          syncModeName: ProfileSyncMode.pathOfNurCloud.name,
        );
    await container.read(accountsSyncControllerProvider.notifier).applySyncReport(
          report,
          reloadScope: report.appliedInboundCount > 0,
        );

    final record = container
        .read(prayerLogRepositoryProvider)
        .readDayEntries(dayKey)[PrayerName.fajr];
    expect(record?.status, PrayerStatus.missed);
    expect(container.read(syncOutboxRepositoryProvider).pendingCount(scopeId), 0);
  });

  test('dhikr session replay is deduplicated by session id', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final resolver = SyncConflictResolver(database);
    final sessionPayload = {
      'sessions': [
        {
          'sessionId': 'session-1',
          'phraseLabel': 'SubhanAllah',
          'count': 33,
          'target': 33,
          'startedAtIso': '2026-03-14T09:00:00.000',
          'finishedAtIso': '2026-03-14T09:02:00.000',
        },
      ],
    };

    final first = resolver.applyInboundChanges([
      SyncInboundChange(
        scopeId: 'profile-a',
        domain: syncDomainDhikrSessions,
        entityKey: 'recent',
        payload: sessionPayload,
        changedAtIso: '2026-03-14T09:02:00.000',
        deviceId: 'remote-1',
        revision: '1',
      ),
    ]);
    final second = resolver.applyInboundChanges([
      SyncInboundChange(
        scopeId: 'profile-a',
        domain: syncDomainDhikrSessions,
        entityKey: 'recent',
        payload: sessionPayload,
        changedAtIso: '2026-03-14T09:02:00.000',
        deviceId: 'remote-1',
        revision: '2',
      ),
    ]);

    final repository = DhikrRepository(
      database: database,
      legacyStore: LocalStore(await SharedPreferences.getInstance()),
      scopeId: 'profile-a',
    );
    expect(first, 1);
    expect(second, 0);
    expect(repository.load().recentSessions, hasLength(1));
  });

  test('ocean event replay is deduplicated by event id', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final resolver = SyncConflictResolver(database);
    final change = SyncInboundChange(
      scopeId: 'profile-a',
      domain: syncDomainOceanEvent,
      entityKey: 'ocean-1',
      changedAtIso: '2026-03-14T12:00:00.000',
      deviceId: 'remote-1',
      revision: 'rev-1',
      payload: {
        'id': 'ocean-1',
        'timestamp': '2026-03-14T12:00:00.000',
        'dateKey': '2026-03-14',
        'actionType': oceanActionPrayerCompleted,
        'sourceModule': oceanSourcePrayer,
        'amount': 1,
        'referenceId': 'dhuhr',
        'metadata': {'timestamp': '2026-03-14T12:00:00.000'},
        'eligibilityKey': 'prayer_completed|prayer|dhuhr|2026-03-14',
      },
    );

    final first = resolver.applyInboundChanges([change]);
    final second = resolver.applyInboundChanges([change]);
    final repository = OceanDropsRepository(
      database: database,
      legacyStore: LocalStore(await SharedPreferences.getInstance()),
      scopeId: 'profile-a',
    );

    expect(first, 1);
    expect(second, 0);
    expect(repository.load().events, hasLength(1));
  });

  test('sync outbox remains profile-scoped across profile switches', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.addAccount(
      provider: AccountProviderType.google,
      identifier: 'family@example.com',
      displayName: 'Family',
      syncMode: ProfileSyncMode.pathOfNurCloud,
    );
    await controller.createProfile(
      displayName: 'Profile A',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.pathOfNurCloud,
      avatar: 'A',
    );
    final profileA = container.read(accountsSyncControllerProvider).activeProfileId!;
    container.read(prayerLogRepositoryProvider).saveDailyRecords(
          LocalStore.todayKey(),
          [
            for (final prayer in PrayerName.values)
              DailyPrayerRecord(
                prayer: prayer,
                status: prayer == PrayerName.fajr
                    ? PrayerStatus.completed
                    : PrayerStatus.pending,
                completedAtIso: prayer == PrayerName.fajr
                    ? DateTime.now().toIso8601String()
                    : null,
              ),
          ],
        );

    await controller.createProfile(
      displayName: 'Profile B',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.pathOfNurCloud,
      avatar: 'B',
    );
    final profileB = container.read(accountsSyncControllerProvider).activeProfileId!;
    container.read(prayerLogRepositoryProvider).saveDailyRecords(
          LocalStore.todayKey(),
          [
            for (final prayer in PrayerName.values)
              DailyPrayerRecord(
                prayer: prayer,
                status:
                    prayer == PrayerName.asr ? PrayerStatus.completed : PrayerStatus.pending,
                completedAtIso: prayer == PrayerName.asr
                    ? DateTime.now().toIso8601String()
                    : null,
              ),
          ],
        );

    final outbox = container.read(syncOutboxRepositoryProvider);
    expect(outbox.pendingEntries(profileA), hasLength(1));
    expect(outbox.pendingEntries(profileB), hasLength(1));
  });

  test('iCloud transport syncs persisted changes through the real channel contract', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
    final store = <String, String>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ICloudSyncTransport.channel, (call) async {
      switch (call.method) {
        case 'isAvailable':
          return true;
        case 'readValue':
          final key = (call.arguments as Map)['key']?.toString() ?? '';
          return store[key];
        case 'writeValue':
          final args = call.arguments as Map;
          store[args['key'].toString()] = args['value'].toString();
          return true;
      }
      return null;
    });

    final transport = const ICloudSyncTransport();
    final firstResponse = await transport.sync(
      const SyncTransportRequest(
        scopeId: 'profile-a',
        accountId: 'acct-1',
        deviceId: 'device-a',
        cursor: null,
        outboxEntries: [
          SyncOutboxEntry(
            outboxId: 'profile-a|prayer_log|2026-03-14',
            scopeId: 'profile-a',
            domain: syncDomainPrayerLog,
            entityKey: '2026-03-14',
            payload: {
              'dayKey': '2026-03-14',
              'updatedAtIso': '2026-03-14T12:00:00.000',
              'records': [
                {'prayer': 'fajr', 'status': 'completed', 'updatedAtIso': '2026-03-14T12:00:00.000'},
              ],
            },
            deviceId: 'device-a',
            dedupKey: 'profile-a|prayer_log|2026-03-14',
            createdAtIso: '2026-03-14T12:00:00.000',
            updatedAtIso: '2026-03-14T12:00:00.000',
            status: 'pending',
            attemptCount: 0,
          ),
        ],
      ),
    );

    final secondResponse = await transport.sync(
      const SyncTransportRequest(
        scopeId: 'profile-a',
        accountId: 'acct-1',
        deviceId: 'device-b',
        cursor: '0',
        outboxEntries: [],
      ),
    );

    expect(firstResponse.online, isTrue);
    expect(firstResponse.acceptedDedupKeys, contains('profile-a|prayer_log|2026-03-14'));
    expect(secondResponse.inboundChanges, hasLength(1));
    expect(secondResponse.inboundChanges.first.domain, syncDomainPrayerLog);
  });

  test('iCloud transport fails safely when unavailable', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ICloudSyncTransport.channel, (call) async {
      if (call.method == 'isAvailable') {
        return false;
      }
      return null;
    });

    final response = await const ICloudSyncTransport().sync(
      const SyncTransportRequest(
        scopeId: 'profile-a',
        accountId: 'acct-1',
        deviceId: 'device-a',
        cursor: null,
        outboxEntries: [],
      ),
    );

    expect(response.online, isFalse);
    expect(response.acceptedDedupKeys, isEmpty);
    expect(response.errorMessage, 'sync_error_icloud_unavailable');
    expect(response.statusCode, 'icloud_unavailable');
    expect(response.transportLabel, syncTransportKeyICloud);
  });

  test('iCloud transport reports write failures with actionable diagnostics', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ICloudSyncTransport.channel, (call) async {
      switch (call.method) {
        case 'isAvailable':
          return true;
        case 'readValue':
          return null;
        case 'writeValue':
          return false;
      }
      return null;
    });

    final response = await const ICloudSyncTransport().sync(
      const SyncTransportRequest(
        scopeId: 'profile-a',
        accountId: 'acct-1',
        deviceId: 'device-a',
        cursor: null,
        outboxEntries: [
          SyncOutboxEntry(
            outboxId: 'profile-a|prayer_log|2026-03-14',
            scopeId: 'profile-a',
            domain: syncDomainPrayerLog,
            entityKey: '2026-03-14',
            payload: {
              'dayKey': '2026-03-14',
              'records': [],
            },
            deviceId: 'device-a',
            dedupKey: 'profile-a|prayer_log|2026-03-14',
            createdAtIso: '2026-03-14T12:00:00.000',
            updatedAtIso: '2026-03-14T12:00:00.000',
            status: 'pending',
            attemptCount: 0,
          ),
        ],
      ),
    );

    expect(response.online, isFalse);
    expect(response.statusCode, 'icloud_write_failed');
    expect(response.errorMessage, 'sync_error_icloud_write_failed');
  });

  test('iCloud transport reports a no-op sync cleanly', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
    final store = <String, String>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ICloudSyncTransport.channel, (call) async {
      switch (call.method) {
        case 'isAvailable':
          return true;
        case 'readValue':
          final key = (call.arguments as Map)['key']?.toString() ?? '';
          return store[key];
        case 'writeValue':
          final args = call.arguments as Map;
          store[args['key'].toString()] = args['value'].toString();
          return true;
      }
      return null;
    });

    final response = await const ICloudSyncTransport().sync(
      const SyncTransportRequest(
        scopeId: 'profile-a',
        accountId: 'acct-1',
        deviceId: 'device-a',
        cursor: null,
        outboxEntries: <SyncOutboxEntry>[],
      ),
    );

    expect(response.online, isTrue);
    expect(response.statusCode, 'noop');
    expect(response.acceptedDedupKeys, isEmpty);
    expect(response.inboundChanges, isEmpty);
  });

  test('failed sync remains retryable and succeeds on retry', () async {
    final flaky = _FlakySyncTransport();
    final container = await makeTestContainer(
      overrides: [
        cloudSyncTransportProvider.overrideWithValue(flaky),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.addAccount(
      provider: AccountProviderType.google,
      identifier: 'cloud@example.com',
      displayName: 'Cloud',
      syncMode: ProfileSyncMode.pathOfNurCloud,
    );
    await controller.createProfile(
      displayName: 'Cloud Profile',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.pathOfNurCloud,
      avatar: 'C',
    );
    final scopeId = container.read(accountsSyncControllerProvider).activeProfileId!;
    container.read(prayerControllerProvider.notifier).cycleStatus(PrayerName.fajr);

    final first = await container.read(syncEngineProvider).syncScope(
          scopeId: scopeId,
          accountId: container.read(accountsSyncControllerProvider).activeAccountId,
          deviceId: container.read(deviceIdentityProvider).deviceId,
          syncModeName: ProfileSyncMode.pathOfNurCloud.name,
        );
    final pendingAfterFailure = container.read(syncOutboxRepositoryProvider).pendingCount(scopeId);

    final second = await container.read(syncEngineProvider).syncScope(
          scopeId: scopeId,
          accountId: container.read(accountsSyncControllerProvider).activeAccountId,
          deviceId: container.read(deviceIdentityProvider).deviceId,
          syncModeName: ProfileSyncMode.pathOfNurCloud.name,
        );

    expect(first.succeeded, isFalse);
    expect(pendingAfterFailure, greaterThan(0));
    expect(second.succeeded, isTrue);
    expect(container.read(syncOutboxRepositoryProvider).pendingCount(scopeId), 0);
  });

  test('iCloud transport keeps profile scopes isolated by document key', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
    final store = <String, String>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ICloudSyncTransport.channel, (call) async {
      switch (call.method) {
        case 'isAvailable':
          return true;
        case 'readValue':
          final key = (call.arguments as Map)['key']?.toString() ?? '';
          return store[key];
        case 'writeValue':
          final args = call.arguments as Map;
          store[args['key'].toString()] = args['value'].toString();
          return true;
      }
      return null;
    });

    final transport = const ICloudSyncTransport();
    await transport.sync(
      const SyncTransportRequest(
        scopeId: 'profile-a',
        accountId: 'acct-1',
        deviceId: 'device-a',
        cursor: null,
        outboxEntries: [
          SyncOutboxEntry(
            outboxId: 'a1',
            scopeId: 'profile-a',
            domain: syncDomainPrayerLog,
            entityKey: '2026-03-14',
            payload: {'dayKey': '2026-03-14', 'records': []},
            deviceId: 'device-a',
            dedupKey: 'a1',
            createdAtIso: '2026-03-14T12:00:00Z',
            updatedAtIso: '2026-03-14T12:00:00Z',
            status: 'pending',
            attemptCount: 0,
          ),
        ],
      ),
    );
    final response = await transport.sync(
      const SyncTransportRequest(
        scopeId: 'profile-b',
        accountId: 'acct-1',
        deviceId: 'device-b',
        cursor: null,
        outboxEntries: <SyncOutboxEntry>[],
      ),
    );

    expect(response.inboundChanges, isEmpty);
    expect(store.keys, contains('sync.scope.profile-a'));
    expect(store.keys, isNot(contains('sync.scope.profile-b')));
  });
}
