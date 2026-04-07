import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import 'qibla_compass_painter.dart';
import 'qibla_direction_math.dart';

class QiblaCompassWidget extends StatefulWidget {
  const QiblaCompassWidget({
    super.key,
    required this.userLatitude,
    required this.userLongitude,
    required this.arMode,
  });

  final double userLatitude;
  final double userLongitude;
  final bool arMode;

  @override
  State<QiblaCompassWidget> createState() => _QiblaCompassWidgetState();
}

class _QiblaCompassWidgetState extends State<QiblaCompassWidget> {
  StreamSubscription<CompassEvent>? _headingSubscription;
  double? _smoothedHeading;
  double? _rawHeading;
  CameraController? _cameraController;
  bool _cameraPermissionDenied = false;
  bool _isInitializingCamera = false;
  bool _cameraUnavailable = false;

  @override
  void initState() {
    super.initState();
    _headingSubscription = FlutterCompass.events?.listen(_handleCompassEvent);
    if (widget.arMode) {
      unawaited(_initializeCamera());
    }
  }

  @override
  void dispose() {
    _headingSubscription?.cancel();
    unawaited(_disposeCamera());
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QiblaCompassWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.arMode == widget.arMode) return;
    if (widget.arMode) {
      unawaited(_initializeCamera());
    } else {
      unawaited(_disposeCamera());
      if (mounted) {
        setState(() {
          _cameraPermissionDenied = false;
          _cameraUnavailable = false;
          _isInitializingCamera = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final decimal = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: 0,
    );
    final qiblaBearing = bearingToKaaba(
      latitude: widget.userLatitude,
      longitude: widget.userLongitude,
    );

    final heading = _smoothedHeading;
    if (heading == null) {
      return _QiblaCompassUnavailable(
        message: l10n.worshipQiblaCompassUnavailable,
        hint: l10n.worshipQiblaCalibrationHint,
      );
    }

    final headingDegrees = normalizeDegrees(heading);
    final relativeQiblaAngle = normalizeDegrees(qiblaBearing - headingDegrees);
    final signedTurnDelta = shortestSignedAngleDelta(
      fromDegrees: headingDegrees,
      toDegrees: qiblaBearing,
    );
    final aligned = signedTurnDelta.abs() <= qiblaAlignedToleranceDegrees;
    if (widget.arMode) {
      return _buildArMode(
        context,
        decimal: decimal,
        headingDegrees: headingDegrees,
        qiblaBearing: qiblaBearing,
        signedTurnDelta: signedTurnDelta,
        aligned: aligned,
      );
    }
    final dialSize = widget.arMode ? 324.0 : 286.0;
    final theme = Theme.of(context);
    final foreground = const Color(0xFF5A4330);
    final subtle = const Color(0xFF8A725A);
    final accent = const Color(0xFF8E6933);
    final tealAccent = const Color(0xFF2A7A78);
    final alignmentGlow = const Color(0xFFB38B46);

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              width: dialSize,
              height: dialSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Transform.rotate(
                      angle: -(headingDegrees * math.pi / 180),
                      child: CustomPaint(
                        painter: QiblaCompassPainter(
                          ringColor: accent.withValues(alpha: 0.42),
                          tickColor: foreground.withValues(alpha: 0.72),
                          labelColor: foreground,
                          accentColor: tealAccent,
                          alignmentGlowColor: alignmentGlow,
                          cardinalNorth: l10n.worshipQiblaCardinalNorth,
                          cardinalEast: l10n.worshipQiblaCardinalEast,
                          cardinalSouth: l10n.worshipQiblaCardinalSouth,
                          cardinalWest: l10n.worshipQiblaCardinalWest,
                          qiblaBearing: qiblaBearing,
                          aligned: aligned,
                        ),
                      ),
                    ),
                  ),
                  _QiblaTargetMarker(
                    size: dialSize,
                    relativeAngleDegrees: relativeQiblaAngle,
                    aligned: aligned,
                  ),
                  Positioned(
                    top: 14,
                    child: _FacingIndicator(aligned: aligned),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.94),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.36),
                        width: 1.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.18),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: foreground,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '${decimal.format(headingDegrees)}°',
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.worshipQiblaCurrentHeadingLabel,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: subtle,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.worshipQiblaDirectionValue(decimal.format(qiblaBearing)),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _guidanceText(
              l10n,
              decimal: decimal,
              signedTurnDelta: signedTurnDelta,
              aligned: aligned,
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: aligned ? tealAccent : subtle,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (aligned ? tealAccent : accent).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: (aligned ? tealAccent : accent).withValues(
                    alpha: 0.24,
                  ),
                ),
              ),
              child: Text(
                l10n.worshipQiblaAlignmentOffsetValue(
                  decimal.format(signedTurnDelta.abs()),
                ),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (_rawHeading != null &&
              shortestSignedAngleDelta(
                    fromDegrees: _rawHeading!,
                    toDegrees: headingDegrees,
                  ).abs() >
                  18) ...[
            const SizedBox(height: 10),
            Text(
              l10n.worshipQiblaCalibrationHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: subtle),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArMode(
    BuildContext context, {
    required NumberFormat decimal,
    required double headingDegrees,
    required double qiblaBearing,
    required double signedTurnDelta,
    required bool aligned,
  }) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = _cameraController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.worshipQiblaArLiveTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF5A4330),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.worshipQiblaArLiveSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF7B6653),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: AspectRatio(
            aspectRatio: controller?.value.isInitialized == true
                ? controller!.value.aspectRatio
                : 3 / 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (controller?.value.isInitialized == true)
                  CameraPreview(controller!)
                else
                  _QiblaArUnavailablePanel(
                    isLoading: _isInitializingCamera,
                    permissionDenied: _cameraPermissionDenied,
                    unavailable: _cameraUnavailable,
                    onRetry: _initializeCamera,
                  ),
                if (controller?.value.isInitialized == true)
                  _QiblaArOverlay(
                    signedTurnDelta: signedTurnDelta,
                    aligned: aligned,
                    onRefreshCamera: _initializeCamera,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.worshipQiblaDirectionValue(decimal.format(qiblaBearing)),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF5A4330),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _guidanceText(
            l10n,
            decimal: decimal,
            signedTurnDelta: signedTurnDelta,
            aligned: aligned,
          ),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: aligned ? const Color(0xFF2A7A78) : const Color(0xFF7B6653),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.worshipQiblaArPrayerMatHint,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF8A725A),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  (aligned ? const Color(0xFF2A7A78) : const Color(0xFF8E6933))
                      .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color:
                    (aligned
                            ? const Color(0xFF2A7A78)
                            : const Color(0xFF8E6933))
                        .withValues(alpha: 0.24),
              ),
            ),
            child: Text(
              l10n.worshipQiblaAlignmentOffsetValue(
                decimal.format(signedTurnDelta.abs()),
              ),
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFF5A4330),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.worshipQiblaDeviceHeadingValue(decimal.format(headingDegrees)),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF8A725A),
          ),
        ),
      ],
    );
  }

  String _guidanceText(
    AppLocalizations l10n, {
    required NumberFormat decimal,
    required double signedTurnDelta,
    required bool aligned,
  }) {
    if (aligned) {
      return l10n.worshipQiblaFacingQibla;
    }
    final amount = decimal.format(signedTurnDelta.abs());
    return signedTurnDelta >= 0
        ? l10n.worshipQiblaTurnRightValue(amount)
        : l10n.worshipQiblaTurnLeftValue(amount);
  }

  void _handleCompassEvent(CompassEvent event) {
    final rawHeading = event.heading;
    if (rawHeading == null || !mounted) return;
    final normalized = normalizeDegrees(rawHeading);
    final current = _smoothedHeading;
    final next = current == null
        ? normalized
        : lerpAngleDegrees(
            current,
            normalized,
            _smoothingFactor(current, normalized),
          );
    setState(() {
      _rawHeading = normalized;
      _smoothedHeading = next;
    });
  }

  double _smoothingFactor(double current, double target) {
    final delta = shortestSignedAngleDelta(
      fromDegrees: current,
      toDegrees: target,
    ).abs();
    if (delta > 30) return 0.34;
    if (delta > 12) return 0.24;
    return 0.18;
  }

  Future<void> _initializeCamera() async {
    if (_isInitializingCamera) return;
    setState(() {
      _isInitializingCamera = true;
      _cameraPermissionDenied = false;
      _cameraUnavailable = false;
    });
    try {
      if (kIsWeb) {
        setState(() {
          _cameraUnavailable = true;
          _isInitializingCamera = false;
        });
        return;
      }
      final status = await Permission.camera.request();
      if (!mounted) return;
      if (!status.isGranted && !status.isLimited) {
        setState(() {
          _cameraPermissionDenied = true;
          _isInitializingCamera = false;
        });
        return;
      }
      final cameras = await availableCameras();
      final backCamera = cameras.cast<CameraDescription?>().firstWhere(
        (camera) => camera?.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.isNotEmpty ? cameras.first : null,
      );
      if (!mounted) return;
      if (backCamera == null) {
        setState(() {
          _cameraUnavailable = true;
          _isInitializingCamera = false;
        });
        return;
      }
      await _disposeCamera();
      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      _cameraController = controller;
      setState(() {
        _isInitializingCamera = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cameraUnavailable = true;
        _isInitializingCamera = false;
      });
    }
  }

  Future<void> _disposeCamera() async {
    final controller = _cameraController;
    _cameraController = null;
    if (controller == null) return;
    await controller.dispose();
  }
}

