import 'package:flutter/material.dart';

import '../../../../shared/widgets/premium_card.dart';
import '../application/wudu_trainer_controller.dart';
import '../models/wudu_models.dart';
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
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trainer Mode',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          SegmentedButton<WuduTrainerMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: WuduTrainerMode.guided,
                label: Text('Guided'),
                icon: Icon(Icons.directions_walk_rounded),
              ),
              ButtonSegment(
                value: WuduTrainerMode.checklist,
                label: Text('Checklist'),
                icon: Icon(Icons.checklist_rounded),
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
    required this.skippedCount,
  });

  final int currentStep;
  final int totalSteps;
  final int completedCount;
  final int skippedCount;

  @override
  Widget build(BuildContext context) {
    final progress = totalSteps == 0
        ? 0.0
        : (completedCount + skippedCount) / totalSteps;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Step $currentStep of $totalSteps',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '$completedCount done · $skippedCount skipped',
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
    return WuduIllustratedStepCard(
      step: step,
      isCompleted: isCompleted,
      isSkipped: isSkipped,
    );
  }
}

class WuduIllustratedStepCard extends StatelessWidget {
  const WuduIllustratedStepCard({
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
    Color? stateColor;
    String? stateLabel;
    IconData? stateIcon;

    if (isCompleted) {
      stateColor = const Color(0xFF4F7E54);
      stateLabel = 'Completed';
      stateIcon = Icons.check_rounded;
    } else if (isSkipped) {
      stateColor = const Color(0xFFA8773A);
      stateLabel = 'Skipped';
      stateIcon = Icons.fast_forward_rounded;
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.18),
                ),
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
                    color: stateColor!.withValues(alpha: 0.14),
                    border: Border.all(color: stateColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(stateIcon, size: 14, color: stateColor),
                      const SizedBox(width: 4),
                      Text(
                        stateLabel,
                        style: TextStyle(
                          fontSize: 11.5,
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
          WuduStepIllustration(step: step),
          const SizedBox(height: 12),
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
          if (step.trainerNote != null) ...[
            const SizedBox(height: 8),
            Text(
              step.trainerNote!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (step.repeatCount == 3)
                _BadgePill(label: 'Repeat 3x', icon: Icons.repeat_rounded),
              _BadgePill(
                label: 'Be mindful, not obsessive.',
                icon: Icons.spa_outlined,
              ),
            ],
          ),
          if (step.whyItMatters != null) ...[
            const SizedBox(height: 10),
            WuduWhyItMattersPanel(text: step.whyItMatters!),
          ],
        ],
      ),
    );
  }
}

class WuduStepIllustration extends StatelessWidget {
  const WuduStepIllustration({super.key, required this.step});

  final WuduStep step;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolver = WuduStepAssetResolver(step: step);

    return Semantics(
      label: 'Illustration for ${step.title}',
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 168),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.18),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface.withValues(alpha: 0.92),
              colorScheme.surfaceContainerHigh.withValues(alpha: 0.85),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Image.asset(
                resolver.assetPath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
                errorBuilder: (context, error, stackTrace) {
                  return _IllustrationFallback(
                    icon: resolver.fallbackIcon,
                    stepNumber: step.number,
                    label: resolver.placeholderLabel,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WuduWhyItMattersPanel extends StatelessWidget {
  const WuduWhyItMattersPanel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      title: Text(
        'Why this step matters',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class WuduChecklistItem extends StatelessWidget {
  const WuduChecklistItem({
    super.key,
    required this.step,
    required this.isCompleted,
    required this.isSkipped,
    required this.isCurrent,
    required this.showOrderHint,
    required this.onToggle,
    required this.onOpenGuided,
  });

  final WuduStep step;
  final bool isCompleted;
  final bool isSkipped;
  final bool isCurrent;
  final bool showOrderHint;
  final VoidCallback onToggle;
  final VoidCallback onOpenGuided;

  @override
  Widget build(BuildContext context) {
    final status = _statusForStep();

    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              Icon(
                WuduStepAssetResolver(step: step).fallbackIcon,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
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
          const SizedBox(height: 4),
          Row(
            children: [
              _StatusPill(status: status),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onOpenGuided,
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Open in guided'),
              ),
            ],
          ),
          if (showOrderHint)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Recommended order: complete earlier steps first.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF8A6734)),
              ),
            ),
        ],
      ),
    );
  }

  _ChecklistStepStatus _statusForStep() {
    if (isCompleted) return _ChecklistStepStatus.completed;
    if (isSkipped) return _ChecklistStepStatus.skipped;
    if (isCurrent) return _ChecklistStepStatus.current;
    return _ChecklistStepStatus.pending;
  }
}

