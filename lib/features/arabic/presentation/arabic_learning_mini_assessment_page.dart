import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../../learn/quran_teaching/application/quran_teaching_controller.dart';
import '../application/arabic_learning_assessment_provider.dart';
import '../application/arabic_learning_audio_controller.dart';
import '../domain/arabic_learning_assessment_models.dart';
import '../domain/arabic_learning_audio_models.dart';
import '../domain/arabic_learning_continuity_models.dart';
import 'arabic_learning_route_target_navigation.dart';
import 'widgets/arabic_learning_playback_speed_toggle.dart';
import '../../../core/theme/app_fonts.dart';

class ArabicLearningMiniAssessmentPage extends ConsumerStatefulWidget {
  const ArabicLearningMiniAssessmentPage({required this.audience, super.key});

  final ArabicLearningAudience audience;

  @override
  ConsumerState<ArabicLearningMiniAssessmentPage> createState() =>
      _ArabicLearningMiniAssessmentPageState();
}

class _ArabicLearningMiniAssessmentPageState
    extends ConsumerState<ArabicLearningMiniAssessmentPage> {
  late final ArabicLearningAssessmentSession _session = ref.read(
    arabicLearningMiniAssessmentSessionProvider(widget.audience),
  );
  int _questionIndex = 0;
  final Map<String, int> _retryCounts = <String, int>{};
  final Set<String> _resolvedQuestions = <String>{};
  String? _feedbackKey;
  bool _lastAnswerCorrect = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final audioState = ref.watch(arabicLearningAudioControllerProvider);
    final adultCatalog = widget.audience == ArabicLearningAudience.adult
        ? ref.watch(quranTeachingCatalogProvider)
        : null;
    final currentQuestion = _questionIndex < _session.questions.length
        ? _session.questions[_questionIndex]
        : null;
    final hasStruggle = _retryCounts.values.any((count) => count > 0);
    final prefersReview = hasStruggle && _session.reviewSuggestion != null;

    final children = <Widget>[
      _IntroCard(
        audience: widget.audience,
        questionCount: _session.questions.length,
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerLeft,
        child: ArabicLearningPlaybackSpeedToggle(
          variant: widget.audience == ArabicLearningAudience.kids
              ? ArabicLearningPlaybackToggleVariant.kids
              : ArabicLearningPlaybackToggleVariant.adult,
        ),
      ),
      const SizedBox(height: 12),
      if (currentQuestion != null)
        _QuestionCard(
          audience: widget.audience,
          questionNumber: _questionIndex + 1,
          totalQuestions: _session.questions.length,
          question: currentQuestion,
          audioState: audioState,
          feedback: _feedbackKey == null
              ? null
              : (_lastAnswerCorrect
                    ? l10n.arabicLearningMiniAssessmentCorrectFeedback
                    : l10n.arabicLearningMiniAssessmentRetryFeedback),
          positiveFeedback: _lastAnswerCorrect,
          onReplayAudio:
              currentQuestion.type ==
                  ArabicLearningAssessmentQuestionType.hearChoose
              ? () => _playQuestionAudio(currentQuestion)
              : null,
          onSelectOption: (optionId) =>
              _selectOption(currentQuestion, optionId),
          resolved: _resolvedQuestions.contains(currentQuestion.questionId),
        )
      else
        _CompletionCard(
          audience: widget.audience,
          showReview: _session.reviewSuggestion != null,
          prefersReview: prefersReview,
          onPrimaryTap: () {
            final target = prefersReview
                ? _session.reviewSuggestion!.target
                : _session.continueTarget;
            openArabicLearningRouteTarget(
              context,
              target: target,
              adultCatalog: adultCatalog,
            );
          },
          onSecondaryTap: !prefersReview || _session.reviewSuggestion == null
              ? null
              : () => openArabicLearningRouteTarget(
                  context,
                  target: _session.continueTarget,
                  adultCatalog: adultCatalog,
                ),
        ),
      if (currentQuestion != null &&
          _resolvedQuestions.contains(currentQuestion.questionId)) ...[
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _advance,
          child: Text(
            _questionIndex == _session.questions.length - 1
                ? l10n.arabicLearningMiniAssessmentFinishAction
                : l10n.arabicLearningMiniAssessmentNextAction,
          ),
        ),
      ],
    ];

    if (widget.audience == ArabicLearningAudience.kids) {
      return LearnHubPageScaffold(
        headerIcon: Icons.self_improvement_rounded,
        title: l10n.kidsArabicMiniAssessmentPageTitle,
        subtitle: l10n.kidsArabicMiniAssessmentPageSubtitle,
        children: children,
      );
    }

    return AppPageScaffold(
      title: l10n.quranTeachingMiniAssessmentPageTitle,
      subtitle: l10n.quranTeachingMiniAssessmentPageSubtitle,
      children: children,
    );
  }

  Future<void> _playQuestionAudio(
    ArabicLearningAssessmentQuestion question,
  ) async {
    await ref
        .read(arabicLearningAudioControllerProvider.notifier)
        .playResolvedAudio(
          playbackId: question.audioPlaybackId ?? question.questionId,
          primaryAssetPath: question.audioAssetPath,
          alternateAssetPaths: question.audioAlternateAssetPaths,
          fallbackText: question.audioFallbackText,
        );
  }

  void _selectOption(
    ArabicLearningAssessmentQuestion question,
    String optionId,
  ) {
    if (_resolvedQuestions.contains(question.questionId)) {
      return;
    }
    final correct = optionId == question.correctOptionId;
    setState(() {
      _feedbackKey = correct ? 'correct' : 'retry';
      _lastAnswerCorrect = correct;
      if (correct) {
        _resolvedQuestions.add(question.questionId);
      } else {
        _retryCounts.update(
          question.questionId,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    });
  }

  void _advance() {
    setState(() {
      _questionIndex += 1;
      _feedbackKey = null;
      _lastAnswerCorrect = false;
    });
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.audience, required this.questionCount});

  final ArabicLearningAudience audience;
  final int questionCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKids = audience == ArabicLearningAudience.kids;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isKids ? const Color(0xFFFFF7E8) : const Color(0xFFF5F1EA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isKids ? const Color(0xFFE9D7B3) : const Color(0xFFE0D6C8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.arabicLearningMiniAssessmentIntroTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.arabicLearningMiniAssessmentIntroBody(questionCount)),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.audience,
    required this.questionNumber,
    required this.totalQuestions,
    required this.question,
    required this.audioState,
    required this.onSelectOption,
    this.feedback,
    this.positiveFeedback = false,
    this.onReplayAudio,
    this.resolved = false,
  });

  final ArabicLearningAudience audience;
  final int questionNumber;
  final int totalQuestions;
  final ArabicLearningAssessmentQuestion question;
  final ArabicLearningAudioState audioState;
  final String? feedback;
  final bool positiveFeedback;
  final VoidCallback? onReplayAudio;
  final ValueChanged<String> onSelectOption;
  final bool resolved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKids = audience == ArabicLearningAudience.kids;
    final contentLabel = switch (question.contentType) {
      ArabicLearningContinuationContentType.letter =>
        l10n.arabicLearningMiniAssessmentContentLetter,
      ArabicLearningContinuationContentType.word =>
        l10n.arabicLearningMiniAssessmentContentWord,
      ArabicLearningContinuationContentType.phrase =>
        l10n.arabicLearningMiniAssessmentContentPhrase,
      ArabicLearningContinuationContentType.lesson =>
        l10n.arabicLearningMiniAssessmentContentLetter,
      ArabicLearningContinuationContentType.review =>
        l10n.arabicLearningMiniAssessmentContentWord,
    };
    final isPlaying =
        question.audioPlaybackId != null &&
        audioState.isPlaying &&
        audioState.activePlaybackId == question.audioPlaybackId;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isKids ? const Color(0xFFF8F2E8) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isKids ? const Color(0xFFE5D5C1) : const Color(0xFFE3DDD2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.arabicLearningMiniAssessmentQuestionCounter(
              questionNumber,
              totalQuestions,
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            question.type == ArabicLearningAssessmentQuestionType.seeChoose
                ? l10n.arabicLearningMiniAssessmentSeeChoosePrompt(contentLabel)
                : l10n.arabicLearningMiniAssessmentHearChoosePrompt(
                    contentLabel,
                  ),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          if (question.type ==
              ArabicLearningAssessmentQuestionType.seeChoose) ...[
            Center(
              child: Text(
                question.arabicPrompt ?? '',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: isKids ? 42 : 38,
                  fontFamily: AppFonts.quranArabic,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (question.meaning != null) ...[
              const SizedBox(height: 8),
              Center(child: Text(question.meaning!)),
            ],
          ] else ...[
            FilledButton.tonalIcon(
              onPressed: onReplayAudio,
              icon: Icon(
                isPlaying ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
              ),
              label: Text(l10n.arabicLearningMiniAssessmentReplayAudioAction),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.arabicLearningMiniAssessmentHearChooseHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          ...question.options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  key: Key('arabicAssessmentOption_${option.id}'),
                  onTap: resolved ? null : () => onSelectOption(option.id),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE4DACE)),
                    ),
                    child:
                        question.type ==
                            ArabicLearningAssessmentQuestionType.seeChoose
                        ? _SeeChooseOption(option: option)
                        : _HearChooseOption(option: option),
                  ),
                ),
              ),
            ),
          ),
          if (feedback != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: positiveFeedback
                    ? const Color(0xFFEAF6EA)
                    : const Color(0xFFFFF5E8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(feedback!),
            ),
          ],
        ],
      ),
    );
  }
}

