import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../presentation/data/learn_icon_registry.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import '../domain/trivia_models.dart';
import 'trivia_ui_localization.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaHomePage extends ConsumerWidget {
  const IslamicTriviaHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    final state = ref.watch(triviaControllerProvider);
    final controller = ref.read(triviaControllerProvider.notifier);
    final repository = ref.read(triviaRepositoryProvider);
    final stats = state.stats;
    final dueReviews = controller.dueReviewItems();
    final dayKey = DateTime.now();
    final todayKey =
        '${dayKey.year}-${dayKey.month.toString().padLeft(2, '0')}-${dayKey.day.toString().padLeft(2, '0')}';
    final dailyCompletedToday =
        state.dailyQuizState?.dayKey == todayKey &&
        state.dailyQuizState?.completed == true;

    return LearnHubPageScaffold(
      headerIcon: Icons.quiz_rounded,
      title: l10n.learnCategoryIslamicTriviaTitle,
      subtitle: l10n.triviaHomeSubtitle,
      children: [
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaHomeCurrentStreakLabel,
              value: numberFormat.format(stats.currentStreak),
              caption: l10n.triviaHomeLongestStreakCaption(
                numberFormat.format(stats.longestStreak),
              ),
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaHomeAccuracyLabel,
              value: l10n.growthPercentValue(
                numberFormat.format((stats.overallAccuracy * 100).round()),
              ),
              caption: l10n.triviaHomeAnsweredCount(
                numberFormat.format(stats.totalQuestionsAnswered),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaHomeTriviaXpLabel,
              value: numberFormat.format(stats.totalTriviaXp),
              caption: l10n.triviaHomeQuizzesCompletedCount(
                numberFormat.format(stats.totalQuizzesCompleted),
              ),
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaHomeOceanDropsLabel,
              value: numberFormat.format(stats.totalTriviaOceanDrops),
              caption: l10n.triviaHomeBestSurvivalCaption(
                numberFormat.format(stats.bestSurvivalRun),
              ),
            ),
          ],
        ),
        if (state.activeSession != null) ...[
          const SizedBox(height: 14),
          TriviaSectionHeader(
            title: l10n.triviaHomeContinuePreviousSessionTitle,
            subtitle: l10n.triviaHomeContinuePreviousSessionSubtitle,
          ),
          const SizedBox(height: 8),
          TriviaEmptyStateCard(
            title: state.activeSession!.mode.localizedLabel(l10n),
            subtitle: l10n.triviaHomeAnsweredProgress(
              numberFormat.format(state.activeSession!.answeredCount),
              numberFormat.format(state.activeSession!.questionIds.length),
            ),
            action: FilledButton.tonalIcon(
              onPressed: () => context.pushNamed('learnTriviaSession'),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(l10n.learnHubResumeAction),
            ),
          ),
        ],
        const SizedBox(height: 14),
        TriviaSectionHeader(
          title: l10n.triviaHomeTodayTitle,
          subtitle: l10n.triviaHomeTodaySubtitle,
        ),
        const SizedBox(height: 8),
        TriviaModeCard(
          mode: TriviaMode.dailyQuiz,
          trailingLabel: dailyCompletedToday
              ? l10n.triviaCompletedTodayLabel
              : l10n.triviaAvailableLabel,
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
          trailingLabel: dueReviews.isEmpty
              ? l10n.triviaNoDueItemsLabel
              : l10n.triviaDueCount(numberFormat.format(dueReviews.length)),
          onPressed: dueReviews.isEmpty
              ? () => context.pushNamed('learnTriviaReview')
              : () {
                  final started = controller.startSession(
                    mode: TriviaMode.reviewMistakes,
                  );
                  if (started) {
                    context.pushNamed('learnTriviaSession');
                  }
                },
        ),
        const SizedBox(height: 14),
        TriviaSectionHeader(
          title: l10n.triviaHomeKnowledgePathsTitle,
          subtitle: l10n.triviaHomeKnowledgePathsSubtitle,
        ),
        const SizedBox(height: 8),
        TriviaEmptyStateCard(
          title: l10n.triviaHomeStructuredLearningTitle,
          subtitle: l10n.triviaHomeStructuredLearningSubtitle,
          action: FilledButton.tonalIcon(
            onPressed: () => context.pushNamed('learnTriviaKnowledgePaths'),
            icon: const Icon(Icons.route_rounded),
            label: Text(l10n.triviaHomeOpenKnowledgePathsAction),
          ),
        ),
        const SizedBox(height: 14),
        TriviaSectionHeader(
          title: l10n.triviaHomeCoreModesTitle,
          subtitle: l10n.triviaHomeCoreModesSubtitle,
        ),
        const SizedBox(height: 8),
        TriviaModeCard(
          mode: TriviaMode.quickChallenge,
          onPressed: () {
            final started = controller.startSession(
              mode: TriviaMode.quickChallenge,
            );
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
        TriviaSectionHeader(
          title: l10n.triviaHomeCategoriesTitle,
          subtitle: l10n.triviaHomeCategoriesSubtitle,
        ),
        const SizedBox(height: 8),
        ...repository.categories.map((category) {
          final count = repository.questionCountForCategory(category.id);
          final categoryStats = controller.statsForCategory(category.id);
          final accuracyLabel = categoryStats.questionsAnswered == 0
              ? l10n.triviaHomeNoAnswersYet
              : l10n.triviaHomeCategoryAccuracy(
                  numberFormat.format((categoryStats.accuracy * 100).round()),
                  numberFormat.format((categoryStats.accuracy * 100).round()),
                  category.title,
                );
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
                label: Text(l10n.triviaHomeReviewQueueAction),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.pushNamed('learnTriviaStats'),
                icon: const Icon(Icons.bar_chart_rounded),
                label: Text(l10n.triviaHomeProgressStatsAction),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TriviaSectionHeader(
          title: l10n.triviaHomeRecentPerformanceTitle,
          subtitle: l10n.triviaHomeRecentPerformanceSubtitle,
        ),
        const SizedBox(height: 8),
        if (stats.recentResults.isEmpty)
          TriviaEmptyStateCard(
            title: l10n.triviaHomeNoSessionsYetTitle,
            subtitle: l10n.triviaHomeNoSessionsYetSubtitle,
          )
        else
          ...stats.recentResults.take(4).map((result) {
            final categoryTitle = result.categoryId == null
                ? l10n.triviaMixedLabel
                : repository.categoryById(result.categoryId!)?.title ??
                      l10n.triviaMixedLabel;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TriviaEmptyStateCard(
                title:
                    '${result.mode.localizedLabel(l10n)} • ${l10n.growthPercentValue(numberFormat.format((result.accuracy * 100).round()))}',
                subtitle: l10n.triviaHomeRecentPerformanceSummaryQuiet(
                  categoryTitle,
                  numberFormat.format(result.correctCount),
                  numberFormat.format(result.totalAnswered),
                ),
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
