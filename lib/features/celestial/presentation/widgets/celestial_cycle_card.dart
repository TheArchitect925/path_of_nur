import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/prayer/prayer_location_search_service.dart';
import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/profile/application/profile_settings_provider.dart';
import '../../../../shared/state/location_permission_state.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../application/celestial_services.dart';
import '../../domain/celestial_models.dart';

class CelestialCycleCard extends ConsumerStatefulWidget {
  const CelestialCycleCard({super.key});

  @override
  ConsumerState<CelestialCycleCard> createState() => _CelestialCycleCardState();
}

class _CelestialCycleCardState extends ConsumerState<CelestialCycleCard> {
  bool _markedOpen = false;

  Future<void> _showLocationPicker(BuildContext context, String currentLocationLabel) async {
    final service = ref.read(prayerLocationSearchServiceProvider);
    final recentLocations = ref.read(prayerRecentLocationsProvider);
    final selection = await showModalBottomSheet<PrayerLocationPickerSelection>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PrayerLocationPickerSheet(
        currentLocationLabel: currentLocationLabel,
        recentLocations: recentLocations,
        onSearch: service.search,
      ),
    );
    if (selection == null) return;
    final notifier = ref.read(prayerSettingsProvider.notifier);
    if (selection.useDeviceLocation) {
      await ref.read(locationPermissionProvider.notifier).requestWhileUsingApp();
      notifier.useCurrentLocation();
      ref.invalidate(celestialSnapshotProvider);
      return;
    }
    if (selection.latitude == null || selection.longitude == null) return;
    await ref.read(prayerRecentLocationsStoreProvider).save(
      PrayerRecentLocation(
        label: selection.label,
        latitude: selection.latitude!,
        longitude: selection.longitude!,
      ),
    );
    notifier.setManualLocation(
      label: selection.label,
      latitude: selection.latitude!,
      longitude: selection.longitude!,
    );
    ref.invalidate(celestialSnapshotProvider);
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(celestialSnapshotProvider);
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final hintDismissed = ref.watch(celestialHintDismissedProvider);
    final permission = ref.watch(locationPermissionProvider);
    final prefs = ref.watch(prayerSettingsProvider).preferences;
    final displayLocation = ref.watch(prayerLocationDisplayLabelProvider).value ?? prefs.location;

