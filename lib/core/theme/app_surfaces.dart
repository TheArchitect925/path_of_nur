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

@immutable
class AppSurfaceContentColors {
  const AppSurfaceContentColors({
    required this.foreground,
    required this.subtleForeground,
    required this.captionForeground,
    required this.iconColor,
  });

  final Color foreground;
  final Color subtleForeground;
  final Color captionForeground;
  final Color iconColor;

  TextTheme applyTo(TextTheme base) {
    return base.copyWith(
      displayLarge: _withColor(base.displayLarge, foreground),
      displayMedium: _withColor(base.displayMedium, foreground),
      displaySmall: _withColor(base.displaySmall, foreground),
      headlineLarge: _withColor(base.headlineLarge, foreground),
      headlineMedium: _withColor(base.headlineMedium, foreground),
      headlineSmall: _withColor(base.headlineSmall, foreground),
      titleLarge: _withColor(base.titleLarge, foreground),
      titleMedium: _withColor(base.titleMedium, foreground),
      titleSmall: _withColor(base.titleSmall, foreground),
      bodyLarge: _withColor(base.bodyLarge, foreground),
      bodyMedium: _withColor(base.bodyMedium, subtleForeground),
      bodySmall: _withColor(base.bodySmall, captionForeground),
      labelLarge: _withColor(base.labelLarge, foreground),
      labelMedium: _withColor(base.labelMedium, foreground),
      labelSmall: _withColor(base.labelSmall, captionForeground),
    );
  }

  TextStyle? _withColor(TextStyle? style, Color color) =>
      style?.copyWith(color: color);
}

class AppSurfaceTheme {
  const AppSurfaceTheme._();

