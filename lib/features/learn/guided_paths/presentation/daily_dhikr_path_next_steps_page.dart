import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/guided_learning_paths_provider.dart';
import '../domain/guided_learning_path_icon_registry.dart';
import '../../../../core/theme/app_palette.dart';

class DailyDhikrPathNextStepsPage extends ConsumerWidget {
  const DailyDhikrPathNextStepsPage({super.key});

  static const List<String> _nextPathIds = <String>[
    'character-starter',
    'salah-starter',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(learnAnalyticsServiceProvider);
    final localizedPaths = _nextPathIds
        .map(
          (pathId) =>
              ref.watch(localizedGuidedLearningPathByIdProvider(pathId)),
        )
        .whereType<LocalizedGuidedLearningPath>()
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: Icons.self_improvement_rounded,
      title: l10n.learnDailyDhikrNextStepsTitle,
      subtitle: l10n.learnDailyDhikrNextStepsSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnDailyDhikrNextStepsIntroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.learnDailyDhikrNextStepsIntroBody),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () {
                  analytics.logPrimaryCardOpened(
                    cardId: 'dhikr_tool',
                    sourceSurface: 'daily_dhikr_next_steps',
                    domain: 'worship',
                  );
                  context.pushNamed('worshipDhikrPage');
                },
                icon: const Icon(Icons.favorite_border_rounded),
                label: Text(l10n.learnDailyDhikrNextStepsOpenToolAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnDailyDhikrNextStepsSectionTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.learnDailyDhikrNextStepsSectionSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              ...localizedPaths.asMap().entries.map((entry) {
                final index = entry.key;
                final localizedPath = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == localizedPaths.length - 1 ? 0 : 12,
                  ),
                  child: _NextPathCard(
                    localizedPath: localizedPath,
                    helperText: _helperTextForPath(
                      context,
                      localizedPath.path.id,
                    ),
                    analytics: analytics,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  String _helperTextForPath(BuildContext context, String pathId) {
    final l10n = AppLocalizations.of(context);
    return switch (pathId) {
      'character-starter' => l10n.learnDailyDhikrNextStepsCharacterHint,
      'salah-starter' => l10n.learnDailyDhikrNextStepsSalahHint,
      _ => '',
    };
  }
}

class _NextPathCard extends ConsumerWidget {
  const _NextPathCard({
    required this.localizedPath,
    required this.helperText,
    required this.analytics,
  });

  final LocalizedGuidedLearningPath localizedPath;
  final String helperText;
  final LearnAnalyticsService analytics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(
      guidedLearningPathProgressProvider(localizedPath.path.id),
    );
    final completedCount = progress.completedStepIds.length;
    final totalCount = localizedPath.path.steps.length;
    final accent = switch (localizedPath.path.id) {
      'character-starter' => context.palette.error,
      'salah-starter' => const Color(0xFF2B7A78),
      _ => Theme.of(context).colorScheme.primary,
    };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
        color: accent.withValues(alpha: 0.04),
      ),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    GuidedLearningPathIconRegistry.iconForPathId(
                      localizedPath.path.id,
                    ),
                    color: accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedPath.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(localizedPath.subtitle),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              helperText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            if (progress.isStarted) ...[
              ProgressBar(
                value: totalCount == 0 ? 0 : completedCount / totalCount,
                height: 8,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 6),
            ],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _statusChip(
                  context,
                  label: progress.isCompleted
                      ? l10n.guidedLearningPathCompletedLabel
                      : progress.isStarted
                      ? l10n.guidedLearningPathProgressValue(
                          completedCount,
                          totalCount,
                        )
                      : l10n.guidedLearningPathStatusNotStarted,
                ),
                FilledButton.icon(
                  onPressed: () {
                    analytics.logRelatedContentOpened(
                      sourceId: 'daily_dhikr_next_steps',
                      targetId: localizedPath.path.id,
                      sourceSurface: 'daily_dhikr_next_steps',
                    );
                    context.pushNamed(
                      'learnGuidedPathDetail',
                      pathParameters: <String, String>{
                        'pathId': localizedPath.path.id,
                      },
                    );
                  },
                  icon: Icon(
                    progress.isStarted
                        ? Icons.play_arrow_rounded
                        : Icons.alt_route_rounded,
                  ),
                  label: Text(
                    progress.isStarted
                        ? l10n.guidedLearningPathContinueAction
                        : l10n.guidedLearningPathStartAction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
