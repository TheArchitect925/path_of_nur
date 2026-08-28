import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import '../domain/trivia_models.dart';
import 'trivia_metadata_localization.dart';
import 'trivia_ui_localization.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaSessionPage extends ConsumerStatefulWidget {
  const IslamicTriviaSessionPage({super.key});

  @override
  ConsumerState<IslamicTriviaSessionPage> createState() =>
      _IslamicTriviaSessionPageState();
}

class _IslamicTriviaSessionPageState
    extends ConsumerState<IslamicTriviaSessionPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    final state = ref.watch(triviaControllerProvider);
    final controller = ref.read(triviaControllerProvider.notifier);
    final session = state.activeSession;
    final question = controller.currentQuestion;
    final questionState = controller.currentQuestionState();
    final repository = ref.read(triviaRepositoryProvider);

    if (session == null || question == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.triviaSessionPageTitle)),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: TriviaEmptyStateCard(
            title: l10n.triviaSessionNoActiveTitle,
            subtitle: l10n.triviaSessionNoActiveSubtitle,
          ),
        ),
      );
    }

    final categoryLabel = session.categoryId == null
        ? l10n.triviaMixedLabel
        : repository.categoryById(session.categoryId!) == null
        ? l10n.triviaMixedLabel
        : localizedTriviaCategoryTitle(
            l10n,
            repository.categoryById(session.categoryId!)!,
          );
    final progress =
        ((session.currentIndex + (questionState?.isAnswered == true ? 1 : 0)) /
                session.questionIds.length)
            .clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          session.knowledgeStageTitle ??
              localizedTriviaModeLabel(l10n, session.mode),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _confirmQuit,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: AppColors.accentGoldSoft,
              backgroundColor: AppColors.surfaceSoft,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(
                  context,
                  l10n.homeFractionValue(
                    numberFormat.format(session.currentIndex + 1),
                    numberFormat.format(session.questionIds.length),
                  ),
                ),
                _chip(
                  context,
                  session.isKnowledgePathSession
                      ? l10n.triviaKnowledgePathsPageTitle
                      : localizedTriviaModeLabel(l10n, session.mode),
                ),
                _chip(context, categoryLabel),
                _chip(context, question.difficulty.localizedLabel(l10n)),
              ],
            ),
            const SizedBox(height: 16),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.prompt,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...question.options.map((option) {
                    final isAnswered = questionState?.isAnswered == true;
                    final isSelected =
                        questionState?.selectedOptionId == option.id;
                    final isCorrectOption =
                        question.correctOptionId == option.id;
                    final showIncorrect =
                        isAnswered && isSelected && !isCorrectOption;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TriviaOptionCard(
                        label: option.label,
                        stateLabel: option.label,
                        selected: isSelected,
                        correct: isAnswered && isCorrectOption,
                        incorrect: showIncorrect,
                        disabled: isAnswered,
                        onTap: () {
                          controller.answerCurrent(option.id);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (questionState?.isAnswered == true) ...[
              const SizedBox(height: 14),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          questionState?.isCorrect == true
                              ? Icons.check_circle_rounded
                              : Icons.info_rounded,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            questionState?.isCorrect == true
                                ? l10n.triviaSessionCorrectAnswer
                                : l10n.triviaSessionReviewThisPoint,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(question.explanation),
                    if (question.quranReference != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        question.quranReference!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                    ],
                    if (question.sourceReference != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        question.sourceReference!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                    ],
                    if (question.learningNote != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        question.learningNote!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (question.tags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: question.tags
                            .map((tag) => _chip(context, tag))
                            .toList(growable: false),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final finished = controller.nextQuestion();
                  if (finished && mounted) {
                    context.goNamed('learnTriviaResults');
                  }
                },
                child: Text(
                  session.mode == TriviaMode.survival &&
                          questionState?.isCorrect == false
                      ? l10n.triviaSessionSeeResults
                      : session.isLastQuestion
                      ? l10n.triviaSessionFinish
                      : l10n.triviaSessionNext,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmQuit() async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(triviaControllerProvider.notifier);
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.triviaSessionLeaveTitle),
          content: Text(l10n.triviaSessionLeaveSubtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.triviaSessionResumeLater),
            ),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.triviaSessionDiscard),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (shouldDiscard == true) {
      controller.discardActiveSession();
    } else {
      controller.resumeLater();
    }
    context.pop();
  }

  Widget _chip(BuildContext context, String label) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
