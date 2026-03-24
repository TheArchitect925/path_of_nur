import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'kids_arabic_starter_tracing.dart';
import '../domain/kids_arabic_models.dart';

typedef KidsArabicVectorPathBuilder = Path Function(Size size);

class KidsArabicVectorTraceStroke {
  const KidsArabicVectorTraceStroke({
    required this.id,
    required this.pathBuilder,
    this.completionThreshold = 0.68,
  });

  final String id;
  final KidsArabicVectorPathBuilder pathBuilder;
  final double completionThreshold;
}

class KidsArabicVectorTraceLetter {
  const KidsArabicVectorTraceLetter({
    required this.id,
    required this.name,
    required this.outlineBuilder,
    required this.strokes,
    this.minimumEffortPoints = 26,
    this.completedThreshold = 0.48,
    this.goodThreshold = 0.68,
    this.excellentThreshold = 0.84,
    this.goodAlignmentThreshold = 0.52,
    this.excellentAlignmentThreshold = 0.72,
    this.proximityThreshold = 0.11,
  });

  final String id;
  final String name;
  final KidsArabicVectorPathBuilder outlineBuilder;
  final List<KidsArabicVectorTraceStroke> strokes;
  final int minimumEffortPoints;
  final double completedThreshold;
  final double goodThreshold;
  final double excellentThreshold;
  final double goodAlignmentThreshold;
  final double excellentAlignmentThreshold;
  final double proximityThreshold;
}

