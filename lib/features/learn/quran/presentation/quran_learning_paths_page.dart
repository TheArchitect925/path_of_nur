import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/quran_guided_learning_paths_provider.dart';
import '../domain/quran_guided_learning_path_models.dart';
import 'quran_learning_path_copy.dart';

class QuranLearningPathsPage extends ConsumerWidget {
  const QuranLearningPathsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final paths = ref.watch(quranGuidedFeaturedLearningPathsProvider);
    final continuePath = ref.watch(quranGuidedContinuePathProvider);
    final continuity = ref.watch(quranGuidedLearningContinuityProvider);
    final continueStep = continuePath?.steps.firstWhere(
      (step) => step.id == continuity.lastStepId,
      orElse: () => continuePath.steps.first,
    );

    return AppPageScaffold(
      headerIcon: Icons.route_rounded,
      title: l10n.quranLearningPathsTitle,
      subtitle: l10n.quranLearningPathsSubtitle,
      children: [
        if (continuePath != null && continueStep != null) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranLearningPathsContinueTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.quranLearningPathsContinueSubtitle(
                    localizedQuranLearningPathTitle(l10n, continuePath.id),
                    localizedQuranLearningPathStepTitle(l10n, continueStep.id),
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(
                    'quranLearningPathDetail',
                    pathParameters: {'pathId': continuePath.id},
                  ),
                  icon: const Icon(Icons.play_circle_outline_rounded),
                  label: Text(l10n.quranLearningPathsOpenContinueAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        ...paths.map(
          (path) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => context.pushNamed(
                  'quranLearningPathDetail',
                  pathParameters: {'pathId': path.id},
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedQuranLearningPathTitle(l10n, path.id),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizedQuranLearningPathSubtitle(l10n, path.id),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizedQuranLearningPathDescription(l10n, path.id),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              localizedQuranLearningPathTypeLabel(
                                l10n,
                                path.type,
                              ),
                            ),
                          ),
                          Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              localizedQuranLearningPathIntensityLabel(
                                l10n,
                                path.intensity,
                              ),
                            ),
                          ),
                          Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              l10n.quranLearningPathsStepCountLabel(
                                path.steps.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class QuranLearningPathDetailPage extends ConsumerWidget {
  const QuranLearningPathDetailPage({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final path = ref.watch(quranGuidedLearningPathByIdProvider(pathId));
    final continuity = ref.watch(quranGuidedLearningContinuityProvider);

    if (path == null) {
      return AppPageScaffold(
        headerIcon: Icons.route_rounded,
        title: l10n.quranLearningPathsTitle,
        subtitle: l10n.quranLearningPathsSubtitle,
        children: [PremiumCard(child: Text(l10n.quranLearningPathNotFound))],
      );
    }

    final continueStep = path.steps.firstWhere(
      (step) => step.id == continuity.lastStepId,
      orElse: () => path.steps.first,
    );

    return AppPageScaffold(
      headerIcon: Icons.route_rounded,
      title: localizedQuranLearningPathTitle(l10n, path.id),
      subtitle: localizedQuranLearningPathSubtitle(l10n, path.id),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizedQuranLearningPathDescription(l10n, path.id),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      localizedQuranLearningPathTypeLabel(l10n, path.type),
                    ),
                  ),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      localizedQuranLearningPathIntensityLabel(
                        l10n,
                        path.intensity,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => _openStep(context, ref, path, continueStep),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l10n.quranLearningPathsOpenContinueAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.quranLearningPathsStepsTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...path.steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isContinueStep =
              continuity.lastPathId == path.id &&
              continuity.lastStepId == step.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 16, child: Text('${index + 1}')),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizedQuranLearningPathStepTitle(
                                l10n,
                                step.id,
                              ),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localizedQuranLearningPathStepSubtitle(
                                l10n,
                                step.id,
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (isContinueStep)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(l10n.quranLearningPathsContinueStepLabel),
                        ),
                      FilledButton.tonal(
                        onPressed: () => _openStep(context, ref, path, step),
                        child: Text(l10n.quranLearningPathsOpenStepAction),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _openStep(
    BuildContext context,
    WidgetRef ref,
    QuranGuidedLearningPath path,
    QuranGuidedLearningPathStep step,
  ) {
    ref
        .read(quranGuidedLearningContinuityProvider.notifier)
        .markStepOpened(pathId: path.id, stepId: step.id);
    context.pushNamed(
      step.routeName,
      pathParameters: step.pathParameters,
      queryParameters: step.queryParameters,
    );
  }
}
