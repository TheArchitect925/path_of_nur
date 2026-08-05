import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progression.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_starter_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_tracing_engine.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_vector_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

void main() {
  test('tracing guides exist for every playable Arabic letter', () {
    for (final letter in kidsArabicLetters) {
      final id = letter.id;
      final guide = kidsArabicTracingGuideFor(id);
      expect(guide, isNotNull);
      expect(guide!.strokes, isNotEmpty);
    }
  });

  test('vector tracing templates exist for the expanded release batch', () {
    expect(kidsArabicVectorTraceLetterFor('alif'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('ba'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('ta'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('tha'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('jim'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('ha'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('kha'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('dal'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('dhal'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('ra'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('zay'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('meem'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('noon'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('seen'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('lam'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('kaf'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('ha2'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('sheen'), isNotNull);
    expect(kidsArabicVectorTraceLetterFor('not-a-letter'), isNull);
  });

  test('vector tracing support is centralized by letter id', () {
    expect(kidsArabicSupportsVectorTracing('alif'), isTrue);
    expect(kidsArabicSupportsVectorTracing('ta'), isTrue);
    expect(kidsArabicSupportsVectorTracing('tha'), isTrue);
    expect(kidsArabicSupportsVectorTracing('jim'), isTrue);
    expect(kidsArabicSupportsVectorTracing('ha'), isTrue);
    expect(kidsArabicSupportsVectorTracing('kha'), isTrue);
    expect(kidsArabicSupportsVectorTracing('dal'), isTrue);
    expect(kidsArabicSupportsVectorTracing('dhal'), isTrue);
    expect(kidsArabicSupportsVectorTracing('ra'), isTrue);
    expect(kidsArabicSupportsVectorTracing('zay'), isTrue);
    expect(kidsArabicSupportsVectorTracing('seen'), isTrue);
    expect(kidsArabicSupportsVectorTracing('lam'), isTrue);
    expect(kidsArabicSupportsVectorTracing('kaf'), isTrue);
    expect(kidsArabicSupportsVectorTracing('ha2'), isTrue);
    expect(kidsArabicSupportsVectorTracing('sheen'), isTrue);
    expect(kidsArabicSupportsVectorTracing('sad'), isTrue);
    expect(kidsArabicSupportsVectorTracing('not-a-letter'), isFalse);
  });

  test('every Arabic letter has either vector or fallback tracing support', () {
    for (final letter in kidsArabicLetters) {
      expect(
        kidsArabicSupportsVectorTracing(letter.id) ||
            kidsArabicTracingGuideFor(letter.id) != null,
        isTrue,
        reason: letter.id,
      );
    }
  });

  test('progression order covers the full alphabet without duplicates', () {
    expect(kidsArabicProgressionOrderIds, hasLength(kidsArabicLetters.length));
    expect(
      kidsArabicProgressionOrderIds.toSet(),
      hasLength(kidsArabicLetters.length),
    );
    expect(
      kidsArabicProgressionOrderIds.toSet(),
      equals(kidsArabicLetters.map((letter) => letter.id).toSet()),
    );
  });

  test('starter tracing evaluation recognizes meaningful guided progress', () {
    final guide = kidsArabicTracingGuideFor('alif')!;
    final size = const Size(300, 300);
    final baseStroke = guide.strokes.first.points
        .map((point) => Offset(point.dx * size.width, point.dy * size.height))
        .toList(growable: false);
    final stroke = <Offset>[...baseStroke, ...baseStroke, ...baseStroke];
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

  test('vector tracing evaluation recognizes real path coverage', () {
    final letter = kidsArabicVectorTraceLetterFor('alif')!;
    final size = const Size(300, 300);
    final stroke = kidsArabicSampledVectorPathPoints(
      letter.strokes.first.pathBuilder(size),
      sampleSpacing: 8,
    );
    final evaluation = evaluateKidsArabicVectorTrace(
      userStrokes: <List<Offset>>[stroke],
      size: size,
      letter: letter,
    );

    expect(evaluation.minimumEffortMet, isTrue);
    expect(evaluation.guidedProgress, greaterThan(0.8));
    expect(evaluation.completedStrokeCount, 1);
    expect(evaluation.successPulse, isTrue);
  });

  test('expanded vector letters evaluate meaningful path coverage', () {
    const size = Size(300, 300);
    for (final id in <String>[
      'ta',
      'tha',
      'jim',
      'ha',
      'kha',
      'dal',
      'dhal',
      'ra',
      'zay',
      'noon',
      'seen',
      'lam',
      'kaf',
      'ha2',
    ]) {
      final letter = kidsArabicVectorTraceLetterFor(id)!;
      final strokes = letter.strokes
          .map(
            (stroke) => kidsArabicSampledVectorPathPoints(
              stroke.pathBuilder(size),
              sampleSpacing: 8,
            ),
          )
          .toList(growable: false);
      final evaluation = evaluateKidsArabicVectorTrace(
        userStrokes: strokes,
        size: size,
        letter: letter,
      );

      expect(evaluation.minimumEffortMet, isTrue, reason: id);
      expect(evaluation.guidedProgress, greaterThan(0.74), reason: id);
      expect(
        evaluation.completedStrokeCount,
        letter.strokes.length,
        reason: id,
      );
      expect(evaluation.successPulse, isTrue, reason: id);
    }
  });

  test('vector scoring maps cleanly to result buckets', () {
    final letter = kidsArabicVectorTraceLetterFor('meem')!;

    expect(
      scoreKidsArabicTraceWithVectorLetter(
        letter: letter,
        metrics: const KidsArabicTraceMetrics(
          strokeCount: 1,
          pointCount: 18,
          guidedProgress: 0.44,
          alignmentScore: 0.42,
          completedGuideStrokes: 1,
          totalGuideStrokes: 2,
          minimumEffortMet: true,
        ),
      ),
      KidsArabicTraceResult.completed,
    );

    expect(
      scoreKidsArabicTraceWithVectorLetter(
        letter: letter,
        metrics: const KidsArabicTraceMetrics(
          strokeCount: 2,
          pointCount: 30,
          guidedProgress: 0.72,
          alignmentScore: 0.58,
          completedGuideStrokes: 2,
          totalGuideStrokes: 2,
          minimumEffortMet: true,
        ),
      ),
      KidsArabicTraceResult.good,
    );

    expect(
      scoreKidsArabicTraceWithVectorLetter(
        letter: letter,
        metrics: const KidsArabicTraceMetrics(
          strokeCount: 2,
          pointCount: 42,
          guidedProgress: 0.88,
          alignmentScore: 0.8,
          completedGuideStrokes: 2,
          totalGuideStrokes: 2,
          minimumEffortMet: true,
        ),
      ),
      KidsArabicTraceResult.excellent,
    );
  });

  test('dot guides sample multiple target points for coverage scoring', () {
    final guide = kidsArabicTracingGuideFor('ba')!;
    final dotStroke = guide.strokes.last;
    final sampled = kidsArabicSampledGuidePoints(dotStroke);

    expect(dotStroke.kind, KidsArabicGuideStrokeKind.dot);
    expect(sampled.length, greaterThan(6));
  });

  test(
    'reward hook scoring still returns a usable result for starter lessons',
    () {
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
    },
  );

  test('scoreKidsArabicTrace uses vector tracing for supported letters', () {
    final letter = kidsArabicLetters.firstWhere((item) => item.id == 'noon');
    final result = scoreKidsArabicTrace(
      letter: letter,
      metrics: const KidsArabicTraceMetrics(
        strokeCount: 2,
        pointCount: 30,
        guidedProgress: 0.72,
        alignmentScore: 0.62,
        completedGuideStrokes: 2,
        totalGuideStrokes: 2,
        minimumEffortMet: true,
      ),
    );

    expect(result, KidsArabicTraceResult.good);
  });

  test(
    'scoreKidsArabicTrace still falls back safely for unsupported letters',
    () {
      const letter = KidsArabicLetter(
        id: 'not-a-letter',
        glyph: '؟',
        nameEn: 'Unknown',
        nameAr: 'مجهول',
        transliteration: 'unknown',
        soundHint: 'unknown',
        strokeCount: 2,
        exampleWord: 'unknown',
        exampleWordAr: 'مجهول',
        exampleWordEn: 'unknown',
        childFriendlyLine: 'A letter we have not met yet.',
        rewardXp: 0,
        rewardDrops: 0,
      );
      final result = scoreKidsArabicTrace(
        letter: letter,
        metrics: const KidsArabicTraceMetrics(
          strokeCount: 2,
          pointCount: 140,
          guidedProgress: 0.66,
          alignmentScore: 0.60,
          completedGuideStrokes: 3,
          totalGuideStrokes: 4,
          minimumEffortMet: true,
        ),
      );

      expect(kidsArabicSupportsVectorTracing('not-a-letter'), isFalse);
      expect(result, KidsArabicTraceResult.good);
    },
  );
}
