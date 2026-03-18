import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import 'trivia_metadata_localization.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaKnowledgePathsPage extends ConsumerWidget {
  const IslamicTriviaKnowledgePathsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(triviaControllerProvider.notifier);
    final paths = controller.knowledgePaths;

    return LearnHubPageScaffold(
      headerIcon: Icons.route_rounded,
      title: l10n.triviaKnowledgePathsPageTitle,
      subtitle: l10n.triviaKnowledgePathsPageSubtitle,
      children: [
        if (paths.isEmpty)
          TriviaEmptyStateCard(
            title: l10n.triviaKnowledgePathsEmptyTitle,
            subtitle: l10n.triviaKnowledgePathsEmptySubtitle,
          )
        else
          ...paths.map((path) {
            final progress = controller.pathProgress(path.id);
            final completed = progress.completedStageIds.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TriviaKnowledgePathCard(
                icon: path.icon,
                title: localizedTriviaKnowledgePathTitle(l10n, path),
                subtitle: localizedTriviaKnowledgePathDescription(l10n, path),
                progress: controller.pathCompletionRatio(path.id),
                progressLabel: l10n.triviaKnowledgePathsProgressLabel(
                  '$completed',
                  '${path.stages.length}',
                ),
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
