import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../core/theme/app_radii.dart';
import '../../core/theme/app_surfaces.dart';

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
    required this.settings,
    required this.borderRadius,
    required this.padding,
    this.useBackdropGroup = false,
    this.grouped = false,
    this.glassContainsChild = false,
    this.clipBehavior = Clip.hardEdge,
    this.fallbackTreatment = AppSurfaceTreatment.standard,
    this.tintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = false,
    this.borderWidth = 1,
  });

  const NoorLiquidGlassSpec.card({
    this.mode = NoorLiquidGlassMode.disabled,
    this.settings = const LiquidGlassSettings(
      thickness: 14,
      blur: 8,
      lightIntensity: 0.42,
      ambientStrength: 0.08,
      saturation: 1.08,
      glassColor: Color(0x12FFFFFF),
    ),
    this.padding = const EdgeInsets.all(16),
    this.useBackdropGroup = false,
    this.grouped = false,
    this.glassContainsChild = false,
    this.clipBehavior = Clip.hardEdge,
    this.fallbackTreatment = AppSurfaceTreatment.standard,
    this.tintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = false,
    this.borderWidth = 1,
  }) : preset = NoorLiquidGlassPreset.card,
       borderRadius = AppRadii.card;

  const NoorLiquidGlassSpec.panel({
    this.mode = NoorLiquidGlassMode.disabled,
    this.settings = const LiquidGlassSettings(
      thickness: 12,
      blur: 7,
      lightIntensity: 0.40,
      ambientStrength: 0.08,
      saturation: 1.06,
      glassColor: Color(0x10FFFFFF),
    ),
    this.padding = const EdgeInsets.all(16),
    this.useBackdropGroup = true,
    this.grouped = false,
    this.glassContainsChild = false,
    this.clipBehavior = Clip.hardEdge,
    this.fallbackTreatment = AppSurfaceTreatment.standard,
    this.tintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = false,
    this.borderWidth = 1,
  }) : preset = NoorLiquidGlassPreset.panel,
       borderRadius = AppRadii.card;

  const NoorLiquidGlassSpec.pill({
    this.mode = NoorLiquidGlassMode.disabled,
    this.settings = const LiquidGlassSettings(
      thickness: 8,
      blur: 6,
      lightIntensity: 0.34,
      ambientStrength: 0.05,
      saturation: 1.03,
      glassColor: Color(0x0FFFFFFF),
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.useBackdropGroup = true,
    this.grouped = false,
    this.glassContainsChild = false,
    this.clipBehavior = Clip.hardEdge,
    this.fallbackTreatment = AppSurfaceTreatment.standard,
    this.tintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = false,
    this.borderWidth = 1,
  }) : preset = NoorLiquidGlassPreset.pill,
       borderRadius = AppRadii.pill;

  final NoorLiquidGlassMode mode;
  final NoorLiquidGlassPreset preset;
  final LiquidGlassSettings settings;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool useBackdropGroup;
  final bool grouped;
  final bool glassContainsChild;
  final Clip clipBehavior;
  final AppSurfaceTreatment fallbackTreatment;
  final Color? tintColor;
  final double? surfaceAlphaOverride;
  final bool includeShadow;
  final double borderWidth;

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
    LiquidGlassSettings? settings,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    bool? useBackdropGroup,
    bool? grouped,
    bool? glassContainsChild,
    Clip? clipBehavior,
    AppSurfaceTreatment? fallbackTreatment,
    Color? tintColor,
    double? surfaceAlphaOverride,
    bool? includeShadow,
    double? borderWidth,
  }) {
    return NoorLiquidGlassSpec(
      mode: mode ?? this.mode,
      preset: preset,
      settings: settings ?? this.settings,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      useBackdropGroup: useBackdropGroup ?? this.useBackdropGroup,
      grouped: grouped ?? this.grouped,
      glassContainsChild: glassContainsChild ?? this.glassContainsChild,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      fallbackTreatment: fallbackTreatment ?? this.fallbackTreatment,
      tintColor: tintColor ?? this.tintColor,
      surfaceAlphaOverride: surfaceAlphaOverride ?? this.surfaceAlphaOverride,
      includeShadow: includeShadow ?? this.includeShadow,
      borderWidth: borderWidth ?? this.borderWidth,
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
      platformSupported: !kIsWeb && _supportsPlatform(defaultTargetPlatform),
      shaderFilterSupported: ui.ImageFilter.isShaderFilterSupported,
    );
  }

  static bool _supportsPlatform(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      case TargetPlatform.macOS:
        return true;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
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
  Widget build(BuildContext context) {
    final resolvedMode = _resolveMode(spec.mode);
    if (resolvedMode != NoorLiquidGlassMode.liquid) {
      return child;
    }
    return LiquidGlassLayer(
      settings: spec.settings,
      fake: false,
      useBackdropGroup: spec.useBackdropGroup,
      child: child,
    );
  }
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
  final double width;

  @override
  Widget build(BuildContext context) {
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: spec.surfaceVariant,
      treatment: spec.fallbackTreatment,
      tintColor: spec.tintColor,
      surfaceAlphaOverride: spec.surfaceAlphaOverride,
    );
    final chrome = _NoorLiquidGlassChrome(
      spec: spec,
      surfaceStyle: surfaceStyle,
      width: width,
      child: child,
    );
    final resolvedMode = _resolveMode(spec.mode);
    if (resolvedMode != NoorLiquidGlassMode.liquid) {
      return chrome;
    }
    return LiquidGlass.withOwnLayer(
      settings: spec.settings,
      fake: false,
      shape: LiquidRoundedSuperellipse(borderRadius: spec.borderRadius),
      glassContainsChild: spec.glassContainsChild,
      clipBehavior: spec.clipBehavior,
      child: chrome,
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
  final double width;

  @override
  Widget build(BuildContext context) {
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: spec.surfaceVariant,
      treatment: spec.fallbackTreatment,
      tintColor: spec.tintColor,
      surfaceAlphaOverride: spec.surfaceAlphaOverride,
    );
    final chrome = _NoorLiquidGlassChrome(
      spec: spec,
      surfaceStyle: surfaceStyle,
      width: width,
      child: child,
    );
    if (_resolveMode(spec.mode) != NoorLiquidGlassMode.liquid) {
      return chrome;
    }
    final shape = LiquidRoundedSuperellipse(borderRadius: spec.borderRadius);
    return spec.grouped
        ? LiquidGlass.grouped(
            shape: shape,
            glassContainsChild: spec.glassContainsChild,
            clipBehavior: spec.clipBehavior,
            child: chrome,
          )
        : LiquidGlass(
            shape: shape,
            glassContainsChild: spec.glassContainsChild,
            clipBehavior: spec.clipBehavior,
            child: chrome,
          );
  }
}

class _NoorLiquidGlassChrome extends StatelessWidget {
  const _NoorLiquidGlassChrome({
    required this.spec,
    required this.surfaceStyle,
    required this.width,
    required this.child,
  });

  final NoorLiquidGlassSpec spec;
  final AppSurfaceStyle surfaceStyle;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final baseDecoration = surfaceStyle.decoration(
      radius: spec.borderRadius,
      borderWidth: spec.borderWidth,
      includeShadow: spec.includeShadow,
    );
    final highlightColor = Colors.white.withValues(alpha: 0.10);
    return Container(
      width: width,
      padding: spec.padding,
      decoration: baseDecoration.copyWith(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            highlightColor,
            surfaceStyle.backgroundColor.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: child,
    );
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
