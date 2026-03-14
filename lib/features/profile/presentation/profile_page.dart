import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../application/profile_settings_provider.dart';

const bool _simplifiedProfileView = true;

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final userProfileNotifier = ref.read(userProfileProvider.notifier);
    final profileSettings = ref.watch(profileSettingsProvider);
    final profileSettingsNotifier = ref.read(profileSettingsProvider.notifier);
    final profileSummary = ref.watch(profileSummaryProvider);
    final modeState = ref.watch(specialModeProvider);

    return AppPageScaffold(
      headerIcon: IslamicIcons.muslim,
      title: l10n.profileTitle,
      subtitle: l10n.profileSubtitle,
      children: [
        _ProfileSummaryCard(
          address: _addressFromSex(profileSummary.sex, l10n),
          name: profileSummary.name,
          subtitle: l10n.profileSummarySubtitle,
          levelValue: '${profileSummary.level}',
          streakValue:
              '${profileSummary.currentStreakDays} ${l10n.homeDaysLabel}',
          selectedLanguage: _languageLabel(l10n, profileSummary.selectedLocale),
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
                  onSelectionChanged: (value) =>
                      userProfileNotifier.updateSex(value.first),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        if (_simplifiedProfileView)
          PremiumCard(
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: const Text(
                'More profile options',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(l10n.profileAboutSubtitle),
              children: [
                const SizedBox(height: 8),
                SectionTitle(
                  title: l10n.profileModesTitle,
                  subtitle: l10n.profileModesSubtitle,
                ),
                _ModeTile(
                  icon: IslamicIcons.lantern,
                  title: l10n.profileRamadanModeTitle,
                  subtitle: l10n.profileRamadanModeSubtitle,
                  value: modeState.isRamadan,
                  onChanged: profileSettingsNotifier.setRamadanModeEnabled,
                ),
                const Divider(height: 1),
                _ModeTile(
                  icon: IslamicIcons.community,
                  title: l10n.profileLossModeTitle,
                  subtitle: l10n.profileLossModeSubtitle,
                  value: modeState.isLoss,
                  onChanged: profileSettingsNotifier.setLossModeEnabled,
                ),
                const Divider(height: 1),
                _ModeTile(
                  icon: IslamicIcons.tasbih,
                  title: l10n.profileGentleModeTitle,
                  subtitle: l10n.profileGentleModeSubtitle,
                  value: modeState.isGentle,
                  onChanged: profileSettingsNotifier.setGentleModeEnabled,
                ),
                const Divider(height: 1),
                _ModeTile(
                  icon: IslamicIcons.family,
                  title: l10n.kidsModeTitle,
                  subtitle: l10n.kidsModeSubtitle,
                  value: profileSettings.kidsModeEnabled,
                  onChanged: profileSettingsNotifier.setKidsModeEnabled,
                ),
                if (modeState.isGentle) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(IslamicIcons.tasbih),
                    title: Text(l10n.modeGentleHomeTitle),
                    subtitle: Text(l10n.modeGentleHomeSubtitle),
                  ),
                ],
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.summarize_outlined),
                  title: Text(l10n.homeOverviewHeroTitle),
                  subtitle: Text(l10n.homeOverviewHeroSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('profileSummary'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(IslamicIcons.community),
                  title: Text(l10n.circlesTitle),
                  subtitle: Text(l10n.circlesSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('circlesDiscovery'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l10n.profilePrayerSettingsTitle),
                  subtitle: Text(l10n.profilePrayerSettingsSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('settings'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.new_releases_outlined),
                  title: const Text('What’s new'),
                  subtitle: const Text('See the latest app changes and earlier updates.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('profileWhatsNew'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.upcoming_outlined),
                  title: const Text('Coming soon'),
                  subtitle: const Text('Preview the next improvements planned for the app.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('profileComingSoon'),
                ),
              ],
            ),
          )
        else ...[
          SectionTitle(
            title: l10n.profileModesTitle,
            subtitle: l10n.profileModesSubtitle,
          ),
          PremiumCard(
            child: Column(
              children: [
                _ModeTile(
                  icon: IslamicIcons.lantern,
                  title: l10n.profileRamadanModeTitle,
                  subtitle: l10n.profileRamadanModeSubtitle,
                  value: modeState.isRamadan,
                  onChanged: profileSettingsNotifier.setRamadanModeEnabled,
                ),
                const Divider(height: 1),
                _ModeTile(
                  icon: IslamicIcons.community,
                  title: l10n.profileLossModeTitle,
                  subtitle: l10n.profileLossModeSubtitle,
                  value: modeState.isLoss,
                  onChanged: profileSettingsNotifier.setLossModeEnabled,
                ),
                const Divider(height: 1),
                _ModeTile(
                  icon: IslamicIcons.tasbih,
                  title: l10n.profileGentleModeTitle,
                  subtitle: l10n.profileGentleModeSubtitle,
                  value: modeState.isGentle,
                  onChanged: profileSettingsNotifier.setGentleModeEnabled,
                ),
                const Divider(height: 1),
                _ModeTile(
                  icon: IslamicIcons.family,
                  title: l10n.kidsModeTitle,
                  subtitle: l10n.kidsModeSubtitle,
                  value: profileSettings.kidsModeEnabled,
                  onChanged: profileSettingsNotifier.setKidsModeEnabled,
                ),
              ],
            ),
          ),
          if (modeState.isGentle) ...[
            const SizedBox(height: 10),
            PremiumCard(
              child: Row(
                children: [
                  const Icon(IslamicIcons.tasbih, color: Color(0xFF7A5A33)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.modeGentleHomeSubtitle,
                      style: const TextStyle(height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          SectionTitle(
            title: l10n.profileAboutTitle,
            subtitle: l10n.profileAboutSubtitle,
          ),
          PremiumCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.summarize_outlined),
                  title: Text(l10n.homeOverviewHeroTitle),
                  subtitle: Text(l10n.homeOverviewHeroSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('profileSummary'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(IslamicIcons.community),
                  title: Text(l10n.circlesTitle),
                  subtitle: Text(l10n.circlesSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('circlesDiscovery'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l10n.profilePrayerSettingsTitle),
                  subtitle: Text(l10n.profilePrayerSettingsSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('settings'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.new_releases_outlined),
                  title: const Text('What’s new'),
                  subtitle: const Text('See the latest app changes and earlier updates.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('profileWhatsNew'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.upcoming_outlined),
                  title: const Text('Coming soon'),
                  subtitle: const Text('Preview the next improvements planned for the app.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('profileComingSoon'),
                ),
              ],
            ),
          ),
        ],
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
            leading: const CircleAvatar(child: Icon(Icons.person)),
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
        color: const Color(0xFFF3EBE1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
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
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
