import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/reminders/adhan_audio_service.dart';
import '../../../core/reminders/adhan_options.dart';
import '../../../core/reminders/reminder_scheduler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/section_title.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../../profile/application/profile_settings_provider.dart';
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
    final profileSettings = ref.watch(profileSettingsProvider);
    final profileSettingsNotifier = ref.read(profileSettingsProvider.notifier);
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
            ? 'Current location'
            : prayerState.preferences.location);

    return AppPageScaffold(
      headerIcon: Icons.settings_outlined,
      title: l10n.profilePrayerSettingsTitle,
      subtitle: l10n.profileSummarySubtitle,
      children: [
        SectionTitle(
          title: 'Accounts, Profiles & Sync',
          subtitle:
              'Manage shared devices, protected profiles, sync mode, and backups without disturbing your current journey.',
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Current Profile'),
                subtitle: Text(
                  accountsSync.activeProfile == null
                      ? 'No profile selected'
                      : '${accountsSync.activeProfile!.displayName} • ${accountsSync.activeProfile!.syncMode.name}',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/accounts-sync'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sync Status'),
                subtitle: Text(
                  '${accountsSync.syncStatus.pendingChangesCount} pending • ${accountsSync.syncStatus.syncState.name}',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/accounts-sync/sync-details'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Backup & Restore'),
                subtitle: Text(
                  accountsSync.backupRecommended
                      ? 'Backup recommended'
                      : accountsSync.backupRecord.lastExportAtIso == null
                      ? 'No manual backup yet'
                      : 'Last export recorded',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/accounts-sync/backup'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: 'Adhan',
          subtitle:
              'Choose a dedicated Fajr Adhan, preview the bundled clips, and keep prayer audio offline.',
        ),
        PremiumCard(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable Adhan audio'),
                subtitle: const Text(
                  'Prayer reminders can play the selected Adhan when this is on.',
                ),
                value: prayerState.adhanSettings.enabled,
                onChanged: prayerNotifier.setAdhanEnabled,
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Regular Adhan'),
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
                title: const Text('Fajr Adhan'),
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
                      'Preview & volume',
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
                          label: const Text('Test Regular Adhan'),
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
                          label: const Text('Test Fajr Adhan'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Use App Volume'),
                      subtitle: const Text(
                        'Keep preview playback aligned with the app volume level.',
                      ),
                      value: prayerState.adhanSettings.useAppVolume,
                      onChanged: prayerNotifier.setUseAppAdhanVolume,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Adhan preview volume',
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
                          ? 'Using app volume'
                          : '${(prayerState.adhanSettings.volume * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: prayerNotifier.restoreDefaultAdhanSettings,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Restore Default Adhan Settings'),
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
                  PrayerMadhab.shafii: 'Shafi\'i',
                  PrayerMadhab.hanafi: 'Hanafi',
                  PrayerMadhab.maliki: 'Maliki',
                  PrayerMadhab.hanbali: 'Hanbali',
                },
                onChanged: (value) {
                  if (value != null) prayerNotifier.updateMadhab(value);
                },
              ),
              const Divider(height: 1),
              _PreferenceDropdown<PrayerCalculationMethod>(
                label: l10n.profileCalculationMethodLabel,
                value: prayerState.preferences.calculationMethod,
                entries: const {
                  PrayerCalculationMethod.muslimWorldLeague:
                      'Muslim World League',
                  PrayerCalculationMethod.egyptian: 'Egyptian',
                  PrayerCalculationMethod.isna: 'ISNA',
                  PrayerCalculationMethod.karachi: 'Karachi',
                  PrayerCalculationMethod.ummAlQura: 'Umm Al-Qura',
                },
                onChanged: (value) {
                  if (value != null) prayerNotifier.updateMethod(value);
                },
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _PrayerTimeAdjustmentsSection(
                  prayerState: prayerState,
                  prayerNotifier: prayerNotifier,
                ),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Stable Dynamic Island'),
                subtitle: const Text(
                  'Keep the prayer Dynamic Island in a calmer, fixed layout.',
                ),
                value: prayerState.preferences.useStableDynamicIsland,
                onChanged: prayerNotifier.setStableDynamicIsland,
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Stable Lock Screen Widget'),
                subtitle: const Text(
                  'Keep the prayer lock screen Live Activity in a calmer, fixed layout.',
                ),
                value: prayerState.preferences.useStableLockScreenWidget,
                onChanged: prayerNotifier.setStableLockScreenWidget,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: 'Appearance',
          subtitle:
              'Choose the visual style that feels most comfortable for your journey.',
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Mode',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ThemeChoiceChip(
                    label: 'Default',
                    selected:
                        profileSettings.appThemeMode ==
                        AppThemeMode.defaultMode,
                    onSelected: () {
                      profileSettingsNotifier.setAppThemeMode(
                        AppThemeMode.defaultMode,
                      );
                      _showAppearanceSnack(context, 'Appearance updated');
                    },
                  ),
                  _ThemeChoiceChip(
                    label: 'Easy Read',
                    selected:
                        profileSettings.appThemeMode == AppThemeMode.easyRead,
                    onSelected: () {
                      profileSettingsNotifier.setAppThemeMode(
                        AppThemeMode.easyRead,
                      );
                      _showAppearanceSnack(
                        context,
                        'Theme changed successfully',
                      );
                    },
                  ),
                  _ThemeChoiceChip(
                    label: 'Dark',
                    selected: profileSettings.appThemeMode == AppThemeMode.dark,
                    onSelected: () {
                      profileSettingsNotifier.setAppThemeMode(
                        AppThemeMode.dark,
                      );
                      _showAppearanceSnack(
                        context,
                        'Theme changed successfully',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _themeModeDescription(profileSettings.appThemeMode),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Visual Preferences',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              _SettingsToggleRow(
                label: 'Disable Glass Transparency',
                subtitle: 'Use solid surfaces instead of translucent glass.',
                value: profileSettings.disableGlassTransparency,
                onChanged: (value) {
                  profileSettingsNotifier.setDisableGlassTransparency(value);
                  _showAppearanceSnack(context, 'Visual preference updated');
                },
              ),
              const Divider(height: 1),
              _SettingsToggleRow(
                label: 'Disable Background',
                subtitle:
                    'Hide decorative background imagery for a cleaner view.',
                value: profileSettings.disableBackground,
                onChanged: (value) {
                  profileSettingsNotifier.setDisableBackground(value);
                  _showAppearanceSnack(context, 'Visual preference updated');
                },
              ),
              const SizedBox(height: 10),
              Text(
                'These settings change the look of the app without changing your content or progress.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (profileSettings.appThemeMode == AppThemeMode.defaultMode &&
                  !profileSettings.disableGlassTransparency &&
                  !profileSettings.disableBackground) ...[
                const SizedBox(height: 6),
                Text(
                  'Default appearance active',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  profileSettingsNotifier.resetAppearance();
                  _showAppearanceSnack(context, 'Appearance reset to default');
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset Appearance'),
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
          title: 'Prayer Notifications',
          subtitle:
              'Keep all prayer reminder behavior in one place, with one mode for each salah.',
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
                subtitle:
                    'Turn all prayer reminders on or off without changing your saved per-prayer modes.',
                value: profileSettings.prayerReminders,
                onChanged: profileSettingsNotifier.setPrayerReminders,
              ),
              const Divider(height: 1),
              ..._buildPrayerNotificationTiles(
                context: context,
                settings: prayerState,
                onChanged: prayerNotifier.updateNotificationMode,
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
                child: const Text('Attributions & Licenses'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

List<Widget> _buildPrayerNotificationTiles({
  required BuildContext context,
  required PrayerSettingsState settings,
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
        title: _prayerDisplayName(prayerId),
        active:
            settings.notificationModes[prayerId] ?? PrayerNotificationMode.none,
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
    required this.prayerState,
    required this.prayerNotifier,
  });

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
          'Prayer Time Mode',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Choose how Path of Nūr handles your prayer schedule. Most users should keep calculated prayer times and apply small adjustments if needed.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        _PrayerTimeModeCard(
          title: 'Calculated Times + Adjustments',
          description:
              'Best for most users. Path of Nūr calculates prayer times for your location and method each day, then applies your saved per-prayer adjustments automatically.',
          selected: mode == PrayerTimeMode.calculatedAdjusted,
          recommended: true,
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
          title: 'Fully Manual Prayer Times',
          description:
              'Use exact prayer times that you enter yourself. This overrides normal daily prayer calculation for tracked salah times and should only be used if you intentionally want a fixed manual schedule.',
          selected: mode == PrayerTimeMode.manual,
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
              'Manual times were prefilled from today’s active prayer schedule.',
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Manual mode is an advanced option. If your local prayer times change seasonally, you may need to update them yourself.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        if (mode == PrayerTimeMode.calculatedAdjusted) ...[
          _CalculatedAdjustmentsContent(
            prayerState: prayerState,
            prayerNotifier: prayerNotifier,
            baseSchedule: baseSchedule,
            effectiveSchedule: effectiveSchedule,
            location: location,
            prayerIds: prayerIds,
            adjustments: adjustments,
            mosqueReferenceTimes: mosqueReferenceTimes,
          ),
        ] else ...[
          _ManualPrayerTimesContent(
            prayerNotifier: prayerNotifier,
            effectiveSchedule: effectiveSchedule,
            location: location,
            prayerIds: prayerIds,
            manualTimes: manualTimes,
          ),
        ],
        const SizedBox(height: 16),
        _JumuahSettingsSection(
          prayerState: prayerState,
          prayerNotifier: prayerNotifier,
        ),
      ],
    );
  }
}

class _PrayerTimeModeCard extends StatelessWidget {
  const _PrayerTimeModeCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    this.recommended = false,
  });

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
                      'Recommended',
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
    required this.prayerState,
    required this.prayerNotifier,
    required this.baseSchedule,
    required this.effectiveSchedule,
    required this.location,
    required this.prayerIds,
    required this.adjustments,
    required this.mosqueReferenceTimes,
  });

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
          'Prayer Time Adjustments',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Fine-tune your calculated salah times by a few minutes. Path of Nūr will continue calculating prayer times normally for your location and method, then apply your saved adjustments automatically.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'If Fajr is calculated as 5:00 AM and you change it to 4:55 AM, the app saves a -5 minute adjustment for Fajr. Future Fajr times will also use that same saved adjustment.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Your adjustments are used across the app for prayer display, reminders, countdowns, and daily prayer tracking.',
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
              'Custom adjustments active',
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
              prayerName: _prayerDisplayName(prayerId),
              baseItem: baseItem,
              effectiveItem: effectiveItem,
              adjustmentMinutes: adjustments.offsetForPrayer(prayerId),
              onTap: baseItem == null
                  ? null
                  : () => _showPrayerAdjustmentEditor(
                      context: context,
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
                        title: const Text('Reset all adjustments?'),
                        content: const Text(
                          'This will return Fajr, Dhuhr, Asr, Maghrib, and Isha to their calculated times.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      prayerNotifier.resetAllPrayerAdjustments();
                    }
                  }
                : null,
            child: const Text('Reset All Adjustments'),
          ),
        ),
        Text(
          'Resetting removes all saved offsets and returns each salah to its calculated time.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 18),
        _MosqueComparisonSection(
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
    required this.prayerNotifier,
    required this.effectiveSchedule,
    required this.location,
    required this.prayerIds,
    required this.manualTimes,
  });

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
          'Manual Prayer Times',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'These manual times will be used across the app for reminders, countdowns, and prayer tracking while manual mode is active.',
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
                        _prayerDisplayName(prayerId),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Text(
                      _formatMinutesLabel(
                        context,
                        manualTimes.minuteForPrayer(prayerId),
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
                child: const Text('Use Today’s Calculated Times'),
              ),
              TextButton(
                onPressed: manualTimes.isComplete
                    ? () => prayerNotifier.resetManualPrayerTimes()
                    : null,
                child: const Text('Reset Manual Times'),
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
                child: const Text('Return to Recommended Mode'),
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
    required this.prayerNotifier,
    required this.prayerState,
    required this.baseSchedule,
    required this.effectiveSchedule,
    required this.mosqueReferenceTimes,
    required this.prayerIds,
  });

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
          'Mosque Time Comparison',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Compare your local masjid timetable with Path of Nūr’s calculated and adjusted prayer times. This stays local and helps you review how close your current adjustments are.',
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
                            _prayerDisplayName(prayerId),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Text(
                          'Mosque: ${_formatMinutesLabel(context, mosqueMinutes)}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Calculated: ${baseItem?.offerTime ?? 'Unavailable'}'),
                    Text(
                      'Adjustment: ${_formatAdjustmentLabel(prayerState.preferences.adjustments.offsetForPrayer(prayerId))}',
                    ),
                    Text(
                      'Effective: ${effectiveItem?.offerTime ?? 'Unavailable'}',
                    ),
                    Text(
                      'Difference: ${difference == null ? 'Not set' : _formatDifferenceLabel(difference)}',
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
                    currentAdjustments: prayerState.preferences.adjustments,
                    suggestedAdjustments: suggestedAdjustments,
                    onApply: () {
                      prayerNotifier.applyPrayerAdjustments(
                        suggestedAdjustments,
                      );
                    },
                  )
                : null,
            child: const Text('Apply Suggested Adjustments'),
          ),
        ),
      ],
    );
  }
}

