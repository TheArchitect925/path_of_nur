import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/bedtime_story_learning_loop_service.dart';
import '../application/bedtime_story_learning_progress_service.dart';
import '../application/bedtime_story_learning_repository.dart';
import '../application/bedtime_story_repository.dart';
import '../domain/bedtime_story_learning_models.dart';
import 'bedtime_story_question_card.dart';

class BedtimeStoryQuizPage extends ConsumerStatefulWidget {
  const BedtimeStoryQuizPage({super.key, required this.storyId});

  final String storyId;

  @override
  ConsumerState<BedtimeStoryQuizPage> createState() => _BedtimeStoryQuizPageState();
}

class _BedtimeStoryQuizPageState extends ConsumerState<BedtimeStoryQuizPage> {
  String? _selectedAnswerId;
  bool _submitted = false;
  bool _answeredCorrectly = false;
  bool _didOpenActivity = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(bedtimeStoryByIdProvider(widget.storyId));
    final quiz = ref.watch(bedtimeStoryQuizByStoryIdProvider(widget.storyId));

    if (story == null) {
      return AppPageScaffold(
        title: l10n.bedtimeStoriesTitle,
        subtitle: l10n.routerNotFoundTitle,
        children: [Text(l10n.routerNotFoundTitle)],
      );
    }

    if (quiz == null) {
      return AppPageScaffold(
        title: l10n.bedtimeStoryQuizTitle,
        subtitle: story.shortTitle,
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeStoryLearningUnavailableTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(l10n.bedtimeStoryQuizUnavailableSubtitle),
              ],
            ),
          ),
        ],
      );
    }

    if (quiz.questions.isEmpty) {
      return AppPageScaffold(
        title: l10n.bedtimeStoryQuizTitle,
        subtitle: story.shortTitle,
        children: [
          PremiumCard(
            child: Text(l10n.bedtimeStoryQuizUnavailableSubtitle),
          ),
        ],
      );
    }

    final progress = ref.watch(
      bedtimeStoryLearningProgressProvider.select(
        (value) =>
            value.progressByActivityId[quiz.quizId] ??
            BedtimeStoryLearningActivityProgress(
              storyId: quiz.storyId,
              mode: BedtimeStoryLearningMode.quiz,
            ),
      ),
    );
    final safeIndex = progress.currentStepIndex.clamp(0, quiz.questions.length - 1);
    final question = quiz.questions[safeIndex];
    final nextSuggestion = ref.watch(
      bedtimeStoryNextLearningSuggestionByStoryIdProvider(widget.storyId),
    );

    if (!_didOpenActivity) {
      _didOpenActivity = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bedtimeStoryLearningProgressProvider.notifier).openActivity(
          activityId: quiz.quizId,
          storyId: story.id,
          mode: BedtimeStoryLearningMode.quiz,
          totalSteps: quiz.questions.length,
        );
      });
    }

    return AppPageScaffold(
      title: l10n.bedtimeStoryQuizTitle,
      subtitle: story.shortTitle,
      headerIcon: Icons.quiz_rounded,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(quiz.shortDescription),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: quiz.questions.isEmpty
                    ? 0
                    : (safeIndex + (progress.isCompleted ? 1 : 0)) /
                        quiz.questions.length,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.bedtimeStoryQuizProgressLabel(
                  progress.isCompleted ? quiz.questions.length : safeIndex + 1,
                  quiz.questions.length,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (!progress.isCompleted) ...[
          BedtimeStoryQuestionCard(
            question: question,
            selectedAnswerId: _selectedAnswerId,
            locked: _submitted,
            onSelect: (answerId) {
              if (_submitted) {
                return;
              }
              setState(() {
                _selectedAnswerId = answerId;
                _submitted = true;
                _answeredCorrectly = answerId == question.correctAnswerId;
              });
              ref.read(bedtimeStoryLearningProgressProvider.notifier).recordStepProgress(
                    activityId: quiz.quizId,
                    storyId: story.id,
                    mode: BedtimeStoryLearningMode.quiz,
                    // Keep the current question visible until the user
                    // explicitly continues, otherwise the next question
                    // renders immediately while the local answer state is
                    // still locked.
                    currentStepIndex: safeIndex,
                    totalSteps: quiz.questions.length,
                    completedStepId: question.questionId,
                    answeredCorrectly: _answeredCorrectly,
                  );
            },
          ),
          if (_submitted) ...[
            const SizedBox(height: 12),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _answeredCorrectly
                        ? l10n.bedtimeStoryQuizCorrectTitle
                        : l10n.bedtimeStoryQuizTryAgainTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(question.explanation),
                  if ((question.hint ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.bedtimeStoryQuizHintLabel(question.hint!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      if (safeIndex >= quiz.questions.length - 1) {
                        final outcome = ref
                            .read(bedtimeStoryLearningProgressProvider.notifier)
                            .completeActivity(
                              activityId: quiz.quizId,
                              storyId: story.id,
                              mode: BedtimeStoryLearningMode.quiz,
                              totalSteps: quiz.questions.length,
                              xpReward: quiz.reward.xpReward,
                              sourceRef: 'bedtime_story_quiz:${quiz.quizId}:complete',
                              metadata: <String, Object?>{
                                'feature': 'kids_bedtime_story_quiz',
                                'storyId': story.id,
                                'quizId': quiz.quizId,
                                'prophetId': quiz.prophetId,
                              },
                            );
                        if (outcome.firstCompletion) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.bedtimeStoryLearningCompletionSnack(
                                  outcome.xpAwarded,
                                ),
                              ),
                            ),
                          );
                        }
                        setState(() {
                          _selectedAnswerId = null;
                          _submitted = false;
                          _answeredCorrectly = false;
                        });
                        return;
                      }
                      ref
                          .read(bedtimeStoryLearningProgressProvider.notifier)
                          .recordStepProgress(
                            activityId: quiz.quizId,
                            storyId: story.id,
                            mode: BedtimeStoryLearningMode.quiz,
                            currentStepIndex: safeIndex + 1,
                            totalSteps: quiz.questions.length,
                          );
                      setState(() {
                        _selectedAnswerId = null;
                        _submitted = false;
                        _answeredCorrectly = false;
                      });
                    },
                    child: Text(
                      safeIndex >= quiz.questions.length - 1
                          ? l10n.bedtimeStoryQuizFinishAction
                          : l10n.bedtimeStoryQuizNextAction,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ] else ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeStoryQuizCompleteTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  nextSuggestion != null &&
                          nextSuggestion.mode ==
                              BedtimeStoryLearningMode.memoryCards
                      ? l10n.bedtimeStoryQuizCompleteWithNextSubtitle
                      : l10n.bedtimeStoryQuizCompleteSubtitle,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () => context.pushNamed(
                        'kidsBedtimeStoryDetail',
                        pathParameters: {'storyId': story.id},
                      ),
                      icon: const Icon(Icons.nightlight_round),
                      label: Text(l10n.bedtimeStoryBackToStoryAction),
                    ),
                    if (nextSuggestion != null &&
                        nextSuggestion.mode ==
                            BedtimeStoryLearningMode.memoryCards)
                      OutlinedButton.icon(
                        onPressed: () => context.pushNamed(
                          'kidsBedtimeStoryMemory',
                          pathParameters: {'storyId': story.id},
                        ),
                        icon: const Icon(Icons.style_rounded),
                        label: Text(l10n.bedtimeStoryMemoryCardsAction),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
