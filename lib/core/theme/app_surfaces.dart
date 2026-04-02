import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme.dart';

enum AppSurfaceVariant { card, island, pill, panel, featureTile, navigationBar }

enum AppSurfaceTreatment { standard, homepageWarmGlass, denseSanctuary }

@immutable
class AppSurfaceStyle {
  const AppSurfaceStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.gradient,
    required this.shadowColor,
    required this.boxShadows,
    required this.splashColor,
    required this.highlightColor,
    required this.iconBackgroundColor,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Gradient gradient;
  final Color shadowColor;
  final List<BoxShadow> boxShadows;
  final Color splashColor;
  final Color highlightColor;
  final Color iconBackgroundColor;

  BoxDecoration decoration({
    required double radius,
    double borderWidth = 1,
    bool includeShadow = true,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: includeShadow ? boxShadows : null,
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
    AppSurfaceTreatment treatment = AppSurfaceTreatment.standard,
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

    final baseSurfaceAlpha = _surfaceAlpha(
      appearance: appearance,
      variant: variant,
      disableGlass: disableGlass,
    );
    final baseBorderAlpha =
        borderAlphaOverride ??
        _borderAlpha(
          appearance: appearance,
          variant: variant,
          disableGlass: disableGlass,
        );

    var surfaceAlpha = surfaceAlphaOverride == null
        ? baseSurfaceAlpha
        : _resolveSurfaceAlphaOverride(
            baseAlpha: baseSurfaceAlpha,
            overrideAlpha: surfaceAlphaOverride,
            disableGlass: disableGlass,
          );
    var borderAlpha = baseBorderAlpha;
    var surfaceBlend = _surfaceBlend(variant, disableGlass: disableGlass);
    var borderBlend = _borderBlend(variant);
    var milkBlend = _milkBlend(
      variant,
      isDark: isDark,
      disableGlass: disableGlass,
    );
    var topHighlightBlend = _topHighlightBlend(
      variant,
      isDark: isDark,
      disableGlass: disableGlass,
    );
    var bottomAccentBlend = _bottomAccentBlend(
      variant,
      isDark: isDark,
      disableGlass: disableGlass,
    );
    var tintAlpha = _tintAlpha(
      variant,
      isDark: isDark,
      disableGlass: disableGlass,
    );

    final frostedTone =
        appearance?.frostedGlassTone ??
        (isDark ? const Color(0xFFF1E7D8) : const Color(0xFFFEFBF6));
    final sanctuaryTone =
        appearance?.sanctuarySurfaceTone ??
        (isDark ? const Color(0xFFEADFC6) : const Color(0xFFF9F0DF));
    final sanctuaryEdgeLight =
        appearance?.sanctuaryEdgeLight ?? const Color(0xFFF6E3B7);
    var milkTone = frostedTone;

    switch (treatment) {
      case AppSurfaceTreatment.standard:
        surfaceAlpha =
            (surfaceAlpha +
                    (disableGlass
                        ? 0.0
                        : variant == AppSurfaceVariant.panel
                        ? 0.05
                        : 0.04))
                .clamp(0.0, 1.0);
        borderAlpha = (borderAlpha + (isDark ? 0.03 : 0.05)).clamp(0.0, 1.0);
        surfaceBlend = (surfaceBlend + (disableColoredGlass ? 0.01 : 0.03))
            .clamp(0.0, 1.0);
        milkBlend = (milkBlend + (isDark ? 0.08 : 0.14)).clamp(0.0, 1.0);
        topHighlightBlend = (topHighlightBlend + (isDark ? 0.04 : 0.07)).clamp(
          0.0,
          1.0,
        );
        bottomAccentBlend = (bottomAccentBlend + 0.018).clamp(0.0, 1.0);
        tintAlpha = (tintAlpha - (isDark ? 0.008 : 0.014)).clamp(0.0, 1.0);
        break;
      case AppSurfaceTreatment.homepageWarmGlass:
        milkTone =
            Color.lerp(frostedTone, sanctuaryTone, 0.45) ?? sanctuaryTone;
        surfaceAlpha =
            (surfaceAlpha +
                    (disableGlass
                        ? 0.0
                        : variant == AppSurfaceVariant.panel
                        ? 0.04
                        : 0.03))
                .clamp(0.0, 1.0);
        borderAlpha = (borderAlpha + (isDark ? 0.02 : 0.03)).clamp(0.0, 1.0);
        surfaceBlend = (surfaceBlend + (disableColoredGlass ? 0.012 : 0.035))
            .clamp(0.0, 1.0);
        milkBlend = (milkBlend + (isDark ? 0.08 : 0.11)).clamp(0.0, 1.0);
        topHighlightBlend = (topHighlightBlend + (isDark ? 0.03 : 0.05)).clamp(
          0.0,
          1.0,
        );
        bottomAccentBlend = (bottomAccentBlend + 0.015).clamp(0.0, 1.0);
        tintAlpha = (tintAlpha - (isDark ? 0.004 : 0.010)).clamp(0.0, 1.0);
        break;
      case AppSurfaceTreatment.denseSanctuary:
        milkTone = sanctuaryTone;
        surfaceAlpha =
            (surfaceAlpha +
                    (disableGlass
                        ? 0.0
                        : switch (variant) {
                            AppSurfaceVariant.pill => 0.03,
                            AppSurfaceVariant.navigationBar => 0.02,
                            AppSurfaceVariant.panel => 0.10,
                            AppSurfaceVariant.card ||
                            AppSurfaceVariant.island ||
                            AppSurfaceVariant.featureTile => 0.08,
                          }))
                .clamp(0.0, 1.0);
        borderAlpha = (borderAlpha + (isDark ? 0.08 : 0.10)).clamp(0.0, 1.0);
        surfaceBlend = (surfaceBlend + 0.04).clamp(0.0, 1.0);
        borderBlend = (borderBlend + 0.10).clamp(0.0, 1.0);
        milkBlend = (milkBlend + (isDark ? 0.18 : 0.22)).clamp(0.0, 1.0);
        topHighlightBlend = (topHighlightBlend + (isDark ? 0.05 : 0.08)).clamp(
          0.0,
          1.0,
        );
        bottomAccentBlend = (bottomAccentBlend + 0.04).clamp(0.0, 1.0);
        tintAlpha = (tintAlpha - (isDark ? 0.005 : 0.012)).clamp(0.0, 1.0);
        break;
    }

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
      topSurface =
          Color.lerp(topSurface, depthTone, isDark ? 0.16 : 0.12) ?? topSurface;
      bottomSurface =
          Color.lerp(bottomSurface, depthTone, isDark ? 0.22 : 0.18) ??
          bottomSurface;
    }

    if (treatment == AppSurfaceTreatment.denseSanctuary) {
      final sanctuaryDepth = isDark
          ? Colors.black.withValues(alpha: 0.10)
          : sanctuaryTone.withValues(alpha: 0.22);
      topSurface = Color.alphaBlend(sanctuaryDepth, topSurface);
      bottomSurface = Color.alphaBlend(
        sanctuaryDepth.withValues(alpha: isDark ? 0.12 : 0.18),
        bottomSurface,
      );
    }

    var blendedBorder =
        Color.lerp(
          Colors.white,
          accent,
          borderBlend,
        )?.withValues(alpha: borderAlpha) ??
        accent.withValues(alpha: borderAlpha);

    if (treatment == AppSurfaceTreatment.denseSanctuary) {
      blendedBorder = Color.alphaBlend(
        sanctuaryEdgeLight.withValues(alpha: isDark ? 0.18 : 0.22),
        blendedBorder,
      );
    }

    final resolvedShadowColor = (isDark ? Colors.black : accent).withValues(
      alpha: disableGlass ? 0.08 : 0.16,
    );
    final resolvedIconBackgroundColor =
        (Color.lerp(
                  milkTone,
                  accent,
                  treatment == AppSurfaceTreatment.denseSanctuary ? 0.42 : 0.55,
                ) ??
                accent)
            .withValues(
              alpha: disableGlass
                  ? 0.18
                  : treatment == AppSurfaceTreatment.denseSanctuary
                  ? 0.26
                  : 0.22,
            );

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
          alpha: (surfaceAlpha - tintAlpha).clamp(0.0, 1.0),
        ),
      ],
    );

    return AppSurfaceStyle(
      backgroundColor: bottomSurface.withValues(alpha: surfaceAlpha),
      borderColor: blendedBorder,
      gradient: gradient,
      shadowColor: resolvedShadowColor,
      boxShadows: _boxShadows(
        variant: variant,
        treatment: treatment,
        isDark: isDark,
        disableGlass: disableGlass,
        accent: accent,
        highlight: treatment == AppSurfaceTreatment.denseSanctuary
            ? sanctuaryEdgeLight
            : Colors.white,
      ),
      splashColor: accent.withValues(alpha: disableGlass ? 0.10 : 0.12),
      highlightColor: accent.withValues(alpha: disableGlass ? 0.06 : 0.07),
      iconBackgroundColor: resolvedIconBackgroundColor,
    );
  }

  static AppSurfaceContentColors contentColors(
    BuildContext context, {
    AppSurfaceTreatment treatment = AppSurfaceTreatment.standard,
  }) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    if (treatment == AppSurfaceTreatment.denseSanctuary && appearance != null) {
      return AppSurfaceContentColors(
        foreground: Color.alphaBlend(
          (appearance.isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.04,
          ),
          appearance.quranArabicEmphasis,
        ),
        subtleForeground: Color.alphaBlend(
          (appearance.isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.03,
          ),
          appearance.onSurface,
        ),
        captionForeground: Color.alphaBlend(
          appearance.sanctuaryEdgeLight.withValues(alpha: 0.06),
          appearance.glassOnSurfaceSubtle,
        ),
        iconColor: appearance.quranArabicEmphasis,
      );
    }
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
        return (base + 0.05).clamp(0.0, 1.0);
      case AppSurfaceVariant.navigationBar:
        return (base - 0.01).clamp(0.0, 1.0);
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return base.clamp(0.0, 1.0);
      case AppSurfaceVariant.panel:
        return 0.58;
      case AppSurfaceVariant.card:
        return (base + 0.01).clamp(0.0, 1.0);
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
        return (base + 0.03).clamp(0.0, 1.0);
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
        return disableGlass ? 0.14 : 0.10;
      case AppSurfaceVariant.card:
        return disableGlass ? 0.10 : 0.08;
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
        return isDark ? 0.04 : 0.08;
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
        return isDark ? 0.012 : 0.022;
      case AppSurfaceVariant.card:
        return isDark ? 0.018 : 0.028;
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
        return isDark ? 0.20 : 0.28;
      case AppSurfaceVariant.navigationBar:
        return isDark ? 0.18 : 0.24;
      case AppSurfaceVariant.island:
      case AppSurfaceVariant.featureTile:
        return isDark ? 0.22 : 0.31;
      case AppSurfaceVariant.panel:
        return isDark ? 0.17 : 0.22;
      case AppSurfaceVariant.card:
        return isDark ? 0.21 : 0.29;
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
        return isDark ? 0.15 : 0.22;
      case AppSurfaceVariant.panel:
        return isDark ? 0.11 : 0.17;
      case AppSurfaceVariant.card:
        return isDark ? 0.14 : 0.20;
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

  static List<BoxShadow> _boxShadows({
    required AppSurfaceVariant variant,
    required AppSurfaceTreatment treatment,
    required bool isDark,
    required bool disableGlass,
    required Color accent,
    required Color highlight,
  }) {
    final extraBlack = disableGlass ? 0.04 : 0.0;
    switch (treatment) {
      case AppSurfaceTreatment.standard:
        return switch (variant) {
          AppSurfaceVariant.pill => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.18 : 0.12) + extraBlack,
              ),
              blurRadius: 20,
              spreadRadius: -6,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.08 : 0.07),
              blurRadius: 14,
              spreadRadius: -8,
              offset: const Offset(0, 4),
            ),
          ],
          AppSurfaceVariant.navigationBar => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.22 : 0.15) + extraBlack,
              ),
              blurRadius: 28,
              spreadRadius: -7,
              offset: const Offset(0, 15),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.11 : 0.10),
              blurRadius: 22,
              spreadRadius: -9,
              offset: const Offset(0, 8),
            ),
          ],
          AppSurfaceVariant.panel => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.28 : 0.18) + extraBlack,
              ),
              blurRadius: 34,
              spreadRadius: -5,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.14 : 0.12),
              blurRadius: 24,
              spreadRadius: -7,
              offset: const Offset(0, 10),
            ),
          ],
          AppSurfaceVariant.card ||
          AppSurfaceVariant.island ||
          AppSurfaceVariant.featureTile => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.30 : 0.18) + extraBlack,
              ),
              blurRadius: 40,
              spreadRadius: -4,
              offset: const Offset(0, 22),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.17 : 0.14),
              blurRadius: 28,
              spreadRadius: -6,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: isDark ? 0.03 : 0.08),
              blurRadius: 14,
              spreadRadius: -8,
              offset: const Offset(0, 1),
            ),
          ],
        };
      case AppSurfaceTreatment.homepageWarmGlass:
        return switch (variant) {
          AppSurfaceVariant.pill => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.16 : 0.12) + extraBlack,
              ),
              blurRadius: 18,
              spreadRadius: -7,
              offset: const Offset(0, 9),
            ),
          ],
          AppSurfaceVariant.navigationBar => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.20 : 0.14) + extraBlack,
              ),
              blurRadius: 26,
              spreadRadius: -8,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.10 : 0.09),
              blurRadius: 20,
              spreadRadius: -10,
              offset: const Offset(0, 8),
            ),
          ],
          AppSurfaceVariant.panel => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.24 : 0.16) + extraBlack,
              ),
              blurRadius: 30,
              spreadRadius: -6,
              offset: const Offset(0, 18),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.12 : 0.11),
              blurRadius: 24,
              spreadRadius: -8,
              offset: const Offset(0, 10),
            ),
          ],
          AppSurfaceVariant.card ||
          AppSurfaceVariant.island ||
          AppSurfaceVariant.featureTile => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.26 : 0.16) + extraBlack,
              ),
              blurRadius: 36,
              spreadRadius: -5,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.16 : 0.12),
              blurRadius: 26,
              spreadRadius: -8,
              offset: const Offset(0, 10),
            ),
          ],
        };
      case AppSurfaceTreatment.denseSanctuary:
        return switch (variant) {
          AppSurfaceVariant.pill => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.18 : 0.12) + extraBlack,
              ),
              blurRadius: 18,
              spreadRadius: -7,
              offset: const Offset(0, 9),
            ),
            BoxShadow(
              color: highlight.withValues(alpha: isDark ? 0.06 : 0.08),
              blurRadius: 10,
              spreadRadius: -6,
              offset: const Offset(0, 1),
            ),
          ],
          AppSurfaceVariant.navigationBar => <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.22 : 0.14) + extraBlack,
              ),
              blurRadius: 30,
              spreadRadius: -8,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.14 : 0.13),
              blurRadius: 24,
              spreadRadius: -9,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: highlight.withValues(alpha: isDark ? 0.08 : 0.12),
              blurRadius: 14,
              spreadRadius: -8,
              offset: const Offset(0, 1),
            ),
          ],
          AppSurfaceVariant.panel => <BoxShadow>[
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.16 : 0.15),
              blurRadius: 30,
              spreadRadius: -8,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.24 : 0.14) + extraBlack,
              ),
              blurRadius: 40,
              spreadRadius: -8,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: highlight.withValues(alpha: isDark ? 0.07 : 0.11),
              blurRadius: 16,
              spreadRadius: -8,
              offset: const Offset(0, 1),
            ),
          ],
          AppSurfaceVariant.card ||
          AppSurfaceVariant.island ||
          AppSurfaceVariant.featureTile => <BoxShadow>[
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.18 : 0.16),
              blurRadius: 34,
              spreadRadius: -7,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: Colors.black.withValues(
                alpha: (isDark ? 0.24 : 0.14) + extraBlack,
              ),
              blurRadius: 44,
              spreadRadius: -8,
              offset: const Offset(0, 22),
            ),
            BoxShadow(
              color: highlight.withValues(alpha: isDark ? 0.06 : 0.11),
              blurRadius: 16,
              spreadRadius: -8,
              offset: const Offset(0, 1),
            ),
          ],
        };
    }
  }
}
