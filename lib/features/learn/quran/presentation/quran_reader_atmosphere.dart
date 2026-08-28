
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/widgets/night_sky.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../domain/quran_reader_atmosphere.dart';

export '../domain/quran_reader_atmosphere.dart';

String quranReaderAtmosphereLabel(
  AppLocalizations l10n,
  QuranReaderAtmosphere atmosphere,
) {
  switch (atmosphere) {
    case QuranReaderAtmosphere.followApp:
      return l10n.quranReaderAtmosphereFollowApp;
    case QuranReaderAtmosphere.noorGlass:
      return l10n.quranReaderAtmosphereNoorGlass;
    case QuranReaderAtmosphere.midnight:
      return l10n.quranReaderAtmosphereMidnight;
    case QuranReaderAtmosphere.candlelight:
      return l10n.quranReaderAtmosphereCandlelight;
    case QuranReaderAtmosphere.jummah:
      return l10n.settingsThemeChoiceJummah;
  }
}

/// Turns the persisted setting into a concrete atmosphere: an explicit
/// choice wins; "match app theme" maps night app themes to their own
/// atmosphere and everything else to Noor Glass.
QuranReaderAtmosphere resolveQuranReaderAtmosphere(
  QuranReaderAtmosphere setting,
  AppAppearanceTheme? appearance,
) {
  if (setting != QuranReaderAtmosphere.followApp) return setting;
  if (appearance == null) return QuranReaderAtmosphere.noorGlass;
  if (appearance.mode == AppThemeMode.candlelight) {
    return QuranReaderAtmosphere.candlelight;
  }
  if (appearance.mode == AppThemeMode.jummah) {
    return QuranReaderAtmosphere.jummah;
  }
  if (appearance.isDark) return QuranReaderAtmosphere.midnight;
  return QuranReaderAtmosphere.noorGlass;
}

/// Resolved colors for one atmosphere. Noor Glass mirrors what the surfaces
/// render today; the two dark atmospheres carry their own ink so text never
/// runs through the light-theme translucency pipeline on a dark ground.
class QuranReaderAtmospherePalette {
  const QuranReaderAtmospherePalette._({
    required this.atmosphere,
    required this.isDark,
    required this.base,
    required this.primaryText,
    required this.supportText,
    required this.subtleText,
    required this.arabicText,
    required this.harakat,
    required this.chipFill,
    required this.chipBorder,
    required this.chipContent,
    required this.controlsFill,
    required this.controlsContent,
    required this.playFill,
    required this.playForeground,
  });

  final QuranReaderAtmosphere atmosphere;
  final bool isDark;

  /// Deepest background stop; used as the Scaffold color so route
  /// transitions never flash a mismatched frame.
  final Color base;
  final Color primaryText;
  final Color supportText;
  final Color subtleText;
  final Color arabicText;
  final Color harakat;
  final Color chipFill;
  final Color chipBorder;
  final Color chipContent;
  final Color controlsFill;
  final Color controlsContent;
  final Color playFill;
  final Color playForeground;

  static const _noorGlass = QuranReaderAtmospherePalette._(
    atmosphere: QuranReaderAtmosphere.noorGlass,
    isDark: false,
    base: Color(0xFFF8F2E8),
    primaryText: AppColors.onSurface,
    supportText: Color(0xFF3D3025),
    subtleText: AppColors.onSurfaceSubtle,
    arabicText: Color(0xFF3A3025),
    harakat: Color(0xFFC22A2A),
    chipFill: Color(0xB8FFFFFF),
    chipBorder: Color(0xCCCCB79D),
    chipContent: Color(0xFF6A5A4A),
    controlsFill: Color(0x9EFFF8EC),
    controlsContent: Color(0xFF4A3C2F),
    playFill: Color(0xF04A3C2F),
    playForeground: Colors.white,
  );

  static const _midnight = QuranReaderAtmospherePalette._(
    atmosphere: QuranReaderAtmosphere.midnight,
    isDark: true,
    base: Color(0xFF121423),
    primaryText: Color(0xFFEFE8D7),
    supportText: Color(0xFFE6DEC9),
    subtleText: Color(0xFFC9C0AA),
    arabicText: Color(0xFFF5EFDF),
    harakat: Color(0xFFE58B72),
    chipFill: Color(0x14F0E8D7),
    chipBorder: Color(0x2EF0E8D7),
    chipContent: Color(0xFFD8CFB8),
    controlsFill: Color(0x1AF0E8D7),
    controlsContent: Color(0xFFEFE8D7),
    playFill: Color(0xFFE9DDBF),
    playForeground: Color(0xFF1A1F33),
  );

  static const _candlelight = QuranReaderAtmospherePalette._(
    atmosphere: QuranReaderAtmosphere.candlelight,
    isDark: true,
    base: Color(0xFF15100B),
    primaryText: Color(0xFFEFE2C8),
    supportText: Color(0xFFE5D5B4),
    subtleText: Color(0xFFC4B394),
    arabicText: Color(0xFFF3E7CC),
    harakat: Color(0xFFE8946B),
    chipFill: Color(0x14EFE2C8),
    chipBorder: Color(0x2EEFE2C8),
    chipContent: Color(0xFFD6C5A2),
    controlsFill: Color(0x1AEFE2C8),
    controlsContent: Color(0xFFEFE2C8),
    playFill: Color(0xFFE3CD9F),
    playForeground: Color(0xFF241C12),
  );

