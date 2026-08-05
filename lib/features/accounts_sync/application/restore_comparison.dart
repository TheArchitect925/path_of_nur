import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/accounts_sync_models.dart';
import 'accounts_sync_controller.dart';
import 'accounts_sync_services.dart';
import 'sync_scope_support.dart';

final restoreComparisonEngineProvider = Provider<RestoreComparisonEngine>(
  (ref) => RestoreComparisonEngine(),
);

class RestoreComparisonEngine {
  const RestoreComparisonEngine();

  RestoreComparisonSummary compare({
    required ImportPackagePreview localPreview,
    required ImportPackagePreview remotePreview,
    required RemoteBackupMetadata remoteMetadata,
    required AccountsSyncState state,
  }) {
    final localPayload = localPreview.decodedPayload;
    final remotePayload = remotePreview.decodedPayload;
    final providerMismatch =
        localPreview.metadata.provider != null &&
        localPreview.metadata.provider != remotePreview.metadata.provider;
    final accountMismatch = _hasAccountMismatch(
      state: state,
      localPreview: localPreview,
      remotePreview: remotePreview,
      remoteMetadata: remoteMetadata,
    );
    final schemaMismatch =
        remotePreview.metadata.schemaVersion > accountsSyncBackupSchemaVersion;

    final domains = <RestoreDomainComparison>[
      _compareProfileBasics(localPayload, remotePayload),
      _compareSnapshotDomain(
        domain: SyncableDomain.settingsPreferences,
        localPayload: localPayload,
        remotePayload: remotePayload,
      ),
      _compareStructuredDomain(
        domainId: 'prayer_tracking',
        localPayload: localPayload,
        remotePayload: remotePayload,
      ),
      _compareDhikrDomain(localPayload, remotePayload),
      _compareSnapshotDomain(
        domain: SyncableDomain.quranProgress,
        localPayload: localPayload,
        remotePayload: remotePayload,
      ),
      _compareStructuredUnionDomain(
        domainId: 'xp_drops_ocean',
        localPayload: localPayload,
        remotePayload: remotePayload,
        localKeys: const <String>[
          'xpLedgerEntries',
          'xpSummary',
          'dropEvents',
          'dropSummary',
          'oceanEvents',
          'oceanState',
        ],
        remoteKeys: const <String>[
          'xpLedgerEntries',
          'xpSummary',
          'dropEvents',
          'dropSummary',
          'oceanEvents',
          'oceanState',
        ],
      ),
      _compareSnapshotDomain(
        domain: SyncableDomain.learningProgress,
        localPayload: localPayload,
        remotePayload: remotePayload,
      ),
      _compareSnapshotDomain(
        domain: SyncableDomain.journalNotes,
        localPayload: localPayload,
        remotePayload: remotePayload,
      ),
      _compareSnapshotDomain(
        domain: SyncableDomain.remindersPreferences,
        localPayload: localPayload,
        remotePayload: remotePayload,
      ),
      _compareSnapshotDomain(
        domain: SyncableDomain.themeAccessibility,
        localPayload: localPayload,
        remotePayload: remotePayload,
      ),
    ];

    final warningCodes = <String>[
      if (providerMismatch) 'provider_mismatch',
      if (accountMismatch) 'account_mismatch',
      if (schemaMismatch) 'incompatible_schema',
      if (domains.any(
        (item) => item.conflictType == RestoreConflictType.localNewer,
      ))
        'local_newer_progress',
      if (domains.any(
        (item) => item.conflictType == RestoreConflictType.remoteNewer,
      ))
        'remote_newer_progress',
      if (domains.any(
        (item) => item.conflictType == RestoreConflictType.localOnlyData,
      ))
        'local_only_data',
      if (domains.any(
        (item) => item.conflictType == RestoreConflictType.remoteOnlyData,
      ))
        'remote_only_data',
      if (domains.any(
        (item) => item.conflictType == RestoreConflictType.uncertainDifference,
      ))
        'uncertain_difference',
    ];

    final canMergeSafeDomains =
        !providerMismatch &&
        !accountMismatch &&
        !schemaMismatch &&
        domains.any(
          (item) =>
              item.mergeEligibility == MergeEligibilityResult.safeToMerge &&
              item.conflictType != RestoreConflictType.identical,
        );

    return RestoreComparisonSummary(
      overallConflictType: _resolveOverallConflictType(
        domains: domains,
        providerMismatch: providerMismatch,
        accountMismatch: accountMismatch,
        schemaMismatch: schemaMismatch,
      ),
      localOverallUpdatedAtIso: _latestIso(
        domains.map((item) => item.localUpdatedAtIso),
      ),
      remoteOverallUpdatedAtIso: _latestIso(
        domains.map((item) => item.remoteUpdatedAtIso),
      ),
      domainComparisons: domains,
      availableDecisionModes: <RestoreDecisionMode>[
        RestoreDecisionMode.cancel,
        RestoreDecisionMode.keepLocalOnly,
        if (!schemaMismatch) RestoreDecisionMode.replaceLocalWithRemote,
        if (canMergeSafeDomains) RestoreDecisionMode.mergeSafeDomains,
      ],
      warningCodes: warningCodes,
      hasAccountMismatch: accountMismatch,
      hasProviderMismatch: providerMismatch,
      hasSchemaMismatch: schemaMismatch,
      canMergeSafeDomains: canMergeSafeDomains,
    );
  }

