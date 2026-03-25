import '../data/tvos_foundation_registry.dart';
import '../data/tvos_release_governance.dart';
import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_release_governance_models.dart';
import 'tvos_release_policy.dart';

TVOSUpdateGovernanceSnapshot buildTVOSUpdateGovernanceSnapshot() {
  final gatedRoutePaths = tvosSurfaceFlags
      .where(
        (flag) =>
            flag.allowInSidebar &&
            flag.availability == TVOSFeatureAvailability.enabled,
      )
      .map((flag) => flag.routePath)
      .toList(growable: false);

  final allBlockingGatesPassing = tvosReleaseGovernanceGates
      .where((gate) => gate.blocksPromotion)
      .every((gate) => gate.isPassing);

  return TVOSUpdateGovernanceSnapshot(
    channel: tvosCurrentUpdateChannel,
    releaseStage: TVOSReleasePolicy.currentReleaseStage,
    gatedRoutePaths: gatedRoutePaths,
    requiredPhases: tvosGovernedReleasePhases,
    releaseGates: tvosReleaseGovernanceGates,
    allBlockingGatesPassing: allBlockingGatesPassing,
  );
}

bool tvosUpdateGovernanceMatchesEnabledSidebarRoutes() {
  final snapshot = buildTVOSUpdateGovernanceSnapshot();
  final enabledSidebarRoutes = tvosSurfaceFlags
      .where(
        (flag) =>
            flag.allowInSidebar &&
            flag.availability == TVOSFeatureAvailability.enabled,
      )
      .map((flag) => flag.routePath)
      .toSet();

  return snapshot.gatedRoutePaths.toSet().difference(enabledSidebarRoutes).isEmpty &&
      enabledSidebarRoutes.difference(snapshot.gatedRoutePaths.toSet()).isEmpty;
}

bool tvosGovernanceAllowsOnlyTestflightPromotion() {
  final snapshot = buildTVOSUpdateGovernanceSnapshot();
  return snapshot.channel == TVOSUpdateChannel.testflight &&
      snapshot.releaseStage == TVOSReleaseStage.testflight &&
      snapshot.allBlockingGatesPassing == false;
}

List<TVOSReleaseGate> tvosPassingReleaseGates() {
  return buildTVOSUpdateGovernanceSnapshot()
      .releaseGates
      .where((gate) => gate.isPassing)
      .toList(growable: false);
}

List<TVOSReleaseGate> tvosBlockingReleaseGatesStillOpen() {
  return buildTVOSUpdateGovernanceSnapshot()
      .releaseGates
      .where((gate) => gate.blocksPromotion && !gate.isPassing)
      .toList(growable: false);
}
