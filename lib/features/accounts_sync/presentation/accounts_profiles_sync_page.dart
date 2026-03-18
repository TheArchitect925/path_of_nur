import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../application/accounts_sync_controller.dart';
import '../application/sync_foundation.dart';

class AccountsProfilesSyncPage extends ConsumerWidget {
  const AccountsProfilesSyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    final activeProfile = state.activeProfile;
    final activeAccount = state.activeAccount;
    return AppPageScaffold(
      headerIcon: Icons.manage_accounts_rounded,
      title: l10n.settingsAccountsSyncTitle,
      subtitle: l10n.settingsAccountsSyncSubtitle,
      children: [
        SectionTitle(
          title: l10n.settingsCurrentProfileTitle,
          subtitle: l10n.accountsSyncCurrentProfileSectionSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Text(activeProfile?.avatar ?? '🌙'),
                ),
                title: Text(
                  activeProfile?.displayName ??
                      l10n.accountsSyncNoActiveProfileTitle,
                ),
                subtitle: Text(
                  activeProfile == null
                      ? l10n.accountsSyncChooseProfileToBegin
                      : l10n.accountsSyncProfileStatusSummary(
                          _profileKindLabel(l10n, activeProfile.profileType),
                          _syncModeLabel(l10n, activeProfile.syncMode),
                          _profileKindLabel(l10n, activeProfile.profileType),
                          activeProfile.displayName,
                          _syncModeLabel(l10n, activeProfile.syncMode),
                        ),
                ),
                trailing: activeProfile?.pinProtected == true
                    ? const Icon(Icons.lock_outline_rounded)
                    : null,
              ),
              const Divider(height: 1),
              _NavRow(
                title: l10n.accountsSyncSwitchProfileTitle,
                subtitle: l10n.accountsSyncSwitchProfileSubtitle,
                onTap: () => context.push('/accounts-sync/profiles'),
              ),
              const Divider(height: 1),
              _NavRow(
                title: l10n.accountsSyncProfilesInAccountTitle,
                subtitle: activeAccount == null
                    ? l10n.accountsSyncProfilesInAccountCreateSubtitle
                    : l10n.accountsSyncProfilesInAccountManageSubtitle(
                        activeAccount.displayName,
                      ),
                onTap: () => context.push('/accounts-sync/profiles'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.accountsSyncAccountsOnDeviceTitle,
          subtitle: l10n.accountsSyncAccountsOnDeviceSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: l10n.accountsSyncSignedInAccountsTitle,
                subtitle: l10n.accountsSyncAccountsAvailableCount(
                  state.accounts.length,
                ),
                onTap: () => context.push('/accounts-sync/accounts'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.settingsSyncStatusTitle,
          subtitle: l10n.accountsSyncSyncStatusSectionSubtitle,
        ),
        SyncStatusCard(state: state),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.accountsSyncConnectedDevicesTitle,
          subtitle: l10n.accountsSyncConnectedDevicesSubtitle,
        ),
        PremiumCard(
          child: _NavRow(
            title: l10n.accountsSyncConnectedDevicesTitle,
            subtitle: l10n.accountsSyncDeviceCount(
              state.connectedDevices.length,
            ),
            onTap: () => context.push('/accounts-sync/devices'),
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.settingsBackupRestoreTitle,
          subtitle: state.backupRecommended
              ? l10n.accountsSyncBackupRestoreSectionSubtitleRecommended
              : l10n.accountsSyncBackupRestoreSectionSubtitleDefault,
        ),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: l10n.settingsBackupRestoreTitle,
                subtitle: state.backupRecord.lastExportAtIso == null
                    ? l10n.accountsSyncNoManualBackupExportedYet
                    : l10n.accountsSyncLastExportLabel(
                        _formatWhen(
                          context,
                          l10n,
                          state.backupRecord.lastExportAtIso,
                        ),
                      ),
                onTap: () => context.push('/accounts-sync/backup'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.accountsSyncSharedDeviceSafetyTitle,
          subtitle: l10n.accountsSyncSharedDeviceSafetySubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: l10n.accountsSyncSharedDeviceSafetyTitle,
                subtitle: state.sharedDeviceModeEnabled
                    ? l10n.accountsSyncSharedDeviceModeActive
                    : l10n.accountsSyncSharedDeviceModeDirectOpen,
                onTap: () => context.push('/accounts-sync/shared-device'),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncSharedDeviceModeLabel),
                subtitle: Text(l10n.accountsSyncSharedDeviceModeHelper),
                value: state.sharedDeviceModeEnabled,
                onChanged: (value) {
                  ref
                      .read(sharedDeviceModeControllerProvider)
                      .setEnabled(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SharedDeviceProfilePickerPage extends ConsumerStatefulWidget {
  const SharedDeviceProfilePickerPage({super.key});

  @override
  ConsumerState<SharedDeviceProfilePickerPage> createState() =>
      _SharedDeviceProfilePickerPageState();
}

class _SharedDeviceProfilePickerPageState
    extends ConsumerState<SharedDeviceProfilePickerPage> {
  String? _profileIdAwaitingPin;
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    return AppPageScaffold(
      headerIcon: Icons.people_alt_outlined,
      title: l10n.accountsSyncChooseProfileTitle,
      subtitle: l10n.accountsSyncChooseProfileSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              for (final profile in state.profiles) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text(profile.avatar)),
                  title: Text(profile.displayName),
                  subtitle: Text(
                    l10n.accountsSyncProfileListSubtitle(
                      _profileKindLabel(l10n, profile.profileType),
                      _syncModeLabel(l10n, profile.syncMode),
                      _formatWhen(context, l10n, profile.lastActiveAtIso),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (profile.pinProtected)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.lock_outline_rounded, size: 18),
                        ),
                      if (state.activeProfileId == profile.profileId)
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 18,
                        ),
                    ],
                  ),
                  onTap: () async {
                    if (profile.pinProtected) {
                      setState(() => _profileIdAwaitingPin = profile.profileId);
                      return;
                    }
                    final router = GoRouter.of(context);
                    final ok = await ref
                        .read(deviceSessionManagerProvider)
                        .switchProfile(profile.profileId, pin: '');
                    if (!mounted) return;
                    if (ok) router.go('/home');
                  },
                ),
                if (profile != state.profiles.last) const Divider(height: 1),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: l10n.accountsSyncAddProfileTitle,
                subtitle: l10n.accountsSyncAddProfileSubtitle,
                onTap: () => context.push('/accounts-sync/profiles'),
              ),
              const Divider(height: 1),
              _NavRow(
                title: l10n.accountsSyncSignInAnotherAccountTitle,
                subtitle: l10n.accountsSyncSignInAnotherAccountSubtitle,
                onTap: () => context.push('/accounts-sync/accounts'),
              ),
              const Divider(height: 1),
              _NavRow(
                title: l10n.accountsSyncManageSharedDeviceSettingsTitle,
                subtitle: l10n.accountsSyncManageSharedDeviceSettingsSubtitle,
                onTap: () => context.push('/accounts-sync/shared-device'),
              ),
            ],
          ),
        ),
        if (_profileIdAwaitingPin != null) ...[
          const SizedBox(height: 16),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.accountsSyncProtectedProfileTitle),
                const SizedBox(height: 8),
                TextField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: l10n.accountsSyncEnterPinHint,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _profileIdAwaitingPin = null);
                          _pinController.clear();
                        },
                        child: Text(
                          MaterialLocalizations.of(context).cancelButtonLabel,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final profileId = _profileIdAwaitingPin;
                          if (profileId == null) return;
                          final router = GoRouter.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          final ok = await ref
                              .read(deviceSessionManagerProvider)
                              .switchProfile(
                                profileId,
                                pin: _pinController.text.trim(),
                              );
                          if (!mounted) return;
                          if (ok) {
                            router.go('/home');
                          } else {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(l10n.accountsSyncPinMismatch),
                              ),
                            );
                          }
                        },
                        child: Text(l10n.accountsSyncOpenProfileAction),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class ProfilesInAccountPage extends ConsumerStatefulWidget {
  const ProfilesInAccountPage({super.key});

  @override
  ConsumerState<ProfilesInAccountPage> createState() =>
      _ProfilesInAccountPageState();
}