class KidsArabicVectorTraceEvaluation {
  const KidsArabicVectorTraceEvaluation({
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

KidsArabicVectorTraceLetter _guideBackedVectorLetter({
  required String id,
  required String name,
}) {
  final guide = kidsArabicTracingGuideFor(id)!;
  return KidsArabicVectorTraceLetter(
    id: id,
    name: name,
    minimumEffortPoints: guide.minimumEffortPoints,
    completedThreshold: guide.completedThreshold,
    goodThreshold: guide.goodThreshold,
    excellentThreshold: guide.excellentThreshold,
    goodAlignmentThreshold: guide.goodAlignmentThreshold,
    excellentAlignmentThreshold: guide.excellentAlignmentThreshold,
    proximityThreshold: guide.proximityThreshold,
    outlineBuilder: (size) => _buildGuideOutlinePath(id, size),
    strokes: List<KidsArabicVectorTraceStroke>.generate(
      guide.strokes.length,
      (index) => KidsArabicVectorTraceStroke(
        id: '$id-$index',
        pathBuilder: (size) => _buildGuideStrokePath(id, index, size),
        completionThreshold: guide.strokes[index].completionThreshold,
      ),
      growable: false,
    ),
  );
}

final Map<String, KidsArabicVectorTraceLetter> kidsArabicVectorTraceLetters =
    <String, KidsArabicVectorTraceLetter>{
      'alif': KidsArabicVectorTraceLetter(
        id: 'alif',
        name: 'Alif',
        minimumEffortPoints: 18,
        completedThreshold: 0.52,
        goodThreshold: 0.76,
        excellentThreshold: 0.9,
        outlineBuilder: (size) => _buildAlifBodyPath(size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'alif-body',
            pathBuilder: _buildAlifBodyPath,
            completionThreshold: 0.74,
          ),
        ],
      ),
      'ba': KidsArabicVectorTraceLetter(
        id: 'ba',
        name: 'Ba',
        minimumEffortPoints: 28,
        completedThreshold: 0.48,
        goodThreshold: 0.7,
        excellentThreshold: 0.86,
        outlineBuilder: (size) {
          final path = Path()
            ..addPath(_buildBaBodyPath(size), Offset.zero)
            ..addPath(_buildBaDotPath(size), Offset.zero);
          return path;
        },
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'ba-body',
            pathBuilder: _buildBaBodyPath,
            completionThreshold: 0.7,
          ),
          KidsArabicVectorTraceStroke(
            id: 'ba-dot',
            pathBuilder: _buildBaDotPath,
            completionThreshold: 0.82,
          ),
        ],
      ),
      'ta': KidsArabicVectorTraceLetter(
        id: 'ta',
        name: 'Ta',
        minimumEffortPoints: 30,
        completedThreshold: 0.46,
        goodThreshold: 0.68,
        excellentThreshold: 0.84,
        outlineBuilder: (size) => _buildGuideOutlinePath('ta', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'ta-body',
            pathBuilder: (size) => _buildGuideStrokePath('ta', 0, size),
            completionThreshold: 0.7,
          ),
          KidsArabicVectorTraceStroke(
            id: 'ta-dot-left',
            pathBuilder: (size) => _buildGuideStrokePath('ta', 1, size),
            completionThreshold: 0.8,
          ),
          KidsArabicVectorTraceStroke(
            id: 'ta-dot-right',
            pathBuilder: (size) => _buildGuideStrokePath('ta', 2, size),
            completionThreshold: 0.8,
          ),
        ],
      ),
      'tha': KidsArabicVectorTraceLetter(
        id: 'tha',
        name: 'Tha',
        minimumEffortPoints: 32,
        completedThreshold: 0.46,
        goodThreshold: 0.68,
        excellentThreshold: 0.84,
        outlineBuilder: (size) => _buildGuideOutlinePath('tha', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'tha-body',
            pathBuilder: (size) => _buildGuideStrokePath('tha', 0, size),
            completionThreshold: 0.7,
          ),
          KidsArabicVectorTraceStroke(
            id: 'tha-dot-left',
            pathBuilder: (size) => _buildGuideStrokePath('tha', 1, size),
            completionThreshold: 0.8,
          ),
          KidsArabicVectorTraceStroke(
            id: 'tha-dot-center',
            pathBuilder: (size) => _buildGuideStrokePath('tha', 2, size),
            completionThreshold: 0.8,
          ),
          KidsArabicVectorTraceStroke(
            id: 'tha-dot-right',
            pathBuilder: (size) => _buildGuideStrokePath('tha', 3, size),
            completionThreshold: 0.8,
          ),
        ],
      ),
      'jim': KidsArabicVectorTraceLetter(
        id: 'jim',
        name: 'Jeem',
        minimumEffortPoints: 36,
        completedThreshold: 0.44,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
        outlineBuilder: (size) => _buildGuideOutlinePath('jim', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'jim-body',
            pathBuilder: (size) => _buildGuideStrokePath('jim', 0, size),
            completionThreshold: 0.68,
          ),
          KidsArabicVectorTraceStroke(
            id: 'jim-dot',
            pathBuilder: (size) => _buildGuideStrokePath('jim', 1, size),
            completionThreshold: 0.8,
          ),
        ],
      ),
      'ha': KidsArabicVectorTraceLetter(
        id: 'ha',
        name: 'Hha',
        minimumEffortPoints: 34,
        completedThreshold: 0.44,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
        outlineBuilder: (size) => _buildGuideOutlinePath('ha', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'ha-body',
            pathBuilder: (size) => _buildGuideStrokePath('ha', 0, size),
            completionThreshold: 0.68,
          ),
        ],
      ),
      'kha': KidsArabicVectorTraceLetter(
        id: 'kha',
        name: 'Kha',
        minimumEffortPoints: 36,
        completedThreshold: 0.44,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
        outlineBuilder: (size) => _buildGuideOutlinePath('kha', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'kha-body',
            pathBuilder: (size) => _buildGuideStrokePath('kha', 0, size),
            completionThreshold: 0.68,
          ),
          KidsArabicVectorTraceStroke(
            id: 'kha-dot',
            pathBuilder: (size) => _buildGuideStrokePath('kha', 1, size),
            completionThreshold: 0.8,
          ),
        ],
      ),
      'dal': KidsArabicVectorTraceLetter(
        id: 'dal',
        name: 'Dal',
        minimumEffortPoints: 20,
        completedThreshold: 0.5,
        goodThreshold: 0.74,
        excellentThreshold: 0.88,
        outlineBuilder: (size) => _buildGuideOutlinePath('dal', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'dal-body',
            pathBuilder: (size) => _buildGuideStrokePath('dal', 0, size),
            completionThreshold: 0.72,
          ),
        ],
      ),
      'dhal': KidsArabicVectorTraceLetter(
        id: 'dhal',
        name: 'Dhal',
        minimumEffortPoints: 24,
        completedThreshold: 0.48,
        goodThreshold: 0.72,
        excellentThreshold: 0.88,
        outlineBuilder: (size) => _buildGuideOutlinePath('dhal', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'dhal-body',
            pathBuilder: (size) => _buildGuideStrokePath('dhal', 0, size),
            completionThreshold: 0.72,
          ),
          KidsArabicVectorTraceStroke(
            id: 'dhal-dot',
            pathBuilder: (size) => _buildGuideStrokePath('dhal', 1, size),
            completionThreshold: 0.8,
          ),
        ],
      ),
      'ra': KidsArabicVectorTraceLetter(
        id: 'ra',
        name: 'Ra',
        minimumEffortPoints: 20,
        completedThreshold: 0.5,
        goodThreshold: 0.74,
        excellentThreshold: 0.88,
        outlineBuilder: (size) => _buildGuideOutlinePath('ra', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'ra-body',
            pathBuilder: (size) => _buildGuideStrokePath('ra', 0, size),
            completionThreshold: 0.72,
          ),
        ],
      ),
      'zay': KidsArabicVectorTraceLetter(
        id: 'zay',
        name: 'Zay',
        minimumEffortPoints: 24,
        completedThreshold: 0.48,
        goodThreshold: 0.72,
        excellentThreshold: 0.88,
        outlineBuilder: (size) => _buildGuideOutlinePath('zay', size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'zay-body',
            pathBuilder: (size) => _buildGuideStrokePath('zay', 0, size),
            completionThreshold: 0.72,
          ),
          KidsArabicVectorTraceStroke(
            id: 'zay-dot',
            pathBuilder: (size) => _buildGuideStrokePath('zay', 1, size),
            completionThreshold: 0.8,
          ),
        ],
      ),
      'meem': KidsArabicVectorTraceLetter(
        id: 'meem',
        name: 'Meem',
        minimumEffortPoints: 30,
        completedThreshold: 0.46,
        goodThreshold: 0.68,
        excellentThreshold: 0.84,
        outlineBuilder: (size) {
          final path = Path()
            ..addPath(_buildMeemLoopPath(size), Offset.zero)
            ..addPath(_buildMeemTailPath(size), Offset.zero);
          return path;
        },
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'meem-loop',
            pathBuilder: _buildMeemLoopPath,
            completionThreshold: 0.68,
          ),
          KidsArabicVectorTraceStroke(
            id: 'meem-tail',
            pathBuilder: _buildMeemTailPath,
            completionThreshold: 0.68,
          ),
        ],
      ),
      'noon': KidsArabicVectorTraceLetter(
        id: 'noon',
        name: 'Noon',
        minimumEffortPoints: 28,
        completedThreshold: 0.48,
        goodThreshold: 0.68,
        excellentThreshold: 0.84,
        outlineBuilder: (size) {
          final path = Path()
            ..addPath(_buildNoonBodyPath(size), Offset.zero)
            ..addPath(_buildNoonDotPath(size), Offset.zero);
          return path;
        },
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'noon-body',
            pathBuilder: _buildNoonBodyPath,
            completionThreshold: 0.68,
          ),
          KidsArabicVectorTraceStroke(
            id: 'noon-dot',
            pathBuilder: _buildNoonDotPath,
            completionThreshold: 0.78,
          ),
        ],
      ),
      'seen': KidsArabicVectorTraceLetter(
        id: 'seen',
        name: 'Seen',
        minimumEffortPoints: 38,
        completedThreshold: 0.42,
        goodThreshold: 0.62,
        excellentThreshold: 0.8,
        goodAlignmentThreshold: 0.5,
        excellentAlignmentThreshold: 0.7,
        outlineBuilder: (size) => _buildSeenBodyPath(size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'seen-body',
            pathBuilder: _buildSeenBodyPath,
            completionThreshold: 0.66,
          ),
        ],
      ),
      'sheen': _guideBackedVectorLetter(id: 'sheen', name: 'Sheen'),
      'sad': _guideBackedVectorLetter(id: 'sad', name: 'Sad'),
      'dad': _guideBackedVectorLetter(id: 'dad', name: 'Dad'),
      'taa': _guideBackedVectorLetter(id: 'taa', name: 'Taa'),
      'zaa': _guideBackedVectorLetter(id: 'zaa', name: 'Zaa'),
      'ain': _guideBackedVectorLetter(id: 'ain', name: 'Ain'),
      'ghain': _guideBackedVectorLetter(id: 'ghain', name: 'Ghain'),
      'fa': _guideBackedVectorLetter(id: 'fa', name: 'Fa'),
      'qaf': _guideBackedVectorLetter(id: 'qaf', name: 'Qaf'),
      'lam': KidsArabicVectorTraceLetter(
        id: 'lam',
        name: 'Laam',
        minimumEffortPoints: 20,
        completedThreshold: 0.5,
        goodThreshold: 0.74,
        excellentThreshold: 0.88,
        outlineBuilder: (size) => _buildLamBodyPath(size),
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'lam-body',
            pathBuilder: _buildLamBodyPath,
            completionThreshold: 0.72,
          ),
        ],
      ),
      'kaf': KidsArabicVectorTraceLetter(
        id: 'kaf',
        name: 'Kaaf',
        minimumEffortPoints: 32,
        completedThreshold: 0.46,
        goodThreshold: 0.68,
        excellentThreshold: 0.84,
        outlineBuilder: (size) {
          final path = Path()
            ..addPath(_buildKafStemPath(size), Offset.zero)
            ..addPath(_buildKafArmPath(size), Offset.zero);
          return path;
        },
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'kaf-stem',
            pathBuilder: _buildKafStemPath,
            completionThreshold: 0.66,
          ),
          KidsArabicVectorTraceStroke(
            id: 'kaf-arm',
            pathBuilder: _buildKafArmPath,
            completionThreshold: 0.64,
          ),
        ],
      ),
      'ha2': KidsArabicVectorTraceLetter(
        id: 'ha2',
        name: 'Haa',
        minimumEffortPoints: 34,
        completedThreshold: 0.44,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
        outlineBuilder: (size) {
          final path = Path()
            ..addPath(_buildHaaLoopPath(size), Offset.zero)
            ..addPath(_buildHaaTailPath(size), Offset.zero);
          return path;
        },
        strokes: <KidsArabicVectorTraceStroke>[
          KidsArabicVectorTraceStroke(
            id: 'haa-loop',
            pathBuilder: _buildHaaLoopPath,
            completionThreshold: 0.66,
          ),
          KidsArabicVectorTraceStroke(
            id: 'haa-tail',
            pathBuilder: _buildHaaTailPath,
            completionThreshold: 0.64,
          ),
        ],
      ),
      'waw': _guideBackedVectorLetter(id: 'waw', name: 'Waw'),
      'ya': _guideBackedVectorLetter(id: 'ya', name: 'Ya'),
    };

