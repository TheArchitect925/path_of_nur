import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/content/learning_quote.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthHabitsPage extends ConsumerWidget {
  const GrowthHabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedDate = ref.watch(growthSelectedDateProvider);
    final seasonal = ref.watch(growthSeasonalContextProvider);
    final ramadanDashboard = ref.watch(growthRamadanDashboardProvider);
    final quranTracker = ref.watch(growthRamadanQuranTrackerProvider);
    final fastTracking = ref.watch(growthFastTrackingProvider);
    final summary = ref.watch(growthTodaySummaryProvider);
    final sections = ref.watch(growthDueHabitSectionsProvider);
    final logs = ref.watch(growthLogsForSelectedDateProvider);
    final endOfDay = ref.watch(growthEndOfDaySummaryProvider);
    final encouragement = ref.watch(growthEncouragementCopyProvider);

    return SectionHubScaffold(
      headerIcon: Icons.checklist_rtl_rounded,
      title: l10n.growthTodayHabitTrackerTitle,
      subtitle: l10n.growthHabitsPageSubtitle,
      quote: buildGrowthReflectionQuote(),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      shortcutActions: [
        SectionShortcutAction(
          label: l10n.growthTrackingOverviewTitle,
          supportingText: l10n.growthTrackingOverviewSubtitle,
          icon: Icons.dashboard_customize_rounded,
          onTap: () => context.pushNamed('growthStatisticsPage'),
        ),
        SectionShortcutAction(
          label: l10n.growthTrackingCalendarTitle,
          supportingText: l10n.growthTrackingCalendarSubtitle,
          icon: Icons.calendar_month_rounded,
          onTap: () => context.pushNamed('growthHabitCalendar'),
        ),
        SectionShortcutAction(
          label: l10n.growthHabitSettingsTitle,
          supportingText: l10n.growthHabitSettingsSubtitle,
          icon: Icons.tune_rounded,
          onTap: () => context.pushNamed('growthHabitSettings'),
        ),
      ],
      children: [
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index - 3));
              final isSelected = _isSameDate(date, selectedDate);
              return ChoiceChip(
                selected: isSelected,
                label: Text(growthDateLabel(date)),
                onSelected: (_) =>
                    ref.read(growthSelectedDateProvider.notifier).state = date,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Row(
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: summary.completionProgress,
                      strokeWidth: 7,
                    ),
                    Center(
                      child: Text(
                        l10n.growthPercentValue(
                          '${(summary.completionProgress * 100).round()}',
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.growthHabitsSummaryTitle,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.growthTodayCompletedSummary(
                        '${summary.completedCount}',
                        '${summary.dueCount}',
                      ),
                    ),
                    if (summary.partialCount > 0)
                      Text(
                        l10n.growthTodayInProgressSummary(summary.partialCount),
                      ),
                    Text(
                      l10n.growthTodayLightAdded(
                        '${summary.visibleLightEarnedToday}',
                      ),
                    ),
                    if (summary.subtleLightEarnedToday >
                        summary.visibleLightEarnedToday)
                      Text(
                        l10n.growthTodayQuietProgressNote,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6A5A4A),
                        ),
                      ),
                    Text(
                      l10n.growthTodaySteadyDaysSummary(
                        '${summary.currentStreakDays}',
                        '${summary.bestStreakDays}',
                      ),
                    ),
                    Text(
                      summary.completedCount > 0
                          ? encouragement.completion[(selectedDate.day +
                                    selectedDate.month) %
                                encouragement.completion.length]
                          : encouragement.returning[(selectedDate.day +
                                    selectedDate.month) %
                                encouragement.returning.length],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6A5A4A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (ramadanDashboard != null) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seasonal.isRamadanMode
                      ? l10n.growthHabitsRamadanTrackingTitle
                      : l10n.growthHabitsSeasonalTrackingTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(ramadanDashboard.progressLabel),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: ramadanDashboard.dailyProgress,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _seasonalPill(
                      l10n.growthHabitsSeasonalPillFast,
                      ramadanDashboard.fastCompleted,
                    ),
                    _seasonalPill(
                      l10n.growthHabitsSeasonalPillQuran,
                      ramadanDashboard.quranHabitCompleted,
                    ),
                    _seasonalPill(
                      l10n.growthHabitsSeasonalPillCharity,
                      ramadanDashboard.charityCompleted,
                    ),
                    _seasonalPill(
                      l10n.growthTabReflection,
                      ramadanDashboard.reflectionCompleted,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(l10n.growthHabitsQuranCompletionPlan),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: quranTracker.planDays,
                      items: const [30, 15, 10]
                          .map(
                            (days) => DropdownMenuItem(
                              value: days,
                              child: Text(l10n.homeDaysCount(days)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        ref
                            .read(growthControllerProvider.notifier)
                            .setRamadanQuranPlanDays(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.growthHabitsJuzJourneySummary(
                    quranTracker.currentJuzProgress.toStringAsFixed(1),
                    quranTracker.remainingJuz.toStringAsFixed(1),
                  ),
                ),
                Text(
                  l10n.growthHabitsGentlePaceSummary(
                    quranTracker.estimatedDailyJuzNeeded.toStringAsFixed(2),
                    '${quranTracker.estimatedDaysRemaining}',
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A5A4A),
                  ),
                ),
                Slider(
                  value: quranTracker.currentJuzProgress,
                  min: 0,
                  max: 30,
                  divisions: 60,
                  label: quranTracker.currentJuzProgress.toStringAsFixed(1),
                  onChanged: (value) => ref
                      .read(growthControllerProvider.notifier)
                      .setRamadanQuranCompletedJuz(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHabitsFastTrackingTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthHabitsRecommendedValue(
                  _fastTypeLabel(fastTracking.recommendedType, l10n),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: fastTracking.availableTypes
                    .map(
                      (type) => ChoiceChip(
                        selected: type == fastTracking.selectedType,
                        label: Text(_fastTypeLabel(type, l10n)),
                        onSelected: (_) => ref
                            .read(growthControllerProvider.notifier)
                            .setFastTrackTypeForDay(
                              date: selectedDate,
                              type: type,
                            ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        final habitId = fastTracking.habitIdForToday;
                        if (habitId == null) return;
                        ref
                            .read(growthControllerProvider.notifier)
                            .toggleCompleted(
                              date: selectedDate,
                              habitId: habitId,
                            );
                      },
                      child: Text(
                        fastTracking.completedToday
                            ? l10n.growthHabitsFastNotedToday
                            : l10n.growthHabitsNoteTodaysFast,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (sections.isEmpty)
          PremiumCard(child: Text(l10n.growthHabitsNoHabitsDue)),
        ...sections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (section.subtitle != null && section.subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        section.subtitle!,
                        style: const TextStyle(
                          color: Color(0xFF6A5A4A),
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  ...section.habits.map((habit) {
                    final log = logs[habit.id];
                    final status = log?.status;
                    final completed = status == GrowthHabitStatus.completed;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => context.pushNamed(
                            'growthHabitDetail',
                            pathParameters: {'habitId': habit.id},
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: completed
                                    ? const Color(0xFF9A7A4F)
                                    : const Color(0xFFD8C5A8),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => ref
                                          .read(
                                            growthControllerProvider.notifier,
                                          )
                                          .toggleCompleted(
                                            date: selectedDate,
                                            habitId: habit.id,
                                          ),
                                      icon: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 220,
                                        ),
                                        child: Icon(
                                          completed
                                              ? Icons.check_circle_rounded
                                              : Icons.radio_button_unchecked,
                                          key: ValueKey<bool>(completed),
                                          color: completed
                                              ? const Color(0xFF7A5C35)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            habit.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            habit.subtitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFF6A5A4A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        final controller = ref.read(
                                          growthControllerProvider.notifier,
                                        );
                                        switch (value) {
                                          case 'skip':
                                            controller.setHabitStatus(
                                              date: selectedDate,
                                              habitId: habit.id,
                                              status: GrowthHabitStatus.skipped,
                                            );
                                            break;
                                          case 'snooze':
                                            controller.setHabitStatus(
                                              date: selectedDate,
                                              habitId: habit.id,
                                              status: GrowthHabitStatus.snoozed,
                                            );
                                            break;
                                          case 'defer':
                                            controller.setHabitStatus(
                                              date: selectedDate,
                                              habitId: habit.id,
                                              status:
                                                  GrowthHabitStatus.deferred,
                                            );
                                            break;
                                          case 'partial':
                                            _showPartialSheet(
                                              context,
                                              ref,
                                              selectedDate,
                                              habit.id,
                                            );
                                            break;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'skip',
                                          child: Text(
                                            l10n.growthHabitPauseTodayAction,
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'snooze',
                                          child: Text(
                                            l10n.growthHabitReturnLaterTodayAction,
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'defer',
                                          child: Text(
                                            l10n.growthHabitCarryToTomorrowAction,
                                          ),
                                        ),
                                        if (habit.allowPartial)
                                          PopupMenuItem(
                                            value: 'partial',
                                            child: Text(
                                              l10n.growthHabitPartialCompletionAction,
                                            ),
                                          ),
                                      ],
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5EEE3),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Text(
                                          growthStatusLocalizedLabel(
                                            status,
                                            l10n,
                                          ),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (habit.allowPartial)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 52,
                                      top: 2,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          l10n.growthHabitsProgressLabel,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: (log?.progress ?? 0).clamp(
                                              0.0,
                                              1.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.growthPercentValue(
                                            '${(((log?.progress ?? 0) * 100).round())}',
                                          ),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthTodayEndOfDayTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthTodayEndOfDaySummary(
                  '${endOfDay.completionPercent}',
                  '${endOfDay.completed}',
                  '${endOfDay.partial}',
                  '${endOfDay.missed}',
                ),
              ),
              const SizedBox(height: 6),
              Text(endOfDay.tone),
            ],
          ),
        ),
      ],
    );
  }

  void _showPartialSheet(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDate,
    String habitId,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        double progress = 0.5;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    ).growthHabitsSetPartialCompletion,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: progress,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: AppLocalizations.of(
                      context,
                    ).growthPercentValue('${(progress * 100).round()}'),
                    onChanged: (value) => setState(() => progress = value),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            ref
                                .read(growthControllerProvider.notifier)
                                .setHabitProgress(
                                  date: selectedDate,
                                  habitId: habitId,
                                  progress: progress,
                                );
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context).quranSave),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _seasonalPill(String label, bool complete) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: complete ? const Color(0xFFE8F2E8) : const Color(0xFFF5EEE3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(complete ? '$label ✓' : label),
    );
  }

  String _fastTypeLabel(GrowthFastTrackType type, AppLocalizations l10n) {
    switch (type) {
      case GrowthFastTrackType.ramadan:
        return l10n.growthFastTypeRamadan;
      case GrowthFastTrackType.mondayThursday:
        return l10n.growthFastTypeMondayThursday;
      case GrowthFastTrackType.whiteDays:
        return l10n.growthFastTypeWhiteDays;
      case GrowthFastTrackType.arafah:
        return l10n.growthFastTypeArafah;
      case GrowthFastTrackType.ashura:
        return l10n.growthFastTypeAshura;
      case GrowthFastTrackType.custom:
        return l10n.growthFastTypeCustom;
    }
  }
}
