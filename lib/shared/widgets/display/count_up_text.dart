import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_motion.dart';
import '../../motion/motion_preferences.dart';

/// A number that counts to its value when it arrives and glides to each new
/// value after that. Tabular figures, so the width holds still.
class CountUpText extends ConsumerWidget {
  const CountUpText(
    this.value, {
    super.key,
    this.style,
    this.textAlign,
    this.format,
    this.fromZero = true,
    this.maxLines,
    this.overflow,
  });

  final num value;
  final TextStyle? style;
  final TextAlign? textAlign;

  /// How to print a value on the way (defaults to the rounded integer).
  final String Function(num value)? format;

  /// Count up from zero on first build; false starts at the value.
  final bool fromZero;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = ref.watch(effectiveReduceMotionProvider);
    final target = value.toDouble();
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: fromZero ? 0 : target, end: target),
      duration: reduceMotion ? AppMotion.instant : AppMotion.countUp,
      curve: AppMotion.settleCurve,
      builder: (context, animated, _) {
        final shown = format?.call(animated.round()) ?? '${animated.round()}';
        return Text(
          shown,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: (style ?? const TextStyle()).copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );
      },
    );
  }
}
