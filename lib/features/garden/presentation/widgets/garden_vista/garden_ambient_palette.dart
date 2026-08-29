import 'package:flutter/material.dart';

import '../../../domain/garden_models.dart';

/// Fixed scene-art palettes for the vista and its fallbacks — art colors,
/// deliberately not theme tokens, mirroring the generator's sky recipes so
/// the painted placeholder and the WebP layers always match. Brightness picks
/// the day or night recipe; the ambient state is worship-derived "inner
/// weather" from GardenService, never the clock.
class GardenAmbientPalette {
  const GardenAmbientPalette._();

  /// Two-stop gradient used by compact fallbacks (the old hero errorBuilder).
  static List<Color> heroFallbackColors(GardenAmbientState state) {
    return switch (state) {
      GardenAmbientState.quietDawn => const [
        Color(0xFFE7DCC9),
        Color(0xFFB8C7A3),
      ],
      GardenAmbientState.gentleMorning => const [
        Color(0xFFF2E3C0),
        Color(0xFF9AB780),
      ],
      GardenAmbientState.warmLight => const [
        Color(0xFFF3DEAF),
        Color(0xFFC98F54),
      ],
      GardenAmbientState.eveningGlow => const [
        Color(0xFFDCC9B7),
        Color(0xFF738B6B),
      ],
    };
  }

  /// Sky gradient stops (top to horizon) per ambient state and brightness.
  static List<Color> skyColors(GardenAmbientState state, Brightness brightness) {
    if (brightness == Brightness.dark) {
      return switch (state) {
        GardenAmbientState.quietDawn => const [
          Color(0xFF101323),
          Color(0xFF181C31),
          Color(0xFF2E3550),
        ],
        GardenAmbientState.gentleMorning => const [
          Color(0xFF141127),
          Color(0xFF201A37),
          Color(0xFF2E2649),
        ],
        GardenAmbientState.warmLight => const [
          Color(0xFF191330),
          Color(0xFF2A2145),
          Color(0xFF4A3560),
        ],
        GardenAmbientState.eveningGlow => const [
          Color(0xFF0D091C),
          Color(0xFF141024),
          Color(0xFF241B3C),
        ],
      };
    }
    return switch (state) {
      GardenAmbientState.quietDawn => const [
        Color(0xFF3D4E79),
        Color(0xFF7A6488),
        Color(0xFFEFC183),
      ],
      GardenAmbientState.gentleMorning => const [
        Color(0xFF39628C),
        Color(0xFF6E93A6),
        Color(0xFFEAD3A2),
      ],
      GardenAmbientState.warmLight => const [
        Color(0xFF8A5E3C),
        Color(0xFFC08A52),
        Color(0xFFF2D6A0),
      ],
      GardenAmbientState.eveningGlow => const [
        Color(0xFF3A2E55),
        Color(0xFF5C4370),
        Color(0xFFD99A66),
      ],
    };
  }

  static const Color ivory = Color(0xFFF0E4C0);
  static const Color gold = Color(0xFFE2C177);

  /// Terrain and foliage recipe per brightness, matching the generator.
  static GardenScenePalette scene(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const GardenScenePalette(
        farHill: Color(0xFF2A3444),
        midHill: Color(0xFF28362B),
        meadowHi: Color(0xFF35482F),
        meadowLo: Color(0xFF243422),
        nearHi: Color(0xFF1F2E1E),
        nearLo: Color(0xFF162216),
        trunk: Color(0xFF2E2118),
        canopyShade: Color(0xFF1C2B1E),
        canopyMid: Color(0xFF2A3D2A),
        canopyLight: Color(0xFF3A5236),
        waterHi: Color(0xFF31456A),
        waterLo: Color(0xFF141F38),
        sea: Color(0xFF25395A),
      );
    }
    return const GardenScenePalette(
      farHill: Color(0xFF8BA08A),
      midHill: Color(0xFF6B8A57),
      meadowHi: Color(0xFF8AA663),
      meadowLo: Color(0xFF57774B),
      nearHi: Color(0xFF4C6944),
      nearLo: Color(0xFF37502F),
      trunk: Color(0xFF5E4632),
      canopyShade: Color(0xFF3C5A3F),
      canopyMid: Color(0xFF5A7A4A),
      canopyLight: Color(0xFF7E9C5F),
      waterHi: Color(0xFFA8C2BE),
      waterLo: Color(0xFF3E5F74),
      sea: Color(0xFF9FBDB9),
    );
  }
}

class GardenScenePalette {
  const GardenScenePalette({
    required this.farHill,
    required this.midHill,
    required this.meadowHi,
    required this.meadowLo,
    required this.nearHi,
    required this.nearLo,
    required this.trunk,
    required this.canopyShade,
    required this.canopyMid,
    required this.canopyLight,
    required this.waterHi,
    required this.waterLo,
    required this.sea,
  });

  final Color farHill;
  final Color midHill;
  final Color meadowHi;
  final Color meadowLo;
  final Color nearHi;
  final Color nearLo;
  final Color trunk;
  final Color canopyShade;
  final Color canopyMid;
  final Color canopyLight;
  final Color waterHi;
  final Color waterLo;
  final Color sea;
}
