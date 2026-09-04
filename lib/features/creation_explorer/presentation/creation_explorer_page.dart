import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_verse_content.dart';
import '../../../shared/widgets/segmented_pill_control.dart';
import '../../creation_challenges/application/creation_challenge_services.dart';
import '../../creation_challenges/domain/creation_challenge_models.dart';
import '../application/creation_explorer_services.dart';
import '../data/creation_explorer_catalog.dart';
import '../domain/creation_explorer_models.dart';
import '../../../core/theme/app_icons.dart';

enum _CreationExplorerTab { camera, discover, journal }

class CreationExplorerPage extends ConsumerStatefulWidget {
  const CreationExplorerPage({super.key});

  @override
  ConsumerState<CreationExplorerPage> createState() =>
      _CreationExplorerPageState();
}

class _CreationExplorerPageState extends ConsumerState<CreationExplorerPage>
    with WidgetsBindingObserver {
  static const _detectionThrottle = Duration(milliseconds: 400);
  static const _staleDetectionWindow = Duration(seconds: 2);

  _CreationExplorerTab _tab = _CreationExplorerTab.camera;
  CameraController? _cameraController;
  bool _cameraPermissionDenied = false;
  bool _isBootstrappingCamera = true;
  bool _isImageLabelingDeviceOnly = false;
  bool _isProcessingFrame = false;
  bool _isStreaming = false;
  DateTime? _lastInferenceAt;
  final List<CreationDetection> _recentDetections = <CreationDetection>[];
  CreationDetection? _stableDetection;
  String? _lastLoggedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(creationExplorerActionServiceProvider).markExplorerOpened();
      _initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_disposeCamera());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_startImageStream());
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(_stopImageStream());
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isBootstrappingCamera = true;
      _cameraPermissionDenied = false;
      _isImageLabelingDeviceOnly = false;
    });
    final imageLabelingAvailable = await ref
        .read(creationImageLabelingRuntimeProvider)
        .isImageLabelingAvailable();
    if (!mounted) return;
    if (!imageLabelingAvailable) {
      await _disposeCamera();
      setState(() {
        _isBootstrappingCamera = false;
        _isImageLabelingDeviceOnly = true;
      });
      return;
    }
    final status = await Permission.camera.request();
    if (!mounted) return;
    if (!status.isGranted && !status.isLimited) {
      setState(() {
        _cameraPermissionDenied = true;
        _isBootstrappingCamera = false;
      });
      return;
    }
    final cameras = await ref.read(creationExplorerCameraProvider.future);
    if (!mounted) return;
    final camera = cameras.isNotEmpty ? cameras.first : null;
    if (camera == null) {
      setState(() {
        _cameraPermissionDenied = true;
        _isBootstrappingCamera = false;
      });
      return;
    }
    await _disposeCamera();
    final controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: _preferredImageFormatGroup(),
    );
    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }
    _cameraController = controller;
    setState(() {
      _isBootstrappingCamera = false;
    });
    await _startImageStream();
  }

  ImageFormatGroup _preferredImageFormatGroup() {
    if (Platform.isIOS) {
      return ImageFormatGroup.bgra8888;
    }
    return ImageFormatGroup.nv21;
  }

  Future<void> _disposeCamera() async {
    final controller = _cameraController;
    _cameraController = null;
    _isStreaming = false;
    if (controller == null) return;
    if (controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
    await controller.dispose();
  }

  Future<void> _startImageStream() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized || _isStreaming) {
      return;
    }
    await controller.startImageStream(_handleCameraFrame);
    _isStreaming = true;
  }

  Future<void> _stopImageStream() async {
    final controller = _cameraController;
    if (controller == null ||
        !_isStreaming ||
        !controller.value.isStreamingImages) {
      return;
    }
    await controller.stopImageStream();
    _isStreaming = false;
  }

  Future<void> _handleCameraFrame(CameraImage image) async {
    final controller = _cameraController;
    final now = DateTime.now();
    if (controller == null || _isProcessingFrame) return;
    if (_lastInferenceAt != null &&
        now.difference(_lastInferenceAt!) < _detectionThrottle) {
      return;
    }
    _isProcessingFrame = true;
    _lastInferenceAt = now;
    try {
      final detection = await ref
          .read(creationObjectDetectionServiceProvider)
          .detect(image: image, camera: controller.description);
      if (!mounted) return;
      _applyDetection(detection);
    } catch (_) {
      if (!mounted) return;
      _applyDetection(null);
    } finally {
      _isProcessingFrame = false;
    }
  }

  void _applyDetection(CreationDetection? detection) {
    final now = DateTime.now();
    _recentDetections.removeWhere(
      (item) => now.difference(item.detectedAt) > _staleDetectionWindow,
    );
    if (detection != null) {
      _recentDetections.add(detection);
      if (_recentDetections.length > 5) {
        _recentDetections.removeAt(0);
      }
    }
    if (_recentDetections.isEmpty) {
      setState(() => _stableDetection = null);
      return;
    }

    final counts = <CreationCategoryId, int>{};
    final confidenceTotals = <CreationCategoryId, double>{};
    final latestByCategory = <CreationCategoryId, CreationDetection>{};
    for (final item in _recentDetections) {
      counts[item.categoryId] = (counts[item.categoryId] ?? 0) + 1;
      confidenceTotals[item.categoryId] =
          (confidenceTotals[item.categoryId] ?? 0) + item.confidence;
      latestByCategory[item.categoryId] = item;
    }
    CreationDetection? best;
    var bestCount = 0;
    var bestAverage = 0.0;
    for (final entry in counts.entries) {
      final average = (confidenceTotals[entry.key] ?? 0) / entry.value;
      final candidate = latestByCategory[entry.key];
      if (candidate == null) continue;
      final shouldTake =
          entry.value > bestCount ||
          (entry.value == bestCount && average > bestAverage);
      if (shouldTake) {
        best = candidate;
        bestCount = entry.value;
        bestAverage = average;
      }
    }
    final resolved = best != null && (bestCount >= 2 || bestAverage >= 0.82)
        ? best
        : null;
    setState(() => _stableDetection = resolved);
    if (resolved != null && resolved.categoryId.name != _lastLoggedCategory) {
      _lastLoggedCategory = resolved.categoryId.name;
      ref.read(creationExplorerActionServiceProvider).markDetection(resolved);
    }
  }

  Future<void> _openReflectionCard(CreationDetection detection) async {
    final detectionService = ref.read(creationObjectDetectionServiceProvider);
    final verse = detectionService.verseForCategory(detection.categoryId);
    final category =
        creationCategoryById[detection.categoryId] ??
        creationExplorerCategories.first;
    final reflectionController = TextEditingController();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        var isSaving = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> onSave() async {
              setModalState(() => isSaving = true);
              String? imagePath;
              final controller = _cameraController;
              if (controller != null && controller.value.isInitialized) {
                try {
                  await _stopImageStream();
                  final file = await controller.takePicture();
                  imagePath = file.path;
                } catch (_) {
                  imagePath = null;
                } finally {
                  await _startImageStream();
                }
              }
              final observation = await ref
                  .read(creationExplorerActionServiceProvider)
                  .saveObservation(
                    detection: detection,
                    verse: verse,
                    imagePath: imagePath,
                    reflection: reflectionController.text,
                  );
              await ref
                  .read(creationObservationsProvider.notifier)
                  .add(observation);
              if (!sheetContext.mounted) return;
              Navigator.of(sheetContext).pop(true);
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: PremiumCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.12),
                          child: Icon(
                            category.icon,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_confidenceBandLabel(detection.confidence)} detection · ${_confidenceLabel(detection.confidence)} confidence',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(category.description),
                    const SizedBox(height: 12),
                    QuranVerseContent(
                      source: QuranVerseSource(
                        referenceText: verse.ayahReference,
                        arabicText: verse.arabicText,
                        translation: verse.translation,
                      ),
                      center: false,
                      dense: true,
                      arabicBaseSize: 25,
                    ),
                    const SizedBox(height: 8),
                    Text(verse.reflection),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reflectionController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(
                          context,
                        ).creationExplorerYourReflectionLabel,
                        hintText: AppLocalizations.of(
                          context,
                        ).creationExplorerYourReflectionHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isSaving
                                ? null
                                : () => Navigator.of(context).pop(false),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              ).creationExplorerCloseAction,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: isSaving ? null : onSave,
                            icon: isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.bookmark_add_rounded),
                            label: Text(
                              AppLocalizations.of(
                                context,
                              ).creationExplorerSaveObservationAction,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    reflectionController.dispose();
    if (result == true && mounted) {
      setState(() => _tab = _CreationExplorerTab.journal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final observations = ref.watch(creationObservationsProvider);
    final challengeSummaries = ref.watch(currentCreationChallengesProvider);
    final dailyChallenge = challengeSummaries.firstWhere(
      (item) => item.slot == ChallengeSlot.daily,
    );
    final theme = Theme.of(context);
    return AppPageScaffold(
      headerIcon: AppIcons.explore,
      title: AppLocalizations.of(context).creationExplorerTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.creationExplorer,
        kidsMode: isKidsMode,
      ),
      children: [
        SegmentedPillControl<_CreationExplorerTab>(
          items: _CreationExplorerTab.values,
          selectedItem: _tab,
          labelBuilder: _tabLabel,
          onChanged: (value) => setState(() => _tab = value),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metricPill(
                context,
                AppLocalizations.of(context).creationExplorerMetricObservations,
                '${observations.length}',
              ),
              _metricPill(
                context,
                AppLocalizations.of(context).creationExplorerMetricCategories,
                '${creationExplorerCategories.length}',
              ),
              _metricPill(
                context,
                AppLocalizations.of(context).creationExplorerMetricVerses,
                '${creationExplorerVerses.length}',
              ),
              _metricPill(
                context,
                AppLocalizations.of(context).creationExplorerMetricCamera,
                _isImageLabelingDeviceOnly
                    ? AppLocalizations.of(
                        context,
                      ).creationExplorerMetricCameraDeviceOnly
                    : _cameraPermissionDenied
                    ? AppLocalizations.of(
                        context,
                      ).creationExplorerMetricCameraOff
                    : (_cameraController?.value.isInitialized == true
                          ? AppLocalizations.of(
                              context,
                            ).creationExplorerMetricCameraReady
                          : AppLocalizations.of(
                              context,
                            ).creationExplorerMetricCameraPending),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      ).creationExplorerTodaysChallenge,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(dailyChallenge.challenge.title),
                    const SizedBox(height: 2),
                    Text(dailyChallenge.challenge.subtitle),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => context.pushNamed('creationChallenges'),
                child: Text(
                  dailyChallenge.isCompleted
                      ? AppLocalizations.of(
                          context,
                        ).creationExplorerHistoryAction
                      : AppLocalizations.of(context).creationExplorerOpenAction,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_tab == _CreationExplorerTab.camera) _buildCameraTab(theme),
        if (_tab == _CreationExplorerTab.discover) _buildDiscoverTab(),
        if (_tab == _CreationExplorerTab.journal)
          _buildJournalTab(observations),
      ],
    );
  }

  Widget _buildCameraTab(ThemeData theme) {
    if (_isBootstrappingCamera) {
      return const PremiumCard(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 36),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (_isImageLabelingDeviceOnly) {
      return PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).creationExplorerDeviceOnlyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(creationImageLabelingDeviceOnlyMessage),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).creationExplorerDeviceOnlyBody),
          ],
        ),
      );
    }
    if (_cameraPermissionDenied) {
      return PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).creationExplorerCameraAccessTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).creationExplorerCameraAccessBody),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: _initializeCamera,
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: Text(
                    AppLocalizations.of(
                      context,
                    ).creationExplorerAllowCameraAction,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: openAppSettings,
                  icon: const Icon(Icons.settings_rounded),
                  label: Text(
                    AppLocalizations.of(
                      context,
                    ).creationExplorerOpenSettingsAction,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).creationExplorerCameraUnavailable,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(
                context,
              ).creationExplorerCameraUnavailableBody,
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: _initializeCamera,
              child: Text(
                AppLocalizations.of(context).creationExplorerRetryAction,
              ),
            ),
          ],
        ),
      );
    }
    final detectedCategory = _stableDetection == null
        ? null
        : creationCategoryById[_stableDetection!.categoryId];
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.18),
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.48),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.38),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          ).creationExplorerOnDeviceDetection,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        tooltip: AppLocalizations.of(
                          context,
                        ).accessibilityRefreshCamera,
                        onPressed: _initializeCamera,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: detectedCategory == null ? 0.28 : 0.72,
                      duration: const Duration(milliseconds: 220),
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: detectedCategory == null
                                ? Colors.white24
                                : detectedCategory.colorTheme.withValues(
                                    alpha: 0.92,
                                  ),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: detectedCategory == null
                                  ? Colors.transparent
                                  : detectedCategory.colorTheme.withValues(
                                      alpha: 0.28,
                                    ),
                              blurRadius: 28,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 18,
                  child: AnimatedOpacity(
                    opacity: detectedCategory == null ? 0.85 : 1,
                    duration: const Duration(milliseconds: 220),
                    child: Semantics(
                      button: detectedCategory != null,
                      label: detectedCategory == null
                          ? AppLocalizations.of(
                              context,
                            ).accessibilityCreationCategoryNotDetected
                          : AppLocalizations.of(
                              context,
                            ).accessibilityCreationCategoryDetected(
                              detectedCategory.name,
                            ),
                      child: GestureDetector(
                        onTap: _stableDetection == null
                            ? null
                            : () => _openReflectionCard(_stableDetection!),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.52),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.14),
                            ),
                          ),
                          child: detectedCategory == null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      ).creationExplorerDetectionPromptTitle,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      ).creationExplorerDetectionPromptSubtitle,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: detectedCategory
                                          .colorTheme
                                          .withValues(alpha: 0.24),
                                      child: Icon(
                                        detectedCategory.icon,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            detectedCategory.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            ).creationExplorerTapToReflect,
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.88,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _confidenceLabel(
                                        _stableDetection!.confidence,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).creationExplorerHowItWorksTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context).creationExplorerHowItWorksBody),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoverTab() {
    final detectionService = ref.read(creationObjectDetectionServiceProvider);
    return Column(
      children: [
        if (_stableDetection != null) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  ).creationExplorerCurrentDetectedSign,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                _CategoryVerseTile(
                  category: creationCategoryById[_stableDetection!.categoryId]!,
                  verse: detectionService.verseForCategory(
                    _stableDetection!.categoryId,
                  ),
                  trailing: FilledButton.tonal(
                    onPressed: () => _openReflectionCard(_stableDetection!),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).creationExplorerReflectAction,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      ).creationExplorerAlsoExploreSkyTitle,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 6),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).creationExplorerAlsoExploreSkySubtitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('skyExplorer'),
                icon: const Icon(Icons.nights_stay_rounded),
                label: Text(
                  AppLocalizations.of(
                    context,
                  ).creationExplorerSkyExplorerAction,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...creationExplorerCategories.map((category) {
          final verse = detectionService.verseForCategory(category.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: _CategoryVerseTile(category: category, verse: verse),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildJournalTab(List<CreationObservation> observations) {
    if (observations.isEmpty) {
      return PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).creationExplorerNoObservationsTitle,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).creationExplorerNoObservationsBody,
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () =>
                  setState(() => _tab = _CreationExplorerTab.camera),
              child: Text(
                AppLocalizations.of(
                  context,
                ).creationExplorerOpenCameraExploreAction,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: observations
          .map((observation) {
            final category =
                creationCategoryById[observation.categoryId] ??
                creationExplorerCategories.first;
            final verse =
                creationVerseById[observation.selectedVerseId] ??
                creationExplorerVerses.first;
            final reflection = observation.userReflection;
            final imageFile = observation.imagePath == null
                ? null
                : File(observation.imagePath!);
            final hasImage = imageFile != null && imageFile.existsSync();
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasImage) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          imageFile,
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.12),
                          child: Icon(
                            category.icon,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat.yMMMd().add_jm().format(
                                  observation.timestamp,
                                ),
                              ),
                              if (observation.locationName != null &&
                                  observation.locationName!
                                      .trim()
                                      .isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(observation.locationName!),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: observation.isFavorite
                              ? AppLocalizations.of(
                                  context,
                                ).accessibilityRemoveFavorite
                              : AppLocalizations.of(
                                  context,
                                ).accessibilitySaveFavorite,
                          onPressed: () => ref
                              .read(creationObservationsProvider.notifier)
                              .toggleFavorite(observation.id),
                          icon: Icon(
                            observation.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                        ),
                        IconButton(
                          tooltip: AppLocalizations.of(
                            context,
                          ).accessibilityDeleteObservation,
                          onPressed: () => ref
                              .read(creationObservationsProvider.notifier)
                              .remove(observation.id),
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    QuranVerseContent(
                      source: QuranVerseSource(
                        referenceText: verse.ayahReference,
                        arabicText: verse.arabicText,
                        translation: verse.translation,
                      ),
                      center: false,
                      dense: true,
                      arabicBaseSize: 22,
                    ),
                    const SizedBox(height: 8),
                    Text(verse.reflection),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            ).creationExplorerYourReflectionLabel,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            reflection == null || reflection.trim().isEmpty
                                ? AppLocalizations.of(
                                    context,
                                  ).creationExplorerNoReflectionSaved
                                : reflection,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () => _editReflection(observation),
                        icon: const Icon(Icons.edit_rounded),
                        label: Text(
                          AppLocalizations.of(
                            context,
                          ).creationExplorerEditReflectionAction,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Future<void> _editReflection(CreationObservation observation) async {
    final controller = TextEditingController(
      text: observation.userReflection ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).creationExplorerEditReflectionAction,
        ),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(
              context,
            ).creationExplorerEditReflectionHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).quranCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(AppLocalizations.of(context).quranSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null) return;
    await ref
        .read(creationObservationsProvider.notifier)
        .updateReflection(observation.id, result);
  }

  Widget _metricPill(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text('$label: $value'),
    );
  }

  String _tabLabel(_CreationExplorerTab tab) {
    switch (tab) {
      case _CreationExplorerTab.camera:
        return AppLocalizations.of(context).creationExplorerTabCamera;
      case _CreationExplorerTab.discover:
        return AppLocalizations.of(context).creationExplorerTabDiscover;
      case _CreationExplorerTab.journal:
        return AppLocalizations.of(context).creationExplorerTabJournal;
    }
  }

  String _confidenceLabel(double confidence) {
    return '${(confidence * 100).round()}%';
  }

  String _confidenceBandLabel(double confidence) {
    if (confidence >= 0.9) return 'Strong';
    if (confidence >= 0.7) return 'Probable';
    if (confidence >= 0.5) return 'Possible';
    return 'Low';
  }
}

class _CategoryVerseTile extends StatelessWidget {
  const _CategoryVerseTile({
    required this.category,
    required this.verse,
    this.trailing,
  });

  final CreationCategory category;
  final CreationVerse verse;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: category.colorTheme.withValues(alpha: 0.18),
          child: Icon(category.icon, color: category.colorTheme),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(category.description),
              const SizedBox(height: 10),
              QuranVerseContent(
                source: QuranVerseSource(
                  referenceText: verse.ayahReference,
                  arabicText: verse.arabicText,
                  translation: verse.translation,
                ),
                center: false,
                dense: true,
                arabicBaseSize: 21,
              ),
              const SizedBox(height: 6),
              Text(verse.reflection),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}
