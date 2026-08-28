import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Right-edge fast-scroll rail for long uniform collections. Renders the
/// given labels vertically; tapping or dragging reports the nearest label's
/// index so the host page can jump its scroll position.
class IndexRail extends StatefulWidget {
  const IndexRail({
    super.key,
    required this.labels,
    required this.onSelected,
    this.width = 26,
  });

  final List<String> labels;
  final ValueChanged<int> onSelected;
  final double width;

  @override
  State<IndexRail> createState() => _IndexRailState();
}

class _IndexRailState extends State<IndexRail> {
  int? _activeIndex;

  void _handlePosition(double dy, double height) {
    if (widget.labels.isEmpty || height <= 0) return;
    final fraction = (dy / height).clamp(0.0, 1.0);
    final index = (fraction * widget.labels.length)
        .floor()
        .clamp(0, widget.labels.length - 1);
    if (index != _activeIndex) {
      setState(() => _activeIndex = index);
      widget.onSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground =
        appearance?.backgroundForegroundSubtle ??
        Theme.of(context).colorScheme.onSurfaceVariant;
    final activeColor =
        appearance?.accent ?? Theme.of(context).colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) =>
              _handlePosition(details.localPosition.dy, height),
          onVerticalDragUpdate: (details) =>
              _handlePosition(details.localPosition.dy, height),
          onVerticalDragEnd: (_) => setState(() => _activeIndex = null),
          onTapUp: (_) => setState(() => _activeIndex = null),
          child: SizedBox(
            width: widget.width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < widget.labels.length; i++)
                  Text(
                    widget.labels[i],
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 10,
                      height: 1,
                      color: i == _activeIndex ? activeColor : foreground,
                      fontWeight: i == _activeIndex
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
