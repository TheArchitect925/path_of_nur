import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../core/prayer/prayer_location_search_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import 'widgets/qibla_compass_widget.dart';

class QiblaFinderPage extends StatefulWidget {
  const QiblaFinderPage({super.key});

  @override
  State<QiblaFinderPage> createState() => _QiblaFinderPageState();
}

class _QiblaFinderPageState extends State<QiblaFinderPage> {
  final PrayerLocationSearchService _locationSearchService =
      PrayerLocationSearchService();

  Position? _position;
  String? _locationLabel;
  String? _error;
  bool _loadingLocation = true;
  bool _resolvingLocationLabel = false;
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
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(l10n.worshipQiblaDetectingLocation)),
                  ],
                )
              else if (_error != null)
                Text(_error!, style: Theme.of(context).textTheme.bodyMedium)
              else if (_position != null) ...[
                QiblaCompassWidget(
                  userLatitude: _position!.latitude,
                  userLongitude: _position!.longitude,
                  arMode: _arMode,
                ),
                const SizedBox(height: 18),
                _QiblaLocationSection(
                  label: _resolvedLocationLabel(context),
                  loading: _resolvingLocationLabel,
                  onRefresh: _resolveLocation,
                ),
              ] else
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

  String _resolvedLocationLabel(BuildContext context) {
    if (_locationLabel != null && _locationLabel!.trim().isNotEmpty) {
      return _locationLabel!;
    }
    final position = _position;
    if (position == null) {
      return AppLocalizations.of(context).worshipQiblaLocationUnknown;
    }
    final locale = Localizations.localeOf(context).toLanguageTag();
    final decimal = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: 2,
    );
    return '${decimal.format(position.latitude)}, ${decimal.format(position.longitude)}';
  }

  Future<void> _resolveLocation() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _loadingLocation = true;
      _error = null;
    });
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
        _resolvingLocationLabel = true;
      });
      unawaited(_resolveLocationLabel(position));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingLocation = false;
        _error = l10n.worshipQiblaUnableToReadLocation;
      });
    }
  }

  Future<void> _resolveLocationLabel(Position position) async {
    try {
      final label = await _locationSearchService.reverseLookup(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (!mounted) return;
      setState(() {
        _locationLabel = label;
        _resolvingLocationLabel = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _resolvingLocationLabel = false;
      });
    }
  }
}

class _QiblaLocationSection extends StatelessWidget {
  const _QiblaLocationSection({
    required this.label,
    required this.loading,
    required this.onRefresh,
  });

  final String label;
  final bool loading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC29A63).withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF3E7471).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF3E7471).withValues(alpha: 0.18),
              ),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF3E7471),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worshipQiblaLocationLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF5A4330),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7B6653),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            tooltip: l10n.worshipQiblaRefreshLocation,
            onPressed: loading ? null : () => unawaited(onRefresh()),
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    );
  }
}
