import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/app_fonts.dart';
import 'package:path_of_nur/core/theme/app_theme.dart';

/// K1 of the kids redesign: the kids theme is not the adult theme in cream.
/// Headings take the rounded kids face and every text slot reads a step
/// larger, so a page built on the shared widgets is a kids page without
/// naming a colour or a size of its own.
void main() {
  ThemeData themeFor(AppThemeMode mode, {Locale? locale}) {
    return AppTheme.themeFor(
      mode: mode,
      pageTransitionStyle: AppPageTransitionStyle.defaultSystem,
      reduceMotion: false,
      disableGlassTransparency: false,
      disableColoredGlass: false,
      disableBackground: false,
      highContrastText: false,
      glassSurfaceAlpha: 0.88,
      locale: locale,
    );
  }

  test('kids headings use the rounded display face', () {
    final kids = themeFor(AppThemeMode.noorKids).textTheme;
    expect(kids.displayLarge?.fontFamily, AppFonts.kidsDisplay);
    expect(kids.titleLarge?.fontFamily, AppFonts.kidsDisplay);
    expect(kids.titleMedium?.fontFamily, AppFonts.kidsDisplay);
    expect(kids.titleSmall?.fontFamily, AppFonts.kidsDisplay);
    // Body copy keeps the reading face.
    expect(kids.bodyLarge?.fontFamily, AppFonts.latinSans);
  });

  test('the kids face also carries Arabic-script locales', () {
    final kids = themeFor(
      AppThemeMode.noorKids,
      locale: const Locale('ar'),
    ).textTheme;
    expect(kids.titleLarge?.fontFamily, AppFonts.kidsDisplay);
    expect(kids.bodyLarge?.fontFamily, AppFonts.uiArabic);
  });

  test('every kids text slot is larger than its adult counterpart', () {
    final kids = themeFor(AppThemeMode.noorKids).textTheme;
    final adult = themeFor(AppThemeMode.noorGlass).textTheme;
    for (final pick in <TextStyle? Function(TextTheme)>[
      (t) => t.displayLarge,
      (t) => t.titleLarge,
      (t) => t.titleMedium,
      (t) => t.titleSmall,
      (t) => t.bodyLarge,
      (t) => t.bodyMedium,
      (t) => t.bodySmall,
      (t) => t.labelLarge,
      (t) => t.labelMedium,
    ]) {
      expect(pick(kids)!.fontSize!, greaterThan(pick(adult)!.fontSize!));
    }
    expect(kids.bodyLarge?.fontSize, 18);
  });

  test('the adult themes are untouched', () {
    final adult = themeFor(AppThemeMode.noorGlass).textTheme;
    expect(adult.titleLarge?.fontFamily, AppFonts.latinSerif);
    expect(adult.titleLarge?.fontSize, 25);
    expect(adult.bodyLarge?.fontSize, 15);
  });
}
