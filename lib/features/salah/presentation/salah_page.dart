import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../learn/quran/domain/quran_content_refs.dart';
import '../../../features/worship/application/prayer_tracker_controller.dart';
import '../../../features/worship/domain/prayer_name.dart';
import '../../../features/worship/domain/prayer_tracker_fields.dart';
import '../../../features/worship/domain/prayer_status.dart';
import '../../../shared/application/daily_clock_provider.dart';
import '../../../shared/state/location_permission_state.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/arabic_text_utils.dart';
import '../../../shared/widgets/global_background.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';

class SalahTimesPage extends ConsumerStatefulWidget {
  const SalahTimesPage({super.key});

  @override
  ConsumerState<SalahTimesPage> createState() => _SalahTimesPageState();
}

class _SalahTimesPageState extends ConsumerState<SalahTimesPage> {
  final Map<String, GlobalKey> _salahCardKeys = {
    'fajr': GlobalKey(),
    'dhuhr': GlobalKey(),
    'asr': GlobalKey(),
    'maghrib': GlobalKey(),
    'isha': GlobalKey(),
    'tahajjud': GlobalKey(),
  };

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

  Future<void> _jumpToCurrentSalah(String? prayerId) async {
    if (prayerId == null) return;
    final targetKey = _salahCardKeys[prayerId];
    final targetContext = targetKey?.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final settings = ref.watch(prayerSettingsProvider);
    final tracker = ref.watch(prayerTrackerControllerProvider);
    final trackerNotifier = ref.read(prayerTrackerControllerProvider.notifier);
    final displayLocation = ref.watch(prayerLocationDisplayLabelProvider);
    final schedule = ref.watch(prayerScheduleProvider);
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final trackedCount = tracker.records.values
        .where((entry) => entry.status != PrayerStatus.pending)
        .length;
    final mostRecentUntrackedId = _mostRecentUntrackedPrayerId(
      schedule: schedule,
      tracker: tracker.records,
      now: now,
    );
    final salahQuote = _dailySalahQuote(now);
    final locationLabel =
        displayLocation.valueOrNull ??
        (settings.preferences.useDeviceLocation
            ? 'Current location'
            : settings.preferences.location);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const GlobalBackground(),
          SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: const Color(0xFF3C2F25),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      IslamicIcons.prayer,
                      color: Color(0xFF3C2F25),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Salah Timings',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF32251D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _SalahVerseHeader(
                  quote: salahQuote,
                  onOpenQuran: () =>
                      openQuranQuoteLocation(context, salahQuote),
                ),
                const SizedBox(height: 12),
                _SalahSummaryHeader(
                  schedule: schedule,
                  scheduleContext: scheduleContext,
                  now: now,
                  onJumpToCurrent: () =>
                      _jumpToCurrentSalah(scheduleContext.currentPrayerId),
                ),
                const SizedBox(height: 10),
                _DailySalahProgressStrip(
                  trackedCount: trackedCount,
                  totalCount: 5,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () =>
                          _showLocationPicker(context, ref, locationLabel),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Color(0xFF7A5A33),
                            ),
                            SizedBox(width: 2),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () =>
                          _showLocationPicker(context, ref, locationLabel),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        child: Text(
                          locationLabel,
                          style: const TextStyle(
                            color: Color(0xFF4D4036),
                            fontSize: 12.8,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF7A5A33),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '· ${_madhabLabel(settings.preferences.madhab)} · ${_methodLabel(settings.preferences.calculationMethod)}',
                      style: const TextStyle(
                        color: Color(0xFF4D4036),
                        fontSize: 12.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _SalahRakatGuideCard(),
                const SizedBox(height: 16),
                ...List.generate(schedule.length, (index) {
                  final entry = schedule[index];
                  final isNext = scheduleContext.nextPrayerId == entry.id;
                  final isCurrent = scheduleContext.currentPrayerId == entry.id;
                  final trackerEntry = tracker.records[_toPrayerName(entry.id)];
                  final isMostRecentUntracked =
                      mostRecentUntrackedId == entry.id;
                  final highlightCard = isCurrent || isMostRecentUntracked;
                  final offerStatus = _offerTimingText(entry, now);
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == schedule.length - 1 ? 0 : 14,
                    ),
                    child: PremiumCard(
                      key: _salahCardKeys[entry.id],
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (highlightCard)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: isCurrent
                                      ? const Color(
                                          0xFF5E8D58,
                                        ).withValues(alpha: 0.14)
                                      : const Color(
                                          0xFFB58D46,
                                        ).withValues(alpha: 0.14),
                                  border: Border.all(
                                    color: isCurrent
                                        ? const Color(0xFF5E8D58)
                                        : const Color(0xFFB58D46),
                                  ),
                                ),
                                child: Text(
                                  isCurrent
                                      ? 'Track this current salah'
                                      : 'Most recent untracked salah',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            if (isNext || isCurrent)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color:
                                      (isCurrent
                                              ? const Color(0xFF8FAF89)
                                              : const Color(0xFFB58D46))
                                          .withValues(alpha: 0.2),
                                  border: Border.all(
                                    color: isCurrent
                                        ? const Color(0xFF8FAF89)
                                        : const Color(0xFFB58D46),
                                  ),
                                ),
                                child: Text(
                                  isCurrent ? 'Current Salah' : 'Next Salah',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.name,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'serif',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF33281F),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        entry.arabicName,
                                        textAlign: textAlignForContent(
                                          entry.arabicName,
                                        ),
                                        textDirection: textDirectionForContent(
                                          entry.arabicName,
                                        ),
                                        style: AppTextStyles.arabicLearning(
                                          size: 18,
                                          color: const Color(0xFF3F332C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: AppColors.accentGoldSoft,
                                    ),
                                  ),
                                  child: Text(
                                    '${entry.totalRakats} Rakats',
                                    style: const TextStyle(
                                      color: Color(0xFF5B6B5C),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _MetaRow(
                              label: 'Offer time',
                              value: entry.offerTime,
                            ),
                            const SizedBox(height: 6),
                            _MetaRow(
                              label: 'Offer Window',
                              value:
                                  '${entry.windowStart} to ${entry.windowEnd}',
                            ),
                            const SizedBox(height: 6),
                            _MetaRow(
                              label: 'Becomes qada after',
                              value: entry.overdueAt,
                            ),
                            const SizedBox(height: 6),
                            _MetaRow(
                              label: 'Time remaining to offer',
                              value: offerStatus,
                            ),
                            if (entry.hasDelayedMakeUpWindow) ...[
                              const SizedBox(height: 6),
                              _MetaRow(
                                label: 'Make up from',
                                value: entry.makeUpFrom,
                              ),
                            ],
                            const SizedBox(height: 6),
                            _QadaRuleRow(summary: entry.qadaRuleSummary),
                            const SizedBox(height: 10),
                            _SalahTrackerInlineSection(
                              prayerId: entry.id,
                              entry: trackerEntry,
                              isCurrent: isCurrent,
                              onQuickSelect: (timing) {
                                trackerNotifier.setEntry(
                                  _toPrayerName(entry.id),
                                  status: PrayerStatus.completed,
                                  timing: timing,
                                  place: PrayerOfferPlace.alone,
                                );
                              },
                              onOpenDetails: () async {
                                final result =
                                    await showModalBottomSheet<
                                      _SalahTrackerSheetResult
                                    >(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) => _SalahTrackerSheet(
                                        prayerName: entry.name,
                                        initialEntry:
                                            trackerEntry ??
                                            const PrayerTrackerEntry(),
                                      ),
                                    );
                                if (result == null) return;
                                trackerNotifier.setEntry(
                                  _toPrayerName(entry.id),
                                  status: result.status,
                                  timing: result.timing,
                                  place: result.place,
                                  notes: result.notes,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _offerTimingText(PrayerScheduleItem entry, DateTime now) {
  if (now.isBefore(entry.windowStartDateTime)) {
    return 'Starts in ${_formatDuration(entry.windowStartDateTime.difference(now))}';
  }
  if (now.isBefore(entry.overdueDateTime)) {
    return _formatDuration(entry.overdueDateTime.difference(now));
  }
  return 'Offer window ended';
}

String _formatDuration(Duration value) {
  if (value.isNegative) return '0m';
  final totalMinutes = value.inMinutes;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours <= 0) return '${minutes}m';
  return '${hours}h ${minutes}m';
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4F4137),
              fontWeight: FontWeight.w600,
              fontSize: 12.8,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Color(0xFF2F2620),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SalahSummaryHeader extends StatelessWidget {
  const _SalahSummaryHeader({
    required this.schedule,
    required this.scheduleContext,
    required this.now,
    required this.onJumpToCurrent,
  });

  final List<PrayerScheduleItem> schedule;
  final PrayerScheduleContext scheduleContext;
  final DateTime now;
  final VoidCallback onJumpToCurrent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = schedule
        .where((item) => item.id == scheduleContext.currentPrayerId)
        .firstOrNull;
    final next = schedule
        .where((item) => item.id == scheduleContext.nextPrayerId)
        .firstOrNull;
    final currentAccent = _currentSalahAccent(current, now);
    final nextAccent = _nextSalahAccent(next, now);

    return PremiumCard(
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: _SummaryTile(
              label: 'Current Salah',
              title: current?.name ?? 'No active salah',
              subtitle: current == null
                  ? '--'
                  : 'Offer by ${current.overdueAt} • ${_offerTimingText(current, now)}',
              accent: currentAccent,
              emphasized: true,
              trailing: current == null
                  ? null
                  : IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: l10n.accessibilityJumpToCurrentSalah,
                      onPressed: onJumpToCurrent,
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        color: currentAccent,
                        size: 18,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 4,
            child: _SummaryTile(
              label: 'Next Salah',
              title: next?.name ?? 'No upcoming salah',
              subtitle: next == null
                  ? '--'
                  : 'Begins at ${next.offerTime} • ${_startsInText(next, now)}',
              accent: nextAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.accent,
    this.emphasized = false,
    this.trailing,
  });

  final String label;
  final String title;
  final String subtitle;
  final Color accent;
  final bool emphasized;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(emphasized ? 15 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: accent.withValues(alpha: 0.08),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
        boxShadow: emphasized
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
              if (trailing != null) ...<Widget>[trailing!],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: emphasized ? 21 : 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF33281F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.2,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5F5144),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalahRakatGuideCard extends StatelessWidget {
  const _SalahRakatGuideCard();

  static const _rows = [
    ('Fajr', '2 before', '2', '-'),
    ('Dhuhr', '4 before, 2 after', '4', '2 after'),
    ('Asr', '4 before', '4', '-'),
    ('Maghrib', '2 after', '3', '2 after'),
    ('Isha', '2 after', '4', '3 witr + 2 nafl'),
  ];

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Salah Rakat Guide',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF33281F),
            ),
          ),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.45),
              1: FlexColumnWidth(1.35),
              2: FlexColumnWidth(0.9),
              3: FlexColumnWidth(1.2),
            },
            children: [
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Salah',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A4A3D),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Sunnah',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A4A3D),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Fard',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A4A3D),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Nafl / Witr',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A4A3D),
                      ),
                    ),
                  ),
                ],
              ),
              for (final row in _rows)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        row.$1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F2620),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        row.$2,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7B694F),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        row.$3,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5E8D58),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        row.$4,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7B694F),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).salahDailyGuideNote,
            style: TextStyle(color: Color(0xFF6B5C4E), fontSize: 12.2),
          ),
        ],
      ),
    );
  }
}

