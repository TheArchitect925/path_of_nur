import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_motion.dart';
import 'light_band.dart';
import 'motion_preferences.dart';

/// One band of light crossing [child], once, when [play] is true on first
/// build or turns true later — for something that changed while the reader
/// was away. It never repeats on its own.
class GlintSweep extends ConsumerStatefulWidget {
  const GlintSweep({
    super.key,
    required this.play,
    required this.child,
    this.borderRadius = 18,
    this.color = const Color(0xFFFFF6DF),
    this.strength = 0.38,
  });

  final bool play;
  final Widget child;
  final double borderRadius;
  final Color color;
  final double strength;

  @override
  ConsumerState<GlintSweep> createState() => _GlintSweepState();
}

class _GlintSweepState extends ConsumerState<GlintSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.glint,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (widget.play) _play();
  }

  @override
  void didUpdateWidget(GlintSweep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) _play();
  }

  void _play() {
    if (ref.read(effectiveReduceMotionProvider)) return;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: CustomPaint(
        foregroundPainter: LightBandPainter(
          progress: _controller.value,
          color: widget.color,
          strength: widget.strength,
          repaint: _controller,
        ),
        child: widget.child,
      ),
    );
  }
}
