import 'tvos_foundation_models.dart';

enum TVOSUpdateChannel {
  internal,
  testflight,
  releaseCandidate,
  publicStore,
}

enum TVOSReleaseGateId {
  unsignedReleaseBuild,
  focusRegressionHarness,
  diagnosticsGuardrails,
  performanceProfiles,
  testflightChecklist,
  companionManagedSyncPosture,
  realDeviceQaRequired,
}

class TVOSReleaseGate {
  const TVOSReleaseGate({
    required this.id,
    required this.label,
    required this.isPassing,
    required this.blocksPromotion,
    required this.notes,
  });

  final TVOSReleaseGateId id;
  final String label;
  final bool isPassing;
  final bool blocksPromotion;
  final String notes;
}

class TVOSUpdateGovernanceSnapshot {
  const TVOSUpdateGovernanceSnapshot({
    required this.channel,
    required this.releaseStage,
    required this.gatedRoutePaths,
    required this.requiredPhases,
    required this.releaseGates,
    required this.allBlockingGatesPassing,
  });

  final TVOSUpdateChannel channel;
  final TVOSReleaseStage releaseStage;
  final List<String> gatedRoutePaths;
  final List<TVOSPhaseId> requiredPhases;
  final List<TVOSReleaseGate> releaseGates;
  final bool allBlockingGatesPassing;
}
