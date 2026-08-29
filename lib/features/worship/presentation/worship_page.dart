import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../learn/quran/domain/quran_content_refs.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/main_page_search_launcher.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import '../../home/application/home_calendar_progress_provider.dart';
import 'widgets/salah_timings_tracker_card.dart';

class WorshipPage extends ConsumerWidget {
  const WorshipPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      children: [
        QuranQuoteBlock(
          quote: quote,
          onTap: () => openQuranQuoteLocation(context, quote),
        ),
        const SizedBox(height: 12),
        // The daily timings tracker moved here from Home (calm-navigation
        // Phase 1); Home's compact prayer strip deep-links to this tab.
        SalahTimingsTrackerCard(
          selectedDate: ref.watch(homePrayerSelectedDateProvider),
          onSelectedDateChanged: (value) {
            ref.read(homePrayerSelectedDateProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: 12),
        const MainPageSearchLauncher(),
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
