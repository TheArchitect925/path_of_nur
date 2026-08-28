import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Thin rounded progress bar drawing its colors from the appearance theme,
/// intended as the drop-in replacement for bare [LinearProgressIndicator]s
/// on glass surfaces.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color,
    this.backgroundColor,
  });

  /// Progress in [0, 1].
  final double value;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final fill = color ?? appearance?.accent ?? Theme.of(context).colorScheme.primary;
    final track =
        backgroundColor ??
        fill.withValues(alpha: 0.18);
    final clamped = value.isNaN ? 0.0 : value.clamp(0.0, 1.0);

    return Semantics(
      value: '${(clamped * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(color: track),
                FractionallySizedBox(
                  widthFactor: clamped,
                  child: Container(color: fill),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
