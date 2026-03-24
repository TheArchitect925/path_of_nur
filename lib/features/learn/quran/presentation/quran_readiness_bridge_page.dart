import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../../../../shared/widgets/quran_text_span.dart';
import '../../../arabic/application/arabic_learning_audio_controller.dart';
import '../../../arabic/application/arabic_learning_lesson_packs_provider.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../../arabic/domain/arabic_learning_lesson_pack_models.dart';
import '../../../arabic/presentation/arabic_learning_lesson_pack_localizations.dart';
import '../../../arabic/presentation/arabic_learning_route_target_navigation.dart';
import '../../../arabic/presentation/widgets/arabic_learning_playback_speed_toggle.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_readiness_bridge_provider.dart';
import '../application/quran_guided_passage_readiness_provider.dart';
import '../application/quran_short_surah_readiness_provider.dart';
import '../../quran_teaching/application/quran_teaching_controller.dart';
import '../../quran_teaching/domain/quran_teaching_models.dart';
import '../domain/quran_guided_passage_readiness_models.dart';
import '../domain/quran_readiness_bridge_models.dart';
import '../domain/quran_short_surah_readiness_models.dart';

class QuranReadinessBridgePage extends ConsumerStatefulWidget {
  const QuranReadinessBridgePage({
    super.key,
    required this.audience,
    this.initialSnippetId,
  });

  final ArabicLearningAudience audience;
  final String? initialSnippetId;

  @override
  ConsumerState<QuranReadinessBridgePage> createState() =>
      _QuranReadinessBridgePageState();
}