class _JumuahSettingsSection extends StatelessWidget {
  const _JumuahSettingsSection({
    required this.prayerState,
    required this.prayerNotifier,
  });

  final PrayerSettingsState prayerState;
  final PrayerSettingsController prayerNotifier;

  @override
  Widget build(BuildContext context) {
    final preferences = prayerState.preferences;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jumu‘ah Settings',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Use a Friday-specific reminder time if your Jumu‘ah timing differs from standard Dhuhr.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable Jumu‘ah override'),
          subtitle: const Text(
            'Use a dedicated Friday midday reminder without changing the tracked prayer schedule.',
          ),
          value: preferences.jumuahOverrideEnabled,
          onChanged: (value) {
            prayerNotifier.updateJumuahSettings(enabled: value);
          },
        ),
        if (preferences.jumuahOverrideEnabled) ...[
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Jumu‘ah time'),
            subtitle: const Text(
              'Used for Friday reminder behavior when selected.',
            ),
            trailing: Text(
              _formatMinutesLabel(context, preferences.jumuahTimeMinutes),
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
                    label: Text(_fridayReminderModeLabel(mode)),
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
    required this.prayerName,
    required this.baseItem,
    required this.effectiveItem,
    required this.adjustmentMinutes,
    required this.onTap,
  });

  final String prayerName;
  final PrayerScheduleItem? baseItem;
  final PrayerScheduleItem? effectiveItem;
  final int adjustmentMinutes;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final adjustmentLabel = adjustmentMinutes == 0
        ? 'No change'
        : '${adjustmentMinutes > 0 ? '+' : ''}$adjustmentMinutes min';
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
                      'Modified',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Base: ${baseItem?.offerTime ?? 'Unavailable'}'),
            Text('Adjustment: $adjustmentLabel'),
            Text(
              'Final: ${effectiveItem?.offerTime ?? baseItem?.offerTime ?? 'Unavailable'}',
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
                  'Apply Suggested Adjustments',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Review the proposed offsets before replacing your current calculated-time adjustments.',
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
                      '${_prayerDisplayName(prayerId)}: ${_formatAdjustmentLabel(currentAdjustments.offsetForPrayer(prayerId))} → ${_formatAdjustmentLabel(suggestedAdjustments.offsetForPrayer(prayerId))}',
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          onApply();
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('Apply'),
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
                      _prayerDisplayName(prayerId),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Base calculated time: ${baseItem.offerTime}'),
                    const SizedBox(height: 4),
                    Text(
                      'Current adjustment: ${draftMinutes == 0 ? 'No change' : '${draftMinutes > 0 ? '+' : ''}$draftMinutes min'}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Final effective time: ${previewItem?.offerTime ?? baseItem.offerTime}',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This adjustment will be applied to future calculated prayer times for this salah as well.',
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
                              '${draftMinutes > 0 ? '+' : ''}$draftMinutes min',
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
                              label: Text(
                                value == 0
                                    ? '0'
                                    : '${value > 0 ? '+' : ''}$value',
                              ),
                              onPressed: () => updateDraft(value),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => updateDraft(0),
                      child: const Text('Reset this prayer'),
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
                            child: const Text('Cancel'),
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
                            child: const Text('Save'),
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

String _formatAdjustmentLabel(int minutes) {
  if (minutes == 0) return 'No change';
  return '${minutes > 0 ? '+' : ''}$minutes min';
}

String _formatDifferenceLabel(int minutes) {
  return '${minutes > 0 ? '+' : ''}$minutes min';
}

int _minutesFromDateTime(DateTime value) => value.hour * 60 + value.minute;

TimeOfDay _timeOfDayFromMinutes(int minutes) {
  final normalized = minutes.clamp(0, 1439);
  return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
}

String _formatMinutesLabel(BuildContext context, int? minutes) {
  if (minutes == null) return 'Not set';
  return MaterialLocalizations.of(
    context,
  ).formatTimeOfDay(_timeOfDayFromMinutes(minutes));
}

String _fridayReminderModeLabel(FridayReminderMode mode) {
  switch (mode) {
    case FridayReminderMode.normalDhuhr:
      return 'Normal Dhuhr timing';
    case FridayReminderMode.customJumuah:
      return 'Custom Jumu‘ah time';
  }
}

String _prayerDisplayName(String prayerId) {
  switch (prayerId) {
    case 'fajr':
      return 'Fajr';
    case 'dhuhr':
      return 'Dhuhr';
    case 'asr':
      return 'Asr';
    case 'maghrib':
      return 'Maghrib';
    case 'isha':
      return 'Isha';
    default:
      return prayerId;
  }
}

String _notificationModeLabel(PrayerNotificationMode mode) {
  switch (mode) {
    case PrayerNotificationMode.none:
      return 'Off';
    case PrayerNotificationMode.notificationOnly:
      return 'Notification';
    case PrayerNotificationMode.adhanWithSound:
      return 'Adhan';
    case PrayerNotificationMode.reminderBeforeQaza:
      return 'Before qaza';
  }
}

class _PrayerNotificationTile extends StatelessWidget {
  const _PrayerNotificationTile({
    required this.prayerId,
    required this.title,
    required this.active,
    required this.onChanged,
  });

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
                _notificationModeLabel(active),
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
                    label: Text(_notificationModeLabel(mode)),
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

String _themeModeDescription(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.defaultMode:
      return 'The default Path of Nūr look with a soft, elegant feel and gentle depth.';
    case AppThemeMode.calmBeautiful:
      return 'The default Path of Nūr look with a soft, elegant feel and gentle depth.';
    case AppThemeMode.easyRead:
      return 'Cleaner surfaces and stronger contrast for focused reading. Recommended for longer reading sessions.';
    case AppThemeMode.dark:
      return 'A calm low-light appearance for night use. Recommended for low-light environments.';
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
  });

  final String label;
  final T value;
  final Map<T, String> entries;
  final ValueChanged<T?> onChanged;

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
                      child: Text(entry.value, textAlign: TextAlign.right),
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
