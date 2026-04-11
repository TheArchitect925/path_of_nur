import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../features/home/application/home_calendar_progress_provider.dart';
import '../../../../features/profile/application/profile_settings_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/home_prayer_localizations.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../shared/widgets/noor_glass_card.dart';
import '../../../../shared/widgets/noor_liquid_glass.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../application/prayer_controller.dart';
import '../../data/prayer_log_repository.dart';
import '../../domain/prayer_name.dart';
import '../../domain/prayer_status.dart';
import '../../domain/prayer_tracker_fields.dart';
import '../prayer_date_utils.dart';

const Color _salahTrackerPrimaryTextColor = Color(0xFF25221E);

class SalahTimingsTrackerCard extends ConsumerWidget {
  const SalahTimingsTrackerCard({
    super.key,
    required this.selectedDate,
    required this.onSelectedDateChanged,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectedDateChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    ref.watch(homePrayerHistoryEditVersionProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = sameDay(selectedDate, today);
    final isFutureDay = selectedDate.isAfter(today);
    final prayerState = ref.watch(prayerSettingsProvider);
    final profileSettings = ref.watch(profileSettingsProvider);
    final location = ref.watch(prayerLocationProvider);
    final schedule = buildPrayerScheduleForDate(
      date: selectedDate,
      latitude: location.latitude,
      longitude: location.longitude,
      settings: prayerState.preferences,
    ).toList();
    final scheduleContext = isToday
        ? ref.watch(prayerScheduleContextProvider)
        : null;
    final dayKey = LocalStore.todayKey(selectedDate);
    final dayEntries = ref.watch(prayerLogRepositoryProvider).readDayEntries(
      dayKey,
    );
    ref.watch(prayerControllerProvider);
    final completedCount = dayEntries.values
        .where((entry) => entry.status == PrayerStatus.completed)
        .length;
    final trackedPrayerCount = schedule
        .where((item) => item.id != 'tahajjud')
        .length;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final timeFormat = DateFormat.jm(locale);
    final dateLabel = formatPrayerDateLabel(
      context: context,
      l10n: l10n,
      selectedDate: selectedDate,
      calendarMode: profileSettings.prayerCalendarMode,
      todayLabel: l10n.homePrayerDateToday,
      yesterdayLabel: l10n.homePrayerDateYesterday,
      tomorrowLabel: l10n.homePrayerDateTomorrow,
      relativeTo: today,
    );

    if (schedule.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppHeroGlassShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  onSelectedDateChanged(
                    selectedDate.subtract(const Duration(days: 1)),
                  );
                },
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFF7A5A33),
                ),
                tooltip: l10n.homePrayerPreviousDayTooltip,
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await _showPrayerCalendarSheet(
                        context: context,
                        initialDate: selectedDate,
                      );
                      if (picked != null) {
                        onSelectedDateChanged(
                          DateTime(picked.year, picked.month, picked.day),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.homePrayerSectionTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _salahTrackerPrimaryTextColor,
                              fontFamily: 'serif',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateLabel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: _salahTrackerPrimaryTextColor,
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  onSelectedDateChanged(
                    selectedDate.add(const Duration(days: 1)),
                  );
                },
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF7A5A33),
                ),
                tooltip: l10n.homePrayerNextDayTooltip,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: isFutureDay
                    ? const SizedBox.shrink()
                    : Text(
                        l10n.homePrayerCompletedCountValue(
                          _formatLocalizedCount(context, completedCount),
                          _formatLocalizedCount(context, trackedPrayerCount),
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: _salahTrackerPrimaryTextColor,
                          height: 1.3,
                        ),
                      ),
              ),
              IconButton(
                onPressed: () => context.pushNamed('settingsPrayerWorship'),
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF8A7A6B),
                ),
                tooltip: l10n.profilePrayerSettingsTitle,
              ),
            ],
          ),
          if (!isFutureDay) ...[
            const SizedBox(height: 8),
          ] else ...[
            const SizedBox(height: 2),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 10) / 2;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final item in schedule)
                    SizedBox(
                      width: itemWidth,
                      child: Builder(
                        builder: (context) {
                          final trackedPrayer = prayerNameFromScheduleId(
                            item.id,
                          );
                          final entry = dayEntries[trackedPrayer];
                          final completedAt = entry?.completedAtIso == null
                              ? null
                              : DateTime.tryParse(entry!.completedAtIso!);
                          final hasPostSalahDhikr =
                              entry?.postSalahAdhkarCompletedAtIso != null;
                          final canOpenDetails = !isFutureDay;
                          return PrayerTimingPill(
                            prayerId: item.id,
                            name: localizedPrayerNameForDate(
                              prayerId: item.id,
                              l10n: l10n,
                              date: selectedDate,
                            ),
                            arabicName: arabicPrayerNameForDate(
                              prayerId: item.id,
                              date: selectedDate,
                            ),
                            time: item.offerTime,
                            status: entry?.status ?? PrayerStatus.pending,
                            completionDetail: completedAt == null
                                ? null
                                : l10n.worshipPrayerCompletedAt(
                                    timeFormat.format(completedAt),
                                  ),
                            hasPostSalahDhikr: hasPostSalahDhikr,
                            isCurrent:
                                isToday &&
                                item.id == scheduleContext?.currentPrayerId,
                            isNext:
                                isToday &&
                                item.id == scheduleContext?.nextPrayerId,
                            onToggleOffered: isFutureDay
                                ? null
                                : entry?.status == PrayerStatus.completed
                                ? isToday
                                      ? () => ref
                                            .read(
                                              prayerControllerProvider.notifier,
                                            )
                                            .toggleCompleted(trackedPrayer)
                                      : () => toggleHistoricalPrayerCompletion(
                                          ref,
                                          dayKey: dayKey,
                                          prayer: trackedPrayer,
                                          existingEntry: entry,
                                          completedAt: item.offerDateTime,
                                        )
                                : null,
                            onOpenDetails: !canOpenDetails
                                ? null
                                : () => openPrayerTrackerSheet(
                                    context,
                                    ref,
                                    dayKey: dayKey,
                                    prayer: trackedPrayer,
                                    prayerName: localizedPrayerNameForDate(
                                      prayerId: item.id,
                                      l10n: l10n,
                                      date: selectedDate,
                                    ),
                                    selectedDate: selectedDate,
                                    existingEntry: entry,
                                    isToday: isToday,
                                    defaultCompletedAt: isToday
                                        ? DateTime.now()
                                        : item.offerDateTime,
                                  ),
                            onMarkPostSalahDhikr:
                                !isToday || !canOpenDetails || hasPostSalahDhikr
                                ? null
                                : () => ref
                                      .read(prayerControllerProvider.notifier)
                                      .logPostSalahDhikr(trackedPrayer),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

void toggleHistoricalPrayerCompletion(
  WidgetRef ref, {
  required String dayKey,
  required PrayerName prayer,
  required PrayerLogDayEntry? existingEntry,
  required DateTime completedAt,
}) {
  final repository = ref.read(prayerLogRepositoryProvider);
  final entries = Map<PrayerName, PrayerLogDayEntry>.from(
    repository.readDayEntries(dayKey),
  );
  final current = existingEntry ?? entries[prayer];
  final isCompleted = current?.status == PrayerStatus.completed;

  entries[prayer] = isCompleted
      ? const PrayerLogDayEntry(status: PrayerStatus.pending)
      : PrayerLogDayEntry(
          status: PrayerStatus.completed,
          completedAtIso: completedAt.toIso8601String(),
          postSalahAdhkarCompletedAtIso: null,
        );
  repository.saveDayEntries(dayKey, entries);
  ref
      .read(homePrayerHistoryEditVersionProvider.notifier)
      .update((value) => value + 1);
}

Future<void> openPrayerTrackerSheet(
  BuildContext context,
  WidgetRef ref, {
  required String dayKey,
  required PrayerName prayer,
  required String prayerName,
  required DateTime selectedDate,
  required PrayerLogDayEntry? existingEntry,
  required bool isToday,
  required DateTime defaultCompletedAt,
}) async {
  final result = await showModalBottomSheet<_PrayerTrackerResult>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _PrayerTrackerSheet(
      prayerName: prayerName,
      initialTiming: existingEntry?.timing,
      initialPlace: existingEntry?.place,
    ),
  );
  if (result == null) return;

  if (isToday) {
    final controller = ref.read(prayerControllerProvider.notifier);
    final activeEntry = controller.readActiveDayEntry(prayer);
    if (activeEntry?.status != PrayerStatus.completed) {
      controller.markCompleted(prayer);
    }
    ref
        .read(prayerControllerProvider.notifier)
        .saveCompletionDetails(
          prayer,
          timing: result.timing,
          place: result.place,
        );
    return;
  }

  final repository = ref.read(prayerLogRepositoryProvider);
  final entries = Map<PrayerName, PrayerLogDayEntry>.from(
    repository.readDayEntries(dayKey),
  );
  final current = existingEntry ?? entries[prayer];
  entries[prayer] =
      (current ?? const PrayerLogDayEntry(status: PrayerStatus.completed))
          .copyWith(
            status: PrayerStatus.completed,
            completedAtIso:
                current?.completedAtIso ?? defaultCompletedAt.toIso8601String(),
            timing: result.timing,
            place: result.place,
          );
  repository.saveDayEntries(dayKey, entries);
  ref
      .read(homePrayerHistoryEditVersionProvider.notifier)
      .update((value) => value + 1);
}

class _PrayerTrackerResult {
  const _PrayerTrackerResult({required this.timing, required this.place});

  final PrayerOfferTiming timing;
  final PrayerOfferPlace place;
}

class _PrayerTrackerSheet extends StatefulWidget {
  const _PrayerTrackerSheet({
    required this.prayerName,
    required this.initialTiming,
    required this.initialPlace,
  });

  final String prayerName;
  final PrayerOfferTiming? initialTiming;
  final PrayerOfferPlace? initialPlace;

  @override
  State<_PrayerTrackerSheet> createState() => _PrayerTrackerSheetState();
}

class _PrayerTrackerSheetState extends State<_PrayerTrackerSheet> {
  late PrayerOfferTiming _timing;
  late PrayerOfferPlace _place;

  @override
  void initState() {
    super.initState();
    _timing = widget.initialTiming ?? PrayerOfferTiming.onTime;
    _place = widget.initialPlace ?? PrayerOfferPlace.alone;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: PremiumCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.prayerName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.salahHowOfferedTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final timing in const <PrayerOfferTiming>[
                    PrayerOfferTiming.onTime,
                    PrayerOfferTiming.qada,
                  ])
                    ChoiceChip(
                      label: Text(timing.localizedLabel(l10n)),
                      selected: _timing == timing,
                      onSelected: (_) => setState(() => _timing = timing),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                l10n.salahWhereOfferedTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final place in PrayerOfferPlace.values)
                    ChoiceChip(
                      label: Text(place.localizedLabel(l10n)),
                      selected: _place == place,
                      onSelected: (_) => setState(() => _place = place),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.quranCancel),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(
                        _PrayerTrackerResult(timing: _timing, place: _place),
                      ),
                      child: Text(l10n.quranSave),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> _showPrayerCalendarSheet({
  required BuildContext context,
  required DateTime initialDate,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    showDragHandle: true,
    builder: (_) => _PrayerCalendarSheet(initialDate: initialDate),
  );
}

class _PrayerCalendarSheet extends ConsumerStatefulWidget {
  const _PrayerCalendarSheet({required this.initialDate});

  final DateTime initialDate;

  @override
  ConsumerState<_PrayerCalendarSheet> createState() =>
      _PrayerCalendarSheetState();
}

class _PrayerCalendarSheetState extends ConsumerState<_PrayerCalendarSheet> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    _visibleMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final progressByDay = ref.watch(
      homeCalendarMonthProgressProvider(_visibleMonth),
    );
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final nextMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    final dayCount = nextMonth.difference(firstDay).inDays;
    final firstWeekdayOffset = firstDay.weekday % 7;
    final totalCells = (((firstWeekdayOffset + dayCount) / 7).ceil()) * 7;
    final today = DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month - 1,
                        1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Text(
                    DateFormat.yMMMM(locale).format(_visibleMonth),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month + 1,
                        1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 6,
              children: [
                _CalendarLegendItem(
                  label: l10n.homeShortcutSalahLabel,
                  color: AppColors.accentGoldSoft,
                ),
                _CalendarLegendItem(
                  label: l10n.homeShortcutDhikrLabel,
                  color: AppColors.success,
                ),
                _CalendarLegendItem(
                  label: l10n.quranTitle,
                  color: AppColors.caution,
                ),
                _CalendarLegendItem(
                  label: l10n.learnTitle,
                  color: AppColors.onSurfaceSubtle,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: MaterialLocalizations.of(context).narrowWeekdays
                  .map(
                    (day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _salahTrackerPrimaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 8),
            for (var row = 0; row < totalCells ~/ 7; row += 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: List.generate(7, (column) {
                    final index = row * 7 + column;
                    final dayNumber = index - firstWeekdayOffset + 1;
                    if (dayNumber < 1 || dayNumber > dayCount) {
                      return const Expanded(child: SizedBox(height: 48));
                    }
                    final date = DateTime(
                      _visibleMonth.year,
                      _visibleMonth.month,
                      dayNumber,
                    );
                    final summary = progressByDay[date];
                    return Expanded(
                      child: _CalendarDayCell(
                        date: date,
                        isToday: sameDay(date, today),
                        isSelected: sameDay(date, widget.initialDate),
                        summary: summary,
                        onTap: () => Navigator.of(context).pop(date),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CalendarLegendItem extends StatelessWidget {
  const _CalendarLegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            color: _salahTrackerPrimaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.summary,
    required this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final HomeDayProgressSummary? summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: AppColors.accentGold,
    );
    final unselectedStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      surfaceAlphaOverride: 0.12,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            decoration: (isSelected ? selectedStyle : unselectedStyle)
                .decoration(radius: 14, includeShadow: false)
                .copyWith(
                  border: Border.all(
                    color: isSelected
                        ? selectedStyle.borderColor
                        : isToday
                        ? AppColors.accentGoldSoft.withValues(alpha: 0.34)
                        : Colors.transparent,
                  ),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                _CalendarDayProgressRow(summary: summary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarDayProgressRow extends StatelessWidget {
  const _CalendarDayProgressRow({required this.summary});

  final HomeDayProgressSummary? summary;

  @override
  Widget build(BuildContext context) {
    final effective =
        summary ??
        const HomeDayProgressSummary(
          salah: HomeDayProgressLevel.empty,
          dhikr: HomeDayProgressLevel.empty,
          reading: HomeDayProgressLevel.empty,
          learning: HomeDayProgressLevel.empty,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CalendarProgressDot(
          level: effective.salah,
          color: AppColors.accentGoldSoft,
        ),
        const SizedBox(width: 2),
        _CalendarProgressDot(level: effective.dhikr, color: AppColors.success),
        const SizedBox(width: 2),
        _CalendarProgressDot(
          level: effective.reading,
          color: AppColors.caution,
        ),
        const SizedBox(width: 2),
        _CalendarProgressDot(
          level: effective.learning,
          color: AppColors.onSurfaceSubtle,
        ),
      ],
    );
  }
}

class _CalendarProgressDot extends StatelessWidget {
  const _CalendarProgressDot({required this.level, required this.color});

  final HomeDayProgressLevel level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final alpha = switch (level) {
      HomeDayProgressLevel.empty => 0.14,
      HomeDayProgressLevel.partial => 0.48,
      HomeDayProgressLevel.complete => 0.92,
    };
    return Container(
      width: 8,
      height: 4,
      decoration: BoxDecoration(
        color: color.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class PrayerTimingPill extends StatelessWidget {
  const PrayerTimingPill({
    super.key,
    required this.prayerId,
    required this.name,
    required this.arabicName,
    required this.time,
    required this.status,
    required this.isCurrent,
    required this.isNext,
    required this.hasPostSalahDhikr,
    this.completionDetail,
    required this.onToggleOffered,
    this.onOpenDetails,
    this.onMarkPostSalahDhikr,
  });

  final String prayerId;
  final String name;
  final String arabicName;
  final String time;
  final PrayerStatus status;
  final bool isCurrent;
  final bool isNext;
  final bool hasPostSalahDhikr;
  final String? completionDetail;
  final VoidCallback? onToggleOffered;
  final VoidCallback? onOpenDetails;
  final VoidCallback? onMarkPostSalahDhikr;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = _paletteForPrayerId(prayerId);
    final accent = isCurrent
        ? palette.strong
        : isNext
        ? palette.base
        : palette.muted;
    final isCompleted = status == PrayerStatus.completed;
    final pillBackgroundTint =
        Color.lerp(
          palette.soft,
          palette.base,
          isCurrent ? 0.62 : (isNext ? 0.48 : 0.34),
        ) ??
        palette.base;
    final innerCardTop =
        Color.lerp(palette.soft, Colors.white, isCurrent ? 0.18 : 0.30) ??
        palette.soft;
    final innerCardBottom =
        Color.lerp(
          palette.soft,
          palette.base,
          isCurrent ? 0.26 : (isNext ? 0.20 : 0.14),
        ) ??
        palette.base;
    final innerBorderColor =
        Color.lerp(
          Colors.white.withValues(alpha: 0.88),
          palette.base.withValues(alpha: isCurrent ? 0.42 : 0.30),
          isCurrent ? 0.52 : (isNext ? 0.40 : 0.28),
        ) ??
        Colors.white.withValues(alpha: 0.88);
    final pillContent = NoorGlassCard(
      padding: const EdgeInsets.all(4),
      surfaceVariant: AppSurfaceVariant.panel,
      surfaceTintColor: pillBackgroundTint,
      surfaceAlphaOverride: isCurrent ? 0.34 : (isNext ? 0.30 : 0.26),
      includeShadow: false,
      mode: NoorLiquidGlassMode.fake,
      borderRadius: 28,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: innerBorderColor),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              innerCardTop.withValues(alpha: 0.92),
              innerCardBottom.withValues(alpha: 0.86),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconForPrayerId(prayerId), size: 15, color: accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w700,
                      color: _salahTrackerPrimaryTextColor,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: isCompleted ? onToggleOffered : onOpenDetails,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFF5E8A43).withValues(alpha: 0.14)
                          : (onOpenDetails ?? onToggleOffered) == null
                          ? const Color(0xFFF1ECE4)
                          : const Color(0xFFF7F1E8),
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 18,
                      color: isCompleted
                          ? const Color(0xFF5E8A43)
                          : (onOpenDetails ?? onToggleOffered) == null
                          ? const Color(0xFFB4A594)
                          : const Color(0xFF7D705F),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              arabicName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              textDirection: textDirectionForContent(arabicName),
              style: const TextStyle(
                fontSize: 15,
                color: _salahTrackerPrimaryTextColor,
                fontFamily: 'serif',
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _salahTrackerPrimaryTextColor,
                fontFamily: 'serif',
              ),
            ),
            if (isCompleted) ...[
              const SizedBox(height: 4),
              Text(
                completionDetail ?? l10n.homePrayerOfferedStatus,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: _salahTrackerPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.homePrayerCompletedTapHintText,
                style: const TextStyle(
                  fontSize: 11,
                  color: _salahTrackerPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: hasPostSalahDhikr,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: onMarkPostSalahDhikr == null
                          ? null
                          : (_) => onMarkPostSalahDhikr?.call(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hasPostSalahDhikr
                          ? l10n.homePrayerPostSalahDhikrLoggedText
                          : l10n.homePrayerPostSalahDhikrActionText,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: _salahTrackerPrimaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onOpenDetails ?? onToggleOffered,
        child: pillContent,
      ),
    );
  }
}

String _formatLocalizedCount(BuildContext context, num value) {
  return NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

PrayerName prayerNameFromScheduleId(String id) {
  switch (id) {
    case 'fajr':
      return PrayerName.fajr;
    case 'dhuhr':
      return PrayerName.dhuhr;
    case 'asr':
      return PrayerName.asr;
    case 'maghrib':
      return PrayerName.maghrib;
    case 'tahajjud':
      return PrayerName.tahajjud;
    case 'isha':
    default:
      return PrayerName.isha;
  }
}

IconData iconForPrayerId(String prayerId) {
  switch (prayerId) {
    case 'fajr':
      return PrayerName.fajr.icon;
    case 'dhuhr':
      return PrayerName.dhuhr.icon;
    case 'asr':
      return PrayerName.asr.icon;
    case 'maghrib':
      return PrayerName.maghrib.icon;
    case 'tahajjud':
      return PrayerName.tahajjud.icon;
    case 'isha':
    default:
      return PrayerName.isha.icon;
  }
}

_PrayerColorPalette _paletteForPrayerId(String prayerId) {
  switch (prayerId) {
    case 'fajr':
      return const _PrayerColorPalette(
        base: Color(0xFF87AFC7),
        strong: Color(0xFF587D9A),
        muted: Color(0xFF70889A),
        soft: Color(0xFFE6F0F5),
      );
    case 'dhuhr':
      return const _PrayerColorPalette(
        base: Color(0xFFD4A74F),
        strong: Color(0xFF9A6D16),
        muted: Color(0xFFA58850),
        soft: Color(0xFFF6ECD7),
      );
    case 'asr':
      return const _PrayerColorPalette(
        base: Color(0xFFD28D6A),
        strong: Color(0xFF9C5C34),
        muted: Color(0xFFA87455),
        soft: Color(0xFFF5E4D9),
      );
    case 'maghrib':
      return const _PrayerColorPalette(
        base: Color(0xFFC67663),
        strong: Color(0xFF8C4137),
        muted: Color(0xFFA85A4A),
        soft: Color(0xFFF4DFD8),
      );
    case 'tahajjud':
      return const _PrayerColorPalette(
        base: Color(0xFF746EA8),
        strong: Color(0xFF4D467D),
        muted: Color(0xFF625C96),
        soft: Color(0xFFE8E6F5),
      );
    case 'isha':
    default:
      return const _PrayerColorPalette(
        base: Color(0xFF6B7AA8),
        strong: Color(0xFF445173),
        muted: Color(0xFF5C688F),
        soft: Color(0xFFE4E9F5),
      );
  }
}

class _PrayerColorPalette {
  const _PrayerColorPalette({
    required this.base,
    required this.strong,
    required this.muted,
    required this.soft,
  });

  final Color base;
  final Color strong;
  final Color muted;
  final Color soft;
}
