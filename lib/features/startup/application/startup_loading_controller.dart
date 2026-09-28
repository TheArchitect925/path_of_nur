import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_motion.dart';
import '../../../l10n/app_localizations.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';

enum StartupLoadingStage {
  initializing,
  restoring,
  syncing,
  finalizing,
  complete,
}

/// One unit of real start-up work. The light-line on the loading card
/// advances as each one completes, in the order the stages are listed.
typedef StartupCheckpoint = Future<void> Function();

@immutable
class StartupGreeting {
  const StartupGreeting({required this.arabic, required this.translation});

  final String arabic;
  final String translation;
}

@immutable
class StartupLoadingState {
  const StartupLoadingState({required this.stage, this.targetLocation});

  const StartupLoadingState.initial()
    : stage = StartupLoadingStage.initializing,
      targetLocation = null;

  final StartupLoadingStage stage;
  final String? targetLocation;

  StartupLoadingState copyWith({
    StartupLoadingStage? stage,
    String? targetLocation,
  }) {
    return StartupLoadingState(
      stage: stage ?? this.stage,
      targetLocation: targetLocation ?? this.targetLocation,
    );
  }
}

/// Walks the loading card through its stages on real work.
///
/// Each stage waits for its [StartupCheckpoint] (restoring, syncing,
/// finalizing) but stays on screen at least [AppMotion.checkpointMinimum] so
/// the light-line reads, and never longer than [AppMotion.checkpointCeiling]
/// — a slow or failing checkpoint moves the reader on rather than holding
/// them. The whole card stays at least [AppMotion.startupMinimum] so the
/// kindle can finish, and completes as soon as the work is done after that.
class StartupLoadingController extends StateNotifier<StartupLoadingState> {
  StartupLoadingController() : super(const StartupLoadingState.initial());

  int _generation = 0;

  static const List<StartupLoadingStage> _stages = [
    StartupLoadingStage.restoring,
    StartupLoadingStage.syncing,
    StartupLoadingStage.finalizing,
  ];

  void start({
    required bool onboardingCompleted,
    required AccountsSyncState accountsSyncState,
    List<StartupCheckpoint> checkpoints = const [],
  }) {
    final generation = ++_generation;
    state = const StartupLoadingState.initial();
    final targetLocation = _resolveTargetLocation(
      onboardingCompleted: onboardingCompleted,
      accountsSyncState: accountsSyncState,
    );
    unawaited(_run(generation, targetLocation, checkpoints));
  }

  Future<void> _run(
    int generation,
    String targetLocation,
    List<StartupCheckpoint> checkpoints,
  ) async {
    // Timer-based, not clock-based, so the hold is honest under fake time.
    final minimumHold = Future<void>.delayed(AppMotion.startupMinimum);
    bool stale() => generation != _generation || !mounted;

    for (var i = 0; i < _stages.length; i++) {
      final checkpoint = i < checkpoints.length ? checkpoints[i] : null;
      await Future.wait<void>([
        if (checkpoint != null) _guarded(checkpoint),
        Future<void>.delayed(AppMotion.checkpointMinimum),
      ]);
      if (stale()) return;
      state = state.copyWith(stage: _stages[i]);
    }

    await minimumHold;
    if (stale()) return;
    state = StartupLoadingState(
      stage: StartupLoadingStage.complete,
      targetLocation: targetLocation,
    );
  }

  /// A checkpoint may be slow or may fail; neither holds the reader.
  Future<void> _guarded(StartupCheckpoint checkpoint) async {
    try {
      await checkpoint().timeout(AppMotion.checkpointCeiling);
    } catch (_) {
      // Start-up work that fails is retried by its own feature later.
    }
  }

  @override
  void dispose() {
    _generation++;
    super.dispose();
  }
}

final startupLoadingControllerProvider =
    StateNotifierProvider<StartupLoadingController, StartupLoadingState>(
      (ref) => StartupLoadingController(),
    );

String resolveStartupStatusLabel(
  StartupLoadingStage stage,
  AppLocalizations l10n,
) {
  switch (stage) {
    case StartupLoadingStage.initializing:
      return l10n.loadingStatusPreparing;
    case StartupLoadingStage.restoring:
      return l10n.loadingStatusRestoring;
    case StartupLoadingStage.syncing:
      return l10n.loadingStatusSyncing;
    case StartupLoadingStage.finalizing:
    case StartupLoadingStage.complete:
      return l10n.loadingStatusFinalizing;
  }
}

/// How far along the light-line is for a stage, 0..1.
double startupLightLineProgress(StartupLoadingStage stage) {
  switch (stage) {
    case StartupLoadingStage.initializing:
      return 0.18;
    case StartupLoadingStage.restoring:
      return 0.45;
    case StartupLoadingStage.syncing:
      return 0.72;
    case StartupLoadingStage.finalizing:
      return 0.9;
    case StartupLoadingStage.complete:
      return 1;
  }
}

StartupGreeting getIslamicGreeting({
  required DateTime now,
  required AppLocalizations l10n,
}) {
  // Use authenticated morning/evening adhkar openings rather than unsourced
  // greeting copy. The selected lines come from the established
  // "Allahumma bika asbahna / amsayna" supplication tradition
  // (for example Sunan Abi Dawud 5068 and related narrations).
  final hour = now.hour;
  if (hour >= 5 && hour < 12) {
    return StartupGreeting(
      arabic: l10n.loadingGreetingMorning,
      translation: l10n.loadingGreetingMorningTranslation,
    );
  }
  return StartupGreeting(
    arabic: l10n.loadingGreetingEvening,
    translation: l10n.loadingGreetingEveningTranslation,
  );
}

String _resolveTargetLocation({
  required bool onboardingCompleted,
  required AccountsSyncState accountsSyncState,
}) {
  if (!onboardingCompleted) {
    return '/onboarding';
  }

  if (accountsSyncState.sharedDeviceModeEnabled &&
      accountsSyncState.sharedDeviceSafety.requireProfileSelectionOnLaunch &&
      accountsSyncState.sessionUnlockedProfileId == null) {
    return '/profiles/launch';
  }

  return '/home';
}
