import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_motion.dart';
import 'motion_preferences.dart';

/// Text arriving as if being written: a clip that opens in reading
/// direction. Layout never changes — only what is visible does — so the line
/// reads at rest exactly where it lands. Arabic passes
/// [TextDirection.rtl] whatever the app locale.
///
/// Drive it from an outer [animation] (the startup kindle) or let it run its
/// own [duration] after [delay]. Under Reduce Motion the text is simply there.
class InkReveal extends ConsumerStatefulWidget {
  const InkReveal({
    super.key,
    required this.child,
    required this.textDirection,
    this.animation,
    this.delay = Duration.zero,
    this.duration = AppMotion.inkReveal,
  });

  final Widget child;
  final TextDirection textDirection;
  final Animation<double>? animation;
  final Duration delay;
  final Duration duration;

  @override
  ConsumerState<InkReveal> createState() => _InkRevealState();
}

class _InkRevealState extends ConsumerState<InkReveal>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _own;

  @override
  void initState() {
    super.initState();
    if (widget.animation != null) return;
    final total = widget.delay + widget.duration;
    final controller = AnimationController(vsync: this, duration: total);
    _controller = controller;
    _own = CurvedAnimation(
      parent: controller,
      curve: Interval(
        total.inMilliseconds == 0
            ? 0
            : widget.delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: AppMotion.settleCurve,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = _controller;
    if (controller == null ||
        controller.isAnimating ||
        controller.isCompleted) {
      return;
    }
    if (ref.read(effectiveReduceMotionProvider)) {
      controller.value = 1;
    } else {
      controller.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation ?? _own!;
    // Under Reduce Motion the line is simply there, with no wrapper at all.
    if (ref.watch(effectiveReduceMotionProvider)) return widget.child;
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      // The clip stays in place at rest (it then clips nothing), so the
      // line is never rebuilt when its reveal completes.
      builder: (context, child) => ClipRect(
        clipper: InkRevealClipper(
          fraction: animation.value,
          textDirection: widget.textDirection,
        ),
        child: child,
      ),
    );
  }
}

/// The visible window of an [InkReveal]: from the reading edge, [fraction]
/// of the width, with generous vertical overscan so ascenders and diacritics
/// are never trimmed.
class InkRevealClipper extends CustomClipper<Rect> {
  const InkRevealClipper({required this.fraction, required this.textDirection});

  final double fraction;
  final TextDirection textDirection;

  @override
  Rect getClip(Size size) {
    final visible = size.width * fraction.clamp(0.0, 1.0);
    final left = textDirection == TextDirection.rtl
        ? size.width - visible
        : 0.0;
    return Rect.fromLTWH(left, -size.height, visible, size.height * 3);
  }

  @override
  bool shouldReclip(InkRevealClipper oldClipper) =>
      oldClipper.fraction != fraction ||
      oldClipper.textDirection != textDirection;
}

/// A line that follows an ink reveal: it fades in and rises four pixels.
/// Content only — never glass.
class FadeRise extends ConsumerStatefulWidget {
  const FadeRise({
    super.key,
    required this.child,
    this.animation,
    this.delay = AppMotion.inkFollow,
    this.duration = AppMotion.gentle,
    this.distance = 4,
  });

  final Widget child;
  final Animation<double>? animation;
  final Duration delay;
  final Duration duration;
  final double distance;

  @override
  ConsumerState<FadeRise> createState() => _FadeRiseState();
}

class _FadeRiseState extends ConsumerState<FadeRise>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _own;

  @override
  void initState() {
    super.initState();
    if (widget.animation != null) return;
    final total = widget.delay + widget.duration;
    final controller = AnimationController(vsync: this, duration: total);
    _controller = controller;
    _own = CurvedAnimation(
      parent: controller,
      curve: Interval(
        total.inMilliseconds == 0
            ? 0
            : widget.delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = _controller;
    if (controller == null ||
        controller.isAnimating ||
        controller.isCompleted) {
      return;
    }
    if (ref.read(effectiveReduceMotionProvider)) {
      controller.value = 1;
    } else {
      controller.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation ?? _own!;
    // Under Reduce Motion the line is simply there, with no wrapper at all.
    if (ref.watch(effectiveReduceMotionProvider)) return widget.child;
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.distance),
            child: child,
          ),
        );
      },
    );
  }
}
