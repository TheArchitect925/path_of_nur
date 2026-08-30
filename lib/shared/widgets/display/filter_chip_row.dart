import 'package:flutter/material.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_theme.dart';

class FilterChipItem<T> {
  const FilterChipItem({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// Horizontally scrolling row of selectable filter chips using the theme's
/// chip colors, so every appearance mode renders it correctly. Selecting the
/// active chip again clears the selection (reports null).
class FilterChipRow<T> extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<FilterChipItem<T>> items;
  final T? selected;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final scheme = Theme.of(context).colorScheme;
    final selectedFill = appearance?.chipSelectedFill ?? scheme.primary;
    final selectedText = appearance?.chipSelectedText ?? scheme.onPrimary;
    final unselectedFill =
        appearance?.chipUnselectedFill ?? scheme.surfaceContainerHighest;
    final unselectedText = appearance?.backgroundForeground ?? scheme.onSurface;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final item in items) ...[
            _FilterChip(
              label: item.label,
              icon: item.icon,
              isSelected: item.value == selected,
              fill: item.value == selected ? selectedFill : unselectedFill,
              foreground: item.value == selected
                  ? selectedText
                  : unselectedText,
              onTap: () =>
                  onSelected(item.value == selected ? null : item.value),
            ),
            if (item != items.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.fill,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final Color fill;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        onTap: onTap,
        child: Semantics(
          button: true,
          selected: isSelected,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 15, color: foreground),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
