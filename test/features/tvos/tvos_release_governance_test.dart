import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_release_governance.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_release_governance_models.dart';

void main() {
  test('update governance snapshot stays on testflight channel', () {
    final snapshot = buildTVOSUpdateGovernanceSnapshot();

    expect(snapshot.channel, TVOSUpdateChannel.testflight);
    expect(snapshot.releaseStage, TVOSReleaseStage.testflight);
  });

  test('governed route set matches enabled sidebar routes', () {
    expect(tvosUpdateGovernanceMatchesEnabledSidebarRoutes(), isTrue);
  });

  test('governance requires phases 21, 22, 24, 25, 26, and 23', () {
    final snapshot = buildTVOSUpdateGovernanceSnapshot();

    expect(snapshot.requiredPhases, <TVOSPhaseId>[
      TVOSPhaseId.phase21FeatureFlagsParity,
      TVOSPhaseId.phase22ContentRegistryOnboarding,
      TVOSPhaseId.phase24AnalyticsCrashQuality,
      TVOSPhaseId.phase25TestFocusRegression,
      TVOSPhaseId.phase26PerformanceOptimization,
      TVOSPhaseId.phase23UpdatePipelineGovernance,
    ]);
  });

  test('public promotion remains blocked by real-device Apple TV QA', () {
    expect(tvosGovernanceAllowsOnlyTestflightPromotion(), isTrue);

    final openBlockingGates = tvosBlockingReleaseGatesStillOpen();
    expect(openBlockingGates, hasLength(1));
    expect(openBlockingGates.single.id, TVOSReleaseGateId.realDeviceQaRequired);
  });

  test('passing gates include diagnostics, focus regression, and performance', () {
    final passingGateIds = tvosPassingReleaseGates()
        .map((gate) => gate.id)
        .toSet();

    expect(passingGateIds, contains(TVOSReleaseGateId.diagnosticsGuardrails));
    expect(passingGateIds, contains(TVOSReleaseGateId.focusRegressionHarness));
    expect(passingGateIds, contains(TVOSReleaseGateId.performanceProfiles));
  });
}
