import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/app_summary_providers.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../profile/application/profile_settings_provider.dart';
import '../../application/dhikr_anti_rush_detector.dart';
import '../../application/dhikr_daily_goal_provider.dart';
import '../../application/dhikr_history_provider.dart';
import '../../application/dhikr_routine_catalog.dart';
import '../../application/dhikr_routine_controller.dart';
import '../../domain/dhikr_routine.dart';
import 'dhikr_routine_labels.dart';
import 'widgets/dhikr_anti_rush_dialog.dart';
import 'widgets/dhikr_page_body.dart';
import 'widgets/dhikr_phrase_header.dart';
import 'widgets/dhikr_pill_button.dart';
import 'widgets/dhikr_sheets.dart';
import 'widgets/misbaha_ring.dart';

/// Plays one routine step by step. Each step is its own bead ring; when a
/// step's count is reached the player moves on by itself with a firmer tick.
class DhikrRoutinePage extends ConsumerStatefulWidget {
  const DhikrRoutinePage({super.key, required this.routineId, this.prayerId});

  final String routineId;
  final String? prayerId;

  @override
  ConsumerState<DhikrRoutinePage> createState() => _DhikrRoutinePageState();
}

class _DhikrRoutinePageState extends ConsumerState<DhikrRoutinePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;
  final DhikrAntiRushDetector _antiRush = DhikrAntiRushDetector();
  bool _antiRushVisible = false;
  bool _completing = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.035), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.035, end: 0.99), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.99, end: 1), weight: 35),
    ]).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureStarted());
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _ensureStarted() {
    if (!mounted) return;
    final routine = ref.read(dhikrRoutineByIdProvider(widget.routineId));
    if (routine == null) return;
    ref
        .read(dhikrRoutineControllerProvider.notifier)
        .start(routine, prayerId: widget.prayerId);
  }

  Future<void> _handleTap(DhikrRoutine routine, bool reduceMotion) async {
    if (_completing) return;
    if (_antiRush.registerTap(DateTime.now()) && !_antiRushVisible) {
      final progress = ref.read(dhikrRoutineControllerProvider);
      final index = (progress?.stepIndex ?? 0).clamp(
        0,
        routine.steps.length - 1,
      );
      _antiRushVisible = true;
      await showDhikrAntiRushDialog(
        context,
        phraseLabel: routine.steps[index].title,
      );
      _antiRushVisible = false;
      return;
    }
    if (!reduceMotion) _pulse.forward(from: 0);
    final result = ref
        .read(dhikrRoutineControllerProvider.notifier)
        .tap(routine);
    await _react(routine, result);
  }

  Future<void> _react(
    DhikrRoutine routine,
    DhikrRoutineTapResult result,
  ) async {
    switch (result.outcome) {
      case DhikrRoutineTapOutcome.counted:
        HapticFeedback.selectionClick();
      case DhikrRoutineTapOutcome.stepAdvanced:
        HapticFeedback.mediumImpact();
        _antiRush.reset();
      case DhikrRoutineTapOutcome.completed:
        HapticFeedback.heavyImpact();
        await _showCompletion(routine, result.completion!);
    }
  }

  Future<void> _showCompletion(
    DhikrRoutine routine,
    DhikrRoutineCompletion completion,
  ) async {
    if (!mounted) return;
    _completing = true;
    final l10n = AppLocalizations.of(context);
    final streak = ref.read(dhikrStreakProvider);
    final today = ref.read(worshipSummaryProvider).dhikrCount;
    final goal = ref.read(dhikrDailyGoalProvider);
    await showDhikrCompletionSheet(
      context,
      title: l10n.dhikrRoutineCompleteTitle(
        dhikrRoutineTitle(l10n, routine.kind),
      ),
      subtitle: routine.steps
          .map((step) => '${step.title} × ${step.count}')
          .join(' · '),
      count: routine.totalCount,
      duration: completion.duration,
      streak: streak,
      todayCount: today,
      dailyGoal: goal,
      allowKeepCounting: false,
    );
    _completing = false;
    if (mounted) context.pop();
  }

  void _openMenu(DhikrRoutine routine) {
    final l10n = AppLocalizations.of(context);
    showDhikrMenuSheet(
      context,
      title: l10n.dhikrMenuTooltip,
      entries: [
        DhikrMenuEntry(
          icon: Icons.refresh_rounded,
          label: l10n.dhikrResetAction,
          onTap: () {
            final notifier = ref.read(dhikrRoutineControllerProvider.notifier);
            notifier.abandon();
            notifier.start(routine, prayerId: widget.prayerId);
            _antiRush.reset();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final theme = Theme.of(context);
    final routine = ref.watch(dhikrRoutineByIdProvider(widget.routineId));
    if (routine == null || routine.steps.isEmpty) {
      return AppPageScaffold(
        ownsBackground: false,
        title: l10n.dhikrRoutinesTitle,
        subtitle: l10n.dhikrLandingSubtitle,
        children: [
          PremiumCard(
            density: PremiumCardDensity.compact,
            child: Text(l10n.learnContentNotFound),
          ),
        ],
      );
    }

    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final progress = ref.watch(dhikrRoutineControllerProvider);
    final isThisRoutine = progress?.routineId == routine.id;
    final stepIndex = isThisRoutine
        ? progress!.stepIndex.clamp(0, routine.steps.length - 1)
        : 0;
    final stepCount = isThisRoutine ? progress!.stepCount : 0;
    final step = routine.steps[stepIndex];
    final isLast = stepIndex == routine.steps.length - 1;
    final next = isLast ? null : routine.steps[stepIndex + 1];
    final layout = MisbahaLoopLayout.resolve(
      count: stepCount,
      target: step.count,
    );
    final numberFormat = intl.NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final prayerId = progress?.prayerId ?? widget.prayerId;
    final eyebrow =
        prayerId != null && routine.kind == DhikrRoutineKind.afterSalah
        ? l10n.dhikrRoutineAfterPrayerEyebrow(dhikrPrayerLabel(l10n, prayerId))
        : dhikrRoutineTitle(l10n, routine.kind);

    return DhikrPageBody(
      builder: (context, compact) => [
        Row(
          children: [
            DhikrRoundButton(
              icon: Icons.close_rounded,
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onTap: () => context.pop(),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    eyebrow,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.accentSoft,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.dhikrNowStepOf(stepIndex + 1, routine.steps.length),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.onSurfaceSubtle,
                    ),
                  ),
                ],
              ),
            ),
            DhikrRoundButton(
              icon: Icons.more_horiz_rounded,
              tooltip: l10n.dhikrMenuTooltip,
              onTap: () => _openMenu(routine),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Row(
            children: [
              for (var i = 0; i < routine.steps.length; i++) ...[
                Expanded(
                  flex: routine.steps[i].count > 5 ? 3 : 1,
                  child: ProgressBar(
                    value: i < stepIndex
                        ? 1
                        : i == stepIndex
                        ? (step.count <= 0 ? 1 : stepCount / step.count)
                        : 0,
                  ),
                ),
                if (i < routine.steps.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        AnimatedSwitcher(
          duration: Duration(milliseconds: reduceMotion ? 0 : 260),
          child: KeyedSubtree(
            key: ValueKey<int>(stepIndex),
            child: DhikrPhraseHeader(
              title: step.title,
              arabic: step.arabic,
              transliteration: step.transliteration,
              translation: step.translation,
              compact: compact || step.isLongText,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxRing = step.isLongText || compact ? 220.0 : 300.0;
              final ringSize = [
                constraints.maxWidth - 32,
                constraints.maxHeight - 36,
                maxRing,
              ].reduce((a, b) => a < b ? a : b).clamp(0.0, maxRing);
              final showCaption = constraints.maxHeight >= 140;
              return Semantics(
                button: true,
                label: l10n.dhikrTapToCountSemantics,
                child: GestureDetector(
                  key: const Key('dhikr-routine-tap-zone'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _handleTap(routine, reduceMotion),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _pulse,
                          builder: (context, child) => Transform.scale(
                            scale: reduceMotion ? 1 : _scale.value,
                            child: MisbahaRing(
                              layout: layout,
                              centerLabel: numberFormat.format(stepCount),
                              centerCaption: l10n.dhikrOfTargetValue(
                                numberFormat.format(step.count),
                              ),
                              size: ringSize,
                              glow: reduceMotion ? 0 : _pulse.value,
                            ),
                          ),
                        ),
                        if (showCaption) ...[
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            l10n.dhikrTapAnywhere,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: palette.onSurfaceMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        PremiumCard(
          density: PremiumCardDensity.tile,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                next == null
                    ? l10n.dhikrRoutineLastStepHint(
                        numberFormat.format(step.count),
                      )
                    : l10n.dhikrRoutineNextEyebrow(
                        numberFormat.format(step.count),
                      ),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.accentSoft,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              if (next != null) ...[
                const SizedBox(height: 2),
                Text(
                  l10n.dhikrRoutineNextValue(
                    next.title,
                    numberFormat.format(next.count),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            DhikrPillButton(
              icon: Icons.undo_rounded,
              label: l10n.dhikrUndoAction,
              enabled: stepCount > 0 || stepIndex > 0,
              onTap: () => ref
                  .read(dhikrRoutineControllerProvider.notifier)
                  .undo(routine),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: DhikrPillButton(
                key: const Key('dhikr-routine-skip'),
                icon: Icons.skip_next_rounded,
                label: l10n.dhikrRoutineSkipStepAction,
                expand: true,
                onTap: () async {
                  final result = ref
                      .read(dhikrRoutineControllerProvider.notifier)
                      .skipStep(routine);
                  await _react(routine, result);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
