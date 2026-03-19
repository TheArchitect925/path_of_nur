import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../learn/journey/application/learning_path_provider.dart';
import '../../learn/journey/domain/learning_path_models.dart';
import '../application/growth_providers.dart';
import '../drops/application/journey_drops_providers.dart';
import '../xp/application/journey_xp_providers.dart';

class GrowthTrackingDashboardPage extends ConsumerWidget {
  const GrowthTrackingDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final summary = ref.watch(homeDashboardSummaryProvider);
    final today = ref.watch(growthTodaySummaryProvider);
    final xp = ref.watch(journeyXpSummaryProvider);
    final drops = ref.watch(journeyDropSummaryProvider);
    final suggestions = _buildSuggestions(context, ref);

    return AppPageScaffold(
      headerIcon: Icons.dashboard_customize_rounded,
      title: l10n.growthTrackingOverviewTitle,
      subtitle: l10n.growthTrackingOverviewSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthTrackingOverviewTodayTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _OverviewMetric(
                    label: l10n.growthTrackingOverviewHabits,
                    value: countFormat.format(today.completedCount),
                    detail: l10n.growthTrackingOverviewHabitsDetail(
                      countFormat.format(today.dueCount),
                    ),
                  ),
                  _OverviewMetric(
                    label: l10n.homePrayerProgressTitle,
                    value: l10n.homeFractionValue(
                      countFormat.format(summary.worship.prayerCompleted),
                      countFormat.format(summary.worship.prayerTotal),
                    ),
                    detail: l10n.growthTrackingOverviewPrayerDetail,
                  ),
                  _OverviewMetric(
                    label: l10n.homeCurrentStreakTitle,
                    value: l10n.homeDaysCount(summary.journey.currentStreakDays),
                    detail: l10n.growthTrackingOverviewStreakDetail,
                  ),
                  _OverviewMetric(
                    label: l10n.homeXpLevelTitle,
                    value: l10n.homeLevelValue(
                      countFormat.format(xp.currentLevel),
                      countFormat.format(xp.currentLevel),
                    ),
                    detail: l10n.growthTrackingOverviewXpDetail(
                      countFormat.format(xp.totalXp),
                    ),
                  ),
                  _OverviewMetric(
                    label: l10n.oceanTitle,
                    value: countFormat.format(drops.totalDrops),
                    detail: l10n.growthTrackingOverviewDropsDetail,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (suggestions.isNotEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.growthTrackingSuggestionsTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...suggestions.map(
                  (suggestion) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(suggestion.title),
                      subtitle: Text(suggestion.subtitle),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: suggestion.onTap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (suggestions.isNotEmpty) const SizedBox(height: 14),
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

  List<_SuggestionItem> _buildSuggestions(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pathState = ref.watch(learningPathStateProvider);
    final suggestions = <_SuggestionItem>[];
    if (pathState == null) return suggestions;

    if (pathState.ageGroup == LearningAgeGroup.kids) {
      suggestions.add(
        _SuggestionItem(
          title: l10n.growthTrackingSuggestionKidsTitle,
          subtitle: l10n.growthTrackingSuggestionKidsSubtitle,
          onTap: () => context.pushNamed('learnJourneyHome'),
        ),
      );
    } else if (pathState.ageGroup == LearningAgeGroup.teens) {
      suggestions.add(
        _SuggestionItem(
          title: l10n.growthTrackingSuggestionTeensTitle,
          subtitle: l10n.growthTrackingSuggestionTeensSubtitle,
          onTap: () => context.pushNamed('growthHabitDashboard'),
        ),
      );
    }

    switch (pathState.path.level) {
      case LearningPathLevel.beginner:
        suggestions.add(
          _SuggestionItem(
            title: l10n.growthTrackingSuggestionBeginnerTitle,
            subtitle: l10n.growthTrackingSuggestionBeginnerSubtitle,
            onTap: () => context.pushNamed('learnJourneyHome'),
          ),
        );
        break;
      case LearningPathLevel.practicing:
        suggestions.add(
          _SuggestionItem(
            title: l10n.growthTrackingSuggestionPracticingTitle,
            subtitle: l10n.growthTrackingSuggestionPracticingSubtitle,
            onTap: () => context.pushNamed('growthHabitDashboard'),
          ),
        );
        break;
      case LearningPathLevel.seeker:
      case LearningPathLevel.advanced:
        suggestions.add(
          _SuggestionItem(
            title: l10n.growthTrackingSuggestionAdvancedTitle,
            subtitle: l10n.growthTrackingSuggestionAdvancedSubtitle,
            onTap: () => context.pushNamed('growthHabitCalendar'),
          ),
        );
        break;
    }
    return suggestions;
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
      constraints: const BoxConstraints(minWidth: 130),
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

class _SuggestionItem {
  const _SuggestionItem({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
}
