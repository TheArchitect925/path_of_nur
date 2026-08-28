import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'app_spacing.dart';
import 'app_radii.dart';
import 'app_fonts.dart';

enum AppThemeMode {
  defaultMode,
  calmBeautiful,
  easyRead,
  dark,
  noorGlass,
  noorGlassDark,
  noGlass,
  noGlassDark,
  midnightManuscript,
  noorMidnightManuscript,
  noorKids,
}

enum AppPageTransitionStyle { defaultSystem, gentleFade, iosStyle, noAnimation }

const double _glassContrastAlphaMin = 0.82;
const double _glassContrastAlphaMax = 0.95;
const double _glassContrastFactorMaxBoost = 0.08;

class AppAppearanceTheme extends ThemeExtension<AppAppearanceTheme> {
  const AppAppearanceTheme({
    required this.mode,
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceSoft,
    required this.frostedGlassTone,
    required this.sanctuarySurfaceTone,
    required this.sanctuaryEdgeLight,
    required this.inputSurface,
    required this.onSurface,
    required this.onSurfaceSubtle,
    required this.onSurfaceMuted,
    required this.accent,
    required this.accentSoft,
    required this.border,
    required this.divider,
    required this.success,
    required this.quranArabicEmphasis,
    required this.makkiFill,
    required this.makkiBorder,
    required this.madaniFill,
    required this.madaniBorder,
    required this.glassSurfaceAlpha,
    required this.glassBorderAlpha,
    required this.disableGlassTransparency,
    required this.disableColoredGlass,
    required this.disableBackground,
  });

  final AppThemeMode mode;
  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceSoft;
  final Color frostedGlassTone;
  final Color sanctuarySurfaceTone;
  final Color sanctuaryEdgeLight;
  final Color inputSurface;
  final Color onSurface;
  final Color onSurfaceSubtle;
  final Color onSurfaceMuted;
  final Color accent;
  final Color accentSoft;
  final Color border;
  final Color divider;
  final Color success;
  final Color quranArabicEmphasis;
  final Color makkiFill;
  final Color makkiBorder;
  final Color madaniFill;
  final Color madaniBorder;
  final double glassSurfaceAlpha;
  final double glassBorderAlpha;
  final bool disableGlassTransparency;
  final bool disableColoredGlass;
  final bool disableBackground;
  bool get isDark =>
      mode == AppThemeMode.dark ||
      mode == AppThemeMode.noorGlassDark ||
      mode == AppThemeMode.noGlassDark ||
      mode == AppThemeMode.midnightManuscript ||
      mode == AppThemeMode.noorMidnightManuscript;

  bool get isMidnightFamily =>
      mode == AppThemeMode.midnightManuscript ||
      mode == AppThemeMode.noorMidnightManuscript;

  bool get isNoorGlassFamily =>
      mode == AppThemeMode.noorGlass ||
      mode == AppThemeMode.noorGlassDark ||
      mode == AppThemeMode.noorMidnightManuscript ||
      mode == AppThemeMode.noorKids;

  bool get isNoorGlassPrimaryFamily =>
      mode == AppThemeMode.noorGlass || mode == AppThemeMode.noorGlassDark;

  bool get isNoGlassFamily =>
      mode == AppThemeMode.noGlass || mode == AppThemeMode.noGlassDark;

  bool get resolvesGlassDisabled =>
      disableGlassTransparency || isNoGlassFamily || isNoorGlassPrimaryFamily;

  bool get resolvesColoredGlassDisabled =>
      disableColoredGlass || isNoGlassFamily;

  double get glassContrastProgress {
    if (resolvesGlassDisabled) {
      return 0;
    }
    final range = _glassContrastAlphaMax - _glassContrastAlphaMin;
    if (range <= 0) {
      return 0;
    }
    return ((_glassContrastAlphaMax - glassSurfaceAlpha) / range).clamp(
      0.0,
      1.0,
    );
  }

  double get glassContrastFactor =>
      1.0 + (glassContrastProgress * _glassContrastFactorMaxBoost);

  Color get glassOnSurface => _scaledGlassTextColor(onSurface, strength: 0.92);

  Color get glassOnSurfaceSubtle =>
      _scaledGlassTextColor(onSurfaceSubtle, strength: 0.72);

  Color get glassOnSurfaceCaption => _scaledGlassTextColor(
    onSurfaceSubtle.withValues(alpha: isDark ? 0.94 : 0.88),
    strength: 0.56,
  );

  Color get backgroundForeground => isDark && !disableBackground
      ? (isMidnightFamily ? const Color(0xFFE1D0AB) : const Color(0xFF2A231C))
      : onSurface;

