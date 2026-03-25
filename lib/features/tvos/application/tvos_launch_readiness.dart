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

  final readyForTestflight = tvosLaunchReadinessGates
      .where((gate) => gate.blocksTestflight)
      .every((gate) => gate.isPassing);

  final readyForPublicLaunch = tvosLaunchReadinessGates
      .where((gate) => gate.blocksPublicLaunch)
      .every((gate) => gate.isPassing);

  return TVOSLaunchReadinessSnapshot(
    level: readyForPublicLaunch
        ? TVOSLaunchReadinessLevel.publicLaunchReady
        : TVOSLaunchReadinessLevel.publicLaunchBlocked,
    releaseStage: TVOSReleasePolicy.currentReleaseStage,
    completedPhases: tvosLaunchReadinessPhases,
    polishedRoutePaths: polishedRoutePaths,
    gates: tvosLaunchReadinessGates,
    readyForTestflight: readyForTestflight,
    readyForPublicLaunch: readyForPublicLaunch,
  );
}

bool tvosLaunchReadinessIncludesPhase27() {
  return buildTVOSLaunchReadinessSnapshot()
      .completedPhases
      .contains(TVOSPhaseId.phase27LaunchPolishReadiness);
}

List<TVOSLaunchReadinessGate> tvosPublicLaunchBlockingGates() {
  return buildTVOSLaunchReadinessSnapshot()
      .gates
      .where((gate) => gate.blocksPublicLaunch && !gate.isPassing)
      .toList(growable: false);
}
