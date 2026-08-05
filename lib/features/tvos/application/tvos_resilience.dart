import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../../accounts_sync/application/sync_scope_support.dart';
import '../../../shared/persistence/app_database.dart';
import '../../../shared/persistence/local_store.dart';
import '../data/tvos_content_registry.dart';
import '../data/tvos_foundation_registry.dart';
import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_resilience_models.dart';

TVOSResilienceSnapshot buildTVOSResilienceSnapshot({
  required AccountsSyncState accountsSyncState,
  required LocalStore localStore,
  required AppDatabase appDatabase,
  required List<TVOSSurfaceFlag> enabledSurfaceFlags,
  DateTime? now,
}) {
  final preferenceCount = localStore.dumpAll().length;
  final structuredDataRowCount = _structuredDataRowCount(appDatabase);
  final pendingOutboxCount = _countRows(
    appDatabase,
    'SELECT COUNT(*) AS value FROM sync_outbox WHERE status != ?;',
    <Object?>['acknowledged'],
  );
  final routeSnapshots = enabledSurfaceFlags
      .map((flag) => _buildRouteSnapshot(flag.routePath))
      .toList(growable: false);
  final scopeSummary = buildBackupScopeSummary(
    accountsSyncState.syncScopePreferences,
  );

  return TVOSResilienceSnapshot(
    generatedAtIso: (now ?? DateTime.now().toUtc()).toIso8601String(),
    offlineReadiness: _offlineReadinessFor(
      preferenceCount: preferenceCount,
      structuredDataRowCount: structuredDataRowCount,
      routeSnapshots: routeSnapshots,
    ),
    syncAwareness: _syncAwarenessFor(accountsSyncState),
    localPreferenceCount: preferenceCount,
    structuredDataRowCount: structuredDataRowCount,
    pendingOutboxCount: pendingOutboxCount,
    lastManualBackupAtIso: accountsSyncState.backupRecord.lastExportAtIso,
    lastRemoteBackupAtIso:
        accountsSyncState.remoteBackupRecord.lastRemoteBackupAtIso,
    includedBackupDomains: scopeSummary.includedDomainNames,
    routeSnapshots: routeSnapshots,
  );
}

final tvosResilienceSnapshotProvider = Provider<TVOSResilienceSnapshot>((ref) {
  final accountsSyncState = ref.watch(accountsSyncControllerProvider);
  final localStore = ref.watch(localStoreProvider);
  final appDatabase = ref.watch(appDatabaseProvider);
  final enabledSurfaceFlags = tvosSurfaceFlags
      .where((flag) => flag.availability == TVOSFeatureAvailability.enabled)
      .toList(growable: false);
  return buildTVOSResilienceSnapshot(
    accountsSyncState: accountsSyncState,
    localStore: localStore,
    appDatabase: appDatabase,
    enabledSurfaceFlags: enabledSurfaceFlags,
  );
});

TVOSRouteResilienceSnapshot _buildRouteSnapshot(String routePath) {
  final modules = tvosContentModulesForRoute(routePath);
  final parityBackedSectionCount = modules
      .where((module) => module.requiresSharedParityPayload)
      .length;
  return TVOSRouteResilienceSnapshot(
    routePath: routePath,
    sectionCount: modules.length,
    parityBackedSectionCount: parityBackedSectionCount,
    offlineReady: true,
    syncAware: _syncAwareRoutes.contains(routePath),
    notes: _routeResilienceNote(routePath),
  );
}

TVOSOfflineReadiness _offlineReadinessFor({
  required int preferenceCount,
  required int structuredDataRowCount,
  required List<TVOSRouteResilienceSnapshot> routeSnapshots,
}) {
  if (structuredDataRowCount > 0 || preferenceCount > 0) {
    if (routeSnapshots.any((snapshot) => snapshot.syncAware)) {
      return TVOSOfflineReadiness.cacheAndSyncAware;
    }
    return TVOSOfflineReadiness.cachedLocalData;
  }
  return TVOSOfflineReadiness.bundledFallback;
}

TVOSSyncAwareness _syncAwarenessFor(AccountsSyncState state) {
  if (state.syncStatus.syncState == SyncStateKind.offlinePending ||
      state.syncStatus.pendingChangesCount > 0) {
    return TVOSSyncAwareness.pendingSync;
  }
  if (state.remoteBackupRecord.lastRemoteBackupAtIso != null) {
    return TVOSSyncAwareness.remoteBackupReady;
  }
  if (state.backupRecord.lastExportAtIso != null) {
    return TVOSSyncAwareness.manualBackupReady;
  }
  final syncMode = state.activeProfile?.syncMode ?? state.syncStatus.syncMode;
  if (syncMode == ProfileSyncMode.localOnly ||
      syncMode == ProfileSyncMode.manualBackupOnly) {
    return TVOSSyncAwareness.localOnly;
  }
  return TVOSSyncAwareness.deferredToCompanion;
}

int _structuredDataRowCount(AppDatabase appDatabase) {
  return _countRows(
        appDatabase,
        'SELECT COUNT(*) AS value FROM prayer_records;',
      ) +
      _countRows(appDatabase, 'SELECT COUNT(*) AS value FROM dhikr_state;') +
      _countRows(appDatabase, 'SELECT COUNT(*) AS value FROM dhikr_sessions;') +
      _countRows(appDatabase, 'SELECT COUNT(*) AS value FROM sync_outbox;') +
      _countRows(appDatabase, 'SELECT COUNT(*) AS value FROM sync_cursor;');
}

int _countRows(
  AppDatabase appDatabase,
  String sql, [
  List<Object?> parameters = const <Object?>[],
]) {
  final rows = appDatabase.select(sql, parameters);
  if (rows.isEmpty) {
    return 0;
  }
  return (rows.first['value'] as int?) ?? 0;
}

const Set<String> _syncAwareRoutes = <String>{
  '/home',
  '/accounts-sync/profiles',
  '/quran',
  '/quran/bookmarks',
  '/learn',
  '/learn/games',
  '/learn/kids/fun-learning',
  '/quran/arabic',
  '/worship/prayer',
  '/worship/dhikr',
};

String _routeResilienceNote(String routePath) {
  switch (routePath) {
    case '/home':
    case '/quran':
    case '/quran/bookmarks':
      return 'Qur’an, prayer rhythm, and saved return paths should stay usable offline while deeper backup and sync controls remain on iPhone or iPad.';
    case '/accounts-sync/profiles':
      return 'Household switching and last-used room continuity should stay available on tvOS, while deeper account, backup, and permission management remains on companion devices.';
    case '/worship/prayer':
    case '/worship/dhikr':
      return 'Worship surfaces should remain calm and readable offline, even when transport sync is deferred or temporarily unavailable.';
    default:
      return 'Learning and family-room content should remain bundled or cache-safe on tvOS, with heavier authoring and sync decisions deferred to companion devices.';
  }
}
