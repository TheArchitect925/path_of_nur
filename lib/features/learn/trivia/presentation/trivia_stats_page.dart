import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import 'trivia_metadata_localization.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaStatsPage extends ConsumerWidget {
  const IslamicTriviaStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    final controller = ref.read(triviaControllerProvider.notifier);
    final state = ref.watch(triviaControllerProvider);
    final repository = ref.read(triviaRepositoryProvider);
    final stats = state.stats;
    final strongest = controller.strongestCategoryId();
    final weakest = controller.weakestCategoryId();

    return LearnHubPageScaffold(
      title: l10n.triviaStatsTitle,
      subtitle: l10n.triviaStatsSubtitle,
      children: [
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaStatsQuestionsAnswered,
              value: numberFormat.format(stats.totalQuestionsAnswered),
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaStatsQuizzesCompleted,
              value: numberFormat.format(stats.totalQuizzesCompleted),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaStatsCorrect,
              value: numberFormat.format(stats.totalCorrect),
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaStatsIncorrect,
              value: numberFormat.format(stats.totalIncorrect),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaStatsOverallAccuracy,
              value: l10n.growthPercentValue(
                numberFormat.format((stats.overallAccuracy * 100).round()),
              ),
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaStatsDailyQuizStreak,
              value: numberFormat.format(stats.dailyQuizStreak),
              caption: l10n.triviaStatsLongestStreak(
                numberFormat.format(stats.longestDailyQuizStreak),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaStatsXp,
              value: numberFormat.format(stats.totalTriviaXp),
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaStatsOceanDrops,
              value: numberFormat.format(stats.totalTriviaOceanDrops),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TriviaEmptyStateCard(
          title: l10n.triviaStatsPerformanceSnapshotTitle,
          subtitle: l10n.triviaStatsPerformanceSnapshotBody(
            strongest == null || repository.categoryById(strongest) == null
                ? l10n.triviaStatsNotEnoughData
                : localizedTriviaCategoryTitle(
                    l10n,
                    repository.categoryById(strongest)!,
                  ),
            weakest == null || repository.categoryById(weakest) == null
                ? l10n.triviaStatsNotEnoughData
                : localizedTriviaCategoryTitle(
                    l10n,
                    repository.categoryById(weakest)!,
                  ),
            numberFormat.format(controller.dueReviewCount),
            numberFormat.format(controller.masteredReviewCount),
          ),
        ),
        const SizedBox(height: 14),
        TriviaSectionHeader(
          title: l10n.triviaStatsCategoryBreakdownTitle,
          subtitle: l10n.triviaStatsCategoryBreakdownSubtitle,
        ),
        const SizedBox(height: 8),
        ...repository.categories.map((category) {
          final categoryStats = controller.statsForCategory(category.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TriviaEmptyStateCard(
              title: localizedTriviaCategoryTitle(l10n, category),
              subtitle: l10n.triviaStatsCategoryBreakdownRow(
                numberFormat.format(categoryStats.questionsAnswered),
                numberFormat.format((categoryStats.accuracy * 100).round()),
                numberFormat.format(categoryStats.quizzesCompleted),
              ),
            ),
          );
        }),
      ],
    );
  }
}
