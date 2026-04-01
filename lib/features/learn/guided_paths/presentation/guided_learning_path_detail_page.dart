import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../enrichment/application/learn_enrichment_provider.dart';
import '../../enrichment/presentation/widgets/learn_enrichment_cards.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/guided_learning_paths_provider.dart';
import '../domain/guided_learning_path_models.dart';

class GuidedLearningPathDetailPage extends ConsumerWidget {
  const GuidedLearningPathDetailPage({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final localizedPath = ref.watch(
      localizedGuidedLearningPathByIdProvider(pathId),
    );
    if (localizedPath == null) {
      return LearnHubPageScaffold(
        title: l10n.guidedLearningPathsTitle,
        subtitle: l10n.guidedLearningPathMissingSubtitle,
        children: [
          PremiumCard(child: Text(l10n.guidedLearningPathMissingBody)),
        ],
      );
    }
    final progress = ref.watch(guidedLearningPathProgressProvider(pathId));
    final completionEnrichment = ref.watch(
      localizedPathCompletionEnrichmentProvider(pathId),
    );
    final controller = ref.read(guidedLearningPathsControllerProvider.notifier);
    final visibilityPolicy = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy,
      ),
    );
    final nextStep = _nextIncompleteStep(localizedPath.path, progress);
    final completedCount = progress.completedStepIds.length;
    final totalCount = localizedPath.path.steps.length;
    final percent = totalCount == 0
        ? 0
        : ((completedCount / totalCount) * 100).round();

    if (visibilityPolicy.isChildProfile &&
        localizedPath.path.audience != GuidedLearningPathAudience.kids) {
      return LearnHubPageScaffold(
        title: l10n.guidedLearningPathsTitle,
        subtitle: l10n.guidedLearningPathUnavailableSubtitle,
        children: [
          PremiumCard(child: Text(l10n.guidedLearningPathUnavailableBody)),
        ],
      );
    }

