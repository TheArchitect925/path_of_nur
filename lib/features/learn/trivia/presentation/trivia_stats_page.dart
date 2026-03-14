import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaStatsPage extends ConsumerWidget {
  const IslamicTriviaStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(triviaControllerProvider.notifier);
    final state = ref.watch(triviaControllerProvider);
    final repository = ref.read(triviaRepositoryProvider);
    final stats = state.stats;
    final strongest = controller.strongestCategoryId();
    final weakest = controller.weakestCategoryId();

    return LearnHubPageScaffold(
      headerIcon: Icons.bar_chart_rounded,
      title: 'Trivia Progress',
      subtitle: 'A clear view of what is improving, what is stable, and what needs another pass.',
      children: [
        Row(
          children: [
            TriviaStatTile(
              label: 'Questions answered',
              value: '${stats.totalQuestionsAnswered}',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Quizzes completed',
              value: '${stats.totalQuizzesCompleted}',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: 'Correct',
              value: '${stats.totalCorrect}',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Incorrect',
              value: '${stats.totalIncorrect}',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: 'Overall accuracy',
              value: '${(stats.overallAccuracy * 100).round()}%',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Daily quiz streak',
              value: '${stats.dailyQuizStreak}',
              caption: 'Longest ${stats.longestDailyQuizStreak}',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: 'Trivia XP',
              value: '${stats.totalTriviaXp}',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Ocean Drops',
              value: '${stats.totalTriviaOceanDrops}',
            ),
          ],
        ),
        const SizedBox(height: 14),
        TriviaEmptyStateCard(
          title: 'Performance snapshot',
          subtitle:
              'Strongest: ${strongest == null ? 'Not enough data yet' : repository.categoryById(strongest)?.title ?? strongest}\nWeakest: ${weakest == null ? 'Not enough data yet' : repository.categoryById(weakest)?.title ?? weakest}\nReview queue: ${controller.dueReviewCount} due • ${controller.masteredReviewCount} mastered',
        ),
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Category breakdown',
          subtitle: 'Accuracy and volume by category.',
        ),
        const SizedBox(height: 8),
        ...repository.categories.map((category) {
          final categoryStats = controller.statsForCategory(category.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TriviaEmptyStateCard(
              title: category.title,
              subtitle:
                  '${categoryStats.questionsAnswered} answered • ${(categoryStats.accuracy * 100).round()}% accuracy • ${categoryStats.quizzesCompleted} quizzes',
            ),
          );
        }),
      ],
    );
  }
}
