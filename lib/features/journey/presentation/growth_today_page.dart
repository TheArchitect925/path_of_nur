import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthTodayPage extends ConsumerWidget {
  const GrowthTodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedDate = ref.watch(growthSelectedDateProvider);
    final seasonal = ref.watch(growthSeasonalContextProvider);
    final seasonalCards = ref.watch(growthActiveSeasonalJourneyCardsProvider);
    final ramadanDashboard = ref.watch(growthRamadanDashboardProvider);
    final quranTracker = ref.watch(growthRamadanQuranTrackerProvider);
    final fastTracking = ref.watch(growthFastTrackingProvider);
    final summary = ref.watch(growthTodaySummaryProvider);
    final endOfDay = ref.watch(growthEndOfDaySummaryProvider);
    final encouragement = ref.watch(growthEncouragementCopyProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final decimalFormat = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: 1,
    );

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
                label: Text(growthDateLabelForLocale(date, locale)),
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
                          countFormat.format(
                            (summary.completionProgress * 100).round(),
                          ),
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
                      l10n.growthTodaySummaryTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.growthTodayCompletedSummary(
                        countFormat.format(summary.completedCount),
                        countFormat.format(summary.dueCount),
                      ),
                    ),
                    if (summary.partialCount > 0)
                      Text(
                        l10n.growthTodayInProgressSummary(summary.partialCount),
                      ),
                    Text(
                      l10n.growthTodayLightAdded(
                        countFormat.format(summary.visibleLightEarnedToday),
                      ),
                    ),
                    if (summary.subtleLightEarnedToday >
                        summary.visibleLightEarnedToday)
                      Text(
                        l10n.growthTodayQuietProgressNote,
                        style: TextStyle(
                          color: growthNoorSubtleTextColor(context),
                          fontSize: 12,
                        ),
                      ),
                    Text(
                      l10n.growthTodaySteadyDaysSummary(
                        countFormat.format(summary.currentStreakDays),
                        countFormat.format(summary.bestStreakDays),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: growthNoorSubtleTextColor(context),
                      ),
                    ),
                    if (summary.protectedDaysUsedThisWeek > 0)
                      Text(
                        l10n.growthTodayGentleReturnSupport(
                          summary.protectedDaysUsedThisWeek,
                        ),
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
        if (seasonal.activeSeasons.isNotEmpty) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      seasonal.isRamadanMode
                          ? l10n.growthTodaySeasonalJourneyTitle
                          : l10n.growthTodaySeasonalRhythmTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text(
                      l10n.growthJourneyHijriDateCompactValue(
                        countFormat.format(seasonal.hijriDate.day),
                        seasonal.hijriDate.monthName,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6A5A4A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: ref
                      .watch(growthControllerProvider)
                      .ramadanModeOverride,
                  onChanged: (v) => ref
                      .read(growthControllerProvider.notifier)
                      .setRamadanModeOverride(v),
                  title: Text(l10n.growthTodayRamadanModeOverrideTitle),
                  subtitle: Text(l10n.growthTodayRamadanModeOverrideSubtitle),
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
                          decoration: growthNoorPillDecoration(context),
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
                Text(
                  l10n.growthTodayRamadanSnapshotTitle,
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
                  l10n.growthTodayJuzJourneyValue(
                    decimalFormat.format(quranTracker.currentJuzProgress),
                  ),
                ),
                Text(
                  l10n.growthTodayFastTrackingValue(
                    _fastTypeLabel(fastTracking.selectedType, l10n),
                  ),
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
              Text(
                l10n.growthTodayHabitTrackerTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(l10n.growthTodayHabitTrackerSubtitle),
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('growthHabitsPage'),
                child: Text(l10n.growthTodayOpenHabitTracker),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthTodayEndOfDayTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthTodayEndOfDaySummary(
                  countFormat.format(endOfDay.completionPercent),
                  countFormat.format(endOfDay.completed),
                  countFormat.format(endOfDay.partial),
                  countFormat.format(endOfDay.missed),
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

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
