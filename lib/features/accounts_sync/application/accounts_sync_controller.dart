import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'sync_foundation.dart';
import '../../../shared/persistence/app_database.dart';
import '../../../shared/persistence/local_store.dart';

const _accountsSyncStorageKey = 'accounts_sync.state.v1';
const _accountsSyncReservedPrefix = 'accounts_sync.';

enum AccountProviderType { signInWithApple, google, emailMagicLink, localOnly }
enum ProfileKind { adult, youth, child, guest }
enum ProfileExperienceMode { full, simplified, learningFocused, prayerFocused }
enum ProfileSyncMode { pathOfNurCloud, iCloud, localOnly, manualBackupOnly }
enum SyncStateKind {
  allCaughtUp,
  syncing,
  offlinePending,
  needsAttention,
  localOnly,
  iCloudActive,
}

enum DevicePlatformKind {
  iphone,
  ipad,
  appleWatch,
  appleTv,
  androidPhone,
  androidTablet,
  androidWatch,
  androidTv,
}

enum AuthStatus { unauthenticated, localOnly, authenticated }

class AuthAccount {
  const AuthAccount({
    required this.accountId,
    required this.provider,
    required this.identifier,
    required this.displayName,
  });

  final String accountId;
  final AccountProviderType provider;
  final String identifier;
  final String displayName;
}

class AuthSession {
  const AuthSession({
    required this.deviceId,
    required this.account,
    required this.startedAtIso,
  });

  final String deviceId;
  final AuthAccount? account;
  final String startedAtIso;
}

class AuthState {
  const AuthState({
    required this.status,
    required this.session,
  });

  final AuthStatus status;
  final AuthSession? session;
}

class AccountRecord {
  const AccountRecord({
    required this.accountId,
    required this.provider,
    required this.identifier,
    required this.displayName,
    required this.createdAtIso,
    required this.lastLoginAtIso,
    required this.lastSyncAtIso,
    required this.connectedDeviceCount,
    required this.syncMode,
  });

  final String accountId;
  final AccountProviderType provider;
  final String identifier;
  final String displayName;
  final String createdAtIso;
  final String lastLoginAtIso;
  final String? lastSyncAtIso;
  final int connectedDeviceCount;
  final ProfileSyncMode syncMode;

  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'provider': provider.name,
        'identifier': identifier,
        'displayName': displayName,
        'createdAtIso': createdAtIso,
        'lastLoginAtIso': lastLoginAtIso,
        'lastSyncAtIso': lastSyncAtIso,
        'connectedDeviceCount': connectedDeviceCount,
        'syncMode': syncMode.name,
      };

  factory AccountRecord.fromJson(Map<String, dynamic> json) => AccountRecord(
        accountId: json['accountId']?.toString() ?? '',
        provider: AccountProviderType.values.byName(
          json['provider']?.toString() ?? AccountProviderType.localOnly.name,
        ),
        identifier: json['identifier']?.toString() ?? '',
        displayName: json['displayName']?.toString() ?? '',
        createdAtIso: json['createdAtIso']?.toString() ?? DateTime.now().toIso8601String(),
        lastLoginAtIso: json['lastLoginAtIso']?.toString() ?? DateTime.now().toIso8601String(),
        lastSyncAtIso: json['lastSyncAtIso']?.toString(),
        connectedDeviceCount: (json['connectedDeviceCount'] as num?)?.toInt() ?? 1,
        syncMode: ProfileSyncMode.values.byName(
          json['syncMode']?.toString() ?? ProfileSyncMode.localOnly.name,
        ),
      );
}

class ProfileRecord {
  const ProfileRecord({
    required this.profileId,
    required this.accountId,
    required this.displayName,
    required this.avatar,
    required this.profileType,
    required this.experienceMode,
    required this.createdAtIso,
    required this.updatedAtIso,
    required this.lastActiveAtIso,
    required this.syncEnabled,
    required this.syncMode,
    required this.pinProtected,
    required this.isLocalOnly,
    required this.isGuest,
    required this.guardianManaged,
    required this.settingsEditable,
    required this.allowExportImport,
    required this.canLeaveWithoutPin,
    required this.visibleSections,
  });

  final String profileId;
  final String? accountId;
  final String displayName;
  final String avatar;
  final ProfileKind profileType;
  final ProfileExperienceMode experienceMode;
  final String createdAtIso;
  final String updatedAtIso;
  final String lastActiveAtIso;
  final bool syncEnabled;
  final ProfileSyncMode syncMode;
  final bool pinProtected;
  final bool isLocalOnly;
  final bool isGuest;
  final bool guardianManaged;
  final bool settingsEditable;
  final bool allowExportImport;
  final bool canLeaveWithoutPin;
  final List<String> visibleSections;

  ProfileRecord copyWith({
    String? displayName,
    String? avatar,
    ProfileKind? profileType,
    ProfileExperienceMode? experienceMode,
    String? updatedAtIso,
    String? lastActiveAtIso,
    bool? syncEnabled,
    ProfileSyncMode? syncMode,
    bool? pinProtected,
    bool? isLocalOnly,
    bool? isGuest,
    bool? guardianManaged,
    bool? settingsEditable,
    bool? allowExportImport,
    bool? canLeaveWithoutPin,
    List<String>? visibleSections,
  }) {
    return ProfileRecord(
      profileId: profileId,
      accountId: accountId,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      profileType: profileType ?? this.profileType,
      experienceMode: experienceMode ?? this.experienceMode,
      createdAtIso: createdAtIso,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
      lastActiveAtIso: lastActiveAtIso ?? this.lastActiveAtIso,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      syncMode: syncMode ?? this.syncMode,
      pinProtected: pinProtected ?? this.pinProtected,
      isLocalOnly: isLocalOnly ?? this.isLocalOnly,
      isGuest: isGuest ?? this.isGuest,
      guardianManaged: guardianManaged ?? this.guardianManaged,
      settingsEditable: settingsEditable ?? this.settingsEditable,
      allowExportImport: allowExportImport ?? this.allowExportImport,
      canLeaveWithoutPin: canLeaveWithoutPin ?? this.canLeaveWithoutPin,
      visibleSections: visibleSections ?? this.visibleSections,
    );
  }

