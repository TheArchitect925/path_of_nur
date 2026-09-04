import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/salah_guided_settings_provider.dart';
import '../application/salah_sync_controller.dart';
import '../application/salah_trainer_provider.dart';
import '../data/salah_trainer_data.dart';
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
  late final String _surahId;
  int? _resumeIndex;

  ({SalahPrayerId prayerId, String surahId}) get _args =>
      (prayerId: widget.prayerId, surahId: _surahId);

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(salahTrainerProgressProvider.notifier);
    final session = ref
        .read(salahTrainerProgressProvider)
        .sessionFor(widget.prayerId);
    _surahId = notifier.chooseGuidedSurahId(prayerId: widget.prayerId);
    if (session != null && session.hasProgress && session.surahId == _surahId) {
      _resumeIndex = session.stepIndex;
    }
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
    final settings = ref.watch(salahGuidedSettingsProvider);
    final settingsNotifier = ref.read(salahGuidedSettingsProvider.notifier);
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
    final resumeIndex = _resumeIndex;
    final offerResume =
        resumeIndex != null &&
        resumeIndex < steps.length &&
        syncState.currentStepIndex == 0 &&
        !syncState.isPlaying;

    return LearnHubPageScaffold(
      title: l10n.salahGuidedPrayerPageTitle(prayer.title),
      subtitle: l10n.salahGuidedPrayerSelectedSurahSubtitle(
        surah?.name ?? l10n.salahGuidedPrayerSurahNotSet,
      ),
      children: [
        if (offerResume) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.wuduTrainerResumeTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.wuduTrainerResumeSubtitle(resumeIndex + 1, steps.length),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        sync.setCurrentStep(resumeIndex);
                        setState(() => _resumeIndex = null);
                      },
                      child: Text(l10n.wuduTrainerResumeAction),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        ref
                            .read(salahTrainerProgressProvider.notifier)
                            .clearGuidedSession(widget.prayerId);
                        setState(() => _resumeIndex = null);
                      },
                      child: Text(l10n.wuduTrainerStartAgainActionText),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
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
              ProgressBar(value: progressRatio, height: 8),
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      current.step.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (current.step.isTasbih &&
                      syncState.phase == GuidedStepPhase.reciting)
                    Text(
                      '${syncState.repeatIteration} / ${settings.tasbihRepeats}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (syncState.phase == GuidedStepPhase.holding)
                    Text(
                      '${(syncState.holdRemainingMs / 1000).ceil()} s',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
              if (current.step.isDynamicSurah) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.salahGuidedPrayerFromSurahValue(
                    surah?.name ?? l10n.salahGuidedPrayerSelectedSurahFallback,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (syncState.phase == GuidedStepPhase.entryTakbir) ...[
                const SizedBox(height: 8),
                Text(
                  salahTakbirArabic,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
              const SizedBox(height: 12),
              for (var i = 0; i < current.step.segments.length; i += 1) ...[
                if (i > 0) const SizedBox(height: 14),
                SyncedAyahText(
                  arabicText: current.step.segments[i].arabicText,
                  transliteration: current.step.segments[i].transliteration,
                  translation: current.step.segments[i].translation,
                  timing: i == syncState.currentSegmentIndex
                      ? syncState.activeTiming ?? RecitationTimingModel.empty
                      : RecitationTimingModel.empty,
                  activeWordIndex: i == syncState.currentSegmentIndex
                      ? syncState.currentWordIndex
                      : -1,
                  showTransliteration: settings.showTransliteration,
                  showTranslation: settings.showTranslation,
                  highlightEntireAyah:
                      i == syncState.currentSegmentIndex &&
                      (syncState.activeTiming?.isEmpty ?? true),
                ),
              ],
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
                value: settings.showTransliteration,
                onChanged: settingsNotifier.setShowTransliteration,
                title: Text(l10n.salahGuidedPrayerShowTransliteration),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: settings.showTranslation,
                onChanged: settingsNotifier.setShowTranslation,
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
}

/// The takbir shown while a posture is entered.
String get salahTakbirArabic => salahTakbirSegment.arabicText;
