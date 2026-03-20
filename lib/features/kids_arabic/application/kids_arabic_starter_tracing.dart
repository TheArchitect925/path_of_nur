import 'dart:math' as math;

import 'package:flutter/material.dart';

enum KidsArabicGuideStrokeKind { path, dot }

class KidsArabicGuideStroke {
  const KidsArabicGuideStroke.path({
    required this.points,
    this.completionThreshold = 0.64,
  }) : kind = KidsArabicGuideStrokeKind.path,
       dotRadius = 0.0,
       center = null;

  const KidsArabicGuideStroke.dot({
    required this.center,
    this.dotRadius = 0.034,
    this.completionThreshold = 0.82,
  }) : kind = KidsArabicGuideStrokeKind.dot,
       points = const <Offset>[];

  final KidsArabicGuideStrokeKind kind;
  final List<Offset> points;
  final double dotRadius;
  final double completionThreshold;
  final Offset? center;
}

class KidsArabicTracingGuide {
  const KidsArabicTracingGuide({
    required this.letterId,
    required this.strokes,
    this.minimumEffortPoints = 32,
    this.completedThreshold = 0.48,
    this.goodThreshold = 0.68,
    this.excellentThreshold = 0.84,
    this.goodAlignmentThreshold = 0.52,
    this.excellentAlignmentThreshold = 0.72,
    this.proximityThreshold = 0.12,
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

KidsArabicTracingGuide _dotFamilyGuide({
  required String letterId,
  required List<Offset> base,
  required List<Offset> aboveDots,
  required List<Offset> belowDots,
  int minimumEffortPoints = 30,
  double completedThreshold = 0.46,
  double goodThreshold = 0.68,
  double excellentThreshold = 0.84,
  double proximityThreshold = 0.12,
}) {
  return KidsArabicTracingGuide(
    letterId: letterId,
    minimumEffortPoints: minimumEffortPoints,
    completedThreshold: completedThreshold,
    goodThreshold: goodThreshold,
    excellentThreshold: excellentThreshold,
    proximityThreshold: proximityThreshold,
    strokes: <KidsArabicGuideStroke>[
      KidsArabicGuideStroke.path(points: base),
      ...aboveDots.map((center) => KidsArabicGuideStroke.dot(center: center)),
      ...belowDots.map((center) => KidsArabicGuideStroke.dot(center: center)),
    ],
  );
}

KidsArabicTracingGuide _curvedLetterGuide({
  required String letterId,
  required List<KidsArabicGuideStroke> strokes,
  int minimumEffortPoints = 34,
  double completedThreshold = 0.46,
  double goodThreshold = 0.68,
  double excellentThreshold = 0.84,
  double proximityThreshold = 0.12,
}) {
  return KidsArabicTracingGuide(
    letterId: letterId,
    strokes: strokes,
    minimumEffortPoints: minimumEffortPoints,
    completedThreshold: completedThreshold,
    goodThreshold: goodThreshold,
    excellentThreshold: excellentThreshold,
    proximityThreshold: proximityThreshold,
  );
}

final Map<String, KidsArabicTracingGuide> kidsArabicStarterTracingGuides =
    <String, KidsArabicTracingGuide>{
      'alif': _curvedLetterGuide(
        letterId: 'alif',
        minimumEffortPoints: 18,
        completedThreshold: 0.50,
        goodThreshold: 0.74,
        excellentThreshold: 0.88,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.58, 0.16),
              Offset(0.57, 0.28),
              Offset(0.55, 0.42),
              Offset(0.53, 0.58),
              Offset(0.51, 0.74),
              Offset(0.49, 0.86),
            ],
          ),
        ],
      ),
      'ba': _dotFamilyGuide(
        letterId: 'ba',
        base: const <Offset>[
          Offset(0.78, 0.38),
          Offset(0.70, 0.46),
          Offset(0.60, 0.55),
          Offset(0.48, 0.62),
          Offset(0.34, 0.66),
          Offset(0.22, 0.64),
        ],
        aboveDots: const <Offset>[],
        belowDots: const <Offset>[Offset(0.52, 0.78)],
        minimumEffortPoints: 28,
        completedThreshold: 0.42,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
      ),
      'ta': _dotFamilyGuide(
        letterId: 'ta',
        base: const <Offset>[
          Offset(0.78, 0.38),
          Offset(0.70, 0.46),
          Offset(0.60, 0.55),
          Offset(0.48, 0.62),
          Offset(0.34, 0.66),
          Offset(0.22, 0.64),
        ],
        aboveDots: const <Offset>[Offset(0.46, 0.26), Offset(0.58, 0.22)],
        belowDots: const <Offset>[],
      ),
      'tha': _dotFamilyGuide(
        letterId: 'tha',
        base: const <Offset>[
          Offset(0.78, 0.38),
          Offset(0.70, 0.46),
          Offset(0.60, 0.55),
          Offset(0.48, 0.62),
          Offset(0.34, 0.66),
          Offset(0.22, 0.64),
        ],
        aboveDots: const <Offset>[
          Offset(0.40, 0.26),
          Offset(0.52, 0.22),
          Offset(0.64, 0.26),
        ],
        belowDots: const <Offset>[],
      ),
      'jim': _curvedLetterGuide(
        letterId: 'jim',
        minimumEffortPoints: 36,
        completedThreshold: 0.42,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.70, 0.34),
              Offset(0.58, 0.30),
              Offset(0.44, 0.34),
              Offset(0.34, 0.44),
              Offset(0.34, 0.58),
              Offset(0.44, 0.66),
              Offset(0.58, 0.66),
              Offset(0.66, 0.58),
              Offset(0.66, 0.48),
              Offset(0.56, 0.44),
              Offset(0.44, 0.48),
              Offset(0.40, 0.58),
              Offset(0.46, 0.68),
              Offset(0.58, 0.76),
              Offset(0.70, 0.82),
            ],
          ),
          KidsArabicGuideStroke.dot(center: Offset(0.56, 0.84)),
        ],
      ),
      'ha': _curvedLetterGuide(
        letterId: 'ha',
        minimumEffortPoints: 34,
        completedThreshold: 0.42,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.70, 0.34),
              Offset(0.58, 0.30),
              Offset(0.44, 0.34),
              Offset(0.34, 0.44),
              Offset(0.34, 0.58),
              Offset(0.44, 0.66),
              Offset(0.58, 0.66),
              Offset(0.66, 0.58),
              Offset(0.66, 0.48),
              Offset(0.56, 0.44),
              Offset(0.44, 0.48),
              Offset(0.40, 0.58),
              Offset(0.46, 0.68),
              Offset(0.58, 0.76),
              Offset(0.70, 0.82),
            ],
          ),
        ],
      ),
      'kha': _curvedLetterGuide(
        letterId: 'kha',
        minimumEffortPoints: 36,
        completedThreshold: 0.42,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.70, 0.34),
              Offset(0.58, 0.30),
              Offset(0.44, 0.34),
              Offset(0.34, 0.44),
              Offset(0.34, 0.58),
              Offset(0.44, 0.66),
              Offset(0.58, 0.66),
              Offset(0.66, 0.58),
              Offset(0.66, 0.48),
              Offset(0.56, 0.44),
              Offset(0.44, 0.48),
              Offset(0.40, 0.58),
              Offset(0.46, 0.68),
              Offset(0.58, 0.76),
              Offset(0.70, 0.82),
            ],
          ),
          KidsArabicGuideStroke.dot(center: Offset(0.56, 0.20)),
        ],
      ),
      'dal': _curvedLetterGuide(
        letterId: 'dal',
        minimumEffortPoints: 20,
        completedThreshold: 0.48,
        goodThreshold: 0.72,
        excellentThreshold: 0.88,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.68, 0.30),
              Offset(0.62, 0.40),
              Offset(0.54, 0.50),
              Offset(0.44, 0.58),
              Offset(0.32, 0.64),
              Offset(0.22, 0.68),
            ],
          ),
        ],
      ),
      'dhal': _curvedLetterGuide(
        letterId: 'dhal',
        minimumEffortPoints: 24,
        completedThreshold: 0.48,
        goodThreshold: 0.72,
        excellentThreshold: 0.88,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.68, 0.30),
              Offset(0.62, 0.40),
              Offset(0.54, 0.50),
              Offset(0.44, 0.58),
              Offset(0.32, 0.64),
              Offset(0.22, 0.68),
            ],
          ),
          KidsArabicGuideStroke.dot(center: Offset(0.52, 0.20)),
        ],
      ),
      'ra': _curvedLetterGuide(
        letterId: 'ra',
        minimumEffortPoints: 20,
        completedThreshold: 0.48,
        goodThreshold: 0.72,
        excellentThreshold: 0.88,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.68, 0.34),
              Offset(0.60, 0.46),
              Offset(0.50, 0.58),
              Offset(0.38, 0.68),
              Offset(0.26, 0.74),
            ],
          ),
        ],
      ),
      'zay': _curvedLetterGuide(
        letterId: 'zay',
        minimumEffortPoints: 24,
        completedThreshold: 0.48,
        goodThreshold: 0.72,
        excellentThreshold: 0.88,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.68, 0.34),
              Offset(0.60, 0.46),
              Offset(0.50, 0.58),
              Offset(0.38, 0.68),
              Offset(0.26, 0.74),
            ],
          ),
          KidsArabicGuideStroke.dot(center: Offset(0.52, 0.20)),
        ],
      ),
      'seen': _curvedLetterGuide(
        letterId: 'seen',
        minimumEffortPoints: 42,
        completedThreshold: 0.38,
        goodThreshold: 0.60,
        excellentThreshold: 0.78,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.78, 0.44),
              Offset(0.70, 0.36),
              Offset(0.62, 0.44),
              Offset(0.54, 0.36),
              Offset(0.46, 0.44),
              Offset(0.38, 0.36),
              Offset(0.30, 0.44),
              Offset(0.22, 0.54),
            ],
          ),
        ],
      ),
      'sheen': _curvedLetterGuide(
        letterId: 'sheen',
        minimumEffortPoints: 46,
        completedThreshold: 0.38,
        goodThreshold: 0.60,
        excellentThreshold: 0.78,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.78, 0.44),
              Offset(0.70, 0.36),
              Offset(0.62, 0.44),
              Offset(0.54, 0.36),
              Offset(0.46, 0.44),
              Offset(0.38, 0.36),
              Offset(0.30, 0.44),
              Offset(0.22, 0.54),
            ],
          ),
          KidsArabicGuideStroke.dot(center: Offset(0.40, 0.24)),
          KidsArabicGuideStroke.dot(center: Offset(0.52, 0.20)),
          KidsArabicGuideStroke.dot(center: Offset(0.64, 0.24)),
        ],
      ),
      'sad': _curvedLetterGuide(
        letterId: 'sad',
        minimumEffortPoints: 36,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.76, 0.36),
              Offset(0.64, 0.36),
              Offset(0.54, 0.44),
              Offset(0.48, 0.56),
              Offset(0.52, 0.66),
              Offset(0.64, 0.70),
              Offset(0.76, 0.66),
              Offset(0.80, 0.56),
              Offset(0.76, 0.46),
              Offset(0.66, 0.44),
              Offset(0.56, 0.52),
              Offset(0.50, 0.64),
              Offset(0.40, 0.72),
              Offset(0.28, 0.74),
              Offset(0.20, 0.72),
            ],
          ),
        ],
      ),
      'dad': _curvedLetterGuide(
        letterId: 'dad',
        minimumEffortPoints: 40,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.76, 0.36),
              Offset(0.64, 0.36),
              Offset(0.54, 0.44),
              Offset(0.48, 0.56),
              Offset(0.52, 0.66),
              Offset(0.64, 0.70),
              Offset(0.76, 0.66),
              Offset(0.80, 0.56),
              Offset(0.76, 0.46),
              Offset(0.66, 0.44),
              Offset(0.56, 0.52),
              Offset(0.50, 0.64),
              Offset(0.40, 0.72),
              Offset(0.28, 0.74),
              Offset(0.20, 0.72),
            ],
          ),
          KidsArabicGuideStroke.dot(center: Offset(0.54, 0.22)),
        ],
      ),
      'taa': _curvedLetterGuide(
        letterId: 'taa',
        minimumEffortPoints: 34,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.62, 0.16),
              Offset(0.60, 0.28),
              Offset(0.58, 0.40),
              Offset(0.54, 0.52),
              Offset(0.48, 0.62),
              Offset(0.52, 0.70),
              Offset(0.64, 0.72),
              Offset(0.76, 0.68),
              Offset(0.80, 0.58),
              Offset(0.74, 0.48),
              Offset(0.62, 0.46),
              Offset(0.52, 0.54),
              Offset(0.44, 0.66),
              Offset(0.32, 0.74),
              Offset(0.20, 0.74),
            ],
          ),
        ],
      ),
      'zaa': _curvedLetterGuide(
        letterId: 'zaa',
        minimumEffortPoints: 38,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.62, 0.16),
              Offset(0.60, 0.28),
              Offset(0.58, 0.40),
              Offset(0.54, 0.52),
              Offset(0.48, 0.62),
              Offset(0.52, 0.70),
              Offset(0.64, 0.72),
              Offset(0.76, 0.68),
              Offset(0.80, 0.58),
              Offset(0.74, 0.48),
              Offset(0.62, 0.46),
              Offset(0.52, 0.54),
              Offset(0.44, 0.66),
              Offset(0.32, 0.74),
              Offset(0.20, 0.74),
            ],
          ),
          KidsArabicGuideStroke.dot(center: Offset(0.52, 0.18)),
        ],
      ),
      'ain': _curvedLetterGuide(
        letterId: 'ain',
        minimumEffortPoints: 38,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.72, 0.34),
              Offset(0.62, 0.40),
              Offset(0.54, 0.50),
              Offset(0.54, 0.60),
              Offset(0.64, 0.66),
              Offset(0.74, 0.62),
              Offset(0.70, 0.52),
              Offset(0.58, 0.52),
              Offset(0.46, 0.60),
              Offset(0.34, 0.70),
              Offset(0.22, 0.76),
            ],
          ),
        ],
      ),
      'ghain': _curvedLetterGuide(
        letterId: 'ghain',
        minimumEffortPoints: 42,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.72, 0.34),
              Offset(0.62, 0.40),
              Offset(0.54, 0.50),
              Offset(0.54, 0.60),
              Offset(0.64, 0.66),
              Offset(0.74, 0.62),
              Offset(0.70, 0.52),
              Offset(0.58, 0.52),
              Offset(0.46, 0.60),
              Offset(0.34, 0.70),
              Offset(0.22, 0.76),
            ],
          ),
          KidsArabicGuideStroke.dot(center: Offset(0.54, 0.20)),
        ],
      ),
      'fa': _dotFamilyGuide(
        letterId: 'fa',
        base: const <Offset>[
          Offset(0.74, 0.36),
          Offset(0.64, 0.36),
          Offset(0.56, 0.44),
          Offset(0.56, 0.54),
          Offset(0.66, 0.60),
          Offset(0.76, 0.56),
          Offset(0.74, 0.48),
          Offset(0.64, 0.48),
          Offset(0.54, 0.56),
          Offset(0.42, 0.66),
          Offset(0.28, 0.72),
          Offset(0.18, 0.72),
        ],
        aboveDots: const <Offset>[Offset(0.56, 0.22)],
        belowDots: const <Offset>[],
        minimumEffortPoints: 34,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
      ),
      'qaf': _dotFamilyGuide(
        letterId: 'qaf',
        base: const <Offset>[
          Offset(0.74, 0.36),
          Offset(0.64, 0.36),
          Offset(0.56, 0.44),
          Offset(0.56, 0.54),
          Offset(0.66, 0.60),
          Offset(0.76, 0.56),
          Offset(0.74, 0.48),
          Offset(0.64, 0.48),
          Offset(0.54, 0.56),
          Offset(0.42, 0.66),
          Offset(0.28, 0.72),
          Offset(0.18, 0.72),
        ],
        aboveDots: const <Offset>[Offset(0.50, 0.24), Offset(0.62, 0.20)],
        belowDots: const <Offset>[],
        minimumEffortPoints: 38,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
      ),
      'kaf': _curvedLetterGuide(
        letterId: 'kaf',
        minimumEffortPoints: 30,
        completedThreshold: 0.46,
        goodThreshold: 0.68,
        excellentThreshold: 0.84,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.62, 0.16),
              Offset(0.60, 0.32),
              Offset(0.58, 0.48),
              Offset(0.56, 0.66),
              Offset(0.52, 0.84),
            ],
          ),
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.70, 0.44),
              Offset(0.56, 0.52),
              Offset(0.68, 0.60),
            ],
            completionThreshold: 0.58,
          ),
        ],
      ),
      'lam': _curvedLetterGuide(
        letterId: 'lam',
        minimumEffortPoints: 20,
        completedThreshold: 0.50,
        goodThreshold: 0.74,
        excellentThreshold: 0.88,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.60, 0.16),
              Offset(0.59, 0.30),
              Offset(0.57, 0.46),
              Offset(0.55, 0.62),
              Offset(0.53, 0.76),
              Offset(0.44, 0.86),
            ],
          ),
        ],
      ),
      'meem': _curvedLetterGuide(
        letterId: 'meem',
        minimumEffortPoints: 34,
        completedThreshold: 0.40,
        goodThreshold: 0.62,
        excellentThreshold: 0.82,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
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
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.68, 0.55),
              Offset(0.60, 0.60),
              Offset(0.48, 0.66),
              Offset(0.34, 0.70),
              Offset(0.22, 0.69),
            ],
          ),
        ],
      ),
      'noon': _dotFamilyGuide(
        letterId: 'noon',
        base: const <Offset>[
          Offset(0.74, 0.40),
          Offset(0.66, 0.48),
          Offset(0.56, 0.55),
          Offset(0.44, 0.61),
          Offset(0.32, 0.64),
          Offset(0.22, 0.63),
        ],
        aboveDots: const <Offset>[Offset(0.49, 0.28)],
        belowDots: const <Offset>[],
        minimumEffortPoints: 28,
        completedThreshold: 0.40,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
      ),
      'ha2': _curvedLetterGuide(
        letterId: 'ha2',
        minimumEffortPoints: 34,
        completedThreshold: 0.42,
        goodThreshold: 0.66,
        excellentThreshold: 0.84,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.64, 0.34),
              Offset(0.54, 0.30),
              Offset(0.42, 0.34),
              Offset(0.34, 0.44),
              Offset(0.34, 0.58),
              Offset(0.44, 0.66),
              Offset(0.56, 0.66),
              Offset(0.64, 0.58),
              Offset(0.64, 0.46),
              Offset(0.56, 0.40),
              Offset(0.46, 0.44),
              Offset(0.42, 0.54),
              Offset(0.48, 0.62),
              Offset(0.60, 0.72),
              Offset(0.70, 0.78),
            ],
          ),
        ],
      ),
      'waw': _curvedLetterGuide(
        letterId: 'waw',
        minimumEffortPoints: 24,
        completedThreshold: 0.46,
        goodThreshold: 0.70,
        excellentThreshold: 0.86,
        strokes: const <KidsArabicGuideStroke>[
          KidsArabicGuideStroke.path(
            points: <Offset>[
              Offset(0.62, 0.28),
              Offset(0.54, 0.30),
              Offset(0.48, 0.38),
              Offset(0.48, 0.48),
              Offset(0.56, 0.56),
              Offset(0.64, 0.54),
              Offset(0.68, 0.46),
              Offset(0.64, 0.38),
              Offset(0.56, 0.46),
              Offset(0.56, 0.60),
              Offset(0.64, 0.72),
              Offset(0.74, 0.80),
            ],
          ),
        ],
      ),
      'ya': _dotFamilyGuide(
        letterId: 'ya',
        base: const <Offset>[
          Offset(0.76, 0.40),
          Offset(0.66, 0.48),
          Offset(0.54, 0.56),
          Offset(0.40, 0.64),
          Offset(0.30, 0.72),
          Offset(0.22, 0.80),
        ],
        aboveDots: const <Offset>[],
        belowDots: const <Offset>[Offset(0.42, 0.78), Offset(0.54, 0.82)],
        minimumEffortPoints: 34,
        completedThreshold: 0.42,
        goodThreshold: 0.64,
        excellentThreshold: 0.82,
      ),
    };

