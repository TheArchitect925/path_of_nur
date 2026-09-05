import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/quran/application/quran_personalization_provider.dart';
import '../../learn/quran/domain/quran_personalization_models.dart';
import '../../learn/quran/presentation/widgets/quran_personalized_recommendation_card.dart';
import '../../../shared/widgets/display/activity_heatmap.dart';
import '../../../shared/widgets/display/compact_list_tile.dart';
import '../../../shared/widgets/display/hub_list_group.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import '../application/growth_statistics_provider.dart';
import '../../../core/theme/app_icons.dart';

class GrowthHomePage extends ConsumerWidget {
  const GrowthHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SectionHubScaffold(
      ownsBackground: false,
      headerIcon: AppIcons.growth,
      title: l10n.journeyTitle,
      subtitle: l10n.growthHomeHeaderSubtitle,
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      headerActions: [
        IconButton(
          onPressed: () => context.pushNamed('allSearch'),
          icon: const Icon(Icons.search_rounded),
          tooltip: l10n.homeSearchTooltip,
        ),
      ],
      children: [
        const _GrowthRecentActivityCard(),
        const _GrowthSuggestedSpiritualFocusSection(),
        const SizedBox(height: 6),
        HubListGroup(
          title: l10n.growthGroupTrackTitle,
          children: [
            CompactListTile(
              title: l10n.growthTabToday,
              subtitle: l10n.growthHomeTodaySubtitle,
              leading: const HubLeadingIcon(AppIcons.today),
              onTap: () => context.pushNamed('growthTodayPage'),
            ),
            CompactListTile(
              title: l10n.growthTabHabits,
              subtitle: l10n.growthHomeHabitsSubtitle,
              leading: const HubLeadingIcon(AppIcons.habits),
              onTap: () => context.pushNamed('growthHabitsPage'),
            ),
            CompactListTile(
              title: l10n.growthStatisticsTitle,
              subtitle: l10n.growthStatisticsSubtitle,
              leading: const HubLeadingIcon(AppIcons.statistics),
              onTap: () => context.pushNamed('growthStatisticsPage'),
            ),
            CompactListTile(
              title: l10n.journalTitle,
              subtitle: l10n.journalSubtitle,
              leading: const HubLeadingIcon(AppIcons.journal),
              trailing: HubNewBadge(label: l10n.hubNewBadgeLabel),
              onTap: () => context.pushNamed('journalTimeline'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        HubListGroup(
          title: l10n.growthGroupGrowTitle,
          children: [
            CompactListTile(
              title: l10n.growthTabPaths,
              subtitle: l10n.growthHomePathsSubtitle,
              leading: const HubLeadingIcon(AppIcons.growthPaths),
              onTap: () => context.pushNamed('growthPathsPage'),
            ),
            CompactListTile(
              title: l10n.growthTabJourney,
              subtitle: l10n.growthHomeJourneySubtitle,
              leading: const HubLeadingIcon(AppIcons.path),
              onTap: () => context.pushNamed('growthJourneyPage'),
            ),
            CompactListTile(
              title: l10n.spiritualGrowthTitle,
              subtitle: l10n.spiritualGrowthShortcutSubtitle,
              leading: const HubLeadingIcon(AppIcons.spiritualGrowth),
              onTap: () => context.pushNamed('spiritualGrowthPage'),
            ),
            CompactListTile(
              title: l10n.growthTabReflection,
              subtitle: l10n.growthHomeReflectionSubtitle,
              leading: const HubLeadingIcon(AppIcons.reflection),
              onTap: () => context.pushNamed('growthReflectionPage'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        HubListGroup(
          title: l10n.growthGroupEnjoyTitle,
          children: [
            CompactListTile(
              title: l10n.gardenPageTitle,
              subtitle: l10n.gardenPageEntryHomeSubtitle,
              leading: const HubLeadingIcon(AppIcons.garden),
              onTap: () => context.pushNamed('gardenPage'),
            ),
            CompactListTile(
              title: l10n.oceanTitle,
              subtitle: l10n.oceanSubtitle,
              leading: const HubLeadingIcon(AppIcons.drops),
              onTap: () => context.pushNamed('oceanDrops'),
            ),
            CompactListTile(
              title: l10n.wallpaperLibraryTitle,
              subtitle: l10n.wallpaperLibrarySubtitle,
              leading: const HubLeadingIcon(AppIcons.wallpapers),
              onTap: () => context.pushNamed('wallpaperLibrary'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        HubListGroup(
          title: l10n.growthGroupConnectTitle,
          children: [
            CompactListTile(
              title: l10n.circlesTitle,
              subtitle: l10n.circlesSubtitle,
              leading: const HubLeadingIcon(AppIcons.community),
              trailing: HubNewBadge(label: l10n.hubNewBadgeLabel),
              onTap: () => context.pushNamed('circlesDiscovery'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        CompactListTile(
          title: l10n.growthHomeBrowseAllTitle,
          subtitle: l10n.growthHomeBrowseAllSubtitle,
          leading: const HubLeadingIcon(AppIcons.browseAll),
          onTap: () => context.pushNamed('growthBrowseAllPage'),
        ),
      ],
    );
  }
}

class _GrowthSuggestedSpiritualFocusSection extends ConsumerStatefulWidget {
  const _GrowthSuggestedSpiritualFocusSection();

  @override
  ConsumerState<_GrowthSuggestedSpiritualFocusSection> createState() =>
      _GrowthSuggestedSpiritualFocusSectionState();
}

class _GrowthSuggestedSpiritualFocusSectionState
    extends ConsumerState<_GrowthSuggestedSpiritualFocusSection> {
  String? _dismissedDateKey;

  @override
  Widget build(BuildContext context) {
    final quranBundle = ref.watch(
      quranPersonalizedRecommendationBundleProvider((
        QuranPersonalizationSurface.growth,
        false,
      )),
    );
    if (quranBundle == null) {
      return const SizedBox.shrink();
    }
    if (_dismissedDateKey == quranBundle.generatedDateKey) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        QuranPersonalizedRecommendationCard(
          bundle: quranBundle,
          surface: QuranPersonalizationSurface.growth,
          allowDismiss: true,
          onDismissed: () {
            if (!mounted) return;
            setState(() {
              _dismissedDateKey = quranBundle.generatedDateKey;
            });
          },
        ),
      ],
    );
  }
}

class _GrowthRecentActivityCard extends ConsumerWidget {
  const _GrowthRecentActivityCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rollups = ref.watch(
      growthStatisticsDashboardProvider.select(
        (dashboard) => dashboard.recentDailyRollups,
      ),
    );
    if (rollups.isEmpty) return const SizedBox.shrink();
    final recent = rollups.length <= 35
        ? rollups
        : rollups.sublist(rollups.length - 35);

    return PremiumCard(
      density: PremiumCardDensity.compact,
      leading: const Icon(Icons.calendar_view_month_rounded),
      title: Text(l10n.growthActivityHeatmapTitle),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.growthActivityHeatmapSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          ActivityHeatmap(
            values: recent
                .map((rollup) => rollup.dayScore)
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}
