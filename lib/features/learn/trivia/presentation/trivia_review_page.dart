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

class IslamicTriviaReviewPage extends ConsumerWidget {
  const IslamicTriviaReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(triviaControllerProvider.notifier);
    final state = ref.watch(triviaControllerProvider);
    final repository = ref.read(triviaRepositoryProvider);
    final dueItems = controller.dueReviewItems();
    final mastered = state.reviewItems.values
        .where((item) => item.isMastered)
        .length;
    final improved = state.reviewItems.values
        .where(
          (item) =>
              item.masteryState == TriviaReviewMasteryState.improving ||
              item.masteryState == TriviaReviewMasteryState.mastered,
        )
        .length;

    return LearnHubPageScaffold(
      headerIcon: Icons.replay_circle_filled_rounded,
      title: 'Review Mistakes',
      subtitle:
          'Questions you missed return here gently until they become steadier.',
      children: [
        Row(
          children: [
            TriviaStatTile(
              label: 'Due now',
              value: '${dueItems.length}',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Improving',
              value: '$improved',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Mastered',
              value: '$mastered',
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (dueItems.isEmpty)
          const TriviaEmptyStateCard(
            title: 'No review questions due',
            subtitle:
                'Keep practicing. Questions you miss will appear here for another pass.',
          )
        else
          TriviaEmptyStateCard(
            title: 'Start a review session',
            subtitle:
                '${dueItems.length} items are ready. The queue favors what was recently missed or still unstable.',
            action: FilledButton.tonalIcon(
              onPressed: () {
                final started =
                    controller.startSession(mode: TriviaMode.reviewMistakes);
                if (started) {
                  context.pushNamed('learnTriviaSession');
                }
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Review'),
            ),
          ),
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Priority items',
          subtitle: 'These questions are due sooner because they were missed more often.',
        ),
        const SizedBox(height: 8),
        if (dueItems.isEmpty)
          const SizedBox.shrink()
        else
          ...dueItems.take(8).map((item) {
            final question = repository.questionById(item.questionId);
            final category = repository.categoryById(item.categoryId);
            if (question == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.prompt,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${category?.title ?? 'Unknown'} • ${item.masteryState.label}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seen ${item.timesSeen} • Correct ${item.timesCorrect} • Incorrect ${item.timesIncorrect}',
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
