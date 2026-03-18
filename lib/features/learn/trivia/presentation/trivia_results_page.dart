import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import '../domain/trivia_models.dart';
import 'trivia_ui_localization.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaResultsPage extends ConsumerWidget {
  const IslamicTriviaResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
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
              subtitle:
                  'Complete a trivia session and the result will appear here.',
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
        ? l10n.triviaMixedLabel
        : repository.categoryById(result.categoryId!)?.title ??
              l10n.triviaMixedLabel;
    final resultTitle =
        result.knowledgeStageTitle ?? result.mode.localizedLabel(l10n);

    return LearnHubPageScaffold(
      headerIcon: Icons.emoji_events_rounded,
      title: l10n.triviaResultsTitle,
      subtitle: l10n.triviaResultsSubtitle,
      children: [
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaResultsScoreLabel,
              value:
                  '${numberFormat.format(result.correctCount)}/${numberFormat.format(result.totalAnswered)}',
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaHomeAccuracyLabel,
              value: l10n.growthPercentValue(
                numberFormat.format((result.accuracy * 100).round()),
              ),
              caption: categoryTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaResultsXpGainedLabel,
              value: '+${numberFormat.format(result.xpEarned)}',
              caption: result.wasPerfect
                  ? l10n.triviaResultsPerfectBonusIncluded
                  : null,
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaHomeOceanDropsLabel,
              value: '+${numberFormat.format(result.oceanDropsEarned)}',
              caption: result.wasDailyReplay
                  ? l10n.triviaResultsReplayRewardsLighter
                  : null,
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
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.triviaResultsCompletedSummary(
                  numberFormat.format(result.durationSeconds),
                  numberFormat.format(result.incorrectCount),
                  numberFormat.format(result.totalAnswered),
                  numberFormat.format(result.correctCount),
                  numberFormat.format(result.totalAnswered),
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              if (result.mode == TriviaMode.survival) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.triviaResultsBestRunInSession(
                    numberFormat.format(result.survivalRun),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child:
                  result.knowledgePathId != null &&
                      result.knowledgeStageId != null
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
                      label: Text(l10n.triviaResultsRetryStageAction),
                    )
                  : FilledButton.tonalIcon(
                      onPressed: () {
                        final started = controller.retryLastSession();
                        if (started) {
                          context.goNamed('learnTriviaSession');
                        }
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.triviaResultsRetryAction),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('learnTriviaReview'),
                icon: const Icon(Icons.replay_circle_filled_rounded),
                label: Text(l10n.triviaReviewMistakesAction),
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
                  result.knowledgePathId != null
                      ? l10n.triviaResultsBackToPathAction
                      : l10n.triviaResultsGoHomeAction,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pushNamed('learnTriviaStats'),
                child: Text(l10n.triviaHomeProgressStatsAction),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TriviaSectionHeader(
          title: l10n.triviaResultsMissedQuestionsTitle,
          subtitle: l10n.triviaResultsMissedQuestionsSubtitle,
        ),
        const SizedBox(height: 8),
        if (missedQuestions.isEmpty)
          TriviaEmptyStateCard(
            title: l10n.triviaResultsNoMissedQuestionsTitle,
            subtitle: l10n.triviaResultsNoMissedQuestionsSubtitle,
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