class WuduTrainerCompletionCard extends StatelessWidget {
  const WuduTrainerCompletionCard({
    super.key,
    required this.dua,
    required this.onRestart,
    required this.onReturn,
  });

  final WuduDua dua;
  final VoidCallback onRestart;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WuduCompletionGlowCard(onRestart: onRestart, onReturn: onReturn),
        const SizedBox(height: 10),
        WuduDuaCard(dua: dua),
      ],
    );
  }
}

class WuduCompletionGlowCard extends StatelessWidget {
  const WuduCompletionGlowCard({
    super.key,
    required this.onRestart,
    required this.onReturn,
  });

  final VoidCallback onRestart;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withValues(alpha: 0.14),
            colorScheme.surface.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_rounded, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Wudu Complete',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'You are prepared for prayer with calm focus and intention.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 6),
            Text(
              'May this purification bring steadiness and presence in worship.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRestart,
                    child: const Text('Restart Trainer'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: onReturn,
                    child: const Text('Return to Guide'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WuduStepAssetResolver {
  const WuduStepAssetResolver({required this.step});

  final WuduStep step;

  String get assetPath => 'assets/images/wudu/${step.illustrationAssetKey}.png';

  String get placeholderLabel => 'Step ${step.number} visual placeholder';

  IconData get fallbackIcon => _iconFor(step.iconKey);

  static IconData _iconFor(String key) {
    switch (key) {
      case 'intention':
        return Icons.favorite_outline_rounded;
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
      case 'arm_left':
        return Icons.accessibility_new_rounded;
      case 'head':
        return Icons.self_improvement_rounded;
      case 'ears':
        return Icons.hearing_rounded;
      case 'foot_right':
      case 'foot_left':
        return Icons.directions_walk_rounded;
      default:
        return Icons.water_drop_outlined;
    }
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

class _IllustrationFallback extends StatelessWidget {
  const _IllustrationFallback({
    required this.icon,
    required this.stepNumber,
    required this.label,
  });

  final IconData icon;
  final int stepNumber;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary.withValues(alpha: 0.14),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.24),
            ),
          ),
          child: Icon(icon, size: 30, color: colorScheme.primary),
        ),
        const SizedBox(height: 10),
        Text(
          'Step $stepNumber',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

enum _ChecklistStepStatus { completed, skipped, current, pending }

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final _ChecklistStepStatus status;

  @override
  Widget build(BuildContext context) {
    final style = switch (status) {
      _ChecklistStepStatus.completed => (
        label: 'Completed',
        color: const Color(0xFF4F7E54),
        icon: Icons.check_rounded,
      ),
      _ChecklistStepStatus.skipped => (
        label: 'Skipped',
        color: const Color(0xFFA8773A),
        icon: Icons.fast_forward_rounded,
      ),
      _ChecklistStepStatus.current => (
        label: 'Current',
        color: Theme.of(context).colorScheme.primary,
        icon: Icons.play_arrow_rounded,
      ),
      _ChecklistStepStatus.pending => (
        label: 'Pending',
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        icon: Icons.schedule_rounded,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: style.color.withValues(alpha: 0.4)),
        color: style.color.withValues(alpha: 0.12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 13, color: style.color),
          const SizedBox(width: 4),
          Text(
            style.label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: style.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
