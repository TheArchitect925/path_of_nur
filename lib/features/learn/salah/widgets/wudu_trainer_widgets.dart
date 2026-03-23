import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/wudu_trainer_controller.dart';
import '../models/wudu_models.dart';
import '../presentation/wudu_localizations.dart';
import 'wudu_cards.dart';

class WuduTrainerModeSelector extends StatelessWidget {
  const WuduTrainerModeSelector({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final WuduTrainerMode mode;
  final ValueChanged<WuduTrainerMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.wuduTrainerModeTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          SegmentedButton<WuduTrainerMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: WuduTrainerMode.guided,
                label: Text(l10n.wuduTrainerModeGuided),
                icon: const Icon(Icons.directions_walk_rounded),
              ),
              ButtonSegment(
                value: WuduTrainerMode.checklist,
                label: Text(l10n.wuduTrainerModeChecklist),
                icon: const Icon(Icons.checklist_rounded),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (selection) {
              if (selection.isEmpty) return;
              onChanged(selection.first);
            },
          ),
        ],
      ),
    );
  }
}

class WuduProgressHeader extends StatelessWidget {
  const WuduProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.completedCount,
  });

  final int currentStep;
  final int totalSteps;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = totalSteps == 0 ? 0.0 : completedCount / totalSteps;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.wuduTrainerProgressOf(currentStep, totalSteps),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                l10n.wuduTrainerProgressCounts(completedCount, totalSteps),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress.clamp(0.0, 1.0),
            ),
          ),
        ],
      ),
    );
  }
}

class WuduTrainerCompletionStatusCard extends StatelessWidget {
  const WuduTrainerCompletionStatusCard({
    super.key,
    required this.summary,
    required this.isReviewing,
    required this.onReviewSteps,
    required this.onRestart,
    this.onViewSummary,
    this.onTakeQuiz,
  });

  final String summary;
  final bool isReviewing;
  final VoidCallback onReviewSteps;
  final VoidCallback onRestart;
  final VoidCallback? onViewSummary;
  final VoidCallback? onTakeQuiz;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.wuduTrainerCompletedStateTitleText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(summary, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!isReviewing)
                FilledButton.tonal(
                  onPressed: onReviewSteps,
                  child: Text(l10n.wuduTrainerReviewStepsActionText),
                ),
              if (isReviewing && onViewSummary != null)
                FilledButton.tonal(
                  onPressed: onViewSummary,
                  child: Text(l10n.wuduTrainerViewCompletionSummaryActionText),
                ),
              if (onTakeQuiz != null)
                FilledButton.tonal(
                  onPressed: onTakeQuiz,
                  child: Text(l10n.wuduQuizStartAction),
                ),
              OutlinedButton(
                onPressed: onRestart,
                child: Text(l10n.wuduTrainerStartAgainActionText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WuduGuidedStepCard extends StatelessWidget {
  const WuduGuidedStepCard({
    super.key,
    required this.step,
    required this.isCompleted,
    required this.isSkipped,
  });

  final WuduStep step;
  final bool isCompleted;
  final bool isSkipped;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String? stateLabel;
    Color? stateColor;
    IconData? stateIcon;

    if (isCompleted) {
      stateLabel = l10n.wuduTrainerStatusCompleted;
      stateColor = const Color(0xFF4F7E54);
      stateIcon = Icons.check_rounded;
    } else if (isSkipped) {
      stateLabel = l10n.wuduTrainerStatusSkipped;
      stateColor = const Color(0xFFA8773A);
      stateIcon = Icons.fast_forward_rounded;
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.16),
                child: Text(
                  '${step.number}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
              if (stateLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: stateColor!.withValues(alpha: 0.12),
                    border: Border.all(
                      color: stateColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(stateIcon, size: 14, color: stateColor),
                      const SizedBox(width: 4),
                      Text(
                        stateLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: stateColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _WuduStepIllustration(step: step),
          const SizedBox(height: 12),
          Text(
            step.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BadgePill(
                label: l10n.wuduTrainerStepRepeatBadge,
                icon: Icons.repeat_rounded,
              ),
              _BadgePill(
                label: l10n.wuduTrainerStepCalmBadge,
                icon: Icons.spa_outlined,
              ),
            ],
          ),
          if (step.teachingNote != null) ...[
            const SizedBox(height: 10),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                l10n.wuduTrainerStepMattersTitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    step.teachingNote!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class WuduChecklistItem extends StatelessWidget {
  const WuduChecklistItem({
    super.key,
    required this.step,
    required this.isCompleted,
    required this.isCurrent,
    required this.showOrderHint,
    required this.onToggle,
    required this.onOpenGuided,
  });

  final WuduStep step;
  final bool isCompleted;
  final bool isCurrent;
  final bool showOrderHint;
  final VoidCallback onToggle;
  final VoidCallback onOpenGuided;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = isCompleted
        ? l10n.wuduTrainerStatusCompleted
        : (isCurrent
              ? l10n.wuduTrainerStatusCurrent
              : l10n.wuduTrainerStatusPending);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.16),
                child: Text(
                  '${step.number}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  step.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Checkbox(value: isCompleted, onChanged: (_) => onToggle()),
            ],
          ),
          const SizedBox(height: 6),
          Text(step.subtitle),
          const SizedBox(height: 8),
          Row(
            children: [
              _BadgePill(label: status, icon: Icons.checklist_rtl_rounded),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onOpenGuided,
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(l10n.wuduTrainerChecklistOpenGuidedAction),
              ),
            ],
          ),
          if (showOrderHint)
            Text(
              l10n.wuduTrainerOrderHint,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF8A6734)),
            ),
        ],
      ),
    );
  }
}

