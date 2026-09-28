import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/expandable_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/salah_guided_settings_provider.dart';
import '../application/salah_sync_controller.dart';
import '../application/salah_trainer_provider.dart';
import '../models/salah_trainer_models.dart';
import '../widgets/salah_posture_art.dart';
import '../widgets/salah_trainer_widgets.dart';
import '../widgets/synced_ayah_text.dart';
import '../../../../core/theme/app_icons.dart';

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
  final GlobalKey _stepCardKey = GlobalKey();
  final GlobalKey _activeSegmentKey = GlobalKey();
  final GlobalKey _completionKey = GlobalKey();

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
    // No plugin in tests or on unsupported platforms; the trainer still runs.
    unawaited(WakelockPlus.enable().catchError((_) {}));
  }

  @override
  void dispose() {
    // The sync controller is autoDispose: losing this page as its last
    // listener stops its ticker and audio, and `ref` is off-limits here.
    unawaited(WakelockPlus.disable().catchError((_) {}));
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
    final madhhab = ref.watch(salahTrainerMadhhabProvider);
    ref.listen(
      guidedPrayerSyncControllerProvider(_args).select(
        (state) => (
          state.currentStepIndex,
          state.currentSegmentIndex,
          state.phase == GuidedStepPhase.completed,
        ),
      ),
      (previous, next) {
        if (previous == null || previous == next) return;
        // The finished prayer shows its completion card; a new step shows
        // its posture first; a new ayah inside a surah step keeps the
        // recited line above the transport bar.
        final stepChanged = previous.$1 != next.$1;
        final key = next.$3
            ? _completionKey
            : stepChanged
            ? _stepCardKey
            : _activeSegmentKey;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final target = key.currentContext;
          if (!mounted || target == null) return;
          Scrollable.ensureVisible(
            target,
            alignment: key == _activeSegmentKey ? 0.2 : 0.0,
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          );
        });
      },
    );
    if (prayer == null || steps.isEmpty) {
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

    final current = steps[syncState.currentStepIndex];
    final focus = settings.focusMode;
    final completed = syncState.phase == GuidedStepPhase.completed;
    final isLast = syncState.currentStepIndex >= steps.length - 1;
    final resumeIndex = _resumeIndex;
    final offerResume =
        resumeIndex != null &&
        resumeIndex < steps.length &&
        syncState.currentStepIndex == 0 &&
        !syncState.isPlaying;

    return LearnHubPageScaffold(
      title: prayer.title,
      subtitle: l10n.salahGuidedPrayerSelectedSurahSubtitle(
        surah?.name ?? l10n.salahGuidedPrayerSurahNotSet,
      ),
      headerActions: [
        IconButton(
          tooltip: focus
              ? l10n.salahTrainerExitFocusAction
              : l10n.salahTrainerFocusModeLabel,
          onPressed: () => settingsNotifier.setFocusMode(!focus),
          icon: Icon(
            focus ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
          ),
        ),
      ],
      floatingBottom: _TransportBar(
        isPlaying: syncState.isPlaying,
        canGoBack: syncState.currentStepIndex > 0,
        isLast: isLast,
        onPlayPause: syncState.isPlaying ? sync.pause : sync.playAll,
        onRepeat: sync.repeatCurrent,
        onPrevious: () => sync.setCurrentStep(syncState.currentStepIndex - 1),
        onNext: isLast
            ? () {
                ref
                    .read(salahTrainerProgressProvider.notifier)
                    .completePrayer(widget.prayerId);
                if (mounted) Navigator.of(context).maybePop();
              }
            : () => sync.setCurrentStep(syncState.currentStepIndex + 1),
      ),
      children: [
        if (offerResume) ...[
          SalahResumeCard(
            stepNumber: resumeIndex + 1,
            totalSteps: steps.length,
            onResume: () {
              sync.setCurrentStep(resumeIndex);
              setState(() => _resumeIndex = null);
            },
            onStartOver: () {
              ref
                  .read(salahTrainerProgressProvider.notifier)
                  .clearGuidedSession(widget.prayerId);
              setState(() => _resumeIndex = null);
            },
          ),
          const SizedBox(height: 10),
        ],
        if (completed) ...[
          SalahCompletionCard(
            key: _completionKey,
            prayerTitle: prayer.title,
            surahName: surah?.name,
            onPracticeSurah: surah == null
                ? null
                : () => context.pushNamed(
                    'learnSalahSurahDetail',
                    pathParameters: {'surahId': surah.id},
                  ),
            onReviewStructure: () => context.pushNamed(
              'learnSalahPrayerDetail',
              pathParameters: {'prayerId': prayer.id.name},
            ),
            onPrayAgain: () => sync.setCurrentStep(0),
          ),
          const SizedBox(height: 10),
        ],
        if (!focus) ...[
          _ProgressCard(
            steps: steps,
            currentIndex: syncState.currentStepIndex,
            onJump: sync.setCurrentStep,
          ),
          const SizedBox(height: 10),
        ],
        _StepCard(
          key: _stepCardKey,
          activeSegmentKey: _activeSegmentKey,
          step: current,
          surahName: surah?.name,
          syncState: syncState,
          settings: settings,
          focus: focus,
          madhhab: madhhab,
        ),
        if (!focus) ...[
          const SizedBox(height: 10),
          _SettingsTile(
            settings: settings,
            notifier: settingsNotifier,
            madhhab: madhhab,
          ),
        ],
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.steps,
    required this.currentIndex,
    required this.onJump,
  });

  final List<GuidedPrayerStep> steps;
  final int currentIndex;
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final current = steps[currentIndex];
    final ratio = steps.length <= 1 ? 1.0 : (currentIndex + 1) / steps.length;
    final rakahStarts = <int, int>{};
    for (var i = 0; i < steps.length; i += 1) {
      rakahStarts.putIfAbsent(steps[i].rakahNumber, () => i);
    }
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.salahGuidedPrayerCurrentRakahValue(current.rakahNumber),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                l10n.salahGuidedPrayerStepProgressValue(
                  currentIndex + 1,
                  steps.length,
                ),
                style: textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ProgressBar(value: ratio, height: 8),
          const SizedBox(height: 12),
          Text(
            l10n.salahTrainerJumpToRakahLabel,
            style: textTheme.bodySmall?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in rakahStarts.entries)
                SalahPill(
                  label: l10n.salahTrainerRakahTitle(entry.key),
                  selected: entry.key == current.rakahNumber,
                  onTap: () => onJump(entry.value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    super.key,
    required this.activeSegmentKey,
    required this.step,
    required this.surahName,
    required this.syncState,
    required this.settings,
    required this.focus,
    required this.madhhab,
  });

  final GlobalKey activeSegmentKey;
  final GuidedPrayerStep step;
  final String? surahName;
  final GuidedPrayerSyncState syncState;
  final SalahGuidedSettings settings;
  final bool focus;
  final PrayerMadhab madhhab;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final model = step.step;
    final title = model.isDynamicSurah && surahName != null
        ? l10n.salahTrainerSurahStepTitle(surahName!)
        : model.title;
    final reciting = syncState.phase == GuidedStepPhase.reciting;
    final holding = syncState.phase == GuidedStepPhase.holding;
    final enteringWithTakbir = syncState.phase == GuidedStepPhase.entryTakbir;
    final subtle = textTheme.bodySmall?.copyWith(
      color: context.palette.onSurfaceSubtle,
    );

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalahPostureArt(posture: syncState.activePosture),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: (focus ? textTheme.titleLarge : textTheme.titleMedium)
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (model.isOptional)
                    SalahPill(
                      label: l10n.salahTrainerOptionalBadge,
                      compact: true,
                    ),
                  if (model.isTasbih)
                    SalahPill(
                      icon: Icons.repeat_rounded,
                      label: reciting
                          ? l10n.salahTrainerRepeatCounter(
                              syncState.repeatIteration,
                              settings.tasbihRepeats,
                            )
                          : l10n.salahTrainerTasbihBadge(
                              settings.tasbihRepeats,
                            ),
                      selected: reciting,
                      compact: true,
                    ),
                  if (holding)
                    SalahPill(
                      icon: Icons.hourglass_bottom_rounded,
                      label: l10n.salahTrainerHoldLabel(
                        (syncState.holdRemainingMs / 1000).ceil(),
                      ),
                      selected: true,
                      compact: true,
                    ),
                ],
              ),
            ],
          ),
          if (model.entryTakbir) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.south_rounded,
                  size: 14,
                  color: context.palette.onSurfaceSubtle,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(l10n.salahTrainerEntryTakbirLabel, style: subtle),
                ),
                if (enteringWithTakbir)
                  Text(
                    'اللَّهُ أَكْبَرُ',
                    textDirection: TextDirection.rtl,
                    style: textTheme.titleMedium,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          for (var i = 0; i < model.segments.length; i += 1) ...[
            if (i > 0) const SizedBox(height: 14),
            SyncedAyahText(
              key: i == syncState.currentSegmentIndex ? activeSegmentKey : null,
              arabicText: model.segments[i].arabicText,
              transliteration: model.segments[i].transliteration,
              translation: model.segments[i].translation,
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
                  reciting &&
                  (syncState.activeTiming?.isEmpty ?? true),
              emphasis: model.segments.length == 1 || !reciting
                  ? SyncedTextEmphasis.active
                  : i == syncState.currentSegmentIndex
                  ? SyncedTextEmphasis.active
                  : i < syncState.currentSegmentIndex
                  ? SyncedTextEmphasis.done
                  : SyncedTextEmphasis.upcoming,
              arabicSize: focus ? 38 : 30,
            ),
          ],
          if (model.helperText != null) ...[
            const SizedBox(height: 10),
            Text(model.helperText!, style: subtle),
          ],
          if (model.madhhabNotes[madhhab] case final note?) ...[
            const SizedBox(height: 10),
            SalahMadhhabNote(
              label: l10n.salahTrainerMadhhabGuidanceTitle(
                madhhab.localizedLabel(l10n),
              ),
              note: note,
            ),
          ],
          if (!model.isSilent &&
              syncState.sourceKind != null &&
              syncState.sourceKind != SalahAudioSourceKind.asset) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  syncState.sourceKind == SalahAudioSourceKind.tts
                      ? Icons.record_voice_over_rounded
                      : Icons.volume_off_rounded,
                  size: 14,
                  color: context.palette.onSurfaceSubtle,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    syncState.sourceKind == SalahAudioSourceKind.tts
                        ? l10n.salahTrainerAudioSourceTts
                        : l10n.salahTrainerAudioSourceSilent,
                    style: subtle,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.settings,
    required this.notifier,
    required this.madhhab,
  });

  final SalahGuidedSettings settings;
  final SalahGuidedSettingsNotifier notifier;
  final PrayerMadhab madhhab;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ExpandableTile(
      leading: const HubLeadingIcon(AppIcons.adjust),
      title: Text(l10n.salahTrainerSettingsTitle),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalahPillChoice<SalahTrainerPace>(
            label: l10n.salahTrainerPaceLabel,
            values: SalahTrainerPace.values,
            selected: settings.pace,
            labelOf: (pace) => switch (pace) {
              SalahTrainerPace.unhurried => l10n.salahTrainerPaceUnhurried,
              SalahTrainerPace.steady => l10n.salahTrainerPaceSteady,
              SalahTrainerPace.brisk => l10n.salahTrainerPaceBrisk,
            },
            onChanged: notifier.setPace,
            hint: l10n.salahTrainerPaceHint,
          ),
          const SizedBox(height: 12),
          SalahPillChoice<int>(
            label: l10n.salahTrainerTasbihRepeatsLabel,
            values: SalahGuidedSettings.tasbihRepeatOptions,
            selected: settings.tasbihRepeats,
            labelOf: l10n.salahTrainerTasbihRepeatsValue,
            onChanged: notifier.setTasbihRepeats,
          ),
          const SizedBox(height: 4),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: settings.showTransliteration,
            onChanged: notifier.setShowTransliteration,
            title: Text(l10n.salahGuidedPrayerShowTransliteration),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: settings.showTranslation,
            onChanged: notifier.setShowTranslation,
            title: Text(l10n.salahGuidedPrayerShowTranslation),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: settings.focusMode,
            onChanged: notifier.setFocusMode,
            title: Text(l10n.salahTrainerFocusModeLabel),
            subtitle: Text(l10n.salahTrainerFocusModeHint),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.salahTrainerMadhhabFollowingLabel(
              madhhab.localizedLabel(l10n),
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

/// The transport, floating above the step so it stays in reach while a
/// seven-ayah surah scrolls.
class _TransportBar extends StatelessWidget {
  const _TransportBar({
    required this.isPlaying,
    required this.canGoBack,
    required this.isLast,
    required this.onPlayPause,
    required this.onRepeat,
    required this.onPrevious,
    required this.onNext,
  });

  final bool isPlaying;
  final bool canGoBack;
  final bool isLast;
  final VoidCallback onPlayPause;
  final VoidCallback onRepeat;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: PremiumCard(
          density: PremiumCardDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: l10n.wuduTrainerPreviousAction,
                onPressed: canGoBack ? onPrevious : null,
                icon: const Icon(Icons.skip_previous_rounded),
              ),
              FilledButton.icon(
                onPressed: onPlayPause,
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                label: Text(
                  isPlaying
                      ? l10n.salahGuidedPrayerPauseAction
                      : l10n.salahGuidedPrayerPlayAction,
                ),
              ),
              IconButton(
                tooltip: l10n.salahGuidedPrayerRepeatStepAction,
                onPressed: onRepeat,
                icon: const Icon(Icons.replay_rounded),
              ),
              IconButton(
                tooltip: isLast
                    ? l10n.salahGuidedPrayerFinishAction
                    : l10n.salahGuidedPrayerNextStepAction,
                onPressed: onNext,
                icon: Icon(
                  isLast ? Icons.check_rounded : Icons.skip_next_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
