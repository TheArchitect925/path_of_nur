import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../kids/shared/presentation/kids_page_scaffold.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progression.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../domain/kids_arabic_models.dart';

/// Sound first. A child hears a letter and finds it, or sees a letter and
/// finds its sound; nothing here asks a pre-reader to read a transliteration.
enum _KidsArabicReviewMode { hearTap, seeHear }

const int _questionsPerRound = 5;

class KidsArabicReviewPage extends ConsumerStatefulWidget {
  const KidsArabicReviewPage({super.key});

  @override
  ConsumerState<KidsArabicReviewPage> createState() =>
      _KidsArabicReviewPageState();
}

class _KidsArabicReviewPageState extends ConsumerState<KidsArabicReviewPage> {
  _KidsArabicReviewMode _mode = _KidsArabicReviewMode.hearTap;
  int _questionIndex = 0;
  int _correctAnswers = 0;
  bool? _lastAnswerCorrect;
  KidsArabicLetter? _lastTarget;
  String? _selectedOptionId;
  int? _autoplayedQuestion;
  KidsArabicDailyMissionCompletionResult? _dailyMissionResult;

  void _restart(_KidsArabicReviewMode mode) {
    setState(() {
      _mode = mode;
      _questionIndex = 0;
      _correctAnswers = 0;
      _lastAnswerCorrect = null;
      _lastTarget = null;
      _selectedOptionId = null;
      _autoplayedQuestion = null;
      _dailyMissionResult = null;
    });
  }

  Future<void> _speak(KidsArabicLetter letter) =>
      ref.read(kidsArabicAudioServiceProvider).speakLetter(letter);

