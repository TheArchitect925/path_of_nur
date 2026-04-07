import 'package:flutter/material.dart';

import '../../core/theme/app_surfaces.dart';
import 'noor_liquid_glass.dart';

class AppHeroGlassShell extends StatelessWidget {
  static const EdgeInsetsGeometry globalCardPadding = EdgeInsets.symmetric(
    horizontal: 28,
    vertical: 30,
  );
  static const double globalCardRadius = 36;
  static const Color globalCardTintColor = Color(0xFFE7C98C);
  static const double globalCardSurfaceAlpha = 0.2;
  static const Color globalCardBorderColor = Color(0x42FFFFFF);
  static const List<Color> globalCardHighlightGradientColors = [
    Color(0x24FFFFFF),
    Colors.transparent,
    Color(0x16E8C98F),
  ];
  static const List<double> globalCardHighlightGradientStops = [0.0, 0.24, 1.0];

  const AppHeroGlassShell({
    super.key,
    required this.child,
    this.padding = globalCardPadding,
    this.radius = globalCardRadius,
    this.tintColor = globalCardTintColor,
    this.surfaceAlphaOverride = globalCardSurfaceAlpha,
    this.borderColor = globalCardBorderColor,
    this.highlightGradientColors = globalCardHighlightGradientColors,
    this.highlightGradientStops = globalCardHighlightGradientStops,
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
    final glass = NoorLiquidGlassContainer(
      spec: NoorLiquidGlassSpec.card(
        mode: NoorLiquidGlassMode.liquid,
        padding: padding,
        fallbackTreatment: AppSurfaceTreatment.standard,
        tintColor: tintColor,
        surfaceAlphaOverride: surfaceAlphaOverride,
        includeShadow: true,
        borderColor: borderColor,
        highlightGradientColors: highlightGradientColors,
        highlightGradientStops: highlightGradientStops,
      ).copyWith(borderRadius: radius, borderWidth: 1),
      child: child,
    );

    if (onTap == null) {
      return glass;
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: glass,
      ),
    );
  }
}
