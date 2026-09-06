import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/reward_feedback.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progression.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../domain/kids_arabic_models.dart';
import '../widgets/kids_arabic_audio_learning_widgets.dart';

enum _KidsArabicReviewMode { matchLetterToSound, tapCorrectLetter }

const int _questionsPerRound = 5;

class KidsArabicReviewPage extends ConsumerStatefulWidget {
  const KidsArabicReviewPage({super.key});

  @override
  ConsumerState<KidsArabicReviewPage> createState() =>
      _KidsArabicReviewPageState();
}

class _KidsArabicReviewPageState extends ConsumerState<KidsArabicReviewPage> {
  _KidsArabicReviewMode _mode = _KidsArabicReviewMode.matchLetterToSound;
  int _questionIndex = 0;
  int _correctAnswers = 0;
  bool? _lastAnswerCorrect;
  KidsArabicDailyMissionCompletionResult? _dailyMissionResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(kidsArabicProgressProvider);
    final dailyMission = ref.watch(kidsArabicDailyMissionProvider);
    final parentReviewLetter = ref.watch(kidsArabicParentReviewLetterProvider);
    final pool = _reviewPool(progress, dailyMission, parentReviewLetter);

    if (pool.length < 2) {
      // A quiz over one letter has one answer. Invite the next lesson instead
      // of pretending to ask a question.
      return LearnHubPageScaffold(
        title: l10n.kidsArabicReviewTitle,
        subtitle: l10n.kidsArabicReviewSubtitle,
        children: [
          _ReviewNeedsLettersCard(nextLetter: _nextLetterToLearn(progress)),
        ],
      );
    }

    final target = pool[_questionIndex % pool.length];
    final options = _optionsFor(target, pool, _questionIndex);
    final finished = _questionIndex >= _questionsPerRound;

    return LearnHubPageScaffold(
      title: l10n.kidsArabicReviewTitle,
      subtitle: l10n.kidsArabicReviewSubtitle,
      children: [
        SegmentedButton<_KidsArabicReviewMode>(
          segments: [
            ButtonSegment(
              value: _KidsArabicReviewMode.matchLetterToSound,
              label: Text(l10n.kidsArabicReviewModeMatchSound),
            ),
            ButtonSegment(
              value: _KidsArabicReviewMode.tapCorrectLetter,
              label: Text(l10n.kidsArabicReviewModeTapCorrectLetter),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: (selection) {
            setState(() {
              _mode = selection.first;
              _questionIndex = 0;
              _correctAnswers = 0;
              _lastAnswerCorrect = null;
              _dailyMissionResult = null;
            });
          },
        ),
        const SizedBox(height: 16),
        if (_lastAnswerCorrect != null) ...[
          _ReviewFeedbackBanner(
            label: _lastAnswerCorrect!
                ? l10n.kidsArabicReviewCorrectFeedback
                : l10n.kidsArabicReviewRetryFeedback,
            positive: _lastAnswerCorrect!,
          ),
          const SizedBox(height: 12),
        ],
        if (finished)
          _ReviewSummaryCard(
            correctAnswers: _correctAnswers,
            totalQuestions: _questionsPerRound,
            dailyMissionResult: _dailyMissionResult,
          )
        else
          _ReviewQuestionCard(
            mode: _mode,
            target: target,
            options: options,
            questionNumber: _questionIndex + 1,
            totalQuestions: _questionsPerRound,
            onListen: () =>
                ref.read(kidsArabicAudioServiceProvider).speakLetter(target),
            onAnswer: (selected) {
              final correct = selected.id == target.id;
              ref
                  .read(kidsArabicProgressProvider.notifier)
                  .recordReviewAnswer(letterId: target.id, correct: correct);
              final dailyResult = correct && dailyMission != null
                  ? ref
                        .read(kidsArabicProgressProvider.notifier)
                        .completeDailyReviewMissionIfEligible(
                          targetLetterId: target.id,
                        )
                  : null;
              setState(() {
                _lastAnswerCorrect = correct;
                if (correct) _correctAnswers += 1;
                _questionIndex += 1;
                _dailyMissionResult ??= dailyResult;
              });
            },
          ),
      ],
    );
  }

  /// Letters the child has finished, the parent's or the day's review letter
  /// first. Never a letter the child has not met: a quiz cannot ask about it.
  List<KidsArabicLetter> _reviewPool(
    KidsArabicProgressState progress,
    KidsArabicDailyMission? dailyMission,
    KidsArabicLetter? parentReviewLetter,
  ) {
    final completed = kidsArabicProgressionLetters
        .where((letter) => progress.completedLetterIds.contains(letter.id))
        .toList(growable: false);
    return _prioritizeTargets(completed, dailyMission, parentReviewLetter);
  }

  KidsArabicLetter _nextLetterToLearn(KidsArabicProgressState progress) {
    final unlocked = unlockedKidsArabicLetterIds(progress.completedLetterIds);
    for (final letter in kidsArabicProgressionLetters) {
      if (unlocked.contains(letter.id) &&
          !progress.completedLetterIds.contains(letter.id)) {
        return letter;
      }
    }
    return kidsArabicProgressionLetters.first;
  }

  List<KidsArabicLetter> _prioritizeTargets(
    List<KidsArabicLetter> letters,
    KidsArabicDailyMission? dailyMission,
    KidsArabicLetter? parentReviewLetter,
  ) {
    final targetIds = <String>[
      if (parentReviewLetter != null) parentReviewLetter.id,
      if (dailyMission != null &&
          dailyMission.type == KidsArabicDailyMissionType.review)
        dailyMission.targetLetterId,
    ];
    var ordered = letters;
    for (final targetId in targetIds.reversed) {
      final index = ordered.indexWhere((letter) => letter.id == targetId);
      if (index > 0) {
        ordered = <KidsArabicLetter>[
          ordered[index],
          ...ordered.take(index),
          ...ordered.skip(index + 1),
        ];
      }
    }
    return ordered;
  }

  /// Up to four options: the target and three other learned letters, with
  /// the target's position moving from question to question so the right
  /// answer is never simply the first chip.
  List<KidsArabicLetter> _optionsFor(
    KidsArabicLetter target,
    List<KidsArabicLetter> pool,
    int questionIndex,
  ) {
    final rest = pool
        .where((letter) => letter.id != target.id)
        .toList(growable: false);
    final picked = <KidsArabicLetter>[];
    for (var i = 0; i < rest.length && picked.length < 3; i += 1) {
      final candidate = rest[(questionIndex + i * 3) % rest.length];
      if (!picked.contains(candidate)) picked.add(candidate);
    }
    for (final letter in rest) {
      if (picked.length >= 3) break;
      if (!picked.contains(letter)) picked.add(letter);
    }
    final options = <KidsArabicLetter>[target, ...picked];
    final shift = questionIndex % options.length;
    return <KidsArabicLetter>[
      ...options.sublist(options.length - shift),
      ...options.sublist(0, options.length - shift),
    ];
  }
}

class _ReviewNeedsLettersCard extends StatelessWidget {
  const _ReviewNeedsLettersCard({required this.nextLetter});

