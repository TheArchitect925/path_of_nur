import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/content/learning_quote.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';

class GrowthHomePage extends ConsumerWidget {
  const GrowthHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quote = buildGrowthReflectionQuote();

    return SectionHubScaffold(
      headerIcon: IslamicIcons.tasbih,
      title: l10n.journeyTitle,
      subtitle: l10n.growthHomeHeaderSubtitle,
      quote: quote,
      onQuoteTap: (selectedQuote) =>
          openQuranQuoteLocation(context, selectedQuote),
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      children: [
        SectionHubActionGrid(
          actions: [
            SectionHubAction(
              title: l10n.growthTabToday,
              subtitle: l10n.growthHomeTodaySubtitle,
              icon: Icons.today_rounded,
              color: const Color(0xFFE8E0CF),
              accentColor: const Color(0xFF7A6241),
              onTap: () => context.pushNamed('growthTodayPage'),
            ),
            SectionHubAction(
              title: l10n.growthTabPaths,
              subtitle: l10n.growthHomePathsSubtitle,
              icon: Icons.alt_route_rounded,
              color: const Color(0xFFE4ECD9),
              accentColor: const Color(0xFF597045),
              onTap: () => context.pushNamed('growthPathsPage'),
            ),
            SectionHubAction(
              title: l10n.growthTabHabits,
              subtitle: l10n.growthHomeHabitsSubtitle,
              icon: Icons.checklist_rtl_rounded,
              color: const Color(0xFFF0E2D6),
              accentColor: const Color(0xFF8D6143),
              onTap: () => context.pushNamed('growthHabitsPage'),
            ),
            SectionHubAction(
              title: l10n.growthTabJourney,
              subtitle: l10n.growthHomeJourneySubtitle,
              icon: Icons.route_rounded,
              color: const Color(0xFFE2E5F3),
              accentColor: const Color(0xFF545E8D),
              onTap: () => context.pushNamed('growthJourneyPage'),
            ),
            SectionHubAction(
              title: l10n.growthTabReflection,
              subtitle: l10n.growthHomeReflectionSubtitle,
              icon: Icons.auto_stories_rounded,
              color: const Color(0xFFEADFEB),
              accentColor: const Color(0xFF7D5D81),
              onTap: () => context.pushNamed('growthReflectionPage'),
            ),
            SectionHubAction(
              title: l10n.spiritualGrowthTitle,
              subtitle: l10n.spiritualGrowthShortcutSubtitle,
              icon: Icons.self_improvement_rounded,
              color: const Color(0xFFE6E8D7),
              accentColor: const Color(0xFF5F6E45),
              onTap: () => context.pushNamed('spiritualGrowthPage'),
            ),
            SectionHubAction(
              title: l10n.growthStatisticsTitle,
              subtitle: l10n.growthStatisticsSubtitle,
              icon: Icons.query_stats_rounded,
              color: const Color(0xFFE8E8EF),
              accentColor: const Color(0xFF5D6382),
              onTap: () => context.pushNamed('growthStatisticsPage'),
            ),
            SectionHubAction(
              title: l10n.gardenPageTitle,
              subtitle: l10n.gardenPageEntryHomeSubtitle,
              icon: Icons.local_florist_rounded,
              color: const Color(0xFFE4EDDE),
              accentColor: const Color(0xFF56704A),
              onTap: () => context.pushNamed('gardenPage'),
            ),
            SectionHubAction(
              title: l10n.growthHomeBrowseAllTitle,
              subtitle: l10n.growthHomeBrowseAllSubtitle,
              icon: Icons.grid_view_rounded,
              color: const Color(0xFFF4ECDF),
              accentColor: const Color(0xFF7C684B),
              onTap: () => context.pushNamed('growthBrowseAllPage'),
            ),
          ],
        ),
      ],
    );
  }
}
