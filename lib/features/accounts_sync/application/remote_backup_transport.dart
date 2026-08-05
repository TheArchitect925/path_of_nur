import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/accounts_sync_models.dart';
import 'accounts_sync_controller.dart';
import 'accounts_sync_services.dart';
import 'backup_payload_fingerprint.dart';
import 'restore_comparison.dart';
import 'sync_scope_support.dart';

const _iCloudBackupChannelName = 'path_of_nur/icloud_sync';
const _googleDriveFilesBase = 'https://www.googleapis.com/drive/v3/files';
const _googleDriveUploadBase =
    'https://www.googleapis.com/upload/drive/v3/files';

class RemoteBackupPayload {
  const RemoteBackupPayload({
    required this.metadata,
    required this.payload,
    required this.checksum,
  });

  final RemoteBackupMetadata metadata;
  final String payload;
  final String checksum;
}

abstract class BackupTransport {
  RemoteBackupProvider get provider;

  Future<RemoteBackupAvailability> checkAvailability();

  Future<RemoteBackupMetadata?> fetchMetadata();

  Future<SyncOperationResult> upload(RemoteBackupPayload payload);

  Future<String?> downloadPayload(String backupId);
}

class AppleICloudBackupTransport implements BackupTransport {
  AppleICloudBackupTransport(this.ref);

  final Ref ref;

  static const MethodChannel _channel = MethodChannel(_iCloudBackupChannelName);

  @override
  RemoteBackupProvider get provider => RemoteBackupProvider.apple;

  @override
  Future<RemoteBackupAvailability> checkAvailability() async {
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS)) {
      return RemoteBackupAvailability.unavailable;
    }
    final available = await _channel.invokeMethod<bool>('isAvailable') ?? false;
    return available
        ? RemoteBackupAvailability.available
        : RemoteBackupAvailability.providerNotConfigured;
  }

  @override
  Future<RemoteBackupMetadata?> fetchMetadata() async {
    final state = ref.read(accountsSyncControllerProvider);
    final account = state.authenticatedAccount;
    if (account == null) {
      return null;
    }
    final response = await _channel.invokeMapMethod<String, dynamic>(
      'backupFileMetadata',
      <String, Object?>{'path': _appleBackupPath(account.identifier)},
    );
    if (response == null || response['exists'] != true) {
      return null;
    }
    return RemoteBackupMetadata(
      provider: provider,
      backupId:
          response['path']?.toString() ?? _appleBackupPath(account.identifier),
      schemaVersion:
          (response['schemaVersion'] as num?)?.toInt() ??
          accountsSyncBackupSchemaVersion,
      appVersion: response['appVersion']?.toString() ?? 'unknown',
      appBuild: response['buildNumber']?.toString() ?? 'unknown',
      createdAtIso:
          response['createdAtIso']?.toString() ??
          response['updatedAtIso']?.toString() ??
          DateTime.now().toIso8601String(),
      updatedAtIso:
          response['updatedAtIso']?.toString() ??
          DateTime.now().toIso8601String(),
      deviceLabel:
          response['deviceLabel']?.toString() ?? state.syncStatus.deviceName,
      accountLabel: response['accountLabel']?.toString() ?? account.displayName,
      payloadSizeBytes: (response['sizeBytes'] as num?)?.toInt() ?? 0,
      scopeSummary: response['scopeSummary'] is Map
          ? BackupScopeSummary.fromJson(
              (response['scopeSummary'] as Map).map(
                (key, value) => MapEntry(key.toString(), value),
              ),
            )
          : defaultFullBackupScopeSummary(),
      checksum: response['checksum']?.toString(),
    );
  }

  @override
  Future<SyncOperationResult> upload(RemoteBackupPayload payload) async {
    final availability = await checkAvailability();
    if (availability != RemoteBackupAvailability.available) {
      return SyncOperationResult(
        success: false,
        availability: availability,
        messageCode: 'icloud_unavailable',
      );
    }
    final ok =
        await _channel.invokeMethod<bool>('writeBackupFile', <String, Object?>{
          'path': payload.metadata.backupId,
          'value': payload.payload,
        }) ??
        false;
    if (!ok) {
      return const SyncOperationResult(
        success: false,
        availability: RemoteBackupAvailability.error,
        messageCode: 'icloud_write_failed',
      );
    }
    return SyncOperationResult(
      success: true,
      availability: RemoteBackupAvailability.available,
      metadata: payload.metadata,
    );
  }

  @override
  Future<String?> downloadPayload(String backupId) {
    return _channel.invokeMethod<String>('readBackupFile', <String, Object?>{
      'path': backupId,
    });
  }

  String _appleBackupPath(String identifier) {
    final safeIdentifier = identifier.replaceAll(
      RegExp(r'[^a-zA-Z0-9._-]'),
      '_',
    );
    return 'remote_backups/$safeIdentifier/path_of_nur_backup.json';
  }
}

