import 'tvos_foundation_models.dart';

enum TVOSFocusRegressionRisk { low, medium, high }

class TVOSFocusQaScenario {
  const TVOSFocusQaScenario({
    required this.surfaceId,
    required this.routePath,
    required this.defaultSectionId,
    required this.orderedSectionIds,
    required this.requiresLeftEdgeNavigationEscape,
    required this.requiresContentFocusRestore,
    required this.requiresNavigationRestore,
    required this.requiresModalReturnCoverage,
    required this.risk,
    required this.notes,
  });

  final TVOSSurfaceId surfaceId;
  final String routePath;
  final String defaultSectionId;
  final List<String> orderedSectionIds;
  final bool requiresLeftEdgeNavigationEscape;
  final bool requiresContentFocusRestore;
  final bool requiresNavigationRestore;
  final bool requiresModalReturnCoverage;
  final TVOSFocusRegressionRisk risk;
  final String notes;
}
