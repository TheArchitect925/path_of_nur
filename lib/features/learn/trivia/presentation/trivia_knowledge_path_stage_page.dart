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
import 'trivia_ui_localization.dart';
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
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
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
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: TriviaEmptyStateCard(
              title: l10n.triviaStageNotFoundTitle,
              subtitle: l10n.triviaStageNotFoundSubtitle,
            ),
          ),
        ),
      );
    }
    final resolvedStage = stage;

    final stageState = controller.stageState(path, resolvedStage);
    final questions = repository.questionsForIds(resolvedStage.questionIds);
    final activeSession = state.activeSession;
    final canResume =
        activeSession?.knowledgePathId == path.id &&
        activeSession?.knowledgeStageId == resolvedStage.id;

    return Scaffold(
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
                _chip(context, resolvedStage.difficulty.localizedLabel(l10n)),
                _chip(
                  context,
                  l10n.triviaQuestionsCount(
                    numberFormat.format(questions.length),
                  ),
                ),
                _chip(context, stageState.localizedLabel(l10n)),
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
              title: l10n.triviaStageQuizTitle,
              subtitle: l10n.triviaStageQuizSubtitle(
                numberFormat.format(questions.length),
              ),
              action: FilledButton.tonalIcon(
                onPressed:
                    stageState == TriviaKnowledgeStageState.locked ||
                        questions.isEmpty
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
                  canResume
                      ? Icons.play_circle_fill_rounded
                      : Icons.quiz_rounded,
                ),
                label: Text(
                  canResume
                      ? l10n.triviaContinueQuizAction
                      : l10n.triviaStartQuizAction,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TriviaSectionHeader(
              title: l10n.triviaIncludedQuestionsTitle,
              subtitle: l10n.triviaIncludedQuestionsSubtitle,
            ),
            const SizedBox(height: 8),
            if (questions.isEmpty)
              TriviaEmptyStateCard(
                title: l10n.triviaNoQuestionsAvailableTitle,
                subtitle: l10n.triviaNoQuestionsAvailableSubtitle,
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