bool kidsArabicSupportsVectorTracing(String letterId) {
  return kidsArabicVectorTraceLetters.containsKey(letterId);
}

KidsArabicVectorTraceLetter? kidsArabicVectorTraceLetterFor(String letterId) {
  return kidsArabicVectorTraceLetters[letterId];
}

KidsArabicVectorTraceEvaluation evaluateKidsArabicVectorTrace({
  required List<List<Offset>> userStrokes,
  required Size size,
  required KidsArabicVectorTraceLetter letter,
}) {
  final pointCount = userStrokes.fold<int>(
    0,
    (sum, stroke) => sum + stroke.length,
  );
  final allPoints = userStrokes
      .expand((stroke) => stroke)
      .toList(growable: false);
  final threshold =
      math.min(size.width, size.height) * letter.proximityThreshold;
  final strokeProgress = <double>[];
  final strokeAlignment = <double>[];
  var completedStrokeCount = 0;
  var activeStrokeIndex = 0;

  for (var i = 0; i < letter.strokes.length; i += 1) {
    final stroke = letter.strokes[i];
    final sampledPoints = kidsArabicSampledVectorPathPoints(
      stroke.pathBuilder(size),
    );
    var covered = 0;
    var alignmentTotal = 0.0;
    for (final target in sampledPoints) {
      var nearest = double.infinity;
      for (final point in allPoints) {
        final distance = (point - target).distance;
        if (distance < nearest) {
          nearest = distance;
        }
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
      if (activeStrokeIndex == i && i + 1 < letter.strokes.length) {
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
      pointCount >= letter.minimumEffortPoints &&
      guidedProgress >= letter.completedThreshold * 0.55;

  return KidsArabicVectorTraceEvaluation(
    completedStrokeCount: completedStrokeCount,
    totalStrokeCount: letter.strokes.length,
    guidedProgress: guidedProgress,
    alignmentScore: alignmentScore,
    activeStrokeIndex: activeStrokeIndex,
    minimumEffortMet: minimumEffortMet,
    successPulse:
        minimumEffortMet && completedStrokeCount == letter.strokes.length,
  );
}

KidsArabicTraceResult scoreKidsArabicTraceWithVectorLetter({
  required KidsArabicTraceMetrics metrics,
  required KidsArabicVectorTraceLetter letter,
}) {
  if (!metrics.minimumEffortMet) {
    return KidsArabicTraceResult.completed;
  }
  if (metrics.guidedProgress >= letter.excellentThreshold &&
      metrics.alignmentScore >= letter.excellentAlignmentThreshold) {
    return KidsArabicTraceResult.excellent;
  }
  if (metrics.guidedProgress >= letter.goodThreshold &&
      metrics.alignmentScore >= letter.goodAlignmentThreshold) {
    return KidsArabicTraceResult.good;
  }
  return KidsArabicTraceResult.completed;
}

List<Offset> kidsArabicSampledVectorPathPoints(
  Path path, {
  double sampleSpacing = 12,
}) {
  final samples = <Offset>[];
  for (final metric in path.computeMetrics()) {
    final divisions = math.max(1, (metric.length / sampleSpacing).ceil());
    for (var step = 0; step <= divisions; step += 1) {
      final tangent = metric.getTangentForOffset(
        metric.length * (step / divisions),
      );
      if (tangent != null) {
        samples.add(tangent.position);
      }
    }
  }
  return samples;
}

Path _buildGuideOutlinePath(String letterId, Size size) {
  final guide = kidsArabicTracingGuideFor(letterId);
  if (guide == null) {
    return Path();
  }
  final path = Path();
  for (final stroke in guide.strokes) {
    path.addPath(_pathFromGuideStroke(size, stroke), Offset.zero);
  }
  return path;
}

Path _buildGuideStrokePath(String letterId, int strokeIndex, Size size) {
  final guide = kidsArabicTracingGuideFor(letterId);
  if (guide == null || strokeIndex < 0 || strokeIndex >= guide.strokes.length) {
    return Path();
  }
  return _pathFromGuideStroke(size, guide.strokes[strokeIndex]);
}

Path _pathFromGuideStroke(Size size, KidsArabicGuideStroke stroke) {
  switch (stroke.kind) {
    case KidsArabicGuideStrokeKind.path:
      return _pathFromGuidePoints(size, stroke.points);
    case KidsArabicGuideStrokeKind.dot:
      return _buildGuideDotPath(
        size,
        stroke.center!,
        radiusFactor: stroke.dotRadius,
      );
  }
}

Path _pathFromGuidePoints(Size size, List<Offset> points) {
  final scaledPoints = points
      .map((point) => _scaled(size, point.dx, point.dy))
      .toList(growable: false);
  final path = Path();
  if (scaledPoints.isEmpty) {
    return path;
  }
  if (scaledPoints.length == 1) {
    path.addOval(
      Rect.fromCircle(
        center: scaledPoints.first,
        radius: size.shortestSide * 0.01,
      ),
    );
    return path;
  }
  path.moveTo(scaledPoints.first.dx, scaledPoints.first.dy);
  if (scaledPoints.length == 2) {
    path.lineTo(scaledPoints.last.dx, scaledPoints.last.dy);
    return path;
  }
  for (var i = 1; i < scaledPoints.length - 1; i += 1) {
    final current = scaledPoints[i];
    final next = scaledPoints[i + 1];
    final midpoint = Offset(
      (current.dx + next.dx) / 2,
      (current.dy + next.dy) / 2,
    );
    path.quadraticBezierTo(current.dx, current.dy, midpoint.dx, midpoint.dy);
  }
  final penultimate = scaledPoints[scaledPoints.length - 2];
  final last = scaledPoints.last;
  path.quadraticBezierTo(penultimate.dx, penultimate.dy, last.dx, last.dy);
  return path;
}

Path _buildGuideDotPath(
  Size size,
  Offset center, {
  double radiusFactor = 0.034,
}) {
  final path = Path();
  path.addOval(
    Rect.fromCircle(
      center: _scaled(size, center.dx, center.dy),
      radius: size.shortestSide * radiusFactor,
    ),
  );
  return path;
}

Path _buildAlifBodyPath(Size size) {
  final path = Path();
  final start = _scaled(size, 0.60, 0.16);
  final end = _scaled(size, 0.50, 0.86);
  path.moveTo(start.dx, start.dy);
  path.cubicTo(
    size.width * 0.60,
    size.height * 0.28,
    size.width * 0.56,
    size.height * 0.56,
    end.dx,
    end.dy,
  );
  return path;
}

Path _buildBaBodyPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.78, size.height * 0.40);
  path.cubicTo(
    size.width * 0.70,
    size.height * 0.46,
    size.width * 0.61,
    size.height * 0.56,
    size.width * 0.48,
    size.height * 0.62,
  );
  path.cubicTo(
    size.width * 0.38,
    size.height * 0.67,
    size.width * 0.28,
    size.height * 0.68,
    size.width * 0.20,
    size.height * 0.64,
  );
  return path;
}

Path _buildBaDotPath(Size size) {
  final path = Path();
  path.addOval(
    Rect.fromCircle(
      center: _scaled(size, 0.52, 0.79),
      radius: size.shortestSide * 0.04,
    ),
  );
  return path;
}

Path _buildMeemLoopPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.72, size.height * 0.48);
  path.cubicTo(
    size.width * 0.72,
    size.height * 0.30,
    size.width * 0.54,
    size.height * 0.24,
    size.width * 0.40,
    size.height * 0.30,
  );
  path.cubicTo(
    size.width * 0.28,
    size.height * 0.36,
    size.width * 0.24,
    size.height * 0.54,
    size.width * 0.34,
    size.height * 0.66,
  );
  path.cubicTo(
    size.width * 0.44,
    size.height * 0.78,
    size.width * 0.64,
    size.height * 0.72,
    size.width * 0.66,
    size.height * 0.58,
  );
  return path;
}

