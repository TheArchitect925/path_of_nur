import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import '../../core/theme/app_surfaces.dart';
import '../../core/theme/app_theme.dart';

enum NoorLiquidGlassMode { disabled, fake, liquid }

enum NoorLiquidGlassPreset {
  card,
  panel,
  pill,
  island,
  featureTile,
  navigationBar,
}

@immutable
class NoorLiquidGlassSpec {
  const NoorLiquidGlassSpec({
    required this.mode,
    required this.preset,
    required this.borderRadius,
    required this.padding,
    this.clipBehavior = Clip.antiAlias,
    this.fallbackTreatment = AppSurfaceTreatment.standard,
    this.tintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = false,
    this.borderWidth = 1,
    this.blurSigma,
    this.borderColor,
    this.highlightGradientColors,
    this.highlightGradientStops,
  });

  const NoorLiquidGlassSpec.card({
    this.mode = NoorLiquidGlassMode.disabled,
    this.padding = const EdgeInsets.all(16),
    this.clipBehavior = Clip.antiAlias,
    this.fallbackTreatment = AppSurfaceTreatment.standard,
    this.tintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = false,
    this.borderWidth = 1,
    this.blurSigma,
    this.borderColor,
    this.highlightGradientColors,
    this.highlightGradientStops,
  }) : preset = NoorLiquidGlassPreset.card,
       borderRadius = AppRadii.card;

  const NoorLiquidGlassSpec.panel({
    this.mode = NoorLiquidGlassMode.disabled,
    this.padding = const EdgeInsets.all(16),
    this.clipBehavior = Clip.antiAlias,
    this.fallbackTreatment = AppSurfaceTreatment.standard,
    this.tintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = false,
    this.borderWidth = 1,
    this.blurSigma,
    this.borderColor,
    this.highlightGradientColors,
    this.highlightGradientStops,
  }) : preset = NoorLiquidGlassPreset.panel,
       borderRadius = AppRadii.card;

  const NoorLiquidGlassSpec.pill({
    this.mode = NoorLiquidGlassMode.disabled,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.clipBehavior = Clip.antiAlias,
    this.fallbackTreatment = AppSurfaceTreatment.standard,
    this.tintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = false,
    this.borderWidth = 1,
    this.blurSigma,
    this.borderColor,
    this.highlightGradientColors,
    this.highlightGradientStops,
  }) : preset = NoorLiquidGlassPreset.pill,
       borderRadius = AppRadii.pill;

  final NoorLiquidGlassMode mode;
  final NoorLiquidGlassPreset preset;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Clip clipBehavior;
  final AppSurfaceTreatment fallbackTreatment;
  final Color? tintColor;
  final double? surfaceAlphaOverride;
  final bool includeShadow;
  final double borderWidth;
  final double? blurSigma;
  final Color? borderColor;
  final List<Color>? highlightGradientColors;
  final List<double>? highlightGradientStops;

  AppSurfaceVariant get surfaceVariant {
    switch (preset) {
      case NoorLiquidGlassPreset.card:
        return AppSurfaceVariant.card;
      case NoorLiquidGlassPreset.panel:
        return AppSurfaceVariant.panel;
      case NoorLiquidGlassPreset.pill:
        return AppSurfaceVariant.pill;
      case NoorLiquidGlassPreset.island:
        return AppSurfaceVariant.island;
      case NoorLiquidGlassPreset.featureTile:
        return AppSurfaceVariant.featureTile;
      case NoorLiquidGlassPreset.navigationBar:
        return AppSurfaceVariant.navigationBar;
    }
  }

