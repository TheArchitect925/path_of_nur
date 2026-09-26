import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_motion.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../shared/motion/motion_preferences.dart';

/// Which beads of a misbaha to light for a given count. A string holds 33
/// beads; longer targets run several loops, and a target that is not a
/// multiple of 33 leaves the last loop partly inactive.
class MisbahaLoopLayout {
  const MisbahaLoopLayout({
    required this.beadsPerLoop,
    required this.loops,
    required this.loopIndex,
    required this.filledBeads,
    required this.activeBeads,
  });

  static const int beadsPerString = 33;

  final int beadsPerLoop;
  final int loops;

  /// Zero-based loop the count is currently in.
  final int loopIndex;

  /// Beads lit in the current loop.
  final int filledBeads;

  /// Beads that can still be lit in the current loop (shorter on a partial
  /// last loop).
  final int activeBeads;

  bool get hasLoops => loops > 1;

  static MisbahaLoopLayout resolve({required int count, required int target}) {
    final safeTarget = target <= 0 ? beadsPerString : target;
    final beadsPerLoop = safeTarget < beadsPerString
        ? safeTarget
        : beadsPerString;
    final loops = (safeTarget / beadsPerLoop).ceil();
    final clamped = count.clamp(0, safeTarget);
    var loopIndex = clamped ~/ beadsPerLoop;
    if (loopIndex >= loops) loopIndex = loops - 1;
    final lastLoopBeads = safeTarget - (loops - 1) * beadsPerLoop;
    final activeBeads = loopIndex == loops - 1 ? lastLoopBeads : beadsPerLoop;
    var filled = clamped - loopIndex * beadsPerLoop;
    if (filled > activeBeads) filled = activeBeads;
    return MisbahaLoopLayout(
      beadsPerLoop: beadsPerLoop,
      loops: loops,
      loopIndex: loopIndex,
      filledBeads: filled,
      activeBeads: activeBeads,
    );
  }
}

/// The bead ring with the count in the middle. Every colour comes from the
/// active palette, so Midnight and Ramadan get their own glow. Each count
/// slides the newest bead along the string into its place.
class MisbahaRing extends ConsumerWidget {
  const MisbahaRing({
    super.key,
    required this.layout,
    required this.centerLabel,
    required this.centerCaption,
    this.size = 300,
    this.glow = 0,
  });

  final MisbahaLoopLayout layout;
  final String centerLabel;
  final String centerCaption;
  final double size;

  /// 0..1 extra glow strength, driven by the tap pulse.
  final double glow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final reduceMotion = ref.watch(effectiveReduceMotionProvider);
    // The loop index is part of the tween so a new loop starts from an
    // empty string instead of sliding 33 beads backwards.
    final beadPosition =
        layout.loopIndex * layout.beadsPerLoop + layout.filledBeads;
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: beadPosition.toDouble()),
        duration: reduceMotion ? AppMotion.instant : AppMotion.beadSlide,
        curve: AppMotion.settleCurve,
        builder: (context, animatedPosition, child) {
          final inLoop =
              animatedPosition - layout.loopIndex * layout.beadsPerLoop;
          return CustomPaint(
            painter: _MisbahaPainter(
              beads: layout.beadsPerLoop,
              filled: inLoop.clamp(0, layout.activeBeads.toDouble()),
              active: layout.activeBeads,
              accent: palette.accent,
              accentSoft: palette.accentSoft,
              glow: glow.clamp(0, 1),
            ),
            child: child,
          );
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(size * 0.18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    centerLabel,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: size * 0.29,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: palette.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                SizedBox(height: size * 0.03),
                Text(
                  centerCaption,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: palette.onSurfaceSubtle,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MisbahaPainter extends CustomPainter {
  const _MisbahaPainter({
    required this.beads,
    required this.filled,
    required this.active,
    required this.accent,
    required this.accentSoft,
    required this.glow,
  });

  final int beads;

  /// Lit beads, fractional while the newest one is still sliding into its
  /// slot from the slot before it.
  final double filled;
  final int active;
  final Color accent;
  final Color accentSoft;
  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.shortestSide / 2;
    final ringRadius = outer - 12;

    canvas.drawCircle(
      center,
      outer,
      Paint()
        ..shader = RadialGradient(
          colors: [
            accent.withValues(alpha: 0.20 + glow * 0.18),
            accent.withValues(alpha: 0.06 + glow * 0.04),
            accent.withValues(alpha: 0),
          ],
          stops: const [0, 0.7, 1],
        ).createShader(Rect.fromCircle(center: center, radius: outer)),
    );
    canvas.drawCircle(
      center,
      ringRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = accentSoft.withValues(alpha: 0.28),
    );

    if (beads <= 0) return;
    final fill = Paint()..color = accent;
    final marker = Paint()..color = accentSoft;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = accent.withValues(alpha: 0.7);
    final inactive = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = accent.withValues(alpha: 0.22);
    final beadRadius = beads > 24 ? 6.0 : 7.0;
    final settled = filled.floor();
    final sliding = filled - settled;

    double angleOf(int k) => -math.pi / 2 + 2 * math.pi * k / beads;
    Offset positionAt(double angle) => Offset(
      center.dx + ringRadius * math.cos(angle),
      center.dy + ringRadius * math.sin(angle),
    );

    for (var k = 0; k < beads; k++) {
      final position = positionAt(angleOf(k));
      if (k == 0) {
        canvas.drawCircle(position, beadRadius + 1.5, marker);
      } else if (k < settled) {
        canvas.drawCircle(position, beadRadius, fill);
      } else if (k < active) {
        canvas.drawCircle(position, beadRadius, outline);
      } else {
        canvas.drawCircle(position, beadRadius, inactive);
      }
    }

    // The newest bead, on its way from the previous slot to its own.
    if (sliding > 0 && settled >= 1 && settled < active) {
      final from = angleOf(settled - 1);
      final to = angleOf(settled);
      final angle = from + (to - from) * sliding;
      canvas.drawCircle(positionAt(angle), beadRadius, fill);
    }
  }

  @override
  bool shouldRepaint(_MisbahaPainter oldDelegate) =>
      oldDelegate.beads != beads ||
      oldDelegate.filled != filled ||
      oldDelegate.active != active ||
      oldDelegate.accent != accent ||
      oldDelegate.accentSoft != accentSoft ||
      oldDelegate.glow != glow;
}