List<Offset> kidsArabicSampledGuidePoints(KidsArabicGuideStroke stroke) {
  switch (stroke.kind) {
    case KidsArabicGuideStrokeKind.dot:
      final center = stroke.center!;
      final samples = <Offset>[center];
      for (var i = 0; i < 10; i += 1) {
        final angle = (math.pi * 2 * i) / 10;
        samples.add(
          Offset(
            center.dx + math.cos(angle) * stroke.dotRadius,
            center.dy + math.sin(angle) * stroke.dotRadius,
          ),
        );
      }
      return samples;
    case KidsArabicGuideStrokeKind.path:
      if (stroke.points.length <= 1) return stroke.points;
      final samples = <Offset>[stroke.points.first];
      for (var i = 0; i < stroke.points.length - 1; i += 1) {
        final from = stroke.points[i];
        final to = stroke.points[i + 1];
        final distance = (to - from).distance;
        final divisions = math.max(1, (distance / 0.035).round());
        for (var step = 1; step <= divisions; step += 1) {
          final t = step / divisions;
          samples.add(Offset.lerp(from, to, t)!);
        }
      }
      return samples;
  }
}

Path kidsArabicGuideStrokePath(KidsArabicGuideStroke stroke, Size size) {
  final path = Path();
  switch (stroke.kind) {
    case KidsArabicGuideStrokeKind.dot:
      final center = Offset(
        stroke.center!.dx * size.width,
        stroke.center!.dy * size.height,
      );
      final radius = stroke.dotRadius * math.min(size.width, size.height);
      path.addOval(Rect.fromCircle(center: center, radius: radius));
      return path;
    case KidsArabicGuideStrokeKind.path:
      if (stroke.points.isEmpty) return path;
      final scaled = stroke.points
          .map((point) => Offset(point.dx * size.width, point.dy * size.height))
          .toList(growable: false);
      if (scaled.length == 1) {
        path.addOval(Rect.fromCircle(center: scaled.first, radius: 4));
        return path;
      }
      path.moveTo(scaled.first.dx, scaled.first.dy);
      if (scaled.length == 2) {
        path.lineTo(scaled.last.dx, scaled.last.dy);
        return path;
      }
      for (var i = 1; i < scaled.length - 1; i += 1) {
        final current = scaled[i];
        final next = scaled[i + 1];
        final control = current;
        final midPoint = Offset(
          (current.dx + next.dx) / 2,
          (current.dy + next.dy) / 2,
        );
        path.quadraticBezierTo(control.dx, control.dy, midPoint.dx, midPoint.dy);
      }
      path.lineTo(scaled.last.dx, scaled.last.dy);
      return path;
  }
}

KidsArabicTracingGuide? kidsArabicTracingGuideFor(String letterId) {
  return kidsArabicStarterTracingGuides[letterId];
}