class _QuranReadinessBridgePageState
    extends ConsumerState<QuranReadinessBridgePage> {
  String? _selectedSnippetId;
  String? _lastTrackedSnippetId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKids = widget.audience == ArabicLearningAudience.kids;
    final snippets = ref.watch(quranReadinessBridgeSnippetsProvider);
    final summary = ref.watch(
      quranReadinessBridgeSummaryProvider(widget.audience),
    );
    final shortSurahs = ref.watch(
      quranShortSurahReadinessSummaryProvider(widget.audience),
    );
    final guidedPassages = ref.watch(
      quranGuidedPassageReadinessSummaryProvider(widget.audience),
    );
    final levels = ref.watch(quranReadinessBridgeLevelsProvider);
    final audioState = ref.watch(arabicLearningAudioControllerProvider);
    final lessonPacks = ref.watch(
      arabicLearningLessonPacksProvider(widget.audience),
    );
    final adultCatalog = isKids
        ? null
        : ref.watch(quranTeachingCatalogProvider);
    final quranLinkedThemePack = _resolveQuranLinkedThemePack(
      lessonPacks,
      isKids: isKids,
    );
    final activeSnippet = _resolveActiveSnippet(snippets, summary);
    final activeIndex = activeSnippet == null
        ? -1
        : snippets.indexWhere((item) => item.id == activeSnippet.id);
    final previousSnippet = activeIndex > 0 ? snippets[activeIndex - 1] : null;
    final nextSnippet = activeIndex >= 0 && activeIndex + 1 < snippets.length
        ? snippets[activeIndex + 1]
        : null;

    if (activeSnippet != null && _lastTrackedSnippetId != activeSnippet.id) {
      _lastTrackedSnippetId = activeSnippet.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref
            .read(
              quranReadinessBridgeProgressProvider(widget.audience).notifier,
            )
            .markSnippetOpened(activeSnippet.id);
      });
    }

    final content = <Widget>[
      PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isKids
                  ? l10n.quranReadinessKidsIntroTitle
                  : l10n.quranReadinessAdultIntroTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              isKids
                  ? l10n.quranReadinessKidsIntroSubtitle
                  : l10n.quranReadinessAdultIntroSubtitle,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _BridgeSummaryChip(
                  label: l10n.quranReadinessCountValue(
                    summary.openedCount,
                    summary.totalCount,
                  ),
                ),
                _BridgeSummaryChip(
                  label: l10n.quranReadinessLevelProgressValue(
                    _levelLabel(l10n, summary.currentLevel),
                    _levelOpenedCount(summary),
                    _levelTotalCount(summary),
                  ),
                ),
                _BridgeSummaryChip(
                  label: summary.hasArabicFoundationStarted
                      ? l10n.quranReadinessReadyFromArabic
                      : l10n.quranReadinessStartGently,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const ArabicLearningPlaybackSpeedToggle(),
          ],
        ),
      ),
      const SizedBox(height: 12),
      PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quranReadinessProgressionTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(l10n.quranReadinessProgressionSubtitle),
            const SizedBox(height: 12),
            for (final level in levels) ...[
              Text(
                _levelLabel(l10n, level),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(_levelSubtitle(l10n, level)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: snippets
                    .where((snippet) => snippet.level == level)
                    .map(
                      (snippet) => ChoiceChip(
                        label: Text(snippet.transliteration),
                        selected: activeSnippet?.id == snippet.id,
                        onSelected: (_) {
                          setState(() {
                            _selectedSnippetId = snippet.id;
                          });
                        },
                      ),
                    )
                    .toList(growable: false),
              ),
              if (level != levels.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),
    ];

    if (activeSnippet != null) {
      final isPlaying =
          audioState.activePlaybackId == 'quran_readiness:${activeSnippet.id}';
      content.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isPlaying
                  ? (isKids
                        ? const Color(0xFF9ED081)
                        : AppColors.accentGoldSoft)
                  : const Color(0xFFE2D9CB),
              width: isPlaying ? 1.6 : 1,
            ),
            boxShadow: isPlaying
                ? [
                    BoxShadow(
                      color:
                          (isKids
                                  ? const Color(0xFFB8E39E)
                                  : AppColors.accentGoldSoft)
                              .withValues(alpha: 0.22),
                      blurRadius: 18,
                    ),
                  ]
                : const [],
          ),
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            text: _buildSnippetSpan(
                              context,
                              snippet: activeSnippet,
                              isPlaying: isPlaying,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            activeSnippet.transliteration,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(activeSnippet.simpleMeaning),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filledTonal(
                      onPressed: () => _playSnippet(activeSnippet),
                      tooltip: l10n.quranReadinessPlaySnippetAction,
                      icon: Icon(
                        isPlaying
                            ? Icons.volume_up_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  activeSnippet.sharedPhrase != null
                      ? (isKids
                            ? l10n.quranReadinessKnownPhraseKidsTitle
                            : l10n.quranReadinessKnownPhraseAdultTitle)
                      : (isKids
                            ? l10n.quranReadinessRecognitionKidsTitle
                            : l10n.quranReadinessRecognitionAdultTitle),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  activeSnippet.sharedPhrase != null
                      ? (isKids
                            ? l10n.quranReadinessKnownPhraseKidsSubtitle
                            : l10n.quranReadinessKnownPhraseAdultSubtitle)
                      : (isKids
                            ? l10n.quranReadinessRecognitionKidsSubtitle
                            : l10n.quranReadinessRecognitionAdultSubtitle),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (activeSnippet.sharedPhrase != null)
                      _BridgeSummaryChip(
                        label: activeSnippet.sharedPhrase!.arabicText,
                        rtl: true,
                      ),
                    ...activeSnippet.familiarWords.map(
                      (word) =>
                          _BridgeSummaryChip(label: word.arabicText, rtl: true),
                    ),
                    if (activeSnippet.sharedPhrase == null &&
                        activeSnippet.familiarWords.isEmpty)
                      _BridgeSummaryChip(
                        label: activeSnippet.snippetArabic,
                        rtl: true,
                      ),
                  ],
                ),
                if (activeSnippet.hints.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.quranReadinessPronunciationHintsTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.quranReadinessPronunciationHintsSubtitle),
                  const SizedBox(height: 10),
                  ...activeSnippet.hints.map((hint) {
                    final target = hint.targetForAudience(widget.audience);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: _hintColor(
                            hint.type,
                          ).withValues(alpha: isKids ? 0.16 : 0.12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _hintIcon(hint.type),
                              size: 18,
                              color: _hintColor(hint.type),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _hintLabel(l10n, hint.type),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _hintDescription(
                                      l10n,
                                      hint.type,
                                      hint.focusArabic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (target != null) ...[
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => openArabicLearningRouteTarget(
                                  context,
                                  target: target,
                                  adultCatalog: adultCatalog,
                                ),
                                child: Text(
                                  l10n.quranReadinessPronunciationHintsOpenAction,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 16),
                Text(
                  isKids
                      ? l10n.quranReadinessAyahContextKidsTitle
                      : l10n.quranReadinessAyahContextAdultTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  text: _buildContextSpan(
                    context,
                    ayahArabic: activeSnippet.ayahArabic,
                    snippetArabic: activeSnippet.snippetArabic,
                    isPlaying: isPlaying,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  activeSnippet.ayahTranslation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 12),
                QuranReferenceLinkTile.forRef(
                  referenceLabel:
                      '${activeSnippet.surahName} • ${activeSnippet.ref.locationLabel}',
                  ref: activeSnippet.ref,
                  subtitle: l10n.quranReadinessOpenFullAyahHint,
                  margin: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      );
      content.add(const SizedBox(height: 12));
      content.add(
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: previousSnippet == null
                    ? null
                    : () => setState(() {
                        _selectedSnippetId = previousSnippet.id;
                      }),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.quranReadinessPreviousAction),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => setState(() {
                  _selectedSnippetId =
                      nextSnippet?.id ?? snippets.firstOrNull?.id;
                }),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(
                  nextSnippet == null
                      ? l10n.quranReadinessReviewAgainAction
                      : l10n.quranReadinessNextAction,
                ),
              ),
            ),
          ],
        ),
      );
      content.add(const SizedBox(height: 12));
      content.add(_BridgeToShortSurahsCard(summary: shortSurahs));
      content.add(const SizedBox(height: 12));
      content.add(_BridgeToGuidedPassagesCard(summary: guidedPassages));
      content.add(const SizedBox(height: 12));
      if (quranLinkedThemePack != null) {
        content.add(
          _BridgeToVocabularyThemeCard(
            pack: quranLinkedThemePack,
            adultCatalog: adultCatalog,
          ),
        );
      }
    }

    if (isKids) {
      return LearnHubPageScaffold(
        showDefaultQuote: false,
        headerIcon: Icons.menu_book_rounded,
        title: l10n.quranReadinessKidsPageTitle,
        subtitle: l10n.quranReadinessKidsPageSubtitle,
        children: content,
      );
    }

    return AppPageScaffold(
      title: l10n.quranReadinessAdultPageTitle,
      subtitle: l10n.quranReadinessAdultPageSubtitle,
      children: content,
    );
  }

  ArabicLearningLessonPack? _resolveQuranLinkedThemePack(
    List<ArabicLearningLessonPack> lessonPacks, {
    required bool isKids,
  }) {
    final preferredId = isKids
        ? 'kids_quran_linked_words_theme_pack'
        : 'adult_quran_linked_words_theme_pack';
    for (final pack in lessonPacks) {
      if (pack.id == preferredId) {
        return pack;
      }
    }
    for (final pack in lessonPacks) {
      if (pack.type == ArabicLearningLessonPackType.theme) {
        return pack;
      }
    }
    return null;
  }

  QuranReadinessBridgeSnippet? _resolveActiveSnippet(
    List<QuranReadinessBridgeSnippet> snippets,
    QuranReadinessBridgeSummary summary,
  ) {
    if (snippets.isEmpty) {
      return null;
    }
    for (final candidateId in <String?>[
      _selectedSnippetId,
      widget.initialSnippetId,
      summary.snippet.id,
    ]) {
      if (candidateId == null) {
        continue;
      }
      for (final snippet in snippets) {
        if (snippet.id == candidateId) {
          return snippet;
        }
      }
    }
    return snippets.first;
  }

  Future<void> _playSnippet(QuranReadinessBridgeSnippet snippet) async {
    final played = await ref
        .read(arabicLearningAudioControllerProvider.notifier)
        .playResolvedAudio(
          playbackId: 'quran_readiness:${snippet.id}',
          primaryAssetPath: snippet.audioAssetPath,
          fallbackText: snippet.snippetArabic,
        );
    if (!played && mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quranReadinessAudioUnavailable)),
      );
    }
  }

  String _levelLabel(AppLocalizations l10n, QuranReadinessBridgeLevel level) {
    switch (level) {
      case QuranReadinessBridgeLevel.firstRecognition:
        return l10n.quranReadinessLevelOneTitle;
      case QuranReadinessBridgeLevel.familiarPhrases:
        return l10n.quranReadinessLevelTwoTitle;
      case QuranReadinessBridgeLevel.ayahConfidence:
        return l10n.quranReadinessLevelThreeTitle;
    }
  }

  String _levelSubtitle(
    AppLocalizations l10n,
    QuranReadinessBridgeLevel level,
  ) {
    switch (level) {
      case QuranReadinessBridgeLevel.firstRecognition:
        return l10n.quranReadinessLevelOneSubtitle;
      case QuranReadinessBridgeLevel.familiarPhrases:
        return l10n.quranReadinessLevelTwoSubtitle;
      case QuranReadinessBridgeLevel.ayahConfidence:
        return l10n.quranReadinessLevelThreeSubtitle;
    }
  }

  int _levelOpenedCount(QuranReadinessBridgeSummary summary) {
    for (final levelSummary in summary.levelSummaries) {
      if (levelSummary.level == summary.currentLevel) {
        return levelSummary.openedCount;
      }
    }
    return 0;
  }

  int _levelTotalCount(QuranReadinessBridgeSummary summary) {
    for (final levelSummary in summary.levelSummaries) {
      if (levelSummary.level == summary.currentLevel) {
        return levelSummary.totalCount;
      }
    }
    return 0;
  }

  TextSpan _buildSnippetSpan(
    BuildContext context, {
    required QuranReadinessBridgeSnippet snippet,
    required bool isPlaying,
  }) {
    final baseStyle = const TextStyle(
      fontSize: 38,
      fontFamily: 'AmiriQuran',
      fontWeight: FontWeight.w700,
      height: 1.6,
    );
    final matches = <_SnippetHighlightMatch>[];
    for (final hint in snippet.hints) {
      final start = snippet.snippetArabic.indexOf(hint.focusArabic);
      if (start < 0) {
        continue;
      }
      matches.add(
        _SnippetHighlightMatch(
          start: start,
          end: start + hint.focusArabic.length,
          type: hint.type,
        ),
      );
    }
    matches.sort((a, b) => a.start.compareTo(b.start));
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in matches) {
      if (match.start < cursor) {
        continue;
      }
      if (match.start > cursor) {
        spans.add(
          TextSpan(text: snippet.snippetArabic.substring(cursor, match.start)),
        );
      }
      spans.add(
        TextSpan(
          text: snippet.snippetArabic.substring(match.start, match.end),
          style: baseStyle.copyWith(
            color: isPlaying ? _hintColor(match.type) : null,
            backgroundColor: _hintColor(
              match.type,
            ).withValues(alpha: isPlaying ? 0.22 : 0.14),
          ),
        ),
      );
      cursor = match.end;
    }
    if (cursor < snippet.snippetArabic.length) {
      spans.add(TextSpan(text: snippet.snippetArabic.substring(cursor)));
    }
    return TextSpan(style: baseStyle, children: spans);
  }

  TextSpan _buildContextSpan(
    BuildContext context, {
    required String ayahArabic,
    required String snippetArabic,
    required bool isPlaying,
  }) {
    final baseStyle =
        Theme.of(context).textTheme.headlineSmall?.copyWith(
          height: 1.7,
          fontFamily: 'AmiriQuran',
          fontWeight: FontWeight.w700,
        ) ??
        const TextStyle(fontSize: 30, height: 1.7, fontFamily: 'AmiriQuran');
    final start = ayahArabic.indexOf(snippetArabic);
    if (start < 0) {
      return buildQuranTextWithColoredHarakat(ayahArabic, baseStyle);
    }
    final end = start + snippetArabic.length;
    return TextSpan(
      children: [
        if (start > 0)
          buildQuranTextWithColoredHarakat(
            ayahArabic.substring(0, start),
            baseStyle,
          ),
        TextSpan(
          text: snippetArabic,
          style: baseStyle.copyWith(
            color: isPlaying
                ? const Color(0xFF8A5A1F)
                : AppColors.accentGoldSoft,
            backgroundColor:
                (isPlaying ? const Color(0xFFFFE5B6) : const Color(0xFFF9EBCF))
                    .withValues(alpha: 0.9),
          ),
        ),
        if (end < ayahArabic.length)
          buildQuranTextWithColoredHarakat(
            ayahArabic.substring(end),
            baseStyle,
          ),
      ],
    );
  }

  String _hintLabel(
    AppLocalizations l10n,
    QuranReadinessPronunciationHintType type,
  ) {
    switch (type) {
      case QuranReadinessPronunciationHintType.clear:
        return l10n.quranReadinessHintClearLabel;
      case QuranReadinessPronunciationHintType.stretch:
        return l10n.quranReadinessHintStretchLabel;
      case QuranReadinessPronunciationHintType.bounce:
        return l10n.quranReadinessHintBounceLabel;
      case QuranReadinessPronunciationHintType.nasal:
        return l10n.quranReadinessHintNasalLabel;
    }
  }

  String _hintDescription(
    AppLocalizations l10n,
    QuranReadinessPronunciationHintType type,
    String focusArabic,
  ) {
    switch (type) {
      case QuranReadinessPronunciationHintType.clear:
        return l10n.quranReadinessHintClearDescription(focusArabic);
      case QuranReadinessPronunciationHintType.stretch:
        return l10n.quranReadinessHintStretchDescription(focusArabic);
      case QuranReadinessPronunciationHintType.bounce:
        return l10n.quranReadinessHintBounceDescription(focusArabic);
      case QuranReadinessPronunciationHintType.nasal:
        return l10n.quranReadinessHintNasalDescription(focusArabic);
    }
  }

  IconData _hintIcon(QuranReadinessPronunciationHintType type) {
    switch (type) {
      case QuranReadinessPronunciationHintType.clear:
        return Icons.record_voice_over_rounded;
      case QuranReadinessPronunciationHintType.stretch:
        return Icons.swap_horiz_rounded;
      case QuranReadinessPronunciationHintType.bounce:
        return Icons.keyboard_double_arrow_up_rounded;
      case QuranReadinessPronunciationHintType.nasal:
        return Icons.air_rounded;
    }
  }

  Color _hintColor(QuranReadinessPronunciationHintType type) {
    switch (type) {
      case QuranReadinessPronunciationHintType.clear:
        return const Color(0xFF5A7C92);
      case QuranReadinessPronunciationHintType.stretch:
        return const Color(0xFF7E6BBD);
      case QuranReadinessPronunciationHintType.bounce:
        return const Color(0xFF8A5A1F);
      case QuranReadinessPronunciationHintType.nasal:
        return const Color(0xFF4F7D73);
    }
  }
}

