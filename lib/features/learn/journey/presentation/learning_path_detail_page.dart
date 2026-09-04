import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/art_header_card.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/expandable_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../guided_paths/application/guided_learning_paths_provider.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../shared/learn_art_assets.dart';
import '../application/learning_path_provider.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_path_registry.dart';
import '../data/learning_journey_localized_metadata.dart';
import '../domain/learning_journey_models.dart';
import '../domain/learning_path_models.dart';

/// The one spine: the leveled learning path with its phases laid out top to
/// bottom. Completed phases collapse, the current phase opens with its
/// journeys, guided-path steps, and the end-of-phase "test yourself".
class LearningPathDetailPage extends ConsumerWidget {
  const LearningPathDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pathState = ref.watch(learningPathStateProvider);

    if (pathState == null) {
      return LearnHubPageScaffold(
        headerIcon: Icons.route_rounded,
        title: l10n.learnPathDetailTitle,
        subtitle: l10n.learnLandingChoosePathSubtitle,
        children: [
          ArtHeaderCard(
            imageAsset: levelArtAsset(LearningPathLevel.beginner),
            eyebrow: l10n.learnLandingPathEyebrow,
            title: l10n.learnLandingChoosePathTitle,
            subtitle: l10n.learnLandingChoosePathSubtitle,
            fallbackIcon: Icons.flag_rounded,
            fallbackColor: Theme.of(context).colorScheme.primary,
            aspectRatio: 16 / 9,
            onTap: () => context.pushNamed('learnLearningPath'),
          ),
        ],
      );
    }

    final path = pathState.path;
    return LearnHubPageScaffold(
      headerIcon: Icons.route_rounded,
      title: l10n.learnPathDetailTitle,
      subtitle: LearningPathRegistry.localizedPathDescription(l10n, path),
      children: [
        ArtHeaderCard(
          imageAsset: levelArtAsset(path.level),
          eyebrow: l10n.learnLandingPathEyebrow,
          title: LearningPathRegistry.localizedPathTitle(l10n, path),
          subtitle: l10n.learnLandingPhaseOfLabel(
            pathState.phaseIndex + 1,
            path.phases.length,
          ),
          fallbackIcon: Icons.route_rounded,
          fallbackColor: Theme.of(context).colorScheme.primary,
          aspectRatio: 16 / 9,
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(
            onPressed: () => context.pushNamed('learnLearningPath'),
            icon: const Icon(Icons.swap_horiz_rounded, size: 18),
            label: Text(l10n.learnPathDetailChangeLevelAction),
          ),
        ),
        for (final phase in path.phases) ...[
          _PhaseTile(
            phase: phase,
            isCurrent: phase.id == pathState.currentPhase.id,
            isCompleted: pathState.completedPhaseIds.contains(phase.id),
            completedJourneyIds: pathState.completedJourneyIds,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PhaseTile extends ConsumerWidget {
  const _PhaseTile({
    required this.phase,
    required this.isCurrent,
    required this.isCompleted,
    required this.completedJourneyIds,
  });

  final LearningPathPhase phase;
  final bool isCurrent;
  final bool isCompleted;
  final Set<String> completedJourneyIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final journeys = phase.journeyIds
        .map(LearningJourneyRegistry.journeyById)
        .whereType<LearningJourney>()
        .toList(growable: false);
    final doneCount = journeys
        .where((journey) => completedJourneyIds.contains(journey.id))
        .length;

    return ExpandableTile(
      leading: Icon(
        isCompleted
            ? Icons.check_circle_rounded
            : isCurrent
            ? Icons.play_circle_outline_rounded
            : Icons.circle_outlined,
        color: isCompleted || isCurrent
            ? accent
            : Theme.of(context).colorScheme.outline,
      ),
      title: Text(
        LearningPathRegistry.localizedPhaseTitle(l10n, phase),
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        isCompleted
            ? l10n.learnPathPhaseCompletedLabel
            : LearningPathRegistry.localizedPhaseDescription(l10n, phase),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      initiallyExpanded: isCurrent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (journeys.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                l10n.learnLandingPhaseOfLabel(doneCount, journeys.length),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          for (final journey in journeys)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: CompactListTile(
                leading: Icon(
                  completedJourneyIds.contains(journey.id)
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 20,
                  color: completedJourneyIds.contains(journey.id)
                      ? accent
                      : Theme.of(context).colorScheme.outline,
                ),
                title: localizedJourneyTitle(context, journey),
                subtitle: localizedJourneySubtitle(context, journey),
                onTap: () => context.pushNamed(
                  'learnJourneyDetail',
                  pathParameters: {'journeyId': journey.id},
                ),
              ),
            ),
          for (final guidedPathId in phase.guidedPathIds)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _GuidedPathRow(pathId: guidedPathId),
            ),
          if (phase.triviaPathId != null)
            CompactListTile(
              leading: const HubLeadingIcon(Icons.quiz_rounded),
              title: l10n.learnPathTestYourselfTitle,
              subtitle: l10n.learnPathTestYourselfSubtitle,
              onTap: () => context.pushNamed(
                'learnTriviaKnowledgePathDetail',
                pathParameters: {'pathId': phase.triviaPathId!},
              ),
            ),
        ],
      ),
    );
  }
}

class _GuidedPathRow extends ConsumerWidget {
  const _GuidedPathRow({required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final paths = ref.watch(guidedLearningPathsProvider);
    final path = paths.where((item) => item.id == pathId).firstOrNull;
    if (path == null) return const SizedBox.shrink();
    final progress = ref.watch(
      guidedLearningPathsControllerProvider.select(
        (state) => state.progressByPathId[pathId],
      ),
    );
    final completed = progress?.completedStepIds.length ?? 0;
    final artAsset = guidedPathArtAsset(pathId);
    return CompactListTile(
      leading: artAsset == null
          ? const HubLeadingIcon(Icons.flag_rounded)
          : ArtLeadingThumb(
              imageAsset: artAsset,
              fallbackIcon: Icons.flag_rounded,
              fallbackColor: Theme.of(context).colorScheme.primary,
              size: 44,
            ),
      title: localizedGuidedLearningPathTitle(l10n, pathId),
      subtitle: l10n.guidedLearningPathProgressValue(
        completed,
        path.steps.length,
      ),
      onTap: () => context.pushNamed(
        'learnGuidedPathDetail',
        pathParameters: {'pathId': pathId},
      ),
    );
  }
}
