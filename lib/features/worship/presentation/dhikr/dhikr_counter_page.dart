import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/app_summary_providers.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../profile/application/profile_settings_provider.dart';
import '../../application/dhikr_controller.dart';
import '../../application/dhikr_daily_goal_provider.dart';
import '../../application/dhikr_history_provider.dart';
import 'widgets/dhikr_anti_rush_dialog.dart';
import 'widgets/dhikr_page_body.dart';
import 'widgets/dhikr_phrase_header.dart';
import 'widgets/dhikr_pill_button.dart';
import 'widgets/dhikr_sheets.dart';
import 'widgets/misbaha_ring.dart';

/// The free counter: one phrase, one target, the whole middle of the screen
/// as the tap target, beads around the count.
class DhikrCounterPage extends ConsumerStatefulWidget {
  const DhikrCounterPage({super.key});

  @override
  ConsumerState<DhikrCounterPage> createState() => _DhikrCounterPageState();
}

class _DhikrCounterPageState extends ConsumerState<DhikrCounterPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;
  bool _antiRushVisible = false;

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
    ref.listenManual<DhikrSessionState>(dhikrControllerProvider, (
      previous,
      next,
    ) {
      final shouldPrompt =
          next.showAntiRushReminder &&
          next.antiRushReminderCount != previous?.antiRushReminderCount;
      if (!shouldPrompt || _antiRushVisible || !mounted) return;
      _showAntiRush(next.selectedPreset.label);
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _showAntiRush(String label) async {
    _antiRushVisible = true;
    await showDhikrAntiRushDialog(context, phraseLabel: label);
    if (mounted) {
      ref.read(dhikrControllerProvider.notifier).dismissAntiRushReminder();
    }
    _antiRushVisible = false;
  }

  Future<void> _handleTap({required bool reduceMotion}) async {
    final notifier = ref.read(dhikrControllerProvider.notifier);
    final before = ref.read(dhikrControllerProvider);
    final layout = MisbahaLoopLayout.resolve(
      count: before.currentCount,
      target: before.target,
    );
    final nextCount = before.currentCount + 1;
    if (nextCount == before.target) {
      HapticFeedback.heavyImpact();
    } else if (layout.hasLoops && nextCount % layout.beadsPerLoop == 0) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }
    if (!reduceMotion) _pulse.forward(from: 0);
    notifier.increment();
  }

  Future<void> _finish() async {
    final state = ref.read(dhikrControllerProvider);
    final session = state.activeSession;
    if (session == null) return;
    final l10n = AppLocalizations.of(context);
    ref.read(dhikrControllerProvider.notifier).finishSession();
    final streak = ref.read(dhikrStreakProvider);
    final today = ref.read(worshipSummaryProvider).dhikrCount;
    final goal = ref.read(dhikrDailyGoalProvider);
    final done = await showDhikrCompletionSheet(
      context,
      title: l10n.dhikrSessionCompleteTitle,
      subtitle: session.phraseLabel,
      count: session.count,
      duration: session.duration,
      streak: streak,
      todayCount: today,
      dailyGoal: goal,
    );
    if (done && mounted) context.pop();
  }

  Future<void> _confirmReset() async {
    final l10n = AppLocalizations.of(context);
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.dhikrResetSessionTitle),
        content: Text(l10n.dhikrResetSessionBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.dhikrResetAction),
          ),
        ],
      ),
    );
    if (shouldReset == true && mounted) {
      ref.read(dhikrControllerProvider.notifier).reset();
    }
  }

  void _openMenu(bool isKids) {
    final l10n = AppLocalizations.of(context);
    showDhikrMenuSheet(
      context,
      title: l10n.dhikrMenuTooltip,
      entries: [
        DhikrMenuEntry(
          icon: Icons.flag_rounded,
          label: l10n.dhikrSessionTargetTitle,
          onTap: () => showDhikrTargetSheet(context, ref),
        ),
        DhikrMenuEntry(
          icon: Icons.translate_rounded,
          label: l10n.dhikrChoosePhraseTitle,
          onTap: () => showDhikrPhraseSheet(context, ref),
        ),
        DhikrMenuEntry(
          icon: Icons.refresh_rounded,
          label: isKids ? l10n.kidsDhikrResetAction : l10n.dhikrResetAction,
          onTap: _confirmReset,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final theme = Theme.of(context);
    final isKids = ref.watch(specialModeProvider.select((mode) => mode.isKids));
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final state = ref.watch(dhikrControllerProvider);
    final numberFormat = intl.NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final layout = MisbahaLoopLayout.resolve(
      count: state.currentCount,
      target: state.target,
    );
    final reached = state.hasTargetReached;
    final headerCaption = layout.hasLoops
        ? '${l10n.dhikrTargetValue(numberFormat.format(state.target))} · '
              '${l10n.dhikrLoopValue(layout.loopIndex + 1, layout.loops)}'
        : l10n.dhikrTargetValue(numberFormat.format(state.target));

    return DhikrPageBody(
      builder: (context, compact) => [
        Row(
          children: [
            DhikrRoundButton(
              icon: Icons.arrow_back_ios_new_rounded,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onTap: () => context.pop(),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.dhikrFreeCountTitle,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.accentSoft,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    headerCaption,
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
              onTap: () => _openMenu(isKids),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        DhikrPhraseHeader(
          arabic: state.selectedPreset.phrase,
          transliteration: state.selectedPreset.transliteration,
          translation: state.selectedPreset.translation,
          compact: compact,
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final ringSize = [
                constraints.maxWidth - 32,
                constraints.maxHeight - 40,
                312.0,
              ].reduce((a, b) => a < b ? a : b).clamp(0.0, 312.0);
              final showCaption = constraints.maxHeight >= 140;
              return Semantics(
                button: true,
                label: l10n.dhikrTapToCountSemantics,
                child: GestureDetector(
                  key: const Key('dhikr-counter-tap-zone'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _handleTap(reduceMotion: reduceMotion),
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
                              centerLabel: numberFormat.format(
                                state.currentCount,
                              ),
                              centerCaption: l10n.dhikrOfTargetValue(
                                numberFormat.format(state.target),
                              ),
                              size: ringSize,
                              glow: reduceMotion ? 0 : _pulse.value,
                            ),
                          ),
                        ),
                        if (showCaption) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            reached
                                ? (isKids
                                      ? l10n.kidsDhikrTargetReachedMessage
                                      : l10n.dhikrTargetReachedMessage)
                                : l10n.dhikrTapAnywhere,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: reached
                                  ? palette.success
                                  : palette.onSurfaceMuted,
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
        Row(
          children: [
            DhikrPillButton(
              icon: Icons.undo_rounded,
              label: l10n.dhikrUndoAction,
              enabled: state.currentCount > 0,
              onTap: ref.read(dhikrControllerProvider.notifier).undo,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: DhikrPillButton(
                key: const Key('dhikr-counter-finish'),
                icon: Icons.check_rounded,
                label: l10n.dhikrFinishWithCount(
                  numberFormat.format(state.currentCount),
                ),
                emphasized: true,
                expand: true,
                enabled: state.currentCount > 0,
                onTap: _finish,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            DhikrPillButton(
              icon: Icons.add_rounded,
              label: l10n.dhikrAddAction,
              onTap: () => showDhikrAddManualSheet(context, ref),
            ),
          ],
        ),
      ],
    );
  }
}
