import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../analytics/application/learn_analytics_service.dart';
import '../../application/learn_enrichment_provider.dart';
import '../../domain/learn_enrichment_models.dart';

class LearnMilestoneMomentCard extends ConsumerWidget {
  const LearnMilestoneMomentCard({super.key, required this.moment});

  final LocalizedLearningMilestoneMoment moment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(learnEnrichmentControllerProvider.notifier);
    final analytics = ref.read(learnAnalyticsServiceProvider);
    final accent = moment.isKids
        ? const Color(0xFF7A61D1)
        : const Color(0xFF2E6A63);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: accent.withValues(alpha: 0.12),
                ),
                child: Icon(
                  IconData(moment.iconCodePoint, fontFamily: 'MaterialIcons'),
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.learnEnrichmentMomentLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      moment.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(moment.body),
          const SizedBox(height: 8),
          Text(
            moment.encouragement,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (moment.pathId != null)
                FilledButton.tonalIcon(
                  onPressed: () {
                    analytics.logRelatedContentOpened(
                      sourceId: moment.id,
                      targetId: moment.pathId!,
                      sourceSurface: 'learn_enrichment_moment',
                    );
                    controller.acknowledgeMilestone(
                      moment.id.replaceFirst('memory:', ''),
                    );
                    context.pushNamed(
                      'learnGuidedPathDetail',
                      pathParameters: <String, String>{
                        'pathId': moment.pathId!,
                      },
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(l10n.learnEnrichmentOpenPathAction),
                ),
              OutlinedButton(
                onPressed: () {
                  controller.acknowledgeMilestone(
                    moment.id.replaceFirst('memory:', ''),
                  );
                },
                child: Text(l10n.learnEnrichmentKeepGoingAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LearnMemoryHighlightsCard extends StatelessWidget {
  const LearnMemoryHighlightsCard({
    super.key,
    required this.memories,
    required this.encouragement,
  });

  final List<LocalizedLearningMemoryCard> memories;
  final String? encouragement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (memories.isEmpty) return const SizedBox.shrink();
    final material = MaterialLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnEnrichmentMemoriesTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(l10n.learnEnrichmentMemoriesSubtitle),
          const SizedBox(height: 12),
          ...memories
              .take(3)
              .map(
                (memory) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              (memory.isKids
                                      ? const Color(0xFF7A61D1)
                                      : const Color(0xFF2E6A63))
                                  .withValues(alpha: 0.10),
                        ),
                        child: Icon(
                          IconData(
                            memory.iconCodePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              memory.title,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              memory.body,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              material.formatCompactDate(memory.occurredAt),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (encouragement != null) ...[
            const SizedBox(height: 4),
            Text(
              encouragement!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LearnPathCompletionCard extends ConsumerWidget {
  const LearnPathCompletionCard({
    super.key,
    required this.pathId,
    required this.completion,
  });

  final String pathId;
  final LocalizedLearningPathCompletionEnrichment completion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(learnAnalyticsServiceProvider);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            completion.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            completion.subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(completion.body),
          if (completion.memoryLine != null) ...[
            const SizedBox(height: 10),
            Text(
              completion.memoryLine!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            completion.encouragement,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (completion.primarySuggestions.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              l10n.learnEnrichmentNextPathsTitle,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: completion.primarySuggestions
                  .map(
                    (suggestion) => ActionChip(
                      label: Text(suggestion.title),
                      onPressed: () {
                        analytics.logRelatedContentOpened(
                          sourceId: 'path_complete:$pathId',
                          targetId: suggestion.pathId,
                          sourceSurface: 'guided_path_detail_complete',
                        );
                        context.pushNamed(
                          'learnGuidedPathDetail',
                          pathParameters: <String, String>{
                            'pathId': suggestion.pathId,
                          },
                        );
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}