class _QiblaArOverlay extends StatelessWidget {
  const _QiblaArOverlay({
    required this.signedTurnDelta,
    required this.aligned,
    required this.onRefreshCamera,
  });

  final double signedTurnDelta;
  final bool aligned;
  final Future<void> Function() onRefreshCamera;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final horizonY = height * 0.34;
        final centerX = width / 2;
        final normalizedOffset = (signedTurnDelta / 60).clamp(-1.0, 1.0);
        final markerX = centerX + (normalizedOffset * width * 0.34);
        final markerLeft = (markerX - 30).clamp(16.0, width - 76.0);
        final matAngle = (signedTurnDelta / 180) * math.pi;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.12),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.22),
              ],
            ),
          ),
          child: Stack(
            children: [
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
                        color: Colors.black.withValues(alpha: 0.34),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        aligned
                            ? l10n.worshipQiblaFacingQibla
                            : l10n.worshipQiblaArOverlayTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton.filledTonal(
                      tooltip: l10n.accessibilityRefreshCamera,
                      onPressed: () => unawaited(onRefreshCamera()),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: horizonY,
                child: Column(
                  children: [
                    Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.worshipQiblaArHorizonLineLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: markerLeft,
                top: horizonY - 88,
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.94),
                        border: Border.all(
                          color:
                              (aligned
                                      ? const Color(0xFF2A7A78)
                                      : const Color(0xFF8E6933))
                                  .withValues(alpha: 0.48),
                          width: aligned ? 2.6 : 1.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (aligned
                                        ? const Color(0xFF2A7A78)
                                        : const Color(0xFF8E6933))
                                    .withValues(alpha: 0.28),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        IslamicIcons.kaaba,
                        size: 26,
                        color: Color(0xFF5A4330),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.worshipQiblaArKaabaLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: centerX - 72,
                bottom: 26,
                child: Transform.rotate(
                  angle: matAngle.clamp(-0.6, 0.6),
                  child: _PrayerMatOverlay(aligned: aligned),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PrayerMatOverlay extends StatelessWidget {
  const _PrayerMatOverlay({required this.aligned});

  final bool aligned;

  @override
  Widget build(BuildContext context) {
    final accent = aligned ? const Color(0xFF2A7A78) : const Color(0xFF8E6933);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 16,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
        ),
        Container(
          width: 144,
          height: 188,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE9D8BB).withValues(alpha: 0.96),
                const Color(0xFFD0B28A).withValues(alpha: 0.98),
              ],
            ),
            border: Border.all(color: accent.withValues(alpha: 0.55), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.46)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Icon(IslamicIcons.mosque, color: accent, size: 28),
                  const Spacer(),
                  Container(
                    height: 34,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: accent.withValues(alpha: 0.18),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QiblaArUnavailablePanel extends StatelessWidget {
  const _QiblaArUnavailablePanel({
    required this.isLoading,
    required this.permissionDenied,
    required this.unavailable,
    required this.onRetry,
  });

  final bool isLoading;
  final bool permissionDenied;
  final bool unavailable;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = permissionDenied
        ? l10n.worshipQiblaArCameraPermissionBody
        : unavailable
        ? l10n.worshipQiblaArCameraUnavailableBody
        : l10n.worshipQiblaArCameraLoadingBody;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF37474F), const Color(0xFF1F252B)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                )
              else
                const Icon(
                  Icons.view_in_ar_outlined,
                  color: Colors.white,
                  size: 42,
                ),
              const SizedBox(height: 14),
              Text(
                l10n.worshipQiblaArCameraUnavailableTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.86),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.tonalIcon(
                onPressed: isLoading ? null : () => unawaited(onRetry()),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.worshipQiblaArRetryCameraAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QiblaCompassUnavailable extends StatelessWidget {
  const _QiblaCompassUnavailable({required this.message, required this.hint});

  final String message;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          Icons.explore_off_rounded,
          size: 44,
          color: const Color(0xFF7B6653),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF5A4330),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hint,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF8A725A),
          ),
        ),
      ],
    );
  }
}

