enum AccountsAuthProvider {
  localOnly,
  apple,
  google,
  email,
}

enum AccountsSyncConnectionMode {
  localOnly,
  signedInNoBackup,
  backupAvailable,
  backupInProgress,
  restoreAvailable,
  syncError,
}

enum BackupSourceType {
  manualExport,
  safetySnapshot,
  remoteBackup,
}

enum RemoteBackupProvider {
  apple,
  google,
  email,
}

enum RemoteBackupAvailability {
  unknown,
  unavailable,
  available,
  noBackup,
  providerNotConfigured,
  authExpired,
  error,
}

enum ImportConflictMode {
  merge,
  replace,
}

enum RestoreConflictType {
  identical,
  remoteNewer,
  localNewer,
  remoteOnlyData,
  localOnlyData,
  incompatibleSchema,
  uncertainDifference,
  accountMismatch,
  providerMismatch,
}

enum RestoreDecisionMode {
  cancel,
  replaceLocalWithRemote,
  mergeSafeDomains,
  keepLocalOnly,
}

enum MergeEligibilityResult {
  safeToMerge,
  replaceOnly,
  unsafe,
  unsupported,
}

enum AutoBackupFrequency {
  smart,
  daily,
  weekly,
  manualOnly,
}

enum AutoBackupTrigger {
  appLaunch,
  appResumed,
  appBackgrounded,
  signIn,
  manualRetry,
}

enum AutoBackupEligibilityResult {
  eligibleNow,
  disabled,
  manualOnly,
  notSignedIn,
  providerUnavailable,
  noMeaningfulChanges,
  throttled,
  backupAlreadyRunning,
  waitingForSchedule,
}

enum PendingBackupReason {
  meaningfulProgressChanged,
  backupOverdue,
  signedIn,
  manualRetry,
}

enum SyncableDomain {
  profileBasics,
  settingsPreferences,
  prayerTracking,
  dhikrProgress,
  quranProgress,
  growthProgress,
  learningProgress,
  journalNotes,
  remindersPreferences,
  themeAccessibility,
}

enum DomainBackupInclusionState {
  included,
  excluded,
  requiredCore,
  unsupported,
}

enum AuthActionStatus {
  success,
  cancelled,
  unavailable,
  notConfigured,
  error,
}

class AccountIdentity {
  const AccountIdentity({
    required this.provider,
    required this.identifier,
    required this.displayName,
    this.email,
  });

  final AccountsAuthProvider provider;
  final String identifier;
  final String displayName;
  final String? email;
}

class SyncPreferences {
  const SyncPreferences({
    required this.keepLocalOnlyAvailable,
    required this.preferManualBackup,
    required this.allowRestoreSuggestions,
  });

  final bool keepLocalOnlyAvailable;
  final bool preferManualBackup;
  final bool allowRestoreSuggestions;

  SyncPreferences copyWith({
    bool? keepLocalOnlyAvailable,
    bool? preferManualBackup,
    bool? allowRestoreSuggestions,
  }) {
    return SyncPreferences(
      keepLocalOnlyAvailable:
          keepLocalOnlyAvailable ?? this.keepLocalOnlyAvailable,
      preferManualBackup: preferManualBackup ?? this.preferManualBackup,
      allowRestoreSuggestions:
          allowRestoreSuggestions ?? this.allowRestoreSuggestions,
    );
  }
}

class SyncScopePreferences {
  const SyncScopePreferences({
    required this.excludedOptionalDomainNames,
  });

  final List<String> excludedOptionalDomainNames;

  Set<String> get excludedOptionalDomainNameSet =>
      excludedOptionalDomainNames.toSet();

  SyncScopePreferences copyWith({
    List<String>? excludedOptionalDomainNames,
  }) {
    return SyncScopePreferences(
      excludedOptionalDomainNames:
          excludedOptionalDomainNames ?? this.excludedOptionalDomainNames,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'excludedOptionalDomainNames': excludedOptionalDomainNames,
  };

  factory SyncScopePreferences.fromJson(Map<String, dynamic>? json) =>
      SyncScopePreferences(
        excludedOptionalDomainNames:
            (json?['excludedOptionalDomainNames'] as List?)
                ?.map((item) => item.toString())
                .toList(growable: false) ??
            const <String>[],
      );
}

class BackupScopeSummary {
  const BackupScopeSummary({
    required this.includedDomainNames,
    required this.excludedDomainNames,
    required this.requiredDomainNames,
  });

  final List<String> includedDomainNames;
  final List<String> excludedDomainNames;
  final List<String> requiredDomainNames;

  bool get isPartial => excludedDomainNames.isNotEmpty;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'includedDomainNames': includedDomainNames,
    'excludedDomainNames': excludedDomainNames,
    'requiredDomainNames': requiredDomainNames,
    'isPartial': isPartial,
  };

