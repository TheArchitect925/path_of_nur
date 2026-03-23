import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/wudu_quiz_controller.dart';
import '../models/wudu_models.dart';

class WuduQuizPage extends StatelessWidget {
  const WuduQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ProviderScope(
      overrides: [wuduQuizLocalizationsProvider.overrideWithValue(l10n)],
      child: const _WuduQuizView(),
    );
  }
}

class _WuduQuizView extends ConsumerWidget {
  const _WuduQuizView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final content = ref.watch(wuduQuizContentProvider);
    final state = ref.watch(wuduQuizControllerProvider);

    return LearnHubPageScaffold(
      headerIcon: IslamicIcons.wudhu,
      title: content.title,
      subtitle: content.subtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.introTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                content.introSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (state.hasPartialProgress && !state.finished) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.wuduQuizResume,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (state.finished)
          _QuizSummaryCard(content: content)
        else
          const _QuestionCard(),
      ],
    );
  }
}

class _QuestionCard extends ConsumerWidget {
  const _QuestionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final content = ref.watch(wuduQuizContentProvider);
    final state = ref.watch(wuduQuizControllerProvider);
    final controller = ref.read(wuduQuizControllerProvider.notifier);
    final question = controller.currentQuestion();
    final questionNumber = state.currentQuestionIndex + 1;
    final selectedOptionId = state.selectedAnswerFor(question.id);
    final submitted = state.isSubmitted(question.id);
    final isCorrect = submitted ? controller.currentAnswerIsCorrect() : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.wuduQuizQuestionProgress(
                      questionNumber,
                      content.questions.length,
                    ),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _typeLabel(context, question.type),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: questionNumber / content.questions.length,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                question.questionText,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...question.options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: submitted
                    ? null
                    : () => controller.selectAnswer(question.id, option.id),
                child: Row(
                  children: [
                    Icon(
                      selectedOptionId == option.id
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.label,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (submitted) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle_rounded
                          : Icons.lightbulb_rounded,
                      color: isCorrect
                          ? const Color(0xFF4F7E54)
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isCorrect
                            ? l10n.wuduQuizCorrectFeedback
                            : l10n.wuduQuizKeepLearningFeedback,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  question.explanation,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                submitted
                    ? l10n.wuduQuizAnswerLocked
                    : l10n.wuduQuizAnswerHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: submitted
                      ? controller.goNext
                      : (selectedOptionId == null
                            ? null
                            : controller.submitCurrentAnswer),
                  child: Text(
                    submitted
                        ? (questionNumber == content.questions.length
                              ? l10n.wuduQuizFinishAction
                              : l10n.wuduQuizNextAction)
                        : l10n.wuduQuizCheckAnswerAction,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _typeLabel(BuildContext context, WuduQuizQuestionType type) {
    final l10n = AppLocalizations.of(context);
    return switch (type) {
      WuduQuizQuestionType.stepOrder => l10n.wuduQuizTypeOrder,
      WuduQuizQuestionType.whatComesNext => l10n.wuduQuizTypeNext,
      WuduQuizQuestionType.identifyValidStep => l10n.wuduQuizTypeIdentify,
      WuduQuizQuestionType.adab => l10n.wuduQuizTypeAdab,
    };
  }
}

class _QuizSummaryCard extends ConsumerWidget {
  const _QuizSummaryCard({required this.content});

  final WuduQuizContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(wuduQuizControllerProvider);
    final controller = ref.read(wuduQuizControllerProvider.notifier);
    final score = controller.totalScore();
    final total = controller.totalQuestions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.school_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      content.summaryTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                content.summarySubtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.wuduQuizScoreSummary(score, total),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (state.rewardSummary != null) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.wuduQuizRewardFeedback(
                    state.rewardSummary!.xpAwarded,
                    state.rewardSummary!.oceanDropsAwarded,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (state.completedOnce) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.wuduQuizCompletionSaved,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: controller.restartQuiz,
                    child: Text(l10n.wuduQuizRestartAction),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(l10n.wuduQuizReturnToTrainerAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