  NoorLiquidGlassSpec copyWith({
    NoorLiquidGlassMode? mode,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    Clip? clipBehavior,
    AppSurfaceTreatment? fallbackTreatment,
    Color? tintColor,
    double? surfaceAlphaOverride,
    bool? includeShadow,
    double? borderWidth,
    double? blurSigma,
    Color? borderColor,
    List<Color>? highlightGradientColors,
    List<double>? highlightGradientStops,
  }) {
    return NoorLiquidGlassSpec(
      mode: mode ?? this.mode,
      preset: preset,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      fallbackTreatment: fallbackTreatment ?? this.fallbackTreatment,
      tintColor: tintColor ?? this.tintColor,
      surfaceAlphaOverride: surfaceAlphaOverride ?? this.surfaceAlphaOverride,
      includeShadow: includeShadow ?? this.includeShadow,
      borderWidth: borderWidth ?? this.borderWidth,
      blurSigma: blurSigma ?? this.blurSigma,
      borderColor: borderColor ?? this.borderColor,
      highlightGradientColors:
          highlightGradientColors ?? this.highlightGradientColors,
      highlightGradientStops:
          highlightGradientStops ?? this.highlightGradientStops,
    );
  }
}

@immutable
class NoorLiquidGlassCapability {
  const NoorLiquidGlassCapability({
    required this.platformSupported,
    required this.shaderFilterSupported,
  });

  final bool platformSupported;
  final bool shaderFilterSupported;

  bool get canRenderLiquid => platformSupported && shaderFilterSupported;
  bool get shouldFallbackToFake => platformSupported && !shaderFilterSupported;

  static NoorLiquidGlassCapability current() {
    return NoorLiquidGlassCapability(
      platformSupported: !kIsWeb,
      shaderFilterSupported: ui.ImageFilter.isShaderFilterSupported,
    );
  }
}

class NoorLiquidGlassLayer extends StatelessWidget {
  const NoorLiquidGlassLayer({
    super.key,
    required this.spec,
    required this.child,
  });

  final NoorLiquidGlassSpec spec;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class NoorLiquidGlassContainer extends StatelessWidget {
  const NoorLiquidGlassContainer({
    super.key,
    required this.spec,
    required this.child,
    this.width = double.infinity,
  });

  final NoorLiquidGlassSpec spec;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final style = _ResolvedNoorGlassStyle.resolve(context, spec);
    final radius = BorderRadius.circular(spec.borderRadius);
    final shell = ClipRRect(
      borderRadius: radius,
      clipBehavior: spec.clipBehavior,
      child: Stack(
        children: [
          if (style.shouldBlur)
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: style.blurSigma,
                  sigmaY: style.blurSigma,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    style.topFill.withValues(alpha: style.surfaceAlpha + 0.04),
                    style.bottomFill.withValues(alpha: style.surfaceAlpha),
                  ],
                ),
                border: Border.all(
                  color: style.borderColor,
                  width: spec.borderWidth,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: style.highlightGradientColors,
                    stops: style.highlightGradientStops,
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: spec.padding, child: child),
        ],
      ),
    );

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: spec.includeShadow ? style.boxShadows : null,
      ),
      child: shell,
    );
  }
}

class NoorLiquidGlassShape extends StatelessWidget {
  const NoorLiquidGlassShape({
    super.key,
    required this.spec,
    required this.child,
    this.width = double.infinity,
  });

  final NoorLiquidGlassSpec spec;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return NoorLiquidGlassContainer(spec: spec, width: width, child: child);
  }
}

class _ResolvedNoorGlassStyle {
  const _ResolvedNoorGlassStyle({
    required this.topFill,
    required this.bottomFill,
    required this.surfaceAlpha,
    required this.borderColor,
    required this.highlightGradientColors,
    required this.highlightGradientStops,
    required this.boxShadows,
    required this.blurSigma,
    required this.shouldBlur,
  });

  final Color topFill;
  final Color bottomFill;
  final double surfaceAlpha;
  final Color borderColor;
  final List<Color> highlightGradientColors;
  final List<double> highlightGradientStops;
  final List<BoxShadow> boxShadows;
  final double blurSigma;
  final bool shouldBlur;

