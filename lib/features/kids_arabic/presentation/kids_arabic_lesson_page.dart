import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progression.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../application/kids_arabic_starter_tracing.dart';
import '../domain/kids_arabic_models.dart';
import '../widgets/kids_arabic_tracing_pad.dart';
import 'kids_arabic_localized_content.dart';

class KidsArabicLessonPage extends ConsumerStatefulWidget {
  const KidsArabicLessonPage({super.key, required this.letterId});

  final String letterId;

  @override
  ConsumerState<KidsArabicLessonPage> createState() =>
      _KidsArabicLessonPageState();
}

class _KidsArabicLessonPageState extends ConsumerState<KidsArabicLessonPage> {
  KidsArabicTraceMetrics _metrics = const KidsArabicTraceMetrics(
    strokeCount: 0,
    pointCount: 0,
  );
  String? _lastAutoPlayedLetterId;
  final GlobalKey<KidsArabicTracingPadState> _traceKey =
      GlobalKey<KidsArabicTracingPadState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(kidsArabicProgressProvider.notifier);
    final unlockedLetterIds = ref.watch(kidsArabicUnlockedLetterIdsProvider);
    final parentPreferences = ref.watch(kidsArabicParentPreferencesProvider);
    final letter = notifier.letterById(widget.letterId);
    if (letter == null) {
      return LearnHubPageScaffold(
        headerIcon: Icons.error_outline_rounded,
        title: l10n.kidsArabicLetterMissingTitle,
        subtitle: l10n.kidsArabicLetterMissingSubtitle,
        children: [Text(l10n.kidsArabicLetterMissingBody)],
      );
    }
    if (!unlockedLetterIds.contains(letter.id)) {
      return LearnHubPageScaffold(
        headerIcon: Icons.lock_outline_rounded,
        title: l10n.kidsArabicLockedTitle,
        subtitle: l10n.kidsArabicLockedSubtitle,
        children: [Text(l10n.kidsArabicLockedBody)],
      );
    }
    final nextLetter = nextKidsArabicLetter(letter.id);
    final guide = kidsArabicTracingGuideFor(letter.id);
    final liveResult = scoreKidsArabicTrace(letter: letter, metrics: _metrics);
    final encouragement = localizedKidsArabicTraceEncouragement(
      l10n,
      _metrics,
      liveResult,
    );
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
    if (parentPreferences.audioAutoplay &&
        _lastAutoPlayedLetterId != letter.id) {
      _lastAutoPlayedLetterId = letter.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(kidsArabicAudioServiceProvider).speakLetter(letter);
      });
    }

    return LearnHubPageScaffold(
      headerIcon: Icons.draw_rounded,
      title: l10n.kidsArabicLessonTitle(letter.glyph),
      subtitle: l10n.kidsArabicLessonSubtitle(letter.nameAr),
      children: [
        _GlyphHero(
          letter: letter,
          childLine: localizedKidsArabicChildLine(l10n, letter.id),
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
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonalIcon(
            onPressed: () =>
                ref.read(kidsArabicAudioServiceProvider).speakLetter(letter),
            icon: const Icon(Icons.volume_up_rounded),
            label: Text(l10n.kidsArabicPronunciationAction),
          ),
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
                glyph: letter.glyph,
                guide: guide,
                clearActionLabel: l10n.kidsArabicClearTraceAction,
                traceColorLabel: l10n.kidsArabicTraceColorLabel,
                readyBadgeLabel: l10n.kidsArabicTraceReadyBadge,
                colorOptions: tracingColors,
                onMetricsChanged: (metrics) {
                  setState(() {
                    _metrics = metrics;
                  });
                },
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
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  letter.exampleWordAr,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 26,
                    fontFamily: 'Noto Naskh Arabic',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5E462A),
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E261F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizedKidsArabicChildLine(l10n, letter.id),
                      style: const TextStyle(
                        color: Color(0xFF675B4E),
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
            color: const Color(0xFFEFF6E6),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD4E4C0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsArabicLessonRewardTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E261F),
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: !_metrics.minimumEffortMet
                      ? null
                      : () async {
                          final result = notifier.completeLesson(
                            letter: letter,
                            traceResult: liveResult,
                          );
                          if (!mounted) return;
                          await showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (sheetContext) {
                              return _CompletionSheet(
                                letter: letter,
                                result: result,
                                nextLetter: nextLetter,
                              );
                            },
                          );
                        },
                  child: Text(l10n.kidsArabicCompleteLessonAction),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlyphHero extends StatelessWidget {
  const _GlyphHero({required this.letter, required this.childLine});

  final KidsArabicLetter letter;
  final String childLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7D6C0)),
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
              style: const TextStyle(
                fontSize: 72,
                fontFamily: 'Noto Naskh Arabic',
                fontWeight: FontWeight.w700,
                color: Color(0xFF5E462A),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E261F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  letter.transliteration,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A6C49),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  childLine,
                  style: const TextStyle(
                    color: Color(0xFF675B4E),
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
        color: const Color(0xFFF8F2E8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5D5C1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
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
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5D5C1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            progressLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF8A6C49),
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
            style: const TextStyle(
              color: Color(0xFF675B4E),
              fontWeight: FontWeight.w600,
            ),
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
  });

  final KidsArabicLetter letter;
  final KidsArabicCompletionResult result;
  final KidsArabicLetter? nextLetter;

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
                    color: const Color(0xFFEFF6E6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter.glyph,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 42,
                      fontFamily: 'Noto Naskh Arabic',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF52713A),
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
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E261F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.kidsArabicCompletionSubtitle(letter.glyph, result.xpAwarded),
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.kidsArabicCompletionRewardRow(
                result.xpAwarded,
                result.oceanDropsAwarded,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF52713A),
              ),
            ),
            if (result.dailyMissionResult != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5E7),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE7D6C0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        result.dailyMissionResult!.currentStreak,
                      ),
                      style: const TextStyle(
                        color: Color(0xFF675B4E),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.kidsArabicDailyMissionRewardRow(
                        result.dailyMissionResult!.xpAwarded,
                        result.dailyMissionResult!.oceanDropsAwarded,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF52713A),
                      ),
                    ),
                    if (result.dailyMissionResult!.graceUsed) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.kidsArabicDailyMissionGraceUsed,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8A6C49),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      l10n.kidsArabicDailyMissionTomorrowPrompt,
                      style: const TextStyle(color: Color(0xFF675B4E)),
                    ),
                  ],
                ),
              ),
            ],
            if (nextLetter != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.kidsArabicCompletionNextUnlock(nextLetter!.glyph),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A6C49),
                ),
              ),
            ],
            const SizedBox(height: 14),
            if (result.newStickerIds.isNotEmpty)
              Text(
                l10n.kidsArabicStickerUnlocked(result.newStickerIds.length),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF52713A),
                ),
              ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.kidsArabicBackToLettersAction),
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
          ],
        ),
      ),
    );
  }
}
