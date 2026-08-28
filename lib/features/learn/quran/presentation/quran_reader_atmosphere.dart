import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../domain/quran_reader_atmosphere.dart';

export '../domain/quran_reader_atmosphere.dart';

String quranReaderAtmosphereLabel(
  AppLocalizations l10n,
  QuranReaderAtmosphere atmosphere,
) {
  switch (atmosphere) {
    case QuranReaderAtmosphere.noorGlass:
      return l10n.quranReaderAtmosphereNoorGlass;
    case QuranReaderAtmosphere.midnight:
      return l10n.quranReaderAtmosphereMidnight;
    case QuranReaderAtmosphere.candlelight:
      return l10n.quranReaderAtmosphereCandlelight;
  }
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

  static QuranReaderAtmospherePalette of(QuranReaderAtmosphere atmosphere) {
    switch (atmosphere) {
      case QuranReaderAtmosphere.noorGlass:
        return _noorGlass;
      case QuranReaderAtmosphere.midnight:
        return _midnight;
      case QuranReaderAtmosphere.candlelight:
        return _candlelight;
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
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.85),
              radius: 1.5,
              colors: <Color>[
                Color(0xFF232A44),
                Color(0xFF1A1F33),
                Color(0xFF121423),
              ],
              stops: <double>[0.0, 0.48, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: _MidnightStarsPainter(),
            child: child,
          ),
        );
      case QuranReaderAtmosphere.candlelight:
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.55),
              radius: 1.6,
              colors: <Color>[
                Color(0xFF241C12),
                Color(0xFF1D1610),
                Color(0xFF15100B),
              ],
              stops: <double>[0.0, 0.55, 1.0],
            ),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -1.2),
                radius: 1.1,
                colors: <Color>[Color(0x4DC48A3A), Colors.transparent],
                stops: <double>[0.0, 0.60],
              ),
            ),
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

/// Faint star specks for Midnight, kept to the top and bottom bands where no
/// text sits. Deterministic layout (fixed seed) so frames never shimmer.
class _MidnightStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(19);
    final paint = Paint();
    const starColor = Color(0xFFFFF4D6);
    for (var i = 0; i < 34; i++) {
      final x = random.nextDouble() * size.width;
      final inTopBand = random.nextDouble() < 0.72;
      final y = inTopBand
          ? random.nextDouble() * size.height * 0.16
          : size.height * (0.90 + random.nextDouble() * 0.08);
      final radius = 0.5 + random.nextDouble() * 0.7;
      paint.color = starColor.withValues(
        alpha: 0.18 + random.nextDouble() * 0.5,
      );
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MidnightStarsPainter oldDelegate) => false;
}