  Map<String, dynamic> toJson() => {
        'profileId': profileId,
        'accountId': accountId,
        'displayName': displayName,
        'avatar': avatar,
        'profileType': profileType.name,
        'experienceMode': experienceMode.name,
        'createdAtIso': createdAtIso,
        'updatedAtIso': updatedAtIso,
        'lastActiveAtIso': lastActiveAtIso,
        'syncEnabled': syncEnabled,
        'syncMode': syncMode.name,
        'pinProtected': pinProtected,
        'isLocalOnly': isLocalOnly,
        'isGuest': isGuest,
        'guardianManaged': guardianManaged,
        'settingsEditable': settingsEditable,
        'allowExportImport': allowExportImport,
        'canLeaveWithoutPin': canLeaveWithoutPin,
        'visibleSections': visibleSections,
      };

  factory ProfileRecord.fromJson(Map<String, dynamic> json) => ProfileRecord(
        profileId: json['profileId']?.toString() ?? '',
        accountId: json['accountId']?.toString(),
        displayName: json['displayName']?.toString() ?? '',
        avatar: json['avatar']?.toString() ?? '✨',
        profileType: ProfileKind.values.byName(
          json['profileType']?.toString() ?? ProfileKind.adult.name,
        ),
        experienceMode: ProfileExperienceMode.values.byName(
          json['experienceMode']?.toString() ?? ProfileExperienceMode.full.name,
        ),
        createdAtIso: json['createdAtIso']?.toString() ?? DateTime.now().toIso8601String(),
        updatedAtIso: json['updatedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
        lastActiveAtIso: json['lastActiveAtIso']?.toString() ?? DateTime.now().toIso8601String(),
        syncEnabled: json['syncEnabled'] as bool? ?? true,
        syncMode: ProfileSyncMode.values.byName(
          json['syncMode']?.toString() ?? ProfileSyncMode.localOnly.name,
        ),
        pinProtected: json['pinProtected'] as bool? ?? false,
        isLocalOnly: json['isLocalOnly'] as bool? ?? false,
        isGuest: json['isGuest'] as bool? ?? false,
        guardianManaged: json['guardianManaged'] as bool? ?? false,
        settingsEditable: json['settingsEditable'] as bool? ?? true,
        allowExportImport: json['allowExportImport'] as bool? ?? true,
        canLeaveWithoutPin: json['canLeaveWithoutPin'] as bool? ?? true,
        visibleSections: (json['visibleSections'] as List?)
                ?.map((item) => item.toString())
                .toList() ??
            const ['home', 'worship', 'learn', 'journey', 'profile'],
      );
}

class ConnectedDeviceRecord {
  const ConnectedDeviceRecord({
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.lastActiveAtIso,
    required this.lastSyncAtIso,
    required this.syncState,
    required this.isCurrentDevice,
  });

  final String deviceId;
  final String deviceName;
  final DevicePlatformKind platform;
  final String lastActiveAtIso;
  final String? lastSyncAtIso;
  final SyncStateKind syncState;
  final bool isCurrentDevice;

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'deviceName': deviceName,
        'platform': platform.name,
        'lastActiveAtIso': lastActiveAtIso,
        'lastSyncAtIso': lastSyncAtIso,
        'syncState': syncState.name,
        'isCurrentDevice': isCurrentDevice,
      };

  factory ConnectedDeviceRecord.fromJson(Map<String, dynamic> json) =>
      ConnectedDeviceRecord(
        deviceId: json['deviceId']?.toString() ?? '',
        deviceName: json['deviceName']?.toString() ?? 'This device',
        platform: DevicePlatformKind.values.byName(
          json['platform']?.toString() ?? _platformForCurrentDevice().name,
        ),
        lastActiveAtIso:
            json['lastActiveAtIso']?.toString() ?? DateTime.now().toIso8601String(),
        lastSyncAtIso: json['lastSyncAtIso']?.toString(),
        syncState: SyncStateKind.values.byName(
          json['syncState']?.toString() ?? SyncStateKind.localOnly.name,
        ),
        isCurrentDevice: json['isCurrentDevice'] as bool? ?? false,
      );
}

class SharedDeviceSafetySettings {
  const SharedDeviceSafetySettings({
    required this.requireProfileSelectionOnLaunch,
    required this.requirePinForAdultProfiles,
    required this.autoLockAfterInactivity,
    required this.restrictChildProfileSettings,
    required this.hideAdvancedToolsFromChildProfiles,
    required this.disableEasySwitchingForProtectedProfiles,
  });

  final bool requireProfileSelectionOnLaunch;
  final bool requirePinForAdultProfiles;
  final bool autoLockAfterInactivity;
  final bool restrictChildProfileSettings;
  final bool hideAdvancedToolsFromChildProfiles;
  final bool disableEasySwitchingForProtectedProfiles;

  SharedDeviceSafetySettings copyWith({
    bool? requireProfileSelectionOnLaunch,
    bool? requirePinForAdultProfiles,
    bool? autoLockAfterInactivity,
    bool? restrictChildProfileSettings,
    bool? hideAdvancedToolsFromChildProfiles,
    bool? disableEasySwitchingForProtectedProfiles,
  }) {
    return SharedDeviceSafetySettings(
      requireProfileSelectionOnLaunch:
          requireProfileSelectionOnLaunch ??
          this.requireProfileSelectionOnLaunch,
      requirePinForAdultProfiles:
          requirePinForAdultProfiles ?? this.requirePinForAdultProfiles,
      autoLockAfterInactivity:
          autoLockAfterInactivity ?? this.autoLockAfterInactivity,
      restrictChildProfileSettings:
          restrictChildProfileSettings ?? this.restrictChildProfileSettings,
      hideAdvancedToolsFromChildProfiles:
          hideAdvancedToolsFromChildProfiles ??
          this.hideAdvancedToolsFromChildProfiles,
      disableEasySwitchingForProtectedProfiles:
          disableEasySwitchingForProtectedProfiles ??
          this.disableEasySwitchingForProtectedProfiles,
    );
  }

  Map<String, dynamic> toJson() => {
        'requireProfileSelectionOnLaunch': requireProfileSelectionOnLaunch,
        'requirePinForAdultProfiles': requirePinForAdultProfiles,
        'autoLockAfterInactivity': autoLockAfterInactivity,
        'restrictChildProfileSettings': restrictChildProfileSettings,
        'hideAdvancedToolsFromChildProfiles': hideAdvancedToolsFromChildProfiles,
        'disableEasySwitchingForProtectedProfiles':
            disableEasySwitchingForProtectedProfiles,
      };

