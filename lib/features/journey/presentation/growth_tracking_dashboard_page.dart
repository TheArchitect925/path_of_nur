import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/nav_tabs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/display/activity_heatmap.dart';
import '../../../shared/widgets/display/sparkline.dart';
import '../../../shared/widgets/display/stat_ring.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../ocean/application/ocean_drops_provider.dart';
import '../application/growth_statistics_provider.dart';
import '../application/growth_statistics_share_service.dart';
import '../application/journey_stats_provider.dart';
import '../drops/application/journey_drops_providers.dart';
import 'growth_statistics_localizations.dart';

class GrowthTrackingDashboardPage extends ConsumerWidget {
  const GrowthTrackingDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final percentFormat = NumberFormat.decimalPercentPattern(
      locale: locale,
      decimalDigits: 0,
    );
    final dateFormat = DateFormat.MMMd(locale);
    final longDateFormat = DateFormat.yMMMd(locale);
    final stats = ref.watch(journeyStatsSummaryProvider);
    final dashboard = ref.watch(growthStatisticsDashboardProvider);
    final dropSummary = ref.watch(journeyDropSummaryProvider);
    final oceanState = ref.watch(oceanDropsProvider);
    final shareService = ref.watch(growthStatisticsShareServiceProvider);

    Future<void> shareWeekly() {
      return shareService.shareText(
        shareService.buildWeeklySummaryShareText(
          localeTag: locale,
          dashboard: dashboard,
        ),
      );
    }

    Future<void> shareMonthly() {
      return shareService.shareText(
        shareService.buildMonthlySummaryShareText(
          localeTag: locale,
          dashboard: dashboard,
        ),
      );
    }

    Future<void> shareSnapshot() {
      return shareService.shareText(
        shareService.buildSnapshotShareText(
          localeTag: locale,
          dashboard: dashboard,
        ),
      );
    }

