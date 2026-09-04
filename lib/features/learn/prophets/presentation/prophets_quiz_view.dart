import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/prophet_quiz_controller.dart';
import '../application/prophets_repository.dart';
import '../domain/prophet_quiz.dart';

class ProphetsQuizView extends ConsumerStatefulWidget {
  const ProphetsQuizView({
    super.key,
    this.onReviewProphets,
    this.initialModeName,
    this.initialDifficultyName,
  });

  final VoidCallback? onReviewProphets;
  final String? initialModeName;
  final String? initialDifficultyName;

  @override
  ConsumerState<ProphetsQuizView> createState() => _ProphetsQuizViewState();
}

class _ProphetsQuizViewState extends ConsumerState<ProphetsQuizView> {
  ProphetQuizDifficulty _selectedDifficulty = ProphetQuizDifficulty.easy;
  ProphetQuizMode? _selectedMode;
  String? _selectedProphetId;
  String? _selectedEraId;

  @override
  void initState() {
    super.initState();
    final initialDifficultyName = widget.initialDifficultyName;
    if (initialDifficultyName != null) {
      for (final difficulty in ProphetQuizDifficulty.values) {
        if (difficulty.name == initialDifficultyName) {
          _selectedDifficulty = difficulty;
          break;
        }
      }
    }
    final initialModeName = widget.initialModeName;
    if (initialModeName != null) {
      for (final mode in ProphetQuizMode.values) {
        if (mode.name == initialModeName) {
          _selectedMode = mode;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(prophetQuizControllerProvider);
    final controller = ref.read(prophetQuizControllerProvider.notifier);
    final prophets = ref.watch(prophetsProvider);
    final prophetById = {for (final prophet in prophets) prophet.id: prophet};

    final activeQuestions = controller.activeQuestions();
    final hasCurrent =
        state.inProgress &&
        state.currentIndex >= 0 &&
        state.currentIndex < activeQuestions.length;

    if (hasCurrent) {
      final current = activeQuestions[state.currentIndex];
      final selected = state.selectedAnswers[current.id];
      final answered = selected != null;
      final isCorrect = answered && selected == current.correctAnswerIndex;

      return Column(
        children: [
          PremiumCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.batch9QuestionProgress(
                      '${state.currentIndex + 1}',
                      '${activeQuestions.length}',
                    ),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _difficultyLabel(state.lastDifficulty),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _modeLabel(current.mode),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  current.questionText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(current.options.length, (index) {
                  final option = current.options[index];
                  final selectedThis = selected == index;
                  final showCorrect =
                      answered && index == current.correctAnswerIndex;
                  final showWrong = answered && selectedThis && !showCorrect;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: answered
                          ? null
                          : () {
                              controller.answerCurrent(index);
                            },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: showCorrect
                              ? const Color(0x332D8F58)
                              : showWrong
                              ? const Color(0x33A55050)
                              : context.palette.surface.withValues(alpha: 0.25),
                          border: Border.all(
                            color: showCorrect
                                ? context.palette.successInk
                                : showWrong
                                ? context.palette.error
                                : (selectedThis
                                      ? context.palette.accent.withValues(
                                          alpha: 0.65,
                                        )
                                      : context.palette.accentSoft.withValues(
                                          alpha: 0.34,
                                        )),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(option)),
                            if (showCorrect)
                              Icon(
                                Icons.check_circle_rounded,
                                color: context.palette.successInk,
                                size: 18,
                              ),
                            if (showWrong)
                              Icon(
                                Icons.cancel_rounded,
                                color: context.palette.error,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                if (answered) ...[
                  const SizedBox(height: 6),
                  Text(
                    isCorrect
                        ? l10n.batch9AnswerCorrect
                        : l10n.batch9AnswerNotQuite,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isCorrect
                          ? context.palette.successInk
                          : context.palette.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(current.explanation),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () {
                      controller.nextQuestion();
                    },
                    child: Text(
                      state.currentIndex + 1 >= activeQuestions.length
                          ? l10n.triviaSessionSeeResults
                          : l10n.batch9ContinueAction,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    if (state.lastResult != null &&
        !state.inProgress &&
        state.lastResult!.total > 0) {
      final result = state.lastResult!;
      final reviewItems = activeQuestions.isNotEmpty
          ? activeQuestions
          : controller.questionPool.take(5).toList();

      return Column(
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.batch9QuizResultsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.batch9QuizScoreSummary(
                    '${result.score}',
                    '${result.total}',
                  ),
                ),
                Text(
                  l10n.batch9QuizAccuracySummary(
                    '${(result.accuracy * 100).round()}',
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.batch9BestScoreSummary('${state.bestScore}')),
                Text(
                  l10n.batch9TotalQuizzesTakenSummary(
                    '${state.totalQuizzesTaken}',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () => controller.startQuiz(
                        difficulty: _selectedDifficulty,
                        mode: _selectedMode,
                        prophetId: _selectedProphetId,
                        eraId: _selectedEraId,
                      ),
                      child: Text(l10n.batch9RetryQuizAction),
                    ),
                    OutlinedButton(
                      onPressed: widget.onReviewProphets,
                      child: Text(l10n.batch9ReviewProphetsAction),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.batch9LearningNotesTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...reviewItems
                    .take(5)
                    .map(
                      (q) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• ${q.explanation}'),
                      ),
                    ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.batch9ProphetQuizTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.batch9ProphetQuizSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.batch9DifficultyTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ProphetQuizDifficulty.values.map((difficulty) {
                  final selected = _selectedDifficulty == difficulty;
                  return ChoiceChip(
                    label: Text(_difficultyLabel(difficulty)),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedDifficulty = difficulty),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.batch9ModeTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.triviaMixedLabel),
                    selected: _selectedMode == null,
                    onSelected: (_) => setState(() => _selectedMode = null),
                  ),
                  ...ProphetQuizMode.values.map((mode) {
                    final selected = _selectedMode == mode;
                    return ChoiceChip(
                      label: Text(_modeLabel(mode)),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedMode = mode),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                l10n.batch9ProphetFocusTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String?>(
                initialValue: _selectedProphetId,
                items: <DropdownMenuItem<String?>>[
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.batch9AllProphets),
                  ),
                  ...prophets.map(
                    (prophet) => DropdownMenuItem<String?>(
                      value: prophet.id,
                      child: Text(prophet.honoredName),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedProphetId = value);
                },
              ),
              const SizedBox(height: 10),
              Text(
                l10n.batch9EraFocusTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String?>(
                initialValue: _selectedEraId,
                items: <DropdownMenuItem<String?>>[
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.batch9AllEras),
                  ),
                  ..._eraOptionsFromPool(controller.questionPool).map(
                    (eraId) => DropdownMenuItem<String?>(
                      value: eraId,
                      child: Text(_eraLabel(l10n, eraId)),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedEraId = value);
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => controller.startQuiz(
                        difficulty: _selectedDifficulty,
                        mode: _selectedMode,
                        prophetId: _selectedProphetId,
                        eraId: _selectedEraId,
                      ),
                      child: Text(l10n.triviaStartQuizAction),
                    ),
                  ),
                  if (state.inProgress) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(l10n.triviaContinueQuizAction),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Text(l10n.batch9LastScoreSummary('${state.lastScore}')),
              Text(l10n.batch9BestScoreSummary('${state.bestScore}')),
              Text(
                l10n.batch9TotalQuizzesTakenSummary(
                  '${state.totalQuizzesTaken}',
                ),
              ),
              Text(
                l10n.batch9QuestionPoolSummary(
                  '${controller.questionPool.length}',
                ),
              ),
              if (state.lastProphetId != null || state.lastEraId != null)
                Text(
                  l10n.batch9LastFocusSummary(
                    state.lastProphetId == null
                        ? l10n.batch9AllProphets
                        : (prophetById[state.lastProphetId!]?.honoredName ??
                              state.lastProphetId!),
                    state.lastEraId == null
                        ? l10n.batch9AllEras
                        : _eraLabel(l10n, state.lastEraId!),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _difficultyLabel(ProphetQuizDifficulty difficulty) {
    switch (difficulty) {
      case ProphetQuizDifficulty.easy:
        return AppLocalizations.of(context).triviaDifficultyEasy;
      case ProphetQuizDifficulty.medium:
        return AppLocalizations.of(context).triviaDifficultyMedium;
      case ProphetQuizDifficulty.hard:
        return AppLocalizations.of(context).triviaDifficultyHard;
    }
  }

  String _modeLabel(ProphetQuizMode mode) {
    switch (mode) {
      case ProphetQuizMode.prophetIdentification:
        return AppLocalizations.of(
          context,
        ).learnQuizzesProphetModeIdentification;
      case ProphetQuizMode.timelineOrder:
        return AppLocalizations.of(context).learnQuizzesProphetModeTimeline;
      case ProphetQuizMode.storyMatching:
        return AppLocalizations.of(
          context,
        ).learnQuizzesProphetModeStoryMatching;
      case ProphetQuizMode.quranReference:
        return AppLocalizations.of(
          context,
        ).learnQuizzesProphetModeQuranReference;
      case ProphetQuizMode.lessonRecognition:
        return AppLocalizations.of(
          context,
        ).learnQuizzesProphetModeLessonRecognition;
    }
  }

  List<String> _eraOptionsFromPool(List<ProphetQuizQuestion> pool) {
    final eras = <String>{};
    for (final question in pool) {
      final era = question.eraId;
      if (era != null && era.trim().isNotEmpty) {
        eras.add(era);
      }
    }
    final sorted = eras.toList()..sort();
    return sorted;
  }

  String _eraLabel(AppLocalizations l10n, String eraId) {
    switch (eraId) {
      case 'earlyHumanity':
        return l10n.prophetsEraEarlyHumanityTitle;
      case 'earlyCivilizations':
        return l10n.prophetsEraEarlyCivilizationsTitle;
      case 'postFloodPeoples':
        return l10n.prophetsEraPostFloodPeoplesTitle;
      case 'ageOfIbrahim':
        return l10n.prophetsEraAgeOfIbrahimTitle;
      case 'childrenOfIsrael':
        return l10n.prophetsEraChildrenOfIsraelTitle;
      case 'laterIsraeliteProphets':
        return l10n.prophetsEraLaterIsraeliteProphetsTitle;
      case 'finalMessenger':
        return l10n.prophetsEraFinalMessengerTitle;
      default:
        return eraId;
    }
  }
}
