import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_motion.dart';
import 'motion_preferences.dart';

/// A tick that draws itself when [checked] turns on, with one soft ring
/// expanding behind it. Unchecked it is an empty circle; already checked on
/// first build it paints at rest. One-shot, never repeats.
class DrawnCheck extends ConsumerStatefulWidget {
  const DrawnCheck({
    super.key,
    required this.checked,
    required this.color,
    required this.emptyColor,
    this.tickColor = const Color(0xFF2F4A33),
    this.size = 14,
  });

  final bool checked;

  /// Fill and ring colour once checked.
  final Color color;

  /// Outline colour while unchecked.
  final Color emptyColor;
  final Color tickColor;
  final double size;

  @override
  ConsumerState<DrawnCheck> createState() => _DrawnCheckState();
}

class _DrawnCheckState extends ConsumerState<DrawnCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.drawCheck + AppMotion.ringOut,
    value: widget.checked ? 1 : 0,
  );

  @override
  void didUpdateWidget(DrawnCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.checked == oldWidget.checked) return;
    if (!widget.checked) {
      _controller.value = 0;
      return;
    }
    if (ref.read(effectiveReduceMotionProvider)) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(
        painter: _DrawnCheckPainter(
          progress: _controller,
          color: widget.color,
          emptyColor: widget.emptyColor,
          tickColor: widget.tickColor,
        ),
      ),
    );
  }
}

class _DrawnCheckPainter extends CustomPainter {
  _DrawnCheckPainter({
    required this.progress,
    required this.color,
    required this.emptyColor,
    required this.tickColor,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final Color color;
  final Color emptyColor;
  final Color tickColor;

  static const double _drawShare = 0.58;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final t = progress.value;
    if (t <= 0) {
      canvas.drawCircle(
        center,
        radius - 0.75,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = emptyColor,
      );
      return;
    }
    final draw = (t / _drawShare).clamp(0.0, 1.0);
    final ring = ((t - 0.25) / 0.75).clamp(0.0, 1.0);

    // The soft ring, expanding once and fading.
    if (ring > 0 && ring < 1) {
      canvas.drawCircle(
        center,
        radius * (1 + 1.2 * ring),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = color.withValues(alpha: 0.7 * (1 - ring)),
      );
    }

    // The fill grows in first.
    final fillScale = Curves.easeOutCubic.transform((draw / 0.5).clamp(0, 1));
    canvas.drawCircle(center, radius * fillScale, Paint()..color = color);

    // Then the tick draws itself.
    final tickProgress = ((draw - 0.3) / 0.7).clamp(0.0, 1.0);
    if (tickProgress <= 0) return;
    final path = Path()
      ..moveTo(size.width * 0.28, size.height * 0.53)
      ..lineTo(size.width * 0.44, size.height * 0.69)
      ..lineTo(size.width * 0.73, size.height * 0.36);
    final metric = path.computeMetrics().first;
    final partial = metric.extractPath(0, metric.length * tickProgress);
    canvas.drawPath(
      partial,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.16
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = tickColor,
    );
  }

  @override
  bool shouldRepaint(_DrawnCheckPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.emptyColor != emptyColor ||
      oldDelegate.tickColor != tickColor;
}
