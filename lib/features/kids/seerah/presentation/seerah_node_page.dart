import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/seerah_journey_progress_service.dart';
import '../application/seerah_journey_repository.dart';
import '../domain/seerah_journey_models.dart';

class KidsSeerahNodePage extends ConsumerStatefulWidget {
  const KidsSeerahNodePage({
    super.key,
    required this.journeyId,
    required this.nodeId,
  });

  final String journeyId;
  final String nodeId;

  @override
  ConsumerState<KidsSeerahNodePage> createState() => _KidsSeerahNodePageState();
}

class _KidsSeerahNodePageState extends ConsumerState<KidsSeerahNodePage> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(kidsSeerahJourneyRepositoryProvider);
    final summary = ref.watch(
      kidsSeerahJourneySummaryProvider(widget.journeyId),
    );
    final node = repository.nodeById(widget.nodeId);
    if (summary == null || node == null) {
      return AppPageScaffold(
        title: l10n.kidsSeerahJourneysTitle,
        children: [
          PremiumCard(child: Text(l10n.kidsSeerahJourneyUnavailableSubtitle)),
        ],
      );
    }

    if (!_opened) {
      _opened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(kidsSeerahJourneyProgressProvider.notifier)
            .openNode(journeyId: widget.journeyId, nodeId: node.nodeId);
      });
    }

    final stage = summary.stages.firstWhere(
      (item) => item.stage.stageId == node.stageId,
    );
    final nodeSummary = stage.nodes.firstWhere(
      (item) => item.node.nodeId == node.nodeId,
    );
    final nextNode = repository.nextNodeInJourney(
      journeyId: widget.journeyId,
      currentNodeId: widget.nodeId,
    );

    return AppPageScaffold(
      title: node.title,
      subtitle: stage.stage.title,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                node.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(node.description),
              const SizedBox(height: 12),
              Chip(
                label: Text(
                  nodeSummary.isCompleted
                      ? l10n.kidsSeerahNodeCompletedBadge
                      : l10n.kidsSeerahNodeReadyBadge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._buildNodeBody(
          context: context,
          ref: ref,
          node: node,
          nodeSummary: nodeSummary,
        ),
        if (nextNode != null) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(l10n.kidsSeerahNextNodeLabel(nextNode.title)),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () => context.pushReplacementNamed(
                    'kidsSeerahNode',
                    pathParameters: {
                      'journeyId': widget.journeyId,
                      'nodeId': nextNode.nodeId,
                    },
                  ),
                  child: Text(l10n.kidsSeerahNextNodeAction),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildNodeBody({
    required BuildContext context,
    required WidgetRef ref,
    required KidsSeerahJourneyNode node,
    required KidsSeerahJourneyNodeSummary nodeSummary,
  }) {
    final l10n = AppLocalizations.of(context);
    switch (node.nodeType) {
      case KidsSeerahJourneyNodeType.storyEvent:
      case KidsSeerahJourneyNodeType.companionStory:
        return [
          PremiumCard(
            child: FilledButton.tonalIcon(
              onPressed: node.relatedStoryId == null
                  ? null
                  : () => context.pushNamed(
                      'kidsStoryDetail',
                      pathParameters: {'storyId': node.relatedStoryId!},
                    ),
              icon: const Icon(Icons.auto_stories_rounded),
              label: Text(l10n.kidsSeerahOpenStoryAction),
            ),
          ),
        ];
      case KidsSeerahJourneyNodeType.quiz:
        return [
          PremiumCard(
            child: FilledButton.tonalIcon(
              onPressed: node.relatedQuizStoryId == null
                  ? null
                  : () => context.pushNamed(
                      'kidsStoryQuiz',
                      pathParameters: {'storyId': node.relatedQuizStoryId!},
                    ),
              icon: const Icon(Icons.quiz_rounded),
              label: Text(l10n.kidsSeerahOpenQuizAction),
            ),
          ),
        ];
      case KidsSeerahJourneyNodeType.reflection:
      case KidsSeerahJourneyNodeType.milestone:
        return [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((node.reflectionPrompt ?? '').isNotEmpty) ...[
                  Text(
                    node.reflectionPrompt!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                ...node.reflectionChoices.map(
                  (choice) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.circle_rounded, size: 8),
                        const SizedBox(width: 8),
                        Expanded(child: Text(choice)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: nodeSummary.isCompleted
                      ? null
                      : () {
                          ref
                              .read(kidsSeerahJourneyProgressProvider.notifier)
                              .completeManualNode(
                                journeyId: widget.journeyId,
                                node: node,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.kidsSeerahNodeCompletedSnack),
                            ),
                          );
                          setState(() {});
                        },
                  child: Text(
                    node.nodeType == KidsSeerahJourneyNodeType.milestone
                        ? l10n.kidsSeerahMarkMilestoneAction
                        : l10n.kidsSeerahMarkReflectionAction,
                  ),
                ),
              ],
            ),
          ),
        ];
    }
  }
}
