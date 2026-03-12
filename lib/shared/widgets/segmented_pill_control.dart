import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class SegmentedPillControl<T> extends StatelessWidget {
  const SegmentedPillControl({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.labelBuilder,
    required this.onChanged,
  });

  final List<T> items;
  final T selectedItem;
  final String Function(T item) labelBuilder;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final surface = appearance?.surface ?? AppColors.surface;
    final accent = appearance?.accent ?? AppColors.accentGold;
    final onSurface = appearance?.onSurface ?? AppColors.onSurface;
    final onSurfaceSubtle =
        appearance?.onSurfaceSubtle ?? AppColors.onSurfaceSubtle;
    final borderAlpha =
        appearance?.glassBorderAlpha ?? AppColors.glassBorderAlpha;
    final surfaceAlpha =
        appearance?.glassSurfaceAlpha ?? AppColors.glassSurfaceAlpha;

    return Container(
      decoration: BoxDecoration(
        color: surface.withValues(alpha: surfaceAlpha),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: borderAlpha)),
      ),
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: InkWell(
                    onTap: () => onChanged(item),
                    borderRadius: BorderRadius.circular(999),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 170),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: selectedItem == item
                            ? accent.withValues(alpha: 0.28)
                            : Colors.transparent,
                        border: selectedItem == item
                            ? Border.all(color: accent.withValues(alpha: 0.55))
                            : null,
                      ),
                      child: Text(
                        labelBuilder(item),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          color: selectedItem == item
                              ? onSurface
                              : onSurfaceSubtle,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}