  Color get backgroundForegroundSubtle => isDark && !disableBackground
      ? (isMidnightFamily ? const Color(0xFF9D8860) : const Color(0xFF4F4438))
      : onSurfaceSubtle;

  Color get navLabelActive => isMidnightFamily
      ? quranArabicEmphasis
      : isNoorGlassFamily
      ? quranArabicEmphasis
      : glassOnSurface;

  Color get navLabelInactive => isMidnightFamily
      ? onSurfaceMuted
      : isNoorGlassFamily
      ? onSurfaceSubtle
      : glassOnSurfaceSubtle;

  Color get navActiveFill => isMidnightFamily
      ? Color.alphaBlend(accent.withValues(alpha: 0.18), surfaceSoft)
      : isNoorGlassFamily
      ? Color.alphaBlend(accent.withValues(alpha: 0.14), surfaceSoft)
      : accent.withValues(alpha: isDark ? 0.22 : 0.16);

  Color get inputFocus =>
      isMidnightFamily || isNoorGlassFamily ? accent : accentSoft;

  Color get chipSelectedFill => isMidnightFamily
      ? accent.withValues(alpha: 0.18)
      : isNoorGlassFamily
      ? accent.withValues(alpha: 0.15)
      : accent.withValues(alpha: isDark ? 0.22 : 0.16);

  Color get chipSelectedText =>
      isMidnightFamily || isNoorGlassFamily ? quranArabicEmphasis : onSurface;

  Color get chipUnselectedFill => isMidnightFamily
      ? inputSurface.withValues(alpha: 0.90)
      : isNoorGlassFamily
      ? inputSurface.withValues(alpha: 0.76)
      : inputSurface;

  Color get outlinedButtonFill => isMidnightFamily
      ? surfaceSoft.withValues(alpha: 0.62)
      : isNoorGlassFamily
      ? surface.withValues(alpha: 0.34)
      : surface.withValues(alpha: isDark ? 0.38 : 0.18);

  Color get filledButtonFill => isMidnightFamily
      ? Color.alphaBlend(accent.withValues(alpha: 0.20), surfaceSoft)
      : isNoorGlassFamily
      ? Color.alphaBlend(accent.withValues(alpha: 0.18), surfaceSoft)
      : accent;

  Color _scaledGlassTextColor(Color color, {double strength = 1.0}) {
    final progress = (glassContrastProgress * strength).clamp(0.0, 1.0);
    if (progress <= 0) {
      return color;
    }
    final overlay = (isDark ? Colors.white : Colors.black).withValues(
      alpha: 0.10 * progress,
    );
    return Color.alphaBlend(overlay, color);
  }

