import 'package:flutter/material.dart';

import '../../core/theme/app_surfaces.dart';
import 'noor_liquid_glass.dart';

class AppHeroGlassShell extends StatelessWidget {
  const AppHeroGlassShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    this.radius = 32,
    this.tintColor = const Color(0xFFE6C98F),
    this.surfaceAlphaOverride = 0.18,
    this.borderColor = const Color(0x38FFFFFF),
    this.highlightGradientColors = const [
      Color(0x1FFFFFFF),
      Colors.transparent,
      Color(0x14E8C98F),
    ],
    this.highlightGradientStops = const [0.0, 0.24, 1.0],
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color tintColor;
  final double surfaceAlphaOverride;
  final Color borderColor;
  final List<Color> highlightGradientColors;
  final List<double> highlightGradientStops;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius - 4),
        border: Border.all(color: borderColor),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: highlightGradientColors,
          stops: highlightGradientStops,
        ),
      ),
      child: child,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: NoorLiquidGlassContainer(
        spec: NoorLiquidGlassSpec.card(
          mode: NoorLiquidGlassMode.liquid,
          padding: const EdgeInsets.all(2),
          fallbackTreatment: AppSurfaceTreatment.standard,
          tintColor: tintColor,
          surfaceAlphaOverride: surfaceAlphaOverride,
          includeShadow: true,
        ).copyWith(borderRadius: radius, borderWidth: 1),
        child: content,
      ),
    );
  }
}