class GoogleDriveBackupTransport implements BackupTransport {
  GoogleDriveBackupTransport(this.ref);

  final Ref ref;

  @override
  RemoteBackupProvider get provider => RemoteBackupProvider.google;

  @override
  Future<RemoteBackupAvailability> checkAvailability() async {
    final account = await _currentAccount();
    if (account == null) {
      return RemoteBackupAvailability.authExpired;
    }
    try {
      final headers = await account.authHeaders;
      return headers.containsKey('Authorization')
          ? RemoteBackupAvailability.available
          : RemoteBackupAvailability.providerNotConfigured;
    } catch (_) {
      return RemoteBackupAvailability.providerNotConfigured;
    }
  }

  @override
  Future<RemoteBackupMetadata?> fetchMetadata() async {
    final account = await _currentAccount();
    if (account == null) return null;
    final response = await _getJson(
      Uri.parse(
        "$_googleDriveFilesBase?q=name='path_of_nur_backup.json' and 'appDataFolder' in parents&spaces=appDataFolder&fields=files(id,name,modifiedTime,size,appProperties)",
      ),
      await account.authHeaders,
    );
    final files = (response['files'] as List?) ?? const <dynamic>[];
    if (files.isEmpty) {
      return null;
    }
    final file = (files.first as Map).map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final appProperties =
        (file['appProperties'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value),
        ) ??
        <String, dynamic>{};
    final includedDomainNames =
        (appProperties['includedDomains']?.toString() ?? '')
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList(growable: false);
    final excludedDomainNames =
        (appProperties['excludedDomains']?.toString() ?? '')
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList(growable: false);
    final requiredDomainNames =
        (appProperties['requiredDomains']?.toString() ?? '')
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList(growable: false);
    return RemoteBackupMetadata(
      provider: provider,
      backupId: file['id']?.toString() ?? '',
      schemaVersion:
          int.tryParse(appProperties['schemaVersion']?.toString() ?? '') ??
          accountsSyncBackupSchemaVersion,
      appVersion: appProperties['appVersion']?.toString() ?? 'unknown',
      appBuild: appProperties['buildNumber']?.toString() ?? 'unknown',
      createdAtIso:
          appProperties['createdAtIso']?.toString() ??
          file['modifiedTime']?.toString() ??
          DateTime.now().toIso8601String(),
      updatedAtIso:
          file['modifiedTime']?.toString() ?? DateTime.now().toIso8601String(),
      deviceLabel: appProperties['deviceLabel']?.toString() ?? 'Google Drive',
      accountLabel: account.displayName ?? account.email,
      payloadSizeBytes: int.tryParse(file['size']?.toString() ?? '') ?? 0,
      scopeSummary:
          includedDomainNames.isEmpty &&
              excludedDomainNames.isEmpty &&
              requiredDomainNames.isEmpty
          ? defaultFullBackupScopeSummary()
          : BackupScopeSummary(
              includedDomainNames: includedDomainNames,
              excludedDomainNames: excludedDomainNames,
              requiredDomainNames: requiredDomainNames,
            ),
      checksum: appProperties['checksum']?.toString(),
    );
  }