    return LearnHubPageScaffold(
      headerIcon: IconData(
        localizedPath.path.iconCodePoint,
        fontFamily: 'MaterialIcons',
      ),
      title: localizedPath.title,
      subtitle: localizedPath.subtitle,
      children: [
        if (completionEnrichment != null) ...[
          LearnPathCompletionCard(
            pathId: pathId,
            completion: completionEnrichment,
          ),
          const SizedBox(height: 12),
        ],
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizedPath.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: totalCount == 0 ? 0 : completedCount / totalCount,
                  minHeight: 8,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _statusChip(
                    context,
                    label: l10n.guidedLearningPathProgressValue(
                      completedCount,
                      totalCount,
                    ),
                  ),
                  _statusChip(
                    context,
                    label: l10n.guidedLearningPathPercentValue(percent),
                  ),
                  if (progress.isCompleted)
                    _statusChip(
                      context,
                      label: l10n.guidedLearningPathCompletedLabel,
                    )
                  else if (nextStep != null)
                    _statusChip(
                      context,
                      label: l10n.guidedLearningPathNextStepLabel(
                        localizedPath.steps
                            .firstWhere((item) => item.step.id == nextStep.id)
                            .title,
                      ),
                    ),
                ],
              ),
              if (nextStep != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.guidedLearningPathStepOfTotal(
                          localizedPath.steps.indexWhere(
                                (item) => item.step.id == nextStep.id,
                              ) +
                              1,
                          totalCount,
                        ),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.guidedLearningPathCurrentStepLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        localizedPath.steps
                            .firstWhere((item) => item.step.id == nextStep.id)
                            .title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: nextStep == null
                        ? null
                        : () {
                            controller.markStepOpened(
                              localizedPath.path,
                              nextStep,
                              sourceSurface: 'guided_path_detail',
                            );
                            _openTarget(context, nextStep.routeTarget);
                          },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      progress.isStarted
                          ? l10n.guidedLearningPathContinueAction
                          : l10n.guidedLearningPathStartAction,
                    ),
                  ),
                  if (nextStep != null)
                    OutlinedButton.icon(
                      onPressed: () {
                        final nextAfterCompletion = _nextIncompleteStepFromIds(
                          localizedPath.path,
                          <String>{...progress.completedStepIds, nextStep.id},
                        );
                        controller.markStepCompleted(
                          localizedPath.path,
                          nextStep,
                          sourceSurface: 'guided_path_detail',
                        );
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              nextAfterCompletion == null
                                  ? l10n.guidedLearningPathCompletedMessage(
                                      localizedPath.title,
                                    )
                                  : l10n.guidedLearningPathNextUnlockedMessage(
                                      localizedPath.steps
                                          .firstWhere(
                                            (item) =>
                                                item.step.id ==
                                                nextAfterCompletion.id,
                                          )
                                          .title,
                                    ),
                            ),
                            action: nextAfterCompletion == null
                                ? null
                                : SnackBarAction(
                                    label:
                                        l10n.guidedLearningPathOpenNextAction,
                                    onPressed: () {
                                      controller.markStepOpened(
                                        localizedPath.path,
                                        nextAfterCompletion,
                                        sourceSurface: 'guided_path_detail',
                                      );
                                      _openTarget(
                                        context,
                                        nextAfterCompletion.routeTarget,
                                      );
                                    },
                                  ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: Text(
                        l10n.guidedLearningPathMarkStepCompleteAction,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...localizedPath.steps.asMap().entries.map((entry) {
          final index = entry.key;
          final localizedStep = entry.value;
          final isComplete = progress.completedStepIds.contains(
            localizedStep.step.id,
          );
          final isNext = !isComplete && nextStep?.id == localizedStep.step.id;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == localizedPath.steps.length - 1 ? 0 : 10,
            ),
            child: _GuidedLearningPathStepCard(
              localizedPath: localizedPath,
              localizedStep: localizedStep,
              isComplete: isComplete,
              isNext: isNext,
              stepNumber: index + 1,
              onOpen: () {
                controller.markStepOpened(
                  localizedPath.path,
                  localizedStep.step,
                  sourceSurface: 'guided_path_detail',
                );
                _openTarget(context, localizedStep.step.routeTarget);
              },
              onMarkComplete: isComplete
                  ? null
                  : () => controller.markStepCompleted(
                      localizedPath.path,
                      localizedStep.step,
                      sourceSurface: 'guided_path_detail',
                    ),
            ),
          );
        }),
      ],
    );
  }

  GuidedLearningPathStep? _nextIncompleteStep(
    GuidedLearningPath path,
    GuidedLearningPathProgress progress,
  ) {
    return _nextIncompleteStepFromIds(path, progress.completedStepIds);
  }

  GuidedLearningPathStep? _nextIncompleteStepFromIds(
    GuidedLearningPath path,
    Set<String> completedStepIds,
  ) {
    for (final step in path.steps) {
      if (!completedStepIds.contains(step.id)) return step;
    }
    return null;
  }

  void _openTarget(BuildContext context, GuidedLearningPathRouteTarget target) {
    context.pushNamed(
      target.routeName,
      pathParameters: target.pathParameters,
      queryParameters: target.queryParameters,
    );
  }

  Widget _statusChip(BuildContext context, {required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _GuidedLearningPathStepCard extends StatelessWidget {
  const _GuidedLearningPathStepCard({
    required this.localizedPath,
    required this.localizedStep,
    required this.isComplete,
    required this.isNext,
    required this.stepNumber,
    required this.onOpen,
    required this.onMarkComplete,
  });

  final LocalizedGuidedLearningPath localizedPath;
  final LocalizedGuidedLearningPathStep localizedStep;
  final bool isComplete;
  final bool isNext;
  final int stepNumber;
  final VoidCallback onOpen;
  final VoidCallback? onMarkComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final accent = switch (localizedPath.path.bucketId) {
      'quran' => Theme.of(context).colorScheme.primary,
      'worship' => const Color(0xFF2B7A78),
      'character' => const Color(0xFF8A5A44),
      'kids' => const Color(0xFF8F6AE3),
      _ => const Color(0xFF7A5C2E),
    };
    final background = isNext
        ? accent.withValues(alpha: 0.08)
        : isComplete
        ? Theme.of(context).colorScheme.surfaceContainerLowest
        : Colors.transparent;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: isComplete ? 0.82 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accent.withValues(alpha: isNext ? 0.30 : 0.12),
          ),
          color: background,
          boxShadow: isNext
              ? <BoxShadow>[
                  BoxShadow(
                    color: accent.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$stepNumber',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isNext)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              l10n.guidedLearningPathCurrentStepLabel,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: accent,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        Text(
                          localizedStep.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(localizedStep.subtitle),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (isComplete)
                    Icon(Icons.check_circle_rounded, color: accent)
                  else if (isNext)
                    Icon(Icons.arrow_forward_rounded, color: accent),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: Text(
                      isNext
                          ? l10n.guidedLearningPathContinueStepAction
                          : l10n.guidedLearningPathStepOpenAction,
                    ),
                  ),
                  if (!isComplete)
                    OutlinedButton.icon(
                      onPressed: () {
                        onMarkComplete?.call();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                              l10n.guidedLearningPathStepCompletedMessage(
                                localizedStep.title,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.task_alt_rounded),
                      label: Text(
                        l10n.guidedLearningPathMarkStepCompleteAction,
                      ),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: onOpen,
                      icon: const Icon(Icons.replay_rounded),
                      label: Text(l10n.guidedLearningPathReviewStepAction),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