  static AppAppearanceTheme defaults({
    required AppThemeMode mode,
    required bool disableGlassTransparency,
    required bool disableColoredGlass,
    required bool disableBackground,
    required double glassSurfaceAlpha,
  }) {
    switch (mode) {
      case AppThemeMode.defaultMode:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFFEDE6DF),
          backgroundAlt: const Color(0xFFE2D8CC),
          surface: const Color(0xFFF5EEE5),
          surfaceSoft: const Color(0xFFECE1D4),
          frostedGlassTone: const Color(0xFFF9F1DE),
          sanctuarySurfaceTone: const Color(0xFFF8EFDE),
          sanctuaryEdgeLight: const Color(0xFFF6E3B7),
          inputSurface: const Color(0xFFF7F0E8),
          onSurface: const Color(0xFF3D3025),
          onSurfaceSubtle: const Color(0xFF6D5C4C),
          onSurfaceMuted: const Color(0xFF8A7865),
          accent: const Color(0xFFDABE8D),
          accentSoft: const Color(0xFFB9955E),
          border: const Color(0xFFB9955E),
          divider: const Color(0xFFD7C5AE),
          success: const Color(0xFFA8C9A8),
          quranArabicEmphasis: const Color(0xFF4A3720),
          makkiFill: const Color(0x26A67C2C),
          makkiBorder: const Color(0xFFA67C2C),
          madaniFill: const Color(0x22488667),
          madaniBorder: const Color(0xFF4F8264),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.96
              : glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency ? 0.42 : 0.42,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.calmBeautiful:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFFEDE6DF),
          backgroundAlt: const Color(0xFFE2D8CC),
          surface: const Color(0xFFF5EEE5),
          surfaceSoft: const Color(0xFFECE1D4),
          frostedGlassTone: const Color(0xFFF9F1DE),
          sanctuarySurfaceTone: const Color(0xFFF8EFDE),
          sanctuaryEdgeLight: const Color(0xFFF6E3B7),
          inputSurface: const Color(0xFFF7F0E8),
          onSurface: const Color(0xFF3D3025),
          onSurfaceSubtle: const Color(0xFF6D5C4C),
          onSurfaceMuted: const Color(0xFF8A7865),
          accent: const Color(0xFFDABE8D),
          accentSoft: const Color(0xFFB9955E),
          border: const Color(0xFFB9955E),
          divider: const Color(0xFFD7C5AE),
          success: const Color(0xFFA8C9A8),
          quranArabicEmphasis: const Color(0xFF4A3720),
          makkiFill: const Color(0x26A67C2C),
          makkiBorder: const Color(0xFFA67C2C),
          madaniFill: const Color(0x22488667),
          madaniBorder: const Color(0xFF4F8264),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.96
              : glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency ? 0.42 : 0.42,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.easyRead:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFFF3EFE9),
          backgroundAlt: const Color(0xFFE9E2D8),
          surface: const Color(0xFFF8F4ED),
          surfaceSoft: const Color(0xFFEEE6DA),
          frostedGlassTone: const Color(0xFFFBF3E4),
          sanctuarySurfaceTone: const Color(0xFFF9F2E4),
          sanctuaryEdgeLight: const Color(0xFFF7E3B8),
          inputSurface: const Color(0xFFF9F5EE),
          onSurface: const Color(0xFF2C221A),
          onSurfaceSubtle: const Color(0xFF4B3D30),
          onSurfaceMuted: const Color(0xFF6B5B49),
          accent: const Color(0xFFC6AA78),
          accentSoft: const Color(0xFFA48756),
          border: const Color(0xFFB0915E),
          divider: const Color(0xFFDACAB0),
          success: const Color(0xFF98C3A5),
          quranArabicEmphasis: const Color(0xFF3A2A1E),
          makkiFill: const Color(0x26A67C2C),
          makkiBorder: const Color(0xFFA67C2C),
          madaniFill: const Color(0x22488667),
          madaniBorder: const Color(0xFF4F8264),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.98
              : glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency ? 0.48 : 0.46,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.dark:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFF121315),
          backgroundAlt: const Color(0xFF1A1C1F),
          surface: const Color(0xFF1D2024),
          surfaceSoft: const Color(0xFF252A30),
          frostedGlassTone: const Color(0xFFE7DEC9),
          sanctuarySurfaceTone: const Color(0xFFEADFC7),
          sanctuaryEdgeLight: const Color(0xFFCBB37E),
          inputSurface: const Color(0xFF1F2328),
          onSurface: const Color(0xFFEDE5D7),
          onSurfaceSubtle: const Color(0xFFC8BDAA),
          onSurfaceMuted: const Color(0xFFA49582),
          accent: const Color(0xFFBFA572),
          accentSoft: const Color(0xFF927647),
          border: const Color(0xFF5E4A28),
          divider: const Color(0xFF30271A),
          success: const Color(0xFF89B2A1),
          quranArabicEmphasis: const Color(0xFFF4E8CC),
          makkiFill: const Color(0x3A9C6F28),
          makkiBorder: const Color(0xFFB28C46),
          madaniFill: const Color(0x333D7E5A),
          madaniBorder: const Color(0xFF71AE8B),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.98
              : glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency ? 0.40 : 0.38,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.noorGlass:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFFF4EFE5),
          backgroundAlt: const Color(0xFFE9E0CF),
          surface: const Color(0xFFFBF6ED),
          surfaceSoft: const Color(0xFFF3E9D9),
          frostedGlassTone: const Color(0xFFFBF0D8),
          sanctuarySurfaceTone: const Color(0xFFF9EEDB),
          sanctuaryEdgeLight: const Color(0xFFF2DCB2),
          inputSurface: const Color(0xFFF7EFE2),
          onSurface: const Color(0xFF3A2E22),
          onSurfaceSubtle: const Color(0xFF655444),
          onSurfaceMuted: const Color(0xFF85715E),
          accent: const Color(0xFFD3B280),
          accentSoft: const Color(0xFFAA8651),
          border: const Color(0xFFD8C4A2),
          divider: const Color(0xFFE4D7C0),
          success: const Color(0xFFA7C8BE),
          quranArabicEmphasis: const Color(0xFF413429),
          makkiFill: const Color(0x24B48B43),
          makkiBorder: const Color(0xFFBC9750),
          madaniFill: const Color(0x2279B2A4),
          madaniBorder: const Color(0xFF6EA798),
          glassSurfaceAlpha: 0.985,
          glassBorderAlpha: 0.42,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.noorGlassDark:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFF17191D),
          backgroundAlt: const Color(0xFF1E2228),
          surface: const Color(0xFF252A31),
          surfaceSoft: const Color(0xFF2D343C),
          frostedGlassTone: const Color(0xFFF0DFC0),
          sanctuarySurfaceTone: const Color(0xFFEEDFC2),
          sanctuaryEdgeLight: const Color(0xFFDFC493),
          inputSurface: const Color(0xFF2A3038),
          onSurface: const Color(0xFFF0E4D0),
          onSurfaceSubtle: const Color(0xFFD0C0AA),
          onSurfaceMuted: const Color(0xFFA79681),
          accent: const Color(0xFFCFAA70),
          accentSoft: const Color(0xFFA27E46),
          border: const Color(0xFF786242),
          divider: const Color(0xFF392E20),
          success: const Color(0xFF8AB7A9),
          quranArabicEmphasis: const Color(0xFFF6E9CF),
          makkiFill: const Color(0x2EB48A3B),
          makkiBorder: const Color(0xFFD0B586),
          madaniFill: const Color(0x2A79B2A4),
          madaniBorder: const Color(0xFF79B2A4),
          glassSurfaceAlpha: 0.99,
          glassBorderAlpha: 0.40,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.noGlass:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFFF4F0E7),
          backgroundAlt: const Color(0xFFE8E0D3),
          surface: const Color(0xFFFCF8F1),
          surfaceSoft: const Color(0xFFF4EBDD),
          frostedGlassTone: const Color(0xFFFCF2E0),
          sanctuarySurfaceTone: const Color(0xFFFFF1DC),
          sanctuaryEdgeLight: const Color(0xFFF2DCB1),
          inputSurface: const Color(0xFFF8F1E7),
          onSurface: const Color(0xFF382C22),
          onSurfaceSubtle: const Color(0xFF605142),
          onSurfaceMuted: const Color(0xFF857360),
          accent: const Color(0xFFD0B27E),
          accentSoft: const Color(0xFFA88752),
          border: const Color(0xFFD7C4A7),
          divider: const Color(0xFFE4D8C8),
          success: const Color(0xFFA7C5A8),
          quranArabicEmphasis: const Color(0xFF443426),
          makkiFill: const Color(0x25B38A3F),
          makkiBorder: const Color(0xFFB99047),
          madaniFill: const Color(0x2272A292),
          madaniBorder: const Color(0xFF6B9B8C),
          glassSurfaceAlpha: 0.985,
          glassBorderAlpha: 0.48,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.noGlassDark:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFF131518),
          backgroundAlt: const Color(0xFF191C20),
          surface: const Color(0xFF20242A),
          surfaceSoft: const Color(0xFF282D34),
          frostedGlassTone: const Color(0xFFEADBBC),
          sanctuarySurfaceTone: const Color(0xFFE8DBC0),
          sanctuaryEdgeLight: const Color(0xFFD9C092),
          inputSurface: const Color(0xFF23282F),
          onSurface: const Color(0xFFEEE2CE),
          onSurfaceSubtle: const Color(0xFFCEBFA9),
          onSurfaceMuted: const Color(0xFFA79681),
          accent: const Color(0xFFC7A96E),
          accentSoft: const Color(0xFF9B7B45),
          border: const Color(0xFF6C5737),
          divider: const Color(0xFF342A1D),
          success: const Color(0xFF86B0A1),
          quranArabicEmphasis: const Color(0xFFF4E8CE),
          makkiFill: const Color(0x2EAF8539),
          makkiBorder: const Color(0xFFC7A96E),
          madaniFill: const Color(0x2A6DA395),
          madaniBorder: const Color(0xFF6DA395),
          glassSurfaceAlpha: 0.99,
          glassBorderAlpha: 0.42,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.midnightManuscript:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFF0D1117),
          backgroundAlt: const Color(0xFF111418),
          surface: const Color(0xFF111418),
          surfaceSoft: const Color(0xFF161B22),
          frostedGlassTone: const Color(0xFFE8D8B8),
          sanctuarySurfaceTone: const Color(0xFFEEE0C6),
          sanctuaryEdgeLight: const Color(0xFFE3CC97),
          inputSurface: const Color(0xFF171D25),
          onSurface: const Color(0xFFE8DCC8),
          onSurfaceSubtle: const Color(0xFF8A7A5A),
          onSurfaceMuted: const Color(0xFF6A5C3A),
          accent: const Color(0xFFC9A84C),
          accentSoft: const Color(0xFF9E7E2F),
          border: const Color(0xFF2A2210),
          divider: const Color(0xFF3A2A0A),
          success: const Color(0xFF7EB5A6),
          quranArabicEmphasis: const Color(0xFFF0E4C9),
          makkiFill: const Color(0x2EB48936),
          makkiBorder: const Color(0xFFC9A84C),
          madaniFill: const Color(0x2A7EB5A6),
          madaniBorder: const Color(0xFF7EB5A6),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.985
              : glassSurfaceAlpha.clamp(0.84, 0.95),
          glassBorderAlpha: disableGlassTransparency ? 0.44 : 0.40,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.noorMidnightManuscript:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFF0F131A),
          backgroundAlt: const Color(0xFF151922),
          surface: const Color(0xFF171B22),
          surfaceSoft: const Color(0xFF1C222B),
          frostedGlassTone: const Color(0xFFF1DEB8),
          sanctuarySurfaceTone: const Color(0xFFF3E4C8),
          sanctuaryEdgeLight: const Color(0xFFE8D09F),
          inputSurface: const Color(0xFF1B212A),
          onSurface: const Color(0xFFEFE2CC),
          onSurfaceSubtle: const Color(0xFFB29F7B),
          onSurfaceMuted: const Color(0xFF86724D),
          accent: const Color(0xFFD2B15C),
          accentSoft: const Color(0xFFAA8535),
          border: const Color(0xFF3A2D14),
          divider: const Color(0xFF483514),
          success: const Color(0xFF85BCAA),
          quranArabicEmphasis: const Color(0xFFF4E7CB),
          makkiFill: const Color(0x31CC9E3B),
          makkiBorder: const Color(0xFFD2B15C),
          madaniFill: const Color(0x2D85BCAA),
          madaniBorder: const Color(0xFF85BCAA),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.986
              : glassSurfaceAlpha.clamp(0.82, 0.92),
          glassBorderAlpha: disableGlassTransparency ? 0.42 : 0.37,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
      case AppThemeMode.noorKids:
        return AppAppearanceTheme(
          mode: mode,
          background: const Color(0xFFF5F1E6),
          backgroundAlt: const Color(0xFFEAE5D7),
          surface: const Color(0xFFFDF9F1),
          surfaceSoft: const Color(0xFFF4EEDC),
          frostedGlassTone: const Color(0xFFFBF1DA),
          sanctuarySurfaceTone: const Color(0xFFFFF3DE),
          sanctuaryEdgeLight: const Color(0xFFF9E2B4),
          inputSurface: const Color(0xFFF9F4E9),
          onSurface: const Color(0xFF3C3024),
          onSurfaceSubtle: const Color(0xFF655646),
          onSurfaceMuted: const Color(0xFF867663),
          accent: const Color(0xFF9BC5B2),
          accentSoft: const Color(0xFF7AA68E),
          border: const Color(0xFFD8C6A4),
          divider: const Color(0xFFE7DDC9),
          success: const Color(0xFFB7D8A2),
          quranArabicEmphasis: const Color(0xFF473728),
          makkiFill: const Color(0x25D6B86A),
          makkiBorder: const Color(0xFFD2AF62),
          madaniFill: const Color(0x238BC8BC),
          madaniBorder: const Color(0xFF7AA68E),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.97
              : glassSurfaceAlpha.clamp(0.76, 0.86),
          glassBorderAlpha: disableGlassTransparency ? 0.40 : 0.30,
          disableGlassTransparency: disableGlassTransparency,
          disableColoredGlass: disableColoredGlass,
          disableBackground: disableBackground,
        );
    }
  }

  @override
  ThemeExtension<AppAppearanceTheme> copyWith({
    AppThemeMode? mode,
    Color? background,
    Color? backgroundAlt,
    Color? surface,
    Color? surfaceSoft,
    Color? frostedGlassTone,
    Color? sanctuarySurfaceTone,
    Color? sanctuaryEdgeLight,
    Color? inputSurface,
    Color? onSurface,
    Color? onSurfaceSubtle,
    Color? onSurfaceMuted,
    Color? accent,
    Color? accentSoft,
    Color? border,
    Color? divider,
    Color? success,
    Color? quranArabicEmphasis,
    Color? makkiFill,
    Color? makkiBorder,
    Color? madaniFill,
    Color? madaniBorder,
    double? glassSurfaceAlpha,
    double? glassBorderAlpha,
    bool? disableGlassTransparency,
    bool? disableColoredGlass,
    bool? disableBackground,
  }) {
    return AppAppearanceTheme(
      mode: mode ?? this.mode,
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      surface: surface ?? this.surface,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      frostedGlassTone: frostedGlassTone ?? this.frostedGlassTone,
      sanctuarySurfaceTone: sanctuarySurfaceTone ?? this.sanctuarySurfaceTone,
      sanctuaryEdgeLight: sanctuaryEdgeLight ?? this.sanctuaryEdgeLight,
      inputSurface: inputSurface ?? this.inputSurface,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceSubtle: onSurfaceSubtle ?? this.onSurfaceSubtle,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      quranArabicEmphasis: quranArabicEmphasis ?? this.quranArabicEmphasis,
      makkiFill: makkiFill ?? this.makkiFill,
      makkiBorder: makkiBorder ?? this.makkiBorder,
      madaniFill: madaniFill ?? this.madaniFill,
      madaniBorder: madaniBorder ?? this.madaniBorder,
      glassSurfaceAlpha: glassSurfaceAlpha ?? this.glassSurfaceAlpha,
      glassBorderAlpha: glassBorderAlpha ?? this.glassBorderAlpha,
      disableGlassTransparency:
          disableGlassTransparency ?? this.disableGlassTransparency,
      disableColoredGlass: disableColoredGlass ?? this.disableColoredGlass,
      disableBackground: disableBackground ?? this.disableBackground,
    );
  }

  @override
  ThemeExtension<AppAppearanceTheme> lerp(
    covariant ThemeExtension<AppAppearanceTheme>? other,
    double t,
  ) {
    if (other is! AppAppearanceTheme) return this;
    return AppAppearanceTheme(
      mode: t < 0.5 ? mode : other.mode,
      background: Color.lerp(background, other.background, t) ?? background,
      backgroundAlt:
          Color.lerp(backgroundAlt, other.backgroundAlt, t) ?? backgroundAlt,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t) ?? surfaceSoft,
      frostedGlassTone:
          Color.lerp(frostedGlassTone, other.frostedGlassTone, t) ??
          frostedGlassTone,
      sanctuarySurfaceTone:
          Color.lerp(sanctuarySurfaceTone, other.sanctuarySurfaceTone, t) ??
          sanctuarySurfaceTone,
      sanctuaryEdgeLight:
          Color.lerp(sanctuaryEdgeLight, other.sanctuaryEdgeLight, t) ??
          sanctuaryEdgeLight,
      inputSurface:
          Color.lerp(inputSurface, other.inputSurface, t) ?? inputSurface,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      onSurfaceSubtle:
          Color.lerp(onSurfaceSubtle, other.onSurfaceSubtle, t) ??
          onSurfaceSubtle,
      onSurfaceMuted:
          Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t) ?? onSurfaceMuted,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t) ?? accentSoft,
      border: Color.lerp(border, other.border, t) ?? border,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      success: Color.lerp(success, other.success, t) ?? success,
      quranArabicEmphasis:
          Color.lerp(quranArabicEmphasis, other.quranArabicEmphasis, t) ??
          quranArabicEmphasis,
      makkiFill: Color.lerp(makkiFill, other.makkiFill, t) ?? makkiFill,
      makkiBorder: Color.lerp(makkiBorder, other.makkiBorder, t) ?? makkiBorder,
      madaniFill: Color.lerp(madaniFill, other.madaniFill, t) ?? madaniFill,
      madaniBorder:
          Color.lerp(madaniBorder, other.madaniBorder, t) ?? madaniBorder,
      glassSurfaceAlpha:
          glassSurfaceAlpha + (other.glassSurfaceAlpha - glassSurfaceAlpha) * t,
      glassBorderAlpha:
          glassBorderAlpha + (other.glassBorderAlpha - glassBorderAlpha) * t,
      disableGlassTransparency: t < 0.5
          ? disableGlassTransparency
          : other.disableGlassTransparency,
      disableColoredGlass: t < 0.5
          ? disableColoredGlass
          : other.disableColoredGlass,
      disableBackground: t < 0.5 ? disableBackground : other.disableBackground,
    );
  }
}