  @override
  Future<SyncOperationResult> upload(RemoteBackupPayload payload) async {
    final account = await _currentAccount();
    if (account == null) {
      return const SyncOperationResult(
        success: false,
        availability: RemoteBackupAvailability.authExpired,
        messageCode: 'google_auth_expired',
      );
    }
    final metadata = await fetchMetadata();
    final fileId = metadata?.backupId;
    final uri = Uri.parse(
      '${fileId == null ? _googleDriveUploadBase : "$_googleDriveUploadBase/$fileId"}?uploadType=multipart&fields=id,name,modifiedTime,size,appProperties',
    );
    final boundary = 'path_of_nur_backup_boundary';
    final metaJson = jsonEncode(<String, dynamic>{
      'name': 'path_of_nur_backup.json',
      'parents': <String>['appDataFolder'],
      'appProperties': <String, String>{
        'schemaVersion': payload.metadata.schemaVersion.toString(),
        'appVersion': payload.metadata.appVersion,
        'buildNumber': payload.metadata.appBuild,
        'createdAtIso': payload.metadata.createdAtIso,
        'deviceLabel': payload.metadata.deviceLabel,
        'accountLabel': payload.metadata.accountLabel,
        'includedDomains': payload.metadata.scopeSummary.includedDomainNames
            .join(','),
        'excludedDomains': payload.metadata.scopeSummary.excludedDomainNames
            .join(','),
        'requiredDomains': payload.metadata.scopeSummary.requiredDomainNames
            .join(','),
        'checksum': payload.checksum,
      },
    });
    final body =
        '--$boundary\r\n'
        'Content-Type: application/json; charset=UTF-8\r\n\r\n'
        '$metaJson\r\n'
        '--$boundary\r\n'
        'Content-Type: application/json; charset=UTF-8\r\n\r\n'
        '${payload.payload}\r\n'
        '--$boundary--';
    final result = await _sendRequest(
      method: fileId == null ? 'POST' : 'PATCH',
      uri: uri,
      headers: <String, String>{
        ...(await account.authHeaders),
        'Content-Type': 'multipart/related; boundary=$boundary',
      },
      body: utf8.encode(body),
    );
    if (result.statusCode < 200 || result.statusCode >= 300) {
      return const SyncOperationResult(
        success: false,
        availability: RemoteBackupAvailability.error,
        messageCode: 'google_drive_upload_failed',
      );
    }
    final decoded = jsonDecode(result.body) as Map<String, dynamic>;
    return SyncOperationResult(
      success: true,
      availability: RemoteBackupAvailability.available,
      metadata: RemoteBackupMetadata(
        provider: provider,
        backupId: decoded['id']?.toString() ?? fileId ?? '',
        schemaVersion: payload.metadata.schemaVersion,
        appVersion: payload.metadata.appVersion,
        appBuild: payload.metadata.appBuild,
        createdAtIso: payload.metadata.createdAtIso,
        updatedAtIso:
            decoded['modifiedTime']?.toString() ??
            DateTime.now().toIso8601String(),
        deviceLabel: payload.metadata.deviceLabel,
        accountLabel: payload.metadata.accountLabel,
        payloadSizeBytes: utf8.encode(payload.payload).length,
        scopeSummary: payload.metadata.scopeSummary,
        checksum: payload.checksum,
      ),
    );
  }

  @override
  Future<String?> downloadPayload(String backupId) async {
    final account = await _currentAccount();
    if (account == null) return null;
    final response = await _sendRequest(
      method: 'GET',
      uri: Uri.parse('$_googleDriveFilesBase/$backupId?alt=media'),
      headers: await account.authHeaders,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }
    return response.body;
  }

  Future<GoogleSignInAccount?> _currentAccount() async {
    final signIn = ref.read(googleSignInProvider);
    final current = signIn.currentUser;
    if (current != null) {
      return current;
    }
    try {
      return await signIn.signInSilently();
    } catch (_) {
      return null;
    }
  }
}

class EmailRemoteBackupTransport implements BackupTransport {
  const EmailRemoteBackupTransport();

  @override
  RemoteBackupProvider get provider => RemoteBackupProvider.email;

  @override
  Future<RemoteBackupAvailability> checkAvailability() async {
    return RemoteBackupAvailability.providerNotConfigured;
  }

