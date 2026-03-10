import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/wallpaper/application/wallpaper_provider.dart';

class GlobalBackground extends ConsumerWidget {
  const GlobalBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallpaper = ref.watch(selectedWallpaperProvider);
    return Positioned.fill(
      child: Image.asset(
        wallpaper.assetPath,
        fit: BoxFit.cover,
        color: const Color(0xFFEDE6DE).withValues(alpha: 0.65),
        colorBlendMode: BlendMode.srcATop,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEDE6DE), Color(0xFFE2D8CC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
