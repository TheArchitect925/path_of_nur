import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_services.dart';
import 'package:path_of_nur/features/accounts_sync/application/auto_backup_engine.dart';
import 'package:path_of_nur/features/accounts_sync/application/backup_payload_fingerprint.dart';
import 'package:path_of_nur/features/accounts_sync/application/remote_backup_transport.dart';
import 'package:path_of_nur/features/accounts_sync/application/sync_scope_support.dart';
import 'package:path_of_nur/features/accounts_sync/domain/accounts_sync_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeBackupTransport implements BackupTransport {
  _FakeBackupTransport({
    required this.provider,
    this.availability = RemoteBackupAvailability.available,
    this.uploadShouldSucceed = true,
    this.messageCode,
  });

  @override
  final RemoteBackupProvider provider;
  final RemoteBackupAvailability availability;
  final bool uploadShouldSucceed;
  final String? messageCode;
  RemoteBackupPayload? uploadedPayload;

  @override
  Future<RemoteBackupAvailability> checkAvailability() async => availability;

  @override
  Future<String?> downloadPayload(String backupId) async => null;

  @override
  Future<RemoteBackupMetadata?> fetchMetadata() async => null;

  @override
  Future<SyncOperationResult> upload(RemoteBackupPayload payload) async {
    uploadedPayload = payload;
    return SyncOperationResult(
      success: uploadShouldSucceed,
      availability: availability,
      metadata: uploadShouldSucceed ? payload.metadata : null,
      messageCode: uploadShouldSucceed ? null : messageCode ?? 'transport_failure',
    );
  }
}

