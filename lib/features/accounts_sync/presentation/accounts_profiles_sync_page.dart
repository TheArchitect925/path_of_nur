import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../application/accounts_sync_controller.dart';
import '../application/auto_backup_engine.dart';
import '../application/remote_backup_transport.dart';
import '../application/accounts_sync_services.dart';
import '../application/sync_scope_support.dart';
import '../application/sync_foundation.dart';
import '../domain/accounts_sync_models.dart';

class AccountsProfilesSyncPage extends ConsumerStatefulWidget {
  const AccountsProfilesSyncPage({super.key});

  @override
  ConsumerState<AccountsProfilesSyncPage> createState() =>
      _AccountsProfilesSyncPageState();
}

class _AccountsProfilesSyncPageState
    extends ConsumerState<AccountsProfilesSyncPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    final accountStatus = ref.watch(accountsSyncStatusProvider);
    final activeProfile = state.activeProfile;
    final activeAccount = state.activeAccount;
    return AppPageScaffold(
      headerIcon: Icons.manage_accounts_rounded,
      title: l10n.settingsAccountsSyncTitle,
      subtitle: l10n.settingsAccountsSyncSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncStatusCardTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                _connectionModeBody(
                  l10n,
                  accountStatus.mode,
                  accountStatus.accountLabel,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(
                      l10n.accountsSyncCurrentModeValue(
                        _connectionModeLabel(l10n, accountStatus.mode),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      l10n.accountsSyncProviderValue(
                        accountStatus.providerLabel == null
                            ? l10n.accountsSyncProviderNone
                            : _accountProviderNameFromKey(
                                l10n,
                                accountStatus.providerLabel!,
                              ),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      accountStatus.lastBackupAtIso == null
                          ? l10n.accountsSyncBackupNeverBackedUp
                          : l10n.accountsSyncLastBackupValue(
                              _formatWhen(
                                context,
                                l10n,
                                accountStatus.lastBackupAtIso,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
        _AccountConnectionCard(
          onManageAccountsTap: () => context.push('/accounts-sync/accounts'),
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
        const _AccountConnectionCard(),
      ],
    );
  }
}

class _AccountConnectionCard extends ConsumerStatefulWidget {
  const _AccountConnectionCard({this.onManageAccountsTap});

  final VoidCallback? onManageAccountsTap;

  @override
  ConsumerState<_AccountConnectionCard> createState() =>
      _AccountConnectionCardState();
}

class _AccountConnectionCardState
    extends ConsumerState<_AccountConnectionCard> {
  bool _authBusy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(accountsSyncControllerProvider);
    final authState = ref.watch(authStateProvider);
    final status = ref.watch(accountsSyncStatusProvider);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.accountsSyncAccountSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            authState.status == AuthStatus.authenticated
                ? l10n.accountsSyncConnectedAccountBody(
                    state.authenticatedAccount?.displayName ??
                        l10n.accountsSyncProviderNone,
                  )
                : l10n.accountsSyncLocalOnlyBody,
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.accountsSyncCurrentModeLabel),
            subtitle: Text(_connectionModeLabel(l10n, status.mode)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.accountsSyncBackupStatusTitle),
            subtitle: Text(
              status.lastBackupAtIso == null
                  ? l10n.accountsSyncBackupNeverBackedUp
                  : l10n.accountsSyncLastBackupValue(
                      _formatWhen(context, l10n, status.lastBackupAtIso),
                    ),
            ),
          ),
          if (widget.onManageAccountsTap != null) ...[
            const Divider(height: 24),
            _NavRow(
              title: l10n.accountsSyncSignedInAccountsTitle,
              subtitle: l10n.accountsSyncSignInAnotherAccountSubtitle,
              onTap: widget.onManageAccountsTap!,
            ),
          ],
          const Divider(height: 24),
          FilledButton.icon(
            onPressed: _authBusy
                ? null
                : () => _handleAuthAction(
                    () => ref
                        .read(accountsAuthRepositoryProvider)
                        .signInWithApple(),
                  ),
            icon: const Icon(Icons.apple_rounded),
            label: Text(l10n.accountsSyncContinueWithAppleAction),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _authBusy
                ? null
                : () => _handleAuthAction(
                    () => ref
                        .read(accountsAuthRepositoryProvider)
                        .signInWithGoogle(),
                  ),
            icon: const Icon(Icons.account_circle_outlined),
            label: Text(l10n.accountsSyncContinueWithGoogleAction),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _authBusy
                ? null
                : () => _handleAuthAction(
                    () => ref
                        .read(accountsAuthRepositoryProvider)
                        .signInWithEmail(),
                  ),
            icon: const Icon(Icons.email_outlined),
            label: Text(l10n.accountsSyncContinueWithEmailAction),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.accountsSyncEmailComingNextBody,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _authBusy
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await ref.read(accountsAuthRepositoryProvider).signOut();
                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(l10n.accountsSyncContinueLocalOnlyResult),
                      ),
                    );
                  },
            child: Text(l10n.accountsSyncContinueLocalOnlyAction),
          ),
          if (authState.status == AuthStatus.authenticated) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: _authBusy
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await ref.read(accountsAuthRepositoryProvider).signOut();
                      if (!mounted) return;
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l10n.accountsSyncSignedOutResult),
                        ),
                      );
                    },
              child: Text(l10n.accountsSyncSignOutAction),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleAuthAction(
    Future<AuthActionResult> Function() action,
  ) async {
    setState(() => _authBusy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await action();
    if (!mounted) return;
    setState(() => _authBusy = false);
    final message = switch (result.status) {
      AuthActionStatus.success => l10n.accountsSyncAccountConnectedResult(
        result.identity?.displayName ??
            l10n.accountsSyncDefaultAccountDisplayName,
      ),
      AuthActionStatus.cancelled => l10n.accountsSyncAuthCancelledResult,
      AuthActionStatus.unavailable => l10n.accountsSyncAuthUnavailableResult,
      AuthActionStatus.notConfigured =>
        l10n.accountsSyncAuthNotConfiguredResult,
      AuthActionStatus.error => l10n.accountsSyncAuthFailedResult,
    };
    messenger.showSnackBar(SnackBar(content: Text(message)));
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
    final prefs = ref.watch(syncPreferencesProvider);
    final accountStatus = ref.watch(accountsSyncStatusProvider);
    final autoBackup = ref.watch(autoBackupStatusProvider);
    final syncScopePreferences = ref.watch(syncScopePreferencesProvider);
    final syncScopeSummary = buildBackupScopeSummary(syncScopePreferences);
    return AppPageScaffold(
      headerIcon: Icons.backup_outlined,
      title: l10n.settingsBackupRestoreTitle,
      subtitle: l10n.accountsSyncBackupRestorePageSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncRemoteBackupSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                accountStatus.remoteBackupConfigured
                    ? l10n.accountsSyncRemoteBackupReadyBody
                    : l10n.accountsSyncRemoteBackupUnavailableBody,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncRemoteProviderTitle),
                subtitle: Text(
                  accountStatus.remoteProviderLabel == null
                      ? l10n.accountsSyncProviderNone
                      : _remoteProviderLabel(
                          l10n,
                          accountStatus.remoteProviderLabel!,
                        ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncRemoteLastBackupTitle),
                subtitle: Text(
                  accountStatus.lastRemoteBackupAtIso == null
                      ? l10n.accountsSyncBackupNeverBackedUp
                      : l10n.accountsSyncLastBackupValue(
                          _formatWhen(
                            context,
                            l10n,
                            accountStatus.lastRemoteBackupAtIso,
                          ),
                        ),
                ),
              ),
              if (accountStatus.remoteErrorCode != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.accountsSyncRemoteStatusIssueTitle),
                  subtitle: Text(
                    _remoteErrorLabel(l10n, accountStatus.remoteErrorCode!),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final result = await ref
                            .read(remoteBackupRepositoryProvider)
                            .backupNow();
                        if (!context.mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              result.success
                                  ? l10n.accountsSyncRemoteBackupSuccessResult
                                  : _remoteResultLabel(
                                      l10n,
                                      result.messageCode,
                                    ),
                            ),
                          ),
                        );
                      },
                      child: Text(l10n.accountsSyncBackUpNowAction),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final metadata = await ref
                            .read(remoteBackupRepositoryProvider)
                            .fetchRemoteMetadata();
                        if (!context.mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              metadata == null
                                  ? l10n.accountsSyncNoRemoteBackupFound
                                  : l10n.accountsSyncRemoteBackupFoundResult,
                            ),
                          ),
                        );
                      },
                      child: Text(l10n.accountsSyncCheckBackupStatusAction),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final preview = await ref
                      .read(remoteBackupRepositoryProvider)
                      .prepareRestorePreview();
                  if (!context.mounted) return;
                  if (preview == null) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(l10n.accountsSyncNoRemoteBackupFound),
                      ),
                    );
                    return;
                  }
                  context.push(
                    '/accounts-sync/backup/remote-restore',
                    extra: preview,
                  );
                },
                child: Text(l10n.accountsSyncRestoreFromRemoteAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncAutoBackupSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(l10n.accountsSyncAutoBackupSectionSubtitle),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: autoBackup.preferences.enabled,
                title: Text(l10n.accountsSyncAutoBackupEnabledTitle),
                subtitle: Text(
                  autoBackup.preferences.enabled
                      ? l10n.accountsSyncAutoBackupOnBody
                      : l10n.accountsSyncAutoBackupOffBody,
                ),
                onChanged: (value) {
                  ref
                      .read(autoBackupControllerProvider)
                      .updatePreferences(
                        autoBackup.preferences.copyWith(enabled: value),
                      );
                },
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncAutoBackupFrequencyTitle),
                subtitle: Text(
                  _autoBackupFrequencyLabel(
                    l10n,
                    autoBackup.preferences.frequency,
                  ),
                ),
                trailing: DropdownButton<AutoBackupFrequency>(
                  value: autoBackup.preferences.frequency,
                  onChanged: (value) {
                    if (value == null) return;
                    ref
                        .read(autoBackupControllerProvider)
                        .updatePreferences(
                          autoBackup.preferences.copyWith(frequency: value),
                        );
                  },
                  items: AutoBackupFrequency.values
                      .map(
                        (value) => DropdownMenuItem<AutoBackupFrequency>(
                          value: value,
                          child: Text(_autoBackupFrequencyLabel(l10n, value)),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: autoBackup.preferences.backupOnMeaningfulProgressChange,
                title: Text(l10n.accountsSyncAutoBackupMeaningfulChangeTitle),
                onChanged: (value) {
                  ref
                      .read(autoBackupControllerProvider)
                      .updatePreferences(
                        autoBackup.preferences.copyWith(
                          backupOnMeaningfulProgressChange: value,
                        ),
                      );
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: autoBackup.preferences.backupOnBackground,
                title: Text(l10n.accountsSyncAutoBackupBackgroundTitle),
                onChanged: (value) {
                  ref
                      .read(autoBackupControllerProvider)
                      .updatePreferences(
                        autoBackup.preferences.copyWith(
                          backupOnBackground: value,
                        ),
                      );
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncAutoBackupStatusTitle),
                subtitle: Text(_autoBackupStatusBody(l10n, autoBackup)),
              ),
              if (autoBackup.lastAttemptAtIso != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.accountsSyncAutoBackupLastAttemptTitle),
                  subtitle: Text(
                    _formatWhen(context, l10n, autoBackup.lastAttemptAtIso),
                  ),
                ),
              if (autoBackup.lastSuccessAtIso != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.accountsSyncAutoBackupLastSuccessTitle),
                  subtitle: Text(
                    _formatWhen(context, l10n, autoBackup.lastSuccessAtIso),
                  ),
                ),
              if (autoBackup.lastFailureCode != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.accountsSyncAutoBackupFailureTitle),
                  subtitle: Text(
                    _remoteErrorLabel(l10n, autoBackup.lastFailureCode!),
                  ),
                ),
              if (autoBackup.pendingReasons.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: autoBackup.pendingReasons
                        .map(
                          (item) => Chip(
                            label: Text(_pendingBackupReasonLabel(l10n, item)),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: autoBackup.inProgress
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final result = await ref
                            .read(autoBackupControllerProvider)
                            .runIfEligible(
                              trigger: AutoBackupTrigger.manualRetry,
                              force: true,
                            );
                        if (!context.mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              result.success == true
                                  ? l10n.accountsSyncRemoteBackupSuccessResult
                                  : _autoBackupEligibilityLabel(
                                      l10n,
                                      result.eligibility,
                                    ),
                            ),
                          ),
                        );
                      },
                child: Text(l10n.accountsSyncAutoBackupRetryAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncScopeSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(l10n.accountsSyncScopeSectionSubtitle),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncScopeCurrentSummaryTitle),
                subtitle: Text(_syncScopeSummaryBody(l10n, syncScopeSummary)),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncScopeEssentialTitle),
                subtitle: Text(l10n.accountsSyncScopeEssentialSubtitle),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kRequiredSyncDomains
                    .map(
                      (domain) => Chip(
                        label: Text(_syncScopeDomainLabel(l10n, domain)),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncScopeOptionalTitle),
                subtitle: Text(l10n.accountsSyncScopeOptionalSubtitle),
              ),
              for (final domain in kOptionalSyncDomains) ...[
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_syncScopeDomainLabel(l10n, domain)),
                  subtitle: Text(_syncScopeDomainSubtitle(l10n, domain)),
                  value: isDomainIncludedInBackup(syncScopePreferences, domain),
                  onChanged: (value) async {
                    final validation = buildScopeValidationResult(
                      syncScopePreferences,
                      domain,
                    );
                    if (!validation.canToggle) {
                      return;
                    }
                    if (!value &&
                        validation.impactPreview?.requiresConfirmation ==
                            true) {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Text(l10n.accountsSyncScopeConfirmTitle),
                          content: Text(
                            _scopeImpactBody(
                              l10n,
                              domain,
                              includeInBackup: value,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: Text(
                                MaterialLocalizations.of(
                                  dialogContext,
                                ).cancelButtonLabel,
                              ),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: Text(l10n.accountsSyncScopeConfirmAction),
                            ),
                          ],
                        ),
                      );
                      if (confirmed != true) {
                        return;
                      }
                    }
                    final nextPreferences = updateSyncScopePreference(
                      syncScopePreferences,
                      domain: domain,
                      includeInBackup: value,
                    );
                    await ref
                        .read(accountsSyncControllerProvider.notifier)
                        .updateSyncScopePreferences(nextPreferences);
                    await ref
                        .read(autoBackupControllerProvider)
                        .evaluateEligibility(
                          trigger: AutoBackupTrigger.appResumed,
                        );
                  },
                ),
                if (domain != kOptionalSyncDomains.last)
                  const Divider(height: 1),
              ],
              const SizedBox(height: 12),
              Text(
                l10n.accountsSyncScopeManualExportNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (syncScopeSummary.isPartial) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    await ref
                        .read(accountsSyncControllerProvider.notifier)
                        .updateSyncScopePreferences(
                          const SyncScopePreferences(
                            excludedOptionalDomainNames: <String>[],
                          ),
                        );
                    await ref
                        .read(autoBackupControllerProvider)
                        .evaluateEligibility(
                          trigger: AutoBackupTrigger.appResumed,
                        );
                  },
                  child: Text(l10n.accountsSyncScopeRestoreDefaultsAction),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncSyncPreferencesTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: prefs.preferManualBackup,
                title: Text(l10n.accountsSyncPreferManualBackupTitle),
                onChanged: (value) {
                  ref.read(syncPreferencesProvider.notifier).state = prefs
                      .copyWith(preferManualBackup: value);
                },
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: prefs.allowRestoreSuggestions,
                title: Text(l10n.accountsSyncAllowRestoreSuggestionsTitle),
                onChanged: (value) {
                  ref.read(syncPreferencesProvider.notifier).state = prefs
                      .copyWith(allowRestoreSuggestions: value);
                },
              ),
              const SizedBox(height: 8),
              Text(
                l10n.accountsSyncRemoteBackupNotConfiguredBody,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RemoteRestorePreviewPage extends ConsumerStatefulWidget {
  const RemoteRestorePreviewPage({required this.preview, super.key});

  final RestorePreview preview;

  @override
  ConsumerState<RemoteRestorePreviewPage> createState() =>
      _RemoteRestorePreviewPageState();
}

class _RemoteRestorePreviewPageState
    extends ConsumerState<RemoteRestorePreviewPage> {
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preview = widget.preview;
    final summary = preview.comparisonSummary;
    final state = ref.watch(accountsSyncControllerProvider);
    final remoteScope = preview.importPreview.metadata.scopeSummary;
    final currentScope = buildBackupScopeSummary(state.syncScopePreferences);
    return AppPageScaffold(
      headerIcon: Icons.compare_arrows_rounded,
      title: l10n.accountsSyncRemoteRestorePreviewTitle,
      subtitle: l10n.accountsSyncRemoteRestorePreviewSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncRemoteRestoreTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(_restoreSummaryBody(l10n, preview)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(
                      l10n.accountsSyncCurrentProviderSummary(
                        state.authenticatedAccount?.displayName ??
                            l10n.accountsSyncProviderNone,
                        _remoteProviderLabel(
                          l10n,
                          preview.remoteMetadata.provider.name,
                        ),
                        _remoteProviderLabel(
                          l10n,
                          preview.remoteMetadata.provider.name,
                        ),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      l10n.accountsSyncLastBackupValue(
                        _formatWhen(
                          context,
                          l10n,
                          preview.remoteMetadata.updatedAtIso,
                        ),
                      ),
                    ),
                  ),
                  if (summary.localOverallUpdatedAtIso != null)
                    Chip(
                      label: Text(
                        l10n.accountsSyncRemotePreviewLocalUpdatedValue(
                          _formatWhen(
                            context,
                            l10n,
                            summary.localOverallUpdatedAtIso,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncScopePreviewTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.accountsSyncScopePreviewRemoteValue(
                  _syncScopeSummaryBody(l10n, remoteScope),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.accountsSyncScopePreviewCurrentValue(
                  _syncScopeSummaryBody(l10n, currentScope),
                ),
              ),
              if (remoteScope.excludedDomainNames.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final key in remoteScope.excludedDomainNames)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      l10n.accountsSyncScopePreviewExcludedDomain(
                        _syncScopeDomainLabelFromKey(l10n, key),
                      ),
                    ),
                  ),
              ],
              ..._buildScopeMismatchLines(
                l10n,
                remoteScope: remoteScope,
                currentScope: currentScope,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncRemotePreviewComparisonTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              for (final comparison in summary.domainComparisons) ...[
                _DomainComparisonTile(comparison: comparison),
                if (comparison != summary.domainComparisons.last)
                  const Divider(height: 1),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncRemotePreviewWarningsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (summary.warningCodes.isEmpty)
                Text(l10n.accountsSyncRemotePreviewNoWarnings)
              else
                for (final warning in summary.warningCodes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(_restoreWarningLabel(l10n, warning)),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountsSyncRemotePreviewActionsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _running
                    ? null
                    : () => _runRestore(
                        RestoreDecisionMode.replaceLocalWithRemote,
                      ),
                child: Text(l10n.accountsSyncRemotePreviewReplaceAction),
              ),
              const SizedBox(height: 10),
              if (summary.canMergeSafeDomains)
                OutlinedButton(
                  onPressed: _running
                      ? null
                      : () => _runRestore(RestoreDecisionMode.mergeSafeDomains),
                  child: Text(l10n.accountsSyncRemotePreviewMergeAction),
                ),
              if (summary.canMergeSafeDomains) const SizedBox(height: 10),
              TextButton(
                onPressed: _running ? null : () => context.pop(),
                child: Text(l10n.accountsSyncRemotePreviewKeepLocalAction),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _runRestore(RestoreDecisionMode mode) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          mode == RestoreDecisionMode.mergeSafeDomains
              ? l10n.accountsSyncRemotePreviewMergeAction
              : l10n.accountsSyncRemotePreviewReplaceAction,
        ),
        content: Text(
          mode == RestoreDecisionMode.mergeSafeDomains
              ? l10n.accountsSyncRemotePreviewMergeConfirmBody
              : l10n.accountsSyncRemotePreviewReplaceConfirmBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              MaterialLocalizations.of(dialogContext).cancelButtonLabel,
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              mode == RestoreDecisionMode.mergeSafeDomains
                  ? l10n.accountsSyncRemotePreviewMergeAction
                  : l10n.accountsSyncRemotePreviewReplaceAction,
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    setState(() => _running = true);
    final result = await ref
        .read(remoteBackupRepositoryProvider)
        .restoreRemote(mode: mode);
    if (!mounted) {
      return;
    }
    setState(() => _running = false);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          result.applied
              ? l10n.accountsSyncRemotePreviewResultTitle
              : l10n.accountsSyncImportFailedResult,
        ),
        content: Text(_restoreResultLabel(l10n, result)),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(MaterialLocalizations.of(dialogContext).okButtonLabel),
          ),
        ],
      ),
    );
    if (!mounted) {
      return;
    }
    if (result.applied) {
      context.pop();
    }
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
  BackupExportResult? _lastExport;
  bool _busy = false;

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
                onPressed: _busy
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        setState(() => _busy = true);
                        final export = await ref
                            .read(backupRepositoryProvider)
                            .export(
                              BackupExportOptions(
                                currentProfileOnly: _currentProfileOnly,
                                encrypted: _encrypt,
                              ),
                            );
                        if (!mounted) return;
                        setState(() {
                          _busy = false;
                          _lastExport = export;
                        });
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(l10n.accountsSyncExportCreatedResult),
                          ),
                        );
                      },
                child: Text(l10n.accountsSyncExportNowAction),
              ),
              if (_lastExport != null) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.accountsSyncExportReadyBody,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _lastExport!.filePath,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref
                      .read(backupRepositoryProvider)
                      .shareExport(_lastExport!.filePath),
                  child: Text(l10n.accountsSyncShareBackupAction),
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
  bool _busy = false;
  ImportValidationResult? _validationResult;
  ImportConflictMode _mode = ImportConflictMode.merge;
  String? _selectedPayload;

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
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncImportChooseFileTitle),
                subtitle: Text(
                  _selectedPayload == null
                      ? l10n.accountsSyncImportChooseFileSubtitle
                      : l10n.accountsSyncImportFileLoadedSubtitle,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _busy
                    ? null
                    : () async {
                        setState(() => _busy = true);
                        final payload = await ref
                            .read(backupRepositoryProvider)
                            .pickImportPayload();
                        if (!mounted) return;
                        if (payload == null) {
                          setState(() => _busy = false);
                          return;
                        }
                        final result = await ref
                            .read(backupRepositoryProvider)
                            .validateImportPayload(
                              payload: payload,
                              encrypted: _encrypted,
                            );
                        if (!mounted) return;
                        setState(() {
                          _busy = false;
                          _selectedPayload = payload;
                          _validationResult = result;
                        });
                      },
                icon: const Icon(Icons.file_open_outlined),
                label: Text(l10n.accountsSyncChooseBackupFileAction),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.accountsSyncEncryptedPayloadTitle),
                value: _encrypted,
                onChanged: (value) => setState(() => _encrypted = value),
              ),
              const Divider(height: 1),
              SegmentedButton<ImportConflictMode>(
                segments: <ButtonSegment<ImportConflictMode>>[
                  ButtonSegment<ImportConflictMode>(
                    value: ImportConflictMode.merge,
                    label: Text(l10n.accountsSyncImportModeMerge),
                  ),
                  ButtonSegment<ImportConflictMode>(
                    value: ImportConflictMode.replace,
                    label: Text(l10n.accountsSyncImportModeReplace),
                  ),
                ],
                selected: <ImportConflictMode>{_mode},
                onSelectionChanged: (selection) {
                  setState(() => _mode = selection.first);
                },
              ),
              if (_validationResult?.preview != null) ...[
                const SizedBox(height: 16),
                _ImportPreviewCard(
                  preview: _validationResult!.preview!,
                  mode: _mode,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _busy
                      ? null
                      : () => _confirmAndApply(
                          context,
                          _validationResult!.preview!,
                        ),
                  child: Text(l10n.accountsSyncRestoreBackupAction),
                ),
              ] else if (_validationResult?.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _validationMessage(l10n, _validationResult!.errorMessage!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmAndApply(
    BuildContext context,
    ImportPackagePreview preview,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.accountsSyncImportConfirmTitle),
        content: Text(
          _mode == ImportConflictMode.replace
              ? l10n.accountsSyncImportConfirmReplaceBody
              : l10n.accountsSyncImportConfirmMergeBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.accountsSyncRestoreBackupAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    final result = await ref
        .read(backupRepositoryProvider)
        .applyImport(preview: preview, mode: _mode);
    if (!mounted) return;
    setState(() => _busy = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.applied
              ? l10n.accountsSyncBackupImported
              : l10n.accountsSyncImportFailedResult,
        ),
      ),
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
      onTap: onTap,
    );
  }
}