  factory BackupScopeSummary.fromJson(Map<String, dynamic>? json) =>
      BackupScopeSummary(
        includedDomainNames:
            (json?['includedDomainNames'] as List?)
                ?.map((item) => item.toString())
                .toList(growable: false) ??
            const <String>[],
        excludedDomainNames:
            (json?['excludedDomainNames'] as List?)
                ?.map((item) => item.toString())
                .toList(growable: false) ??
            const <String>[],
        requiredDomainNames:
            (json?['requiredDomainNames'] as List?)
                ?.map((item) => item.toString())
                .toList(growable: false) ??
            const <String>[],
      );
}

class ScopeChangeImpactPreview {
  const ScopeChangeImpactPreview({
    required this.domain,
    required this.nextState,
    required this.requiresConfirmation,
    required this.messageCode,
  });

  final SyncableDomain domain;
  final DomainBackupInclusionState nextState;
  final bool requiresConfirmation;
  final String messageCode;
}

class ScopeValidationResult {
  const ScopeValidationResult({
    required this.domain,
    required this.currentState,
    required this.canToggle,
    this.impactPreview,
  });

  final SyncableDomain domain;
  final DomainBackupInclusionState currentState;
  final bool canToggle;
  final ScopeChangeImpactPreview? impactPreview;
}

class BackupMetadata {
  const BackupMetadata({
    required this.schemaVersion,
    required this.appVersion,
    required this.appBuild,
    required this.sourceType,
    required this.exportedAtIso,
    required this.currentProfileOnly,
    required this.encrypted,
    required this.scopeSummary,
    this.provider,
    this.accountLabel,
    this.deviceLabel,
    this.lastBackupAtIso,
  });

  final int schemaVersion;
  final String appVersion;
  final String appBuild;
  final BackupSourceType sourceType;
  final String exportedAtIso;
  final bool currentProfileOnly;
  final bool encrypted;
  final BackupScopeSummary scopeSummary;
  final AccountsAuthProvider? provider;
  final String? accountLabel;
  final String? deviceLabel;
  final String? lastBackupAtIso;
}

class RemoteBackupMetadata {
  const RemoteBackupMetadata({
    required this.provider,
    required this.backupId,
    required this.schemaVersion,
    required this.appVersion,
    required this.appBuild,
    required this.createdAtIso,
    required this.updatedAtIso,
    required this.deviceLabel,
    required this.accountLabel,
    required this.payloadSizeBytes,
    required this.scopeSummary,
    this.checksum,
  });

  final RemoteBackupProvider provider;
  final String backupId;
  final int schemaVersion;
  final String appVersion;
  final String appBuild;
  final String createdAtIso;
  final String updatedAtIso;
  final String deviceLabel;
  final String accountLabel;
  final int payloadSizeBytes;
  final BackupScopeSummary scopeSummary;
  final String? checksum;
}

class ImportPackagePreview {
  const ImportPackagePreview({
    required this.metadata,
    required this.accountCount,
    required this.profileCount,
    required this.profileNames,
    required this.warnings,
    required this.rawPayload,
    required this.decodedPayload,
  });

  final BackupMetadata metadata;
  final int accountCount;
  final int profileCount;
  final List<String> profileNames;
  final List<String> warnings;
  final String rawPayload;
  final Map<String, dynamic> decodedPayload;
}

class RestoreConflictSummary {
  const RestoreConflictSummary({
    required this.mode,
    required this.decisionMode,
    required this.willReplaceLocalProfiles,
    required this.willMergeProfiles,
    required this.safetySnapshotCreated,
    this.mergedDomains = const <String>[],
    this.replacedDomains = const <String>[],
    this.skippedDomains = const <String>[],
  });

  final ImportConflictMode mode;
  final RestoreDecisionMode decisionMode;
  final bool willReplaceLocalProfiles;
  final bool willMergeProfiles;
  final bool safetySnapshotCreated;
  final List<String> mergedDomains;
  final List<String> replacedDomains;
  final List<String> skippedDomains;
}

class ImportValidationResult {
  const ImportValidationResult.success(this.preview)
    : errorCode = null,
      errorMessage = null;

  const ImportValidationResult.failure({
    required this.errorCode,
    required this.errorMessage,
  }) : preview = null;

  final ImportPackagePreview? preview;
  final String? errorCode;
  final String? errorMessage;

  bool get isValid => preview != null;
}

class RestoreResult {
  const RestoreResult({
    required this.applied,
    required this.conflictSummary,
    required this.safetySnapshotPath,
    this.errorMessage,
  });

  final bool applied;
  final RestoreConflictSummary conflictSummary;
  final String? safetySnapshotPath;
  final String? errorMessage;
}

