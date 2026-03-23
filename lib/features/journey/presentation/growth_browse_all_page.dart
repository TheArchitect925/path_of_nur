import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';

class GrowthBrowseAllPage extends StatelessWidget {
  const GrowthBrowseAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppPageScaffold(
      headerIcon: Icons.grid_view_rounded,
      title: l10n.growthHomeBrowseAllTitle,
      subtitle: l10n.growthHomeBrowseAllSubtitle,
      children: [
        _BrowseGroup(
          title: l10n.growthBrowseAllDailyFocusTitle,
          items: [
            _BrowseItem(
              title: l10n.growthTabToday,
              subtitle: l10n.growthHomeTodaySubtitle,
              icon: Icons.today_rounded,
              onTap: () => context.pushNamed('growthTodayPage'),
            ),
            _BrowseItem(
              title: l10n.growthTabHabits,
              subtitle: l10n.growthHomeHabitsSubtitle,
              icon: Icons.checklist_rtl_rounded,
              onTap: () => context.pushNamed('growthHabitsPage'),
            ),
            _BrowseItem(
              title: l10n.growthTabReflection,
              subtitle: l10n.growthHomeReflectionSubtitle,
              icon: Icons.auto_stories_rounded,
              onTap: () => context.pushNamed('growthReflectionPage'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _BrowseGroup(
          title: l10n.growthBrowseAllGrowthToolsTitle,
          items: [
            _BrowseItem(
              title: l10n.growthTabPaths,
              subtitle: l10n.growthHomePathsSubtitle,
              icon: Icons.alt_route_rounded,
              onTap: () => context.pushNamed('growthPathsPage'),
            ),
            _BrowseItem(
              title: l10n.growthTabJourney,
              subtitle: l10n.growthHomeJourneySubtitle,
              icon: Icons.route_rounded,
              onTap: () => context.pushNamed('growthJourneyPage'),
            ),
            _BrowseItem(
              title: l10n.spiritualGrowthTitle,
              subtitle: l10n.spiritualGrowthShortcutSubtitle,
              icon: Icons.self_improvement_rounded,
              onTap: () => context.pushNamed('spiritualGrowthPage'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _BrowseGroup(
          title: l10n.growthBrowseAllDashboardsTitle,
          items: [
            _BrowseItem(
              title: l10n.growthStatisticsTitle,
              subtitle: l10n.growthStatisticsSubtitle,
              icon: Icons.query_stats_rounded,
              onTap: () => context.pushNamed('growthStatisticsPage'),
            ),
            _BrowseItem(
              title: l10n.gardenPageTitle,
              subtitle: l10n.gardenPageEntryHomeSubtitle,
              icon: Icons.local_florist_rounded,
              onTap: () => context.pushNamed('gardenPage'),
            ),
            _BrowseItem(
              title: l10n.growthOceanDashboardTitle,
              subtitle: l10n.growthOceanDashboardSubtitle,
              icon: Icons.water_drop_rounded,
              onTap: () => context.pushNamed('oceanDrops'),
            ),
          ],
        ),
      ],
    );
  }
}

class _BrowseGroup extends StatelessWidget {
  const _BrowseGroup({required this.title, required this.items});

  final String title;
  final List<_BrowseItem> items;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const Divider(height: 18),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFF2EBDD),
                child: Icon(items[index].icon, color: const Color(0xFF6A5A4A)),
              ),
              title: Text(items[index].title),
              subtitle: Text(items[index].subtitle),
              onTap: items[index].onTap,
            ),
          ],
        ],
      ),
    );
  }
}

class _BrowseItem {
  const _BrowseItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}