class _ImportPreviewCard extends StatelessWidget {
  const _ImportPreviewCard({required this.preview, required this.mode});

  final ImportPackagePreview preview;
  final ImportConflictMode mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.accountsSyncImportPreviewTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.accountsSyncImportPreviewSummary(
            preview.profileCount,
            preview.accountCount,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.accountsSyncImportPreviewModeValue(
            mode == ImportConflictMode.replace
                ? l10n.accountsSyncImportModeReplace
                : l10n.accountsSyncImportModeMerge,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.accountsSyncImportPreviewExportedAtValue(
            _formatWhen(context, l10n, preview.metadata.exportedAtIso),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.accountsSyncScopePreviewValue(
            _syncScopeSummaryBody(l10n, preview.metadata.scopeSummary),
          ),
        ),
        if (preview.profileNames.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: preview.profileNames
                .map((name) => Chip(label: Text(name)))
                .toList(growable: false),
          ),
        ],
        if (preview.warnings.isNotEmpty) ...[
          const SizedBox(height: 8),
          for (final warning in preview.warnings)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(_warningLabel(l10n, warning)),
            ),
        ],
      ],
    );
  }
}

class _DomainComparisonTile extends StatelessWidget {
  const _DomainComparisonTile({required this.comparison});

  final RestoreDomainComparison comparison;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(_restoreDomainLabel(l10n, comparison.domainId)),
      subtitle: Text(
        l10n.accountsSyncRemotePreviewDomainSummary(
          _restoreConflictLabel(l10n, comparison.conflictType),
          comparison.localItemCount,
          comparison.remoteItemCount,
          _mergeEligibilityLabel(l10n, comparison.mergeEligibility),
        ),
      ),
      isThreeLine: true,
    );
  }
}

