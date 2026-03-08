import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/worship_tab_provider.dart';

class WorshipSegmentedControl extends StatelessWidget {
  const WorshipSegmentedControl({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final WorshipTab selected;
  final ValueChanged<WorshipTab> onChanged;

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
        children: WorshipTab.values
            .map(
              (tab) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
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
                                color: AppColors.accentGold.withValues(
                                  alpha: 0.55,
                                ),
                              )
                            : null,
                      ),
                      child: Text(
                        tab.label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: selected == tab
                              ? AppColors.onSurface
                              : AppColors.onSurfaceSubtle,
                          fontSize: 13.6,
                        ),
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
}
