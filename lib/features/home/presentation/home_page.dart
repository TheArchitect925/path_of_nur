import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/nav_tabs.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/celestial/presentation/widgets/celestial_cycle_card.dart';
import '../../../features/history/presentation/widgets/on_this_day_home_card.dart';
import '../application/home_calendar_progress_provider.dart';
import '../../../shared/content/contextual_quran_quotes.dart';
import '../../../features/profile/application/profile_settings_provider.dart';
import '../../../features/worship/application/prayer_controller.dart';
import '../../../features/worship/data/prayer_log_repository.dart';
import '../../../features/worship/domain/prayer_name.dart';
import '../../../features/worship/domain/prayer_status.dart';
import '../../../features/worship/domain/prayer_tracker_fields.dart';
import '../../../features/worship/presentation/prayer_date_utils.dart';
import '../../../features/learn/quran/application/quran_providers.dart';
import '../../../features/learn/prophets/application/daily_learning_service.dart';
import '../../../features/learn/prophets/application/prophets_repository.dart';
import '../../../features/learn/prophets/presentation/widgets/daily_prophet_quiz_card.dart';
import '../../../features/learn/prophets/presentation/widgets/daily_revelation_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/home_prayer_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../../../shared/profile/profile_logo_assets.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/state/shell_state.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/arabic_text_utils.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_verse_content.dart';
import '../../../shared/widgets/shortcut_dock.dart';
import '../../../shared/utils/compact_duration_formatter.dart';
import '../../learn/presentation/data/learn_category_catalog.dart';
import '../../learn/presentation/learn_ui_localization.dart';
import '../../learn/presentation/models/learn_category_item.dart';

String _formatLocalizedCount(BuildContext context, num value) {
  return NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static final math.Random _verseRandom = math.Random();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ValueNotifier<bool> _shortcutsExpanded;

  @override
  void initState() {
    super.initState();
    _shortcutsExpanded = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _shortcutsExpanded.dispose();
    super.dispose();
  }

  void _collapseShortcuts() {
    if (_shortcutsExpanded.value) {
      _shortcutsExpanded.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final verseVersion = ref.watch(homeVerseVersionProvider);
    final displayVerse =
        homeContextualQuotePool[verseVersion % homeContextualQuotePool.length];

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _collapseShortcuts,
          child: SafeArea(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification ||
                    notification is ScrollUpdateNotification ||
                    notification is UserScrollNotification) {
                  _collapseShortcuts();
                }
                return false;
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 136),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TopGreetingBlock(l10n: l10n, userProfile: userProfile),
                    const SizedBox(height: 12),
                    _AyahCard(
                      verse: displayVerse,
                      onTap: () => ref
                          .read(homeVerseVersionProvider.notifier)
                          .update((state) {
                            final poolLength = homeContextualQuotePool.length;
                            if (poolLength <= 1) {
                              return state;
                            }
                            var next = HomePage._verseRandom.nextInt(
                              poolLength,
                            );
                            final current = state % poolLength;
                            while (next == current) {
                              next = HomePage._verseRandom.nextInt(poolLength);
                            }
                            return next;
                          }),
                    ),
                    const SizedBox(height: 14),
                    const _ModeAwareHomeCard(),
                    const SizedBox(height: 10),
                    _SalahSummaryCard(l10n: l10n),
                    const SizedBox(height: 12),
                    const _DailySalahTimingsCard(),
                    const SizedBox(height: 12),
                    const OnThisDayHomeCard(),
                    const SizedBox(height: 12),
                    const CelestialCycleCard(),
                    const SizedBox(height: 12),
                    const _HomeLearningActionsCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 18,
          bottom: 92,
          child: _FloatingShortcutDock(expandedListenable: _shortcutsExpanded),
        ),
      ],
    );
  }
}

