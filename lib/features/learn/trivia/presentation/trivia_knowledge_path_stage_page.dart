import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/trivia_controller.dart';
import '../application/trivia_repository.dart';
import '../domain/trivia_models.dart';
import 'widgets/trivia_widgets.dart';

class IslamicTriviaKnowledgePathStagePage extends ConsumerWidget {
  const IslamicTriviaKnowledgePathStagePage({
    super.key,
    required this.pathId,
    required this.stageId,
  });

  final String pathId;
  final String stageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(triviaControllerProvider.notifier);
    final repository = ref.read(triviaRepositoryProvider);
    final state = ref.watch(triviaControllerProvider);
    final path = controller.knowledgePathById(pathId);
    TriviaKnowledgeStage? stage;
    if (path != null) {
      for (final item in path.stages) {
        if (item.id == stageId) {
          stage = item;
          break;
        }
      }
    }
    if (path == null || stage == null) {
      return const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: TriviaEmptyStateCard(
              title: 'Stage not found',
              subtitle: 'This knowledge path stage is unavailable right now.',
            ),
          ),
        ),
      );
    }
    final resolvedStage = stage;

    final stageState = controller.stageState(path, resolvedStage);
    final questions = repository.questionsForIds(resolvedStage.questionIds);
    final activeSession = state.activeSession;
    final canResume = activeSession?.knowledgePathId == path.id &&
        activeSession?.knowledgeStageId == resolvedStage.id;

    return Scaffold(
      backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(resolvedStage.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(context, path.title),
                _chip(context, resolvedStage.difficulty.label),
                _chip(context, '${questions.length} questions'),
                _chip(
                  context,
                  switch (stageState) {
                    TriviaKnowledgeStageState.completed => 'Completed',
                    TriviaKnowledgeStageState.unlocked => 'Unlocked',
                    TriviaKnowledgeStageState.locked => 'Locked',
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resolvedStage.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(resolvedStage.learningText),
                  if (resolvedStage.reference != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      resolvedStage.reference!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                  ],
                  if (resolvedStage.note != null) ...[
                    const SizedBox(height: 8),
                    Text(
                        resolvedStage.note!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            TriviaEmptyStateCard(
              title: 'Stage quiz',
              subtitle:
                  'Answer ${questions.length} focused questions. Wrong answers still feed your review queue.',
              action: FilledButton.tonalIcon(
                onPressed: stageState == TriviaKnowledgeStageState.locked || questions.isEmpty
                    ? null
                    : () {
                        final started = controller.startKnowledgePathStage(
                          pathId: path.id,
                          stageId: resolvedStage.id,
                        );
                        if (started) {
                          context.pushNamed('learnTriviaSession');
                        }
                      },
                icon: Icon(
                  canResume ? Icons.play_circle_fill_rounded : Icons.quiz_rounded,
                ),
                label: Text(canResume ? 'Continue Quiz' : 'Start Quiz'),
              ),
            ),
            const SizedBox(height: 14),
            const TriviaSectionHeader(
              title: 'Included questions',
              subtitle: 'A short preview of what this stage will reinforce.',
            ),
            const SizedBox(height: 8),
            if (questions.isEmpty)
              const TriviaEmptyStateCard(
                title: 'No questions available',
                subtitle: 'This stage definition needs valid trivia question links.',
              )
            else
              ...questions.map((question) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TriviaEmptyStateCard(
                    title: question.prompt,
                    subtitle: question.explanation,
                  ),
                );
              }),
          ],
        ),
      ),
    );
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
