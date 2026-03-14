import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import '../domain/trivia_models.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaKnowledgePathDetailPage extends ConsumerWidget {
  const IslamicTriviaKnowledgePathDetailPage({
    super.key,
    required this.pathId,
  });

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(triviaControllerProvider.notifier);
    final path = controller.knowledgePathById(pathId);
    if (path == null) {
      return const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: TriviaEmptyStateCard(
              title: 'Knowledge path not found',
              subtitle: 'This guided path is unavailable right now.',
            ),
          ),
        ),
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
      title: path.title,
      subtitle: path.description,
      children: [
        TriviaEmptyStateCard(
          title: '$completed of ${path.stages.length} stages completed',
          subtitle:
              progress.pathCompletionRewardGranted
                  ? 'This path is complete. You can revisit any stage for review.'
                  : 'Each stage includes a short lesson and a focused quiz.',
          action: FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'learnTriviaKnowledgePathStage',
              pathParameters: {'pathId': path.id, 'stageId': nextStage.id},
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              activeSession?.knowledgePathId == path.id
                  ? 'Continue Stage'
                  : (progress.completedStageIds.isEmpty ? 'Start Path' : 'Continue Path'),
            ),
          ),
        ),
        const SizedBox(height: 14),
        LinearProgressIndicator(
          value: controller.pathCompletionRatio(path.id),
          minHeight: 8,
        ),
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Stages',
          subtitle: 'Move in order. Each completed stage opens the next one.',
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
              title: stage.title,
              subtitle: '${stage.questionIds.length} questions • +${stage.xpReward} XP',
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
