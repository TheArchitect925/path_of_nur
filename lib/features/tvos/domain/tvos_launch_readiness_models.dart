import 'tvos_foundation_models.dart';

enum TVOSLaunchReadinessLevel {
  testflightReady,
  publicLaunchBlocked,
  publicLaunchReady,
}

enum TVOSLaunchReadinessGateId {
  repoSideReleaseBuild,
  launchPolishEmptyStates,
  localizationAccessibility,
  focusRegressionCoverage,
  releaseGovernanceAligned,
  signedArchiveDistribution,
  realDeviceAppleTvQa,
}

class TVOSLaunchReadinessGate {
  const TVOSLaunchReadinessGate({
    required this.id,
    required this.label,
    required this.isPassing,
    required this.blocksTestflight,
    required this.blocksPublicLaunch,
    required this.notes,
  });

  final TVOSLaunchReadinessGateId id;
  final String label;
  final bool isPassing;
  final bool blocksTestflight;
  final bool blocksPublicLaunch;
  final String notes;
}

class TVOSLaunchReadinessSnapshot {
  const TVOSLaunchReadinessSnapshot({
    required this.level,
    required this.releaseStage,
    required this.completedPhases,
    required this.polishedRoutePaths,
    required this.gates,
    required this.readyForTestflight,
    required this.readyForPublicLaunch,
  });

  final TVOSLaunchReadinessLevel level;
  final TVOSReleaseStage releaseStage;
  final List<TVOSPhaseId> completedPhases;
  final List<String> polishedRoutePaths;
  final List<TVOSLaunchReadinessGate> gates;
  final bool readyForTestflight;
  final bool readyForPublicLaunch;
}
