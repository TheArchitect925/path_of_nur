import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../quran/application/quran_providers.dart';
import '../application/salah_sync_controller.dart';
import '../application/salah_trainer_provider.dart';
import '../models/salah_trainer_models.dart';
import '../widgets/prayer_posture_animator.dart';
import '../widgets/synced_ayah_text.dart';

class SalahGuidedPrayerPage extends ConsumerStatefulWidget {
  const SalahGuidedPrayerPage({super.key, required this.prayerId});

  final SalahPrayerId prayerId;

  @override
  ConsumerState<SalahGuidedPrayerPage> createState() =>
      _SalahGuidedPrayerPageState();
}

class _SalahGuidedPrayerPageState extends ConsumerState<SalahGuidedPrayerPage> {
  bool _showTransliteration = true;
  bool _showTranslation = true;
  late final String _surahId;

  ({SalahPrayerId prayerId, String surahId}) get _args =>
      (prayerId: widget.prayerId, surahId: _surahId);

  @override
  void initState() {
    super.initState();
    final settings = ref.read(quranReaderSettingsProvider);
    _showTransliteration = settings.showTransliteration;
    _showTranslation = settings.showTranslation;
    final notifier = ref.read(salahTrainerProgressProvider.notifier);
    _surahId = notifier.chooseGuidedSurahId(prayerId: widget.prayerId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(salahTrainerProgressProvider.notifier)
          .openPrayer(widget.prayerId);
    });
    unawaited(WakelockPlus.enable());
  }

  @override
  void dispose() {
    unawaited(
      ref.read(guidedPrayerSyncControllerProvider(_args).notifier).pause(),
    );
    unawaited(WakelockPlus.disable());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prayer = ref.watch(salahTrainerPrayerByIdProvider(widget.prayerId));
    final surah = ref.watch(salahTrainerSurahByIdProvider(_surahId));
    final steps = ref.watch(salahGuidedStepsProvider(_args));
    final syncState = ref.watch(guidedPrayerSyncControllerProvider(_args));
    final sync = ref.read(guidedPrayerSyncControllerProvider(_args).notifier);
    if (prayer == null || steps.isEmpty) {
      return LearnHubPageScaffold(
        title: l10n.salahGuidedPrayerUnavailable,
        subtitle: l10n.learnContentNotFound,
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

    final current = steps[syncState.currentStepIndex];
    final progressRatio = steps.length <= 1
        ? 1.0
        : (syncState.currentStepIndex + 1) / steps.length;
    final timing = _timingForStep(current.step);

    return LearnHubPageScaffold(
      title: l10n.salahGuidedPrayerPageTitle(prayer.title),
      subtitle: l10n.salahGuidedPrayerSelectedSurahSubtitle(
        surah?.name ?? l10n.salahGuidedPrayerSurahNotSet,
      ),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prayer.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.salahGuidedPrayerCurrentRakahValue(current.rakahNumber),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: progressRatio, minHeight: 8),
              const SizedBox(height: 8),
              Text(
                l10n.salahGuidedPrayerStepProgressValue(
                  syncState.currentStepIndex + 1,
                  steps.length,
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: PrayerPostureAnimator(
                  posture: syncState.activePosture,
                  size: 170,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                current.step.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (current.surahId != null) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.salahGuidedPrayerFromSurahValue(
                    surah?.name ?? l10n.salahGuidedPrayerSelectedSurahFallback,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              SyncedAyahText(
                arabicText: current.step.arabicText,
                transliteration: current.step.transliteration,
                translation: current.step.translation,
                timing: timing,
                activeWordIndex: syncState.currentWordIndex,
                showTransliteration: _showTransliteration,
                showTranslation: _showTranslation,
                highlightEntireAyah: timing.wordTimings.isEmpty,
              ),
              if (current.step.helperText != null) ...[
                const SizedBox(height: 10),
                Text(
                  current.step.helperText!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _showTransliteration,
                onChanged: (value) =>
                    setState(() => _showTransliteration = value),
                title: Text(l10n.salahGuidedPrayerShowTransliteration),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _showTranslation,
                onChanged: (value) => setState(() => _showTranslation = value),
                title: Text(l10n.salahGuidedPrayerShowTranslation),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: syncState.isPlaying ? sync.pause : sync.playAll,
                  icon: Icon(
                    syncState.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    syncState.isPlaying
                        ? l10n.salahGuidedPrayerPauseAction
                        : l10n.salahGuidedPrayerPlayAction,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: sync.repeatCurrent,
                  child: Text(l10n.salahGuidedPrayerRepeatStepAction),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: syncState.currentStepIndex > 0
                    ? () => sync.setCurrentStep(syncState.currentStepIndex - 1)
                    : null,
                child: Text(l10n.wuduTrainerPreviousAction),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: syncState.currentStepIndex < steps.length - 1
                    ? () => sync.setCurrentStep(syncState.currentStepIndex + 1)
                    : () {
                        ref
                            .read(salahTrainerProgressProvider.notifier)
                            .completePrayer(widget.prayerId);
                        if (mounted) Navigator.of(context).maybePop();
                      },
                child: Text(
                  syncState.currentStepIndex < steps.length - 1
                      ? l10n.salahGuidedPrayerNextStepAction
                      : l10n.salahGuidedPrayerFinishAction,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  RecitationTimingModel _timingForStep(PrayerStepModel step) {
    final arabicWords = step.arabicText
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    if (arabicWords.isEmpty) {
      return const RecitationTimingModel(
        totalDurationMs: 1000,
        wordTimings: <RecitationWordTimingModel>[],
      );
    }
    final transliterationWords = step.transliteration
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final translationWords = step.translation
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final totalDurationMs = 900 + (arabicWords.length * 300);
    final segmentSize = (totalDurationMs / arabicWords.length).round();
    return RecitationTimingModel(
      totalDurationMs: totalDurationMs,
      wordTimings: List<RecitationWordTimingModel>.generate(
        arabicWords.length,
        (index) {
          return RecitationWordTimingModel(
            wordId: '${step.id}-$index',
            arabicText: arabicWords[index],
            transliteration: index < transliterationWords.length
                ? transliterationWords[index]
                : '',
            translation: index < translationWords.length
                ? translationWords[index]
                : '',
            startMs: segmentSize * index,
            endMs: index == arabicWords.length - 1
                ? totalDurationMs
                : segmentSize * (index + 1),
          );
        },
      ),
    );
  }
}
