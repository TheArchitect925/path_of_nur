import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../arabic/data/arabic_alphabet_catalog.dart';
import '../../../arabic/domain/arabic_alphabet_models.dart';
import '../../../arabic/presentation/widgets/arabic_learning_playback_speed_toggle.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_teaching_audio_playback_service.dart';
import '../application/quran_teaching_controller.dart';
import '../application/quran_teaching_smart_review_controller.dart';
import '../domain/quran_teaching_models.dart';
import '../domain/quran_teaching_review_models.dart';
import 'quran_teaching_listen_only_page.dart';
import 'widgets/quran_teaching_asset_widgets.dart';

class QuranTeachingLessonPage extends ConsumerStatefulWidget {
  const QuranTeachingLessonPage({
    super.key,
    required this.lesson,
    required this.module,
  });

  final QuranTeachingLesson lesson;
  final QuranTeachingModule module;

  @override
  ConsumerState<QuranTeachingLessonPage> createState() =>
      _QuranTeachingLessonPageState();
}

class _QuranTeachingLessonPageState
    extends ConsumerState<QuranTeachingLessonPage> {
  int _stepIndex = 0;
  int _quizIndex = 0;
  bool _inQuiz = false;
  final Map<String, bool> _quizAnsweredCorrectly = <String, bool>{};

  String? _selectedOptionId;
  bool? _selectedTrueFalse;
  String? _feedback;
  bool? _wasCorrect;
  final List<String> _buildSelection = <String>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(quranTeachingProgressProvider.notifier)
          .markLessonStarted(widget.lesson.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(quranTeachingProgressProvider);
    final reviewLater = progress.reviewLaterLessonIds.contains(
      widget.lesson.id,
    );
    final catalog = ref.watch(quranTeachingCatalogProvider);
    final totalPages =
        widget.lesson.steps.length + widget.lesson.quizzes.length;
    final currentPage = _inQuiz
        ? widget.lesson.steps.length + _quizIndex + 1
        : _stepIndex + 1;
    final nextStepTitle =
        !_inQuiz && _stepIndex + 1 < widget.lesson.steps.length
        ? widget.lesson.steps[_stepIndex + 1].title
        : null;

    return LearnHubPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: widget.lesson.title,
      subtitle: widget.module.title,
      headerActions: [
        IconButton(
          onPressed: () {
            final fallbackPack = _firstAudioPackForModule(
              catalog,
              widget.module.id,
            );
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => QuranTeachingListenOnlyPage(
                  initialPackId: fallbackPack?.id,
                ),
              ),
            );
          },
          icon: const Icon(Icons.headphones_rounded),
          tooltip: l10n.batch9PracticeAsAudioTooltip,
        ),
        IconButton(
          onPressed: () => ref
              .read(quranTeachingProgressProvider.notifier)
              .toggleReviewLater(widget.lesson.id),
          icon: Icon(
            reviewLater
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
          ),
          tooltip: reviewLater
              ? l10n.accessibilitySavedForReview
              : l10n.accessibilityReviewLater,
        ),
      ],
      children: [
        const ArabicLearningPlaybackSpeedToggle(),
        const SizedBox(height: 12),
        Text(
          '$currentPage / $totalPages',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: context.palette.onSurfaceSubtle,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: totalPages == 0 ? 0 : currentPage / totalPages,
          minHeight: 8,
          borderRadius: BorderRadius.circular(999),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: _inQuiz
              ? _QuizBody(
                  quiz: widget.lesson.quizzes[_quizIndex],
                  selectedOptionId: _selectedOptionId,
                  selectedTrueFalse: _selectedTrueFalse,
                  buildSelection: _buildSelection,
                  feedback: _feedback,
                  wasCorrect: _wasCorrect,
                  onPlayAudio: _playAudio,
                  onSelectOption: (id) {
                    if (_feedback != null) return;
                    setState(() => _selectedOptionId = id);
                  },
                  onSelectTrueFalse: (value) {
                    if (_feedback != null) return;
                    setState(() => _selectedTrueFalse = value);
                  },
                  onTapBuildToken: (value) {
                    if (_feedback != null) return;
                    setState(() {
                      if (_buildSelection.contains(value)) {
                        _buildSelection.remove(value);
                      } else {
                        _buildSelection.add(value);
                      }
                    });
                  },
                )
              : _LessonStepBody(
                  step: widget.lesson.steps[_stepIndex],
                  visualModeEnabled: progress.visualModeEnabled,
                  onPlayAudio: _playAudio,
                ),
        ),
        if (!_inQuiz && nextStepTitle != null) ...[
          const SizedBox(height: 12),
          Text(
            l10n.quranTeachingLessonUpNext(nextStepTitle),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.palette.onSurfaceSubtle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (!_inQuiz)
          FilledButton(
            onPressed: _advanceStep,
            child: Text(
              _stepIndex == widget.lesson.steps.length - 1
                  ? (widget.lesson.quizzes.isEmpty
                        ? l10n.batch9CompleteLessonAction
                        : l10n.batch9TryQuickQuizAction)
                  : l10n.batch9ContinueAction,
            ),
          ),
        if (_inQuiz && _feedback == null)
          FilledButton(
            onPressed: _submitQuiz,
            child: Text(l10n.batch9CheckAnswerAction),
          ),
        if (_inQuiz && _feedback != null)
          FilledButton(
            onPressed: _advanceQuiz,
            child: Text(
              _quizIndex == widget.lesson.quizzes.length - 1
                  ? l10n.batch9FinishLessonAction
                  : l10n.batch9NextQuestionAction,
            ),
          ),
      ],
    );
  }

  void _playAudio(QuranAudioCue audio) {
    final l10n = AppLocalizations.of(context);
    ref.read(quranTeachingAudioPlaybackServiceProvider).playCue(audio).then((
      played,
    ) {
      if (!mounted || played) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.batch9AudioNotAddedYet(audio.label))),
      );
    });
  }

  void _advanceStep() {
    if (_stepIndex < widget.lesson.steps.length - 1) {
      setState(() => _stepIndex += 1);
      return;
    }
    if (widget.lesson.quizzes.isEmpty) {
      _finishLesson();
      return;
    }
    setState(() => _inQuiz = true);
  }

  void _submitQuiz() {
    final quiz = widget.lesson.quizzes[_quizIndex];
    var correct = false;
    switch (quiz.type) {
      case QuranTeachingQuizType.tapInOrderBuildWord:
        correct = _buildSelection.join('|') == quiz.buildOrder.join('|');
        break;
      case QuranTeachingQuizType.trueFalse:
        correct = _selectedTrueFalse == quiz.truthAnswer;
        break;
      default:
        correct = quiz.correctOptionIds.contains(_selectedOptionId);
        break;
    }
    _quizAnsweredCorrectly[quiz.id] = correct;
    ref
        .read(quranTeachingSmartReviewProvider.notifier)
        .recordQuizAttempt(
          lesson: widget.lesson,
          quiz: quiz,
          correct: correct,
          source: QuranTeachingReviewSource.lesson,
        );
    if (!correct) {
      ref
          .read(quranTeachingMistakeQueueProvider.notifier)
          .recordMistake(
            lesson: widget.lesson,
            quiz: quiz,
            selectedOptionId: _selectedOptionId,
            selectedTokens: List<String>.from(_buildSelection),
          );
    }
    setState(() {
      _wasCorrect = correct;
      _feedback = correct ? quiz.feedbackCorrect : quiz.feedbackIncorrect;
    });
  }

  void _advanceQuiz() {
    if (_quizIndex < widget.lesson.quizzes.length - 1) {
      setState(() {
        _quizIndex += 1;
        _selectedOptionId = null;
        _selectedTrueFalse = null;
        _feedback = null;
        _wasCorrect = null;
        _buildSelection.clear();
      });
      return;
    }
    _finishLesson();
  }

  void _finishLesson() {
    final catalog = ref.read(quranTeachingCatalogProvider);
    final nextLesson = _nextLessonInModule(
      catalog,
      widget.module,
      widget.lesson,
    );
    var score = 1.0;
    if (widget.lesson.quizzes.isNotEmpty) {
      final correct = _quizAnsweredCorrectly.values
          .where((item) => item)
          .length;
      score = correct / widget.lesson.quizzes.length;
      for (final quiz in widget.lesson.quizzes) {
        ref
            .read(quranTeachingProgressProvider.notifier)
            .recordQuizScore(
              quiz.id,
              _quizAnsweredCorrectly[quiz.id] == true ? 1 : 0,
              lessonId: widget.lesson.id,
            );
      }
    }
    ref
        .read(quranTeachingProgressProvider.notifier)
        .completeLesson(widget.lesson.id);
    ref
        .read(quranTeachingSmartReviewProvider.notifier)
        .registerLessonCompletion(widget.lesson);
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranTeachingLessonCompleteTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                nextLesson == null
                    ? l10n.quranTeachingLessonCompleteSubtitle(
                        widget.lesson.title,
                      )
                    : l10n.quranTeachingLessonCompleteNextSubtitle(
                        widget.lesson.title,
                        nextLesson.title,
                      ),
              ),
              const SizedBox(height: 12),
              if (widget.lesson.quizzes.isNotEmpty)
                Text(l10n.quranTeachingLessonQuizScore((score * 100).round())),
              const SizedBox(height: 16),
              if (nextLesson != null) ...[
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(this.context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => QuranTeachingLessonPage(
                          lesson: nextLesson,
                          module: widget.module,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    l10n.quranTeachingLessonNextLesson(nextLesson.title),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(this.context).pop(true);
                },
                child: Text(l10n.quranTeachingLessonBackToModule),
              ),
            ],
          ),
        );
      },
    );
  }
}

