import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/content/contextual_quran_quotes.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../application/dhikr_controller.dart';
import '../application/fasting_controller.dart';
import '../application/prayer_tracker_controller.dart';
import '../domain/fasting_status.dart';
import '../domain/prayer_status.dart';
import 'widgets/dhikr_section.dart';
import 'widgets/fasting_section.dart';
import 'widgets/prayer_section.dart';

class WorshipPrayerPage extends StatelessWidget {
  const WorshipPrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _WorshipSectionScaffold(
      headerIcon: IslamicIcons.prayer,
      title: l10n.worshipPrayerHubTitle,
      subtitle: l10n.worshipPrayerHubSubtitle,
      quote: buildContextualQuranQuote(ContextualQuranQuoteKey.worshipPrayer),
      child: const PrayerSection(),
    );
  }
}

class WorshipDhikrPage extends StatelessWidget {
  const WorshipDhikrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _WorshipSectionScaffold(
      headerIcon: IslamicIcons.tasbih,
      title: l10n.dhikrSectionTitle,
      subtitle: l10n.dhikrSectionSubtitle,
      quote: buildContextualQuranQuote(ContextualQuranQuoteKey.worshipDhikr),
      child: const DhikrSection(),
    );
  }
}

class WorshipFastingPage extends StatelessWidget {
  const WorshipFastingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _WorshipSectionScaffold(
      headerIcon: Icons.fastfood_outlined,
      title: l10n.fastingSectionTitle,
      subtitle: l10n.fastingSectionSubtitle,
      quote: buildContextualQuranQuote(ContextualQuranQuoteKey.worshipFasting),
      child: const FastingSection(),
    );
  }
}

class WorshipTrackingPage extends ConsumerWidget {
  const WorshipTrackingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prayerTracker = ref.watch(prayerTrackerControllerProvider);
    final dhikr = ref.watch(dhikrControllerProvider);
    final fasting = ref.watch(fastingControllerProvider);
    final completedPrayers = prayerTracker.records.values
        .where((entry) => entry.status == PrayerStatus.completed)
        .length;

    return _WorshipSectionScaffold(
      headerIcon: Icons.fact_check_rounded,
      title: l10n.worshipTrackingPageTitle,
      subtitle: l10n.worshipTrackingPageSubtitle,
      quote: buildContextualQuranQuote(ContextualQuranQuoteKey.worshipTracking),
      child: Column(
        children: [
          _TrackingLinkCard(
            title: l10n.worshipPrayerHubTitle,
            subtitle: l10n.worshipTrackingPrayerSummary(
              completedPrayers,
              MaterialLocalizations.of(
                context,
              ).formatMediumDate(prayerTracker.selectedDate),
            ),
            icon: IslamicIcons.prayer,
            onTap: () => context.pushNamed('worshipPrayerPage'),
          ),
          const SizedBox(height: 12),
          _TrackingLinkCard(
            title: l10n.dhikrSectionTitle,
            subtitle: l10n.worshipTrackingDhikrSummary(
              dhikr.currentCount,
              dhikr.target,
              dhikr.recentSessions.length,
            ),
            icon: IslamicIcons.tasbih,
            onTap: () => context.pushNamed('worshipDhikrPage'),
          ),
          const SizedBox(height: 12),
          _TrackingLinkCard(
            title: l10n.fastingSectionTitle,
            subtitle: l10n.worshipTrackingFastingSummary(
              fasting.todayStatus.label,
            ),
            icon: Icons.fastfood_outlined,
            onTap: () => context.pushNamed('worshipFastingPage'),
          ),
        ],
      ),
    );
  }
}

class WorshipRemindersPage extends ConsumerWidget {
  const WorshipRemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prayerState = ref.watch(prayerSettingsProvider);
    final profileSettings = ref.watch(profileSettingsProvider);
    final enabledPrayerReminders = prayerState.notificationModes.values
        .where((mode) => mode != PrayerNotificationMode.none)
        .length;

    return _WorshipSectionScaffold(
      headerIcon: Icons.notifications_active_outlined,
      title: l10n.worshipRemindersPageTitle,
      subtitle: l10n.worshipRemindersPageSubtitle,
      quote: buildContextualQuranQuote(
        ContextualQuranQuoteKey.worshipReminders,
      ),
      child: Column(
        children: [
          _TrackingLinkCard(
            title: l10n.settingsPrayerNotificationsTitle,
            subtitle: l10n.worshipRemindersPrayerSummary(
              enabledPrayerReminders,
            ),
            icon: IslamicIcons.prayer,
            onTap: () => context.pushNamed('settingsNotificationsReminders'),
          ),
          const SizedBox(height: 12),
          _TrackingLinkCard(
            title: l10n.profileNotificationsTitle,
            subtitle: l10n.worshipRemindersGeneralSummary(
              profileSettings.dhikrReminders
                  ? l10n.settingsReminderStateOn
                  : l10n.settingsReminderStateOff,
              profileSettings.quranReminders
                  ? l10n.settingsReminderStateOn
                  : l10n.settingsReminderStateOff,
              profileSettings.reflectionReminders
                  ? l10n.settingsReminderStateOn
                  : l10n.settingsReminderStateOff,
            ),
            icon: Icons.notifications_outlined,
            onTap: () => context.pushNamed('settingsNotificationsReminders'),
          ),
          const SizedBox(height: 12),
          _TrackingLinkCard(
            title: l10n.settingsPrayerTimeModeTitle,
            subtitle: l10n.worshipRemindersDevicesSummary,
            icon: Icons.watch_later_outlined,
            onTap: () => context.pushNamed('settingsPrayerWorship'),
          ),
        ],
      ),
    );
  }
}

class _WorshipSectionScaffold extends StatelessWidget {
  const _WorshipSectionScaffold({
    required this.headerIcon,
    required this.title,
    required this.subtitle,
    required this.quote,
    required this.child,
  });

  final IconData headerIcon;
  final String title;
  final String subtitle;
  final QuranQuote quote;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionHubScaffold(
      ownsBackground: false,
      headerIcon: headerIcon,
      title: title,
      subtitle: subtitle,
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      children: [
        QuranQuoteBlock(
          quote: quote,
          onTap: () => openQuranQuoteLocation(context, quote),
        ),
        child,
      ],
    );
  }
}

class _TrackingLinkCard extends StatelessWidget {
  const _TrackingLinkCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.card,
    );
    final iconStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: cardStyle.decoration(radius: 18),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: iconStyle.decoration(
                  radius: 12,
                  includeShadow: false,
                ),
                child: Icon(icon, color: AppColors.onSurface),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.onSurfaceSubtle,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.onSurfaceSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
