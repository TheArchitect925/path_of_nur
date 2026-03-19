import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DuaCategoryThemeData {
  const DuaCategoryThemeData({
    required this.surface,
    required this.accent,
    required this.iconBackground,
    required this.border,
    required this.icon,
  });

  final Color surface;
  final Color accent;
  final Color iconBackground;
  final Color border;
  final IconData icon;
}

class DuaCategoryTheme {
  const DuaCategoryTheme._();

  static DuaCategoryThemeData resolve(BuildContext context, String categoryId) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final base = _baseColorForCategory(categoryId);
    final surface = Color.lerp(
      theme.colorScheme.surface,
      base,
      brightness == Brightness.dark ? 0.16 : 0.28,
    )!;
    final accent = Color.lerp(
      theme.colorScheme.onSurface,
      base,
      brightness == Brightness.dark ? 0.42 : 0.72,
    )!;
    return DuaCategoryThemeData(
      surface: surface,
      accent: accent,
      iconBackground: accent.withValues(
        alpha: brightness == Brightness.dark ? 0.22 : 0.12,
      ),
      border: accent.withValues(
        alpha: brightness == Brightness.dark ? 0.28 : 0.18,
      ),
      icon: _iconForCategory(categoryId),
    );
  }

  static Color _baseColorForCategory(String categoryId) {
    switch (categoryId) {
      case 'daily_life':
        return Color.lerp(AppColors.accentGold, AppColors.caution, 0.35)!;
      case 'prayer_and_worship':
        return Color.lerp(AppColors.success, AppColors.accentGoldSoft, 0.20)!;
      case 'home_and_family':
        return Color.lerp(AppColors.backgroundAlt, AppColors.caution, 0.45)!;
      case 'travel_and_movement':
        return Color.lerp(
          AppColors.accentGoldSoft,
          AppColors.onSurfaceSubtle,
          0.18,
        )!;
      case 'situational':
        return Color.lerp(AppColors.caution, AppColors.success, 0.12)!;
      case 'special_days':
        return Color.lerp(AppColors.accentGold, AppColors.success, 0.30)!;
      case 'forgiveness_and_growth':
        return Color.lerp(AppColors.success, AppColors.backgroundAlt, 0.18)!;
      default:
        return AppColors.accentGold;
    }
  }

  static IconData _iconForCategory(String categoryId) {
    switch (categoryId) {
      case 'daily_life':
        return Icons.wb_sunny_rounded;
      case 'prayer_and_worship':
        return Icons.mosque_rounded;
      case 'home_and_family':
        return Icons.home_rounded;
      case 'travel_and_movement':
        return Icons.route_rounded;
      case 'situational':
        return Icons.favorite_rounded;
      case 'special_days':
        return Icons.calendar_month_rounded;
      case 'forgiveness_and_growth':
        return Icons.self_improvement_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }
}
