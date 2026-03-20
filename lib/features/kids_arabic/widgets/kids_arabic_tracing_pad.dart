import 'package:flutter/material.dart';

import '../application/kids_arabic_starter_tracing.dart';
import '../application/kids_arabic_tracing_engine.dart';
import '../domain/kids_arabic_models.dart';

class KidsArabicTracingColorOption {
  const KidsArabicTracingColorOption({
    required this.id,
    required this.color,
    required this.label,
  });

  final String id;
  final Color color;
  final String label;
}

class KidsArabicTracingPad extends StatefulWidget {
  const KidsArabicTracingPad({
    super.key,
    required this.glyph,
    required this.clearActionLabel,
    required this.traceColorLabel,
    required this.readyBadgeLabel,
    required this.colorOptions,
    required this.onMetricsChanged,
    this.guide,
  });

  final String glyph;
  final String clearActionLabel;
  final String traceColorLabel;
  final String readyBadgeLabel;
  final List<KidsArabicTracingColorOption> colorOptions;
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
  late Color _selectedColor;
  KidsArabicTraceMetrics _metrics = const KidsArabicTraceMetrics(
    strokeCount: 0,
    pointCount: 0,
  );

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.colorOptions.first.color;
  }

  @override
  void didUpdateWidget(covariant KidsArabicTracingPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.colorOptions.any((option) => option.color == _selectedColor)) {
      _selectedColor = widget.colorOptions.first.color;
    }
  }

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

  void _startStroke(Offset position) {
    setState(() {
      _strokes.add(<Offset>[position]);
    });
    _notify();
  }

  void _appendPoint(Offset position) {
    if (_strokes.isEmpty) return;
    final stroke = _strokes.last;
    if (stroke.isNotEmpty && (stroke.last - position).distance < 2.5) {
      return;
    }
    setState(() {
      stroke.add(position);
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _metrics.minimumEffortMet;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size.square(constraints.maxWidth);
              _lastSize = size;
              return AspectRatio(
                aspectRatio: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) => _startStroke(details.localPosition),
                  onPanUpdate: (details) => _appendPoint(details.localPosition),
                  child: AnimatedBuilder(
                    animation: _successController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _TracingPadPainter(
                          glyph: widget.glyph,
                          strokes: _strokes,
                          guide: widget.guide,
                          metrics: _metrics,
                          selectedColor: _selectedColor,
                          successT: _successController.value,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF5),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: ready
                                  ? const Color(0xFFD5E6B7)
                                  : const Color(0xFFE5D6C3),
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
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              widget.traceColorLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF5E462A),
              ),
            ),
            ...widget.colorOptions.map(
              (option) => _TracingColorChip(
                option: option,
                isSelected: option.color == _selectedColor,
                onTap: () {
                  setState(() {
                    _selectedColor = option.color;
                  });
                },
              ),
            ),
            if (ready)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5D6),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFC7DBA0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: Color(0xFF64873B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.readyBadgeLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF557131),
                      ),
                    ),
                  ],
                ),
              ),
          ],
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