  static _ResolvedNoorGlassStyle resolve(
    BuildContext context,
    NoorLiquidGlassSpec spec,
  ) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final isDark = appearance?.isDark ?? false;
    final baseSurface = appearance?.surface ?? theme.colorScheme.surface;
    final softSurface = appearance?.surfaceSoft ?? baseSurface;
    final isNightMilk = appearance?.isNightFamily ?? false;
    // Night themes never milk-wash toward the light frosted tones — the
    // glass stays on the dark surface so cards read as deep night glass.
    final milkTone = isNightMilk
        ? (appearance?.surfaceSoft ?? baseSurface)
        : appearance?.frostedGlassTone ??
              (isDark ? const Color(0xFFEFE3CB) : const Color(0xFFFEFBF6));
    final sanctuaryTone = isNightMilk
        ? (appearance?.surface ?? baseSurface)
        : appearance?.sanctuarySurfaceTone ??
              (isDark ? const Color(0xFFEBDCBD) : const Color(0xFFF9F0DF));
    // The night themes use one standard glass everywhere: per-tile colored
    // tints and custom highlights are ignored so every surface reads as the
    // same deep glass over the painted atmosphere.
    final isNight = appearance?.isNightFamily ?? false;
    final tint = isNight
        ? (appearance?.accent ?? const Color(0xFFE7C98C))
        : (spec.tintColor ?? const Color(0xFFE7C98C));
    final tokens = _NoorGlassTokens.forPreset(spec.preset);
    final surfaceAlpha = spec.surfaceAlphaOverride ?? tokens.surfaceAlpha;
    final fillBase =
        Color.lerp(softSurface, milkTone, tokens.milkBlend) ?? softSurface;
    final warmedBase =
        Color.lerp(fillBase, sanctuaryTone, tokens.sanctuaryBlend) ?? fillBase;
    final bottomFill =
        Color.lerp(warmedBase, tint, tokens.tintBlend) ?? warmedBase;
    final topFill = isNightMilk
        ? bottomFill
        : Color.lerp(bottomFill, Colors.white, tokens.topLightBlend) ??
              bottomFill;
    final borderColor =
        spec.borderColor ??
        (Color.lerp(Colors.white, tint, tokens.borderTintBlend) ?? Colors.white)
            .withValues(alpha: tokens.borderAlpha);
    final highlightGradientColors =
        (isNight ? null : spec.highlightGradientColors) ??
        <Color>[
          Colors.white.withValues(alpha: tokens.topHighlightAlpha),
          Colors.white.withValues(alpha: tokens.midHighlightAlpha),
          tint.withValues(alpha: tokens.bottomHighlightAlpha),
        ];
    final shadowBase = isDark ? Colors.black : const Color(0xFF7F6642);
    final boxShadows = <BoxShadow>[
      BoxShadow(
        color: shadowBase.withValues(alpha: tokens.shadowAlpha),
        blurRadius: tokens.shadowBlur,
        offset: Offset(0, tokens.shadowYOffset),
        spreadRadius: tokens.shadowSpread,
      ),
    ];
    final resolvedMode = _resolveMode(spec.mode);

    return _ResolvedNoorGlassStyle(
      topFill: topFill,
      bottomFill: bottomFill,
      surfaceAlpha: surfaceAlpha,
      borderColor: borderColor,
      highlightGradientColors: highlightGradientColors,
      highlightGradientStops:
          spec.highlightGradientStops ?? const <double>[0.0, 0.42, 1.0],
      boxShadows: boxShadows,
      blurSigma: spec.blurSigma ?? tokens.blurSigma,
      shouldBlur:
          resolvedMode == NoorLiquidGlassMode.liquid &&
          (spec.blurSigma ?? tokens.blurSigma) > 0,
    );
  }
}

class _NoorGlassTokens {
  const _NoorGlassTokens({
    required this.surfaceAlpha,
    required this.milkBlend,
    required this.sanctuaryBlend,
    required this.tintBlend,
    required this.topLightBlend,
    required this.borderAlpha,
    required this.borderTintBlend,
    required this.topHighlightAlpha,
    required this.midHighlightAlpha,
    required this.bottomHighlightAlpha,
    required this.shadowAlpha,
    required this.shadowBlur,
    required this.shadowYOffset,
    required this.shadowSpread,
    required this.blurSigma,
  });

