import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/kids_arabic_models.dart';
import 'kids_arabic_starter_tracing.dart';

class KidsArabicTraceEvaluation {
  const KidsArabicTraceEvaluation({
    required this.completedStrokeCount,
    required this.totalStrokeCount,
    required this.guidedProgress,
    required this.alignmentScore,
    required this.activeStrokeIndex,
    required this.minimumEffortMet,
    required this.successPulse,
  });

  final int completedStrokeCount;
  final int totalStrokeCount;
  final double guidedProgress;
  final double alignmentScore;
  final int activeStrokeIndex;
  final bool minimumEffortMet;
  final bool successPulse;
}

KidsArabicTraceEvaluation evaluateKidsArabicTrace({
  required List<List<Offset>> userStrokes,
  required Size size,
  required KidsArabicTracingGuide? guide,
}) {
  final pointCount = userStrokes.fold<int>(
    0,
    (sum, stroke) => sum + stroke.length,
  );
  if (guide == null) {
    final minimumEffortMet = pointCount >= 30 && userStrokes.isNotEmpty;
    return KidsArabicTraceEvaluation(
      completedStrokeCount: minimumEffortMet ? 1 : 0,
      totalStrokeCount: 1,
      guidedProgress: minimumEffortMet ? 1 : math.min(1, pointCount / 30),
      alignmentScore: minimumEffortMet ? 0.7 : 0.0,
      activeStrokeIndex: minimumEffortMet ? 0 : 0,
      minimumEffortMet: minimumEffortMet,
      successPulse: minimumEffortMet,
    );
  }

  final allPoints = userStrokes
      .expand((stroke) => stroke)
      .toList(growable: false);
  final threshold =
      math.min(size.width, size.height) * guide.proximityThreshold;
  final strokeProgress = <double>[];
  final strokeAlignment = <double>[];
  var completedStrokeCount = 0;
  var activeStrokeIndex = 0;

  for (var i = 0; i < guide.strokes.length; i += 1) {
    final stroke = guide.strokes[i];
    final sampledPoints = kidsArabicSampledGuidePoints(stroke);
    var covered = 0;
    var alignmentTotal = 0.0;
    for (final normalized in sampledPoints) {
      final target = Offset(
        normalized.dx * size.width,
        normalized.dy * size.height,
      );
      var nearest = double.infinity;
      for (final point in allPoints) {
        final distance = (point - target).distance;
        if (distance < nearest) nearest = distance;
      }
      if (nearest <= threshold) {
        covered += 1;
      }
      if (nearest.isFinite) {
        alignmentTotal += (1 - (nearest / threshold)).clamp(0.0, 1.0);
      }
    }
    final progress = sampledPoints.isEmpty
        ? 0.0
        : covered / sampledPoints.length;
    final alignment = sampledPoints.isEmpty
        ? 0.0
        : alignmentTotal / sampledPoints.length;
    strokeProgress.add(progress.clamp(0.0, 1.0));
    strokeAlignment.add(alignment.clamp(0.0, 1.0));
    if (progress >= stroke.completionThreshold) {
      completedStrokeCount += 1;
      if (activeStrokeIndex == i && i + 1 < guide.strokes.length) {
        activeStrokeIndex = i + 1;
      }
    }
  }

  final guidedProgress = strokeProgress.isEmpty
      ? 0.0
      : strokeProgress.reduce((a, b) => a + b) / strokeProgress.length;
  final alignmentScore = strokeAlignment.isEmpty
      ? 0.0
      : strokeAlignment.reduce((a, b) => a + b) / strokeAlignment.length;
  final minimumEffortMet =
      pointCount >= guide.minimumEffortPoints &&
      guidedProgress >= guide.completedThreshold * 0.55;

  return KidsArabicTraceEvaluation(
    completedStrokeCount: completedStrokeCount,
    totalStrokeCount: guide.strokes.length,
    guidedProgress: guidedProgress,
    alignmentScore: alignmentScore,
    activeStrokeIndex: activeStrokeIndex,
    minimumEffortMet: minimumEffortMet,
    successPulse:
        minimumEffortMet && completedStrokeCount == guide.strokes.length,
  );
}

KidsArabicTraceResult scoreKidsArabicTraceWithGuide({
  required KidsArabicTraceMetrics metrics,
  required KidsArabicTracingGuide? guide,
}) {
  if (!metrics.minimumEffortMet) {
    return KidsArabicTraceResult.completed;
  }
  if (guide == null) {
    if (metrics.pointCount >= 220 &&
        metrics.strokeCount >= metrics.totalGuideStrokes) {
      return KidsArabicTraceResult.excellent;
    }
    if (metrics.pointCount >= 120) {
      return KidsArabicTraceResult.good;
    }
    return KidsArabicTraceResult.completed;
  }
  if (metrics.guidedProgress >= guide.excellentThreshold &&
      metrics.alignmentScore >= guide.excellentAlignmentThreshold) {
    return KidsArabicTraceResult.excellent;
  }
  if (metrics.guidedProgress >= guide.goodThreshold &&
      metrics.alignmentScore >= guide.goodAlignmentThreshold) {
    return KidsArabicTraceResult.good;
  }
  return KidsArabicTraceResult.completed;
}
