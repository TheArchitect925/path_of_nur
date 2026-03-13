import 'package:flutter/material.dart';

import '../models/salah_trainer_models.dart';

class PrayerPostureAnimator extends StatelessWidget {
  const PrayerPostureAnimator({
    super.key,
    required this.posture,
    this.size = 180,
    this.duration = const Duration(milliseconds: 300),
  });

  final PrayerPostureType posture;
  final double size;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.38);
    return AnimatedSwitcher(
      duration: duration,
      child: CustomPaint(
        key: ValueKey(posture),
        size: Size.square(size),
        painter: _PrayerPosturePainter(posture: posture, color: color),
      ),
    );
  }
}

class _PrayerPosturePainter extends CustomPainter {
  const _PrayerPosturePainter({required this.posture, required this.color});

  final PrayerPostureType posture;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.05
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final centerX = size.width / 2;
    final headRadius = size.width * 0.09;
    final headCenter = Offset(centerX, size.height * 0.18);
    canvas.drawCircle(headCenter, headRadius, paint);

    switch (posture) {
      case PrayerPostureType.qiyam:
        _drawStanding(canvas, size, paint, headCenter, 0);
      case PrayerPostureType.ruku:
        _drawBowing(canvas, size, paint, headCenter);
      case PrayerPostureType.qawmah:
        _drawStanding(canvas, size, paint, headCenter, -0.04);
      case PrayerPostureType.sujud:
        _drawSujud(canvas, size, paint);
      case PrayerPostureType.jalsah:
        _drawSitting(canvas, size, paint, low: false);
      case PrayerPostureType.tashahhud:
        _drawSitting(canvas, size, paint, low: true);
      case PrayerPostureType.salamRight:
        _drawStanding(canvas, size, paint, headCenter, 0.08);
      case PrayerPostureType.salamLeft:
        _drawStanding(canvas, size, paint, headCenter, -0.08);
    }
  }

  void _drawStanding(
    Canvas canvas,
    Size size,
    Paint paint,
    Offset headCenter,
    double headOffset,
  ) {
    final neck = Offset(
      headCenter.dx + size.width * headOffset,
      size.height * 0.28,
    );
    final hip = Offset(neck.dx, size.height * 0.58);
    final kneeLeft = Offset(neck.dx - size.width * 0.07, size.height * 0.77);
    final kneeRight = Offset(neck.dx + size.width * 0.07, size.height * 0.77);
    final footLeft = Offset(
      kneeLeft.dx - size.width * 0.02,
      size.height * 0.92,
    );
    final footRight = Offset(
      kneeRight.dx + size.width * 0.02,
      size.height * 0.92,
    );
    final armLeft = Offset(neck.dx - size.width * 0.14, size.height * 0.43);
    final armRight = Offset(neck.dx + size.width * 0.14, size.height * 0.43);

    canvas.drawLine(Offset(headCenter.dx, size.height * 0.27), neck, paint);
    canvas.drawLine(neck, hip, paint);
    canvas.drawLine(neck, armLeft, paint);
    canvas.drawLine(neck, armRight, paint);
    canvas.drawLine(hip, kneeLeft, paint);
    canvas.drawLine(hip, kneeRight, paint);
    canvas.drawLine(kneeLeft, footLeft, paint);
    canvas.drawLine(kneeRight, footRight, paint);
  }

  void _drawBowing(Canvas canvas, Size size, Paint paint, Offset headCenter) {
    final shoulder = Offset(size.width * 0.44, size.height * 0.34);
    final hip = Offset(size.width * 0.60, size.height * 0.54);
    final kneeLeft = Offset(size.width * 0.53, size.height * 0.76);
    final kneeRight = Offset(size.width * 0.66, size.height * 0.76);
    final handLeft = Offset(size.width * 0.36, size.height * 0.54);
    final handRight = Offset(size.width * 0.48, size.height * 0.61);
    canvas.drawLine(
      Offset(headCenter.dx - 12, size.height * 0.25),
      shoulder,
      paint,
    );
    canvas.drawLine(shoulder, hip, paint);
    canvas.drawLine(shoulder, handLeft, paint);
    canvas.drawLine(shoulder, handRight, paint);
    canvas.drawLine(hip, kneeLeft, paint);
    canvas.drawLine(hip, kneeRight, paint);
    canvas.drawLine(
      kneeLeft,
      Offset(size.width * 0.50, size.height * 0.92),
      paint,
    );
    canvas.drawLine(
      kneeRight,
      Offset(size.width * 0.70, size.height * 0.92),
      paint,
    );
  }

  void _drawSujud(Canvas canvas, Size size, Paint paint) {
    final head = Offset(size.width * 0.62, size.height * 0.62);
    canvas.drawCircle(head, size.width * 0.06, paint);
    final backStart = Offset(size.width * 0.44, size.height * 0.50);
    final backEnd = Offset(size.width * 0.66, size.height * 0.56);
    final knees = Offset(size.width * 0.42, size.height * 0.72);
    canvas.drawLine(backStart, backEnd, paint);
    canvas.drawLine(
      backStart,
      Offset(size.width * 0.28, size.height * 0.62),
      paint,
    );
    canvas.drawLine(backStart, knees, paint);
    canvas.drawLine(
      knees,
      Offset(size.width * 0.30, size.height * 0.90),
      paint,
    );
    canvas.drawLine(
      knees,
      Offset(size.width * 0.46, size.height * 0.90),
      paint,
    );
    canvas.drawLine(head, Offset(size.width * 0.78, size.height * 0.70), paint);
  }

  void _drawSitting(
    Canvas canvas,
    Size size,
    Paint paint, {
    required bool low,
  }) {
    final torsoTop = Offset(size.width * 0.50, size.height * 0.30);
    final hip = Offset(size.width * 0.50, size.height * 0.58);
    final knee = Offset(size.width * 0.38, size.height * 0.74);
    final shin = Offset(size.width * 0.56, size.height * 0.84);
    final handLeft = Offset(size.width * 0.38, size.height * 0.48);
    final handRight = Offset(
      size.width * 0.60,
      size.height * (low ? 0.50 : 0.46),
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.26),
      torsoTop,
      paint,
    );
    canvas.drawLine(torsoTop, hip, paint);
    canvas.drawLine(torsoTop, handLeft, paint);
    canvas.drawLine(torsoTop, handRight, paint);
    canvas.drawLine(hip, knee, paint);
    canvas.drawLine(knee, Offset(size.width * 0.28, size.height * 0.90), paint);
    canvas.drawLine(hip, shin, paint);
    canvas.drawLine(shin, Offset(size.width * 0.70, size.height * 0.88), paint);
  }

  @override
  bool shouldRepaint(covariant _PrayerPosturePainter oldDelegate) {
    return oldDelegate.posture != posture || oldDelegate.color != color;
  }
}
