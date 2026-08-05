import 'package:flutter/material.dart';
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
}
