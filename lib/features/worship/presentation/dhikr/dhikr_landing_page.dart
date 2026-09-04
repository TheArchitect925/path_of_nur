import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/app_summary_providers.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/content/contextual_quran_quotes.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/utils/compact_duration_formatter.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/activity_heatmap.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../../shared/widgets/display/stat_ring.dart';
import '../../../../shared/widgets/noor_glass_card.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_quote_block.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/dhikr_controller.dart';
import '../../application/dhikr_daily_goal_provider.dart';
import '../../application/dhikr_history_provider.dart';
import '../../application/dhikr_now_suggestion.dart';
import '../../application/dhikr_routine_catalog.dart';
import '../../application/dhikr_routine_controller.dart';
import '../../domain/dhikr_day_total.dart';
import '../../domain/dhikr_preset.dart';
import '../../domain/dhikr_routine.dart';
import '../../domain/dhikr_session.dart';
import 'dhikr_routine_labels.dart';
import 'widgets/dhikr_pill_button.dart';
import 'widgets/dhikr_sheets.dart';

/// The dhikr hub. Opens on what this moment asks for, then today's numbers,
/// the routines, free tasbih, and the month's history.
class DhikrLandingPage extends ConsumerWidget {
  const DhikrLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quote = buildContextualQuranQuote(
      ContextualQuranQuoteKey.worshipDhikr,
    );
    return AppPageScaffold(
      ownsBackground: false,
      headerIcon: IslamicIcons.tasbih,
      title: l10n.dhikrSectionTitle,
      subtitle: l10n.dhikrLandingSubtitle,
      children: [
        const _DhikrNowCard(),
        const SizedBox(height: AppSpacing.s),
        const _DhikrTodayRow(),
        const SizedBox(height: AppSpacing.m),
        const _DhikrRoutinesGroup(),
        const SizedBox(height: AppSpacing.m),
        const _DhikrFreeTasbihCard(),
        const SizedBox(height: AppSpacing.m),
        const _DhikrHistorySection(),
        const SizedBox(height: AppSpacing.m),
        QuranQuoteBlock(
          quote: quote,
          compact: true,
          onTap: () => openQuranQuoteLocation(context, quote),
        ),
      ],
    );
  }
}

