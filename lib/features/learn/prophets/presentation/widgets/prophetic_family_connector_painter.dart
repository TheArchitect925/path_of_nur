import 'package:flutter/material.dart';

class PropheticFamilyConnectorPainter extends CustomPainter {
  const PropheticFamilyConnectorPainter({
    required this.color,
    required this.drawVertical,
  });

  final Color color;
  final bool drawVertical;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final midY = size.height * 0.5;
    final midX = size.width * 0.5;

    if (drawVertical) {
      canvas.drawLine(Offset(midX, 0), Offset(midX, size.height), paint);
    }
    canvas.drawLine(Offset(midX, midY), Offset(size.width, midY), paint);
  }

  @override
  bool shouldRepaint(covariant PropheticFamilyConnectorPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawVertical != drawVertical;
  }
}
