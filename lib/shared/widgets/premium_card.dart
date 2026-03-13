import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_theme.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.surfaceAlphaOverride,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? surfaceAlphaOverride;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final surface = appearance?.surface ?? AppColors.surface;
    final accent = appearance?.accent ?? AppColors.accentGold;
    final surfaceAlpha =
        surfaceAlphaOverride ??
        appearance?.glassSurfaceAlpha ??
        AppColors.glassSurfaceAlpha;
    final borderAlpha =
        appearance?.glassBorderAlpha ?? AppColors.glassBorderAlpha;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: surface.withValues(alpha: surfaceAlpha),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(
          color: accent.withValues(alpha: borderAlpha),
          width: 1.0,
        ),
      ),
      child: child,
    );
  }
}
