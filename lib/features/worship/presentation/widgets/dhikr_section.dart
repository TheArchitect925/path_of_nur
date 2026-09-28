import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/utils/compact_duration_formatter.dart';
import '../../../../shared/widgets/premium_card.dart';
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
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.dhikrAntiRushTitle),
          content: Text(l10n.dhikrAntiRushBody),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.dhikrAntiRushAcknowledgeAction),
            ),
          ],
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
                        color: AppColors.homeAccent.withValues(alpha: 0.22),
                        border: Border.all(
                          color: AppColors.homeAccent.withValues(alpha: 0.7),
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
                          : AppColors.accentGoldSoft.withValues(alpha: 0.45),
                    ),
                    color: isSelected
                        ? AppColors.accentGold.withValues(alpha: 0.16)
                        : AppColors.surfaceSoft.withValues(alpha: 0.35),
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
              ? AppColors.accentGold.withValues(alpha: 0.18)
              : AppColors.surface.withValues(alpha: 0.45),
          border: Border.all(
            color: isSelected
                ? AppColors.accentGold
                : AppColors.accentGoldSoft.withValues(alpha: 0.45),
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
            DateFormat.jm(
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
  return NumberFormat.decimalPattern(
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