  @override
  Future<RemoteBackupMetadata?> fetchMetadata() async => null;

  @override
  Future<String?> downloadPayload(String backupId) async => null;

  @override
  Future<SyncOperationResult> upload(RemoteBackupPayload payload) async {
    return const SyncOperationResult(
      success: false,
      availability: RemoteBackupAvailability.providerNotConfigured,
      messageCode: 'email_backup_not_configured',
    );
  }
}

class HttpResult {
  const HttpResult(this.statusCode, this.body);

  final int statusCode;
  final String body;
}

Future<Map<String, dynamic>> _getJson(
  Uri uri,
  Map<String, String> headers,
) async {
  final response = await _sendRequest(
    method: 'GET',
    uri: uri,
    headers: headers,
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException('Request failed: ${response.statusCode}');
  }
  final decoded = jsonDecode(response.body);
  if (decoded is! Map) return <String, dynamic>{};
  return decoded.map((key, value) => MapEntry(key.toString(), value));
}

Future<HttpResult> _sendRequest({
  required String method,
  required Uri uri,
  required Map<String, String> headers,
  List<int>? body,
}) async {
  final client = HttpClient();
  try {
    final request = await client.openUrl(method, uri);
    headers.forEach(request.headers.set);
    if (body != null) {
      request.add(body);
    }
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    return HttpResult(response.statusCode, responseBody);
  } finally {
    client.close(force: true);
  }
}

abstract class RemoteBackupRepository {
  Future<RemoteBackupAvailability> checkStatus();

  Future<RemoteBackupMetadata?> fetchRemoteMetadata();

  Future<SyncOperationResult> backupNow();

  Future<RestorePreview?> prepareRestorePreview();

  Future<RestoreResult> restoreRemote({required RestoreDecisionMode mode});
}

class DefaultRemoteBackupRepository implements RemoteBackupRepository {
  DefaultRemoteBackupRepository(this.ref);

  final Ref ref;

  BackupTransport? get _transport {
    final account = ref
        .read(accountsSyncControllerProvider)
        .authenticatedAccount;
    return switch (account?.provider) {
      AccountProviderType.signInWithApple => ref.read(
        appleRemoteBackupTransportProvider,
      ),
      AccountProviderType.google => ref.read(
        googleRemoteBackupTransportProvider,
      ),
      AccountProviderType.emailMagicLink => ref.read(
        emailRemoteBackupTransportProvider,
      ),
      _ => null,
    };
  }

  @override
  Future<RemoteBackupAvailability> checkStatus() async {
    final transport = _transport;
    if (transport == null) {
      return RemoteBackupAvailability.unavailable;
    }
    final availability = await transport.checkAvailability();
    final controller = ref.read(accountsSyncControllerProvider.notifier);
    await controller.updateRemoteBackupRecord(
      providerKey: transport.provider.name,
      lastRemoteCheckAtIso: DateTime.now().toIso8601String(),
      lastRemoteErrorCode: availability == RemoteBackupAvailability.available
          ? null
          : availability.name,
      clearRemoteErrorCode: availability == RemoteBackupAvailability.available,
    );
    return availability;
  }

  @override
  Future<RemoteBackupMetadata?> fetchRemoteMetadata() async {
    final transport = _transport;
    if (transport == null) {
      return null;
    }
    final metadata = await transport.fetchMetadata();
    await ref
        .read(accountsSyncControllerProvider.notifier)
        .updateRemoteBackupRecord(
          providerKey: transport.provider.name,
          remoteBackupId: metadata?.backupId,
          lastRemoteBackupAtIso: metadata?.updatedAtIso,
          lastRemoteCheckAtIso: DateTime.now().toIso8601String(),
          lastRemoteChecksum: metadata?.checksum,
          lastRemoteDeviceLabel: metadata?.deviceLabel,
          lastRemoteAccountLabel: metadata?.accountLabel,
          clearRemoteErrorCode: metadata != null,
        );
    return metadata;
  }

