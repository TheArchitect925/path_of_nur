import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_experience_provider.dart';
import '../application/kids_dua_my_day_provider.dart';
import '../application/kids_dua_my_day_practice_service.dart';
import '../application/kids_dua_progress_provider.dart';
import '../application/kids_dua_repository.dart';
import '../application/kids_dua_story_repository.dart';
import '../domain/kids_dua_models.dart';

class KidsDuaLessonPage extends ConsumerStatefulWidget {
  const KidsDuaLessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<KidsDuaLessonPage> createState() => _KidsDuaLessonPageState();
}

class _KidsDuaLessonPageState extends ConsumerState<KidsDuaLessonPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kidsDuaLearningProvider.notifier).openLesson(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lesson = ref.watch(kidsDuaLessonByIdProvider(widget.lessonId));
    final nextLesson = ref.watch(
      kidsDuaNextLessonByIdProvider(widget.lessonId),
    );
    final stories = ref.watch(kidsDuaStoriesForLessonProvider(widget.lessonId));
    final progress = ref
        .watch(kidsDuaLearningProvider)
        .progressByLessonId[widget.lessonId];
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.routerNotFoundTitle)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          _HeroCard(lesson: lesson),
          const SizedBox(height: 12),
          _InfoCard(title: l10n.kidsDuaMeaningSection, body: lesson.meaning),
          const SizedBox(height: 12),
          _InfoCard(
            title: l10n.kidsDuaMiniLessonSection,
            body: lesson.miniLesson,
          ),
          const SizedBox(height: 12),
          _InfoCard(title: l10n.kidsDuaWhenSection, body: lesson.whenToSay),
          const SizedBox(height: 12),
          _ChunksCard(lesson: lesson),
          const SizedBox(height: 12),
          _ActionCard(
            lesson: lesson,
            isLearned: progress?.status == KidsDuaLessonStatus.learned,
            hasStory: stories.isNotEmpty,
            onPractice: () => context.pushNamed('kidsDuaPractice'),
            onStory: stories.isEmpty
                ? null
                : () => context.pushNamed(
                    'kidsDuaStoryPlayer',
                    pathParameters: {'storyId': stories.first.id},
                  ),
            onDraw: () => context.pushNamed(
              'kidsDuaDrawing',
              pathParameters: {'lessonId': lesson.id},
            ),
            onComplete: () {
              final result = ref
                  .read(kidsDuaLearningProvider.notifier)
                  .completeLesson(lesson.id);
              final myDayResult = ref
                  .read(kidsDuaMyDayProvider.notifier)
                  .completeDuaForToday(lesson.id);
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                builder: (context) => _CompletionSheet(
                  lesson: lesson,
                  nextLesson: nextLesson,
                  result: result,
                  myDayResult: myDayResult,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _SourceCard(lesson: lesson),
          const SizedBox(height: 12),
          if (progress != null) _ProgressCard(progress: progress),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.lesson});

  final KidsDuaLessonContent lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7D7BE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(lesson.icon, color: const Color(0xFF8A6A45)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              lesson.arabic,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 30,
                height: 1.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            lesson.transliteration,
            style: const TextStyle(fontSize: 16, color: Color(0xFF655A4C)),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.lesson,
    required this.isLearned,
    required this.hasStory,
    required this.onPractice,
    required this.onStory,
    required this.onDraw,
    required this.onComplete,
  });

  final KidsDuaLessonContent lesson;
  final bool isLearned;
  final bool hasStory;
  final VoidCallback onPractice;
  final VoidCallback? onStory;
  final VoidCallback onDraw;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.miniLesson,
            style: const TextStyle(color: Color(0xFF655A4C), height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: lesson.audioAssetPath.isNotEmpty ? () {} : null,
                  icon: const Icon(Icons.volume_up_rounded),
                  label: Text(
                    lesson.audioAssetPath.isNotEmpty
                        ? l10n.kidsDuaPlayAudioAction
                        : l10n.kidsDuaAudioComingSoon,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPractice,
                  icon: const Icon(Icons.quiz_rounded),
                  label: Text(l10n.kidsDuaPracticeTitle),
                ),
              ),
            ],
          ),
          if (hasStory) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onStory,
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(l10n.kidsDuaStoriesAction),
              ),
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onDraw,
              icon: const Icon(Icons.brush_rounded),
              label: Text(l10n.kidsDuaDrawAction),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onComplete,
              child: Text(
                isLearned
                    ? l10n.kidsDuaCompleteAgainAction
                    : l10n.kidsDuaCompleteLessonAction,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChunksCard extends StatelessWidget {
  const _ChunksCard({required this.lesson});

  final KidsDuaLessonContent lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaRepeatAfterMeSection,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...lesson.phraseChunks.map(
            (chunk) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      chunk.arabic,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    chunk.transliteration,
                    style: const TextStyle(color: Color(0xFF655A4C)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF554C42),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress});

  final KidsDuaLessonProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: Row(
        children: [
          Expanded(
            child: _MiniStat(
              label: l10n.kidsDuaStatusInProgress,
              value: '${progress.openCount}',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MiniStat(
              label: l10n.kidsDuaPracticeTitle,
              value: '${progress.timesPracticed}',
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF655A4C))),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.lesson});

  final KidsDuaLessonContent lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Frame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaSourceSection,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '${lesson.sourceType} • ${lesson.sourceReference}',
            style: const TextStyle(color: Color(0xFF655A4C)),
          ),
        ],
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: child,
    );
  }
}

