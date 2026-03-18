import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_starter_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_tracing_engine.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

void main() {
  test('starter tracing guides exist for the five playable starter letters', () {
    for (final id in const ['alif', 'ba', 'meem', 'noon', 'seen']) {
      final guide = kidsArabicTracingGuideFor(id);
      expect(guide, isNotNull);
      expect(guide!.strokes, isNotEmpty);
    }
  });

  test('starter tracing evaluation recognizes meaningful guided progress', () {
    final guide = kidsArabicTracingGuideFor('alif')!;
    final size = const Size(300, 300);
    final baseStroke = guide.strokes.first.points
        .map((point) => Offset(point.dx * size.width, point.dy * size.height))
        .toList(growable: false);
    final stroke = <Offset>[
      ...baseStroke,
      ...baseStroke,
      ...baseStroke,
    ];
    final evaluation = evaluateKidsArabicTrace(
      userStrokes: [stroke],
      size: size,
      guide: guide,
    );

    expect(evaluation.minimumEffortMet, isTrue);
    expect(evaluation.guidedProgress, greaterThan(0.8));
    expect(evaluation.completedStrokeCount, 1);
  });

  test('completion result buckets map correctly for starter tracing', () {
    final guide = kidsArabicTracingGuideFor('seen')!;

    expect(
      scoreKidsArabicTraceWithGuide(
        guide: guide,
        metrics: const KidsArabicTraceMetrics(
          strokeCount: 1,
          pointCount: 16,
          guidedProgress: 0.42,
          alignmentScore: 0.44,
          completedGuideStrokes: 1,
          totalGuideStrokes: 4,
          minimumEffortMet: true,
        ),
      ),
      KidsArabicTraceResult.completed,
    );

    expect(
      scoreKidsArabicTraceWithGuide(
        guide: guide,
        metrics: const KidsArabicTraceMetrics(
          strokeCount: 2,
          pointCount: 34,
          guidedProgress: 0.66,
          alignmentScore: 0.60,
          completedGuideStrokes: 2,
          totalGuideStrokes: 4,
          minimumEffortMet: true,
        ),
      ),
      KidsArabicTraceResult.good,
    );

    expect(
      scoreKidsArabicTraceWithGuide(
        guide: guide,
        metrics: const KidsArabicTraceMetrics(
          strokeCount: 3,
          pointCount: 50,
          guidedProgress: 0.88,
          alignmentScore: 0.80,
          completedGuideStrokes: 4,
          totalGuideStrokes: 4,
          minimumEffortMet: true,
        ),
      ),
      KidsArabicTraceResult.excellent,
    );
  });

  test('reward hook scoring still returns a usable result for starter lessons', () {
    final letter = kidsArabicLetters.firstWhere((item) => item.id == 'ba');
    final result = scoreKidsArabicTrace(
      letter: letter,
      metrics: const KidsArabicTraceMetrics(
        strokeCount: 2,
        pointCount: 30,
        guidedProgress: 0.70,
        alignmentScore: 0.64,
        completedGuideStrokes: 2,
        totalGuideStrokes: 2,
        minimumEffortMet: true,
      ),
    );

    expect(result, KidsArabicTraceResult.good);
  });
}
