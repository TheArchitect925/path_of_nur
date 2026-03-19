import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme.dart';

enum AppSurfaceVariant { card, island, pill, panel, featureTile, navigationBar }

@immutable
class AppSurfaceStyle {
  const AppSurfaceStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.gradient,
    required this.shadowColor,
    required this.splashColor,
    required this.highlightColor,
    required this.iconBackgroundColor,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Gradient gradient;
  final Color shadowColor;
  final Color splashColor;
  final Color highlightColor;
  final Color iconBackgroundColor;

  BoxDecoration decoration({
    required double radius,
    double borderWidth = 1,
    bool includeShadow = false,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: includeShadow
          ? <BoxShadow>[
              BoxShadow(
                color: shadowColor,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ]
          : null,
    );
  }
}

class AppSurfaceTheme {
  const AppSurfaceTheme._();

  static AppSurfaceStyle resolve(
    BuildContext context, {
    AppSurfaceVariant variant = AppSurfaceVariant.card,
    Color? tintColor,
    Color? baseColor,
    double? surfaceAlphaOverride,
    double? borderAlphaOverride,
  }) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isDark = appearance?.isDark ?? false;
    final disableGlass = appearance?.disableGlassTransparency ?? false;
    final surface = baseColor ?? appearance?.surface ?? AppColors.surface;
    final accent = tintColor ?? appearance?.accent ?? AppColors.accentGold;
    final accentSoft = appearance?.accentSoft ?? AppColors.accentGoldSoft;

    final surfaceAlpha =
        surfaceAlphaOverride ??
        _surfaceAlpha(
          appearance: appearance,
          variant: variant,
          disableGlass: disableGlass,
        );
    final borderAlpha =
        borderAlphaOverride ??
        _borderAlpha(
          appearance: appearance,
          variant: variant,
          disableGlass: disableGlass,
        );

    final surfaceBlend = _surfaceBlend(variant, disableGlass: disableGlass);
    final borderBlend = _borderBlend(variant);

    final blendedSurface =
        Color.lerp(
          surface,
          accent,
          surfaceBlend,
        )?.withValues(alpha: surfaceAlpha) ??
        surface.withValues(alpha: surfaceAlpha);
    final blendedBorder =
        Color.lerp(
          accentSoft,
          accent,
          borderBlend,
        )?.withValues(alpha: borderAlpha) ??
        accent.withValues(alpha: borderAlpha);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Colors.white.withValues(
          alpha: _highlightAlpha(
            variant,
            isDark: isDark,
            disableGlass: disableGlass,
          ),
        ),
        accent.withValues(
          alpha: _tintAlpha(
            variant,
            isDark: isDark,
            disableGlass: disableGlass,
          ),
        ),
      ],
    );

    return AppSurfaceStyle(
      backgroundColor: blendedSurface,
      borderColor: blendedBorder,
      gradient: gradient,
      shadowColor: (isDark ? Colors.black : accent).withValues(
        alpha: disableGlass ? 0.05 : 0.10,
      ),
      splashColor: accent.withValues(alpha: disableGlass ? 0.10 : 0.14),
      highlightColor: accent.withValues(alpha: disableGlass ? 0.06 : 0.08),
      iconBackgroundColor: accent.withValues(alpha: disableGlass ? 0.12 : 0.16),
    );
  }

  static double _surfaceAlpha({
    required AppAppearanceTheme? appearance,
    required AppSurfaceVariant variant,
    required bool disableGlass,
  }) {
    if (disableGlass) {
      switch (variant) {
        case AppSurfaceVariant.pill:
          return 0.98;
        case AppSurfaceVariant.navigationBar:
          return 0.96;
        case AppSurfaceVariant.island:
        case AppSurfaceVariant.featureTile:
        case AppSurfaceVariant.panel:
        case AppSurfaceVariant.card:
          return 0.97;
      }
    }

    final base = appearance?.glassSurfaceAlpha ?? AppColors.glassSurfaceAlpha;
    switch (variant) {
      case AppSurfaceVariant.pill:
        return (base + 0.04).clamp(0.0, 1.0);
      case AppSurfaceVariant.navigationBar:
        return (base - 0.06).clamp(0.0, 1.0);
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return (base - 0.02).clamp(0.0, 1.0);
      case AppSurfaceVariant.panel:
      case AppSurfaceVariant.card:
        return base;
    }
  }

  static double _borderAlpha({
    required AppAppearanceTheme? appearance,
    required AppSurfaceVariant variant,
    required bool disableGlass,
  }) {
    final base = appearance?.glassBorderAlpha ?? AppColors.glassBorderAlpha;
    if (disableGlass) {
      return (base + 0.10).clamp(0.0, 1.0);
    }
    switch (variant) {
      case AppSurfaceVariant.pill:
        return (base + 0.04).clamp(0.0, 1.0);
      case AppSurfaceVariant.navigationBar:
        return (base + 0.02).clamp(0.0, 1.0);
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return (base + 0.03).clamp(0.0, 1.0);
      case AppSurfaceVariant.panel:
      case AppSurfaceVariant.card:
        return base;
    }
  }

  static double _surfaceBlend(
    AppSurfaceVariant variant, {
    required bool disableGlass,
  }) {
    switch (variant) {
      case AppSurfaceVariant.pill:
        return disableGlass ? 0.08 : 0.06;
      case AppSurfaceVariant.navigationBar:
        return disableGlass ? 0.09 : 0.07;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return disableGlass ? 0.12 : 0.10;
      case AppSurfaceVariant.panel:
      case AppSurfaceVariant.card:
        return disableGlass ? 0.10 : 0.08;
    }
  }

  static double _borderBlend(AppSurfaceVariant variant) {
    switch (variant) {
      case AppSurfaceVariant.pill:
        return 0.55;
      case AppSurfaceVariant.navigationBar:
        return 0.52;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return 0.62;
      case AppSurfaceVariant.panel:
      case AppSurfaceVariant.card:
        return 0.58;
    }
  }

  static double _highlightAlpha(
    AppSurfaceVariant variant, {
    required bool isDark,
    required bool disableGlass,
  }) {
    if (disableGlass) {
      return isDark ? 0.03 : 0.08;
    }
    switch (variant) {
      case AppSurfaceVariant.pill:
        return isDark ? 0.05 : 0.16;
      case AppSurfaceVariant.navigationBar:
        return isDark ? 0.04 : 0.14;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return isDark ? 0.06 : 0.18;
      case AppSurfaceVariant.panel:
      case AppSurfaceVariant.card:
        return isDark ? 0.05 : 0.14;
    }
  }

  static double _tintAlpha(
    AppSurfaceVariant variant, {
    required bool isDark,
    required bool disableGlass,
  }) {
    if (disableGlass) {
      return isDark ? 0.02 : 0.05;
    }
    switch (variant) {
      case AppSurfaceVariant.pill:
        return isDark ? 0.05 : 0.08;
      case AppSurfaceVariant.navigationBar:
        return isDark ? 0.04 : 0.06;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return isDark ? 0.06 : 0.09;
      case AppSurfaceVariant.panel:
      case AppSurfaceVariant.card:
        return isDark ? 0.05 : 0.07;
    }
  }
}