  static double adaptiveAlpha(
    BuildContext context,
    double alpha, {
    double? solidAlphaWhenDisabled,
  }) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    return _adaptiveAlphaForAppearance(
      appearance,
      alpha: alpha,
      solidAlphaWhenDisabled: solidAlphaWhenDisabled,
    );
  }

  static Color adaptiveColor(
    BuildContext context,
    Color color, {
    required double alpha,
    double? solidAlphaWhenDisabled,
  }) {
    return color.withValues(
      alpha: adaptiveAlpha(
        context,
        alpha,
        solidAlphaWhenDisabled: solidAlphaWhenDisabled,
      ),
    );
  }

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
    final disableColoredGlass = appearance?.disableColoredGlass ?? false;
    final accent = resolveTintColor(
      appearance: appearance,
      tintColor: tintColor,
      surface: surface,
      disableColoredGlass: disableColoredGlass,
    );

    final resolvedSurfaceAlpha = _surfaceAlpha(
      appearance: appearance,
      variant: variant,
      disableGlass: disableGlass,
    );
    final surfaceAlpha = surfaceAlphaOverride == null
        ? resolvedSurfaceAlpha
        : _resolveSurfaceAlphaOverride(
            baseAlpha: resolvedSurfaceAlpha,
            overrideAlpha: surfaceAlphaOverride,
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
    final milkBlend = _milkBlend(
      variant,
      isDark: isDark,
      disableGlass: disableGlass,
    );
    final topHighlightBlend = _topHighlightBlend(
      variant,
      isDark: isDark,
      disableGlass: disableGlass,
    );
    final bottomAccentBlend = _bottomAccentBlend(
      variant,
      isDark: isDark,
      disableGlass: disableGlass,
    );

    final milkTone = isDark ? const Color(0xFFF1E7D8) : const Color(0xFFFEFBF6);
    final milkySurface = Color.lerp(surface, milkTone, milkBlend) ?? surface;
    final blendedSurface =
        Color.lerp(milkySurface, accent, surfaceBlend) ?? milkySurface;
    var topSurface =
        Color.lerp(blendedSurface, Colors.white, topHighlightBlend) ??
        blendedSurface;
    var bottomSurface =
        Color.lerp(blendedSurface, accent, bottomAccentBlend) ?? blendedSurface;

    if (variant == AppSurfaceVariant.panel) {
      final depthTone = isDark
          ? Colors.black
          : (appearance?.backgroundAlt ?? AppColors.backgroundAlt);
      topSurface = Color.lerp(
            topSurface,
            depthTone,
            isDark ? 0.16 : 0.12,
          ) ??
          topSurface;
      bottomSurface = Color.lerp(
            bottomSurface,
            depthTone,
            isDark ? 0.22 : 0.18,
          ) ??
          bottomSurface;
    }

    final blendedBorder =
        Color.lerp(
          Colors.white,
          accent,
          borderBlend,
        )?.withValues(alpha: borderAlpha) ??
        accent.withValues(alpha: borderAlpha);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        topSurface.withValues(
          alpha:
              (surfaceAlpha +
                      _highlightAlpha(
                        variant,
                        isDark: isDark,
                        disableGlass: disableGlass,
                      ))
                  .clamp(0.0, 1.0),
        ),
        bottomSurface.withValues(
          alpha:
              (surfaceAlpha -
                      _tintAlpha(
                        variant,
                        isDark: isDark,
                        disableGlass: disableGlass,
                      ))
                  .clamp(0.0, 1.0),
        ),
      ],
    );

    return AppSurfaceStyle(
      backgroundColor: bottomSurface.withValues(alpha: surfaceAlpha),
      borderColor: blendedBorder,
      gradient: gradient,
      shadowColor: (isDark ? Colors.black : accent).withValues(
        alpha: disableGlass ? 0.05 : 0.12,
      ),
      splashColor: accent.withValues(alpha: disableGlass ? 0.10 : 0.12),
      highlightColor: accent.withValues(alpha: disableGlass ? 0.06 : 0.07),
      iconBackgroundColor: (Color.lerp(milkTone, accent, 0.55) ?? accent)
          .withValues(alpha: disableGlass ? 0.14 : 0.20),
    );
  }

  static AppSurfaceContentColors contentColors(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    return AppSurfaceContentColors(
      foreground: appearance?.glassOnSurface ?? AppColors.onSurface,
      subtleForeground:
          appearance?.glassOnSurfaceSubtle ?? AppColors.onSurfaceSubtle,
      captionForeground:
          appearance?.glassOnSurfaceCaption ?? AppColors.onSurfaceSubtle,
      iconColor: appearance?.glassOnSurface ?? AppColors.onSurface,
    );
  }

  static Color resolveTintColor({
    required AppAppearanceTheme? appearance,
    required Color? tintColor,
    required Color surface,
    required bool disableColoredGlass,
  }) {
    if (!disableColoredGlass) {
      return tintColor ?? appearance?.accent ?? AppColors.accentGold;
    }
    final neutralBase = appearance?.surfaceSoft ?? surface;
    return Color.lerp(surface, neutralBase, 0.78) ?? neutralBase;
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
        return (base - 0.02).clamp(0.0, 1.0);
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return (base - 0.01).clamp(0.0, 1.0);
      case AppSurfaceVariant.panel:
        return 0.50;
      case AppSurfaceVariant.card:
        return base;
    }
  }

  static double _resolveSurfaceAlphaOverride({
    required double baseAlpha,
    required double overrideAlpha,
    required bool disableGlass,
  }) {
    final appearance = AppAppearanceTheme.defaults(
      mode: AppThemeMode.defaultMode,
      disableGlassTransparency: disableGlass,
      disableColoredGlass: false,
      disableBackground: false,
      glassSurfaceAlpha: baseAlpha,
    );
    return _adaptiveAlphaForAppearance(appearance, alpha: overrideAlpha);
  }

  static double _adaptiveAlphaForAppearance(
    AppAppearanceTheme? appearance, {
    required double alpha,
    double? solidAlphaWhenDisabled,
  }) {
    final clampedAlpha = alpha.clamp(0.0, 1.0);
    final disableGlass = appearance?.disableGlassTransparency ?? false;
    if (disableGlass) {
      return (solidAlphaWhenDisabled ?? clampedAlpha).clamp(0.0, 1.0);
    }
    final base = appearance?.glassSurfaceAlpha ?? AppColors.glassSurfaceAlpha;
    return (base + (clampedAlpha - AppColors.glassSurfaceAlpha)).clamp(
      0.0,
      1.0,
    );
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
        return (base + 0.03).clamp(0.0, 1.0);
      case AppSurfaceVariant.navigationBar:
        return (base + 0.03).clamp(0.0, 1.0);
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return (base + 0.05).clamp(0.0, 1.0);
      case AppSurfaceVariant.panel:
        return (base + 0.08).clamp(0.0, 1.0);
      case AppSurfaceVariant.card:
        return (base + 0.02).clamp(0.0, 1.0);
    }
  }

  static double _surfaceBlend(
    AppSurfaceVariant variant, {
    required bool disableGlass,
  }) {
    switch (variant) {
      case AppSurfaceVariant.pill:
        return disableGlass ? 0.08 : 0.07;
      case AppSurfaceVariant.navigationBar:
        return disableGlass ? 0.09 : 0.08;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return disableGlass ? 0.12 : 0.09;
      case AppSurfaceVariant.panel:
        return disableGlass ? 0.14 : 0.11;
      case AppSurfaceVariant.card:
        return disableGlass ? 0.10 : 0.07;
    }
  }

  static double _borderBlend(AppSurfaceVariant variant) {
    switch (variant) {
      case AppSurfaceVariant.pill:
        return 0.60;
      case AppSurfaceVariant.navigationBar:
        return 0.56;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return 0.68;
      case AppSurfaceVariant.panel:
        return 0.70;
      case AppSurfaceVariant.card:
        return 0.64;
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
        return isDark ? 0.04 : 0.08;
      case AppSurfaceVariant.navigationBar:
        return isDark ? 0.03 : 0.07;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return isDark ? 0.05 : 0.10;
      case AppSurfaceVariant.panel:
        return isDark ? 0.03 : 0.06;
      case AppSurfaceVariant.card:
        return isDark ? 0.04 : 0.08;
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
        return isDark ? 0.02 : 0.03;
      case AppSurfaceVariant.navigationBar:
        return isDark ? 0.015 : 0.025;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return isDark ? 0.025 : 0.04;
      case AppSurfaceVariant.panel:
        return isDark ? 0.015 : 0.025;
      case AppSurfaceVariant.card:
        return isDark ? 0.02 : 0.03;
    }
  }

  static double _milkBlend(
    AppSurfaceVariant variant, {
    required bool isDark,
    required bool disableGlass,
  }) {
    if (disableGlass) {
      return isDark ? 0.04 : 0.06;
    }
    switch (variant) {
      case AppSurfaceVariant.pill:
        return isDark ? 0.18 : 0.24;
      case AppSurfaceVariant.navigationBar:
        return isDark ? 0.16 : 0.22;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return isDark ? 0.20 : 0.28;
      case AppSurfaceVariant.panel:
        return isDark ? 0.15 : 0.18;
      case AppSurfaceVariant.card:
        return isDark ? 0.19 : 0.26;
    }
  }

  static double _topHighlightBlend(
    AppSurfaceVariant variant, {
    required bool isDark,
    required bool disableGlass,
  }) {
    if (disableGlass) {
      return isDark ? 0.04 : 0.08;
    }
    switch (variant) {
      case AppSurfaceVariant.pill:
        return isDark ? 0.12 : 0.18;
      case AppSurfaceVariant.navigationBar:
        return isDark ? 0.10 : 0.16;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return isDark ? 0.14 : 0.20;
      case AppSurfaceVariant.panel:
        return isDark ? 0.10 : 0.14;
      case AppSurfaceVariant.card:
        return isDark ? 0.13 : 0.18;
    }
  }

  static double _bottomAccentBlend(
    AppSurfaceVariant variant, {
    required bool isDark,
    required bool disableGlass,
  }) {
    if (disableGlass) {
      return isDark ? 0.03 : 0.05;
    }
    switch (variant) {
      case AppSurfaceVariant.pill:
        return isDark ? 0.02 : 0.04;
      case AppSurfaceVariant.navigationBar:
        return isDark ? 0.015 : 0.03;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return isDark ? 0.03 : 0.05;
      case AppSurfaceVariant.panel:
        return isDark ? 0.015 : 0.028;
      case AppSurfaceVariant.card:
        return isDark ? 0.025 : 0.04;
    }
  }
}