Path _buildMeemTailPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.58, size.height * 0.60);
  path.quadraticBezierTo(
    size.width * 0.50,
    size.height * 0.70,
    size.width * 0.40,
    size.height * 0.74,
  );
  path.quadraticBezierTo(
    size.width * 0.28,
    size.height * 0.78,
    size.width * 0.18,
    size.height * 0.74,
  );
  return path;
}

Path _buildNoonBodyPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.76, size.height * 0.40);
  path.cubicTo(
    size.width * 0.70,
    size.height * 0.48,
    size.width * 0.58,
    size.height * 0.58,
    size.width * 0.44,
    size.height * 0.64,
  );
  path.cubicTo(
    size.width * 0.34,
    size.height * 0.68,
    size.width * 0.24,
    size.height * 0.68,
    size.width * 0.18,
    size.height * 0.64,
  );
  return path;
}

Path _buildNoonDotPath(Size size) {
  final path = Path();
  path.addOval(
    Rect.fromCircle(
      center: _scaled(size, 0.50, 0.28),
      radius: size.shortestSide * 0.038,
    ),
  );
  return path;
}

Path _buildSeenBodyPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.80, size.height * 0.48);
  path.cubicTo(
    size.width * 0.76,
    size.height * 0.34,
    size.width * 0.66,
    size.height * 0.34,
    size.width * 0.62,
    size.height * 0.46,
  );
  path.cubicTo(
    size.width * 0.58,
    size.height * 0.56,
    size.width * 0.50,
    size.height * 0.56,
    size.width * 0.46,
    size.height * 0.46,
  );
  path.cubicTo(
    size.width * 0.42,
    size.height * 0.34,
    size.width * 0.34,
    size.height * 0.34,
    size.width * 0.30,
    size.height * 0.48,
  );
  path.cubicTo(
    size.width * 0.28,
    size.height * 0.56,
    size.width * 0.24,
    size.height * 0.62,
    size.width * 0.18,
    size.height * 0.68,
  );
  return path;
}

