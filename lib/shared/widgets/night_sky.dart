import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'moon_phase_visual.dart';

/// Shared visual vocabulary for the night themes (Midnight and Candlelight),
/// used by both the app-wide [GlobalBackground] and the reader atmospheres.

const Gradient midnightSkyGradient = RadialGradient(
  center: Alignment(0, -0.85),
  radius: 1.5,
  colors: <Color>[Color(0xFF232A44), Color(0xFF1A1F33), Color(0xFF121423)],
  stops: <double>[0.0, 0.48, 1.0],
);

const Gradient candlelightBaseGradient = RadialGradient(
  center: Alignment(0, -0.55),
  radius: 1.6,
  colors: <Color>[Color(0xFF241C12), Color(0xFF1D1610), Color(0xFF15100B)],
  stops: <double>[0.0, 0.55, 1.0],
);

const Gradient candlelightGlowGradient = RadialGradient(
  center: Alignment(0, -1.2),
  radius: 1.1,
  colors: <Color>[Color(0x4DC48A3A), Colors.transparent],
  stops: <double>[0.0, 0.60],
);

/// A night sky: softly glowing stars kept to the top and bottom bands where
/// no text sits, and a moon whose lit shape tracks the real lunar phase for
/// [now] (waxing lights the right limb, waning the left). Star layout is
/// deterministic (fixed seed) so frames never shimmer.
class MidnightSkyPainter extends CustomPainter {
  MidnightSkyPainter({
    required this.now,
    this.moonFraction = const Offset(0.19, 0.085),
  });

  final DateTime now;

  /// Moon center as a fraction of the canvas. The reader (no chrome in the
  /// top-left) uses the default; app-wide pages put page titles top-left, so
  /// GlobalBackground tucks the moon top-right instead.
  final Offset moonFraction;

  static const Color _starColor = Color(0xFFFFF4D6);
  static const Color _moonLit = Color(0xFFEDE5CE);
  static const Color _moonShadow = Color(0xFF2C3352);

  @override
  void paint(Canvas canvas, Size size) {
    _paintStars(canvas, size);
    _paintMoon(canvas, size);
  }

  void _paintStars(Canvas canvas, Size size) {
    final random = math.Random(19);
    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.4);
    final corePaint = Paint();
    for (var i = 0; i < 34; i++) {
      final x = random.nextDouble() * size.width;
      final inTopBand = random.nextDouble() < 0.72;
      final y = inTopBand
          ? random.nextDouble() * size.height * 0.16
          : size.height * (0.90 + random.nextDouble() * 0.08);
      final radius = 0.5 + random.nextDouble() * 0.7;
      final alpha = 0.18 + random.nextDouble() * 0.5;
      // Every few stars burn a little brighter and carry a wider halo.
      final bright = i % 7 == 0;
      glowPaint.color = _starColor.withValues(
        alpha: alpha * (bright ? 0.55 : 0.38),
      );
      canvas.drawCircle(
        Offset(x, y),
        radius * (bright ? 3.2 : 2.4),
        glowPaint,
      );
      corePaint.color = _starColor.withValues(
        alpha: bright ? (alpha + 0.25).clamp(0.0, 1.0) : alpha,
      );
      canvas.drawCircle(Offset(x, y), radius * (bright ? 1.2 : 1.0), corePaint);
    }
  }

  void _paintMoon(Canvas canvas, Size size) {
    final r = math.min(size.width, size.height) * 0.052;
    final center = Offset(
      size.width * moonFraction.dx,
      size.height * moonFraction.dy,
    );
    final age = moonAgeDays(now);
    final phase = age / lunarSynodicMonthDays;
    final illuminated = moonIlluminatedFraction(now);

    if (illuminated > 0.02) {
      final glow = Paint()
        ..color = _moonLit.withValues(alpha: 0.10 + 0.16 * illuminated)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 1.1);
      canvas.drawCircle(center, r * 1.35, glow);
    }

    // Unlit body, faintly separated from the sky.
    canvas.drawCircle(center, r, Paint()..color = _moonShadow);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _starColor.withValues(alpha: 0.12),
    );

    if (illuminated <= 0.008) return;

    // Lit region: the near limb is a semicircle, the terminator a
    // half-ellipse whose signed half-width follows cos(2π·phase) — full limb
    // at new moon (zero lit area), a straight line at the quarters, and the
    // far limb at full moon. Waxing lights the right side; waning mirrors
    // left.
    final terminator = r * math.cos(2 * math.pi * phase);
    final waxing = phase < 0.5;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (!waxing) canvas.scale(-1, 1);
    final lit = Path()..moveTo(0, -r);
    lit.arcToPoint(
      Offset(0, r),
      radius: Radius.circular(r),
      clockwise: true,
    );
    if (terminator.abs() < r * 0.02) {
      lit.lineTo(0, -r);
    } else {
      final oval = Rect.fromCenter(
        center: Offset.zero,
        width: 2 * terminator.abs(),
        height: 2 * r,
      );
      // Bulge toward the lit limb while a crescent, away from it once
      // gibbous.
      lit.arcTo(oval, math.pi / 2, terminator > 0 ? -math.pi : math.pi, false);
    }
    lit.close();
    canvas.drawPath(
      lit,
      Paint()..color = _moonLit.withValues(alpha: 0.95),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MidnightSkyPainter oldDelegate) {
    final a = oldDelegate.now;
    return a.year != now.year ||
        a.month != now.month ||
        a.day != now.day ||
        oldDelegate.moonFraction != moonFraction;
  }
}

/// The golden mihrab arch that crowns the Jumu'ah (Masjid Emerald) theme:
/// a fine arch outline whose stroke fades toward its base, with a soft gold
/// radiance inside the crown. Pure paint — no assets.
class MihrabArchPainter extends CustomPainter {
  MihrabArchPainter({this.glowColor = const Color(0xFFDCC07A)});

  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final archWidth = size.width * 0.78;
    final left = (size.width - archWidth) / 2;
    final topY = -size.height * 0.03;
    final crownRect = Rect.fromLTWH(left, topY, archWidth, archWidth * 0.92);
    final baseY = size.height * 0.40;

    // Radiance inside the crown.
    final glow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.4),
        radius: 0.9,
        colors: <Color>[
          glowColor.withValues(alpha: 0.16),
          glowColor.withValues(alpha: 0.0),
        ],
      ).createShader(crownRect);
    canvas.drawRect(
      Rect.fromLTRB(left, topY, left + archWidth, baseY),
      glow,
    );

    // Arch outline, fading toward the base.
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          glowColor.withValues(alpha: 0.42),
          glowColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTRB(left, topY, left + archWidth, baseY));
    final path = Path()
      ..moveTo(left, baseY)
      ..lineTo(left, topY + crownRect.height / 2)
      ..arcTo(crownRect, math.pi, math.pi, false)
      ..lineTo(left + archWidth, baseY);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant MihrabArchPainter oldDelegate) =>
      oldDelegate.glowColor != glowColor;
}
