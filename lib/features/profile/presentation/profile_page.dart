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
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_title.dart';

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

    return AppPageScaffold(
      headerIcon: Icons.manage_accounts,
      title: l10n.profileTitle,
      subtitle: l10n.profileSubtitle,
      quote: const QuranQuote(
        arabic: 'فَمَنِ اتَّقَى اللَّهَ',
        transliteration: 'Faman ittaqa Allaha',
        translation:
            'Whoever is mindful of Allah is guided toward balance and intention.',
        surah: 13,
        verse: 28,
        locationLabel: 'Qur’an 13:28',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        PremiumCard(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.accentGoldSoft,
              child: Icon(Icons.person, color: AppColors.background),
            ),
            title: Text('${_addressFromSex(userProfile.sex)} ${userProfile.name}'),
            subtitle: const Text('Daily intention account placeholder'),
            trailing: const Icon(Icons.chevron_right),
          ),
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
                  decoration: const InputDecoration(
                    labelText: 'Display name',
                    isDense: true,
                  ),
                  onChanged: userProfileNotifier.updateName,
                  maxLength: 26,
                ),
                const SizedBox(height: 12),
                const Text('Address me as:'),
                const SizedBox(height: 8),
                SegmentedButton<UserSex>(
                  segments: const [
                    ButtonSegment<UserSex>(
                      value: UserSex.brother,
                      label: Text('Brother'),
                    ),
                    ButtonSegment<UserSex>(
                      value: UserSex.sister,
                      label: Text('Sister'),
                    ),
                  ],
                  selected: {userProfile.sex},
                  onSelectionChanged: (value) {
                    final selected = value.first;
                    userProfileNotifier.updateSex(selected);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle(
          title: 'Prayer & Prayer Time Settings',
          subtitle: 'Set location and calculation preferences.',
        ),
        PremiumCard(
          child: Column(
            children: [
              _PreferenceDropdown<String>(
                label: 'Location',
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
                label: 'Madhab',
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
                label: 'Prayer calculation method',
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
        const SectionTitle(
          title: 'Appearance / Themes',
          subtitle: 'Visual and atmosphere preferences.',
        ),
        PremiumCard(
          child: _ToggleList([
            const _ProfileToggle('Warm theme (default)', true),
            const _ProfileToggle('Reduce motion effects', false),
            const _ProfileToggle('High contrast text', false),
          ]),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Modes',
          subtitle: 'Mode presets to support focus and consistency.',
        ),
        PremiumCard(
          child: const Column(
            children: [
              _ModeRow('Ramadan Mode'),
              _ModeRow('Loss Mode'),
              _ModeRow('Gentle Mode (Placeholder)'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Tracking & Privacy',
          subtitle: 'Controls for reminders, summaries, and data intent.',
        ),
        PremiumCard(
          child: Column(
            children: [
              ListTile(
                title: const Text('Location while using app'),
                subtitle: Text(
                  locationState.isGranted
                      ? 'Enabled for foreground use only.'
                      : 'Enable to keep prayer times accurate.',
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
                              ? 'Open settings'
                              : 'Allow',
                        ),
                      ),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text('Tracking preferences'),
                subtitle: Text(
                  'Syncing and summary toggles will be added later',
                ),
                trailing: Icon(Icons.chevron_right),
              ),
              Divider(height: 1),
              ListTile(
                title: Text('Privacy / intention settings'),
                subtitle: Text('Local-first defaults and export options'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Notifications',
          subtitle: 'Reminder placeholders.',
        ),
        PremiumCard(
          child: _ToggleList([
            const _ProfileToggle('Gentle worship reminders', true),
            const _ProfileToggle('Daily learning prompts', false),
            const _ProfileToggle('Streak check-ins', false),
          ]),
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.languageOptionsTitle,
          subtitle: l10n.languageOptionsSubtitle,
        ),
        ExpansionTile(
          initiallyExpanded: false,
          title: const Text('Language options'),
          subtitle: const Text('Select language below'),
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
        const SectionTitle(
          title: 'About',
          subtitle: 'Product and app information.',
        ),
        PremiumCard(
          child: const ListTile(
            title: Text('Path of Nūr'),
            subtitle: Text('A calm spiritual companion app blueprint.'),
            trailing: Icon(Icons.info_outline),
          ),
        ),
      ],
    );
  }
}

String _addressFromSex(UserSex sex) {
  return sex == UserSex.brother ? 'Brother' : 'Sister';
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

class _ToggleList extends StatelessWidget {
  const _ToggleList(this.items);

  final List<_ProfileToggle> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: item,
            ),
          )
          .toList(),
    );
  }
}

class _ProfileToggle extends StatelessWidget {
  const _ProfileToggle(this.label, this.enabled);

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      activeThumbColor: AppColors.homeAccent,
      value: enabled,
      onChanged: (_) {},
      title: Text(label),
      subtitle: const Text('Placeholder setting'),
    );
  }
}

class _ModeRow extends StatelessWidget {
  const _ModeRow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.adjust_rounded, color: AppColors.accentGold),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          const Icon(Icons.chevron_right),
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
