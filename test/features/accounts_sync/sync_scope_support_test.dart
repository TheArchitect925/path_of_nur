import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_services.dart';
import 'package:path_of_nur/features/accounts_sync/domain/accounts_sync_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final testDocumentsDirectory = Directory('.dart_tool/test_documents_scope');

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

  test('sync scope preferences persist through accounts sync state serialization', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.updateSyncScopePreferences(
      const SyncScopePreferences(
        excludedOptionalDomainNames: <String>[
          'journal_notes',
          'theme_accessibility',
        ],
      ),
    );

    final serialized = container.read(accountsSyncControllerProvider).toJson();
    final restored = AccountsSyncState.fromJson(
      serialized.map((key, value) => MapEntry(key.toString(), value)),
    );

    expect(
      restored.syncScopePreferences.excludedOptionalDomainNames,
      containsAll(<String>['journal_notes', 'theme_accessibility']),
    );
  });

  test('scoped backup payload excludes optional domains from future remote backups', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);
    final store = container.read(localStoreProvider);

    await controller.addAccount(
      provider: AccountProviderType.localOnly,
      identifier: 'local-device',
      displayName: 'Owner',
    );
    await controller.createProfile(
      displayName: 'Traveler',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.manualBackupOnly,
      avatar: 'T',
    );
    await store.setJsonMap('settings.profile', <String, dynamic>{'theme': 'amber'});
    await store.setString('journal.entry.example', 'private note');
    await store.setString('theme.mode', 'midnight');
    await controller.updateSyncScopePreferences(
      const SyncScopePreferences(
        excludedOptionalDomainNames: <String>[
          'journal_notes',
          'theme_accessibility',
        ],
      ),
    );

    final payload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
      sourceType: BackupSourceType.remoteBackup,
      useSyncScope: true,
      appVersion: '1.2.3',
      buildNumber: '23',
    );
    final decoded = jsonDecode(payload) as Map<String, dynamic>;
    final metadata = (decoded['metadata'] as Map<String, dynamic>);
    final scopeSummary = BackupScopeSummary.fromJson(
      (metadata['scopeSummary'] as Map).map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    );
    final snapshots = ((decoded['profileSnapshots'] as Map).values.first as Map)
        .map((key, value) => MapEntry(key.toString(), value));

    expect(scopeSummary.isPartial, isTrue);
    expect(scopeSummary.excludedDomainNames, contains('journal_notes'));
    expect(scopeSummary.excludedDomainNames, contains('theme_accessibility'));
    expect(snapshots.containsKey('journal.entry.example'), isFalse);
    expect(snapshots.containsKey('theme.mode'), isFalse);
    expect(snapshots.containsKey('settings.profile'), isTrue);
  });

  test('partial backup import preserves excluded local-only domains', () async {
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

    await controller.addAccount(
      provider: AccountProviderType.localOnly,
      identifier: 'local-device',
      displayName: 'Owner',
    );
    await controller.createProfile(
      displayName: 'Traveler',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.manualBackupOnly,
      avatar: 'T',
    );
    await store.setJsonMap('settings.profile', <String, dynamic>{'theme': 'amber'});
    await store.setString('journal.entry.example', 'keep me local');
    await controller.updateSyncScopePreferences(
      const SyncScopePreferences(
        excludedOptionalDomainNames: <String>['journal_notes'],
      ),
    );

    final remotePayload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
      sourceType: BackupSourceType.remoteBackup,
      useSyncScope: true,
      appVersion: '1.2.3',
      buildNumber: '23',
    );
    final remoteMap = jsonDecode(remotePayload) as Map<String, dynamic>;
    final profileId = container.read(accountsSyncControllerProvider).activeProfileId!;
    final snapshots =
        (remoteMap['profileSnapshots'] as Map<String, dynamic>)[profileId]
            as Map<String, dynamic>;
    snapshots['settings.profile'] = jsonEncode(<String, dynamic>{'theme': 'teal'});

    final preview = await container.read(backupRepositoryProvider).validateImportPayload(
          payload: jsonEncode(remoteMap),
          encrypted: false,
        );
    final result = await container.read(backupRepositoryProvider).applyImport(
          preview: preview.preview!,
          mode: ImportConflictMode.replace,
        );

    expect(result.applied, isTrue);
    expect(store.getString('journal.entry.example'), 'keep me local');
    expect(store.getJsonMap('settings.profile')?['theme'], 'teal');
  });
}