String _formatCount(BuildContext context, num value) {
  return intl.NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

String _formatTime(BuildContext context, DateTime time) {
  return intl.DateFormat.jm(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(time);
}

void _openRoutine(BuildContext context, String routineId, {String? prayerId}) {
  context.pushNamed(
    'worshipDhikrRoutine',
    pathParameters: <String, String>{'routineId': routineId},
    queryParameters: <String, String>{'prayer': ?prayerId},
  );
}

class _DhikrNowCard extends ConsumerWidget {
  const _DhikrNowCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final suggestion = ref.watch(dhikrNowSuggestionProvider);
    final routine = suggestion.routineId == null
        ? null
        : ref.watch(dhikrRoutineByIdProvider(suggestion.routineId!));
    final progress = ref.watch(dhikrRoutineControllerProvider);
    final dhikr = ref.watch(dhikrControllerProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();

    final String eyebrow;
    switch (suggestion.kind) {
      case DhikrNowKind.continueRoutine:
        eyebrow = l10n.dhikrNowEyebrowContinue;
      case DhikrNowKind.afterSalah:
        eyebrow = suggestion.prayerId == null
            ? l10n.dhikrNowEyebrowAnytime
            : l10n.dhikrNowEyebrowAfterPrayer(
                dhikrPrayerLabel(l10n, suggestion.prayerId!, date: now),
              );
      case DhikrNowKind.morning:
        eyebrow = l10n.dhikrNowEyebrowMorning;
      case DhikrNowKind.evening:
        eyebrow = l10n.dhikrNowEyebrowEvening;
      case DhikrNowKind.sleep:
        eyebrow = l10n.dhikrNowEyebrowSleep;
      case DhikrNowKind.free:
        eyebrow = l10n.dhikrNowEyebrowAnytime;
    }

    final title = routine == null
        ? l10n.dhikrFreeCountTitle
        : dhikrRoutineTitle(l10n, routine.kind);
    final String meta;
    if (routine == null) {
      meta = l10n.dhikrTargetValue(_formatCount(context, dhikr.target));
    } else if (suggestion.kind == DhikrNowKind.continueRoutine &&
        progress != null) {
      meta = l10n.dhikrNowStepOf(progress.stepIndex + 1, routine.steps.length);
    } else {
      final base = l10n.dhikrNowMeta(
        routine.steps.length,
        routine.estimatedMinutes,
      );
      meta =
          '$base · ${suggestion.doneToday ? l10n.dhikrNowDoneToday : l10n.dhikrNowNotYetToday}';
    }
    final icon = routine == null
        ? IslamicIcons.tasbih
        : dhikrRoutineIcon(routine.kind);

    return NoorGlassCard(
      padding: const EdgeInsets.all(AppSpacing.m + 2),
      surfaceVariant: AppSurfaceVariant.panel,
      borderRadius: AppRadii.glassCard,
      surfaceTintColor: palette.accent,
      surfaceAlphaOverride: 0.12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: theme.textTheme.labelMedium?.copyWith(
              color: palette.accent,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: palette.onSurfaceSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: palette.accent.withValues(alpha: 0.14),
                  border: Border.all(
                    color: palette.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(icon, size: 26, color: palette.accentSoft),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Expanded(
                child: DhikrPillButton(
                  key: const Key('dhikr-now-primary'),
                  icon: routine == null
                      ? Icons.touch_app_rounded
                      : Icons.play_arrow_rounded,
                  label: routine == null
                      ? l10n.dhikrCountAction
                      : suggestion.kind == DhikrNowKind.continueRoutine
                      ? l10n.dhikrContinueAction
                      : l10n.dhikrBeginAction,
                  emphasized: true,
                  expand: true,
                  onTap: () {
                    if (routine == null) {
                      context.pushNamed('worshipDhikrCounter');
                    } else {
                      _openRoutine(
                        context,
                        routine.id,
                        prayerId: suggestion.prayerId,
                      );
                    }
                  },
                ),
              ),
              if (routine != null) ...[
                const SizedBox(width: AppSpacing.xs),
                DhikrPillButton(
                  key: const Key('dhikr-now-free-count'),
                  label: l10n.dhikrFreeCountAction,
                  onTap: () => context.pushNamed('worshipDhikrCounter'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DhikrTodayRow extends ConsumerWidget {
  const _DhikrTodayRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final isKids = ref.watch(specialModeProvider.select((mode) => mode.isKids));
    final today = ref.watch(
      worshipSummaryProvider.select((summary) => summary.dhikrCount),
    );
    final goal = ref.watch(dhikrDailyGoalProvider);
    final streak = ref.watch(dhikrStreakProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final sessionsToday = ref.watch(
      dhikrControllerProvider.select(
        (state) => state.totalForDay(now)?.sessions ?? 0,
      ),
    );

    Widget numberTile(String value, String caption) {
      return PremiumCard(
        density: PremiumCardDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: palette.onSurfaceSubtle,
              ),
            ),
          ],
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PremiumCard(
              density: PremiumCardDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              onTap: () => showDhikrDailyGoalSheet(context, ref),
              child: Semantics(
                label: isKids
                    ? l10n.kidsDhikrDailyGoalTitle
                    : l10n.dhikrDailyGoalTitle,
                child: StatRing(
                  value: goal <= 0 ? 0 : today / goal,
                  label: _formatCount(context, today),
                  caption: l10n.dhikrTodayOfGoal(_formatCount(context, goal)),
                  size: 66,
                  strokeWidth: 7,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: numberTile(
              _formatCount(context, streak),
              l10n.dhikrStreakCaption,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: numberTile(
              _formatCount(context, sessionsToday),
              l10n.dhikrSessionsTodayCaption,
            ),
          ),
        ],
      ),
    );
  }
}

class _DhikrRoutinesGroup extends ConsumerWidget {
  const _DhikrRoutinesGroup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final routines = ref.watch(dhikrRoutinesProvider);
    final suggestion = ref.watch(dhikrNowSuggestionProvider);
    final progress = ref.watch(dhikrRoutineControllerProvider);
    final dhikr = ref.watch(dhikrControllerProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final today = dhikr.totalForDay(now);
    final todayKey = dhikrDayKey(now);

    DhikrSession? latestSessionFor(DhikrRoutine routine) {
      for (final session in dhikr.recentSessions) {
        if (session.phraseLabel == routine.sessionLabel &&
            dhikrDayKey(session.finishedAt) == todayKey) {
          return session;
        }
      }
      return null;
    }

    return HubListGroup(
      title: l10n.dhikrRoutinesTitle,
      children: [
        for (final routine in routines)
          Builder(
            builder: (context) {
              final isActive = progress?.routineId == routine.id;
              final doneToday = today?.hasRoutine(routine.id) ?? false;
              final latest = doneToday ? latestSessionFor(routine) : null;
              var subtitle = dhikrRoutineSubtitle(l10n, routine);
              if (latest != null) {
                subtitle =
                    '$subtitle · ${l10n.dhikrRoutineDoneAt(_formatTime(context, latest.finishedAt))}';
              }
              Widget? trailing;
              if (isActive && progress != null) {
                trailing = Text(
                  l10n.dhikrNowStepOf(
                    progress.stepIndex + 1,
                    routine.steps.length,
                  ),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: palette.accentSoft,
                    fontWeight: FontWeight.w700,
                  ),
                );
              } else if (doneToday &&
                  routine.kind != DhikrRoutineKind.afterSalah) {
                trailing = Icon(
                  Icons.check_circle_outline_rounded,
                  color: palette.success,
                );
              } else if (suggestion.routineId == routine.id) {
                trailing = HubNewBadge(label: l10n.dhikrRoutineNowBadge);
              }
              return CompactListTile(
                key: Key('dhikr-routine-${routine.id}'),
                title: dhikrRoutineTitle(l10n, routine.kind),
                subtitle: subtitle,
                leading: HubLeadingIcon(dhikrRoutineIcon(routine.kind)),
                trailing: trailing,
                onTap: () => _openRoutine(
                  context,
                  routine.id,
                  prayerId: suggestion.routineId == routine.id
                      ? suggestion.prayerId
                      : null,
                ),
              );
            },
          ),
      ],
    );
  }
}

class _DhikrFreeTasbihCard extends ConsumerWidget {
  const _DhikrFreeTasbihCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final state = ref.watch(dhikrControllerProvider);
    final notifier = ref.read(dhikrControllerProvider.notifier);
    final lastFree = state.recentSessions
        .where(
          (session) => DhikrPreset.defaults.any(
            (preset) => preset.label == session.phraseLabel,
          ),
        )
        .firstOrNull;

    final String? status;
    if (state.currentCount > 0) {
      status = l10n.dhikrInProgressValue(
        state.selectedPreset.label,
        _formatCount(context, state.currentCount),
        _formatCount(context, state.target),
      );
    } else if (lastFree != null) {
      status = l10n.dhikrLastSessionValue(
        lastFree.phraseLabel,
        _formatCount(context, lastFree.count),
        _formatTime(context, lastFree.finishedAt),
      );
    } else {
      status = null;
    }

    return PremiumCard(
      density: PremiumCardDensity.compact,
      title: Text(l10n.dhikrFreeTasbihTitle),
      trailing: DhikrChoicePill(
        label: l10n.dhikrTargetValue(_formatCount(context, state.target)),
        isSelected: false,
        onTap: () => showDhikrTargetSheet(context, ref),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in DhikrPreset.defaults)
                DhikrChoicePill(
                  key: Key('dhikr-phrase-${preset.id}'),
                  label: preset.label,
                  isSelected: preset.id == state.selectedPreset.id,
                  onTap: () => notifier.selectPreset(preset),
                ),
            ],
          ),
          if (status != null) ...[
            const SizedBox(height: AppSpacing.s),
            Text(
              status,
              style: theme.textTheme.bodySmall?.copyWith(
                color: palette.onSurfaceSubtle,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s),
          DhikrPillButton(
            key: const Key('dhikr-free-count'),
            icon: Icons.touch_app_rounded,
            label: state.currentCount > 0
                ? l10n.dhikrContinueAction
                : l10n.dhikrCountAction,
            emphasized: true,
            expand: true,
            onTap: () => context.pushNamed('worshipDhikrCounter'),
          ),
        ],
      ),
    );
  }
}

class _DhikrHistorySection extends ConsumerWidget {
  const _DhikrHistorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final values = ref.watch(dhikrHeatmapValuesProvider);
    final insights = ref.watch(dhikrInsightsProvider);
    final sessions = ref.watch(
      dhikrControllerProvider.select((state) => state.recentSessions),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SectionTitle(title: l10n.dhikrThisMonthTitle)),
            TextButton(
              key: const Key('dhikr-insights-link'),
              onPressed: () => context.pushNamed('worshipDhikrInsights'),
              child: Text(l10n.dhikrInsightsAction),
            ),
          ],
        ),
        PremiumCard(
          density: PremiumCardDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  // Twelve week columns fill the card instead of leaving the
                  // kit's 14px default floating at one edge.
                  const gap = 3.0;
                  final columns = (values.length / 7).ceil();
                  final cell = columns <= 0 || !constraints.maxWidth.isFinite
                      ? 14.0
                      : ((constraints.maxWidth - gap * (columns - 1)) / columns)
                            .clamp(10.0, 22.0);
                  return ActivityHeatmap(
                    values: values,
                    cellSize: cell,
                    cellGap: gap,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.dhikrHeatmapSummary(12, insights.activeDaysInWindow),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.onSurfaceSubtle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (sessions.isEmpty)
          PremiumCard(
            density: PremiumCardDensity.compact,
            child: Text(
              l10n.dhikrNoCompletedSessionsYet,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: palette.onSurfaceSubtle,
              ),
            ),
          )
        else
          for (final session in sessions.take(3)) ...[
            CompactListTile(
              leading: CompactTileBadge(
                label: _formatCount(context, session.count),
              ),
              title: localizedDhikrSessionLabel(l10n, session.phraseLabel),
              subtitle: l10n.dhikrSessionSummaryValue(
                l10n.homeFractionValue(
                  _formatCount(context, session.count),
                  _formatCount(context, session.target),
                ),
                _formatSessionDuration(l10n, session),
              ),
              trailing: Text(
                _formatTime(context, session.finishedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.onSurfaceSubtle,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxs + 2),
          ],
      ],
    );
  }
}

String _formatSessionDuration(AppLocalizations l10n, DhikrSession session) {
  final duration = session.finishedAt.difference(session.startedAt);
  if (duration <= Duration.zero) return l10n.dhikrDurationJustNow;
  return formatCompactDuration(
    duration,
    localeName: l10n.localeName,
    hourSuffix: l10n.durationCompactHourSuffix,
    minuteSuffix: l10n.durationCompactMinuteSuffix,
  );
}