class _FacingIndicator extends StatelessWidget {
  const _FacingIndicator({required this.aligned});

  final bool aligned;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = aligned
        ? const Color(0xFF2A7A78)
        : const Color(0xFF7B5B2C);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: indicatorColor,
            shape: BoxShape.circle,
            boxShadow: aligned
                ? [
                    BoxShadow(
                      color: indicatorColor.withValues(alpha: 0.26),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
        ClipPath(
          clipper: _TriangleClipper(),
          child: Container(width: 18, height: 18, color: indicatorColor),
        ),
      ],
    );
  }
}

class _QiblaTargetMarker extends StatelessWidget {
  const _QiblaTargetMarker({
    required this.size,
    required this.relativeAngleDegrees,
    required this.aligned,
  });

  final double size;
  final double relativeAngleDegrees;
  final bool aligned;

  @override
  Widget build(BuildContext context) {
    const markerSize = 46.0;
    final radius = (size / 2) - 38;
    final radians = relativeAngleDegrees * math.pi / 180;
    final center = size / 2;
    final x = center + (math.sin(radians) * radius) - (markerSize / 2);
    final y = center - (math.cos(radians) * radius) - (markerSize / 2);

    return Positioned(
      left: x,
      top: y,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: markerSize,
        height: markerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: aligned ? 0.98 : 0.94),
          border: Border.all(
            color: (aligned ? const Color(0xFF2A7A78) : const Color(0xFF8E6933))
                .withValues(alpha: 0.42),
            width: aligned ? 2.2 : 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (aligned ? const Color(0xFF2A7A78) : const Color(0xFF8E6933))
                      .withValues(alpha: aligned ? 0.22 : 0.12),
              blurRadius: aligned ? 18 : 10,
              spreadRadius: aligned ? 2 : 0,
            ),
          ],
        ),
        child: const Center(
          child: Icon(IslamicIcons.kaaba, size: 20, color: Color(0xFF5A4330)),
        ),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
