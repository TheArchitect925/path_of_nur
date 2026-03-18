import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/reminders/adhan_audio_service.dart';
import '../../../core/reminders/adhan_options.dart';
import '../../../core/reminders/reminder_scheduler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/section_title.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../../profile/domain/profile_age_preferences.dart';
import 'adhan_option_picker_sheet.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prayerState = ref.watch(prayerSettingsProvider);
    final prayerNotifier = ref.read(prayerSettingsProvider.notifier);
    final locationState = ref.watch(locationPermissionProvider);
    final locationNotifier = ref.read(locationPermissionProvider.notifier);
    final userProfile = ref.watch(userProfileProvider);
    final userProfileNotifier = ref.read(userProfileProvider.notifier);
    final specialMode = ref.watch(specialModeProvider);
    final profileSettings = ref.watch(profileSettingsProvider);
    final profileSettingsNotifier = ref.read(profileSettingsProvider.notifier);
    final profileSummary = ref.watch(profileSummaryProvider);
    final reminderPlan = ref.watch(reminderSchedulerProvider);
    final adhanRepository = ref.watch(adhanRepositoryProvider);
    final adhanPreview = ref.watch(adhanPreviewControllerProvider);
    final adhanPreviewController = ref.read(
      adhanPreviewControllerProvider.notifier,
    );
    final displayLocation = ref.watch(prayerLocationDisplayLabelProvider);
    final accountsSync = ref.watch(accountsSyncControllerProvider);
    final locationLabel =
        displayLocation.valueOrNull ??
        (prayerState.preferences.useDeviceLocation
            ? l10n.settingsCurrentLocation
            : prayerState.preferences.location);

    return AppPageScaffold(
      headerIcon: Icons.settings_outlined,
      title: l10n.profilePrayerSettingsTitle,
      subtitle: l10n.profileSummarySubtitle,
      children: [
        SectionTitle(
          title: l10n.settingsProfilePersonalizationTitle,
          subtitle: l10n.settingsProfilePersonalizationSubtitle,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(
                  l10n.settingsProfileDisplayNameSummary(
                    _addressFromSex(userProfile.sex, l10n),
                    userProfile.name,
                  ),
                ),
                subtitle: Text(
                  l10n.settingsProfileLevelStreakSummary(
                    l10n.homeLevelValue(
                      _formatCount(context, profileSummary.level),
                      _formatCount(context, profileSummary.level),
                    ),
                    l10n.homeDaysCount(profileSummary.currentStreakDays),
                    profileSummary.currentStreakDays,
                    profileSummary.level,
                    profileSummary.currentStreakDays,
                    profileSummary.currentStreakDays,
                  ),
                ),
              ),
              TextFormField(
                initialValue: userProfile.name,
                decoration: InputDecoration(
                  labelText: l10n.profileDisplayNameLabel,
                  isDense: true,
                ),
                onChanged: userProfileNotifier.updateName,
                maxLength: 26,
              ),
              const SizedBox(height: 12),
              Text(l10n.profileAddressMeAs),
              const SizedBox(height: 8),
              SegmentedButton<UserSex>(
                segments: [
                  ButtonSegment<UserSex>(
                    value: UserSex.brother,
                    label: Text(l10n.profileBrother),
                  ),
                  ButtonSegment<UserSex>(
                    value: UserSex.sister,
                    label: Text(l10n.profileSister),
                  ),
                ],
                selected: {userProfile.sex},
                onSelectionChanged: (value) {
                  userProfileNotifier.updateSex(value.first);
                },
              ),
              const Divider(height: 24),
              _ModeTile(
                icon: IslamicIcons.lantern,
                title: l10n.profileRamadanModeTitle,
                subtitle: l10n.profileRamadanModeSubtitle,
                value: specialMode.isRamadan,
                onChanged: profileSettingsNotifier.setRamadanModeEnabled,
              ),
              const Divider(height: 1),
              _ModeTile(
                icon: IslamicIcons.community,
                title: l10n.profileLossModeTitle,
                subtitle: l10n.profileLossModeSubtitle,
                value: specialMode.isLoss,
                onChanged: profileSettingsNotifier.setLossModeEnabled,
              ),
              const Divider(height: 1),
              _ModeTile(
                icon: IslamicIcons.tasbih,
                title: l10n.profileGentleModeTitle,
                subtitle: l10n.profileGentleModeSubtitle,
                value: specialMode.isGentle,
                onChanged: profileSettingsNotifier.setGentleModeEnabled,
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(IslamicIcons.family, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.kidsUiThemeSettingTitle,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.kidsUiThemeSettingSubtitle,
                                style: const TextStyle(
                                  color: Color(0xFF675B4E),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<ProfileAgeRange>(
                      initialValue: profileSettings.ageRange,
                      decoration: InputDecoration(
                        labelText: l10n.kidsUiAgeRangeTitle,
                        isDense: true,
                      ),
                      items: ProfileAgeRange.values
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(_profileAgeRangeLabel(item, l10n)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          profileSettingsNotifier.setAgeRange(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<KidsUiThemeMode>(
                      initialValue: profileSettings.kidsUiThemeMode,
                      decoration: InputDecoration(
                        labelText: l10n.kidsUiThemeSettingModeTitle,
                        helperText: l10n.kidsUiThemeSettingModeHelper(
                          profileSettings.effectiveKidsUiThemeEnabled
                              ? l10n.kidsUiThemeModeOn
                              : l10n.kidsUiThemeModeOff,
                        ),
                        isDense: true,
                      ),
                      items: KidsUiThemeMode.values
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(_kidsUiThemeModeLabel(item, l10n)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          profileSettingsNotifier.setKidsUiThemeMode(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.summarize_outlined),
                title: Text(l10n.homeOverviewHeroTitle),
                subtitle: Text(l10n.homeOverviewHeroSubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.pushNamed('profileSummary'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.new_releases_outlined),
                title: Text(l10n.settingsWhatsNewTitle),
                subtitle: Text(l10n.settingsWhatsNewSubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.pushNamed('profileWhatsNew'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.upcoming_outlined),
                title: Text(l10n.settingsComingSoonTitle),
                subtitle: Text(l10n.settingsComingSoonSubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.pushNamed('profileComingSoon'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.settingsAccountsSyncTitle,
          subtitle: l10n.settingsAccountsSyncSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsCurrentProfileTitle),
                subtitle: Text(
                  accountsSync.activeProfile == null
                      ? l10n.settingsNoProfileSelected
                      : l10n.settingsCurrentProfileSummary(
                          accountsSync.activeProfile!.displayName,
                          _profileSyncModeLabel(
                            accountsSync.activeProfile!.syncMode,
                            l10n,
                          ),
                        ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/accounts-sync'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsSyncStatusTitle),
                subtitle: Text(
                  l10n.settingsSyncStatusSummary(
                    accountsSync.syncStatus.pendingChangesCount,
                    _syncStateLabel(accountsSync.syncStatus.syncState, l10n),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/accounts-sync/sync-details'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsBackupRestoreTitle),
                subtitle: Text(
                  accountsSync.backupRecommended
                      ? l10n.settingsBackupRecommended
                      : accountsSync.backupRecord.lastExportAtIso == null
                      ? l10n.settingsNoManualBackupYet
                      : l10n.settingsLastExportRecorded,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/accounts-sync/backup'),
              ),
              if (accountsSync.activeProfile != null &&
                  accountsSync.activeProfile!.profileType !=
                      ProfileKind.child &&
                  accountsSync.activeProfile!.profileType !=
                      ProfileKind.guest) ...[
                const Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.familyLearningSettingsTitle),
                  subtitle: Text(l10n.familyLearningSettingsSubtitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.pushNamed('learnFamilyManagement'),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.settingsAdhanTitle,
          subtitle: l10n.settingsAdhanSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsEnableAdhanAudioTitle),
                subtitle: Text(l10n.settingsEnableAdhanAudioSubtitle),
                value: prayerState.adhanSettings.enabled,
                onChanged: prayerNotifier.setAdhanEnabled,
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsRegularAdhanTitle),
                subtitle: Text(
                  adhanRepository
                      .resolveRegular(prayerState.adhanSettings)
                      .option
                      .title,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => AdhanOptionPickerSheet(
                      category: AdhanOptionCategory.regular,
                      selectedId:
                          prayerState.adhanSettings.selectedRegularAdhanId,
                      settings: prayerState.adhanSettings,
                      onSelected: prayerNotifier.selectRegularAdhan,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsFajrAdhanTitle),
                subtitle: Text(
                  adhanRepository
                      .resolveFajr(prayerState.adhanSettings)
                      .option
                      .title,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => AdhanOptionPickerSheet(
                      category: AdhanOptionCategory.fajr,
                      selectedId: prayerState.adhanSettings.selectedFajrAdhanId,
                      settings: prayerState.adhanSettings,
                      onSelected: prayerNotifier.selectFajrAdhan,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsPreviewVolumeTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            adhanPreviewController.playRegular(
                              prayerState.adhanSettings,
                            );
                          },
                          icon: Icon(
                            adhanPreview.playingOptionId ==
                                        prayerState
                                            .adhanSettings
                                            .selectedRegularAdhanId &&
                                    (adhanPreview.isPlaying ||
                                        adhanPreview.isBuffering)
                                ? Icons.stop_circle_outlined
                                : Icons.play_circle_outline_rounded,
                          ),
                          label: Text(l10n.settingsTestRegularAdhan),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            adhanPreviewController.playFajr(
                              prayerState.adhanSettings,
                            );
                          },
                          icon: Icon(
                            adhanPreview.playingOptionId ==
                                        prayerState
                                            .adhanSettings
                                            .selectedFajrAdhanId &&
                                    (adhanPreview.isPlaying ||
                                        adhanPreview.isBuffering)
                                ? Icons.stop_circle_outlined
                                : Icons.play_circle_outline_rounded,
                          ),
                          label: Text(l10n.settingsTestFajrAdhan),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.settingsUseAppVolumeTitle),
                      subtitle: Text(l10n.settingsUseAppVolumeSubtitle),
                      value: prayerState.adhanSettings.useAppVolume,
                      onChanged: prayerNotifier.setUseAppAdhanVolume,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsAdhanPreviewVolume,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Slider(
                      value: prayerState.adhanSettings.volume,
                      onChanged: prayerState.adhanSettings.useAppVolume
                          ? null
                          : prayerNotifier.setAdhanVolume,
                    ),
                    Text(
                      prayerState.adhanSettings.useAppVolume
                          ? l10n.settingsUsingAppVolume
                          : l10n.settingsPercentValue(
                              _formatCount(
                                context,
                                (prayerState.adhanSettings.volume * 100)
                                    .round(),
                              ),
                            ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: prayerNotifier.restoreDefaultAdhanSettings,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l10n.settingsRestoreDefaultAdhanSettings),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.profilePrayerSettingsTitle,
          subtitle: l10n.profilePrayerSettingsSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.profileLocationLabel),
                subtitle: Text(locationLabel),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final service = ref.read(prayerLocationSearchServiceProvider);
                  final recentLocations = ref.read(
                    prayerRecentLocationsProvider,
                  );
                  final selection =
                      await showModalBottomSheet<PrayerLocationPickerSelection>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => PrayerLocationPickerSheet(
                          currentLocationLabel: locationLabel,
                          recentLocations: recentLocations,
                          onSearch: service.search,
                        ),
                      );
                  if (selection == null) return;
                  if (selection.useDeviceLocation) {
                    await locationNotifier.requestWhileUsingApp();
                    prayerNotifier.useCurrentLocation();
                    return;
                  }
                  if (selection.latitude == null ||
                      selection.longitude == null) {
                    return;
                  }
                  await ref
                      .read(prayerRecentLocationsStoreProvider)
                      .save(
                        PrayerRecentLocation(
                          label: selection.label,
                          latitude: selection.latitude!,
                          longitude: selection.longitude!,
                        ),
                      );
                  prayerNotifier.setManualLocation(
                    label: selection.label,
                    latitude: selection.latitude!,
                    longitude: selection.longitude!,
                  );
                },
              ),
              const Divider(height: 1),
              _PreferenceDropdown<PrayerMadhab>(
                label: l10n.profileMadhabLabel,
                value: prayerState.preferences.madhab,
                entries: const {
                  PrayerMadhab.shafii: '',
                  PrayerMadhab.hanafi: '',
                  PrayerMadhab.maliki: '',
                  PrayerMadhab.hanbali: '',
                },
                entryBuilder: (value) => _madhabLabel(value, l10n),
                onChanged: (value) {
                  if (value != null) prayerNotifier.updateMadhab(value);
                },
              ),
              const Divider(height: 1),
              _PreferenceDropdown<PrayerCalculationMethod>(
                label: l10n.profileCalculationMethodLabel,
                value: prayerState.preferences.calculationMethod,
                entries: const {
                  PrayerCalculationMethod.muslimWorldLeague: '',
                  PrayerCalculationMethod.egyptian: '',
                  PrayerCalculationMethod.isna: '',
                  PrayerCalculationMethod.karachi: '',
                  PrayerCalculationMethod.ummAlQura: '',
                },
                entryBuilder: (value) => _calculationMethodLabel(value, l10n),
                onChanged: (value) {
                  if (value != null) prayerNotifier.updateMethod(value);
                },
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _PrayerTimeAdjustmentsSection(
                  l10n: l10n,
                  prayerState: prayerState,
                  prayerNotifier: prayerNotifier,
                ),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsStableDynamicIslandTitle),
                subtitle: Text(l10n.settingsStableDynamicIslandSubtitle),
                value: prayerState.preferences.useStableDynamicIsland,
                onChanged: prayerNotifier.setStableDynamicIsland,
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsStableLockScreenWidgetTitle),
                subtitle: Text(l10n.settingsStableLockScreenWidgetSubtitle),
                value: prayerState.preferences.useStableLockScreenWidget,
                onChanged: prayerNotifier.setStableLockScreenWidget,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.profileAppearanceTitle,
          subtitle: l10n.profileAppearanceSubtitle,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.profileThemeModeLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ThemeChoiceChip(
                    label: l10n.settingsThemeChoiceDefault,
                    selected:
                        profileSettings.appThemeMode ==
                        AppThemeMode.defaultMode,
                    onSelected: () {
                      profileSettingsNotifier.setAppThemeMode(
                        AppThemeMode.defaultMode,
                      );
                      _showAppearanceSnack(
                        context,
                        l10n.settingsThemeChangedSuccessfully,
                      );
                    },
                  ),
                  _ThemeChoiceChip(
                    label: l10n.settingsThemeChoiceEasyRead,
                    selected:
                        profileSettings.appThemeMode == AppThemeMode.easyRead,
                    onSelected: () {
                      profileSettingsNotifier.setAppThemeMode(
                        AppThemeMode.easyRead,
                      );
                      _showAppearanceSnack(
                        context,
                        l10n.settingsThemeChangedSuccessfully,
                      );
                    },
                  ),
                  _ThemeChoiceChip(
                    label: l10n.profileThemeDark,
                    selected: profileSettings.appThemeMode == AppThemeMode.dark,
                    onSelected: () {
                      profileSettingsNotifier.setAppThemeMode(
                        AppThemeMode.dark,
                      );
                      _showAppearanceSnack(
                        context,
                        l10n.settingsThemeChangedSuccessfully,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _themeModeDescription(profileSettings.appThemeMode, l10n),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.settingsVisualPreferencesTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              _SettingsToggleRow(
                label: l10n.settingsDisableGlassTransparencyTitle,
                subtitle: l10n.settingsDisableGlassTransparencySubtitle,
                value: profileSettings.disableGlassTransparency,
                onChanged: (value) {
                  profileSettingsNotifier.setDisableGlassTransparency(value);
                  _showAppearanceSnack(
                    context,
                    l10n.settingsVisualPreferenceUpdated,
                  );
                },
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.settingsDisableBackgroundTitle,
                subtitle: l10n.settingsDisableBackgroundSubtitle,
                value: profileSettings.disableBackground,
                onChanged: (value) {
                  profileSettingsNotifier.setDisableBackground(value);
                  _showAppearanceSnack(
                    context,
                    l10n.settingsVisualPreferenceUpdated,
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                l10n.settingsAppearanceNoContentChangeNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (profileSettings.appThemeMode == AppThemeMode.defaultMode &&
                  !profileSettings.disableGlassTransparency &&
                  !profileSettings.disableBackground) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.settingsDefaultAppearanceActive,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  profileSettingsNotifier.resetAppearance();
                  _showAppearanceSnack(
                    context,
                    l10n.settingsAppearanceResetToDefault,
                  );
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.settingsResetAppearance),
              ),
              const SizedBox(height: 10),
              _SettingsToggleRow(
                label: l10n.profileReduceMotion,
                value: profileSettings.reduceMotion,
                onChanged: profileSettingsNotifier.setReduceMotion,
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profileHighContrastText,
                value: profileSettings.highContrastText,
                onChanged: profileSettingsNotifier.setHighContrastText,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.settingsPrayerNotificationsTitle,
          subtitle: l10n.settingsPrayerNotificationsSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.profilePrayerReminders),
                subtitle: Text(
                  l10n.profilePlannedRemindersToday(
                    reminderPlan.items
                        .where(
                          (item) =>
                              item.kind == ReminderKind.prayerAtTime ||
                              item.kind == ReminderKind.prayerBeforeQaza,
                        )
                        .length,
                  ),
                ),
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profilePrayerReminders,
                subtitle: l10n.settingsPrayerRemindersToggleSubtitle,
                value: profileSettings.prayerReminders,
                onChanged: profileSettingsNotifier.setPrayerReminders,
              ),
              const Divider(height: 1),
              ..._buildPrayerNotificationTiles(
                context: context,
                settings: prayerState,
                onChanged: prayerNotifier.updateNotificationMode,
                l10n: l10n,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.profileTrackingPrivacyTitle,
          subtitle: l10n.profileTrackingPrivacySubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                title: Text(l10n.profileLocationWhileUsingApp),
                subtitle: Text(
                  locationState.isGranted
                      ? l10n.profileLocationEnabledSubtitle
                      : l10n.profileLocationDisabledSubtitle,
                ),
                trailing: locationState.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton(
                        onPressed: locationState.isPermanentlyDenied
                            ? locationNotifier.openSystemSettings
                            : locationNotifier.requestWhileUsingApp,
                        child: Text(
                          locationState.isPermanentlyDenied
                              ? l10n.profileOpenSettings
                              : l10n.profileAllow,
                        ),
                      ),
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profilePrivateTrackingModeTitle,
                subtitle: l10n.profilePrivateTrackingModeSubtitle,
                value: profileSettings.privateTrackingMode,
                onChanged: profileSettingsNotifier.setPrivateTrackingMode,
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profileMinimalTrackingModeTitle,
                subtitle: l10n.profileMinimalTrackingModeSubtitle,
                value: profileSettings.minimalTrackingMode,
                onChanged: profileSettingsNotifier.setMinimalTrackingMode,
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profileHideGrowthVisualsTitle,
                subtitle: l10n.profileHideGrowthVisualsSubtitle,
                value: profileSettings.hideGrowthVisuals,
                onChanged: profileSettingsNotifier.setHideGrowthVisuals,
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profileReflectionOnlyModeTitle,
                subtitle: l10n.profileReflectionOnlyModeSubtitle,
                value: profileSettings.reflectionOnlyMode,
                onChanged: profileSettingsNotifier.setReflectionOnlyMode,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.profileNotificationsTitle,
          subtitle: l10n.profileNotificationsSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.profileNotificationsSubtitle),
                subtitle: Text(
                  l10n.profilePlannedRemindersToday(reminderPlan.items.length),
                ),
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profileDhikrReminders,
                value: profileSettings.dhikrReminders,
                onChanged: profileSettingsNotifier.setDhikrReminders,
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profileQuranReminders,
                value: profileSettings.quranReminders,
                onChanged: profileSettingsNotifier.setQuranReminders,
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profileReflectionReminders,
                value: profileSettings.reflectionReminders,
                onChanged: profileSettingsNotifier.setReflectionReminders,
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: l10n.profileFastingReminders,
                value: profileSettings.fastingReminders,
                onChanged: profileSettingsNotifier.setFastingReminders,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.languageOptionsTitle,
          subtitle: l10n.languageOptionsSubtitle,
        ),
        ExpansionTile(
          title: Text(l10n.profileLanguageExpandTitle),
          subtitle: Text(l10n.profileLanguageExpandSubtitle),
          children: [
            PremiumCard(
              child: Column(
                children: [
                  _LanguageRow(l10n.languageEnglish, const Locale('en')),
                  _LanguageRow(l10n.languageArabic, const Locale('ar')),
                  _LanguageRow(l10n.languageGerman, const Locale('de')),
                  _LanguageRow(l10n.languageIndonesian, const Locale('id')),
                  _LanguageRow(l10n.languageMalay, const Locale('ms')),
                  _LanguageRow(l10n.languageBengali, const Locale('bn')),
                  _LanguageRow(l10n.languageUrdu, const Locale('ur')),
                  _LanguageRow(l10n.languageFarsi, const Locale('fa')),
                  _LanguageRow(l10n.languageDari, const Locale('fa', 'AF')),
                  _LanguageRow(l10n.languageTajik, const Locale('tg')),
                  _LanguageRow(l10n.languageTurkish, const Locale('tr')),
                  _LanguageRow(l10n.languageHindi, const Locale('hi')),
                  _LanguageRow(l10n.languagePunjabi, const Locale('pa')),
                  _LanguageRow(l10n.languageHausa, const Locale('ha')),
                  _LanguageRow(l10n.languagePashto, const Locale('ps')),
                  _LanguageRow(l10n.languageKurdish, const Locale('ku')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.profileAboutTitle,
          subtitle: l10n.profileAboutSubtitle,
        ),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: () => context.pushNamed('privacyPolicy'),
                child: Text(l10n.profileTrackingPrivacyTitle),
              ),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('termsUsage'),
                child: Text(l10n.profileAboutTitle),
              ),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('supportInfo'),
                child: Text(l10n.profileNotificationsTitle),
              ),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('attributionsLicenses'),
                child: Text(l10n.settingsAttributionsLicensesTitle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _addressFromSex(UserSex sex, AppLocalizations l10n) {
  return sex == UserSex.brother ? l10n.profileBrother : l10n.profileSister;
}

String _profileAgeRangeLabel(ProfileAgeRange ageRange, AppLocalizations l10n) {
  switch (ageRange) {
    case ProfileAgeRange.child:
      return l10n.kidsUiAgeRangeChild;
    case ProfileAgeRange.teen:
      return l10n.kidsUiAgeRangeTeen;
    case ProfileAgeRange.adult:
      return l10n.kidsUiAgeRangeAdult;
  }
}

String _kidsUiThemeModeLabel(KidsUiThemeMode mode, AppLocalizations l10n) {
  switch (mode) {
    case KidsUiThemeMode.auto:
      return l10n.kidsUiThemeModeAuto;
    case KidsUiThemeMode.on:
      return l10n.kidsUiThemeModeOn;
    case KidsUiThemeMode.off:
      return l10n.kidsUiThemeModeOff;
  }
}

String _madhabLabel(PrayerMadhab value, AppLocalizations l10n) {
  switch (value) {
    case PrayerMadhab.shafii:
      return l10n.settingsMadhabShafii;
    case PrayerMadhab.hanafi:
      return l10n.settingsMadhabHanafi;
    case PrayerMadhab.maliki:
      return l10n.settingsMadhabMaliki;
    case PrayerMadhab.hanbali:
      return l10n.settingsMadhabHanbali;
  }
}

String _calculationMethodLabel(
  PrayerCalculationMethod value,
  AppLocalizations l10n,
) {
  switch (value) {
    case PrayerCalculationMethod.muslimWorldLeague:
      return l10n.settingsCalculationMethodMuslimWorldLeague;
    case PrayerCalculationMethod.egyptian:
      return l10n.settingsCalculationMethodEgyptian;
    case PrayerCalculationMethod.isna:
      return l10n.settingsCalculationMethodIsna;
    case PrayerCalculationMethod.karachi:
      return l10n.settingsCalculationMethodKarachi;
    case PrayerCalculationMethod.ummAlQura:
      return l10n.settingsCalculationMethodUmmAlQura;
  }
}

String _profileSyncModeLabel(ProfileSyncMode mode, AppLocalizations l10n) {
  switch (mode) {
    case ProfileSyncMode.pathOfNurCloud:
      return l10n.settingsSyncModePathOfNurCloud;
    case ProfileSyncMode.iCloud:
      return l10n.settingsSyncModeICloud;
    case ProfileSyncMode.localOnly:
      return l10n.settingsSyncModeLocalOnly;
    case ProfileSyncMode.manualBackupOnly:
      return l10n.settingsSyncModeManualBackupOnly;
  }
}

String _syncStateLabel(SyncStateKind state, AppLocalizations l10n) {
  switch (state) {
    case SyncStateKind.allCaughtUp:
      return l10n.settingsSyncStateAllCaughtUp;
    case SyncStateKind.syncing:
      return l10n.settingsSyncStateSyncing;
    case SyncStateKind.offlinePending:
      return l10n.settingsSyncStateOfflinePending;
    case SyncStateKind.needsAttention:
      return l10n.settingsSyncStateNeedsAttention;
    case SyncStateKind.localOnly:
      return l10n.settingsSyncStateLocalOnly;
    case SyncStateKind.iCloudActive:
      return l10n.settingsSyncStateICloudActive;
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

List<Widget> _buildPrayerNotificationTiles({
  required BuildContext context,
  required PrayerSettingsState settings,
  required AppLocalizations l10n,
  required void Function(String prayerId, PrayerNotificationMode mode)
  onChanged,
}) {
  const prayerOrder = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
  final tiles = <Widget>[];
  for (var index = 0; index < prayerOrder.length; index++) {
    final prayerId = prayerOrder[index];
    tiles.add(
      _PrayerNotificationTile(
        prayerId: prayerId,
        title: _prayerDisplayName(prayerId, l10n),
        active:
            settings.notificationModes[prayerId] ?? PrayerNotificationMode.none,
        l10n: l10n,
        onChanged: (mode) => onChanged(prayerId, mode),
      ),
    );
    if (index != prayerOrder.length - 1) {
      tiles.add(const Divider(height: 1));
    }
  }
  return tiles;
}

class _PrayerTimeAdjustmentsSection extends ConsumerWidget {
  const _PrayerTimeAdjustmentsSection({
    required this.l10n,
    required this.prayerState,
    required this.prayerNotifier,
  });

  final AppLocalizations l10n;
  final PrayerSettingsState prayerState;
  final PrayerSettingsController prayerNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseSchedule = ref.watch(prayerBaseScheduleProvider);
    final effectiveSchedule = ref.watch(prayerScheduleProvider);
    final location = ref.watch(prayerLocationProvider);
    final adjustments = prayerState.preferences.adjustments;
    final manualTimes = prayerState.preferences.manualTimes;
    final mosqueReferenceTimes = prayerState.preferences.mosqueReferenceTimes;
    final mode = prayerState.preferences.prayerTimeMode;
    const prayerIds = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsPrayerTimeModeTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsPrayerTimeModeSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        _PrayerTimeModeCard(
          title: l10n.settingsPrayerTimeModeCalculatedAdjustedTitle,
          description: l10n.settingsPrayerTimeModeCalculatedAdjustedDescription,
          selected: mode == PrayerTimeMode.calculatedAdjusted,
          recommended: true,
          l10n: l10n,
          onTap: () {
            if (mode == PrayerTimeMode.calculatedAdjusted) return;
            prayerNotifier.switchPrayerTimeMode(
              mode: PrayerTimeMode.calculatedAdjusted,
              date: DateTime.now(),
              latitude: location.latitude,
              longitude: location.longitude,
            );
          },
        ),
        const SizedBox(height: 10),
        _PrayerTimeModeCard(
          title: l10n.settingsPrayerTimeModeManualTitle,
          description: l10n.settingsPrayerTimeModeManualDescription,
          selected: mode == PrayerTimeMode.manual,
          l10n: l10n,
          onTap: () {
            if (mode == PrayerTimeMode.manual) return;
            prayerNotifier.switchPrayerTimeMode(
              mode: PrayerTimeMode.manual,
              date: DateTime.now(),
              latitude: location.latitude,
              longitude: location.longitude,
            );
            _showAppearanceSnack(
              context,
              l10n.settingsManualTimesPrefilledFromToday,
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsPrayerTimeModeManualNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        if (mode == PrayerTimeMode.calculatedAdjusted) ...[
          _CalculatedAdjustmentsContent(
            prayerState: prayerState,
            prayerNotifier: prayerNotifier,
            l10n: l10n,
            baseSchedule: baseSchedule,
            effectiveSchedule: effectiveSchedule,
            location: location,
            prayerIds: prayerIds,
            adjustments: adjustments,
            mosqueReferenceTimes: mosqueReferenceTimes,
          ),
        ] else ...[
          _ManualPrayerTimesContent(
            l10n: l10n,
            prayerNotifier: prayerNotifier,
            effectiveSchedule: effectiveSchedule,
            location: location,
            prayerIds: prayerIds,
            manualTimes: manualTimes,
          ),
        ],
        const SizedBox(height: 16),
        _JumuahSettingsSection(
          l10n: l10n,
          prayerState: prayerState,
          prayerNotifier: prayerNotifier,
        ),
      ],
    );
  }
}

class _PrayerTimeModeCard extends StatelessWidget {
  const _PrayerTimeModeCard({
    required this.l10n,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    this.recommended = false,
  });

  final AppLocalizations l10n;
  final String title;
  final String description;
  final bool selected;
  final bool recommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.35)
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (recommended)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.settingsRecommendedBadge,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _CalculatedAdjustmentsContent extends StatelessWidget {
  const _CalculatedAdjustmentsContent({
    required this.l10n,
    required this.prayerState,
    required this.prayerNotifier,
    required this.baseSchedule,
    required this.effectiveSchedule,
    required this.location,
    required this.prayerIds,
    required this.adjustments,
    required this.mosqueReferenceTimes,
  });

  final AppLocalizations l10n;
  final PrayerSettingsState prayerState;
  final PrayerSettingsController prayerNotifier;
  final List<PrayerScheduleItem> baseSchedule;
  final List<PrayerScheduleItem> effectiveSchedule;
  final PrayerLocationState location;
  final List<String> prayerIds;
  final PrayerTimeAdjustments adjustments;
  final PrayerClockTimes mosqueReferenceTimes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsPrayerTimeAdjustmentsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsPrayerTimeAdjustmentsSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsPrayerTimeAdjustmentsExample,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsPrayerTimeAdjustmentsScope,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (adjustments.hasAnyAdjustment) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              l10n.settingsCustomAdjustmentsActive,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
        const SizedBox(height: 14),
        ...prayerIds.map((prayerId) {
          final baseItem = _scheduleItemById(baseSchedule, prayerId);
          final effectiveItem = _scheduleItemById(effectiveSchedule, prayerId);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PrayerAdjustmentRow(
              l10n: l10n,
              prayerName: _prayerDisplayName(prayerId, l10n),
              baseItem: baseItem,
              effectiveItem: effectiveItem,
              adjustmentMinutes: adjustments.offsetForPrayer(prayerId),
              onTap: baseItem == null
                  ? null
                  : () => _showPrayerAdjustmentEditor(
                      context: context,
                      l10n: l10n,
                      prayerId: prayerId,
                      baseSchedule: baseSchedule,
                      currentAdjustments: adjustments,
                      latitude: location.latitude,
                      longitude: location.longitude,
                      onSave: (minutes) {
                        final error = prayerNotifier.updatePrayerAdjustment(
                          prayerId: prayerId,
                          offsetMinutes: minutes,
                          date: DateTime.now(),
                          latitude: location.latitude,
                          longitude: location.longitude,
                        );
                        return error;
                      },
                      preferences: prayerState.preferences,
                    ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: adjustments.hasAnyAdjustment
                ? () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Text(l10n.settingsResetAllAdjustmentsTitle),
                        content: Text(l10n.settingsResetAllAdjustmentsBody),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: Text(l10n.quranCancel),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: Text(l10n.settingsResetAllAdjustments),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      prayerNotifier.resetAllPrayerAdjustments();
                    }
                  }
                : null,
            child: Text(l10n.settingsResetAllAdjustments),
          ),
        ),
        Text(
          l10n.settingsResetAdjustmentsNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 18),
        _MosqueComparisonSection(
          l10n: l10n,
          prayerNotifier: prayerNotifier,
          prayerState: prayerState,
          baseSchedule: baseSchedule,
          effectiveSchedule: effectiveSchedule,
          mosqueReferenceTimes: mosqueReferenceTimes,
          prayerIds: prayerIds,
        ),
      ],
    );
  }
}

class _ManualPrayerTimesContent extends StatelessWidget {
  const _ManualPrayerTimesContent({
    required this.l10n,
    required this.prayerNotifier,
    required this.effectiveSchedule,
    required this.location,
    required this.prayerIds,
    required this.manualTimes,
  });

  final AppLocalizations l10n;
  final PrayerSettingsController prayerNotifier;
  final List<PrayerScheduleItem> effectiveSchedule;
  final PrayerLocationState location;
  final List<String> prayerIds;
  final PrayerClockTimes manualTimes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsManualPrayerTimesTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsManualPrayerTimesSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        ...prayerIds.map((prayerId) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _timeOfDayFromMinutes(
                    manualTimes.minuteForPrayer(prayerId) ??
                        _minutesFromDateTime(
                          _scheduleItemById(
                            effectiveSchedule,
                            prayerId,
                          )!.offerDateTime,
                        ),
                  ),
                );
                if (picked == null) return;
                final error = prayerNotifier.updateManualPrayerTime(
                  prayerId: prayerId,
                  minutes: picked.hour * 60 + picked.minute,
                  date: DateTime.now(),
                  latitude: location.latitude,
                  longitude: location.longitude,
                );
                if (error != null && context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _prayerDisplayName(prayerId, l10n),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Text(
                      _formatMinutesLabel(
                        context,
                        manualTimes.minuteForPrayer(prayerId),
                        l10n,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: () {
                  prayerNotifier.initializeManualTimesFromCalculated(
                    date: DateTime.now(),
                    latitude: location.latitude,
                    longitude: location.longitude,
                  );
                },
                child: Text(l10n.settingsUseTodaysCalculatedTimes),
              ),
              TextButton(
                onPressed: manualTimes.isComplete
                    ? () => prayerNotifier.resetManualPrayerTimes()
                    : null,
                child: Text(l10n.settingsResetManualTimes),
              ),
              TextButton(
                onPressed: () {
                  prayerNotifier.switchPrayerTimeMode(
                    mode: PrayerTimeMode.calculatedAdjusted,
                    date: DateTime.now(),
                    latitude: location.latitude,
                    longitude: location.longitude,
                  );
                },
                child: Text(l10n.settingsReturnToRecommendedMode),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MosqueComparisonSection extends StatelessWidget {
  const _MosqueComparisonSection({
    required this.l10n,
    required this.prayerNotifier,
    required this.prayerState,
    required this.baseSchedule,
    required this.effectiveSchedule,
    required this.mosqueReferenceTimes,
    required this.prayerIds,
  });

  final AppLocalizations l10n;
  final PrayerSettingsController prayerNotifier;
  final PrayerSettingsState prayerState;
  final List<PrayerScheduleItem> baseSchedule;
  final List<PrayerScheduleItem> effectiveSchedule;
  final PrayerClockTimes mosqueReferenceTimes;
  final List<String> prayerIds;

  @override
  Widget build(BuildContext context) {
    final suggestedAdjustments = _suggestedAdjustmentsFromMosque(
      baseSchedule: baseSchedule,
      mosqueReferenceTimes: mosqueReferenceTimes,
      currentAdjustments: prayerState.preferences.adjustments,
    );
    final hasSuggestionChange =
        const ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'].any(
          (prayerId) =>
              suggestedAdjustments.offsetForPrayer(prayerId) !=
              prayerState.preferences.adjustments.offsetForPrayer(prayerId),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsMosqueTimeComparisonTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsMosqueTimeComparisonSubtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        ...prayerIds.map((prayerId) {
          final baseItem = _scheduleItemById(baseSchedule, prayerId);
          final effectiveItem = _scheduleItemById(effectiveSchedule, prayerId);
          final mosqueMinutes = mosqueReferenceTimes.minuteForPrayer(prayerId);
          final difference = mosqueMinutes == null || effectiveItem == null
              ? null
              : _minutesFromDateTime(effectiveItem.offerDateTime) -
                    mosqueMinutes;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _timeOfDayFromMinutes(
                    mosqueMinutes ??
                        _minutesFromDateTime(baseItem!.offerDateTime),
                  ),
                );
                if (picked == null) return;
                prayerNotifier.updateMosqueReferenceTime(
                  prayerId: prayerId,
                  minutes: picked.hour * 60 + picked.minute,
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _prayerDisplayName(prayerId, l10n),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Text(
                          l10n.settingsMosqueTimeLabel(
                            _formatMinutesLabel(context, mosqueMinutes, l10n),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.settingsCalculatedTimeLabel(
                        baseItem?.offerTime ?? l10n.settingsUnavailable,
                      ),
                    ),
                    Text(
                      l10n.settingsAdjustmentValueLabel(
                        _formatAdjustmentLabel(
                          prayerState.preferences.adjustments.offsetForPrayer(
                            prayerId,
                          ),
                          l10n,
                          context,
                        ),
                      ),
                    ),
                    Text(
                      l10n.settingsEffectiveTimeLabel(
                        effectiveItem?.offerTime ?? l10n.settingsUnavailable,
                      ),
                    ),
                    Text(
                      l10n.settingsDifferenceValueLabel(
                        difference == null
                            ? l10n.settingsNotSet
                            : _formatDifferenceLabel(difference, l10n, context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: hasSuggestionChange
                ? () => _showSuggestedAdjustmentsSheet(
                    context: context,
                    l10n: l10n,
                    currentAdjustments: prayerState.preferences.adjustments,
                    suggestedAdjustments: suggestedAdjustments,
                    onApply: () {
                      prayerNotifier.applyPrayerAdjustments(
                        suggestedAdjustments,
                      );
                    },
                  )
                : null,
            child: Text(l10n.settingsApplySuggestedAdjustments),
          ),
        ),
      ],
    );
  }
}

class _JumuahSettingsSection extends StatelessWidget {
  const _JumuahSettingsSection({
    required this.l10n,
    required this.prayerState,
    required this.prayerNotifier,
  });

  final AppLocalizations l10n;
  final PrayerSettingsState prayerState;
  final PrayerSettingsController prayerNotifier;

  @override
  Widget build(BuildContext context) {
    final preferences = prayerState.preferences;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsJumuahSettingsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsJumuahSettingsSubtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsEnableJumuahOverrideTitle),
          subtitle: Text(l10n.settingsEnableJumuahOverrideSubtitle),
          value: preferences.jumuahOverrideEnabled,
          onChanged: (value) {
            prayerNotifier.updateJumuahSettings(enabled: value);
          },
        ),
        if (preferences.jumuahOverrideEnabled) ...[
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsJumuahTimeTitle),
            subtitle: Text(l10n.settingsJumuahTimeSubtitle),
            trailing: Text(
              _formatMinutesLabel(context, preferences.jumuahTimeMinutes, l10n),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _timeOfDayFromMinutes(
                  preferences.jumuahTimeMinutes ?? (13 * 60),
                ),
              );
              if (picked == null) return;
              prayerNotifier.updateJumuahSettings(
                jumuahTimeMinutes: picked.hour * 60 + picked.minute,
              );
            },
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FridayReminderMode.values
                .map(
                  (mode) => ChoiceChip(
                    label: Text(_fridayReminderModeLabel(mode, l10n)),
                    selected: preferences.fridayReminderMode == mode,
                    onSelected: (_) {
                      prayerNotifier.updateJumuahSettings(
                        fridayReminderMode: mode,
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _PrayerAdjustmentRow extends StatelessWidget {
  const _PrayerAdjustmentRow({
    required this.l10n,
    required this.prayerName,
    required this.baseItem,
    required this.effectiveItem,
    required this.adjustmentMinutes,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final String prayerName;
  final PrayerScheduleItem? baseItem;
  final PrayerScheduleItem? effectiveItem;
  final int adjustmentMinutes;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final adjustmentLabel = adjustmentMinutes == 0
        ? l10n.settingsNoChange
        : _formatAdjustmentLabel(adjustmentMinutes, l10n, context);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    prayerName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (adjustmentMinutes != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.settingsModified,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.settingsBaseTimeLabel(
                baseItem?.offerTime ?? l10n.settingsUnavailable,
              ),
            ),
            Text(l10n.settingsAdjustmentValueLabel(adjustmentLabel)),
            Text(
              l10n.settingsFinalTimeLabel(
                effectiveItem?.offerTime ??
                    baseItem?.offerTime ??
                    l10n.settingsUnavailable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

PrayerScheduleItem? _scheduleItemById(
  List<PrayerScheduleItem> schedule,
  String prayerId,
) {
  for (final item in schedule) {
    if (item.id == prayerId) {
      return item;
    }
  }
  return null;
}

PrayerTimeAdjustments _suggestedAdjustmentsFromMosque({
  required List<PrayerScheduleItem> baseSchedule,
  required PrayerClockTimes mosqueReferenceTimes,
  required PrayerTimeAdjustments currentAdjustments,
}) {
  var next = currentAdjustments;
  for (final prayerId in const ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha']) {
    final baseItem = _scheduleItemById(baseSchedule, prayerId);
    final mosqueMinutes = mosqueReferenceTimes.minuteForPrayer(prayerId);
    if (baseItem == null || mosqueMinutes == null) {
      continue;
    }
    final calculatedMinutes = _minutesFromDateTime(baseItem.offerDateTime);
    next = _setAdjustmentForPrayer(
      next,
      prayerId,
      mosqueMinutes - calculatedMinutes,
    );
  }
  return next;
}

Future<void> _showSuggestedAdjustmentsSheet({
  required BuildContext context,
  required AppLocalizations l10n,
  required PrayerTimeAdjustments currentAdjustments,
  required PrayerTimeAdjustments suggestedAdjustments,
  required VoidCallback onApply,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PremiumCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsApplySuggestedAdjustmentsTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsApplySuggestedAdjustmentsSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                for (final prayerId in const [
                  'fajr',
                  'dhuhr',
                  'asr',
                  'maghrib',
                  'isha',
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      l10n.settingsSuggestedAdjustmentChangeRow(
                        _prayerDisplayName(prayerId, l10n),
                        _formatAdjustmentLabel(
                          currentAdjustments.offsetForPrayer(prayerId),
                          l10n,
                          context,
                        ),
                        _formatAdjustmentLabel(
                          suggestedAdjustments.offsetForPrayer(prayerId),
                          l10n,
                          context,
                        ),
                        _formatAdjustmentLabel(
                          suggestedAdjustments.offsetForPrayer(prayerId),
                          l10n,
                          context,
                        ),
                        _prayerDisplayName(prayerId, l10n),
                        _formatAdjustmentLabel(
                          suggestedAdjustments.offsetForPrayer(prayerId),
                          l10n,
                          context,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: Text(l10n.quranCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          onApply();
                          Navigator.of(sheetContext).pop();
                        },
                        child: Text(l10n.wallpaperApply),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> _showPrayerAdjustmentEditor({
  required BuildContext context,
  required AppLocalizations l10n,
  required String prayerId,
  required List<PrayerScheduleItem> baseSchedule,
  required PrayerTimeAdjustments currentAdjustments,
  required double latitude,
  required double longitude,
  required String? Function(int minutes) onSave,
  required PrayerPreferences preferences,
}) async {
  final baseItem = _scheduleItemById(baseSchedule, prayerId);
  if (baseItem == null) return;
  var draftMinutes = currentAdjustments.offsetForPrayer(prayerId);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final draftAdjustments = _setAdjustmentForPrayer(
            currentAdjustments,
            prayerId,
            draftMinutes,
          );
          final validation = validatePrayerAdjustmentsForDate(
            date: DateTime.now(),
            latitude: latitude,
            longitude: longitude,
            settings: preferences.copyWith(adjustments: draftAdjustments),
          );
          final previewItem = _scheduleItemById(
            buildPrayerScheduleForDate(
              date: DateTime.now(),
              latitude: latitude,
              longitude: longitude,
              settings: preferences.copyWith(adjustments: draftAdjustments),
            ),
            prayerId,
          );

          void updateDraft(int nextValue) {
            setState(() {
              draftMinutes = nextValue.clamp(-30, 30);
            });
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: PremiumCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _prayerDisplayName(prayerId, l10n),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.settingsPrayerAdjustmentEditorBaseCalculatedTime(
                        baseItem.offerTime,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsPrayerAdjustmentEditorCurrentAdjustment(
                        _formatAdjustmentLabel(draftMinutes, l10n, context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsPrayerAdjustmentEditorFinalEffectiveTime(
                        previewItem?.offerTime ?? baseItem.offerTime,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.settingsPrayerAdjustmentEditorFutureUseNote,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => updateDraft(draftMinutes - 1),
                          icon: const Icon(Icons.remove_circle_outline_rounded),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _formatAdjustmentLabel(
                                draftMinutes,
                                l10n,
                                context,
                              ),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => updateDraft(draftMinutes + 1),
                          icon: const Icon(Icons.add_circle_outline_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [-10, -5, 0, 5, 10]
                          .map(
                            (value) => ActionChip(
                              label: Text(_formatSignedCount(context, value)),
                              onPressed: () => updateDraft(value),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => updateDraft(0),
                      child: Text(l10n.settingsResetThisPrayer),
                    ),
                    if (validation != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        validation,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            child: Text(l10n.quranCancel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: validation == null
                                ? () {
                                    final error = onSave(draftMinutes);
                                    if (error != null) {
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          SnackBar(content: Text(error)),
                                        );
                                      return;
                                    }
                                    Navigator.of(sheetContext).pop();
                                  }
                                : null,
                            child: Text(l10n.quranSave),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

PrayerTimeAdjustments _setAdjustmentForPrayer(
  PrayerTimeAdjustments adjustments,
  String prayerId,
  int minutes,
) {
  switch (prayerId) {
    case 'fajr':
      return adjustments.copyWith(fajrOffsetMinutes: minutes);
    case 'dhuhr':
      return adjustments.copyWith(dhuhrOffsetMinutes: minutes);
    case 'asr':
      return adjustments.copyWith(asrOffsetMinutes: minutes);
    case 'maghrib':
      return adjustments.copyWith(maghribOffsetMinutes: minutes);
    case 'isha':
      return adjustments.copyWith(ishaOffsetMinutes: minutes);
    default:
      return adjustments;
  }
}

String _formatAdjustmentLabel(
  int minutes,
  AppLocalizations l10n,
  BuildContext context,
) {
  if (minutes == 0) return l10n.settingsNoChange;
  return l10n.settingsMinutesValue(_formatSignedCount(context, minutes));
}

String _formatDifferenceLabel(
  int minutes,
  AppLocalizations l10n,
  BuildContext context,
) {
  return l10n.settingsMinutesValue(_formatSignedCount(context, minutes));
}

int _minutesFromDateTime(DateTime value) => value.hour * 60 + value.minute;

TimeOfDay _timeOfDayFromMinutes(int minutes) {
  final normalized = minutes.clamp(0, 1439);
  return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
}

String _formatMinutesLabel(
  BuildContext context,
  int? minutes,
  AppLocalizations l10n,
) {
  if (minutes == null) return l10n.settingsNotSet;
  return MaterialLocalizations.of(
    context,
  ).formatTimeOfDay(_timeOfDayFromMinutes(minutes));
}

String _formatCount(BuildContext context, num value) {
  return NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

String _formatSignedCount(BuildContext context, int value) {
  final formatted = _formatCount(context, value.abs());
  if (value == 0) return formatted;
  return value > 0 ? '+$formatted' : '-$formatted';
}

String _fridayReminderModeLabel(
  FridayReminderMode mode,
  AppLocalizations l10n,
) {
  switch (mode) {
    case FridayReminderMode.normalDhuhr:
      return l10n.settingsFridayReminderModeNormalDhuhr;
    case FridayReminderMode.customJumuah:
      return l10n.settingsFridayReminderModeCustomJumuah;
  }
}

String _prayerDisplayName(String prayerId, AppLocalizations l10n) {
  switch (prayerId) {
    case 'fajr':
      return l10n.settingsPrayerNameFajr;
    case 'dhuhr':
      return l10n.settingsPrayerNameDhuhr;
    case 'asr':
      return l10n.settingsPrayerNameAsr;
    case 'maghrib':
      return l10n.settingsPrayerNameMaghrib;
    case 'isha':
      return l10n.settingsPrayerNameIsha;
    default:
      return prayerId;
  }
}

String _notificationModeLabel(
  PrayerNotificationMode mode,
  AppLocalizations l10n,
) {
  switch (mode) {
    case PrayerNotificationMode.none:
      return l10n.salahNotificationOff;
    case PrayerNotificationMode.notificationOnly:
      return l10n.settingsNotificationModeNotification;
    case PrayerNotificationMode.adhanWithSound:
      return l10n.settingsNotificationModeAdhan;
    case PrayerNotificationMode.reminderBeforeQaza:
      return l10n.settingsNotificationModeBeforeQaza;
  }
}

class _PrayerNotificationTile extends StatelessWidget {
  const _PrayerNotificationTile({
    required this.l10n,
    required this.prayerId,
    required this.title,
    required this.active,
    required this.onChanged,
  });

  final AppLocalizations l10n;
  final String prayerId;
  final String title;
  final PrayerNotificationMode active;
  final ValueChanged<PrayerNotificationMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                _notificationModeLabel(active, l10n),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PrayerNotificationMode.values
                .map(
                  (mode) => ChoiceChip(
                    label: Text(_notificationModeLabel(mode, l10n)),
                    selected: active == mode,
                    onSelected: (_) => onChanged(mode),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

String _themeModeDescription(AppThemeMode mode, AppLocalizations l10n) {
  switch (mode) {
    case AppThemeMode.defaultMode:
      return l10n.settingsThemeModeDefaultDescription;
    case AppThemeMode.calmBeautiful:
      return l10n.settingsThemeModeDefaultDescription;
    case AppThemeMode.easyRead:
      return l10n.settingsThemeModeEasyReadDescription;
    case AppThemeMode.dark:
      return l10n.settingsThemeModeDarkDescription;
  }
}

void _showAppearanceSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class _ThemeChoiceChip extends StatelessWidget {
  const _ThemeChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  const _SettingsToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: subtitle == null ? null : Text(subtitle!),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _PreferenceDropdown<T> extends StatelessWidget {
  const _PreferenceDropdown({
    required this.label,
    required this.value,
    required this.entries,
    required this.onChanged,
    this.entryBuilder,
  });

  final String label;
  final T value;
  final Map<T, String> entries;
  final ValueChanged<T?> onChanged;
  final String Function(T value)? entryBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Align(
            alignment: Alignment.centerRight,
            child: DropdownButton<T>(
              value: value,
              alignment: AlignmentDirectional.centerEnd,
              style: Theme.of(context).textTheme.bodyLarge,
              underline: const SizedBox.shrink(),
              onChanged: onChanged,
              items: entries.entries
                  .map(
                    (entry) => DropdownMenuItem<T>(
                      value: entry.key,
                      child: Text(
                        entryBuilder?.call(entry.key) ?? entry.value,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends ConsumerWidget {
  const _LanguageRow(this.label, this.locale);

  final String label;
  final Locale locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = Localizations.localeOf(context);
    final isCurrent =
        current.languageCode == locale.languageCode &&
        (locale.countryCode == null ||
            current.countryCode == locale.countryCode);

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      onTap: () => ref.read(appLocaleProvider.notifier).setLocale(locale),
      title: Text(label),
      subtitle: Text(locale.toLanguageTag()),
      trailing: Icon(
        isCurrent ? Icons.radio_button_checked : Icons.radio_button_off,
      ),
    );
  }
}
