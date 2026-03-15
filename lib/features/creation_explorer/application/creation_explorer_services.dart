import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

import '../../../core/diagnostics/app_telemetry.dart';
import '../../../core/prayer/prayer_preferences.dart';
import '../../creation_challenges/application/creation_challenge_services.dart';
import '../../creation_challenges/domain/creation_challenge_models.dart';
import '../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../shared/persistence/local_store.dart';
import 'creation_category_mapping_service.dart';
import '../data/creation_explorer_catalog.dart';
import '../domain/creation_explorer_models.dart';

final creationExplorerCameraProvider = FutureProvider<List<CameraDescription>>((ref) async {
  final cameras = await availableCameras();
  return cameras
      .where((camera) => camera.lensDirection == CameraLensDirection.back)
      .toList(growable: false);
});

final creationObjectDetectionServiceProvider = Provider<CreationObjectDetectionService>((ref) {
  return CreationObjectDetectionService(
    ref.watch(creationCategoryMappingServiceProvider),
    ref.watch(creationImageLabelingRuntimeProvider),
  );
});

final creationImageLabelingRuntimeProvider = Provider<CreationImageLabelingRuntime>((ref) {
  return const CreationImageLabelingRuntime();
});

const String creationImageLabelingDeviceOnlyMessage =
    'Image labeling is available on a physical device.';

final creationObservationRepositoryProvider = Provider<CreationObservationRepository>((ref) {
  return CreationObservationRepository(ref.watch(localStoreProvider));
});

final creationExplorerActionServiceProvider = Provider<CreationExplorerActionService>((ref) {
  return CreationExplorerActionService(
    ref: ref,
    store: ref.watch(localStoreProvider),
    oceanDrops: ref.watch(oceanDropsProvider.notifier),
    observations: ref.watch(creationObservationRepositoryProvider),
    prayerPreferences: ref.watch(prayerSettingsProvider).preferences,
    prayerLocation: ref.watch(prayerLocationProvider),
  );
});

final creationObservationsProvider =
    StateNotifierProvider<CreationObservationsController, List<CreationObservation>>((ref) {
      return CreationObservationsController(
        ref.watch(creationObservationRepositoryProvider),
      );
    });

class CreationObservationsController extends StateNotifier<List<CreationObservation>> {
  CreationObservationsController(this._repository) : super(_repository.load());

  final CreationObservationRepository _repository;

  Future<void> reload() async {
    state = _repository.load();
  }

  Future<void> add(CreationObservation observation) async {
    final next = <CreationObservation>[observation, ...state.where((item) => item.id != observation.id)]
        .take(160)
        .toList(growable: false);
    state = next;
    await _repository.saveAll(next);
  }

  Future<void> toggleFavorite(String id) async {
    final next = state
        .map((item) => item.id == id ? item.copyWith(isFavorite: !item.isFavorite) : item)
        .toList(growable: false);
    state = next;
    await _repository.saveAll(next);
  }

  Future<void> updateReflection(String id, String reflection) async {
    final next = state
        .map((item) => item.id == id ? item.copyWith(userReflection: reflection.trim()) : item)
        .toList(growable: false);
    state = next;
    await _repository.saveAll(next);
  }

  Future<void> remove(String id) async {
    final next = state.where((item) => item.id != id).toList(growable: false);
    state = next;
    await _repository.saveAll(next);
  }
}

class CreationObservationRepository {
  const CreationObservationRepository(this._store);

  final LocalStore _store;
  static const _storageKey = 'creation_explorer.observations.v1';

  List<CreationObservation> load() {
    final raw = _store.getJsonList(_storageKey);
    if (raw == null) return const <CreationObservation>[];
    return raw
        .map(CreationObservation.fromJson)
        .whereType<CreationObservation>()
        .toList(growable: false);
  }

  Future<void> saveAll(List<CreationObservation> items) {
    return _store.setJsonList(
      _storageKey,
      items.map((item) => item.toJson()).toList(growable: false),
    );
  }
}

