import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/premium_card.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthTodayPage extends ConsumerWidget {
  const GrowthTodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(growthSelectedDateProvider);
    final seasonal = ref.watch(growthSeasonalContextProvider);
    final seasonalCards = ref.watch(growthActiveSeasonalJourneyCardsProvider);
    final ramadanDashboard = ref.watch(growthRamadanDashboardProvider);
    final quranTracker = ref.watch(growthRamadanQuranTrackerProvider);
    final fastTracking = ref.watch(growthFastTrackingProvider);
    final summary = ref.watch(growthTodaySummaryProvider);
    final endOfDay = ref.watch(growthEndOfDaySummaryProvider);
    final encouragement = ref.watch(growthEncouragementCopyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Text('Today Summary', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('${summary.completedCount}/${summary.dueCount} gently completed'),
                    if (summary.partialCount > 0)
                      Text('${summary.partialCount} still in progress'),
                    Text('Light added today: ${summary.visibleLightEarnedToday}'),
                    if (summary.subtleLightEarnedToday > summary.visibleLightEarnedToday)
                      const Text(
                        'Some progress is entrusted and tracked quietly.',
                        style: TextStyle(color: Color(0xFF6A5A4A), fontSize: 12),
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
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
                    ),
                    if (summary.protectedDaysUsedThisWeek > 0)
                      Text(
                        'Gentle return support used this week: ${summary.protectedDaysUsedThisWeek}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (seasonal.activeSeasons.isNotEmpty) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      seasonal.isRamadanMode ? '🌙 Seasonal Journey' : '🗓 Seasonal Rhythm',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text(
                      '${seasonal.hijriDate.day} ${seasonal.hijriDate.monthName}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: ref.watch(growthControllerProvider).ramadanModeOverride,
                  onChanged: (v) => ref
                      .read(growthControllerProvider.notifier)
                      .setRamadanModeOverride(v),
                  title: const Text('Ramadan mode override'),
                  subtitle: const Text(
                    'Enable manually when you want Ramadan journeys active.',
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: seasonalCards
                      .map(
                        (card) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EEE3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text('${card.icon} ${card.title}'),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (ramadanDashboard != null) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ramadan Snapshot',
                  style: TextStyle(fontWeight: FontWeight.w700),
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
                Text(
                  'Juz journey ${quranTracker.currentJuzProgress.toStringAsFixed(1)}/30',
                ),
                Text(
                  'Fast tracking: ${_fastTypeLabel(fastTracking.selectedType)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A5A4A),
                  ),
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
                'Habit Tracker',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'All habit tracking now lives in its own dedicated page, with day selection, fast tracking, progress, and end-of-day review.',
              ),
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('growthHabitsDeepLink'),
                child: const Text('Open Habit Tracker'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('End of Day', style: TextStyle(fontWeight: FontWeight.w700)),
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

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
