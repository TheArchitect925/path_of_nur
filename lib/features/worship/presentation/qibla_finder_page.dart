import 'dart:async';

import 'package:flutter/foundation.dart';
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
    final position = _position;
    final isIpad = _isIpad(context);
    return AppPageScaffold(
      headerIcon: Icons.explore_rounded,
      title: l10n.worshipQiblaFinderTitle,
      subtitle: l10n.worshipQiblaFinderSubtitle,
      children: [
        if (isIpad) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worshipQiblaUnavailableOnIpadTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.worshipQiblaUnavailableOnIpadBody),
              ],
            ),
          ),
        ] else ...[
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
              else if (position != null) ...[
                QiblaCompassWidget(
                  userLatitude: position.latitude,
                  userLongitude: position.longitude,
                  arMode: _arMode,
                ),
                const SizedBox(height: 18),
                _QiblaLocationSection(
                  label: _resolvedLocationLabel(context),
                  loading: _resolvingLocationLabel,
                  onRefresh: _resolveLocation,
                  siteDistances: _buildSiteDistances(context, position),
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
      ],
    );
  }

  bool _isIpad(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS &&
        MediaQuery.sizeOf(context).shortestSide >= 600;
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

  List<_IslamicSiteDistance> _buildSiteDistances(
    BuildContext context,
    Position position,
  ) {
    final l10n = AppLocalizations.of(context);
    return _majorIslamicSites
        .map(
          (site) => _IslamicSiteDistance(
            title: site.localizedTitle(l10n),
            location: site.localizedLocation(l10n),
            distanceKm:
                Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  site.latitude,
                  site.longitude,
                ) /
                1000,
          ),
        )
        .toList(growable: false);
  }
}

class _QiblaLocationSection extends StatelessWidget {
  const _QiblaLocationSection({
    required this.label,
    required this.loading,
    required this.onRefresh,
    required this.siteDistances,
  });

  final String label;
  final bool loading;
  final Future<void> Function() onRefresh;
  final List<_IslamicSiteDistance> siteDistances;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          if (siteDistances.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              l10n.worshipQiblaMajorSitesTitle,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5A4330),
              ),
            ),
            const SizedBox(height: 10),
            for (final site in siteDistances) ...[
              _QiblaSiteDistanceRow(site: site),
              if (site != siteDistances.last) const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    );
  }
}

class _QiblaSiteDistanceRow extends StatelessWidget {
  const _QiblaSiteDistanceRow({required this.site});

  final _IslamicSiteDistance site;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: site.distanceKm >= 100 ? 0 : 1,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC29A63).withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  site.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF5A4330),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  site.location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7B6653),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.worshipQiblaDistanceKmValue(
              numberFormat.format(site.distanceKm),
            ),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3E7471),
            ),
          ),
        ],
      ),
    );
  }
}

class _IslamicSiteDistance {
  const _IslamicSiteDistance({
    required this.title,
    required this.location,
    required this.distanceKm,
  });

  final String title;
  final String location;
  final double distanceKm;
}

class _MajorIslamicSite {
  const _MajorIslamicSite({
    required this.latitude,
    required this.longitude,
    required this.localizedTitle,
    required this.localizedLocation,
  });

  final double latitude;
  final double longitude;
  final String Function(AppLocalizations l10n) localizedTitle;
  final String Function(AppLocalizations l10n) localizedLocation;
}

const List<_MajorIslamicSite> _majorIslamicSites = <_MajorIslamicSite>[
  _MajorIslamicSite(
    latitude: 21.4225,
    longitude: 39.8262,
    localizedTitle: _siteMasjidAlHaramTitle,
    localizedLocation: _siteMakkahLocation,
  ),
  _MajorIslamicSite(
    latitude: 24.4672,
    longitude: 39.6111,
    localizedTitle: _siteProphetsMosqueTitle,
    localizedLocation: _siteMadinahLocation,
  ),
  _MajorIslamicSite(
    latitude: 31.7767,
    longitude: 35.2354,
    localizedTitle: _siteAlAqsaTitle,
    localizedLocation: _siteJerusalemLocation,
  ),
  _MajorIslamicSite(
    latitude: 24.4575,
    longitude: 39.6212,
    localizedTitle: _siteQubaMosqueTitle,
    localizedLocation: _siteMadinahLocation,
  ),
];

String _siteMasjidAlHaramTitle(AppLocalizations l10n) =>
    l10n.worshipQiblaSiteMasjidAlHaram;
String _siteProphetsMosqueTitle(AppLocalizations l10n) =>
    l10n.worshipQiblaSiteProphetsMosque;
String _siteAlAqsaTitle(AppLocalizations l10n) => l10n.worshipQiblaSiteAlAqsa;
String _siteQubaMosqueTitle(AppLocalizations l10n) =>
    l10n.worshipQiblaSiteQubaMosque;
String _siteMakkahLocation(AppLocalizations l10n) =>
    l10n.worshipQiblaLocationMakkah;
String _siteMadinahLocation(AppLocalizations l10n) =>
    l10n.worshipQiblaLocationMadinah;
String _siteJerusalemLocation(AppLocalizations l10n) =>
    l10n.worshipQiblaLocationJerusalem;
