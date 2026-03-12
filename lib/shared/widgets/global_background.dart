import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import '../../features/wallpaper/application/wallpaper_provider.dart';

class GlobalBackground extends ConsumerWidget {
  const GlobalBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallpaper = ref.watch(selectedWallpaperProvider);
    final settings = ref.watch(profileSettingsProvider);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final fallbackColor = appearance?.background ?? AppColors.background;

    if (settings.disableBackground || appearance?.disableBackground == true) {
      return Positioned.fill(child: ColoredBox(color: fallbackColor));
    }

    return Positioned.fill(
      child: Image.asset(
        wallpaper.assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: fallbackColor),
      ),
    );
  }
}
