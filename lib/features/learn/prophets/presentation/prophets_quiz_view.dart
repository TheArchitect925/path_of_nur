import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/prophet_quiz_controller.dart';
import '../application/prophets_repository.dart';
import '../domain/prophet_quiz.dart';

class ProphetsQuizView extends ConsumerStatefulWidget {
  const ProphetsQuizView({super.key, this.onReviewProphets});

  final VoidCallback? onReviewProphets;

  @override
  ConsumerState<ProphetsQuizView> createState() => _ProphetsQuizViewState();
}

class _ProphetsQuizViewState extends ConsumerState<ProphetsQuizView> {
  ProphetQuizDifficulty _selectedDifficulty = ProphetQuizDifficulty.easy;
  ProphetQuizMode? _selectedMode;
  String? _selectedProphetId;
  String? _selectedEraId;

  @override
  Widget build(BuildContext context) {
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
                    'Question ${state.currentIndex + 1} of ${activeQuestions.length}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _difficultyLabel(state.lastDifficulty),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
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
                    color: AppColors.onSurfaceSubtle,
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
                              : AppColors.surface.withValues(alpha: 0.25),
                          border: Border.all(
                            color: showCorrect
                                ? const Color(0xFF2D8F58)
                                : showWrong
                                ? const Color(0xFFA55050)
                                : (selectedThis
                                      ? AppColors.accentGold.withValues(
                                          alpha: 0.65,
                                        )
                                      : AppColors.accentGoldSoft.withValues(
                                          alpha: 0.34,
                                        )),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(option)),
                            if (showCorrect)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF2D8F58),
                                size: 18,
                              ),
                            if (showWrong)
                              const Icon(
                                Icons.cancel_rounded,
                                color: Color(0xFFA55050),
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
                    isCorrect ? 'Correct' : 'Not quite',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isCorrect
                          ? const Color(0xFF2D8F58)
                          : const Color(0xFFA55050),
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
                          ? 'See Results'
                          : 'Continue',
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
                  'Quiz Results',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text('Score: ${result.score}/${result.total}'),
                Text('Accuracy: ${(result.accuracy * 100).round()}%'),
                const SizedBox(height: 8),
                Text('Best score: ${state.bestScore}'),
                Text('Total quizzes taken: ${state.totalQuizzesTaken}'),
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
                      child: const Text('Retry Quiz'),
                    ),
                    OutlinedButton(
                      onPressed: widget.onReviewProphets,
                      child: const Text('Review Prophets'),
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
                const Text(
                  'Learning Notes',
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
                'Prophet Quiz',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Test knowledge of prophetic stories, timelines, lessons, and Qur\'anic references.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Difficulty',
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
                'Mode',
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
                    label: const Text('Mixed'),
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
                'Prophet Focus',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String?>(
                initialValue: _selectedProphetId,
                items: <DropdownMenuItem<String?>>[
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Prophets'),
                  ),
                  ...prophets.map(
                    (prophet) => DropdownMenuItem<String?>(
                      value: prophet.id,
                      child: Text(prophet.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedProphetId = value);
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Era Focus',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String?>(
                initialValue: _selectedEraId,
                items: <DropdownMenuItem<String?>>[
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Eras'),
                  ),
                  ..._eraOptionsFromPool(controller.questionPool).map(
                    (eraId) => DropdownMenuItem<String?>(
                      value: eraId,
                      child: Text(_eraLabel(eraId)),
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
                      child: const Text('Start Quiz'),
                    ),
                  ),
                  if (state.inProgress) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Continue Quiz'),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Text('Last score: ${state.lastScore}'),
              Text('Best score: ${state.bestScore}'),
              Text('Total quizzes taken: ${state.totalQuizzesTaken}'),
              Text('Question pool: ${controller.questionPool.length}'),
              if (state.lastProphetId != null || state.lastEraId != null)
                Text(
                  'Last focus: ${state.lastProphetId == null ? 'All prophets' : (prophetById[state.lastProphetId!]?.name ?? state.lastProphetId!)} · ${state.lastEraId == null ? 'All eras' : _eraLabel(state.lastEraId!)}',
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
        return 'Easy';
      case ProphetQuizDifficulty.medium:
        return 'Medium';
      case ProphetQuizDifficulty.hard:
        return 'Hard';
    }
  }

  String _modeLabel(ProphetQuizMode mode) {
    switch (mode) {
      case ProphetQuizMode.prophetIdentification:
        return 'Identify';
      case ProphetQuizMode.timelineOrder:
        return 'Timeline';
      case ProphetQuizMode.storyMatching:
        return 'Story Match';
      case ProphetQuizMode.quranReference:
        return 'References';
      case ProphetQuizMode.lessonRecognition:
        return 'Lessons';
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

  String _eraLabel(String eraId) {
    switch (eraId) {
      case 'earlyHumanity':
        return 'Early Humanity';
      case 'earlyCivilizations':
        return 'Early Civilizations';
      case 'postFloodPeoples':
        return 'Post-Flood Peoples';
      case 'ageOfIbrahim':
        return 'Age of Ibrahim';
      case 'childrenOfIsrael':
        return 'Children of Israel';
      case 'laterIsraeliteProphets':
        return 'Later Israelite Prophets';
      case 'finalMessenger':
        return 'Final Messenger';
      default:
        return eraId;
    }
  }
}
