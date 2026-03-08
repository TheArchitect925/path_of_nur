import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/learn_tab_provider.dart';

class LearnSegmentedControl extends StatelessWidget {
  const LearnSegmentedControl({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final LearnTab selected;
  final ValueChanged<LearnTab> onChanged;

  String _label(AppLocalizations l10n, LearnTab tab) {
    switch (tab) {
      case LearnTab.quran:
        return l10n.learnTabQuran;
      case LearnTab.life:
        return l10n.learnTabLife;
      case LearnTab.world:
        return l10n.learnTabWorld;
      case LearnTab.hadith:
        return l10n.learnTabHadith;
      case LearnTab.notes:
        return l10n.learnTabNotes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.45)),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxs),
      child: Row(
        children: LearnTab.values
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
                      _label(l10n, tab),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: selected == tab
                                ? AppColors.onSurface
                                : AppColors.onSurfaceSubtle,
                            fontSize: 13.2,
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

