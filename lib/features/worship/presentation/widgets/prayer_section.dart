import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/state/user_profile_state.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../learn/quran/application/quran_spiritual_moment_provider.dart';
import '../../../learn/quran/domain/quran_spiritual_moment_models.dart';
import '../../../learn/quran/presentation/widgets/quran_spiritual_moment_card.dart';
import '../../application/prayer_tracker_controller.dart';
import '../../application/sister_cycle_provider.dart';
import '../../domain/prayer_name.dart';
import '../../domain/prayer_tracker_fields.dart';
import '../../domain/prayer_status.dart';
import 'salah_timings_tracker_card.dart';

class PrayerSection extends ConsumerWidget {
  const PrayerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: l10n.worshipPrayerHubTitle,
            subtitle: l10n.worshipPrayerHubSubtitle,
          ),
          const _PrayerHubTabs(),
          const SizedBox(height: 10),
          const _PrayerHubTabViews(),
        ],
      ),
    );
  }
}

class _PrayerHubTabs extends StatelessWidget {
  const _PrayerHubTabs();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return Container(
      decoration: surfaceStyle.decoration(radius: 14),
      child: TabBar(
        labelColor: AppColors.onSurface,
        unselectedLabelColor: AppColors.onSurfaceSubtle,
        indicatorColor: AppColors.accentGold,
        labelStyle: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: l10n.worshipPrayerTabTimes),
          Tab(text: l10n.worshipPrayerTabQada),
          Tab(text: l10n.worshipPrayerTabStats),
          Tab(text: l10n.worshipPrayerTabRakat),
        ],
      ),
    );
  }
}

class _PrayerHubTabViews extends ConsumerWidget {
  const _PrayerHubTabViews();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (context) {
        final controller = DefaultTabController.of(context);
        final tabChildren = const <Widget>[
          _PrayerTimesTab(),
          _PrayerTrackerTab(),
          _PrayerStatsTab(),
          _PrayerRakatTab(),
        ];

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final index = controller.index.clamp(0, tabChildren.length - 1);
            return KeyedSubtree(
              key: ValueKey(index),
              child: tabChildren[index],
            );
          },
        );
      },
    );
  }
}

