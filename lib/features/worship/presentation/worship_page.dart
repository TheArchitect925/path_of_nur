import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/prayer/prayer_forbidden_periods.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/reminders/reminder_scheduler.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/utils/compact_duration_formatter.dart';
import '../../../shared/widgets/display/compact_list_tile.dart';
import '../../../shared/widgets/display/hub_list_group.dart';
import '../../../shared/widgets/noor_glass_card.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import '../../home/application/home_calendar_progress_provider.dart';
import '../application/dhikr_daily_goal_provider.dart';
import '../application/fasting_insights_provider.dart';
import '../application/jumuah_leave_provider.dart';
import '../application/prayer_controller.dart';
import '../domain/fasting_status.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_status.dart';
import 'widgets/salah_timings_tracker_card.dart';
import '../../../core/theme/app_icons.dart';

/// The Ibadah landing — "The Prayer Room". The page opens on NOW: the
/// current prayer window with its countdown and situational chips
/// (becomes-qada, Jumu'ah leave-by, forbidden times, Ramadan iftar/suhoor),
/// then the timings tracker, today's numbers, and the Worship + Tools lists.
class WorshipPage extends ConsumerWidget {
  const WorshipPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );

    return SectionHubScaffold(
      ownsBackground: false,
      headerIcon: AppIcons.salah,
      title: l10n.worshipTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.worshipHub,
        kidsMode: isKidsMode,
      ),
      headerActions: [
        IconButton(
          onPressed: () => context.pushNamed('allSearch'),
          icon: const Icon(Icons.search_rounded),
          tooltip: l10n.homeSearchTooltip,
        ),
      ],
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      children: [
        const _WorshipNowHero(),
        const SizedBox(height: AppSpacing.s),
        SalahTimingsTrackerCard(
          selectedDate: ref.watch(homePrayerSelectedDateProvider),
          onSelectedDateChanged: (value) {
            ref.read(homePrayerSelectedDateProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: AppSpacing.s),
        const _WorshipTodayNumbersRow(),
        const SizedBox(height: AppSpacing.m),
        HubListGroup(
          title: l10n.worshipGroupWorshipTitle,
          children: [
            CompactListTile(
              title: l10n.worshipSectionLandingPrayerTitle,
              subtitle: l10n.worshipSalahHubSubtitle,
              leading: const HubLeadingIcon(AppIcons.salah),
              onTap: () => context.pushNamed('worshipPrayerPage'),
            ),
            Consumer(
              builder: (context, ref, _) {
                final dhikrCount = ref.watch(
                  worshipSummaryProvider.select(
                    (summary) => summary.dhikrCount,
                  ),
                );
                return CompactListTile(
                  title: l10n.worshipSectionLandingDhikrTitle,
                  subtitle: l10n.worshipDhikrTodaySubtitle(
                    _formatCount(context, dhikrCount),
                  ),
                  leading: const HubLeadingIcon(AppIcons.dhikr),
                  onTap: () => context.pushNamed('worshipDhikrPage'),
                );
              },
            ),
            CompactListTile(
              title: l10n.worshipSectionLandingDuasTitle,
              subtitle: l10n.worshipSectionLandingDuasSubtitle,
              leading: const HubLeadingIcon(AppIcons.dua),
              onTap: () => context.pushNamed('worshipDuasPage'),
            ),
            Consumer(
              builder: (context, ref, _) {
                final suggestion = ref.watch(fastingSuggestionProvider);
                return CompactListTile(
                  title: l10n.fastingSectionTitle,
                  subtitle:
                      suggestion?.label(l10n) ??
                      l10n.worshipSectionLandingFastingSubtitle,
                  leading: const HubLeadingIcon(AppIcons.fasting),
                  onTap: () => context.pushNamed('worshipFastingPage'),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        HubListGroup(
          title: l10n.worshipGroupToolsTitle,
          children: [
            CompactListTile(
              title: l10n.worshipQiblaFinderTitle,
              subtitle: l10n.worshipQiblaFinderSubtitle,
              leading: const HubLeadingIcon(AppIcons.qibla),
              onTap: () => context.pushNamed('qiblaFinder'),
            ),
            Consumer(
              builder: (context, ref, _) {
                final plannedCount = ref
                    .watch(reminderSchedulerProvider)
                    .items
                    .length;
                return CompactListTile(
                  title: l10n.worshipRemindersAdhanTitle,
                  subtitle: l10n.profilePlannedRemindersToday(plannedCount),
                  leading: const HubLeadingIcon(AppIcons.notifications),
                  onTap: () =>
                      context.pushNamed('settingsNotificationsReminders'),
                );
              },
            ),
            CompactListTile(
              title: l10n.worshipLearnToPrayTitle,
              subtitle: l10n.worshipLearnToPraySubtitle,
              leading: const HubLeadingIcon(AppIcons.learn),
              onTap: () => context.pushNamed('learnSalahHub'),
            ),
          ],
        ),
      ],
    );
  }
}

String _formatCount(BuildContext context, num value) {
  return NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

class _WorshipNowHero extends ConsumerWidget {
  const _WorshipNowHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    final subtle = appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurface;

    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final records = ref.watch(prayerControllerProvider);
    final isRamadan = ref.watch(
      specialModeProvider.select((mode) => mode.isRamadan),
    );

    final current = scheduleContext.items
        .where((item) => item.id == scheduleContext.currentPrayerId)
        .firstOrNull;
    final next = scheduleContext.items
        .where((item) => item.id == scheduleContext.nextPrayerId)
        .firstOrNull;
    final currentPrayerName = current == null
        ? null
        : PrayerName.values
              .where((value) => value.name == current.id)
              .firstOrNull;
    final currentCompleted =
        currentPrayerName != null &&
        records
                .where((record) => record.prayer == currentPrayerName)
                .firstOrNull
                ?.status ==
            PrayerStatus.completed;

    // The hero features the open window when there is one, else the next
    // prayer.
    final featured = current ?? next;
    final featuredIsCurrent = current != null;
    final featuredName = featured == null
        ? ''
        : localizedPrayerNameForDate(
            prayerId: featured.id,
            l10n: l10n,
            date: now,
          );
    final featuredArabic = featured == null
        ? ''
        : arabicPrayerNameForDate(prayerId: featured.id, date: now);
    final eyebrow = featuredIsCurrent
        ? l10n.worshipNowWindowOpen(featuredName)
        : l10n.worshipNowUpNext(featuredName);
    final timeLabel = featuredIsCurrent
        ? l10n.worshipWindowEndsLabel
        : l10n.worshipBeginsAtLabel;
    final timeValue = featuredIsCurrent
        ? (featured?.overdueAt ?? '')
        : (featured?.offerTime ?? '');

    final chips = _buildChips(
      context,
      ref,
      l10n: l10n,
      now: now,
      scheduleContext: scheduleContext,
      current: current,
      isRamadan: isRamadan,
    );

    return NoorGlassCard(
      padding: const EdgeInsets.all(AppSpacing.m + 2),
      surfaceVariant: AppSurfaceVariant.panel,
      borderRadius: AppRadii.glassCard,
      surfaceTintColor: accent,
      surfaceAlphaOverride: 0.12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: theme.textTheme.labelMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(featuredName, style: theme.textTheme.headlineSmall),
                    Text(
                      featuredArabic,
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: subtle,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timeLabel,
                    style: theme.textTheme.bodySmall?.copyWith(color: subtle),
                  ),
                  Text(
                    timeValue,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: chips,
            ),
          ],
          if (featuredIsCurrent &&
              currentPrayerName != null &&
              !currentCompleted) ...[
            const SizedBox(height: AppSpacing.s),
            FilledButton.tonal(
              onPressed: () {
                ref
                    .read(prayerControllerProvider.notifier)
                    .markCompleted(currentPrayerName);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.quickActionsPrayerOffered(featuredName)),
                  ),
                );
              },
              child: Text(l10n.quickActionsMarkPrayer(featuredName)),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildChips(
    BuildContext context,
    WidgetRef ref, {
    required AppLocalizations l10n,
    required DateTime now,
    required PrayerScheduleContext scheduleContext,
    required PrayerScheduleItem? current,
    required bool isRamadan,
  }) {
    final chips = <Widget>[];

    final forbidden = activeForbiddenPrayerPeriod(scheduleContext.items, now);
    if (forbidden != null) {
      chips.add(
        _HeroChip(
          icon: Icons.block_rounded,
          label:
              '${forbiddenPrayerPeriodLabel(l10n, forbidden)} • ${l10n.homeUntilTime(forbidden.untilTime)}',
          color: const Color(0xFFD01919),
        ),
      );
    } else if (current != null && current.hasDelayedMakeUpWindow) {
      final remaining = current.overdueDateTime.difference(now);
      if (!remaining.isNegative) {
        chips.add(
          _HeroChip(
            icon: Icons.timelapse_rounded,
            label: l10n.worshipBecomesQadaIn(
              formatCompactDuration(
                remaining,
                localeName: l10n.localeName,
                hourSuffix: l10n.durationCompactHourSuffix,
                minuteSuffix: l10n.durationCompactMinuteSuffix,
              ),
            ),
            color: const Color(0xFF9A6D16),
          ),
        );
      }
    }

    // Jumu'ah leave-by chip, Fridays only, when the reminder is configured.
    if (now.weekday == DateTime.friday) {
      final preferences = ref.watch(prayerSettingsProvider).preferences;
      final estimated = ref
          .watch(jumuahTravelEstimateMinutesProvider)
          .valueOrNull;
      final leaveAt = jumuahLeaveTimeFor(
        day: now,
        preferences: preferences,
        estimatedTravelMinutes: estimated,
      );
      if (leaveAt != null && now.isBefore(leaveAt)) {
        final materialL10n = MaterialLocalizations.of(context);
        chips.add(
          _HeroChip(
            icon: AppIcons.mosque,
            label: l10n.worshipJumuahLeaveBy(
              materialL10n.formatTimeOfDay(TimeOfDay.fromDateTime(leaveAt)),
            ),
          ),
        );
      }
    }

    // Ramadan: suhoor countdown before fajr, iftar countdown through the day.
    if (isRamadan) {
      final fajr = scheduleContext.items
          .where((item) => item.id == 'fajr')
          .firstOrNull;
      final maghrib = scheduleContext.items
          .where((item) => item.id == 'maghrib')
          .firstOrNull;
      String format(Duration value) => formatCompactDuration(
        value,
        localeName: l10n.localeName,
        hourSuffix: l10n.durationCompactHourSuffix,
        minuteSuffix: l10n.durationCompactMinuteSuffix,
      );
      if (fajr != null && now.isBefore(fajr.offerDateTime)) {
        chips.add(
          _HeroChip(
            icon: Icons.nightlight_round_rounded,
            label: l10n.homeRamadanSuhoorEndsIn(
              format(fajr.offerDateTime.difference(now)),
            ),
          ),
        );
      } else if (maghrib != null && now.isBefore(maghrib.offerDateTime)) {
        chips.add(
          _HeroChip(
            icon: Icons.restaurant_rounded,
            label: l10n.homeRamadanIftarIn(
              format(maghrib.offerDateTime.difference(now)),
            ),
          ),
        );
      }
    }

    return chips;
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final tint =
        color ?? appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s - 1,
        vertical: AppSpacing.xxs + 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: tint.withValues(alpha: 0.4)),
        color: tint.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: tint),
          const SizedBox(width: AppSpacing.xxs + 1),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(color: tint),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorshipTodayNumbersRow extends ConsumerWidget {
  const _WorshipTodayNumbersRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(worshipSummaryProvider);
    final dhikrGoal = ref.watch(dhikrDailyGoalProvider);

    String fastingLabel(FastingStatus status) {
      switch (status) {
        case FastingStatus.notFasting:
          return l10n.fastingStatusNotFasting;
        case FastingStatus.intending:
          return l10n.fastingStatusIntending;
        case FastingStatus.completed:
          return l10n.fastingStatusCompleted;
        case FastingStatus.broken:
          return l10n.fastingStatusBroken;
      }
    }

    return Row(
      children: [
        Expanded(
          child: _TodayNumberTile(
            value: l10n.homeFractionValue(
              _formatCount(context, summary.prayerCompleted),
              _formatCount(
                context,
                summary.prayerTotal < 5 ? 5 : summary.prayerTotal,
              ),
            ),
            label: l10n.homeShortcutSalahLabel,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _TodayNumberTile(
            value: l10n.homeFractionValue(
              _formatCount(context, summary.dhikrCount),
              _formatCount(context, dhikrGoal),
            ),
            label: l10n.homeShortcutDhikrLabel,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _TodayNumberTile(
            value: fastingLabel(summary.fastingStatus),
            label: l10n.fastingSectionTitle,
          ),
        ),
      ],
    );
  }
}

class _TodayNumberTile extends StatelessWidget {
  const _TodayNumberTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final subtle = appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurface;
    return NoorGlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.s - 1,
      ),
      surfaceVariant: AppSurfaceVariant.pill,
      borderRadius: AppRadii.glassTile,
      includeShadow: false,
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(color: subtle),
          ),
        ],
      ),
    );
  }
}
