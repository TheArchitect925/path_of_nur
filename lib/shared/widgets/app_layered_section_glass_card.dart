import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import '../../core/theme/app_surfaces.dart';
import 'app_hero_glass_shell.dart';

class AppLayeredSectionGlassCard extends StatelessWidget {
  const AppLayeredSectionGlassCard({
    super.key,
    required this.child,
    this.contentPadding = const EdgeInsets.all(16),
    this.outerRadius = 32,
    this.innerRadius = AppRadii.card,
    this.surfaceVariant = AppSurfaceVariant.card,
    this.surfaceTreatment = AppSurfaceTreatment.standard,
    this.surfaceTintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = true,
    this.width = double.infinity,
  });

  final Widget child;
  final EdgeInsetsGeometry contentPadding;
  final double outerRadius;
  final double innerRadius;
  final AppSurfaceVariant surfaceVariant;
  final AppSurfaceTreatment surfaceTreatment;
  final Color? surfaceTintColor;
  final double? surfaceAlphaOverride;
  final bool includeShadow;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AppHeroGlassShell(
        padding: contentPadding,
        tintColor: AppHeroGlassShell.globalCardTintColor,
        surfaceAlphaOverride: AppHeroGlassShell.globalCardSurfaceAlpha,
        radius: AppHeroGlassShell.globalCardRadius,
        borderColor: AppHeroGlassShell.globalCardBorderColor,
        highlightGradientColors:
            AppHeroGlassShell.globalCardHighlightGradientColors,
        child: Theme(
          data: Theme.of(context).copyWith(),
          child: DefaultTextStyle.merge(child: child),
        ),
      ),
    );
  }
}
