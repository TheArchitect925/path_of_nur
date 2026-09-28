import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../data/garden_scene_layout.g.dart';
import '../../../domain/garden_models.dart';
import '../../../domain/garden_scene_models.dart';
import 'garden_ambient_palette.dart';

/// Paints the whole vista in the generator's visual language so the feature
/// works before (and beneath) any WebP layer: produced raster art simply
/// covers the matching painted region. Deterministic — same spec, same frame.
class GardenVistaPlaceholderPainter extends CustomPainter {
  const GardenVistaPlaceholderPainter({
    required this.spec,
    required this.brightness,
  });

  final GardenSceneSpec spec;
  final Brightness brightness;

  static const double _w = GardenSceneLayout.canvasWidth;
  static const double _h = GardenSceneLayout.canvasHeight;
  static const double _horizon = GardenSceneLayout.horizonY;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _w;
    canvas.save();
    canvas.scale(scale);
    final palette = GardenAmbientPalette.scene(brightness);
    final night = brightness == Brightness.dark;
    final seaVisible =
        spec.water.oceanHorizonVisible || spec.water.streamTier >= 4;

    _paintSky(canvas, night);
    if (seaVisible) {
      _paintSea(canvas, palette);
    }
    _paintTerrain(canvas, palette, seaVisible);
    _paintStream(canvas, palette);
    for (final element in _plantsBackToFront()) {
      _paintPlant(canvas, palette, element);
    }
    _paintTree(canvas, palette);
    _paintCreatures(canvas, palette, night);
    _paintVignette(canvas, night);
    canvas.restore();
  }

  Iterable<GardenSceneElementSpec> _plantsBackToFront() {
    final visible =
        spec.elements
            .where(
              (element) =>
                  element.variantLevel > 0 &&
                  element.kind != GardenSceneElementKind.animal,
            )
            .toList()
          ..sort((a, b) {
            final za = GardenSceneLayout.elementPlacements[a.id.name]?.z ?? 0;
            final zb = GardenSceneLayout.elementPlacements[b.id.name]?.z ?? 0;
            return za.compareTo(zb);
          });
    return visible;
  }

  void _paintSky(Canvas canvas, bool night) {
    final colors = GardenAmbientPalette.skyColors(spec.ambient, brightness);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, _w, _h),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          const Offset(0, _h),
          colors,
          const [0.0, 0.5, 1.0],
        ),
    );
    if (night) {
      final starPaint = Paint()..color = GardenAmbientPalette.ivory;
      var seed = 21;
      for (var i = 0; i < 30; i++) {
        seed = (seed * 48271) % 0x7fffffff;
        final x = 60 + (seed % 1880).toDouble();
        seed = (seed * 48271) % 0x7fffffff;
        final y = 50 + (seed % 420).toDouble();
        starPaint.color = GardenAmbientPalette.ivory.withValues(
          alpha: 0.4 + (seed % 40) / 100,
        );
        canvas.drawCircle(Offset(x, y), 1.6 + (seed % 20) / 10, starPaint);
      }
      _paintGlow(
        canvas,
        const Offset(330, 180),
        140,
        GardenAmbientPalette.ivory,
        0.4,
      );
      final crescent = Path()
        ..addArc(
          Rect.fromCircle(center: const Offset(330, 180), radius: 64),
          -math.pi / 2,
          math.pi,
        )
        ..arcTo(
          Rect.fromCircle(center: const Offset(330, 180), radius: 75.5),
          math.pi / 2,
          -math.pi,
          false,
        )
        ..close();
      canvas.drawPath(crescent, Paint()..color = GardenAmbientPalette.ivory);
      return;
    }
    final sun = switch (spec.ambient) {
      GardenAmbientState.quietDawn => const Offset(620, 470),
      GardenAmbientState.gentleMorning => const Offset(560, 300),
      GardenAmbientState.warmLight => const Offset(660, 430),
      GardenAmbientState.eveningGlow => const Offset(470, 300),
    };
    final disc = spec.ambient == GardenAmbientState.eveningGlow
        ? const Color(0xFFF5E3BC)
        : const Color(0xFFFBEED2);
    _paintGlow(canvas, sun, 380, const Color(0xFFFBE3B0), 0.55);
    canvas.drawCircle(sun, 64, Paint()..color = disc);
  }

  void _paintGlow(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double alpha,
  ) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = ui.Gradient.radial(center, radius, [
          color.withValues(alpha: alpha),
          color.withValues(alpha: 0),
        ]),
    );
  }

  void _paintSea(Canvas canvas, GardenScenePalette palette) {
    final height = spec.water.oceanHorizonFull ? 130.0 : 80.0;
    canvas.drawRect(
      Rect.fromLTWH(1170, _horizon - 14, 830, height),
      Paint()..color = palette.sea,
    );
    canvas.drawRect(
      Rect.fromLTWH(1170, _horizon - 14, 830, 4),
      Paint()..color = GardenAmbientPalette.ivory.withValues(alpha: 0.3),
    );
  }

  void _paintTerrain(
    Canvas canvas,
    GardenScenePalette palette,
    bool seaVisible,
  ) {
    final dipTop = seaVisible ? 34.0 : 16.0;
    final dipBottom = seaVisible ? 96.0 : 26.0;
    final far = Path()
      ..moveTo(-60, _h)
      ..lineTo(-60, _horizon + 30)
      ..cubicTo(240, _horizon - 4, 560, _horizon + 36, 900, _horizon + 18)
      ..cubicTo(
        1080,
        _horizon + 8,
        1180,
        _horizon + 14,
        1260,
        _horizon + dipTop,
      )
      ..cubicTo(
        1400,
        _horizon + dipBottom,
        1720,
        _horizon + dipBottom,
        1900,
        _horizon + dipTop,
      )
      ..cubicTo(1960, _horizon + 10, 2060, _horizon + 16, 2060, _horizon + 16)
      ..lineTo(2060, _h)
      ..close();
    canvas.drawPath(far, Paint()..color = palette.farHill);

    final mid = Path()
      ..moveTo(-60, _h)
      ..lineTo(-60, 786)
      ..cubicTo(340, 706, 820, 762, 1150, 792)
      ..cubicTo(1450, 818, 1740, 756, 2060, 788)
      ..lineTo(2060, _h)
      ..close();
    canvas.drawPath(mid, Paint()..color = palette.midHill);

    final meadow = Path()
      ..moveTo(-60, _h)
      ..lineTo(-60, 908)
      ..quadraticBezierTo(500, 838, 1010, 886)
      ..quadraticBezierTo(1520, 932, 2060, 878)
      ..lineTo(2060, _h)
      ..close();
    canvas.drawPath(
      meadow,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 838),
          const Offset(0, _h),
          [palette.meadowHi, palette.meadowLo],
        ),
    );

    final near = Path()
      ..moveTo(-60, _h)
      ..lineTo(-60, 1072)
      ..quadraticBezierTo(800, 1018, 2060, 1058)
      ..lineTo(2060, _h)
      ..close();
    canvas.drawPath(
      near,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 1018),
          const Offset(0, _h),
          [palette.nearHi, palette.nearLo],
        ),
    );
  }

  void _paintStream(Canvas canvas, GardenScenePalette palette) {
    final tier = spec.water.streamTier;
    if (tier <= 1) {
      final pond = Rect.fromCenter(
        center: const Offset(1350, 1082),
        width: 172,
        height: 48,
      );
      canvas.drawOval(pond, Paint()..color = palette.waterLo);
      canvas.drawOval(
        pond.deflate(10),
        Paint()
          ..shader = ui.Gradient.linear(pond.topCenter, pond.bottomCenter, [
            palette.waterHi,
            palette.waterLo,
          ]),
      );
      return;
    }
    final halfWidth = [0.0, 0.0, 46.0, 78.0, 114.0, 152.0][tier];
    final points = GardenSceneLayout.streamCenterline;
    final left = <Offset>[];
    final right = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final t = i / (points.length - 1);
      final w = math.max(8.0, halfWidth * (0.1 + 0.9 * t));
      left.add(Offset(points[i][0] - w, points[i][1]));
      right.add(Offset(points[i][0] + w, points[i][1]));
    }
    final path = Path()..moveTo(left.first.dx, left.first.dy);
    for (final point in left.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    for (final point in right.reversed) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, _horizon),
          const Offset(0, _h),
          [palette.waterHi, palette.waterLo],
        ),
    );
  }

  void _paintTree(Canvas canvas, GardenScenePalette palette) {
    const baseX = 1000.0;
    const baseY = 990.0;
    final stageNumber = spec.treeStage.index + 1;
    final shadow = Paint()
      ..shader = ui.Gradient.radial(
        Offset(baseX + 20, baseY + 4),
        150 + stageNumber * 16,
        [const Color(0x3D0E1710), const Color(0x000E1710)],
      );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(baseX + 20, baseY + 4),
        width: (150 + stageNumber * 16) * 2,
        height: 40 + stageNumber * 4,
      ),
      shadow,
    );
    if (stageNumber == 1) {
      canvas.drawOval(
        Rect.fromCenter(
          center: const Offset(baseX, baseY - 8),
          width: 52,
          height: 34,
        ),
        Paint()..color = palette.trunk,
      );
      return;
    }
    if (stageNumber <= 3) {
      final stem = Paint()
        ..color = palette.canopyMid
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round;
      final height = stageNumber == 2 ? 82.0 : 124.0;
      canvas.drawLine(
        const Offset(baseX, baseY),
        Offset(baseX, baseY - height),
        stem,
      );
      canvas.drawCircle(
        Offset(baseX - 24, baseY - height + 14),
        24,
        Paint()..color = palette.canopyMid,
      );
      canvas.drawCircle(
        Offset(baseX + 22, baseY - height + 4),
        26,
        Paint()..color = palette.canopyLight,
      );
      return;
    }
    final t = (stageNumber - 4) / 6;
    final trunkHeight = 160 + t * 280;
    final trunkWidth = 24 + t * 54;
    final canopyRadius = 105 + t * 205;
    final canopyY = baseY - trunkHeight - canopyRadius * 0.38;
    final trunk = Path()
      ..moveTo(baseX - trunkWidth * 0.55, baseY)
      ..cubicTo(
        baseX - trunkWidth * 0.42,
        baseY - trunkHeight * 0.5,
        baseX - trunkWidth * 0.3,
        baseY - trunkHeight * 0.82,
        baseX - trunkWidth * 0.16,
        baseY - trunkHeight,
      )
      ..lineTo(baseX + trunkWidth * 0.16, baseY - trunkHeight)
      ..cubicTo(
        baseX + trunkWidth * 0.28,
        baseY - trunkHeight * 0.78,
        baseX + trunkWidth * 0.4,
        baseY - trunkHeight * 0.48,
        baseX + trunkWidth * 0.55,
        baseY,
      )
      ..close();
    canvas.drawPath(trunk, Paint()..color = palette.trunk);
    void blob(double dx, double dy, double r, Color color) {
      canvas.drawCircle(
        Offset(baseX + dx, canopyY + dy),
        r,
        Paint()..color = color,
      );
    }

    blob(0, -canopyRadius * 0.06, canopyRadius * 0.95, palette.canopyShade);
    if (stageNumber >= 6) {
      blob(
        -canopyRadius * 0.86,
        canopyRadius * 0.24,
        canopyRadius * 0.58,
        palette.canopyShade,
      );
      blob(
        canopyRadius * 0.84,
        canopyRadius * 0.22,
        canopyRadius * 0.54,
        palette.canopyShade,
      );
      blob(
        -canopyRadius * 0.5,
        canopyRadius * 0.05,
        canopyRadius * 0.5,
        palette.canopyMid,
      );
      blob(
        canopyRadius * 0.5,
        canopyRadius * 0.05,
        canopyRadius * 0.48,
        palette.canopyMid,
      );
    }
    if (stageNumber >= 8) {
      blob(
        -canopyRadius * 0.26,
        -canopyRadius * 0.48,
        canopyRadius * 0.5,
        palette.canopyLight,
      );
      blob(
        canopyRadius * 0.36,
        -canopyRadius * 0.42,
        canopyRadius * 0.46,
        palette.canopyLight,
      );
    }
    if (stageNumber >= 9) {
      final fruit = Paint()..color = GardenAmbientPalette.gold;
      var seed = 7;
      for (var i = 0; i < 10; i++) {
        seed = (seed * 48271) % 0x7fffffff;
        final angle = -math.pi * 0.95 + (seed % 100) / 100 * math.pi * 0.9;
        seed = (seed * 48271) % 0x7fffffff;
        final radius = canopyRadius * (0.4 + (seed % 50) / 100);
        canvas.drawCircle(
          Offset(
            baseX + radius * math.cos(angle),
            canopyY + radius * math.sin(angle) * 0.68,
          ),
          7 + (seed % 6).toDouble(),
          fruit,
        );
      }
    }
    if (stageNumber >= 10) {
      final blossom = Paint()
        ..color = const Color(0xFFF5E7BE).withValues(alpha: 0.9);
      var seed = 13;
      for (var i = 0; i < 12; i++) {
        seed = (seed * 48271) % 0x7fffffff;
        final angle = (seed % 628) / 100;
        seed = (seed * 48271) % 0x7fffffff;
        final radius = canopyRadius * (0.55 + (seed % 50) / 100);
        canvas.drawCircle(
          Offset(
            baseX + radius * math.cos(angle),
            canopyY + radius * math.sin(angle) * 0.7,
          ),
          4 + (seed % 4).toDouble(),
          blossom,
        );
      }
    }
  }

  void _paintPlant(
    Canvas canvas,
    GardenScenePalette palette,
    GardenSceneElementSpec element,
  ) {
    if (element.id == GardenSceneElementId.stream ||
        element.id == GardenSceneElementId.oceanHorizon ||
        element.id == GardenSceneElementId.centralTree) {
      return;
    }
    final placement = GardenSceneLayout.elementPlacements[element.id.name];
    if (placement == null) {
      return;
    }
    final baseX = placement.baseX;
    final baseY = placement.baseY;
    final growth = [0.0, 0.6, 0.8, 1.0][element.variantLevel];
    switch (element.id) {
      case GardenSceneElementId.datePalm:
        final trunkPaint = Paint()
          ..color = palette.trunk
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20 * growth
          ..strokeCap = StrokeCap.round;
        final tip = Offset(baseX + 30 * growth, baseY - 300 * growth);
        canvas.drawLine(Offset(baseX, baseY), tip, trunkPaint);
        final frond = Paint()
          ..color = palette.canopyMid
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12 * growth
          ..strokeCap = StrokeCap.round;
        for (final direction in const [
          Offset(-1, -0.4),
          Offset(-0.6, -0.9),
          Offset(0.1, -1.05),
          Offset(0.7, -0.8),
          Offset(1.05, -0.25),
        ]) {
          canvas.drawLine(
            tip,
            tip +
                Offset(
                  direction.dx * 180 * growth,
                  direction.dy * 130 * growth,
                ),
            frond,
          );
        }
      case GardenSceneElementId.rayhan:
        final blade = Paint()
          ..color = palette.canopyLight
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5 * growth
          ..strokeCap = StrokeCap.round;
        for (var i = -2; i <= 2; i++) {
          canvas.drawLine(
            Offset(baseX + i * 12 * growth, baseY),
            Offset(baseX + i * 16 * growth, baseY - 48 * growth),
            blade,
          );
        }
      case GardenSceneElementId.gourd:
        final vine = Paint()
          ..color = palette.canopyMid
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6 * growth
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(baseX - 70 * growth, baseY),
          Offset(baseX + 70 * growth, baseY - 20 * growth),
          vine,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(baseX - 6 * growth, baseY - 14 * growth),
            width: 32 * growth,
            height: 24 * growth,
          ),
          Paint()..color = const Color(0xFFD8C48E),
        );
      default:
        final trunkPaint = Paint()
          ..color = palette.trunk
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9 * growth
          ..strokeCap = StrokeCap.round;
        final height = 84 * growth;
        canvas.drawLine(
          Offset(baseX, baseY),
          Offset(baseX, baseY - height),
          trunkPaint,
        );
        canvas.drawCircle(
          Offset(baseX - 26 * growth, baseY - height - 14),
          30 * growth,
          Paint()..color = palette.canopyShade,
        );
        canvas.drawCircle(
          Offset(baseX + 24 * growth, baseY - height - 18),
          28 * growth,
          Paint()..color = palette.canopyMid,
        );
        canvas.drawCircle(
          Offset(baseX, baseY - height - 40 * growth),
          32 * growth,
          Paint()..color = palette.canopyLight,
        );
        if (element.id == GardenSceneElementId.loteTree) {
          _paintGlow(
            canvas,
            Offset(baseX, baseY - height - 40 * growth),
            150 * growth,
            GardenAmbientPalette.ivory,
            0.35,
          );
        }
    }
  }

  void _paintCreatures(Canvas canvas, GardenScenePalette palette, bool night) {
    final bee = spec.elementById(GardenSceneElementId.bee);
    if (bee != null && bee.variantLevel > 0) {
      final paint = Paint()..color = GardenAmbientPalette.gold;
      final count = bee.variantLevel == 1
          ? 1
          : GardenSceneLayout.beeAnchors.length;
      for (var i = 0; i < count; i++) {
        final anchor = GardenSceneLayout.beeAnchors[i];
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(anchor[0], anchor[1]),
            width: 20,
            height: 14,
          ),
          paint,
        );
      }
    }
    final ant = spec.elementById(GardenSceneElementId.ant);
    if (ant != null && ant.variantLevel > 0) {
      final paint = Paint()..color = const Color(0xFF2A1E12);
      final placement = GardenSceneLayout.elementPlacements['ant']!;
      for (var i = 0; i < 4; i++) {
        canvas.drawCircle(
          Offset(placement.rect.x + 30 + i * 28, placement.baseY + 8 - i * 4),
          4.4,
          paint,
        );
      }
    }
    final hoopoe = spec.elementById(GardenSceneElementId.hoopoe);
    if (hoopoe != null && hoopoe.variantLevel > 0) {
      final placement = GardenSceneLayout.elementPlacements['hoopoe']!;
      final body = Paint()..color = const Color(0xFF8A6E52);
      final center = Offset(placement.baseX, placement.baseY + 14);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: 62, height: 40),
        body,
      );
      canvas.drawCircle(
        center + const Offset(-26, -16),
        11,
        Paint()..color = const Color(0xFF9A7A58),
      );
      final crest = Paint()
        ..color = const Color(0xFFB4714A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        center + const Offset(-28, -26),
        center + const Offset(-24, -40),
        crest,
      );
      canvas.drawLine(
        center + const Offset(-22, -26),
        center + const Offset(-14, -38),
        crest,
      );
    }
    final fish = spec.elementById(GardenSceneElementId.fish);
    if (fish != null && fish.variantLevel > 0) {
      final anchor = GardenSceneLayout.fishAnchor;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(anchor[0], anchor[1] + 7),
          width: 56,
          height: 14,
        ),
        Paint()..color = const Color(0xFF18222E).withValues(alpha: 0.5),
      );
      canvas.drawCircle(
        Offset(anchor[0], anchor[1]),
        22,
        Paint()
          ..color = GardenAmbientPalette.ivory.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6,
      );
    }
    final songbirds = spec.elementById(GardenSceneElementId.songbirds);
    if (songbirds != null && songbirds.variantLevel > 0) {
      final wing = Paint()
        ..color = night
            ? GardenAmbientPalette.ivory.withValues(alpha: 0.65)
            : const Color(0xA63A4A38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.4
        ..strokeCap = StrokeCap.round;
      void bird(double x, double y) {
        final path = Path()
          ..moveTo(x, y)
          ..quadraticBezierTo(x + 13, y - 11, x + 26, y)
          ..quadraticBezierTo(x + 39, y - 11, x + 52, y);
        canvas.drawPath(path, wing);
      }

      bird(760, GardenSceneLayout.birdBandTop + 40);
      if (songbirds.variantLevel >= 2) {
        bird(940, GardenSceneLayout.birdBandTop + 98);
        bird(620, GardenSceneLayout.birdBandTop);
      }
    }
  }

  void _paintVignette(Canvas canvas, bool night) {
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, _w, _h),
      Paint()
        ..shader = ui.Gradient.radial(
          const Offset(_w * 0.5, _h * 0.46),
          _w * 0.72,
          [const Color(0x000D1018), Color(night ? 0x570D1018 : 0x330D1018)],
          const [0.62, 1.0],
        ),
    );
  }

  @override
  bool shouldRepaint(GardenVistaPlaceholderPainter oldDelegate) {
    return oldDelegate.spec.revision != spec.revision ||
        oldDelegate.spec.ambient != spec.ambient ||
        oldDelegate.brightness != brightness;
  }
}