class RestorePreview {
  const RestorePreview({
    required this.remoteMetadata,
    required this.importPreview,
    required this.localImportPreview,
    required this.comparisonSummary,
    required this.remoteNewerThanLocal,
    required this.remoteOlderThanLocal,
    required this.localHasUnsavedNewerBackup,
  });

  final RemoteBackupMetadata remoteMetadata;
  final ImportPackagePreview importPreview;
  final ImportPackagePreview localImportPreview;
  final RestoreComparisonSummary comparisonSummary;
  final bool remoteNewerThanLocal;
  final bool remoteOlderThanLocal;
  final bool localHasUnsavedNewerBackup;
}

class RestoreDomainComparison {
  const RestoreDomainComparison({
    required this.domainId,
    required this.conflictType,
    required this.mergeEligibility,
    required this.localItemCount,
    required this.remoteItemCount,
    required this.localHasData,
    required this.remoteHasData,
    this.localUpdatedAtIso,
    this.remoteUpdatedAtIso,
    this.warningCodes = const <String>[],
  });

  final String domainId;
  final RestoreConflictType conflictType;
  final MergeEligibilityResult mergeEligibility;
  final int localItemCount;
  final int remoteItemCount;
  final bool localHasData;
  final bool remoteHasData;
  final String? localUpdatedAtIso;
  final String? remoteUpdatedAtIso;
  final List<String> warningCodes;
}

class RestoreComparisonSummary {
  const RestoreComparisonSummary({
    required this.overallConflictType,
    required this.localOverallUpdatedAtIso,
    required this.remoteOverallUpdatedAtIso,
    required this.domainComparisons,
    required this.availableDecisionModes,
    required this.warningCodes,
    required this.hasAccountMismatch,
    required this.hasProviderMismatch,
    required this.hasSchemaMismatch,
    required this.canMergeSafeDomains,
  });

  final RestoreConflictType overallConflictType;
  final String? localOverallUpdatedAtIso;
  final String? remoteOverallUpdatedAtIso;
  final List<RestoreDomainComparison> domainComparisons;
  final List<RestoreDecisionMode> availableDecisionModes;
  final List<String> warningCodes;
  final bool hasAccountMismatch;
  final bool hasProviderMismatch;
  final bool hasSchemaMismatch;
  final bool canMergeSafeDomains;
}

class SyncOperationResult {
  const SyncOperationResult({
    required this.success,
    required this.availability,
    this.metadata,
    this.messageCode,
  });

  final bool success;
  final RemoteBackupAvailability availability;
  final RemoteBackupMetadata? metadata;
  final String? messageCode;
}

class AuthActionResult {
  const AuthActionResult({
    required this.status,
    this.identity,
    this.message,
  });

  final AuthActionStatus status;
  final AccountIdentity? identity;
  final String? message;
}

class AutoBackupPreferences {
  const AutoBackupPreferences({
    required this.enabled,
    required this.frequency,
    required this.backupOnMeaningfulProgressChange,
    required this.backupOnBackground,
    required this.minimumIntervalMinutes,
  });

  final bool enabled;
  final AutoBackupFrequency frequency;
  final bool backupOnMeaningfulProgressChange;
  final bool backupOnBackground;
  final int minimumIntervalMinutes;

  AutoBackupPreferences copyWith({
    bool? enabled,
    AutoBackupFrequency? frequency,
    bool? backupOnMeaningfulProgressChange,
    bool? backupOnBackground,
    int? minimumIntervalMinutes,
  }) {
    return AutoBackupPreferences(
      enabled: enabled ?? this.enabled,
      frequency: frequency ?? this.frequency,
      backupOnMeaningfulProgressChange:
          backupOnMeaningfulProgressChange ??
          this.backupOnMeaningfulProgressChange,
      backupOnBackground: backupOnBackground ?? this.backupOnBackground,
      minimumIntervalMinutes:
          minimumIntervalMinutes ?? this.minimumIntervalMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'frequency': frequency.name,
    'backupOnMeaningfulProgressChange': backupOnMeaningfulProgressChange,
    'backupOnBackground': backupOnBackground,
    'minimumIntervalMinutes': minimumIntervalMinutes,
  };

  factory AutoBackupPreferences.fromJson(Map<String, dynamic>? json) =>
      AutoBackupPreferences(
        enabled: json?['enabled'] as bool? ?? false,
        frequency: AutoBackupFrequency.values.byName(
          json?['frequency']?.toString() ?? AutoBackupFrequency.smart.name,
        ),
        backupOnMeaningfulProgressChange:
            json?['backupOnMeaningfulProgressChange'] as bool? ?? true,
        backupOnBackground: json?['backupOnBackground'] as bool? ?? true,
        minimumIntervalMinutes:
            (json?['minimumIntervalMinutes'] as num?)?.toInt() ?? 240,
      );
}

class AutoBackupPolicyState {
  const AutoBackupPolicyState({
    required this.preferences,
    required this.dirty,
    required this.pendingReasons,
    required this.lastAttemptAtIso,
    required this.lastSuccessAtIso,
    required this.lastFailureCode,
    required this.lastTrigger,
    required this.lastEvaluatedAtIso,
    required this.lastSuccessfulDataSignature,
    required this.lastEvaluatedDataSignature,
    required this.inProgress,
  });

