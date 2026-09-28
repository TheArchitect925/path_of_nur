import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// GitHub-style activity heatmap. Takes one value per day (oldest first)
/// and renders columns of seven days, coloring each cell by intensity
/// relative to the strongest day in the window. Uses accent-alpha steps
/// from the appearance theme — no hardcoded palette.
class ActivityHeatmap extends StatelessWidget {
  const ActivityHeatmap({
    super.key,
    required this.values,
    this.cellSize = 14,
    this.cellGap = 3,
  });

  /// Daily intensity values (any non-negative scale), oldest first.
  final List<double> values;
  final double cellSize;
  final double cellGap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    final empty = accent.withValues(alpha: 0.10);
    final max = values.fold<double>(0, (acc, v) => v > acc ? v : acc);

    Color cellColor(double value) {
      if (value <= 0 || max <= 0) return empty;
      final fraction = (value / max).clamp(0.0, 1.0);
      if (fraction < 0.25) return accent.withValues(alpha: 0.30);
      if (fraction < 0.5) return accent.withValues(alpha: 0.50);
      if (fraction < 0.75) return accent.withValues(alpha: 0.72);
      return accent;
    }

    final weekCount = (values.length / 7).ceil();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var week = 0; week < weekCount; week++) ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var day = 0; day < 7; day++) ...[
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: week * 7 + day < values.length
                          ? cellColor(values[week * 7 + day])
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(cellSize / 4),
                    ),
                  ),
                  if (day < 6) SizedBox(height: cellGap),
                ],
              ],
            ),
            if (week < weekCount - 1) SizedBox(width: cellGap),
          ],
        ],
      ),
    );
  }
}
