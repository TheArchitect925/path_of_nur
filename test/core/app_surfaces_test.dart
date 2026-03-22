import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/app_surfaces.dart';
import 'package:path_of_nur/core/theme/app_theme.dart';

void main() {
  test(
    'colored glass toggle neutralizes page tint inputs in the shared surface layer',
    () {
      const surface = Color(0xFFF5EEE5);
      final coloredAppearance = AppAppearanceTheme.defaults(
        mode: AppThemeMode.defaultMode,
        disableGlassTransparency: false,
        disableColoredGlass: false,
        disableBackground: false,
        glassSurfaceAlpha: 0.93,
      );
      final neutralAppearance = AppAppearanceTheme.defaults(
        mode: AppThemeMode.defaultMode,
        disableGlassTransparency: false,
        disableColoredGlass: true,
        disableBackground: false,
        glassSurfaceAlpha: 0.93,
      );

      final coloredTint = AppSurfaceTheme.resolveTintColor(
        appearance: coloredAppearance,
        tintColor: Colors.blueAccent,
        surface: surface,
        disableColoredGlass: false,
      );
      final coloredBaseline = AppSurfaceTheme.resolveTintColor(
        appearance: coloredAppearance,
        tintColor: null,
        surface: surface,
        disableColoredGlass: false,
      );
      final neutralBlue = AppSurfaceTheme.resolveTintColor(
        appearance: neutralAppearance,
        tintColor: Colors.blueAccent,
        surface: surface,
        disableColoredGlass: true,
      );
      final neutralRed = AppSurfaceTheme.resolveTintColor(
        appearance: neutralAppearance,
        tintColor: Colors.redAccent,
        surface: surface,
        disableColoredGlass: true,
      );

      expect(coloredTint, isNot(equals(coloredBaseline)));
      expect(neutralBlue, equals(neutralRed));
    },
  );
}
