import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/journey_stats_provider.dart';

class GrowthTrackingDashboardPage extends ConsumerWidget {
  const GrowthTrackingDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final percentFormat = NumberFormat.decimalPercentPattern(
      locale: locale,
      decimalDigits: 1,
    );
    final stats = ref.watch(journeyStatsSummaryProvider);

    return AppPageScaffold(
      headerIcon: Icons.query_stats_rounded,
      title: l10n.growthTrackingOverviewTitle,
      subtitle: l10n.growthTrackingOverviewSubtitle,
      children: [
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
                      Duration(
                        seconds: stats.totalTrackedWorshipGrowthSeconds,
                      ),
                    ),
                    detail: l10n.journeyStatsWorshipGrowthTimeSubtitle,
                  ),
                  _OverviewMetric(
                    label: l10n.journeyStatsTrackedShareTitle,
                    value: percentFormat.format(stats.trackedShareOfInstallTime),
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
                    value: countFormat.format(stats.totalAdhkarCompletedLifetime),
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
                l10n.growthTrackingDashboardsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _DashboardLink(
                title: l10n.growthHabitDashboardTitle,
                subtitle: l10n.growthHabitDashboardSubtitle,
                onTap: () => context.pushNamed('growthHabitDashboard'),
              ),
              const Divider(height: 18),
              _DashboardLink(
                title: l10n.growthOceanDashboardTitle,
                subtitle: l10n.growthOceanDashboardSubtitle,
                onTap: () => context.pushNamed('oceanDrops'),
              ),
              const Divider(height: 18),
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
      countFormat.format(safeDuration.inMinutes == 0 ? 0 : safeDuration.inMinutes),
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
    return Container(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EEE3),
        borderRadius: BorderRadius.circular(14),
      ),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