class _PrayerTimesTab extends ConsumerWidget {
  const _PrayerTimesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spiritualMoment = ref.watch(
      quranSpiritualMomentBundleProvider((
        QuranSpiritualMomentSurface.prayer,
        false,
        Localizations.localeOf(context).languageCode,
      )),
    );
    final tracker = ref.watch(prayerTrackerControllerProvider);
    final trackerNotifier = ref.read(prayerTrackerControllerProvider.notifier);
    final sisterCycle = ref.watch(sisterCycleProvider);
    final sisterCycleNotifier = ref.read(sisterCycleProvider.notifier);
    final sisterCycleGuidance = ref.watch(sisterCycleGuidanceProvider);
    final userProfile = ref.watch(userProfileProvider);
    final isSister = userProfile.sex == UserSex.sister;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSister) ...[
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          ).worshipPrayerSisterCyclePauseTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Switch.adaptive(
                        value: sisterCycle.active,
                        onChanged: sisterCycleNotifier.setActive,
                      ),
                    ],
                  ),
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
                      AppLocalizations.of(context).worshipPrayerCycleDay(
                        _formatCount(context, sisterCycleGuidance.dayNumber),
                        sisterCycleGuidance.dayNumber,
                      ),
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
                            (item) =>
                                _PrayerTagPill(label: item, fontSize: 11.5),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          ).worshipPrayerExpectedDurationTitle,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DropdownButton<int>(
                        value: sisterCycle.expectedDurationDays,
                        style: Theme.of(context).textTheme.bodyLarge,
                        onChanged: (value) {
                          if (value == null) return;
                          sisterCycleNotifier.setExpectedDurationDays(value);
                        },
                        items: List.generate(
                          6,
                          (index) => DropdownMenuItem(
                            value: index + 5,
                            child: Text(
                              AppLocalizations.of(
                                context,
                              ).homeDaysCount(index + 5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SwitchListTile.adaptive(
                    value: sisterCycle.autoAdjustReminders,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppLocalizations.of(
                        context,
                      ).worshipPrayerAutoAdjustRemindersTitle,
                    ),
                    subtitle: Text(
                      AppLocalizations.of(
                        context,
                      ).worshipPrayerAutoAdjustRemindersSubtitle,
                    ),
                    onChanged: sisterCycleNotifier.setAutoAdjustReminders,
                  ),
                  SwitchListTile.adaptive(
                    value: sisterCycle.sendPurityCheckReminder,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppLocalizations.of(
                        context,
                      ).worshipPrayerPurityCheckReminderTitle,
                    ),
                    subtitle: Text(
                      AppLocalizations.of(
                        context,
                      ).worshipPrayerPurityCheckReminderSubtitle,
                    ),
                    onChanged: sisterCycleNotifier.setSendPurityCheckReminder,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: sisterCycle.notes,
                    onChanged: sisterCycleNotifier.updateNotes,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(
                        context,
                      ).worshipPrayerOptionalPrivateNotesHint,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          SalahTimingsTrackerCard(
            selectedDate: tracker.selectedDate,
            onSelectedDateChanged: trackerNotifier.setSelectedDate,
          ),
          if (spiritualMoment != null) ...[
            const SizedBox(height: 12),
            QuranSpiritualMomentCard(
              bundle: spiritualMoment,
              surface: QuranSpiritualMomentSurface.prayer,
              allowDismiss: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _PrayerTrackerTab extends ConsumerWidget {
  const _PrayerTrackerTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tracker = ref.watch(prayerTrackerControllerProvider);
    final trackerNotifier = ref.read(prayerTrackerControllerProvider.notifier);
    final maxBacklog = tracker.qadaBacklog.values.fold<int>(0, math.max);

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worshipPrayerQadaOverviewTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.worshipPrayerQadaOverviewSubtitle,
                  style: TextStyle(color: AppColors.onSurfaceSubtle),
                ),
                const SizedBox(height: 10),
                ...obligatoryPrayerNames.map(
                  (prayer) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _QadaBacklogBar(
                      prayer: prayer,
                      count: tracker.qadaBacklog[prayer] ?? 0,
                      maxCount: maxBacklog == 0 ? 1 : maxBacklog,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _QadaPlannerCard(
            backlog: tracker.qadaBacklog,
            queue: trackerNotifier.qadaQueue(limit: 20),
            recommendedCadence: _qadaCadenceRecommendation(
              l10n,
              tracker.qadaBacklog.values.fold<int>(0, (a, b) => a + b),
            ),
            estimatedDays: trackerNotifier.estimateQadaDaysToClear(),
            dailyTarget: tracker.dailyQadaTarget,
            dailyCompleted: tracker.dailyQadaCompleted,
            dailyProgress: trackerNotifier.qadaDailyTargetProgress(),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worshipPrayerQadaGuidanceTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  l10n.worshipPrayerQadaGuidanceBody,
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

class _QadaBacklogBar extends StatelessWidget {
  const _QadaBacklogBar({
    required this.prayer,
    required this.count,
    required this.maxCount,
  });

  final PrayerName prayer;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = count <= 0 ? 0.0 : count / maxCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                prayer.localizedLabel(l10n),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              l10n.worshipPrayerQueuedCount(count),
              style: const TextStyle(
                color: AppColors.onSurfaceSubtle,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 9,
            backgroundColor: AppColors.surfaceSoft,
            color: count == 0 ? AppColors.success : const Color(0xFFC85E34),
          ),
        ),
      ],
    );
  }
}

class _StatMiniTile extends StatelessWidget {
  const _StatMiniTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: style.decoration(radius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.onSurfaceSubtle,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PrayerTagPill extends StatelessWidget {
  const _PrayerTagPill({required this.label, this.fontSize = 12});

  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: style.decoration(radius: 999, includeShadow: false),
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _PrayerStatsTab extends ConsumerStatefulWidget {
  const _PrayerStatsTab();

  @override
  ConsumerState<_PrayerStatsTab> createState() => _PrayerStatsTabState();
}

class _PrayerStatsTabState extends ConsumerState<_PrayerStatsTab> {
  DateTime? _selectedMonth;

  DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);

  void _changeMonth(int delta) {
    final current = _selectedMonth ?? _monthStart(DateTime.now());
    setState(() {
      _selectedMonth = DateTime(current.year, current.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tracker = ref.watch(prayerTrackerControllerProvider);
    final todayMonth = _monthStart(DateTime.now());
    final selectedMonth = _selectedMonth ?? _monthStart(tracker.selectedDate);
    final canGoToNextMonth = selectedMonth.isBefore(todayMonth);
    final monthRecords = ref.watch(prayerMonthlyRecordsProvider(selectedMonth));
    final monthEntryRecords = ref.watch(
      prayerMonthlyEntryRecordsProvider(selectedMonth),
    );
    final totalDays = monthRecords.length;
    var completedPoints = 0;
    var totalPoints = 0;
    var missedPoints = 0;
    var timedCompletedCount = 0;
    var onTimeCount = 0;
    var masjidCount = 0;
    var qadaCount = 0;
    for (final daily in monthRecords.values) {
      for (final prayer in obligatoryPrayerNames) {
        final status = daily[prayer] ?? PrayerStatus.pending;
        totalPoints += 1;
        if (status == PrayerStatus.completed) completedPoints += 1;
        if (status == PrayerStatus.missed) missedPoints += 1;
      }
    }
    for (final daily in monthEntryRecords.values) {
      for (final entry in daily.values) {
        if (entry.status != PrayerStatus.completed) continue;
        if (entry.timing != null) {
          timedCompletedCount += 1;
          if (entry.timing == PrayerOfferTiming.onTime) onTimeCount += 1;
          if (entry.timing == PrayerOfferTiming.qada) qadaCount += 1;
        }
        if (entry.place == PrayerOfferPlace.masjid) {
          masjidCount += 1;
        }
      }
    }
    final completion = totalPoints == 0 ? 0.0 : completedPoints / totalPoints;
    final onTimeRate = timedCompletedCount == 0
        ? 0.0
        : onTimeCount / timedCompletedCount;
    final weeklyTrend = _buildWeeklyTrend(
      ref.read(prayerTrackerControllerProvider.notifier),
      tracker.selectedDate,
      l10n: l10n,
      weeks: 8,
    );
    final monthlyTrend = _buildMonthlyTrend(
      ref.read(prayerTrackerControllerProvider.notifier),
      selectedMonth,
      context: context,
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
                _MonthSectionHeader(
                  title: l10n.worshipPrayerMonthlyOverviewTitle,
                  selectedMonth: selectedMonth,
                  canGoToNextMonth: canGoToNextMonth,
                  onPreviousMonth: () => _changeMonth(-1),
                  onNextMonth: canGoToNextMonth ? () => _changeMonth(1) : null,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.worshipPrayerTrackedDays(
                    _formatCount(context, totalDays),
                  ),
                ),
                Text(
                  l10n.worshipPrayerOfferedSalahs(
                    _formatCount(context, completedPoints),
                  ),
                ),
                Text(
                  l10n.worshipPrayerMissedSalahs(
                    _formatCount(context, missedPoints),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatMiniTile(
                        label: l10n.worshipPrayerOnTimeRateTitle,
                        value: l10n.worshipPrayerPercentValue(
                          _formatCount(
                            context,
                            (onTimeRate * 100).toStringAsFixed(0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatMiniTile(
                        label: l10n.worshipPrayerMasjidCountTitle,
                        value: _formatCount(context, masjidCount),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatMiniTile(
                        label: l10n.worshipPrayerQadaCountTitle,
                        value: _formatCount(context, qadaCount),
                      ),
                    ),
                  ],
                ),
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
                  l10n.worshipPrayerCompletionValue(
                    _formatCount(
                      context,
                      (completion * 100).toStringAsFixed(1),
                    ),
                    (completion * 100).round(),
                    _formatCount(
                      context,
                      (completion * 100).toStringAsFixed(1),
                    ),
                  ),
                  style: const TextStyle(color: AppColors.onSurfaceSubtle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worshipPrayerMonthlyConsistencyTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat.yMMMM(
                    Localizations.localeOf(context).toLanguageTag(),
                  ).format(selectedMonth),
                  style: const TextStyle(color: AppColors.onSurfaceSubtle),
                ),
                const SizedBox(height: 10),
                _MonthlyTrackerGrid(
                  selectedMonth: selectedMonth,
                  monthRecords: monthRecords,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _TrendChartCard(
            title: l10n.worshipPrayerWeeklyTrendTitle,
            subtitle: l10n.worshipPrayerWeeklyTrendSubtitle,
            bars: weeklyTrend,
          ),
          const SizedBox(height: 12),
          _TrendChartCard(
            title: l10n.worshipPrayerMonthlyTrendTitle,
            subtitle: l10n.worshipPrayerMonthlyTrendSubtitle,
            bars: monthlyTrend,
          ),
          const SizedBox(height: 12),
          _PrayerConsistencyHeatmapCard(monthRecords: monthRecords),
        ],
      ),
    );
  }
}

class _MonthSectionHeader extends StatelessWidget {
  const _MonthSectionHeader({
    required this.title,
    required this.selectedMonth,
    required this.canGoToNextMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final String title;
  final DateTime selectedMonth;
  final bool canGoToNextMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback? onNextMonth;

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                DateFormat.yMMMM(localeTag).format(selectedMonth),
                style: const TextStyle(color: AppColors.onSurfaceSubtle),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onPreviousMonth,
          tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        IconButton(
          onPressed: onNextMonth,
          tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
          icon: Icon(
            Icons.chevron_right_rounded,
            color: canGoToNextMonth
                ? null
                : AppColors.onSurfaceSubtle.withValues(alpha: 0.5),
          ),
        ),
      ],
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
        children: [_RakatCard()],
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
          children: MaterialLocalizations.of(context).narrowWeekdays
              .map((day) => _WeekdayHead(day))
              .toList(growable: false),
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
                        children: obligatoryPrayerNames
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
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(prayerTrackerControllerProvider.notifier);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.worshipPrayerQadaPlannerTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.worshipPrayerCadenceValue(recommendedCadence),
            style: const TextStyle(
              color: AppColors.onSurfaceSubtle,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.worshipPrayerEstimatedDaysToClear(
              _formatCount(context, estimatedDays),
              estimatedDays,
            ),
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
            l10n.worshipPrayerTodaysQadaTarget(
              _formatCount(context, dailyCompleted),
              _formatCount(context, dailyTarget),
              dailyTarget,
            ),
            style: const TextStyle(
              color: AppColors.onSurfaceSubtle,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ...obligatoryPrayerNames.map(
            (prayer) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(prayer.localizedLabel(l10n))),
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
                    child: Text(l10n.worshipPrayerDoneOneAction),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 18),
          Text(
            l10n.worshipPrayerNextInQueueTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          if (queue.isEmpty)
            Text(
              l10n.worshipPrayerNoQueuedQadaLeft,
              style: TextStyle(color: AppColors.onSurfaceSubtle),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: queue
                  .map(
                    (prayer) =>
                        _PrayerTagPill(label: prayer.localizedLabel(l10n)),
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
      final l10n = AppLocalizations.of(context);
      return PremiumCard(
        child: Text(
          l10n.worshipPrayerNoRecordsThisMonth,
          style: TextStyle(color: AppColors.onSurfaceSubtle),
        ),
      );
    }
    final l10n = AppLocalizations.of(context);
    final days = [...monthRecords.keys]..sort((a, b) => a.compareTo(b));
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.worshipPrayerHeatmapTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.worshipPrayerHeatmapSubtitle,
            style: TextStyle(color: AppColors.onSurfaceSubtle, fontSize: 12.5),
          ),
          const SizedBox(height: 10),
          for (final prayer in obligatoryPrayerNames)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Text(
                      prayer.localizedLabel(l10n),
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

class _RakatCard extends StatefulWidget {
  const _RakatCard();

  @override
  State<_RakatCard> createState() => _RakatCardState();
}

class _RakatCardState extends State<_RakatCard> {
  late final ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final guideColors = _RakatGuideColumnColors.resolve(context);
    final rows = <_RakatGuideRowData>[
      _RakatGuideRowData(
        prayer: l10n.settingsPrayerNameFajr,
        sunnah: l10n.salahRakatGuideFajrSunnah,
        fard: '2',
        nafl: '—',
      ),
      _RakatGuideRowData(
        prayer: l10n.settingsPrayerNameDhuhr,
        sunnah: l10n.salahRakatGuideDhuhrSunnah,
        fard: '4',
        nafl: l10n.salahRakatGuideDhuhrNafl,
      ),
      _RakatGuideRowData(
        prayer: l10n.settingsPrayerNameAsr,
        sunnah: l10n.salahRakatGuideAsrSunnah,
        fard: '4',
        nafl: '—',
      ),
      _RakatGuideRowData(
        prayer: l10n.settingsPrayerNameMaghrib,
        sunnah: l10n.salahRakatGuideMaghribSunnah,
        fard: '3',
        nafl: l10n.salahRakatGuideMaghribNafl,
      ),
      _RakatGuideRowData(
        prayer: l10n.settingsPrayerNameIsha,
        sunnah: l10n.salahRakatGuideIshaSunnah,
        fard: '4',
        nafl: l10n.salahRakatGuideIshaNafl,
      ),
    ];

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.salahRakatGuideTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RakatGuideLegendChip(
                label: l10n.salahRakatGuideSunnahColumn,
                colors: guideColors.sunnah,
              ),
              _RakatGuideLegendChip(
                label: l10n.salahRakatGuideFardColumn,
                colors: guideColors.fard,
              ),
              _RakatGuideLegendChip(
                label: l10n.salahRakatGuideNaflColumn,
                colors: guideColors.nafl,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            interactive: true,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 620),
                child: Column(
                  children: [
                    _RakatGuideRow(
                      isHeader: true,
                      prayer: l10n.salahRakatGuidePrayerColumn,
                      sunnah: l10n.salahRakatGuideSunnahColumn,
                      fard: l10n.salahRakatGuideFardColumn,
                      nafl: l10n.salahRakatGuideNaflColumn,
                    ),
                    const SizedBox(height: 8),
                    ...rows.expand(
                      (row) => [
                        _RakatGuideRow(
                          prayer: row.prayer,
                          sunnah: row.sunnah,
                          fard: row.fard,
                          nafl: row.nafl,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            l10n.salahDailyGuideNote,
            style: const TextStyle(color: AppColors.onSurfaceSubtle),
          ),
        ],
      ),
    );
  }
}

class _RakatGuideRowData {
  const _RakatGuideRowData({
    required this.prayer,
    required this.sunnah,
    required this.fard,
    required this.nafl,
  });

  final String prayer;
  final String sunnah;
  final String fard;
  final String nafl;
}

class _RakatGuideRow extends StatelessWidget {
  const _RakatGuideRow({
    required this.prayer,
    required this.sunnah,
    required this.fard,
    required this.nafl,
    this.isHeader = false,
  });

  final String prayer;
  final String sunnah;
  final String fard;
  final String nafl;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final guideColors = _RakatGuideColumnColors.resolve(context);
    final borderColor = AppSurfaceTheme.adaptiveColor(
      context,
      AppColors.accentGoldSoft,
      alpha: 0.18,
      solidAlphaWhenDisabled: 0.24,
    );
    final headerColor = AppSurfaceTheme.adaptiveColor(
      context,
      AppColors.accentGold,
      alpha: 0.12,
      solidAlphaWhenDisabled: 0.16,
    );
    final rowColor = AppSurfaceTheme.adaptiveColor(
      context,
      AppColors.surfaceSoft,
      alpha: 0.28,
      solidAlphaWhenDisabled: 0.42,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHeader ? headerColor : rowColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _RakatGuideCell(
              text: prayer,
              width: 108,
              isHeader: isHeader,
              colors: guideColors.prayer,
            ),
            const SizedBox(width: 12),
            _RakatGuideCell(
              text: sunnah,
              width: 170,
              isHeader: isHeader,
              colors: guideColors.sunnah,
            ),
            const SizedBox(width: 12),
            _RakatGuideCell(
              text: fard,
              width: 72,
              isHeader: isHeader,
              colors: guideColors.fard,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 12),
            _RakatGuideCell(
              text: nafl,
              width: 130,
              isHeader: isHeader,
              colors: guideColors.nafl,
            ),
          ],
        ),
      ),
    );
  }
}

class _RakatGuideCell extends StatelessWidget {
  const _RakatGuideCell({
    required this.text,
    required this.width,
    required this.isHeader,
    required this.colors,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final double width;
  final bool isHeader;
  final _RakatGuideCellColors colors;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isHeader ? colors.headerFill : colors.fill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHeader ? colors.headerBorder : colors.border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            text,
            textAlign: textAlign,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.w700 : FontWeight.w600,
              color: isHeader ? colors.headerText : colors.text,
            ),
          ),
        ),
      ),
    );
  }
}

class _RakatGuideLegendChip extends StatelessWidget {
  const _RakatGuideLegendChip({required this.label, required this.colors});

  final String label;
  final _RakatGuideCellColors colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.fill,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w700, color: colors.text),
        ),
      ),
    );
  }
}

class _RakatGuideColumnColors {
  const _RakatGuideColumnColors({
    required this.prayer,
    required this.sunnah,
    required this.fard,
    required this.nafl,
  });

  final _RakatGuideCellColors prayer;
  final _RakatGuideCellColors sunnah;
  final _RakatGuideCellColors fard;
  final _RakatGuideCellColors nafl;

  static _RakatGuideColumnColors resolve(BuildContext context) {
    return _RakatGuideColumnColors(
      prayer: _RakatGuideCellColors.fromBase(
        context,
        base: AppColors.surfaceSoft,
        textColor: AppColors.onSurface,
      ),
      sunnah: _RakatGuideCellColors.fromBase(
        context,
        base: const Color(0xFF4C8C74),
        textColor: const Color(0xFF194B38),
      ),
      fard: _RakatGuideCellColors.fromBase(
        context,
        base: const Color(0xFFC78B2B),
        textColor: const Color(0xFF6C4300),
      ),
      nafl: _RakatGuideCellColors.fromBase(
        context,
        base: const Color(0xFF7E6BC6),
        textColor: const Color(0xFF413187),
      ),
    );
  }
}

class _RakatGuideCellColors {
  const _RakatGuideCellColors({
    required this.fill,
    required this.border,
    required this.text,
    required this.headerFill,
    required this.headerBorder,
    required this.headerText,
  });

  final Color fill;
  final Color border;
  final Color text;
  final Color headerFill;
  final Color headerBorder;
  final Color headerText;

  factory _RakatGuideCellColors.fromBase(
    BuildContext context, {
    required Color base,
    required Color textColor,
  }) {
    return _RakatGuideCellColors(
      fill: AppSurfaceTheme.adaptiveColor(
        context,
        base,
        alpha: 0.16,
        solidAlphaWhenDisabled: 0.28,
      ),
      border: AppSurfaceTheme.adaptiveColor(
        context,
        base,
        alpha: 0.24,
        solidAlphaWhenDisabled: 0.4,
      ),
      text: AppSurfaceTheme.adaptiveColor(
        context,
        textColor,
        alpha: 1,
        solidAlphaWhenDisabled: 1,
      ),
      headerFill: AppSurfaceTheme.adaptiveColor(
        context,
        base,
        alpha: 0.24,
        solidAlphaWhenDisabled: 0.38,
      ),
      headerBorder: AppSurfaceTheme.adaptiveColor(
        context,
        base,
        alpha: 0.3,
        solidAlphaWhenDisabled: 0.46,
      ),
      headerText: AppSurfaceTheme.adaptiveColor(
        context,
        textColor,
        alpha: 1,
        solidAlphaWhenDisabled: 1,
      ),
    );
  }
}

List<_TrendPoint> _buildWeeklyTrend(
  PrayerTrackerController controller,
  DateTime anchorDate, {
  required AppLocalizations l10n,
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
      for (final prayer in obligatoryPrayerNames) {
        total += 1;
        if ((map[prayer] ?? PrayerStatus.pending) == PrayerStatus.completed) {
          completed += 1;
        }
      }
    }
    points.add(
      _TrendPoint(
        label: l10n.worshipPrayerWeekLabel(weeks - i, i, weeks - i),
        completionRate: total == 0 ? 0 : (completed / total),
      ),
    );
  }
  return points;
}

List<_TrendPoint> _buildMonthlyTrend(
  PrayerTrackerController controller,
  DateTime anchorDate, {
  required BuildContext context,
  int months = 6,
}) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final points = <_TrendPoint>[];
  for (var i = months - 1; i >= 0; i -= 1) {
    final month = DateTime(anchorDate.year, anchorDate.month - i, 1);
    final records = controller.loadMonthMap(month);
    var total = 0;
    var completed = 0;
    for (final day in records.values) {
      for (final prayer in obligatoryPrayerNames) {
        total += 1;
        if ((day[prayer] ?? PrayerStatus.pending) == PrayerStatus.completed) {
          completed += 1;
        }
      }
    }
    points.add(
      _TrendPoint(
        label: DateFormat.MMM(locale).format(month),
        completionRate: total == 0 ? 0 : completed / total,
      ),
    );
  }
  return points;
}

String _formatCount(BuildContext context, Object value) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  if (value is int) {
    return NumberFormat.decimalPattern(locale).format(value);
  }
  if (value is double) {
    return NumberFormat.decimalPattern(locale).format(value);
  }
  return NumberFormat.decimalPattern(
    locale,
  ).format(num.tryParse(value.toString()) ?? 0);
}

String _qadaCadenceRecommendation(AppLocalizations l10n, int total) {
  if (total <= 0) return l10n.worshipPrayerCadenceQueueClear;
  if (total <= 20) return l10n.worshipPrayerCadenceLight;
  if (total <= 60) return l10n.worshipPrayerCadenceSteady;
  return l10n.worshipPrayerCadenceFocused;
}