void main() {
  Future<ProviderContainer> makeContainerWithGoogleTransport(
    _FakeBackupTransport transport,
  ) {
    return makeTestContainer(
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
  }

  Future<void> connectGoogleAccount(
    ProviderContainer container,
  ) async {
    await container.read(accountsSyncControllerProvider.notifier).connectAuthenticatedAccount(
          const AccountIdentity(
            provider: AccountsAuthProvider.google,
            identifier: 'tester@example.com',
            displayName: 'Tester',
            email: 'tester@example.com',
          ),
        );
    await container.read(accountsSyncControllerProvider.notifier).createProfile(
          displayName: 'Traveler',
          kind: ProfileKind.adult,
          experienceMode: ProfileExperienceMode.full,
          syncMode: ProfileSyncMode.manualBackupOnly,
          avatar: 'T',
        );
  }

  test('auto-backup eligibility is disabled when preferences are off', () async {
    final container = await makeContainerWithGoogleTransport(
      _FakeBackupTransport(provider: RemoteBackupProvider.google),
    );
    addTearDown(container.dispose);
    await connectGoogleAccount(container);
    await container.read(accountsSyncControllerProvider.notifier).updateAutoBackupState(
          preferences: const AutoBackupPreferences(
            enabled: false,
            frequency: AutoBackupFrequency.smart,
            backupOnMeaningfulProgressChange: true,
            backupOnBackground: true,
            minimumIntervalMinutes: 240,
          ),
        );

    final eligibility = await container.read(autoBackupControllerProvider).evaluateEligibility(
          trigger: AutoBackupTrigger.appResumed,
        );

    expect(eligibility.result, AutoBackupEligibilityResult.disabled);
  });

  test('auto-backup requires sign-in before becoming eligible', () async {
    final container = await makeContainerWithGoogleTransport(
      _FakeBackupTransport(provider: RemoteBackupProvider.google),
    );
    addTearDown(container.dispose);
    await container.read(accountsSyncControllerProvider.notifier).updateAutoBackupState(
          preferences: const AutoBackupPreferences(
            enabled: true,
            frequency: AutoBackupFrequency.smart,
            backupOnMeaningfulProgressChange: true,
            backupOnBackground: true,
            minimumIntervalMinutes: 240,
          ),
        );

    final eligibility = await container.read(autoBackupControllerProvider).evaluateEligibility(
          trigger: AutoBackupTrigger.appLaunch,
        );

    expect(eligibility.result, AutoBackupEligibilityResult.notSignedIn);
  });

  test('auto-backup becomes eligible when signed in and progress changed', () async {
    final container = await makeContainerWithGoogleTransport(
      _FakeBackupTransport(provider: RemoteBackupProvider.google),
    );
    addTearDown(container.dispose);
    await connectGoogleAccount(container);
    await container.read(accountsSyncControllerProvider.notifier).updateAutoBackupState(
          preferences: const AutoBackupPreferences(
            enabled: true,
            frequency: AutoBackupFrequency.smart,
            backupOnMeaningfulProgressChange: true,
            backupOnBackground: true,
            minimumIntervalMinutes: 240,
          ),
        );

    final eligibility = await container.read(autoBackupControllerProvider).evaluateEligibility(
          trigger: AutoBackupTrigger.appResumed,
        );

    expect(eligibility.result, AutoBackupEligibilityResult.eligibleNow);
    expect(
      eligibility.pendingReasons,
      contains(PendingBackupReason.meaningfulProgressChanged),
    );
  });

  test('auto-backup throttles repeated attempts inside the minimum window', () async {
    final container = await makeContainerWithGoogleTransport(
      _FakeBackupTransport(provider: RemoteBackupProvider.google),
    );
    addTearDown(container.dispose);
    await connectGoogleAccount(container);
    await container.read(accountsSyncControllerProvider.notifier).updateAutoBackupState(
          preferences: const AutoBackupPreferences(
            enabled: true,
            frequency: AutoBackupFrequency.smart,
            backupOnMeaningfulProgressChange: true,
            backupOnBackground: true,
            minimumIntervalMinutes: 240,
          ),
          lastAttemptAtIso: DateTime.now().toIso8601String(),
        );

    final eligibility = await container.read(autoBackupControllerProvider).evaluateEligibility(
          trigger: AutoBackupTrigger.appResumed,
        );

    expect(eligibility.result, AutoBackupEligibilityResult.throttled);
  });

  test('successful auto-backup clears dirty state and stores success metadata', () async {
    final transport = _FakeBackupTransport(provider: RemoteBackupProvider.google);
    final container = await makeContainerWithGoogleTransport(transport);
    addTearDown(container.dispose);
    await connectGoogleAccount(container);
    await container.read(accountsSyncControllerProvider.notifier).updateAutoBackupState(
          preferences: const AutoBackupPreferences(
            enabled: true,
            frequency: AutoBackupFrequency.smart,
            backupOnMeaningfulProgressChange: true,
            backupOnBackground: true,
            minimumIntervalMinutes: 0,
          ),
        );

    final result = await container.read(autoBackupControllerProvider).runIfEligible(
          trigger: AutoBackupTrigger.appResumed,
        );

    final state = container.read(accountsSyncControllerProvider).autoBackupState;
    expect(result.ran, isTrue);
    expect(result.success, isTrue);
    expect(transport.uploadedPayload, isNotNull);
    expect(state.dirty, isFalse);
    expect(state.pendingReasons, isEmpty);
    expect(state.lastSuccessAtIso, isNotNull);
    expect(state.lastSuccessfulDataSignature, isNotNull);
    expect(state.lastFailureCode, isNull);
  });

  test('failed auto-backup preserves dirty state and records failure', () async {
    final transport = _FakeBackupTransport(
      provider: RemoteBackupProvider.google,
      uploadShouldSucceed: false,
      messageCode: 'transport_failure',
    );
    final container = await makeContainerWithGoogleTransport(transport);
    addTearDown(container.dispose);
    await connectGoogleAccount(container);
    await container.read(accountsSyncControllerProvider.notifier).updateAutoBackupState(
          preferences: const AutoBackupPreferences(
            enabled: true,
            frequency: AutoBackupFrequency.smart,
            backupOnMeaningfulProgressChange: true,
            backupOnBackground: true,
            minimumIntervalMinutes: 0,
          ),
        );

    final result = await container.read(autoBackupControllerProvider).runIfEligible(
          trigger: AutoBackupTrigger.appResumed,
        );

    final state = container.read(accountsSyncControllerProvider).autoBackupState;
    expect(result.ran, isTrue);
    expect(result.success, isFalse);
    expect(state.dirty, isTrue);
    expect(state.lastFailureCode, 'transport_failure');
    expect(state.lastSuccessAtIso, isNull);
  });

  test('disabling meaningful-change backups waits for overdue schedule instead of payload diff', () async {
    final container = await makeContainerWithGoogleTransport(
      _FakeBackupTransport(provider: RemoteBackupProvider.google),
    );
    addTearDown(container.dispose);
    await connectGoogleAccount(container);
    await container.read(accountsSyncControllerProvider.notifier).updateAutoBackupState(
          preferences: const AutoBackupPreferences(
            enabled: true,
            frequency: AutoBackupFrequency.daily,
            backupOnMeaningfulProgressChange: false,
            backupOnBackground: true,
            minimumIntervalMinutes: 0,
          ),
          lastSuccessAtIso: DateTime.now().toIso8601String(),
        );

    final eligibility = await container.read(autoBackupControllerProvider).evaluateEligibility(
          trigger: AutoBackupTrigger.appResumed,
        );

    expect(eligibility.result, AutoBackupEligibilityResult.noMeaningfulChanges);
  });

  test('auto-backup reports provider unavailable when transport cannot back up', () async {
    final container = await makeContainerWithGoogleTransport(
      _FakeBackupTransport(
        provider: RemoteBackupProvider.google,
        availability: RemoteBackupAvailability.providerNotConfigured,
      ),
    );
    addTearDown(container.dispose);
    await connectGoogleAccount(container);
    await container.read(accountsSyncControllerProvider.notifier).updateAutoBackupState(
          preferences: const AutoBackupPreferences(
            enabled: true,
            frequency: AutoBackupFrequency.smart,
            backupOnMeaningfulProgressChange: true,
            backupOnBackground: true,
            minimumIntervalMinutes: 0,
          ),
        );

    final eligibility = await container.read(autoBackupControllerProvider).evaluateEligibility(
          trigger: AutoBackupTrigger.appLaunch,
        );

    expect(eligibility.result, AutoBackupEligibilityResult.providerUnavailable);
  });

  test('excluded optional domains do not make scoped auto-backup dirty', () async {
    final container = await makeContainerWithGoogleTransport(
      _FakeBackupTransport(provider: RemoteBackupProvider.google),
    );
    addTearDown(container.dispose);
    await connectGoogleAccount(container);
    final controller = container.read(accountsSyncControllerProvider.notifier);
    await controller.updateSyncScopePreferences(
      updateSyncScopePreference(
        container.read(accountsSyncControllerProvider).syncScopePreferences,
        domain: SyncableDomain.journalNotes,
        includeInBackup: false,
      ),
    );
    await controller.updateAutoBackupState(
      preferences: const AutoBackupPreferences(
        enabled: true,
        frequency: AutoBackupFrequency.smart,
        backupOnMeaningfulProgressChange: true,
        backupOnBackground: true,
        minimumIntervalMinutes: 0,
      ),
    );
    final baselinePayload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
      sourceType: BackupSourceType.remoteBackup,
      useSyncScope: true,
      appVersion: '1.2.3',
      buildNumber: '23',
    );
    await controller.updateAutoBackupState(
      lastSuccessfulDataSignature: backupPayloadFingerprint(baselinePayload),
      lastSuccessAtIso: DateTime.now().toIso8601String(),
    );

    final store = container.read(localStoreProvider);
    await store.setString('journal.entry.test', 'private note');

    final eligibility = await container.read(autoBackupControllerProvider).evaluateEligibility(
          trigger: AutoBackupTrigger.appResumed,
        );

    expect(eligibility.result, AutoBackupEligibilityResult.noMeaningfulChanges);
  });
}