    return PremiumCard(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        onTap: () async {
          await ref.read(celestialActionServiceProvider).markExplorerOpened();
          if (!context.mounted) return;
          context.pushNamed('skyExplorer');
        },
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: snapshotAsync.when(
            data: (snapshot) {
              if (!_markedOpen) {
                _markedOpen = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(celestialActionServiceProvider).markCardOpened();
                });
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Signs in the sky',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${snapshot.locationLabel} • ${DateFormat.yMMMMd().format(snapshot.timestamp)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceSubtle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _SkyStateChip(state: snapshot.solarData.state),
                    ],
                  ),
                  if (!hintDismissed) ...[
                    const SizedBox(height: 12),
                    _HintBanner(
                      onDismiss: () {
                        ref.read(celestialActionServiceProvider).dismissHomeHint();
                        ref.read(celestialHintDismissedProvider.notifier).state = true;
                      },
                    ),
                  ],
                  if (prefs.useDeviceLocation && !permission.isGranted) ...[
                    const SizedBox(height: 12),
                    _PermissionBanner(
                      onUseSavedLocation: () {
                        _showLocationPicker(context, displayLocation);
                      },
                      onEnable: () {
                        if (permission.isPermanentlyDenied) {
                          ref.read(locationPermissionProvider.notifier).openSystemSettings();
                        } else {
                          ref.read(locationPermissionProvider.notifier).requestWhileUsingApp();
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 18),
                  _HorizonProgress(
                    snapshot: snapshot,
                    reduceMotion: reduceMotion,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoPill(
                          label: 'Sunrise',
                          value: DateFormat.jm().format(snapshot.solarData.sunrise),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoPill(
                          label: 'Sunset',
                          value: DateFormat.jm().format(snapshot.solarData.sunset),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoPill(
                          label: 'Moonrise',
                          value: snapshot.lunarData.moonrise == null
                              ? 'Unavailable'
                              : DateFormat.jm().format(snapshot.lunarData.moonrise!),
                          footnote: snapshot.lunarData.riseSetApproximate ? 'Approx.' : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoPill(
                          label: 'Moonset',
                          value: snapshot.lunarData.moonset == null
                              ? 'Unavailable'
                              : DateFormat.jm().format(snapshot.lunarData.moonset!),
                          footnote: snapshot.lunarData.riseSetApproximate ? 'Approx.' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoPill(
                          label: 'Moon phase',
                          value: snapshot.lunarData.phaseName,
                          footnote: '${snapshot.lunarData.illuminationPercent}% illumination',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoPill(
                          label: 'Next event',
                          value: '${snapshot.nextEvent.label} ${DateFormat.jm().format(snapshot.nextEvent.time)}',
                          footnote: snapshot.nextEvent.relativeDescription,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.verseOfMoment.ayahReference,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceSubtle,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          snapshot.verseOfMoment.shortReflection,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const _CardSkeleton(),
            error: (_, _) => _UnavailableState(
              onPickLocation: () {
                _showLocationPicker(context, displayLocation);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SkyStateChip extends StatelessWidget {
  const _SkyStateChip({required this.state});

  final CelestialSkyState state;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (state) {
      CelestialSkyState.dawn => ('Dawn', const Color(0xFFFFC68A)),
      CelestialSkyState.day => ('Day', const Color(0xFFFFE19A)),
      CelestialSkyState.dusk => ('Dusk', const Color(0xFFE6A3AF)),
      CelestialSkyState.night => ('Night', const Color(0xFF9AB7FF)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

class _HintBanner extends StatelessWidget {
  const _HintBanner({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2B48).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_twilight_rounded, size: 18, color: Color(0xFFFFD5A3)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'A gentle sky summary for prayer rhythms, reflection, and moon awareness.',
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded, size: 18),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}

class _PermissionBanner extends StatelessWidget {
  const _PermissionBanner({
    required this.onUseSavedLocation,
    required this.onEnable,
  });

  final VoidCallback onUseSavedLocation;
  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location improves celestial accuracy',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'You can keep using a saved city, or allow location for better rise and set times.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: onUseSavedLocation,
                child: const Text('Choose city'),
              ),
              FilledButton(
                onPressed: onEnable,
                child: const Text('Enable location'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.value,
    this.footnote,
  });

  final String label;
  final String value;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
          if (footnote != null) ...[
            const SizedBox(height: 2),
            Text(
              footnote!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HorizonProgress extends StatelessWidget {
  const _HorizonProgress({
    required this.snapshot,
    required this.reduceMotion,
  });

  final CelestialSnapshot snapshot;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.solarData.progress.clamp(0.0, 1.0);
    final icon = snapshot.solarData.isAboveHorizon ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded;
    final markerColor = snapshot.solarData.isAboveHorizon
        ? const Color(0xFFFFD27A)
        : const Color(0xFFC9D9FF);

    return SizedBox(
      height: 92,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final markerX = (width - 32) * progress;
          final markerY = math.sin(progress * math.pi) * -26 + 42;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _HorizonPainter(
                    color: Colors.white.withValues(alpha: 0.20),
                    accent: markerColor.withValues(alpha: 0.55),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: reduceMotion ? 0 : 900),
                curve: Curves.easeOutCubic,
                left: markerX,
                top: markerY,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: markerColor.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: markerColor.withValues(alpha: 0.25),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: markerColor, size: 18),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Text(
                  'Sunrise ${DateFormat.jm().format(snapshot.solarData.sunrise)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  'Sunset ${DateFormat.jm().format(snapshot.solarData.sunset)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HorizonPainter extends CustomPainter {
  const _HorizonPainter({
    required this.color,
    required this.accent,
  });

  final Color color;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final baseline = size.height * 0.72;
    final path = Path()
      ..moveTo(0, baseline)
      ..quadraticBezierTo(size.width / 2, baseline - 54, size.width, baseline);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = LinearGradient(
        colors: [color, accent, color],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HorizonPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.accent != accent;
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 220,
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _UnavailableState extends StatelessWidget {
  const _UnavailableState({required this.onPickLocation});

  final VoidCallback onPickLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Celestial data is unavailable right now',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Choose a city or refresh location to calculate the sky cycle for your area.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onPickLocation,
          icon: const Icon(Icons.place_rounded),
          label: const Text('Choose location'),
        ),
      ],
    );
  }
}
