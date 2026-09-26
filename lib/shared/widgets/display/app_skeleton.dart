import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_palette.dart';
import '../../motion/motion_preferences.dart';
import '../premium_card.dart';

/// Content-shaped placeholders in the surface's own ink, with a light sweep
/// while data is on its way. Each block has the shape of the content it
/// stands in for, so nothing jumps when the data lands.
///
/// The sweep runs only while the app is in the foreground and never under
/// Reduce Motion; then the blocks are simply still. The first Skeleton in a
/// subtree hosts the one controller the rest read.
class SkeletonSweep extends ConsumerStatefulWidget {
  const SkeletonSweep({super.key, required this.child});

  final Widget child;

  static Animation<double>? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_SkeletonSweepInherited>()
      ?.animation;

  @override
  ConsumerState<SkeletonSweep> createState() => _SkeletonSweepState();
}

class _SkeletonSweepState extends ConsumerState<SkeletonSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.shimmerPeriod,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(continuousMotionProvider);
    if (enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!enabled && _controller.isAnimating) {
      _controller.stop();
    }
    return _SkeletonSweepInherited(
      animation: enabled ? _controller : null,
      child: widget.child,
    );
  }
}

class _SkeletonSweepInherited extends InheritedWidget {
  const _SkeletonSweepInherited({
    required this.animation,
    required super.child,
  });

  final Animation<double>? animation;

  @override
  bool updateShouldNotify(_SkeletonSweepInherited oldWidget) =>
      oldWidget.animation != animation;
}

/// Hosts a sweep when none is above, so a lone block still sweeps.
class _SkeletonHost extends StatelessWidget {
  const _SkeletonHost({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (context.getInheritedWidgetOfExactType<_SkeletonSweepInherited>() !=
        null) {
      return child;
    }
    return SkeletonSweep(child: child);
  }
}

/// One rounded block of ink.
class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({
    super.key,
    this.width,
    this.widthFactor,
    this.height = 12,
    this.radius = 8,
    this.alignment = AlignmentDirectional.centerStart,
  });

  /// Absolute width; null with [widthFactor] null fills the line.
  final double? width;

  /// Fraction of the available width.
  final double? widthFactor;
  final double height;
  final double radius;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final ink = context.palette.onSurface;
    Widget block = _SkeletonHost(
      child: Builder(
        builder: (context) {
          final animation = SkeletonSweep.maybeOf(context);
          Widget paint(double phase) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  ink.withValues(alpha: 0.12),
                  ink.withValues(alpha: 0.12),
                  ink.withValues(alpha: 0.22),
                  ink.withValues(alpha: 0.12),
                  ink.withValues(alpha: 0.12),
                ],
                stops: [
                  0,
                  (phase - 0.25).clamp(0.0, 1.0),
                  phase.clamp(0.0, 1.0),
                  (phase + 0.25).clamp(0.0, 1.0),
                  1,
                ],
              ),
            ),
            child: SizedBox(height: height, width: double.infinity),
          );
          return AnimatedBuilder(
            animation: animation ?? kAlwaysDismissedAnimation,
            // The highlight travels from off the left to off the right.
            builder: (context, _) =>
                paint(animation == null ? -1 : animation.value * 1.8 - 0.4),
          );
        },
      ),
    );
    if (width != null) {
      block = SizedBox(width: width, child: block);
    } else if (widthFactor != null) {
      block = FractionallySizedBox(
        widthFactor: widthFactor,
        alignment: alignment,
        child: block,
      );
    }
    return block;
  }
}

/// A title line and a few body lines, the shape of a short paragraph.
class SkeletonParagraph extends StatelessWidget {
  const SkeletonParagraph({
    super.key,
    this.title = true,
    this.lines = const [1.0, 0.82, 0.55],
    this.lineHeight = 12,
    this.gap = 8,
  });

  final bool title;
  final List<double> lines;
  final double lineHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SkeletonSweep(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title) ...[
            const SkeletonBlock(widthFactor: 0.38, height: 15),
            SizedBox(height: gap + 4),
          ],
          for (var i = 0; i < lines.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            SkeletonBlock(widthFactor: lines[i], height: lineHeight),
          ],
        ],
      ),
    );
  }
}

/// A row with a leading square and two lines, the shape of a list tile.
class SkeletonRow extends StatelessWidget {
  const SkeletonRow({super.key, this.leadingSize = 34});

  final double leadingSize;

  @override
  Widget build(BuildContext context) {
    return SkeletonSweep(
      child: Row(
        children: [
          SkeletonBlock(
            width: leadingSize,
            height: leadingSize,
            radius: leadingSize * 0.35,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBlock(widthFactor: 0.6, height: 13),
                SizedBox(height: 7),
                SkeletonBlock(widthFactor: 0.85, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A glass card holding a [SkeletonParagraph]: the stand-in for any page
/// section that used to show a spinner.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.density = PremiumCardDensity.compact,
    this.lines = const [1.0, 0.82, 0.55],
    this.title = true,
  });

  final PremiumCardDensity density;
  final List<double> lines;
  final bool title;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      density: density,
      child: SkeletonParagraph(title: title, lines: lines),
    );
  }
}