class _BridgeToShortSurahsCard extends StatelessWidget {
  const _BridgeToShortSurahsCard({required this.summary});

  final QuranShortSurahReadinessSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKids = summary.audience == ArabicLearningAudience.kids;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isKids
                ? l10n.quranShortSurahsKidsCardTitle
                : l10n.quranShortSurahsAdultCardTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            isKids
                ? l10n.quranShortSurahsBridgeKidsSubtitle(
                    summary.surah.surahTransliteratedName,
                  )
                : l10n.quranShortSurahsBridgeAdultSubtitle(
                    summary.surah.surahTransliteratedName,
                  ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              summary.routeName,
              queryParameters: <String, String>{
                'surah': summary.surah.surahNumber.toString(),
              },
            ),
            icon: const Icon(Icons.auto_stories_rounded),
            label: Text(switch (summary.intent) {
              ArabicLearningContinuationIntent.review =>
                isKids
                    ? l10n.quranShortSurahsKidsReviewAction
                    : l10n.quranShortSurahsAdultReviewAction,
              ArabicLearningContinuationIntent.continueForward =>
                isKids
                    ? l10n.quranShortSurahsKidsContinueAction
                    : l10n.quranShortSurahsAdultContinueAction,
              _ =>
                isKids
                    ? l10n.quranShortSurahsKidsStartAction
                    : l10n.quranShortSurahsAdultStartAction,
            }),
          ),
        ],
      ),
    );
  }
}