class _QadaRuleRow extends StatelessWidget {
  const _QadaRuleRow({required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.salahQadaRuleTitle,
            style: TextStyle(
              color: Color(0xFF4F4137),
              fontWeight: FontWeight.w600,
              fontSize: 12.8,
            ),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: l10n.accessibilityReadQadaRule,
          icon: const Icon(
            Icons.help_outline_rounded,
            size: 18,
            color: Color(0xFF7A5A33),
          ),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: PremiumCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.salahQadaRuleTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF33281F),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          summary,
                          style: const TextStyle(
                            height: 1.45,
                            color: Color(0xFF4F4137),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(l10n.salahCloseAction),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DailySalahProgressStrip extends StatelessWidget {
  const _DailySalahProgressStrip({
    required this.trackedCount,
    required this.totalCount,
  });

  final int trackedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = totalCount <= 0 ? 0.0 : trackedCount / totalCount;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF7F0E5).withValues(alpha: 0.9),
        border: Border.all(color: const Color(0xFFD7C2A1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.salahTrackedProgress('$trackedCount', '$totalCount'),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF4E4034),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFE6DCCB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF5E8D58),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalahVerseHeader extends StatelessWidget {
  const _SalahVerseHeader({required this.quote, required this.onOpenQuran});

  final QuranQuote quote;
  final VoidCallback onOpenQuran;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD8C7AF).withValues(alpha: 0.9),
        ),
        color: const Color(0xFFF9F3EA).withValues(alpha: 0.55),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Text(
              l10n.salahReflectionHeaderTitle,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A5A33),
                letterSpacing: 0.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: QuranQuoteBlock(
              quote: quote,
              compact: true,
              onTap: onOpenQuran,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              height: 1,
              color: const Color(0xFFD8C7AF).withValues(alpha: 0.9),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.salahReflectionHeaderNote,
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF6B5C4E)),
                  ),
                ),
                TextButton.icon(
                  onPressed: onOpenQuran,
                  icon: const Icon(Icons.menu_book_rounded, size: 16),
                  label: Text(l10n.salahOpenInQuranAction),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalahTrackerInlineSection extends StatelessWidget {
  const _SalahTrackerInlineSection({
    required this.prayerId,
    required this.entry,
    required this.isCurrent,
    required this.onQuickSelect,
    required this.onOpenDetails,
  });

  final String prayerId;
  final PrayerTrackerEntry? entry;
  final bool isCurrent;
  final ValueChanged<PrayerOfferTiming> onQuickSelect;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final trackerEntry = entry ?? const PrayerTrackerEntry();
    final hasTracked = trackerEntry.status != PrayerStatus.pending;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF8F2EA).withValues(alpha: 0.82),
        border: Border.all(color: const Color(0xFFD8C7AF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.salahTrackSalahTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3F332C),
                  ),
                ),
              ),
              if (hasTracked) _TrackerSummaryPill(entry: trackerEntry),
            ],
          ),
          const SizedBox(height: 8),
          if (isCurrent) ...[
            Text(
              l10n.salahQuickActionsTitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5F5144),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickTrackChip(
                  label: l10n.salahQuickTrackOnTime,
                  icon: Icons.schedule_rounded,
                  color: const Color(0xFF5E8D58),
                  onTap: () => onQuickSelect(PrayerOfferTiming.onTime),
                ),
                _QuickTrackChip(
                  label: l10n.salahQuickTrackLate,
                  icon: Icons.access_time_filled_rounded,
                  color: const Color(0xFFB58D46),
                  onTap: () => onQuickSelect(PrayerOfferTiming.late),
                ),
                _QuickTrackChip(
                  label: l10n.salahQuickTrackQada,
                  icon: Icons.history_toggle_off_rounded,
                  color: const Color(0xFFC85E34),
                  onTap: () => onQuickSelect(PrayerOfferTiming.qada),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onOpenDetails,
                  icon: Icon(
                    isCurrent ? Icons.tune_rounded : Icons.edit_rounded,
                  ),
                  label: Text(
                    isCurrent
                        ? l10n.salahMoreOptionsAction
                        : l10n.salahTrackAction,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickTrackChip extends StatelessWidget {
  const _QuickTrackChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(icon, size: 16, color: color),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.25)),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _TrackerSummaryPill extends StatelessWidget {
  const _TrackerSummaryPill({required this.entry});

  final PrayerTrackerEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final parts = <String>[
      entry.status.localizedLabel(l10n),
      if (entry.timing != null) _salahTimingLabel(entry.timing!),
      if (entry.place != null) _salahPlaceLabel(entry.place!),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFEFE5D4),
      ),
      child: Text(
        parts.join(' • '),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF5F5144),
        ),
      ),
    );
  }
}

