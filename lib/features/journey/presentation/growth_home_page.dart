import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../learn/quran/application/quran_personalization_provider.dart';
import '../../learn/quran/domain/quran_personalization_models.dart';
import '../../learn/quran/presentation/widgets/quran_personalized_recommendation_card.dart';
import '../../../shared/content/learning_quote.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/display/activity_heatmap.dart';
import '../../../shared/widgets/display/progress_bar.dart';
import '../../../shared/widgets/main_page_search_launcher.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import '../application/growth_statistics_provider.dart';
import '../application/journey_progression_provider.dart';

class GrowthHomePage extends ConsumerWidget {
  const GrowthHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quote = buildGrowthReflectionQuote();
    final snapshot = ref.watch(journeyActivitySnapshotProvider);
    final progress = ref.watch(journeyComputedProgressProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final percentFormat = NumberFormat.decimalPercentPattern(
      locale: locale,
      decimalDigits: 0,
    );

    return SectionHubScaffold(
      ownsBackground: false,
      headerIcon: IslamicIcons.tasbih,
      title: l10n.journeyTitle,
      subtitle: l10n.growthHomeHeaderSubtitle,
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      children: [
        QuranQuoteBlock(
          quote: quote,
          onTap: () => openQuranQuoteLocation(context, quote),
        ),
        const SizedBox(height: 12),
        const MainPageSearchLauncher(),
        const _GrowthSuggestedSpiritualFocusSection(),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHomeJourneyDepthTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(l10n.growthHomeJourneyDepthSubtitle),
              const SizedBox(height: 12),
              _GrowthProgressMetricRow(
                label: l10n.growthHomeJourneyDepthPrayerLabel,
                value: snapshot.prayerProgress,
                percentLabel: percentFormat.format(snapshot.prayerProgress),
              ),
              const SizedBox(height: 8),
              _GrowthProgressMetricRow(
                label: l10n.growthHomeJourneyDepthDhikrLabel,
                value: snapshot.dhikrProgress,
                percentLabel: percentFormat.format(snapshot.dhikrProgress),
              ),
              const SizedBox(height: 8),
              _GrowthProgressMetricRow(
                label: l10n.growthHomeJourneyDepthQuranLabel,
                value: snapshot.quranProgress,
                percentLabel: percentFormat.format(snapshot.quranProgress),
              ),
              const SizedBox(height: 8),
              _GrowthProgressMetricRow(
                label: l10n.growthHomeJourneyDepthReflectionLabel,
                value: snapshot.reflectionProgress,
                percentLabel: percentFormat.format(snapshot.reflectionProgress),
              ),
              const SizedBox(height: 8),
              _GrowthProgressMetricRow(
                label: l10n.growthHomeJourneyDepthFastingLabel,
                value: snapshot.fastingProgress,
                percentLabel: percentFormat.format(snapshot.fastingProgress),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.growthHomeJourneyDepthSummary(
                  percentFormat.format(snapshot.dailyCompletionScore),
                  '${progress.currentStreakDays}',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _GrowthActionButton(
                    onPressed: () => context.pushNamed('growthStatisticsPage'),
                    icon: Icons.query_stats_rounded,
                    label: l10n.growthHomeJourneyDepthOpenStatistics,
                  ),
                  _GrowthActionButton(
                    onPressed: () => context.pushNamed('gardenPage'),
                    icon: Icons.local_florist_rounded,
                    label: l10n.growthHomeJourneyDepthOpenGarden,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _GrowthRecentActivityCard(),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _GrowthFeatureCard(
              title: l10n.growthStatisticsTitle,
              subtitle: l10n.growthHomeFeaturedStatisticsSubtitle,
              icon: Icons.query_stats_rounded,
              actionLabel: l10n.growthHomeFeaturedStatisticsAction,
              onTap: () => context.pushNamed('growthStatisticsPage'),
            ),
            _GrowthFeatureCard(
              title: l10n.gardenPageTitle,
              subtitle: l10n.growthHomeFeaturedGardenSubtitle,
              icon: Icons.local_florist_rounded,
              actionLabel: l10n.growthHomeFeaturedGardenAction,
              onTap: () => context.pushNamed('gardenPage'),
            ),
          ],
        ),
        const SizedBox(height: 12),
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

class _GrowthProgressMetricRow extends StatelessWidget {
  const _GrowthProgressMetricRow({
    required this.label,
    required this.value,
    required this.percentLabel,
  });

  final String label;
  final double value;
  final String percentLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ProgressBar(value: value),
        ),
        const SizedBox(width: 10),
        Text(
          percentLabel,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _GrowthFeatureCard extends StatelessWidget {
  const _GrowthFeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return SizedBox(
      width: 320,
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: iconStyle.decoration(
                    radius: 14,
                    includeShadow: false,
                  ),
                  child: Icon(icon),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: _GrowthActionButton(
                onPressed: onTap,
                icon: Icons.arrow_forward_rounded,
                label: actionLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrowthActionButton extends StatelessWidget {
  const _GrowthActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Five-week personal activity heatmap for the Journey root. Private by
/// design: it shows only the user's own rhythm, never comparisons.
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
