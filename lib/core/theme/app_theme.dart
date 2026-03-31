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
  midnightManuscript,
}

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
      mode == AppThemeMode.dark || mode == AppThemeMode.midnightManuscript;

  double get glassContrastProgress {
    if (disableGlassTransparency) {
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
      ? (mode == AppThemeMode.midnightManuscript
            ? const Color(0xFFE1D0AB)
            : const Color(0xFF2A231C))
      : onSurface;

  Color get backgroundForegroundSubtle => isDark && !disableBackground
      ? (mode == AppThemeMode.midnightManuscript
            ? const Color(0xFF9D8860)
            : const Color(0xFF4F4438))
      : onSurfaceSubtle;

  Color get navLabelActive => mode == AppThemeMode.midnightManuscript
      ? quranArabicEmphasis
      : mode == AppThemeMode.noorGlass
      ? quranArabicEmphasis
      : glassOnSurface;

  Color get navLabelInactive => mode == AppThemeMode.midnightManuscript
      ? onSurfaceMuted
      : mode == AppThemeMode.noorGlass
      ? onSurfaceSubtle
      : glassOnSurfaceSubtle;

  Color get navActiveFill => mode == AppThemeMode.midnightManuscript
      ? Color.alphaBlend(accent.withValues(alpha: 0.18), surfaceSoft)
      : mode == AppThemeMode.noorGlass
      ? Color.alphaBlend(accent.withValues(alpha: 0.14), surfaceSoft)
      : accent.withValues(alpha: isDark ? 0.22 : 0.16);

  Color get inputFocus =>
      mode == AppThemeMode.midnightManuscript || mode == AppThemeMode.noorGlass
      ? accent
      : accentSoft;

  Color get chipSelectedFill => mode == AppThemeMode.midnightManuscript
      ? accent.withValues(alpha: 0.18)
      : mode == AppThemeMode.noorGlass
      ? accent.withValues(alpha: 0.15)
      : accent.withValues(alpha: isDark ? 0.22 : 0.16);

  Color get chipSelectedText =>
      mode == AppThemeMode.midnightManuscript || mode == AppThemeMode.noorGlass
      ? quranArabicEmphasis
      : onSurface;

  Color get chipUnselectedFill => mode == AppThemeMode.midnightManuscript
      ? inputSurface.withValues(alpha: 0.90)
      : mode == AppThemeMode.noorGlass
      ? inputSurface.withValues(alpha: 0.76)
      : inputSurface;

  Color get outlinedButtonFill => mode == AppThemeMode.midnightManuscript
      ? surfaceSoft.withValues(alpha: 0.62)
      : mode == AppThemeMode.noorGlass
      ? surface.withValues(alpha: 0.34)
      : surface.withValues(alpha: isDark ? 0.38 : 0.18);

  Color get filledButtonFill => mode == AppThemeMode.midnightManuscript
      ? Color.alphaBlend(accent.withValues(alpha: 0.20), surfaceSoft)
      : mode == AppThemeMode.noorGlass
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
          background: const Color(0xFFF3EFE8),
          backgroundAlt: const Color(0xFFE7E0D6),
          surface: const Color(0xFFF8F4EE),
          surfaceSoft: const Color(0xFFF1EADF),
          inputSurface: const Color(0xFFFCF8F2),
          onSurface: const Color(0xFF372D24),
          onSurfaceSubtle: const Color(0xFF605244),
          onSurfaceMuted: const Color(0xFF837463),
          accent: const Color(0xFFD6BE96),
          accentSoft: const Color(0xFFB69A73),
          border: const Color(0xFFD8C7AE),
          divider: const Color(0xFFE7DBCB),
          success: const Color(0xFFA7C8BE),
          quranArabicEmphasis: const Color(0xFF413429),
          makkiFill: const Color(0x24B48B43),
          makkiBorder: const Color(0xFFBC9750),
          madaniFill: const Color(0x2279B2A4),
          madaniBorder: const Color(0xFF6EA798),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.96
              : glassSurfaceAlpha.clamp(0.72, 0.82),
          glassBorderAlpha: disableGlassTransparency ? 0.34 : 0.28,
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
    }
  }

  @override
  ThemeExtension<AppAppearanceTheme> copyWith({
    AppThemeMode? mode,
    Color? background,
    Color? backgroundAlt,
    Color? surface,
    Color? surfaceSoft,
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
    final serifOrLocaleUi = localeUsesRtlUiFont ? localeUiFont : 'serif';

    return ThemeData(
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
          alpha: appearance.mode == AppThemeMode.midnightManuscript
              ? 0.84
              : appearance.mode == AppThemeMode.noorGlass
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
          alpha: appearance.mode == AppThemeMode.midnightManuscript
              ? 0.94
              : appearance.mode == AppThemeMode.noorGlass
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
            appearance.mode == AppThemeMode.midnightManuscript
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
                      alpha: appearance.mode == AppThemeMode.midnightManuscript
                          ? 0.86
                          : appearance.mode == AppThemeMode.noorGlass
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
  }

  static final ThemeData darkTheme = themeFor(
    mode: AppThemeMode.dark,
    disableGlassTransparency: false,
    disableColoredGlass: false,
    disableBackground: false,
    highContrastText: false,
    glassSurfaceAlpha: 0.93,
  );
}
