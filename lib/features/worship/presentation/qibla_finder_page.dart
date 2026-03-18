import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';

class QiblaFinderPage extends StatefulWidget {
  const QiblaFinderPage({super.key});

  @override
  State<QiblaFinderPage> createState() => _QiblaFinderPageState();
}

class _QiblaFinderPageState extends State<QiblaFinderPage> {
  Position? _position;
  String? _error;
  bool _loadingLocation = true;
  bool _arMode = false;

  @override
  void initState() {
    super.initState();
    unawaited(_resolveLocation());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      headerIcon: Icons.explore_rounded,
      title: l10n.worshipQiblaFinderTitle,
      subtitle: l10n.worshipQiblaFinderSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.worshipQiblaCompassDirectionTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              if (_loadingLocation)
                Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: Text(l10n.worshipQiblaDetectingLocation)),
                  ],
                )
              else if (_error != null)
                Text(_error!, style: Theme.of(context).textTheme.bodyMedium)
              else if (_position != null)
                _QiblaCompass(
                  userLat: _position!.latitude,
                  userLng: _position!.longitude,
                  arMode: _arMode,
                )
              else
                Text(l10n.worshipQiblaUnableToDetermineLocation),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.worshipQiblaArOptionTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(l10n.worshipQiblaArOptionSubtitle),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => setState(() => _arMode = !_arMode),
                icon: Icon(
                  _arMode
                      ? Icons.view_in_ar_rounded
                      : Icons.view_in_ar_outlined,
                ),
                label: Text(
                  _arMode
                      ? l10n.worshipQiblaDisableArMode
                      : l10n.worshipQiblaEnableArMode,
                ),
              ),
              if (_arMode) ...[
                const SizedBox(height: 8),
                Text(l10n.worshipQiblaArModeBetaHint),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _resolveLocation() async {
    final l10n = AppLocalizations.of(context);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _loadingLocation = false;
          _error = l10n.worshipQiblaLocationServicesDisabled;
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _loadingLocation = false;
          _error = l10n.worshipQiblaLocationPermissionRequired;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;
      setState(() {
        _position = position;
        _loadingLocation = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingLocation = false;
        _error = l10n.worshipQiblaUnableToReadLocation;
      });
    }
  }
}

class _QiblaCompass extends StatelessWidget {
  const _QiblaCompass({
    required this.userLat,
    required this.userLng,
    required this.arMode,
  });

  final double userLat;
  final double userLng;
  final bool arMode;

  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final decimal = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: 1,
    );
    final qiblaBearing = _bearingToKaaba(
      lat: userLat,
      lng: userLng,
      kaabaLat: _kaabaLat,
      kaabaLng: _kaabaLng,
    );

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final heading = snapshot.data?.heading;
        if (heading == null) {
          return Text(l10n.worshipQiblaCompassUnavailable);
        }

        final normalizedHeading = (heading + 360) % 360;
        final qiblaOffset = (qiblaBearing - normalizedHeading + 360) % 360;
        final diff = qiblaOffset > 180 ? 360 - qiblaOffset : qiblaOffset;

        final arrowSize = arMode ? 120.0 : 92.0;
        final dialSize = arMode ? 290.0 : 240.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: dialSize,
                height: dialSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: dialSize,
                      height: dialSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFB89A6A).withValues(alpha: 0.4),
                          width: 1.4,
                        ),
                        color: const Color(0xFFF2EBE1).withValues(alpha: 0.24),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: _CardinalLabel(l10n.worshipQiblaCardinalNorth),
                    ),
                    Positioned(
                      bottom: 10,
                      child: _CardinalLabel(l10n.worshipQiblaCardinalSouth),
                    ),
                    Positioned(
                      left: 12,
                      child: _CardinalLabel(l10n.worshipQiblaCardinalWest),
                    ),
                    Positioned(
                      right: 12,
                      child: _CardinalLabel(l10n.worshipQiblaCardinalEast),
                    ),
                    Transform.rotate(
                      angle: qiblaOffset * math.pi / 180,
                      child: Icon(
                        Icons.navigation_rounded,
                        size: arrowSize,
                        color: const Color(0xFF6A4E2D),
                      ),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6A4E2D),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.worshipQiblaBearingValue(decimal.format(qiblaBearing))),
            Text(
              l10n.worshipQiblaDeviceHeadingValue(
                decimal.format(normalizedHeading),
              ),
            ),
            Text(
              l10n.worshipQiblaAlignmentOffsetValue(decimal.format(diff)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              diff <= 10
                  ? l10n.worshipQiblaAlignedMessage
                  : l10n.worshipQiblaRotateMessage,
            ),
          ],
        );
      },
    );
  }

  double _bearingToKaaba({
    required double lat,
    required double lng,
    required double kaabaLat,
    required double kaabaLng,
  }) {
    final lat1 = _degToRad(lat);
    final lat2 = _degToRad(kaabaLat);
    final dLng = _degToRad(kaabaLng - lng);

    final y = math.sin(dLng) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    final brng = math.atan2(y, x);
    return (_radToDeg(brng) + 360) % 360;
  }

  double _degToRad(double deg) => deg * math.pi / 180;
  double _radToDeg(double rad) => rad * 180 / math.pi;
}

class _CardinalLabel extends StatelessWidget {
  const _CardinalLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
