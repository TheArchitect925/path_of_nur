import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../learn/quran/domain/quran_content_refs.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/main_page_search_launcher.dart';
import '../../../shared/widgets/main_page_shortcut_configs.dart';
import '../../../shared/widgets/main_page_shortcut_stack.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';

const int _shortcutDailyDhikrGoal = 500;

class WorshipPage extends ConsumerWidget {
  const WorshipPage({super.key});

  String _formatLocalizedCount(BuildContext context, num value) {
    return NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final worshipSummary = ref.watch(worshipSummaryProvider);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    const quote = QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 45));

    return SectionHubScaffold(
      ownsBackground: false,
      headerIcon: IslamicIcons.prayer,
      title: l10n.worshipTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.worshipHub,
        kidsMode: isKidsMode,
      ),
      floatingBottom: MainPageShortcutStack(
        items: buildWorshipPageShortcuts(
          l10n,
          salahProgressText:
              '${_formatLocalizedCount(context, worshipSummary.prayerCompleted)}/${_formatLocalizedCount(context, worshipSummary.prayerTotal)}',
          dhikrProgressText:
              '${_formatLocalizedCount(context, worshipSummary.dhikrCount)}/${_formatLocalizedCount(context, _shortcutDailyDhikrGoal)}',
        ),
        openLabel: l10n.learnShortcutOpen,
        closeLabel: l10n.learnShortcutClose,
      ),
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      children: [
        QuranQuoteBlock(
          quote: quote,
          onTap: () => openQuranQuoteLocation(context, quote),
        ),
        const SizedBox(height: 12),
        MainPageSearchLauncher(
          destinations: [
            MainPageSearchDestination(
              title: l10n.worshipSectionLandingPrayerTitle,
              subtitle: l10n.worshipSectionLandingPrayerSubtitle,
              icon: IslamicIcons.prayer,
              keywords: ['salah', 'prayer times', 'tracker'],
              onTap: () => context.pushNamed('worshipPrayerPage'),
            ),
            MainPageSearchDestination(
              title: l10n.worshipSectionLandingDhikrTitle,
              subtitle: l10n.worshipSectionLandingDhikrSubtitle,
              icon: IslamicIcons.tasbih,
              keywords: ['tasbih', 'adhkar', 'remembrance'],
              onTap: () => context.pushNamed('worshipDhikrPage'),
            ),
            MainPageSearchDestination(
              title: l10n.worshipSectionLandingDuasTitle,
              subtitle: l10n.worshipSectionLandingDuasSubtitle,
              icon: IslamicIcons.lantern,
              keywords: ['dua', 'supplication'],
              onTap: () => context.pushNamed('worshipDuasPage'),
            ),
            MainPageSearchDestination(
              title: l10n.fastingSectionTitle,
              subtitle: l10n.worshipSectionLandingFastingSubtitle,
              icon: Icons.fastfood_outlined,
              keywords: ['fasting', 'sawm', 'ramadan'],
              onTap: () => context.pushNamed('worshipFastingPage'),
            ),
            MainPageSearchDestination(
              title: l10n.worshipTrackingPageTitle,
              subtitle: l10n.worshipTrackingPageSubtitle,
              icon: Icons.fact_check_rounded,
              keywords: ['tracking', 'entries', 'history'],
              onTap: () => context.pushNamed('worshipTrackingPage'),
            ),
            MainPageSearchDestination(
              title: l10n.worshipRemindersPageTitle,
              subtitle: l10n.worshipRemindersPageSubtitle,
              icon: Icons.notifications_active_outlined,
              keywords: ['reminders', 'notifications', 'alerts'],
              onTap: () => context.pushNamed('worshipRemindersPage'),
            ),
            MainPageSearchDestination(
              title: l10n.worshipQiblaFinderTitle,
              subtitle: l10n.worshipQiblaFinderSubtitle,
              icon: Icons.explore_rounded,
              keywords: ['qibla', 'compass', 'direction'],
              onTap: () => context.pushNamed('qiblaFinder'),
            ),
            MainPageSearchDestination(
              title: l10n.khusuPageTitle,
              subtitle: l10n.khusuFocusSubtitle,
              icon: Icons.self_improvement_rounded,
              keywords: ['khusu', 'focus', 'presence'],
              onTap: () => context.pushNamed('khusuFocus'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SectionHubActionGrid(
          actions: [
            SectionHubAction(
              title: l10n.worshipSectionLandingPrayerTitle,
              subtitle: l10n.worshipSectionLandingPrayerSubtitle,
              icon: IslamicIcons.prayer,
              color: const Color(0xFFECE5D7),
              accentColor: const Color(0xFF6F5A3E),
              onTap: () => context.pushNamed('worshipPrayerPage'),
            ),
            SectionHubAction(
              title: l10n.worshipSectionLandingDhikrTitle,
              subtitle: l10n.worshipSectionLandingDhikrSubtitle,
              icon: IslamicIcons.tasbih,
              color: const Color(0xFFE4ECD9),
              accentColor: const Color(0xFF597045),
              onTap: () => context.pushNamed('worshipDhikrPage'),
            ),
            SectionHubAction(
              title: l10n.worshipSectionLandingDuasTitle,
              subtitle: l10n.worshipSectionLandingDuasSubtitle,
              icon: IslamicIcons.lantern,
              color: const Color(0xFFF0E2D6),
              accentColor: const Color(0xFF8D6143),
              onTap: () => context.pushNamed('worshipDuasPage'),
            ),
            SectionHubAction(
              title: l10n.fastingSectionTitle,
              subtitle: l10n.worshipSectionLandingFastingSubtitle,
              icon: Icons.fastfood_outlined,
              color: const Color(0xFFE2E5F3),
              accentColor: const Color(0xFF545E8D),
              onTap: () => context.pushNamed('worshipFastingPage'),
            ),
            SectionHubAction(
              title: l10n.worshipTrackingPageTitle,
              subtitle: l10n.worshipTrackingPageSubtitle,
              icon: Icons.fact_check_rounded,
              color: const Color(0xFFEADFEB),
              accentColor: const Color(0xFF7D5D81),
              onTap: () => context.pushNamed('worshipTrackingPage'),
            ),
            SectionHubAction(
              title: l10n.worshipRemindersPageTitle,
              subtitle: l10n.worshipRemindersPageSubtitle,
              icon: Icons.notifications_active_outlined,
              color: const Color(0xFFE6EEF1),
              accentColor: const Color(0xFF45636D),
              onTap: () => context.pushNamed('worshipRemindersPage'),
            ),
          ],
        ),
      ],
    );
  }
}
