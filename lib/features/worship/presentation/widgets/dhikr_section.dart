import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/utils/compact_duration_formatter.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/dhikr_controller.dart';
import '../../domain/dhikr_preset.dart';
import '../../domain/dhikr_session.dart';

class DhikrSection extends ConsumerStatefulWidget {
  const DhikrSection({super.key});

  @override
  ConsumerState<DhikrSection> createState() => _DhikrSectionState();
}

class _DhikrSectionState extends ConsumerState<DhikrSection> {
  bool _antiRushDialogVisible = false;

  static const _dailyDhikrGoal = 500;

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
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: const Color(0xFFF6E7C8),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0x26B79661), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3320120B),
                  blurRadius: 28,
                  offset: Offset(0, 18),
                ),
              ],
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
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    l10n.dhikrAntiRushTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.onSurface,
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
                          color: const Color(0xFF261A12),
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
                            color: const Color(0xFF7A654C),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ) ??
                          const TextStyle(
                            color: Color(0xFF7A654C),
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
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ) ??
                          const TextStyle(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.dhikrAntiRushBody,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF8A6430),
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
    final state = ref.watch(dhikrControllerProvider);
    final notifier = ref.read(dhikrControllerProvider.notifier);
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
    final dailyProgress = (todayTotal / _dailyDhikrGoal).clamp(0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: '', subtitle: ''),
        SectionTitle(
          title: l10n.dhikrSectionTitle,
          subtitle: l10n.dhikrSectionSubtitle,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.selectedPreset.label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                state.selectedPreset.transliteration,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              Text(
                state.selectedPreset.translation,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceSoft,
                minHeight: 8,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.homeFractionValue(
                  _formatCount(context, state.currentCount),
                  _formatCount(context, state.target),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  height: 1,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Semantics(
                  button: true,
                  label: l10n.dhikrTapToCountSemantics,
                  child: GestureDetector(
                    onTap: notifier.increment,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppSurfaceTheme.adaptiveColor(
                          context,
                          AppColors.homeAccent,
                          alpha: 0.22,
                          solidAlphaWhenDisabled: 0.30,
                        ),
                        border: Border.all(
                          color: AppSurfaceTheme.adaptiveColor(
                            context,
                            AppColors.homeAccent,
                            alpha: 0.7,
                            solidAlphaWhenDisabled: 0.78,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.dhikrTapToCount,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (state.hasTargetReached)
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    isKidsMode
                        ? l10n.kidsDhikrTargetReachedMessage
                        : l10n.dhikrTargetReachedMessage,
                    style: TextStyle(color: AppColors.success),
                  ),
                ),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconButton(
                    onPressed: notifier.undo,
                    icon: const Icon(Icons.undo_rounded),
                    tooltip: isKidsMode
                        ? l10n.kidsDhikrUndoOneTooltip
                        : l10n.dhikrUndoOneTooltip,
                  ),
                  TextButton.icon(
                    onPressed: () => _addManualCount(context, ref),
                    icon: const Icon(Icons.edit_note_rounded),
                    label: Text(
                      isKidsMode
                          ? l10n.kidsDhikrAddManuallyAction
                          : l10n.dhikrAddManuallyAction,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _confirmReset(context, ref),
                    child: Text(
                      isKidsMode
                          ? l10n.kidsDhikrResetAction
                          : l10n.dhikrResetAction,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: notifier.finishSession,
                    child: Text(
                      isKidsMode
                          ? l10n.kidsDhikrFinishSessionAction
                          : l10n.dhikrFinishSessionAction,
                    ),
                  ),
                ],
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
              return InkWell(
                onTap: () => notifier.selectPreset(preset),
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentGold
                          : AppSurfaceTheme.adaptiveColor(
                              context,
                              AppColors.accentGoldSoft,
                              alpha: 0.45,
                              solidAlphaWhenDisabled: 0.55,
                            ),
                    ),
                    color: isSelected
                        ? AppSurfaceTheme.adaptiveColor(
                            context,
                            AppColors.accentGold,
                            alpha: 0.16,
                            solidAlphaWhenDisabled: 0.26,
                          )
                        : AppSurfaceTheme.adaptiveColor(
                            context,
                            AppColors.surfaceSoft,
                            alpha: 0.35,
                            solidAlphaWhenDisabled: 0.96,
                          ),
                  ),
                  child: Text(
                    preset.label,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.onSurface
                          : AppColors.onSurfaceSubtle,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
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
                backgroundColor: AppColors.surfaceSoft,
                minHeight: 8,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.homeFractionValue(
                  _formatCount(context, todayTotal),
                  _formatCount(context, _dailyDhikrGoal),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isKidsMode
                    ? l10n.kidsDhikrDailyGoalSubtitle
                    : l10n.dhikrDailyGoalSubtitle,
                style: TextStyle(color: AppColors.onSurfaceSubtle),
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
              style: TextStyle(color: AppColors.onSurfaceSubtle),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? AppSurfaceTheme.adaptiveColor(
                  context,
                  AppColors.accentGold,
                  alpha: 0.18,
                  solidAlphaWhenDisabled: 0.28,
                )
              : AppSurfaceTheme.adaptiveColor(
                  context,
                  AppColors.surface,
                  alpha: 0.45,
                  solidAlphaWhenDisabled: 0.96,
                ),
          border: Border.all(
            color: isSelected
                ? AppColors.accentGold
                : AppSurfaceTheme.adaptiveColor(
                    context,
                    AppColors.accentGoldSoft,
                    alpha: 0.45,
                    solidAlphaWhenDisabled: 0.55,
                  ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.onSurface,
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
            backgroundColor: AppColors.accentGoldSoft,
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
                  style: const TextStyle(color: AppColors.onSurfaceSubtle),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            intl.DateFormat.jm(
              Localizations.localeOf(context).toLanguageTag(),
            ).format(session.finishedAt),
            style: const TextStyle(color: AppColors.onSurfaceSubtle),
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
