import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/reward_feedback.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progression.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../domain/kids_arabic_models.dart';

enum _KidsArabicReviewMode { matchLetterToSound, tapCorrectLetter }

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
    final unlocked = ref.watch(kidsArabicUnlockedLetterIdsProvider);
    final pool = _reviewPool(progress, dailyMission, parentReviewLetter);
    final target = pool[_questionIndex % pool.length];
    final options = _optionsFor(target, pool);
    final finished = _questionIndex >= 5;

    return LearnHubPageScaffold(
      headerIcon: Icons.quiz_rounded,
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
            totalQuestions: 5,
            dailyMissionResult: _dailyMissionResult,
          )
        else
          _ReviewQuestionCard(
            mode: _mode,
            target: target,
            options: options,
            unlockedLetterIds: unlocked,
            questionNumber: _questionIndex + 1,
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

  List<KidsArabicLetter> _reviewPool(
    KidsArabicProgressState progress,
    KidsArabicDailyMission? dailyMission,
    KidsArabicLetter? parentReviewLetter,
  ) {
    final completed = kidsArabicProgressionLetters
        .where((letter) => progress.completedLetterIds.contains(letter.id))
        .toList(growable: false);
    final prioritized = _prioritizeTargets(
      completed,
      dailyMission,
      parentReviewLetter,
    );
    if (prioritized.length >= 2) return prioritized;
    final unlocked = kidsArabicProgressionLetters
        .where(
          (letter) => isKidsArabicLetterUnlocked(
            letterId: letter.id,
            completedLetterIds: progress.completedLetterIds,
          ),
        )
        .toList(growable: false);
    final unlockedPrioritized = _prioritizeTargets(
      unlocked,
      dailyMission,
      parentReviewLetter,
    );
    if (unlockedPrioritized.length >= 2) return unlockedPrioritized;
    return _prioritizeTargets(
      kidsArabicStarterReleaseOrderIds
          .map(
            (id) => kidsArabicProgressionLetters.firstWhere(
              (letter) => letter.id == id,
            ),
          )
          .toList(growable: false),
      dailyMission,
      parentReviewLetter,
    );
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

  List<KidsArabicLetter> _optionsFor(
    KidsArabicLetter target,
    List<KidsArabicLetter> reviewPool,
  ) {
    final pool = [...reviewPool];
    final startIndex = pool.indexWhere((letter) => letter.id == target.id);
    final selected = <KidsArabicLetter>[target];
    for (
      var offset = 1;
      selected.length < 4 && offset < pool.length;
      offset += 1
    ) {
      selected.add(pool[(startIndex + offset * 3) % pool.length]);
    }
    return selected.toSet().toList(growable: false);
  }
}

class _ReviewQuestionCard extends StatelessWidget {
  const _ReviewQuestionCard({
    required this.mode,
    required this.target,
    required this.options,
    required this.unlockedLetterIds,
    required this.questionNumber,
    required this.onAnswer,
  });

  final _KidsArabicReviewMode mode;
  final KidsArabicLetter target;
  final List<KidsArabicLetter> options;
  final Set<String> unlockedLetterIds;
  final int questionNumber;
  final ValueChanged<KidsArabicLetter> onAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2E8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5D5C1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicQuestionCounter(questionNumber, 5),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF8A6C49),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            mode == _KidsArabicReviewMode.matchLetterToSound
                ? l10n.kidsArabicReviewQuestionMatchSound(target.glyph)
                : l10n.kidsArabicReviewQuestionTapCorrect(
                    target.transliteration,
                  ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options
                .map(
                  (option) => InkWell(
                    onTap: unlockedLetterIds.contains(option.id)
                        ? () => onAnswer(option)
                        : null,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 156,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: unlockedLetterIds.contains(option.id)
                            ? Colors.white
                            : const Color(0xFFF2EEE7),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE5D5C1)),
                      ),
                      child: Center(
                        child: Text(
                          mode == _KidsArabicReviewMode.matchLetterToSound
                              ? option.transliteration
                              : option.glyph,
                          textDirection:
                              mode == _KidsArabicReviewMode.matchLetterToSound
                              ? null
                              : TextDirection.rtl,
                          style: TextStyle(
                            fontSize:
                                mode == _KidsArabicReviewMode.matchLetterToSound
                                ? 18
                                : 34,
                            fontFamily:
                                mode == _KidsArabicReviewMode.matchLetterToSound
                                ? null
                                : 'Noto Naskh Arabic',
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5E462A),
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
        color: positive ? const Color(0xFFEFF6E6) : const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: positive ? const Color(0xFFD4E4C0) : const Color(0xFFE7D6C0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: positive ? const Color(0xFF52713A) : const Color(0xFF8A6C49),
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
        color: const Color(0xFFEFF6E6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD4E4C0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicReviewFinishedTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
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
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E261F),
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
              style: const TextStyle(fontSize: 12, color: Color(0xFF675B4E)),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.kidsArabicDailyMissionTomorrowPrompt,
              style: const TextStyle(color: Color(0xFF675B4E)),
            ),
          ],
        ],
      ),
    );
  }
}