class _CompletionSheet extends ConsumerStatefulWidget {
  const _CompletionSheet({
    required this.lesson,
    required this.nextLesson,
    required this.result,
    required this.myDayResult,
  });

  final KidsDuaLessonContent lesson;
  final KidsDuaLessonContent? nextLesson;
  final KidsDuaCompletionResult result;
  final KidsDuaMyDayCompletionResult myDayResult;

  @override
  ConsumerState<_CompletionSheet> createState() => _CompletionSheetState();
}

class _CompletionSheetState extends ConsumerState<_CompletionSheet> {
  List<KidsDuaPracticeQuestion> _questions = const <KidsDuaPracticeQuestion>[];
  int _questionIndex = 0;
  int _correctAnswers = 0;
  int? _selectedIndex;
  bool _submitted = false;
  bool _practiceFinished = false;
  KidsDuaPracticeResult? _practiceResult;
  int _bonusXpAwarded = 0;
  int _bonusDropsAwarded = 0;

  @override
  void initState() {
    super.initState();
    final lessons = ref.read(kidsDuaLessonsProvider);
    final state = ref.read(kidsDuaLearningProvider);
    final practiceService = ref.read(kidsDuaMyDayPracticeServiceProvider);
    _questions = widget.myDayResult.dayCompletedNow
        ? practiceService.recapQuestionsForDay(
            completedDuaIds: ref.read(kidsDuaMyDayProvider).completedDuaIds,
            lessons: lessons,
            state: state,
          )
        : [
            if (practiceService.questionAfterLesson(
                  lesson: widget.lesson,
                  lessons: lessons,
                  state: state,
                ) !=
                null)
              practiceService.questionAfterLesson(
                lesson: widget.lesson,
                lessons: lessons,
                state: state,
              )!,
          ];
  }

  KidsDuaPracticeQuestion get _currentQuestion => _questions[_questionIndex];