  @override
  Future<SyncOperationResult> backupNow() async {
    final transport = _transport;
    if (transport == null) {
      return const SyncOperationResult(
        success: false,
        availability: RemoteBackupAvailability.unavailable,
        messageCode: 'no_remote_provider',
      );
    }
    final packageInfo = await ref.read(accountsSyncPackageInfoProvider.future);
    final controller = ref.read(accountsSyncControllerProvider.notifier);
    final state = ref.read(accountsSyncControllerProvider);
    final payload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
      sourceType: BackupSourceType.remoteBackup,
      useSyncScope: true,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
    final checksum = sha256.convert(utf8.encode(payload)).toString();
    final dataSignature = backupPayloadFingerprint(payload);
    final account = state.authenticatedAccount;
    final remotePayload = RemoteBackupPayload(
      metadata: RemoteBackupMetadata(
        provider: transport.provider,
        backupId:
            state.remoteBackupRecord.remoteBackupId ??
            _defaultBackupId(
              transport.provider,
              account?.identifier ?? 'local',
            ),
        schemaVersion: accountsSyncBackupSchemaVersion,
        appVersion: packageInfo.version,
        appBuild: packageInfo.buildNumber,
        createdAtIso:
            state.remoteBackupRecord.lastRemoteBackupAtIso ??
            DateTime.now().toIso8601String(),
        updatedAtIso: DateTime.now().toIso8601String(),
        deviceLabel: state.syncStatus.deviceName,
        accountLabel: account?.displayName ?? 'Path of Nūr User',
        payloadSizeBytes: utf8.encode(payload).length,
        scopeSummary: buildBackupScopeSummary(state.syncScopePreferences),
        checksum: checksum,
      ),
      payload: payload,
      checksum: checksum,
    );
    final result = await transport.upload(remotePayload);
    await controller.updateRemoteBackupRecord(
      providerKey: transport.provider.name,
      remoteBackupId: result.metadata?.backupId,
      lastRemoteBackupAtIso: result.metadata?.updatedAtIso,
      lastRemoteCheckAtIso: DateTime.now().toIso8601String(),
      lastRemoteChecksum: result.metadata?.checksum,
      lastRemoteErrorCode: result.success ? null : result.messageCode,
      lastRemoteDeviceLabel: result.metadata?.deviceLabel,
      lastRemoteAccountLabel: result.metadata?.accountLabel,
      clearRemoteErrorCode: result.success,
    );
    await controller.updateAutoBackupState(
      lastAttemptAtIso: DateTime.now().toIso8601String(),
      lastTrigger: AutoBackupTrigger.manualRetry,
      lastSuccessAtIso: result.success
          ? DateTime.now().toIso8601String()
          : null,
      lastSuccessfulDataSignature: result.success ? dataSignature : null,
      dirty: result.success
          ? false
          : ref.read(accountsSyncControllerProvider).autoBackupState.dirty,
      pendingReasons: result.success
          ? const <PendingBackupReason>[]
          : ref
                .read(accountsSyncControllerProvider)
                .autoBackupState
                .pendingReasons,
      lastFailureCode: result.success ? null : result.messageCode,
      clearLastFailureCode: result.success,
    );
    return result;
  }

