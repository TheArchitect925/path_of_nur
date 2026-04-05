import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_text_span.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_guided_passage_readiness_provider.dart';
import '../application/quran_player_controller.dart';
import '../application/quran_providers.dart';
import '../domain/quran_guided_passage_readiness_models.dart';
import '../domain/quran_playback_request.dart';
import '../domain/quran_readiness_bridge_models.dart';

class QuranGuidedPassageReadinessPage extends ConsumerStatefulWidget {
  const QuranGuidedPassageReadinessPage({
    super.key,
    required this.audience,
    this.initialPassageId,
  });

  final ArabicLearningAudience audience;
  final String? initialPassageId;

  @override
  ConsumerState<QuranGuidedPassageReadinessPage> createState() =>
      _QuranGuidedPassageReadinessPageState();
}

class _QuranGuidedPassageReadinessPageState
    extends ConsumerState<QuranGuidedPassageReadinessPage> {
  String? _selectedPassageId;
  String? _lastTrackedPassageId;
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
    final passages = ref.watch(quranGuidedPassageReadinessPassagesProvider);
    final stages = ref.watch(quranGuidedPassageReadinessStagesProvider);
    final summary = ref.watch(
      quranGuidedPassageReadinessSummaryProvider(widget.audience),
    );
    final audioSettings = ref.watch(quranAudioSettingsProvider);
    final activeSession = ref.watch(quranActivePlaybackSessionProvider);
    final activePassage = _resolveActivePassage(passages, summary);
    final activeIndex = activePassage == null
        ? -1
        : passages.indexWhere((item) => item.id == activePassage.id);
    final previousPassage = activeIndex > 0 ? passages[activeIndex - 1] : null;
    final nextPassage = activeIndex >= 0 && activeIndex + 1 < passages.length
        ? passages[activeIndex + 1]
        : null;
    final selectedSpeedSlow = audioSettings.playbackSpeed < 0.95;
    final isCurrentPassageSession =
        activePassage != null &&
        activeSession?.surahNumber == activePassage.ref.surah &&
        _sameAyahNumbers(
          activeSession?.ayahNumbers ?? const <int>[],
          activePassage.ayahs
              .map((ayah) => ayah.ref.ayah)
              .toList(growable: false),
        );

    if (activePassage != null && _lastTrackedPassageId != activePassage.id) {
      _lastTrackedPassageId = activePassage.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref
            .read(
              quranGuidedPassageReadinessProgressProvider(
                widget.audience,
              ).notifier,
            )
            .markPassageOpened(activePassage.id);
      });
    }

    final content = <Widget>[
      PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isKids
                  ? l10n.quranGuidedPassagesKidsIntroTitle
                  : l10n.quranGuidedPassagesAdultIntroTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              isKids
                  ? l10n.quranGuidedPassagesKidsIntroSubtitle
                  : l10n.quranGuidedPassagesAdultIntroSubtitle,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _GuidedPassageSummaryChip(
                  label: l10n.quranGuidedPassagesCountValue(
                    summary.openedCount,
                    summary.totalCount,
                  ),
                ),
                _GuidedPassageSummaryChip(
                  label: l10n.quranGuidedPassagesAyahCountValue(
                    activePassage?.ayahCount ?? 0,
                  ),
                ),
                _GuidedPassageSummaryChip(
                  label: summary.hasShortSurahStageStarted
                      ? l10n.quranGuidedPassagesReadyFromShortSurahs
                      : l10n.quranGuidedPassagesStartGently,
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
                _GuidedReadinessChoicePill(
                  label: l10n.arabicLearningPlaybackModeNormal,
                  selected: !selectedSpeedSlow,
                  onTap: () => ref
                      .read(quranAudioSettingsProvider.notifier)
                      .setPlaybackSpeed(1.0),
                ),
                _GuidedReadinessChoicePill(
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
              l10n.quranGuidedPassagesProgressionTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(l10n.quranGuidedPassagesProgressionSubtitle),
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
                children: passages
                    .where((passage) => passage.stage == stage)
                    .map(
                      (passage) => _GuidedReadinessChoicePill(
                        label: _passageTitle(l10n, passage.id),
                        selected: activePassage?.id == passage.id,
                        onTap: () {
                          setState(() {
                            _selectedPassageId = passage.id;
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

    if (activePassage != null) {
      final ayahNumbers = activePassage.ayahs
          .map((ayah) => ayah.ref.ayah)
          .toList(growable: false);
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
                          _passageTitle(l10n, activePassage.id),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _passageSubtitle(l10n, activePassage.id),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.quranGuidedPassagesPassageMeta(
                            activePassage.surahTransliteratedName,
                            activePassage.ref.ayah,
                            activePassage.ref.ayahEnd ?? activePassage.ref.ayah,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.tonalIcon(
                    onPressed: () => _togglePassagePlayback(
                      activePassage,
                      isCurrentSession: isCurrentPassageSession,
                    ),
                    icon: Icon(
                      isCurrentPassageSession && _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(
                      isCurrentPassageSession && _isPlaying
                          ? l10n.quranGuidedPassagesPauseAction
                          : l10n.quranGuidedPassagesPlayAction,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => openQuranReaderLocation(
                  context,
                  surahNumber: activePassage.ref.surah,
                  ayahNumber: activePassage.ref.ayah,
                  endAyahNumber: activePassage.ref.ayahEnd,
                  autoplay: true,
                ),
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(l10n.quranGuidedPassagesOpenReaderAction),
              ),
              if (activePassage.familiarSnippets.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.quranGuidedPassagesKnownSnippetsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranGuidedPassagesKnownSnippetsSubtitle),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: activePassage.familiarSnippets
                      .map(
                        (snippet) => _GuidedPassageSummaryChip(
                          label: snippet.snippetArabic,
                          rtl: true,
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              if (activePassage.hints.isNotEmpty) ...[
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
                  children: activePassage.hints
                      .map(
                        (hint) => _GuidedPassageSummaryChip(
                          label: _hintLabel(l10n, hint.type),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: 16),
              for (final ayah in activePassage.ayahs) ...[
                _GuidedPassageAyahCard(
                  ayah: ayah,
                  highlighted:
                      isCurrentPassageSession &&
                      _currentAyahNumber == ayah.ref.ayah,
                ),
                const SizedBox(height: 10),
              ],
              if (ayahNumbers.length > 1) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.quranGuidedPassagesFlowHint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
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
                onPressed: previousPassage == null
                    ? null
                    : () => setState(() {
                        _selectedPassageId = previousPassage.id;
                      }),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.quranReadinessPreviousAction),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => setState(() {
                  _selectedPassageId =
                      nextPassage?.id ?? passages.firstOrNull?.id;
                }),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(
                  nextPassage == null
                      ? l10n.quranReadinessReviewAgainAction
                      : l10n.quranGuidedPassagesNextAction,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (isKids) {
      return LearnHubPageScaffold(
        showDefaultQuote: false,
        headerIcon: Icons.auto_stories_rounded,
        title: l10n.quranGuidedPassagesKidsPageTitle,
        subtitle: l10n.quranGuidedPassagesKidsPageSubtitle,
        children: content,
      );
    }

    return AppPageScaffold(
      title: l10n.quranGuidedPassagesAdultPageTitle,
      subtitle: l10n.quranGuidedPassagesAdultPageSubtitle,
      children: content,
    );
  }

  QuranGuidedPassageReadinessPassage? _resolveActivePassage(
    List<QuranGuidedPassageReadinessPassage> passages,
    QuranGuidedPassageReadinessSummary summary,
  ) {
    if (passages.isEmpty) {
      return null;
    }
    for (final candidate in <String?>[
      _selectedPassageId,
      widget.initialPassageId,
      summary.passage.id,
    ]) {
      if (candidate == null) {
        continue;
      }
      for (final passage in passages) {
        if (passage.id == candidate) {
          return passage;
        }
      }
    }
    return passages.first;
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

  Future<void> _togglePassagePlayback(
    QuranGuidedPassageReadinessPassage passage, {
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
    final ayahNumbers = passage.ayahs
        .map((ayah) => ayah.ref.ayah)
        .toList(growable: false);
    final prepared = await ref
        .read(quranPlaybackOrchestratorProvider)
        .startPlayback(
          request: QuranPlaybackRequest(
            surahNumber: passage.ref.surah,
            ayahNumber: passage.ref.ayah,
            playbackReason: QuranPlaybackReason.lesson,
            isSurahEntry: passage.ref.ayah == 1,
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
        surahNumber: passage.ref.surah,
        ayahNumbers: ayahNumbers,
        reciterId: settings.reciterId,
        playbackSpeed: settings.playbackSpeed,
        includeMediaTags: false,
        isSurahMode: false,
        bismillahMode: ref.read(quranDefaultBismillahPlaybackModeProvider),
      ),
    );
  }

  String _stageLabel(
    AppLocalizations l10n,
    QuranGuidedPassageReadinessStage stage,
  ) {
    switch (stage) {
      case QuranGuidedPassageReadinessStage.familiarOpening:
        return l10n.quranGuidedPassagesStageOneTitle;
      case QuranGuidedPassageReadinessStage.completingFatihah:
        return l10n.quranGuidedPassagesStageTwoTitle;
      case QuranGuidedPassageReadinessStage.fullSurahConfidence:
        return l10n.quranGuidedPassagesStageThreeTitle;
    }
  }

  String _stageSubtitle(
    AppLocalizations l10n,
    QuranGuidedPassageReadinessStage stage,
  ) {
    switch (stage) {
      case QuranGuidedPassageReadinessStage.familiarOpening:
        return l10n.quranGuidedPassagesStageOneSubtitle;
      case QuranGuidedPassageReadinessStage.completingFatihah:
        return l10n.quranGuidedPassagesStageTwoSubtitle;
      case QuranGuidedPassageReadinessStage.fullSurahConfidence:
        return l10n.quranGuidedPassagesStageThreeSubtitle;
    }
  }

  String _passageTitle(AppLocalizations l10n, String passageId) {
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

  String _passageSubtitle(AppLocalizations l10n, String passageId) {
    switch (passageId) {
      case 'fatihah_opening_passage':
        return l10n.quranGuidedPassagesOpeningSubtitle;
      case 'fatihah_response_passage':
        return l10n.quranGuidedPassagesResponseSubtitle;
      case 'fatihah_full_passage':
        return l10n.quranGuidedPassagesFullSubtitle;
    }
    return passageId;
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

  bool _sameAyahNumbers(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) {
        return false;
      }
    }
    return true;
  }
}

class _GuidedPassageSummaryChip extends StatelessWidget {
  const _GuidedPassageSummaryChip({required this.label, this.rtl = false});

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
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF5A4A39),
        ),
      ),
    );
  }
}

class _GuidedReadinessChoicePill extends StatelessWidget {
  const _GuidedReadinessChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: selected ? AppColors.accentGoldSoft : null,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: style.decoration(radius: 999, includeShadow: false),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF8A5A1F) : const Color(0xFF5A4A39),
          ),
        ),
      ),
    );
  }
}

class _GuidedPassageAyahCard extends StatelessWidget {
  const _GuidedPassageAyahCard({required this.ayah, required this.highlighted});

  final QuranGuidedPassageReadinessAyah ayah;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final borderColor = highlighted
        ? AppColors.accentGoldSoft
        : const Color(0xFFE6DDD1);
    final backgroundColor = highlighted
        ? AppColors.accentGoldSoft.withValues(alpha: 0.18)
        : Colors.white;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: highlighted ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ayah ${ayah.ref.ayah}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF66513D),
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            text: buildQuranTextWithColoredHarakat(
              ayah.arabic,
              Theme.of(context).textTheme.headlineSmall?.copyWith(
                    height: 1.7,
                    fontFamily: 'AmiriQuran',
                    fontWeight: FontWeight.w700,
                  ) ??
                  const TextStyle(
                    fontSize: 30,
                    height: 1.7,
                    fontFamily: 'AmiriQuran',
                    fontWeight: FontWeight.w700,
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
