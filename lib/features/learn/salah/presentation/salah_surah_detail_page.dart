import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/salah_sync_controller.dart';
import '../application/salah_trainer_provider.dart';
import '../models/salah_trainer_models.dart';
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

  @override
  void dispose() {
    unawaited(
      ref
          .read(surahPlaybackControllerProvider(widget.surahId).notifier)
          .pause(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surah = ref.watch(salahTrainerSurahByIdProvider(widget.surahId));
    final notifier = ref.read(salahTrainerProgressProvider.notifier);
    final progressState = ref.watch(salahTrainerProgressProvider);
    final playback = ref.watch(surahPlaybackControllerProvider(widget.surahId));
    final playbackNotifier = ref.read(
      surahPlaybackControllerProvider(widget.surahId).notifier,
    );
    if (surah == null) {
      final l10n = AppLocalizations.of(context);
      return LearnHubPageScaffold(
        title: l10n.learnContentNotFound,
        subtitle: l10n.salahPrayerDetailNotFound,
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
    final status =
        progressState.surahProgressById[surah.id] ??
        SalahSurahProgress.notStarted;
    final currentVerse = surah.verses[playback.currentAyahIndex];

    return LearnHubPageScaffold(
      title: 'Learn Ayah - ${surah.name}',
      subtitle: surah.summary,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surah.arabicName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('Surah ${surah.surahNumber} • ${surah.verses.length} ayahs'),
              const SizedBox(height: 8),
              Text(surah.reflection),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SegmentedPillControl<SurahLearningMode>(
          items: SurahLearningMode.values,
          selectedItem: _mode,
          labelBuilder: _modeLabel,
          onChanged: (value) => setState(() => _mode = value),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: playback.isPlaying
                        ? playbackNotifier.pause
                        : () => playbackNotifier.playSurah(mode: _mode),
                    child: Text(
                      playback.isPlaying ? 'Pause' : 'Play Full Surah',
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => playbackNotifier.playCurrentAyah(),
                    child: const Text('Play Current Ayah'),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        playbackNotifier.setSlowMode(!playback.slowMode),
                    child: Text(
                      playback.slowMode ? 'Slow Mode On' : 'Slow Playback',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Pause After Ayah'),
                    selected: playback.pauseAfterAyah,
                    onSelected: (value) =>
                        playbackNotifier.setPauseAfterAyah(value),
                  ),
                  ...[1, 2, 3].map(
                    (repeat) => ChoiceChip(
                      label: Text('Repeat x$repeat'),
                      selected: playback.repeatCount == repeat,
                      onSelected: (_) =>
                          playbackNotifier.setRepeatCount(repeat),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: SalahSurahProgress.values
                    .map((value) {
                      return ChoiceChip(
                        label: Text(_statusLabel(value)),
                        selected: status == value,
                        onSelected: (_) =>
                            notifier.setSurahProgress(surah.id, value),
                      );
                    })
                    .toList(growable: false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now highlighting ayah ${currentVerse.ayahNumber}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              SyncedAyahText(
                arabicText: currentVerse.arabicText,
                transliteration:
                    _mode == SurahLearningMode.practice ||
                        _mode == SurahLearningMode.memory
                    ? ''
                    : currentVerse.transliteration,
                translation: _mode == SurahLearningMode.memory
                    ? ''
                    : currentVerse.translation,
                timing: currentVerse.audio.timing,
                activeWordIndex: playback.currentWordIndex,
                showTransliteration:
                    _mode != SurahLearningMode.practice &&
                    _mode != SurahLearningMode.memory,
                showTranslation: _mode != SurahLearningMode.memory,
                highlightEntireAyah:
                    currentVerse.audio.timing.wordTimings.isEmpty,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...surah.verses.map(
          (verse) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Ayah ${verse.ayahNumber}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      if (playback.currentAyahIndex == verse.ayahNumber - 1)
                        const Icon(Icons.graphic_eq_rounded, size: 18),
                      IconButton(
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
                    transliteration:
                        _mode == SurahLearningMode.practice ||
                            _mode == SurahLearningMode.memory
                        ? ''
                        : verse.transliteration,
                    translation: _mode == SurahLearningMode.memory
                        ? ''
                        : verse.translation,
                    timing: verse.audio.timing,
                    activeWordIndex:
                        playback.currentAyahIndex == verse.ayahNumber - 1
                        ? playback.currentWordIndex
                        : -1,
                    showTransliteration:
                        _mode != SurahLearningMode.practice &&
                        _mode != SurahLearningMode.memory,
                    showTranslation: _mode != SurahLearningMode.memory,
                    highlightEntireAyah: verse.audio.timing.wordTimings.isEmpty,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _modeLabel(SurahLearningMode mode) {
    switch (mode) {
      case SurahLearningMode.listen:
        return 'Listen';
      case SurahLearningMode.repeat:
        return 'Repeat After Ayah';
      case SurahLearningMode.practice:
        return 'Practice';
      case SurahLearningMode.memory:
        return 'Memory Mode';
    }
  }

  String _statusLabel(SalahSurahProgress value) {
    switch (value) {
      case SalahSurahProgress.notStarted:
        return 'Not started';
      case SalahSurahProgress.learning:
        return 'Learning';
      case SalahSurahProgress.practiced:
        return 'Practiced';
      case SalahSurahProgress.memorized:
        return 'Memorized';
    }
  }
}