  Map<String, dynamic> buildMergedPayload({
    required ImportPackagePreview localPreview,
    required ImportPackagePreview remotePreview,
    required RestoreComparisonSummary summary,
  }) {
    final merged =
        jsonDecode(jsonEncode(remotePreview.decodedPayload))
            as Map<String, dynamic>;
    final localPayload = localPreview.decodedPayload;
    final remotePayload = remotePreview.decodedPayload;

    merged['accounts'] = _mergeAccounts(
      _mapList(localPayload['accounts']),
      _mapList(remotePayload['accounts']),
    );
    merged['profiles'] = _mergeProfiles(
      _mapList(localPayload['profiles']),
      _mapList(remotePayload['profiles']),
    );
    merged['profileSnapshots'] = _mergeProfileSnapshots(
      localPayload['profileSnapshots'],
      remotePayload['profileSnapshots'],
    );
    merged['structuredDataByProfile'] = _mergeStructuredDataByProfile(
      localPayload['structuredDataByProfile'],
      remotePayload['structuredDataByProfile'],
      summary,
    );
    final metadata =
        (merged['metadata'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value),
        ) ??
        <String, dynamic>{};
    metadata['sourceType'] = BackupSourceType.remoteBackup.name;
    metadata['mergeMode'] = RestoreDecisionMode.mergeSafeDomains.name;
    merged['metadata'] = metadata;
    return merged;
  }

  bool _hasAccountMismatch({
    required AccountsSyncState state,
    required ImportPackagePreview localPreview,
    required ImportPackagePreview remotePreview,
    required RemoteBackupMetadata remoteMetadata,
  }) {
    final localIdentity = state.authenticatedAccount;
    if (localIdentity == null) {
      return false;
    }
    final remoteAccountLabel = remoteMetadata.accountLabel.isNotEmpty
        ? remoteMetadata.accountLabel
        : remotePreview.metadata.accountLabel;
    final localLabels = <String>{
      localIdentity.displayName.trim().toLowerCase(),
      localIdentity.identifier.trim().toLowerCase(),
      if (localPreview.metadata.accountLabel != null)
        localPreview.metadata.accountLabel!.trim().toLowerCase(),
    }..removeWhere((item) => item.isEmpty);
    if (remoteAccountLabel == null || remoteAccountLabel.trim().isEmpty) {
      return false;
    }
    return !localLabels.contains(remoteAccountLabel.trim().toLowerCase());
  }