String _connectionModeLabel(
  AppLocalizations l10n,
  AccountsSyncConnectionMode mode,
) {
  return switch (mode) {
    AccountsSyncConnectionMode.localOnly => l10n.accountsSyncModeLocalOnly,
    AccountsSyncConnectionMode.signedInNoBackup =>
      l10n.accountsSyncModeSignedInNoBackup,
    AccountsSyncConnectionMode.backupAvailable =>
      l10n.accountsSyncModeBackupAvailable,
    AccountsSyncConnectionMode.backupInProgress =>
      l10n.accountsSyncModeBackupInProgress,
    AccountsSyncConnectionMode.restoreAvailable =>
      l10n.accountsSyncModeRestoreAvailable,
    AccountsSyncConnectionMode.syncError => l10n.accountsSyncModeSyncError,
  };
}

String _restoreSummaryBody(AppLocalizations l10n, RestorePreview preview) {
  if (preview.comparisonSummary.hasSchemaMismatch) {
    return l10n.accountsSyncRemotePreviewSchemaMismatchBody;
  }
  if (preview.comparisonSummary.hasProviderMismatch) {
    return l10n.accountsSyncRemotePreviewProviderMismatchBody;
  }
  if (preview.comparisonSummary.hasAccountMismatch) {
    return l10n.accountsSyncRemotePreviewAccountMismatchBody;
  }
  if (preview.remoteNewerThanLocal) {
    return l10n.accountsSyncRemoteRestoreNewerBody;
  }
  if (preview.remoteOlderThanLocal) {
    return l10n.accountsSyncRemoteRestoreOlderBody;
  }
  return l10n.accountsSyncRemoteRestoreEqualBody;
}

