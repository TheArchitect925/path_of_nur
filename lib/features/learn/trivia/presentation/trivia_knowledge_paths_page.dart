import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaKnowledgePathsPage extends ConsumerWidget {
  const IslamicTriviaKnowledgePathsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(triviaControllerProvider.notifier);
    final paths = controller.knowledgePaths;

    return LearnHubPageScaffold(
      headerIcon: Icons.route_rounded,
      title: 'Knowledge Paths',
      subtitle:
          'Walk through guided trivia journeys with short learning cards and focused stage practice.',
      children: [
        if (paths.isEmpty)
          const TriviaEmptyStateCard(
            title: 'No paths yet',
            subtitle:
                'Knowledge Paths will appear here when guided journeys are available.',
          )
        else
          ...paths.map((path) {
            final progress = controller.pathProgress(path.id);
            final completed = progress.completedStageIds.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TriviaKnowledgePathCard(
                icon: path.icon,
                title: path.title,
                subtitle: path.description,
                progress: controller.pathCompletionRatio(path.id),
                progressLabel: '$completed/${path.stages.length} stages',
                onPressed: () => context.pushNamed(
                  'learnTriviaKnowledgePathDetail',
                  pathParameters: {'pathId': path.id},
                ),
              ),
            );
          }),
      ],
    );
  }
}