class _ProfilesInAccountPageState extends ConsumerState<ProfilesInAccountPage> {
  ProfileKind _kind = ProfileKind.adult;
  ProfileExperienceMode _experience = ProfileExperienceMode.full;
  ProfileSyncMode _syncMode = ProfileSyncMode.localOnly;
  final _nameController = TextEditingController();
  final _avatarController = TextEditingController(text: '🌙');
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    return AppPageScaffold(
      headerIcon: Icons.badge_outlined,
      title: l10n.accountsSyncProfilesInAccountTitle,
      subtitle: l10n.accountsSyncProfilesInAccountPageSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              for (final profile in state.profiles.where(
                (item) =>
                    item.accountId == state.activeAccountId ||
                    item.accountId == null,
              )) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text(profile.avatar)),
                  title: Text(profile.displayName),
                  subtitle: Text(
                    l10n.accountsSyncProfileListSubtitle(
                      _profileKindLabel(l10n, profile.profileType),
                      _syncModeLabel(l10n, profile.syncMode),
                      _formatWhen(context, l10n, profile.lastActiveAtIso),
                    ),
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      if (profile.pinProtected)
                        const Icon(Icons.lock_outline_rounded, size: 18),
                      if (state.activeProfileId == profile.profileId)
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 18,
                        ),
                    ],
                  ),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await ref
                        .read(deviceSessionManagerProvider)
                        .switchProfile(profile.profileId, pin: '');
                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.accountsSyncProfileActivated(
                            profile.displayName,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (profile != state.profiles.last) const Divider(height: 1),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.accountsSyncAddProfileTitle,
          subtitle: l10n.accountsSyncAddProfileSectionSubtitle,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncDisplayNameLabel,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _avatarController,
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncAvatarLabel,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProfileKind>(
                initialValue: _kind,
                items: ProfileKind.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_profileKindLabel(l10n, item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _kind = value ?? _kind),
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncProfileTypeLabel,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProfileExperienceMode>(
                initialValue: _experience,
                items: ProfileExperienceMode.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_profileExperienceLabel(l10n, item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _experience = value ?? _experience),
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncExperienceModeLabel,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProfileSyncMode>(
                initialValue: _syncMode,
                items: ProfileSyncMode.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_syncModeLabel(l10n, item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _syncMode = value ?? _syncMode),
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncDataModeLabel,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pinController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncOptionalPinLabel,
                  helperText: l10n.accountsSyncOptionalPinHelper,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref
                      .read(profileManagerProvider)
                      .create(
                        displayName: _nameController.text.trim().isEmpty
                            ? l10n.accountsSyncDefaultNewProfileName
                            : _nameController.text.trim(),
                        kind: _kind,
                        experienceMode: _experience,
                        syncMode: _syncMode,
                        avatar: _avatarController.text.trim().isEmpty
                            ? '🌙'
                            : _avatarController.text.trim(),
                        pin: _pinController.text.trim().isEmpty
                            ? null
                            : _pinController.text.trim(),
                      );
                  if (!mounted) return;
                  _nameController.clear();
                  _pinController.clear();
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.accountsSyncProfileCreated)),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_rounded),
                label: Text(l10n.accountsSyncCreateProfileAction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SignedInAccountsPage extends ConsumerStatefulWidget {
  const SignedInAccountsPage({super.key});

  @override
  ConsumerState<SignedInAccountsPage> createState() =>
      _SignedInAccountsPageState();
}

class _SignedInAccountsPageState extends ConsumerState<SignedInAccountsPage> {
  AccountProviderType _provider = AccountProviderType.localOnly;
  ProfileSyncMode _syncMode = ProfileSyncMode.localOnly;
  final _identifierController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    return AppPageScaffold(
      headerIcon: Icons.devices_other_rounded,
      title: l10n.accountsSyncSignedInAccountsTitle,
      subtitle: l10n.accountsSyncSignedInAccountsSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              for (final account in state.accounts) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(account.displayName),
                  subtitle: Text(
                    l10n.accountsSyncAccountSummary(
                      _accountProviderLabel(l10n, account.provider),
                      account.identifier,
                      _syncModeLabel(l10n, account.syncMode),
                      _accountProviderLabel(l10n, account.provider),
                      account.identifier,
                    ),
                  ),
                  trailing: account.accountId == state.activeAccountId
                      ? const Icon(Icons.check_circle_outline_rounded)
                      : null,
                ),
                if (account != state.accounts.last) const Divider(height: 1),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.accountsSyncSignInAnotherAccountTitle),
              const SizedBox(height: 12),
              DropdownButtonFormField<AccountProviderType>(
                initialValue: _provider,
                items: AccountProviderType.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_accountProviderLabel(l10n, item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _provider = value ?? _provider),
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncSignInMethodLabel,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _identifierController,
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncEmailOrIdentifierLabel,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncDisplayNameLabel,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProfileSyncMode>(
                initialValue: _syncMode,
                items: ProfileSyncMode.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_syncModeLabel(l10n, item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _syncMode = value ?? _syncMode),
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncSyncModeLabel,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref
                      .read(accountManagerProvider)
                      .add(
                        provider: _provider,
                        identifier: _identifierController.text.trim().isEmpty
                            ? _provider.name
                            : _identifierController.text.trim(),
                        displayName: _nameController.text.trim().isEmpty
                            ? l10n.accountsSyncDefaultAccountDisplayName
                            : _nameController.text.trim(),
                        syncMode: _syncMode,
                      );
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(l10n.accountsSyncAccountAddedOnDevice),
                    ),
                  );
                },
                child: Text(l10n.accountsSyncAddAccountAction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SharedDeviceSafetyPage extends ConsumerWidget {
  const SharedDeviceSafetyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    final settings = state.sharedDeviceSafety;
    return AppPageScaffold(
      headerIcon: Icons.shield_moon_outlined,
      title: l10n.accountsSyncSharedDeviceSafetyTitle,
      subtitle: l10n.accountsSyncSharedDeviceSafetyPageSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncRequireProfileSelectionOnLaunch),
                value: settings.requireProfileSelectionOnLaunch,
                onChanged: (value) {
                  ref
                      .read(accountsSyncControllerProvider.notifier)
                      .updateSharedDeviceSafety(
                        settings.copyWith(
                          requireProfileSelectionOnLaunch: value,
                        ),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncRequirePinForAdultProfiles),
                value: settings.requirePinForAdultProfiles,
                onChanged: (value) {
                  ref
                      .read(accountsSyncControllerProvider.notifier)
                      .updateSharedDeviceSafety(
                        settings.copyWith(requirePinForAdultProfiles: value),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncAutoLockAfterInactivity),
                value: settings.autoLockAfterInactivity,
                onChanged: (value) {
                  ref
                      .read(accountsSyncControllerProvider.notifier)
                      .updateSharedDeviceSafety(
                        settings.copyWith(autoLockAfterInactivity: value),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncRestrictChildProfileSettings),
                value: settings.restrictChildProfileSettings,
                onChanged: (value) {
                  ref
                      .read(accountsSyncControllerProvider.notifier)
                      .updateSharedDeviceSafety(
                        settings.copyWith(restrictChildProfileSettings: value),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l10n.accountsSyncHideAdvancedToolsFromChildProfiles,
                ),
                value: settings.hideAdvancedToolsFromChildProfiles,
                onChanged: (value) {
                  ref
                      .read(accountsSyncControllerProvider.notifier)
                      .updateSharedDeviceSafety(
                        settings.copyWith(
                          hideAdvancedToolsFromChildProfiles: value,
                        ),
                      );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ConnectedDevicesPage extends ConsumerWidget {
  const ConnectedDevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final devices = ref.watch(accountsSyncControllerProvider).connectedDevices;
    return AppPageScaffold(
      headerIcon: Icons.devices_rounded,
      title: l10n.accountsSyncConnectedDevicesTitle,
      subtitle: l10n.accountsSyncConnectedDevicesSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              for (final device in devices) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_deviceNameLabel(l10n, device)),
                  subtitle: Text(
                    l10n.accountsSyncDeviceSummary(
                      _devicePlatformLabel(l10n, device.platform),
                      _formatWhen(context, l10n, device.lastActiveAtIso),
                      _formatWhen(context, l10n, device.lastActiveAtIso),
                      _devicePlatformLabel(l10n, device.platform),
                      _formatWhen(context, l10n, device.lastActiveAtIso),
                    ),
                  ),
                  trailing: device.isCurrentDevice
                      ? Chip(label: Text(l10n.accountsSyncCurrentDeviceChip))
                      : null,
                ),
                if (device != devices.last) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class BackupRestoreHomePage extends ConsumerWidget {
  const BackupRestoreHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    return AppPageScaffold(
      headerIcon: Icons.backup_outlined,
      title: l10n.settingsBackupRestoreTitle,
      subtitle: l10n.accountsSyncBackupRestorePageSubtitle,
      children: [
        if (state.backupRecommended)
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.settingsBackupRecommended),
              subtitle: Text(l10n.accountsSyncBackupRecommendedSubtitle),
            ),
          ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: l10n.accountsSyncExportBackupTitle,
                subtitle: state.backupRecord.lastExportAtIso == null
                    ? l10n.accountsSyncExportBackupSubtitleDefault
                    : l10n.accountsSyncLastExportLabel(
                        _formatWhen(
                          context,
                          l10n,
                          state.backupRecord.lastExportAtIso,
                        ),
                      ),
                onTap: () => context.push('/accounts-sync/backup/export'),
              ),
              const Divider(height: 1),
              _NavRow(
                title: l10n.accountsSyncImportBackupTitle,
                subtitle: l10n.accountsSyncImportBackupSubtitle,
                onTap: () => context.push('/accounts-sync/backup/import'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BackupExportFlowPage extends ConsumerStatefulWidget {
  const BackupExportFlowPage({super.key});

  @override
  ConsumerState<BackupExportFlowPage> createState() =>
      _BackupExportFlowPageState();
}

class _BackupExportFlowPageState extends ConsumerState<BackupExportFlowPage> {
  bool _currentProfileOnly = true;
  bool _encrypt = true;
  String? _lastPath;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      headerIcon: Icons.ios_share_rounded,
      title: l10n.accountsSyncExportBackupTitle,
      subtitle: l10n.accountsSyncExportBackupPageSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncCurrentProfileOnlyTitle),
                subtitle: Text(l10n.accountsSyncCurrentProfileOnlySubtitle),
                value: _currentProfileOnly,
                onChanged: (value) =>
                    setState(() => _currentProfileOnly = value),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncEncryptedExportTitle),
                subtitle: Text(l10n.accountsSyncEncryptedExportSubtitle),
                value: _encrypt,
                onChanged: (value) => setState(() => _encrypt = value),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final path = await ref
                      .read(backupManagerProvider)
                      .export(
                        currentProfileOnly: _currentProfileOnly,
                        encrypt: _encrypt,
                      );
                  setState(() => _lastPath = path);
                },
                child: Text(l10n.accountsSyncExportNowAction),
              ),
              if (_lastPath != null) ...[
                const SizedBox(height: 10),
                SelectableText(
                  _lastPath!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class BackupImportFlowPage extends ConsumerStatefulWidget {
  const BackupImportFlowPage({super.key});

  @override
  ConsumerState<BackupImportFlowPage> createState() =>
      _BackupImportFlowPageState();
}

class _BackupImportFlowPageState extends ConsumerState<BackupImportFlowPage> {
  bool _encrypted = true;
  bool _createNewProfiles = true;
  bool _replaceExisting = false;
  final _payloadController = TextEditingController();

  @override
  void dispose() {
    _payloadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      headerIcon: Icons.restore_page_outlined,
      title: l10n.accountsSyncImportBackupTitle,
      subtitle: l10n.accountsSyncImportBackupPageSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              TextField(
                controller: _payloadController,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: l10n.accountsSyncBackupPayloadLabel,
                  hintText: l10n.accountsSyncBackupPayloadHint,
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncEncryptedPayloadTitle),
                value: _encrypted,
                onChanged: (value) => setState(() => _encrypted = value),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncCreateNewProfilesTitle),
                value: _createNewProfiles,
                onChanged: (value) =>
                    setState(() => _createNewProfiles = value),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncReplaceExistingLocalDataTitle),
                value: _replaceExisting,
                onChanged: (value) => setState(() => _replaceExisting = value),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref
                      .read(importRestoreServiceProvider)
                      .import(
                        payload: _payloadController.text.trim(),
                        encrypted: _encrypted,
                        createNewProfiles: _createNewProfiles,
                        replaceExisting: _replaceExisting,
                      );
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.accountsSyncBackupImported)),
                  );
                },
                child: Text(l10n.accountsSyncRestoreBackupAction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SyncDetailsPage extends ConsumerWidget {
  const SyncDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    final sync = state.syncStatus;
    return AppPageScaffold(
      headerIcon: Icons.sync_alt_rounded,
      title: l10n.accountsSyncSyncDetailsTitle,
      subtitle: l10n.accountsSyncSyncDetailsSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncCurrentProviderTitle),
                subtitle: Text(
                  l10n.accountsSyncCurrentProviderSummary(
                    _syncModeLabel(l10n, sync.syncMode),
                    _transportLabel(l10n, sync.transportLabel),
                    _transportLabel(l10n, sync.transportLabel),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncCurrentStateTitle),
                subtitle: Text(_syncStateTitle(l10n, sync.syncState)),
              ),
              if (sync.lastResultSummary != null) ...[
                const Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.accountsSyncLastResultTitle),
                  subtitle: Text(
                    _syncFeedbackLabel(l10n, sync.lastResultSummary!),
                  ),
                ),
              ],
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncPendingUploadsTitle),
                subtitle: Text(
                  l10n.accountsSyncPendingChangesCount(
                    sync.pendingChangesCount,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncLastSuccessfulSyncTitle),
                subtitle: Text(_formatWhen(context, l10n, sync.lastSyncAtIso)),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncTransportAvailabilityTitle),
                subtitle: Text(
                  sync.transportAvailable
                      ? l10n.accountsSyncTransportAvailable
                      : l10n.accountsSyncTransportUnavailableOffline,
                ),
              ),
              if (sync.lastErrorSummary != null) ...[
                const Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.accountsSyncLastErrorTitle),
                  subtitle: Text(
                    _syncFeedbackLabel(l10n, sync.lastErrorSummary!),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.accountsSyncRecentSyncEventsTitle),
              const SizedBox(height: 8),
              for (final event in sync.recentEvents)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    l10n.accountsSyncRecentSyncEventBullet(
                      _syncFeedbackLabel(l10n, event),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.read(syncManagerProvider).syncNow(),
                child: Text(l10n.accountsSyncSyncNowAction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SyncStatusCard extends ConsumerWidget {
  const SyncStatusCard({super.key, required this.state});

  final AccountsSyncState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sync = state.syncStatus;
    return PremiumCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_syncStateTitle(l10n, sync.syncState)),
            subtitle: Text(
              (sync.lastErrorSummary == null
                      ? null
                      : _syncFeedbackLabel(l10n, sync.lastErrorSummary!)) ??
                  (sync.lastResultSummary == null
                      ? null
                      : _syncFeedbackLabel(l10n, sync.lastResultSummary!)) ??
                  l10n.accountsSyncCurrentProviderSummary(
                    _syncModeLabel(l10n, sync.syncMode),
                    _transportLabel(l10n, sync.transportLabel),
                    _transportLabel(l10n, sync.transportLabel),
                  ),
            ),
            trailing: Icon(switch (sync.syncState) {
              SyncStateKind.allCaughtUp => Icons.cloud_done_outlined,
              SyncStateKind.syncing => Icons.sync_rounded,
              SyncStateKind.offlinePending => Icons.cloud_off_outlined,
              SyncStateKind.needsAttention => Icons.warning_amber_rounded,
              SyncStateKind.localOnly => Icons.phone_iphone_rounded,
              SyncStateKind.iCloudActive => Icons.cloud_queue_rounded,
            }),
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.accountsSyncLastSyncTitle),
            subtitle: Text(_formatWhen(context, l10n, sync.lastSyncAtIso)),
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.accountsSyncPendingChangesTitle),
            subtitle: Text(
              l10n.accountsSyncPendingChangesWaiting(sync.pendingChangesCount),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.accountsSyncTransportTitle),
            subtitle: Text(
              l10n.accountsSyncTransportSummary(
                _transportLabel(l10n, sync.transportLabel),
                sync.transportAvailable
                    ? l10n.accountsSyncTransportAvailable
                    : l10n.settingsUnavailable,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref.read(syncManagerProvider).syncNow(),
                  child: Text(l10n.accountsSyncSyncNowAction),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => context.push('/accounts-sync/sync-details'),
                  child: Text(l10n.accountsSyncViewDetailsAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

String _syncModeLabel(AppLocalizations l10n, ProfileSyncMode mode) {
  return switch (mode) {
    ProfileSyncMode.pathOfNurCloud => l10n.settingsSyncModePathOfNurCloud,
    ProfileSyncMode.iCloud => l10n.settingsSyncModeICloud,
    ProfileSyncMode.localOnly => l10n.settingsSyncModeLocalOnly,
    ProfileSyncMode.manualBackupOnly => l10n.settingsSyncModeManualBackupOnly,
  };
}

String _syncStateTitle(AppLocalizations l10n, SyncStateKind state) {
  return switch (state) {
    SyncStateKind.allCaughtUp => l10n.settingsSyncStateAllCaughtUp,
    SyncStateKind.syncing => l10n.settingsSyncStateSyncing,
    SyncStateKind.offlinePending => l10n.settingsSyncStateOfflinePending,
    SyncStateKind.needsAttention => l10n.settingsSyncStateNeedsAttention,
    SyncStateKind.localOnly => l10n.settingsSyncStateLocalOnly,
    SyncStateKind.iCloudActive => l10n.settingsSyncStateICloudActive,
  };
}

String _profileKindLabel(AppLocalizations l10n, ProfileKind kind) {
  return switch (kind) {
    ProfileKind.adult => l10n.familyLearningProfileTypeAdult,
    ProfileKind.youth => l10n.familyLearningProfileTypeYouth,
    ProfileKind.child => l10n.familyLearningProfileTypeChild,
    ProfileKind.guest => l10n.familyLearningProfileTypeGuest,
  };
}

String _profileExperienceLabel(
  AppLocalizations l10n,
  ProfileExperienceMode mode,
) {
  return switch (mode) {
    ProfileExperienceMode.full => l10n.accountsSyncExperienceModeFull,
    ProfileExperienceMode.simplified =>
      l10n.accountsSyncExperienceModeSimplified,
    ProfileExperienceMode.learningFocused =>
      l10n.accountsSyncExperienceModeLearningFocused,
    ProfileExperienceMode.prayerFocused =>
      l10n.accountsSyncExperienceModePrayerFocused,
  };
}

String _accountProviderLabel(
  AppLocalizations l10n,
  AccountProviderType provider,
) {
  return switch (provider) {
    AccountProviderType.signInWithApple =>
      l10n.accountsSyncProviderSignInWithApple,
    AccountProviderType.google => l10n.accountsSyncProviderGoogle,
    AccountProviderType.emailMagicLink =>
      l10n.accountsSyncProviderEmailMagicLink,
    AccountProviderType.localOnly => l10n.accountsSyncProviderLocalOnly,
  };
}

String _devicePlatformLabel(
  AppLocalizations l10n,
  DevicePlatformKind platform,
) {
  return switch (platform) {
    DevicePlatformKind.iphone => l10n.accountsSyncDevicePlatformIPhone,
    DevicePlatformKind.ipad => l10n.accountsSyncDevicePlatformIPad,
    DevicePlatformKind.appleWatch => l10n.accountsSyncDevicePlatformAppleWatch,
    DevicePlatformKind.appleTv => l10n.accountsSyncDevicePlatformAppleDevice,
    DevicePlatformKind.androidPhone =>
      l10n.accountsSyncDevicePlatformAndroidPhone,
    DevicePlatformKind.androidTablet =>
      l10n.accountsSyncDevicePlatformAndroidTablet,
    DevicePlatformKind.androidWatch =>
      l10n.accountsSyncDevicePlatformWearOsWatch,
    DevicePlatformKind.androidTv => l10n.accountsSyncDevicePlatformAndroidTv,
  };
}

String _transportLabel(AppLocalizations l10n, String transportLabel) {
  switch (transportLabel) {
    case 'pathOfNurCloud':
      return l10n.settingsSyncModePathOfNurCloud;
    case 'localOnly':
      return l10n.settingsSyncModeLocalOnly;
    case 'manualBackupOnly':
      return l10n.settingsSyncModeManualBackupOnly;
    case syncTransportKeyLocalStorage:
    case 'Local storage':
      return l10n.accountsSyncTransportLocalStorage;
    case syncTransportKeyICloud:
    case 'iCloud':
      return l10n.settingsSyncModeICloud;
    default:
      return transportLabel;
  }
}

String _deviceNameLabel(AppLocalizations l10n, ConnectedDeviceRecord device) {
  switch (device.deviceName) {
    case 'current_device':
    case 'This device':
      return l10n.accountsSyncThisDeviceGeneric;
    case 'current_device_iphone':
    case 'This iPhone':
      return l10n.accountsSyncThisDeviceIPhone;
    case 'current_device_ipad':
    case 'This iPad':
      return l10n.accountsSyncThisDeviceIPad;
    case 'current_device_apple_watch':
    case 'Apple Watch':
      return l10n.accountsSyncThisDeviceAppleWatch;
    case 'current_device_apple_tv':
    case 'This Apple Device':
      return l10n.accountsSyncThisDeviceAppleTv;
    case 'current_device_android_phone':
    case 'This Android Phone':
      return l10n.accountsSyncThisDeviceAndroidPhone;
    case 'current_device_android_tablet':
    case 'This Android Tablet':
      return l10n.accountsSyncThisDeviceAndroidTablet;
    case 'current_device_android_watch':
    case 'Wear OS Watch':
      return l10n.accountsSyncThisDeviceAndroidWatch;
    case 'current_device_android_tv':
    case 'Android TV':
      return l10n.accountsSyncThisDeviceAndroidTv;
    case 'current_device_apple':
      return l10n.accountsSyncThisDeviceApple;
    case 'current_device_android':
      return l10n.accountsSyncThisDeviceAndroid;
    case 'current_device_mac':
      return l10n.accountsSyncThisDeviceMac;
    case 'current_device_windows':
      return l10n.accountsSyncThisDeviceWindows;
    case 'current_device_linux':
      return l10n.accountsSyncThisDeviceLinux;
    case 'current_device_generic':
      return l10n.accountsSyncThisDeviceGeneric;
    default:
      return device.deviceName;
  }
}

String _syncFeedbackLabel(AppLocalizations l10n, String raw) {
  if (raw == 'sync_result_local_only_mode_active') {
    return l10n.accountsSyncResultLocalOnlyModeActive;
  }
  if (raw == 'sync_result_no_changes') {
    return l10n.accountsSyncResultNoChanges;
  }
  if (raw == 'sync_result_completed_successfully') {
    return l10n.accountsSyncResultCompletedSuccessfully;
  }
  if (raw == 'sync_event_local_only_mode_active') {
    return l10n.accountsSyncEventLocalOnlyModeActive;
  }
  if (raw == 'sync_event_no_changes') {
    return l10n.accountsSyncEventNoChanges;
  }
  if (raw.startsWith('sync_event_uploaded:')) {
    final count = int.tryParse(raw.split(':').last) ?? 0;
    return l10n.accountsSyncEventUploadedChanges(count);
  }
  if (raw.startsWith('sync_event_applied_inbound:')) {
    final count = int.tryParse(raw.split(':').last) ?? 0;
    return l10n.accountsSyncEventAppliedInboundChanges(count);
  }
  switch (raw) {
    case 'sync_error_offline':
      return l10n.accountsSyncErrorOffline;
    case 'sync_error_sync_unavailable':
    case 'sync_error_transport_unavailable':
      return l10n.accountsSyncErrorSyncUnavailable;
    case 'sync_error_icloud_unsupported_platform':
      return l10n.accountsSyncErrorICloudUnsupportedPlatform;
    case 'sync_error_icloud_unavailable':
      return l10n.accountsSyncErrorICloudUnavailable;
    case 'sync_error_icloud_write_failed':
      return l10n.accountsSyncErrorICloudWriteFailed;
    case 'sync_error_transport_failure':
      return l10n.accountsSyncErrorTransportFailure;
    default:
      return raw;
  }
}

String _formatWhen(BuildContext context, AppLocalizations l10n, String? iso) {
  if (iso == null) return l10n.accountsSyncTimeNotYet;
  final date = DateTime.tryParse(iso);
  if (date == null) return l10n.accountsSyncTimeUnknown;
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return l10n.accountsSyncTimeJustNow;
  if (diff.inHours < 1) return l10n.accountsSyncTimeMinutesAgo(diff.inMinutes);
  if (diff.inDays < 1) return l10n.accountsSyncTimeHoursAgo(diff.inHours);
  if (diff.inDays < 7) return l10n.accountsSyncTimeDaysAgo(diff.inDays);
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).add_jm().format(date.toLocal());
}
