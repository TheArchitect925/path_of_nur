import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_radii.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accentGold,
      brightness: Brightness.light,
      primary: AppColors.accentGold,
      secondary: AppColors.accentGoldSoft,
      onPrimary: AppColors.onSurface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceSubtle,
      surface: AppColors.surface,
      surfaceContainerHighest: AppColors.surfaceSoft,
    ),
    iconTheme: const IconThemeData(color: AppColors.onSurface),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.onSurface,
        fontSize: 34,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: AppColors.onSurface,
        fontSize: 25,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        fontFamily: 'serif',
      ),
      titleMedium: TextStyle(
        color: AppColors.onSurface,
        fontSize: 19,
        fontWeight: FontWeight.w600,
        fontFamily: 'serif',
      ),
      titleSmall: TextStyle(
        color: AppColors.onSurface,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        fontFamily: 'serif',
      ),
      bodyLarge: TextStyle(
        color: AppColors.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.45,
        fontFamily: 'serif',
      ),
      bodyMedium: TextStyle(
        color: AppColors.onSurfaceSubtle,
        fontSize: 14,
        height: 1.45,
        fontFamily: 'serif',
      ),
      bodySmall: TextStyle(
        color: AppColors.onSurfaceSubtle,
        fontSize: 13,
        fontFamily: 'serif',
      ),
      labelLarge: TextStyle(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        fontFamily: 'serif',
      ),
      labelMedium: TextStyle(
        color: AppColors.onSurface,
        fontSize: 12,
        fontFamily: 'serif',
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface.withValues(alpha: 0.72),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadii.card)),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      indicatorColor: Colors.transparent,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0x29B79D70),
      thickness: 1,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.onSurfaceSubtle,
      textColor: AppColors.onSurface,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadii.pill)),
      ),
      side: BorderSide(color: AppColors.accentGoldSoft),
      showCheckmark: false,
      labelStyle: TextStyle(color: AppColors.onSurface),
      secondaryLabelStyle: TextStyle(color: AppColors.onSurface),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
    ),
  );
}
