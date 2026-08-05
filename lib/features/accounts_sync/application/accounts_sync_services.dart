import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../domain/accounts_sync_models.dart';
import 'accounts_sync_controller.dart';
import 'backup_crypto.dart';
import 'sync_scope_support.dart';

const int accountsSyncBackupSchemaVersion = 2;

class AccountsSyncPackageInfo {
  const AccountsSyncPackageInfo({
    required this.appName,
    required this.version,
    required this.buildNumber,
  });

  final String appName;
  final String version;
  final String buildNumber;
}

final accountsSyncPackageInfoProvider = FutureProvider<AccountsSyncPackageInfo>(
  (ref) async {
    final info = await PackageInfo.fromPlatform();
    return AccountsSyncPackageInfo(
      appName: info.appName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  },
);

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: const <String>[
      'email',
      'https://www.googleapis.com/auth/drive.appdata',
    ],
  );
});

abstract class AccountsAuthRepository {
  Future<AuthActionResult> signInWithApple();

  Future<AuthActionResult> signInWithGoogle();

  Future<AuthActionResult> signInWithEmail();

  Future<void> signOut();
}

class PlatformAccountsAuthRepository implements AccountsAuthRepository {
  const PlatformAccountsAuthRepository(this.ref);

  final Ref ref;

  @override
  Future<AuthActionResult> signInWithApple() async {
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS)) {
      return const AuthActionResult(
        status: AuthActionStatus.unavailable,
        message: 'unsupported_platform',
      );
    }
    if (!await SignInWithApple.isAvailable()) {
      return const AuthActionResult(
        status: AuthActionStatus.notConfigured,
        message: 'apple_sign_in_unavailable',
      );
    }
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final fullName = <String>[
        credential.givenName ?? '',
        credential.familyName ?? '',
      ].where((part) => part.isNotEmpty).join(' ');
      final identity = AccountIdentity(
        provider: AccountsAuthProvider.apple,
        identifier: credential.userIdentifier ?? credential.email ?? 'apple',
        displayName: fullName.isNotEmpty
            ? fullName
            : credential.email ?? 'Apple User',
        email: credential.email,
      );
      await ref
          .read(accountsSyncControllerProvider.notifier)
          .connectAuthenticatedAccount(identity);
      return AuthActionResult(
        status: AuthActionStatus.success,
        identity: identity,
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        return const AuthActionResult(status: AuthActionStatus.cancelled);
      }
      return AuthActionResult(
        status: AuthActionStatus.error,
        message: error.code.name,
      );
    } catch (_) {
      return const AuthActionResult(
        status: AuthActionStatus.error,
        message: 'apple_sign_in_failed',
      );
    }
  }

  @override
  Future<AuthActionResult> signInWithGoogle() async {
    try {
      final account = await ref.read(googleSignInProvider).signIn();
      if (account == null) {
        return const AuthActionResult(status: AuthActionStatus.cancelled);
      }
      final identity = AccountIdentity(
        provider: AccountsAuthProvider.google,
        identifier: account.id,
        displayName: account.displayName ?? account.email,
        email: account.email,
      );
      await ref
          .read(accountsSyncControllerProvider.notifier)
          .connectAuthenticatedAccount(identity);
      return AuthActionResult(
        status: AuthActionStatus.success,
        identity: identity,
      );
    } catch (_) {
      return const AuthActionResult(
        status: AuthActionStatus.error,
        message: 'google_sign_in_failed',
      );
    }
  }

  @override
  Future<AuthActionResult> signInWithEmail() async {
    return const AuthActionResult(
      status: AuthActionStatus.notConfigured,
      message: 'email_not_connected',
    );
  }

  @override
  Future<void> signOut() async {
    final controller = ref.read(accountsSyncControllerProvider.notifier);
    final provider = ref
        .read(accountsSyncControllerProvider)
        .authenticatedAccount
        ?.provider;
    if (provider == AccountProviderType.google) {
      final googleSignIn = ref.read(googleSignInProvider);
      try {
        // disconnect() also revokes the OAuth grant so the app no longer
        // holds access to the Google account after sign-out.
        await googleSignIn.disconnect();
      } catch (_) {
        try {
          await googleSignIn.signOut();
        } catch (_) {}
      }
    }
    await controller.disconnectAuthenticatedAccount();
  }
}

final accountsAuthRepositoryProvider = Provider<AccountsAuthRepository>(
  PlatformAccountsAuthRepository.new,
);

class BackupExportResult {
  const BackupExportResult({required this.filePath, required this.metadata});

  final String filePath;
  final BackupMetadata metadata;
}