  RestoreDomainComparison _compareProfileBasics(
    Map<String, dynamic> localPayload,
    Map<String, dynamic> remotePayload,
  ) {
    final localAccounts = _mapList(localPayload['accounts']);
    final remoteAccounts = _mapList(remotePayload['accounts']);
    final localProfiles = _mapList(localPayload['profiles']);
    final remoteProfiles = _mapList(remotePayload['profiles']);
    final localIds = <String>{
      ...localAccounts.map(
        (item) => 'account:${item['provider']}:${item['identifier']}',
      ),
      ...localProfiles.map((item) => 'profile:${item['profileId']}'),
    };
    final remoteIds = <String>{
      ...remoteAccounts.map(
        (item) => 'account:${item['provider']}:${item['identifier']}',
      ),
      ...remoteProfiles.map((item) => 'profile:${item['profileId']}'),
    };
    return RestoreDomainComparison(
      domainId: 'profile_basics',
      conflictType: _compareSets(
        localIds,
        remoteIds,
        localUpdatedAtIso: _latestIso(<String?>[
          ...localAccounts.map((item) => item['lastLoginAtIso']?.toString()),
          ...localProfiles.map((item) => item['updatedAtIso']?.toString()),
        ]),
        remoteUpdatedAtIso: _latestIso(<String?>[
          ...remoteAccounts.map((item) => item['lastLoginAtIso']?.toString()),
          ...remoteProfiles.map((item) => item['updatedAtIso']?.toString()),
        ]),
      ),
      mergeEligibility: MergeEligibilityResult.safeToMerge,
      localItemCount: localIds.length,
      remoteItemCount: remoteIds.length,
      localHasData: localIds.isNotEmpty,
      remoteHasData: remoteIds.isNotEmpty,
      localUpdatedAtIso: _latestIso(<String?>[
        ...localAccounts.map((item) => item['lastLoginAtIso']?.toString()),
        ...localProfiles.map((item) => item['updatedAtIso']?.toString()),
      ]),
      remoteUpdatedAtIso: _latestIso(<String?>[
        ...remoteAccounts.map((item) => item['lastLoginAtIso']?.toString()),
        ...remoteProfiles.map((item) => item['updatedAtIso']?.toString()),
      ]),
    );
  }

  RestoreDomainComparison _compareStructuredDomain({
    required String domainId,
    required Map<String, dynamic> localPayload,
    required Map<String, dynamic> remotePayload,
  }) {
    final localProfiles = _structuredProfiles(localPayload);
    final remoteProfiles = _structuredProfiles(remotePayload);
    final localRecords = <String, String?>{};
    final remoteRecords = <String, String?>{};
    for (final entry in localProfiles.entries) {
      final rows = _mapList(entry.value['prayerRecords']);
      for (final row in rows) {
        localRecords['${entry.key}:${row['dayKey']}:${row['prayer']}'] =
            row['updatedAtIso']?.toString();
      }
    }
    for (final entry in remoteProfiles.entries) {
      final rows = _mapList(entry.value['prayerRecords']);
      for (final row in rows) {
        remoteRecords['${entry.key}:${row['dayKey']}:${row['prayer']}'] =
            row['updatedAtIso']?.toString();
      }
    }
    final localUpdated = _latestIso(localRecords.values);
    final remoteUpdated = _latestIso(remoteRecords.values);
    return RestoreDomainComparison(
      domainId: domainId,
      conflictType: _compareSets(
        localRecords.keys.toSet(),
        remoteRecords.keys.toSet(),
        localUpdatedAtIso: localUpdated,
        remoteUpdatedAtIso: remoteUpdated,
      ),
      mergeEligibility: MergeEligibilityResult.safeToMerge,
      localItemCount: localRecords.length,
      remoteItemCount: remoteRecords.length,
      localHasData: localRecords.isNotEmpty,
      remoteHasData: remoteRecords.isNotEmpty,
      localUpdatedAtIso: localUpdated,
      remoteUpdatedAtIso: remoteUpdated,
    );
  }

