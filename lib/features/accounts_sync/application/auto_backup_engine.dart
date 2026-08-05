import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/accounts_sync_models.dart';
import 'accounts_sync_controller.dart';
import 'accounts_sync_services.dart';
import 'backup_payload_fingerprint.dart';
import 'remote_backup_transport.dart';

class AutoBackupStatusViewModel {
  const AutoBackupStatusViewModel({
    required this.preferences,
    required this.dirty,
    required this.pendingReasons,
    required this.lastAttemptAtIso,
    required this.lastSuccessAtIso,
    required this.lastFailureCode,
    required this.inProgress,
  });

  final AutoBackupPreferences preferences;
  final bool dirty;
  final List<PendingBackupReason> pendingReasons;
  final String? lastAttemptAtIso;
  final String? lastSuccessAtIso;
  final String? lastFailureCode;
  final bool inProgress;
}

final autoBackupStatusProvider = Provider<AutoBackupStatusViewModel>((ref) {
  final state = ref.watch(accountsSyncControllerProvider).autoBackupState;
  return AutoBackupStatusViewModel(
    preferences: state.preferences,
    dirty: state.dirty,
    pendingReasons: state.pendingReasons,
    lastAttemptAtIso: state.lastAttemptAtIso,
    lastSuccessAtIso: state.lastSuccessAtIso,
    lastFailureCode: state.lastFailureCode,
    inProgress: state.inProgress,
  );
});

class AutoBackupEligibility {
  const AutoBackupEligibility({
    required this.result,
    required this.pendingReasons,
  });

  final AutoBackupEligibilityResult result;
  final List<PendingBackupReason> pendingReasons;
}

abstract class AutoBackupController {
  Future<AutoBackupEligibility> evaluateEligibility({
    required AutoBackupTrigger trigger,
  });

  Future<AutoBackupRunResult> runIfEligible({
    required AutoBackupTrigger trigger,
    bool force = false,
  });

  Future<void> updatePreferences(AutoBackupPreferences preferences);
}

class DefaultAutoBackupController implements AutoBackupController {
  DefaultAutoBackupController(this.ref);

  final Ref ref;

  @override
  Future<void> updatePreferences(AutoBackupPreferences preferences) {
    return ref
        .read(accountsSyncControllerProvider.notifier)
        .updateAutoBackupState(preferences: preferences);
  }

  @override
  Future<AutoBackupEligibility> evaluateEligibility({
    required AutoBackupTrigger trigger,
  }) async {
    final state = ref.read(accountsSyncControllerProvider);
    final autoState = state.autoBackupState;
    final prefs = autoState.preferences;

    if (!prefs.enabled) {
      return const AutoBackupEligibility(
        result: AutoBackupEligibilityResult.disabled,
        pendingReasons: <PendingBackupReason>[],
      );
    }
    if (prefs.frequency == AutoBackupFrequency.manualOnly) {
      return const AutoBackupEligibility(
        result: AutoBackupEligibilityResult.manualOnly,
        pendingReasons: <PendingBackupReason>[],
      );
    }
    if (state.authenticatedAccount == null) {
      return const AutoBackupEligibility(
        result: AutoBackupEligibilityResult.notSignedIn,
        pendingReasons: <PendingBackupReason>[],
      );
    }
    if (autoState.inProgress) {
      return AutoBackupEligibility(
        result: AutoBackupEligibilityResult.backupAlreadyRunning,
        pendingReasons: autoState.pendingReasons,
      );
    }
    final availability = await ref
        .read(remoteBackupRepositoryProvider)
        .checkStatus();
    if (availability != RemoteBackupAvailability.available) {
      return AutoBackupEligibility(
        result: AutoBackupEligibilityResult.providerUnavailable,
        pendingReasons: autoState.pendingReasons,
      );
    }

    final signature = await _evaluateDirtyState(trigger: trigger);
    final freshState = ref.read(accountsSyncControllerProvider).autoBackupState;
    final pendingReasons = freshState.pendingReasons;
    if (!freshState.dirty && pendingReasons.isEmpty) {
      return const AutoBackupEligibility(
        result: AutoBackupEligibilityResult.noMeaningfulChanges,
        pendingReasons: <PendingBackupReason>[],
      );
    }

    if (_isThrottled(freshState, prefs.minimumIntervalMinutes)) {
      return AutoBackupEligibility(
        result: AutoBackupEligibilityResult.throttled,
        pendingReasons: pendingReasons,
      );
    }
    if (!_isDueForFrequency(freshState, prefs.frequency, trigger)) {
      return AutoBackupEligibility(
        result: AutoBackupEligibilityResult.waitingForSchedule,
        pendingReasons: pendingReasons,
      );
    }
    if (signature == freshState.lastSuccessfulDataSignature &&
        !pendingReasons.contains(PendingBackupReason.backupOverdue)) {
      return const AutoBackupEligibility(
        result: AutoBackupEligibilityResult.noMeaningfulChanges,
        pendingReasons: <PendingBackupReason>[],
      );
    }
    return AutoBackupEligibility(
      result: AutoBackupEligibilityResult.eligibleNow,
      pendingReasons: pendingReasons,
    );
  }

