import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../features/profile/application/profile_settings_provider.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/utils/compact_duration_formatter.dart';
import '../../../../shared/widgets/noor_glass_card.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/dhikr_controller.dart';
import '../../application/dhikr_daily_goal_provider.dart';
import '../../domain/dhikr_preset.dart';
import '../../domain/dhikr_session.dart';

class DhikrSection extends ConsumerStatefulWidget {
  const DhikrSection({super.key});

  @override
  ConsumerState<DhikrSection> createState() => _DhikrSectionState();
}

class _DhikrSectionState extends ConsumerState<DhikrSection>
    with SingleTickerProviderStateMixin {
  bool _antiRushDialogVisible = false;
  bool _counterPressed = false;

  late final AnimationController _counterPulseController;
  late final Animation<double> _counterScale;
  late final Animation<double> _counterGlow;

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
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
        );
      },
    );

    if (shouldReset == true) {
      ref.read(dhikrControllerProvider.notifier).reset();
    }
  }

  void _setCustomTarget(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.dhikrCustomTargetTitle),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: l10n.dhikrCustomTargetHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());
                if (value != null && value > 0) {
                  ref.read(dhikrControllerProvider.notifier).setTarget(value);
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.dhikrApplyAction),
            ),
          ],
        );
      },
    );
  }

  void _addManualCount(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.dhikrAddManualTitle),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: l10n.dhikrAddManualHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());
                if (value != null && value > 0) {
                  ref
                      .read(dhikrControllerProvider.notifier)
                      .addManualCount(value);
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.dhikrAddAction),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _counterPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _counterScale =
        TweenSequence<double>([
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1, end: 1.04),
            weight: 40,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.04, end: 0.985),
            weight: 25,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0.985, end: 1),
            weight: 35,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _counterPulseController,
            curve: Curves.easeOutCubic,
          ),
        );
    _counterGlow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _counterPulseController,
        curve: Curves.easeOutCubic,
      ),
    );
    ref.listenManual<DhikrSessionState>(dhikrControllerProvider, (
      previous,
      next,
    ) {
      final shouldPrompt =
          next.showAntiRushReminder &&
          next.antiRushReminderCount != previous?.antiRushReminderCount;
      if (!shouldPrompt || _antiRushDialogVisible || !mounted) {
        return;
      }
      _showAntiRushReminder();
    });
  }

  @override
  void dispose() {
    _counterPulseController.dispose();
    super.dispose();
  }

  Future<void> _handleCounterTap({
    required DhikrController notifier,
    required bool reduceMotion,
  }) async {
    await HapticFeedback.selectionClick();
    if (mounted) {
      setState(() => _counterPressed = true);
    }
    if (!reduceMotion) {
      _counterPulseController.forward(from: 0);
    }
    notifier.increment();
    if (reduceMotion) {
      await Future<void>.delayed(const Duration(milliseconds: 90));
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 140));
    }
    if (mounted) {
      setState(() => _counterPressed = false);
    }
  }

  Future<void> _showAntiRushReminder() async {
    _antiRushDialogVisible = true;
    await HapticFeedback.heavyImpact();
    if (!mounted) {
      _antiRushDialogVisible = false;
      return;
    }
    final l10n = AppLocalizations.of(context);
    final presetLabel = ref.read(
      dhikrControllerProvider.select((state) => state.selectedPreset.label),
    );
    final theme = Theme.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final dialogStyle = AppSurfaceTheme.resolve(
          dialogContext,
          variant: AppSurfaceVariant.card,
          tintColor: context.palette.accent,
        );
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: dialogStyle
                .decoration(radius: 32)
                .copyWith(
                  border: Border.all(
                    color: AppSurfaceTheme.adaptiveColor(
                      dialogContext,
                      context.palette.accent,
                      alpha: 0.26,
                      solidAlphaWhenDisabled: 0.34,
                    ),
                    width: 1.2,
                  ),
                ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      presetLabel,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: context.palette.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    l10n.dhikrAntiRushTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: context.palette.onSurface,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      l10n.dhikrAntiRushVerseArabic,
                      style: QuranPresentationStyle.translucentTextStyle(
                        context,
                        AppTextStyles.quranVerse(
                          size: 28,
                          color: context.palette.onSurface,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.dhikrAntiRushVerseTransliteration,
                    style: QuranPresentationStyle.translucentTextStyle(
                      context,
                      theme.textTheme.titleLarge?.copyWith(
                            color: context.palette.onSurfaceSubtle,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ) ??
                          TextStyle(
                            color: context.palette.onSurfaceSubtle,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.dhikrAntiRushVerseTranslation,
                    style: QuranPresentationStyle.translucentTextStyle(
                      context,
                      theme.textTheme.headlineSmall?.copyWith(
                            color: context.palette.onSurface,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ) ??
                          TextStyle(
                            color: context.palette.onSurface,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.dhikrAntiRushBody,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: context.palette.onSurfaceSubtle,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: context.palette.accent,
                        textStyle: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(l10n.dhikrAntiRushAcknowledgeAction),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (!mounted) {
      _antiRushDialogVisible = false;
      return;
    }
    ref.read(dhikrControllerProvider.notifier).dismissAntiRushReminder();
    _antiRushDialogVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final state = ref.watch(dhikrControllerProvider);
    final notifier = ref.read(dhikrControllerProvider.notifier);
    final dailyDhikrGoal = ref.watch(dhikrDailyGoalProvider);
    final progress = (state.currentCount / state.target).clamp(0, 1).toDouble();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayCompleted = state.recentSessions
        .where((session) => !session.finishedAt.isBefore(todayStart))
        .fold<int>(0, (sum, session) => sum + session.count);
    final todaySessions = state.recentSessions
        .where((session) => !session.finishedAt.isBefore(todayStart))
        .length;
    final todayTotal = todayCompleted + state.currentCount;
    final dailyProgress = (todayTotal / dailyDhikrGoal).clamp(0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: '', subtitle: ''),
        SectionTitle(
          title: l10n.dhikrSectionTitle,
          subtitle: l10n.dhikrSectionSubtitle,
        ),
        PremiumCard(
          surfaceTintColor: context.palette.accent,
          surfaceAlphaOverride: 0.18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                state.selectedPreset.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.palette.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  state.selectedPreset.phrase,
                  textAlign: TextAlign.center,
                  style: QuranPresentationStyle.translucentTextStyle(
                    context,
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: context.palette.onSurface,
                          height: 1.35,
                        ) ??
                        TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: context.palette.onSurface,
                          height: 1.35,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.selectedPreset.transliteration,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                state.selectedPreset.translation,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : MediaQuery.sizeOf(context).width;
                  final orbSize = maxWidth < 420 ? maxWidth * 0.64 : 248.0;
                  final displayScale =
                      (_counterPressed && !reduceMotion ? 0.985 : 1.0) *
                      (reduceMotion ? 1.0 : _counterScale.value);
                  final glowStrength = reduceMotion ? 0.16 : _counterGlow.value;
                  final reachedTarget = state.hasTargetReached;

                  return AnimatedBuilder(
                    animation: _counterPulseController,
                    builder: (context, child) {
                      return Transform.scale(scale: displayScale, child: child);
                    },
                    child: Semantics(
                      button: true,
                      label: l10n.dhikrTapToCountSemantics,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () => _handleCounterTap(
                            notifier: notifier,
                            reduceMotion: reduceMotion,
                          ),
                          borderRadius: BorderRadius.circular(999),
                          splashColor: context.palette.accent.withValues(
                            alpha: 0.08,
                          ),
                          highlightColor: context.palette.accent.withValues(
                            alpha: 0.04,
                          ),
                          child: AnimatedContainer(
                            duration: Duration(
                              milliseconds: reduceMotion ? 80 : 180,
                            ),
                            curve: Curves.easeOutCubic,
                            width: orbSize,
                            height: orbSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                center: const Alignment(-0.12, -0.22),
                                radius: 0.92,
                                colors: reachedTarget
                                    ? <Color>[
                                        const Color(0xFFFFF6D8),
                                        const Color(0xFFF7D985),
                                        const Color(0xFFE4B95B),
                                      ]
                                    : <Color>[
                                        const Color(0xFFFFFBEE),
                                        const Color(0xFFF4DF9A),
                                        const Color(0xFFE7C56B),
                                      ],
                              ),
                              border: Border.all(
                                color: context.palette.accent.withValues(
                                  alpha: reachedTarget ? 0.86 : 0.62,
                                ),
                                width: reachedTarget ? 2.2 : 1.4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: context.palette.accent.withValues(
                                    alpha: 0.18 + (glowStrength * 0.18),
                                  ),
                                  blurRadius: 22 + (glowStrength * 18),
                                  spreadRadius: 1 + (glowStrength * 2),
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        _formatCount(
                                          context,
                                          state.currentCount,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              height: 1,
                                              color: context.palette.onSurface,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      l10n.homeFractionValue(
                                        _formatCount(
                                          context,
                                          state.currentCount,
                                        ),
                                        _formatCount(context, state.target),
                                      ),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: context.palette.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.dhikrTapToCount,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color:
                                                context.palette.onSurfaceSubtle,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              if (state.hasTargetReached)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    isKidsMode
                        ? l10n.kidsDhikrTargetReachedMessage
                        : l10n.dhikrTargetReachedMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.palette.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _DhikrActionPill(
                    icon: Icons.add_rounded,
                    label: isKidsMode
                        ? l10n.kidsDhikrAddManuallyAction
                        : l10n.dhikrAddManuallyAction,
                    onTap: () => _addManualCount(context, ref),
                  ),
                  _DhikrActionPill(
                    icon: Icons.remove_rounded,
                    label: isKidsMode
                        ? l10n.kidsDhikrUndoOneTooltip
                        : l10n.dhikrUndoOneTooltip,
                    onTap: notifier.undo,
                  ),
                  _DhikrActionPill(
                    icon: Icons.refresh_rounded,
                    label: isKidsMode
                        ? l10n.kidsDhikrResetAction
                        : l10n.dhikrResetAction,
                    onTap: () => _confirmReset(context, ref),
                  ),
                  _DhikrActionPill(
                    icon: Icons.check_rounded,
                    emphasize: true,
                    label: isKidsMode
                        ? l10n.kidsDhikrFinishSessionAction
                        : l10n.dhikrFinishSessionAction,
                    onTap: notifier.finishSession,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: AppSurfaceTheme.adaptiveColor(
                    context,
                    context.palette.accentSoft,
                    alpha: 0.20,
                    solidAlphaWhenDisabled: 0.24,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppSurfaceTheme.adaptiveColor(
                      context,
                      context.palette.accent,
                      alpha: 0.92,
                      solidAlphaWhenDisabled: 0.92,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.homeFractionValue(
                  _formatCount(context, state.currentCount),
                  _formatCount(context, state.target),
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.dhikrChoosePhraseTitle,
          subtitle: l10n.dhikrChoosePhraseSubtitle,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...DhikrPreset.defaults.map((preset) {
              final isSelected = preset.id == state.selectedPreset.id;
              return _SelectableDhikrPill(
                label: preset.label,
                isSelected: isSelected,
                onTap: () => notifier.selectPreset(preset),
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.dhikrSessionTargetTitle,
          subtitle: l10n.dhikrSessionTargetSubtitle,
        ),
        Wrap(
          spacing: 8,
          children: [
            ...[33, 99, 100, 500].map(
              (value) => _TargetChip(
                value: value,
                isSelected: state.target == value,
                onTap: () => notifier.setTarget(value),
              ),
            ),
            _TargetChip(
              value: null,
              isSelected: false,
              label: l10n.dhikrCustomTargetChip,
              onTap: () => _setCustomTarget(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isKidsMode
                    ? l10n.kidsDhikrDailyGoalTitle
                    : l10n.dhikrDailyGoalTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: dailyProgress,
                backgroundColor: context.palette.surfaceSoft,
                minHeight: 8,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    l10n.homeFractionValue(
                      _formatCount(context, todayTotal),
                      _formatCount(context, dailyDhikrGoal),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l10n.dhikrDailyGoalEditTooltip,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    onPressed: () => _showDailyGoalPicker(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isKidsMode
                    ? l10n.kidsDhikrDailyGoalSubtitle
                    : l10n.dhikrDailyGoalSubtitle,
                style: TextStyle(color: context.palette.onSurfaceSubtle),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Text(
                l10n.dhikrSessionVsDailyTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.dhikrCurrentSessionValue(
                  l10n.homeFractionValue(
                    _formatCount(context, state.currentCount),
                    _formatCount(context, state.target),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.dhikrCompletedTodayValue(
                  _formatCount(context, todayCompleted),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.dhikrDailyTotalValue(_formatCount(context, todayTotal)),
              ),
              const SizedBox(height: 6),
              Text(l10n.dhikrSessionsCompletedTodayValue(todaySessions)),
              const SizedBox(height: 6),
              Text(l10n.dhikrFavoritePhraseValue(state.summary.favoritePhrase)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.dhikrRecentSessionsTitle,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (state.recentSessions.isEmpty)
          PremiumCard(
            child: Text(
              l10n.dhikrNoCompletedSessionsYet,
              style: TextStyle(color: context.palette.onSurfaceSubtle),
            ),
          )
        else
          ...state.recentSessions.map(
            (session) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RecentDhikrSessionCard(session: session),
            ),
          ),
      ],
    );
  }
}

class _DhikrActionPill extends StatelessWidget {
  const _DhikrActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.emphasize = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final tint = emphasize
        ? context.palette.accent
        : context.palette.accentSoft;
    return NoorGlassCard(
      padding: EdgeInsets.zero,
      surfaceVariant: AppSurfaceVariant.pill,
      surfaceTintColor: tint,
      surfaceAlphaOverride: emphasize ? 0.24 : 0.18,
      includeShadow: false,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: context.palette.onSurface),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TargetChip extends StatelessWidget {
  const _TargetChip({
    this.value,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  final int? value;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = label ?? value.toString();
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: context.palette.accent,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: style
            .decoration(radius: 18, includeShadow: false)
            .copyWith(
              color: isSelected
                  ? AppSurfaceTheme.adaptiveColor(
                      context,
                      context.palette.accent,
                      alpha: 0.18,
                      solidAlphaWhenDisabled: 0.28,
                    )
                  : style.backgroundColor,
              gradient: isSelected ? null : style.gradient,
              border: Border.all(
                color: isSelected ? context.palette.accent : style.borderColor,
              ),
            ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: context.palette.onSurface,
          ),
        ),
      ),
    );
  }
}

class _SelectableDhikrPill extends StatelessWidget {
  const _SelectableDhikrPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: context.palette.accent,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: style
            .decoration(radius: AppRadii.pill, includeShadow: false)
            .copyWith(
              color: isSelected
                  ? AppSurfaceTheme.adaptiveColor(
                      context,
                      context.palette.accent,
                      alpha: 0.16,
                      solidAlphaWhenDisabled: 0.26,
                    )
                  : style.backgroundColor,
              gradient: isSelected ? null : style.gradient,
              border: Border.all(
                color: isSelected
                    ? context.palette.accent
                    : AppSurfaceTheme.adaptiveColor(
                        context,
                        context.palette.accentSoft,
                        alpha: 0.45,
                        solidAlphaWhenDisabled: 0.55,
                      ),
              ),
            ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? context.palette.onSurface
                : context.palette.onSurfaceSubtle,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _RecentDhikrSessionCard extends StatelessWidget {
  const _RecentDhikrSessionCard({required this.session});

  final DhikrSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: context.palette.accentSoft,
            child: Text(
              '${session.count}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.phraseLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.dhikrSessionSummaryValue(
                    l10n.homeFractionValue(
                      _formatCount(context, session.count),
                      _formatCount(context, session.target),
                    ),
                    _formatSessionDuration(context, l10n, session),
                  ),
                  style: TextStyle(color: context.palette.onSurfaceSubtle),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            intl.DateFormat.jm(
              Localizations.localeOf(context).toLanguageTag(),
            ).format(session.finishedAt),
            style: TextStyle(color: context.palette.onSurfaceSubtle),
          ),
        ],
      ),
    );
  }
}

String _formatCount(BuildContext context, num value) {
  return intl.NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

String _formatSessionDuration(
  BuildContext context,
  AppLocalizations l10n,
  DhikrSession session,
) {
  final duration = session.finishedAt.difference(session.startedAt);
  if (duration <= Duration.zero) return l10n.dhikrDurationJustNow;
  return formatCompactDuration(
    duration,
    localeName: l10n.localeName,
    hourSuffix: l10n.durationCompactHourSuffix,
    minuteSuffix: l10n.durationCompactMinuteSuffix,
  );
}

Future<void> _showDailyGoalPicker(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final current = ref.read(dhikrDailyGoalProvider);
  final controller = TextEditingController(text: '$current');
  final result = await showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.dhikrDailyGoalEditTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in const <int>[100, 300, 500, 1000])
                ChoiceChip(
                  label: Text('$preset'),
                  selected: current == preset,
                  onSelected: (_) => Navigator.of(context).pop(preset),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.dhikrDailyGoalEditCustomLabel,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.quranCancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(int.tryParse(controller.text.trim())),
          child: Text(l10n.quranSave),
        ),
      ],
    ),
  );
  if (result != null && result > 0) {
    ref.read(dhikrDailyGoalProvider.notifier).setGoal(result);
  }
}