class CreationExplorerActionService {
  const CreationExplorerActionService({
    required Ref ref,
    required LocalStore store,
    required OceanDropService oceanDrops,
    required CreationObservationRepository observations,
    required PrayerPreferences prayerPreferences,
    required PrayerLocationState prayerLocation,
  }) : _ref = ref,
       _store = store,
       _oceanDrops = oceanDrops,
       _observations = observations,
       _prayerPreferences = prayerPreferences,
       _prayerLocation = prayerLocation;

  final Ref _ref;
  final LocalStore _store;
  final OceanDropService _oceanDrops;
  final CreationObservationRepository _observations;
  final PrayerPreferences _prayerPreferences;
  final PrayerLocationState _prayerLocation;

  Future<void> markExplorerOpened() async {
    final todayKey = LocalStore.todayKey();
    final openKey = 'creation_explorer.opened.$todayKey';
    if (!(_store.getBool(openKey) ?? false)) {
      await _store.setBool(openKey, true);
      _oceanDrops.awardDrop(
        actionType: oceanActionCreationExplorerOpened,
        sourceModule: oceanSourceCreation,
        referenceId: todayKey,
      );
    }
    AppTelemetry.logEvent('creation_explorer_opened');
    await _ref.read(creationChallengeServiceProvider.notifier).processEvidence(
      CreationChallengeEvidence(
        ruleType: CreationChallengeRuleType.openExplorer,
        source: CreationExplorerMode.creationExplorer,
        occurredAt: DateTime.now(),
      ),
    );
  }

  void markDetection(CreationDetection detection) {
    AppTelemetry.logEvent(
      'creation_detected',
      metadata: <String, Object?>{
        'category': detection.categoryId.name,
        'confidence': detection.confidence,
        'label': detection.rawLabel,
      },
    );
    _ref.read(creationChallengeServiceProvider.notifier).processEvidence(
      CreationChallengeEvidence(
        ruleType: CreationChallengeRuleType.detectCategory,
        source: CreationExplorerMode.creationExplorer,
        occurredAt: DateTime.now(),
        categoryId: detection.categoryId,
        refId: detection.rawLabel,
      ),
    );
  }

  Future<CreationObservation> saveObservation({
    required CreationDetection detection,
    required CreationVerse verse,
    String? imagePath,
    String? reflection,
  }) async {
    final trimmedReflection = reflection?.trim();
    final observation = CreationObservation(
      id: 'creation_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      locationName: _prayerPreferences.location,
      latitude: _prayerLocation.latitude,
      longitude: _prayerLocation.longitude,
      categoryId: detection.categoryId,
      aiConfidence: detection.confidence,
      imagePath: imagePath,
      selectedVerseId: verse.id,
      userReflection: trimmedReflection?.isEmpty == true ? null : trimmedReflection,
      isFavorite: false,
    );
    final existing = _observations.load().where((item) => item.id != observation.id).toList(growable: true);
    existing.insert(0, observation);
    await _observations.saveAll(existing.take(160).toList(growable: false));
    _oceanDrops.awardDrop(
      actionType: oceanActionCreationObservationSaved,
      sourceModule: oceanSourceCreation,
      referenceId: observation.id,
    );
    if (trimmedReflection != null && trimmedReflection.isNotEmpty) {
      _oceanDrops.awardDrop(
        actionType: oceanActionCreationReflectionWritten,
        sourceModule: oceanSourceCreation,
        referenceId: '${observation.id}:reflection',
      );
      AppTelemetry.logEvent(
        'creation_reflection_written',
        metadata: <String, Object?>{'category': detection.categoryId.name},
      );
    }
    AppTelemetry.logEvent(
      'creation_observation_saved',
      metadata: <String, Object?>{
        'category': detection.categoryId.name,
        'confidence': detection.confidence,
        'hasPhoto': imagePath != null && imagePath.isNotEmpty,
      },
    );
    await _ref.read(creationChallengeServiceProvider.notifier).processEvidence(
      CreationChallengeEvidence(
        ruleType: CreationChallengeRuleType.saveObservation,
        source: CreationExplorerMode.journal,
        occurredAt: observation.timestamp,
        categoryId: detection.categoryId,
        refId: observation.id,
        notes: trimmedReflection,
      ),
    );
    if (trimmedReflection != null && trimmedReflection.isNotEmpty) {
      await _ref.read(creationChallengeServiceProvider.notifier).processEvidence(
        CreationChallengeEvidence(
          ruleType: CreationChallengeRuleType.saveReflection,
          source: CreationExplorerMode.journal,
          occurredAt: observation.timestamp,
          categoryId: detection.categoryId,
          refId: '${observation.id}:reflection',
          notes: trimmedReflection,
        ),
      );
    }
    return observation;
  }
}

