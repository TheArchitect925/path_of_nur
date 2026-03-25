import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/tvos/application/tvos_resilience.dart';
import 'package:path_of_nur/features/tvos/data/tvos_foundation_registry.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_resilience_models.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<LocalStore> storeWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    final prefs = await SharedPreferences.getInstance();
    return LocalStore(prefs);
  }

  List<TVOSSurfaceFlag> enabledFlags() => tvosSurfaceFlags
      .where((flag) => flag.availability == TVOSFeatureAvailability.enabled)
      .toList(growable: false);

  ProfileRecord profile(ProfileSyncMode mode) {
    final now = DateTime(2026, 3, 25).toIso8601String();
    return ProfileRecord(
      profileId: 'adult-default',
      accountId: null,
      displayName: 'Adult',
      avatar: '✨',
      profileType: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      createdAtIso: now,
      updatedAtIso: now,
      lastActiveAtIso: now,
      syncEnabled: mode != ProfileSyncMode.localOnly,
      syncMode: mode,
      pinProtected: false,
      isLocalOnly: mode == ProfileSyncMode.localOnly,
      isGuest: false,
      guardianManaged: false,
      settingsEditable: true,
      allowExportImport: true,
      canLeaveWithoutPin: true,
      visibleSections: const <String>['home', 'learn', 'profile'],
    );
  }

  test('manual backup state is reflected for local-first tvOS resilience', () async {
    final store = await storeWith(<String, Object>{
      'quran.reader.last_surah': '1',
    });
    final db = AppDatabase.inMemory();
    db.execute(
      '''
      INSERT INTO prayer_records(
        scope_id, day_key, prayer, status, updated_at_iso
      ) VALUES(?, ?, ?, ?, ?);
      ''',
      <Object?>['__default__', '2026-03-25', 'fajr', 'completed', '2026-03-25T10:00:00Z'],
    );

    final state = AccountsSyncState.initial().copyWith(
      profiles: <ProfileRecord>[profile(ProfileSyncMode.localOnly)],
      activeProfileId: 'adult-default',
      backupRecord: const BackupRecord(
        lastExportAtIso: '2026-03-10T12:00:00Z',
        lastImportAtIso: null,
        lastExportPath: '/tmp/path_of_nur_backup.json',
      ),
    );

    final snapshot = buildTVOSResilienceSnapshot(
      accountsSyncState: state,
      localStore: store,
      appDatabase: db,
      enabledSurfaceFlags: enabledFlags(),
      now: DateTime.utc(2026, 3, 25),
    );

    expect(snapshot.offlineReadiness, TVOSOfflineReadiness.cacheAndSyncAware);
    expect(snapshot.syncAwareness, TVOSSyncAwareness.manualBackupReady);
    expect(snapshot.localPreferenceCount, greaterThan(0));
    expect(snapshot.structuredDataRowCount, greaterThan(0));
    expect(snapshot.lastManualBackupAtIso, '2026-03-10T12:00:00Z');
  });

  test('pending sync has higher priority than remote backup readiness', () async {
    final store = await storeWith(<String, Object>{});
    final db = AppDatabase.inMemory();
    db.execute(
      '''
      INSERT INTO sync_outbox(
        outbox_id, scope_id, domain, entity_key, payload_json, device_id,
        dedup_key, created_at_iso, updated_at_iso, status, attempt_count
      ) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
      <Object?>[
        'outbox-1',
        '__default__',
        'quran_progress',
        'ayah:1:5',
        '{}',
        'device-local',
        'dedup-1',
        '2026-03-25T09:00:00Z',
        '2026-03-25T09:00:00Z',
        'pending',
        0,
      ],
    );

    final state = AccountsSyncState.initial().copyWith(
      profiles: <ProfileRecord>[profile(ProfileSyncMode.iCloud)],
      activeProfileId: 'adult-default',
      syncStatus: const SyncStatusSnapshot(
        syncMode: ProfileSyncMode.iCloud,
        syncState: SyncStateKind.offlinePending,
        lastSyncAtIso: null,
        pendingChangesCount: 1,
        deviceName: 'Apple TV',
        healthy: true,
        recentEvents: <String>[],
        lastFailedSyncAtIso: null,
        transportLabel: 'icloud',
        transportAvailable: true,
        lastResultSummary: null,
        lastErrorSummary: null,
      ),
      remoteBackupRecord: const RemoteBackupRecord(
        providerKey: 'icloud',
        remoteBackupId: 'remote-1',
        lastRemoteBackupAtIso: '2026-03-24T08:00:00Z',
        lastRemoteRestoreAtIso: null,
        lastRemoteCheckAtIso: null,
        lastRemoteChecksum: null,
        lastRemoteErrorCode: null,
        lastRemoteDeviceLabel: null,
        lastRemoteAccountLabel: null,
      ),
    );

    final snapshot = buildTVOSResilienceSnapshot(
      accountsSyncState: state,
      localStore: store,
      appDatabase: db,
      enabledSurfaceFlags: enabledFlags(),
      now: DateTime.utc(2026, 3, 25),
    );

    expect(snapshot.syncAwareness, TVOSSyncAwareness.pendingSync);
    expect(snapshot.pendingOutboxCount, 1);
    expect(snapshot.lastRemoteBackupAtIso, '2026-03-24T08:00:00Z');
  });

  test('route snapshots preserve enabled tvOS routes and parity counts', () async {
    final store = await storeWith(<String, Object>{});
    final db = AppDatabase.inMemory();

    final snapshot = buildTVOSResilienceSnapshot(
      accountsSyncState: AccountsSyncState.initial(),
      localStore: store,
      appDatabase: db,
      enabledSurfaceFlags: enabledFlags(),
      now: DateTime.utc(2026, 3, 25),
    );

    expect(snapshot.routeSnapshots.map((route) => route.routePath), <String>[
      '/home',
      '/quran',
      '/learn',
      '/learn/games',
      '/worship/prayer',
      '/worship/dhikr',
      '/learn/kids/fun-learning',
      '/quran/arabic',
      '/quran/bookmarks',
      '/settings',
      '/accounts-sync/profiles',
    ]);
    expect(
      snapshot.routeSnapshots.firstWhere((route) => route.routePath == '/quran').parityBackedSectionCount,
      4,
    );
    expect(
      snapshot.routeSnapshots.firstWhere((route) => route.routePath == '/learn').offlineReady,
      isTrue,
    );
  });
}