String _restoreDomainLabel(AppLocalizations l10n, String domainId) {
  return switch (domainId) {
    'profile_basics' => l10n.accountsSyncRemoteDomainProfileBasics,
    'settings_preferences' => l10n.accountsSyncRemoteDomainSettings,
    'prayer_tracking' => l10n.accountsSyncRemoteDomainPrayer,
    'dhikr_progress' => l10n.accountsSyncRemoteDomainDhikr,
    'quran_progress' => l10n.accountsSyncRemoteDomainQuran,
    'xp_drops_ocean' => l10n.accountsSyncRemoteDomainGrowth,
    'learning_progress' => l10n.accountsSyncRemoteDomainLearning,
    'journal_notes' => l10n.accountsSyncRemoteDomainJournal,
    'reminders_preferences' => l10n.accountsSyncRemoteDomainReminders,
    'theme_accessibility' => l10n.accountsSyncRemoteDomainTheme,
    _ => domainId,
  };
}

String _syncScopeDomainLabel(AppLocalizations l10n, SyncableDomain domain) {
  return switch (domain) {
    SyncableDomain.profileBasics => l10n.accountsSyncRemoteDomainProfileBasics,
    SyncableDomain.settingsPreferences => l10n.accountsSyncRemoteDomainSettings,
    SyncableDomain.prayerTracking => l10n.accountsSyncRemoteDomainPrayer,
    SyncableDomain.dhikrProgress => l10n.accountsSyncRemoteDomainDhikr,
    SyncableDomain.quranProgress => l10n.accountsSyncRemoteDomainQuran,
    SyncableDomain.growthProgress => l10n.accountsSyncRemoteDomainGrowth,
    SyncableDomain.learningProgress => l10n.accountsSyncRemoteDomainLearning,
    SyncableDomain.journalNotes => l10n.accountsSyncRemoteDomainJournal,
    SyncableDomain.remindersPreferences =>
      l10n.accountsSyncRemoteDomainReminders,
    SyncableDomain.themeAccessibility => l10n.accountsSyncRemoteDomainTheme,
  };
}