  final AutoBackupPreferences preferences;
  final bool dirty;
  final List<PendingBackupReason> pendingReasons;
  final String? lastAttemptAtIso;
  final String? lastSuccessAtIso;
  final String? lastFailureCode;
  final AutoBackupTrigger? lastTrigger;
  final String? lastEvaluatedAtIso;
  final String? lastSuccessfulDataSignature;
  final String? lastEvaluatedDataSignature;
  final bool inProgress;

  AutoBackupPolicyState copyWith({
    AutoBackupPreferences? preferences,
    bool? dirty,
    List<PendingBackupReason>? pendingReasons,
    String? lastAttemptAtIso,
    String? lastSuccessAtIso,
    String? lastFailureCode,
    AutoBackupTrigger? lastTrigger,
    String? lastEvaluatedAtIso,
    String? lastSuccessfulDataSignature,
    String? lastEvaluatedDataSignature,
    bool? inProgress,
    bool clearLastFailureCode = false,
  }) {
    return AutoBackupPolicyState(
      preferences: preferences ?? this.preferences,
      dirty: dirty ?? this.dirty,
      pendingReasons: pendingReasons ?? this.pendingReasons,
      lastAttemptAtIso: lastAttemptAtIso ?? this.lastAttemptAtIso,
      lastSuccessAtIso: lastSuccessAtIso ?? this.lastSuccessAtIso,
      lastFailureCode: clearLastFailureCode
          ? null
          : lastFailureCode ?? this.lastFailureCode,
      lastTrigger: lastTrigger ?? this.lastTrigger,
      lastEvaluatedAtIso: lastEvaluatedAtIso ?? this.lastEvaluatedAtIso,
      lastSuccessfulDataSignature:
          lastSuccessfulDataSignature ?? this.lastSuccessfulDataSignature,
      lastEvaluatedDataSignature:
          lastEvaluatedDataSignature ?? this.lastEvaluatedDataSignature,
      inProgress: inProgress ?? this.inProgress,
    );
  }

  Map<String, dynamic> toJson() => {
    'preferences': preferences.toJson(),
    'dirty': dirty,
    'pendingReasons': pendingReasons.map((item) => item.name).toList(),
    'lastAttemptAtIso': lastAttemptAtIso,
    'lastSuccessAtIso': lastSuccessAtIso,
    'lastFailureCode': lastFailureCode,
    'lastTrigger': lastTrigger?.name,
    'lastEvaluatedAtIso': lastEvaluatedAtIso,
    'lastSuccessfulDataSignature': lastSuccessfulDataSignature,
    'lastEvaluatedDataSignature': lastEvaluatedDataSignature,
    'inProgress': inProgress,
  };

  factory AutoBackupPolicyState.fromJson(Map<String, dynamic>? json) =>
      AutoBackupPolicyState(
        preferences: AutoBackupPreferences.fromJson(
          (json?['preferences'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        ),
        dirty: json?['dirty'] as bool? ?? false,
        pendingReasons:
            (json?['pendingReasons'] as List?)
                ?.map(
                  (item) => PendingBackupReason.values.byName(item.toString()),
                )
                .toList() ??
            const <PendingBackupReason>[],
        lastAttemptAtIso: json?['lastAttemptAtIso']?.toString(),
        lastSuccessAtIso: json?['lastSuccessAtIso']?.toString(),
        lastFailureCode: json?['lastFailureCode']?.toString(),
        lastTrigger: json?['lastTrigger'] == null
            ? null
            : AutoBackupTrigger.values.byName(
                json!['lastTrigger'].toString(),
              ),
        lastEvaluatedAtIso: json?['lastEvaluatedAtIso']?.toString(),
        lastSuccessfulDataSignature:
            json?['lastSuccessfulDataSignature']?.toString(),
        lastEvaluatedDataSignature:
            json?['lastEvaluatedDataSignature']?.toString(),
        inProgress: json?['inProgress'] as bool? ?? false,
      );
}

class AutoBackupRunResult {
  const AutoBackupRunResult({
    required this.eligibility,
    required this.trigger,
    required this.ran,
    this.success,
    this.messageCode,
  });

  final AutoBackupEligibilityResult eligibility;
  final AutoBackupTrigger trigger;
  final bool ran;
  final bool? success;
  final String? messageCode;
}
