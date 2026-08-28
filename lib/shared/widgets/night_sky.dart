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
    this.moonShadowColor = const Color(0xFF2C3352),
  });

  final DateTime now;

  /// Moon center as a fraction of the canvas. The reader (no chrome in the
  /// top-left) uses the default; app-wide pages put page titles top-left, so
  /// GlobalBackground tucks the moon top-right instead.
  final Offset moonFraction;

  /// Unlit-limb color; overridable so violet skies (Ramadan) can match.
  final Color moonShadowColor;

  static const Color _starColor = Color(0xFFFFF4D6);
  static const Color _moonLit = Color(0xFFEDE5CE);

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
      canvas.drawCircle(Offset(x, y), radius * (bright ? 3.2 : 2.4), glowPaint);
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
    canvas.drawCircle(center, r, Paint()..color = moonShadowColor);
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
    lit.arcToPoint(Offset(0, r), radius: Radius.circular(r), clockwise: true);
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
    canvas.drawPath(lit, Paint()..color = _moonLit.withValues(alpha: 0.95));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MidnightSkyPainter oldDelegate) {
    final a = oldDelegate.now;
    return a.year != now.year ||
        a.month != now.month ||
        a.day != now.day ||
        oldDelegate.moonFraction != moonFraction ||
        oldDelegate.moonShadowColor != moonShadowColor;
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
    canvas.drawRect(Rect.fromLTRB(left, topY, left + archWidth, baseY), glow);

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

/// The Ramadan fanoos: a small lantern hanging from the top of the screen,
/// its glow warming as iftar draws near. Pure paint — no assets.
class FanoosLanternPainter extends CustomPainter {
  FanoosLanternPainter({
    required this.glowStrength,
    this.lanternFraction = const Offset(0.88, 0.0),
  });

  /// 0..1 — how strongly the lantern glows (rises toward iftar).
  final double glowStrength;

  /// Horizontal position of the lantern as a fraction of the width; it
  /// always hangs from the top edge.
  final Offset lanternFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * lanternFraction.dx;
    final unit = size.width * 0.055;
    // Long enough that the lantern body hangs below the status-bar clock.
    final cordEnd = size.height * 0.052;
    final bodyTop = cordEnd + unit * 0.16;
    final bodyRect = Rect.fromCenter(
      center: Offset(x, bodyTop + unit * 0.62),
      width: unit * 0.78,
      height: unit * 1.24,
    );

    // Glow — scales with iftar proximity.
    final glowAlpha = 0.18 + 0.30 * glowStrength.clamp(0.0, 1.0);
    canvas.drawCircle(
      bodyRect.center,
      unit * (1.4 + glowStrength * 0.7),
      Paint()
        ..color = const Color(0xFFE9BE7B).withValues(alpha: glowAlpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, unit * 0.9),
    );

    // Cord.
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, cordEnd),
      Paint()
        ..color = const Color(0xFFF0E9DA).withValues(alpha: 0.38)
        ..strokeWidth = 1.2,
    );

    // Cap.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, cordEnd + unit * 0.08),
          width: unit * 0.42,
          height: unit * 0.16,
        ),
        Radius.circular(unit * 0.06),
      ),
      Paint()..color = const Color(0xFF8E6A34),
    );

    // Body.
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(unit * 0.24)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFE9BE7B),
            Color(0xFFD9A254),
            Color(0xFFB97F35),
          ],
        ).createShader(bodyRect),
    );

    // Inner flame panel.
    final flameRect = bodyRect.deflate(unit * 0.14);
    canvas.drawRRect(
      RRect.fromRectAndRadius(flameRect, Radius.circular(unit * 0.12)),
      Paint()
        ..color = const Color(
          0xFFFFECBE,
        ).withValues(alpha: 0.72 + 0.24 * glowStrength.clamp(0.0, 1.0)),
    );
  }

  @override
  bool shouldRepaint(covariant FanoosLanternPainter oldDelegate) =>
      oldDelegate.glowStrength != glowStrength ||
      oldDelegate.lanternFraction != lanternFraction;
}

/// Hour-bucketed glow strength for the fanoos: soft through the day,
/// brightening through the afternoon toward iftar, warm through the night.
double fanoosGlowStrengthFor(DateTime now) {
  final hour = now.hour;
  if (hour >= 16 && hour < 20) return 1.0; // approaching and at iftar
  if (hour >= 12 && hour < 16) return 0.55;
  if (hour >= 20 || hour < 2) return 0.7; // taraweeh evenings
  return 0.35;
}