  RestoreDomainComparison _compareDhikrDomain(
    Map<String, dynamic> localPayload,
    Map<String, dynamic> remotePayload,
  ) {
    final localProfiles = _structuredProfiles(localPayload);
    final remoteProfiles = _structuredProfiles(remotePayload);
    final localIds = <String>{};
    final remoteIds = <String>{};
    final localUpdatedCandidates = <String?>[];
    final remoteUpdatedCandidates = <String?>[];
    for (final entry in localProfiles.entries) {
      final state = _mapOrNull(entry.value['dhikrState']);
      if (state != null) {
        localIds.add(
          '${entry.key}:state:${state['selectedPresetId']}:${state['target']}:${state['currentCount']}',
        );
        localUpdatedCandidates.add(state['updatedAtIso']?.toString());
      }
      for (final row in _mapList(entry.value['dhikrSessions'])) {
        localIds.add('${entry.key}:session:${row['sessionId']}');
        localUpdatedCandidates.add(row['finishedAtIso']?.toString());
      }
    }
    for (final entry in remoteProfiles.entries) {
      final state = _mapOrNull(entry.value['dhikrState']);
      if (state != null) {
        remoteIds.add(
          '${entry.key}:state:${state['selectedPresetId']}:${state['target']}:${state['currentCount']}',
        );
        remoteUpdatedCandidates.add(state['updatedAtIso']?.toString());
      }
      for (final row in _mapList(entry.value['dhikrSessions'])) {
        remoteIds.add('${entry.key}:session:${row['sessionId']}');
        remoteUpdatedCandidates.add(row['finishedAtIso']?.toString());
      }
    }
    final localUpdated = _latestIso(localUpdatedCandidates);
    final remoteUpdated = _latestIso(remoteUpdatedCandidates);
    return RestoreDomainComparison(
      domainId: 'dhikr_progress',
      conflictType: _compareSets(
        localIds,
        remoteIds,
        localUpdatedAtIso: localUpdated,
        remoteUpdatedAtIso: remoteUpdated,
      ),
      mergeEligibility: MergeEligibilityResult.safeToMerge,
      localItemCount: localIds.length,
      remoteItemCount: remoteIds.length,
      localHasData: localIds.isNotEmpty,
      remoteHasData: remoteIds.isNotEmpty,
      localUpdatedAtIso: localUpdated,
      remoteUpdatedAtIso: remoteUpdated,
    );
  }

  RestoreDomainComparison _compareStructuredUnionDomain({
    required String domainId,
    required Map<String, dynamic> localPayload,
    required Map<String, dynamic> remotePayload,
    required List<String> localKeys,
    required List<String> remoteKeys,
  }) {
    final localProfiles = _structuredProfiles(localPayload);
    final remoteProfiles = _structuredProfiles(remotePayload);
    final localIds = <String>{};
    final remoteIds = <String>{};
    final localUpdatedCandidates = <String?>[];
    final remoteUpdatedCandidates = <String?>[];
    for (final entry in localProfiles.entries) {
      for (final key in localKeys) {
        final value = entry.value[key];
        if (value is List) {
          for (final row in _mapList(value)) {
            final id =
                row['entryId'] ??
                row['eventId'] ??
                row['id'] ??
                row['sourceRef'] ??
                row['occurredAtIso'];
            if (id != null) {
              localIds.add('${entry.key}:$key:$id');
            }
            localUpdatedCandidates.add(
              row['updatedAtIso']?.toString() ??
                  row['createdAtIso']?.toString() ??
                  row['occurredAtIso']?.toString() ??
                  row['timestamp']?.toString(),
            );
          }
        } else if (value is Map) {
          localIds.add('${entry.key}:$key');
          localUpdatedCandidates.add(value['updatedAtIso']?.toString());
        }
      }
    }
    for (final entry in remoteProfiles.entries) {
      for (final key in remoteKeys) {
        final value = entry.value[key];
        if (value is List) {
          for (final row in _mapList(value)) {
            final id =
                row['entryId'] ??
                row['eventId'] ??
                row['id'] ??
                row['sourceRef'] ??
                row['occurredAtIso'];
            if (id != null) {
              remoteIds.add('${entry.key}:$key:$id');
            }
            remoteUpdatedCandidates.add(
              row['updatedAtIso']?.toString() ??
                  row['createdAtIso']?.toString() ??
                  row['occurredAtIso']?.toString() ??
                  row['timestamp']?.toString(),
            );
          }
        } else if (value is Map) {
          remoteIds.add('${entry.key}:$key');
          remoteUpdatedCandidates.add(value['updatedAtIso']?.toString());
        }
      }
    }
    final localUpdated = _latestIso(localUpdatedCandidates);
    final remoteUpdated = _latestIso(remoteUpdatedCandidates);
    return RestoreDomainComparison(
      domainId: domainId,
      conflictType: _compareSets(
        localIds,
        remoteIds,
        localUpdatedAtIso: localUpdated,
        remoteUpdatedAtIso: remoteUpdated,
      ),
      mergeEligibility: MergeEligibilityResult.replaceOnly,
      localItemCount: localIds.length,
      remoteItemCount: remoteIds.length,
      localHasData: localIds.isNotEmpty,
      remoteHasData: remoteIds.isNotEmpty,
      localUpdatedAtIso: localUpdated,
      remoteUpdatedAtIso: remoteUpdated,
    );
  }

