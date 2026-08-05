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

enum TVOSDistributionEvidenceId { signedArchive, testflightUpload }

enum TVOSDistributionEvidenceStatus { missing, recorded }

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

class TVOSDistributionEvidenceRecord {
  const TVOSDistributionEvidenceRecord({
    required this.id,
    required this.label,
    required this.status,
    required this.reference,
    required this.notes,
    this.recordedOn,
  });

  final TVOSDistributionEvidenceId id;
  final String label;
  final TVOSDistributionEvidenceStatus status;
  final String reference;
  final String notes;
  final DateTime? recordedOn;

  bool get isRecorded => status == TVOSDistributionEvidenceStatus.recorded;
}

class TVOSLaunchReadinessSnapshot {
  const TVOSLaunchReadinessSnapshot({
    required this.level,
    required this.releaseStage,
    required this.completedPhases,
    required this.polishedRoutePaths,
    required this.distributionEvidence,
    required this.gates,
    required this.readyForTestflight,
    required this.readyForPublicLaunch,
  });

  final TVOSLaunchReadinessLevel level;
  final TVOSReleaseStage releaseStage;
  final List<TVOSPhaseId> completedPhases;
  final List<String> polishedRoutePaths;
  final List<TVOSDistributionEvidenceRecord> distributionEvidence;
  final List<TVOSLaunchReadinessGate> gates;
  final bool readyForTestflight;
  final bool readyForPublicLaunch;
}