class _DailySalahTimingsCard extends ConsumerWidget {
  const _DailySalahTimingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedDate = ref.watch(homePrayerSelectedDateProvider);
    ref.watch(homePrayerHistoryEditVersionProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = sameDay(selectedDate, today);
    final isFutureDay = selectedDate.isAfter(today);
    final profileSettings = ref.watch(profileSettingsProvider);
    final prayerState = ref.watch(prayerSettingsProvider);
    final location = ref.watch(prayerLocationProvider);
    final schedule = buildPrayerScheduleForDate(
      date: selectedDate,
      latitude: location.latitude,
      longitude: location.longitude,
      settings: prayerState.preferences,
    ).where((item) => item.id != 'tahajjud').toList();
    final scheduleContext = isToday
        ? ref.watch(prayerScheduleContextProvider)
        : null;
    final dayKey = LocalStore.todayKey(selectedDate);
    final dayEntries = ref
        .watch(prayerLogRepositoryProvider)
        .readDayEntries(dayKey);
    ref.watch(prayerControllerProvider);
    final completedCount = dayEntries.values
        .where((entry) => entry.status == PrayerStatus.completed)
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

    return _GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      radius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.read(homePrayerSelectedDateProvider.notifier).state =
                      selectedDate.subtract(const Duration(days: 1));
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
                      final picked = await _showHomePrayerCalendarSheet(
                        context: context,
                        initialDate: selectedDate,
                      );
                      if (picked != null) {
                        ref
                            .read(homePrayerSelectedDateProvider.notifier)
                            .state = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
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
                              color: Color(0xFF25221E),
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
                              color: Color(0xFF6E5D4C),
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
                  ref.read(homePrayerSelectedDateProvider.notifier).state =
                      selectedDate.add(const Duration(days: 1));
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
                          _formatLocalizedCount(context, schedule.length),
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF766656),
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
                tooltip: AppLocalizations.of(
                  context,
                ).profilePrayerSettingsTitle,
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
                          final prayer = _prayerNameFromScheduleId(item.id);
                          final entry = dayEntries[prayer];
                          final completedAt = entry?.completedAtIso == null
                              ? null
                              : DateTime.tryParse(entry!.completedAtIso!);
                          final hasPostSalahDhikr =
                              entry?.postSalahAdhkarCompletedAtIso != null;
                          final canOpenDetails =
                              entry?.status == PrayerStatus.completed;
                          return _PrayerTimingPill(
                            prayer: prayer,
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
                                : isToday
                                ? () => ref
                                      .read(prayerControllerProvider.notifier)
                                      .toggleCompleted(prayer)
                                : () => _toggleHistoricalPrayerCompletion(
                                    ref,
                                    dayKey: dayKey,
                                    prayer: prayer,
                                    existingEntry: entry,
                                    completedAt: item.offerDateTime,
                                  ),
                            onOpenDetails: !canOpenDetails
                                ? null
                                : () => _openHomePrayerTrackerSheet(
                                    context,
                                    ref,
                                    dayKey: dayKey,
                                    prayer: prayer,
                                    prayerName: localizedPrayerNameForDate(
                                      prayerId: item.id,
                                      l10n: l10n,
                                      date: selectedDate,
                                    ),
                                    selectedDate: selectedDate,
                                    existingEntry: entry,
                                    isToday: isToday,
                                  ),
                            onMarkPostSalahDhikr:
                                !isToday || !canOpenDetails || hasPostSalahDhikr
                                ? null
                                : () => ref
                                      .read(prayerControllerProvider.notifier)
                                      .logPostSalahDhikr(prayer),
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

void _toggleHistoricalPrayerCompletion(
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

Future<void> _openHomePrayerTrackerSheet(
  BuildContext context,
  WidgetRef ref, {
  required String dayKey,
  required PrayerName prayer,
  required String prayerName,
  required DateTime selectedDate,
  required PrayerLogDayEntry? existingEntry,
  required bool isToday,
}) async {
  final result = await showModalBottomSheet<_HomePrayerTrackerResult>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _HomePrayerTrackerSheet(
      prayerName: prayerName,
      initialTiming: existingEntry?.timing,
      initialPlace: existingEntry?.place,
    ),
  );
  if (result == null) return;

  if (isToday) {
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
  if (current == null || current.status != PrayerStatus.completed) return;
  entries[prayer] = current.copyWith(
    timing: result.timing,
    place: result.place,
  );
  repository.saveDayEntries(dayKey, entries);
  ref
      .read(homePrayerHistoryEditVersionProvider.notifier)
      .update((value) => value + 1);
}

class _HomePrayerTrackerResult {
  const _HomePrayerTrackerResult({required this.timing, required this.place});

  final PrayerOfferTiming timing;
  final PrayerOfferPlace place;
}

class _HomePrayerTrackerSheet extends StatefulWidget {
  const _HomePrayerTrackerSheet({
    required this.prayerName,
    required this.initialTiming,
    required this.initialPlace,
  });

  final String prayerName;
  final PrayerOfferTiming? initialTiming;
  final PrayerOfferPlace? initialPlace;

  @override
  State<_HomePrayerTrackerSheet> createState() =>
      _HomePrayerTrackerSheetState();
}

class _HomePrayerTrackerSheetState extends State<_HomePrayerTrackerSheet> {
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
                        _HomePrayerTrackerResult(
                          timing: _timing,
                          place: _place,
                        ),
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

Future<DateTime?> _showHomePrayerCalendarSheet({
  required BuildContext context,
  required DateTime initialDate,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    showDragHandle: true,
    builder: (_) => _HomePrayerCalendarSheet(initialDate: initialDate),
  );
}

class _HomePrayerCalendarSheet extends ConsumerStatefulWidget {
  const _HomePrayerCalendarSheet({required this.initialDate});

  final DateTime initialDate;

  @override
  ConsumerState<_HomePrayerCalendarSheet> createState() =>
      _HomePrayerCalendarSheetState();
}

class _HomePrayerCalendarSheetState
    extends ConsumerState<_HomePrayerCalendarSheet> {
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
                          color: AppColors.onSurfaceSubtle,
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
            color: AppColors.onSurfaceSubtle,
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isSelected ? selectedStyle.backgroundColor : null,
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

class _TopGreetingBlock extends StatelessWidget {
  const _TopGreetingBlock({required this.l10n, required this.userProfile});

  final AppLocalizations l10n;
  final UserProfileState userProfile;

  String get _address {
    return userProfile.sex == UserSex.brother
        ? l10n.profileBrother
        : l10n.profileSister;
  }

  String get _profileLogoAsset {
    return resolveProfileLogoAsset(userProfile.sex);
  }

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground =
        appearance?.backgroundForeground ?? const Color(0xFF3C2F25);
    final subtleForeground =
        appearance?.backgroundForegroundSubtle ?? const Color(0xFF5D4F44);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  IslamicIcons.mosque,
                  size: 24,
                  color: Color(0xFF6E563E),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.navHome,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                    fontFamily: 'serif',
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                showSearch<void>(
                  context: context,
                  delegate: _HomeGlobalSearchDelegate(
                    l10n: l10n,
                    destinations: _buildHomeSearchDestinations(l10n),
                  ),
                );
              },
              icon: const Icon(
                Icons.search_rounded,
                size: 30,
                color: Color(0xFF7A5A33),
              ),
              tooltip: l10n.homeSearchTooltip,
            ),
            IconButton(
              onPressed: () => context.goNamed('settings'),
              icon: const Icon(
                Icons.settings,
                size: 30,
                color: Color(0xFF7A5A33),
              ),
              tooltip: l10n.profilePrayerSettingsTitle,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          l10n.greetingArabic,
          textAlign: textAlignForContent(l10n.greetingArabic),
          textDirection: textDirectionForContent(l10n.greetingArabic),
          style: TextStyle(
            fontSize: 20,
            color: foreground,
            height: 1.15,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.goNamed('settings'),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Text(
                    '$_address ${userProfile.name}',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                      letterSpacing: 0.2,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.peaceUponYou,
                    style: TextStyle(
                      fontSize: 15,
                      color: subtleForeground,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    _profileLogoAsset,
                    width: 112,
                    height: 112,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          width: 112,
                          height: 112,
                          child: Icon(Icons.account_circle_rounded, size: 64),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrayerTimingPill extends StatelessWidget {
  const _PrayerTimingPill({
    required this.prayer,
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

  final PrayerName prayer;
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
    final palette = _paletteForPrayer(prayer);
    final accent = isCurrent
        ? palette.strong
        : isNext
        ? palette.base
        : palette.muted;
    final background = isCurrent
        ? AppSurfaceTheme.adaptiveColor(
            context,
            palette.base,
            alpha: 0.34,
            solidAlphaWhenDisabled: 0.44,
          )
        : isNext
        ? AppSurfaceTheme.adaptiveColor(
            context,
            palette.base,
            alpha: 0.26,
            solidAlphaWhenDisabled: 0.38,
          )
        : palette.soft;
    final isCompleted = status == PrayerStatus.completed;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: isCompleted ? (onOpenDetails ?? onToggleOffered) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppSurfaceTheme.adaptiveColor(
                context,
                accent,
                alpha: 0.22,
                solidAlphaWhenDisabled: 0.34,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(prayer.icon, size: 15, color: accent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.8,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F2923),
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: onToggleOffered,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? const Color(0xFF5E8A43).withValues(alpha: 0.14)
                            : onToggleOffered == null
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
                            : onToggleOffered == null
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
                  color: Color(0xFF5F554B),
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
                  color: Color(0xFF2F2923),
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
                    color: Color(0xFF5E8A43),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.homePrayerCompletedTapHintText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7D705F),
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
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: hasPostSalahDhikr
                              ? const Color(0xFF5E8A43)
                              : const Color(0xFF5F554B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

PrayerName _prayerNameFromScheduleId(String id) {
  switch (id) {
    case 'fajr':
      return PrayerName.fajr;
    case 'dhuhr':
      return PrayerName.dhuhr;
    case 'asr':
      return PrayerName.asr;
    case 'maghrib':
      return PrayerName.maghrib;
    case 'isha':
    default:
      return PrayerName.isha;
  }
}

_PrayerColorPalette _paletteForPrayer(PrayerName prayer) {
  switch (prayer) {
    case PrayerName.fajr:
      return const _PrayerColorPalette(
        base: Color(0xFF87AFC7),
        strong: Color(0xFF587D9A),
        muted: Color(0xFF70889A),
        soft: Color(0xFFE6F0F5),
      );
    case PrayerName.dhuhr:
      return const _PrayerColorPalette(
        base: Color(0xFFD4A74F),
        strong: Color(0xFF9A6D16),
        muted: Color(0xFFA58850),
        soft: Color(0xFFF6ECD7),
      );
    case PrayerName.asr:
      return const _PrayerColorPalette(
        base: Color(0xFFC9824F),
        strong: Color(0xFF9C5F34),
        muted: Color(0xFFA67B62),
        soft: Color(0xFFF5E6DC),
      );
    case PrayerName.maghrib:
      return const _PrayerColorPalette(
        base: Color(0xFFC56A63),
        strong: Color(0xFF94443E),
        muted: Color(0xFFA46B67),
        soft: Color(0xFFF6E1E0),
      );
    case PrayerName.isha:
      return const _PrayerColorPalette(
        base: Color(0xFF6B6FAF),
        strong: Color(0xFF474C84),
        muted: Color(0xFF717499),
        soft: Color(0xFFE6E8F7),
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

class _FloatingShortcutDock extends ConsumerWidget {
  const _FloatingShortcutDock({required this.expandedListenable});

  final ValueNotifier<bool> expandedListenable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final progress = ref.watch(quranReadingProgressProvider);
    final recitationSession = ref.watch(quranRecitationSessionProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final worship = ref.watch(worshipSummaryProvider);
    final prayerRecords = ref.watch(prayerControllerProvider);
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final fallbackSurah = surahMap[1];
    final currentSurah = surahMap[progress.surahNumber] ?? fallbackSurah;
    final sessionSurah = recitationSession == null
        ? null
        : surahMap[recitationSession.surahNumber];
    final activeSurah = sessionSurah ?? currentSurah ?? fallbackSurah;
    final surahNumber = activeSurah?.number ?? 1;
    final ayahCount = activeSurah?.verseCount ?? 1;
    final initialAyahFromSession = recitationSession?.ayahNumber;
    final progressAyah = progress.ayahNumber;
    final ayahNumber = ayahCount > 0
        ? ((initialAyahFromSession ?? progressAyah).clamp(1, ayahCount))
        : 1;
    final dhikrDailyGoal = math.max(worship.dhikrTarget, 500);
    final missedCount = prayerRecords
        .where((record) => record.status.name == 'missed')
        .length;
    final currentPrayer = scheduleContext.items
        .where((item) => item.id == scheduleContext.currentPrayerId)
        .firstOrNull;
    final timeUntilCurrentEnds = currentPrayer?.overdueDateTime.difference(now);
    final isPrayerUrgent =
        (timeUntilCurrentEnds != null &&
            !timeUntilCurrentEnds.isNegative &&
            timeUntilCurrentEnds <= const Duration(minutes: 60)) ||
        (!scheduleContext.remainingToNext.isNegative &&
            scheduleContext.remainingToNext <= const Duration(minutes: 30));

    final shortcutItems = <({String keyName, ShortcutDockAction action})>[
      (
        keyName: 'quran',
        action: _buildHomeShortcutAction(
          label: l10n.quranTitle,
          icon: Icons.menu_book_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF2D5E45),
            borderColor: Color(0xFF4D8B63),
            shadowColor: Color(0xFF4D8B63),
            gradient: [Color(0xFFEAF9EB), Color(0xFFBDE0C5)],
          ),
          onTap: () => context.pushNamed(
            'quranReader',
            pathParameters: {'surahNumber': surahNumber.toString()},
            queryParameters: {'ayah': ayahNumber.toString()},
          ),
        ),
      ),
      (
        keyName: 'salah',
        action: _buildHomeShortcutAction(
          label: isKidsMode
              ? l10n.kidsHomeShortcutSalahLabel
              : l10n.homeShortcutSalahLabel,
          icon: Icons.checklist_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF69411A),
            borderColor: Color(0xFF9F7A42),
            shadowColor: Color(0xFF9F7A42),
            gradient: [Color(0xFFF8E6D2), Color(0xFFE7BE8E)],
          ),
          statusText: l10n.homeFractionValue(
            _formatLocalizedCount(context, worship.prayerCompleted),
            _formatLocalizedCount(context, worship.prayerTotal),
          ),
          badgeIcon: missedCount > 0 ? Icons.error_outline_rounded : null,
          badgeColor: const Color(0xFFC96A2B),
          badgeTooltip: missedCount > 0
              ? (isKidsMode
                    ? l10n.kidsHomeShortcutMissedCount(missedCount)
                    : l10n.homeShortcutMissedCount(missedCount))
              : null,
          onTap: () => context.pushNamed('worshipPrayerPage'),
        ),
      ),
      (
        keyName: 'dhikr',
        action: _buildHomeShortcutAction(
          label: isKidsMode
              ? l10n.kidsHomeShortcutDhikrLabel
              : l10n.homeShortcutDhikrLabel,
          icon: Icons.favorite_outline_rounded,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF5D4520),
            borderColor: Color(0xFF8F7547),
            shadowColor: Color(0xFF8F7547),
            gradient: [Color(0xFFF6EFD8), Color(0xFFE1D0A0)],
          ),
          statusText: l10n.homeFractionValue(
            _formatLocalizedCount(context, worship.dhikrCount),
            _formatLocalizedCount(context, dhikrDailyGoal),
          ),
          statusCaption: isKidsMode
              ? l10n.kidsHomeShortcutDailyCaption
              : l10n.homeShortcutDailyCaption,
          badgeIcon: dhikrDailyGoal > 0 && worship.dhikrCount >= dhikrDailyGoal
              ? Icons.check_circle_rounded
              : null,
          badgeColor: const Color(0xFF5E8A43),
          badgeTooltip:
              dhikrDailyGoal > 0 && worship.dhikrCount >= dhikrDailyGoal
              ? (isKidsMode
                    ? l10n.kidsHomeShortcutDailyDhikrGoalReached
                    : l10n.homeShortcutDailyDhikrGoalReached)
              : null,
          onTap: () => context.pushNamed('worshipDhikrPage'),
        ),
      ),
      (
        keyName: 'qibla',
        action: _buildHomeShortcutAction(
          label: l10n.homeShortcutQiblaLabel,
          icon: IslamicIcons.qibla,
          palette: const ShortcutDockPalette(
            textColor: Color(0xFF5C4325),
            borderColor: Color(0xFF8A6A3D),
            shadowColor: Color(0xFF8A6A3D),
            gradient: [Color(0xFFF5E6C7), Color(0xFFE1C48F)],
          ),
          onTap: () => context.pushNamed('qiblaFinder'),
        ),
      ),
    ];

    shortcutItems.sort((a, b) {
      final baseOrder = {'quran': 0, 'salah': 1, 'dhikr': 2, 'qibla': 3};
      final aOrder = isPrayerUrgent && a.keyName == 'salah'
          ? -1
          : baseOrder[a.keyName] ?? 99;
      final bOrder = isPrayerUrgent && b.keyName == 'salah'
          ? -1
          : baseOrder[b.keyName] ?? 99;
      return aOrder.compareTo(bOrder);
    });

    return ValueListenableBuilder<bool>(
      valueListenable: expandedListenable,
      builder: (context, expanded, child) {
        return ShortcutDock(
          expanded: expanded,
          openLabel: isKidsMode
              ? l10n.kidsHomeShortcutOpen
              : l10n.homeShortcutOpen,
          closeLabel: isKidsMode
              ? l10n.kidsHomeShortcutClose
              : l10n.homeShortcutClose,
          onToggle: () => expandedListenable.value = !expanded,
          actions: shortcutItems
              .map((item) => item.action)
              .toList(growable: false),
        );
      },
    );
  }
}

ShortcutDockAction _buildHomeShortcutAction({
  required String label,
  required IconData icon,
  required ShortcutDockPalette palette,
  required VoidCallback onTap,
  String? supportingText,
  String? statusText,
  String? statusCaption,
  IconData? badgeIcon,
  Color? badgeColor,
  String? badgeTooltip,
}) {
  return ShortcutDockAction(
    label: label,
    icon: icon,
    onTap: onTap,
    palette: palette,
    supportingText: supportingText,
    statusText: statusText,
    statusCaption: statusCaption,
    badgeIcon: badgeIcon,
    badgeColor: badgeColor,
    badgeTooltip: badgeTooltip,
  );
}

class _HomeSearchDestination {
  const _HomeSearchDestination({
    required this.title,
    required this.subtitle,
    required this.keywords,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final List<String> keywords;
  final void Function(BuildContext context) onSelected;
}

List<_HomeSearchDestination> _buildHomeSearchDestinations(
  AppLocalizations l10n,
) {
  return [
    _HomeSearchDestination(
      title: l10n.navHome,
      subtitle: l10n.homeOverviewHeroSubtitle,
      keywords: ['home', 'dashboard', 'overview'],
      onSelected: (context) => context.go(NavTab.home.path),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchQiblaFinderTitle,
      subtitle: l10n.homeSearchQiblaFinderSubtitle,
      keywords: ['qibla', 'direction', 'compass', 'kaaba', 'ar qibla'],
      onSelected: (context) => context.pushNamed('qiblaFinder'),
    ),
    _HomeSearchDestination(
      title: l10n.worshipTitle,
      subtitle: l10n.worshipSubtitle,
      keywords: ['worship', 'prayer', 'dhikr', 'fasting', 'khusu'],
      onSelected: (context) => context.go(NavTab.worship.path),
    ),
    _HomeSearchDestination(
      title: l10n.worshipTitle,
      subtitle: l10n.worshipSubtitle,
      keywords: [
        'salah',
        'prayer times',
        'fajr',
        'dhuhr',
        'asr',
        'maghrib',
        'isha',
      ],
      onSelected: (context) => context.pushNamed('salahTimes'),
    ),
    _HomeSearchDestination(
      title: l10n.navLearning,
      subtitle: l10n.learnSubtitle,
      keywords: ['learn', 'quran', 'life', 'world', 'hadith', 'notes'],
      onSelected: (context) => context.go(NavTab.learn.path),
    ),
    _HomeSearchDestination(
      title: l10n.quranExplorerTitle,
      subtitle: l10n.quranExplorerSubtitle,
      keywords: ['surah', 'quran', 'reader', 'explorer'],
      onSelected: (context) => context.pushNamed('quranExplorer'),
    ),
    _HomeSearchDestination(
      title: l10n.quranSearchTitle,
      subtitle: l10n.quranSearchSubtitle,
      keywords: ['quran search', 'ayah', 'surah search'],
      onSelected: (context) => context.pushNamed('quranSearch'),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchQuranTopWordsTitle,
      subtitle: l10n.homeSearchQuranTopWordsSubtitle,
      keywords: [
        'top 500 words',
        'quran words',
        'vocabulary',
        'transliteration',
      ],
      onSelected: (context) => context.pushNamed('quranTopWords'),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchNamesOfAllahTitle,
      subtitle: l10n.homeSearchNamesOfAllahSubtitle,
      keywords: ['99 names', 'asma ul husna', 'allah names', 'names of الله'],
      onSelected: (context) => context.pushNamed('quranNamesOfAllah'),
    ),
    _HomeSearchDestination(
      title: l10n.historyArchiveTitle,
      subtitle: l10n.historyArchiveSubtitle,
      keywords: [
        'on this day',
        'history archive',
        'historical calendar',
        'islamic history',
      ],
      onSelected: (context) => context.pushNamed('learnHistoryArchive'),
    ),
    _HomeSearchDestination(
      title: l10n.learnLifeSectionTitle,
      subtitle: l10n.learnLifeSectionSubtitle,
      keywords: ['life', 'family', 'character'],
      onSelected: (context) => context.pushNamed('learnLifeLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.babyNamesTitle,
      subtitle: l10n.babyNamesSubtitle,
      keywords: ['baby', 'names', 'family names', 'muslim baby names'],
      onSelected: (context) => context.pushNamed('babyNamesHome'),
    ),
    _HomeSearchDestination(
      title: l10n.learnWorldSectionTitle,
      subtitle: l10n.learnWorldSectionSubtitle,
      keywords: ['world', 'creation', 'signs'],
      onSelected: (context) => context.pushNamed('learnWorldLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.learnHadithSectionTitle,
      subtitle: l10n.learnHadithSectionSubtitle,
      keywords: ['hadith', 'manners', 'character'],
      onSelected: (context) => context.pushNamed('learnHadithLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.homeSearchImportantHadithTitle,
      subtitle: l10n.homeSearchImportantHadithSubtitle,
      keywords: ['important ahadith', 'hadith 50', 'nawawi', 'hadith study'],
      onSelected: (context) => context.pushNamed('learnHadithImportant'),
    ),
    _HomeSearchDestination(
      title: l10n.learnNotesSectionTitle,
      subtitle: l10n.learnNotesSectionSubtitle,
      keywords: ['notes', 'reflection', 'journal notes'],
      onSelected: (context) => context.pushNamed('learnNotesLanding'),
    ),
    _HomeSearchDestination(
      title: l10n.assistantTitle,
      subtitle: l10n.assistantSubtitle,
      keywords: ['assistant', 'help', 'guide'],
      onSelected: (context) => context.pushNamed('assistant'),
    ),
    _HomeSearchDestination(
      title: l10n.circlesTitle,
      subtitle: l10n.circlesSubtitle,
      keywords: ['community', 'circles', 'groups'],
      onSelected: (context) => context.pushNamed('circlesDiscovery'),
    ),
    _HomeSearchDestination(
      title: l10n.journalTitle,
      subtitle: l10n.journalSubtitle,
      keywords: ['journal', 'timeline', 'memories', 'reflection'],
      onSelected: (context) => context.pushNamed('journalTimeline'),
    ),
    _HomeSearchDestination(
      title: l10n.navPrayer,
      subtitle: l10n.journeySubtitle,
      keywords: ['journey', 'xp', 'streak', 'rings'],
      onSelected: (context) => context.go(NavTab.journey.path),
    ),
    _HomeSearchDestination(
      title: l10n.oceanTitle,
      subtitle: l10n.oceanSubtitle,
      keywords: ['ocean', 'drops', 'rewards'],
      onSelected: (context) => context.pushNamed('oceanDrops'),
    ),
    _HomeSearchDestination(
      title: l10n.wallpaperLibraryTitle,
      subtitle: l10n.wallpaperLibrarySubtitle,
      keywords: ['wallpaper', 'rewards', 'background'],
      onSelected: (context) => context.pushNamed('wallpaperLibrary'),
    ),
    _HomeSearchDestination(
      title: l10n.profilePrayerSettingsTitle,
      subtitle: l10n.profilePrayerSettingsSubtitle,
      keywords: ['profile', 'settings', 'reminders', 'preferences'],
      onSelected: (context) => context.goNamed('settings'),
    ),
    ..._learnCategorySearchDestinations(l10n),
  ];
}

List<_HomeSearchDestination> _learnCategorySearchDestinations(
  AppLocalizations l10n,
) {
  _HomeSearchDestination destinationForCategory(LearnCategoryItem item) {
    final categoryLabel = item.sectionType.replaceAll('-', ' ');
    return _HomeSearchDestination(
      title: item.localizedTitle(l10n),
      subtitle:
          item.localizedDescription(l10n) ??
          l10n.homeLearnCategoryFallbackSubtitle(categoryLabel),
      keywords: [...item.searchKeywords, ...item.tags, item.sectionType],
      onSelected: (context) => context.pushNamed(
        item.routeName,
        pathParameters: item.pathParameters,
        queryParameters: item.queryParameters,
      ),
    );
  }

  return [...LearnCategoryCatalog.searchableItems.map(destinationForCategory)];
}

class _HomeGlobalSearchDelegate extends SearchDelegate<void> {
  _HomeGlobalSearchDelegate({required this.l10n, required this.destinations});

  final AppLocalizations l10n;
  final List<_HomeSearchDestination> destinations;

  @override
  String get searchFieldLabel => l10n.homeSearchHint;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear_rounded),
          tooltip: l10n.homeSearchClearTooltip,
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_rounded),
      tooltip: l10n.homeSearchCloseTooltip,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SearchResultList(
      query: query,
      items: destinations,
      emptyLabel: l10n.homeSearchNoResults,
      onTap: (item) {
        close(context, null);
        item.onSelected(context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchResultList(
      query: query,
      items: destinations,
      emptyLabel: l10n.homeSearchNoResults,
      onTap: (item) {
        close(context, null);
        item.onSelected(context);
      },
    );
  }
}

class _SearchResultList extends StatelessWidget {
  const _SearchResultList({
    required this.query,
    required this.items,
    required this.emptyLabel,
    required this.onTap,
  });

  final String query;
  final List<_HomeSearchDestination> items;
  final String emptyLabel;
  final ValueChanged<_HomeSearchDestination> onTap;

  @override
  Widget build(BuildContext context) {
    final trimmed = query.trim().toLowerCase();
    final filtered = trimmed.isEmpty
        ? items
        : items.where((item) {
            final haystack =
                '${item.title} ${item.subtitle} ${item.keywords.join(' ')}'
                    .toLowerCase();
            return haystack.contains(trimmed);
          }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          style: const TextStyle(color: Color(0xFF65584A)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemBuilder: (context, index) {
        final item = filtered[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => onTap(item),
        );
      },
      separatorBuilder: (_, index) => const Divider(height: 1),
      itemCount: filtered.length,
    );
  }
}

// ignore: unused_element
class _WelcomeCarousel extends StatelessWidget {
  const _WelcomeCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: PageView(
        physics: const BouncingScrollPhysics(),
        children: const [
          _WelcomeCarouselCard(
            icon: Icons.wb_sunny_outlined,
            title: 'homeWelcomeDailyIntentionTitle',
            subtitle: 'homeWelcomeDailyIntentionSubtitle',
          ),
          _WelcomeCarouselCard(
            icon: Icons.schedule_rounded,
            title: 'homeWelcomePrayerRhythmTitle',
            subtitle: 'homeWelcomePrayerRhythmSubtitle',
          ),
          _WelcomeCarouselCard(
            icon: Icons.favorite_outline_rounded,
            title: 'homeWelcomeDhikrQuietTitle',
            subtitle: 'homeWelcomeDhikrQuietSubtitle',
          ),
        ],
      ),
    );
  }
}

class _WelcomeCarouselCard extends StatelessWidget {
  const _WelcomeCarouselCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resolvedTitle = _localize(context, title, l10n);
    final resolvedSubtitle = _localize(context, subtitle, l10n);
    return _GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF2E8DC).withValues(alpha: 0.7),
              border: Border.all(
                color: const Color(0xFFD8C49A).withValues(alpha: 0.45),
              ),
            ),
            child: Icon(icon, color: const Color(0xFF8F6E40)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  resolvedTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3027),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resolvedSubtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF65584A),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localize(
    BuildContext context,
    String keyOrText,
    AppLocalizations l10n,
  ) {
    switch (keyOrText) {
      case 'homeWelcomeDailyIntentionTitle':
        return l10n.homeWelcomeDailyIntentionTitle;
      case 'homeWelcomeDailyIntentionSubtitle':
        return l10n.homeWelcomeDailyIntentionSubtitle;
      case 'homeWelcomePrayerRhythmTitle':
        return l10n.homeWelcomePrayerRhythmTitle;
      case 'homeWelcomePrayerRhythmSubtitle':
        return l10n.homeWelcomePrayerRhythmSubtitle;
      case 'homeWelcomeDhikrQuietTitle':
        return l10n.homeWelcomeDhikrQuietTitle;
      case 'homeWelcomeDhikrQuietSubtitle':
        return l10n.homeWelcomeDhikrQuietSubtitle;
      default:
        return keyOrText;
    }
  }
}

// ignore: unused_element
class _AvatarHaloSection extends StatelessWidget {
  const _AvatarHaloSection();

  @override
  Widget build(BuildContext context) {
    final double size = math.min(MediaQuery.of(context).size.width - 40, 300);
    final double inner = size * 0.53;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0EADD).withValues(alpha: 0.33),
                border: Border.all(
                  color: const Color(0xFFD8C28D).withValues(alpha: 0.64),
                  width: 1.8,
                ),
              ),
            ),
            Container(
              width: inner,
              height: inner,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE9ED98).withValues(alpha: 0.42),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF4F386).withValues(alpha: 0.62),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: inner - 8,
              height: inner - 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEEFA7C).withValues(alpha: 0.84),
                  width: 3.5,
                ),
              ),
            ),
            CircleAvatar(
              radius: inner * 0.38,
              backgroundColor: const Color(0xFFF8EFE2),
              child: CircleAvatar(
                radius: inner * 0.365,
                backgroundColor: const Color(0xFFEFDFC9),
                child: Icon(
                  Icons.person,
                  size: inner * 0.42,
                  color: const Color(0xFF61422D).withValues(alpha: 0.86),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahCard extends StatelessWidget {
  const _AyahCard({required this.verse, required this.onTap});

  final QuranQuote verse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: _GlassCard(
        radius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: QuranVerseContent(
          source: QuranVerseSource(
            ref: verse.ref,
            referenceText: verse.locationText,
          ),
          center: true,
          arabicBaseSize: 34,
          transliterationBaseSize: 16,
          translationBaseSize: 15.5,
        ),
      ),
    );
  }
}

class _SalahSummaryCard extends ConsumerWidget {
  const _SalahSummaryCard({required this.l10n});

  static const _zenithForbiddenLead = Duration(minutes: 5);
  static const _sunsetForbiddenLead = Duration(minutes: 20);

  final AppLocalizations l10n;

  Future<void> _showLocationPicker(
    BuildContext context,
    WidgetRef ref,
    String currentLocationLabel,
  ) async {
    final service = ref.read(prayerLocationSearchServiceProvider);
    final recentLocations = ref.read(prayerRecentLocationsProvider);
    final selection = await showModalBottomSheet<PrayerLocationPickerSelection>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PrayerLocationPickerSheet(
        currentLocationLabel: currentLocationLabel,
        recentLocations: recentLocations,
        onSearch: service.search,
      ),
    );
    if (selection == null) return;
    final notifier = ref.read(prayerSettingsProvider.notifier);
    if (selection.useDeviceLocation) {
      final permissionNotifier = ref.read(locationPermissionProvider.notifier);
      await permissionNotifier.requestWhileUsingApp();
      notifier.useCurrentLocation();
      return;
    }
    if (selection.latitude == null || selection.longitude == null) return;
    await ref
        .read(prayerRecentLocationsStoreProvider)
        .save(
          PrayerRecentLocation(
            label: selection.label,
            latitude: selection.latitude!,
            longitude: selection.longitude!,
          ),
        );
    notifier.setManualLocation(
      label: selection.label,
      latitude: selection.latitude!,
      longitude: selection.longitude!,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(homeDashboardSummaryProvider);
    final worship = summary.worship;
    final journey = summary.journey;
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final prayerSettings = ref.watch(prayerSettingsProvider);
    final displayLocation = ref.watch(prayerLocationDisplayLabelProvider);
    final next = scheduleContext.items
        .where((item) => item.id == scheduleContext.nextPrayerId)
        .firstOrNull;
    final current = scheduleContext.items
        .where((item) => item.id == scheduleContext.currentPrayerId)
        .firstOrNull;
    final forbiddenPeriod = _activeForbiddenPeriod(
      l10n,
      scheduleContext.items,
      now,
    );

    final nextName = next == null
        ? localizedPrayerNameForDate(prayerId: 'dhuhr', l10n: l10n, date: now)
        : localizedPrayerNameForDate(prayerId: next.id, l10n: l10n, date: now);
    final nextArabic = next == null
        ? arabicPrayerNameForDate(prayerId: 'dhuhr', date: now)
        : arabicPrayerNameForDate(prayerId: next.id, date: now);
    final nextAt = next?.offerTime ?? l10n.atTime.replaceFirst('at ', '');
    final currentEndsIn = current == null
        ? null
        : _formatDuration(
            context,
            l10n,
            current.overdueDateTime.difference(now),
          );
    final offerByLabel = l10n.homePrayerBeginsAt(nextAt);
    final offerByValue = nextAt;
    final prayerCompletedValue = l10n.homeFractionValue(
      _formatLocalizedCount(context, worship.prayerCompleted),
      _formatLocalizedCount(context, worship.prayerTotal),
    );
    final dhikrDailyGoal = math.max(worship.dhikrTarget, 500);
    final dhikrValue = l10n.homeFractionValue(
      _formatLocalizedCount(context, worship.dhikrCount),
      _formatLocalizedCount(context, dhikrDailyGoal),
    );
    final locationLabel =
        displayLocation.valueOrNull ??
        (prayerSettings.preferences.useDeviceLocation
            ? l10n.settingsCurrentLocation
            : prayerSettings.preferences.location);

    return InkWell(
      onTap: () => context.pushNamed('salahTimes'),
      borderRadius: BorderRadius.circular(32),
      child: _GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        radius: 32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => _showLocationPicker(context, ref, locationLabel),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xFF7A5A33),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locationLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF4D4036),
                          fontSize: 12.8,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF7A5A33),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  l10n.nextSalah,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6E5D4C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3E8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    size: 22,
                    color: Color(0xFF6E9A73),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF202228),
                          fontFamily: 'serif',
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nextArabic,
                        textAlign: textAlignForContent(nextArabic),
                        textDirection: textDirectionForContent(nextArabic),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4D4036),
                          fontFamily: 'serif',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      offerByValue,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202228),
                        fontFamily: 'serif',
                      ),
                    ),
                    Text(
                      offerByLabel,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF6E5D4C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (forbiddenPeriod != null) ...[
              const SizedBox(height: 10),
              _CompactPrayerMetaChip(
                icon: Icons.block_rounded,
                label: '${forbiddenPeriod.label} • ${forbiddenPeriod.value}',
                color: const Color(0xFFD01919),
              ),
            ] else if (current != null) ...[
              const SizedBox(height: 10),
              _CompactPrayerMetaChip(
                icon: Icons.timelapse_rounded,
                label:
                    '${l10n.homeTimeRemainingToOffer(current.name)} • ${currentEndsIn ?? current.overdueAt}',
              ),
              if (current.hasDelayedMakeUpWindow) ...[
                const SizedBox(height: 8),
                _CompactPrayerMetaChip(
                  icon: Icons.warning_amber_rounded,
                  label: l10n.homePrayerBecomesQada(
                    current.name,
                    current.name,
                    current.overdueAt,
                  ),
                  color: const Color(0xFF9A6D16),
                ),
              ],
            ],
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EBDD).withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFE1CEB8).withValues(alpha: 0.9),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _PrayerSummaryMiniStat(
                          title: l10n.homeShortcutSalahLabel,
                          value: prayerCompletedValue,
                          subtitle: l10n.homeShortcutDailyCaption,
                          icon: Icons.checklist_rounded,
                          tint: const Color(0xFF9F7A42),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PrayerSummaryMiniStat(
                          title: l10n.homeShortcutDhikrLabel,
                          value: dhikrValue,
                          subtitle: l10n.homeShortcutDailyCaption,
                          icon: Icons.favorite_outline_rounded,
                          tint: const Color(0xFF8F7547),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PrayerSummaryMiniStat(
                          title: l10n.streakLabel,
                          value: _formatLocalizedCount(
                            context,
                            journey.currentStreakDays,
                          ),
                          subtitle: l10n.homeCurrentStreakTitle,
                          icon: Icons.local_fire_department_outlined,
                          tint: const Color(0xFFB56D43),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(
    BuildContext context,
    AppLocalizations l10n,
    Duration value,
  ) {
    return formatCompactDuration(
      value,
      localeName: l10n.localeName,
      hourSuffix: l10n.durationCompactHourSuffix,
      minuteSuffix: l10n.durationCompactMinuteSuffix,
    );
  }

  _ForbiddenPrayerPeriod? _activeForbiddenPeriod(
    AppLocalizations l10n,
    List<PrayerScheduleItem> items,
    DateTime now,
  ) {
    PrayerScheduleItem? itemById(String id) =>
        items.where((item) => item.id == id).firstOrNull;

    final fajr = itemById('fajr');
    if (fajr != null) {
      final sunriseStart = fajr.overdueDateTime;
      final sunriseEnd = fajr.makeUpFromDateTime;
      if (!now.isBefore(sunriseStart) && now.isBefore(sunriseEnd)) {
        return _ForbiddenPrayerPeriod(
          label: l10n.homePrayerForbiddenSunrise,
          value: l10n.homeUntilTime(fajr.makeUpFrom),
        );
      }
    }

    final dhuhr = itemById('dhuhr');
    if (dhuhr != null) {
      final zenithStart = dhuhr.windowStartDateTime.subtract(
        _zenithForbiddenLead,
      );
      final zenithEnd = dhuhr.windowStartDateTime;
      if (!now.isBefore(zenithStart) && now.isBefore(zenithEnd)) {
        return _ForbiddenPrayerPeriod(
          label: l10n.homePrayerForbiddenZenith,
          value: l10n.homeUntilTime(dhuhr.windowStart),
        );
      }
    }

    final maghrib = itemById('maghrib');
    if (maghrib != null) {
      final sunsetStart = maghrib.windowStartDateTime.subtract(
        _sunsetForbiddenLead,
      );
      final sunsetEnd = maghrib.windowStartDateTime;
      if (!now.isBefore(sunsetStart) && now.isBefore(sunsetEnd)) {
        return _ForbiddenPrayerPeriod(
          label: l10n.homePrayerForbiddenSunset,
          value: l10n.homeUntilTime(maghrib.windowStart),
        );
      }
    }

    return null;
  }
}

class _PrayerSummaryMiniStat extends StatelessWidget {
  const _PrayerSummaryMiniStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tint.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: tint),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: tint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2F2923),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.2,
              color: Color(0xFF6E5D4C),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactPrayerMetaChip extends StatelessWidget {
  const _CompactPrayerMetaChip({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF6E5D4C),
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForbiddenPrayerPeriod {
  const _ForbiddenPrayerPeriod({required this.label, required this.value});

  final String label;
  final String value;
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 30,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.card,
    );
    return Container(
      padding: padding,
      decoration: surfaceStyle.decoration(radius: radius),
      child: child,
    );
  }
}

class _ModeAwareHomeCard extends ConsumerWidget {
  const _ModeAwareHomeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(homeDashboardSummaryProvider);
    final mode = summary.mode.activeMode;
    if ((mode == AppSpecialMode.none || mode == AppSpecialMode.gentle) &&
        !summary.mode.isKidsMode) {
      return const SizedBox.shrink();
    }

    String title;
    String subtitle;
    IconData icon;
    List<Widget> actions;

    switch (mode) {
      case AppSpecialMode.ramadan:
        title = l10n.modeRamadanHomeTitle;
        subtitle = l10n.modeRamadanHomeSubtitle;
        icon = Icons.nightlight_round;
        actions = [
          _ModeActionChip(
            icon: Icons.fastfood_outlined,
            label: l10n.modeRamadanActionFasting,
            onTap: () => context.pushNamed('worshipFastingPage'),
          ),
          _ModeActionChip(
            icon: Icons.menu_book_outlined,
            label: l10n.modeRamadanActionQuran,
            onTap: () => context.pushNamed('quranExplorer'),
          ),
          _ModeActionChip(
            icon: Icons.rate_review_outlined,
            label: l10n.modeRamadanActionReflect,
            onTap: () => context.pushNamed('learnNotesLanding'),
          ),
        ];
        break;
      case AppSpecialMode.loss:
        title = l10n.modeLossHomeTitle;
        subtitle = l10n.modeLossHomeSubtitle;
        icon = Icons.favorite_border;
        actions = [
          _ModeActionChip(
            icon: Icons.self_improvement_rounded,
            label: l10n.modeLossActionDhikr,
            onTap: () => goToTab(context, NavTab.worship),
          ),
          _ModeActionChip(
            icon: Icons.spa_outlined,
            label: l10n.modeLossActionKhusu,
            onTap: () => context.pushNamed('khusuFocus'),
          ),
          _ModeActionChip(
            icon: Icons.menu_book_outlined,
            label: l10n.modeLossActionMercy,
            onTap: () => context.pushNamed('quranExplorer'),
          ),
        ];
        break;
      case AppSpecialMode.gentle:
        return const SizedBox.shrink();
      case AppSpecialMode.none:
        if (!summary.mode.isKidsMode) return const SizedBox.shrink();
        title = l10n.kidsModeTitle;
        subtitle = l10n.kidsHomeHint;
        icon = Icons.child_care_outlined;
        actions = [
          _ModeActionChip(
            icon: Icons.menu_book_outlined,
            label: l10n.kidsHomeQuickLearning,
            onTap: () => goToTab(context, NavTab.learn),
          ),
          _ModeActionChip(
            icon: Icons.auto_stories_outlined,
            label: l10n.kidsHomeQuickJournal,
            onTap: () => context.pushNamed('journalTimeline'),
          ),
        ];
        break;
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentGoldSoft),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }
}

