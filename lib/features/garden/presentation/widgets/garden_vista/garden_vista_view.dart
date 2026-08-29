import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../profile/application/profile_settings_provider.dart';
import '../../../application/garden_scene_provider.dart';
import '../../../data/garden_scene_asset_resolver.dart';
import '../../../data/garden_scene_layout.g.dart';
import '../../../domain/garden_models.dart';
import '../../../domain/garden_scene_models.dart';
import 'garden_motion_painter.dart';
import 'garden_vista_placeholder_painter.dart';

enum GardenVistaCrop { hero, homeCard, full }

/// The living garden scene. One widget serves every surface: the crop window
/// picks which slice of the 2000x1200 design space is shown. Layers come from
/// the generated WebP set when produced; the placeholder painter always
/// paints the full scene beneath, so missing art reads as absence, never as
/// a broken image. Motion (canopy sway + water light) runs only on the hero
/// crop and goes fully still under reduce-motion.
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

class _GardenVistaViewState extends ConsumerState<GardenVistaView>
    with SingleTickerProviderStateMixin {
  AnimationController? _motion;

  bool get _wantsMotion =>
      widget.enableMotion && widget.crop == GardenVistaCrop.hero;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheScene();
  }

  void _precacheScene() {
    final brightness = Theme.of(context).brightness;
    final resolver = widget.resolver;
    final spec = widget.spec;
    final paths = <String?>[
      resolver.skyAsset(spec.ambient, brightness),
      resolver.groundAsset(brightness),
      resolver.waterAsset(spec.water.streamTier, brightness),
      // The next tier/stage too, so a growth moment never pops a decode.
      if (spec.water.streamTier < 5)
        resolver.waterAsset(spec.water.streamTier + 1, brightness),
      ...?resolver.treeAssets(spec.treeStage),
      if (spec.treeStage.index < GardenVisualStageId.values.length - 1)
        ...?resolver.treeAssets(
            GardenVisualStageId.values[spec.treeStage.index + 1]),
    ];
    for (final path in paths) {
      if (path != null) {
        precacheImage(AssetImage(path), context, onError: (_, _) {});
      }
    }
  }

  AnimationController _ensureMotionController() {
    return _motion ??= AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
  }

  void _syncMotion(bool reduceMotion) {
    if (_wantsMotion && !reduceMotion) {
      final controller = _ensureMotionController();
      if (!controller.isAnimating) {
        controller.repeat();
      }
    } else {
      _motion?.stop();
    }
  }

  @override
  void dispose() {
    _motion?.dispose();
    super.dispose();
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
    final reduceMotion = ref
        .watch(profileSettingsProvider.select((value) => value.reduceMotion));
    _syncMotion(reduceMotion);
    final motionActive = _wantsMotion && !reduceMotion;
    final brightness = Theme.of(context).brightness;
    final mode = Theme.of(context).extension<AppAppearanceTheme>()?.mode;
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
                        motion: motionActive ? _ensureMotionController() : null,
                      ),
                    ),
                  ),
                ),
                if (_occasionTintFor(mode) != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration:
                            BoxDecoration(color: _occasionTintFor(mode)),
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

  /// A single low-alpha wash that lets occasion themes harmonize the scene
  /// without bespoke art — the app chrome carries the occasion identity.
  Color? _occasionTintFor(AppThemeMode? mode) {
    return switch (mode) {
      AppThemeMode.ramadan => const Color(0x0F2C2347),
      AppThemeMode.jummah => const Color(0x0D16382C),
      AppThemeMode.laylatAlQadr => const Color(0x14151024),
      AppThemeMode.candlelight => const Color(0x0FB0743B),
      _ => null,
    };
  }
}

class _SceneLayers extends StatelessWidget {
  const _SceneLayers({
    required this.spec,
    required this.resolver,
    required this.brightness,
    this.motion,
  });

  final GardenSceneSpec spec;
  final GardenSceneAssetResolver resolver;
  final Brightness brightness;
  final Animation<double>? motion;

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
    void addLayer(String? assetPath, GardenLayerRect rect, {bool sway = false}) {
      if (assetPath == null) {
        return;
      }
      Widget child = Image.asset(assetPath, fit: BoxFit.fill);
      final animation = motion;
      if (sway && animation != null) {
        // Sway rotates a cached raster around the trunk top — a GPU layer
        // transform, never a re-raster.
        child = AnimatedBuilder(
          animation: animation,
          child: RepaintBoundary(child: child),
          builder: (context, cached) => Transform.rotate(
            angle: math.sin(animation.value * 2 * math.pi * 3) * 0.006,
            alignment: Alignment.bottomCenter,
            child: cached,
          ),
        );
      }
      layers.add(
        Positioned(
          left: rect.x,
          top: rect.y,
          width: rect.w,
          height: rect.h,
          child: child,
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
      if (placement == null || element.id == GardenSceneElementId.centralTree) {
        continue;
      }
      final path = element.kind == GardenSceneElementKind.animal
          ? resolver.animalAsset(element.id)
          : resolver.plantAsset(element.id, element.variantLevel);
      addLayer(path, placement.rect);
    }
    final treePlacement = GardenSceneLayout
        .elementPlacements[GardenSceneElementId.centralTree.name];
    final treeAssets = resolver.treeAssets(spec.treeStage);
    if (treePlacement != null && treeAssets != null) {
      for (final path in treeAssets) {
        addLayer(
          path,
          treePlacement.rect,
          sway: path.contains('_canopy'),
        );
      }
    }
    addLayer(resolver.vignetteAsset(), fullCanvas);
    final animation = motion;
    if (animation != null) {
      layers.add(
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: GardenMotionPainter(
                animation: animation,
                spec: spec,
                brightness: brightness,
              ),
            ),
          ),
        ),
      );
    }
    return Stack(clipBehavior: Clip.none, children: layers);
  }
}
