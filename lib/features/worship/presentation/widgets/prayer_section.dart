import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/state/user_profile_state.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/prayer_controller.dart';
import '../../application/prayer_tracker_controller.dart';
import '../../application/sister_cycle_provider.dart';
import '../../domain/prayer_name.dart';
import '../../domain/prayer_status.dart';

class PrayerSection extends ConsumerWidget {
  const PrayerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(
            title: 'Prayer Hub',
            subtitle:
                'Times, tracking, consistency, rakats, and practical guidance in one focused flow.',
          ),
          _PrayerHubTabs(),
          SizedBox(height: 10),
          _PrayerHubTabViews(),
        ],
      ),
    );
  }
}

class _PrayerHubTabs extends StatelessWidget {
  const _PrayerHubTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const TabBar(
        labelColor: AppColors.onSurface,
        unselectedLabelColor: AppColors.onSurfaceSubtle,
        indicatorColor: AppColors.accentGold,
        labelStyle: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: 'Times'),
          Tab(text: 'Tracker'),
          Tab(text: 'Stats'),
          Tab(text: 'Rakat'),
        ],
      ),
    );
  }
}

class _PrayerHubTabViews extends ConsumerWidget {
  const _PrayerHubTabViews();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox(
      height: 1750,
      child: TabBarView(
        children: [
          _PrayerTimesTab(),
          _PrayerTrackerTab(),
          _PrayerStatsTab(),
          _PrayerRakatTab(),
        ],
      ),
    );
  }
}

