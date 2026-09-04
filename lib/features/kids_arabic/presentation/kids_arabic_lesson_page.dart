import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/reward_feedback.dart';
import '../../arabic/presentation/widgets/arabic_learning_playback_speed_toggle.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_achievements_provider.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progression.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../application/kids_arabic_starter_tracing.dart';
import '../application/kids_arabic_vector_tracing.dart';
import '../domain/kids_arabic_achievement_models.dart';
import '../domain/kids_arabic_models.dart';
import '../widgets/kids_arabic_audio_learning_widgets.dart';
import '../widgets/kids_arabic_tracing_pad.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicLessonPage extends ConsumerStatefulWidget {
  const KidsArabicLessonPage({
    super.key,
    required this.letterId,
    this.initialMetrics = const KidsArabicTraceMetrics(
      strokeCount: 0,
      pointCount: 0,
    ),
  });

  final String letterId;
  final KidsArabicTraceMetrics initialMetrics;

  @override
  ConsumerState<KidsArabicLessonPage> createState() =>
      _KidsArabicLessonPageState();
}

class _KidsArabicLessonPageState extends ConsumerState<KidsArabicLessonPage> {
  late KidsArabicTraceMetrics _metrics;
  bool _isCompleting = false;
  bool _showCompletionActions = false;
  bool _hasTracedOnPage = false;
  bool _completionAudioPlayedForAttempt = false;
  bool _handledInitialCompletionState = false;
  Timer? _completionRevealTimer;
  final GlobalKey<KidsArabicTracingPadState> _traceKey =
      GlobalKey<KidsArabicTracingPadState>();

