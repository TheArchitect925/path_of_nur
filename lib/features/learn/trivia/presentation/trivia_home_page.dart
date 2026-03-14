import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/data/learn_icon_registry.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import '../domain/trivia_models.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaHomePage extends ConsumerWidget {
  const IslamicTriviaHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(triviaControllerProvider);
    final controller = ref.read(triviaControllerProvider.notifier);
    final repository = ref.read(triviaRepositoryProvider);
    final stats = state.stats;
    final dueReviews = controller.dueReviewItems();
    final dayKey = DateTime.now();
    final todayKey = '${dayKey.year}-${dayKey.month.toString().padLeft(2, '0')}-${dayKey.day.toString().padLeft(2, '0')}';
    final dailyCompletedToday =
        state.dailyQuizState?.dayKey == todayKey &&
        state.dailyQuizState?.completed == true;

    return LearnHubPageScaffold(
      headerIcon: Icons.quiz_rounded,
      title: 'Islamic Trivia',
      subtitle:
          'A calm knowledge space for short quizzes, daily review, and gentle reinforcement.',
      children: [
        Row(
          children: [
            TriviaStatTile(
              label: 'Current streak',
              value: '${stats.currentStreak}',
              caption: 'Longest ${stats.longestStreak}',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Accuracy',
              value: '${(stats.overallAccuracy * 100).round()}%',
              caption: '${stats.totalQuestionsAnswered} answered',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: 'Trivia XP',
              value: '${stats.totalTriviaXp}',
              caption: '${stats.totalQuizzesCompleted} quizzes completed',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: 'Ocean Drops',
              value: '${stats.totalTriviaOceanDrops}',
              caption: 'Best survival ${stats.bestSurvivalRun}',
            ),
          ],
        ),
        if (state.activeSession != null) ...[
          const SizedBox(height: 14),
          const TriviaSectionHeader(
            title: 'Continue previous session',
            subtitle: 'Your unfinished run is still waiting.',
          ),
          const SizedBox(height: 8),
          TriviaEmptyStateCard(
            title: state.activeSession!.mode.label,
            subtitle:
                '${state.activeSession!.answeredCount} of ${state.activeSession!.questionIds.length} answered.',
            action: FilledButton.tonalIcon(
              onPressed: () => context.pushNamed('learnTriviaSession'),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Resume'),
            ),
          ),
        ],
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Today',
          subtitle: 'Start with a short daily run or revisit what needs another pass.',
        ),
        const SizedBox(height: 8),
        TriviaModeCard(
          mode: TriviaMode.dailyQuiz,
          trailingLabel: dailyCompletedToday ? 'Completed today' : 'Available',
          onPressed: () {
            final started = controller.startSession(mode: TriviaMode.dailyQuiz);
            if (started) {
              context.pushNamed('learnTriviaSession');
            }
          },
        ),
        const SizedBox(height: 10),
        TriviaModeCard(
          mode: TriviaMode.reviewMistakes,
          trailingLabel: dueReviews.isEmpty ? 'No due items' : '${dueReviews.length} due',
          onPressed: dueReviews.isEmpty
              ? () => context.pushNamed('learnTriviaReview')
              : () {
                  final started =
                      controller.startSession(mode: TriviaMode.reviewMistakes);
                  if (started) {
                    context.pushNamed('learnTriviaSession');
                  }
                },
        ),
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Knowledge Paths',
          subtitle: 'Follow a guided journey with short lessons and focused stage quizzes.',
        ),
        const SizedBox(height: 8),
        TriviaEmptyStateCard(
          title: 'Structured learning',
          subtitle:
              'Move through calm, topic-based journeys one stage at a time.',
          action: FilledButton.tonalIcon(
            onPressed: () => context.pushNamed('learnTriviaKnowledgePaths'),
            icon: const Icon(Icons.route_rounded),
            label: const Text('Open Knowledge Paths'),
          ),
        ),
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Core modes',
          subtitle: 'Choose a short mixed run or stay with a topic longer.',
        ),
        const SizedBox(height: 8),
        TriviaModeCard(
          mode: TriviaMode.quickChallenge,
          onPressed: () {
            final started = controller.startSession(mode: TriviaMode.quickChallenge);
            if (started) {
              context.pushNamed('learnTriviaSession');
            }
          },
        ),
        const SizedBox(height: 10),
        TriviaModeCard(
          mode: TriviaMode.deepDive,
          onPressed: () {
            final started = controller.startSession(mode: TriviaMode.deepDive);
            if (started) {
              context.pushNamed('learnTriviaSession');
            }
          },
        ),
        const SizedBox(height: 10),
        TriviaModeCard(
          mode: TriviaMode.survival,
          onPressed: () {
            final started = controller.startSession(mode: TriviaMode.survival);
            if (started) {
              context.pushNamed('learnTriviaSession');
            }
          },
        ),
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Categories',
          subtitle: 'Start with a focused category or browse where you are strongest.',
        ),
        const SizedBox(height: 8),
        ...repository.categories.map((category) {
          final count = repository.questionCountForCategory(category.id);
          final categoryStats = controller.statsForCategory(category.id);
          final accuracyLabel = categoryStats.questionsAnswered == 0
              ? 'No answers yet'
              : 'Accuracy ${(categoryStats.accuracy * 100).round()}%';
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TriviaCategoryCard(
              icon: _iconForCategory(category.iconKey),
              title: category.title,
              subtitle: category.subtitle,
              questionCount: count,
              accuracyLabel: accuracyLabel,
              onQuickStart: count == 0
                  ? null
                  : () {
                      final started = controller.startSession(
                        mode: TriviaMode.quickChallenge,
                        categoryId: category.id,
                      );
                      if (started) {
                        context.pushNamed('learnTriviaSession');
                      }
                    },
            ),
          );
        }),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.pushNamed('learnTriviaReview'),
                icon: const Icon(Icons.replay_circle_filled_rounded),
                label: const Text('Review Queue'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.pushNamed('learnTriviaStats'),
                icon: const Icon(Icons.bar_chart_rounded),
                label: const Text('Progress & Stats'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const TriviaSectionHeader(
          title: 'Recent performance',
          subtitle: 'A quiet look at your most recent sessions.',
        ),
        const SizedBox(height: 8),
        if (stats.recentResults.isEmpty)
          const TriviaEmptyStateCard(
            title: 'No sessions yet',
            subtitle:
                'Start a short quiz and your recent progress will appear here.',
          )
        else
          ...stats.recentResults.take(4).map((result) {
            final categoryTitle = result.categoryId == null
                ? 'Mixed'
                : repository.categoryById(result.categoryId!)?.title ?? 'Mixed';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TriviaEmptyStateCard(
                title:
                    '${result.mode.label} • ${(result.accuracy * 100).round()}%',
                subtitle:
                    '$categoryTitle • ${result.correctCount}/${result.totalAnswered} correct • +${result.xpEarned} XP',
              ),
            );
          }),
      ],
    );
  }

  IconData _iconForCategory(String iconKey) {
    switch (iconKey) {
      case 'history':
        return Icons.history_edu_rounded;
      case 'general':
        return Icons.lightbulb_outline_rounded;
      case 'ramadan':
        return Icons.nightlight_round_rounded;
      case 'dua':
        return Icons.volunteer_activism_rounded;
      case 'seerah':
        return Icons.route_rounded;
      default:
        return LearnIconRegistry.iconFor(iconKey);
    }
  }
}
