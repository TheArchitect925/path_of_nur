import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/content/learning_quote.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import '../application/journey_stats_provider.dart';

class GrowthHomePage extends ConsumerWidget {
  const GrowthHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quote = buildGrowthReflectionQuote();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final percentFormat = NumberFormat.decimalPercentPattern(
      locale: locale,
      decimalDigits: 1,
    );
    final stats = ref.watch(journeyStatsSummaryProvider);

    return SectionHubScaffold(
      headerIcon: IslamicIcons.tasbih,
      title: l10n.journeyTitle,
      subtitle: l10n.growthHomeHeaderSubtitle,
      quote: quote,
      onQuoteTap: (selectedQuote) =>
          openQuranQuoteLocation(context, selectedQuote),
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      shortcutActions: [
        SectionShortcutAction(
          label: l10n.growthTrackingOverviewTitle,
          supportingText: l10n.growthTrackingOverviewSubtitle,
          icon: Icons.dashboard_customize_rounded,
          onTap: () => context.pushNamed('growthTrackingDashboard'),
        ),
        SectionShortcutAction(
          label: l10n.gardenPageTitle,
          supportingText: l10n.gardenPageEntryHomeSubtitle,
          icon: Icons.local_florist_rounded,
          onTap: () => context.pushNamed('gardenPage'),
        ),
        SectionShortcutAction(
          label: l10n.growthOceanDashboardTitle,
          supportingText: l10n.growthOceanDashboardSubtitle,
          icon: Icons.water_drop_rounded,
          onTap: () => context.pushNamed('oceanDrops'),
        ),
        SectionShortcutAction(
          label: l10n.spiritualGrowthTitle,
          supportingText: l10n.spiritualGrowthShortcutSubtitle,
          icon: Icons.self_improvement_rounded,
          onTap: () => context.pushNamed('spiritualGrowthPage'),
        ),
      ],
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
              title: l10n.growthHomeBrowseAllTitle,
              subtitle: l10n.growthHomeBrowseAllSubtitle,
              icon: Icons.grid_view_rounded,
              color: const Color(0xFFF4ECDF),
              accentColor: const Color(0xFF7C684B),
              onTap: () => context.pushNamed('growthPathsPage'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed('growthTrackingDashboard'),
            child: PremiumCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEADFC3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF7A6241),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.journeyStatsQuranReadingTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatReadingDuration(
                            l10n,
                            countFormat,
                            Duration(seconds: stats.totalQuranReadingSeconds),
                          ),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.growthHomeQuranTrackerSubtitle(
                            _formatReadingDuration(
                              l10n,
                              countFormat,
                              Duration(
                                seconds: stats.todayQuranReadingSeconds,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.growthHomeQuranListeningTrackerSubtitle(
                            _formatReadingDuration(
                              l10n,
                              countFormat,
                              Duration(
                                seconds: stats.totalQuranListeningSeconds,
                              ),
                            ),
                            _formatReadingDuration(
                              l10n,
                              countFormat,
                              Duration(
                                seconds: stats.todayQuranListeningSeconds,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6A5A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed('growthTrackingDashboard'),
            child: PremiumCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E1EE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.hourglass_bottom_rounded,
                      color: Color(0xFF6A5A8A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.journeyStatsTimeReflectionTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatReflectionDuration(
                            l10n,
                            countFormat,
                            Duration(
                              seconds: stats.totalTrackedWorshipGrowthSeconds,
                            ),
                          ),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.growthHomeTimeReflectionSubtitle(
                            _formatReflectionDuration(
                              l10n,
                              countFormat,
                              Duration(seconds: stats.timeSinceInstallSeconds),
                            ),
                            percentFormat.format(stats.trackedShareOfInstallTime),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed('growthTrackingDashboard'),
            child: PremiumCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E3D1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFF7A6241),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.journeyStatsTotalAdhkarCompletedTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          countFormat.format(
                            stats.totalAdhkarCompletedLifetime,
                          ),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.growthHomeTotalAdhkarCompletedSubtitle(
                            countFormat.format(
                              stats.totalPostSalahAdhkarCompleted,
                            ),
                            countFormat.format(stats.dhikrCompletedSessions),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.growthHomeDhikrTimeSubtitle(
                            _formatReadingDuration(
                              l10n,
                              countFormat,
                              Duration(seconds: stats.totalDhikrSeconds),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6A5A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
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
