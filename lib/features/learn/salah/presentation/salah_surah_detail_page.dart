import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/salah_sync_controller.dart';
import '../application/salah_trainer_provider.dart';
import '../models/salah_trainer_models.dart';
import '../widgets/salah_trainer_widgets.dart';
import '../widgets/synced_ayah_text.dart';

class SalahSurahDetailPage extends ConsumerStatefulWidget {
  const SalahSurahDetailPage({super.key, required this.surahId});

  final String surahId;

  @override
  ConsumerState<SalahSurahDetailPage> createState() =>
      _SalahSurahDetailPageState();
}

class _SalahSurahDetailPageState extends ConsumerState<SalahSurahDetailPage> {
  SurahLearningMode _mode = SurahLearningMode.listen;

  bool get _showTransliteration =>
      _mode != SurahLearningMode.practice && _mode != SurahLearningMode.memory;
  bool get _showTranslation => _mode != SurahLearningMode.memory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final surah = ref.watch(salahTrainerSurahByIdProvider(widget.surahId));
    final notifier = ref.read(salahTrainerProgressProvider.notifier);
    final progressState = ref.watch(salahTrainerProgressProvider);
    final playback = ref.watch(surahPlaybackControllerProvider(widget.surahId));
    final playbackNotifier = ref.read(
      surahPlaybackControllerProvider(widget.surahId).notifier,
    );
    if (surah == null) {
      return LearnHubPageScaffold(
        title: l10n.learnSalahHubTitle,
        children: [
          PremiumCard(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton.tonalIcon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.salahCloseAction),
              ),
            ),
          ),
        ],
      );
    }
    final textTheme = Theme.of(context).textTheme;
    final subtle = textTheme.bodySmall?.copyWith(
      color: context.palette.onSurfaceSubtle,
    );
    final status =
        progressState.surahProgressById[surah.id] ??
        SalahSurahProgress.notStarted;
    final currentVerse = surah.verses[playback.currentAyahIndex];
    final activeTiming = playback.activeTiming ?? RecitationTimingModel.empty;

    return LearnHubPageScaffold(
      title: l10n.salahTrainerLearnAyahTitle(surah.name),
      subtitle: surah.summary,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surah.arabicName,
                textDirection: TextDirection.rtl,
                style: QuranPresentationStyle.translucentTextStyle(
                  context,
                  AppTextStyles.quranVerse(size: 28),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.salahTrainerSurahMeta(
                  surah.surahNumber,
                  surah.verses.length,
                ),
                style: subtle,
              ),
              const SizedBox(height: 8),
              Text(surah.reflection),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SegmentedPillControl<SurahLearningMode>(
          items: SurahLearningMode.values,
          selectedItem: _mode,
          labelBuilder: (mode) => _modeLabel(l10n, mode),
          onChanged: (value) => setState(() => _mode = value),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(_modeHint(l10n, _mode), style: subtle),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: playback.isPlaying
                          ? playbackNotifier.pause
                          : () => playbackNotifier.playSurah(mode: _mode),
                      icon: Icon(
                        playback.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text(
                        playback.isPlaying
                            ? l10n.salahGuidedPrayerPauseAction
                            : l10n.salahTrainerPlayFullSurahAction,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: playbackNotifier.playCurrentAyah,
                      child: Text(l10n.salahTrainerPlayCurrentAyahAction),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SalahPill(
                    icon: Icons.slow_motion_video_rounded,
                    label: l10n.salahTrainerSlowPlaybackLabel,
                    selected: playback.slowMode,
                    onTap: () =>
                        playbackNotifier.setSlowMode(!playback.slowMode),
                  ),
                  SalahPill(
                    icon: Icons.pause_circle_outline_rounded,
                    label: l10n.salahTrainerPauseAfterAyahLabel,
                    selected: playback.pauseAfterAyah,
                    onTap: () => playbackNotifier.setPauseAfterAyah(
                      !playback.pauseAfterAyah,
                    ),
                  ),
                  for (final repeat in const [1, 2, 3])
                    SalahPill(
                      label: l10n.salahTrainerRepeatTimesLabel(repeat),
                      selected: playback.repeatCount == repeat,
                      onTap: () => playbackNotifier.setRepeatCount(repeat),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: SalahPillChoice<SalahSurahProgress>(
            label: l10n.salahTrainerYourProgressLabel,
            values: SalahSurahProgress.values,
            selected: status,
            labelOf: (value) => _statusLabel(l10n, value),
            onChanged: (value) => notifier.setSurahProgress(surah.id, value),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.salahTrainerNowOnAyah(currentVerse.ayahNumber),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              SyncedAyahText(
                arabicText: currentVerse.arabicText,
                transliteration: currentVerse.transliteration,
                translation: currentVerse.translation,
                timing: activeTiming,
                activeWordIndex: playback.currentWordIndex,
                showTransliteration: _showTransliteration,
                showTranslation: _showTranslation,
                highlightEntireAyah: playback.isPlaying && activeTiming.isEmpty,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...surah.verses.map((verse) {
          final isCurrent = playback.currentAyahIndex == verse.ayahNumber - 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.salahTrainerAyahLabel(verse.ayahNumber),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isCurrent && playback.isPlaying)
                        Icon(
                          Icons.graphic_eq_rounded,
                          size: 18,
                          color: context.palette.accent,
                        ),
                      IconButton(
                        tooltip: l10n.salahTrainerPlayCurrentAyahAction,
                        onPressed: () {
                          playbackNotifier.setCurrentAyahIndex(
                            verse.ayahNumber - 1,
                          );
                          playbackNotifier.playCurrentAyah();
                        },
                        icon: const Icon(Icons.play_arrow_rounded),
                      ),
                    ],
                  ),
                  SyncedAyahText(
                    arabicText: verse.arabicText,
                    transliteration: verse.transliteration,
                    translation: verse.translation,
                    timing: isCurrent
                        ? activeTiming
                        : RecitationTimingModel.empty,
                    activeWordIndex: isCurrent ? playback.currentWordIndex : -1,
                    showTransliteration: _showTransliteration,
                    showTranslation: _showTranslation,
                    highlightEntireAyah:
                        isCurrent && playback.isPlaying && activeTiming.isEmpty,
                    emphasis: isCurrent || !playback.isPlaying
                        ? SyncedTextEmphasis.active
                        : SyncedTextEmphasis.upcoming,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  String _modeLabel(AppLocalizations l10n, SurahLearningMode mode) {
    switch (mode) {
      case SurahLearningMode.listen:
        return l10n.salahTrainerModeListen;
      case SurahLearningMode.repeat:
        return l10n.salahTrainerModeRepeat;
      case SurahLearningMode.practice:
        return l10n.salahTrainerModePractice;
      case SurahLearningMode.memory:
        return l10n.salahTrainerModeMemory;
    }
  }

  String _modeHint(AppLocalizations l10n, SurahLearningMode mode) {
    switch (mode) {
      case SurahLearningMode.listen:
        return l10n.salahTrainerModeListenHint;
      case SurahLearningMode.repeat:
        return l10n.salahTrainerModeRepeatHint;
      case SurahLearningMode.practice:
        return l10n.salahTrainerModePracticeHint;
      case SurahLearningMode.memory:
        return l10n.salahTrainerModeMemoryHint;
    }
  }

  String _statusLabel(AppLocalizations l10n, SalahSurahProgress value) {
    switch (value) {
      case SalahSurahProgress.notStarted:
        return l10n.learnSalahHubStatusNotStarted;
      case SalahSurahProgress.learning:
        return l10n.learnSalahHubStatusLearning;
      case SalahSurahProgress.practiced:
        return l10n.learnSalahHubStatusPracticed;
      case SalahSurahProgress.memorized:
        return l10n.learnSalahHubStatusMemorized;
    }
  }
}
