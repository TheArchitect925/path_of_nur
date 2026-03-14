import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import '../domain/trivia_models.dart';
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
    final state = ref.watch(triviaControllerProvider);
    final controller = ref.read(triviaControllerProvider.notifier);
    final session = state.activeSession;
    final question = controller.currentQuestion;
    final questionState = controller.currentQuestionState();
    final repository = ref.read(triviaRepositoryProvider);

    if (session == null || question == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Islamic Trivia')),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: TriviaEmptyStateCard(
            title: 'No active session',
            subtitle:
                'Start a new quiz from Islamic Trivia to begin a session.',
          ),
        ),
      );
    }

    final categoryLabel = session.categoryId == null
        ? 'Mixed'
        : repository.categoryById(session.categoryId!)?.title ?? 'Mixed';
    final progress =
        ((session.currentIndex + (questionState?.isAnswered == true ? 1 : 0)) /
                session.questionIds.length)
            .clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          session.knowledgeStageTitle ?? session.mode.label,
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
                _chip(context, '${session.currentIndex + 1}/${session.questionIds.length}'),
                _chip(
                  context,
                  session.isKnowledgePathSession ? 'Knowledge Path' : session.mode.label,
                ),
                _chip(context, categoryLabel),
                _chip(context, question.difficulty.label),
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
                    final isSelected = questionState?.selectedOptionId == option.id;
                    final isCorrectOption = question.correctOptionId == option.id;
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
                                ? 'Correct answer'
                                : 'Review this point',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
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
                      ? 'See results'
                      : session.isLastQuestion
                          ? 'Finish'
                          : 'Next',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmQuit() async {
    final controller = ref.read(triviaControllerProvider.notifier);
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave this session?'),
          content: const Text(
            'You can keep this session and resume later, or discard it now.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Resume later'),
            ),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Discard'),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