String _syncScopeDomainLabelFromKey(AppLocalizations l10n, String key) {
  final domain = syncableDomainFromKey(key);
  return domain == null ? key : _syncScopeDomainLabel(l10n, domain);
}

String _syncScopeDomainSubtitle(AppLocalizations l10n, SyncableDomain domain) {
  return switch (domain) {
    SyncableDomain.settingsPreferences =>
      l10n.accountsSyncScopeSettingsDescription,
    SyncableDomain.journalNotes => l10n.accountsSyncScopeJournalDescription,
    SyncableDomain.remindersPreferences =>
      l10n.accountsSyncScopeRemindersDescription,
    SyncableDomain.themeAccessibility => l10n.accountsSyncScopeThemeDescription,
    _ => '',
  };
}

String _syncScopeSummaryBody(
  AppLocalizations l10n,
  BackupScopeSummary summary,
) {
  if (!summary.isPartial) {
    return l10n.accountsSyncScopeSummaryFull;
  }
  final excluded = summary.excludedDomainNames
      .map((key) => _syncScopeDomainLabelFromKey(l10n, key))
      .join(', ');
  return l10n.accountsSyncScopeSummaryPartial(excluded);
}

String _scopeImpactBody(
  AppLocalizations l10n,
  SyncableDomain domain, {
  required bool includeInBackup,
}) {
  final label = _syncScopeDomainLabel(l10n, domain);
  if (includeInBackup) {
    return l10n.accountsSyncScopeIncludeImpactBody(label);
  }
  return l10n.accountsSyncScopeExcludeImpactBody(label);
}