class CreationObjectDetectionService {
  const CreationObjectDetectionService(this._mappingService, this._runtime);

  static const double threshold = 0.70;
  final CreationCategoryMappingService _mappingService;
  final CreationImageLabelingRuntime _runtime;

  Future<CreationDetection?> detect({
    required CameraImage image,
    required CameraDescription camera,
  }) async {
    if (!await _runtime.isImageLabelingAvailable()) {
      return null;
    }
    final inputImage = _inputImageFromCameraImage(image, camera);
    if (inputImage == null) return null;
    final labeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: threshold),
    );
    try {
      final labels = await labeler.processImage(inputImage);
      return _bestDetection(labels);
    } finally {
      labeler.close();
    }
  }

  CreationVerse verseForCategory(CreationCategoryId categoryId) {
    final category = creationCategoryById[categoryId] ?? creationExplorerCategories.first;
    return creationVerseById[category.verseIds.first] ?? creationExplorerVerses.first;
  }

  List<CreationVerse> versesForCategory(CreationCategoryId categoryId) {
    final category = creationCategoryById[categoryId] ?? creationExplorerCategories.first;
    return category.verseIds
        .map((id) => creationVerseById[id])
        .whereType<CreationVerse>()
        .toList(growable: false);
  }

  CreationDetection? _bestDetection(List<ImageLabel> labels) {
    CreationDetection? best;
    for (final label in labels) {
      final category = _mapLabel(label.label);
      if (category == null || label.confidence < threshold) continue;
      final candidate = CreationDetection(
        categoryId: category,
        confidence: label.confidence,
        detectedAt: DateTime.now(),
        rawLabel: label.label,
      );
      if (best == null || candidate.confidence > best.confidence) {
        best = candidate;
      }
    }
    return best;
  }

  CreationCategoryId? _mapLabel(String label) {
    return _mappingService.mapRawLabel(label);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image, CameraDescription camera) {
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (rotation == null || format == null) return null;
    final bytes = _concatenatePlanes(image.planes);
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final buffer = BytesBuilder(copy: false);
    for (final plane in planes) {
      buffer.add(plane.bytes);
    }
    return buffer.toBytes();
  }
}

class CreationImageLabelingRuntime {
  const CreationImageLabelingRuntime({
    MethodChannel methodChannel = _defaultMethodChannel,
    TargetPlatform? platformOverride,
    Future<bool> Function()? availabilityOverride,
  }) : _methodChannel = methodChannel,
       _platformOverride = platformOverride,
       _availabilityOverride = availabilityOverride;

  static const MethodChannel _defaultMethodChannel = MethodChannel(
    'path_of_nur/platform_runtime',
  );

  final MethodChannel _methodChannel;
  final TargetPlatform? _platformOverride;
  final Future<bool> Function()? _availabilityOverride;

  Future<bool> isImageLabelingAvailable() async {
    final override = _availabilityOverride;
    if (override != null) return override();
    if (kIsWeb) return false;
    final platform = _platformOverride ?? defaultTargetPlatform;
    if (platform != TargetPlatform.iOS) return true;
    try {
      final isSimulator =
          await _methodChannel.invokeMethod<bool>('isIosSimulator') ?? false;
      return !isSimulator;
    } on MissingPluginException {
      return true;
    } on PlatformException {
      return true;
    }
  }
}
