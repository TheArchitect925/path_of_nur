import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../bedtime_stories/presentation/bedtime_story_mini_player.dart';
import '../application/seerah_journey_progress_service.dart';
import '../domain/seerah_journey_models.dart';
import '../../../../core/theme/app_icons.dart';

class KidsSeerahJourneyPage extends ConsumerStatefulWidget {
  const KidsSeerahJourneyPage({super.key, required this.journeyId});

  final String journeyId;

  @override
  ConsumerState<KidsSeerahJourneyPage> createState() =>
      _KidsSeerahJourneyPageState();
}

class _KidsSeerahJourneyPageState extends ConsumerState<KidsSeerahJourneyPage> {
  bool _synced = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(
      kidsSeerahJourneySummaryProvider(widget.journeyId),
    );
    if (summary == null) {
      return AppPageScaffold(
        title: l10n.kidsSeerahJourneysTitle,
        children: [
          PremiumCard(child: Text(l10n.kidsSeerahJourneyUnavailableSubtitle)),
        ],
      );
    }

    if (!_synced) {
      _synced = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(kidsSeerahJourneyProgressProvider.notifier)
            .openJourney(summary.journey.journeyId);
        ref
            .read(kidsSeerahJourneyProgressProvider.notifier)
            .syncJourney(summary.journey.journeyId);
      });
    }

    return AppPageScaffold(
      title: summary.journey.title,
      subtitle: summary.journey.description,
      floatingBottom: const BedtimeStoryMiniPlayer(),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsSeerahTimelineTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: summary.journey.timeline
                    .map((marker) => Chip(label: Text(marker.label)))
                    .toList(growable: false),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: summary.stages.isEmpty
                    ? 0
                    : summary.completedStageCount / summary.stages.length,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.kidsSeerahJourneyProgressLabel(
                  summary.completedStageCount,
                  summary.stages.length,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (summary.nextNodeId != null) ...[
          PremiumCard(
            child: Row(
              children: [
                const Icon(Icons.play_circle_fill_rounded),
                const SizedBox(width: 10),
                Expanded(child: Text(l10n.kidsSeerahContinueNodeSubtitle)),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () => context.pushNamed(
                    'kidsSeerahNode',
                    pathParameters: {
                      'journeyId': summary.journey.journeyId,
                      'nodeId': summary.nextNodeId!,
                    },
                  ),
                  child: Text(l10n.kidsSeerahContinueNodeAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...summary.stages.map(
          (stage) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _StageCard(
              journeyId: summary.journey.journeyId,
              stage: stage,
            ),
          ),
        ),
        if (summary.isCompleted)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsSeerahJourneyCompleteTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.kidsSeerahJourneyCompleteSubtitle),
              ],
            ),
          ),
      ],
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({required this.journeyId, required this.stage});

  final String journeyId;
  final KidsSeerahJourneyStageSummary stage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.stage.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(stage.stage.description),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(
                  stage.isCompleted
                      ? l10n.kidsSeerahStageCompletedBadge
                      : stage.isUnlocked
                      ? l10n.kidsSeerahStageInProgressBadge
                      : l10n.kidsSeerahStageLockedBadge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.kidsSeerahStageProgressLabel(
              stage.completedNodeCount,
              stage.nodes.length,
            ),
          ),
          const SizedBox(height: 12),
          ...stage.nodes.map(
            (node) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_nodeIcon(node.node.nodeType)),
                title: Text(node.node.title),
                subtitle: Text(node.node.description),
                trailing: node.isCompleted
                    ? const Icon(Icons.check_circle_rounded)
                    : const Icon(Icons.chevron_right_rounded),
                onTap: !stage.isUnlocked
                    ? null
                    : () => context.pushNamed(
                        'kidsSeerahNode',
                        pathParameters: {
                          'journeyId': journeyId,
                          'nodeId': node.node.nodeId,
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _nodeIcon(KidsSeerahJourneyNodeType type) {
    switch (type) {
      case KidsSeerahJourneyNodeType.storyEvent:
        return Icons.auto_stories_rounded;
      case KidsSeerahJourneyNodeType.companionStory:
        return Icons.people_alt_rounded;
      case KidsSeerahJourneyNodeType.reflection:
        return AppIcons.reflection;
      case KidsSeerahJourneyNodeType.quiz:
        return Icons.quiz_rounded;
      case KidsSeerahJourneyNodeType.milestone:
        return Icons.flag_rounded;
    }
  }
}