  @override
  Future<AutoBackupRunResult> runIfEligible({
    required AutoBackupTrigger trigger,
    bool force = false,
  }) async {
    final controller = ref.read(accountsSyncControllerProvider.notifier);
    final eligibility = await evaluateEligibility(trigger: trigger);
    if (!force &&
        eligibility.result != AutoBackupEligibilityResult.eligibleNow) {
      return AutoBackupRunResult(
        eligibility: eligibility.result,
        trigger: trigger,
        ran: false,
      );
    }
    await controller.updateAutoBackupState(
      inProgress: true,
      lastAttemptAtIso: DateTime.now().toIso8601String(),
      lastTrigger: trigger,
    );
    final result = await ref.read(remoteBackupRepositoryProvider).backupNow();
    final latestState = ref
        .read(accountsSyncControllerProvider)
        .autoBackupState;
    if (result.success) {
      await controller.updateAutoBackupState(
        inProgress: false,
        dirty: false,
        pendingReasons: const <PendingBackupReason>[],
        lastSuccessAtIso: DateTime.now().toIso8601String(),
        lastSuccessfulDataSignature: latestState.lastEvaluatedDataSignature,
        clearLastFailureCode: true,
      );
    } else {
      await controller.updateAutoBackupState(
        inProgress: false,
        lastFailureCode: result.messageCode ?? result.availability.name,
      );
    }
    return AutoBackupRunResult(
      eligibility: eligibility.result,
      trigger: trigger,
      ran: true,
      success: result.success,
      messageCode: result.messageCode,
    );
  }

  Future<String> _evaluateDirtyState({
    required AutoBackupTrigger trigger,
  }) async {
    final packageInfo = await ref.read(accountsSyncPackageInfoProvider.future);
    final controller = ref.read(accountsSyncControllerProvider.notifier);
    final payload = await controller.buildBackupPayload(
      currentProfileOnly: false,
      encrypt: false,
      sourceType: BackupSourceType.remoteBackup,
      useSyncScope: true,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
    final signature = backupPayloadFingerprint(payload);
    final currentState = ref
        .read(accountsSyncControllerProvider)
        .autoBackupState;
    final successfulSignature = currentState.lastSuccessfulDataSignature;
    final overdue = _isOverdue(
      currentState.lastSuccessAtIso,
      currentState.preferences.frequency,
    );
    final shouldTrackMeaningfulChanges =
        currentState.preferences.backupOnMeaningfulProgressChange;
    final dirty =
        shouldTrackMeaningfulChanges &&
        (successfulSignature == null || successfulSignature != signature);
    final pendingReasons = <PendingBackupReason>[
      if (dirty) PendingBackupReason.meaningfulProgressChanged,
      if (overdue) PendingBackupReason.backupOverdue,
      if (trigger == AutoBackupTrigger.signIn) PendingBackupReason.signedIn,
      if (trigger == AutoBackupTrigger.manualRetry)
        PendingBackupReason.manualRetry,
    ];
    await controller.updateAutoBackupState(
      dirty: dirty || overdue,
      pendingReasons: pendingReasons,
      lastEvaluatedAtIso: DateTime.now().toIso8601String(),
      lastEvaluatedDataSignature: signature,
    );
    return signature;
  }

  bool _isThrottled(AutoBackupPolicyState state, int minIntervalMinutes) {
    final lastAttempt = DateTime.tryParse(state.lastAttemptAtIso ?? '');
    if (lastAttempt == null) {
      return false;
    }
    return DateTime.now().difference(lastAttempt).inMinutes <
        minIntervalMinutes;
  }

  bool _isDueForFrequency(
    AutoBackupPolicyState state,
    AutoBackupFrequency frequency,
    AutoBackupTrigger trigger,
  ) {
    if (frequency == AutoBackupFrequency.smart) {
      return trigger != AutoBackupTrigger.appBackgrounded ||
          state.preferences.backupOnBackground;
    }
    if (trigger == AutoBackupTrigger.appBackgrounded &&
        !state.preferences.backupOnBackground) {
      return false;
    }
    return _isOverdue(state.lastSuccessAtIso, frequency);
  }

  bool _isOverdue(String? lastSuccessAtIso, AutoBackupFrequency frequency) {
    final lastSuccess = DateTime.tryParse(lastSuccessAtIso ?? '');
    if (lastSuccess == null) {
      return true;
    }
    final now = DateTime.now();
    return switch (frequency) {
      AutoBackupFrequency.smart => now.difference(lastSuccess).inHours >= 24,
      AutoBackupFrequency.daily => now.difference(lastSuccess).inHours >= 24,
      AutoBackupFrequency.weekly => now.difference(lastSuccess).inDays >= 7,
      AutoBackupFrequency.manualOnly => false,
    };
  }
}

final autoBackupControllerProvider = Provider<AutoBackupController>(
  DefaultAutoBackupController.new,
);

class _AutoBackupRuntimeBridge with WidgetsBindingObserver {
  _AutoBackupRuntimeBridge(this.ref) {
    WidgetsBinding.instance.addObserver(this);
    unawaited(
      ref
          .read(autoBackupControllerProvider)
          .runIfEligible(trigger: AutoBackupTrigger.appLaunch),
    );
  }

  final Ref ref;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(
        ref
            .read(autoBackupControllerProvider)
            .runIfEligible(trigger: AutoBackupTrigger.appResumed),
      );
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      final prefs = ref
          .read(accountsSyncControllerProvider)
          .autoBackupState
          .preferences;
      if (prefs.backupOnBackground) {
        unawaited(
          ref
              .read(autoBackupControllerProvider)
              .runIfEligible(trigger: AutoBackupTrigger.appBackgrounded),
        );
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

final autoBackupBootstrapProvider = Provider<void>((ref) {
  final bridge = _AutoBackupRuntimeBridge(ref);
  ref.listen<AuthState>(authStateProvider, (previous, next) {
    if (next.status == AuthStatus.authenticated &&
        previous?.status != AuthStatus.authenticated) {
      unawaited(
        ref
            .read(autoBackupControllerProvider)
            .runIfEligible(trigger: AutoBackupTrigger.signIn),
      );
    }
  });
  ref.onDispose(bridge.dispose);
});
