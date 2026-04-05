import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_text_span.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_player_controller.dart';
import '../application/quran_providers.dart';
import '../application/quran_guided_passage_readiness_provider.dart';
import '../application/quran_short_surah_readiness_provider.dart';
import '../domain/quran_guided_passage_readiness_models.dart';
import '../domain/quran_playback_request.dart';
import '../domain/quran_readiness_bridge_models.dart';
import '../domain/quran_short_surah_readiness_models.dart';

class QuranShortSurahReadinessPage extends ConsumerStatefulWidget {
  const QuranShortSurahReadinessPage({
    super.key,
    required this.audience,
    this.initialSurahNumber,
  });

  final ArabicLearningAudience audience;
  final int? initialSurahNumber;

  @override
  ConsumerState<QuranShortSurahReadinessPage> createState() =>
      _QuranShortSurahReadinessPageState();
}

class _QuranShortSurahReadinessPageState
    extends ConsumerState<QuranShortSurahReadinessPage> {
  int? _selectedSurahNumber;
  int? _lastTrackedSurahNumber;
  int? _currentAyahNumber;
  bool _isPlaying = false;
  StreamSubscription<int?>? _currentIndexSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    final player = ref.read(quranSharedAudioPlayerProvider);
    _currentIndexSubscription = player.currentIndexStream.listen((index) {
      if (!mounted) {
        return;
      }
      setState(() {
        _currentAyahNumber = _resolveCurrentAyahNumber(index);
      });
    });
    _playerStateSubscription = player.playerStateStream.listen((state) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _currentIndexSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKids = widget.audience == ArabicLearningAudience.kids;
    final surahs = ref.watch(quranShortSurahReadinessSurahsProvider);
    final stages = ref.watch(quranShortSurahReadinessStagesProvider);
    final summary = ref.watch(
      quranShortSurahReadinessSummaryProvider(widget.audience),
    );
    final guidedPassages = ref.watch(
      quranGuidedPassageReadinessSummaryProvider(widget.audience),
    );
    final audioSettings = ref.watch(quranAudioSettingsProvider);
    final activeSession = ref.watch(quranActivePlaybackSessionProvider);
    final activeSurah = _resolveActiveSurah(surahs, summary);
    final activeIndex = activeSurah == null
        ? -1
        : surahs.indexWhere(
            (item) => item.surahNumber == activeSurah.surahNumber,
          );
    final previousSurah = activeIndex > 0 ? surahs[activeIndex - 1] : null;
    final nextSurah = activeIndex >= 0 && activeIndex + 1 < surahs.length
        ? surahs[activeIndex + 1]
        : null;
    final selectedSpeedSlow = audioSettings.playbackSpeed < 0.95;
    final isCurrentSurahSession =
        activeSurah != null &&
        activeSession?.surahNumber == activeSurah.surahNumber;

    if (activeSurah != null &&
        _lastTrackedSurahNumber != activeSurah.surahNumber) {
      _lastTrackedSurahNumber = activeSurah.surahNumber;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref
            .read(
              quranShortSurahReadinessProgressProvider(
                widget.audience,
              ).notifier,
            )
            .markSurahOpened(activeSurah.surahNumber);
      });
    }

    final content = <Widget>[
      PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isKids
                  ? l10n.quranShortSurahsKidsIntroTitle
                  : l10n.quranShortSurahsAdultIntroTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              isKids
                  ? l10n.quranShortSurahsKidsIntroSubtitle
                  : l10n.quranShortSurahsAdultIntroSubtitle,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ShortSurahSummaryChip(
                  label: l10n.quranShortSurahsCountValue(
                    summary.openedCount,
                    summary.totalCount,
                  ),
                ),
                _ShortSurahSummaryChip(
                  label: l10n.quranShortSurahsAyahCountValue(
                    activeSurah?.ayahCount ?? 0,
                  ),
                ),
                _ShortSurahSummaryChip(
                  label: summary.hasSnippetBridgeStarted
                      ? l10n.quranShortSurahsReadyFromBridge
                      : l10n.quranShortSurahsStartGently,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.arabicLearningPlaybackModeLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ReadinessChoicePill(
                  label: l10n.arabicLearningPlaybackModeNormal,
                  selected: !selectedSpeedSlow,
                  onTap: () => ref
                      .read(quranAudioSettingsProvider.notifier)
                      .setPlaybackSpeed(1.0),
                ),
                _ReadinessChoicePill(
                  label: l10n.arabicLearningPlaybackModeSlow,
                  selected: selectedSpeedSlow,
                  onTap: () => ref
                      .read(quranAudioSettingsProvider.notifier)
                      .setPlaybackSpeed(0.8),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quranShortSurahsProgressionTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(l10n.quranShortSurahsProgressionSubtitle),
            const SizedBox(height: 12),
            for (final stage in stages) ...[
              Text(
                _stageLabel(l10n, stage),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(_stageSubtitle(l10n, stage)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: surahs
                    .where((surah) => surah.stage == stage)
                    .map(
                      (surah) => _ReadinessChoicePill(
                        label: surah.surahTransliteratedName,
                        selected: activeSurah?.surahNumber == surah.surahNumber,
                        onTap: () {
                          setState(() {
                            _selectedSurahNumber = surah.surahNumber;
                          });
                        },
                      ),
                    )
                    .toList(growable: false),
              ),
              if (stage != stages.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),
    ];

    if (activeSurah != null) {
      content.add(
        PremiumCard(
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
                        Text(
                          activeSurah.surahArabicName,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 34,
                            fontFamily: 'AmiriQuran',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activeSurah.surahTransliteratedName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.quranShortSurahsSurahMeta(
                            activeSurah.surahTransliteratedName,
                            activeSurah.ayahCount,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppLayeredGlassPillButton(
                    onPressed: () => _toggleSurahPlayback(
                      activeSurah,
                      isCurrentSession: isCurrentSurahSession,
                    ),
                    leading: Icon(
                      isCurrentSurahSession && _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 18,
                    ),
                    label: isCurrentSurahSession && _isPlaying
                        ? l10n.quranShortSurahsPauseAction
                        : l10n.quranShortSurahsPlayAction,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppLayeredGlassPillButton(
                onPressed: () => openQuranReaderLocation(
                  context,
                  surahNumber: activeSurah.surahNumber,
                  autoplay: true,
                ),
                leading: const Icon(Icons.open_in_new_rounded, size: 18),
                label: l10n.quranShortSurahsOpenReaderAction,
              ),
              if (activeSurah.familiarSnippets.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.quranShortSurahsKnownSnippetsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranShortSurahsKnownSnippetsSubtitle),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: activeSurah.familiarSnippets
                      .map(
                        (snippet) => _ShortSurahSummaryChip(
                          label: snippet.snippetArabic,
                          rtl: true,
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              if (activeSurah.hints.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.quranReadinessPronunciationHintsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranReadinessPronunciationHintsSubtitle),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: activeSurah.hints
                      .map(
                        (hint) => _ShortSurahSummaryChip(
                          label: _hintLabel(l10n, hint.type),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: 16),
              for (final ayah in activeSurah.ayahs) ...[
                _SurahAyahCard(
                  ayah: ayah,
                  highlighted:
                      isCurrentSurahSession &&
                      _currentAyahNumber == ayah.ref.ayah,
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      );
      content.add(const SizedBox(height: 12));
      content.add(
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: previousSurah == null
                    ? null
                    : () => setState(() {
                        _selectedSurahNumber = previousSurah.surahNumber;
                      }),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.quranReadinessPreviousAction),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => setState(() {
                  _selectedSurahNumber =
                      nextSurah?.surahNumber ?? surahs.firstOrNull?.surahNumber;
                }),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(
                  nextSurah == null
                      ? l10n.quranReadinessReviewAgainAction
                      : l10n.quranReadinessNextAction,
                ),
              ),
            ),
          ],
        ),
      );
      content.add(const SizedBox(height: 12));
      content.add(_BridgeToGuidedPassagesCard(summary: guidedPassages));
    }

    if (isKids) {
      return LearnHubPageScaffold(
        showDefaultQuote: false,
        headerIcon: Icons.auto_stories_rounded,
        title: l10n.quranShortSurahsKidsPageTitle,
        subtitle: l10n.quranShortSurahsKidsPageSubtitle,
        children: content,
      );
    }

    return AppPageScaffold(
      title: l10n.quranShortSurahsAdultPageTitle,
      subtitle: l10n.quranShortSurahsAdultPageSubtitle,
      children: content,
    );
  }

  QuranShortSurahReadinessSurah? _resolveActiveSurah(
    List<QuranShortSurahReadinessSurah> surahs,
    QuranShortSurahReadinessSummary summary,
  ) {
    if (surahs.isEmpty) {
      return null;
    }
    for (final candidate in <int?>[
      _selectedSurahNumber,
      widget.initialSurahNumber,
      summary.surah.surahNumber,
    ]) {
      if (candidate == null) {
        continue;
      }
      for (final surah in surahs) {
        if (surah.surahNumber == candidate) {
          return surah;
        }
      }
    }
    return surahs.first;
  }

  int? _resolveCurrentAyahNumber(int? currentIndex) {
    final session = ref.read(quranActivePlaybackSessionProvider);
    if (session == null || currentIndex == null) {
      return null;
    }
    if (currentIndex < 0 || currentIndex >= session.ayahNumbers.length) {
      return null;
    }
    return session.ayahNumbers[currentIndex];
  }

  Future<void> _toggleSurahPlayback(
    QuranShortSurahReadinessSurah surah, {
    required bool isCurrentSession,
  }) async {
    final player = ref.read(quranSharedAudioPlayerProvider);
    if (isCurrentSession) {
      if (player.playing) {
        await ref.read(quranPlayerControllerProvider).pause();
      } else {
        await player.play();
      }
      return;
    }

    final settings = ref.read(quranAudioSettingsProvider);
    final ayahNumbers = surah.ayahs
        .map((ayah) => ayah.ref.ayah)
        .toList(growable: false);
    final prepared = await ref
        .read(quranPlaybackOrchestratorProvider)
        .startPlayback(
          request: QuranPlaybackRequest(
            surahNumber: surah.surahNumber,
            ayahNumber: 1,
            playbackReason: QuranPlaybackReason.lesson,
            isSurahEntry: true,
          ),
          reciterId: settings.reciterId,
          ayahNumbers: ayahNumbers,
          mode: ref.read(quranDefaultBismillahPlaybackModeProvider),
        );
    final controller = ref.read(quranPlayerControllerProvider);
    await controller.startPreparedPlayback(
      prepared,
      reciterId: settings.reciterId,
      playbackSpeed: settings.playbackSpeed,
      includeMediaTags: false,
    );
    controller.rememberSession(
      QuranActivePlaybackSession(
        surahNumber: surah.surahNumber,
        ayahNumbers: ayahNumbers,
        reciterId: settings.reciterId,
        playbackSpeed: settings.playbackSpeed,
        includeMediaTags: false,
        isSurahMode: true,
        bismillahMode: ref.read(quranDefaultBismillahPlaybackModeProvider),
      ),
    );
  }

  String _stageLabel(
    AppLocalizations l10n,
    QuranShortSurahReadinessStage stage,
  ) {
    switch (stage) {
      case QuranShortSurahReadinessStage.firstCompleteSurah:
        return l10n.quranShortSurahsStageOneTitle;
      case QuranShortSurahReadinessStage.gentleExpansion:
        return l10n.quranShortSurahsStageTwoTitle;
      case QuranShortSurahReadinessStage.protectionPair:
        return l10n.quranShortSurahsStageThreeTitle;
    }
  }

  String _stageSubtitle(
    AppLocalizations l10n,
    QuranShortSurahReadinessStage stage,
  ) {
    switch (stage) {
      case QuranShortSurahReadinessStage.firstCompleteSurah:
        return l10n.quranShortSurahsStageOneSubtitle;
      case QuranShortSurahReadinessStage.gentleExpansion:
        return l10n.quranShortSurahsStageTwoSubtitle;
      case QuranShortSurahReadinessStage.protectionPair:
        return l10n.quranShortSurahsStageThreeSubtitle;
    }
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

class _ShortSurahSummaryChip extends StatelessWidget {
  const _ShortSurahSummaryChip({required this.label, this.rtl = false});

  final String label;
  final bool rtl;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: style.decoration(radius: 999, includeShadow: false),
      child: Text(
        label,
        textDirection: rtl ? TextDirection.rtl : null,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ReadinessChoicePill extends StatelessWidget {
  const _ReadinessChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPillButton(
      onPressed: onTap,
      label: label,
      tintColor: selected ? AppColors.accentGoldSoft : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      foregroundColor: selected
          ? const Color(0xFF8A5A1F)
          : AppColors.onSurfaceSubtle,
    );
  }
}

class _SurahAyahCard extends StatelessWidget {
  const _SurahAyahCard({required this.ayah, required this.highlighted});

  final QuranShortSurahReadinessAyah ayah;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        Theme.of(context).textTheme.headlineSmall?.copyWith(
          height: 1.7,
          fontFamily: 'AmiriQuran',
          fontWeight: FontWeight.w700,
        ) ??
        const TextStyle(fontSize: 30, height: 1.7, fontFamily: 'AmiriQuran');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: highlighted ? const Color(0xFFFFF1D8) : const Color(0xFFF9F6F1),
        border: Border.all(
          color: highlighted
              ? AppColors.accentGoldSoft
              : const Color(0xFFE6DDD1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(
              context,
            ).quranShortSurahsAyahLabel(ayah.ref.ayah),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            text: buildQuranTextWithColoredHarakat(
              ayah.arabic,
              baseStyle.copyWith(
                color: highlighted ? const Color(0xFF8A5A1F) : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ayah.translation,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
        ],
      ),
    );
  }
}