class _TracingColorChip extends StatelessWidget {
  const _TracingColorChip({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final KidsArabicTracingColorOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: option.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF7EC) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? const Color(0xFFB99365) : const Color(0xFFDCCBB3),
            ),
          ),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: option.color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _TracingPadPainter extends CustomPainter {
  const _TracingPadPainter({
    required this.glyph,
    required this.strokes,
    required this.guide,
    required this.metrics,
    required this.selectedColor,
    required this.successT,
  });

  final String glyph;
  final List<List<Offset>> strokes;
  final KidsArabicTracingGuide? guide;
  final KidsArabicTraceMetrics metrics;
  final Color selectedColor;
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

    final guideLinePaint = Paint()
      ..color = const Color(0xFFF0E5D6)
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(size.width / 2, 18),
      Offset(size.width / 2, size.height - 18),
      guideLinePaint,
    );
    canvas.drawLine(
      Offset(18, size.height / 2),
      Offset(size.width - 18, size.height / 2),
      guideLinePaint,
    );

    _paintGlyphEcho(canvas, size);
    _paintGuide(canvas, size);
    _paintUserTrace(canvas);
    _paintCompletionGlow(canvas, size);
  }

  void _paintGlyphEcho(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: glyph,
        style: TextStyle(
          fontSize: size.width * 0.34,
          color: const Color(0x11B58D61),
          fontFamily: 'Noto Naskh Arabic',
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout(maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2 - 4,
      ),
    );
  }

  void _paintGuide(Canvas canvas, Size size) {
    if (guide == null) return;
    final outlinePaint = Paint()
      ..color = const Color(0xFFE6D7C4)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final completedPaint = Paint()
      ..color = const Color(0xFFCFE7B6)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final activeGlowPaint = Paint()
      ..color = const Color(0x446FC08A)
      ..strokeWidth = 20
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final activePaint = Paint()
      ..color = const Color(0xFF8FC870)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final dotFillPaint = Paint()
      ..color = const Color(0xFFF0DFC7)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < guide!.strokes.length; i += 1) {
      final stroke = guide!.strokes[i];
      final path = kidsArabicGuideStrokePath(stroke, size);
      final isDot = stroke.kind == KidsArabicGuideStrokeKind.dot;
      final isCompleted = i < metrics.completedGuideStrokes;
      final isActive = i == metrics.activeGuideStrokeIndex;

      if (isDot) {
        canvas.drawPath(path, dotFillPaint);
        canvas.drawPath(
          path,
          Paint()
            ..color = isCompleted
                ? const Color(0xFFC0D8A5)
                : isActive
                ? const Color(0xFF8FC870)
                : const Color(0xFFD8C7B1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.5,
        );
      } else {
        canvas.drawPath(path, outlinePaint);
        if (isCompleted) {
          canvas.drawPath(path, completedPaint);
        } else if (isActive) {
          canvas.drawPath(path, activeGlowPaint);
          canvas.drawPath(path, activePaint);
        }
      }

      _paintStartHint(canvas, size, stroke, isCompleted);
    }
  }

  void _paintStartHint(
    Canvas canvas,
    Size size,
    KidsArabicGuideStroke stroke,
    bool isCompleted,
  ) {
    final hasStartPoint = stroke.kind == KidsArabicGuideStrokeKind.dot
        ? stroke.center != null
        : stroke.points.isNotEmpty;
    if (isCompleted || !hasStartPoint) return;
    final startPoint = stroke.kind == KidsArabicGuideStrokeKind.dot
        ? stroke.center!
        : stroke.points.first;
    final start = Offset(startPoint.dx * size.width, startPoint.dy * size.height);
    canvas.drawCircle(start, 10, Paint()..color = const Color(0xFFFFE1AA));
    canvas.drawCircle(start, 5, Paint()..color = const Color(0xFF9E7448));
    if (stroke.kind == KidsArabicGuideStrokeKind.path && stroke.points.length >= 2) {
      final next = Offset(
        stroke.points[1].dx * size.width,
        stroke.points[1].dy * size.height,
      );
      _paintArrow(canvas, start, next);
    }
  }

  void _paintArrow(Canvas canvas, Offset from, Offset to) {
    final direction = to - from;
    if (direction.distance == 0) return;
    final unit = direction / direction.distance;
    final tip = from + unit * 24;
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
      ..color = selectedColor
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
      for (var i = 1; i < stroke.length; i += 1) {
        final current = stroke[i];
        final previous = stroke[i - 1];
        final midPoint = Offset(
          (current.dx + previous.dx) / 2,
          (current.dy + previous.dy) / 2,
        );
        path.quadraticBezierTo(previous.dx, previous.dy, midPoint.dx, midPoint.dy);
      }
      path.lineTo(stroke.last.dx, stroke.last.dy);
      canvas.drawPath(path, tracePaint);
    }
  }

  void _paintCompletionGlow(Canvas canvas, Size size) {
    if (!metrics.successPulse) return;
    final glowPaint = Paint()
      ..color = Color.lerp(
        const Color(0x009FE29B),
        const Color(0x559FE29B),
        1 - successT,
      )!
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
        oldDelegate.selectedColor != selectedColor ||
        oldDelegate.successT != successT;
  }
}