  RestoreDomainComparison _compareSnapshotDomain({
    required SyncableDomain domain,
    required Map<String, dynamic> localPayload,
    required Map<String, dynamic> remotePayload,
  }) {
    final localSnapshot = _snapshotDomainEntries(localPayload, domain);
    final remoteSnapshot = _snapshotDomainEntries(remotePayload, domain);
    return RestoreDomainComparison(
      domainId: syncableDomainKey(domain),
      conflictType: _compareApproximateDomain(localSnapshot, remoteSnapshot),
      mergeEligibility: MergeEligibilityResult.replaceOnly,
      localItemCount: localSnapshot.length,
      remoteItemCount: remoteSnapshot.length,
      localHasData: localSnapshot.isNotEmpty,
      remoteHasData: remoteSnapshot.isNotEmpty,
    );
  }

  RestoreConflictType _compareApproximateDomain(
    Map<String, dynamic> localEntries,
    Map<String, dynamic> remoteEntries,
  ) {
    if (localEntries.isEmpty && remoteEntries.isEmpty) {
      return RestoreConflictType.identical;
    }
    if (localEntries.isEmpty) {
      return RestoreConflictType.remoteOnlyData;
    }
    if (remoteEntries.isEmpty) {
      return RestoreConflictType.localOnlyData;
    }
    final localEncoded = jsonEncode(localEntries);
    final remoteEncoded = jsonEncode(remoteEntries);
    if (localEncoded == remoteEncoded) {
      return RestoreConflictType.identical;
    }
    return RestoreConflictType.uncertainDifference;
  }

  RestoreConflictType _compareSets(
    Set<String> localIds,
    Set<String> remoteIds, {
    String? localUpdatedAtIso,
    String? remoteUpdatedAtIso,
  }) {
    if (localIds.isEmpty && remoteIds.isEmpty) {
      return RestoreConflictType.identical;
    }
    if (localIds.isEmpty) {
      return RestoreConflictType.remoteOnlyData;
    }
    if (remoteIds.isEmpty) {
      return RestoreConflictType.localOnlyData;
    }
    if (setEquals(localIds, remoteIds)) {
      final localUpdated = _parseIso(localUpdatedAtIso);
      final remoteUpdated = _parseIso(remoteUpdatedAtIso);
      if (localUpdated != null &&
          remoteUpdated != null &&
          remoteUpdated.isAfter(localUpdated)) {
        return RestoreConflictType.remoteNewer;
      }
      if (localUpdated != null &&
          remoteUpdated != null &&
          localUpdated.isAfter(remoteUpdated)) {
        return RestoreConflictType.localNewer;
      }
      return RestoreConflictType.identical;
    }
    final remoteHasUnique = remoteIds.difference(localIds).isNotEmpty;
    final localHasUnique = localIds.difference(remoteIds).isNotEmpty;
    if (remoteHasUnique && !localHasUnique) {
      return RestoreConflictType.remoteOnlyData;
    }
    if (localHasUnique && !remoteHasUnique) {
      return RestoreConflictType.localOnlyData;
    }
    final localUpdated = _parseIso(localUpdatedAtIso);
    final remoteUpdated = _parseIso(remoteUpdatedAtIso);
    if (localUpdated != null &&
        remoteUpdated != null &&
        remoteUpdated.isAfter(localUpdated)) {
      return RestoreConflictType.remoteNewer;
    }
    if (localUpdated != null &&
        remoteUpdated != null &&
        localUpdated.isAfter(remoteUpdated)) {
      return RestoreConflictType.localNewer;
    }
    return RestoreConflictType.uncertainDifference;
  }

  RestoreConflictType _resolveOverallConflictType({
    required List<RestoreDomainComparison> domains,
    required bool providerMismatch,
    required bool accountMismatch,
    required bool schemaMismatch,
  }) {
    if (schemaMismatch) {
      return RestoreConflictType.incompatibleSchema;
    }
    if (providerMismatch) {
      return RestoreConflictType.providerMismatch;
    }
    if (accountMismatch) {
      return RestoreConflictType.accountMismatch;
    }
    if (domains.every(
      (item) => item.conflictType == RestoreConflictType.identical,
    )) {
      return RestoreConflictType.identical;
    }
    if (domains.any(
      (item) => item.conflictType == RestoreConflictType.localNewer,
    )) {
      return RestoreConflictType.localNewer;
    }
    if (domains.any(
      (item) => item.conflictType == RestoreConflictType.remoteNewer,
    )) {
      return RestoreConflictType.remoteNewer;
    }
    if (domains.any(
      (item) => item.conflictType == RestoreConflictType.localOnlyData,
    )) {
      return RestoreConflictType.localOnlyData;
    }
    if (domains.any(
      (item) => item.conflictType == RestoreConflictType.remoteOnlyData,
    )) {
      return RestoreConflictType.remoteOnlyData;
    }
    return RestoreConflictType.uncertainDifference;
  }