  final KidsArabicLetter nextLetter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.palette.surfaceSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  nextLetter.glyph,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: AppFonts.arabicLearning,
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.kidsArabicReviewNeedsLettersTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.kidsArabicReviewNeedsLettersBody(nextLetter.nameEn),
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.pushNamed(
                'kidsArabicLesson',
                pathParameters: {'letterId': nextLetter.id},
              ),
              child: Text(
                l10n.kidsArabicReviewNeedsLettersAction(nextLetter.nameEn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewQuestionCard extends StatelessWidget {
  const _ReviewQuestionCard({
    required this.mode,
    required this.target,
    required this.options,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onListen,
    required this.onAnswer,
  });

  final _KidsArabicReviewMode mode;
  final KidsArabicLetter target;
  final List<KidsArabicLetter> options;
  final int questionNumber;
  final int totalQuestions;
  final Future<void> Function() onListen;
  final ValueChanged<KidsArabicLetter> onAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final showsGlyph = mode == _KidsArabicReviewMode.matchLetterToSound;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicQuestionCounter(questionNumber, totalQuestions),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showsGlyph
                ? l10n.kidsArabicReviewQuestionMatchSound(target.glyph)
                : l10n.kidsArabicReviewQuestionTapCorrect(
                    target.transliteration,
                  ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          // The letter the question is about, big enough to be the point of
          // the card, and a way to hear it in either mode.
          if (showsGlyph) ...[
            Center(
              child: InkWell(
                onTap: onListen,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.palette.surfaceSoft,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    target.glyph,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 64,
                      fontFamily: AppFonts.arabicLearning,
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Center(
            child: KidsArabicAudioChipButton(
              label: l10n.kidsArabicPronunciationAction,
              onPlay: onListen,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options
                .map(
                  (option) => InkWell(
                    onTap: () => onAnswer(option),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 156,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: context.palette.surfaceSoft),
                      ),
                      child: Center(
                        child: Text(
                          showsGlyph ? option.transliteration : option.glyph,
                          textDirection: showsGlyph ? null : TextDirection.rtl,
                          style: TextStyle(
                            fontSize: showsGlyph ? 18 : 34,
                            fontFamily: showsGlyph
                                ? null
                                : AppFonts.arabicLearning,
                            fontWeight: FontWeight.w700,
                            color: context.palette.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _ReviewFeedbackBanner extends StatelessWidget {
  const _ReviewFeedbackBanner({required this.label, required this.positive});

  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: positive
            ? context.palette.success.withValues(alpha: 0.25)
            : const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: positive
              ? context.palette.success.withValues(alpha: 0.45)
              : context.palette.surfaceSoft,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: positive
              ? context.palette.successInk
              : context.palette.onSurfaceSubtle,
        ),
      ),
    );
  }
}

class _ReviewSummaryCard extends StatelessWidget {
  const _ReviewSummaryCard({
    required this.correctAnswers,
    required this.totalQuestions,
    this.dailyMissionResult,
  });

  final int correctAnswers;
  final int totalQuestions;
  final KidsArabicDailyMissionCompletionResult? dailyMissionResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.success.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.palette.success.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicReviewFinishedTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.kidsArabicReviewFinishedSubtitle(
              correctAnswers,
              totalQuestions,
            ),
            style: const TextStyle(color: Color(0xFF4A5E32), height: 1.35),
          ),
          if (dailyMissionResult != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.kidsArabicDailyMissionCompletedTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.palette.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.kidsArabicDailyMissionCompletedSubtitle(
                dailyMissionResult!.currentStreak,
              ),
              style: const TextStyle(color: Color(0xFF4A5E32), height: 1.35),
            ),
            const SizedBox(height: 6),
            Text(
              buildCompactRewardSummary(
                l10n,
                xp: dailyMissionResult!.xpAwarded,
                drops: dailyMissionResult!.oceanDropsAwarded,
              ),
              style: TextStyle(
                fontSize: 12,
                color: context.palette.onSurfaceSubtle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.kidsArabicDailyMissionTomorrowPrompt,
              style: TextStyle(color: context.palette.onSurfaceSubtle),
            ),
          ],
        ],
      ),
    );
  }
}
