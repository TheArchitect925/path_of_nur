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

class IslamicTriviaReviewPage extends ConsumerWidget {
  const IslamicTriviaReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
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
      title: l10n.triviaReviewMistakesTitle,
      subtitle: l10n.triviaReviewMistakesSubtitle,
      children: [
        Row(
          children: [
            TriviaStatTile(
              label: l10n.triviaReviewDueNowLabel,
              value: numberFormat.format(dueItems.length),
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaReviewImprovingLabel,
              value: numberFormat.format(improved),
            ),
            const SizedBox(width: 10),
            TriviaStatTile(
              label: l10n.triviaReviewMasteredLabel,
              value: numberFormat.format(mastered),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (dueItems.isEmpty)
          TriviaEmptyStateCard(
            title: l10n.triviaReviewNoQuestionsDueTitle,
            subtitle: l10n.triviaReviewNoQuestionsDueSubtitle,
          )
        else
          TriviaEmptyStateCard(
            title: l10n.triviaReviewStartSessionTitle,
            subtitle: l10n.triviaReviewStartSessionSubtitle(
              numberFormat.format(dueItems.length),
            ),
            action: FilledButton.tonalIcon(
              onPressed: () {
                final started = controller.startSession(
                  mode: TriviaMode.reviewMistakes,
                );
                if (started) {
                  context.pushNamed('learnTriviaSession');
                }
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(l10n.triviaReviewStartAction),
            ),
          ),
        const SizedBox(height: 14),
        TriviaSectionHeader(
          title: l10n.triviaReviewPriorityItemsTitle,
          subtitle: l10n.triviaReviewPriorityItemsSubtitle,
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
                      '${category?.title ?? l10n.triviaUnknownCategory} • ${item.masteryState.localizedLabel(l10n)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.triviaReviewSeenCorrectIncorrect(
                        numberFormat.format(item.timesSeen),
                        numberFormat.format(item.timesCorrect),
                        numberFormat.format(item.timesIncorrect),
                      ),
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
