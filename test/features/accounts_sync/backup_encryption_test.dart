import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_services.dart';
import 'package:path_of_nur/features/accounts_sync/application/backup_crypto.dart';
import 'package:path_of_nur/features/accounts_sync/domain/accounts_sync_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

// Keep unit-test KDF cost low; the envelope stores its own iteration count,
// so decryption always follows whatever the envelope declares.
const _testIterations = 1000;

void main() {
  test('encrypt then decrypt roundtrips the payload', () async {
    const plaintext = '{"schemaVersion":2,"profiles":[{"displayName":"Nur"}]}';
    final envelopeRaw = await encryptBackupPayload(
      plaintext,
      'correct horse battery',
      iterations: _testIterations,
    );
    final envelope = jsonDecode(envelopeRaw) as Map<String, dynamic>;
    expect(envelope['format'], backupEnvelopeFormat);
    expect(envelope['version'], backupEnvelopeVersion);
    expect((envelope['kdf'] as Map)['algo'], backupKdfAlgorithm);
    expect((envelope['kdf'] as Map)['iterations'], _testIterations);
    expect((envelope['cipher'] as Map)['algo'], backupCipherAlgorithm);
    // The ciphertext must not contain the plaintext.
    expect(envelopeRaw, isNot(contains('Nur')));

    final decrypted = await decryptBackupEnvelope(
      envelope,
      'correct horse battery',
    );
    expect(decrypted, plaintext);
  });

  test('wrong passphrase fails cleanly with a typed exception', () async {
    final envelopeRaw = await encryptBackupPayload(
      '{"schemaVersion":2}',
      'right-passphrase',
      iterations: _testIterations,
    );
    final envelope = jsonDecode(envelopeRaw) as Map<String, dynamic>;
    await expectLater(
      () => decryptBackupEnvelope(envelope, 'wrong-passphrase'),
      throwsA(
        isA<BackupDecryptionException>().having(
          (error) => error.code,
          'code',
          'wrong_passphrase',
        ),
      ),
    );
  });

  test(
    'validateImportPayload decrypts envelopes and reports passphrase errors',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final repository = container.read(backupRepositoryProvider);
      final payload = jsonEncode(<String, dynamic>{
        'schemaVersion': 2,
        'accounts': const <Map<String, dynamic>>[],
        'profiles': <Map<String, dynamic>>[
          <String, dynamic>{'profileId': 'p1', 'displayName': 'Amina'},
        ],
        'profileSnapshots': <String, dynamic>{'p1': <String, dynamic>{}},
        'structuredDataByProfile': <String, dynamic>{'p1': <String, dynamic>{}},
      });
      final envelopeRaw = await encryptBackupPayload(
        payload,
        'safe passphrase',
        iterations: _testIterations,
      );

      final missingPass = await repository.validateImportPayload(
        payload: envelopeRaw,
        encrypted: false,
      );
      expect(missingPass.isValid, isFalse);
      expect(missingPass.errorCode, 'passphrase_required');

      final wrongPass = await repository.validateImportPayload(
        payload: envelopeRaw,
        encrypted: false,
        passphrase: 'not the passphrase',
      );
      expect(wrongPass.isValid, isFalse);
      expect(wrongPass.errorCode, 'wrong_passphrase');

      final rightPass = await repository.validateImportPayload(
        payload: envelopeRaw,
        encrypted: false,
        passphrase: 'safe passphrase',
      );
      expect(rightPass.isValid, isTrue);
      expect(rightPass.preview?.profileNames, contains('Amina'));
      expect(rightPass.preview?.metadata.encrypted, isTrue);
      // Downstream restore always receives decoded plaintext.
      expect(rightPass.preview?.rawPayload, payload);
    },
  );

  test('legacy base64 exports and plain JSON exports both import', () async {
    final source = await makeTestContainer();
    addTearDown(source.dispose);
    final sourceController = source.read(
      accountsSyncControllerProvider.notifier,
    );
    await sourceController.addAccount(
      provider: AccountProviderType.localOnly,
      identifier: 'local-source',
      displayName: 'Source',
    );
    await sourceController.createProfile(
      displayName: 'Legacy Traveler',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.localOnly,
      avatar: 'L',
    );
    final plainPayload = await sourceController.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
    );
    final legacyPayload = base64Encode(utf8.encode(plainPayload));

    // Legacy base64 (.enc.json before real encryption existed).
    final legacyTarget = await makeTestContainer();
    addTearDown(legacyTarget.dispose);
    await legacyTarget
        .read(accountsSyncControllerProvider.notifier)
        .importBackup(
          payload: legacyPayload,
          encrypted: true,
          createNewProfiles: true,
          replaceExisting: true,
        );
    expect(
      legacyTarget
          .read(accountsSyncControllerProvider)
          .profiles
          .map((profile) => profile.displayName),
      contains('Legacy Traveler'),
    );

    // Legacy base64 also validates without any toggle hint.
    final legacyValidation = await legacyTarget
        .read(backupRepositoryProvider)
        .validateImportPayload(payload: legacyPayload, encrypted: false);
    expect(legacyValidation.isValid, isTrue);
    expect(legacyValidation.preview?.rawPayload, plainPayload);

    // Plain JSON import path.
    final plainTarget = await makeTestContainer();
    addTearDown(plainTarget.dispose);
    await plainTarget
        .read(accountsSyncControllerProvider.notifier)
        .importBackup(
          payload: plainPayload,
          encrypted: false,
          createNewProfiles: true,
          replaceExisting: true,
        );
    expect(
      plainTarget
          .read(accountsSyncControllerProvider)
          .profiles
          .map((profile) => profile.displayName),
      contains('Legacy Traveler'),
    );
  });

  test('encrypted envelopes cannot bypass decryption at import', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);
    final envelopeRaw = await encryptBackupPayload(
      '{"schemaVersion":2}',
      'safe passphrase',
      iterations: _testIterations,
    );
    await expectLater(
      () => controller.importBackup(
        payload: envelopeRaw,
        encrypted: false,
        createNewProfiles: true,
        replaceExisting: false,
      ),
      throwsFormatException,
    );
  });

  test('diagnostics keys never travel inside backup payloads', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);
    final store = container.read(localStoreProvider);

    await controller.addAccount(
      provider: AccountProviderType.localOnly,
      identifier: 'local-diagnostics',
      displayName: 'Owner',
    );
    await controller.createProfile(
      displayName: 'Profile',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.localOnly,
      avatar: 'P',
    );
    await store.setJsonList('diagnostics.crash_log_v1', <dynamic>[
      <String, dynamic>{'error': 'sensitive stack trace'},
    ]);
    await store.setJsonList('diagnostics.analytics_log_v1', <dynamic>[
      <String, dynamic>{'event': 'sensitive analytics'},
    ]);
    await store.setJsonMap('settings.profile', <String, dynamic>{
      'theme': 'amber',
    });

    final payload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
    );
    expect(payload, isNot(contains('diagnostics.')));
    expect(payload, isNot(contains('sensitive stack trace')));
    expect(payload, isNot(contains('sensitive analytics')));
    expect(payload, contains('settings.profile'));

    // Restore tolerates payloads without diagnostics keys, and scrubs any
    // diagnostics keys found in older payloads.
    final decoded = jsonDecode(payload) as Map<String, dynamic>;
    final snapshots = decoded['profileSnapshots'] as Map<String, dynamic>;
    final firstProfileId = snapshots.keys.first;
    (snapshots[firstProfileId]
            as Map<String, dynamic>)['diagnostics.crash_log_v1'] =
        '[]';
    final target = await makeTestContainer();
    addTearDown(target.dispose);
    await target
        .read(accountsSyncControllerProvider.notifier)
        .importBackup(
          payload: jsonEncode(decoded),
          encrypted: false,
          createNewProfiles: true,
          replaceExisting: true,
        );
    final imported = target.read(accountsSyncControllerProvider);
    expect(
      imported.profileSnapshots[firstProfileId],
      isNot(contains('diagnostics.crash_log_v1')),
    );
  });

  test('diagnostics keys survive profile switches on the device', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);
    final store = container.read(localStoreProvider);

    await controller.createProfile(
      displayName: 'Profile A',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.localOnly,
      avatar: 'A',
    );
    await store.setJsonList('diagnostics.crash_log_v1', <dynamic>[
      <String, dynamic>{'error': 'device local'},
    ]);
    await controller.createProfile(
      displayName: 'Profile B',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.localOnly,
      avatar: 'B',
    );
    expect(store.getJsonList('diagnostics.crash_log_v1'), isNotNull);
  });

  test('sign-out removes the account record and detaches profiles', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);
    final store = container.read(localStoreProvider);

    await controller.connectAuthenticatedAccount(
      const AccountIdentity(
        provider: AccountsAuthProvider.google,
        identifier: 'google-user-1',
        displayName: 'Signed In User',
        email: 'signed-in@example.com',
      ),
    );
    await controller.createProfile(
      displayName: 'Owner',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.manualBackupOnly,
      avatar: 'O',
    );
    expect(container.read(accountsSyncControllerProvider).accounts, isNotEmpty);

    await controller.disconnectAuthenticatedAccount();

    final state = container.read(accountsSyncControllerProvider);
    expect(state.accounts, isEmpty);
    expect(state.authSessionAccountId, isNull);
    expect(state.activeAccountId, isNull);
    // Profile data stays, detached from the removed account.
    expect(state.profiles, isNotEmpty);
    expect(state.profiles.first.accountId, isNull);
    expect(
      container.read(authStateProvider).status,
      AuthStatus.unauthenticated,
    );

    // No PII remains in persisted preferences.
    final persistedRaw = store.getString('accounts_sync.state.v1') ?? '';
    expect(persistedRaw, isNot(contains('signed-in@example.com')));
    expect(persistedRaw, isNot(contains('Signed In User')));
    expect(persistedRaw, isNot(contains('google-user-1')));
  });
}
