import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_launch_readiness.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_launch_readiness_models.dart';

void main() {
  test('launch readiness includes the phase 27 launch polish pass', () {
    expect(tvosLaunchReadinessIncludesPhase27(), isTrue);
  });

  test('launch readiness records signed archive and TestFlight upload evidence slots', () {
    final snapshot = buildTVOSLaunchReadinessSnapshot();
    final evidenceIds = snapshot.distributionEvidence.map((item) => item.id).toSet();

    expect(evidenceIds, <TVOSDistributionEvidenceId>{
      TVOSDistributionEvidenceId.signedArchive,
      TVOSDistributionEvidenceId.testflightUpload,
    });
    expect(tvosHasRecordedSignedArchiveProof(), isFalse);
    expect(tvosHasRecordedTestflightUploadProof(), isFalse);
  });

  test('tvos remains ready for testflight but blocked for public launch', () {
    final snapshot = buildTVOSLaunchReadinessSnapshot();

    expect(snapshot.releaseStage, TVOSReleaseStage.testflight);
    expect(snapshot.readyForTestflight, isTrue);
    expect(snapshot.readyForPublicLaunch, isFalse);
    expect(snapshot.level, TVOSLaunchReadinessLevel.publicLaunchBlocked);
  });

  test('public launch blockers stay limited to signed distribution and device qa', () {
    final blockerIds = tvosPublicLaunchBlockingGates().map((gate) => gate.id).toSet();

    expect(blockerIds, <TVOSLaunchReadinessGateId>{
      TVOSLaunchReadinessGateId.signedArchiveDistribution,
      TVOSLaunchReadinessGateId.realDeviceAppleTvQa,
    });
  });

  test('launch readiness keeps governance, focus, polish, and localization gates passing', () {
    final passingGateIds = buildTVOSLaunchReadinessSnapshot()
        .gates
        .where((gate) => gate.isPassing)
        .map((gate) => gate.id)
        .toSet();

    expect(passingGateIds, contains(TVOSLaunchReadinessGateId.launchPolishEmptyStates));
    expect(passingGateIds, contains(TVOSLaunchReadinessGateId.localizationAccessibility));
    expect(passingGateIds, contains(TVOSLaunchReadinessGateId.focusRegressionCoverage));
    expect(passingGateIds, contains(TVOSLaunchReadinessGateId.releaseGovernanceAligned));
  });

  test('signed distribution gate depends on recorded archive and upload proof', () {
    final gate = buildTVOSLaunchReadinessSnapshot().gates.firstWhere(
      (item) => item.id == TVOSLaunchReadinessGateId.signedArchiveDistribution,
    );

    expect(gate.isPassing, isFalse);
  });
}