  factory SharedDeviceSafetySettings.fromJson(Map<String, dynamic>? json) =>
      SharedDeviceSafetySettings(
        requireProfileSelectionOnLaunch:
            json?['requireProfileSelectionOnLaunch'] as bool? ?? false,
        requirePinForAdultProfiles:
            json?['requirePinForAdultProfiles'] as bool? ?? true,
        autoLockAfterInactivity:
            json?['autoLockAfterInactivity'] as bool? ?? false,
        restrictChildProfileSettings:
            json?['restrictChildProfileSettings'] as bool? ?? true,
        hideAdvancedToolsFromChildProfiles:
            json?['hideAdvancedToolsFromChildProfiles'] as bool? ?? true,
        disableEasySwitchingForProtectedProfiles:
            json?['disableEasySwitchingForProtectedProfiles'] as bool? ?? false,
      );
}

class SyncStatusSnapshot {
  const SyncStatusSnapshot({
    required this.syncMode,
    required this.syncState,
    required this.lastSyncAtIso,
    required this.pendingChangesCount,
    required this.deviceName,
    required this.healthy,
    required this.recentEvents,
    required this.lastFailedSyncAtIso,
    required this.transportLabel,
    required this.transportAvailable,
    required this.lastResultSummary,
    required this.lastErrorSummary,
  });

  final ProfileSyncMode syncMode;
  final SyncStateKind syncState;
  final String? lastSyncAtIso;
  final int pendingChangesCount;
  final String deviceName;
  final bool healthy;
  final List<String> recentEvents;
  final String? lastFailedSyncAtIso;
  final String transportLabel;
  final bool transportAvailable;
  final String? lastResultSummary;
  final String? lastErrorSummary;

  SyncStatusSnapshot copyWith({
    ProfileSyncMode? syncMode,
    SyncStateKind? syncState,
    String? lastSyncAtIso,
    int? pendingChangesCount,
    String? deviceName,
    bool? healthy,
    List<String>? recentEvents,
    String? lastFailedSyncAtIso,
    String? transportLabel,
    bool? transportAvailable,
    String? lastResultSummary,
    String? lastErrorSummary,
  }) {
    return SyncStatusSnapshot(
      syncMode: syncMode ?? this.syncMode,
      syncState: syncState ?? this.syncState,
      lastSyncAtIso: lastSyncAtIso ?? this.lastSyncAtIso,
      pendingChangesCount: pendingChangesCount ?? this.pendingChangesCount,
      deviceName: deviceName ?? this.deviceName,
      healthy: healthy ?? this.healthy,
      recentEvents: recentEvents ?? this.recentEvents,
      lastFailedSyncAtIso: lastFailedSyncAtIso ?? this.lastFailedSyncAtIso,
      transportLabel: transportLabel ?? this.transportLabel,
      transportAvailable: transportAvailable ?? this.transportAvailable,
      lastResultSummary: lastResultSummary ?? this.lastResultSummary,
      lastErrorSummary: lastErrorSummary ?? this.lastErrorSummary,
    );
  }

  Map<String, dynamic> toJson() => {
        'syncMode': syncMode.name,
        'syncState': syncState.name,
        'lastSyncAtIso': lastSyncAtIso,
        'pendingChangesCount': pendingChangesCount,
        'deviceName': deviceName,
        'healthy': healthy,
        'recentEvents': recentEvents,
        'lastFailedSyncAtIso': lastFailedSyncAtIso,
        'transportLabel': transportLabel,
        'transportAvailable': transportAvailable,
        'lastResultSummary': lastResultSummary,
        'lastErrorSummary': lastErrorSummary,
      };

  factory SyncStatusSnapshot.fromJson(Map<String, dynamic>? json) =>
      SyncStatusSnapshot(
        syncMode: ProfileSyncMode.values.byName(
          json?['syncMode']?.toString() ?? ProfileSyncMode.localOnly.name,
        ),
        syncState: SyncStateKind.values.byName(
          json?['syncState']?.toString() ?? SyncStateKind.localOnly.name,
        ),
        lastSyncAtIso: json?['lastSyncAtIso']?.toString(),
        pendingChangesCount: (json?['pendingChangesCount'] as num?)?.toInt() ?? 0,
        deviceName: json?['deviceName']?.toString() ?? 'This device',
        healthy: json?['healthy'] as bool? ?? true,
        recentEvents: (json?['recentEvents'] as List?)
                ?.map((item) => item.toString())
                .toList() ??
            const [],
        lastFailedSyncAtIso: json?['lastFailedSyncAtIso']?.toString(),
        transportLabel: json?['transportLabel']?.toString() ?? 'Local storage',
        transportAvailable: json?['transportAvailable'] as bool? ?? false,
        lastResultSummary: json?['lastResultSummary']?.toString(),
        lastErrorSummary: json?['lastErrorSummary']?.toString(),
      );
}

class BackupRecord {
  const BackupRecord({
    required this.lastExportAtIso,
    required this.lastImportAtIso,
    required this.lastExportPath,
  });

  final String? lastExportAtIso;
  final String? lastImportAtIso;
  final String? lastExportPath;

  BackupRecord copyWith({
    String? lastExportAtIso,
    String? lastImportAtIso,
    String? lastExportPath,
  }) {
    return BackupRecord(
      lastExportAtIso: lastExportAtIso ?? this.lastExportAtIso,
      lastImportAtIso: lastImportAtIso ?? this.lastImportAtIso,
      lastExportPath: lastExportPath ?? this.lastExportPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'lastExportAtIso': lastExportAtIso,
        'lastImportAtIso': lastImportAtIso,
        'lastExportPath': lastExportPath,
      };

  factory BackupRecord.fromJson(Map<String, dynamic>? json) => BackupRecord(
        lastExportAtIso: json?['lastExportAtIso']?.toString(),
        lastImportAtIso: json?['lastImportAtIso']?.toString(),
        lastExportPath: json?['lastExportPath']?.toString(),
      );
}

class AccountsSyncState {
  const AccountsSyncState({
    required this.accounts,
    required this.profiles,
    required this.profileSnapshots,
    required this.profilePins,
    required this.connectedDevices,
    required this.activeAccountId,
    required this.activeProfileId,
    required this.sessionUnlockedProfileId,
    required this.sharedDeviceModeEnabled,
    required this.sharedDeviceSafety,
    required this.syncStatus,
    required this.backupRecord,
    required this.scopeVersion,
  });

  final List<AccountRecord> accounts;
  final List<ProfileRecord> profiles;
  final Map<String, Map<String, dynamic>> profileSnapshots;
  final Map<String, String> profilePins;
  final List<ConnectedDeviceRecord> connectedDevices;
  final String? activeAccountId;
  final String? activeProfileId;
  final String? sessionUnlockedProfileId;
  final bool sharedDeviceModeEnabled;
  final SharedDeviceSafetySettings sharedDeviceSafety;
  final SyncStatusSnapshot syncStatus;
  final BackupRecord backupRecord;
  final int scopeVersion;