class AppTheme {
  const AppTheme._();

  static ThemeData themeFor({
    required AppThemeMode mode,
    required AppPageTransitionStyle pageTransitionStyle,
    required bool reduceMotion,
    required bool disableGlassTransparency,
    required bool disableColoredGlass,
    required bool disableBackground,
    required bool highContrastText,
    required double glassSurfaceAlpha,
    Locale? locale,
  }) {
    final appearance = AppAppearanceTheme.defaults(
      mode: mode,
      disableGlassTransparency: disableGlassTransparency,
      disableColoredGlass: disableColoredGlass,
      disableBackground: disableBackground,
      glassSurfaceAlpha: glassSurfaceAlpha,
    );

    final onSurface = appearance.onSurface;
    final onSurfaceSubtle = highContrastText
        ? appearance.onSurface
        : appearance.onSurfaceSubtle;
    final outlineColor = highContrastText
        ? onSurface.withValues(alpha: 0.55)
        : appearance.divider.withValues(alpha: 0.42);
    final mutedIconColor = highContrastText ? onSurface : onSurfaceSubtle;
    final brightness = appearance.isDark ? Brightness.dark : Brightness.light;
    final localeUiFont = AppFonts.uiFontFamilyForLocale(locale);
    final localeUsesRtlUiFont = AppFonts.usesRtlUiFont(locale);
    final serifOrLocaleUi = localeUsesRtlUiFont
        ? localeUiFont
        : AppFonts.latinSerif;

    final themeData = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: appearance.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: appearance.accent,
        brightness: brightness,
        primary: appearance.accent,
        secondary: appearance.accentSoft,
        onPrimary: onSurface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceSubtle,
        outline: outlineColor,
        outlineVariant: outlineColor.withValues(
          alpha: highContrastText ? 0.4 : 0.24,
        ),
        surface: appearance.surface,
        surfaceContainerHighest: appearance.surfaceSoft,
      ),
      iconTheme: IconThemeData(color: onSurface),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: onSurface,
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: onSurface,
          fontSize: 25,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          fontFamily: serifOrLocaleUi,
        ),
        titleMedium: TextStyle(
          color: onSurface,
          fontSize: 19,
          fontWeight: FontWeight.w600,
          fontFamily: serifOrLocaleUi,
        ),
        titleSmall: TextStyle(
          color: onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: serifOrLocaleUi,
        ),
        bodyLarge: TextStyle(
          color: onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.45,
          fontFamily: serifOrLocaleUi,
        ),
        bodyMedium: TextStyle(
          color: onSurfaceSubtle,
          fontSize: 14,
          height: 1.45,
          fontFamily: serifOrLocaleUi,
        ),
        bodySmall: TextStyle(
          color: onSurfaceSubtle,
          fontSize: 13,
          fontFamily: serifOrLocaleUi,
        ),
        labelLarge: TextStyle(
          color: onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: localeUiFont,
        ),
        labelMedium: TextStyle(
          color: onSurface,
          fontSize: 12,
          fontFamily: localeUiFont,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: appearance.surface.withValues(
          alpha: appearance.glassSurfaceAlpha,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadii.card)),
          side: BorderSide(
            color: appearance.accent.withValues(
              alpha: appearance.glassBorderAlpha,
            ),
            width: 1.0,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: appearance.surfaceSoft.withValues(
          alpha: appearance.resolvesGlassDisabled
              ? (appearance.isDark ? 0.94 : 0.96)
              : appearance.isMidnightFamily
              ? 0.84
              : appearance.isNoorGlassFamily
              ? 0.68
              : 0.80,
        ),
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: appearance.navLabelActive);
          }
          return IconThemeData(color: appearance.navLabelInactive);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: appearance.navLabelActive,
              fontWeight: FontWeight.w700,
              fontFamily: localeUiFont,
            );
          }
          return TextStyle(
            color: appearance.navLabelInactive,
            fontWeight: FontWeight.w500,
            fontFamily: localeUiFont,
          );
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: onSurface,
        unselectedLabelColor: onSurfaceSubtle,
        labelStyle: TextStyle(
          fontFamily: localeUiFont,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: localeUiFont,
          fontWeight: FontWeight.w500,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return appearance.chipSelectedText;
            }
            if (states.contains(WidgetState.disabled)) {
              return onSurfaceSubtle.withValues(alpha: 0.50);
            }
            return onSurfaceSubtle;
          }),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontFamily: localeUiFont),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return appearance.chipSelectedFill;
            }
            return appearance.chipUnselectedFill.withValues(
              alpha: appearance.isDark ? 0.76 : 0.88,
            );
          }),
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              color: states.contains(WidgetState.selected)
                  ? appearance.accent.withValues(alpha: 0.75)
                  : outlineColor.withValues(alpha: 0.70),
            );
          }),
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return onSurfaceSubtle.withValues(alpha: 0.55);
            }
            return states.contains(WidgetState.selected)
                ? appearance.chipSelectedText
                : onSurfaceSubtle;
          }),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(
          color: onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.35,
          fontFamily: serifOrLocaleUi,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(appearance.inputSurface),
          shadowColor: WidgetStatePropertyAll(
            onSurface.withValues(alpha: 0.16),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: outlineColor, thickness: 1),
      listTileTheme: ListTileThemeData(
        iconColor: mutedIconColor,
        textColor: onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        labelStyle: TextStyle(
          color: onSurface,
          fontWeight: highContrastText ? FontWeight.w600 : FontWeight.w500,
          fontFamily: localeUiFont,
        ),
        hintStyle: TextStyle(
          color: onSurfaceSubtle,
          fontWeight: highContrastText ? FontWeight.w500 : FontWeight.w400,
          fontFamily: localeUiFont,
        ),
        helperStyle: TextStyle(
          color: onSurfaceSubtle,
          fontFamily: localeUiFont,
        ),
        counterStyle: TextStyle(
          color: onSurfaceSubtle,
          fontFamily: localeUiFont,
        ),
        fillColor: appearance.inputSurface.withValues(
          alpha: appearance.resolvesGlassDisabled
              ? (appearance.isDark ? 0.96 : 0.98)
              : appearance.isMidnightFamily
              ? 0.94
              : appearance.isNoorGlassFamily
              ? 0.78
              : appearance.isDark
              ? 0.88
              : 0.92,
        ),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.button),
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.button),
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.button),
          borderSide: BorderSide(
            color: highContrastText ? onSurface : appearance.inputFocus,
            width: highContrastText ? 1.6 : 1.2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: appearance.chipUnselectedFill,
        selectedColor: appearance.chipSelectedFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadii.pill)),
        ),
        side: BorderSide(color: appearance.border.withValues(alpha: 0.88)),
        showCheckmark: false,
        labelStyle: TextStyle(color: onSurface, fontFamily: localeUiFont),
        secondaryLabelStyle: TextStyle(
          color: onSurface,
          fontFamily: localeUiFont,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            appearance.isMidnightFamily
                ? appearance.quranArabicEmphasis
                : appearance.isNoorGlassFamily
                ? appearance.quranArabicEmphasis
                : onSurface,
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontFamily: localeUiFont),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return appearance.filledButtonFill.withValues(alpha: 0.40);
            }
            return appearance.filledButtonFill;
          }),
          foregroundColor: WidgetStatePropertyAll(onSurface),
          overlayColor: WidgetStatePropertyAll(
            appearance.accent.withValues(alpha: 0.12),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w700, fontFamily: localeUiFont),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return appearance.outlinedButtonFill.withValues(alpha: 0.18);
            }
            return appearance.outlinedButtonFill;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? outlineColor.withValues(alpha: 0.35)
                  : appearance.border.withValues(
                      alpha: appearance.isMidnightFamily
                          ? 0.86
                          : appearance.isNoorGlassFamily
                          ? 0.74
                          : 0.64,
                    ),
            );
          }),
          foregroundColor: WidgetStatePropertyAll(onSurface),
          overlayColor: WidgetStatePropertyAll(
            appearance.accent.withValues(alpha: 0.08),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontFamily: localeUiFont),
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[appearance],
    );

    final effectiveTransitionStyle = reduceMotion
        ? AppPageTransitionStyle.noAnimation
        : pageTransitionStyle;
    final transitionsTheme = _pageTransitionsThemeFor(effectiveTransitionStyle);
    if (transitionsTheme == null) {
      return themeData;
    }
    return themeData.copyWith(pageTransitionsTheme: transitionsTheme);
  }

  static final ThemeData darkTheme = themeFor(
    mode: AppThemeMode.dark,
    pageTransitionStyle: AppPageTransitionStyle.defaultSystem,
    reduceMotion: false,
    disableGlassTransparency: false,
    disableColoredGlass: false,
    disableBackground: false,
    highContrastText: false,
    glassSurfaceAlpha: 0.93,
  );
}

PageTransitionsTheme? _pageTransitionsThemeFor(AppPageTransitionStyle style) {
  if (style == AppPageTransitionStyle.defaultSystem) {
    return null;
  }
  final builder = switch (style) {
    AppPageTransitionStyle.defaultSystem =>
      const FadeUpwardsPageTransitionsBuilder(),
    AppPageTransitionStyle.gentleFade =>
      const _GentleFadePageTransitionsBuilder(),
    AppPageTransitionStyle.iosStyle => const CupertinoPageTransitionsBuilder(),
    AppPageTransitionStyle.noAnimation =>
      const _NoAnimationPageTransitionsBuilder(),
  };
  return PageTransitionsTheme(
    builders: {for (final platform in TargetPlatform.values) platform: builder},
  );
}

class _GentleFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const _GentleFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
      child: child,
    );
  }
}

class _NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
