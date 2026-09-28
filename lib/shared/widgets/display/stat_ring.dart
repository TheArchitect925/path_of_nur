import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/profile/application/profile_settings_provider.dart';

/// Circular progress ring with a value label in the middle and a caption
/// underneath. Animates the sweep unless reduce-motion is on. Colors come
/// from the appearance theme so it renders correctly in all modes.
class StatRing extends ConsumerWidget {
  const StatRing({
    super.key,
    required this.value,
    required this.label,
    this.caption,
    this.size = 84,
    this.strokeWidth = 8,
    this.color,
  });

  /// Progress in [0, 1].
  final double value;

  /// Text drawn inside the ring (e.g. "23/35" or "82%").
  final String label;

  /// Small caption under the ring (e.g. "Prayers").
  final String? caption;
  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final ringColor = color ?? appearance?.accent ?? theme.colorScheme.primary;
    final clamped = value.isNaN ? 0.0 : value.clamp(0.0, 1.0);

    return Semantics(
      value: '${(clamped * 100).round()}%',
      label: caption,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: Duration(milliseconds: reduceMotion ? 0 : 600),
            curve: Curves.easeOutCubic,
            builder: (context, animated, _) => CustomPaint(
              size: Size.square(size),
              painter: _RingPainter(
                fraction: animated,
                color: ringColor,
                trackColor: ringColor.withValues(alpha: 0.16),
                strokeWidth: strokeWidth,
              ),
              child: SizedBox.square(
                dimension: size,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(strokeWidth + 4),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: 6),
            Text(
              caption!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.fraction,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double fraction;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawCircle(center, radius, track);
    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * fraction,
        false,
        arc,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}
