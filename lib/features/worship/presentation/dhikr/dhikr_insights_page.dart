import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../application/dhikr_daily_goal_provider.dart';
import '../../application/dhikr_history_provider.dart';
import '../../application/dhikr_routine_catalog.dart';
import '../../domain/dhikr_day_total.dart';
import 'dhikr_routine_labels.dart';

/// Remembrance over time: this week, streaks, lifetime, and how each
/// routine is holding up. One observation line, not a feed of stats.
class DhikrInsightsPage extends ConsumerWidget {
  const DhikrInsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final insights = ref.watch(dhikrInsightsProvider);
    final routines = ref.watch(dhikrRoutinesProvider);
    final goal = ref.watch(dhikrDailyGoalProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final numberFormat = intl.NumberFormat.decimalPattern(locale);
    final earliest = insights.earliestDateKey == null
        ? null
        : dhikrDateFromKey(insights.earliestDateKey!);

    Widget statTile(String value, String caption, {bool serif = false}) {
      return Expanded(
        child: PremiumCard(
          density: PremiumCardDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: serif
                    ? AppTextStyles.titleSerif.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: palette.onSurface,
                      )
                    : theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                caption,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.onSurfaceSubtle,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final quiet = insights.quietestRoutine;
    final quietRoutine = quiet == null
        ? null
        : routines
              .where((routine) => routine.id == quiet.routineId)
              .firstOrNull;
    final maxWeek = insights.weekValues.fold<int>(
      goal,
      (acc, value) => value > acc ? value : acc,
    );

    return AppPageScaffold(
      ownsBackground: false,
      title: l10n.dhikrInsightsTitle,
      subtitle: earliest == null
          ? l10n.dhikrInsightsSubtitleEmpty
          : l10n.dhikrInsightsSubtitle(
              intl.DateFormat.yMMMMd(locale).format(earliest),
            ),
      children: [
        Row(
          children: [
            statTile(
              numberFormat.format(insights.thisWeek),
              l10n.dhikrInsightsThisWeekCaption(
                numberFormat.format(insights.lastWeek),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            statTile(
              l10n.dhikrInsightsStreakValue(
                numberFormat.format(insights.streak),
              ),
              l10n.dhikrInsightsStreakCaption(
                numberFormat.format(insights.bestStreak),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            statTile(
              numberFormat.format(insights.lifetime),
              l10n.dhikrInsightsLifetimeCaption,
            ),
            const SizedBox(width: AppSpacing.xs),
            statTile(
              insights.favoritePhrase == null
                  ? '—'
                  : localizedDhikrSessionLabel(l10n, insights.favoritePhrase!),
              l10n.dhikrInsightsFavoriteCaption(
                numberFormat.format(insights.favoriteCount),
              ),
              serif: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        PremiumCard(
          density: PremiumCardDensity.compact,
          title: Text(l10n.dhikrInsightsWeekTitle),
          trailing: Text(
            l10n.dhikrInsightsGoalPerDay(numberFormat.format(goal)),
            style: theme.textTheme.bodySmall?.copyWith(
              color: palette.onSurfaceSubtle,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 96,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < insights.weekValues.length; i++) ...[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: maxWeek <= 0
                                  ? 3
                                  : (96 * insights.weekValues[i] / maxWeek)
                                        .clamp(3, 96)
                                        .toDouble(),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: i == insights.weekValues.length - 1
                                    ? palette.accentSoft
                                    : insights.weekValues[i] >= goal
                                    ? palette.accent
                                    : palette.accent.withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < insights.weekValues.length - 1)
                        const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  for (var i = 0; i < insights.weekValues.length; i++) ...[
                    Expanded(
                      child: Text(
                        intl.DateFormat.E(locale).format(
                          now.subtract(
                            Duration(days: insights.weekValues.length - 1 - i),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: i == insights.weekValues.length - 1
                              ? palette.onSurface
                              : palette.onSurfaceMuted,
                          fontWeight: i == insights.weekValues.length - 1
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (i < insights.weekValues.length - 1)
                      const SizedBox(width: 8),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        PremiumCard(
          density: PremiumCardDensity.compact,
          title: Text(l10n.dhikrInsightsByRoutineTitle),
          child: Column(
            children: [
              for (final stat in insights.routineStats) ...[
                Builder(
                  builder: (context) {
                    final routine = routines
                        .where((routine) => routine.id == stat.routineId)
                        .firstOrNull;
                    if (routine == null) return const SizedBox.shrink();
                    final label = stat.routineId == kDhikrRoutineAfterSalahId
                        ? l10n.dhikrInsightsRoutineRuns(
                            numberFormat.format(stat.done),
                            numberFormat.format(stat.possible),
                          )
                        : l10n.dhikrInsightsRoutineDays(
                            numberFormat.format(stat.done),
                            numberFormat.format(stat.possible),
                          );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dhikrRoutineTitle(l10n, routine.kind),
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                            Text(
                              label,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.onSurfaceSubtle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ProgressBar(value: stat.fraction),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.dhikrFreeCountTitle,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    l10n.dhikrInsightsFreeSessions(
                      numberFormat.format(insights.freeSessionsThisWeek),
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.onSurfaceSubtle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        PremiumCard(
          density: PremiumCardDensity.compact,
          child: Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: palette.accentSoft),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  quietRoutine == null
                      ? (insights.isEmpty
                            ? l10n.dhikrInsightsSubtitleEmpty
                            : l10n.dhikrInsightsObservationSteady)
                      : l10n.dhikrInsightsObservationQuiet(
                          dhikrRoutineTitle(l10n, quietRoutine.kind),
                          quietRoutine.estimatedMinutes,
                        ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
