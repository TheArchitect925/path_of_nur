import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/prayer/prayer_preferences.dart';
import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/living_atmosphere.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import '../../features/wallpaper/application/wallpaper_provider.dart';
import '../application/daily_clock_provider.dart';
import 'night_sky.dart';

const double _backgroundDecodeScale = 1.1;

class GlobalBackground extends ConsumerWidget {
  const GlobalBackground({
    super.key,
    this.assetPath,
    this.overlayColor,
    this.atmosphere = AppBackgroundAtmosphere.standard,
  });

  final String? assetPath;
  final Color? overlayColor;
  final AppBackgroundAtmosphere atmosphere;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallpaper = ref.watch(selectedWallpaperProvider);
    final settings = ref.watch(profileSettingsProvider);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final fallbackColor = appearance?.background ?? AppColors.background;
    final backgroundSpec = AppBackgroundTheme.resolve(
      appearance: appearance,
      disableGlassTransparency: settings.disableGlassTransparency,
      atmosphere: atmosphere,
    );

    if (settings.disableBackground || appearance?.disableBackground == true) {
      return Positioned.fill(child: ColoredBox(color: fallbackColor));
    }

    // Night themes paint their atmosphere instead of a wallpaper photo:
    // Midnight gets the starry sky with the true-phase moon, Candlelight the
    // ember ground with its glow crown (carried by the spec's gradients).
    if (appearance?.isNightFamily == true) {
      final isMidnight = appearance!.mode == AppThemeMode.midnight;
      final isRamadan = appearance.mode == AppThemeMode.ramadan;
      final isQadr = appearance.mode == AppThemeMode.laylatAlQadr;
      final now = isMidnight || isRamadan || isQadr
          ? (ref.watch(dailyNowProvider).value ?? DateTime.now())
          : null;
      return Positioned.fill(
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(gradient: backgroundSpec.baseGradient),
            ),
            if (isMidnight)
              CustomPaint(
                painter: MidnightSkyPainter(
                  now: now!,
                  // Header-height, tucked into the right corner: Home's
                  // greeting is centred, so the moon has to sit outside the
                  // text band. Page titles elsewhere are left-aligned and
                  // stay well clear.
                  moonFraction: const Offset(0.88, 0.105),
                ),
              )
            else if (isRamadan) ...[
              CustomPaint(
                painter: MidnightSkyPainter(
                  now: now!,
                  moonFraction: const Offset(0.88, 0.105),
                  // Violet unlit limb so the crescent sits in the Layali sky.
                  moonShadowColor: const Color(0xFF352B54),
                ),
              ),
              CustomPaint(
                painter: FanoosLanternPainter(
                  glowStrength: fanoosGlowStrengthFor(now),
                  // Hangs left of the page titles, opposite the crescent.
                  lanternFraction: const Offset(0.14, 0.0),
                ),
              ),
            ] else if (isQadr) ...[
              CustomPaint(
                painter: MidnightSkyPainter(
                  now: now!,
                  moonFraction: const Offset(0.88, 0.105),
                  // Near-black violet limb for the Night of Power sky.
                  moonShadowColor: const Color(0xFF241D3F),
                ),
              ),
              CustomPaint(painter: QadrDescentPainter()),
            ] else if (appearance.mode == AppThemeMode.jummah)
              CustomPaint(painter: MihrabArchPainter()),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: backgroundSpec.foregroundGlowGradient,
                ),
              ),
            ),
            if (overlayColor != null) ColoredBox(color: overlayColor!),
          ],
        ),
      );
    }

    // Eid dresses the cream ground with painted bunting instead of a photo.
    if (appearance?.mode == AppThemeMode.eid) {
      return Positioned.fill(
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(gradient: backgroundSpec.baseGradient),
            ),
            CustomPaint(painter: EidBuntingPainter()),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: backgroundSpec.foregroundGlowGradient,
                ),
              ),
            ),
            if (overlayColor != null) ColoredBox(color: overlayColor!),
          ],
        ),
      );
    }

    // Living Atmosphere: on Noor Glass the wallpaper photo gives way to a
    // painted sky that follows the prayer clock — rose-gold dawn, clear
    // day, amber Maghrib. (After dark the app resolves to Midnight before
    // reaching here, so night never paints on this branch.)
    if (assetPath == null &&
        appearance?.mode == AppThemeMode.noorGlass &&
        settings.livingAtmosphere) {
      final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
      final schedule = ref.watch(prayerScheduleContextProvider);
      DateTime? scheduleStart(String id) {
        for (final item in schedule.items) {
          if (item.id == id) return item.windowStartDateTime;
        }
        return null;
      }

      final phase = noorSkyPhaseAt(
        now: now,
        fajrStart: scheduleStart('fajr'),
        maghribStart: scheduleStart('maghrib'),
        ishaStart: scheduleStart('isha'),
      );
      return Positioned.fill(
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(gradient: noorSkyGradientFor(phase)),
            ),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: backgroundSpec.foregroundGlowGradient,
                ),
              ),
            ),
            if (overlayColor != null) ColoredBox(color: overlayColor!),
          ],
        ),
      );
    }

    final effectiveAsset = assetPath ?? wallpaper.assetPath;
    final mediaSize = MediaQuery.sizeOf(context);
    final cacheWidth = (mediaSize.width * _backgroundDecodeScale).round();
    final cacheHeight = (mediaSize.height * _backgroundDecodeScale).round();

    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(gradient: backgroundSpec.baseGradient),
          ),
          Image.asset(
            effectiveAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            cacheWidth: cacheWidth > 0 ? cacheWidth : null,
            cacheHeight: cacheHeight > 0 ? cacheHeight : null,
            filterQuality: FilterQuality.none,
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: backgroundSpec.wallpaperTintGradient,
            ),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: backgroundSpec.foregroundGlowGradient,
              ),
            ),
          ),
          if (overlayColor != null) ColoredBox(color: overlayColor!),
        ],
      ),
    );
  }
}
