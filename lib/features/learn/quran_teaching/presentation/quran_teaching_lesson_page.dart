import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/quran_teaching_asset_resolver.dart';
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
    final totalPages =
        widget.lesson.steps.length + widget.lesson.quizzes.length;
    final currentPage = _inQuiz
        ? widget.lesson.steps.length + _quizIndex + 1
        : _stepIndex + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          IconButton(
            onPressed: () {
              final catalog = ref.read(quranTeachingCatalogProvider);
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
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.module.title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                ),
                Text('$currentPage / $totalPages'),
              ],
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
        ),
      ),
    );
  }

  void _playAudio(QuranAudioCue audio) {
    final l10n = AppLocalizations.of(context);
    QuranTeachingAssetResolver.resolveAudioPath(audio).then((path) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            path == null
                ? l10n.batch9AudioNotAddedYet(audio.label)
                : l10n.batch9AudioReady(audio.label),
          ),
        ),
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lesson complete',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(widget.lesson.title),
              const SizedBox(height: 12),
              Text(
                widget.lesson.quizzes.isEmpty
                    ? 'You finished the lesson. The next one is ready when you are.'
                    : 'Quiz score: ${(score * 100).round()}%',
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(this.context).pop(true);
                },
                child: const Text('Back to module'),
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
            color: AppColors.surfaceSoft.withValues(alpha: 0.65),
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
        if (step.sourceReference != null) ...[
          const SizedBox(height: 8),
          Text(
            'Source: ${step.sourceReference}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceSubtle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (step.helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            step.helperText!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
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
                label: 'Hear this',
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
            'Examples',
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
                    border: Border.all(color: AppColors.surfaceSoft),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
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
                                  'Source: ${example.verseReference}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.onSurfaceSubtle,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            if (visualModeEnabled &&
                                example.visualAnchor != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  '${example.visualAnchor!.label} • ${example.visualAnchor!.hint}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.onSurfaceSubtle,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (example.audio != null)
                        QuranTeachingAudioIconButton(
                          audio: example.audio,
                          availableIcon: Icons.volume_up_rounded,
                          onAvailablePressed: () => onPlayAudio(example.audio!),
                        ),
                    ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quick quiz',
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
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
        ],
        if (quiz.audio != null) ...[
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => onPlayAudio(quiz.audio!),
            icon: const Icon(Icons.volume_up_rounded),
            label: const Text('Hear audio'),
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
              border: Border.all(color: AppColors.surfaceSoft),
            ),
            child: Text(
              buildSelection.isEmpty
                  ? 'Tap the pieces in order.'
                  : buildSelection.join('  '),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, fontFamily: 'AmiriQuran'),
            ),
          ),
        ] else if (quiz.type == QuranTeachingQuizType.trueFalse) ...[
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('True'),
                  selected: selectedTrueFalse == true,
                  onSelected: (_) => onSelectTrueFalse(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Text('False'),
                  selected: selectedTrueFalse == false,
                  onSelected: (_) => onSelectTrueFalse(false),
                ),
              ),
            ],
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
                          : AppColors.surfaceSoft,
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