class BackupExportOptions {
  const BackupExportOptions({
    required this.currentProfileOnly,
    required this.encrypted,
    this.passphrase,
    this.sourceType = BackupSourceType.manualExport,
  });

  final bool currentProfileOnly;
  final bool encrypted;

  /// Required when [encrypted] is true; the export is written as an
  /// AES-256-GCM envelope keyed from this passphrase.
  final String? passphrase;
  final BackupSourceType sourceType;
}

abstract class BackupRepository {
  Future<BackupExportResult> export(BackupExportOptions options);

  Future<void> shareExport(String filePath);

  Future<String?> pickImportPayload();

  Future<ImportValidationResult> validateImportPayload({
    required String payload,
    required bool encrypted,
    String? passphrase,
  });

  Future<RestoreResult> applyImport({
    required ImportPackagePreview preview,
    required ImportConflictMode mode,
  });
}

class LocalBackupRepository implements BackupRepository {
  const LocalBackupRepository(this.ref);

  final Ref ref;

  @override
  Future<BackupExportResult> export(BackupExportOptions options) async {
    final packageInfo = await ref.read(accountsSyncPackageInfoProvider.future);
    final controller = ref.read(accountsSyncControllerProvider.notifier);
    final effectiveEncrypted =
        options.encrypted &&
        options.passphrase != null &&
        options.passphrase!.isNotEmpty;
    final path = await controller.exportBackup(
      currentProfileOnly: options.currentProfileOnly,
      encrypt: options.encrypted,
      passphrase: options.passphrase,
      sourceType: options.sourceType,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
    final state = ref.read(accountsSyncControllerProvider);
    final metadata = BackupMetadata(
      schemaVersion: accountsSyncBackupSchemaVersion,
      appVersion: packageInfo.version,
      appBuild: packageInfo.buildNumber,
      sourceType: options.sourceType,
      exportedAtIso:
          state.backupRecord.lastExportAtIso ??
          DateTime.now().toIso8601String(),
      currentProfileOnly: options.currentProfileOnly,
      encrypted: effectiveEncrypted,
      scopeSummary: defaultFullBackupScopeSummary(),
      provider: _mapProvider(state.authenticatedAccount?.provider),
      accountLabel: state.authenticatedAccount?.displayName,
      deviceLabel: state.syncStatus.deviceName,
      lastBackupAtIso: state.backupRecord.lastExportAtIso,
    );
    return BackupExportResult(filePath: path, metadata: metadata);
  }

  @override
  Future<void> shareExport(String filePath) {
    return Share.shareXFiles(<XFile>[XFile(filePath)]);
  }

  @override
  Future<String?> pickImportPayload() async {
    final file = await openFile(
      acceptedTypeGroups: const <XTypeGroup>[
        XTypeGroup(label: 'Path of Nur backup', extensions: <String>['json']),
      ],
    );
    if (file == null) {
      return null;
    }
    return file.readAsString();
  }

  @override
  Future<ImportValidationResult> validateImportPayload({
    required String payload,
    required bool encrypted,
    String? passphrase,
  }) async {
    final trimmed = payload.trim();
    if (trimmed.isEmpty) {
      return const ImportValidationResult.failure(
        errorCode: 'empty_payload',
        errorMessage: 'empty_payload',
      );
    }
    // Detection order: plain JSON -> passphrase envelope -> legacy
    // base64(JSON) from historical `.enc.json` exports. The `encrypted`
    // argument is retained for call-site compatibility only.
    Object? json;
    var normalizedPayload = trimmed;
    try {
      json = jsonDecode(trimmed);
    } catch (_) {
      try {
        normalizedPayload = utf8.decode(base64Decode(trimmed));
        json = jsonDecode(normalizedPayload);
      } catch (_) {
        return const ImportValidationResult.failure(
          errorCode: 'invalid_payload',
          errorMessage: 'invalid_payload',
        );
      }
    }
    if (json is! Map) {
      return const ImportValidationResult.failure(
        errorCode: 'invalid_payload',
        errorMessage: 'invalid_payload',
      );
    }
    var wasEncrypted = false;
    if (isEncryptedBackupEnvelope(json)) {
      if (passphrase == null || passphrase.isEmpty) {
        return const ImportValidationResult.failure(
          errorCode: 'passphrase_required',
          errorMessage: 'passphrase_required',
        );
      }
      try {
        normalizedPayload = await decryptBackupEnvelope(
          json.map((key, value) => MapEntry(key.toString(), value)),
          passphrase,
        );
        json = jsonDecode(normalizedPayload);
        wasEncrypted = true;
      } on BackupDecryptionException catch (error) {
        return ImportValidationResult.failure(
          errorCode: error.code == 'wrong_passphrase'
              ? 'wrong_passphrase'
              : 'invalid_payload',
          errorMessage: error.code,
        );
      } catch (_) {
        return const ImportValidationResult.failure(
          errorCode: 'invalid_payload',
          errorMessage: 'invalid_payload',
        );
      }
      if (json is! Map) {
        return const ImportValidationResult.failure(
          errorCode: 'invalid_payload',
          errorMessage: 'invalid_payload',
        );
      }
    }
    final decodedMap = json.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final schemaVersion = (decodedMap['schemaVersion'] as num?)?.toInt() ?? 1;
    if (schemaVersion > accountsSyncBackupSchemaVersion) {
      return const ImportValidationResult.failure(
        errorCode: 'future_schema',
        errorMessage: 'future_schema',
      );
    }
    final profiles = ((decodedMap['profiles'] as List?) ?? const <dynamic>[])
        .map((item) => item as Map)
        .toList(growable: false);
    final accounts = ((decodedMap['accounts'] as List?) ?? const <dynamic>[])
        .map((item) => item as Map)
        .toList(growable: false);
    final metadataMap =
        (decodedMap['metadata'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value),
        ) ??
        <String, dynamic>{};
    final warnings = <String>[];
    if (!decodedMap.containsKey('structuredDataByProfile')) {
      warnings.add('structured_data_missing');
    }
    final preview = ImportPackagePreview(
      metadata: BackupMetadata(
        schemaVersion: schemaVersion,
        appVersion: metadataMap['appVersion']?.toString() ?? 'unknown',
        appBuild: metadataMap['buildNumber']?.toString() ?? 'unknown',
        sourceType: _backupSourceFromKey(metadataMap['sourceType']?.toString()),
        exportedAtIso:
            metadataMap['exportedAtIso']?.toString() ??
            decodedMap['exportedAt']?.toString() ??
            DateTime.now().toIso8601String(),
        currentProfileOnly:
            metadataMap['currentProfileOnly'] as bool? ??
            decodedMap['currentProfileOnly'] as bool? ??
            false,
        encrypted:
            wasEncrypted ||
            (metadataMap['encrypted'] as bool? ??
                decodedMap['encrypted'] as bool? ??
                encrypted),
        scopeSummary: metadataMap['scopeSummary'] is Map
            ? BackupScopeSummary.fromJson(
                (metadataMap['scopeSummary'] as Map).map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
              )
            : defaultFullBackupScopeSummary(),
        provider: _backupProviderFromKey(metadataMap['provider']?.toString()),
        accountLabel: metadataMap['accountLabel']?.toString(),
        deviceLabel: metadataMap['deviceLabel']?.toString(),
        lastBackupAtIso: metadataMap['lastBackupAtIso']?.toString(),
      ),
      accountCount: accounts.length,
      profileCount: profiles.length,
      profileNames: profiles
          .map((item) => item['displayName']?.toString() ?? '')
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      warnings: warnings,
      // Always the decoded plaintext JSON so downstream restore logic never
      // has to re-handle envelopes or legacy base64 encodings.
      rawPayload: normalizedPayload,
      decodedPayload: decodedMap,
    );
    return ImportValidationResult.success(preview);
  }

  @override
  Future<RestoreResult> applyImport({
    required ImportPackagePreview preview,
    required ImportConflictMode mode,
  }) async {
    final packageInfo = await ref.read(accountsSyncPackageInfoProvider.future);
    final controller = ref.read(accountsSyncControllerProvider.notifier);
    final snapshotPath = await controller.exportBackup(
      currentProfileOnly: false,
      encrypt: false,
      sourceType: BackupSourceType.safetySnapshot,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
    final localPayload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
      sourceType: BackupSourceType.safetySnapshot,
      useSyncScope: false,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
    try {
      final localDecoded = jsonDecode(localPayload) as Map<String, dynamic>;
      final incomingDecoded = Map<String, dynamic>.from(preview.decodedPayload);
      final protectedPayload = preserveExcludedLocalDomainsInPayload(
        localPayload: localDecoded,
        incomingPayload: incomingDecoded,
        scopeSummary: preview.metadata.scopeSummary,
      );
      // The preview already carries decoded plaintext, so the controller
      // always receives plain JSON regardless of the source file's encoding.
      final protectedRaw = jsonEncode(protectedPayload);
      await controller.importBackup(
        payload: protectedRaw,
        encrypted: false,
        createNewProfiles: mode == ImportConflictMode.merge,
        replaceExisting: mode == ImportConflictMode.replace,
      );
      return RestoreResult(
        applied: true,
        safetySnapshotPath: snapshotPath,
        conflictSummary: RestoreConflictSummary(
          mode: mode,
          decisionMode: mode == ImportConflictMode.replace
              ? RestoreDecisionMode.replaceLocalWithRemote
              : RestoreDecisionMode.mergeSafeDomains,
          willReplaceLocalProfiles: mode == ImportConflictMode.replace,
          willMergeProfiles: mode == ImportConflictMode.merge,
          safetySnapshotCreated: true,
        ),
      );
    } catch (error) {
      return RestoreResult(
        applied: false,
        safetySnapshotPath: snapshotPath,
        errorMessage: error.toString(),
        conflictSummary: RestoreConflictSummary(
          mode: mode,
          decisionMode: mode == ImportConflictMode.replace
              ? RestoreDecisionMode.replaceLocalWithRemote
              : RestoreDecisionMode.mergeSafeDomains,
          willReplaceLocalProfiles: mode == ImportConflictMode.replace,
          willMergeProfiles: mode == ImportConflictMode.merge,
          safetySnapshotCreated: true,
        ),
      );
    }
  }
}

final backupRepositoryProvider = Provider<BackupRepository>(
  LocalBackupRepository.new,
);

AccountsAuthProvider? _mapProvider(AccountProviderType? provider) {
  return switch (provider) {
    AccountProviderType.signInWithApple => AccountsAuthProvider.apple,
    AccountProviderType.google => AccountsAuthProvider.google,
    AccountProviderType.emailMagicLink => AccountsAuthProvider.email,
    AccountProviderType.localOnly => AccountsAuthProvider.localOnly,
    null => null,
  };
}

BackupSourceType _backupSourceFromKey(String? key) {
  return switch (key) {
    'remoteBackup' => BackupSourceType.remoteBackup,
    'safetySnapshot' => BackupSourceType.safetySnapshot,
    _ => BackupSourceType.manualExport,
  };
}

AccountsAuthProvider? _backupProviderFromKey(String? key) {
  return switch (key) {
    'apple' => AccountsAuthProvider.apple,
    'google' => AccountsAuthProvider.google,
    'email' => AccountsAuthProvider.email,
    'localOnly' => AccountsAuthProvider.localOnly,
    _ => null,
  };
}

final syncPreferencesProvider = StateProvider<SyncPreferences>(
  (ref) => const SyncPreferences(
    keepLocalOnlyAvailable: true,
    preferManualBackup: true,
    allowRestoreSuggestions: true,
  ),
);

final syncScopePreferencesProvider = Provider<SyncScopePreferences>((ref) {
  return ref.watch(accountsSyncControllerProvider).syncScopePreferences;
});

class AccountsSyncStatusViewModel {
  const AccountsSyncStatusViewModel({
    required this.mode,
    required this.providerLabel,
    required this.accountLabel,
    required this.lastBackupAtIso,
    required this.lastRemoteBackupAtIso,
    required this.remoteProviderLabel,
    required this.remoteErrorCode,
    required this.remoteBackupConfigured,
  });

  final AccountsSyncConnectionMode mode;
  final String? providerLabel;
  final String? accountLabel;
  final String? lastBackupAtIso;
  final String? lastRemoteBackupAtIso;
  final String? remoteProviderLabel;
  final String? remoteErrorCode;
  final bool remoteBackupConfigured;
}

final accountsSyncStatusProvider = Provider<AccountsSyncStatusViewModel>((ref) {
  final state = ref.watch(accountsSyncControllerProvider);
  final auth = ref.watch(authStateProvider);
  final hasBackup = state.backupRecord.lastExportAtIso != null;
  final mode = switch (auth.status) {
    AuthStatus.localOnly || AuthStatus.unauthenticated =>
      hasBackup
          ? AccountsSyncConnectionMode.backupAvailable
          : AccountsSyncConnectionMode.localOnly,
    AuthStatus.authenticated =>
      hasBackup
          ? AccountsSyncConnectionMode.backupAvailable
          : AccountsSyncConnectionMode.signedInNoBackup,
  };
  return AccountsSyncStatusViewModel(
    mode: mode,
    providerLabel: state.authenticatedAccount?.provider.name,
    accountLabel: state.authenticatedAccount?.displayName,
    lastBackupAtIso: state.backupRecord.lastExportAtIso,
    lastRemoteBackupAtIso: state.remoteBackupRecord.lastRemoteBackupAtIso,
    remoteProviderLabel: state.remoteBackupRecord.providerKey,
    remoteErrorCode: state.remoteBackupRecord.lastRemoteErrorCode,
    remoteBackupConfigured:
        state.remoteBackupRecord.remoteBackupId != null &&
        state.remoteBackupRecord.lastRemoteBackupAtIso != null,
  );
});