class _PrayerTimesTab extends ConsumerWidget {
  const _PrayerTimesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(prayerTrackerControllerProvider);
    final trackerNotifier = ref.read(prayerTrackerControllerProvider.notifier);
    final sisterCycle = ref.watch(sisterCycleProvider);
    final sisterCycleNotifier = ref.read(sisterCycleProvider.notifier);
    final sisterCycleGuidance = ref.watch(sisterCycleGuidanceProvider);
    final userProfile = ref.watch(userProfileProvider);
    final isSister = userProfile.sex == UserSex.sister;
    final settings = ref.watch(prayerSettingsProvider).preferences;
    final location = ref.watch(prayerLocationProvider);
    final schedule = buildPrayerScheduleForDate(
      date: tracker.selectedDate,
      latitude: location.latitude,
      longitude: location.longitude,
      settings: settings,
    ).where((item) => item.id != 'tahajjud').toList();
    final timingContext = _buildTimingContext(schedule, tracker.selectedDate);
    final moon = _moonPhaseForDate(tracker.selectedDate);
    final hijri = _toHijriDate(tracker.selectedDate);
    final dateFormat = DateFormat.yMMMMEEEEd();
    final fajr = schedule.where((item) => item.id == 'fajr').firstOrNull;
    final maghrib = schedule.where((item) => item.id == 'maghrib').firstOrNull;
    final sunriseLabel = fajr == null
        ? '--'
        : DateFormat.jm().format(fajr.windowEndDateTime);
    final sunsetLabel = maghrib == null
        ? '--'
        : DateFormat.jm().format(maghrib.offerDateTime);
    final moonTimes = (fajr != null && maghrib != null)
        ? _calculateMoonTimesForDate(
            tracker.selectedDate,
            sunrise: fajr.windowEndDateTime,
            sunset: maghrib.offerDateTime,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: isSister
                      ? [
                          const Expanded(
                            child: Text(
                              'Sister cycle pause',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Switch.adaptive(
                            value: sisterCycle.active,
                            onChanged: sisterCycleNotifier.setActive,
                          ),
                        ]
                      : const [],
                ),
                if (isSister) ...[
                  const SizedBox(height: 4),
                  Text(
                    sisterCycleGuidance.summary,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.onSurfaceSubtle,
                      height: 1.35,
                    ),
                  ),
                  if (sisterCycle.active) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Cycle day ${sisterCycleGuidance.dayNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: sisterCycleGuidance.recommendedFocus
                          .map(
                            (item) => Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text(
                                item,
                                style: const TextStyle(fontSize: 11.5),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Expected duration',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DropdownButton<int>(
                        value: sisterCycle.expectedDurationDays,
                        style: Theme.of(context).textTheme.bodyLarge,
                        onChanged: (value) {
                          if (value == null) return;
                          sisterCycleNotifier.setExpectedDurationDays(value);
                        },
                        items: const [
                          DropdownMenuItem(value: 5, child: Text('5 days')),
                          DropdownMenuItem(value: 6, child: Text('6 days')),
                          DropdownMenuItem(value: 7, child: Text('7 days')),
                          DropdownMenuItem(value: 8, child: Text('8 days')),
                          DropdownMenuItem(value: 9, child: Text('9 days')),
                          DropdownMenuItem(value: 10, child: Text('10 days')),
                        ],
                      ),
                    ],
                  ),
                  SwitchListTile.adaptive(
                    value: sisterCycle.autoAdjustReminders,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Auto-adjust reminders'),
                    subtitle: const Text(
                      'Pauses prayer and fasting reminders and keeps gentle alternatives.',
                    ),
                    onChanged: sisterCycleNotifier.setAutoAdjustReminders,
                  ),
                  SwitchListTile.adaptive(
                    value: sisterCycle.sendPurityCheckReminder,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Purity check reminder'),
                    subtitle: const Text(
                      'Send a gentle check-in near your expected end day.',
                    ),
                    onChanged: sisterCycleNotifier.setSendPurityCheckReminder,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: sisterCycle.notes,
                    onChanged: sisterCycleNotifier.updateNotes,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Optional private notes',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    height: 1,
                    color: AppColors.onSurfaceSubtle.withValues(alpha: 0.22),
                  ),
                  const SizedBox(height: 10),
                ],
                Row(
                  children: [
                    IconButton(
                      onPressed: trackerNotifier.previousDay,
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _showDateModeSheet(
                          context,
                          ref,
                          tracker.selectedDate,
                        ),
                        child: Column(
                          children: [
                            Text(
                              dateFormat.format(tracker.selectedDate),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${hijri.day} ${hijri.monthName} ${hijri.year} AH',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.onSurfaceSubtle,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: trackerNotifier.nextDay,
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _MoonPhaseCard(
            moon: moon,
            prayerSchedule: schedule,
            nextPrayerName: timingContext.nextPrayerName,
            remaining: timingContext.remainingToNext,
            sunriseLabel: sunriseLabel,
            sunsetLabel: sunsetLabel,
            moonriseLabel: moonTimes == null
                ? '--'
                : DateFormat.jm().format(moonTimes.moonrise),
            moonsetLabel: moonTimes == null
                ? '--'
                : DateFormat.jm().format(moonTimes.moonset),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prayer Times',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...schedule.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onTap: () => context.pushNamed('salahTimes'),
                      title: Text('${item.name} • ${item.arabicName}'),
                      subtitle: Text(
                        '${item.offerTime}  •  Prayer Time Window: ${item.windowStart}–${item.windowEnd}',
                      ),
                      trailing: Text(
                        item.totalRakats.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _QiblaFinderCard(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        ],
      ),
    );
  }
}

class _PrayerTrackerTab extends ConsumerWidget {
  const _PrayerTrackerTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(prayerTrackerControllerProvider);
    final trackerNotifier = ref.read(prayerTrackerControllerProvider.notifier);
    final monthRecords = ref.watch(
      prayerMonthlyRecordsProvider(tracker.selectedDate),
    );
    final selected = tracker.selectedDate;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Salah Tracker',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Each day has 5 points. Green = offered. Yellow = missed. Tap any prayer to update.',
                  style: TextStyle(color: AppColors.onSurfaceSubtle),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PrayerName.values
                      .map(
                        (prayer) => _PrayerStatusChip(
                          prayer: prayer,
                          status:
                              tracker.records[prayer] ?? PrayerStatus.pending,
                          onTap: () {
                            trackerNotifier.cycleStatus(prayer);
                            if (_sameDay(selected, DateTime.now())) {
                              ref
                                  .read(prayerControllerProvider.notifier)
                                  .onDayChanged(
                                    LocalStore.todayKey(),
                                    force: true,
                                  );
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Consistency',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat.yMMMM().format(selected),
                  style: const TextStyle(color: AppColors.onSurfaceSubtle),
                ),
                const SizedBox(height: 10),
                _MonthlyTrackerGrid(
                  selectedMonth: selected,
                  monthRecords: monthRecords,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerStatsTab extends ConsumerWidget {
  const _PrayerStatsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(prayerTrackerControllerProvider);
    final trackerNotifier = ref.read(prayerTrackerControllerProvider.notifier);
    final monthRecords = ref.watch(
      prayerMonthlyRecordsProvider(tracker.selectedDate),
    );
    final totalDays = monthRecords.length;
    var completedPoints = 0;
    var totalPoints = 0;
    var missedPoints = 0;
    for (final daily in monthRecords.values) {
      for (final prayer in PrayerName.values) {
        final status = daily[prayer] ?? PrayerStatus.pending;
        totalPoints += 1;
        if (status == PrayerStatus.completed) completedPoints += 1;
        if (status == PrayerStatus.missed) missedPoints += 1;
      }
    }
    final completion = totalPoints == 0 ? 0.0 : completedPoints / totalPoints;
    final weeklyTrend = _buildWeeklyTrend(
      ref.read(prayerTrackerControllerProvider.notifier),
      tracker.selectedDate,
      weeks: 8,
    );
    final monthlyTrend = _buildMonthlyTrend(
      ref.read(prayerTrackerControllerProvider.notifier),
      tracker.selectedDate,
      months: 6,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Overview',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text('Tracked days: $totalDays'),
                Text('Offered prayers: $completedPoints'),
                Text('Missed prayers: $missedPoints'),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: completion,
                    minHeight: 9,
                    backgroundColor: AppColors.surfaceSoft,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Completion ${(completion * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(color: AppColors.onSurfaceSubtle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _QadaPlannerCard(
            backlog: tracker.qadaBacklog,
            queue: trackerNotifier.qadaQueue(limit: 20),
            recommendedCadence: trackerNotifier.cadenceRecommendation(),
            estimatedDays: trackerNotifier.estimateQadaDaysToClear(),
            dailyTarget: tracker.dailyQadaTarget,
            dailyCompleted: tracker.dailyQadaCompleted,
            dailyProgress: trackerNotifier.qadaDailyTargetProgress(),
          ),
          const SizedBox(height: 12),
          _TrendChartCard(
            title: 'Weekly Consistency Trend',
            subtitle: 'Completion across the last 8 weeks.',
            bars: weeklyTrend,
          ),
          const SizedBox(height: 12),
          _TrendChartCard(
            title: 'Monthly Consistency Trend',
            subtitle: 'Completion across the last 6 months.',
            bars: monthlyTrend,
          ),
          const SizedBox(height: 12),
          _PrayerConsistencyHeatmapCard(monthRecords: monthRecords),
          const SizedBox(height: 12),
          const PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Missed Prayer Make-up (Qada) Guidance',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Keep current prayers on time as the first priority.\n'
                  '2. Make sincere tawbah and ask الله for consistency.\n'
                  '3. Build a manageable qada routine (for example: add one qada after each current prayer).\n'
                  '4. Track by prayer type to avoid overwhelm and maintain steady progress.\n'
                  '5. If your situation is complex, confirm your plan with a trusted local scholar.',
                  style: TextStyle(
                    color: AppColors.onSurfaceSubtle,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerRakatTab extends StatelessWidget {
  const _PrayerRakatTab();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 12, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RakatCard(),
          SizedBox(height: 12),
          _SalahLearningModuleCard(),
        ],
      ),
    );
  }
}

class _PrayerStatusChip extends StatelessWidget {
  const _PrayerStatusChip({
    required this.prayer,
    required this.status,
    required this.onTap,
  });

  final PrayerName prayer;
  final PrayerStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case PrayerStatus.completed:
        color = AppColors.success;
      case PrayerStatus.missed:
        color = AppColors.caution;
      case PrayerStatus.pending:
        color = AppColors.onSurfaceSubtle;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 106,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withValues(alpha: 0.16),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Column(
          children: [
            Text(
              prayer.label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(status.label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _MonthlyTrackerGrid extends StatelessWidget {
  const _MonthlyTrackerGrid({
    required this.selectedMonth,
    required this.monthRecords,
  });

  final DateTime selectedMonth;
  final Map<DateTime, Map<PrayerName, PrayerStatus>> monthRecords;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final firstWeekdayOffset = first.weekday % 7;
    final nextMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);
    final dayCount = nextMonth.difference(first).inDays;
    final totalCells = (((firstWeekdayOffset + dayCount) / 7).ceil()) * 7;

    return Column(
      children: [
        Row(
          children: const [
            _WeekdayHead('S'),
            _WeekdayHead('M'),
            _WeekdayHead('T'),
            _WeekdayHead('W'),
            _WeekdayHead('T'),
            _WeekdayHead('F'),
            _WeekdayHead('S'),
          ],
        ),
        const SizedBox(height: 6),
        for (var row = 0; row < totalCells ~/ 7; row += 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: List.generate(7, (col) {
                final index = row * 7 + col;
                final dayNum = index - firstWeekdayOffset + 1;
                if (dayNum < 1 || dayNum > dayCount) {
                  return const Expanded(child: SizedBox(height: 42));
                }
                final date = DateTime(
                  selectedMonth.year,
                  selectedMonth.month,
                  dayNum,
                );
                final daily =
                    monthRecords[date] ?? const <PrayerName, PrayerStatus>{};
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        dayNum.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 3),
                      Wrap(
                        spacing: 1.2,
                        runSpacing: 1.2,
                        children: PrayerName.values
                            .map(
                              (prayer) => Container(
                                width: 6.8,
                                height: 6.8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _statusColor(
                                    daily[prayer] ?? PrayerStatus.pending,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Color _statusColor(PrayerStatus status) {
    switch (status) {
      case PrayerStatus.completed:
        return AppColors.success;
      case PrayerStatus.missed:
        return AppColors.caution;
      case PrayerStatus.pending:
        return AppColors.surfaceSoft;
    }
  }
}

class _WeekdayHead extends StatelessWidget {
  const _WeekdayHead(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.onSurfaceSubtle,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _QadaPlannerCard extends ConsumerWidget {
  const _QadaPlannerCard({
    required this.backlog,
    required this.queue,
    required this.recommendedCadence,
    required this.estimatedDays,
    required this.dailyTarget,
    required this.dailyCompleted,
    required this.dailyProgress,
  });

  final Map<PrayerName, int> backlog;
  final List<PrayerName> queue;
  final String recommendedCadence;
  final int estimatedDays;
  final int dailyTarget;
  final int dailyCompleted;
  final double dailyProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(prayerTrackerControllerProvider.notifier);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Qada Planner v2',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Cadence: $recommendedCadence',
            style: const TextStyle(
              color: AppColors.onSurfaceSubtle,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Estimated days to clear: $estimatedDays',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: dailyProgress,
              minHeight: 8,
              color: AppColors.success,
              backgroundColor: AppColors.surfaceSoft,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Today\'s qada target: $dailyCompleted / $dailyTarget',
            style: const TextStyle(
              color: AppColors.onSurfaceSubtle,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ...PrayerName.values.map(
            (prayer) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(prayer.label)),
                  IconButton(
                    onPressed: () => notifier.addQada(prayer, -1),
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                  ),
                  Text(
                    (backlog[prayer] ?? 0).toString(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: () => notifier.addQada(prayer, 1),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
                  TextButton(
                    onPressed: () => notifier.completeOneQada(prayer),
                    child: const Text('Done one'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 18),
          const Text(
            'Next in queue',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          if (queue.isEmpty)
            const Text(
              'No queued qada left. Keep today\'s prayers protected.',
              style: TextStyle(color: AppColors.onSurfaceSubtle),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: queue
                  .map(
                    (prayer) => Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(prayer.label),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _TrendPoint {
  const _TrendPoint({required this.label, required this.completionRate});

  final String label;
  final double completionRate;
}

class _TrendChartCard extends StatelessWidget {
  const _TrendChartCard({
    required this.title,
    required this.subtitle,
    required this.bars,
  });

  final String title;
  final String subtitle;
  final List<_TrendPoint> bars;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.onSurfaceSubtle,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 132,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars
                  .map(
                    (item) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: item.completionRate.clamp(
                                    0.0,
                                    1.0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: item.completionRate >= 0.7
                                          ? AppColors.success
                                          : item.completionRate >= 0.4
                                          ? AppColors.accentGold
                                          : AppColors.caution,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.onSurfaceSubtle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerConsistencyHeatmapCard extends StatelessWidget {
  const _PrayerConsistencyHeatmapCard({required this.monthRecords});

  final Map<DateTime, Map<PrayerName, PrayerStatus>> monthRecords;

  @override
  Widget build(BuildContext context) {
    if (monthRecords.isEmpty) {
      return const PremiumCard(
        child: Text(
          'No prayer records yet for this month.',
          style: TextStyle(color: AppColors.onSurfaceSubtle),
        ),
      );
    }
    final days = [...monthRecords.keys]..sort((a, b) => a.compareTo(b));
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prayer-by-Prayer Heatmap',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Each row is one prayer. Green offered, yellow missed, soft gray pending.',
            style: TextStyle(color: AppColors.onSurfaceSubtle, fontSize: 12.5),
          ),
          const SizedBox(height: 10),
          for (final prayer in PrayerName.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Text(
                      prayer.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: days
                            .map(
                              (day) => Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(right: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: _heatmapColor(
                                    monthRecords[day]?[prayer] ??
                                        PrayerStatus.pending,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _heatmapColor(PrayerStatus status) {
    switch (status) {
      case PrayerStatus.completed:
        return AppColors.success;
      case PrayerStatus.missed:
        return AppColors.caution;
      case PrayerStatus.pending:
        return AppColors.surfaceSoft;
    }
  }
}

class _RakatCard extends StatelessWidget {
  const _RakatCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Rakat Guide (Fard)',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('Fajr: 2  •  Dhuhr: 4  •  Asr: 4  •  Maghrib: 3  •  Isha: 4'),
          SizedBox(height: 6),
          Text(
            'Tip: Stay consistent with the fard first. Add sunnah and nafl steadily.',
            style: TextStyle(color: AppColors.onSurfaceSubtle),
          ),
        ],
      ),
    );
  }
}

class _SalahLearningModuleCard extends StatefulWidget {
  const _SalahLearningModuleCard();

  @override
  State<_SalahLearningModuleCard> createState() =>
      _SalahLearningModuleCardState();
}

class _SalahLearningModuleCardState extends State<_SalahLearningModuleCard> {
  final _tts = FlutterTts();
  final _checkedStepIds = <String>{};
  String _activeFlow = 'wudu';

  static const _wuduSteps = <_LearningStep>[
    _LearningStep(
      id: 'wudu-1',
      title: 'Make intention',
      transliteration: 'Nawaytu al-wudu lillah',
      guidance:
          'Intend purification sincerely for salah. Niyyah remains in the heart.',
    ),
    _LearningStep(
      id: 'wudu-2',
      title: 'Wash hands',
      transliteration: 'Bismillah',
      guidance: 'Wash both hands to the wrists three times.',
    ),
    _LearningStep(
      id: 'wudu-3',
      title: 'Rinse mouth and nose',
      transliteration: 'Madmadah and Istinshaq',
      guidance:
          'Rinse the mouth and nose gently, then clear them out, three times.',
    ),
    _LearningStep(
      id: 'wudu-4',
      title: 'Wash face and arms',
      transliteration: 'From forehead to chin; right then left arm',
      guidance:
          'Wash face fully, then wash right arm and left arm including elbows.',
    ),
    _LearningStep(
      id: 'wudu-5',
      title: 'Wipe head and wash feet',
      transliteration: 'Masah + washing feet',
      guidance:
          'Wipe the head once, include ears, then wash right and left feet including ankles.',
    ),
  ];

  static const _salahSteps = <_LearningStep>[
    _LearningStep(
      id: 'salah-1',
      title: 'Niyyah and Takbir',
      transliteration: 'Allahu Akbar',
      guidance:
          'Face qibla, intend the specific prayer, and begin with Takbir.',
    ),
    _LearningStep(
      id: 'salah-2',
      title: 'Opening and recitation',
      transliteration:
          'Subhanaka Allahumma... then Al-Fatihah and a short surah',
      guidance: 'Recite calmly with focus and measured pace.',
    ),
    _LearningStep(
      id: 'salah-3',
      title: 'Ruku and rising',
      transliteration: 'Subhana Rabbiyal Adhim',
      guidance:
          'Bow with a straight back in ruku, then rise with stillness before sujud.',
    ),
    _LearningStep(
      id: 'salah-4',
      title: 'Sujud and sitting',
      transliteration: 'Subhana Rabbiyal A\'la',
      guidance:
          'Perform two sujud with calm pauses and sit between them with humility.',
    ),
    _LearningStep(
      id: 'salah-5',
      title: 'Tashahhud and salam',
      transliteration: 'At-tahiyyatu lillah... Assalamu alaikum wa rahmatullah',
      guidance:
          'Complete tashahhud, prayers on the Prophet, supplication, and end with salam.',
    ),
  ];

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak(_LearningStep step) async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.43);
    await _tts.speak(
      '${step.title}. ${step.transliteration}. ${step.guidance}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWudu = _activeFlow == 'wudu';
    final steps = isWudu ? _wuduSteps : _salahSteps;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wudu & Salah Learning Module',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Step-by-step mode with transliteration, checklist, and audio guidance.',
            style: TextStyle(color: AppColors.onSurfaceSubtle, fontSize: 12.5),
          ),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'wudu', label: Text('Wudu')),
              ButtonSegment(value: 'salah', label: Text('Salah')),
            ],
            selected: {_activeFlow},
            onSelectionChanged: (selection) {
              setState(() {
                _activeFlow = selection.first;
              });
            },
          ),
          const SizedBox(height: 10),
          ...steps.map((step) {
            final checked = _checkedStepIds.contains(step.id);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surfaceSoft.withValues(alpha: 0.35),
                border: Border.all(
                  color: checked
                      ? AppColors.success.withValues(alpha: 0.6)
                      : AppColors.surfaceSoft,
                ),
              ),
              child: CheckboxListTile(
                value: checked,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _checkedStepIds.add(step.id);
                    } else {
                      _checkedStepIds.remove(step.id);
                    }
                  });
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(step.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.transliteration,
                      style: const TextStyle(
                        color: AppColors.onSurfaceSubtle,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.guidance,
                      style: const TextStyle(
                        color: AppColors.onSurfaceSubtle,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                secondary: IconButton(
                  tooltip: 'Play',
                  onPressed: () => _speak(step),
                  icon: const Icon(Icons.volume_up_rounded),
                ),
              ),
            );
          }),
          const SizedBox(height: 6),
          const Text(
            'Opening du\'a example: Subhanaka Allahumma wa bihamdika wa tabarakasmuka wa ta\'ala jadduka wa la ilaha ghayruk.',
            style: TextStyle(color: AppColors.onSurfaceSubtle, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _LearningStep {
  const _LearningStep({
    required this.id,
    required this.title,
    required this.transliteration,
    required this.guidance,
  });

  final String id;
  final String title;
  final String transliteration;
  final String guidance;
}

class _QiblaFinderCard extends ConsumerWidget {
  const _QiblaFinderCard({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qibla = _qiblaBearing(latitude, longitude);
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final heading = snapshot.data?.heading;
        final accuracy = snapshot.data?.accuracy;
        final headingAvailable = heading != null && !heading.isNaN;
        final delta = headingAvailable
            ? _normalizeBearingDelta(qibla - heading)
            : null;
        final quality = _compassQualityLabel(
          accuracy: accuracy,
          headingAvailable: headingAvailable,
        );
        final guidance = _calibrationGuidance(
          delta: delta,
          headingAvailable: headingAvailable,
          accuracy: accuracy,
        );
        return PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AR Qibla Finder v2',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text('Qibla bearing: ${qibla.toStringAsFixed(1)}° from North'),
              const SizedBox(height: 6),
              Text(
                headingAvailable
                    ? 'Current heading: ${heading.toStringAsFixed(1)}°  •  Turn ${delta!.abs().toStringAsFixed(1)}° ${delta >= 0 ? 'right' : 'left'}'
                    : 'Compass heading unavailable on this device/session.',
              ),
              const SizedBox(height: 6),
              Text(
                'Compass quality: $quality',
                style: const TextStyle(color: AppColors.onSurfaceSubtle),
              ),
              const SizedBox(height: 4),
              Text(
                guidance,
                style: const TextStyle(color: AppColors.onSurfaceSubtle),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Calibration Guidance'),
                      content: Text(
                        '1. Keep phone flat and away from metal.\n'
                        '2. Move in a slow figure-eight pattern.\n'
                        '3. Re-check heading accuracy and align toward ${qibla.toStringAsFixed(1)}°.\n'
                        '4. If quality stays low, use known landmarks and mosque direction locally.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.explore_rounded),
                label: const Text('Calibration help'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MoonPhaseCard extends StatelessWidget {
  const _MoonPhaseCard({
    required this.moon,
    required this.prayerSchedule,
    required this.nextPrayerName,
    required this.remaining,
    required this.sunriseLabel,
    required this.sunsetLabel,
    required this.moonriseLabel,
    required this.moonsetLabel,
  });

  final _MoonPhaseData moon;
  final List<PrayerScheduleItem> prayerSchedule;
  final String? nextPrayerName;
  final Duration remaining;
  final String sunriseLabel;
  final String sunsetLabel;
  final String moonriseLabel;
  final String moonsetLabel;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Moon Phase',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${moon.label} • ${moon.illuminationPercent}% illuminated',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.onSurfaceSubtle,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 360,
              height: 360,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // overlay prayer names/times around the moon
                  if (prayerSchedule.isNotEmpty)
                    _PrayerTimesOverlay(
                      schedule: prayerSchedule,
                      onPrayerTimeTap: () => context.pushNamed('salahTimes'),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(moon.emoji, style: const TextStyle(fontSize: 136)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentGoldSoft.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'Sunrise • $sunriseLabel',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentGoldSoft.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'Sunset • $sunsetLabel',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentGoldSoft.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'Moonrise • $moonriseLabel',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentGoldSoft.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'Moonset • $moonsetLabel',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            nextPrayerName == null
                ? 'No upcoming prayer for this selected time.'
                : 'Next prayer: $nextPrayerName in ${_humanDuration(remaining)}',
            style: const TextStyle(color: AppColors.onSurfaceSubtle),
          ),
        ],
      ),
    );
  }
}

class _PrayerTimesOverlay extends StatelessWidget {
  const _PrayerTimesOverlay({
    required this.schedule,
    required this.onPrayerTimeTap,
  });

  final List<PrayerScheduleItem> schedule;
  final VoidCallback onPrayerTimeTap;

  @override
  Widget build(BuildContext context) {
    // positions correspond to the five prayer points around the moon widget.
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final center = Offset(size.width / 2, size.height / 2);
        final radius = size.width * 0.40;
        return Stack(
          children: List.generate(
            schedule.length.clamp(0, 5),
            (i) {
              final angle = (-math.pi / 2) + (2 * math.pi * (i / 5));
              final point = Offset(
                center.dx + radius * math.cos(angle),
                center.dy + radius * math.sin(angle),
              );
              final item = schedule[i];
              final label = '${item.name} ${item.offerTime}';
              return Positioned(
                left: point.dx - 30,
                top: point.dy - 10,
                child: GestureDetector(
                  onTap: onPrayerTimeTap,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MoonTimes {
  const _MoonTimes({required this.moonrise, required this.moonset});

  final DateTime moonrise;
  final DateTime moonset;
}

_MoonTimes _calculateMoonTimesForDate(
  DateTime date, {
  required DateTime sunrise,
  required DateTime sunset,
}) {
  final normalized = DateTime(date.year, date.month, date.day);
  final epoch = DateTime.utc(2000, 1, 6);
  final days = normalized.toUtc().difference(epoch).inHours / 24;
  const synodic = 29.53058867;
  final age = (days % synodic + synodic) % synodic;

  // Approximation: moonrise/moonset shift ~50 minutes later daily.
  final offsetMinutes = (age * 50).round();
  final moonrise = sunrise.add(Duration(minutes: offsetMinutes));
  final moonset = sunset.add(Duration(minutes: offsetMinutes));
  return _MoonTimes(moonrise: moonrise, moonset: moonset);
}

class _TimingContext {
  const _TimingContext({
    required this.nextPrayerName,
    required this.remainingToNext,
    required this.progressToNext,
  });

  final String? nextPrayerName;
  final Duration remainingToNext;
  final double progressToNext;
}

_TimingContext _buildTimingContext(
  List<PrayerScheduleItem> schedule,
  DateTime selectedDate,
) {
  if (schedule.isEmpty) {
    return const _TimingContext(
      nextPrayerName: null,
      remainingToNext: Duration.zero,
      progressToNext: 0,
    );
  }
  final now = _sameDay(selectedDate, DateTime.now())
      ? DateTime.now()
      : DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12);

  PrayerScheduleItem? current;
  PrayerScheduleItem? next;
  for (var i = 0; i < schedule.length; i += 1) {
    final item = schedule[i];
    if (!now.isBefore(item.windowStartDateTime) &&
        now.isBefore(item.windowEndDateTime)) {
      current = item;
      next = i + 1 < schedule.length ? schedule[i + 1] : null;
      break;
    }
    if (now.isBefore(item.windowStartDateTime)) {
      next = item;
      break;
    }
  }
  next ??= schedule.first;
  final previousAnchor =
      current?.windowStartDateTime ?? now.subtract(const Duration(hours: 1));
  final total = math.max(
    1,
    next.windowStartDateTime.difference(previousAnchor).inSeconds,
  );
  final elapsed = now.difference(previousAnchor).inSeconds.clamp(0, total);
  return _TimingContext(
    nextPrayerName: next.name,
    remainingToNext: next.windowStartDateTime.difference(now),
    progressToNext: (elapsed / total).clamp(0.0, 1.0),
  );
}

List<_TrendPoint> _buildWeeklyTrend(
  PrayerTrackerController controller,
  DateTime anchorDate, {
  int weeks = 8,
}) {
  final anchor = DateTime(anchorDate.year, anchorDate.month, anchorDate.day);
  final startOfWeek = anchor.subtract(Duration(days: anchor.weekday % 7));
  final points = <_TrendPoint>[];
  for (var i = weeks - 1; i >= 0; i -= 1) {
    final weekStart = startOfWeek.subtract(Duration(days: i * 7));
    var total = 0;
    var completed = 0;
    for (var d = 0; d < 7; d += 1) {
      final day = weekStart.add(Duration(days: d));
      final map =
          controller.loadMonthMap(day)[DateTime(
            day.year,
            day.month,
            day.day,
          )] ??
          const <PrayerName, PrayerStatus>{};
      for (final prayer in PrayerName.values) {
        total += 1;
        if ((map[prayer] ?? PrayerStatus.pending) == PrayerStatus.completed) {
          completed += 1;
        }
      }
    }
    points.add(
      _TrendPoint(
        label: 'W${weeks - i}',
        completionRate: total == 0 ? 0 : (completed / total),
      ),
    );
  }
  return points;
}

List<_TrendPoint> _buildMonthlyTrend(
  PrayerTrackerController controller,
  DateTime anchorDate, {
  int months = 6,
}) {
  final points = <_TrendPoint>[];
  for (var i = months - 1; i >= 0; i -= 1) {
    final month = DateTime(anchorDate.year, anchorDate.month - i, 1);
    final records = controller.loadMonthMap(month);
    var total = 0;
    var completed = 0;
    for (final day in records.values) {
      for (final prayer in PrayerName.values) {
        total += 1;
        if ((day[prayer] ?? PrayerStatus.pending) == PrayerStatus.completed) {
          completed += 1;
        }
      }
    }
    points.add(
      _TrendPoint(
        label: DateFormat.MMM().format(month),
        completionRate: total == 0 ? 0 : completed / total,
      ),
    );
  }
  return points;
}

Future<void> _showDateModeSheet(
  BuildContext context,
  WidgetRef ref,
  DateTime selected,
) async {
  final trackerNotifier = ref.read(prayerTrackerControllerProvider.notifier);
  // Calendar opens in Gregorian by default; users can still switch in-sheet.
  trackerNotifier.setCalendarMode(PrayerCalendarMode.gregorian);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('Normal Calendar (Gregorian)'),
            onTap: () async {
              Navigator.of(sheetContext).pop();
              trackerNotifier.setCalendarMode(PrayerCalendarMode.gregorian);
              final picked = await showDatePicker(
                context: context,
                initialDate: selected,
                firstDate: DateTime(2010),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                trackerNotifier.setSelectedDate(picked);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.nights_stay_rounded),
            title: const Text('Islamic Calendar (display mode)'),
            subtitle: const Text(
              'Switches to Hijri date display with the same tracked day data.',
            ),
            onTap: () {
              trackerNotifier.setCalendarMode(PrayerCalendarMode.islamic);
              Navigator.of(sheetContext).pop();
            },
          ),
        ],
      ),
    ),
  );
}

double _qiblaBearing(double latitude, double longitude) {
  const kaabaLat = 21.4225;
  const kaabaLng = 39.8262;
  final lat1 = _degToRad(latitude);
  final lng1 = _degToRad(longitude);
  final lat2 = _degToRad(kaabaLat);
  final lng2 = _degToRad(kaabaLng);
  final dLng = lng2 - lng1;
  final y = math.sin(dLng);
  final x = math.cos(lat1) * math.tan(lat2) - math.sin(lat1) * math.cos(dLng);
  final bearing = _radToDeg(math.atan2(y, x));
  return (bearing + 360) % 360;
}

double _normalizeBearingDelta(double delta) {
  var value = delta % 360;
  if (value > 180) value -= 360;
  if (value < -180) value += 360;
  return value;
}

String _compassQualityLabel({
  required double? accuracy,
  required bool headingAvailable,
}) {
  if (!headingAvailable) return 'Unavailable (fallback only)';
  if (accuracy == null || accuracy.isNaN) return 'Medium';
  if (accuracy <= 15) return 'High';
  if (accuracy <= 35) return 'Medium';
  return 'Low';
}

String _calibrationGuidance({
  required double? delta,
  required bool headingAvailable,
  required double? accuracy,
}) {
  if (!headingAvailable) {
    return 'Fallback mode: verify against mosque direction, maps, or trusted local direction.';
  }
  if (accuracy != null && accuracy > 35) {
    return 'Calibration needed: move the device in a figure-eight away from metal objects.';
  }
  if (delta == null) {
    return 'Rotate slowly until aligned with qibla.';
  }
  final abs = delta.abs();
  if (abs <= 8) {
    return 'Aligned well. Keep phone flat for best stability.';
  }
  if (abs <= 25) {
    return 'Close alignment. Turn slightly ${delta > 0 ? 'right' : 'left'}.';
  }
  return 'Turn ${delta > 0 ? 'right' : 'left'} to align more precisely.';
}

double _degToRad(double value) => value * (math.pi / 180);
double _radToDeg(double value) => value * (180 / math.pi);

bool _sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _humanDuration(Duration duration) {
  if (duration.isNegative) return '0m';
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${math.max(0, minutes)}m';
}

class _MoonPhaseData {
  const _MoonPhaseData({
    required this.label,
    required this.emoji,
    required this.illuminationPercent,
  });

  final String label;
  final String emoji;
  final int illuminationPercent;
}

_MoonPhaseData _moonPhaseForDate(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  final epoch = DateTime.utc(2000, 1, 6);
  final days = normalized.toUtc().difference(epoch).inHours / 24;
  const synodic = 29.53058867;
  final age = (days % synodic + synodic) % synodic;
  final illumination = ((1 - math.cos((2 * math.pi * age) / synodic)) / 2 * 100)
      .round()
      .clamp(0, 100);
  if (age < 1.84566) {
    return _MoonPhaseData(
      label: 'New Moon',
      emoji: '🌑',
      illuminationPercent: illumination,
    );
  }
  if (age < 5.53699) {
    return _MoonPhaseData(
      label: 'Waxing Crescent',
      emoji: '🌒',
      illuminationPercent: illumination,
    );
  }
  if (age < 9.22831) {
    return _MoonPhaseData(
      label: 'First Quarter',
      emoji: '🌓',
      illuminationPercent: illumination,
    );
  }
  if (age < 12.91963) {
    return _MoonPhaseData(
      label: 'Waxing Gibbous',
      emoji: '🌔',
      illuminationPercent: illumination,
    );
  }
  if (age < 16.61096) {
    return _MoonPhaseData(
      label: 'Full Moon',
      emoji: '🌕',
      illuminationPercent: illumination,
    );
  }
  if (age < 20.30228) {
    return _MoonPhaseData(
      label: 'Waning Gibbous',
      emoji: '🌖',
      illuminationPercent: illumination,
    );
  }
  if (age < 23.99361) {
    return _MoonPhaseData(
      label: 'Last Quarter',
      emoji: '🌗',
      illuminationPercent: illumination,
    );
  }
  if (age < 27.68493) {
    return _MoonPhaseData(
      label: 'Waning Crescent',
      emoji: '🌘',
      illuminationPercent: illumination,
    );
  }
  return _MoonPhaseData(
    label: 'New Moon',
    emoji: '🌑',
    illuminationPercent: illumination,
  );
}

class _HijriDate {
  const _HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;

  String get monthName => _hijriMonthNames[month - 1];
}

const _hijriMonthNames = <String>[
  'Muharram',
  'Safar',
  'Rabi al-Awwal',
  'Rabi al-Thani',
  'Jumada al-Awwal',
  'Jumada al-Thani',
  'Rajab',
  'Sha\'ban',
  'Ramadan',
  'Shawwal',
  'Dhu al-Qi\'dah',
  'Dhu al-Hijjah',
];

_HijriDate _toHijriDate(DateTime date) {
  final y = date.year;
  final m = date.month;
  final d = date.day;
  final a = ((14 - m) / 12).floor();
  final y2 = y + 4800 - a;
  final m2 = m + 12 * a - 3;
  final jd =
      d +
      ((153 * m2 + 2) / 5).floor() +
      365 * y2 +
      (y2 / 4).floor() -
      (y2 / 100).floor() +
      (y2 / 400).floor() -
      32045;

  var l = jd - 1948440 + 10632;
  final n = ((l - 1) / 10631).floor();
  l = l - 10631 * n + 354;
  final j =
      (((10985 - l) / 5316).floor()) * (((50 * l) / 17719).floor()) +
      ((l / 5670).floor()) * (((43 * l) / 15238).floor());
  l =
      l -
      (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
      ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
      29;
  final month = (24 * l / 709).floor();
  final day = l - (709 * month / 24).floor();
  final year = 30 * n + j - 30;
  return _HijriDate(year: year, month: month, day: day);
}
