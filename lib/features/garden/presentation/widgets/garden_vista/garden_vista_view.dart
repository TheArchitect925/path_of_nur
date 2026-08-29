import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../profile/application/profile_settings_provider.dart';
import '../../../application/garden_scene_provider.dart';
import '../../../data/garden_scene_asset_resolver.dart';
import '../../../data/garden_scene_layout.g.dart';
import '../../../domain/garden_scene_models.dart';
import 'garden_vista_placeholder_painter.dart';

enum GardenVistaCrop { hero, homeCard, full }

/// The living garden scene. One widget serves every surface: the crop window
/// picks which slice of the 2000x1200 design space is shown. Layers come from
/// the generated WebP set when produced; the placeholder painter always
/// paints the full scene beneath, so missing art reads as absence, never as
/// a broken image.
class GardenVistaView extends ConsumerStatefulWidget {
  const GardenVistaView({
    super.key,
    required this.spec,
    this.crop = GardenVistaCrop.hero,
    this.enableMotion = true,
    this.manageSeenLifecycle = false,
    this.semanticLabel,
    this.resolver = const GardenSceneAssetResolver(),
  });

  final GardenSceneSpec spec;
  final GardenVistaCrop crop;

  /// Reserved for the motion layer (sway/shimmer, added with the art waves).
  /// The compact Home card passes false and never carries a ticker.
  final bool enableMotion;

  /// When true (the GardenPage hero), the vista writes the first-visit
  /// baseline memento silently after the first frame.
  final bool manageSeenLifecycle;

  final String? semanticLabel;
  final GardenSceneAssetResolver resolver;

  @override
  ConsumerState<GardenVistaView> createState() => _GardenVistaViewState();
}

class _GardenVistaViewState extends ConsumerState<GardenVistaView> {
  @override
  void initState() {
    super.initState();
    if (widget.manageSeenLifecycle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref
            .read(gardenSceneSeenControllerProvider)
            .ensureBaseline(widget.spec);
      });
    }
  }

  GardenLayerRect get _cropRect => switch (widget.crop) {
        GardenVistaCrop.hero => GardenSceneLayout.heroCrop,
        GardenVistaCrop.homeCard => GardenSceneLayout.homeCardCrop,
        GardenVistaCrop.full => const GardenLayerRect(
            0,
            0,
            GardenSceneLayout.canvasWidth,
            GardenSceneLayout.canvasHeight,
          ),
      };

  @override
  Widget build(BuildContext context) {
    // Watched now so the motion layer (P4) inherits the dependency; with no
    // controllers yet, reduce-motion already means a perfectly still frame.
    ref.watch(profileSettingsProvider.select((value) => value.reduceMotion));
    final brightness = Theme.of(context).brightness;
    final crop = _cropRect;
    final scene = AspectRatio(
      aspectRatio: crop.w / crop.h,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / crop.w;
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: -crop.x * scale,
                  top: -crop.y * scale,
                  width: GardenSceneLayout.canvasWidth * scale,
                  height: GardenSceneLayout.canvasHeight * scale,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: GardenSceneLayout.canvasWidth,
                      height: GardenSceneLayout.canvasHeight,
                      child: _SceneLayers(
                        spec: widget.spec,
                        resolver: widget.resolver,
                        brightness: brightness,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    final label = widget.semanticLabel;
    if (label == null) {
      return scene;
    }
    return Semantics(label: label, image: true, child: scene);
  }
}

class _SceneLayers extends StatelessWidget {
  const _SceneLayers({
    required this.spec,
    required this.resolver,
    required this.brightness,
  });

  final GardenSceneSpec spec;
  final GardenSceneAssetResolver resolver;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    const fullCanvas = GardenLayerRect(
      0,
      0,
      GardenSceneLayout.canvasWidth,
      GardenSceneLayout.canvasHeight,
    );
    final layers = <Widget>[
      RepaintBoundary(
        child: CustomPaint(
          size: const Size(
            GardenSceneLayout.canvasWidth,
            GardenSceneLayout.canvasHeight,
          ),
          painter: GardenVistaPlaceholderPainter(
            spec: spec,
            brightness: brightness,
          ),
        ),
      ),
    ];
    void addLayer(String? assetPath, GardenLayerRect rect) {
      if (assetPath == null) {
        return;
      }
      layers.add(
        Positioned(
          left: rect.x,
          top: rect.y,
          width: rect.w,
          height: rect.h,
          child: Image.asset(assetPath, fit: BoxFit.fill),
        ),
      );
    }

    addLayer(resolver.skyAsset(spec.ambient, brightness), fullCanvas);
    addLayer(resolver.groundAsset(brightness), GardenSceneLayout.groundRect);
    addLayer(
      resolver.waterAsset(spec.water.streamTier, brightness),
      GardenSceneLayout.waterRect,
    );
    final elements = spec.elements
        .where((element) => element.variantLevel > 0)
        .toList()
      ..sort((a, b) {
        final za = GardenSceneLayout.elementPlacements[a.id.name]?.z ?? 0;
        final zb = GardenSceneLayout.elementPlacements[b.id.name]?.z ?? 0;
        return za.compareTo(zb);
      });
    for (final element in elements) {
      final placement = GardenSceneLayout.elementPlacements[element.id.name];
      if (placement == null) {
        continue;
      }
      if (element.id == GardenSceneElementId.centralTree) {
        continue;
      }
      final path = element.kind == GardenSceneElementKind.animal
          ? resolver.animalAsset(element.id)
          : resolver.plantAsset(element.id, element.variantLevel);
      addLayer(path, placement.rect);
    }
    final treePlacement =
        GardenSceneLayout.elementPlacements[GardenSceneElementId.centralTree.name];
    final treeAssets = resolver.treeAssets(spec.treeStage);
    if (treePlacement != null && treeAssets != null) {
      for (final path in treeAssets) {
        addLayer(path, treePlacement.rect);
      }
    }
    addLayer(resolver.vignetteAsset(), fullCanvas);
    return Stack(clipBehavior: Clip.none, children: layers);
  }
}