  List<Map<String, dynamic>> _mergeAccounts(
    List<Map<String, dynamic>> localAccounts,
    List<Map<String, dynamic>> remoteAccounts,
  ) {
    final byKey = <String, Map<String, dynamic>>{};
    for (final item in remoteAccounts) {
      byKey['${item['provider']}:${item['identifier']}'] = item;
    }
    for (final item in localAccounts) {
      final key = '${item['provider']}:${item['identifier']}';
      final existing = byKey[key];
      if (existing == null) {
        byKey[key] = item;
      } else {
        byKey[key] = _pickLatestMap(item, existing, 'lastLoginAtIso');
      }
    }
    return byKey.values.toList(growable: false);
  }

  List<Map<String, dynamic>> _mergeProfiles(
    List<Map<String, dynamic>> localProfiles,
    List<Map<String, dynamic>> remoteProfiles,
  ) {
    final byId = <String, Map<String, dynamic>>{};
    for (final item in remoteProfiles) {
      byId[item['profileId']?.toString() ?? ''] = item;
    }
    for (final item in localProfiles) {
      final key = item['profileId']?.toString() ?? '';
      final existing = byId[key];
      if (existing == null) {
        byId[key] = item;
      } else {
        byId[key] = _pickLatestMap(item, existing, 'updatedAtIso');
      }
    }
    return byId.values
        .where((item) => (item['profileId']?.toString() ?? '').isNotEmpty)
        .toList(growable: false);
  }

  Map<String, dynamic> _mergeProfileSnapshots(
    Object? localRaw,
    Object? remoteRaw,
  ) {
    final local = _mapOfMaps(localRaw);
    final remote = _mapOfMaps(remoteRaw);
    return <String, dynamic>{...local, ...remote};
  }

  Map<String, dynamic> _mergeStructuredDataByProfile(
    Object? localRaw,
    Object? remoteRaw,
    RestoreComparisonSummary summary,
  ) {
    final local = _mapOfMaps(localRaw);
    final remote = _mapOfMaps(remoteRaw);
    final merged = <String, dynamic>{};
    final allProfileIds = <String>{...local.keys, ...remote.keys};
    final canMergePrayer = summary.domainComparisons.any(
      (item) =>
          item.domainId == 'prayer_tracking' &&
          item.mergeEligibility == MergeEligibilityResult.safeToMerge,
    );
    final canMergeDhikr = summary.domainComparisons.any(
      (item) =>
          item.domainId == 'dhikr_progress' &&
          item.mergeEligibility == MergeEligibilityResult.safeToMerge,
    );
    for (final profileId in allProfileIds) {
      final localData = _mapOrNull(local[profileId]) ?? <String, dynamic>{};
      final remoteData = _mapOrNull(remote[profileId]) ?? <String, dynamic>{};
      if (localData.isEmpty) {
        merged[profileId] = remoteData;
        continue;
      }
      if (remoteData.isEmpty) {
        merged[profileId] = localData;
        continue;
      }
      final next = Map<String, dynamic>.from(remoteData);
      if (canMergePrayer) {
        next['prayerRecords'] = _mergePrayerRecords(
          _mapList(localData['prayerRecords']),
          _mapList(remoteData['prayerRecords']),
        );
      }
      if (canMergeDhikr) {
        next['dhikrSessions'] = _mergeDhikrSessions(
          _mapList(localData['dhikrSessions']),
          _mapList(remoteData['dhikrSessions']),
        );
        next['dhikrState'] = _mergeLatestMap(
          _mapOrNull(localData['dhikrState']),
          _mapOrNull(remoteData['dhikrState']),
          'updatedAtIso',
        );
      }
      merged[profileId] = next;
    }
    return merged;
  }

