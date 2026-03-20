import 'package:flutter/material.dart';

class QuranPresentationStyle {
  const QuranPresentationStyle._();

  static const double _lightOpacity = 0.50;
  static const double _darkOpacity = 0.58;
  static const Color _defaultHarakatColor = Color(0xFFC22A2A);

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
    final baseColor = style.color ?? fallbackColor ?? const Color(0xFF1F1B17);
    return style.copyWith(color: translucentColor(context, baseColor));
  }

  static Color translucentHarakatColor(BuildContext context) {
    return translucentColor(context, _defaultHarakatColor);
  }
}
