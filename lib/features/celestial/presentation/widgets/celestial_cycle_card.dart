import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/prayer/prayer_location_search_service.dart';
import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../features/profile/application/profile_settings_provider.dart';
import '../../../../shared/state/location_permission_state.dart';
import '../../../../shared/widgets/moon_phase_visual.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../../shared/widgets/quran_verse_content.dart';
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
    final prefs = ref.watch(prayerSettingsProvider).preferences;
    final displayLocation = ref.watch(prayerLocationDisplayLabelProvider).value ?? prefs.location;
    final l10n = AppLocalizations.of(context);

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
              final moonVisual = moonPhaseVisualForDate(snapshot.timestamp, l10n);
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
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _showLocationPicker(context, displayLocation),
                        tooltip: l10n.worshipPrayerChooseLocationTitle,
                        splashRadius: 20,
                        icon: const Icon(Icons.location_on_outlined),
                      ),
                      _SkyStateChip(state: snapshot.solarData.state),
                    ],
                  ),
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
                          tint: _resolveSolarTint(
                            kind: _SolarPillKind.sunrise,
                            now: snapshot.timestamp,
                            eventTime: snapshot.solarData.sunrise,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoPill(
                          label: 'Sunset',
                          value: DateFormat.jm().format(snapshot.solarData.sunset),
                          tint: _resolveSolarTint(
                            kind: _SolarPillKind.sunset,
                            now: snapshot.timestamp,
                            eventTime: snapshot.solarData.sunset,
                          ),
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
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.025),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: MoonPhaseVisual(
                        moon: moonVisual,
                        size: 68,
                      ),
                    ),
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
                        QuranVerseContent(
                          source: QuranVerseSource(
                            referenceText: snapshot.verseOfMoment.ayahReference,
                            arabicText: snapshot.verseOfMoment.arabicText,
                            translation: snapshot.verseOfMoment.translation,
                          ),
                          center: false,
                          dense: true,
                          arabicBaseSize: 24,
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

enum _SolarPillKind { sunrise, sunset }

class _SolarPillTint {
  const _SolarPillTint({
    required this.surfaceTint,
    required this.gradientColors,
  });

  final Color surfaceTint;
  final List<Color> gradientColors;
}

_SolarPillTint _resolveSolarTint({
  required _SolarPillKind kind,
  required DateTime now,
  required DateTime eventTime,
}) {
  final minutesFromEvent = now.difference(eventTime).inMinutes;

  return switch (kind) {
    _SolarPillKind.sunrise => _resolveSunriseTint(minutesFromEvent),
    _SolarPillKind.sunset => _resolveSunsetTint(minutesFromEvent),
  };
}

_SolarPillTint _resolveSunriseTint(int minutesFromEvent) {
  if (minutesFromEvent < -70) {
    return const _SolarPillTint(
      surfaceTint: Color(0xFFC7D7F3),
      gradientColors: <Color>[
        Color(0x26AFC4EE),
        Color(0x18E7C4A1),
      ],
    );
  }
  if (minutesFromEvent <= 45) {
    return const _SolarPillTint(
      surfaceTint: Color(0xFFF0C987),
      gradientColors: <Color>[
        Color(0x30F8D4A2),
        Color(0x1EF4B78A),
      ],
    );
  }
  return const _SolarPillTint(
    surfaceTint: Color(0xFFE6C37D),
    gradientColors: <Color>[
      Color(0x24F5D89C),
      Color(0x18FFE9BE),
    ],
  );
}

_SolarPillTint _resolveSunsetTint(int minutesFromEvent) {
  if (minutesFromEvent < -90) {
    return const _SolarPillTint(
      surfaceTint: Color(0xFFE0AE70),
      gradientColors: <Color>[
        Color(0x22F0C07D),
        Color(0x12F4D4A0),
      ],
    );
  }
  if (minutesFromEvent <= 50) {
    return const _SolarPillTint(
      surfaceTint: Color(0xFFD89563),
      gradientColors: <Color>[
        Color(0x30EAA17B),
        Color(0x1ECA7C78),
      ],
    );
  }
  return const _SolarPillTint(
    surfaceTint: Color(0xFFB87F6A),
    gradientColors: <Color>[
      Color(0x248C667D),
      Color(0x186D5E88),
    ],
  );
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.value,
    this.footnote,
    this.tint,
  });

  final String label;
  final String value;
  final String? footnote;
  final _SolarPillTint? tint;

  @override
  Widget build(BuildContext context) {
    final overlayGradient = tint == null
        ? null
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: tint!.gradientColors,
          );
    return PremiumCard(
      padding: const EdgeInsets.all(12),
      surfaceVariant: AppSurfaceVariant.pill,
      surfaceTintColor: tint?.surfaceTint,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: overlayGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
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
        ),
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