class _BridgeToGuidedPassagesCard extends StatelessWidget {
  const _BridgeToGuidedPassagesCard({required this.summary});

  final QuranGuidedPassageReadinessSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKids = summary.audience == ArabicLearningAudience.kids;
    final actionLabel = switch (summary.intent) {
      ArabicLearningContinuationIntent.start =>
        isKids
            ? l10n.quranGuidedPassagesKidsStartAction
            : l10n.quranGuidedPassagesAdultStartAction,
      ArabicLearningContinuationIntent.review =>
        isKids
            ? l10n.quranGuidedPassagesKidsReviewAction
            : l10n.quranGuidedPassagesAdultReviewAction,
      ArabicLearningContinuationIntent.resume ||
      ArabicLearningContinuationIntent.continueForward =>
        isKids
            ? l10n.quranGuidedPassagesKidsContinueAction
            : l10n.quranGuidedPassagesAdultContinueAction,
    };

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isKids
                ? l10n.quranGuidedPassagesKidsCardTitle
                : l10n.quranGuidedPassagesAdultCardTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            summary.openedCount > 0
                ? (isKids
                      ? l10n.quranGuidedPassagesBridgeKidsSubtitle(
                          _guidedPassageTitle(l10n, summary.passage.id),
                        )
                      : l10n.quranGuidedPassagesBridgeAdultSubtitle(
                          _guidedPassageTitle(l10n, summary.passage.id),
                        ))
                : (isKids
                      ? l10n.quranGuidedPassagesKidsCardStartSubtitle
                      : l10n.quranGuidedPassagesAdultCardStartSubtitle),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              summary.routeName,
              queryParameters: <String, String>{'passage': summary.passage.id},
            ),
            icon: const Icon(Icons.auto_stories_rounded),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _BridgeToVocabularyThemeCard extends StatelessWidget {
  const _BridgeToVocabularyThemeCard({
    required this.pack,
    required this.adultCatalog,
  });

  final ArabicLearningLessonPack pack;
  final QuranTeachingCatalog? adultCatalog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizedArabicLearningLessonPackTitle(l10n, pack.id),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(localizedArabicLearningLessonPackSubtitle(l10n, pack.id)),
          if (pack.previewArabic.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              pack.previewArabic.take(3).join('  •  '),
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'AmiriQuran',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => openArabicLearningRouteTarget(
              context,
              target: pack.primaryTarget,
              adultCatalog: adultCatalog,
            ),
            icon: const Icon(Icons.translate_rounded),
            label: Text(
              pack.isRecommended
                  ? l10n.arabicLearningLessonPacksContinueAction
                  : l10n.arabicLearningLessonPacksOpenAction,
            ),
          ),
        ],
      ),
    );
  }
}

String _guidedPassageTitle(AppLocalizations l10n, String passageId) {
  switch (passageId) {
    case 'fatihah_opening_passage':
      return l10n.quranGuidedPassagesOpeningTitle;
    case 'fatihah_response_passage':
      return l10n.quranGuidedPassagesResponseTitle;
    case 'fatihah_full_passage':
      return l10n.quranGuidedPassagesFullTitle;
  }
  return passageId;
}

class _SnippetHighlightMatch {
  const _SnippetHighlightMatch({
    required this.start,
    required this.end,
    required this.type,
  });

  final int start;
  final int end;
  final QuranReadinessPronunciationHintType type;
}

class _BridgeSummaryChip extends StatelessWidget {
  const _BridgeSummaryChip({required this.label, this.rtl = false});

  final String label;
  final bool rtl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surfaceSoft.withValues(alpha: 0.55),
      ),
      child: Text(
        label,
        textDirection: rtl ? TextDirection.rtl : null,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