class _HomeLearningActionsCard extends ConsumerWidget {
  const _HomeLearningActionsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dailyBundle = ref.watch(todayDailyLearningBundleProvider);
    final dailyController = ref.read(dailyLearningControllerProvider.notifier);
    final allProphets = ref.watch(prophetsProvider);

    void openProphetById(String prophetId) {
      context.pushNamed(
        'learnProphetsHub',
        queryParameters: {'prophet': prophetId},
      );
    }

    void openDailyItem() {
      final item = dailyBundle.item;
      dailyController.markTodayCardOpened();
      final linkedProphetId = item.linkedProphetId;
      if (linkedProphetId != null &&
          allProphets.any((entry) => entry.id == linkedProphetId)) {
        dailyController.markTodayLinkedProphetOpened(linkedProphetId);
        openProphetById(linkedProphetId);
        return;
      }
      context.pushNamed(
        'learnProphetsHub',
        queryParameters: const {'tab': 'stories'},
      );
    }

    return PremiumCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          title: Text(
            l10n.homeDailyLearningQuizzesTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(l10n.homeDailyLearningQuizzesSubtitle),
          children: [
            const SizedBox(height: 10),
            DailyRevelationCard(
              item: dailyBundle.item,
              isOpened: dailyBundle.status.cardOpened,
              onOpen: openDailyItem,
              onTakeQuiz: () => context.pushNamed(
                'learnProphetsHub',
                queryParameters: {'tab': 'quiz'},
              ),
              showPracticeLesson: dailyBundle.item.linkedGrowthHabitId != null,
              onPracticeLesson: () {
                final habitId = dailyBundle.item.linkedGrowthHabitId;
                if (habitId != null && habitId.trim().isNotEmpty) {
                  context.go('/journey/habit/$habitId');
                  return;
                }
                context.go('/journey/habits');
              },
            ),
            const SizedBox(height: 10),
            DailyProphetQuizCard(
              question: dailyBundle.quizQuestion,
              isAnswered: dailyBundle.status.quizAnswered,
              selectedIndex: dailyBundle.status.quizSelectedIndex,
              onSelectAnswer: (selected) {
                dailyController.answerTodayQuiz(
                  questionId: dailyBundle.quizQuestion.id,
                  selectedIndex: selected,
                  correctIndex: dailyBundle.quizQuestion.correctAnswerIndex,
                );
              },
              onReviewProphet: () =>
                  openProphetById(dailyBundle.quizQuestion.relatedProphetId),
              onOpenFullQuiz: () => context.pushNamed(
                'learnProphetsHub',
                queryParameters: {'tab': 'quiz'},
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickActionButton(
                  icon: Icons.auto_stories_rounded,
                  label: l10n.homeDailyLearningProphetsQuiz,
                  onTap: () => context.pushNamed(
                    'learnProphetsHub',
                    queryParameters: {'tab': 'quiz'},
                  ),
                ),
                _QuickActionButton(
                  icon: Icons.quiz_rounded,
                  label: l10n.homeDailyLearningIslamicTrivia,
                  onTap: () => context.pushNamed(
                    'learnQuizzesHub',
                    queryParameters: {'filter': 'trivia'},
                  ),
                ),
                _QuickActionButton(
                  icon: Icons.route_rounded,
                  label: l10n.homeDailyLearningKnowledgePaths,
                  onTap: () => context.pushNamed('learnTriviaKnowledgePaths'),
                ),
                _QuickActionButton(
                  icon: Icons.replay_circle_filled_rounded,
                  label: l10n.homeDailyLearningReviewMistakes,
                  onTap: () => context.pushNamed('learnTriviaReview'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeActionChip extends StatelessWidget {
  const _ModeActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: AppColors.accentGold,
    );
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppColors.onSurface),
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: onTap,
      side: BorderSide(color: style.borderColor),
      backgroundColor: style.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      elevation: 0,
      pressElevation: 0,
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: AppColors.accentGold,
    );
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: style.decoration(radius: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accentGold, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