List<Widget> _buildScopeMismatchLines(
  AppLocalizations l10n, {
  required BackupScopeSummary remoteScope,
  required BackupScopeSummary currentScope,
}) {
  final lines = <Widget>[];
  final remoteExcluded = remoteScope.excludedDomainNames.toSet();
  final currentIncluded = currentScope.includedDomainNames.toSet();
  final mismatch = currentIncluded.intersection(remoteExcluded);
  if (mismatch.isNotEmpty) {
    lines.add(const SizedBox(height: 12));
    for (final key in mismatch) {
      lines.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            l10n.accountsSyncScopePreviewMismatchDomain(
              _syncScopeDomainLabelFromKey(l10n, key),
            ),
          ),
        ),
      );
    }
  }
  return lines;
}

String _restoreConflictLabel(AppLocalizations l10n, RestoreConflictType type) {
  return switch (type) {
    RestoreConflictType.identical => l10n.accountsSyncRemoteConflictIdentical,
    RestoreConflictType.remoteNewer =>
      l10n.accountsSyncRemoteConflictRemoteNewer,
    RestoreConflictType.localNewer => l10n.accountsSyncRemoteConflictLocalNewer,
    RestoreConflictType.remoteOnlyData =>
      l10n.accountsSyncRemoteConflictRemoteOnly,
    RestoreConflictType.localOnlyData =>
      l10n.accountsSyncRemoteConflictLocalOnly,
    RestoreConflictType.incompatibleSchema =>
      l10n.accountsSyncRemoteConflictSchema,
    RestoreConflictType.uncertainDifference =>
      l10n.accountsSyncRemoteConflictUncertain,
    RestoreConflictType.accountMismatch =>
      l10n.accountsSyncRemoteConflictAccountMismatch,
    RestoreConflictType.providerMismatch =>
      l10n.accountsSyncRemoteConflictProviderMismatch,
  };
}