  ProfileRecord? get activeProfile => profiles.cast<ProfileRecord?>().firstWhere(
        (item) => item?.profileId == activeProfileId,
        orElse: () => null,
      );

  AccountRecord? get activeAccount => accounts.cast<AccountRecord?>().firstWhere(
        (item) => item?.accountId == activeAccountId,
        orElse: () => null,
      );

  bool get backupRecommended {
    final mode = activeProfile?.syncMode;
    final lastExport = backupRecord.lastExportAtIso == null
        ? null
        : DateTime.tryParse(backupRecord.lastExportAtIso!);
    final stale =
        lastExport == null || DateTime.now().difference(lastExport).inDays >= 30;
    return stale &&
        (mode == ProfileSyncMode.localOnly ||
            mode == ProfileSyncMode.manualBackupOnly);
  }

  AccountsSyncState copyWith({
    List<AccountRecord>? accounts,
    List<ProfileRecord>? profiles,
    Map<String, Map<String, dynamic>>? profileSnapshots,
    Map<String, String>? profilePins,
    List<ConnectedDeviceRecord>? connectedDevices,
    String? activeAccountId,
    String? activeProfileId,
    String? sessionUnlockedProfileId,
    bool? sharedDeviceModeEnabled,
    SharedDeviceSafetySettings? sharedDeviceSafety,
    SyncStatusSnapshot? syncStatus,
    BackupRecord? backupRecord,
    int? scopeVersion,
  }) {
    return AccountsSyncState(
      accounts: accounts ?? this.accounts,
      profiles: profiles ?? this.profiles,
      profileSnapshots: profileSnapshots ?? this.profileSnapshots,
      profilePins: profilePins ?? this.profilePins,
      connectedDevices: connectedDevices ?? this.connectedDevices,
      activeAccountId: activeAccountId ?? this.activeAccountId,
      activeProfileId: activeProfileId ?? this.activeProfileId,
      sessionUnlockedProfileId:
          sessionUnlockedProfileId ?? this.sessionUnlockedProfileId,
      sharedDeviceModeEnabled:
          sharedDeviceModeEnabled ?? this.sharedDeviceModeEnabled,
      sharedDeviceSafety: sharedDeviceSafety ?? this.sharedDeviceSafety,
      syncStatus: syncStatus ?? this.syncStatus,
      backupRecord: backupRecord ?? this.backupRecord,
      scopeVersion: scopeVersion ?? this.scopeVersion,
    );
  }

  Map<String, dynamic> toJson() => {
        'accounts': accounts.map((item) => item.toJson()).toList(),
        'profiles': profiles.map((item) => item.toJson()).toList(),
        'profileSnapshots': profileSnapshots,
        'profilePins': profilePins,
        'connectedDevices': connectedDevices.map((item) => item.toJson()).toList(),
        'activeAccountId': activeAccountId,
        'activeProfileId': activeProfileId,
        'sessionUnlockedProfileId': sessionUnlockedProfileId,
        'sharedDeviceModeEnabled': sharedDeviceModeEnabled,
        'sharedDeviceSafety': sharedDeviceSafety.toJson(),
        'syncStatus': syncStatus.toJson(),
        'backupRecord': backupRecord.toJson(),
        'scopeVersion': scopeVersion,
      };

