import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import '../domain/trivia_models.dart';
import 'trivia_metadata_localization.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaKnowledgePathDetailPage extends ConsumerWidget {
  const IslamicTriviaKnowledgePathDetailPage({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    final controller = ref.read(triviaControllerProvider.notifier);
    final path = controller.knowledgePathById(pathId);
    if (path == null) {
      return LearnHubPageScaffold(
        headerIcon: Icons.route_rounded,
        title: l10n.triviaKnowledgePathNotFoundTitle,
        subtitle: l10n.triviaKnowledgePathNotFoundSubtitle,
        children: [
          TriviaEmptyStateCard(
            title: l10n.triviaKnowledgePathsEmptyTitle,
            subtitle: l10n.triviaKnowledgePathsEmptySubtitle,
            action: FilledButton.tonalIcon(
              onPressed: () => context.goNamed('learnQuizzesHub'),
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(l10n.triviaResultsGoHomeAction),
            ),
          ),
        ],
      );
    }
    final progress = controller.pathProgress(path.id);
    final completed = progress.completedStageIds.length;
    final activeSession = ref.watch(triviaControllerProvider).activeSession;
    final continueStageId = activeSession?.knowledgePathId == path.id
        ? activeSession?.knowledgeStageId
        : progress.currentStageId;
    final nextStage = continueStageId == null
        ? path.stages.firstWhere(
            (stage) => !progress.completedStageIds.contains(stage.id),
            orElse: () => path.stages.first,
          )
        : path.stages.firstWhere(
            (stage) => stage.id == continueStageId,
            orElse: () => path.stages.first,
          );

    return LearnHubPageScaffold(
      headerIcon: path.icon,
      title: localizedTriviaKnowledgePathTitle(l10n, path),
      subtitle: localizedTriviaKnowledgePathDescription(l10n, path),
      children: [
        TriviaEmptyStateCard(
          title: l10n.triviaKnowledgePathStagesCompleted(
            numberFormat.format(completed),
            numberFormat.format(path.stages.length),
          ),
          subtitle: progress.pathCompletionRewardGranted
              ? l10n.triviaKnowledgePathCompleteSubtitle
              : l10n.triviaKnowledgePathIncompleteSubtitle,
          action: FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'learnTriviaKnowledgePathStage',
              pathParameters: {'pathId': path.id, 'stageId': nextStage.id},
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              activeSession?.knowledgePathId == path.id
                  ? l10n.triviaContinueStageAction
                  : (progress.completedStageIds.isEmpty
                        ? l10n.triviaStartPathAction
                        : l10n.triviaContinuePathAction),
            ),
          ),
        ),
        const SizedBox(height: 14),
        LinearProgressIndicator(
          value: controller.pathCompletionRatio(path.id),
          minHeight: 8,
        ),
        const SizedBox(height: 14),
        TriviaSectionHeader(
          title: l10n.triviaStagesTitle,
          subtitle: l10n.triviaStagesSubtitle,
        ),
        const SizedBox(height: 8),
        ...path.stages.asMap().entries.map((entry) {
          final index = entry.key;
          final stage = entry.value;
          final stageState = controller.stageState(path, stage);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TriviaKnowledgeStageTile(
              index: index,
              title: localizedTriviaKnowledgeStageTitle(l10n, path, stage),
              subtitle: l10n.triviaKnowledgeStageSummary(
                numberFormat.format(stage.questionIds.length),
                numberFormat.format(stage.xpReward),
              ),
              state: stageState,
              difficulty: stage.difficulty,
              onPressed: stageState == TriviaKnowledgeStageState.locked
                  ? null
                  : () => context.pushNamed(
                      'learnTriviaKnowledgePathStage',
                      pathParameters: {'pathId': path.id, 'stageId': stage.id},
                    ),
            ),
          );
        }),
      ],
    );
  }
}