  @override
  Future<RestorePreview?> prepareRestorePreview() async {
    final transport = _transport;
    if (transport == null) {
      return null;
    }
    final packageInfo = await ref.read(accountsSyncPackageInfoProvider.future);
    final metadata = await fetchRemoteMetadata();
    if (metadata == null) {
      return null;
    }
    final payload = await transport.downloadPayload(metadata.backupId);
    if (payload == null) {
      return null;
    }
    final validation = await ref
        .read(backupRepositoryProvider)
        .validateImportPayload(payload: payload, encrypted: false);
    if (!validation.isValid || validation.preview == null) {
      return null;
    }
    final localPayload = await ref
        .read(accountsSyncControllerProvider.notifier)
        .buildBackupPayload(
          currentProfileOnly: false,
          encrypt: false,
          sourceType: BackupSourceType.safetySnapshot,
          useSyncScope: false,
          appVersion: packageInfo.version,
          buildNumber: packageInfo.buildNumber,
        );
    final localValidation = await ref
        .read(backupRepositoryProvider)
        .validateImportPayload(payload: localPayload, encrypted: false);
    if (!localValidation.isValid || localValidation.preview == null) {
      return null;
    }
    final comparison = ref
        .read(restoreComparisonEngineProvider)
        .compare(
          localPreview: localValidation.preview!,
          remotePreview: validation.preview!,
          remoteMetadata: metadata,
          state: ref.read(accountsSyncControllerProvider),
        );
    final localUpdatedAt = DateTime.tryParse(
      comparison.localOverallUpdatedAtIso ?? '',
    );
    final remoteUpdatedAt = DateTime.tryParse(
      comparison.remoteOverallUpdatedAtIso ?? '',
    );
    return RestorePreview(
      remoteMetadata: metadata,
      importPreview: validation.preview!,
      localImportPreview: localValidation.preview!,
      comparisonSummary: comparison,
      remoteNewerThanLocal:
          remoteUpdatedAt != null &&
          (localUpdatedAt == null || remoteUpdatedAt.isAfter(localUpdatedAt)),
      remoteOlderThanLocal:
          remoteUpdatedAt != null &&
          localUpdatedAt != null &&
          remoteUpdatedAt.isBefore(localUpdatedAt),
      localHasUnsavedNewerBackup:
          remoteUpdatedAt != null &&
          localUpdatedAt != null &&
          localUpdatedAt.isAfter(remoteUpdatedAt),
    );
  }

