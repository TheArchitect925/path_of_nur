import '../domain/accounts_sync_models.dart';

const List<SyncableDomain> kRequiredSyncDomains = <SyncableDomain>[
  SyncableDomain.profileBasics,
  SyncableDomain.prayerTracking,
  SyncableDomain.dhikrProgress,
  SyncableDomain.quranProgress,
  SyncableDomain.growthProgress,
  SyncableDomain.learningProgress,
];

const List<SyncableDomain> kOptionalSyncDomains = <SyncableDomain>[
  SyncableDomain.settingsPreferences,
  SyncableDomain.journalNotes,
  SyncableDomain.remindersPreferences,
  SyncableDomain.themeAccessibility,
];

const List<SyncableDomain> kAllSyncDomains = <SyncableDomain>[
  SyncableDomain.profileBasics,
  SyncableDomain.settingsPreferences,
  SyncableDomain.prayerTracking,
  SyncableDomain.dhikrProgress,
  SyncableDomain.quranProgress,
  SyncableDomain.growthProgress,
  SyncableDomain.learningProgress,
  SyncableDomain.journalNotes,
  SyncableDomain.remindersPreferences,
  SyncableDomain.themeAccessibility,
];

bool isRequiredSyncDomain(SyncableDomain domain) =>
    kRequiredSyncDomains.contains(domain);

bool isOptionalSyncDomain(SyncableDomain domain) =>
    kOptionalSyncDomains.contains(domain);

String syncableDomainKey(SyncableDomain domain) => switch (domain) {
  SyncableDomain.profileBasics => 'profile_basics',
  SyncableDomain.settingsPreferences => 'settings_preferences',
  SyncableDomain.prayerTracking => 'prayer_tracking',
  SyncableDomain.dhikrProgress => 'dhikr_progress',
  SyncableDomain.quranProgress => 'quran_progress',
  SyncableDomain.growthProgress => 'xp_drops_ocean',
  SyncableDomain.learningProgress => 'learning_progress',
  SyncableDomain.journalNotes => 'journal_notes',
  SyncableDomain.remindersPreferences => 'reminders_preferences',
  SyncableDomain.themeAccessibility => 'theme_accessibility',
};

SyncableDomain? syncableDomainFromKey(String key) {
  for (final domain in kAllSyncDomains) {
    if (syncableDomainKey(domain) == key) {
      return domain;
    }
  }
  return null;
}

DomainBackupInclusionState inclusionStateForDomain(
  SyncScopePreferences preferences,
  SyncableDomain domain,
) {
  if (isRequiredSyncDomain(domain)) {
    return DomainBackupInclusionState.requiredCore;
  }
  if (!isOptionalSyncDomain(domain)) {
    return DomainBackupInclusionState.unsupported;
  }
  return preferences.excludedOptionalDomainNameSet.contains(
        syncableDomainKey(domain),
      )
      ? DomainBackupInclusionState.excluded
      : DomainBackupInclusionState.included;
}

bool isDomainIncludedInBackup(
  SyncScopePreferences preferences,
  SyncableDomain domain,
) {
  final state = inclusionStateForDomain(preferences, domain);
  return state == DomainBackupInclusionState.included ||
      state == DomainBackupInclusionState.requiredCore;
}

SyncScopePreferences updateSyncScopePreference(
  SyncScopePreferences preferences, {
  required SyncableDomain domain,
  required bool includeInBackup,
}) {
  if (!isOptionalSyncDomain(domain)) {
    return preferences;
  }
  final next = preferences.excludedOptionalDomainNames.toSet();
  final key = syncableDomainKey(domain);
  if (includeInBackup) {
    next.remove(key);
  } else {
    next.add(key);
  }
  return preferences.copyWith(
    excludedOptionalDomainNames: next.toList()..sort(),
  );
}

BackupScopeSummary buildBackupScopeSummary(SyncScopePreferences preferences) {
  final included = <String>[];
  final excluded = <String>[];
  final required = <String>[];
  for (final domain in kAllSyncDomains) {
    final key = syncableDomainKey(domain);
    final state = inclusionStateForDomain(preferences, domain);
    if (state == DomainBackupInclusionState.requiredCore) {
      required.add(key);
      included.add(key);
    } else if (state == DomainBackupInclusionState.included) {
      included.add(key);
    } else if (state == DomainBackupInclusionState.excluded) {
      excluded.add(key);
    }
  }
  return BackupScopeSummary(
    includedDomainNames: included,
    excludedDomainNames: excluded,
    requiredDomainNames: required,
  );
}

BackupScopeSummary defaultFullBackupScopeSummary() => buildBackupScopeSummary(
  const SyncScopePreferences(excludedOptionalDomainNames: <String>[]),
);

ScopeValidationResult buildScopeValidationResult(
  SyncScopePreferences preferences,
  SyncableDomain domain,
) {
  final currentState = inclusionStateForDomain(preferences, domain);
  if (!isOptionalSyncDomain(domain)) {
    return ScopeValidationResult(
      domain: domain,
      currentState: currentState,
      canToggle: false,
    );
  }
  final nextIncluded = currentState == DomainBackupInclusionState.excluded;
  return ScopeValidationResult(
    domain: domain,
    currentState: currentState,
    canToggle: true,
    impactPreview: ScopeChangeImpactPreview(
      domain: domain,
      nextState: nextIncluded
          ? DomainBackupInclusionState.included
          : DomainBackupInclusionState.excluded,
      requiresConfirmation: !nextIncluded,
      messageCode: nextIncluded
          ? 'scope_include_${syncableDomainKey(domain)}'
          : 'scope_exclude_${syncableDomainKey(domain)}',
    ),
  );
}

