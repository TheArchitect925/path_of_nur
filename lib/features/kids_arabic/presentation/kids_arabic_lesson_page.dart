import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../arabic/data/arabic_alphabet_catalog.dart';
import '../../arabic/domain/arabic_alphabet_models.dart';
import '../../arabic/data/arabic_letter_pictures.dart';
import '../../kids/rewards/domain/kids_sticker_models.dart';
import '../../kids/rewards/presentation/kids_celebration.dart';
import '../../kids/shared/presentation/kids_page_scaffold.dart';
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

/// One letter, three moves: hear it, trace it, remember it by a picture.
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
  }) async {
    if (_isCompleting) return;
    setState(() {
      _isCompleting = true;
    });
    final wasCompleted = ref
        .read(kidsArabicProgressProvider)
        .completedLetterIds
        .contains(letter.id);
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
    // The first time a letter is finished it becomes a sticker (K4); the
    // completion sheet with the next step follows.
    if (!wasCompleted) {
      await showKidsCelebration(
        context,
        ref,
        sticker: KidsSticker(
          id: 'letter:${letter.id}',
          kind: KidsStickerKind.letter,
          title: letter.nameEn,
          subtitle: letter.transliteration,
          glyph: letter.glyph,
        ),
      );
      if (!mounted) return;
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _CompletionSheet(
          letter: letter,
          result: result,
          nextLetter: nextLetter,
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
      return KidsPageScaffold(
        title: l10n.kidsArabicHomeTitle,
        children: [PremiumCard(child: Text(l10n.kidsArabicLetterMissingBody))],
      );
    }
    if (!unlockedLetterIds.contains(letter.id)) {
      return KidsPageScaffold(
        title: l10n.kidsArabicHomeTitle,
        children: [PremiumCard(child: Text(l10n.kidsArabicLockedBody))],
      );
    }
    final nextLetter = nextKidsArabicLetter(letter.id);
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
    final picture = arabicLetterPictureFor(letter.id);
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
    return KidsPageScaffold(
      title: letter.nameEn,
      subtitle: l10n.kidsArabicLessonSubtitle(letter.nameAr),
      children: [
        // Hear it. The letter itself is the hero: tap it and it speaks, and
        // for a child it speaks on its own when the page opens.
        KidsArabicRepeatAfterMeCard(
          autoplayToken: letter.id,
          displayText: letter.glyph,
          displayFontSize: 72,
          caption: parentPreferences.showTransliteration
              ? '${letter.nameAr} · ${letter.transliteration}'
              : letter.nameAr,
          title: l10n.kidsArabicRepeatAfterMeTitle,
          subtitle: l10n.kidsArabicRepeatAfterMeLetterSubtitle,
          listenLabel: l10n.kidsArabicPronunciationAction,
          repeatPromptLabel: l10n.kidsArabicRepeatAfterMePrompt,
          autoplayEnabled: parentPreferences.audioAutoplay,
          onPlay: () =>
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
        const SizedBox(height: 14),
        // Trace it.
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
                          tryAgainLabel: l10n.kidsArabicTryAgainAction,
                          continueLabel: l10n.kidsArabicCompleteLessonAction,
                          onTryAgain: _resetTrace,
                          onContinue: _isCompleting
                              ? null
                              : () => _completeLesson(
                                  letter: letter,
                                  liveResult: liveResult,
                                  nextLetter: nextLetter,
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
        // See it in a word: the same letter in its places (L4).
        if (arabicAlphabetLetterById(letter.id) case final catalogLetter?) ...[
          const SizedBox(height: 14),
          _FormsCard(letter: letter, forms: catalogLetter.positionalForms),
        ],
        // Remember it: one picture, and the word the letter opens.
        if (picture != null) ...[
          const SizedBox(height: 14),
          _PictureCard(
            picture: picture,
            title: l10n.kidsArabicPictureLine(
              letter.nameEn,
              picture.spokenWord,
            ),
            childLine: localizedKidsArabicChildLine(l10n, letter.id),
            letter: letter,
          ),
        ],
      ],
    );
  }
}

/// The same letter alone, at the start, in the middle and at the end, so the
/// squiggle inside a word is recognised as the letter just traced.
class _FormsCard extends StatelessWidget {
  const _FormsCard({required this.letter, required this.forms});

  final KidsArabicLetter letter;
  final ArabicLetterPositionalForms forms;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final places = <(String, String)>[
      (l10n.kidsArabicFormAlone, forms.isolated),
      if (forms.initial case final initial?)
        (l10n.kidsArabicFormStart, initial),
      if (forms.medial case final medial?) (l10n.kidsArabicFormMiddle, medial),
      if (forms.finalForm case final end?) (l10n.kidsArabicFormEnd, end),
    ];
    return _SectionCard(
      title: l10n.kidsArabicFormsTitle(letter.nameEn),
      subtitle: l10n.kidsArabicFormsSubtitle,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final (label, glyph) in places)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.palette.surfaceSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    glyph,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: AppFonts.arabicLearning,
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// The letter's picture friend: one calm object whose name starts with the
/// letter's sound, the same picture the Qur'an teacher's visual mode shows,
/// with the word from the child's own world beside it.
class _PictureCard extends StatelessWidget {
  const _PictureCard({
    required this.picture,
    required this.title,
    required this.childLine,
    required this.letter,
  });

  final ArabicLetterPicture picture;
  final String title;
  final String childLine;
  final KidsArabicLetter letter;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      subtitle: childLine,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 112,
              height: 84,
              child: Image.asset(
                picture.assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    ColoredBox(color: context.palette.surfaceSoft),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  picture.spokenWord,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      letter.exampleWordAr,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: AppFonts.arabicLearning,
                        fontWeight: FontWeight.w700,
                        color: context.palette.onSurface,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        letter.exampleWordEn,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: context.palette.onSurfaceSubtle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    required this.tryAgainLabel,
    required this.continueLabel,
    required this.onTryAgain,
    required this.onContinue,
  });

  final String title;
  final String subtitle;
  final String encouragement;
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
              Icon(AppIcons.fun, size: 18, color: context.palette.successInk),
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

/// After the sticker: the letter, one line, and the next letter. Nothing a
/// child has to read to move on.
class _CompletionSheet extends ConsumerWidget {
  const _CompletionSheet({
    required this.letter,
    required this.result,
    required this.nextLetter,
    required this.achievement,
    required this.onTryAgain,
  });

  final KidsArabicLetter letter;
  final KidsArabicCompletionResult result;
  final KidsArabicLetter? nextLetter;
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
                      fontFamily: AppFonts.arabicLearning,
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
            if (result.dailyMissionResult != null) ...[
              const SizedBox(height: 10),
              Text(
                l10n.kidsArabicDailyMissionCompletedTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.palette.successInk,
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
            if (achievement != null) ...[
              const SizedBox(height: 12),
              _AchievementRevealCard(achievement: achievement!),
            ],
            const SizedBox(height: 16),
            if (nextLetter != null)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onTryAgain,
                    child: Text(l10n.kidsArabicTryAgainAction),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.kidsArabicBackToLettersAction),
                  ),
                ),
              ],
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