String _mergeEligibilityLabel(
  AppLocalizations l10n,
  MergeEligibilityResult result,
) {
  return switch (result) {
    MergeEligibilityResult.safeToMerge => l10n.accountsSyncRemoteMergeSafe,
    MergeEligibilityResult.replaceOnly =>
      l10n.accountsSyncRemoteMergeReplaceOnly,
    MergeEligibilityResult.unsafe => l10n.accountsSyncRemoteMergeUnsafe,
    MergeEligibilityResult.unsupported =>
      l10n.accountsSyncRemoteMergeUnsupported,
  };
}

String _restoreWarningLabel(AppLocalizations l10n, String code) {
  return switch (code) {
    'provider_mismatch' => l10n.accountsSyncRemotePreviewProviderMismatchBody,
    'account_mismatch' => l10n.accountsSyncRemotePreviewAccountMismatchBody,
    'incompatible_schema' => l10n.accountsSyncRemotePreviewSchemaMismatchBody,
    'local_newer_progress' => l10n.accountsSyncRemoteRestoreOlderBody,
    'remote_newer_progress' => l10n.accountsSyncRemoteRestoreNewerBody,
    'local_only_data' => l10n.accountsSyncRemotePreviewLocalOnlyWarning,
    'remote_only_data' => l10n.accountsSyncRemotePreviewRemoteOnlyWarning,
    'uncertain_difference' => l10n.accountsSyncRemotePreviewUncertainWarning,
    _ => code,
  };
}

String _restoreResultLabel(AppLocalizations l10n, RestoreResult result) {
  if (!result.applied) {
    return l10n.accountsSyncImportFailedResult;
  }
  final summary = result.conflictSummary;
  final merged = summary.mergedDomains.isEmpty
      ? l10n.accountsSyncRemotePreviewNoMergedDomains
      : summary.mergedDomains
            .map((id) => _restoreDomainLabel(l10n, id))
            .join(', ');
  final replaced = summary.replacedDomains.isEmpty
      ? l10n.accountsSyncRemotePreviewNoReplacedDomains
      : summary.replacedDomains
            .map((id) => _restoreDomainLabel(l10n, id))
            .join(', ');
  return l10n.accountsSyncRemotePreviewResultBody(
    summary.decisionMode == RestoreDecisionMode.mergeSafeDomains
        ? l10n.accountsSyncRemotePreviewMergeAction
        : l10n.accountsSyncRemotePreviewReplaceAction,
    merged,
    replaced,
    result.safetySnapshotPath == null
        ? l10n.accountsSyncBackupNeverBackedUp
        : result.safetySnapshotPath!,
  );
}

String _autoBackupFrequencyLabel(
  AppLocalizations l10n,
  AutoBackupFrequency frequency,
) {
  return switch (frequency) {
    AutoBackupFrequency.smart => l10n.accountsSyncAutoBackupFrequencySmart,
    AutoBackupFrequency.daily => l10n.accountsSyncAutoBackupFrequencyDaily,
    AutoBackupFrequency.weekly => l10n.accountsSyncAutoBackupFrequencyWeekly,
    AutoBackupFrequency.manualOnly =>
      l10n.accountsSyncAutoBackupFrequencyManual,
  };
}

String _autoBackupStatusBody(
  AppLocalizations l10n,
  AutoBackupStatusViewModel state,
) {
  if (!state.preferences.enabled) {
    return l10n.accountsSyncAutoBackupStatusOff;
  }
  if (state.inProgress) {
    return l10n.accountsSyncAutoBackupStatusRunning;
  }
  if (state.lastFailureCode != null) {
    return l10n.accountsSyncAutoBackupStatusFailed;
  }
  if (state.dirty) {
    return l10n.accountsSyncAutoBackupStatusPending;
  }
  if (state.lastSuccessAtIso != null) {
    return l10n.accountsSyncAutoBackupStatusReady;
  }
  return l10n.accountsSyncAutoBackupStatusWaiting;
}

String _pendingBackupReasonLabel(
  AppLocalizations l10n,
  PendingBackupReason reason,
) {
  return switch (reason) {
    PendingBackupReason.meaningfulProgressChanged =>
      l10n.accountsSyncAutoBackupReasonMeaningfulChange,
    PendingBackupReason.backupOverdue =>
      l10n.accountsSyncAutoBackupReasonOverdue,
    PendingBackupReason.signedIn => l10n.accountsSyncAutoBackupReasonSignedIn,
    PendingBackupReason.manualRetry =>
      l10n.accountsSyncAutoBackupReasonManualRetry,
  };
}

String _autoBackupEligibilityLabel(
  AppLocalizations l10n,
  AutoBackupEligibilityResult result,
) {
  return switch (result) {
    AutoBackupEligibilityResult.eligibleNow =>
      l10n.accountsSyncAutoBackupEligibilityReady,
    AutoBackupEligibilityResult.disabled =>
      l10n.accountsSyncAutoBackupEligibilityDisabled,
    AutoBackupEligibilityResult.manualOnly =>
      l10n.accountsSyncAutoBackupEligibilityManualOnly,
    AutoBackupEligibilityResult.notSignedIn =>
      l10n.accountsSyncAutoBackupEligibilitySignInRequired,
    AutoBackupEligibilityResult.providerUnavailable =>
      l10n.accountsSyncAutoBackupEligibilityProviderUnavailable,
    AutoBackupEligibilityResult.noMeaningfulChanges =>
      l10n.accountsSyncAutoBackupEligibilityNoChanges,
    AutoBackupEligibilityResult.throttled =>
      l10n.accountsSyncAutoBackupEligibilityThrottled,
    AutoBackupEligibilityResult.backupAlreadyRunning =>
      l10n.accountsSyncAutoBackupEligibilityRunning,
    AutoBackupEligibilityResult.waitingForSchedule =>
      l10n.accountsSyncAutoBackupEligibilityWaiting,
  };
}

