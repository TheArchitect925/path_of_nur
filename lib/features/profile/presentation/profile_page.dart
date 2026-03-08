import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/section_title.dart';
import '../application/profile_settings_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prayerState = ref.watch(prayerSettingsProvider);
    final prayerNotifier = ref.read(prayerSettingsProvider.notifier);
    final userProfile = ref.watch(userProfileProvider);
    final userProfileNotifier = ref.read(userProfileProvider.notifier);
    final locationState = ref.watch(locationPermissionProvider);
    final locationNotifier = ref.read(locationPermissionProvider.notifier);
    final profileSettings = ref.watch(profileSettingsProvider);
    final profileSettingsNotifier = ref.read(profileSettingsProvider.notifier);
    final selectedLocale = ref.watch(appLocaleProvider) ?? Localizations.localeOf(context);

    return AppPageScaffold(
      headerIcon: Icons.manage_accounts,
      title: l10n.profileTitle,
      subtitle: l10n.profileSubtitle,
      quote: QuranQuote(
        arabic: 'فَمَنِ اتَّقَى اللَّهَ',
        transliteration: 'Faman ittaqa Allaha',
        translation: l10n.profileQuoteTranslation,
        surah: 13,
        verse: 28,
        locationLabel: 'Qur’an 13:28',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        _ProfileSummaryCard(
          address: _addressFromSex(userProfile.sex, l10n),
          name: userProfile.name,
          subtitle: l10n.profileSummarySubtitle,
          levelValue: '7',
          streakValue: '6 ${l10n.homeDaysLabel}',
          selectedLanguage: _languageLabel(l10n, selectedLocale),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
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
                  for (final location in ref.watch(availablePrayerLocationsProvider))
                    location: location,
                },
                onChanged: (value) {
                  if (value != null) {
                    prayerNotifier.updateLocation(value);
                  }
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
                  if (value != null) {
                    prayerNotifier.updateMadhab(value);
                  }
                },
              ),
              const Divider(height: 1),
              _PreferenceDropdown<PrayerCalculationMethod>(
                label: l10n.profileCalculationMethodLabel,
                value: prayerState.preferences.calculationMethod,
                entries: const {
                  PrayerCalculationMethod.muslimWorldLeague: 'Muslim World League',
                  PrayerCalculationMethod.egyptian: 'Egyptian',
                  PrayerCalculationMethod.isna: 'ISNA',
                  PrayerCalculationMethod.karachi: 'Karachi',
                  PrayerCalculationMethod.ummAlQura: 'Umm Al-Qura',
                },
                onChanged: (value) {
                  if (value != null) {
                    prayerNotifier.updateMethod(value);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
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
                        profileSettings.themePreference == ProfileThemePreference.system,
                    onSelected: () => profileSettingsNotifier
                        .setThemePreference(ProfileThemePreference.system),
                  ),
                  _ThemeChoiceChip(
                    label: l10n.profileThemeDark,
                    selected:
                        profileSettings.themePreference == ProfileThemePreference.dark,
                    onSelected: () => profileSettingsNotifier
                        .setThemePreference(ProfileThemePreference.dark),
                  ),
                  _ThemeChoiceChip(
                    label: l10n.profileThemeLight,
                    selected:
                        profileSettings.themePreference == ProfileThemePreference.light,
                    onSelected: () => profileSettingsNotifier
                        .setThemePreference(ProfileThemePreference.light),
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
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.profileModesTitle,
          subtitle: l10n.profileModesSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _ModeTile(
                icon: Icons.nightlight_round,
                title: l10n.profileRamadanModeTitle,
                subtitle: l10n.profileRamadanModeSubtitle,
                value: profileSettings.ramadanModeEnabled,
                onChanged: profileSettingsNotifier.setRamadanModeEnabled,
              ),
              const Divider(height: 1),
              _ModeTile(
                icon: Icons.favorite_border,
                title: l10n.profileLossModeTitle,
                subtitle: l10n.profileLossModeSubtitle,
                value: profileSettings.lossModeEnabled,
                onChanged: profileSettingsNotifier.setLossModeEnabled,
              ),
              const Divider(height: 1),
              _ModeTile(
                icon: Icons.spa_outlined,
                title: l10n.profileGentleModeTitle,
                subtitle: l10n.profileGentleModeSubtitle,
                value: profileSettings.gentleModeEnabled,
                onChanged: profileSettingsNotifier.setGentleModeEnabled,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
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
              const Divider(height: 1),
              ListTile(
                title: Text(l10n.profileEntrustDeedsTitle),
                subtitle: Text(l10n.profileEntrustDeedsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.profileNotificationsTitle,
          subtitle: l10n.profileNotificationsSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
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
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.languageOptionsTitle,
          subtitle: l10n.languageOptionsSubtitle,
        ),
        ExpansionTile(
          initiallyExpanded: false,
          title: Text(l10n.profileLanguageExpandTitle),
          subtitle: Text(l10n.profileLanguageExpandSubtitle),
          leading: const Icon(Icons.language),
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
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.profileAboutTitle,
          subtitle: l10n.profileAboutSubtitle,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Path of Nur',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(l10n.profileMissionLine),
              const SizedBox(height: 8),
              Text(
                l10n.profileVersionPlaceholder,
                style: Theme.of(context).textTheme.bodySmall,
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

String _languageLabel(AppLocalizations l10n, Locale locale) {
  if (locale.languageCode == 'ar') return l10n.languageArabic;
  if (locale.languageCode == 'id') return l10n.languageIndonesian;
  if (locale.languageCode == 'ms') return l10n.languageMalay;
  if (locale.languageCode == 'bn') return l10n.languageBengali;
  if (locale.languageCode == 'ur') return l10n.languageUrdu;
  if (locale.languageCode == 'fa' && locale.countryCode == 'AF') {
    return l10n.languageDari;
  }
  if (locale.languageCode == 'fa') return l10n.languageFarsi;
  if (locale.languageCode == 'tg') return l10n.languageTajik;
  if (locale.languageCode == 'tr') return l10n.languageTurkish;
  if (locale.languageCode == 'hi') return l10n.languageHindi;
  if (locale.languageCode == 'pa') return l10n.languagePunjabi;
  if (locale.languageCode == 'ha') return l10n.languageHausa;
  if (locale.languageCode == 'ps') return l10n.languagePashto;
  if (locale.languageCode == 'ku') return l10n.languageKurdish;
  return l10n.languageEnglish;
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({
    required this.address,
    required this.name,
    required this.subtitle,
    required this.levelValue,
    required this.streakValue,
    required this.selectedLanguage,
  });

  final String address;
  final String name;
  final String subtitle;
  final String levelValue;
  final String streakValue;
  final String selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: AppColors.accentGoldSoft,
              child: Icon(Icons.person, color: AppColors.background),
            ),
            title: Text('$address $name'),
            subtitle: Text(subtitle),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ProfileInfoChip(
                icon: Icons.auto_awesome,
                label: '${l10n.levelLabel}: $levelValue',
              ),
              _ProfileInfoChip(
                icon: Icons.local_fire_department_outlined,
                label: '${l10n.streakLabel}: $streakValue',
              ),
              _ProfileInfoChip(
                icon: Icons.language,
                label: '${l10n.languageOptionsTitle}: $selectedLanguage',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoChip extends StatelessWidget {
  const _ProfileInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accentGoldSoft.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.accentGold),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
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
      selectedColor: AppColors.accentGoldSoft.withValues(alpha: 0.5),
      backgroundColor: AppColors.surface.withValues(alpha: 0.2),
      side: BorderSide(
        color: AppColors.accentGoldSoft.withValues(alpha: selected ? 0.65 : 0.35),
      ),
      labelStyle: Theme.of(context).textTheme.bodyMedium,
    );
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
      secondary: Icon(icon, color: AppColors.accentGold),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.homeAccent,
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
      activeThumbColor: AppColors.homeAccent,
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
      onTap: () {
        ref.read(appLocaleProvider.notifier).state = locale;
      },
      title: Text(label),
      subtitle: Text(locale.toLanguageTag()),
      trailing: Icon(
        isCurrent ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isCurrent ? AppColors.homeAccent : AppColors.onSurfaceSubtle,
      ),
    );
  }
}