    return AppPageScaffold(
      headerIcon: Icons.query_stats_rounded,
      title: l10n.growthStatisticsTitleText,
      subtitle: l10n.growthStatisticsSubtitleText,
      children: [
        PremiumCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatRing(
                value: dashboard.weeklySummary.prayersCompleted / 35,
                label:
                    '${countFormat.format(dashboard.weeklySummary.prayersCompleted)}/${countFormat.format(35)}',
                caption: l10n.growthStatisticsPrayersLabelText,
              ),
              StatRing(
                value: dashboard.weeklySummary.activeDays / 7,
                label:
                    '${countFormat.format(dashboard.weeklySummary.activeDays)}/${countFormat.format(7)}',
                caption: l10n.growthStatisticsActiveDaysLabelText,
              ),
              StatRing(
                value: dashboard.weeklySummary.averageDayScore.clamp(0, 1),
                label: percentFormat.format(
                  dashboard.weeklySummary.averageDayScore.clamp(0, 1),
                ),
                caption: l10n.growthStatisticsConsistencyLabelText,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _HighlightMetricCard(
              label: l10n.journeyStatsQuranReadingTitle,
              value: _formatReadingDuration(
                l10n,
                countFormat,
                Duration(seconds: stats.totalQuranReadingSeconds),
              ),
              detail: l10n.growthHomeQuranTrackerSubtitle(
                _formatReadingDuration(
                  l10n,
                  countFormat,
                  Duration(seconds: stats.todayQuranReadingSeconds),
                ),
              ),
            ),
            _HighlightMetricCard(
              label: l10n.journeyStatsTimeReflectionTitle,
              value: _formatReflectionDuration(
                l10n,
                countFormat,
                Duration(seconds: stats.totalTrackedWorshipGrowthSeconds),
              ),
              detail: l10n.growthHomeTimeReflectionSubtitle(
                _formatReflectionDuration(
                  l10n,
                  countFormat,
                  Duration(seconds: stats.timeSinceInstallSeconds),
                ),
                percentFormat.format(stats.trackedShareOfInstallTime),
              ),
            ),
            _HighlightMetricCard(
              label: l10n.journeyStatsTotalAdhkarCompletedTitle,
              value: countFormat.format(stats.totalAdhkarCompletedLifetime),
              detail: l10n.growthHomeTotalAdhkarCompletedSubtitle(
                countFormat.format(stats.totalPostSalahAdhkarCompleted),
                countFormat.format(stats.dhikrCompletedSessions),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _SectionIntro(
          title: l10n.growthStatisticsSummaryTitleText,
          subtitle: l10n.growthStatisticsSummarySubtitleText,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SummaryPeriodCard(
              title: l10n.growthJourneyWeeklySummaryTitle,
              rangeLabel: l10n.growthStatisticsPeriodDateRangeText(
                dateFormat.format(dashboard.weeklySummary.start),
                dateFormat.format(dashboard.weeklySummary.end),
              ),
              summary: dashboard.weeklySummary,
              comparison: dashboard.previousWeeklySummary,
              l10n: l10n,
              countFormat: countFormat,
              percentFormat: percentFormat,
            ),
            _SummaryPeriodCard(
              title: l10n.growthStatisticsMonthlySummaryTitleText,
              rangeLabel: l10n.growthStatisticsPeriodDateRangeText(
                dateFormat.format(dashboard.monthlySummary.start),
                dateFormat.format(dashboard.monthlySummary.end),
              ),
              summary: dashboard.monthlySummary,
              comparison: dashboard.previousMonthlySummary,
              l10n: l10n,
              countFormat: countFormat,
              percentFormat: percentFormat,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _SectionIntro(
          title: l10n.growthStatisticsTrendsTitleText,
          subtitle: l10n.growthStatisticsTrendsSubtitleText,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _TrendChartCard(
              title: l10n.growthStatisticsWeeklyTrendTitleText,
              subtitle: l10n.growthStatisticsWeeklyTrendSubtitleText,
              points: dashboard.weeklyTrend,
              labelBuilder: (point) => DateFormat.E(locale).format(point.start),
              detailBuilder: (point) {
                return '${countFormat.format(point.prayersCompleted)} ${l10n.growthStatisticsPrayersLabelText.toLowerCase()} • '
                    '${countFormat.format(point.dhikrCount)} ${l10n.growthStatisticsAdhkarLabelText.toLowerCase()}';
              },
              emptyLabel: l10n.growthStatisticsEmptyTrendText,
            ),
            _TrendChartCard(
              title: l10n.growthStatisticsMonthlyTrendTitleText,
              subtitle: l10n.growthStatisticsMonthlyTrendSubtitleText,
              points: dashboard.monthlyTrend,
              labelBuilder: (point) =>
                  '${DateFormat.MMMd(locale).format(point.start)}\n${DateFormat.MMMd(locale).format(point.end)}',
              detailBuilder: (point) {
                return '${countFormat.format(point.xpGained)} ${l10n.growthStatisticsXpLabelText} • '
                    '${countFormat.format(point.dropsGained)} ${l10n.growthStatisticsDropsLabelText.toLowerCase()}';
              },
              emptyLabel: l10n.growthStatisticsEmptyTrendText,
            ),
          ],
        ),
        const SizedBox(height: 14),
        PremiumCard(
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
                values: dashboard.recentDailyRollups
                    .map((rollup) => rollup.dayScore)
                    .toList(growable: false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SectionIntro(
          title: l10n.growthStatisticsInsightsTitleText,
          subtitle: l10n.growthStatisticsInsightsSubtitleText,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _InsightCard(
              title: l10n.growthStatisticsBestDayTitleText,
              body: dashboard.bestDay == null
                  ? l10n.growthStatisticsBestDayEmptyText
                  : l10n.growthStatisticsBestDayBodyText(
                      longDateFormat.format(dashboard.bestDay!.day),
                      countFormat.format(dashboard.bestDay!.prayersCompleted),
                      countFormat.format(dashboard.bestDay!.dhikrCount),
                      _formatReadingDuration(
                        l10n,
                        countFormat,
                        Duration(seconds: dashboard.bestDay!.quranSeconds),
                      ),
                      countFormat.format(dashboard.bestDay!.xpGained),
                      countFormat.format(dashboard.bestDay!.dropsGained),
                    ),
              footer: dashboard.bestDay == null
                  ? null
                  : l10n.growthStatisticsBestDayReasonPrefixText,
              icon: Icons.workspace_premium_rounded,
            ),
            _InsightCard(
              title: l10n.growthStatisticsRewardsInsightsTitleText,
              body: dashboard.rewardsInsight.hasAnyRewardSignal
                  ? l10n.growthStatisticsRewardsBodyText(
                      countFormat.format(dashboard.rewardsInsight.weeklyXp),
                      countFormat.format(dashboard.rewardsInsight.weeklyDrops),
                      l10n.localizedRewardSourceLabel(
                        dashboard.rewardsInsight.topXpModule,
                      ),
                      l10n.localizedDropSourceLabel(
                        dashboard.rewardsInsight.topDropSource,
                      ),
                    )
                  : l10n.growthStatisticsRewardsInsightsEmptyText,
              footer: dashboard.rewardsInsight.hasAnyRewardSignal
                  ? '${countFormat.format(dashboard.rewardsInsight.topXpValue)} ${l10n.growthStatisticsXpLabelText} • '
                        '${countFormat.format(dashboard.rewardsInsight.topDropValue)} ${l10n.growthStatisticsDropsLabelText.toLowerCase()}'
                  : null,
              icon: Icons.auto_awesome_rounded,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _SectionIntro(
          title: l10n.growthStatisticsReportsTitleText,
          subtitle: l10n.growthStatisticsReportsSubtitleText,
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _ReportCard(
                    title: l10n.growthJourneyWeeklySummaryTitle,
                    body: _buildReportBody(
                      l10n: l10n,
                      summary: dashboard.weeklySummary,
                      countFormat: countFormat,
                    ),
                  ),
                  _ReportCard(
                    title: l10n.growthStatisticsMonthlySummaryTitleText,
                    body: _buildReportBody(
                      l10n: l10n,
                      summary: dashboard.monthlySummary,
                      countFormat: countFormat,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: shareWeekly,
                    icon: const Icon(Icons.ios_share_rounded),
                    label: Text(l10n.growthStatisticsShareWeeklyActionText),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: shareMonthly,
                    icon: const Icon(Icons.share_outlined),
                    label: Text(l10n.growthStatisticsShareMonthlyActionText),
                  ),
                  OutlinedButton.icon(
                    onPressed: shareSnapshot,
                    icon: const Icon(Icons.summarize_rounded),
                    label: Text(l10n.growthStatisticsShareSnapshotActionText),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.journeyStatsQuranReadingTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                _formatReadingDuration(
                  l10n,
                  countFormat,
                  Duration(seconds: stats.totalQuranReadingSeconds),
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.journeyStatsQuranReadingSubtitle(
                  _formatReadingDuration(
                    l10n,
                    countFormat,
                    Duration(seconds: stats.todayQuranReadingSeconds),
                  ),
                  countFormat.format(stats.totalQuranReadingSessions),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.journeyStatsQuranListeningSubtitle(
                  _formatReadingDuration(
                    l10n,
                    countFormat,
                    Duration(seconds: stats.todayQuranListeningSeconds),
                  ),
                  countFormat.format(stats.totalQuranListeningSessions),
                ),
                style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthTrackingOverviewTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthTrackingOverviewSubtitle,
                style: const TextStyle(color: Color(0xFF6A5A4A)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _OverviewMetric(
                    label: l10n.journeyStatsActiveDaysTitle,
                    value: countFormat.format(stats.activeDays),
                    detail: l10n.journeyStatsActiveDaysSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsCurrentStreakTitle,
                    value: l10n.homeDaysCount(stats.currentStreakDays),
                    detail: l10n.journeyStatsCurrentStreakSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsBestStreakTitle,
                    value: l10n.homeDaysCount(stats.bestStreakDays),
                    detail: l10n.journeyStatsBestStreakSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsLessonsCompletedTitle,
                    value: countFormat.format(stats.lessonsCompleted),
                    detail: l10n.journeyStatsLessonsCompletedSubtitle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('growthJourneyPage'),
                icon: const Icon(Icons.route_rounded),
                label: Text(l10n.growthStatisticsOpenJourneyActionText),
              ),
              const SizedBox(height: 10),
              _DashboardLink(
                title: l10n.growthHabitDashboardTitle,
                subtitle: l10n.growthHabitDashboardSubtitle,
                onTap: () => context.pushNamed('growthHabitDashboard'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.journeyStatsTimeReflectionTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.journeyStatsTimeReflectionSubtitle,
                style: const TextStyle(color: Color(0xFF6A5A4A)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _OverviewMetric(
                    label: l10n.journeyStatsTimeSinceInstallTitle,
                    value: _formatReflectionDuration(
                      l10n,
                      countFormat,
                      Duration(seconds: stats.timeSinceInstallSeconds),
                    ),
                    detail: l10n.journeyStatsTimeSinceInstallSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsWorshipGrowthTimeTitle,
                    value: _formatReflectionDuration(
                      l10n,
                      countFormat,
                      Duration(seconds: stats.totalTrackedWorshipGrowthSeconds),
                    ),
                    detail: l10n.journeyStatsWorshipGrowthTimeSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsTrackedShareTitle,
                    value: percentFormat.format(
                      stats.trackedShareOfInstallTime,
                    ),
                    detail: l10n.journeyStatsTrackedShareSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsOtherTimeTitle,
                    value: _formatReflectionDuration(
                      l10n,
                      countFormat,
                      Duration(seconds: stats.otherUntrackedSeconds),
                    ),
                    detail: l10n.journeyStatsOtherTimeSubtitle,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.journeyStatsTimeReflectionHelper,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.journeyStatsMetricsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _OverviewMetric(
                    label: l10n.journeyStatsSalahOfferedTitle,
                    value: countFormat.format(stats.totalSalahOffered),
                    detail: l10n.journeyStatsSalahOfferedSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsTotalAdhkarCompletedTitle,
                    value: countFormat.format(
                      stats.totalAdhkarCompletedLifetime,
                    ),
                    detail: l10n.journeyStatsTotalAdhkarCompletedSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsPostSalahAdhkarTitle,
                    value: countFormat.format(
                      stats.totalPostSalahAdhkarCompleted,
                    ),
                    detail: l10n.journeyStatsPostSalahAdhkarSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsQuranTimeTitle,
                    value: _formatReadingDuration(
                      l10n,
                      countFormat,
                      Duration(seconds: stats.totalQuranReadingSeconds),
                    ),
                    detail: l10n.journeyStatsQuranTimeSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsQuranListeningTimeTitle,
                    value: _formatReadingDuration(
                      l10n,
                      countFormat,
                      Duration(seconds: stats.totalQuranListeningSeconds),
                    ),
                    detail: l10n.journeyStatsQuranListeningTimeSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsDhikrCompletedTitle,
                    value: countFormat.format(stats.dhikrCompletedSessions),
                    detail: l10n.journeyStatsDhikrCompletedSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsDhikrTimeTitle,
                    value: _formatReadingDuration(
                      l10n,
                      countFormat,
                      Duration(seconds: stats.totalDhikrSeconds),
                    ),
                    detail: l10n.journeyStatsDhikrTimeSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsLessonsCompletedTitle,
                    value: countFormat.format(stats.lessonsCompleted),
                    detail: l10n.journeyStatsLessonsCompletedSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsActiveDaysTitle,
                    value: countFormat.format(stats.activeDays),
                    detail: l10n.journeyStatsActiveDaysSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsCurrentStreakTitle,
                    value: l10n.homeDaysCount(stats.currentStreakDays),
                    detail: l10n.journeyStatsCurrentStreakSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsBestStreakTitle,
                    value: l10n.homeDaysCount(stats.bestStreakDays),
                    detail: l10n.journeyStatsBestStreakSubtitle,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthOceanDashboardTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthOceanDashboardSubtitle,
                style: const TextStyle(color: Color(0xFF6A5A4A)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _OverviewMetric(
                    label: l10n.growthOceanDashboardYourDrops,
                    value: countFormat.format(dropSummary.totalDrops),
                    detail: l10n.growthOceanDashboardSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.growthOceanDashboardToday,
                    value: countFormat.format(dropSummary.todayDrops),
                    detail: l10n.growthTodaySummaryTitle,
                  ),
                  _OverviewMetric(
                    label: l10n.growthOceanDashboardCommunity,
                    value: oceanState.totalCommunityDrops.toString(),
                    detail: l10n.oceanTitle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('oceanDrops'),
                icon: const Icon(Icons.water_drop_rounded),
                label: Text(l10n.growthOceanDashboardTitle),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('oceanCommunityDetails'),
                icon: const Icon(Icons.waves_rounded),
                label: Text(l10n.growthOceanDashboardOpenCommunity),
              ),
              const SizedBox(height: 10),
              _DashboardLink(
                title: l10n.homePrayerProgressTitle,
                subtitle: l10n.growthTrackingPrayerDashboardSubtitle,
                onTap: () => goToTab(context, NavTab.worship),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buildReportBody({
    required AppLocalizations l10n,
    required GrowthStatsPeriodSummary summary,
    required NumberFormat countFormat,
  }) {
    return '${countFormat.format(summary.prayersCompleted)} ${l10n.growthStatisticsPrayersLabelText.toLowerCase()} • '
        '${countFormat.format(summary.dhikrCount)} ${l10n.growthStatisticsAdhkarLabelText.toLowerCase()} • '
        '${countFormat.format(summary.xpGained)} ${l10n.growthStatisticsXpLabelText}';
  }

  String _formatReadingDuration(
    AppLocalizations l10n,
    NumberFormat countFormat,
    Duration duration,
  ) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours;
    final minutes = safeDuration.inMinutes.remainder(60);
    if (hours > 0) {
      return l10n.homeDurationHoursMinutes(
        countFormat.format(hours),
        countFormat.format(minutes),
      );
    }
    return l10n.journeyStatsMinutesValue(
      countFormat.format(
        safeDuration.inMinutes == 0 ? 0 : safeDuration.inMinutes,
      ),
    );
  }

  String _formatReflectionDuration(
    AppLocalizations l10n,
    NumberFormat countFormat,
    Duration duration,
  ) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final days = safeDuration.inDays;
    if (days > 0) {
      final hours = safeDuration.inHours.remainder(24);
      return l10n.journeyStatsDaysHoursValue(
        countFormat.format(days),
        countFormat.format(hours),
      );
    }
    return _formatReadingDuration(l10n, countFormat, safeDuration);
  }
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Color(0xFF6A5A4A))),
      ],
    );
  }
}

class _SummaryPeriodCard extends StatelessWidget {
  const _SummaryPeriodCard({
    required this.title,
    required this.rangeLabel,
    required this.summary,
    required this.comparison,
    required this.l10n,
    required this.countFormat,
    required this.percentFormat,
  });

  final String title;
  final String rangeLabel;
  final GrowthStatsPeriodSummary summary;
  final GrowthStatsPeriodSummary? comparison;
  final AppLocalizations l10n;
  final NumberFormat countFormat;
  final NumberFormat percentFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 380),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              rangeLabel,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _MiniMetric(
                  label: l10n.growthStatisticsPrayersLabelText,
                  value: countFormat.format(summary.prayersCompleted),
                ),
                _MiniMetric(
                  label: l10n.growthStatisticsAdhkarLabelText,
                  value: countFormat.format(summary.dhikrCount),
                ),
                _MiniMetric(
                  label: l10n.growthStatisticsQuranLabelText,
                  value:
                      '${countFormat.format(Duration(seconds: summary.quranSeconds).inMinutes)} min',
                ),
                _MiniMetric(
                  label: l10n.growthStatisticsXpLabelText,
                  value: countFormat.format(summary.xpGained),
                ),
                _MiniMetric(
                  label: l10n.growthStatisticsDropsLabelText,
                  value: countFormat.format(summary.dropsGained),
                ),
                _MiniMetric(
                  label: l10n.growthStatisticsActiveDaysLabelText,
                  value: countFormat.format(summary.activeDays),
                ),
                _MiniMetric(
                  label: l10n.growthStatisticsConsistencyLabelText,
                  value: percentFormat.format(
                    summary.averageDayScore.clamp(0, 1),
                  ),
                ),
              ],
            ),
            if (comparison != null) ...[
              const SizedBox(height: 10),
              Text(
                l10n.growthStatisticsWeeklyChangeText(
                  l10n.growthStatisticsComparisonSummaryText(
                    summary,
                    comparison!,
                  ),
                ),
                style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TrendChartCard extends StatelessWidget {
  const _TrendChartCard({
    required this.title,
    required this.subtitle,
    required this.points,
    required this.labelBuilder,
    required this.detailBuilder,
    required this.emptyLabel,
  });

  final String title;
  final String subtitle;
  final List<GrowthStatsChartPoint> points;
  final String Function(GrowthStatsChartPoint point) labelBuilder;
  final String Function(GrowthStatsChartPoint point) detailBuilder;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final hasData = points.any((point) => point.value > 0);
    final peakPoint = peak;

    return Container(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
            ),
            const SizedBox(height: 12),
            if (!hasData)
              Text(emptyLabel, style: const TextStyle(color: Color(0xFF6A5A4A)))
            else ...[
              Sparkline(
                values: points
                    .map((point) => point.value)
                    .toList(growable: false),
                height: 72,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final point in points)
                    Text(
                      labelBuilder(point),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.5,
                      ),
                    ),
                ],
              ),
              if (peakPoint != null) ...[
                const SizedBox(height: 8),
                Text(
                  detailBuilder(peakPoint),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  GrowthStatsChartPoint? get peak {
    GrowthStatsChartPoint? best;
    for (final point in points) {
      if (point.value <= 0) continue;
      if (best == null || point.value > best.value) best = point;
    }
    return best;
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.body,
    required this.icon,
    this.footer,
  });

  final String title;
  final String body;
  final IconData icon;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFC98E44)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(body),
            if (footer != null) ...[
              const SizedBox(height: 8),
              Text(
                footer!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return Container(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
      padding: const EdgeInsets.all(12),
      decoration: style.decoration(radius: 14, includeShadow: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: Color(0xFF6A5A4A))),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return Container(
      constraints: const BoxConstraints(minWidth: 92, maxWidth: 120),
      padding: const EdgeInsets.all(10),
      decoration: style.decoration(radius: 12, includeShadow: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6A5A4A)),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _HighlightMetricCard extends StatelessWidget {
  const _HighlightMetricCard({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: AppColors.accentGoldSoft,
    );
    return Container(
      constraints: const BoxConstraints(minWidth: 170, maxWidth: 240),
      padding: const EdgeInsets.all(14),
      decoration: style.decoration(radius: 16, includeShadow: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return Container(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
      padding: const EdgeInsets.all(12),
      decoration: style.decoration(radius: 14, includeShadow: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            detail,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
          ),
        ],
      ),
    );
  }
}

class _DashboardLink extends StatelessWidget {
  const _DashboardLink({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: style.decoration(radius: 14, includeShadow: false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
            ),
          ],
        ),
      ),
    );
  }
}
