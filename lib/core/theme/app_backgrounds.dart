import 'package:flutter/material.dart';

import 'app_theme.dart';

enum AppBackgroundAtmosphere { standard, quran }

@immutable
class AppBackgroundSpec {
  const AppBackgroundSpec({
    required this.baseGradient,
    required this.wallpaperTintGradient,
    required this.foregroundGlowGradient,
    this.previewGradient,
  });

  final Gradient baseGradient;
  final Gradient wallpaperTintGradient;
  final Gradient foregroundGlowGradient;
  final Gradient? previewGradient;
}

class AppBackgroundTheme {
  const AppBackgroundTheme._();

  static AppBackgroundSpec resolve({
    required AppAppearanceTheme? appearance,
    required bool disableGlassTransparency,
    AppBackgroundAtmosphere atmosphere = AppBackgroundAtmosphere.standard,
  }) {
    final effectiveAppearance =
        appearance ??
        AppAppearanceTheme.defaults(
          mode: AppThemeMode.defaultMode,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: false,
          disableBackground: false,
          glassSurfaceAlpha: 0.88,
        );

    switch (effectiveAppearance.mode) {
      case AppThemeMode.noorGlass:
        return _noorSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: disableGlassTransparency,
        );
      case AppThemeMode.midnightManuscript:
        return _midnightSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: disableGlassTransparency,
        );
      case AppThemeMode.dark:
        return _darkSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: disableGlassTransparency,
        );
      case AppThemeMode.defaultMode:
      case AppThemeMode.calmBeautiful:
      case AppThemeMode.easyRead:
        return _lightSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: disableGlassTransparency,
        );
    }
  }

  static AppBackgroundSpec _noorSpec({
    required AppAppearanceTheme appearance,
    required AppBackgroundAtmosphere atmosphere,
    required bool disableGlassTransparency,
  }) {
    final quranLift = atmosphere == AppBackgroundAtmosphere.quran;
    final tintTopAlpha = disableGlassTransparency
        ? (quranLift ? 0.18 : 0.14)
        : (quranLift ? 0.12 : 0.08);
    final tintBottomAlpha = disableGlassTransparency
        ? (quranLift ? 0.30 : 0.24)
        : (quranLift ? 0.22 : 0.16);
    final glowAlpha = disableGlassTransparency
        ? (quranLift ? 0.10 : 0.08)
        : (quranLift ? 0.16 : 0.12);

    return AppBackgroundSpec(
      baseGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFF8F4EE),
          Color.lerp(
            appearance.background,
            appearance.accent,
            quranLift ? 0.08 : 0.05,
          )!,
          appearance.backgroundAlt,
        ],
        stops: const [0, 0.48, 1],
      ),
      wallpaperTintGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: tintTopAlpha),
          appearance.background.withValues(alpha: tintBottomAlpha),
        ],
      ),
      foregroundGlowGradient: RadialGradient(
        center: quranLift ? const Alignment(0, -0.92) : const Alignment(0, -1),
        radius: quranLift ? 1.08 : 0.96,
        colors: [
          Colors.white.withValues(alpha: glowAlpha * 0.9),
          appearance.accent.withValues(alpha: glowAlpha),
          Colors.transparent,
        ],
        stops: const [0, 0.34, 1],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFFFFCF8),
          Color.alphaBlend(
            appearance.accent.withValues(alpha: 0.10),
            appearance.background,
          ),
          appearance.backgroundAlt,
        ],
      ),
    );
  }

  static AppBackgroundSpec _lightSpec({
    required AppAppearanceTheme appearance,
    required AppBackgroundAtmosphere atmosphere,
    required bool disableGlassTransparency,
  }) {
    final quranLift = atmosphere == AppBackgroundAtmosphere.quran;
    final warmth = quranLift ? 0.18 : 0.12;
    final glowAlpha = disableGlassTransparency ? 0.08 : 0.14;

    return AppBackgroundSpec(
      baseGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(appearance.background, appearance.accent, warmth)!,
          appearance.background,
          appearance.backgroundAlt,
        ],
        stops: const [0, 0.46, 1],
      ),
      wallpaperTintGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          appearance.background.withValues(alpha: quranLift ? 0.34 : 0.24),
          appearance.backgroundAlt.withValues(alpha: quranLift ? 0.54 : 0.42),
        ],
      ),
      foregroundGlowGradient: RadialGradient(
        center: quranLift ? const Alignment(0, -0.95) : const Alignment(0, -1),
        radius: quranLift ? 1.1 : 0.95,
        colors: [
          appearance.accent.withValues(alpha: glowAlpha),
          Colors.transparent,
        ],
        stops: const [0, 1],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(appearance.background, appearance.accent, 0.10)!,
          appearance.backgroundAlt,
        ],
      ),
    );
  }

  static AppBackgroundSpec _darkSpec({
    required AppAppearanceTheme appearance,
    required AppBackgroundAtmosphere atmosphere,
    required bool disableGlassTransparency,
  }) {
    final quranLift = atmosphere == AppBackgroundAtmosphere.quran;
    final glowAlpha = disableGlassTransparency ? 0.07 : 0.12;

    return AppBackgroundSpec(
      baseGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(appearance.backgroundAlt, appearance.accent, 0.08)!,
          appearance.background,
          const Color(0xFF101215),
        ],
        stops: const [0, 0.42, 1],
      ),
      wallpaperTintGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          appearance.background.withValues(alpha: quranLift ? 0.58 : 0.48),
          Colors.black.withValues(alpha: quranLift ? 0.68 : 0.60),
        ],
      ),
      foregroundGlowGradient: RadialGradient(
        center: quranLift ? const Alignment(0, -0.9) : const Alignment(0, -1),
        radius: quranLift ? 1.05 : 0.92,
        colors: [
          appearance.accent.withValues(alpha: glowAlpha),
          Colors.transparent,
        ],
        stops: const [0, 1],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(appearance.backgroundAlt, appearance.accent, 0.08)!,
          appearance.background,
        ],
      ),
    );
  }

  static AppBackgroundSpec _midnightSpec({
    required AppAppearanceTheme appearance,
    required AppBackgroundAtmosphere atmosphere,
    required bool disableGlassTransparency,
  }) {
    final quranLift = atmosphere == AppBackgroundAtmosphere.quran;
    final goldLiftAlpha = disableGlassTransparency
        ? (quranLift ? 0.08 : 0.06)
        : (quranLift ? 0.16 : 0.11);
    final jadeShadowAlpha = disableGlassTransparency ? 0.04 : 0.08;

    return AppBackgroundSpec(
      baseGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF121821),
          appearance.background,
          const Color(0xFF0A0E14),
        ],
        stops: const [0, 0.44, 1],
      ),
      wallpaperTintGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xB20A0F15),
          appearance.background.withValues(alpha: quranLift ? 0.84 : 0.78),
          Colors.black.withValues(alpha: quranLift ? 0.72 : 0.64),
        ],
        stops: const [0, 0.56, 1],
      ),
      foregroundGlowGradient: RadialGradient(
        center: quranLift ? const Alignment(0, -0.86) : const Alignment(0, -1),
        radius: quranLift ? 1.16 : 1.0,
        colors: [
          appearance.accent.withValues(alpha: goldLiftAlpha),
          appearance.success.withValues(alpha: jadeShadowAlpha),
          Colors.transparent,
        ],
        stops: const [0, 0.38, 1],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF151B24),
          Color.alphaBlend(
            appearance.accent.withValues(alpha: 0.10),
            appearance.background,
          ),
          const Color(0xFF090D13),
        ],
      ),
    );
  }
}