  void _handleAnswer() {
    final isCorrect = _selectedIndex == _currentQuestion.correctIndex;
    if (!_submitted) {
      setState(() {
        _submitted = true;
        if (isCorrect) _correctAnswers += 1;
      });
      return;
    }
    if (!isCorrect) {
      setState(() {
        _submitted = false;
        _selectedIndex = null;
      });
      return;
    }
    if (_questionIndex + 1 < _questions.length) {
      setState(() {
        _questionIndex += 1;
        _selectedIndex = null;
        _submitted = false;
      });
      return;
    }
    final practiceResult = ref
        .read(kidsDuaLearningProvider.notifier)
        .recordPracticeSession(
          practicedLessonIds: _questions
              .map((question) => question.relatedDuaId)
              .toSet()
              .toList(growable: false),
          correctAnswers: _correctAnswers,
          totalQuestions: _questions.length,
        );
    var bonusXp = 0;
    var bonusDrops = 0;
    if (widget.myDayResult.dayCompletedNow) {
      final bonus = ref
          .read(kidsDuaLearningProvider.notifier)
          .awardEmbeddedPracticeBonus(
            xp: kidsDuaMyDayRecapXpBonus,
            drops: kidsDuaMyDayRecapDropsBonus,
            referenceId:
                'kids_dua_my_day_recap_${ref.read(kidsDuaMyDayProvider).date}',
          );
      bonusXp = bonus.xpAwarded;
      bonusDrops = bonus.oceanDropsAwarded;
    }
    setState(() {
      _practiceFinished = true;
      _practiceResult = practiceResult;
      _bonusXpAwarded = bonusXp;
      _bonusDropsAwarded = bonusDrops;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaCompletionCelebrateTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.kidsDuaCompletionCelebrateBody(widget.lesson.title),
            style: const TextStyle(color: Color(0xFF655A4C)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _RewardPill(
                label: l10n.kidsDuaCompletionXpValue(widget.result.xpAwarded),
              ),
              _RewardPill(
                label: l10n.kidsDuaCompletionDropsValue(
                  widget.result.oceanDropsAwarded,
                ),
              ),
              if (widget.myDayResult.dayCompletedNow)
                _RewardPill(
                  label: l10n.kidsDuaMyDayCompleteRewardValue(
                    widget.myDayResult.xpAwarded,
                    widget.myDayResult.oceanDropsAwarded,
                  ),
                ),
              if (widget.result.newStickerIds.isNotEmpty)
                _RewardPill(
                  label: l10n.kidsDuaStickerUnlockedValue(
                    widget.result.newStickerIds.length,
                  ),
                ),
              if (widget.result.newRewardIds.isNotEmpty)
                _RewardPill(
                  label: l10n.kidsDuaCompletionRewardsValue(
                    widget.result.newRewardIds.length,
                  ),
                ),
            ],
          ),
          if (widget.myDayResult.dayCompletedNow) ...[
            const SizedBox(height: 10),
            Text(
              l10n.kidsDuaMyDayCompleteBody,
              style: const TextStyle(color: Color(0xFF655A4C)),
            ),
          ],
          if (_questions.isNotEmpty) ...[
            const SizedBox(height: 16),
            if (!_practiceFinished) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EF),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE7D7BE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.myDayResult.dayCompletedNow
                          ? l10n.kidsDuaMyDayQuestionRecapTitle
                          : l10n.kidsDuaMyDayQuestionTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _questionPrompt(l10n, _currentQuestion),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._currentQuestion.options.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: _submitted
                              ? null
                              : () =>
                                    setState(() => _selectedIndex = entry.key),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color:
                                    _submitted &&
                                        entry.key ==
                                            _currentQuestion.correctIndex
                                    ? const Color(0xFF78A65A)
                                    : (_selectedIndex == entry.key
                                          ? const Color(0xFFB58B4D)
                                          : const Color(0xFFE8DDD0)),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: _selectedIndex == null ? null : _handleAnswer,
                      child: Text(
                        _submitted
                            ? (_selectedIndex == _currentQuestion.correctIndex
                                  ? l10n.kidsDuaMyDayQuestionContinueAction
                                  : l10n.kidsDuaMyDayQuestionTryAction)
                            : l10n.kidsDuaPracticeCheckAction,
                      ),
                    ),
                    if (_submitted) ...[
                      const SizedBox(height: 10),
                      Text(
                        _selectedIndex == _currentQuestion.correctIndex
                            ? l10n.kidsDuaMyDayQuestionMashaAllah
                            : l10n.kidsDuaMyDayQuestionTryAgain,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6D6255),
                        ),
                      ),
                      if (_currentQuestion.explanation != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _currentQuestion.explanation!,
                          style: const TextStyle(
                            color: Color(0xFF6D6255),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ] else ...[
              if (widget.myDayResult.dayCompletedNow) ...[
                Text(
                  l10n.kidsDuaMyDayRecapCompleteTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.kidsDuaMyDayRecapCompleteBody(
                    _practiceResult?.correctAnswers ?? 0,
                    _practiceResult?.totalQuestions ?? 0,
                  ),
                  style: const TextStyle(color: Color(0xFF655A4C)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if ((_practiceResult?.correctAnswers ?? 0) > 0)
                      _RewardPill(
                        label: l10n.kidsDuaCompletionXpValue(kidsDuaPracticeXp),
                      ),
                    if (_bonusXpAwarded > 0 || _bonusDropsAwarded > 0)
                      _RewardPill(
                        label: l10n.kidsDuaMyDayRecapBonusValue(
                          _bonusXpAwarded,
                          _bonusDropsAwarded,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
              ] else ...[
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.goNamed('kidsDuaMyDay');
                  },
                  child: Text(l10n.kidsDuaMyDayQuestionBackToDayAction),
                ),
              ),
              if (widget.nextLesson != null &&
                  !widget.myDayResult.dayCompletedNow) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushReplacementNamed(
                        'kidsDuaLesson',
                        pathParameters: {'lessonId': widget.nextLesson!.id},
                      );
                    },
                    child: Text(l10n.kidsDuaNextDuaAction),
                  ),
                ),
              ],
            ],
          ] else ...[
            const SizedBox(height: 16),
            if (widget.nextLesson != null)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pushReplacementNamed(
                      'kidsDuaLesson',
                      pathParameters: {'lessonId': widget.nextLesson!.id},
                    );
                  },
                  child: Text(l10n.kidsDuaNextDuaAction),
                ),
              ),
            if (widget.nextLesson != null) const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.goNamed('kidsDuaMyDay');
                    },
                    child: Text(l10n.kidsDuaMyDayQuestionBackToDayAction),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.goNamed(
                        'kidsDuaCategory',
                        pathParameters: {
                          'categoryId': widget.lesson.categoryId,
                        },
                      );
                    },
                    child: Text(l10n.kidsDuaBackToCategoryAction),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5D7BC)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

String _questionPrompt(
  AppLocalizations l10n,
  KidsDuaPracticeQuestion question,
) {
  switch (question.type) {
    case KidsDuaPracticeQuestionType.matchSituation:
      return l10n.kidsDuaMyDayMatchPrompt(question.prompt);
    case KidsDuaPracticeQuestionType.meaning:
      return l10n.kidsDuaMyDayMeaningPrompt(question.prompt);
    case KidsDuaPracticeQuestionType.behavior:
      return question.prompt;
  }
}