QuranTeachingAudioPracticePack? _firstAudioPackForModule(
  QuranTeachingCatalog catalog,
  String moduleId,
) {
  for (final pack in catalog.audioPracticePacks) {
    if (pack.moduleId == moduleId) return pack;
  }
  return null;
}

class _LessonStepBody extends StatelessWidget {
  const _LessonStepBody({
    required this.step,
    required this.visualModeEnabled,
    required this.onPlayAudio,
  });

  final QuranTeachingStep step;
  final bool visualModeEnabled;
  final ValueChanged<QuranAudioCue> onPlayAudio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sharedLetter = _sharedLetterForStep(step);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          step.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: context.palette.surfaceSoft.withValues(alpha: 0.65),
          ),
          child: Column(
            children: [
              Text(
                step.focusArabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 44,
                  fontFamily: 'AmiriQuran',
                  height: 1.5,
                ),
              ),
              if (step.transliteration != null) ...[
                const SizedBox(height: 8),
                Text(
                  step.transliteration!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(step.explanation),
        if (sharedLetter != null) ...[
          const SizedBox(height: 16),
          _SharedLetterSupportCard(letter: sharedLetter),
        ],
        if (step.sourceReference != null) ...[
          const SizedBox(height: 8),
          Text(
            l10n.quranTeachingLessonSourceLabel(step.sourceReference!),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.onSurfaceSubtle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (step.helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            step.helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            if (step.audio != null)
              QuranTeachingAudioIconButton(
                audio: step.audio,
                availableIcon: Icons.volume_up_rounded,
                label: l10n.quranTeachingLessonHearThis,
                onAvailablePressed: () => onPlayAudio(step.audio!),
              ),
            if (visualModeEnabled && step.visualAnchor != null)
              QuranTeachingVisualAssetTile(
                label: step.visualAnchor!.label,
                hint: step.visualAnchor!.hint,
                icon: step.visualAnchor!.icon,
                imageAssetPath: step.visualAnchor!.imageAssetPath,
              ),
          ],
        ),
        if (step.examples.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(
            l10n.quranTeachingLessonExamplesTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...step.examples.map(
            (example) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: example.audio == null
                    ? null
                    : () => onPlayAudio(example.audio!),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: context.palette.surfaceSoft),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compactExample = constraints.maxWidth < 420;
                      final details = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            example.arabic,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 28,
                              fontFamily: 'AmiriQuran',
                            ),
                          ),
                          if (example.transliteration != null)
                            Text(example.transliteration!),
                          if (example.meaning != null)
                            Text(
                              example.meaning!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (example.verseReference != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                l10n.quranTeachingLessonSourceLabel(
                                  example.verseReference!,
                                ),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: context.palette.onSurfaceSubtle,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          if (visualModeEnabled && example.visualAnchor != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                '${example.visualAnchor!.label} • ${example.visualAnchor!.hint}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: context.palette.onSurfaceSubtle,
                                    ),
                              ),
                            ),
                        ],
                      );
                      final audioButton = example.audio == null
                          ? null
                          : QuranTeachingAudioIconButton(
                              audio: example.audio,
                              availableIcon: Icons.volume_up_rounded,
                              onAvailablePressed: () =>
                                  onPlayAudio(example.audio!),
                            );
                      if (compactExample) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            details,
                            if (audioButton != null) ...[
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: audioButton,
                              ),
                            ],
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: details),
                          if (audioButton != null) ...[
                            const SizedBox(width: 8),
                            audioButton,
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuizBody extends StatelessWidget {
  const _QuizBody({
    required this.quiz,
    required this.selectedOptionId,
    required this.selectedTrueFalse,
    required this.buildSelection,
    required this.feedback,
    required this.wasCorrect,
    required this.onPlayAudio,
    required this.onSelectOption,
    required this.onSelectTrueFalse,
    required this.onTapBuildToken,
  });

  final QuranTeachingQuizItem quiz;
  final String? selectedOptionId;
  final bool? selectedTrueFalse;
  final List<String> buildSelection;
  final String? feedback;
  final bool? wasCorrect;
  final ValueChanged<QuranAudioCue> onPlayAudio;
  final ValueChanged<String> onSelectOption;
  final ValueChanged<bool> onSelectTrueFalse;
  final ValueChanged<String> onTapBuildToken;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.quranTeachingLessonQuickQuizTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(quiz.prompt),
        if (quiz.promptArabic != null) ...[
          const SizedBox(height: 12),
          Text(
            quiz.promptArabic!,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 34, fontFamily: 'AmiriQuran'),
          ),
        ],
        if (quiz.promptSecondary != null) ...[
          const SizedBox(height: 6),
          Text(
            quiz.promptSecondary!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
        ],
        if (quiz.audio != null) ...[
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => onPlayAudio(quiz.audio!),
            icon: const Icon(Icons.volume_up_rounded),
            label: Text(l10n.quranTeachingLessonHearAudio),
          ),
        ],
        const SizedBox(height: 16),
        if (quiz.type == QuranTeachingQuizType.tapInOrderBuildWord) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quiz.options
                .map(
                  (option) => FilterChip(
                    label: Text(option.arabic ?? option.label),
                    selected: buildSelection.contains(option.label),
                    onSelected: (_) => onTapBuildToken(option.label),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.palette.surfaceSoft),
            ),
            child: Text(
              buildSelection.isEmpty
                  ? l10n.quranTeachingLessonTapPiecesHint
                  : buildSelection.join('  '),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, fontFamily: 'AmiriQuran'),
            ),
          ),
        ] else if (quiz.type == QuranTeachingQuizType.trueFalse) ...[
          LayoutBuilder(
            builder: (context, constraints) {
              final compactChoices = constraints.maxWidth < 380;
              if (compactChoices) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.quranTeachingDailyReviewTrue),
                      selected: selectedTrueFalse == true,
                      onSelected: (_) => onSelectTrueFalse(true),
                    ),
                    const SizedBox(height: 10),
                    ChoiceChip(
                      label: Text(l10n.quranTeachingDailyReviewFalse),
                      selected: selectedTrueFalse == false,
                      onSelected: (_) => onSelectTrueFalse(false),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Text(l10n.quranTeachingDailyReviewTrue),
                      selected: selectedTrueFalse == true,
                      onSelected: (_) => onSelectTrueFalse(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: Text(l10n.quranTeachingDailyReviewFalse),
                      selected: selectedTrueFalse == false,
                      onSelected: (_) => onSelectTrueFalse(false),
                    ),
                  ),
                ],
              );
            },
          ),
        ] else ...[
          ...quiz.options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onSelectOption(option.id),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selectedOptionId == option.id
                          ? Theme.of(context).colorScheme.primary
                          : context.palette.surfaceSoft,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (option.icon != null) ...[
                        Icon(option.icon),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (option.arabic != null)
                              Text(
                                option.arabic!,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontFamily: 'AmiriQuran',
                                ),
                              ),
                            Text(option.label),
                            if (option.secondaryLabel != null)
                              Text(
                                option.secondaryLabel!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        if (feedback != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: (wasCorrect == true ? Colors.green : Colors.red)
                  .withValues(alpha: 0.10),
            ),
            child: Text(feedback!),
          ),
        ],
      ],
    );
  }
}

