import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import '../domain/trivia_models.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaResultsPage extends ConsumerWidget {
  const IslamicTriviaResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(triviaControllerProvider);
    final controller = ref.read(triviaControllerProvider.notifier);
    final repository = ref.read(triviaRepositoryProvider);
    final result = state.lastResult;
    if (result == null) {
      return const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: TriviaEmptyStateCard(
              title: 'No recent result',
              subtitle: 'Complete a trivia session and the result will appear here.',
            ),
          ),
        ),
      );
    }

    final missedQuestions = result.incorrectQuestionIds
        .map(repository.questionById)
        .whereType<TriviaQuestion>()
        .toList(growable: false);
    final categoryTitle = result.categoryId == null
        ? 'Mixed'
        : repository.categoryById(result.categoryId!)?.title ?? 'Mixed';
    final resultTitle = result.knowledgeStageTitle ?? result.mode.label;

    return LearnHubPageScaffold(
      headerIcon: Icons.emoji_events_rounded,
      title: 'Session Results',
      subtitle: 'Review what went well and what should return in your next review.',
      children: [
        Row(
          children: [
            TriviaStatTile(
              label: 'Score',
              value: '${result.correctCount}/${result.totalAnswered}',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Accuracy',
              value: '${(result.accuracy * 100).round()}%',
              caption: categoryTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: 'XP gained',
              value: '+${result.xpEarned}',
              caption: result.wasPerfect ? 'Perfect score bonus included' : null,
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Ocean Drops',
              value: '+${result.oceanDropsEarned}',
              caption: result.wasDailyReplay ? 'Replay rewards are lighter' : null,
            ),
          ],
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resultTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Completed in ${result.durationSeconds}s • ${result.incorrectCount} missed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              if (result.mode == TriviaMode.survival) ...[
                const SizedBox(height: 8),
                Text('Best run in this session: ${result.survivalRun}'),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: result.knowledgePathId != null && result.knowledgeStageId != null
                  ? FilledButton.tonalIcon(
                      onPressed: () {
                        final started = controller.startKnowledgePathStage(
                          pathId: result.knowledgePathId!,
                          stageId: result.knowledgeStageId!,
                        );
                        if (started) {
                          context.goNamed('learnTriviaSession');
                        }
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry Stage'),
                    )
                  : FilledButton.tonalIcon(
                      onPressed: () {
                        final started = controller.retryLastSession();
                        if (started) {
                          context.goNamed('learnTriviaSession');
                        }
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('learnTriviaReview'),
                icon: const Icon(Icons.replay_circle_filled_rounded),
                label: const Text('Review Mistakes'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: result.knowledgePathId != null
                    ? () => context.goNamed(
                        'learnTriviaKnowledgePathDetail',
                        pathParameters: {'pathId': result.knowledgePathId!},
                      )
                    : () => context.goNamed('learnIslamicTrivia'),
                child: Text(
                  result.knowledgePathId != null ? 'Back to Path' : 'Go Home',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pushNamed('learnTriviaStats'),
                child: const Text('Progress & Stats'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Missed questions',
          subtitle: 'These will also feed your review queue for reinforcement.',
        ),
        const SizedBox(height: 8),
        if (missedQuestions.isEmpty)
          const TriviaEmptyStateCard(
            title: 'No missed questions',
            subtitle: 'This session stayed clean. Your review queue is lighter now.',
          )
        else
          ...missedQuestions.map((question) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TriviaEmptyStateCard(
                title: question.prompt,
                subtitle: question.explanation,
              ),
            );
          }),
      ],
    );
  }
}
