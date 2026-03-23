import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/wudu_trainer_controller.dart';
import '../data/wudu_content.dart';
import '../models/wudu_models.dart';
import '../widgets/wudu_trainer_widgets.dart';

class WuduTrainerPage extends ConsumerWidget {
  const WuduTrainerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final content = buildWuduContent(l10n);
    final state = ref.watch(wuduTrainerControllerProvider);
    final controller = ref.read(wuduTrainerControllerProvider.notifier);

    return LearnHubPageScaffold(
      headerIcon: IslamicIcons.wudhu,
      title: content.heroTitle,
      subtitle: content.heroSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.introTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                content.introSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 6),
              Text(
                content.learningNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (state.completedOnce) ...[
          const SizedBox(height: 10),
          WuduTrainerCompletionStatusCard(
            summary: content.reviewSummary,
            isReviewing: state.mode == WuduTrainerMode.checklist,
            onReviewSteps: controller.openReviewAllSteps,
            onRestart: controller.restartGuided,
            onTakeQuiz: () => context.pushNamed('learnWuduQuiz'),
            onViewSummary: state.mode == WuduTrainerMode.checklist
                ? controller.showCompletionSummary
                : null,
          ),
        ],
        if (state.shouldOfferResume) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.wuduTrainerResumeTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.wuduTrainerResumeSubtitle(
                    state.resumeStepNumber,
                    state.totalSteps,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(
                      onPressed: () =>
                          controller.jumpToStepIndex(state.resumeStepIndex),
                      child: Text(l10n.wuduTrainerResumeAction),
                    ),
                    OutlinedButton(
                      onPressed: controller.restartGuided,
                      child: Text(l10n.wuduTrainerStartAgainActionText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        WuduTrainerModeSelector(
          mode: state.mode,
          onChanged: controller.setMode,
        ),
        const SizedBox(height: 10),
        if (state.mode == WuduTrainerMode.guided)
          _GuidedModeSection(state: state, content: content)
        else
          _ChecklistModeSection(state: state, content: content),
      ],
    );
  }
}

class _GuidedModeSection extends ConsumerWidget {
  const _GuidedModeSection({required this.state, required this.content});

  final WuduTrainerState state;
  final WuduContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(wuduTrainerControllerProvider.notifier);
    final steps = content.steps;

    if (state.guidedFinished) {
      return WuduTrainerCompletionCard(
        dua: content.afterWuduDua,
        rewardSummary: state.rewardSummary,
        onReviewSteps: controller.openReviewAllSteps,
        onRestart: controller.restartGuided,
        onTakeQuiz: () => context.pushNamed('learnWuduQuiz'),
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
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: WuduGuidedStepCard(
            key: ValueKey(step.id),
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
                    l10n.wuduTrainerReviewModeTitle,
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
              const SizedBox(height: 6),
              Text(
                l10n.wuduTrainerReviewModeSubtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: state.currentStepIndex > 0
                          ? controller.goPrevious
                          : null,
                      child: Text(l10n.wuduTrainerPreviousAction),
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
                            ? l10n.wuduTrainerNextAction
                            : l10n.wuduTrainerCompleteStepAction,
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
  const _ChecklistModeSection({required this.state, required this.content});

  final WuduTrainerState state;
  final WuduContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(wuduTrainerControllerProvider.notifier);
    final steps = content.steps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.checklistTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                content.checklistSubtitle,
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
              isCurrent: state.currentStepNumber == step.number,
              showOrderHint: state.lastOutOfOrderStepNumber == step.number,
              onToggle: () => controller.toggleChecklistStep(step.number),
              onOpenGuided: () => controller.jumpToStepIndex(step.number - 1),
            ),
          ),
        ),
        if (state.completedStepNumbers.length == state.totalSteps)
          WuduTrainerCompletionCard(
            dua: content.afterWuduDua,
            rewardSummary: state.rewardSummary,
            onReviewSteps: controller.showCompletionSummary,
            onRestart: controller.resetProgress,
            onTakeQuiz: () => context.pushNamed('learnWuduQuiz'),
            onReturn: () => Navigator.of(context).maybePop(),
          ),
      ],
    );
  }
}
