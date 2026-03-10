import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/reminders/reminder_scheduler.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../../profile/application/profile_settings_provider.dart';

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

    return AppPageScaffold(
      headerIcon: Icons.settings_outlined,
      title: l10n.profilePrayerSettingsTitle,
      subtitle: l10n.profileSummarySubtitle,
      children: [
        SectionTitle(
          title: l10n.profilePrayerSettingsTitle,
          subtitle: l10n.profilePrayerSettingsSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _PreferenceDropdown<String>(
                label: l10n.profileLocationLabel,
                value: prayerState.preferences.location,
                entries: {
                  for (final location in ref.watch(
                    availablePrayerLocationsProvider,
                  ))
                    location: location,
                },
                onChanged: (value) {
                  if (value != null) prayerNotifier.updateLocation(value);
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
                    label: l10n.profileThemeSystem,
                    selected:
                        profileSettings.themePreference ==
                        ProfileThemePreference.system,
                    onSelected: () => profileSettingsNotifier.setThemePreference(
                      ProfileThemePreference.system,
                    ),
                  ),
                  _ThemeChoiceChip(
                    label: l10n.profileThemeDark,
                    selected:
                        profileSettings.themePreference ==
                        ProfileThemePreference.dark,
                    onSelected: () => profileSettingsNotifier.setThemePreference(
                      ProfileThemePreference.dark,
                    ),
                  ),
                  _ThemeChoiceChip(
                    label: l10n.profileThemeLight,
                    selected:
                        profileSettings.themePreference ==
                        ProfileThemePreference.light,
                    onSelected: () => profileSettingsNotifier.setThemePreference(
                      ProfileThemePreference.light,
                    ),
                  ),
                ],
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
                label: l10n.profilePrayerReminders,
                value: profileSettings.prayerReminders,
                onChanged: profileSettingsNotifier.setPrayerReminders,
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
            ],
          ),
        ),
      ],
    );
  }
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
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: DropdownButton<T>(
        value: value,
        underline: const SizedBox.shrink(),
        onChanged: onChanged,
        items: entries.entries
            .map(
              (entry) => DropdownMenuItem<T>(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
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
        (locale.countryCode == null || current.countryCode == locale.countryCode);

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
