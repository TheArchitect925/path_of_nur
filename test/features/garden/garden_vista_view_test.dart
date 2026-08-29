import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/garden/application/garden_scene_composer.dart';
import 'package:path_of_nur/features/garden/application/garden_scene_provider.dart';
import 'package:path_of_nur/features/garden/presentation/widgets/garden_vista/garden_motion_painter.dart';
import 'package:path_of_nur/features/garden/presentation/widgets/garden_vista/garden_vista_placeholder_painter.dart';
import 'package:path_of_nur/features/garden/presentation/widgets/garden_vista/garden_vista_view.dart';
import 'package:path_of_nur/features/profile/application/profile_settings_provider.dart';

import '../../test_helpers/garden_fixtures.dart';

void main() {
  const composer = GardenSceneComposer();

  Future<ProviderContainer> pumpVista(
    WidgetTester tester, {
    required GardenVistaView vista,
  }) async {
    final container = await makeGardenTestContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: SizedBox(width: 400, child: vista)),
          ),
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  testWidgets('renders the placeholder-painted scene for any spec',
      (tester) async {
    final spec = composer.compose(
      garden: makeGardenState(
        prayer: 0.6,
        learning: 0.65,
        remembrance: 0.6,
        consistency: 0.7,
        wisdom: 0.4,
        drops: 400,
        maturity: 55,
      ),
      lastSeen: null,
    );
    await pumpVista(tester, vista: GardenVistaView(spec: spec));
    expect(
      find.byWidgetPredicate((widget) =>
          widget is CustomPaint &&
          widget.painter is GardenVistaPlaceholderPainter),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('every crop window lays out without errors', (tester) async {
    final spec = composer.compose(
      garden: makeGardenState(drops: 1000, maturity: 100, prayer: 1),
      lastSeen: null,
    );
    for (final crop in GardenVistaCrop.values) {
      await pumpVista(tester, vista: GardenVistaView(spec: spec, crop: crop));
      expect(tester.takeException(), isNull, reason: 'crop $crop');
    }
  });

  testWidgets('exposes the provided semantic label', (tester) async {
    final spec =
        composer.compose(garden: makeGardenState(), lastSeen: null);
    await pumpVista(
      tester,
      vista: GardenVistaView(spec: spec, semanticLabel: 'Seed · 0% grown'),
    );
    expect(find.bySemanticsLabel('Seed · 0% grown'), findsOneWidget);
  });

  testWidgets(
      'manageSeenLifecycle writes the first-visit baseline memento silently',
      (tester) async {
    final spec = composer.compose(
      garden: makeGardenState(prayer: 0.4, drops: 120, maturity: 26),
      lastSeen: null,
    );
    final container = await pumpVista(
      tester,
      vista: GardenVistaView(spec: spec, manageSeenLifecycle: true),
    );
    await tester.pump();
    final memento =
        container.read(gardenSceneMementoRepositoryProvider).read('learner_1');
    expect(memento, isNotNull);
    expect(memento!.variantFor(spec.elements.first.id),
        spec.elements.first.variantLevel);
  });

  testWidgets('hero crop runs the motion layer; reduce-motion stills it',
      (tester) async {
    final spec = composer.compose(
      garden: makeGardenState(prayer: 0.6, drops: 200, maturity: 55),
      lastSeen: null,
    );
    final container = await pumpVista(tester, vista: GardenVistaView(spec: spec));
    expect(
      find.byWidgetPredicate((widget) =>
          widget is CustomPaint && widget.painter is GardenMotionPainter),
      findsOneWidget,
    );

    container
        .read(profileSettingsProvider.notifier)
        .setReduceMotion(true);
    await tester.pump();
    expect(
      find.byWidgetPredicate((widget) =>
          widget is CustomPaint && widget.painter is GardenMotionPainter),
      findsNothing,
      reason: 'reduce-motion must unmount every animated layer',
    );
  });

  testWidgets('home-card crop never mounts the motion layer', (tester) async {
    final spec = composer.compose(
      garden: makeGardenState(drops: 800, maturity: 90),
      lastSeen: null,
    );
    await pumpVista(
      tester,
      vista: GardenVistaView(spec: spec, crop: GardenVistaCrop.homeCard),
    );
    expect(
      find.byWidgetPredicate((widget) =>
          widget is CustomPaint && widget.painter is GardenMotionPainter),
      findsNothing,
    );
  });

  testWidgets('compact card without lifecycle management writes nothing',
      (tester) async {
    final spec = composer.compose(
      garden: makeGardenState(prayer: 0.4),
      lastSeen: null,
    );
    final container = await pumpVista(
      tester,
      vista: GardenVistaView(spec: spec, crop: GardenVistaCrop.homeCard),
    );
    await tester.pump();
    expect(
      container.read(gardenSceneMementoRepositoryProvider).read('learner_1'),
      isNull,
    );
  });
}
