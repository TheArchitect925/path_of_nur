import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/growth_models.dart';

class GrowthSegmentedControl extends StatelessWidget {
  const GrowthSegmentedControl({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final GrowthInternalTab selected;
  final ValueChanged<GrowthInternalTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.45)),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxs),
      child: Row(
        children: GrowthInternalTab.values
            .map(
              (tab) => Expanded(
                child: InkWell(
                  onTap: () => onChanged(tab),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      color: selected == tab
                          ? AppColors.accentGold.withValues(alpha: 0.30)
                          : Colors.transparent,
                      border: selected == tab
                          ? Border.all(
                              color: AppColors.accentGold.withValues(alpha: 0.55),
                            )
                          : null,
                    ),
                    child: Text(
                      _label(tab),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: selected == tab
                            ? AppColors.onSurface
                            : AppColors.onSurfaceSubtle,
                        fontSize: 12.6,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _label(GrowthInternalTab tab) {
    switch (tab) {
      case GrowthInternalTab.today:
        return 'Today';
      case GrowthInternalTab.paths:
        return 'Paths';
      case GrowthInternalTab.habits:
        return 'Habits';
      case GrowthInternalTab.journey:
        return 'Journey';
      case GrowthInternalTab.reflection:
        return 'Reflection';
    }
  }
}
