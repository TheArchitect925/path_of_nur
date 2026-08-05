import '../data/tvos_foundation_registry.dart';
import '../data/tvos_launch_readiness.dart';
import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_launch_readiness_models.dart';
import 'tvos_release_policy.dart';

TVOSLaunchReadinessSnapshot buildTVOSLaunchReadinessSnapshot() {
  final polishedRoutePaths = tvosSurfaceFlags
      .where(
        (flag) =>
            flag.allowInSidebar &&
            flag.availability == TVOSFeatureAvailability.enabled,
      )
      .map((flag) => flag.routePath)
      .toList(growable: false);

  final distributionEvidence = tvosLaunchDistributionEvidence;
  final gates = tvosBaseLaunchReadinessGates
      .map(
        (gate) => gate.id == TVOSLaunchReadinessGateId.signedArchiveDistribution
            ? TVOSLaunchReadinessGate(
                id: gate.id,
                label: gate.label,
                isPassing: _hasRecordedDistributionProof(distributionEvidence),
                blocksTestflight: gate.blocksTestflight,
                blocksPublicLaunch: gate.blocksPublicLaunch,
                notes: gate.notes,
              )
            : gate,
      )
      .toList(growable: false);

  final readyForTestflight = gates
      .where((gate) => gate.blocksTestflight)
      .every((gate) => gate.isPassing);

  final readyForPublicLaunch = gates
      .where((gate) => gate.blocksPublicLaunch)
      .every((gate) => gate.isPassing);

  return TVOSLaunchReadinessSnapshot(
    level: readyForPublicLaunch
        ? TVOSLaunchReadinessLevel.publicLaunchReady
        : TVOSLaunchReadinessLevel.publicLaunchBlocked,
    releaseStage: TVOSReleasePolicy.currentReleaseStage,
    completedPhases: tvosLaunchReadinessPhases,
    polishedRoutePaths: polishedRoutePaths,
    distributionEvidence: distributionEvidence,
    gates: gates,
    readyForTestflight: readyForTestflight,
    readyForPublicLaunch: readyForPublicLaunch,
  );
}

bool tvosLaunchReadinessIncludesPhase27() {
  return buildTVOSLaunchReadinessSnapshot().completedPhases.contains(
    TVOSPhaseId.phase27LaunchPolishReadiness,
  );
}

List<TVOSLaunchReadinessGate> tvosPublicLaunchBlockingGates() {
  return buildTVOSLaunchReadinessSnapshot().gates
      .where((gate) => gate.blocksPublicLaunch && !gate.isPassing)
      .toList(growable: false);
}

bool tvosHasRecordedSignedArchiveProof() {
  return _hasRecordedEvidence(
    buildTVOSLaunchReadinessSnapshot().distributionEvidence,
    TVOSDistributionEvidenceId.signedArchive,
  );
}

bool tvosHasRecordedTestflightUploadProof() {
  return _hasRecordedEvidence(
    buildTVOSLaunchReadinessSnapshot().distributionEvidence,
    TVOSDistributionEvidenceId.testflightUpload,
  );
}

bool _hasRecordedDistributionProof(
  List<TVOSDistributionEvidenceRecord> evidence,
) {
  return _hasRecordedEvidence(
        evidence,
        TVOSDistributionEvidenceId.signedArchive,
      ) &&
      _hasRecordedEvidence(
        evidence,
        TVOSDistributionEvidenceId.testflightUpload,
      );
}

bool _hasRecordedEvidence(
  List<TVOSDistributionEvidenceRecord> evidence,
  TVOSDistributionEvidenceId id,
) {
  return evidence.any((record) => record.id == id && record.isRecorded);
}
