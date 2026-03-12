import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/wudu_trainer_controller.dart';
import '../data/wudu_content.dart';
import '../widgets/wudu_trainer_widgets.dart';

class WuduTrainerPage extends ConsumerWidget {
  const WuduTrainerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wuduTrainerControllerProvider);
    final controller = ref.read(wuduTrainerControllerProvider.notifier);

    return LearnHubPageScaffold(
      headerIcon: IslamicIcons.wudhu,
      title: 'Wudu Trainer',
      subtitle: 'Interactive guided practice for purification before prayer.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'For learning and practice',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Learn with calmness and consistency.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Be mindful, not obsessive.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Text(
                wuduContent.learningNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        WuduTrainerModeSelector(
          mode: state.mode,
          onChanged: controller.setMode,
        ),
        const SizedBox(height: 10),
        if (state.mode == WuduTrainerMode.guided)
          _GuidedModeSection(state: state)
        else if (state.mode == WuduTrainerMode.checklist)
          _ChecklistModeSection(state: state)
        else
          const PremiumCard(
            child: Text(
              'Kids Mode will be added in a future update. Trainer logic is already prepared for it.',
            ),
          ),
      ],
    );
  }
}

class _GuidedModeSection extends ConsumerWidget {
  const _GuidedModeSection({required this.state});

  final WuduTrainerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(wuduTrainerControllerProvider.notifier);
    final steps = wuduContent.steps;

    if (state.guidedFinished) {
      return WuduTrainerCompletionCard(
        dua: wuduContent.afterWuduDua,
        onRestart: controller.restartGuided,
        onReturn: () => Navigator.of(context).maybePop(),
      );
    }

    final index = state.currentStepIndex.clamp(0, steps.length - 1);
    final step = steps[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WuduProgressHeader(
          currentStep: state.currentStepNumber,
          totalSteps: state.totalSteps,
          completedCount: state.completedStepNumbers.length,
          skippedCount: state.skippedStepNumbers.length,
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: WuduGuidedStepCard(
            key: ValueKey(step.number),
            step: step,
            isCompleted: state.isCompleted(step.number),
            isSkipped: state.isSkipped(step.number),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Review mode',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Switch.adaptive(
                    value: state.reviewModeEnabled,
                    onChanged: (_) => controller.toggleReviewMode(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: state.currentStepIndex > 0
                          ? controller.goPrevious
                          : null,
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.skipCurrentStep,
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: state.isProcessed(step.number)
                          ? (state.canMoveNext ? controller.goNext : null)
                          : controller.completeCurrentStep,
                      child: Text(
                        state.isProcessed(step.number)
                            ? 'Next'
                            : 'Complete Step',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChecklistModeSection extends ConsumerWidget {
  const _ChecklistModeSection({required this.state});

  final WuduTrainerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(wuduTrainerControllerProvider.notifier);
    final steps = wuduContent.steps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Checklist Mode',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Wudu should be performed in sequence from start to finish.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...steps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: WuduChecklistItem(
              step: step,
              isCompleted: state.isCompleted(step.number),
              isSkipped: state.isSkipped(step.number),
              isCurrent: state.currentStepNumber == step.number,
              showOrderHint: state.lastOutOfOrderStepNumber == step.number,
              onToggle: () => controller.toggleChecklistStep(step.number),
              onOpenGuided: () => controller.jumpToStepIndex(step.number - 1),
            ),
          ),
        ),
        if (state.completedStepNumbers.length == state.totalSteps)
          WuduTrainerCompletionCard(
            dua: wuduContent.afterWuduDua,
            onRestart: controller.resetProgress,
            onReturn: () => Navigator.of(context).maybePop(),
          ),
      ],
    );
  }
}
