import 'package:flutter/material.dart';
import 'app_spacing.dart';
import 'app_radii.dart';
import 'app_fonts.dart';

enum AppThemeMode { defaultMode, calmBeautiful, easyRead, dark }

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
    required this.onSurface,
    required this.onSurfaceSubtle,
    required this.accent,
    required this.accentSoft,
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
  final Color onSurface;
  final Color onSurfaceSubtle;
  final Color accent;
  final Color accentSoft;
  final double glassSurfaceAlpha;
  final double glassBorderAlpha;
  final bool disableGlassTransparency;
  final bool disableColoredGlass;
  final bool disableBackground;

  bool get isDark => mode == AppThemeMode.dark;

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

  Color get backgroundForeground =>
      isDark && !disableBackground ? const Color(0xFF2A231C) : onSurface;

  Color get backgroundForegroundSubtle =>
      isDark && !disableBackground ? const Color(0xFF4F4438) : onSurfaceSubtle;

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
          onSurface: const Color(0xFF3D3025),
          onSurfaceSubtle: const Color(0xFF6D5C4C),
          accent: const Color(0xFFDABE8D),
          accentSoft: const Color(0xFFB9955E),
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
          onSurface: const Color(0xFF3D3025),
          onSurfaceSubtle: const Color(0xFF6D5C4C),
          accent: const Color(0xFFDABE8D),
          accentSoft: const Color(0xFFB9955E),
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
          onSurface: const Color(0xFF2C221A),
          onSurfaceSubtle: const Color(0xFF4B3D30),
          accent: const Color(0xFFC6AA78),
          accentSoft: const Color(0xFFA48756),
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
          onSurface: const Color(0xFFEDE5D7),
          onSurfaceSubtle: const Color(0xFFC8BDAA),
          accent: const Color(0xFFBFA572),
          accentSoft: const Color(0xFF927647),
          glassSurfaceAlpha: disableGlassTransparency
              ? 0.98
              : glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency ? 0.40 : 0.38,
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
    Color? onSurface,
    Color? onSurfaceSubtle,
    Color? accent,
    Color? accentSoft,
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
      onSurface: onSurface ?? this.onSurface,
      onSurfaceSubtle: onSurfaceSubtle ?? this.onSurfaceSubtle,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
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
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      onSurfaceSubtle:
          Color.lerp(onSurfaceSubtle, other.onSurfaceSubtle, t) ??
          onSurfaceSubtle,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t) ?? accentSoft,
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
        : appearance.accentSoft.withValues(alpha: 0.24);
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
        backgroundColor: appearance.surface.withValues(alpha: 0.80),
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: onSurface);
          }
          return IconThemeData(color: mutedIconColor);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: onSurface,
              fontWeight: FontWeight.w600,
              fontFamily: localeUiFont,
            );
          }
          return TextStyle(
            color: mutedIconColor,
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
          foregroundColor: WidgetStatePropertyAll(onSurface),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontFamily: localeUiFont),
          ),
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return onSurfaceSubtle.withValues(alpha: 0.55);
            }
            return onSurface;
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
          backgroundColor: WidgetStatePropertyAll(appearance.surface),
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
            color: highContrastText ? onSurface : appearance.accentSoft,
            width: highContrastText ? 1.6 : 1.2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: appearance.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadii.pill)),
        ),
        side: BorderSide(color: appearance.accentSoft),
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
          foregroundColor: WidgetStatePropertyAll(onSurface),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontFamily: localeUiFont),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(onSurface),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w700, fontFamily: localeUiFont),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(onSurface),
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
