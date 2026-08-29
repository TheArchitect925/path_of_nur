import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme.dart';

/// Theme-resolved colour access.
///
/// [AppColors] holds the *light* theme's literal values. Reading them directly
/// in a widget pins that widget to the cream palette, so it stops following
/// Midnight, Candlelight, Jumu'ah, Ramadan, Laylat al-Qadr and Eid — the
/// classic symptom being dark-brown caption text on dark glass.
///
/// Use `context.palette.<token>` instead. Each getter reads the live
/// [AppAppearanceTheme] and only falls back to the [AppColors] constant when
/// the extension is absent (bare `MaterialApp`s in tests, for instance).
///
/// The one place [AppColors] is still read directly is `app_surfaces.dart`,
/// where it is the documented `appearance?.x ?? AppColors.y` fallback.
class AppPalette {
  const AppPalette(this._appearance, this._scheme);

  factory AppPalette.of(BuildContext context) {
    final theme = Theme.of(context);
    return AppPalette(theme.extension<AppAppearanceTheme>(), theme.colorScheme);
  }

  final AppAppearanceTheme? _appearance;
  final ColorScheme _scheme;

  /// The live appearance extension, for callers that need a token this
  /// palette does not surface.
  AppAppearanceTheme? get appearance => _appearance;

  Color get background => _appearance?.background ?? AppColors.background;

  Color get backgroundAlt =>
      _appearance?.backgroundAlt ?? AppColors.backgroundAlt;

  Color get surface => _appearance?.surface ?? _scheme.surface;

  Color get surfaceSoft =>
      _appearance?.surfaceSoft ?? _scheme.surfaceContainerHighest;

  Color get onSurface => _appearance?.onSurface ?? _scheme.onSurface;

  /// Captions, helper lines, secondary labels.
  Color get onSurfaceSubtle =>
      _appearance?.onSurfaceSubtle ?? _scheme.onSurfaceVariant;

  /// Quieter still — disabled and placeholder text.
  Color get onSurfaceMuted =>
      _appearance?.onSurfaceMuted ??
      _scheme.onSurfaceVariant.withValues(alpha: 0.70);

  /// The theme's accent. Gold on the standard and night themes, but the
  /// occasion themes shift it (emerald on Jumu'ah, festival on Eid), which is
  /// exactly what `AppColors.accentGold` could not do.
  Color get accent => _appearance?.accent ?? _scheme.primary;

  Color get accentSoft => _appearance?.accentSoft ?? _scheme.primary;

  Color get border =>
      _appearance?.border ?? _scheme.outline.withValues(alpha: 0.40);

  Color get divider => _appearance?.divider ?? _scheme.outlineVariant;

  /// Semantic status hues. These are deliberate hues rather than surface
  /// tokens, so they stay stable across themes; they are exposed here so all
  /// colour access goes through one place.
  Color get success => _appearance?.success ?? AppColors.success;

  Color get caution => AppColors.caution;

  Color get error => _scheme.error;
}

extension AppPaletteContext on BuildContext {
  /// Theme-resolved colours. See [AppPalette].
  AppPalette get palette => AppPalette.of(this);
}
