import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import '../../core/theme/app_surfaces.dart';
import 'noor_glass_card.dart';
import 'noor_liquid_glass.dart';

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
    if (surfaceTreatment == AppSurfaceTreatment.denseSanctuary) {
      return NoorGlassCard(
        padding: contentPadding,
        surfaceVariant: surfaceVariant,
        surfaceTreatment: surfaceTreatment,
        surfaceTintColor: surfaceTintColor,
        surfaceAlphaOverride: surfaceAlphaOverride,
        includeShadow: includeShadow,
        mode: NoorLiquidGlassMode.fake,
        borderRadius: innerRadius,
        width: width,
        child: child,
      );
    }

    final innerTint = surfaceTintColor ?? const Color(0xFFE6B85F);
    final innerAlpha = surfaceAlphaOverride ?? 0.32;

    return NoorGlassCard(
      padding: const EdgeInsets.all(2),
      surfaceVariant: AppSurfaceVariant.card,
      surfaceTreatment: AppSurfaceTreatment.standard,
      surfaceTintColor: const Color(0xFFE6C98F),
      surfaceAlphaOverride: 0.18,
      includeShadow: includeShadow,
      mode: NoorLiquidGlassMode.fake,
      borderRadius: outerRadius,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(outerRadius - 2),
          border: Border.all(color: const Color(0x24C8943F)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              const Color(0x08FFF7E8),
              Colors.transparent,
              const Color(0x12E8C98F),
            ],
            stops: const [0.0, 0.18, 1.0],
          ),
        ),
        child: SizedBox(
          width: width,
          child: NoorGlassCard(
            padding: const EdgeInsets.all(2),
            surfaceVariant: surfaceVariant,
            surfaceTreatment: surfaceTreatment,
            surfaceTintColor: innerTint,
            surfaceAlphaOverride: innerAlpha,
            includeShadow: false,
            mode: NoorLiquidGlassMode.fake,
            borderRadius: innerRadius + 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(innerRadius + 2),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.02),
                    const Color(0xFFE7B965).withValues(alpha: 0.06),
                    const Color(0xFFC8943F).withValues(alpha: 0.12),
                  ],
                  stops: const [0.0, 0.62, 1.0],
                ),
                border: Border.all(
                  color: const Color(0xFFC8943F).withValues(alpha: 0.42),
                ),
              ),
              child: Padding(padding: contentPadding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
