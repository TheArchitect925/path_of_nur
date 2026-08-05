import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_focus_regression.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_focus_regression_models.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';

void main() {
  test('every enabled sidebar route has focus QA coverage', () {
    expect(tvosAllEnabledSidebarRoutesHaveFocusQaCoverage(), isTrue);
  });

  test('focus QA scenarios preserve stable default-first section order', () {
    expect(tvosAllFocusQaScenariosHaveStableSectionOrder(), isTrue);
  });

  test('guardrail surfaces requiring focus QA are covered by the matrix', () {
    expect(tvosGuardrailFocusCoverageMatchesQaMatrix(), isTrue);
  });

  test('quran remains the only high-risk focus regression route', () {
    final highRiskScenarios = highRiskTVOSFocusQaScenarios();

    expect(highRiskScenarios, hasLength(1));
    expect(highRiskScenarios.single.surfaceId, TVOSSurfaceId.quran);
    expect(highRiskScenarios.single.requiresModalReturnCoverage, isTrue);
    expect(highRiskScenarios.single.requiresLeftEdgeNavigationEscape, isTrue);
  });

  test(
    'settings focus regression coverage includes diagnostics-safe support lane',
    () {
      final settingsScenario = activeTVOSFocusQaScenarios().firstWhere(
        (scenario) => scenario.surfaceId == TVOSSurfaceId.settings,
      );

      expect(settingsScenario.defaultSectionId, 'settings.startup');
      expect(settingsScenario.orderedSectionIds, <String>[
        'settings.startup',
        'settings.listening',
        'settings.support',
      ]);
    },
  );

  test(
    'all active focus QA scenarios expect navigation and content restore',
    () {
      for (final scenario in activeTVOSFocusQaScenarios()) {
        expect(
          scenario.requiresContentFocusRestore,
          isTrue,
          reason: 'Expected content restore coverage for ${scenario.routePath}',
        );
        expect(
          scenario.requiresNavigationRestore,
          isTrue,
          reason:
              'Expected navigation restore coverage for ${scenario.routePath}',
        );
      }
    },
  );

  test('focus QA telemetry surface set includes route and settings events', () {
    final eventNames = tvosFocusQaTelemetryEvents()
        .map((event) => event.name)
        .toSet();

    expect(eventNames, contains('tvos_route_opened'));
    expect(eventNames, contains('tvos_settings_changed'));
    expect(eventNames, contains('tvos_playback_error'));
  });

  test(
    'all active focus QA scenarios use medium-or-higher risk classification',
    () {
      final risks = activeTVOSFocusQaScenarios()
          .map((scenario) => scenario.risk)
          .toSet();

      expect(risks.contains(TVOSFocusRegressionRisk.low), isFalse);
    },
  );
}
