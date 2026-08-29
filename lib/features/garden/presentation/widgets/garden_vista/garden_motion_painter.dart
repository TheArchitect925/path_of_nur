import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data/garden_scene_layout.g.dart';
import '../../../domain/garden_scene_models.dart';
import 'garden_ambient_palette.dart';

/// Gentle, deterministic water motion painted above the raster layers:
/// ivory light streaks drifting downstream and a soft pulse on the spring
/// pool. Driven by one repeating animation; never mounted under
/// reduce-motion. Fireflies, birds and fish arrive with later art waves.
class GardenMotionPainter extends CustomPainter {
  GardenMotionPainter({
    required this.animation,
    required this.spec,
    required this.brightness,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final GardenSceneSpec spec;
  final Brightness brightness;

  static const double _designWidth = GardenSceneLayout.canvasWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _designWidth;
    canvas.save();
    canvas.scale(scale);
    final t = animation.value;
    if (spec.water.streamTier <= 1) {
      _paintPondPulse(canvas, t);
    } else {
      _paintStreamStreaks(canvas, t);
    }
    canvas.restore();
  }

  void _paintPondPulse(Canvas canvas, double t) {
    // One slow breath every 8 seconds of the 24s loop.
    final phase = (math.sin(t * 2 * math.pi * 3) + 1) / 2;
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(1350, 1078),
        width: 56 + phase * 14,
        height: 9 + phase * 2,
      ),
      Paint()
        ..color = GardenAmbientPalette.ivory
            .withValues(alpha: 0.10 + phase * 0.12),
    );
  }

  void _paintStreamStreaks(Canvas canvas, double t) {
    final line = GardenSceneLayout.streamCenterline;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const streaks = 4;
    for (var i = 0; i < streaks; i++) {
      // Fractional position drifting downstream, one full run per 12s.
      final position = (t * 2 + i / streaks) % 1.0;
      final scaled = position * (line.length - 1);
      final index = scaled.floor().clamp(0, line.length - 2);
      final f = scaled - index;
      final x = line[index][0] + (line[index + 1][0] - line[index][0]) * f;
      final y = line[index][1] + (line[index + 1][1] - line[index][1]) * f;
      final depth = ((y - GardenSceneLayout.horizonY) /
              (GardenSceneLayout.canvasHeight - GardenSceneLayout.horizonY))
          .clamp(0.0, 1.0);
      // Fade in from the source, out toward the mouth.
      final alpha = 0.22 * math.sin(position * math.pi);
      if (alpha <= 0.01) {
        continue;
      }
      paint
        ..color = GardenAmbientPalette.ivory.withValues(alpha: alpha)
        ..strokeWidth = 2.4 + depth * 3.2;
      final dx = line[index + 1][0] - line[index][0];
      final dy = line[index + 1][1] - line[index][1];
      final length = math.sqrt(dx * dx + dy * dy);
      final ux = dx / length;
      final uy = dy / length;
      final half = 14 + depth * 22;
      final sideOffset = (i.isEven ? -8.0 : 9.0) * (0.3 + depth);
      canvas.drawLine(
        Offset(x - ux * half + sideOffset, y - uy * half),
        Offset(x + ux * half + sideOffset, y + uy * half),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GardenMotionPainter oldDelegate) {
    return oldDelegate.spec.revision != spec.revision ||
        oldDelegate.brightness != brightness;
  }
}
