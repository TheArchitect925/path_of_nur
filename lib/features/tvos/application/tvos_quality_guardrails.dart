import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/tvos_foundation_registry.dart';
import '../data/tvos_quality_guardrails.dart';
import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_quality_guardrail_models.dart';
import 'tvos_feature_flags.dart';

final tvosDiagnosticsModeProvider = Provider<TVOSDiagnosticsMode>((ref) {
  return TVOSDiagnosticsMode.localBufferOnly;
});

final tvosActiveQualityGuardrailsProvider =
    Provider<List<TVOSQualityGuardrailDefinition>>((ref) {
      final enabledSurfaceIds = ref
          .watch(tvosEnabledSurfaceFlagsProvider)
          .map((flag) => flag.surfaceId)
          .toSet();
      return tvosQualityGuardrailDefinitions
          .where((guardrail) => enabledSurfaceIds.contains(guardrail.surfaceId))
          .toList(growable: false);
    });

List<TVOSQualityGuardrailDefinition> activeTVOSQualityGuardrails() {
  final enabledSurfaceIds = tvosSurfaceFlags
      .where((flag) => flag.availability == TVOSFeatureAvailability.enabled)
      .map((flag) => flag.surfaceId)
      .toSet();
  return tvosQualityGuardrailDefinitions
      .where((guardrail) => enabledSurfaceIds.contains(guardrail.surfaceId))
      .toList(growable: false);
}

bool tvosRouteRequiresPlaybackErrorCapture(String routePath) {
  final guardrail = tvosQualityGuardrailDefinitions
      .where((item) => item.routePath == routePath)
      .cast<TVOSQualityGuardrailDefinition?>()
      .firstWhere((item) => item != null, orElse: () => null);
  return guardrail?.requiresPlaybackErrorCapture ?? false;
}

bool tvosRouteRequiresFocusQaCoverage(String routePath) {
  final guardrail = tvosQualityGuardrailDefinitions
      .where((item) => item.routePath == routePath)
      .cast<TVOSQualityGuardrailDefinition?>()
      .firstWhere((item) => item != null, orElse: () => null);
  return guardrail?.requiresFocusQaCoverage ?? false;
}

bool tvosUsesLocalOnlyDiagnostics() => true;
