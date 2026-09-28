import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_starter_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_vector_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/widgets/kids_arabic_tracing_pad.dart';

void main() {
  testWidgets('ghost preview appears after idle delay and hides on touch', (
    tester,
  ) async {
    final key = GlobalKey<KidsArabicTracingPadState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: KidsArabicTracingPad(
              key: key,
              letterId: 'alif',
              clearActionLabel: 'Reset',
              traceColorLabel: 'Color',
              readyBadgeLabel: 'Ready',
              colorOptions: const <KidsArabicTracingColorOption>[
                KidsArabicTracingColorOption(
                  id: 'gold',
                  color: Color(0xFFB9864E),
                  label: 'Gold',
                ),
              ],
              onMetricsChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1200));
    expect(key.currentState?.isGhostPreviewVisible, isTrue);

    final traceSurface = find
        .descendant(
          of: find.byType(KidsArabicTracingPad),
          matching: find.byType(GestureDetector),
        )
        .first;
    final paintRect = tester.getRect(traceSurface);
    final gesture = await tester.startGesture(paintRect.center);
    await tester.pump(const Duration(milliseconds: 16));
    expect(key.currentState?.isGhostPreviewVisible, isFalse);
    await gesture.up();
  });

  testWidgets('tracing pad supports color selection tracing and reset', (
    tester,
  ) async {
    final semanticsHandle = tester.ensureSemantics();

    KidsArabicTraceMetrics latestMetrics = const KidsArabicTraceMetrics(
      strokeCount: 0,
      pointCount: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: KidsArabicTracingPad(
              letterId: 'alif',
              clearActionLabel: 'Reset',
              traceColorLabel: 'Color',
              readyBadgeLabel: 'Ready to continue',
              colorOptions: const <KidsArabicTracingColorOption>[
                KidsArabicTracingColorOption(
                  id: 'gold',
                  color: Color(0xFFB9864E),
                  label: 'Gold',
                ),
                KidsArabicTracingColorOption(
                  id: 'mint',
                  color: Color(0xFF6AA97A),
                  label: 'Mint',
                ),
              ],
              onMetricsChanged: (metrics) {
                latestMetrics = metrics;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Gold'), findsOneWidget);
    expect(find.bySemanticsLabel('Mint'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Mint'));
    await tester.pumpAndSettle();

    final traceSurface = find
        .descendant(
          of: find.byType(KidsArabicTracingPad),
          matching: find.byType(GestureDetector),
        )
        .first;
    final paintRect = tester.getRect(traceSurface);
    final localPath = kidsArabicSampledVectorPathPoints(
      kidsArabicVectorTraceLetterFor(
        'alif',
      )!.strokes.first.pathBuilder(paintRect.size),
      sampleSpacing: 6,
    );
    final gesture = await tester.startGesture(
      paintRect.topLeft + localPath.first,
    );
    for (var pass = 0; pass < 2; pass += 1) {
      for (final point in localPath.skip(1)) {
        await gesture.moveTo(paintRect.topLeft + point);
        await tester.pump(const Duration(milliseconds: 16));
      }
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(latestMetrics.pointCount, greaterThan(0));
    expect(latestMetrics.strokeCount, greaterThan(0));

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(latestMetrics.pointCount, 0);
    expect(latestMetrics.strokeCount, 0);

    semanticsHandle.dispose();
  });

  testWidgets('unsupported letters still use the safe fallback guide', (
    tester,
  ) async {
    KidsArabicTraceMetrics latestMetrics = const KidsArabicTraceMetrics(
      strokeCount: 0,
      pointCount: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: KidsArabicTracingPad(
              letterId: 'not-a-letter',
              guide: kidsArabicTracingGuideFor('sheen'),
              clearActionLabel: 'Reset',
              traceColorLabel: 'Color',
              readyBadgeLabel: 'Ready',
              colorOptions: const <KidsArabicTracingColorOption>[
                KidsArabicTracingColorOption(
                  id: 'gold',
                  color: Color(0xFFB9864E),
                  label: 'Gold',
                ),
              ],
              onMetricsChanged: (metrics) {
                latestMetrics = metrics;
              },
            ),
          ),
        ),
      ),
    );

    final traceSurface = find
        .descendant(
          of: find.byType(KidsArabicTracingPad),
          matching: find.byType(GestureDetector),
        )
        .first;
    final paintRect = tester.getRect(traceSurface);
    final guide = kidsArabicTracingGuideFor('sheen')!;
    final baseStroke = guide.strokes.first.points
        .map(
          (point) =>
              Offset(point.dx * paintRect.width, point.dy * paintRect.height),
        )
        .toList(growable: false);
    final gesture = await tester.startGesture(
      paintRect.topLeft + baseStroke.first,
    );
    for (final point in baseStroke.skip(1)) {
      await gesture.moveTo(paintRect.topLeft + point);
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(kidsArabicSupportsVectorTracing('not-a-letter'), isFalse);
    expect(latestMetrics.pointCount, greaterThan(0));
    expect(latestMetrics.strokeCount, 1);
  });

  testWidgets(
    'the pad paints the guide and the child\'s stroke on top of its paper',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepaintBoundary(
              key: boundaryKey,
              child: SizedBox(
                width: 340,
                child: KidsArabicTracingPad(
                  letterId: 'alif',
                  clearActionLabel: 'Reset',
                  traceColorLabel: 'Color',
                  readyBadgeLabel: 'Ready',
                  colorOptions: const <KidsArabicTracingColorOption>[
                    KidsArabicTracingColorOption(
                      id: 'gold',
                      color: Color(0xFFB9864E),
                      label: 'Gold',
                    ),
                  ],
                  onMetricsChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      final pad = find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint &&
            widget.painter != null &&
            widget.painter.runtimeType.toString().contains('TracingPadPainter'),
      );
      expect(pad, findsOneWidget);
      final rect = tester.getRect(pad);

      // One stroke along the bottom edge, well away from the letter body.
      final gesture = await tester.startGesture(
        rect.topLeft + Offset(rect.width * 0.15, rect.height * 0.95),
      );
      await gesture.moveTo(
        rect.topLeft + Offset(rect.width * 0.85, rect.height * 0.95),
      );
      await gesture.up();
      await tester.pump();

      final firstStroke = kidsArabicVectorTraceLetterFor('alif')!.strokes.first;
      final strokeStart = firstStroke
          .pathBuilder(rect.size)
          .computeMetrics()
          .first
          .getTangentForOffset(0)!
          .position;

      await tester.runAsync(() async {
        final boundary =
            boundaryKey.currentContext!.findRenderObject()
                as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final bytes = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        Color pixelAt(Offset local) {
          final x = (rect.left + local.dx).round();
          final y = (rect.top + local.dy).round();
          final i = (y * image.width + x) * 4;
          return Color.fromARGB(
            bytes.getUint8(i + 3),
            bytes.getUint8(i),
            bytes.getUint8(i + 1),
            bytes.getUint8(i + 2),
          );
        }

        expect(
          pixelAt(Offset(rect.width * 0.9, rect.height * 0.1)),
          const Color(0xFFF7EFE2),
          reason: 'the paper the painter lays down',
        );
        expect(
          pixelAt(strokeStart),
          const Color(0xFF9E7448),
          reason: 'the start dot of the first stroke',
        );
        expect(
          pixelAt(Offset(rect.width * 0.25, rect.height * 0.95)),
          const Color(0xFFB9864E),
          reason: 'the child\'s stroke in the selected colour',
        );
      });
    },
  );
}