  @override
  Future<RestoreResult> restoreRemote({
    required RestoreDecisionMode mode,
  }) async {
    final preview = await prepareRestorePreview();
    if (preview == null) {
      return RestoreResult(
        applied: false,
        safetySnapshotPath: null,
        errorMessage: 'remote_restore_unavailable',
        conflictSummary: RestoreConflictSummary(
          mode: ImportConflictMode.replace,
          decisionMode: mode,
          willReplaceLocalProfiles:
              mode == RestoreDecisionMode.replaceLocalWithRemote,
          willMergeProfiles: mode == RestoreDecisionMode.mergeSafeDomains,
          safetySnapshotCreated: false,
        ),
      );
    }
    if (mode == RestoreDecisionMode.cancel ||
        mode == RestoreDecisionMode.keepLocalOnly) {
      return RestoreResult(
        applied: false,
        safetySnapshotPath: null,
        errorMessage: 'restore_cancelled',
        conflictSummary: RestoreConflictSummary(
          mode: ImportConflictMode.replace,
          decisionMode: mode,
          willReplaceLocalProfiles: false,
          willMergeProfiles: false,
          safetySnapshotCreated: false,
        ),
      );
    }
    late final ImportPackagePreview importPreview;
    late final ImportConflictMode importMode;
    late final List<String> mergedDomains;
    late final List<String> replacedDomains;
    late final List<String> skippedDomains;
    if (mode == RestoreDecisionMode.mergeSafeDomains) {
      final summary = preview.comparisonSummary;
      if (!summary.canMergeSafeDomains) {
        return RestoreResult(
          applied: false,
          safetySnapshotPath: null,
          errorMessage: 'merge_not_available',
          conflictSummary: RestoreConflictSummary(
            mode: ImportConflictMode.replace,
            decisionMode: mode,
            willReplaceLocalProfiles: false,
            willMergeProfiles: false,
            safetySnapshotCreated: false,
          ),
        );
      }
      final mergedPayload = ref
          .read(restoreComparisonEngineProvider)
          .buildMergedPayload(
            localPreview: preview.localImportPreview,
            remotePreview: preview.importPreview,
            summary: summary,
          );
      final mergedValidation = await ref
          .read(backupRepositoryProvider)
          .validateImportPayload(
            payload: jsonEncode(mergedPayload),
            encrypted: false,
          );
      if (!mergedValidation.isValid || mergedValidation.preview == null) {
        return RestoreResult(
          applied: false,
          safetySnapshotPath: null,
          errorMessage: 'invalid_merged_payload',
          conflictSummary: RestoreConflictSummary(
            mode: ImportConflictMode.replace,
            decisionMode: mode,
            willReplaceLocalProfiles: false,
            willMergeProfiles: true,
            safetySnapshotCreated: false,
          ),
        );
      }
      importPreview = mergedValidation.preview!;
      importMode = ImportConflictMode.replace;
      mergedDomains = summary.domainComparisons
          .where(
            (item) =>
                item.mergeEligibility == MergeEligibilityResult.safeToMerge &&
                item.conflictType != RestoreConflictType.identical,
          )
          .map((item) => item.domainId)
          .toList(growable: false);
      replacedDomains = summary.domainComparisons
          .where(
            (item) =>
                item.mergeEligibility != MergeEligibilityResult.safeToMerge &&
                item.remoteHasData,
          )
          .map((item) => item.domainId)
          .toList(growable: false);
      skippedDomains = summary.domainComparisons
          .where(
            (item) =>
                item.mergeEligibility != MergeEligibilityResult.safeToMerge &&
                !item.remoteHasData &&
                item.localHasData,
          )
          .map((item) => item.domainId)
          .toList(growable: false);
    } else {
      importPreview = preview.importPreview;
      importMode = ImportConflictMode.replace;
      mergedDomains = const <String>[];
      replacedDomains = preview.comparisonSummary.domainComparisons
          .where((item) => item.localHasData || item.remoteHasData)
          .map((item) => item.domainId)
          .toList(growable: false);
      skippedDomains = const <String>[];
    }
    final result = await ref
        .read(backupRepositoryProvider)
        .applyImport(preview: importPreview, mode: importMode);
    if (result.applied) {
      await ref
          .read(accountsSyncControllerProvider.notifier)
          .updateRemoteBackupRecord(
            lastRemoteRestoreAtIso: DateTime.now().toIso8601String(),
          );
      final normalizedPayload = mode == RestoreDecisionMode.mergeSafeDomains
          ? jsonEncode(
              ref
                  .read(restoreComparisonEngineProvider)
                  .buildMergedPayload(
                    localPreview: preview.localImportPreview,
                    remotePreview: preview.importPreview,
                    summary: preview.comparisonSummary,
                  ),
            )
          : preview.importPreview.rawPayload;
      await ref
          .read(accountsSyncControllerProvider.notifier)
          .updateAutoBackupState(
            dirty: false,
            pendingReasons: const <PendingBackupReason>[],
            lastSuccessfulDataSignature: backupPayloadFingerprint(
              normalizedPayload,
            ),
            clearLastFailureCode: true,
          );
    }
    final baseSummary = result.conflictSummary;
    return RestoreResult(
      applied: result.applied,
      safetySnapshotPath: result.safetySnapshotPath,
      errorMessage: result.errorMessage,
      conflictSummary: RestoreConflictSummary(
        mode: baseSummary.mode,
        decisionMode: mode,
        willReplaceLocalProfiles: baseSummary.willReplaceLocalProfiles,
        willMergeProfiles: mode == RestoreDecisionMode.mergeSafeDomains,
        safetySnapshotCreated: baseSummary.safetySnapshotCreated,
        mergedDomains: mergedDomains,
        replacedDomains: replacedDomains,
        skippedDomains: skippedDomains,
      ),
    );
  }

  String _defaultBackupId(RemoteBackupProvider provider, String identifier) {
    final safe = identifier.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    return switch (provider) {
      RemoteBackupProvider.apple =>
        'remote_backups/$safe/path_of_nur_backup.json',
      RemoteBackupProvider.google => 'path_of_nur_backup_$safe',
      RemoteBackupProvider.email => 'email_remote_backup_$safe',
    };
  }
}

final appleRemoteBackupTransportProvider = Provider<BackupTransport>(
  AppleICloudBackupTransport.new,
);
final googleRemoteBackupTransportProvider = Provider<BackupTransport>(
  GoogleDriveBackupTransport.new,
);
final emailRemoteBackupTransportProvider = Provider<BackupTransport>(
  (_) => const EmailRemoteBackupTransport(),
);
final remoteBackupRepositoryProvider = Provider<RemoteBackupRepository>(
  DefaultRemoteBackupRepository.new,
);