  @override
  void initState() {
    super.initState();
    _metrics = widget.initialMetrics;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledInitialCompletionState || !_metrics.successPulse) {
      return;
    }
    final notifier = ref.read(kidsArabicProgressProvider.notifier);
    final letter = notifier.letterById(widget.letterId);
    if (letter == null) {
      return;
    }
    _handledInitialCompletionState = true;
    final parentPreferences = ref.read(kidsArabicParentPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _primeCompletionPresentation(letter, parentPreferences);
    });
  }

  @override
  void dispose() {
    _completionRevealTimer?.cancel();
    super.dispose();
  }

  void _resetCompletionPresentation() {
    _completionRevealTimer?.cancel();
    _completionRevealTimer = null;
    _completionAudioPlayedForAttempt = false;
    if (_showCompletionActions) {
      setState(() {
        _showCompletionActions = false;
      });
    }
  }

  void _resetTrace() {
    _resetCompletionPresentation();
    _traceKey.currentState?.clear();
    setState(() {
      _metrics = const KidsArabicTraceMetrics(strokeCount: 0, pointCount: 0);
    });
  }

  void _handleTraceMetricsChanged(
    KidsArabicTraceMetrics metrics,
    KidsArabicLetter letter,
    KidsArabicParentPreferences parentPreferences,
  ) {
    final becameSuccessful = metrics.successPulse && !_metrics.successPulse;
    final lostSuccess = !metrics.successPulse && _metrics.successPulse;
    setState(() {
      _metrics = metrics;
      if (metrics.pointCount > 0) {
        _hasTracedOnPage = true;
      }
    });
    if (lostSuccess) {
      _resetCompletionPresentation();
      return;
    }
    if (!becameSuccessful) {
      return;
    }
    _primeCompletionPresentation(letter, parentPreferences);
  }

  void _primeCompletionPresentation(
    KidsArabicLetter letter,
    KidsArabicParentPreferences parentPreferences,
  ) {
    if (!_metrics.successPulse) {
      return;
    }
    _completionRevealTimer?.cancel();
    _showCompletionActions = false;
    _completionRevealTimer = Timer(const Duration(milliseconds: 320), () {
      if (!mounted || !_metrics.successPulse) return;
      setState(() {
        _showCompletionActions = true;
      });
    });
    if (!_hasTracedOnPage ||
        _completionAudioPlayedForAttempt ||
        !parentPreferences.audioAutoplay) {
      return;
    }
    _completionAudioPlayedForAttempt = true;
    Future<void>.delayed(const Duration(milliseconds: 220), () async {
      if (!mounted || !_metrics.successPulse) return;
      await ref.read(kidsArabicAudioServiceProvider).speakLetter(letter);
    });
  }

  Future<void> _completeLesson({
    required KidsArabicLetter letter,
    required KidsArabicTraceResult liveResult,
    required KidsArabicLetter? nextLetter,
    required KidsArabicLetter? previousLetter,
  }) async {
    if (_isCompleting) return;
    setState(() {
      _isCompleting = true;
    });
    final result = ref
        .read(kidsArabicProgressProvider.notifier)
        .completeLesson(letter: letter, traceResult: liveResult);
    final achievement = ref.read(kidsArabicAchievementCelebrationProvider);
    if (achievement != null) {
      ref
          .read(kidsArabicAchievementsUiProvider.notifier)
          .markCelebrationSeen(achievement.id);
    }
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _CompletionSheet(
          letter: letter,
          result: result,
          nextLetter: nextLetter,
          previousLetter: previousLetter,
          achievement: achievement,
          onTryAgain: () {
            Navigator.of(sheetContext).pop();
            _resetTrace();
          },
        );
      },
    );
    if (!mounted) return;
    setState(() {
      _isCompleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(kidsArabicProgressProvider.notifier);
    final unlockedLetterIds = ref.watch(kidsArabicUnlockedLetterIdsProvider);
    final parentPreferences = ref.watch(kidsArabicParentPreferencesProvider);
    final letter = notifier.letterById(widget.letterId);
    if (letter == null) {
      return LearnHubPageScaffold(
        title: l10n.kidsArabicLetterMissingTitle,
        subtitle: l10n.kidsArabicLetterMissingSubtitle,
        children: [Text(l10n.kidsArabicLetterMissingBody)],
      );
    }
    if (!unlockedLetterIds.contains(letter.id)) {
      return LearnHubPageScaffold(
        title: l10n.kidsArabicLockedTitle,
        subtitle: l10n.kidsArabicLockedSubtitle,
        children: [Text(l10n.kidsArabicLockedBody)],
      );
    }
    final nextLetter = nextKidsArabicLetter(letter.id);
    final previousLetter = previousKidsArabicLetter(letter.id);
    final guide = kidsArabicSupportsVectorTracing(letter.id)
        ? null
        : kidsArabicTracingGuideFor(letter.id);
    final liveResult = scoreKidsArabicTrace(letter: letter, metrics: _metrics);
    final encouragement = localizedKidsArabicTraceEncouragement(
      l10n,
      _metrics,
      liveResult,
    );
    final traceReady = _metrics.minimumEffortMet;
    final tracingColors = <KidsArabicTracingColorOption>[
      KidsArabicTracingColorOption(
        id: 'gold',
        color: const Color(0xFFB9864E),
        label: l10n.kidsArabicTraceColorGold,
      ),
      KidsArabicTracingColorOption(
        id: 'mint',
        color: const Color(0xFF6AA97A),
        label: l10n.kidsArabicTraceColorMint,
      ),
      KidsArabicTracingColorOption(
        id: 'sky',
        color: const Color(0xFF5D8FD6),
        label: l10n.kidsArabicTraceColorSky,
      ),
      KidsArabicTracingColorOption(
        id: 'plum',
        color: const Color(0xFF9368B8),
        label: l10n.kidsArabicTraceColorPlum,
      ),
    ];
    return LearnHubPageScaffold(
      title: l10n.kidsArabicLessonTitle(letter.glyph),
      subtitle: l10n.kidsArabicLessonSubtitle(letter.nameAr),
      children: [
        _GlyphHero(
          letter: letter,
          childLine: localizedKidsArabicChildLine(l10n, letter.id),
          onTap: () =>
              ref.read(kidsArabicAudioServiceProvider).speakLetter(letter),
        ),
        if (parentPreferences.lessonSupportLevel !=
            KidsArabicLessonSupportLevel.standard) ...[
          const SizedBox(height: 12),
          _SectionCard(
            title: l10n.kidsArabicParentSupportNoteTitle,
            subtitle:
                parentPreferences.lessonSupportLevel ==
                    KidsArabicLessonSupportLevel.extraHelp
                ? l10n.kidsArabicParentSupportNoteExtraHelp
                : l10n.kidsArabicParentSupportNoteGentle,
            child: const SizedBox.shrink(),
          ),
        ],
        const SizedBox(height: 12),
        const ArabicLearningPlaybackSpeedToggle(
          variant: ArabicLearningPlaybackToggleVariant.kids,
        ),
        const SizedBox(height: 14),
        KidsArabicRepeatAfterMeCard(
          autoplayToken: letter.id,
          displayText: letter.nameAr,
          title: l10n.kidsArabicRepeatAfterMeTitle,
          subtitle: l10n.kidsArabicRepeatAfterMeLetterSubtitle,
          listenLabel: l10n.kidsArabicPronunciationAction,
          repeatPromptLabel: l10n.kidsArabicRepeatAfterMePrompt,
          autoplayEnabled: parentPreferences.audioAutoplay,
          onPlay: () =>
              ref.read(kidsArabicAudioServiceProvider).speakLetter(letter),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.kidsArabicTraceTitle,
          subtitle: l10n.kidsArabicTraceSubtitle(letter.strokeCount),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TraceStatusCard(
                progressLabel: l10n.kidsArabicTraceStrokeProgress(
                  (_metrics.completedGuideStrokes + 1).clamp(
                    1,
                    _metrics.totalGuideStrokes,
                  ),
                  _metrics.totalGuideStrokes,
                ),
                encouragement: encouragement,
                progress: _metrics.guidedProgress,
              ),
              const SizedBox(height: 12),
              KidsArabicTracingPad(
                key: _traceKey,
                letterId: letter.id,
                guide: guide,
                clearActionLabel: l10n.kidsArabicClearTraceAction,
                traceColorLabel: l10n.kidsArabicTraceColorLabel,
                readyBadgeLabel: l10n.kidsArabicTraceReadyBadge,
                colorOptions: tracingColors,
                onMetricsChanged: (metrics) => _handleTraceMetricsChanged(
                  metrics,
                  letter,
                  parentPreferences,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final offset = Tween<Offset>(
                    begin: const Offset(0, 0.06),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: offset, child: child),
                  );
                },
                child: traceReady && _showCompletionActions
                    ? Padding(
                        key: const ValueKey('trace-completion-card'),
                        padding: const EdgeInsets.only(top: 12),
                        child: _TraceCompletionCard(
                          title: l10n.kidsArabicTraceCompletionTitle,
                          subtitle: l10n.kidsArabicTraceCompletionSubtitleQuiet,
                          encouragement: encouragement,
                          rewardLabel: buildCompactRewardSummary(
                            l10n,
                            xp: letter.rewardXp,
                            drops: letter.rewardDrops,
                          ),
                          tryAgainLabel: l10n.kidsArabicTryAgainAction,
                          continueLabel: l10n.kidsArabicCompleteLessonAction,
                          onTryAgain: _resetTrace,
                          onContinue: _isCompleting
                              ? null
                              : () => _completeLesson(
                                  letter: letter,
                                  liveResult: liveResult,
                                  nextLetter: nextLetter,
                                  previousLetter: previousLetter,
                                ),
                        ),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('trace-completion-empty'),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.kidsArabicWordCardTitle,
          subtitle: l10n.kidsArabicWordCardSubtitle,
          child: Row(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  letter.exampleWordAr,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Noto Naskh Arabic',
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parentPreferences.showTransliteration
                          ? letter.transliteration
                          : letter.exampleWordEn,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.palette.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizedKidsArabicChildLine(l10n, letter.id),
                      style: TextStyle(
                        color: context.palette.onSurfaceSubtle,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
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
                l10n.kidsArabicLessonRewardTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.palette.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.kidsArabicLessonRewardFooter(
                  letter.rewardXp,
                  letter.rewardDrops,
                ),
                style: const TextStyle(color: Color(0xFF4A5E32), height: 1.35),
              ),
              if (!traceReady) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: null,
                    child: Text(l10n.kidsArabicCompleteLessonAction),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GlyphHero extends StatelessWidget {
  const _GlyphHero({
    required this.letter,
    required this.childLine,
    required this.onTap,
  });

  final KidsArabicLetter letter;
  final String childLine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7EC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.palette.surfaceSoft),
        ),
        child: Row(
          children: [
            Container(
              width: 108,
              height: 126,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                letter.glyph,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 72,
                  fontFamily: 'Noto Naskh Arabic',
                  fontWeight: FontWeight.w700,
                  color: context.palette.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    letter.nameAr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    letter.transliteration,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    childLine,
                    style: TextStyle(
                      color: context.palette.onSurfaceSubtle,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TraceStatusCard extends StatelessWidget {
  const _TraceStatusCard({
    required this.progressLabel,
    required this.encouragement,
    required this.progress,
  });

  final String progressLabel;
  final String encouragement;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            progressLabel,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress.clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFF0E6D9),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF90C66E)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            encouragement,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TraceCompletionCard extends StatelessWidget {
  const _TraceCompletionCard({
    required this.title,
    required this.subtitle,
    required this.encouragement,
    required this.rewardLabel,
    required this.tryAgainLabel,
    required this.continueLabel,
    required this.onTryAgain,
    required this.onContinue,
  });

  final String title;
  final String subtitle;
  final String encouragement;
  final String rewardLabel;
  final String tryAgainLabel;
  final String continueLabel;
  final VoidCallback onTryAgain;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.success.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.palette.success.withValues(alpha: 0.45),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: context.palette.successInk,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            encouragement,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.successInk,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            rewardLabel,
            style: TextStyle(
              fontSize: 12,
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onTryAgain,
                  child: Text(tryAgainLabel),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onContinue,
                  child: Text(continueLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompletionSheet extends ConsumerWidget {
  const _CompletionSheet({
    required this.letter,
    required this.result,
    required this.nextLetter,
    required this.previousLetter,
    required this.achievement,
    required this.onTryAgain,
  });

  final KidsArabicLetter letter;
  final KidsArabicCompletionResult result;
  final KidsArabicLetter? nextLetter;
  final KidsArabicLetter? previousLetter;
  final KidsArabicAchievementDefinition? achievement;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.92, end: 1),
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeOutBack,
                builder: (context, value, child) =>
                    Transform.scale(scale: value, child: child),
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: context.palette.success.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter.glyph,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 42,
                      fontFamily: 'Noto Naskh Arabic',
                      fontWeight: FontWeight.w700,
                      color: context.palette.successInk,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.kidsArabicCompletionTitle(
                localizedKidsArabicTraceResult(l10n, result.traceResult),
              ),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: context.palette.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.kidsArabicCompletionSubtitle(letter.glyph, result.xpAwarded),
              style: TextStyle(
                color: context.palette.onSurfaceSubtle,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              buildCompactRewardSummary(
                l10n,
                xp: result.xpAwarded,
                drops: result.oceanDropsAwarded,
              ),
              style: TextStyle(
                fontSize: 12,
                color: context.palette.onSurfaceSubtle,
              ),
            ),
            if (result.dailyMissionResult != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: context.palette.surfaceSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        result.dailyMissionResult!.currentStreak,
                      ),
                      style: TextStyle(
                        color: context.palette.onSurfaceSubtle,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      buildCompactRewardSummary(
                        l10n,
                        xp: result.dailyMissionResult!.xpAwarded,
                        drops: result.dailyMissionResult!.oceanDropsAwarded,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.palette.onSurfaceSubtle,
                      ),
                    ),
                    if (result.dailyMissionResult!.graceUsed) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.kidsArabicDailyMissionGraceUsed,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: context.palette.onSurfaceSubtle,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      l10n.kidsArabicDailyMissionTomorrowPrompt,
                      style: TextStyle(color: context.palette.onSurfaceSubtle),
                    ),
                  ],
                ),
              ),
            ],
            if (nextLetter != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.kidsArabicCompletionNextUnlock(nextLetter!.glyph),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
            ],
            const SizedBox(height: 14),
            if (result.newStickerIds.isNotEmpty)
              Text(
                l10n.kidsArabicStickerUnlocked(result.newStickerIds.length),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.palette.successInk,
                ),
              ),
            if (achievement != null) ...[
              const SizedBox(height: 12),
              _AchievementRevealCard(achievement: achievement!),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onTryAgain,
                    child: Text(l10n.kidsArabicTryAgainAction),
                  ),
                ),
                if (nextLetter != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pushReplacementNamed(
                          'kidsArabicLesson',
                          pathParameters: {'letterId': nextLetter!.id},
                        );
                      },
                      child: Text(l10n.kidsArabicNextLetterAction),
                    ),
                  ),
                ],
              ],
            ),
            if (previousLetter != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pushReplacementNamed(
                      'kidsArabicLesson',
                      pathParameters: {'letterId': previousLetter!.id},
                    );
                  },
                  child: Text(l10n.kidsArabicPreviousLetterAction),
                ),
              ),
            ],
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.kidsArabicBackToLettersAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementRevealCard extends StatelessWidget {
  const _AchievementRevealCard({required this.achievement});

  final KidsArabicAchievementDefinition achievement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: achievement.color.withValues(alpha: 0.42)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: achievement.color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(achievement.icon, color: achievement.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsArabicAchievementCelebrateTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizedKidsArabicAchievementTitle(l10n, achievement),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: achievement.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizedKidsArabicAchievementSubtitle(l10n, achievement),
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
