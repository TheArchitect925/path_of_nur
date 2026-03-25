import '../data/tvos_focus_regression_matrix.dart';
import '../data/tvos_foundation_registry.dart';
import '../data/tvos_quality_guardrails.dart';
import '../domain/tvos_focus_regression_models.dart';
import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_quality_guardrail_models.dart';

List<TVOSFocusQaScenario> activeTVOSFocusQaScenarios() {
  final enabledRoutePaths = tvosSurfaceFlags
      .where(
        (flag) =>
            flag.availability == TVOSFeatureAvailability.enabled &&
            flag.allowInSidebar,
      )
      .map((flag) => flag.routePath)
      .toSet();

  return tvosFocusQaScenarios
      .where((scenario) => enabledRoutePaths.contains(scenario.routePath))
      .toList(growable: false);
}

bool tvosAllEnabledSidebarRoutesHaveFocusQaCoverage() {
  final enabledRoutePaths = tvosSurfaceFlags
      .where(
        (flag) =>
            flag.availability == TVOSFeatureAvailability.enabled &&
            flag.allowInSidebar,
      )
      .map((flag) => flag.routePath)
      .toSet();

  final coveredRoutePaths = activeTVOSFocusQaScenarios()
      .map((scenario) => scenario.routePath)
      .toSet();

  return enabledRoutePaths.difference(coveredRoutePaths).isEmpty;
}

bool tvosAllFocusQaScenariosHaveStableSectionOrder() {
  return activeTVOSFocusQaScenarios().every((scenario) {
    if (scenario.orderedSectionIds.isEmpty) {
      return false;
    }

    final uniqueSections = scenario.orderedSectionIds.toSet();
    return scenario.orderedSectionIds.first == scenario.defaultSectionId &&
        uniqueSections.length == scenario.orderedSectionIds.length &&
        uniqueSections.contains(scenario.defaultSectionId);
  });
}

bool tvosGuardrailFocusCoverageMatchesQaMatrix() {
  final surfacesRequiringFocusQa = tvosQualityGuardrailDefinitions
      .where((guardrail) => guardrail.requiresFocusQaCoverage)
      .map((guardrail) => guardrail.surfaceId)
      .toSet();

  final coveredSurfaces = activeTVOSFocusQaScenarios()
      .map((scenario) => scenario.surfaceId)
      .toSet();

  return surfacesRequiringFocusQa.difference(coveredSurfaces).isEmpty;
}

List<TVOSFocusQaScenario> highRiskTVOSFocusQaScenarios() {
  return activeTVOSFocusQaScenarios()
      .where((scenario) => scenario.risk == TVOSFocusRegressionRisk.high)
      .toList(growable: false);
}

List<TVOSAnalyticsEventDefinition> tvosFocusQaTelemetryEvents() {
  final surfacesUnderQa = activeTVOSFocusQaScenarios()
      .map((scenario) => scenario.surfaceId)
      .toSet();

  return tvosAnalyticsEventDefinitions
      .where((event) => surfacesUnderQa.contains(event.surfaceId))
      .toList(growable: false);
}