  final double surfaceAlpha;
  final double milkBlend;
  final double sanctuaryBlend;
  final double tintBlend;
  final double topLightBlend;
  final double borderAlpha;
  final double borderTintBlend;
  final double topHighlightAlpha;
  final double midHighlightAlpha;
  final double bottomHighlightAlpha;
  final double shadowAlpha;
  final double shadowBlur;
  final double shadowYOffset;
  final double shadowSpread;
  final double blurSigma;

  static _NoorGlassTokens forPreset(NoorLiquidGlassPreset preset) {
    switch (preset) {
      case NoorLiquidGlassPreset.card:
      case NoorLiquidGlassPreset.featureTile:
      case NoorLiquidGlassPreset.island:
        return const _NoorGlassTokens(
          surfaceAlpha: 0.24,
          milkBlend: 0.72,
          sanctuaryBlend: 0.18,
          tintBlend: 0.16,
          topLightBlend: 0.16,
          borderAlpha: 0.26,
          borderTintBlend: 0.12,
          topHighlightAlpha: 0.16,
          midHighlightAlpha: 0.04,
          bottomHighlightAlpha: 0.08,
          shadowAlpha: 0.10,
          shadowBlur: 22,
          shadowYOffset: 12,
          shadowSpread: -8,
          blurSigma: 18,
        );
      case NoorLiquidGlassPreset.navigationBar:
        return const _NoorGlassTokens(
          surfaceAlpha: 0.22,
          milkBlend: 0.70,
          sanctuaryBlend: 0.16,
          tintBlend: 0.14,
          topLightBlend: 0.14,
          borderAlpha: 0.24,
          borderTintBlend: 0.10,
          topHighlightAlpha: 0.14,
          midHighlightAlpha: 0.03,
          bottomHighlightAlpha: 0.07,
          shadowAlpha: 0.08,
          shadowBlur: 18,
          shadowYOffset: 10,
          shadowSpread: -8,
          blurSigma: 14,
        );
      case NoorLiquidGlassPreset.panel:
        return const _NoorGlassTokens(
          surfaceAlpha: 0.16,
          milkBlend: 0.62,
          sanctuaryBlend: 0.12,
          tintBlend: 0.10,
          topLightBlend: 0.10,
          borderAlpha: 0.18,
          borderTintBlend: 0.10,
          topHighlightAlpha: 0.10,
          midHighlightAlpha: 0.03,
          bottomHighlightAlpha: 0.05,
          shadowAlpha: 0.05,
          shadowBlur: 14,
          shadowYOffset: 8,
          shadowSpread: -8,
          blurSigma: 0,
        );
      case NoorLiquidGlassPreset.pill:
        return const _NoorGlassTokens(
          surfaceAlpha: 0.14,
          milkBlend: 0.58,
          sanctuaryBlend: 0.10,
          tintBlend: 0.08,
          topLightBlend: 0.08,
          borderAlpha: 0.16,
          borderTintBlend: 0.08,
          topHighlightAlpha: 0.08,
          midHighlightAlpha: 0.02,
          bottomHighlightAlpha: 0.04,
          shadowAlpha: 0.0,
          shadowBlur: 0,
          shadowYOffset: 0,
          shadowSpread: 0,
          blurSigma: 0,
        );
    }
  }
}

NoorLiquidGlassMode _resolveMode(NoorLiquidGlassMode requestedMode) {
  if (requestedMode == NoorLiquidGlassMode.disabled) {
    return NoorLiquidGlassMode.disabled;
  }
  final capability = NoorLiquidGlassCapability.current();
  if (requestedMode == NoorLiquidGlassMode.fake) {
    return capability.platformSupported
        ? NoorLiquidGlassMode.fake
        : NoorLiquidGlassMode.disabled;
  }
  if (capability.canRenderLiquid) {
    return NoorLiquidGlassMode.liquid;
  }
  if (capability.shouldFallbackToFake) {
    return NoorLiquidGlassMode.fake;
  }
  return NoorLiquidGlassMode.disabled;
}