  void _answer({
    required KidsArabicLetter selected,
    required KidsArabicLetter target,
    required KidsArabicDailyMission? dailyMission,
  }) {
    final correct = selected.id == target.id;
    final notifier = ref.read(kidsArabicProgressProvider.notifier);
    notifier.recordReviewAnswer(letterId: target.id, correct: correct);
    final dailyResult = correct && dailyMission != null
        ? notifier.completeDailyReviewMissionIfEligible(
            targetLetterId: target.id,
          )
        : null;
    setState(() {
      _lastAnswerCorrect = correct;
      _lastTarget = target;
      _selectedOptionId = null;
      if (correct) _correctAnswers += 1;
      _questionIndex += 1;
      _dailyMissionResult ??= dailyResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(kidsArabicProgressProvider);
    final dailyMission = ref.watch(kidsArabicDailyMissionProvider);
    final parentReviewLetter = ref.watch(kidsArabicParentReviewLetterProvider);
    final parentPreferences = ref.watch(kidsArabicParentPreferencesProvider);
    final pool = _reviewPool(progress, dailyMission, parentReviewLetter);

    if (pool.length < 2) {
      // A quiz over one letter has one answer. Invite the next lesson instead
      // of pretending to ask a question.
      return KidsPageScaffold(
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

    // Hear it, tap it: the letter speaks as each question opens, so a child
    // never has to find the Listen button first.
    if (!finished &&
        _mode == _KidsArabicReviewMode.hearTap &&
        parentPreferences.audioAutoplay &&
        _autoplayedQuestion != _questionIndex) {
      _autoplayedQuestion = _questionIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(_speak(target));
      });
    }

    return KidsPageScaffold(
      title: l10n.kidsArabicReviewTitle,
      subtitle: l10n.kidsArabicReviewSubtitle,
      children: [
        SegmentedButton<_KidsArabicReviewMode>(
          segments: [
            ButtonSegment(
              value: _KidsArabicReviewMode.hearTap,
              label: Text(l10n.kidsArabicReviewModeMatchSound),
            ),
            ButtonSegment(
              value: _KidsArabicReviewMode.seeHear,
              label: Text(l10n.kidsArabicReviewModeTapCorrectLetter),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: (selection) => _restart(selection.first),
        ),
        const SizedBox(height: 16),
        if (_lastAnswerCorrect != null) ...[
          _ReviewFeedbackBanner(
            label: _lastAnswerCorrect!
                ? l10n.kidsArabicReviewCorrectLetterFeedback(
                    _lastTarget?.nameEn ?? '',
                  )
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
        else if (_mode == _KidsArabicReviewMode.hearTap)
          _HearTapQuestion(
            target: target,
            options: options,
            questionNumber: _questionIndex + 1,
            totalQuestions: _questionsPerRound,
            onListen: () => _speak(target),
            onAnswer: (selected) => _answer(
              selected: selected,
              target: target,
              dailyMission: dailyMission,
            ),
          )
        else
          _SeeHearQuestion(
            target: target,
            options: options,
            selectedOptionId: _selectedOptionId,
            questionNumber: _questionIndex + 1,
            totalQuestions: _questionsPerRound,
            onHear: (option) {
              setState(() {
                _selectedOptionId = option.id;
              });
              unawaited(_speak(option));
            },
            onCheck: _selectedOptionId == null
                ? null
                : () => _answer(
                    selected: options.firstWhere(
                      (option) => option.id == _selectedOptionId,
                    ),
                    target: target,
                    dailyMission: dailyMission,
                  ),
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
  /// answer is never simply the first tile.
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
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _GlyphBox(glyph: nextLetter.glyph, size: 64, fontSize: 34),
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

/// Hear the letter, find its shape among four.
class _HearTapQuestion extends StatelessWidget {
  const _HearTapQuestion({
    required this.target,
    required this.options,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onListen,
    required this.onAnswer,
  });

  final KidsArabicLetter target;
  final List<KidsArabicLetter> options;
  final int questionNumber;
  final int totalQuestions;
  final Future<void> Function() onListen;
  final ValueChanged<KidsArabicLetter> onAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Counter(
            questionNumber: questionNumber,
            totalQuestions: totalQuestions,
          ),
          const SizedBox(height: 12),
          _Prompt(text: l10n.kidsArabicReviewQuestionMatchSound),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicReviewHearTapHint,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: FilledButton.tonalIcon(
              style: FilledButton.styleFrom(minimumSize: const Size(180, 56)),
              onPressed: onListen,
              icon: const Icon(AppIcons.listen),
              label: Text(l10n.kidsArabicPronunciationAction),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options
                .map(
                  (option) => Semantics(
                    button: true,
                    label: option.nameEn,
                    child: InkWell(
                      onTap: () => onAnswer(option),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 156,
                        height: 96,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: context.palette.surfaceSoft,
                          ),
                        ),
                        child: Text(
                          option.glyph,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 44,
                            fontFamily: AppFonts.arabicLearning,
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

/// See the letter, hear four sounds, pick the one it makes.
class _SeeHearQuestion extends StatelessWidget {
  const _SeeHearQuestion({
    required this.target,
    required this.options,
    required this.selectedOptionId,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onHear,
    required this.onCheck,
  });

  final KidsArabicLetter target;
  final List<KidsArabicLetter> options;
  final String? selectedOptionId;
  final int questionNumber;
  final int totalQuestions;
  final ValueChanged<KidsArabicLetter> onHear;
  final VoidCallback? onCheck;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Counter(
            questionNumber: questionNumber,
            totalQuestions: totalQuestions,
          ),
          const SizedBox(height: 12),
          _Prompt(text: l10n.kidsArabicReviewQuestionSeeHear),
          const SizedBox(height: 14),
          Center(
            child: _GlyphBox(glyph: target.glyph, size: 120, fontSize: 64),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.kidsArabicReviewSeeHearHint,
            style: TextStyle(color: palette.onSurfaceSubtle, height: 1.35),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options
                .map((option) {
                  final selected = option.id == selectedOptionId;
                  return Semantics(
                    button: true,
                    selected: selected,
                    label: option.nameEn,
                    child: InkWell(
                      onTap: () => onHear(option),
                      borderRadius: BorderRadius.circular(18),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: 156,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? palette.accentSoft : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? palette.accent
                                : palette.surfaceSoft,
                            width: selected ? 1.6 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              AppIcons.listen,
                              size: 20,
                              color: selected
                                  ? palette.onSurface
                                  : palette.onSurfaceSubtle,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              option.transliteration,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: palette.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: onCheck,
              child: Text(l10n.kidsArabicReviewCheckAction),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: child,
    );
  }
}

class _GlyphBox extends StatelessWidget {
  const _GlyphBox({
    required this.glyph,
    required this.size,
    required this.fontSize,
  });

  final String glyph;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.palette.surfaceSoft,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Text(
        glyph,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: AppFonts.arabicLearning,
          fontWeight: FontWeight.w700,
          color: context.palette.onSurface,
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({required this.questionNumber, required this.totalQuestions});

  final int questionNumber;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Text(
      l10n.kidsArabicQuestionCounter(questionNumber, totalQuestions),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: context.palette.onSurfaceSubtle,
      ),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: context.palette.onSurface,
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
              l10n.kidsArabicDailyMissionTomorrowPrompt,
              style: const TextStyle(color: Color(0xFF4A5E32), height: 1.35),
            ),
          ],
        ],
      ),
    );
  }
}