class WuduTrainerCompletionCard extends StatelessWidget {
  const WuduTrainerCompletionCard({
    super.key,
    required this.dua,
    required this.onReviewSteps,
    required this.onRestart,
    required this.onReturn,
    this.onTakeQuiz,
    this.rewardSummary,
  });

  final WuduDua dua;
  final VoidCallback onReviewSteps;
  final VoidCallback onRestart;
  final VoidCallback onReturn;
  final VoidCallback? onTakeQuiz;
  final WuduTrainerRewardSummary? rewardSummary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.wuduTrainerCompletionTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.wuduTrainerCompletionBody,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.wuduTrainerCompletionNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (rewardSummary != null) ...[
                const SizedBox(height: 10),
                Text(
                  [
                    l10n.wuduTrainerCompletionFeedback,
                    l10n.wuduTrainerRewardFeedbackText(
                      rewardSummary!.xpAwarded,
                      rewardSummary!.oceanDropsAwarded,
                    ),
                  ].join('\n'),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: onReviewSteps,
                  child: Text(l10n.wuduTrainerReviewStepsActionText),
                ),
              ),
              if (onTakeQuiz != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onTakeQuiz,
                    child: Text(l10n.wuduQuizStartAction),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onRestart,
                      child: Text(l10n.wuduTrainerStartAgainActionText),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: onReturn,
                      child: Text(l10n.wuduTrainerReturnToGuideAction),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        WuduDuaCard(dua: dua),
      ],
    );
  }
}

class _WuduStepIllustration extends StatelessWidget {
  const _WuduStepIllustration({required this.step});

  final WuduStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 168),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            step.imageAssetPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(
                _fallbackIconFor(step.iconKey),
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

IconData _fallbackIconFor(String key) {
  switch (key) {
    case 'intention':
      return Icons.favorite_outline_rounded;
    case 'water':
      return Icons.water_drop_outlined;
    case 'bismillah':
      return Icons.record_voice_over_rounded;
    case 'hands':
      return Icons.front_hand_outlined;
    case 'mouth':
      return Icons.mood_rounded;
    case 'nose':
      return Icons.air_rounded;
    case 'face':
      return Icons.face_retouching_natural_rounded;
    case 'arm_right':
      return Icons.accessibility_new_rounded;
    case 'head':
      return Icons.self_improvement_rounded;
    case 'foot_right':
      return Icons.directions_walk_rounded;
    case 'shahada':
      return Icons.mosque_rounded;
    case 'dua':
      return Icons.volunteer_activism_outlined;
    case 'cleanup':
      return Icons.clean_hands_outlined;
    default:
      return Icons.water_drop_outlined;
  }
}