Path _buildLamBodyPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.64, size.height * 0.16);
  path.cubicTo(
    size.width * 0.62,
    size.height * 0.34,
    size.width * 0.58,
    size.height * 0.60,
    size.width * 0.52,
    size.height * 0.84,
  );
  path.quadraticBezierTo(
    size.width * 0.42,
    size.height * 0.88,
    size.width * 0.34,
    size.height * 0.84,
  );
  return path;
}

Path _buildKafStemPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.64, size.height * 0.18);
  path.cubicTo(
    size.width * 0.62,
    size.height * 0.36,
    size.width * 0.58,
    size.height * 0.62,
    size.width * 0.52,
    size.height * 0.84,
  );
  return path;
}

Path _buildKafArmPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.62, size.height * 0.44);
  path.quadraticBezierTo(
    size.width * 0.56,
    size.height * 0.48,
    size.width * 0.50,
    size.height * 0.54,
  );
  path.quadraticBezierTo(
    size.width * 0.44,
    size.height * 0.60,
    size.width * 0.36,
    size.height * 0.62,
  );
  path.moveTo(size.width * 0.54, size.height * 0.34);
  path.quadraticBezierTo(
    size.width * 0.48,
    size.height * 0.30,
    size.width * 0.42,
    size.height * 0.26,
  );
  return path;
}

