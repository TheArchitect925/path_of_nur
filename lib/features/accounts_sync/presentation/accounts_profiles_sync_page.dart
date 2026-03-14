import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../application/accounts_sync_controller.dart';

class AccountsProfilesSyncPage extends ConsumerWidget {
  const AccountsProfilesSyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountsSyncControllerProvider);
    final activeProfile = state.activeProfile;
    final activeAccount = state.activeAccount;
    return AppPageScaffold(
      headerIcon: Icons.manage_accounts_rounded,
      title: 'Accounts, Profiles & Sync',
      subtitle:
          'Manage who is using this device, how their journey is protected, and how it is stored.',
      children: [
        SectionTitle(
          title: 'Current Profile',
          subtitle: 'See who is active right now and how this profile is protected.',
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text(activeProfile?.avatar ?? '🌙')),
                title: Text(activeProfile?.displayName ?? 'No active profile'),
                subtitle: Text(
                  activeProfile == null
                      ? 'Choose a profile to begin.'
                      : '${activeProfile.profileType.name} • ${activeProfile.syncMode.name}',
                ),
                trailing: activeProfile?.pinProtected == true
                    ? const Icon(Icons.lock_outline_rounded)
                    : null,
              ),
              const Divider(height: 1),
              _NavRow(
                title: 'Switch Profile',
                subtitle: 'Move between profiles without leaking progress.',
                onTap: () => context.push('/accounts-sync/profiles'),
              ),
              const Divider(height: 1),
              _NavRow(
                title: 'Profiles in This Account',
                subtitle: activeAccount == null
                    ? 'Create profiles for adults, youth, children, or guests.'
                    : 'Manage the profiles stored under ${activeAccount.displayName}.',
                onTap: () => context.push('/accounts-sync/profiles'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: 'Accounts on This Device',
          subtitle: 'Keep multiple signed-in identities separate on one phone or tablet.',
        ),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: 'Signed-In Accounts on This Device',
                subtitle: '${state.accounts.length} account${state.accounts.length == 1 ? '' : 's'} available',
                onTap: () => context.push('/accounts-sync/accounts'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: 'Sync Status',
          subtitle: 'Understand what is stored locally, what is synced, and what needs attention.',
        ),
        SyncStatusCard(state: state),
        const SizedBox(height: 16),
        SectionTitle(
          title: 'Connected Devices',
          subtitle: 'See which phones, tablets, watches, and TVs are linked to this journey.',
        ),
        PremiumCard(
          child: _NavRow(
            title: 'Connected Devices',
            subtitle: '${state.connectedDevices.length} device${state.connectedDevices.length == 1 ? '' : 's'}',
            onTap: () => context.push('/accounts-sync/devices'),
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: 'Backup & Restore',
          subtitle: state.backupRecommended
              ? 'Backup recommended. This journey has not been exported recently.'
              : 'Export a manual backup or restore from a previous archive.',
        ),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: 'Backup & Restore',
                subtitle: state.backupRecord.lastExportAtIso == null
                    ? 'No manual backup exported yet.'
                    : 'Last export ${_formatWhen(state.backupRecord.lastExportAtIso)}',
                onTap: () => context.push('/accounts-sync/backup'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: 'Shared Device Safety',
          subtitle: 'Require profile picking on launch and keep child or adult profiles protected.',
        ),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: 'Shared Device Safety',
                subtitle: state.sharedDeviceModeEnabled
                    ? 'Shared Device Mode is active.'
                    : 'This device currently opens directly into one profile.',
                onTap: () => context.push('/accounts-sync/shared-device'),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Shared Device Mode'),
                subtitle: const Text('Show the profile picker on shared tablets and TVs.'),
                value: state.sharedDeviceModeEnabled,
                onChanged: (value) {
                  ref.read(sharedDeviceModeControllerProvider).setEnabled(value);
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
    final state = ref.watch(accountsSyncControllerProvider);
    return AppPageScaffold(
      headerIcon: Icons.people_alt_outlined,
      title: 'Choose a Profile',
      subtitle:
          'This device is set up for shared use. Pick the profile you want to continue with.',
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
                    '${profile.profileType.name} • ${profile.syncMode.name} • Last active ${_formatWhen(profile.lastActiveAtIso)}',
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
                        const Icon(Icons.check_circle_outline_rounded, size: 18),
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
                title: 'Add Profile',
                subtitle: 'Create an adult, youth, child, or guest profile.',
                onTap: () => context.push('/accounts-sync/profiles'),
              ),
              const Divider(height: 1),
              _NavRow(
                title: 'Sign In Another Account',
                subtitle: 'Keep more than one Path of Nūr identity on this device.',
                onTap: () => context.push('/accounts-sync/accounts'),
              ),
              const Divider(height: 1),
              _NavRow(
                title: 'Manage Shared-Device Settings',
                subtitle: 'Adjust launch protection and child restrictions.',
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
                const Text('This profile is protected'),
                const SizedBox(height: 8),
                TextField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter PIN',
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
                        child: const Text('Cancel'),
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
                              .switchProfile(profileId, pin: _pinController.text.trim());
                          if (!mounted) return;
                          if (ok) {
                            router.go('/home');
                          } else {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('PIN did not match.')),
                            );
                          }
                        },
                        child: const Text('Open'),
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
  ConsumerState<ProfilesInAccountPage> createState() => _ProfilesInAccountPageState();
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
    final state = ref.watch(accountsSyncControllerProvider);
    return AppPageScaffold(
      headerIcon: Icons.badge_outlined,
      title: 'Profiles in This Account',
      subtitle:
          'Create separate journeys for adults, youth, children, or guests without mixing their data.',
      children: [
        PremiumCard(
          child: Column(
            children: [
              for (final profile in state.profiles.where(
                (item) => item.accountId == state.activeAccountId || item.accountId == null,
              )) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text(profile.avatar)),
                  title: Text(profile.displayName),
                  subtitle: Text(
                    '${profile.profileType.name} • ${profile.syncMode.name} • Last active ${_formatWhen(profile.lastActiveAtIso)}',
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      if (profile.pinProtected)
                        const Icon(Icons.lock_outline_rounded, size: 18),
                      if (state.activeProfileId == profile.profileId)
                        const Icon(Icons.check_circle_outline_rounded, size: 18),
                    ],
                  ),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await ref.read(deviceSessionManagerProvider).switchProfile(profile.profileId, pin: '');
                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(content: Text('${profile.displayName} is now active.')),
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
          title: 'Add Profile',
          subtitle: 'Choose a profile type, how it should feel, and how its data should be stored.',
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Display name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _avatarController,
                decoration: const InputDecoration(labelText: 'Avatar'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProfileKind>(
                initialValue: _kind,
                items: ProfileKind.values
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(_titleFromEnum(item.name)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _kind = value ?? _kind),
                decoration: const InputDecoration(labelText: 'Profile type'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProfileExperienceMode>(
                initialValue: _experience,
                items: ProfileExperienceMode.values
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(_titleFromEnum(item.name)),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _experience = value ?? _experience),
                decoration: const InputDecoration(labelText: 'Experience mode'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProfileSyncMode>(
                initialValue: _syncMode,
                items: ProfileSyncMode.values
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(_syncModeLabel(item)),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _syncMode = value ?? _syncMode),
                decoration: const InputDecoration(labelText: 'Data mode'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pinController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Optional PIN',
                  helperText: 'Leave empty if this profile should not be protected.',
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref.read(profileManagerProvider).create(
                        displayName: _nameController.text.trim().isEmpty
                            ? 'New Profile'
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
                    const SnackBar(content: Text('Profile created')),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_rounded),
                label: const Text('Create Profile'),
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
  ConsumerState<SignedInAccountsPage> createState() => _SignedInAccountsPageState();
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
    final state = ref.watch(accountsSyncControllerProvider);
    return AppPageScaffold(
      headerIcon: Icons.devices_other_rounded,
      title: 'Signed-In Accounts on This Device',
      subtitle:
          'Keep unrelated identities on one device without mixing their journeys.',
      children: [
        PremiumCard(
          child: Column(
            children: [
              for (final account in state.accounts) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(account.displayName),
                  subtitle: Text(
                    '${_titleFromEnum(account.provider.name)} • ${account.identifier} • ${account.syncMode.name}',
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
              const Text('Sign In Another Account'),
              const SizedBox(height: 12),
              DropdownButtonFormField<AccountProviderType>(
                initialValue: _provider,
                items: AccountProviderType.values
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(_titleFromEnum(item.name)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _provider = value ?? _provider),
                decoration: const InputDecoration(labelText: 'Sign-in method'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _identifierController,
                decoration: const InputDecoration(
                  labelText: 'Email or identifier',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProfileSyncMode>(
                initialValue: _syncMode,
                items: ProfileSyncMode.values
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(_syncModeLabel(item)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _syncMode = value ?? _syncMode),
                decoration: const InputDecoration(labelText: 'Sync mode'),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref.read(accountManagerProvider).add(
                        provider: _provider,
                        identifier: _identifierController.text.trim().isEmpty
                            ? _provider.name
                            : _identifierController.text.trim(),
                        displayName: _nameController.text.trim().isEmpty
                            ? 'Path of Nūr User'
                            : _nameController.text.trim(),
                        syncMode: _syncMode,
                      );
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Account added on this device')),
                  );
                },
                child: const Text('Add Account'),
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
    final state = ref.watch(accountsSyncControllerProvider);
    final settings = state.sharedDeviceSafety;
    return AppPageScaffold(
      headerIcon: Icons.shield_moon_outlined,
      title: 'Shared Device Safety',
      subtitle:
          'Require profile selection on launch, protect adult profiles, and keep child experiences safer.',
      children: [
        PremiumCard(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Require profile selection on launch'),
                value: settings.requireProfileSelectionOnLaunch,
                onChanged: (value) {
                  ref.read(accountsSyncControllerProvider.notifier).updateSharedDeviceSafety(
                        settings.copyWith(requireProfileSelectionOnLaunch: value),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Require PIN for adult profiles'),
                value: settings.requirePinForAdultProfiles,
                onChanged: (value) {
                  ref.read(accountsSyncControllerProvider.notifier).updateSharedDeviceSafety(
                        settings.copyWith(requirePinForAdultProfiles: value),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Auto-lock profile after inactivity'),
                value: settings.autoLockAfterInactivity,
                onChanged: (value) {
                  ref.read(accountsSyncControllerProvider.notifier).updateSharedDeviceSafety(
                        settings.copyWith(autoLockAfterInactivity: value),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Restrict child profile settings'),
                value: settings.restrictChildProfileSettings,
                onChanged: (value) {
                  ref.read(accountsSyncControllerProvider.notifier).updateSharedDeviceSafety(
                        settings.copyWith(restrictChildProfileSettings: value),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hide advanced tools from child profiles'),
                value: settings.hideAdvancedToolsFromChildProfiles,
                onChanged: (value) {
                  ref.read(accountsSyncControllerProvider.notifier).updateSharedDeviceSafety(
                        settings.copyWith(hideAdvancedToolsFromChildProfiles: value),
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
    final devices = ref.watch(accountsSyncControllerProvider).connectedDevices;
    return AppPageScaffold(
      headerIcon: Icons.devices_rounded,
      title: 'Connected Devices',
      subtitle:
          'See which phones, tablets, watches, and TVs are linked to this journey.',
      children: [
        PremiumCard(
          child: Column(
            children: [
              for (final device in devices) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(device.deviceName),
                  subtitle: Text(
                    '${_titleFromEnum(device.platform.name)} • Last active ${_formatWhen(device.lastActiveAtIso)}',
                  ),
                  trailing: device.isCurrentDevice
                      ? const Chip(label: Text('Current'))
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
    final state = ref.watch(accountsSyncControllerProvider);
    return AppPageScaffold(
      headerIcon: Icons.backup_outlined,
      title: 'Backup & Restore',
      subtitle:
          'Keep a manual copy of your journey if you prefer local-only or backup-only storage.',
      children: [
        if (state.backupRecommended)
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Backup recommended'),
              subtitle: const Text(
                'This profile is stored locally and has not been exported recently.',
              ),
            ),
          ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            children: [
              _NavRow(
                title: 'Export Backup',
                subtitle: state.backupRecord.lastExportAtIso == null
                    ? 'Export your current profile or account as JSON.'
                    : 'Last export ${_formatWhen(state.backupRecord.lastExportAtIso)}',
                onTap: () => context.push('/accounts-sync/backup/export'),
              ),
              const Divider(height: 1),
              _NavRow(
                title: 'Import Backup',
                subtitle: 'Restore as a new profile, merge, or replace existing data.',
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
  ConsumerState<BackupExportFlowPage> createState() => _BackupExportFlowPageState();
}

class _BackupExportFlowPageState extends ConsumerState<BackupExportFlowPage> {
  bool _currentProfileOnly = true;
  bool _encrypt = true;
  String? _lastPath;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: Icons.ios_share_rounded,
      title: 'Export Backup',
      subtitle:
          'Create a restorable copy of your journey that you can keep locally, move with AirDrop, or store in Files.',
      children: [
        PremiumCard(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Current profile only'),
                subtitle: const Text('Export only the active profile instead of the full local account set.'),
                value: _currentProfileOnly,
                onChanged: (value) => setState(() => _currentProfileOnly = value),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Encrypted export'),
                subtitle: const Text('Encode the backup payload before writing it to disk.'),
                value: _encrypt,
                onChanged: (value) => setState(() => _encrypt = value),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final path = await ref.read(backupManagerProvider).export(
                        currentProfileOnly: _currentProfileOnly,
                        encrypt: _encrypt,
                      );
                  setState(() => _lastPath = path);
                },
                child: const Text('Export Now'),
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
  ConsumerState<BackupImportFlowPage> createState() => _BackupImportFlowPageState();
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
    return AppPageScaffold(
      headerIcon: Icons.restore_page_outlined,
      title: 'Import Backup',
      subtitle:
          'Paste an exported backup payload and restore it as new, merge it in, or replace the current local set.',
      children: [
        PremiumCard(
          child: Column(
            children: [
              TextField(
                controller: _payloadController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Backup payload',
                  hintText: 'Paste the exported JSON or encoded backup here.',
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Encrypted payload'),
                value: _encrypted,
                onChanged: (value) => setState(() => _encrypted = value),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Create new profiles'),
                value: _createNewProfiles,
                onChanged: (value) => setState(() => _createNewProfiles = value),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Replace existing local data'),
                value: _replaceExisting,
                onChanged: (value) => setState(() => _replaceExisting = value),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref.read(importRestoreServiceProvider).import(
                        payload: _payloadController.text.trim(),
                        encrypted: _encrypted,
                        createNewProfiles: _createNewProfiles,
                        replaceExisting: _replaceExisting,
                      );
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Backup imported')),
                  );
                },
                child: const Text('Restore Backup'),
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
    final state = ref.watch(accountsSyncControllerProvider);
    final sync = state.syncStatus;
    return AppPageScaffold(
      headerIcon: Icons.sync_alt_rounded,
      title: 'Sync Details',
      subtitle:
          'See pending uploads, recent sync events, and whether this device needs attention.',
      children: [
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Current provider'),
                subtitle: Text(_syncModeLabel(sync.syncMode)),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Current state'),
                subtitle: Text(_titleFromEnum(sync.syncState.name)),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Pending uploads'),
                subtitle: Text('${sync.pendingChangesCount} pending changes'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Last successful sync'),
                subtitle: Text(_formatWhen(sync.lastSyncAtIso)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Recent Sync Events'),
              const SizedBox(height: 8),
              for (final event in sync.recentEvents)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• $event'),
                ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.read(syncManagerProvider).syncNow(),
                child: const Text('Sync now'),
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
    final sync = state.syncStatus;
    return PremiumCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_syncStateTitle(sync.syncState)),
            subtitle: Text(_syncModeLabel(sync.syncMode)),
            trailing: Icon(
              switch (sync.syncState) {
                SyncStateKind.allCaughtUp => Icons.cloud_done_outlined,
                SyncStateKind.syncing => Icons.sync_rounded,
                SyncStateKind.offlinePending => Icons.cloud_off_outlined,
                SyncStateKind.needsAttention => Icons.warning_amber_rounded,
                SyncStateKind.localOnly => Icons.phone_iphone_rounded,
                SyncStateKind.iCloudActive => Icons.cloud_queue_rounded,
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Last sync'),
            subtitle: Text(_formatWhen(sync.lastSyncAtIso)),
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Pending changes'),
            subtitle: Text('${sync.pendingChangesCount} change${sync.pendingChangesCount == 1 ? '' : 's'} waiting'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref.read(syncManagerProvider).syncNow(),
                  child: const Text('Sync now'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => context.push('/accounts-sync/sync-details'),
                  child: const Text('View details'),
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

String _titleFromEnum(String value) {
  return value
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => ' ${match.group(1)}',
      )
      .replaceFirstMapped(RegExp(r'^\w'), (match) => match.group(0)!.toUpperCase());
}

String _syncModeLabel(ProfileSyncMode mode) {
  return switch (mode) {
    ProfileSyncMode.pathOfNurCloud => 'Path of Nūr Cloud Sync',
    ProfileSyncMode.iCloud => 'Apple iCloud Sync',
    ProfileSyncMode.localOnly => 'Local Only',
    ProfileSyncMode.manualBackupOnly => 'Manual Backup Only',
  };
}

String _syncStateTitle(SyncStateKind state) {
  return switch (state) {
    SyncStateKind.allCaughtUp => 'All caught up',
    SyncStateKind.syncing => 'Syncing',
    SyncStateKind.offlinePending => 'Offline — changes will sync later',
    SyncStateKind.needsAttention => 'Needs attention',
    SyncStateKind.localOnly => 'Local only',
    SyncStateKind.iCloudActive => 'iCloud active',
  };
}

String _formatWhen(String? iso) {
  if (iso == null) return 'Not yet';
  final date = DateTime.tryParse(iso);
  if (date == null) return 'Unknown';
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}
