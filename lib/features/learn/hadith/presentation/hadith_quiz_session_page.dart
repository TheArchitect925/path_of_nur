import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/reward_feedback.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_references.dart';
import '../application/hadith_path_quiz_service.dart';
import '../domain/hadith_quiz_models.dart';

class HadithQuizSessionPage extends ConsumerStatefulWidget {
  const HadithQuizSessionPage.chapter({
    super.key,
    required this.pathId,
    required this.chapterId,
  }) : mode = HadithQuizPageMode.chapter,
       reviewMode = null,
       themeId = null;

  const HadithQuizSessionPage.review({
    super.key,
    required this.reviewMode,
    this.pathId,
    this.themeId,
  }) : mode = HadithQuizPageMode.review,
       chapterId = null;

  final HadithQuizPageMode mode;
  final HadithReviewQuizMode? reviewMode;
  final String? pathId;
  final String? chapterId;
  final String? themeId;

  @override
  ConsumerState<HadithQuizSessionPage> createState() =>
      _HadithQuizSessionPageState();
}

enum HadithQuizPageMode { chapter, review }

class _HadithQuizSessionPageState extends ConsumerState<HadithQuizSessionPage> {
  int _index = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _showFeedback = false;
  bool _submitting = false;
  HadithQuizSubmissionOutcome? _outcome;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = _resolveSession();
    final title = widget.mode == HadithQuizPageMode.chapter
        ? l10n.learnQuizzesChapterQuizGroup
        : l10n.batch9HadithReviewQuizTitle;

    if (session == null) {
      return AppPageScaffold(
        title: title,
        children: [PremiumCard(child: Text(l10n.batch9HadithQuizUnavailable))],
      );
    }

    if (_outcome != null) {
      return _buildResult(context, session, _outcome!);
    }

    final question = session.questions[_index];
    final progress = (_index + 1) / session.questions.length;

