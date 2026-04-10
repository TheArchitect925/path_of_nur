import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/state/user_profile_state.dart';
import '../../../../shared/utils/compact_duration_formatter.dart';
import '../../../../shared/utils/hijri_date_utils.dart';
import '../../../../shared/widgets/moon_phase_visual.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../learn/quran/application/quran_spiritual_moment_provider.dart';
import '../../../learn/quran/domain/quran_spiritual_moment_models.dart';
import '../../../learn/quran/presentation/widgets/quran_spiritual_moment_card.dart';
import '../../data/prayer_log_repository.dart';
import '../../application/prayer_tracker_controller.dart';
import '../../application/sister_cycle_provider.dart';
import '../../domain/prayer_name.dart';
import '../../domain/prayer_tracker_fields.dart';
import '../../domain/prayer_status.dart';
import '../prayer_date_utils.dart';

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
    final l10n = AppLocalizations.of(context);
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
    final settings = ref.watch(prayerSettingsProvider).preferences;
    final location = ref.watch(prayerLocationProvider);
    final schedule = buildPrayerScheduleForDate(
      date: tracker.selectedDate,
      latitude: location.latitude,
      longitude: location.longitude,
      settings: settings,
    ).where((item) => item.id != 'tahajjud').toList();
    final timingContext = _buildTimingContext(
      schedule,
      tracker.selectedDate,
      l10n,
    );
    final moon = moonPhaseVisualForDate(tracker.selectedDate, l10n);
    final hijri = toHijriDate(tracker.selectedDate);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMMEEEEd(locale);
    final fajr = schedule.where((item) => item.id == 'fajr').firstOrNull;
    final maghrib = schedule.where((item) => item.id == 'maghrib').firstOrNull;
    final sunriseLabel = fajr == null
        ? '--'
        : DateFormat.jm(locale).format(fajr.windowEndDateTime);
    final sunsetLabel = maghrib == null
        ? '--'
        : DateFormat.jm(locale).format(maghrib.offerDateTime);
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
          if (spiritualMoment != null) ...[
            QuranSpiritualMomentCard(
              bundle: spiritualMoment,
              surface: QuranSpiritualMomentSurface.prayer,
              allowDismiss: true,
            ),
            const SizedBox(height: 12),
          ],
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: isSister
                      ? [
                          Expanded(
                            child: Text(
                              l10n.worshipPrayerSisterCyclePauseTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
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
                      l10n.worshipPrayerCycleDay(
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
                          l10n.worshipPrayerExpectedDurationTitle,
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
                            child: Text(l10n.homeDaysCount(index + 5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SwitchListTile.adaptive(
                    value: sisterCycle.autoAdjustReminders,
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.worshipPrayerAutoAdjustRemindersTitle),
                    subtitle: Text(
                      l10n.worshipPrayerAutoAdjustRemindersSubtitle,
                    ),
                    onChanged: sisterCycleNotifier.setAutoAdjustReminders,
                  ),
                  SwitchListTile.adaptive(
                    value: sisterCycle.sendPurityCheckReminder,
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.worshipPrayerPurityCheckReminderTitle),
                    subtitle: Text(
                      l10n.worshipPrayerPurityCheckReminderSubtitle,
                    ),
                    onChanged: sisterCycleNotifier.setSendPurityCheckReminder,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: sisterCycle.notes,
                    onChanged: sisterCycleNotifier.updateNotes,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: l10n.worshipPrayerOptionalPrivateNotesHint,
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
                        onTap: () async {
                          final picked = await showPrayerDateSelectionSheet(
                            context: context,
                            l10n: l10n,
                            initialDate: tracker.selectedDate,
                            onCalendarModeChanged:
                                trackerNotifier.setCalendarMode,
                          );
                          if (picked != null) {
                            trackerNotifier.setSelectedDate(picked);
                          }
                        },
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
                              l10n.worshipPrayerHijriDateValue(
                                _formatCount(context, hijri.day),
                                hijriMonthName(l10n, hijri.month),
                                _formatCount(context, hijri.year),
                              ),
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
          _PrayerHistoryCard(selectedDate: tracker.selectedDate),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worshipPrayerSalahTimesTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...schedule.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onTap: () => context.pushNamed('salahTimes'),
                      title: Text(
                        '${localizedPrayerNameForDate(prayerId: item.id, l10n: l10n, date: tracker.selectedDate)} • ${arabicPrayerNameForDate(prayerId: item.id, date: tracker.selectedDate)}',
                      ),
                      subtitle: Text(
                        l10n.worshipPrayerSalahWindowValue(
                          item.offerTime,
                          item.windowStart,
                          item.windowEnd,
                          item.offerTime,
                          item.windowEnd,
                        ),
                      ),
                      trailing: Text(
                        _formatCount(context, item.totalRakats),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
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

class _PrayerHistoryCard extends ConsumerWidget {
  const _PrayerHistoryCard({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dayKey = LocalStore.todayKey(selectedDate);
    final data = ref.watch(prayerLogRepositoryProvider).readDayEntries(dayKey);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final timeFormat = DateFormat.jm(locale);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.worshipPrayerHistoryTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.worshipPrayerHistorySubtitle(
              DateFormat.yMMMd(locale).format(selectedDate),
            ),
            style: const TextStyle(
              color: AppColors.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          ...obligatoryPrayerNames.map((prayer) {
            final raw = data[prayer];
            final completedAt = raw?.completedAtIso == null
                ? null
                : DateTime.tryParse(raw!.completedAtIso!);
            final status = raw?.status ?? PrayerStatus.pending;
            final statusColor = switch (status) {
              PrayerStatus.completed => AppColors.success,
              PrayerStatus.missed => AppColors.caution,
              PrayerStatus.pending => AppColors.onSurfaceSubtle,
            };
            final statusStyle = AppSurfaceTheme.resolve(
              context,
              variant: AppSurfaceVariant.panel,
              tintColor: statusColor,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: statusStyle
                    .decoration(radius: 14, includeShadow: false)
                    .copyWith(
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.24),
                      ),
                    ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prayer.localizedLabelForDate(l10n, selectedDate),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            completedAt != null
                                ? l10n.worshipPrayerCompletedAt(
                                    timeFormat.format(completedAt),
                                  )
                                : status == PrayerStatus.missed
                                ? l10n.worshipPrayerMarkedMissed
                                : l10n.worshipPrayerNoRecordedCompletionYet,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      status.localizedLabel(l10n),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
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

class _PrayerMiniPanel extends StatelessWidget {
  const _PrayerMiniPanel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: style.decoration(radius: 12),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600),
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

class _PrayerStatsTab extends ConsumerWidget {
  const _PrayerStatsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tracker = ref.watch(prayerTrackerControllerProvider);
    final monthRecords = ref.watch(
      prayerMonthlyRecordsProvider(tracker.selectedDate),
    );
    final monthEntryRecords = ref.watch(
      prayerMonthlyEntryRecordsProvider(tracker.selectedDate),
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
      tracker.selectedDate,
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
                Text(
                  l10n.worshipPrayerMonthlyOverviewTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
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
                  ).format(tracker.selectedDate),
                  style: const TextStyle(color: AppColors.onSurfaceSubtle),
                ),
                const SizedBox(height: 10),
                _MonthlyTrackerGrid(
                  selectedMonth: tracker.selectedDate,
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

class _RakatCard extends StatelessWidget {
  const _RakatCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.worshipPrayerRakatGuideTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.worshipPrayerRakatGuideValue(
              l10n.settingsPrayerNameFajr,
              l10n.settingsPrayerNameDhuhr,
              l10n.settingsPrayerNameAsr,
              l10n.settingsPrayerNameMaghrib,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.worshipPrayerRakatGuideTip,
            style: const TextStyle(color: AppColors.onSurfaceSubtle),
          ),
        ],
      ),
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

  final MoonPhaseVisualData moon;
  final List<PrayerScheduleItem> prayerSchedule;
  final String? nextPrayerName;
  final Duration remaining;
  final String sunriseLabel;
  final String sunsetLabel;
  final String moonriseLabel;
  final String moonsetLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.worshipPrayerMoonPhaseTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.worshipPrayerMoonPhaseIllumination(
                    moon.label,
                    _formatCount(context, moon.illuminationPercent),
                    moon.illuminationPercent,
                  ),
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
                    children: [MoonPhaseVisual(moon: moon)],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _PrayerMiniPanel(
                  label: l10n.worshipPrayerSunriseValue(sunriseLabel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PrayerMiniPanel(
                  label: l10n.worshipPrayerSunsetValue(sunsetLabel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _PrayerMiniPanel(
                  label: l10n.worshipPrayerMoonriseValue(moonriseLabel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PrayerMiniPanel(
                  label: l10n.worshipPrayerMoonsetValue(moonsetLabel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            nextPrayerName == null
                ? l10n.worshipPrayerNoUpcomingPrayer
                : l10n.worshipPrayerNextPrayerIn(
                    nextPrayerName!,
                    _humanDuration(context, l10n, remaining),
                  ),
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
    final l10n = AppLocalizations.of(context);
    // positions correspond to the five prayer points around the moon widget.
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final center = Offset(size.width / 2, size.height / 2);
        final radius = size.width * 0.40;
        return Stack(
          children: List.generate(schedule.length.clamp(0, 5), (i) {
            final angle = (-math.pi / 2) + (2 * math.pi * (i / 5));
            final point = Offset(
              center.dx + radius * math.cos(angle),
              center.dy + radius * math.sin(angle),
            );
            final item = schedule[i];
            final label = l10n.worshipPrayerOverlayLabel(
              localizedPrayerNameForDate(
                prayerId: item.id,
                l10n: l10n,
                date: item.offerDateTime,
              ),
              item.offerTime,
            );
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
          }),
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
  AppLocalizations l10n,
) {
  if (schedule.isEmpty) {
    return const _TimingContext(
      nextPrayerName: null,
      remainingToNext: Duration.zero,
      progressToNext: 0,
    );
  }
  final now = sameDay(selectedDate, DateTime.now())
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
    nextPrayerName: localizedPrayerNameForDate(
      prayerId: next.id,
      l10n: l10n,
      date: selectedDate,
    ),
    remainingToNext: next.windowStartDateTime.difference(now),
    progressToNext: (elapsed / total).clamp(0.0, 1.0),
  );
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

String _humanDuration(
  BuildContext context,
  AppLocalizations l10n,
  Duration duration,
) {
  return formatCompactDuration(
    duration,
    localeName: l10n.localeName,
    hourSuffix: l10n.durationCompactHourSuffix,
    minuteSuffix: l10n.durationCompactMinuteSuffix,
  );
}
