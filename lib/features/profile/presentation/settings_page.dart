import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_backgrounds.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/reminders/adhan_audio_service.dart';
import '../../../core/reminders/adhan_options.dart';
import '../../../core/reminders/reminder_scheduler.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/display/compact_list_tile.dart';
import '../../../shared/widgets/display/expandable_tile.dart';
import '../../../shared/widgets/display/hub_list_group.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/quran_reference_link.dart';
import '../../../shared/widgets/section_title.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../../editorial_dashboard/application/editorial_dashboard_access_provider.dart';
import '../../editorial_dashboard/application/editorial_dashboard_providers.dart';
import '../../learn/journey/application/learning_path_provider.dart';
import '../../learn/journey/domain/learning_path_models.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../../profile/domain/profile_age_preferences.dart';
import '../../worship/application/sister_cycle_provider.dart';
import '../../worship/domain/prayer_calendar_mode.dart';
import 'adhan_option_picker_sheet.dart';
import 'settings/settings_catalog.dart';
import '../../../core/theme/app_icons.dart';

// The router builds every settings page from this file, so it keeps importing
// the category enum from here even though the catalog now owns it.
export 'settings/settings_catalog.dart' show SettingsCategory;

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key, this.category});

  final SettingsCategory? category;

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
    final sisterCycle = ref.watch(sisterCycleProvider);
    final sisterCycleNotifier = ref.read(sisterCycleProvider.notifier);
    final learningPathSelection = ref.watch(learningPathSelectionProvider);
    final profileSummary = ref.watch(profileSummaryProvider);
    final reminderPlan = ref.watch(reminderSchedulerProvider);
    final adhanRepository = ref.watch(adhanRepositoryProvider);
    final adhanPreview = ref.watch(adhanPreviewControllerProvider);
    final adhanPreviewController = ref.read(
      adhanPreviewControllerProvider.notifier,
    );
    final displayLocation = ref.watch(prayerLocationDisplayLabelProvider);
    final accountsSync = ref.watch(accountsSyncControllerProvider);
    final isKidsMode = specialMode.isKids;
    final locationLabel =
        displayLocation.valueOrNull ??
        (prayerState.preferences.useDeviceLocation
            ? l10n.settingsCurrentLocation
            : prayerState.preferences.location);
    const visibleThemeModes = [
      AppThemeMode.noorGlass,
      AppThemeMode.midnight,
      AppThemeMode.candlelight,
      AppThemeMode.jummah,
      AppThemeMode.ramadan,
      AppThemeMode.laylatAlQadr,
      AppThemeMode.eid,
      AppThemeMode.noorGlassDark,
      AppThemeMode.noGlass,
      AppThemeMode.noGlassDark,
    ];
    if (category == null) {
      // One list, one search — the same hub grammar the other tabs use, so
      // Settings stops being the last page with its own tile-grid language.
      return AppPageScaffold(
        headerIcon: AppIcons.settings,
        title: l10n.settingsLandingTitle,
        subtitle: localizedAppPageDescription(
          context,
          AppPageDescriptionKey.settingsLanding,
          kidsMode: isKidsMode,
        ),
        headerActions: [
          IconButton(
            onPressed: () => context.pushNamed('settingsSearch'),
            icon: const Icon(Icons.search_rounded),
            tooltip: l10n.settingsSearchTooltip,
          ),
        ],
        children: [
          for (final group in settingsGroups(l10n)) ...[
            HubListGroup(
              title: group.title,
              children: [
                for (final destination in group.destinations)
                  CompactListTile(
                    title: destination.title,
                    subtitle: destination.subtitle,
                    leading: HubLeadingIcon(destination.icon),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () => context.pushNamed(destination.routeName),
                  ),
              ],
            ),
            const SizedBox(height: 14),
          ],
        ],
      );
    }

    // Pages that carry a single section let the page header be the heading;
    // repeating the same title one line below it is noise. Only pages that
    // stack two sections (Notifications) still label them.
    Widget wrapSection({
      required String title,
      required String subtitle,
      required Widget child,
      bool titled = false,
    }) {
      if (!titled) return child;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(title: title, subtitle: subtitle),
          child,
        ],
      );
    }

    final profilePersonalizationSection = wrapSection(
      title: l10n.settingsProfilePersonalizationTitle,
      subtitle: l10n.settingsProfilePersonalizationSubtitle,
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const _HomepageProfileIcon(size: 42),
              title: Text(
                l10n.settingsProfileDisplayNameSummary(
                  _addressFromSex(userProfile.sex, l10n),
                  userProfile.name,
                ),
              ),
              subtitle: Text(
                l10n.settingsProfileLevelUsageSummary(
                  l10n.homeLevelValue(
                    _formatCount(context, profileSummary.level),
                  ),
                  l10n.homeDaysCount(profileSummary.daysUsingApp),
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
            // Was a Material ExpansionTile, which paints its own
            // dividers and highlight over the glass card.
            ExpandableTile(
              title: Text(l10n.settingsCareModesTitle),
              subtitle: Text(l10n.settingsCareModesSubtitle),
              leading: const HubLeadingIcon(AppIcons.care),
              child: Column(
                children: [
                  _ModeTile(
                    icon: IslamicIcons.lantern,
                    title: l10n.profileRamadanModeTitle,
                    subtitle: l10n.profileRamadanModeSubtitle,
                    value: specialMode.isRamadan,
                    onChanged: profileSettingsNotifier.setRamadanModeEnabled,
                  ),
                  _ModeSupportCard(
                    title: l10n.settingsCareModeRamadanTitle,
                    body: l10n.settingsCareModeRamadanBody,
                    references: [
                      QuranReferenceLinkTile(
                        referenceLabel: l10n.settingsCareModeRamadanReference,
                        surahNumber: 2,
                        fallbackStartAyah: 183,
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  _ModeTile(
                    icon: IslamicIcons.community,
                    title: l10n.profileLossModeTitle,
                    subtitle: l10n.profileLossModeSubtitle,
                    value: specialMode.isLoss,
                    onChanged: profileSettingsNotifier.setLossModeEnabled,
                  ),
                  _ModeSupportCard(
                    title: l10n.settingsCareModeLossTitle,
                    body: l10n.settingsCareModeLossBody,
                    supportingLines: [
                      l10n.settingsCareModeLossPrayer,
                      l10n.settingsCareModeLossHadith,
                    ],
                    references: [
                      QuranReferenceLinkTile(
                        referenceLabel: l10n.settingsCareModeLossReference,
                        surahNumber: 2,
                        fallbackStartAyah: 156,
                        endAyahNumber: 157,
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  _ModeTile(
                    icon: IslamicIcons.tasbih,
                    title: l10n.profileGentleModeTitle,
                    subtitle:
                        l10n.settingsGentleModeReducedNotificationsSubtitle,
                    value: specialMode.isGentle,
                    onChanged: profileSettingsNotifier.setGentleModeEnabled,
                  ),
                  _ModeSupportCard(
                    title: l10n.settingsCareModeGentleTitle,
                    body: l10n.settingsCareModeGentleBody,
                  ),
                  const Divider(height: 1),
                  _ModeTile(
                    icon: AppIcons.care,
                    title: l10n.settingsUnwellModeTitle,
                    subtitle: l10n.settingsUnwellModeSubtitle,
                    value: specialMode.isUnwell,
                    onChanged: profileSettingsNotifier.setUnwellModeEnabled,
                  ),
                  _ModeSupportCard(
                    title: l10n.settingsCareModeUnwellTitle,
                    body: l10n.settingsCareModeUnwellBody,
                    supportingLines: [
                      l10n.settingsCareModeUnwellPrayerEase,
                      l10n.settingsCareModeUnwellHadith,
                    ],
                  ),
                  if (userProfile.sex == UserSex.sister) ...[
                    const Divider(height: 1),
                    _ModeTile(
                      icon: Icons.water_drop_rounded,
                      title: l10n.settingsCycleDaysTitle,
                      subtitle: l10n.settingsCycleDaysSubtitle,
                      value: sisterCycle.active,
                      onChanged: sisterCycleNotifier.setActive,
                    ),
                    _ModeSupportCard(
                      title: l10n.settingsCycleDaysSupportTitle,
                      body: l10n.settingsCycleDaysSupportBody,
                      supportingLines: [
                        l10n.settingsCycleDaysReminderSupport,
                        l10n.settingsCycleDaysStreakSupport,
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final familyLearningRow =
        accountsSync.activeProfile != null &&
            accountsSync.activeProfile!.profileType != ProfileKind.child &&
            accountsSync.activeProfile!.profileType != ProfileKind.guest
        ? CompactListTile(
            title: l10n.familyLearningSettingsTitle,
            subtitle: l10n.familyLearningSettingsSubtitle,
            leading: const HubLeadingIcon(AppIcons.family),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () => context.pushNamed('learnFamilyManagement'),
          )
        : const SizedBox.shrink();

    final accountsSyncSection = wrapSection(
      title: l10n.settingsAccountsSyncTitle,
      subtitle: l10n.settingsAccountsSyncSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CompactListTile(
                title: l10n.settingsCurrentProfileTitle,
                subtitle: accountsSync.activeProfile == null
                    ? l10n.settingsNoProfileSelected
                    : l10n.settingsCurrentProfileSummary(
                        accountsSync.activeProfile!.displayName,
                        _profileSyncModeLabel(
                          accountsSync.activeProfile!.syncMode,
                          l10n,
                        ),
                      ),
                leading: const HubLeadingIcon(AppIcons.profile),
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () => context.push('/accounts-sync'),
              ),
              const SizedBox(height: 6),
              CompactListTile(
                title: l10n.settingsSyncStatusTitle,
                subtitle: l10n.settingsSyncStatusSummary(
                  accountsSync.syncStatus.pendingChangesCount,
                  _syncStateLabel(accountsSync.syncStatus.syncState, l10n),
                ),
                leading: const HubLeadingIcon(AppIcons.backup),
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () => context.push('/accounts-sync/sync-details'),
              ),
              const SizedBox(height: 6),
              CompactListTile(
                title: l10n.settingsBackupRestoreTitle,
                subtitle: accountsSync.backupRecommended
                    ? l10n.settingsBackupRecommended
                    : accountsSync.backupRecord.lastExportAtIso == null
                    ? l10n.settingsNoManualBackupYet
                    : l10n.settingsLastExportRecorded,
                leading: const HubLeadingIcon(AppIcons.download),
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () => context.push('/accounts-sync/backup'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          PremiumCard(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(AppIcons.family, size: 20),
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
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(height: 1.35),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Age range lives on the Learning page — one setting, one
                  // home. This card only owns the kids UI theme mode.
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
                  // Family learning is reached from Profile &
                  // Personalization; it used to appear here as well.
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final adhanSection = wrapSection(
      title: l10n.settingsAdhanTitle,
      subtitle: l10n.settingsAdhanSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(title: l10n.settingsAdhanSoundTitle),
          CompactListTile(
            title: l10n.settingsAdhanChoiceTitle,
            subtitle: adhanRepository
                .resolveRegular(prayerState.adhanSettings)
                .option
                .title,
            leading: const HubLeadingIcon(AppIcons.adhan),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () async {
              await showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => AdhanOptionPickerSheet(
                  category: AdhanOptionCategory.regular,
                  selectedId: prayerState.adhanSettings.selectedRegularAdhanId,
                  settings: prayerState.adhanSettings,
                  onSelected: prayerNotifier.selectRegularAdhan,
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          SectionTitle(title: l10n.settingsPreviewVolumeTitle),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        await adhanPreviewController.playRegular(
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
                            ? Icons.stop_circle_rounded
                            : Icons.play_circle_outline_rounded,
                      ),
                      label: Text(l10n.settingsTestAdhan),
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
                            (prayerState.adhanSettings.volume * 100).round(),
                          ),
                        ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    );

    final prayerSettingsSection = wrapSection(
      title: l10n.profilePrayerSettingsTitle,
      subtitle: l10n.profilePrayerSettingsSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CompactListTile(
            title: l10n.profileLocationLabel,
            subtitle: locationLabel,
            leading: const HubLeadingIcon(AppIcons.location),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () async {
              final service = ref.read(prayerLocationSearchServiceProvider);
              final recentLocations = ref.read(prayerRecentLocationsProvider);
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
              if (selection.latitude == null || selection.longitude == null) {
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
          const SizedBox(height: 14),
          // Was one card holding calculation, calendar, Jumu'ah, time mode
          // and every adjustment — several thousand pixels of unbroken
          // surface. Each concern is its own titled card now.
          SectionTitle(
            title: l10n.settingsSalahCalculationTitle,
            subtitle: l10n.settingsSalahCalculationSubtitle,
          ),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionTitle(
            title: l10n.settingsPrayerCalendarDisplayTitle,
            subtitle: l10n.settingsPrayerCalendarDisplaySubtitle,
          ),
          PremiumCard(
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<PrayerCalendarMode>(
                segments: [
                  ButtonSegment<PrayerCalendarMode>(
                    value: PrayerCalendarMode.gregorian,
                    label: Text(
                      _prayerCalendarModeLabel(
                        PrayerCalendarMode.gregorian,
                        l10n,
                      ),
                    ),
                  ),
                  ButtonSegment<PrayerCalendarMode>(
                    value: PrayerCalendarMode.islamic,
                    label: Text(
                      _prayerCalendarModeLabel(
                        PrayerCalendarMode.islamic,
                        l10n,
                      ),
                    ),
                  ),
                ],
                selected: {profileSettings.prayerCalendarMode},
                onSelectionChanged: (selection) {
                  profileSettingsNotifier.setPrayerCalendarMode(
                    selection.first,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
          _PrayerTimeAdjustmentsSection(
            l10n: l10n,
            prayerState: prayerState,
            prayerNotifier: prayerNotifier,
          ),
        ],
      ),
    );

    final widgetsWatchSection = wrapSection(
      title: l10n.settingsCategoryWidgetsWatchTitle,
      subtitle: l10n.settingsCategoryWidgetsWatchSubtitle,
      // Master switch on its own card, the two surfaces it governs on a
      // second one, so the dimmed state reads as a group rather than as half
      // of a single card fading out.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PremiumCard(
            child: _SettingsToggleRow(
              label: l10n.settingsWidgetsEnabledTitle,
              subtitle: l10n.settingsWidgetsEnabledSubtitle,
              value:
                  prayerState.preferences.useStableDynamicIsland ||
                  prayerState.preferences.useStableLockScreenWidget,
              onChanged: (enabled) {
                prayerNotifier.setStableDynamicIsland(enabled);
                prayerNotifier.setStableLockScreenWidget(enabled);
              },
            ),
          ),
          const SizedBox(height: 6),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity:
                prayerState.preferences.useStableDynamicIsland ||
                    prayerState.preferences.useStableLockScreenWidget
                ? 1
                : 0.55,
            child: IgnorePointer(
              ignoring:
                  !prayerState.preferences.useStableDynamicIsland &&
                  !prayerState.preferences.useStableLockScreenWidget,
              child: PremiumCard(
                child: Column(
                  children: [
                    _SettingsToggleRow(
                      label: l10n.settingsStableDynamicIslandTitle,
                      subtitle: l10n.settingsStableDynamicIslandSubtitle,
                      value: prayerState.preferences.useStableDynamicIsland,
                      onChanged: prayerNotifier.setStableDynamicIsland,
                    ),
                    const Divider(height: 1),
                    _SettingsToggleRow(
                      label: l10n.settingsStableLockScreenWidgetTitle,
                      subtitle: l10n.settingsStableLockScreenWidgetSubtitle,
                      value: prayerState.preferences.useStableLockScreenWidget,
                      onChanged: prayerNotifier.setStableLockScreenWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // The theme picker is the reason people open this page, so it sits at the
    // top, already open. Occasion dress-up and accessibility follow as their
    // own cards instead of hiding inside the picker's expansion.
    final appearanceSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.profileThemeModeLabel,
          subtitle: l10n.settingsThemeModePickerHelper,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsToggleRow(
                label: l10n.settingsFollowSystemThemeTitle,
                subtitle: l10n.settingsFollowSystemThemeSubtitle,
                value:
                    profileSettings.themePreference ==
                    ProfileThemePreference.system,
                onChanged: (value) {
                  profileSettingsNotifier.setFollowSystemTheme(value);
                  _showAppearanceSnack(
                    context,
                    l10n.settingsThemeChangedSuccessfully,
                  );
                },
              ),
              const SizedBox(height: 10),
              // Ten full-width preview tiles stacked vertically pushed every
              // other appearance control several screens down. As a carousel
              // the whole set is one swipe and the rest of the page stays in
              // reach.
              SizedBox(
                height: 296,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: visibleThemeModes.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.xs + 2),
                  itemBuilder: (context, index) {
                    final mode = visibleThemeModes[index];
                    return SizedBox(
                      width: 186,
                      child: _ThemePreviewTile(
                        label: _themeModeLabel(mode, l10n),
                        description: _themeModeDescription(mode, l10n),
                        helper: _themeModeBestForLabel(mode, l10n),
                        data: _themePreviewData(mode),
                        selected: profileSettings.appThemeMode == mode,
                        onSelected: () {
                          profileSettingsNotifier.setAppThemeMode(mode);
                          _showAppearanceSnack(
                            context,
                            l10n.settingsThemeChangedSuccessfully,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              if (profileSettings.appThemeMode == AppThemeMode.noorGlass &&
                  !profileSettings.disableColoredGlass &&
                  profileSettings.themePreference ==
                      ProfileThemePreference.light &&
                  !profileSettings.disableBackground) ...[
                Text(
                  l10n.settingsDefaultAppearanceActive,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
              ],
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
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
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ExpandableTile(
          title: Text(l10n.settingsOccasionThemesTitle),
          subtitle: Text(l10n.settingsOccasionThemesSubtitle),
          leading: const HubLeadingIcon(AppIcons.occasions),
          child: Column(
            children: [
              _SettingsToggleRow(
                label: l10n.settingsLivingSkyTitle,
                subtitle: l10n.settingsLivingSkySubtitle,
                value: profileSettings.livingAtmosphere,
                onChanged: (value) {
                  profileSettingsNotifier.setLivingAtmosphere(value);
                  _showAppearanceSnack(
                    context,
                    l10n.settingsThemeChangedSuccessfully,
                  );
                },
              ),
              _SettingsToggleRow(
                label: l10n.settingsDressUpFridaysTitle,
                subtitle: l10n.settingsDressUpFridaysSubtitle,
                value: profileSettings.dressUpFridays,
                onChanged: (value) {
                  profileSettingsNotifier.setDressUpFridays(value);
                  _showAppearanceSnack(
                    context,
                    l10n.settingsThemeChangedSuccessfully,
                  );
                },
              ),
              _SettingsToggleRow(
                label: l10n.settingsDressUpRamadanTitle,
                subtitle: l10n.settingsDressUpRamadanSubtitle,
                value: profileSettings.dressUpRamadan,
                onChanged: (value) {
                  profileSettingsNotifier.setDressUpRamadan(value);
                  _showAppearanceSnack(
                    context,
                    l10n.settingsThemeChangedSuccessfully,
                  );
                },
              ),
              _SettingsToggleRow(
                label: l10n.settingsDressUpQadrTitle,
                subtitle: l10n.settingsDressUpQadrSubtitle,
                value: profileSettings.dressUpQadrNights,
                onChanged: (value) {
                  profileSettingsNotifier.setDressUpQadrNights(value);
                  _showAppearanceSnack(
                    context,
                    l10n.settingsThemeChangedSuccessfully,
                  );
                },
              ),
              _SettingsToggleRow(
                label: l10n.settingsDressUpEidTitle,
                subtitle: l10n.settingsDressUpEidSubtitle,
                value: profileSettings.dressUpEid,
                onChanged: (value) {
                  profileSettingsNotifier.setDressUpEid(value);
                  _showAppearanceSnack(
                    context,
                    l10n.settingsThemeChangedSuccessfully,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(title: l10n.settingsVisualPreferencesTitle),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsToggleRow(
                label: l10n.settingsDisableColoredGlassTitle,
                subtitle: l10n.settingsDisableColoredGlassSubtitle,
                value: profileSettings.disableColoredGlass,
                onChanged: (value) {
                  profileSettingsNotifier.setDisableColoredGlass(value);
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
              DropdownButtonFormField<AppPageTransitionStyle>(
                initialValue: profileSettings.pageTransitionStyle,
                decoration: InputDecoration(
                  labelText: l10n.settingsPageTransitionsTitle,
                  helperText: l10n.settingsPageTransitionsSubtitle,
                  isDense: true,
                ),
                items: AppPageTransitionStyle.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_pageTransitionStyleLabel(item, l10n)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) {
                    profileSettingsNotifier.setPageTransitionStyle(value);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(title: l10n.settingsAccessibilityTitle),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsToggleRow(
                label: l10n.profileReduceMotion,
                subtitle: l10n.settingsReduceMotionTransitionOverrideSubtitle,
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
      ],
    );

    final prayerNotificationsSection = wrapSection(
      title: l10n.settingsPrayerNotificationsTitle,
      titled: true,
      subtitle: l10n.settingsPrayerNotificationsSubtitle,
      child: PremiumCard(
        child: Column(
          children: [
            _SettingsToggleRow(
              label: l10n.profilePrayerReminders,
              subtitle: l10n.settingsPrayerRemindersToggleSubtitle,
              value: profileSettings.prayerReminders,
              onChanged: profileSettingsNotifier.setPrayerReminders,
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                l10n.profilePlannedRemindersToday(
                  reminderPlan.items
                      .where(
                        (item) =>
                            item.kind == ReminderKind.prayerAtTime ||
                            item.kind == ReminderKind.prayerBeforeQaza,
                      )
                      .length,
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );

    final perPrayerNotificationsSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(title: l10n.settingsRemindersPerPrayerTitle),
        PremiumCard(
          child: Column(
            children: _buildPrayerNotificationTiles(
              context: context,
              settings: prayerState,
              onChanged: prayerNotifier.updateNotificationMode,
              l10n: l10n,
            ),
          ),
        ),
      ],
    );

    final privacySection = wrapSection(
      title: l10n.profileTrackingPrivacyTitle,
      subtitle: l10n.profileTrackingPrivacySubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(title: l10n.settingsPermissionsTitle),
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
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
          ),
          const SizedBox(height: 14),
          SectionTitle(title: l10n.settingsWhatOthersSeeTitle),
          PremiumCard(
            child: Column(
              children: [
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
        ],
      ),
    );

    final notificationsSection = wrapSection(
      title: l10n.settingsOtherRemindersTitle,
      titled: true,
      subtitle: l10n.profileNotificationsSubtitle,
      child: PremiumCard(
        child: Column(
          children: [
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
            const Divider(height: 1),
            _SettingsToggleRow(
              label: l10n.profileOnThisDayReminders,
              subtitle: l10n.profileOnThisDayRemindersSubtitle,
              value: profileSettings.onThisDayReminders,
              onChanged: profileSettingsNotifier.setOnThisDayReminders,
            ),
            const Divider(height: 1),
            _SettingsToggleRow(
              label: l10n.profileMoonriseReminders,
              subtitle: l10n.profileMoonriseRemindersSubtitle,
              value: profileSettings.moonriseReminders,
              onChanged: profileSettingsNotifier.setMoonriseReminders,
            ),
            const Divider(height: 1),
            _SettingsToggleRow(
              label: l10n.profileMoonsetReminders,
              subtitle: l10n.profileMoonsetRemindersSubtitle,
              value: profileSettings.moonsetReminders,
              onChanged: profileSettingsNotifier.setMoonsetReminders,
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                l10n.profilePlannedRemindersToday(reminderPlan.items.length),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );

    // A whole page for two languages does not need an expander in front of
    // them — the choice is the page.
    final languageSection = wrapSection(
      title: l10n.languageOptionsTitle,
      subtitle: l10n.languageOptionsSubtitle,
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LanguageRow(l10n.languageEnglish, const Locale('en')),
            const Divider(height: 1),
            _LanguageRow(l10n.languageGerman, const Locale('de')),
            const Divider(height: 1),
            _LanguageRow(l10n.languageArabic, const Locale('ar')),
            const Divider(height: 1),
            _LanguageRow(l10n.languageUrdu, const Locale('ur')),
            const Divider(height: 1),
            _LanguageRow(l10n.languageFrench, const Locale('fr')),
            const SizedBox(height: 8),
            Text(
              l10n.profileLanguageExpandSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );

    final learningSection = wrapSection(
      title: l10n.learnHubTitle,
      subtitle: l10n.settingsCategoryLearningSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CompactListTile(
            title: l10n.settingsLearningLevelTitle,
            subtitle: _settingsLearningLevelLabel(
              context,
              learningPathSelection?.selectedLevel,
            ),
            leading: const HubLeadingIcon(AppIcons.path),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () => context.pushNamed('learnLearningPath'),
          ),
          const SizedBox(height: 6),
          CompactListTile(
            title: l10n.settingsRunOnboardingTitle,
            subtitle: l10n.settingsRunOnboardingSubtitle,
            leading: const HubLeadingIcon(AppIcons.occasions),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () => context.push('/onboarding?preview=1'),
          ),
          const SizedBox(height: 14),
          PremiumCard(
            child: DropdownButtonFormField<ProfileAgeRange>(
              initialValue: profileSettings.ageRange,
              decoration: InputDecoration(
                labelText: l10n.kidsUiAgeRangeTitle,
                helperText: _profileAgeRangeLabel(
                  profileSettings.ageRange,
                  l10n,
                ),
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
          ),
        ],
      ),
    );

    // The four legal links used to be unlabeled tonal buttons whose captions
    // named other pages entirely (Terms read "About", Support read
    // "Notifications & Reminders"). They are ordinary rows now, each carrying
    // its own name.
    final aboutSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HubListGroup(
          title: l10n.profileAboutTitle,
          children: [
            CompactListTile(
              title: l10n.homeOverviewHeroTitle,
              subtitle: l10n.homeOverviewHeroSubtitle,
              leading: const HubLeadingIcon(AppIcons.summary),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.pushNamed('profileSummary'),
            ),
            CompactListTile(
              title: l10n.settingsWhatsNewTitle,
              subtitle: l10n.settingsWhatsNewSubtitle,
              leading: const HubLeadingIcon(AppIcons.whatsNew),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.pushNamed('profileWhatsNew'),
            ),
            CompactListTile(
              title: l10n.settingsComingSoonTitle,
              subtitle: l10n.settingsComingSoonSubtitle,
              leading: const HubLeadingIcon(AppIcons.comingSoon),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.pushNamed('profileComingSoon'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        HubListGroup(
          title: l10n.settingsLegalTitle,
          children: [
            CompactListTile(
              title: l10n.legalPrivacyTitle,
              subtitle: l10n.legalPrivacySubtitle,
              leading: const HubLeadingIcon(AppIcons.privacy),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.pushNamed('privacyPolicy'),
            ),
            CompactListTile(
              title: l10n.legalTermsTitle,
              subtitle: l10n.legalTermsSubtitle,
              leading: const HubLeadingIcon(AppIcons.legal),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.pushNamed('termsUsage'),
            ),
            CompactListTile(
              title: l10n.legalSupportTitle,
              subtitle: l10n.legalSupportSubtitle,
              leading: const HubLeadingIcon(AppIcons.support),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.pushNamed('supportInfo'),
            ),
            CompactListTile(
              title: l10n.settingsAttributionsLicensesTitle,
              subtitle: l10n.quranReaderSourcesLicensingTitle,
              leading: const HubLeadingIcon(AppIcons.licenses),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () => context.pushNamed('attributionsLicenses'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _EditorialDashboardUnlockFooter(),
      ],
    );

    final sectionMap = <SettingsCategory, List<Widget>>{
      SettingsCategory.profile: [
        profilePersonalizationSection,
        const SizedBox(height: 12),
        familyLearningRow,
      ],
      SettingsCategory.accountSync: [accountsSyncSection],
      SettingsCategory.appearance: [appearanceSection],
      SettingsCategory.prayerWorship: [prayerSettingsSection],
      SettingsCategory.adhan: [adhanSection],
      SettingsCategory.learning: [learningSection],
      SettingsCategory.notificationsReminders: [
        prayerNotificationsSection,
        const SizedBox(height: 14),
        perPrayerNotificationsSection,
        const SizedBox(height: 14),
        notificationsSection,
      ],
      SettingsCategory.widgetsWatch: [widgetsWatchSection],
      SettingsCategory.languageDownloads: [languageSection],
      SettingsCategory.privacyData: [privacySection],
      SettingsCategory.about: [aboutSection],
    };

    final currentCategory = category!;

    return AppPageScaffold(
      headerIcon: settingsCategoryIcon(currentCategory),
      title: settingsCategoryTitle(currentCategory, l10n),
      subtitle: _settingsCategorySubtitle(
        context,
        currentCategory,
        kidsMode: isKidsMode,
      ),
      children: sectionMap[currentCategory] ?? const <Widget>[],
    );
  }
}

class _EditorialDashboardUnlockFooter extends ConsumerStatefulWidget {
  const _EditorialDashboardUnlockFooter();

  @override
  ConsumerState<_EditorialDashboardUnlockFooter> createState() =>
      _EditorialDashboardUnlockFooterState();
}

class _EditorialDashboardUnlockFooterState
    extends ConsumerState<_EditorialDashboardUnlockFooter> {
  static const int _requiredTaps = 7;
  int _tapCount = 0;

  void _handleTap() {
    final enabled = ref.read(editorialDashboardFeatureEnabledProvider);
    if (!enabled) return;
    _tapCount += 1;
    if (_tapCount < _requiredTaps) return;
    _tapCount = 0;
    final unlocked = ref.read(
      editorialDashboardAccessProvider.select(
        (value) => value.isSessionUnlocked,
      ),
    );
    if (!mounted) return;
    context.pushNamed(
      unlocked ? 'editorialDashboard' : 'editorialDashboardPin',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final version = ref.watch(editorialDashboardPackageInfoProvider);
    final label = version.when(
      data: (value) => l10n.editorialDashboardVersionLabel(value),
      loading: () => l10n.editorialDashboardVersionLoading,
      error: (_, _) => l10n.editorialDashboardVersionUnknown,
    );

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

String _settingsCategorySubtitle(
  BuildContext context,
  SettingsCategory category, {
  required bool kidsMode,
}) {
  final l10n = AppLocalizations.of(context);
  switch (category) {
    // Profile and Adhan were split out of the account-sync and prayer pages,
    // so they carry the catalog copy rather than a kids-aware variant.
    case SettingsCategory.profile:
    case SettingsCategory.adhan:
      return settingsCategorySubtitle(category, l10n);
    case SettingsCategory.accountSync:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.accountSync,
        kidsMode: kidsMode,
      );
    case SettingsCategory.appearance:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.appearance,
        kidsMode: kidsMode,
      );
    case SettingsCategory.prayerWorship:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.prayerWorship,
        kidsMode: kidsMode,
      );
    case SettingsCategory.learning:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.learning,
        kidsMode: kidsMode,
      );
    case SettingsCategory.notificationsReminders:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.notifications,
        kidsMode: kidsMode,
      );
    case SettingsCategory.widgetsWatch:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.widgetsWatch,
        kidsMode: kidsMode,
      );
    case SettingsCategory.languageDownloads:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.language,
        kidsMode: kidsMode,
      );
    case SettingsCategory.privacyData:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.privacy,
        kidsMode: kidsMode,
      );
    case SettingsCategory.about:
      return localizedSettingsPageDescription(
        context,
        SettingsPageDescriptionKey.about,
        kidsMode: kidsMode,
      );
  }
}

String _addressFromSex(UserSex sex, AppLocalizations l10n) {
  return sex == UserSex.brother ? l10n.profileBrother : l10n.profileSister;
}

String _settingsLearningLevelLabel(
  BuildContext context,
  LearningPathLevel? level,
) {
  final l10n = AppLocalizations.of(context);
  switch (level) {
    case LearningPathLevel.beginner:
      return l10n.learnPathLevelFoundationsTitle;
    case LearningPathLevel.practicing:
    case LearningPathLevel.seeker:
      return l10n.learnPathLevelGrowingTitle;
    case LearningPathLevel.advanced:
      return l10n.learnPathLevelDeepDiveTitle;
    case null:
      return l10n.learnHubLearningPathCardSubtitleNoPath;
  }
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

String _pageTransitionStyleLabel(
  AppPageTransitionStyle style,
  AppLocalizations l10n,
) {
  switch (style) {
    case AppPageTransitionStyle.defaultSystem:
      return l10n.settingsPageTransitionStyleDefault;
    case AppPageTransitionStyle.gentleFade:
      return l10n.settingsPageTransitionStyleGentleFade;
    case AppPageTransitionStyle.iosStyle:
      return l10n.settingsPageTransitionStyleIos;
    case AppPageTransitionStyle.noAnimation:
      return l10n.settingsPageTransitionStyleNone;
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
  return value.localizedLabel(l10n);
}

String _calculationMethodLabel(
  PrayerCalculationMethod value,
  AppLocalizations l10n,
) {
  return value.localizedLabel(l10n);
}

String _prayerCalendarModeLabel(
  PrayerCalendarMode value,
  AppLocalizations l10n,
) {
  switch (value) {
    case PrayerCalendarMode.gregorian:
      return l10n.worshipPrayerGregorianCalendarTitle;
    case PrayerCalendarMode.islamic:
      return l10n.worshipPrayerIslamicCalendarTitle;
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

class _ModeSupportCard extends StatelessWidget {
  const _ModeSupportCard({
    required this.title,
    required this.body,
    this.supportingLines = const [],
    this.references = const [],
  });

  final String title;
  final String body;
  final List<String> supportingLines;
  final List<Widget> references;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: AppSurfaceTheme.resolve(
          context,
          variant: AppSurfaceVariant.panel,
        ).decoration(radius: 16, includeShadow: false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(body, style: textTheme.bodySmall?.copyWith(height: 1.35)),
            for (final line in supportingLines) ...[
              const SizedBox(height: 6),
              Text(line, style: textTheme.bodySmall?.copyWith(height: 1.35)),
            ],
            if (references.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...references,
            ],
          ],
        ),
      ),
    );
  }
}

class _HomepageProfileIcon extends StatelessWidget {
  const _HomepageProfileIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final inner = size;
    // Themed rather than fixed cream/gold — the old literals rendered as a
    // pale blob on Midnight, Ramadan, and the other night themes.
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    return SizedBox(
      width: inner,
      height: inner,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: inner,
            height: inner,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: accent.withValues(alpha: 0.72),
                width: 3,
              ),
            ),
          ),
          CircleAvatar(
            radius: inner * 0.38,
            backgroundColor: accent.withValues(alpha: 0.14),
            child: CircleAvatar(
              radius: inner * 0.34,
              backgroundColor: accent.withValues(alpha: 0.22),
              child: Icon(
                Icons.person_rounded,
                size: inner * 0.34,
                color: onSurface.withValues(alpha: 0.86),
              ),
            ),
          ),
        ],
      ),
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
  const prayerOrder = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha', 'tahajjud'];
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _JumuahSettingsSection(
          l10n: l10n,
          prayerState: prayerState,
          prayerNotifier: prayerNotifier,
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.settingsPrayerTimeModeTitle,
          subtitle: l10n.settingsPrayerTimeModeSubtitle,
        ),
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
        const SizedBox(height: 14),
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
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: selected ? Theme.of(context).colorScheme.primary : null,
    );
    final badgeStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: Theme.of(context).colorScheme.primary,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: surfaceStyle.decoration(radius: 18),
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
                    decoration: badgeStyle.decoration(radius: 999),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.settingsPrayerTimeAdjustmentsTitle,
          subtitle: l10n.settingsPrayerTimeAdjustmentsSubtitle,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsPrayerTimeAdjustmentsExample,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.settingsPrayerTimeAdjustmentsScope,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (adjustments.hasAnyAdjustment) ...[
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final activeStyle = AppSurfaceTheme.resolve(
                context,
                variant: AppSurfaceVariant.pill,
                tintColor: Theme.of(context).colorScheme.primary,
              );
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: activeStyle.decoration(
                  radius: 999,
                  includeShadow: false,
                ),
                child: Text(
                  l10n.settingsCustomAdjustmentsActive,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              );
            },
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.settingsManualPrayerTimesTitle,
          subtitle: l10n.settingsManualPrayerTimesSubtitle,
        ),
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
                decoration: AppSurfaceTheme.resolve(
                  context,
                  variant: AppSurfaceVariant.panel,
                ).decoration(radius: 18),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.settingsMosqueTimeComparisonTitle,
          subtitle: l10n.settingsMosqueTimeComparisonSubtitle,
        ),
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
                decoration: AppSurfaceTheme.resolve(
                  context,
                  variant: AppSurfaceVariant.panel,
                ).decoration(radius: 18),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.settingsJumuahSettingsTitle,
          subtitle: l10n.settingsJumuahSettingsSubtitle,
        ),
        PremiumCard(
          child: _SettingsToggleRow(
            label: l10n.settingsEnableJumuahOverrideTitle,
            subtitle: l10n.settingsEnableJumuahOverrideSubtitle,
            value: preferences.jumuahOverrideEnabled,
            onChanged: (value) {
              prayerNotifier.updateJumuahSettings(enabled: value);
            },
          ),
        ),
        if (preferences.jumuahOverrideEnabled) ...[
          const SizedBox(height: 6),
          CompactListTile(
            title: l10n.settingsJumuahTimeTitle,
            subtitle: l10n.settingsJumuahTimeSubtitle,
            leading: const HubLeadingIcon(AppIcons.schedule),
            trailing: Text(
              _formatMinutesLabel(context, preferences.jumuahTimeMinutes, l10n),
              style: Theme.of(context).textTheme.titleSmall,
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
          const SizedBox(height: 6),
          PremiumCard(
            child: Wrap(
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
          ),
        ],
        const SizedBox(height: 6),
        CompactListTile(
          title: l10n.settingsJumuahMosqueTitle,
          subtitle:
              preferences.jumuahMosqueName ?? l10n.settingsJumuahChooseMosque,
          leading: const HubLeadingIcon(AppIcons.mosque),
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () async {
            final result = await showDialog<PrayerLocationSearchResult>(
              context: context,
              builder: (context) => const _JumuahMosquePickerDialog(),
            );
            if (result == null) return;
            prayerNotifier.updateJumuahSettings(
              mosqueName: result.label,
              mosqueLatitude: result.latitude,
              mosqueLongitude: result.longitude,
            );
          },
        ),
        const SizedBox(height: 14),
        SectionTitle(title: l10n.settingsJumuahLeaveReminderTitle),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final mode in JumuahLeaveReminderMode.values)
                    ChoiceChip(
                      key: ValueKey('jumuah-leave-${mode.wireName}'),
                      label: Text(switch (mode) {
                        JumuahLeaveReminderMode.off =>
                          l10n.settingsJumuahLeaveOff,
                        JumuahLeaveReminderMode.fixedTravelTime =>
                          l10n.settingsJumuahLeaveFixed,
                        JumuahLeaveReminderMode.locationEstimate =>
                          l10n.settingsJumuahLeaveEstimate,
                      }),
                      selected: preferences.jumuahLeaveReminderMode == mode,
                      onSelected: (_) {
                        prayerNotifier.updateJumuahSettings(
                          leaveReminderMode: mode,
                        );
                      },
                    ),
                ],
              ),
              if (preferences.jumuahLeaveReminderMode ==
                  JumuahLeaveReminderMode.fixedTravelTime) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.settingsJumuahTravelMinutesLabel),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        onPressed: () => prayerNotifier.updateJumuahSettings(
                          travelMinutes: (preferences.jumuahTravelMinutes - 5)
                              .clamp(5, 120),
                        ),
                      ),
                      Text(
                        _formatCount(context, preferences.jumuahTravelMinutes),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        onPressed: () => prayerNotifier.updateJumuahSettings(
                          travelMinutes: (preferences.jumuahTravelMinutes + 5)
                              .clamp(5, 120),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (preferences.jumuahLeaveReminderMode ==
                  JumuahLeaveReminderMode.locationEstimate) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.settingsJumuahEstimatePrivacyNote,
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

class _JumuahMosquePickerDialog extends ConsumerStatefulWidget {
  const _JumuahMosquePickerDialog();

  @override
  ConsumerState<_JumuahMosquePickerDialog> createState() =>
      _JumuahMosquePickerDialogState();
}

class _JumuahMosquePickerDialogState
    extends ConsumerState<_JumuahMosquePickerDialog> {
  final _controller = TextEditingController();
  List<PrayerLocationSearchResult> _results = const [];
  bool _searching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    setState(() => _searching = true);
    try {
      final service = ref.read(prayerLocationSearchServiceProvider);
      final results = await service.search(query);
      if (!mounted) return;
      setState(() => _results = results);
    } catch (_) {
      if (!mounted) return;
      setState(() => _results = const []);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.settingsJumuahMosqueTitle),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: l10n.settingsJumuahChooseMosque,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: _search,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_searching)
              const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final result in _results)
                      ListTile(
                        dense: true,
                        leading: const Icon(AppIcons.mosque),
                        title: Text(
                          result.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Navigator.of(context).pop(result),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
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
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    final modifiedStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: Theme.of(context).colorScheme.primary,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: surfaceStyle.decoration(radius: 18),
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
                    decoration: modifiedStyle.decoration(radius: 999),
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
    case 'tahajjud':
      return l10n.notificationsPrayerNameTahajjud;
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
      return l10n.settingsThemeModeCalmBeautifulDescription;
    case AppThemeMode.easyRead:
      return l10n.settingsThemeModeEasyReadDescription;
    case AppThemeMode.noorGlass:
      return l10n.settingsThemeModeNoorGlassDescription;
    case AppThemeMode.noorGlassDark:
      return l10n.settingsThemeModeNoorGlassDarkDescription;
    case AppThemeMode.noGlass:
      return l10n.settingsThemeModeNoGlassDescription;
    case AppThemeMode.noGlassDark:
      return l10n.settingsThemeModeNoGlassDarkDescription;
    case AppThemeMode.dark:
      return l10n.settingsThemeModeDarkDescription;
    case AppThemeMode.midnightManuscript:
      return l10n.settingsThemeModeMidnightManuscriptDescription;
    case AppThemeMode.noorMidnightManuscript:
      return l10n.settingsThemeModeNoorMidnightManuscriptDescription;
    case AppThemeMode.noorKids:
      return l10n.settingsThemeModeNoorKidsDescription;
    case AppThemeMode.midnight:
      return l10n.settingsThemeModeMidnightDescription;
    case AppThemeMode.candlelight:
      return l10n.settingsThemeModeCandlelightDescription;
    case AppThemeMode.jummah:
      return l10n.settingsThemeModeJummahDescription;
    case AppThemeMode.ramadan:
      return l10n.settingsThemeModeRamadanDescription;
    case AppThemeMode.laylatAlQadr:
      return l10n.settingsThemeModeLaylatAlQadrDescription;
    case AppThemeMode.eid:
      return l10n.settingsThemeModeEidDescription;
  }
}

String _themeModeLabel(AppThemeMode mode, AppLocalizations l10n) {
  switch (mode) {
    case AppThemeMode.defaultMode:
      return l10n.settingsThemeChoiceDefault;
    case AppThemeMode.calmBeautiful:
      return l10n.settingsThemeChoiceCalmBeautiful;
    case AppThemeMode.easyRead:
      return l10n.settingsThemeChoiceEasyRead;
    case AppThemeMode.noorGlass:
      return l10n.settingsThemeChoiceNoorGlass;
    case AppThemeMode.noorGlassDark:
      return l10n.settingsThemeChoiceNoorGlassDark;
    case AppThemeMode.noGlass:
      return l10n.settingsThemeChoiceNoGlass;
    case AppThemeMode.noGlassDark:
      return l10n.settingsThemeChoiceNoGlassDark;
    case AppThemeMode.dark:
      return l10n.profileThemeDark;
    case AppThemeMode.midnightManuscript:
      return l10n.settingsThemeChoiceMidnightManuscript;
    case AppThemeMode.noorMidnightManuscript:
      return l10n.settingsThemeChoiceNoorMidnightManuscript;
    case AppThemeMode.noorKids:
      return l10n.settingsThemeChoiceNoorKids;
    case AppThemeMode.midnight:
      return l10n.quranReaderAtmosphereMidnight;
    case AppThemeMode.candlelight:
      return l10n.quranReaderAtmosphereCandlelight;
    case AppThemeMode.jummah:
      return l10n.settingsThemeChoiceJummah;
    case AppThemeMode.ramadan:
      return l10n.settingsThemeChoiceRamadan;
    case AppThemeMode.laylatAlQadr:
      return l10n.settingsThemeChoiceLaylatAlQadr;
    case AppThemeMode.eid:
      return l10n.settingsThemeChoiceEid;
  }
}

String _themeModeBestForLabel(AppThemeMode mode, AppLocalizations l10n) {
  switch (mode) {
    case AppThemeMode.defaultMode:
      return l10n.settingsThemeModeDefaultBestFor;
    case AppThemeMode.calmBeautiful:
      return l10n.settingsThemeModeCalmBeautifulBestFor;
    case AppThemeMode.easyRead:
      return l10n.settingsThemeModeEasyReadBestFor;
    case AppThemeMode.noorGlass:
      return l10n.settingsThemeModeNoorGlassBestFor;
    case AppThemeMode.noorGlassDark:
      return l10n.settingsThemeModeNoorGlassDarkBestFor;
    case AppThemeMode.noGlass:
      return l10n.settingsThemeModeNoGlassBestFor;
    case AppThemeMode.noGlassDark:
      return l10n.settingsThemeModeNoGlassDarkBestFor;
    case AppThemeMode.dark:
      return l10n.settingsThemeModeDarkBestFor;
    case AppThemeMode.midnightManuscript:
      return l10n.settingsThemeModeMidnightManuscriptBestFor;
    case AppThemeMode.noorMidnightManuscript:
      return l10n.settingsThemeModeNoorMidnightManuscriptBestFor;
    case AppThemeMode.noorKids:
      return l10n.settingsThemeModeNoorKidsBestFor;
    case AppThemeMode.midnight:
      return l10n.settingsThemeModeMidnightBestFor;
    case AppThemeMode.candlelight:
      return l10n.settingsThemeModeCandlelightBestFor;
    case AppThemeMode.jummah:
      return l10n.settingsThemeModeJummahBestFor;
    case AppThemeMode.ramadan:
      return l10n.settingsThemeModeRamadanBestFor;
    case AppThemeMode.laylatAlQadr:
      return l10n.settingsThemeModeLaylatAlQadrBestFor;
    case AppThemeMode.eid:
      return l10n.settingsThemeModeEidBestFor;
  }
}

_ThemePreviewData _themePreviewData(AppThemeMode mode) {
  final appearance = AppAppearanceTheme.defaults(
    mode: mode,
    disableGlassTransparency: false,
    disableColoredGlass: false,
    disableBackground: false,
    glassSurfaceAlpha: 0.88,
  );
  final background = AppBackgroundTheme.resolve(
    appearance: appearance,
    disableGlassTransparency: false,
    atmosphere: appearance.isMidnightFamily
        ? AppBackgroundAtmosphere.quran
        : AppBackgroundAtmosphere.standard,
  );
  final isNoorGlass = appearance.isNoorGlassFamily;
  final isMidnight = appearance.isMidnightFamily;
  final isNoGlass =
      appearance.isNoGlassFamily || appearance.isNoorGlassPrimaryFamily;
  return _ThemePreviewData(
    backgroundGradient: background.previewGradient ?? background.baseGradient,
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appearance.surfaceSoft.withValues(
          alpha: isNoGlass
              ? 0.94
              : isNoorGlass
              ? 0.58
              : 0.86,
        ),
        appearance.surface.withValues(
          alpha: isNoGlass
              ? 0.96
              : isNoorGlass
              ? 0.36
              : 0.74,
        ),
      ],
    ),
    cardBorder: appearance.border.withValues(
      alpha: isMidnight
          ? 0.85
          : isNoorGlass
          ? 0.68
          : 0.58,
    ),
    primaryText: appearance.quranArabicEmphasis,
    secondaryText: appearance.onSurfaceSubtle,
    accent: appearance.accent,
    accentSoft: appearance.isMidnightFamily
        ? appearance.success
        : isNoorGlass
        ? Colors.white.withValues(alpha: 0.92)
        : appearance.accentSoft,
  );
}

void _showAppearanceSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class _ThemePreviewData {
  const _ThemePreviewData({
    required this.backgroundGradient,
    required this.cardGradient,
    required this.cardBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
    required this.accentSoft,
  });

  final Gradient backgroundGradient;
  final Gradient cardGradient;
  final Color cardBorder;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;
  final Color accentSoft;
}

class _ThemePreviewTile extends StatelessWidget {
  const _ThemePreviewTile({
    required this.label,
    required this.description,
    required this.helper,
    required this.selected,
    required this.onSelected,
    required this.data,
  });

  final String label;
  final String description;
  final String helper;
  final bool selected;
  final VoidCallback onSelected;
  final _ThemePreviewData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBorder = selected
        ? data.accent.withValues(alpha: 0.92)
        : theme.dividerColor.withValues(alpha: 0.30);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selectedBorder,
              width: selected ? 1.4 : 1,
            ),
            color: theme.colorScheme.surface.withValues(alpha: 0.28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: data.backgroundGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            opacity: selected ? 1 : 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: data.accent.withValues(alpha: 0.24),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: data.accent.withValues(alpha: 0.8),
                                ),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: 15,
                                color: data.primaryText,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 34,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: data.primaryText.withValues(
                                    alpha: 0.82,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 18,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: data.accent.withValues(alpha: 0.72),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: data.cardGradient,
                              border: Border.all(color: data.cardBorder),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 54,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: data.accent.withValues(alpha: 0.75),
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Container(
                                  width: double.infinity,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: data.primaryText.withValues(
                                      alpha: 0.84,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          color: data.secondaryText.withValues(
                                            alpha: 0.72,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 26,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        color: data.accentSoft.withValues(
                                          alpha: 0.28,
                                        ),
                                        border: Border.all(
                                          color: data.accentSoft.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Flexible so a wrapped label or a larger text scale clips
              // instead of overflowing the carousel's fixed row height.
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  helper,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: data.accent,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            alignment: AlignmentDirectional.centerEnd,
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
                        textAlign: TextAlign.end,
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
        isCurrent
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_unchecked_rounded,
      ),
    );
  }
}
