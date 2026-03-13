import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import '../../features/wallpaper/application/wallpaper_provider.dart';

const double _backgroundDecodeScale = 1.1;

class GlobalBackground extends ConsumerWidget {
  const GlobalBackground({
    super.key,
    this.assetPath,
    this.overlayColor,
  });

  final String? assetPath;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallpaper = ref.watch(selectedWallpaperProvider);
    final settings = ref.watch(profileSettingsProvider);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final fallbackColor = appearance?.background ?? AppColors.background;

    if (settings.disableBackground || appearance?.disableBackground == true) {
      return Positioned.fill(child: ColoredBox(color: fallbackColor));
    }

    final effectiveAsset = assetPath ?? wallpaper.assetPath;
    final mediaSize = MediaQuery.sizeOf(context);
    final cacheWidth = (mediaSize.width * _backgroundDecodeScale).round();
    final cacheHeight = (mediaSize.height * _backgroundDecodeScale).round();

    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            effectiveAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            cacheWidth: cacheWidth > 0 ? cacheWidth : null,
            cacheHeight: cacheHeight > 0 ? cacheHeight : null,
            filterQuality: FilterQuality.none,
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) =>
                ColoredBox(color: fallbackColor),
          ),
          if (overlayColor != null) ColoredBox(color: overlayColor!),
        ],
      ),
    );
  }
}