Path _buildHaaLoopPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.64, size.height * 0.38);
  path.cubicTo(
    size.width * 0.62,
    size.height * 0.28,
    size.width * 0.52,
    size.height * 0.24,
    size.width * 0.42,
    size.height * 0.28,
  );
  path.cubicTo(
    size.width * 0.30,
    size.height * 0.34,
    size.width * 0.28,
    size.height * 0.50,
    size.width * 0.36,
    size.height * 0.60,
  );
  path.cubicTo(
    size.width * 0.44,
    size.height * 0.70,
    size.width * 0.58,
    size.height * 0.70,
    size.width * 0.64,
    size.height * 0.58,
  );
  path.cubicTo(
    size.width * 0.66,
    size.height * 0.52,
    size.width * 0.66,
    size.height * 0.44,
    size.width * 0.64,
    size.height * 0.38,
  );
  return path;
}

Path _buildHaaTailPath(Size size) {
  final path = Path();
  path.moveTo(size.width * 0.54, size.height * 0.60);
  path.quadraticBezierTo(
    size.width * 0.60,
    size.height * 0.68,
    size.width * 0.68,
    size.height * 0.74,
  );
  path.quadraticBezierTo(
    size.width * 0.74,
    size.height * 0.78,
    size.width * 0.80,
    size.height * 0.80,
  );
  return path;
}

Offset _scaled(Size size, double dx, double dy) {
  return Offset(size.width * dx, size.height * dy);
}
