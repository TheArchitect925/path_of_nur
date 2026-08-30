import 'dart:ui' show Brightness;

import '../domain/garden_models.dart';
import '../domain/garden_scene_models.dart';
import 'garden_scene_layout.g.dart';

/// Maps scene elements to generated WebP layers under
/// assets/images/garden_art/, walking variants/stages DOWNWARD through the
/// generator-emitted availability set. A null result means "not produced
/// yet" — the vista's placeholder painter covers it, never a broken image.
class GardenSceneAssetResolver {
  const GardenSceneAssetResolver({Set<String>? availableFiles})
    : _available = availableFiles ?? GardenSceneLayout.availableGardenArtFiles;

  final Set<String> _available;

  static const String _dir = 'assets/images/garden_art';

  String? _existing(String fileName) =>
      _available.contains(fileName) ? '$_dir/$fileName' : null;

  String? skyAsset(GardenAmbientState ambient, Brightness brightness) {
    final key = switch (ambient) {
      GardenAmbientState.quietDawn => 'dawn',
      GardenAmbientState.gentleMorning => 'morning',
      GardenAmbientState.warmLight => 'warm',
      GardenAmbientState.eveningGlow => 'evening',
    };
    if (brightness == Brightness.dark) {
      final night = _existing('garden_sky_${key}_night.webp');
      if (night != null) {
        return night;
      }
    }
    return _existing('garden_sky_${key}_day.webp');
  }

  String? groundAsset(Brightness brightness) {
    if (brightness == Brightness.dark) {
      final night = _existing('garden_ground_night.webp');
      if (night != null) {
        return night;
      }
    }
    return _existing('garden_ground_day.webp');
  }

  String? waterAsset(int streamTier, Brightness brightness) {
    for (var tier = streamTier; tier >= 1; tier--) {
      final base = 'garden_water_e${tier.toString().padLeft(2, '0')}';
      if (brightness == Brightness.dark) {
        final night = _existing('${base}_night.webp');
        if (night != null) {
          return night;
        }
      }
      final day = _existing('$base.webp');
      if (day != null) {
        return day;
      }
    }
    return null;
  }

  /// One file for stages 1-4, a trunk+canopy pair for 5-10 (the canopy sways
  /// independently). Walks stages downward until produced art is found.
  List<String>? treeAssets(GardenVisualStageId stage) {
    for (var index = stage.index; index >= 0; index--) {
      final s = (index + 1).toString().padLeft(2, '0');
      if (index >= 4) {
        final trunk = _existing('garden_tree_s${s}_trunk.webp');
        final canopy = _existing('garden_tree_s${s}_canopy.webp');
        if (trunk != null && canopy != null) {
          return [trunk, canopy];
        }
      } else {
        final single = _existing('garden_tree_s$s.webp');
        if (single != null) {
          return [single];
        }
      }
    }
    return null;
  }

  static const Map<GardenSceneElementId, String> _plantNames = {
    GardenSceneElementId.olive: 'olive',
    GardenSceneElementId.datePalm: 'palm',
    GardenSceneElementId.fig: 'fig',
    GardenSceneElementId.pomegranate: 'pomegranate',
    GardenSceneElementId.grapeVine: 'vine',
    GardenSceneElementId.gourd: 'gourd',
    GardenSceneElementId.loteTree: 'sidr',
    GardenSceneElementId.rayhan: 'rayhan',
  };

  String? plantAsset(GardenSceneElementId id, int variantLevel) {
    final name = _plantNames[id];
    if (name == null || variantLevel <= 0) {
      return null;
    }
    for (var variant = variantLevel; variant >= 1; variant--) {
      final path = _existing('garden_plant_${name}_v$variant.webp');
      if (path != null) {
        return path;
      }
    }
    return null;
  }

  static const Map<GardenSceneElementId, String> _spriteNames = {
    GardenSceneElementId.hoopoe: 'hoopoe',
    GardenSceneElementId.ant: 'ants',
    GardenSceneElementId.bee: 'bee',
  };

  String? animalAsset(GardenSceneElementId id) {
    final name = _spriteNames[id];
    if (name == null) {
      return null;
    }
    return _existing('garden_animal_$name.webp');
  }

  String? beehiveAsset() => _existing('garden_animal_beehive.webp');

  String? vignetteAsset() => _existing('garden_fg_vignette.webp');
}