SyncableDomain? syncableDomainForSnapshotKey(String key) {
  if (_journalMatcher(key)) {
    return SyncableDomain.journalNotes;
  }
  if (_themeMatcher(key)) {
    return SyncableDomain.themeAccessibility;
  }
  if (_reminderMatcher(key)) {
    return SyncableDomain.remindersPreferences;
  }
  if (_quranMatcher(key)) {
    return SyncableDomain.quranProgress;
  }
  if (_learningMatcher(key)) {
    return SyncableDomain.learningProgress;
  }
  if (_settingsMatcher(key)) {
    return SyncableDomain.settingsPreferences;
  }
  return null;
}

Map<String, Map<String, dynamic>> scopeProfileSnapshots(
  Map<String, Map<String, dynamic>> profileSnapshots,
  SyncScopePreferences preferences,
) {
  final scoped = <String, Map<String, dynamic>>{};
  for (final entry in profileSnapshots.entries) {
    final nextSnapshot = <String, dynamic>{};
    for (final snapshotEntry in entry.value.entries) {
      final domain = syncableDomainForSnapshotKey(snapshotEntry.key);
      if (domain == null || isDomainIncludedInBackup(preferences, domain)) {
        nextSnapshot[snapshotEntry.key] = snapshotEntry.value;
      }
    }
    scoped[entry.key] = nextSnapshot;
  }
  return scoped;
}

Map<String, dynamic> scopeStructuredDataByProfile(
  Map<String, dynamic> structuredData,
  SyncScopePreferences preferences,
) {
  final scoped = <String, dynamic>{};
  for (final entry in structuredData.entries) {
    final domain = syncableDomainForStructuredKey(entry.key);
    if (domain == null || isDomainIncludedInBackup(preferences, domain)) {
      scoped[entry.key] = entry.value;
    }
  }
  return scoped;
}

Map<String, dynamic> preserveExcludedLocalDomainsInPayload({
  required Map<String, dynamic> localPayload,
  required Map<String, dynamic> incomingPayload,
  required BackupScopeSummary scopeSummary,
}) {
  if (!scopeSummary.isPartial) {
    return incomingPayload;
  }
  final nextPayload = Map<String, dynamic>.from(incomingPayload);
  final localSnapshots = _mapOfMaps(localPayload['profileSnapshots']);
  final incomingSnapshots = _mapOfMaps(incomingPayload['profileSnapshots']);
  final mergedSnapshots = <String, Map<String, dynamic>>{};
  final allProfileIds = <String>{
    ...localSnapshots.keys,
    ...incomingSnapshots.keys,
  };
  final excludedDomains = scopeSummary.excludedDomainNames
      .map(syncableDomainFromKey)
      .whereType<SyncableDomain>()
      .toSet();

  for (final profileId in allProfileIds) {
    final localSnapshot = Map<String, dynamic>.from(
      localSnapshots[profileId] ?? const <String, dynamic>{},
    );
    final incomingSnapshot = Map<String, dynamic>.from(
      incomingSnapshots[profileId] ?? const <String, dynamic>{},
    );
    for (final entry in localSnapshot.entries) {
      final domain = syncableDomainForSnapshotKey(entry.key);
      if (domain != null && excludedDomains.contains(domain)) {
        incomingSnapshot[entry.key] = entry.value;
      }
    }
    mergedSnapshots[profileId] = incomingSnapshot;
  }
  nextPayload['profileSnapshots'] = mergedSnapshots;
  return nextPayload;
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

SyncableDomain? syncableDomainForStructuredKey(String key) => switch (key) {
  'prayerRecords' => SyncableDomain.prayerTracking,
  'dhikrState' || 'dhikrSessions' => SyncableDomain.dhikrProgress,
  'oceanState' ||
  'oceanEvents' ||
  'xpLedgerEntries' ||
  'xpSummary' ||
  'dropEvents' ||
  'dropSummary' => SyncableDomain.growthProgress,
  _ => null,
};

bool _settingsMatcher(String key) {
  final normalized = key.toLowerCase();
  return normalized.contains('profile.') ||
      normalized.contains('settings') ||
      normalized.contains('preference') ||
      normalized.contains('family_learning') ||
      normalized.contains('parent') ||
      normalized.contains('shared_device');
}

bool _reminderMatcher(String key) {
  final normalized = key.toLowerCase();
  return normalized.contains('reminder') ||
      normalized.contains('notification') ||
      normalized.contains('adhan') ||
      normalized.contains('prayer') ||
      normalized.contains('location');
}

bool _themeMatcher(String key) {
  final normalized = key.toLowerCase();
  return normalized.contains('theme') ||
      normalized.contains('appearance') ||
      normalized.contains('accessibility') ||
      normalized.contains('locale') ||
      normalized.contains('language') ||
      normalized.contains('font');
}

bool _quranMatcher(String key) {
  final normalized = key.toLowerCase();
  return normalized.contains('quran') ||
      normalized.contains('surah') ||
      normalized.contains('ayah') ||
      normalized.contains('bookmark') ||
      normalized.contains('memor') ||
      normalized.contains('reflection');
}

bool _learningMatcher(String key) {
  final normalized = key.toLowerCase();
  return normalized.contains('learn') ||
      normalized.contains('journey') ||
      normalized.contains('arabic') ||
      normalized.contains('dua') ||
      normalized.contains('hadith') ||
      normalized.contains('story') ||
      normalized.contains('quiz') ||
      normalized.contains('game');
}

bool _journalMatcher(String key) {
  final normalized = key.toLowerCase();
  return normalized.contains('journal') || normalized.contains('note');
}
