import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/app_theme.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/motion/ambient_motion.dart';
import 'package:path_of_nur/shared/motion/motion_preferences.dart';
import 'package:path_of_nur/shared/widgets/global_background.dart';

import '../../test_helpers/app_test_harness.dart';

/// The painted moon on the night skies breathes on the ambient cycle; the
/// daylight sky has no moon and no halo.
void main() {
  const breath = Key('shell-moon-breath');

  Future<void> pumpSky(
    WidgetTester tester, {
    required AppThemeMode mode,
    bool continuousMotion = false,
  }) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        // The real clock re-arms a 30 s timer; a fixed night keeps the test
        // free of pending timers.
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T22:00:00')),
        ),
        continuousMotionProvider.overrideWithValue(continuousMotion),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.themeFor(
            mode: mode,
            pageTransitionStyle: AppPageTransitionStyle.defaultSystem,
            reduceMotion: false,
            disableGlassTransparency: false,
            disableColoredGlass: false,
            disableBackground: false,
            highContrastText: false,
            glassSurfaceAlpha: 0.93,
          ),
          home: const AmbientMotion(
            child: Scaffold(body: Stack(children: [GlobalBackground()])),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('Midnight paints a halo behind the moon and stays settled', (
    tester,
  ) async {
    await pumpSky(tester, mode: AppThemeMode.midnight);
    expect(find.byKey(breath), findsOneWidget);
    // No ticker in a test: the halo rests, and the page settles.
    await tester.pumpAndSettle();
    expect(find.byKey(breath), findsOneWidget);
  });

  testWidgets('Ramadan and Laylat al-Qadr breathe too', (tester) async {
    await pumpSky(tester, mode: AppThemeMode.ramadan);
    expect(find.byKey(breath), findsOneWidget);
    await pumpSky(tester, mode: AppThemeMode.laylatAlQadr);
    expect(find.byKey(breath), findsOneWidget);
  });

  testWidgets('the daylight sky has no halo', (tester) async {
    await pumpSky(tester, mode: AppThemeMode.noorGlass);
    expect(find.byKey(breath), findsNothing);
  });

  testWidgets('with the ambient ticker on, the halo changes between frames', (
    tester,
  ) async {
    await pumpSky(tester, mode: AppThemeMode.midnight, continuousMotion: true);
    Transform halo() => tester.widget<Transform>(
      find.descendant(of: find.byKey(breath), matching: find.byType(Transform)),
    );
    final before = halo().transform.getMaxScaleOnAxis();
    await tester.pump(const Duration(seconds: 2));
    expect(halo().transform.getMaxScaleOnAxis(), isNot(before));
  });
}