  List<Map<String, dynamic>> _mergePrayerRecords(
    List<Map<String, dynamic>> localRows,
    List<Map<String, dynamic>> remoteRows,
  ) {
    final byId = <String, Map<String, dynamic>>{};
    for (final row in remoteRows) {
      byId['${row['dayKey']}:${row['prayer']}'] = row;
    }
    for (final row in localRows) {
      final key = '${row['dayKey']}:${row['prayer']}';
      final existing = byId[key];
      if (existing == null) {
        byId[key] = row;
      } else {
        byId[key] = _pickLatestMap(row, existing, 'updatedAtIso');
      }
    }
    return byId.values.toList(growable: false);
  }

  List<Map<String, dynamic>> _mergeDhikrSessions(
    List<Map<String, dynamic>> localRows,
    List<Map<String, dynamic>> remoteRows,
  ) {
    final byId = <String, Map<String, dynamic>>{};
    for (final row in remoteRows) {
      byId[row['sessionId']?.toString() ?? ''] = row;
    }
    for (final row in localRows) {
      final key = row['sessionId']?.toString() ?? '';
      final existing = byId[key];
      if (existing == null) {
        byId[key] = row;
      } else {
        byId[key] = _pickLatestMap(row, existing, 'finishedAtIso');
      }
    }
    return byId.values
        .where((row) => (row['sessionId']?.toString() ?? '').isNotEmpty)
        .toList(growable: false);
  }

  Map<String, Map<String, dynamic>> _structuredProfiles(
    Map<String, dynamic> payload,
  ) {
    return _mapOfMaps(payload['structuredDataByProfile']);
  }

  Map<String, dynamic> _snapshotDomainEntries(
    Map<String, dynamic> payload,
    SyncableDomain domain,
  ) {
    final snapshots = _mapOfMaps(payload['profileSnapshots']);
    final aggregate = <String, dynamic>{};
    for (final entry in snapshots.entries) {
      for (final snapshotEntry in entry.value.entries) {
        if (syncableDomainForSnapshotKey(snapshotEntry.key) == domain) {
          aggregate['${entry.key}:${snapshotEntry.key}'] = snapshotEntry.value;
        }
      }
    }
    return aggregate;
  }

  List<Map<String, dynamic>> _mapList(Object? raw) {
    if (raw is! List) return const <Map<String, dynamic>>[];
    return raw
        .whereType<Map>()
        .map(
          (item) => item.map((key, value) => MapEntry(key.toString(), value)),
        )
        .toList(growable: false);
  }

  Map<String, dynamic>? _mapOrNull(Object? raw) {
    if (raw is! Map) return null;
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }

  Map<String, Map<String, dynamic>> _mapOfMaps(Object? raw) {
    if (raw is! Map) return const <String, Map<String, dynamic>>{};
    return raw.map(
      (key, value) => MapEntry(
        key.toString(),
        value is Map
            ? value.map(
                (innerKey, innerValue) =>
                    MapEntry(innerKey.toString(), innerValue),
              )
            : <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> _pickLatestMap(
    Map<String, dynamic> left,
    Map<String, dynamic> right,
    String timestampKey,
  ) {
    final leftTime = _parseIso(left[timestampKey]?.toString());
    final rightTime = _parseIso(right[timestampKey]?.toString());
    if (leftTime == null && rightTime == null) {
      return right;
    }
    if (rightTime == null) {
      return left;
    }
    if (leftTime == null) {
      return right;
    }
    return leftTime.isAfter(rightTime) ? left : right;
  }

  Map<String, dynamic>? _mergeLatestMap(
    Map<String, dynamic>? local,
    Map<String, dynamic>? remote,
    String timestampKey,
  ) {
    if (local == null) return remote;
    if (remote == null) return local;
    return _pickLatestMap(local, remote, timestampKey);
  }
}

DateTime? _parseIso(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return DateTime.tryParse(value);
}

String? _latestIso(Iterable<String?> values) {
  DateTime? latest;
  String? latestValue;
  for (final value in values) {
    final parsed = _parseIso(value);
    if (parsed == null) {
      continue;
    }
    if (latest == null || parsed.isAfter(latest)) {
      latest = parsed;
      latestValue = value;
    }
  }
  return latestValue;
}