    return AppPageScaffold(
      title: session.title,
      subtitle: session.subtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.batch9QuestionProgress(
                  '${_index + 1}',
                  '${session.questions.length}',
                ),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ProgressBar(value: progress, height: 7),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: context.palette.surface.withValues(alpha: 0.2),
                      border: Border.all(
                        color: context.palette.accentSoft.withValues(
                          alpha: 0.28,
                        ),
                      ),
                    ),
                    child: Text(
                      question.type.label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                question.text,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final isSelected = _selectedIndex == optionIndex;
                final isCorrect = option == question.correctAnswer;

                Color? tileColor;
                Color? borderColor;
                if (_showFeedback && isCorrect) {
                  tileColor = Colors.green.withValues(alpha: 0.14);
                  borderColor = Colors.green.withValues(alpha: 0.40);
                } else if (_showFeedback && isSelected && !isCorrect) {
                  tileColor = Colors.red.withValues(alpha: 0.14);
                  borderColor = Colors.red.withValues(alpha: 0.42);
                } else {
                  tileColor = context.palette.surface.withValues(alpha: 0.2);
                  borderColor = context.palette.accentSoft.withValues(
                    alpha: 0.24,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _showFeedback
                        ? null
                        : () => setState(() {
                            _selectedIndex = optionIndex;
                          }),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: tileColor,
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 18,
                            color: isSelected
                                ? context.palette.onSurface
                                : context.palette.onSurfaceSubtle,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(option)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 4),
              if (_showFeedback) ...[
                Text(
                  question.explanation,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _submitting
                      ? null
                      : _showFeedback
                      ? () => _nextQuestion(session)
                      : (_selectedIndex == null
                            ? null
                            : () => _submitAnswer(question)),
                  icon: Icon(
                    _showFeedback
                        ? (_index == session.questions.length - 1
                              ? Icons.flag_rounded
                              : Icons.arrow_forward_rounded)
                        : Icons.check_rounded,
                  ),
                  label: Text(
                    _showFeedback
                        ? (_index == session.questions.length - 1
                              ? l10n.batch9FinishQuizAction
                              : l10n.batch9NextQuestionAction)
                        : l10n.batch9SubmitAnswerAction,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResult(
    BuildContext context,
    HadithQuizSession session,
    HadithQuizSubmissionOutcome outcome,
  ) {
    final l10n = AppLocalizations.of(context);
    final result = outcome.result;
    final total = result.total;
    final percent = total <= 0 ? 0 : ((result.score / total) * 100).round();

    return AppPageScaffold(
      title: l10n.batch9QuizResultsTitle,
      subtitle: session.title,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.batch9HadithQuizResultHeadline(
                  '${result.score}',
                  '$total',
                  '$percent',
                ),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(result.encouragement),
              const SizedBox(height: 10),
              Text(
                buildCompactRewardSummary(l10n, xp: result.xpAwarded, drops: 0),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
              if (result.chapterMilestoneUnlocked ||
                  result.pathMilestoneUnlocked) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (result.chapterMilestoneUnlocked)
                      _milestoneChip(l10n.batch9ChapterCompleted),
                    if (result.pathMilestoneUnlocked)
                      _milestoneChip(l10n.batch9PathCompletionMilestone),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.batch9QuranReflectionVerseTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              LearningReferences(
                items: [
                  LearningReferenceItem(
                    sourceTitle: result.quranReflection.surahName,
                    sourceNumber: result.quranReflection.surahNumber,
                    rangeOrSection: result.quranReflection.verseRange,
                    label: result.quranReflection.label,
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
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _restart,
                  icon: const Icon(Icons.replay_rounded),
                  label: Text(l10n.batch9RetryQuizAction),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    final lessonId = session.questions.first.lessonId;
                    context.pushNamed(
                      'hadithLessonDetail',
                      pathParameters: {'lessonId': lessonId},
                    );
                  },
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(l10n.batch9ReviewRelatedLessonAction),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _milestoneChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.palette.surface.withValues(alpha: 0.26),
        border: Border.all(
          color: context.palette.accentSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(text),
    );
  }

  HadithQuizSession? _resolveSession() {
    if (widget.mode == HadithQuizPageMode.chapter) {
      final pathId = widget.pathId;
      final chapterId = widget.chapterId;
      if (pathId == null || chapterId == null) return null;
      final status = ref.watch(
        hadithChapterQuizStatusProvider((pathId: pathId, chapterId: chapterId)),
      );
      if (!status.unlocked || status.quiz == null) return null;
      final quiz = status.quiz!;
      return HadithQuizSession(
        id: quiz.id,
        title: quiz.title,
        subtitle: quiz.description,
        questions: quiz.questions,
        quranReflection: quiz.quranReflection,
        pathId: quiz.pathId,
        chapterId: quiz.chapterId,
      );
    }

    final mode = widget.reviewMode;
    if (mode == null) return null;
    return buildHadithReviewSession(
      ref,
      mode: mode,
      themeId: widget.themeId,
      pathId: widget.pathId,
      questionCount: 5,
    );
  }

  void _submitAnswer(HadithQuizQuestion question) {
    final selected = _selectedIndex;
    if (selected == null) return;

    final selectedText = question.options[selected];
    setState(() {
      _showFeedback = true;
      if (selectedText == question.correctAnswer) {
        _score += 1;
      }
    });
  }

  Future<void> _nextQuestion(HadithQuizSession session) async {
    if (_index < session.questions.length - 1) {
      setState(() {
        _index += 1;
        _selectedIndex = null;
        _showFeedback = false;
      });
      return;
    }

    setState(() {
      _submitting = true;
    });

    final outcome = await submitHadithQuizSession(
      ref,
      session: session,
      score: _score,
      isWeekly: widget.reviewMode == HadithReviewQuizMode.weekly,
    );

    if (!mounted) return;
    setState(() {
      _outcome = outcome;
      _submitting = false;
    });
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _selectedIndex = null;
      _showFeedback = false;
      _submitting = false;
      _outcome = null;
    });
  }
}
