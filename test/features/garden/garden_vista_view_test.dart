import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/garden/application/garden_scene_composer.dart';
import 'package:path_of_nur/features/garden/application/garden_scene_provider.dart';
import 'package:path_of_nur/features/garden/data/garden_scene_layout.g.dart';
import 'package:path_of_nur/features/garden/domain/garden_scene_models.dart';
import 'package:path_of_nur/features/garden/presentation/widgets/garden_vista/garden_bloom_painter.dart';
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

  testWidgets('renders the placeholder-painted scene for any spec', (
    tester,
  ) async {
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
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint &&
            widget.painter is GardenVistaPlaceholderPainter,
      ),
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
      await pumpVista(
        tester,
        vista: GardenVistaView(spec: spec, crop: crop),
      );
      expect(tester.takeException(), isNull, reason: 'crop $crop');
    }
  });

  testWidgets('exposes the provided semantic label', (tester) async {
    final spec = composer.compose(garden: makeGardenState(), lastSeen: null);
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
      final memento = container
          .read(gardenSceneMementoRepositoryProvider)
          .read('learner_1');
      expect(memento, isNotNull);
      expect(
        memento!.variantFor(spec.elements.first.id),
        spec.elements.first.variantLevel,
      );
    },
  );

  testWidgets('hero crop runs the motion layer; reduce-motion stills it', (
    tester,
  ) async {
    final spec = composer.compose(
      garden: makeGardenState(prayer: 0.6, drops: 200, maturity: 55),
      lastSeen: null,
    );
    final container = await pumpVista(
      tester,
      vista: GardenVistaView(spec: spec),
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is GardenMotionPainter,
      ),
      findsOneWidget,
    );

    container.read(profileSettingsProvider.notifier).setReduceMotion(true);
    await tester.pump();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is GardenMotionPainter,
      ),
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
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is GardenMotionPainter,
      ),
      findsNothing,
    );
  });

  testWidgets('new growth plays the bloom once, then acknowledges it', (
    tester,
  ) async {
    final container = await makeGardenTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(gardenSceneSeenControllerProvider);

    // Establish a baseline, then grow the garden.
    final before = composer.compose(
      garden: makeGardenState(prayer: 0.1),
      lastSeen: null,
    );
    await controller.ensureBaseline(before, now: DateTime(2026, 8, 29));
    final grown = composer.compose(
      garden: makeGardenState(prayer: 0.6, drops: 120, maturity: 30),
      lastSeen: container
          .read(gardenSceneMementoRepositoryProvider)
          .read('learner_1'),
    );
    expect(grown.hasNewGrowth, isTrue);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                // Motion off: its 24s repeat would never let the test settle,
                // and the bloom controller is independent of it.
                child: GardenVistaView(
                  spec: grown,
                  enableMotion: false,
                  manageSeenLifecycle: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is GardenBloomPainter,
      ),
      findsOneWidget,
      reason: 'the calm bloom should be painting mid-animation',
    );

    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
    final memento = container
        .read(gardenSceneMementoRepositoryProvider)
        .read('learner_1')!;
    expect(
      memento.variantFor(GardenSceneElementId.olive),
      2,
      reason: 'growth must be acknowledged so it never replays',
    );
    final replay = composer.compose(
      garden: makeGardenState(prayer: 0.6, drops: 120, maturity: 30),
      lastSeen: memento,
    );
    expect(replay.hasNewGrowth, isFalse);
  });

  testWidgets('reduce-motion skips the bloom but still acknowledges growth', (
    tester,
  ) async {
    final container = await makeGardenTestContainer();
    addTearDown(container.dispose);
    container.read(profileSettingsProvider.notifier).setReduceMotion(true);
    final controller = container.read(gardenSceneSeenControllerProvider);

    final before = composer.compose(
      garden: makeGardenState(prayer: 0.1),
      lastSeen: null,
    );
    await controller.ensureBaseline(before, now: DateTime(2026, 8, 29));
    final grown = composer.compose(
      garden: makeGardenState(prayer: 0.6),
      lastSeen: container
          .read(gardenSceneMementoRepositoryProvider)
          .read('learner_1'),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                child: GardenVistaView(spec: grown, manageSeenLifecycle: true),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is GardenBloomPainter,
      ),
      findsNothing,
      reason: 'reduce-motion must skip the bloom entirely',
    );
    expect(
      container
          .read(gardenSceneMementoRepositoryProvider)
          .read('learner_1')!
          .variantFor(GardenSceneElementId.olive),
      2,
    );
  });

  testWidgets('tapping a visible element reports it to the caller', (
    tester,
  ) async {
    final spec = composer.compose(
      garden: makeGardenState(prayer: 0.9, drops: 400, maturity: 60),
      lastSeen: null,
    );
    final tapped = <GardenSceneElementId>[];
    await pumpVista(
      tester,
      vista: GardenVistaView(
        spec: spec,
        onElementTap: (element) => tapped.add(element.id),
      ),
    );
    // The date palm sits on the left; tap inside its layout rect.
    final vista = tester.getRect(find.byType(GardenVistaView));
    final crop = GardenSceneLayout.heroCrop;
    final scale = vista.width / crop.w;
    final placement = GardenSceneLayout.elementPlacements['datePalm']!;
    await tester.tapAt(
      Offset(
        vista.left + (placement.rect.x + placement.rect.w / 2 - crop.x) * scale,
        vista.top + (placement.rect.y + placement.rect.h / 2 - crop.y) * scale,
      ),
    );
    await tester.pump();
    expect(tapped, contains(GardenSceneElementId.datePalm));
  });

  testWidgets('compact card without lifecycle management writes nothing', (
    tester,
  ) async {
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
