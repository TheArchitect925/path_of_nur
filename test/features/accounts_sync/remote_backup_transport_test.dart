import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/accounts_sync/application/restore_comparison.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_services.dart';
import 'package:path_of_nur/features/accounts_sync/application/remote_backup_transport.dart';
import 'package:path_of_nur/features/accounts_sync/application/sync_scope_support.dart';
import 'package:path_of_nur/features/accounts_sync/domain/accounts_sync_models.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeBackupTransport implements BackupTransport {
  _FakeBackupTransport({
    required this.provider,
    this.metadata,
    this.downloadedPayload,
  });

  @override
  final RemoteBackupProvider provider;
  final RemoteBackupMetadata? metadata;
  final String? downloadedPayload;
  RemoteBackupPayload? uploadedPayload;

  @override
  Future<RemoteBackupAvailability> checkAvailability() async {
    return RemoteBackupAvailability.available;
  }

  @override
  Future<String?> downloadPayload(String backupId) async => downloadedPayload;

  @override
  Future<RemoteBackupMetadata?> fetchMetadata() async => metadata;

  @override
  Future<SyncOperationResult> upload(RemoteBackupPayload payload) async {
    uploadedPayload = payload;
    return SyncOperationResult(
      success: true,
      availability: RemoteBackupAvailability.available,
      metadata: payload.metadata,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final testDocumentsDirectory = Directory('.dart_tool/test_documents');

  setUp(() {
    testDocumentsDirectory.createSync(recursive: true);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
          return testDocumentsDirectory.path;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('remote backup upload persists remote backup metadata for google account', () async {
    final transport = _FakeBackupTransport(provider: RemoteBackupProvider.google);
    final container = await makeTestContainer(
      overrides: <Override>[
        accountsSyncPackageInfoProvider.overrideWith(
          (ref) async => const AccountsSyncPackageInfo(
            appName: 'Path of Nur',
            version: '1.2.3',
            buildNumber: '23',
          ),
        ),
        googleRemoteBackupTransportProvider.overrideWithValue(transport),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.connectAuthenticatedAccount(
      const AccountIdentity(
        provider: AccountsAuthProvider.google,
        identifier: 'tester@example.com',
        displayName: 'Tester',
        email: 'tester@example.com',
      ),
    );
    await controller.createProfile(
      displayName: 'Profile A',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.manualBackupOnly,
      avatar: 'A',
    );

    final result = await container.read(remoteBackupRepositoryProvider).backupNow();

    expect(result.success, isTrue);
    expect(transport.uploadedPayload, isNotNull);
    final state = container.read(accountsSyncControllerProvider);
    expect(state.remoteBackupRecord.providerKey, 'google');
    expect(state.remoteBackupRecord.lastRemoteBackupAtIso, isNotNull);
  });

  test('remote restore preview compares local and remote backup timestamps', () async {
    final payload =
        '{"schemaVersion":2,"metadata":{"schemaVersion":2,"appVersion":"1.2.3","buildNumber":"23","sourceType":"remoteBackup","exportedAtIso":"2026-03-24T12:00:00Z","currentProfileOnly":false,"encrypted":false},"accounts":[],"profiles":[{"profileId":"p1","displayName":"Traveler"}],"profileSnapshots":{"p1":{}},"structuredDataByProfile":{"p1":{}}}';
    final transport = _FakeBackupTransport(
      provider: RemoteBackupProvider.apple,
      metadata: RemoteBackupMetadata(
        provider: RemoteBackupProvider.apple,
        backupId: 'remote_backups/account/path_of_nur_backup.json',
        schemaVersion: 2,
        appVersion: '1.2.3',
        appBuild: '23',
        createdAtIso: '2026-03-24T12:00:00Z',
        updatedAtIso: '2026-03-24T12:00:00Z',
        deviceLabel: 'iPhone',
        accountLabel: 'Apple User',
        payloadSizeBytes: 200,
        scopeSummary: defaultFullBackupScopeSummary(),
        checksum: 'abc',
      ),
      downloadedPayload: payload,
    );
    final container = await makeTestContainer(
      overrides: <Override>[
        accountsSyncPackageInfoProvider.overrideWith(
          (ref) async => const AccountsSyncPackageInfo(
            appName: 'Path of Nur',
            version: '1.2.3',
            buildNumber: '23',
          ),
        ),
        appleRemoteBackupTransportProvider.overrideWithValue(transport),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.connectAuthenticatedAccount(
      const AccountIdentity(
        provider: AccountsAuthProvider.apple,
        identifier: 'apple-user',
        displayName: 'Apple User',
      ),
    );
    await controller.updateRemoteBackupRecord(
      providerKey: 'apple',
      lastRemoteBackupAtIso: '2026-03-24T12:00:00Z',
    );
    await controller.exportBackup(
      currentProfileOnly: false,
      encrypt: false,
      appVersion: '1.2.3',
      buildNumber: '23',
    );

    final preview = await container
        .read(remoteBackupRepositoryProvider)
        .prepareRestorePreview();

    expect(preview, isNotNull);
    expect(
      preview!.comparisonSummary.domainComparisons,
      isNotEmpty,
    );
    expect(preview.importPreview.profileNames, contains('Traveler'));
  });

  test('restore comparison warns on account mismatch and disables safe merge', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.connectAuthenticatedAccount(
      const AccountIdentity(
        provider: AccountsAuthProvider.google,
        identifier: 'tester@example.com',
        displayName: 'Tester',
        email: 'tester@example.com',
      ),
    );
    await controller.createProfile(
      displayName: 'Profile A',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.manualBackupOnly,
      avatar: 'A',
    );

    final localPayload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
      appVersion: '1.2.3',
      buildNumber: '23',
    );
    final localValidation = await container.read(backupRepositoryProvider).validateImportPayload(
          payload: localPayload,
          encrypted: false,
        );
    final remoteValidation = await container.read(backupRepositoryProvider).validateImportPayload(
          payload: localPayload,
          encrypted: false,
        );

    final summary = container.read(restoreComparisonEngineProvider).compare(
          localPreview: localValidation.preview!,
          remotePreview: remoteValidation.preview!,
          remoteMetadata: RemoteBackupMetadata(
            provider: RemoteBackupProvider.google,
            backupId: 'backup',
            schemaVersion: 2,
            appVersion: '1.2.3',
            appBuild: '23',
            createdAtIso: '2026-03-24T12:00:00Z',
            updatedAtIso: '2026-03-24T12:00:00Z',
            deviceLabel: 'Pixel',
            accountLabel: 'Another User',
            payloadSizeBytes: 120,
            scopeSummary: defaultFullBackupScopeSummary(),
          ),
          state: container.read(accountsSyncControllerProvider),
        );

    expect(summary.hasAccountMismatch, isTrue);
    expect(summary.canMergeSafeDomains, isFalse);
    expect(summary.availableDecisionModes, isNot(contains(RestoreDecisionMode.mergeSafeDomains)));
  });

  test('merge-safe remote restore merges prayer data and keeps remote replace-only settings', () async {
    final container = await makeTestContainer(
      overrides: <Override>[
        accountsSyncPackageInfoProvider.overrideWith(
          (ref) async => const AccountsSyncPackageInfo(
            appName: 'Path of Nur',
            version: '1.2.3',
            buildNumber: '23',
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);
    final store = container.read(localStoreProvider);
    final database = container.read(appDatabaseProvider);

    await controller.connectAuthenticatedAccount(
      const AccountIdentity(
        provider: AccountsAuthProvider.apple,
        identifier: 'apple-user',
        displayName: 'Apple User',
      ),
    );
    await controller.createProfile(
      displayName: 'Traveler',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.manualBackupOnly,
      avatar: 'T',
    );
    final profileId = container.read(accountsSyncControllerProvider).activeProfileId!;
    await store.setJsonMap('settings.profile', <String, dynamic>{'theme': 'amber'});
    database.importStructuredData(profileId, <String, dynamic>{
      'prayerRecords': <Map<String, dynamic>>[
        <String, dynamic>{
          'dayKey': '2026-03-24',
          'prayer': 'fajr',
          'status': 'completed',
          'updatedAtIso': '2026-03-24T06:00:00Z',
        },
      ],
      'dhikrSessions': const <Map<String, dynamic>>[],
      'oceanEvents': const <Map<String, dynamic>>[],
      'xpLedgerEntries': const <Map<String, dynamic>>[],
      'dropEvents': const <Map<String, dynamic>>[],
    });

    final localPayload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
      appVersion: '1.2.3',
      buildNumber: '23',
    );
    final remoteMap = jsonDecode(localPayload) as Map<String, dynamic>;
    final snapshots = (remoteMap['profileSnapshots'] as Map<String, dynamic>);
    snapshots[profileId] = <String, dynamic>{
      'settings.profile': jsonEncode(<String, dynamic>{'theme': 'teal'}),
    };
    final structured = (remoteMap['structuredDataByProfile'] as Map<String, dynamic>);
    structured[profileId] = <String, dynamic>{
      'prayerRecords': <Map<String, dynamic>>[
        <String, dynamic>{
          'dayKey': '2026-03-24',
          'prayer': 'maghrib',
          'status': 'completed',
          'updatedAtIso': '2026-03-24T18:00:00Z',
        },
      ],
      'dhikrSessions': const <Map<String, dynamic>>[],
      'oceanEvents': const <Map<String, dynamic>>[],
      'xpLedgerEntries': const <Map<String, dynamic>>[],
      'dropEvents': const <Map<String, dynamic>>[],
    };
    (remoteMap['metadata'] as Map<String, dynamic>)['exportedAtIso'] = '2026-03-24T18:30:00Z';

    final transport = _FakeBackupTransport(
      provider: RemoteBackupProvider.apple,
      metadata: RemoteBackupMetadata(
        provider: RemoteBackupProvider.apple,
        backupId: 'remote_backups/apple-user/path_of_nur_backup.json',
        schemaVersion: 2,
        appVersion: '1.2.3',
        appBuild: '23',
        createdAtIso: '2026-03-24T18:30:00Z',
        updatedAtIso: '2026-03-24T18:30:00Z',
        deviceLabel: 'iPhone',
        accountLabel: 'Apple User',
        payloadSizeBytes: 220,
        scopeSummary: defaultFullBackupScopeSummary(),
      ),
      downloadedPayload: jsonEncode(remoteMap),
    );

    final scopedContainer = await makeTestContainer(
      seed: Map<String, Object>.from(container.read(localStoreProvider).dumpAll()),
      database: container.read(appDatabaseProvider),
      overrides: <Override>[
        accountsSyncPackageInfoProvider.overrideWith(
          (ref) async => const AccountsSyncPackageInfo(
            appName: 'Path of Nur',
            version: '1.2.3',
            buildNumber: '23',
          ),
        ),
        appleRemoteBackupTransportProvider.overrideWithValue(transport),
      ],
    );
    addTearDown(scopedContainer.dispose);

    final preview = await scopedContainer
        .read(remoteBackupRepositoryProvider)
        .prepareRestorePreview();
    expect(preview, isNotNull);
    expect(preview!.comparisonSummary.canMergeSafeDomains, isTrue);

    final result = await scopedContainer
        .read(remoteBackupRepositoryProvider)
        .restoreRemote(mode: RestoreDecisionMode.mergeSafeDomains);

    expect(result.applied, isTrue);
    expect(
      result.conflictSummary.mergedDomains,
      containsAll(<String>['prayer_tracking']),
    );
    expect(
      result.conflictSummary.replacedDomains,
      contains('settings_preferences'),
    );

    final restoredStore = scopedContainer.read(localStoreProvider);
    final restoredDatabase = scopedContainer.read(appDatabaseProvider);
    expect(restoredStore.getJsonMap('settings.profile')?['theme'], 'teal');
    final restoredStructured = restoredDatabase.exportStructuredData(profileId);
    final prayers = (restoredStructured['prayerRecords'] as List).cast<Map<String, dynamic>>();
    final prayerIds = prayers
        .map((row) => '${row['dayKey']}:${row['prayer']}')
        .toSet();
    expect(prayerIds, containsAll(<String>['2026-03-24:fajr', '2026-03-24:maghrib']));
  });
}
