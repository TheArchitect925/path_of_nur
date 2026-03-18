import 'package:flutter/material.dart';

class KidsArabicGuideStroke {
  const KidsArabicGuideStroke({
    required this.points,
    this.completionThreshold = 0.64,
  });

  final List<Offset> points;
  final double completionThreshold;
}

class KidsArabicTracingGuide {
  const KidsArabicTracingGuide({
    required this.letterId,
    required this.strokes,
    this.minimumEffortPoints = 26,
    this.completedThreshold = 0.42,
    this.goodThreshold = 0.66,
    this.excellentThreshold = 0.84,
    this.goodAlignmentThreshold = 0.50,
    this.excellentAlignmentThreshold = 0.72,
    this.proximityThreshold = 0.13,
  });

  final String letterId;
  final List<KidsArabicGuideStroke> strokes;
  final int minimumEffortPoints;
  final double completedThreshold;
  final double goodThreshold;
  final double excellentThreshold;
  final double goodAlignmentThreshold;
  final double excellentAlignmentThreshold;
  final double proximityThreshold;
}

const Map<String, KidsArabicTracingGuide> kidsArabicStarterTracingGuides = {
  'alif': KidsArabicTracingGuide(
    letterId: 'alif',
    minimumEffortPoints: 18,
    completedThreshold: 0.48,
    goodThreshold: 0.72,
    excellentThreshold: 0.88,
    strokes: [
      KidsArabicGuideStroke(
        points: [
          Offset(0.54, 0.18),
          Offset(0.53, 0.28),
          Offset(0.52, 0.40),
          Offset(0.51, 0.54),
          Offset(0.50, 0.70),
          Offset(0.49, 0.84),
        ],
      ),
    ],
  ),
  'ba': KidsArabicTracingGuide(
    letterId: 'ba',
    minimumEffortPoints: 28,
    completedThreshold: 0.40,
    goodThreshold: 0.62,
    excellentThreshold: 0.82,
    strokes: [
      KidsArabicGuideStroke(
        points: [
          Offset(0.74, 0.40),
          Offset(0.66, 0.48),
          Offset(0.56, 0.55),
          Offset(0.44, 0.61),
          Offset(0.32, 0.64),
          Offset(0.22, 0.63),
        ],
      ),
      KidsArabicGuideStroke(
        points: [
          Offset(0.52, 0.75),
          Offset(0.52, 0.75),
        ],
      ),
    ],
  ),
  'meem': KidsArabicTracingGuide(
    letterId: 'meem',
    minimumEffortPoints: 34,
    completedThreshold: 0.38,
    goodThreshold: 0.60,
    excellentThreshold: 0.80,
    strokes: [
      KidsArabicGuideStroke(
        points: [
          Offset(0.72, 0.40),
          Offset(0.61, 0.35),
          Offset(0.47, 0.35),
          Offset(0.37, 0.42),
          Offset(0.36, 0.54),
          Offset(0.44, 0.62),
          Offset(0.58, 0.62),
          Offset(0.68, 0.55),
        ],
      ),
      KidsArabicGuideStroke(
        points: [
          Offset(0.68, 0.55),
          Offset(0.60, 0.60),
          Offset(0.48, 0.66),
          Offset(0.34, 0.70),
          Offset(0.22, 0.69),
        ],
      ),
    ],
  ),
  'noon': KidsArabicTracingGuide(
    letterId: 'noon',
    minimumEffortPoints: 28,
    completedThreshold: 0.40,
    goodThreshold: 0.64,
    excellentThreshold: 0.82,
    strokes: [
      KidsArabicGuideStroke(
        points: [
          Offset(0.72, 0.40),
          Offset(0.63, 0.48),
          Offset(0.53, 0.56),
          Offset(0.42, 0.62),
          Offset(0.30, 0.64),
          Offset(0.22, 0.63),
        ],
      ),
      KidsArabicGuideStroke(
        points: [
          Offset(0.49, 0.28),
          Offset(0.49, 0.28),
        ],
      ),
    ],
  ),
  'seen': KidsArabicTracingGuide(
    letterId: 'seen',
    minimumEffortPoints: 42,
    completedThreshold: 0.36,
    goodThreshold: 0.58,
    excellentThreshold: 0.76,
    strokes: [
      KidsArabicGuideStroke(
        points: [
          Offset(0.76, 0.43),
          Offset(0.68, 0.35),
          Offset(0.60, 0.43),
          Offset(0.52, 0.35),
          Offset(0.44, 0.43),
          Offset(0.36, 0.35),
          Offset(0.28, 0.43),
        ],
      ),
      KidsArabicGuideStroke(
        points: [
          Offset(0.60, 0.23),
          Offset(0.60, 0.23),
        ],
      ),
      KidsArabicGuideStroke(
        points: [
          Offset(0.49, 0.20),
          Offset(0.49, 0.20),
        ],
      ),
      KidsArabicGuideStroke(
        points: [
          Offset(0.38, 0.23),
          Offset(0.38, 0.23),
        ],
      ),
    ],
  ),
};

KidsArabicTracingGuide? kidsArabicTracingGuideFor(String letterId) {
  return kidsArabicStarterTracingGuides[letterId];
}