class _SeeChooseOption extends StatelessWidget {
  const _SeeChooseOption({required this.option});

  final ArabicLearningAssessmentOption option;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          option.title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (option.meaning != null) ...[
          const SizedBox(height: 4),
          Text(option.meaning!),
        ],
      ],
    );
  }
}

class _HearChooseOption extends StatelessWidget {
  const _HearChooseOption({required this.option});

  final ArabicLearningAssessmentOption option;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (option.arabicText != null)
          Text(
            option.arabicText!,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 28,
              fontFamily: AppFonts.quranArabic,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (option.transliteration != null) ...[
          const SizedBox(height: 4),
          Text(
            option.transliteration!,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
        if (option.meaning != null) ...[
          const SizedBox(height: 4),
          Text(option.meaning!),
        ],
      ],
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({
    required this.audience,
    required this.showReview,
    required this.prefersReview,
    required this.onPrimaryTap,
    this.onSecondaryTap,
  });

  final ArabicLearningAudience audience;
  final bool showReview;
  final bool prefersReview;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primaryLabel = prefersReview
        ? l10n.arabicLearningMiniAssessmentReviewAction
        : l10n.arabicLearningMiniAssessmentContinueAction;
    final secondaryLabel = prefersReview
        ? l10n.arabicLearningMiniAssessmentContinueAction
        : l10n.arabicLearningMiniAssessmentReviewAction;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.arabicLearningMiniAssessmentCompleteTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            prefersReview
                ? l10n.arabicLearningMiniAssessmentCompleteReviewBody
                : l10n.arabicLearningMiniAssessmentCompleteContinueBody,
          ),
          const SizedBox(height: 14),
          FilledButton(onPressed: onPrimaryTap, child: Text(primaryLabel)),
          if (showReview && onSecondaryTap != null) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: onSecondaryTap,
              child: Text(secondaryLabel),
            ),
          ],
        ],
      ),
    );
  }
}
