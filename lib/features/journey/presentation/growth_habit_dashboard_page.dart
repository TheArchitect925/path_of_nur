import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/growth_providers.dart';
import '../xp/presentation/widgets/journey_xp_progress_card.dart';

class GrowthHabitDashboardPage extends ConsumerWidget {
  const GrowthHabitDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final todaySummary = ref.watch(growthTodaySummaryProvider);
    final enabledHabits = ref.watch(growthEnabledHabitsProvider);
    final dueHabits = ref.watch(growthDueHabitsForSelectedDateProvider);
    final customHabits = enabledHabits.where((habit) => habit.isCustom).length;
    final categories = ref.watch(growthCustomHabitCategoriesProvider);

    return AppPageScaffold(
      headerIcon: Icons.checklist_rtl_rounded,
      title: l10n.growthHabitDashboardTitle,
      subtitle: l10n.growthHabitDashboardSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHabitDashboardSummaryTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _SummaryTile(
                    label: l10n.growthHabitDashboardEnabledHabits,
                    value: countFormat.format(enabledHabits.length),
                  ),
                  _SummaryTile(
                    label: l10n.growthHabitDashboardDueToday,
                    value: countFormat.format(dueHabits.length),
                  ),
                  _SummaryTile(
                    label: l10n.growthHabitDashboardCustomHabits,
                    value: countFormat.format(customHabits),
                  ),
                  _SummaryTile(
                    label: l10n.growthHabitDashboardCustomCategories,
                    value: countFormat.format(categories.length),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.growthHabitDashboardCompletionSummary(
                  countFormat.format(todaySummary.completedCount),
                  countFormat.format(todaySummary.dueCount),
                ),
                style: const TextStyle(color: Color(0xFF6A5A4A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const JourneyXpProgressCard(),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHabitDashboardActionsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('growthHabitsPage'),
                icon: const Icon(Icons.playlist_add_check_circle_rounded),
                label: Text(l10n.growthHabitDashboardOpenTracker),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('growthHabitCalendar'),
                icon: const Icon(Icons.calendar_month_rounded),
                label: Text(l10n.growthTrackingCalendarTitle),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('growthHabitSettings'),
                icon: const Icon(Icons.tune_rounded),
                label: Text(l10n.growthHabitSettingsTitle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
