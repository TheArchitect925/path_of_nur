import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A soft band of light crossing a surface, drawn at [progress] (0 = off the
/// leading edge, 1 = off the trailing edge). The hero's ambient specular and
/// the one-shot glint share it.
class LightBandPainter extends CustomPainter {
  const LightBandPainter({
    required this.progress,
    required this.color,
    required this.strength,
    this.bandWidth = 0.55,
    super.repaint,
  });

  /// 0..1 across the surface; anything outside paints nothing.
  final double progress;
  final Color color;

  /// Peak alpha of the band.
  final double strength;

  /// Band width as a fraction of the surface width.
  final double bandWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1 || strength <= 0) return;
    final w = size.width;
    final half = w * bandWidth / 2;
    // The band travels from fully off the left to fully off the right.
    final x = ui.lerpDouble(-half, w + half, progress)!;
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(x - half, 0),
        Offset(x + half, size.height * 0.45),
        [
          color.withValues(alpha: 0),
          color.withValues(alpha: strength),
          color.withValues(alpha: 0),
        ],
        const [0.0, 0.5, 1.0],
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(LightBandPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.strength != strength ||
      oldDelegate.bandWidth != bandWidth;
}
