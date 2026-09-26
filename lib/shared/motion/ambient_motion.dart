import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_motion.dart';
import 'light_band.dart';
import 'motion_preferences.dart';

/// One ticker for all ambient life.
///
/// Placed once above the app. Every breathing or sweeping widget reads it, so
/// there is never more than one repeating animation in the tree, and it
/// stops the moment the app leaves the foreground or Reduce Motion is on.
/// Widgets that read it paint their resting frame when it is off.
class AmbientMotion extends ConsumerStatefulWidget {
  const AmbientMotion({super.key, required this.child});

  final Widget child;

  /// The 0→1 cycle over [AppMotion.ambientCycle], or null when ambient
  /// motion is off.
  static Animation<double>? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_AmbientInherited>()
      ?.animation;

  static final double _breathsPerCycle =
      AppMotion.ambientCycle.inMilliseconds / AppMotion.breath.inMilliseconds;
  static final double _passesPerCycle =
      AppMotion.ambientCycle.inMilliseconds /
      AppMotion.specularPeriod.inMilliseconds;

  /// The lantern's breath at [cycle]: 0 at rest, 1 at full glow, back to 0
  /// every [AppMotion.breath].
  static double breath(double cycle) {
    final phase = (cycle * _breathsPerCycle) % 1.0;
    return 0.5 - 0.5 * math.cos(phase * 2 * math.pi);
  }

  /// Where the light band is within its [AppMotion.specularPeriod], 0→1.
  static double specular(double cycle) => (cycle * _passesPerCycle) % 1.0;

  @override
  ConsumerState<AmbientMotion> createState() => _AmbientMotionState();
}

class _AmbientMotionState extends ConsumerState<AmbientMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.ambientCycle,
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
    return _AmbientInherited(
      animation: enabled ? _controller : null,
      child: widget.child,
    );
  }
}

class _AmbientInherited extends InheritedWidget {
  const _AmbientInherited({required this.animation, required super.child});

  final Animation<double>? animation;

  @override
  bool updateShouldNotify(_AmbientInherited oldWidget) =>
      oldWidget.animation != animation;
}

/// A halo that breathes behind [child] on the ambient cycle: the lantern at
/// startup, the fanoos in Ramadan. Off, it holds a quiet resting glow.
class BreathingGlow extends StatelessWidget {
  const BreathingGlow({
    super.key,
    required this.child,
    required this.color,
    this.maxScale = 1.03,
    this.restingBreath = 0.35,
  });

  final Widget child;
  final Color color;
  final double maxScale;

  /// The breath value painted when ambient motion is off.
  final double restingBreath;

  @override
  Widget build(BuildContext context) {
    final animation = AmbientMotion.maybeOf(context);
    // One tree shape on and off, so the child survives the ticker pausing.
    return AnimatedBuilder(
      animation: animation ?? kAlwaysCompleteAnimation,
      builder: (context, _) => _frame(
        animation == null
            ? restingBreath
            : AmbientMotion.breath(animation.value),
      ),
    );
  }

  Widget _frame(double breath) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Transform.scale(
            scale: 1.15 + 0.25 * breath,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.28 + 0.34 * breath),
                    color.withValues(alpha: 0),
                  ],
                  stops: const [0.15, 1.0],
                ),
              ),
            ),
          ),
        ),
        Transform.scale(scale: 1 + (maxScale - 1) * breath, child: child),
      ],
    );
  }
}

/// One faint band of light crossing [child] every [AppMotion.specularPeriod].
/// Hero cards only. The child paints in its own layer, so only the band
/// repaints while the ambient ticker runs.
class SpecularSweep extends StatelessWidget {
  const SpecularSweep({
    super.key,
    required this.child,
    required this.borderRadius,
    this.color = const Color(0xFFFFF6DF),
    this.strength = 0.16,
  });

  final Widget child;
  final double borderRadius;
  final Color color;
  final double strength;

  /// The band crosses during this share of the period, then rests.
  static const double travelShare = 0.22;

  @override
  Widget build(BuildContext context) {
    final animation = AmbientMotion.maybeOf(context);
    // One tree shape on and off, so the hero survives the ticker pausing.
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CustomPaint(
        foregroundPainter: _SpecularPainter(
          animation: animation ?? kAlwaysDismissedAnimation,
          color: color,
          strength: animation == null ? 0 : strength,
        ),
        child: RepaintBoundary(child: child),
      ),
    );
  }
}

class _SpecularPainter extends CustomPainter {
  _SpecularPainter({
    required this.animation,
    required this.color,
    required this.strength,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;
  final double strength;

  @override
  void paint(Canvas canvas, Size size) {
    if (strength <= 0) return;
    final phase = AmbientMotion.specular(animation.value);
    if (phase >= SpecularSweep.travelShare) return;
    LightBandPainter(
      progress: phase / SpecularSweep.travelShare,
      color: color,
      strength: strength,
    ).paint(canvas, size);
  }

  @override
  bool shouldRepaint(_SpecularPainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.color != color ||
      oldDelegate.strength != strength;
}

/// A glow that kindles around [child] while [active] and fades when it is
/// not: the hero and the strip when a prayer comes in. A state change, so it
/// runs under Reduce Motion too, just instantly.
class KindleGlow extends ConsumerWidget {
  const KindleGlow({
    super.key,
    required this.active,
    required this.child,
    required this.color,
    this.borderRadius = 24,
  });

  final bool active;
  final Widget child;
  final Color color;
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = ref.watch(effectiveReduceMotionProvider);
    return AnimatedContainer(
      duration: reduceMotion ? AppMotion.instant : AppMotion.slow,
      curve: AppMotion.settleCurve,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.42),
                  blurRadius: 46,
                  spreadRadius: 2,
                ),
                BoxShadow(color: color.withValues(alpha: 0.9), blurRadius: 0),
              ]
            : const [],
      ),
      child: child,
    );
  }
}