QuranTeachingLesson? _nextLessonInModule(
  QuranTeachingCatalog catalog,
  QuranTeachingModule module,
  QuranTeachingLesson lesson,
) {
  final lessons = catalog.lessonsForModule(module.id);
  final index = lessons.indexWhere((item) => item.id == lesson.id);
  if (index < 0 || index + 1 >= lessons.length) {
    return null;
  }
  return lessons[index + 1];
}

ArabicAlphabetLetter? _sharedLetterForStep(QuranTeachingStep step) {
  switch (step.type) {
    case QuranTeachingStepType.letterIntroduction:
      return arabicAlphabetLetterByQuranTeachingSeedId(step.id);
    case QuranTeachingStepType.letterShapes:
      if (step.id.startsWith('shape_')) {
        return arabicAlphabetLetterById(step.id.substring('shape_'.length));
      }
      return null;
    case QuranTeachingStepType.harakat:
    case QuranTeachingStepType.wordFormation:
    case QuranTeachingStepType.rule:
    case QuranTeachingStepType.phrase:
      return null;
  }
}

class _SharedLetterSupportCard extends StatelessWidget {
  const _SharedLetterSupportCard({required this.letter});

  final ArabicAlphabetLetter letter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: context.palette.surfaceSoft.withValues(alpha: 0.45),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranTeachingLessonLetterProfileTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            '${letter.nameAr} • ${letter.adultNameEn}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.quranTeachingLessonSoundHintLabel(letter.soundHint),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.quranTeachingLessonFormsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final compactGrid = constraints.maxWidth < 360;
              return GridView.count(
                crossAxisCount: compactGrid ? 1 : 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: compactGrid ? 3.8 : 2.1,
                children: [
                  _LetterFormTile(
                    label: l10n.quranTeachingLessonFormIsolated,
                    glyph: letter.positionalForms.isolated,
                  ),
                  _LetterFormTile(
                    label: l10n.quranTeachingLessonFormInitial,
                    glyph:
                        letter.positionalForms.initial ??
                        l10n.quranTeachingLessonFormUnavailable,
                  ),
                  _LetterFormTile(
                    label: l10n.quranTeachingLessonFormMedial,
                    glyph:
                        letter.positionalForms.medial ??
                        l10n.quranTeachingLessonFormUnavailable,
                  ),
                  _LetterFormTile(
                    label: l10n.quranTeachingLessonFormFinal,
                    glyph:
                        letter.positionalForms.finalForm ??
                        l10n.quranTeachingLessonFormUnavailable,
                  ),
                ],
              );
            },
          ),
          if (!letter.joiningBehavior.joinsToNext) ...[
            const SizedBox(height: 10),
            Text(
              l10n.quranTeachingLessonNoForwardJoinHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.palette.onSurfaceSubtle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LetterFormTile extends StatelessWidget {
  const _LetterFormTile({required this.label, required this.glyph});

  final String label;
  final String glyph;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.palette.onSurfaceSubtle,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            glyph,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 26, fontFamily: 'AmiriQuran'),
          ),
        ],
      ),
    );
  }
}