class _SalahTrackerSheetResult {
  const _SalahTrackerSheetResult({
    required this.status,
    this.timing,
    this.place,
    this.notes,
  });

  final PrayerStatus status;
  final PrayerOfferTiming? timing;
  final PrayerOfferPlace? place;
  final String? notes;
}

class _SalahTrackerSheet extends StatefulWidget {
  const _SalahTrackerSheet({
    required this.prayerName,
    required this.initialEntry,
  });

  final String prayerName;
  final PrayerTrackerEntry initialEntry;

  @override
  State<_SalahTrackerSheet> createState() => _SalahTrackerSheetState();
}

class _SalahTrackerSheetState extends State<_SalahTrackerSheet> {
  late PrayerStatus _status;
  PrayerOfferTiming? _timing;
  PrayerOfferPlace? _place;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _status = widget.initialEntry.status;
    _timing = widget.initialEntry.timing;
    _place = widget.initialEntry.place;
    _notesController = TextEditingController(text: widget.initialEntry.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canSaveCompleted =
        _status != PrayerStatus.completed ||
        (_timing != null && _place != null);
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
              const SizedBox(height: 12),
              Text(
                l10n.salahStatusTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final status in PrayerStatus.values)
                    ChoiceChip(
                      label: Text(status.localizedLabel(l10n)),
                      selected: _status == status,
                      onSelected: (_) {
                        setState(() {
                          _status = status;
                          if (_status != PrayerStatus.completed) {
                            _timing = null;
                            _place = null;
                            _notesController.text = '';
                          } else {
                            _timing ??= PrayerOfferTiming.onTime;
                            _place ??= PrayerOfferPlace.alone;
                          }
                        });
                      },
                    ),
                ],
              ),
              if (_status == PrayerStatus.completed) ...[
                const SizedBox(height: 14),
                Text(
                  l10n.salahHowOfferedTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final timing in PrayerOfferTiming.values)
                      ChoiceChip(
                        label: Text(_salahTimingLabel(timing)),
                        selected: _timing == timing,
                        onSelected: (_) => setState(() => _timing = timing),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.salahWhereOfferedTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final place in PrayerOfferPlace.values)
                      ChoiceChip(
                        label: Text(_salahPlaceLabel(place)),
                        selected: _place == place,
                        onSelected: (_) => setState(() => _place = place),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _notesController,
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.salahOptionalNotesLabel,
                    hintText: l10n.salahOptionalNotesHint,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
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
                      onPressed: !canSaveCompleted
                          ? null
                          : () => Navigator.of(context).pop(
                              _SalahTrackerSheetResult(
                                status: _status,
                                timing: _status == PrayerStatus.completed
                                    ? _timing
                                    : null,
                                place: _status == PrayerStatus.completed
                                    ? _place
                                    : null,
                                notes: _status == PrayerStatus.completed
                                    ? _notesController.text.trim()
                                    : null,
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

String _madhabLabel(PrayerMadhab madhab) {
  switch (madhab) {
    case PrayerMadhab.shafii:
      return 'Shafi\'i';
    case PrayerMadhab.hanafi:
      return 'Hanafi';
    case PrayerMadhab.maliki:
      return 'Maliki';
    case PrayerMadhab.hanbali:
      return 'Hanbali';
  }
}

String _startsInText(PrayerScheduleItem entry, DateTime now) {
  if (now.isAfter(entry.offerDateTime)) return 'Started';
  return 'Starts in ${_formatDuration(entry.offerDateTime.difference(now))}';
}

Color _currentSalahAccent(PrayerScheduleItem? current, DateTime now) {
  if (current == null) return const Color(0xFF5E8D58);
  final remaining = current.overdueDateTime.difference(now);
  if (remaining.inMinutes <= 20) return const Color(0xFFC85E34);
  if (remaining.inMinutes <= 60) return const Color(0xFFB58D46);
  return const Color(0xFF5E8D58);
}

Color _nextSalahAccent(PrayerScheduleItem? next, DateTime now) {
  if (next == null) return const Color(0xFF7A6B5C);
  final untilStart = next.offerDateTime.difference(now);
  if (untilStart.inMinutes <= 20) return const Color(0xFF8A5E2A);
  return const Color(0xFF7D8FAA);
}

String? _mostRecentUntrackedPrayerId({
  required List<PrayerScheduleItem> schedule,
  required Map<PrayerName, PrayerTrackerEntry> tracker,
  required DateTime now,
}) {
  final dueItems = schedule.where((item) => !item.offerDateTime.isAfter(now));
  PrayerScheduleItem? candidate;
  for (final item in dueItems) {
    final prayerName = _toPrayerName(item.id);
    final entry = tracker[prayerName] ?? const PrayerTrackerEntry();
    if (entry.status == PrayerStatus.pending) {
      candidate = item;
    }
  }
  return candidate?.id;
}

PrayerName _toPrayerName(String prayerId) {
  switch (prayerId) {
    case 'fajr':
      return PrayerName.fajr;
    case 'dhuhr':
      return PrayerName.dhuhr;
    case 'asr':
      return PrayerName.asr;
    case 'maghrib':
      return PrayerName.maghrib;
    case 'isha':
      return PrayerName.isha;
    default:
      return PrayerName.fajr;
  }
}

QuranQuote _dailySalahQuote(DateTime now) {
  final quotes = <QuranQuote>[
    const QuranQuote(ref: QuranQuoteRef(surah: 29, ayah: 45)),
    const QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 43)),
    const QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 238)),
    const QuranQuote(ref: QuranQuoteRef(surah: 23, ayah: 1, ayahEnd: 2)),
    const QuranQuote(ref: QuranQuoteRef(surah: 20, ayah: 14)),
  ];
  final daySeed = DateTime(
    now.year,
    now.month,
    now.day,
  ).difference(DateTime(2024, 1, 1)).inDays;
  return quotes[daySeed % quotes.length];
}

String _salahTimingLabel(PrayerOfferTiming timing) {
  switch (timing) {
    case PrayerOfferTiming.onTime:
      return 'On time';
    case PrayerOfferTiming.late:
      return 'Late';
    case PrayerOfferTiming.qada:
      return 'Qada';
  }
}

String _salahPlaceLabel(PrayerOfferPlace place) {
  switch (place) {
    case PrayerOfferPlace.alone:
      return 'Alone';
    case PrayerOfferPlace.congregation:
      return 'Congregation';
    case PrayerOfferPlace.masjid:
      return 'Masjid';
  }
}

String _methodLabel(PrayerCalculationMethod method) {
  switch (method) {
    case PrayerCalculationMethod.muslimWorldLeague:
      return 'MWL';
    case PrayerCalculationMethod.egyptian:
      return 'Egyptian';
    case PrayerCalculationMethod.isna:
      return 'ISNA';
    case PrayerCalculationMethod.karachi:
      return 'Karachi';
    case PrayerCalculationMethod.ummAlQura:
      return 'Umm al-Qura';
  }
}
