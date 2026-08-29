import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../data/garden_scene_layout.g.dart';
import 'garden_ambient_palette.dart';

/// The calm stage-refresh moment: where something new has appeared, a soft
/// ivory light swells and settles, and a few gold motes drift up and fade.
/// No confetti, no burst, no sound — the garden simply catches the light for
/// a moment. Skipped entirely under reduce-motion.
class GardenBloomPainter extends CustomPainter {
  GardenBloomPainter({
    required this.animation,
    required this.anchors,
  }) : super(repaint: animation);

  final Animation<double> animation;

  /// Design-space points where new growth appeared.
  final List<Offset> anchors;

  static const double _designWidth = GardenSceneLayout.canvasWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (anchors.isEmpty) {
      return;
    }
    final t = animation.value;
    final scale = size.width / _designWidth;
    canvas.save();
    canvas.scale(scale);
    for (var i = 0; i < anchors.length; i++) {
      _paintAnchor(canvas, anchors[i], t, i);
    }
    canvas.restore();
  }

  void _paintAnchor(Canvas canvas, Offset anchor, double t, int index) {
    // Light: swells over the first quarter, fully gone by three quarters.
    final lightPhase = _curve(t, 0.0, 0.25, 0.75);
    if (lightPhase > 0) {
      final radius = 150 + lightPhase * 90;
      canvas.drawCircle(
        anchor,
        radius,
        Paint()
          ..shader = ui.Gradient.radial(anchor, radius, [
            GardenAmbientPalette.ivory.withValues(alpha: 0.22 * lightPhase),
            GardenAmbientPalette.ivory.withValues(alpha: 0),
          ]),
      );
    }
    // Motes: rise through the second half and fade out at the end.
    final motePhase = _curve(t, 0.5, 0.7, 1.0);
    if (motePhase <= 0) {
      return;
    }
    final rise = (t - 0.5).clamp(0.0, 0.5) / 0.5;
    for (var i = 0; i < 3; i++) {
      final drift = math.sin((rise + i * 0.33) * math.pi * 2) * 9;
      final centre = Offset(
        anchor.dx + drift + (i - 1) * 15,
        anchor.dy - 18 - rise * 42 - i * 7,
      );
      canvas.drawCircle(
        centre,
        3.6,
        Paint()
          ..color = GardenAmbientPalette.gold
              .withValues(alpha: 0.75 * motePhase)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.4),
      );
    }
  }

  /// Ramps 0->1 between [start] and [peak], holds, then eases back to 0 by
  /// [end]. Returns 0 outside the window.
  double _curve(double t, double start, double peak, double end) {
    if (t <= start || t >= end) {
      return 0;
    }
    if (t < peak) {
      return Curves.easeOutCubic.transform((t - start) / (peak - start));
    }
    return Curves.easeInCubic.transform(1 - (t - peak) / (end - peak));
  }

  @override
  bool shouldRepaint(GardenBloomPainter oldDelegate) {
    return oldDelegate.anchors != anchors;
  }
}
