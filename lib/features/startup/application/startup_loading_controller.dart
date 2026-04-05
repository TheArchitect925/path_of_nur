import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';

enum StartupLoadingStage {
  initializing,
  restoring,
  syncing,
  finalizing,
  complete,
}

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

class StartupLoadingController extends StateNotifier<StartupLoadingState> {
  StartupLoadingController() : super(const StartupLoadingState.initial());

  final List<Timer> _timers = <Timer>[];
  bool _started = false;

  void start({
    required bool onboardingCompleted,
    required AccountsSyncState accountsSyncState,
  }) {
    if (_started) return;
    _started = true;
    final targetLocation = _resolveTargetLocation(
      onboardingCompleted: onboardingCompleted,
      accountsSyncState: accountsSyncState,
    );

    _schedule(const Duration(milliseconds: 220), () {
      state = state.copyWith(stage: StartupLoadingStage.restoring);
    });
    _schedule(const Duration(milliseconds: 520), () {
      state = state.copyWith(stage: StartupLoadingStage.syncing);
    });
    _schedule(const Duration(milliseconds: 860), () {
      state = state.copyWith(stage: StartupLoadingStage.finalizing);
    });
    _schedule(const Duration(milliseconds: 1180), () {
      state = StartupLoadingState(
        stage: StartupLoadingStage.complete,
        targetLocation: targetLocation,
      );
    });
  }

  void _schedule(Duration delay, VoidCallback callback) {
    _timers.add(Timer(delay, callback));
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
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
