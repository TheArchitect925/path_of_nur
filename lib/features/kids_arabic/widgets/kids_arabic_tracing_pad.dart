import 'package:flutter/material.dart';

import '../application/kids_arabic_starter_tracing.dart';
import '../application/kids_arabic_tracing_engine.dart';
import '../domain/kids_arabic_models.dart';

class KidsArabicTracingPad extends StatefulWidget {
  const KidsArabicTracingPad({
    super.key,
    required this.glyph,
    required this.clearActionLabel,
    required this.onMetricsChanged,
    this.guide,
  });

  final String glyph;
  final String clearActionLabel;
  final KidsArabicTracingGuide? guide;
  final ValueChanged<KidsArabicTraceMetrics> onMetricsChanged;

  @override
  State<KidsArabicTracingPad> createState() => KidsArabicTracingPadState();
}

class KidsArabicTracingPadState extends State<KidsArabicTracingPad>
    with SingleTickerProviderStateMixin {
  final List<List<Offset>> _strokes = <List<Offset>>[];
  Size _lastSize = const Size.square(320);
  late final AnimationController _successController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );
  KidsArabicTraceMetrics _metrics = const KidsArabicTraceMetrics(
    strokeCount: 0,
    pointCount: 0,
  );

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  void clear() {
    setState(_strokes.clear);
    _successController.reset();
    _metrics = const KidsArabicTraceMetrics(strokeCount: 0, pointCount: 0);
    widget.onMetricsChanged(_metrics);
  }

  void _notify() {
    final pointCount = _strokes.fold<int>(0, (sum, stroke) => sum + stroke.length);
    final evaluation = evaluateKidsArabicTrace(
      userStrokes: _strokes,
      size: _lastSize,
      guide: widget.guide,
    );
    final nextMetrics = KidsArabicTraceMetrics(
      strokeCount: _strokes.length,
      pointCount: pointCount,
      guidedProgress: evaluation.guidedProgress,
      alignmentScore: evaluation.alignmentScore,
      completedGuideStrokes: evaluation.completedStrokeCount,
      totalGuideStrokes: evaluation.totalStrokeCount,
      activeGuideStrokeIndex: evaluation.activeStrokeIndex,
      minimumEffortMet: evaluation.minimumEffortMet,
      successPulse: evaluation.successPulse,
    );
    if (nextMetrics.successPulse && !_metrics.successPulse) {
      _successController
        ..reset()
        ..forward();
    }
    _metrics = nextMetrics;
    widget.onMetricsChanged(nextMetrics);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = Size.square(constraints.maxWidth);
            _lastSize = size;
            return AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _strokes.add(<Offset>[details.localPosition]);
                  });
                  _notify();
                },
                onPanUpdate: (details) {
                  if (_strokes.isEmpty) return;
                  setState(() {
                    _strokes.last.add(details.localPosition);
                  });
                  _notify();
                },
                child: AnimatedBuilder(
                  animation: _successController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _TracingPadPainter(
                        glyph: widget.glyph,
                        strokes: _strokes,
                        guide: widget.guide,
                        metrics: _metrics,
                        successT: _successController.value,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFE5D6C3),
                            width: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: clear,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(widget.clearActionLabel),
          ),
        ),
      ],
    );
  }
}

class _TracingPadPainter extends CustomPainter {
  const _TracingPadPainter({
    required this.glyph,
    required this.strokes,
    required this.guide,
    required this.metrics,
    required this.successT,
  });

  final String glyph;
  final List<List<Offset>> strokes;
  final KidsArabicTracingGuide? guide;
  final KidsArabicTraceMetrics metrics;
  final double successT;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..color = const Color(0xFFF7EFE2)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(24)),
      background,
    );

    final guidePaint = Paint()
      ..color = const Color(0xFFE9DDCA)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(size.width / 2, 18), Offset(size.width / 2, size.height - 18), guidePaint);
    canvas.drawLine(Offset(18, size.height / 2), Offset(size.width - 18, size.height / 2), guidePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: glyph,
        style: TextStyle(
          fontSize: size.width * 0.48,
          color: const Color(0xFFCCB89F),
          fontFamily: 'Noto Naskh Arabic',
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout(maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2 - 6),
    );

    _paintGuide(canvas, size);
    _paintUserTrace(canvas);
    _paintCompletionGlow(canvas, size);
  }

  void _paintGuide(Canvas canvas, Size size) {
    if (guide == null) return;
    final completedPaint = Paint()
      ..color = const Color(0xFFCFE7B6)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final activeGlowPaint = Paint()
      ..color = const Color(0x556FC08A)
      ..strokeWidth = 18
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final activePaint = Paint()
      ..color = const Color(0xFF8FC870)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final basePaint = Paint()
      ..color = const Color(0xFFE5D6C3)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < guide!.strokes.length; i += 1) {
      final stroke = guide!.strokes[i];
      final path = Path();
      for (var j = 0; j < stroke.points.length; j += 1) {
        final point = Offset(stroke.points[j].dx * size.width, stroke.points[j].dy * size.height);
        if (j == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      if (i < metrics.completedGuideStrokes) {
        canvas.drawPath(path, completedPaint);
      } else if (i == metrics.activeGuideStrokeIndex) {
        canvas.drawPath(path, activeGlowPaint);
        canvas.drawPath(path, activePaint);
      } else {
        canvas.drawPath(path, basePaint);
      }

      if (stroke.points.isNotEmpty) {
        final start = Offset(stroke.points.first.dx * size.width, stroke.points.first.dy * size.height);
        canvas.drawCircle(start, 8, Paint()..color = const Color(0xFFFFD89D));
        canvas.drawCircle(start, 4, Paint()..color = const Color(0xFF9E7448));
      }
      if (stroke.points.length >= 2) {
        final from = Offset(stroke.points.first.dx * size.width, stroke.points.first.dy * size.height);
        final to = Offset(stroke.points[1].dx * size.width, stroke.points[1].dy * size.height);
        _paintArrow(canvas, from, to);
      }
    }
  }

  void _paintArrow(Canvas canvas, Offset from, Offset to) {
    final direction = to - from;
    if (direction.distance == 0) return;
    final unit = direction / direction.distance;
    final tip = from + unit * 22;
    final left = Offset(-unit.dy, unit.dx);
    final arrowPaint = Paint()
      ..color = const Color(0xFFB28F67)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(from + unit * 10, tip, arrowPaint);
    canvas.drawLine(tip, tip - unit * 7 + left * 5, arrowPaint);
    canvas.drawLine(tip, tip - unit * 7 - left * 5, arrowPaint);
  }

  void _paintUserTrace(Canvas canvas) {
    final tracePaint = Paint()
      ..color = const Color(0xFF8B6A44)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      if (stroke.length < 2) {
        if (stroke.isNotEmpty) {
          canvas.drawCircle(stroke.first, 5, tracePaint..style = PaintingStyle.fill);
          tracePaint.style = PaintingStyle.stroke;
        }
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final point in stroke.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, tracePaint);
    }
  }

  void _paintCompletionGlow(Canvas canvas, Size size) {
    if (!metrics.successPulse) return;
    final glowPaint = Paint()
      ..color = Color.lerp(const Color(0x009FE29B), const Color(0x559FE29B), 1 - successT)!
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(24)),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TracingPadPainter oldDelegate) {
    return oldDelegate.glyph != glyph ||
        oldDelegate.strokes != strokes ||
        oldDelegate.guide != guide ||
        oldDelegate.metrics != metrics ||
        oldDelegate.successT != successT;
  }
}
