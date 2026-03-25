enum TVOSOfflineReadiness {
  bundledFallback,
  cachedLocalData,
  cacheAndSyncAware,
}

enum TVOSSyncAwareness {
  localOnly,
  manualBackupReady,
  remoteBackupReady,
  pendingSync,
  deferredToCompanion,
}

class TVOSRouteResilienceSnapshot {
  const TVOSRouteResilienceSnapshot({
    required this.routePath,
    required this.sectionCount,
    required this.parityBackedSectionCount,
    required this.offlineReady,
    required this.syncAware,
    required this.notes,
  });

  final String routePath;
  final int sectionCount;
  final int parityBackedSectionCount;
  final bool offlineReady;
  final bool syncAware;
  final String notes;

  Map<String, Object> toJson() => <String, Object>{
    'routePath': routePath,
    'sectionCount': sectionCount,
    'parityBackedSectionCount': parityBackedSectionCount,
    'offlineReady': offlineReady,
    'syncAware': syncAware,
    'notes': notes,
  };
}

class TVOSResilienceSnapshot {
  const TVOSResilienceSnapshot({
    required this.generatedAtIso,
    required this.offlineReadiness,
    required this.syncAwareness,
    required this.localPreferenceCount,
    required this.structuredDataRowCount,
    required this.pendingOutboxCount,
    required this.lastManualBackupAtIso,
    required this.lastRemoteBackupAtIso,
    required this.includedBackupDomains,
    required this.routeSnapshots,
  });

  final String generatedAtIso;
  final TVOSOfflineReadiness offlineReadiness;
  final TVOSSyncAwareness syncAwareness;
  final int localPreferenceCount;
  final int structuredDataRowCount;
  final int pendingOutboxCount;
  final String? lastManualBackupAtIso;
  final String? lastRemoteBackupAtIso;
  final List<String> includedBackupDomains;
  final List<TVOSRouteResilienceSnapshot> routeSnapshots;

  Map<String, Object?> toJson() => <String, Object?>{
    'generatedAtIso': generatedAtIso,
    'offlineReadiness': offlineReadiness.name,
    'syncAwareness': syncAwareness.name,
    'localPreferenceCount': localPreferenceCount,
    'structuredDataRowCount': structuredDataRowCount,
    'pendingOutboxCount': pendingOutboxCount,
    'lastManualBackupAtIso': lastManualBackupAtIso,
    'lastRemoteBackupAtIso': lastRemoteBackupAtIso,
    'includedBackupDomains': includedBackupDomains,
    'routeSnapshots': routeSnapshots.map((item) => item.toJson()).toList(),
  };
}
