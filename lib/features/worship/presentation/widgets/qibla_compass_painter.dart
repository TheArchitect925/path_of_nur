import 'dart:math' as math;

import 'package:flutter/material.dart';

class QiblaCompassPainter extends CustomPainter {
  QiblaCompassPainter({
    required this.ringColor,
    required this.tickColor,
    required this.labelColor,
    required this.accentColor,
    required this.alignmentGlowColor,
    required this.cardinalNorth,
    required this.cardinalEast,
    required this.cardinalSouth,
    required this.cardinalWest,
    required this.qiblaBearing,
    required this.aligned,
  });

  final Color ringColor;
  final Color tickColor;
  final Color labelColor;
  final Color accentColor;
  final Color alignmentGlowColor;
  final String cardinalNorth;
  final String cardinalEast;
  final String cardinalSouth;
  final String cardinalWest;
  final double qiblaBearing;
  final bool aligned;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final outerRadius = radius - 6;
    final innerRadius = radius * 0.77;

    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.28),
          const Color(0xFFF0E5D2).withValues(alpha: 0.18),
          const Color(0xFFD6BB8B).withValues(alpha: 0.08),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius));
    canvas.drawCircle(center, outerRadius, backgroundPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = ringColor;
    canvas.drawCircle(center, outerRadius, ringPaint);

    final innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = ringColor.withValues(alpha: 0.48);
    canvas.drawCircle(center, innerRadius, innerRingPaint);

    final alignmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = (aligned ? alignmentGlowColor : accentColor).withValues(
        alpha: aligned ? 0.34 : 0.18,
      );
    final alignmentSweep = _degToRad(14);
    final alignmentStart = _degToRad(qiblaBearing - 7) - (math.pi / 2);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius - 10),
      alignmentStart,
      alignmentSweep,
      false,
      alignmentPaint,
    );

    for (var degree = 0; degree < 360; degree += 5) {
      final isMajor = degree % 30 == 0;
      final angle = _degToRad(degree.toDouble()) - (math.pi / 2);
      final outer = Offset(
        center.dx + math.cos(angle) * (outerRadius - 10),
        center.dy + math.sin(angle) * (outerRadius - 10),
      );
      final tickLength = isMajor ? 14.0 : 7.0;
      final inner = Offset(
        center.dx + math.cos(angle) * (outerRadius - 10 - tickLength),
        center.dy + math.sin(angle) * (outerRadius - 10 - tickLength),
      );
      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..color = isMajor ? tickColor : tickColor.withValues(alpha: 0.58)
          ..strokeWidth = isMajor ? 2 : 1.1,
      );
    }

    _paintLabel(canvas, size, cardinalNorth, 0, labelColor);
    _paintLabel(canvas, size, cardinalEast, 90, labelColor);
    _paintLabel(canvas, size, cardinalSouth, 180, labelColor);
    _paintLabel(canvas, size, cardinalWest, 270, labelColor);
  }

  void _paintLabel(
    Canvas canvas,
    Size size,
    String label,
    double degrees,
    Color color,
  ) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final angle = _degToRad(degrees) - (math.pi / 2);
    final labelOffset = Offset(
      center.dx + math.cos(angle) * (radius - 28),
      center.dy + math.sin(angle) * (radius - 28),
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        labelOffset.dx - (textPainter.width / 2),
        labelOffset.dy - (textPainter.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant QiblaCompassPainter oldDelegate) {
    return ringColor != oldDelegate.ringColor ||
        tickColor != oldDelegate.tickColor ||
        labelColor != oldDelegate.labelColor ||
        accentColor != oldDelegate.accentColor ||
        alignmentGlowColor != oldDelegate.alignmentGlowColor ||
        cardinalNorth != oldDelegate.cardinalNorth ||
        cardinalEast != oldDelegate.cardinalEast ||
        cardinalSouth != oldDelegate.cardinalSouth ||
        cardinalWest != oldDelegate.cardinalWest ||
        qiblaBearing != oldDelegate.qiblaBearing ||
        aligned != oldDelegate.aligned;
  }
}

double _degToRad(double degrees) => degrees * math.pi / 180;