String _connectionModeBody(
  AppLocalizations l10n,
  AccountsSyncConnectionMode mode,
  String? accountLabel,
) {
  return switch (mode) {
    AccountsSyncConnectionMode.localOnly =>
      l10n.accountsSyncStatusCardLocalOnlyBody,
    AccountsSyncConnectionMode.signedInNoBackup =>
      l10n.accountsSyncStatusCardSignedInBody(
        accountLabel ?? l10n.accountsSyncProviderNone,
      ),
    AccountsSyncConnectionMode.backupAvailable =>
      l10n.accountsSyncStatusCardBackupReadyBody,
    AccountsSyncConnectionMode.backupInProgress =>
      l10n.accountsSyncStatusCardBackupRunningBody,
    AccountsSyncConnectionMode.restoreAvailable =>
      l10n.accountsSyncStatusCardRestoreReadyBody,
    AccountsSyncConnectionMode.syncError =>
      l10n.accountsSyncStatusCardSyncErrorBody,
  };
}

String _accountProviderNameFromKey(AppLocalizations l10n, String key) {
  return switch (key) {
    'signInWithApple' => l10n.accountsSyncProviderSignInWithApple,
    'google' => l10n.accountsSyncProviderGoogle,
    'emailMagicLink' => l10n.accountsSyncProviderEmailMagicLink,
    'localOnly' => l10n.accountsSyncProviderLocalOnly,
    _ => key,
  };
}

String _validationMessage(AppLocalizations l10n, String code) {
  return switch (code) {
    'empty_payload' => l10n.accountsSyncImportErrorEmpty,
    'future_schema' => l10n.accountsSyncImportErrorFutureSchema,
    _ => l10n.accountsSyncImportErrorInvalid,
  };
}

String _warningLabel(AppLocalizations l10n, String code) {
  return switch (code) {
    'structured_data_missing' =>
      l10n.accountsSyncImportWarningStructuredDataMissing,
    _ => code,
  };
}

String _remoteProviderLabel(AppLocalizations l10n, String key) {
  return switch (key) {
    'apple' => l10n.accountsSyncProviderSignInWithApple,
    'google' => l10n.accountsSyncProviderGoogle,
    'email' => l10n.accountsSyncContinueWithEmailAction,
    _ => l10n.accountsSyncProviderNone,
  };
}

String _remoteErrorLabel(AppLocalizations l10n, String code) {
  return switch (code) {
    'providerNotConfigured' => l10n.accountsSyncRemoteProviderNeedsSetupBody,
    'authExpired' => l10n.accountsSyncRemoteAuthExpiredBody,
    'icloud_unavailable' => l10n.accountsSyncRemoteICloudUnavailableBody,
    'google_auth_expired' => l10n.accountsSyncRemoteAuthExpiredBody,
    'google_drive_upload_failed' => l10n.accountsSyncRemoteBackupFailedBody,
    'email_backup_not_configured' =>
      l10n.accountsSyncRemoteEmailUnavailableBody,
    _ => l10n.accountsSyncRemoteBackupFailedBody,
  };
}

String _remoteResultLabel(AppLocalizations l10n, String? code) {
  if (code == null) return l10n.accountsSyncRemoteBackupFailedBody;
  return _remoteErrorLabel(l10n, code);
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
      return l10n.accountsSyncTransportUnknown;
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
  if (raw == 'Local-only mode active') {
    return l10n.accountsSyncResultLocalOnlyModeActive;
  }
  if (raw == 'sync_result_no_changes') {
    return l10n.accountsSyncResultNoChanges;
  }
  if (raw == 'No changes to sync') {
    return l10n.accountsSyncResultNoChanges;
  }
  if (raw == 'sync_result_completed_successfully') {
    return l10n.accountsSyncResultCompletedSuccessfully;
  }
  if (raw == 'Sync completed successfully') {
    return l10n.accountsSyncResultCompletedSuccessfully;
  }
  if (raw == 'sync_event_local_only_mode_active') {
    return l10n.accountsSyncEventLocalOnlyModeActive;
  }
  if (raw == 'sync_event_no_changes') {
    return l10n.accountsSyncEventNoChanges;
  }
  if (raw == 'Offline') {
    return l10n.accountsSyncErrorOffline;
  }
  if (raw == 'Sync unavailable') {
    return l10n.accountsSyncErrorSyncUnavailable;
  }
  if (raw == 'Transport failure') {
    return l10n.accountsSyncErrorTransportFailure;
  }
  if (raw == 'iCloud is unavailable or not signed in') {
    return l10n.accountsSyncErrorICloudUnavailable;
  }
  if (raw == 'iCloud sync is only available on Apple devices') {
    return l10n.accountsSyncErrorICloudUnsupportedPlatform;
  }
  if (raw == 'iCloud write failed. Check signing and iCloud capability.') {
    return l10n.accountsSyncErrorICloudWriteFailed;
  }
  final uploadedLegacy = RegExp(r'^Uploaded (\d+) changes$').firstMatch(raw);
  if (uploadedLegacy != null) {
    return l10n.accountsSyncEventUploadedChanges(
      int.tryParse(uploadedLegacy.group(1) ?? '') ?? 0,
    );
  }
  final inboundLegacy = RegExp(
    r'^Applied (\d+) inbound changes$',
  ).firstMatch(raw);
  if (inboundLegacy != null) {
    return l10n.accountsSyncEventAppliedInboundChanges(
      int.tryParse(inboundLegacy.group(1) ?? '') ?? 0,
    );
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
      return l10n.accountsSyncStatusUnknown;
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
