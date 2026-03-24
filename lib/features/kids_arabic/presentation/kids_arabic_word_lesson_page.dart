import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../arabic/presentation/widgets/arabic_learning_playback_speed_toggle.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_achievements_provider.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../application/kids_arabic_words_provider.dart';
import '../data/kids_arabic_beginner_words_data.dart';
import '../domain/kids_arabic_achievement_models.dart';
import '../domain/kids_arabic_models.dart';
import '../widgets/kids_arabic_audio_learning_widgets.dart';
import '../widgets/kids_arabic_tracing_pad.dart';
import 'kids_arabic_localized_content.dart';

class KidsArabicWordLessonPage extends ConsumerStatefulWidget {
  const KidsArabicWordLessonPage({
    super.key,
    required this.wordId,
    this.initialMetrics = const KidsArabicTraceMetrics(
      strokeCount: 0,
      pointCount: 0,
    ),
  });

  final String wordId;
  final KidsArabicTraceMetrics initialMetrics;

  @override
  ConsumerState<KidsArabicWordLessonPage> createState() =>
      _KidsArabicWordLessonPageState();
}

class _KidsArabicWordLessonPageState
    extends ConsumerState<KidsArabicWordLessonPage> {
  late KidsArabicTraceMetrics _metrics;
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
  void dispose() {
    _completionRevealTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledInitialCompletionState || !_metrics.successPulse) {
      return;
    }
    final word = kidsArabicBeginnerWordById(widget.wordId);
    if (word == null) {
      return;
    }
    _handledInitialCompletionState = true;
    final parentPreferences = ref.read(kidsArabicParentPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _primeCompletionPresentation(
        wordAr: word.wordAr,
        audioAutoplay: parentPreferences.audioAutoplay,
      );
    });
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

  void _primeCompletionPresentation({
    required String wordAr,
    required bool audioAutoplay,
  }) {
    if (!_metrics.successPulse) {
      return;
    }
    _completionRevealTimer?.cancel();
    _showCompletionActions = false;
    _completionRevealTimer = Timer(const Duration(milliseconds: 320), () {
      if (!mounted || !_metrics.successPulse) {
        return;
      }
      setState(() {
        _showCompletionActions = true;
      });
    });
    if (!_hasTracedOnPage ||
        _completionAudioPlayedForAttempt ||
        !audioAutoplay) {
      return;
    }
    _completionAudioPlayedForAttempt = true;
    Future<void>.delayed(const Duration(milliseconds: 220), () async {
      if (!mounted || !_metrics.successPulse) {
        return;
      }
      await ref.read(kidsArabicAudioServiceProvider).speakText(wordAr);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final word = kidsArabicBeginnerWordById(widget.wordId);
    if (word == null) {
      return LearnHubPageScaffold(
        headerIcon: Icons.error_outline_rounded,
        title: l10n.kidsArabicWordsMissingTitle,
        subtitle: l10n.kidsArabicWordsMissingSubtitle,
        children: [Text(l10n.kidsArabicWordsMissingBody)],
      );
    }

    final completedLetters = ref
        .watch(kidsArabicProgressProvider)
        .completedLetterIds;
    final parentPreferences = ref.watch(kidsArabicParentPreferencesProvider);
    final unlocked = completedLetters.containsAll(
      word.requiredCompletedLetterIds,
    );
    if (!unlocked) {
      return LearnHubPageScaffold(
        headerIcon: Icons.lock_outline_rounded,
        title: l10n.kidsArabicWordsLockedTitle,
        subtitle: l10n.kidsArabicWordsLockedSubtitle,
        children: [
          Text(
            localizedKidsArabicRequiredLettersLabel(l10n, word.joiningExamples),
          ),
        ],
      );
    }

    final words = ref.watch(kidsArabicBeginnerWordsProvider);
    final index = words.indexWhere((item) => item.id == word.id);
    final nextWord = index >= 0 && index + 1 < words.length
        ? words[index + 1]
        : null;
    return LearnHubPageScaffold(
      headerIcon: Icons.spellcheck_rounded,
      title: l10n.kidsArabicWordLessonTitle(word.wordAr),
      subtitle: l10n.kidsArabicWordLessonSubtitle(
        localizedKidsArabicWordMeaning(l10n, word.id),
      ),
      children: [
        const ArabicLearningPlaybackSpeedToggle(
          variant: ArabicLearningPlaybackToggleVariant.kids,
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => ref.read(kidsArabicAudioServiceProvider).speakWord(word),
          borderRadius: BorderRadius.circular(22),
          child: Container(
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
                  word.wordAr,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: 'Noto Naskh Arabic',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5E462A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  word.transliteration,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A6C49),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  localizedKidsArabicWordSummary(l10n, word.id),
                  style: const TextStyle(
                    color: Color(0xFF675B4E),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: word.joiningExamples
                      .map(
                        (example) => _WordLetterChip(
                          name: localizedKidsArabicJoiningLetterName(
                            l10n,
                            example.letterId,
                          ),
                          joinedGlyph: example.joinedGlyph,
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        KidsArabicRepeatAfterMeCard(
          autoplayToken: word.id,
          displayText: word.wordAr,
          title: l10n.kidsArabicRepeatAfterMeTitle,
          subtitle: l10n.kidsArabicRepeatAfterMeWordSubtitle,
          listenLabel: l10n.kidsArabicWordListenAction,
          repeatPromptLabel: l10n.kidsArabicRepeatAfterMePrompt,
          autoplayEnabled: parentPreferences.audioAutoplay,
          onPlay: () =>
              ref.read(kidsArabicAudioServiceProvider).speakWord(word),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsArabicWordsJoiningTitle,
          subtitle: l10n.kidsArabicWordsWordLessonJoiningSubtitle,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: word.joiningExamples
              .map(
                (example) => _JoiningCard(
                  letterName: localizedKidsArabicJoiningLetterName(
                    l10n,
                    example.letterId,
                  ),
                  standaloneGlyph: example.standaloneGlyph,
                  joinedGlyph: example.joinedGlyph,
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsArabicWordTraceTitle,
          subtitle: l10n.kidsArabicWordTraceSubtitle,
        ),
        const SizedBox(height: 10),
        KidsArabicTracingPad(
          key: _traceKey,
          letterId: word.id,
          guide: word.guide,
          clearActionLabel: l10n.kidsArabicWordTryAgainAction,
          traceColorLabel: l10n.kidsArabicTraceColorLabel,
          readyBadgeLabel: l10n.kidsArabicWordReadyBadge,
          colorOptions: <KidsArabicTracingColorOption>[
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
          ],
          onMetricsChanged: (metrics) {
            final becameSuccessful =
                metrics.successPulse && !_metrics.successPulse;
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
            if (becameSuccessful) {
              _primeCompletionPresentation(
                wordAr: word.wordAr,
                audioAutoplay: parentPreferences.audioAutoplay,
              );
            }
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (_showCompletionActions)
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    ref
                        .read(kidsArabicWordProgressProvider.notifier)
                        .completeWord(word.id);
                    final achievement = ref.read(
                      kidsArabicAchievementCelebrationProvider,
                    );
                    if (achievement != null) {
                      ref
                          .read(kidsArabicAchievementsUiProvider.notifier)
                          .markCelebrationSeen(achievement.id);
                    }
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (sheetContext) {
                        return _WordCompletionSheet(
                          wordId: word.id,
                          wordAr: word.wordAr,
                          nextWordId: nextWord?.id,
                          nextWordAr: nextWord?.wordAr,
                          achievement: achievement,
                          onTryAgain: () {
                            Navigator.of(sheetContext).pop();
                            _resetTrace();
                          },
                        );
                      },
                    );
                  },
                  child: Text(l10n.kidsArabicWordsContinueAction),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _WordCompletionSheet extends StatelessWidget {
  const _WordCompletionSheet({
    required this.wordId,
    required this.wordAr,
    required this.onTryAgain,
    required this.achievement,
    this.nextWordId,
    this.nextWordAr,
  });

  final String wordId;
  final String wordAr;
  final String? nextWordId;
  final String? nextWordAr;
  final KidsArabicAchievementDefinition? achievement;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.kidsArabicWordCompleteTitle(wordAr),
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E261F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.kidsArabicWordCompleteSubtitle,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
            ),
            if (achievement != null) ...[
              const SizedBox(height: 14),
              _WordAchievementRevealCard(achievement: achievement!),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.tonal(
                  onPressed: onTryAgain,
                  child: Text(l10n.kidsArabicWordTryAgainAction),
                ),
                if (nextWordId != null)
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.goNamed(
                        'kidsArabicWordLesson',
                        pathParameters: {'wordId': nextWordId!},
                      );
                    },
                    child: Text(l10n.kidsArabicWordNextAction(nextWordAr!)),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.goNamed('kidsArabicWordsHome');
                  },
                  child: Text(l10n.kidsArabicWordsHomeAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WordAchievementRevealCard extends StatelessWidget {
  const _WordAchievementRevealCard({required this.achievement});

  final KidsArabicAchievementDefinition achievement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E7),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E261F),
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

class _JoiningCard extends StatelessWidget {
  const _JoiningCard({
    required this.letterName,
    required this.standaloneGlyph,
    required this.joinedGlyph,
  });

  final String letterName;
  final String standaloneGlyph;
  final String joinedGlyph;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0E6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6D7C5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            letterName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.kidsArabicWordsAloneLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8A6C49),
            ),
          ),
          Text(
            standaloneGlyph,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 28,
              fontFamily: 'Noto Naskh Arabic',
              fontWeight: FontWeight.w700,
              color: Color(0xFF5E462A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.kidsArabicWordsInWordLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8A6C49),
            ),
          ),
          Text(
            joinedGlyph,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 28,
              fontFamily: 'Noto Naskh Arabic',
              fontWeight: FontWeight.w700,
              color: Color(0xFF5E462A),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordLetterChip extends StatelessWidget {
  const _WordLetterChip({required this.name, required this.joinedGlyph});

  final String name;
  final String joinedGlyph;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2D2BC)),
      ),
      child: Text(
        '$joinedGlyph $name',
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B583F),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E261F),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
        ),
      ],
    );
  }
}
