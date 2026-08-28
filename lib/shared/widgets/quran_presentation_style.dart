import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class QuranPresentationStyle {
  const QuranPresentationStyle._();

  static const double _lightOpacity = 0.50;
  static const double _darkOpacity = 0.58;
  static const Color _defaultHarakatColor = Color(0xFFC22A2A);
  static const Color _fallbackSupportText = Color(0xFF3D3025);

  static double translucencyFactor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _darkOpacity
        : _lightOpacity;
  }

  static Color translucentColor(BuildContext context, Color color) {
    final factor = translucencyFactor(context);
    return color.withValues(alpha: (color.a * factor).clamp(0.0, 1.0));
  }

  static TextStyle translucentTextStyle(
    BuildContext context,
    TextStyle style, {
    Color? fallbackColor,
  }) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    if (appearance?.isNightFamily == true) {
      // Night themes paint verses in warm ivory directly — the light-theme
      // translucency would leave the dark default ink invisible.
      return style.copyWith(
        color: appearance!.quranArabicEmphasis.withValues(alpha: 0.94),
      );
    }
    final baseColor = style.color ?? fallbackColor ?? const Color(0xFF1F1B17);
    return style.copyWith(color: translucentColor(context, baseColor));
  }

  static Color translucentHarakatColor(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    if (appearance?.isNightFamily == true) {
      // Soft coral reads on the dark grounds where the deep red vanishes.
      final warm = appearance!.mode == AppThemeMode.candlelight
          ? const Color(0xFFE8946B)
          : const Color(0xFFE58B72);
      return warm.withValues(alpha: 0.92);
    }
    return translucentColor(context, _defaultHarakatColor);
  }

  static Color quranSupportTextColor(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    return appearance?.backgroundForeground ?? _fallbackSupportText;
  }

  static TextStyle quranSupportTextStyle(
    BuildContext context,
    TextStyle style, {
    bool italic = false,
    Color? colorOverride,
  }) {
    return style.copyWith(
      color: colorOverride ?? quranSupportTextColor(context),
      fontStyle: italic ? FontStyle.italic : style.fontStyle,
    );
  }

  static TextStyle quranSupportSubtleTextStyle(
    BuildContext context,
    TextStyle style, {
    bool italic = false,
  }) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    return style.copyWith(
      color: appearance?.backgroundForegroundSubtle ?? _fallbackSupportText,
      fontStyle: italic ? FontStyle.italic : style.fontStyle,
    );
  }
}
