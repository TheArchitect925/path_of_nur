import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_radii.dart';
import 'app_fonts.dart';

enum AppThemeMode { defaultMode, calmBeautiful, easyRead, dark }

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
  final bool disableBackground;

  bool get isDark => mode == AppThemeMode.dark;

  static AppAppearanceTheme defaults({
    required AppThemeMode mode,
    required bool disableGlassTransparency,
    required bool disableBackground,
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
              : AppColors.glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency
              ? 0.42
              : 0.36,
          disableGlassTransparency: disableGlassTransparency,
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
              : AppColors.glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency ? 0.42 : 0.36,
          disableGlassTransparency: disableGlassTransparency,
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
              : AppColors.glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency ? 0.48 : 0.42,
          disableGlassTransparency: disableGlassTransparency,
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
              : AppColors.glassSurfaceAlpha,
          glassBorderAlpha: disableGlassTransparency ? 0.40 : 0.32,
          disableGlassTransparency: disableGlassTransparency,
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
      disableBackground: t < 0.5 ? disableBackground : other.disableBackground,
    );
  }
}

class AppTheme {
  const AppTheme._();

  static ThemeData themeFor({
    required AppThemeMode mode,
    required bool disableGlassTransparency,
    required bool disableBackground,
    required bool highContrastText,
  }) {
    final appearance = AppAppearanceTheme.defaults(
      mode: mode,
      disableGlassTransparency: disableGlassTransparency,
      disableBackground: disableBackground,
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
        outlineVariant: outlineColor.withValues(alpha: highContrastText ? 0.4 : 0.24),
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
          fontFamily: 'serif',
        ),
        titleMedium: TextStyle(
          color: onSurface,
          fontSize: 19,
          fontWeight: FontWeight.w600,
          fontFamily: 'serif',
        ),
        titleSmall: TextStyle(
          color: onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'serif',
        ),
        bodyLarge: TextStyle(
          color: onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.45,
          fontFamily: 'serif',
        ),
        bodyMedium: TextStyle(
          color: onSurfaceSubtle,
          fontSize: 14,
          height: 1.45,
          fontFamily: 'serif',
        ),
        bodySmall: TextStyle(
          color: onSurfaceSubtle,
          fontSize: 13,
          fontFamily: 'serif',
        ),
        labelLarge: TextStyle(
          color: onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: AppFonts.uiArabic,
        ),
        labelMedium: TextStyle(
          color: onSurface,
          fontSize: 12,
          fontFamily: AppFonts.uiArabic,
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
        backgroundColor: appearance.surface.withValues(alpha: 0.90),
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
              fontFamily: AppFonts.uiArabic,
            );
          }
          return TextStyle(
            color: mutedIconColor,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.uiArabic,
          );
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: onSurface,
        unselectedLabelColor: onSurfaceSubtle,
        labelStyle: TextStyle(
          fontFamily: AppFonts.uiArabic,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppFonts.uiArabic,
          fontWeight: FontWeight.w500,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(onSurface),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: AppFonts.uiArabic,
              fontWeight: FontWeight.w600,
            ),
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
          fontFamily: 'serif',
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
      dividerTheme: DividerThemeData(
        color: outlineColor,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: mutedIconColor,
        textColor: onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        labelStyle: TextStyle(
          color: onSurface,
          fontWeight: highContrastText ? FontWeight.w600 : FontWeight.w500,
          fontFamily: AppFonts.uiArabic,
        ),
        hintStyle: TextStyle(
          color: onSurfaceSubtle,
          fontWeight: highContrastText ? FontWeight.w500 : FontWeight.w400,
          fontFamily: AppFonts.uiArabic,
        ),
        helperStyle: TextStyle(
          color: onSurfaceSubtle,
          fontFamily: AppFonts.uiArabic,
        ),
        counterStyle: TextStyle(
          color: onSurfaceSubtle,
          fontFamily: AppFonts.uiArabic,
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
        labelStyle: TextStyle(color: onSurface, fontFamily: AppFonts.uiArabic),
        secondaryLabelStyle: TextStyle(
          color: onSurface,
          fontFamily: AppFonts.uiArabic,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(onSurface),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: AppFonts.uiArabic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(onSurface),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: AppFonts.uiArabic,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(onSurface),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: AppFonts.uiArabic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[appearance],
    );
  }

  static final ThemeData darkTheme = themeFor(
    mode: AppThemeMode.dark,
    disableGlassTransparency: false,
    disableBackground: false,
    highContrastText: false,
  );
}
