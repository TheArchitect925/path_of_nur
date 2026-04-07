import 'package:flutter/material.dart';

import '../../core/theme/app_surfaces.dart';
import '../../core/theme/app_theme.dart';
import 'noor_glass_card.dart';
import 'noor_liquid_glass.dart';

class AppLayeredGlassPill extends StatelessWidget {
  const AppLayeredGlassPill({
    super.key,
    required this.child,
    this.onTap,
    this.tintColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.fillColor,
    this.borderColor,
    this.includeShadow = false,
    this.outerPadding = const EdgeInsets.all(2),
    this.innerPadding = const EdgeInsets.all(3),
    this.borderRadius = 999,
    this.expandToWidth = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? tintColor;
  final EdgeInsetsGeometry padding;
  final Color? fillColor;
  final Color? borderColor;
  final bool includeShadow;
  final EdgeInsetsGeometry outerPadding;
  final EdgeInsetsGeometry innerPadding;
  final double borderRadius;
  final bool expandToWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appearance = theme.extension<AppAppearanceTheme>();
    final tint = tintColor ?? colorScheme.primary;
    final tonalFill =
        fillColor ??
        appearance?.filledButtonFill ??
        colorScheme.secondaryContainer;
    final resolvedBorder = borderColor ?? Colors.white.withValues(alpha: 0.18);

    return NoorGlassCard(
      padding: outerPadding,
      surfaceVariant: AppSurfaceVariant.pill,
      surfaceTintColor: tint,
      surfaceAlphaOverride: 0.18,
      includeShadow: includeShadow,
      mode: NoorLiquidGlassMode.fake,
      borderRadius: borderRadius,
      width: expandToWidth ? double.infinity : null,
      child: Padding(
        padding: innerPadding,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: tonalFill.withValues(alpha: 0.58),
                border: Border.all(color: resolvedBorder),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class AppLayeredGlassPillButton extends StatelessWidget {
  const AppLayeredGlassPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tintColor,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.foregroundColor,
    this.fillColor,
    this.borderColor,
    this.expandToWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? tintColor;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final Color? foregroundColor;
  final Color? fillColor;
  final Color? borderColor;
  final bool expandToWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tonalForeground = foregroundColor ?? colorScheme.onSurface;

    return AppLayeredGlassPill(
      onTap: onPressed,
      tintColor: tintColor,
      padding: padding,
      fillColor: fillColor,
      borderColor: borderColor,
      expandToWidth: expandToWidth,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: tonalForeground,
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
