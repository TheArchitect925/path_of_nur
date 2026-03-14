import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthHabitsPage extends ConsumerWidget {
  const GrowthHabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(growthSelectedDateProvider);
    final seasonal = ref.watch(growthSeasonalContextProvider);
    final ramadanDashboard = ref.watch(growthRamadanDashboardProvider);
    final quranTracker = ref.watch(growthRamadanQuranTrackerProvider);
    final fastTracking = ref.watch(growthFastTrackingProvider);
    final summary = ref.watch(growthTodaySummaryProvider);
    final grouped = ref.watch(growthDueHabitsByCategoryProvider);
    final logs = ref.watch(growthLogsForSelectedDateProvider);
    final endOfDay = ref.watch(growthEndOfDaySummaryProvider);
    final encouragement = ref.watch(growthEncouragementCopyProvider);
    final categoryMeta = ref.watch(growthCategoryContentByTypeProvider);

    return AppPageScaffold(
      headerIcon: Icons.checklist_rtl_rounded,
      title: 'Habit Tracker',
      subtitle: 'Track today’s habits with a clearer, dedicated space.',
      quote: const QuranQuote(
        arabic: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
        transliteration: 'Wa qul rabbi zidni ilma',
        translation: 'My Lord, increase me in knowledge.',
        surah: 20,
        verse: 114,
        locationLabel: 'Qur’an 20:114',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
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
                        '${(summary.completionProgress * 100).round()}%',
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
                    const Text(
                      'Habit Summary',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${summary.completedCount}/${summary.dueCount} gently completed',
                    ),
                    if (summary.partialCount > 0)
                      Text('${summary.partialCount} still in progress'),
                    Text('Light added today: ${summary.visibleLightEarnedToday}'),
                    if (summary.subtleLightEarnedToday >
                        summary.visibleLightEarnedToday)
                      const Text(
                        'Some progress is entrusted and tracked quietly.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6A5A4A),
                        ),
                      ),
                    Text(
                      'Steady days: ${summary.currentStreakDays} (best ${summary.bestStreakDays})',
                    ),
                    Text(
                      summary.completedCount > 0
                          ? encouragement.completion[
                              (selectedDate.day + selectedDate.month) %
                                  encouragement.completion.length]
                          : encouragement.returning[
                              (selectedDate.day + selectedDate.month) %
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
                      ? 'Ramadan Habit Tracking'
                      : 'Seasonal Habit Tracking',
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
                    _seasonalPill('Fast', ramadanDashboard.fastCompleted),
                    _seasonalPill('Qur’an', ramadanDashboard.quranHabitCompleted),
                    _seasonalPill('Charity', ramadanDashboard.charityCompleted),
                    _seasonalPill(
                      'Reflection',
                      ramadanDashboard.reflectionCompleted,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Qur’an completion plan'),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: quranTracker.planDays,
                      items: const [30, 15, 10]
                          .map(
                            (days) => DropdownMenuItem(
                              value: days,
                              child: Text('$days days'),
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
                  'Juz journey ${quranTracker.currentJuzProgress.toStringAsFixed(1)}/30 · ${quranTracker.remainingJuz.toStringAsFixed(1)} to continue',
                ),
                Text(
                  'A gentle pace: ~${quranTracker.estimatedDailyJuzNeeded.toStringAsFixed(2)} juz/day over ${quranTracker.estimatedDaysRemaining} days',
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
              const Text(
                'Fast Tracking',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text('Recommended: ${_fastTypeLabel(fastTracking.recommendedType)}'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: fastTracking.availableTypes
                    .map(
                      (type) => ChoiceChip(
                        selected: type == fastTracking.selectedType,
                        label: Text(_fastTypeLabel(type)),
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
                            ? 'Fast noted for today'
                            : 'Note today’s fast',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (grouped.isEmpty)
          const PremiumCard(
            child: Text(
              'No habits are due right now. Continue your path with a light review.',
            ),
          ),
        ...grouped.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryMeta[entry.key]?.title ??
                        growthCategoryLabel(entry.key),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (categoryMeta[entry.key] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        categoryMeta[entry.key]!.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF6A5A4A),
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  ...entry.value.map((habit) {
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
                                          .read(growthControllerProvider.notifier)
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
                                              status: GrowthHabitStatus.deferred,
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
                                        const PopupMenuItem(
                                          value: 'skip',
                                          child: Text('Pause for today'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'snooze',
                                          child: Text('Return later today'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'defer',
                                          child: Text('Carry to tomorrow'),
                                        ),
                                        if (habit.allowPartial)
                                          const PopupMenuItem(
                                            value: 'partial',
                                            child: Text('Partial completion'),
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
                                          growthStatusLabel(status),
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
                                        const Text(
                                          'Progress',
                                          style: TextStyle(fontSize: 11),
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
                                          '${(((log?.progress ?? 0) * 100).round())}%',
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
              const Text(
                'End of Day',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                '${endOfDay.completionPercent}% tended · ${endOfDay.completed} completed · ${endOfDay.partial} on your path · ${endOfDay.missed} to revisit gently',
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
                  const Text(
                    'Set partial completion',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: progress,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: '${(progress * 100).round()}%',
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
                          child: const Text('Save'),
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

  String _fastTypeLabel(GrowthFastTrackType type) {
    switch (type) {
      case GrowthFastTrackType.ramadan:
        return 'Ramadan';
      case GrowthFastTrackType.mondayThursday:
        return 'Monday/Thursday';
      case GrowthFastTrackType.whiteDays:
        return 'White Days';
      case GrowthFastTrackType.arafah:
        return 'Arafah';
      case GrowthFastTrackType.ashura:
        return 'Ashura';
      case GrowthFastTrackType.custom:
        return 'Custom';
    }
  }
}
