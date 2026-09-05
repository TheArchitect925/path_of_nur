import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/worship/application/dhikr_controller.dart';
import 'package:path_of_nur/features/worship/application/dhikr_custom_routines_provider.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_catalog.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_controller.dart';
import 'package:path_of_nur/features/worship/presentation/dhikr/dhikr_counter_page.dart';
import 'package:path_of_nur/features/worship/presentation/dhikr/dhikr_insights_page.dart';
import 'package:path_of_nur/features/worship/presentation/dhikr/dhikr_landing_page.dart';
import 'package:path_of_nur/features/worship/presentation/dhikr/dhikr_routine_builder_page.dart';
import 'package:path_of_nur/features/worship/presentation/dhikr/dhikr_routine_page.dart';
import 'package:path_of_nur/features/worship/presentation/dhikr/widgets/misbaha_ring.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<ProviderContainer> makeContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T18:00:00')),
        ),
      ],
    );
  }

  testWidgets('the dhikr route opens the routine-first landing', (
    tester,
  ) async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/worship/dhikr');
    await pumpRouteFrames(tester);

    expect(find.byType(DhikrLandingPage), findsOneWidget);
    expect(find.byKey(const Key('dhikr-now-primary')), findsOneWidget);
    expect(tester.takeException(), isNull);

    final routineRow = find.byKey(
      Key('dhikr-routine-$kDhikrRoutineAfterSalahId'),
    );
    await tester.dragUntilVisible(
      routineRow,
      find.byType(Scrollable).first,
      const Offset(0, -240),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(routineRow, findsOneWidget);

    final freeCount = find.byKey(const Key('dhikr-free-count'));
    await tester.dragUntilVisible(
      freeCount,
      find.byType(Scrollable).first,
      const Offset(0, -240),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(freeCount, findsOneWidget);
    expect(find.byKey(const Key('dhikr-insights-link')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('free count opens the counter and taps count beads', (
    tester,
  ) async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    router.go('/worship/dhikr');
    await pumpRouteFrames(tester);

    await tester.tap(find.byKey(const Key('dhikr-now-free-count')));
    await pumpRouteFrames(tester);

    expect(find.byType(DhikrCounterPage), findsOneWidget);
    expect(find.byType(MisbahaRing), findsOneWidget);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const Key('dhikr-counter-tap-zone')));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(container.read(dhikrControllerProvider).currentCount, 3);

    await tester.tap(find.byKey(const Key('dhikr-counter-finish')));
    await pumpRouteFrames(tester);
    expect(container.read(dhikrControllerProvider).currentCount, 0);
    expect(
      container.read(dhikrControllerProvider).recentSessions,
      hasLength(1),
    );
    expect(container.read(dhikrControllerProvider).dailyTotals, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the routine player starts the routine it was opened with', (
    tester,
  ) async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    router.go('/worship/dhikr/routine/$kDhikrRoutineAfterSalahId?prayer=asr');
    await pumpRouteFrames(tester);

    expect(find.byType(DhikrRoutinePage), findsOneWidget);
    final progress = container.read(dhikrRoutineControllerProvider);
    expect(progress?.routineId, kDhikrRoutineAfterSalahId);
    expect(progress?.prayerId, 'asr');

    await tester.tap(find.byKey(const Key('dhikr-routine-tap-zone')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(container.read(dhikrRoutineControllerProvider)?.stepCount, 1);

    await tester.tap(find.byKey(const Key('dhikr-routine-skip')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(container.read(dhikrRoutineControllerProvider)?.stepIndex, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the builder saves a custom routine that the landing lists', (
    tester,
  ) async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    router.go('/worship/dhikr/routine-builder');
    await pumpRouteFrames(tester);
    expect(find.byType(DhikrRoutineBuilderPage), findsOneWidget);

    await tester.tap(find.byKey(const Key('dhikr-builder-save')));
    await pumpRouteFrames(tester);
    expect(find.byKey(const Key('dhikr-builder-error')), findsOneWidget);
    expect(container.read(dhikrCustomRoutinesProvider), isEmpty);

    await tester.enterText(
      find.byKey(const Key('dhikr-builder-name')),
      'Walk home',
    );
    await tester.tap(find.byKey(const Key('dhikr-builder-add-step')));
    await pumpRouteFrames(tester);
    await tester.tap(
      find.byKey(const Key('dhikr-builder-phrase-alhamdulillah')),
    );
    await pumpRouteFrames(tester);
    expect(find.byKey(const ValueKey('dhikr-builder-step-0')), findsOneWidget);

    await tester.tap(find.byKey(const Key('dhikr-builder-save')));
    await pumpRouteFrames(tester);
    final saved = container.read(dhikrCustomRoutinesProvider);
    expect(saved, hasLength(1));
    expect(saved.single.name, 'Walk home');
    expect(saved.single.steps.single.id, 'alhamdulillah');
    expect(saved.single.steps.single.count, 33);

    router.go('/worship/dhikr');
    await pumpRouteFrames(tester);
    final row = find.byKey(Key('dhikr-routine-${saved.single.id}'));
    await tester.dragUntilVisible(
      row,
      find.byType(Scrollable).first,
      const Offset(0, -240),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(row, findsOneWidget);
    expect(find.byKey(const Key('dhikr-routine-new')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('insights page renders from an empty history', (tester) async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    router.go('/worship/dhikr/insights');
    await pumpRouteFrames(tester);

    expect(find.byType(DhikrInsightsPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