  static const _jummah = QuranReaderAtmospherePalette._(
    atmosphere: QuranReaderAtmosphere.jummah,
    isDark: true,
    base: Color(0xFF0D271E),
    primaryText: Color(0xFFEAF2E6),
    supportText: Color(0xFFDFEAD9),
    subtleText: Color(0xFFB8C9B4),
    arabicText: Color(0xFFF0EFD8),
    harakat: Color(0xFFE2A379),
    chipFill: Color(0x14EAF2E6),
    chipBorder: Color(0x2EEAF2E6),
    chipContent: Color(0xFFCBD9C4),
    controlsFill: Color(0x1AEAF2E6),
    controlsContent: Color(0xFFEAF2E6),
    playFill: Color(0xFFDCC07A),
    playForeground: Color(0xFF16382C),
  );

  static QuranReaderAtmospherePalette of(QuranReaderAtmosphere atmosphere) {
    switch (atmosphere) {
      // followApp is resolved before palettes are looked up; fall back to the
      // default look if it ever reaches here unresolved.
      case QuranReaderAtmosphere.followApp:
      case QuranReaderAtmosphere.noorGlass:
        return _noorGlass;
      case QuranReaderAtmosphere.midnight:
        return _midnight;
      case QuranReaderAtmosphere.candlelight:
        return _candlelight;
      case QuranReaderAtmosphere.jummah:
        return _jummah;
    }
  }

  /// Arabic verse color, routed through the existing translucency pipeline on
  /// Noor Glass (unchanged from today) and painted directly on dark grounds,
  /// where that pipeline would wash the ivory out.
  TextStyle arabicStyle(BuildContext context, TextStyle base) {
    if (!isDark) {
      return QuranPresentationStyle.translucentTextStyle(context, base);
    }
    return base.copyWith(color: arabicText.withValues(alpha: 0.96));
  }

  Color harakatColor(BuildContext context) {
    if (!isDark) {
      return QuranPresentationStyle.translucentHarakatColor(context);
    }
    return harakat.withValues(alpha: 0.92);
  }

  TextStyle supportStyle(
    BuildContext context,
    TextStyle base, {
    bool italic = false,
  }) {
    if (!isDark) {
      return QuranPresentationStyle.quranSupportTextStyle(
        context,
        base,
        italic: italic,
      );
    }
    return base.copyWith(
      color: italic ? subtleText : supportText,
      fontStyle: italic ? FontStyle.italic : base.fontStyle,
    );
  }
}

/// Paints the atmosphere behind [child].
///
/// Noor Glass carries the Mihrab Glow: a soft radial crown whose warmth
/// follows the time of day — pale gold around Fajr, near-invisible through
/// the day, amber toward Maghrib, a dim ember at night.
class QuranReaderAtmosphereBackground extends ConsumerWidget {
  const QuranReaderAtmosphereBackground({
    super.key,
    required this.atmosphere,
    required this.child,
  });

  final QuranReaderAtmosphere atmosphere;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (atmosphere) {
      case QuranReaderAtmosphere.followApp:
      case QuranReaderAtmosphere.noorGlass:
        final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFF8F2E8), Color(0xFFEDE3D6)],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -1.15),
                radius: 1.15,
                colors: <Color>[_mihrabGlowColor(now), Colors.transparent],
                stops: const <double>[0.0, 0.62],
              ),
            ),
            child: child,
          ),
        );
      case QuranReaderAtmosphere.midnight:
        final skyNow = ref.watch(dailyNowProvider).value ?? DateTime.now();
        return DecoratedBox(
          decoration: const BoxDecoration(gradient: midnightSkyGradient),
          child: CustomPaint(
            painter: MidnightSkyPainter(now: skyNow),
            child: child,
          ),
        );
      case QuranReaderAtmosphere.candlelight:
        return DecoratedBox(
          decoration: const BoxDecoration(gradient: candlelightBaseGradient),
          child: DecoratedBox(
            decoration: const BoxDecoration(gradient: candlelightGlowGradient),
            child: child,
          ),
        );
      case QuranReaderAtmosphere.jummah:
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.85),
              radius: 1.5,
              colors: <Color>[
                Color(0xFF1E4B3A),
                Color(0xFF16382C),
                Color(0xFF0D271E),
              ],
              stops: <double>[0.0, 0.48, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: MihrabArchPainter(),
            child: child,
          ),
        );
    }
  }

  /// Hour-of-day warmth for the Mihrab Glow. Bucketed rather than tied to the
  /// computed prayer schedule so the glow works before location setup; the
  /// prayer-clock wiring can replace this once atmospheres go app-wide.
  static Color _mihrabGlowColor(DateTime now) {
    final hour = now.hour;
    if (hour >= 4 && hour < 8) {
      // Dawn: pale gold.
      return const Color(0xFFE9C478).withValues(alpha: 0.30);
    }
    if (hour >= 8 && hour < 16) {
      // Day: barely-there warmth.
      return const Color(0xFFE9B060).withValues(alpha: 0.14);
    }
    if (hour >= 16 && hour < 20) {
      // Toward Maghrib: amber.
      return const Color(0xFFE69E4A).withValues(alpha: 0.36);
    }
    // Night: dim ember.
    return const Color(0xFFC49654).withValues(alpha: 0.16);
  }
}

