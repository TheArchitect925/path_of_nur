import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../application/worship_tab_provider.dart';

class WorshipSegmentedControl extends ConsumerWidget {
  const WorshipSegmentedControl({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const double _surfaceAlpha = 0.9;

  final WorshipTab selected;
  final ValueChanged<WorshipTab> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: _surfaceAlpha),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.55)),
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
                            ? AppColors.accentGold.withValues(alpha: 0.40)
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
                        _localizedTabLabel(tab, l10n, isKidsMode),
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

  String _localizedTabLabel(
    WorshipTab tab,
    AppLocalizations l10n,
    bool isKidsMode,
  ) {
    return switch (tab) {
      WorshipTab.prayer =>
        isKidsMode ? l10n.kidsWorshipTabPrayer : l10n.worshipPrayerTabTimes,
      WorshipTab.dhikr => isKidsMode ? l10n.kidsWorshipTabDhikr : tab.label,
      WorshipTab.fasting => isKidsMode ? l10n.kidsWorshipTabFasting : tab.label,
      WorshipTab.khusu => isKidsMode ? l10n.kidsWorshipTabKhusu : tab.label,
    };
  }
}
