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
    final glassDisabled =
        effectiveAppearance.resolvesGlassDisabled || disableGlassTransparency;

    switch (effectiveAppearance.mode) {
      case AppThemeMode.noorGlass:
      case AppThemeMode.noorKids:
        return _noorSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: glassDisabled,
        );
      case AppThemeMode.noorGlassDark:
        return _noorDarkSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: glassDisabled,
        );
      case AppThemeMode.midnightManuscript:
      case AppThemeMode.noorMidnightManuscript:
        return _midnightSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: glassDisabled,
        );
      case AppThemeMode.midnight:
      case AppThemeMode.candlelight:
        return _nightSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
        );
      case AppThemeMode.dark:
      case AppThemeMode.noGlassDark:
        return _darkSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: glassDisabled,
        );
      case AppThemeMode.defaultMode:
      case AppThemeMode.calmBeautiful:
      case AppThemeMode.easyRead:
      case AppThemeMode.noGlass:
        return _lightSpec(
          appearance: effectiveAppearance,
          atmosphere: atmosphere,
          disableGlassTransparency: glassDisabled,
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

  static AppBackgroundSpec _noorDarkSpec({
    required AppAppearanceTheme appearance,
    required AppBackgroundAtmosphere atmosphere,
    required bool disableGlassTransparency,
  }) {
    final quranLift = atmosphere == AppBackgroundAtmosphere.quran;
    final glowAlpha = disableGlassTransparency
        ? (quranLift ? 0.08 : 0.06)
        : (quranLift ? 0.14 : 0.10);

    return AppBackgroundSpec(
      baseGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(appearance.backgroundAlt, appearance.accent, 0.08)!,
          appearance.background,
          const Color(0xFF0D1015),
        ],
        stops: const [0, 0.42, 1],
      ),
      wallpaperTintGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          appearance.background.withValues(alpha: quranLift ? 0.60 : 0.52),
          Colors.black.withValues(alpha: quranLift ? 0.70 : 0.62),
        ],
      ),
      foregroundGlowGradient: RadialGradient(
        center: quranLift ? const Alignment(0, -0.92) : const Alignment(0, -1),
        radius: quranLift ? 1.04 : 0.94,
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
          Color.lerp(appearance.backgroundAlt, appearance.accent, 0.10)!,
          appearance.background,
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

  /// Painted-atmosphere spec for the Midnight and Candlelight themes: no
  /// wallpaper image — the base gradient IS the sky/ember ground, and the
  /// glow layer carries the candle crown (Midnight's stars and moon are
  /// painted separately by GlobalBackground). The Qur'an atmosphere lifts
  /// the crown slightly for reading warmth.
  static AppBackgroundSpec _nightSpec({
    required AppAppearanceTheme appearance,
    required AppBackgroundAtmosphere atmosphere,
  }) {
    final quranLift = atmosphere == AppBackgroundAtmosphere.quran;
    final isCandlelight = appearance.mode == AppThemeMode.candlelight;
    if (isCandlelight) {
      return AppBackgroundSpec(
        baseGradient: const RadialGradient(
          center: Alignment(0, -0.55),
          radius: 1.6,
          colors: <Color>[
            Color(0xFF241C12),
            Color(0xFF1D1610),
            Color(0xFF15100B),
          ],
          stops: <double>[0.0, 0.55, 1.0],
        ),
        wallpaperTintGradient: const LinearGradient(
          colors: <Color>[Colors.transparent, Colors.transparent],
        ),
        foregroundGlowGradient: RadialGradient(
          center: const Alignment(0, -1.2),
          radius: 1.1,
          colors: <Color>[
            const Color(0xFFC48A3A).withValues(alpha: quranLift ? 0.36 : 0.30),
            Colors.transparent,
          ],
          stops: const <double>[0.0, 0.60],
        ),
      );
    }
    return AppBackgroundSpec(
      baseGradient: const RadialGradient(
        center: Alignment(0, -0.85),
        radius: 1.5,
        colors: <Color>[
          Color(0xFF232A44),
          Color(0xFF1A1F33),
          Color(0xFF121423),
        ],
        stops: <double>[0.0, 0.48, 1.0],
      ),
      wallpaperTintGradient: const LinearGradient(
        colors: <Color>[Colors.transparent, Colors.transparent],
      ),
      foregroundGlowGradient: RadialGradient(
        center: const Alignment(0, -1.1),
        radius: 1.0,
        colors: <Color>[
          const Color(0xFFE9DDBF).withValues(alpha: quranLift ? 0.06 : 0.04),
          Colors.transparent,
        ],
        stops: const <double>[0.0, 0.55],
      ),
    );
  }
}