  factory AccountsSyncState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AccountsSyncState.initial();
    }
    return AccountsSyncState(
      accounts: ((json['accounts'] as List?) ?? const [])
          .map((item) => AccountRecord.fromJson(
                (item as Map).map((key, value) => MapEntry(key.toString(), value)),
              ))
          .toList(),
      profiles: ((json['profiles'] as List?) ?? const [])
          .map((item) => ProfileRecord.fromJson(
                (item as Map).map((key, value) => MapEntry(key.toString(), value)),
              ))
          .toList(),
      profileSnapshots: ((json['profileSnapshots'] as Map?) ?? const {})
          .map(
            (key, value) => MapEntry(
              key.toString(),
              (value as Map).map((k, v) => MapEntry(k.toString(), v)),
            ),
          ),
      profilePins: ((json['profilePins'] as Map?) ?? const {})
          .map((key, value) => MapEntry(key.toString(), value.toString())),
      connectedDevices: ((json['connectedDevices'] as List?) ?? const [])
          .map((item) => ConnectedDeviceRecord.fromJson(
                (item as Map).map((key, value) => MapEntry(key.toString(), value)),
              ))
          .toList(),
      activeAccountId: json['activeAccountId']?.toString(),
      activeProfileId: json['activeProfileId']?.toString(),
      sessionUnlockedProfileId: json['sessionUnlockedProfileId']?.toString(),
      sharedDeviceModeEnabled: json['sharedDeviceModeEnabled'] as bool? ?? false,
      sharedDeviceSafety: SharedDeviceSafetySettings.fromJson(
        (json['sharedDeviceSafety'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      ),
      syncStatus: SyncStatusSnapshot.fromJson(
        (json['syncStatus'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      ),
      backupRecord: BackupRecord.fromJson(
        (json['backupRecord'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      ),
      scopeVersion: (json['scopeVersion'] as num?)?.toInt() ?? 0,
    );
  }

  factory AccountsSyncState.initial() {
    final now = DateTime.now().toIso8601String();
    final device = ConnectedDeviceRecord(
      deviceId: 'device-local',
      deviceName: _defaultDeviceName(),
      platform: _platformForCurrentDevice(),
      lastActiveAtIso: now,
      lastSyncAtIso: null,
      syncState: SyncStateKind.localOnly,
      isCurrentDevice: true,
    );
    return AccountsSyncState(
      accounts: const [],
      profiles: const [],
      profileSnapshots: const {},
      profilePins: const {},
      connectedDevices: [device],
      activeAccountId: null,
      activeProfileId: null,
      sessionUnlockedProfileId: null,
      sharedDeviceModeEnabled: false,
      sharedDeviceSafety: SharedDeviceSafetySettings.fromJson(null),
      syncStatus: SyncStatusSnapshot.fromJson(
        <String, dynamic>{
          'deviceName': device.deviceName,
          'syncState': SyncStateKind.localOnly.name,
          'transportLabel': 'Local storage',
          'transportAvailable': false,
          'lastResultSummary': 'Local-only mode active',
        },
      ),
      backupRecord: BackupRecord.fromJson(null),
      scopeVersion: 0,
    );
  }
}

class AccountsSyncController extends StateNotifier<AccountsSyncState> {
  AccountsSyncController(
    this._store,
    this._database, {
    required String currentDeviceId,
    required String currentDeviceName,
    required DevicePlatformKind currentDevicePlatform,
  })
      : super(AccountsSyncState.initial()) {
    final restored =
        AccountsSyncState.fromJson(_store.getJsonMap(_accountsSyncStorageKey));
    state = _normalizeCurrentDevice(
      restored,
      currentDeviceId: currentDeviceId,
      currentDeviceName: currentDeviceName,
      currentDevicePlatform: currentDevicePlatform,
    );
  }

  final LocalStore _store;
  final AppDatabase _database;

  static const _defaultVisibleSections = [
    'home',
    'worship',
    'learn',
    'journey',
    'profile',
  ];

  AccountsSyncState _normalizeCurrentDevice(
    AccountsSyncState source, {
    required String currentDeviceId,
    required String currentDeviceName,
    required DevicePlatformKind currentDevicePlatform,
  }) {
    final now = DateTime.now().toIso8601String();
    final others = source.connectedDevices
        .where((item) => item.deviceId != currentDeviceId)
        .map((item) => ConnectedDeviceRecord(
              deviceId: item.deviceId,
              deviceName: item.deviceName,
              platform: item.platform,
              lastActiveAtIso: item.lastActiveAtIso,
              lastSyncAtIso: item.lastSyncAtIso,
              syncState: item.syncState,
              isCurrentDevice: false,
            ))
        .toList(growable: true);
    final existing = source.connectedDevices.cast<ConnectedDeviceRecord?>().firstWhere(
          (item) => item?.deviceId == currentDeviceId,
          orElse: () => null,
        );
    others.insert(
      0,
      ConnectedDeviceRecord(
        deviceId: currentDeviceId,
        deviceName: currentDeviceName,
        platform: currentDevicePlatform,
        lastActiveAtIso: now,
        lastSyncAtIso: existing?.lastSyncAtIso,
        syncState: existing?.syncState ?? source.syncStatus.syncState,
        isCurrentDevice: true,
      ),
    );
    return source.copyWith(connectedDevices: others);
  }

  Future<void> addAccount({
    required AccountProviderType provider,
    required String identifier,
    required String displayName,
    ProfileSyncMode syncMode = ProfileSyncMode.localOnly,
  }) async {
    final now = DateTime.now().toIso8601String();
    final accountId = 'acct_${DateTime.now().microsecondsSinceEpoch}';
    final next = [
      ...state.accounts,
      AccountRecord(
        accountId: accountId,
        provider: provider,
        identifier: identifier,
        displayName: displayName,
        createdAtIso: now,
        lastLoginAtIso: now,
        lastSyncAtIso: null,
        connectedDeviceCount: state.connectedDevices.length,
        syncMode: syncMode,
      ),
    ];
    state = state.copyWith(accounts: next, activeAccountId: accountId);
    await _persist();
  }

  Future<void> createProfile({
    required String displayName,
    required ProfileKind kind,
    required ProfileExperienceMode experienceMode,
    required ProfileSyncMode syncMode,
    String avatar = '🌙',
    bool pinProtected = false,
    String? pin,
    bool guardianManaged = false,
  }) async {
    final now = DateTime.now().toIso8601String();
    final profileId = 'profile_${DateTime.now().microsecondsSinceEpoch}';
    final nextProfile = ProfileRecord(
      profileId: profileId,
      accountId: state.activeAccountId,
      displayName: displayName,
      avatar: avatar,
      profileType: kind,
      experienceMode: experienceMode,
      createdAtIso: now,
      updatedAtIso: now,
      lastActiveAtIso: now,
      syncEnabled: syncMode != ProfileSyncMode.localOnly,
      syncMode: syncMode,
      pinProtected: pinProtected,
      isLocalOnly: syncMode == ProfileSyncMode.localOnly,
      isGuest: kind == ProfileKind.guest,
      guardianManaged: guardianManaged,
      settingsEditable: kind != ProfileKind.child,
      allowExportImport: kind != ProfileKind.child,
      canLeaveWithoutPin: kind != ProfileKind.child,
      visibleSections: kind == ProfileKind.child
          ? const ['home', 'worship', 'learn', 'profile']
          : _defaultVisibleSections,
    );
    final nextPins = {...state.profilePins};
    if (pinProtected && pin != null && pin.isNotEmpty) {
      nextPins[profileId] = pin;
    }
    state = state.copyWith(
      profiles: [...state.profiles, nextProfile],
      profilePins: nextPins,
    );
    await _persist();
    await switchProfile(profileId, bypassPin: true);
  }

  Future<bool> switchProfile(String profileId, {String? pin, bool bypassPin = false}) async {
    final target = state.profiles.firstWhere((item) => item.profileId == profileId);
    if (!bypassPin && target.pinProtected && !verifyPin(profileId, pin ?? '')) {
      return false;
    }
    await _captureActiveProfileSnapshot();
    final targetSnapshot = state.profileSnapshots[profileId] ?? <String, dynamic>{};
    final currentDataKeys = _dataKeysForIsolation();
    await _store.restoreAll(targetSnapshot, replaceKeys: currentDataKeys);
    state = state.copyWith(
      activeProfileId: profileId,
      activeAccountId: target.accountId,
      sessionUnlockedProfileId: profileId,
      profiles: state.profiles
          .map((item) => item.profileId == profileId
              ? item.copyWith(
                  lastActiveAtIso: DateTime.now().toIso8601String(),
                  updatedAtIso: DateTime.now().toIso8601String(),
                )
              : item)
          .toList(),
      scopeVersion: state.scopeVersion + 1,
    );
    await _persist();
    return true;
  }

  Future<void> lockSharedDevice() async {
    state = state.copyWith(sessionUnlockedProfileId: null);
    await _persist();
  }

  Future<void> setProfilePin(String profileId, String pin) async {
    state = state.copyWith(
      profilePins: {...state.profilePins, profileId: pin},
      profiles: state.profiles
          .map((item) => item.profileId == profileId
              ? item.copyWith(pinProtected: true, updatedAtIso: DateTime.now().toIso8601String())
              : item)
          .toList(),
    );
    await _persist();
  }

  Future<void> removeProfilePin(String profileId) async {
    final nextPins = {...state.profilePins}..remove(profileId);
    state = state.copyWith(
      profilePins: nextPins,
      profiles: state.profiles
          .map((item) => item.profileId == profileId
              ? item.copyWith(pinProtected: false, updatedAtIso: DateTime.now().toIso8601String())
              : item)
          .toList(),
    );
    await _persist();
  }

  bool verifyPin(String profileId, String pin) => state.profilePins[profileId] == pin;

  Future<void> updateSharedDeviceMode(bool enabled) async {
    state = state.copyWith(sharedDeviceModeEnabled: enabled);
    await _persist();
  }

  Future<void> updateSharedDeviceSafety(SharedDeviceSafetySettings settings) async {
    state = state.copyWith(sharedDeviceSafety: settings);
    await _persist();
  }

  Future<void> updateProfileSyncMode(String profileId, ProfileSyncMode mode) async {
    state = state.copyWith(
      profiles: state.profiles
          .map((item) => item.profileId == profileId
              ? item.copyWith(
                  syncMode: mode,
                  syncEnabled: mode != ProfileSyncMode.localOnly,
                  isLocalOnly: mode == ProfileSyncMode.localOnly,
                  updatedAtIso: DateTime.now().toIso8601String(),
                )
              : item)
          .toList(),
      syncStatus: state.syncStatus.copyWith(
        syncMode: mode,
        syncState: switch (mode) {
          ProfileSyncMode.pathOfNurCloud => SyncStateKind.offlinePending,
          ProfileSyncMode.iCloud => SyncStateKind.iCloudActive,
          ProfileSyncMode.localOnly => SyncStateKind.localOnly,
          ProfileSyncMode.manualBackupOnly => SyncStateKind.needsAttention,
        },
      ),
    );
    await _persist();
  }

  Future<void> recordPendingChange(String description) async {
    state = state.copyWith(
      syncStatus: state.syncStatus.copyWith(
        pendingChangesCount: state.syncStatus.pendingChangesCount + 1,
        syncState: state.activeProfile?.syncMode == ProfileSyncMode.localOnly
            ? SyncStateKind.localOnly
            : SyncStateKind.offlinePending,
        recentEvents: [description, ...state.syncStatus.recentEvents].take(10).toList(),
      ),
    );
    await _persist();
  }

  Future<void> syncNow() async {
    final now = DateTime.now().toIso8601String();
    state = state.copyWith(
      syncStatus: state.syncStatus.copyWith(
        syncState: state.activeProfile?.syncMode == ProfileSyncMode.localOnly
            ? SyncStateKind.localOnly
            : SyncStateKind.syncing,
        recentEvents: ['Sync started', ...state.syncStatus.recentEvents].take(10).toList(),
        healthy: true,
        lastFailedSyncAtIso: state.syncStatus.lastFailedSyncAtIso,
        lastErrorSummary: null,
      ),
      connectedDevices: state.connectedDevices
          .map((item) => item.isCurrentDevice
              ? ConnectedDeviceRecord(
                  deviceId: item.deviceId,
                  deviceName: item.deviceName,
                  platform: item.platform,
                  lastActiveAtIso: now,
                  lastSyncAtIso: item.lastSyncAtIso,
                  syncState: SyncStateKind.syncing,
                  isCurrentDevice: true,
                )
              : item)
          .toList(),
    );
    await _persist();
  }

  Future<void> applySyncReport(SyncRunReport report, {required bool reloadScope}) async {
    final syncState = !report.online
        ? (state.activeProfile?.syncMode == ProfileSyncMode.localOnly
            ? SyncStateKind.localOnly
            : SyncStateKind.offlinePending)
        : state.activeProfile?.syncMode == ProfileSyncMode.iCloud
            ? SyncStateKind.iCloudActive
            : report.pendingCount == 0
                ? SyncStateKind.allCaughtUp
                : SyncStateKind.offlinePending;
    state = state.copyWith(
      syncStatus: state.syncStatus.copyWith(
        syncState: syncState,
        lastSyncAtIso: report.succeeded && report.online
            ? report.completedAtIso
            : state.syncStatus.lastSyncAtIso,
        pendingChangesCount: report.pendingCount,
        healthy: report.errorMessage == null,
        recentEvents: [...report.recentEvents, ...state.syncStatus.recentEvents]
            .take(10)
            .toList(),
        lastFailedSyncAtIso:
            report.errorMessage == null ? state.syncStatus.lastFailedSyncAtIso : report.completedAtIso,
        transportLabel: report.transportLabel,
        transportAvailable: report.transportAvailable,
        lastResultSummary: report.resultSummary,
        lastErrorSummary: report.errorMessage,
      ),
      accounts: state.accounts
          .map((item) => item.accountId == state.activeAccountId && report.succeeded && report.online
              ? AccountRecord(
                  accountId: item.accountId,
                  provider: item.provider,
                  identifier: item.identifier,
                  displayName: item.displayName,
                  createdAtIso: item.createdAtIso,
                  lastLoginAtIso: item.lastLoginAtIso,
                  lastSyncAtIso: report.completedAtIso,
                  connectedDeviceCount: item.connectedDeviceCount,
                  syncMode: item.syncMode,
                )
              : item)
          .toList(),
      connectedDevices: state.connectedDevices
          .map((item) => item.isCurrentDevice
              ? ConnectedDeviceRecord(
                  deviceId: item.deviceId,
                  deviceName: item.deviceName,
                  platform: item.platform,
                  lastActiveAtIso: report.completedAtIso,
                  lastSyncAtIso: report.online ? report.completedAtIso : item.lastSyncAtIso,
                  syncState: syncState,
                  isCurrentDevice: true,
                )
              : item)
          .toList(),
      scopeVersion: reloadScope ? state.scopeVersion + 1 : state.scopeVersion,
    );
    await _persist();
  }

  Future<String> exportBackup({
    required bool currentProfileOnly,
    required bool encrypt,
  }) async {
    final encoded = await buildBackupPayload(
      currentProfileOnly: currentProfileOnly,
      encrypt: encrypt,
    );
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/path_of_nur_backup_${DateTime.now().millisecondsSinceEpoch}.${encrypt ? 'enc.json' : 'json'}',
    );
    await file.writeAsString(encoded);
    state = state.copyWith(
      backupRecord: state.backupRecord.copyWith(
        lastExportAtIso: DateTime.now().toIso8601String(),
        lastExportPath: file.path,
      ),
    );
    await _persist();
    return file.path;
  }

  Future<String> buildBackupPayload({
    required bool currentProfileOnly,
    required bool encrypt,
  }) async {
    await _captureActiveProfileSnapshot();
    final payload = <String, dynamic>{
      'exportedAt': DateTime.now().toIso8601String(),
      'schemaVersion': 1,
      'currentProfileOnly': currentProfileOnly,
      'encrypted': encrypt,
      'accounts': currentProfileOnly
          ? state.accounts
              .where((item) => item.accountId == state.activeAccountId)
              .map((item) => item.toJson())
              .toList()
          : state.accounts.map((item) => item.toJson()).toList(),
      'profiles': currentProfileOnly
          ? state.profiles
              .where((item) => item.profileId == state.activeProfileId)
              .map((item) => item.toJson())
              .toList()
          : state.profiles.map((item) => item.toJson()).toList(),
      'profileSnapshots': currentProfileOnly
          ? {
              if (state.activeProfileId != null)
                state.activeProfileId!:
                    state.profileSnapshots[state.activeProfileId] ?? const {}
            }
          : state.profileSnapshots,
      'structuredDataByProfile': {
        for (final profile in (currentProfileOnly
            ? state.profiles
                .where((item) => item.profileId == state.activeProfileId)
                .toList(growable: false)
            : state.profiles))
          profile.profileId: _database.exportStructuredData(profile.profileId),
      },
      'syncStatus': state.syncStatus.toJson(),
    };
    final raw = jsonEncode(payload);
    return encrypt ? base64Encode(utf8.encode(raw)) : raw;
  }

  Future<void> importBackup({
    required String payload,
    required bool encrypted,
    required bool createNewProfiles,
    required bool replaceExisting,
  }) async {
    Map<String, dynamic> map;
    try {
      final decoded = encrypted ? utf8.decode(base64Decode(payload)) : payload;
      final json = jsonDecode(decoded);
      if (json is! Map) return;
      map = json.map((key, value) => MapEntry(key.toString(), value));
    } catch (_) {
      return;
    }
    final importedProfiles = ((map['profiles'] as List?) ?? const [])
        .map((item) => ProfileRecord.fromJson((item as Map).map((k, v) => MapEntry(k.toString(), v))))
        .toList();
    final importedAccounts = ((map['accounts'] as List?) ?? const [])
        .map((item) => AccountRecord.fromJson((item as Map).map((k, v) => MapEntry(k.toString(), v))))
        .toList();
    final importedSnapshots = ((map['profileSnapshots'] as Map?) ?? const {})
        .map((key, value) => MapEntry(
              key.toString(),
              (value as Map).map((k, v) => MapEntry(k.toString(), v)),
            ));
    final importedStructured = ((map['structuredDataByProfile'] as Map?) ?? const {})
        .map(
          (key, value) => MapEntry(
            key.toString(),
            value is Map
                ? value.map((k, v) => MapEntry(k.toString(), v))
                : <String, dynamic>{},
          ),
        );
    state = state.copyWith(
      accounts: replaceExisting ? importedAccounts : [...state.accounts, ...importedAccounts],
      profiles: replaceExisting
          ? importedProfiles
          : createNewProfiles
              ? [...state.profiles, ...importedProfiles]
              : _mergeProfiles(state.profiles, importedProfiles),
      profileSnapshots: replaceExisting
          ? importedSnapshots
          : {...state.profileSnapshots, ...importedSnapshots},
      backupRecord: state.backupRecord.copyWith(
        lastImportAtIso: DateTime.now().toIso8601String(),
      ),
      scopeVersion: state.scopeVersion + 1,
    );
    for (final entry in importedStructured.entries) {
      _database.importStructuredData(entry.key, entry.value);
    }
    await _persist();
  }

  Future<void> convertGuestProfile(String profileId, String newName) async {
    state = state.copyWith(
      profiles: state.profiles
          .map((item) => item.profileId == profileId
              ? item.copyWith(
                  displayName: newName,
                  isGuest: false,
                  profileType: ProfileKind.adult,
                  updatedAtIso: DateTime.now().toIso8601String(),
                )
              : item)
          .toList(),
    );
    await _persist();
  }

  bool get backupRecommended {
    final mode = state.activeProfile?.syncMode;
    final lastExport = state.backupRecord.lastExportAtIso == null
        ? null
        : DateTime.tryParse(state.backupRecord.lastExportAtIso!);
    final stale = lastExport == null ||
        DateTime.now().difference(lastExport).inDays >= 30;
    return stale &&
        (mode == ProfileSyncMode.localOnly || mode == ProfileSyncMode.manualBackupOnly);
  }

  Future<void> _captureActiveProfileSnapshot() async {
    final activeProfileId = state.activeProfileId;
    if (activeProfileId == null) return;
    final snapshot = _store.dumpAll()
      ..removeWhere((key, _) => key.startsWith(_accountsSyncReservedPrefix) || key == _accountsSyncStorageKey);
    state = state.copyWith(
      profileSnapshots: {...state.profileSnapshots, activeProfileId: snapshot},
    );
  }

  Iterable<String> _dataKeysForIsolation() => _store
      .dumpAll()
      .keys
      .where((key) => !key.startsWith(_accountsSyncReservedPrefix) && key != _accountsSyncStorageKey);

  List<ProfileRecord> _mergeProfiles(
    List<ProfileRecord> existing,
    List<ProfileRecord> imported,
  ) {
    final byId = {for (final item in existing) item.profileId: item};
    for (final item in imported) {
      byId[item.profileId] = item;
    }
    return byId.values.toList();
  }

  Future<void> _persist() async {
    await _store.setJsonMap(_accountsSyncStorageKey, state.toJson());
  }
}

class AccountManager {
  const AccountManager(this.ref);
  final Ref ref;

  AccountsSyncController get _controller =>
      ref.read(accountsSyncControllerProvider.notifier);

  Future<void> add({
    required AccountProviderType provider,
    required String identifier,
    required String displayName,
    required ProfileSyncMode syncMode,
  }) => _controller.addAccount(
        provider: provider,
        identifier: identifier,
        displayName: displayName,
        syncMode: syncMode,
      );
}

class ProfileManager {
  const ProfileManager(this.ref);
  final Ref ref;

  AccountsSyncController get _controller =>
      ref.read(accountsSyncControllerProvider.notifier);

  Future<void> create({
    required String displayName,
    required ProfileKind kind,
    required ProfileExperienceMode experienceMode,
    required ProfileSyncMode syncMode,
    required String avatar,
    String? pin,
  }) => _controller.createProfile(
        displayName: displayName,
        kind: kind,
        experienceMode: experienceMode,
        syncMode: syncMode,
        avatar: avatar,
        pinProtected: pin != null && pin.isNotEmpty,
        pin: pin,
        guardianManaged: kind == ProfileKind.child,
      );
}

class DeviceSessionManager {
  const DeviceSessionManager(this.ref);
  final Ref ref;

  Future<bool> switchProfile(String profileId, {String? pin}) =>
      ref.read(accountsSyncControllerProvider.notifier).switchProfile(profileId, pin: pin);
}

class SyncManager {
  const SyncManager(this.ref);
  final Ref ref;

  Future<void> syncNow() async {
    final state = ref.read(accountsSyncControllerProvider);
    final activeProfile = state.activeProfile;
    final scopeId = state.activeProfileId;
    if (activeProfile == null || scopeId == null) {
      return;
    }
    await ref.read(accountsSyncControllerProvider.notifier).syncNow();
    final report = await ref.read(syncEngineProvider).syncScope(
          scopeId: scopeId,
          accountId: state.activeAccountId,
          deviceId: ref.read(deviceIdentityProvider).deviceId,
          syncModeName: activeProfile.syncMode.name,
        );
    await ref.read(accountsSyncControllerProvider.notifier).applySyncReport(
          report,
          reloadScope: report.appliedInboundCount > 0,
        );
  }
}

class CloudSyncService {
  const CloudSyncService(this.ref);
  final Ref ref;

  Future<void> queueEvent(String name) =>
      ref.read(accountsSyncControllerProvider.notifier).recordPendingChange(name);
}

class ICloudSyncService {
  const ICloudSyncService(this.ref);
  final Ref ref;

  bool get supported =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

class BackupManager {
  const BackupManager(this.ref);
  final Ref ref;

  Future<String> export({
    required bool currentProfileOnly,
    required bool encrypt,
  }) => ref.read(accountsSyncControllerProvider.notifier).exportBackup(
        currentProfileOnly: currentProfileOnly,
        encrypt: encrypt,
      );
}

class ImportRestoreService {
  const ImportRestoreService(this.ref);
  final Ref ref;

  Future<void> import({
    required String payload,
    required bool encrypted,
    required bool createNewProfiles,
    required bool replaceExisting,
  }) => ref.read(accountsSyncControllerProvider.notifier).importBackup(
        payload: payload,
        encrypted: encrypted,
        createNewProfiles: createNewProfiles,
        replaceExisting: replaceExisting,
      );
}

class SharedDeviceModeController {
  const SharedDeviceModeController(this.ref);
  final Ref ref;

  Future<void> setEnabled(bool enabled) =>
      ref.read(accountsSyncControllerProvider.notifier).updateSharedDeviceMode(enabled);

  Future<void> lock() =>
      ref.read(accountsSyncControllerProvider.notifier).lockSharedDevice();
}

class PinProtectionService {
  const PinProtectionService(this.ref);
  final Ref ref;

  bool verify(String profileId, String pin) =>
      ref.read(accountsSyncControllerProvider.notifier).verifyPin(profileId, pin);

  Future<void> set(String profileId, String pin) =>
      ref.read(accountsSyncControllerProvider.notifier).setProfilePin(profileId, pin);
}

DevicePlatformKind _platformForCurrentDevice() {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return DevicePlatformKind.iphone;
    case TargetPlatform.android:
      return DevicePlatformKind.androidPhone;
    case TargetPlatform.macOS:
      return DevicePlatformKind.appleTv;
    default:
      return DevicePlatformKind.androidTablet;
  }
}

DevicePlatformKind _devicePlatformKindFromKey(String platformKey) {
  switch (platformKey) {
    case 'ios':
      return DevicePlatformKind.iphone;
    case 'android':
      return DevicePlatformKind.androidPhone;
    case 'macos':
      return DevicePlatformKind.ipad;
    case 'windows':
    case 'linux':
    case 'fuchsia':
      return DevicePlatformKind.androidTablet;
  }
  return DevicePlatformKind.iphone;
}

String _defaultDeviceName() {
  switch (_platformForCurrentDevice()) {
    case DevicePlatformKind.iphone:
      return 'This iPhone';
    case DevicePlatformKind.ipad:
      return 'This iPad';
    case DevicePlatformKind.appleWatch:
      return 'Apple Watch';
    case DevicePlatformKind.appleTv:
      return 'This Apple Device';
    case DevicePlatformKind.androidPhone:
      return 'This Android Phone';
    case DevicePlatformKind.androidTablet:
      return 'This Android Tablet';
    case DevicePlatformKind.androidWatch:
      return 'Wear OS Watch';
    case DevicePlatformKind.androidTv:
      return 'Android TV';
  }
}

final accountsSyncControllerProvider =
    StateNotifierProvider<AccountsSyncController, AccountsSyncState>((ref) {
  final deviceIdentity = ref.watch(deviceIdentityProvider);
  return AccountsSyncController(
    ref.watch(localStoreProvider),
    ref.watch(appDatabaseProvider),
    currentDeviceId: deviceIdentity.deviceId,
    currentDeviceName: deviceIdentity.deviceName,
    currentDevicePlatform: _devicePlatformKindFromKey(deviceIdentity.platformKey),
  );
});

final profileScopeVersionProvider = Provider<int>((ref) {
  return ref.watch(accountsSyncControllerProvider.select((state) => state.scopeVersion));
});

final accountManagerProvider = Provider<AccountManager>(AccountManager.new);
final profileManagerProvider = Provider<ProfileManager>(ProfileManager.new);
final deviceSessionManagerProvider =
    Provider<DeviceSessionManager>(DeviceSessionManager.new);
final syncManagerProvider = Provider<SyncManager>(SyncManager.new);
final cloudSyncServiceProvider = Provider<CloudSyncService>(CloudSyncService.new);
final iCloudSyncServiceProvider =
    Provider<ICloudSyncService>(ICloudSyncService.new);
final backupManagerProvider = Provider<BackupManager>(BackupManager.new);
final importRestoreServiceProvider =
    Provider<ImportRestoreService>(ImportRestoreService.new);
final sharedDeviceModeControllerProvider =
    Provider<SharedDeviceModeController>(SharedDeviceModeController.new);
final pinProtectionServiceProvider =
    Provider<PinProtectionService>(PinProtectionService.new);

final authStateProvider = Provider<AuthState>((ref) {
  final state = ref.watch(accountsSyncControllerProvider);
  final deviceId = ref.watch(deviceIdentityProvider).deviceId;
  final activeAccount = state.activeAccount;
  if (activeAccount == null) {
    return AuthState(status: AuthStatus.unauthenticated, session: null);
  }
  final authAccount = AuthAccount(
    accountId: activeAccount.accountId,
    provider: activeAccount.provider,
    identifier: activeAccount.identifier,
    displayName: activeAccount.displayName,
  );
  return AuthState(
    status: activeAccount.provider == AccountProviderType.localOnly
        ? AuthStatus.localOnly
        : AuthStatus.authenticated,
    session: AuthSession(
      deviceId: deviceId,
      account: authAccount,
      startedAtIso: activeAccount.lastLoginAtIso,
    ),
  );
});
