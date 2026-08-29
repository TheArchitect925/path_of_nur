import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/prayer/prayer_location_search_service.dart';
import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../features/profile/application/profile_settings_provider.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/state/location_permission_state.dart';
import '../../../../shared/widgets/home_feature_card_header.dart';
import '../../../../shared/widgets/moon_phase_visual.dart';
import '../../../../shared/widgets/noor_glass_card.dart';
import '../../../../shared/widgets/noor_liquid_glass.dart';
import '../../../../shared/widgets/prayer_location_picker_sheet.dart';
import '../../../../shared/widgets/quran_verse_content.dart';
import '../../application/celestial_services.dart';
import '../../domain/celestial_models.dart';

Color _celestialInk(BuildContext context) =>
    Theme.of(context).extension<AppAppearanceTheme>()?.onSurface ??
    context.palette.onSurface;

Color _celestialSubtleInk(BuildContext context) =>
    Theme.of(context).extension<AppAppearanceTheme>()?.onSurfaceSubtle ??
    context.palette.onSurfaceSubtle;

Color _celestialAccent(BuildContext context) {
  final appearance = Theme.of(context).extension<AppAppearanceTheme>();
  if (appearance?.isNightFamily == true) return appearance!.accentSoft;
  return const Color(0xFF7A5A33);
}

class CelestialCycleCard extends ConsumerStatefulWidget {
  const CelestialCycleCard({
    super.key,
    this.collapsible = false,
    this.initiallyExpanded = true,
  });

  final bool collapsible;
  final bool initiallyExpanded;

  @override
  ConsumerState<CelestialCycleCard> createState() => _CelestialCycleCardState();
}

class _CelestialCycleCardState extends ConsumerState<CelestialCycleCard> {
  bool _markedOpen = false;
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _markedOpen) return;
      _markedOpen = true;
      await ref.read(celestialActionServiceProvider).markCardOpened();
    });
  }

  Future<void> _showLocationPicker(
    BuildContext context,
    String currentLocationLabel,
  ) async {
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
      await ref
          .read(locationPermissionProvider.notifier)
          .requestWhileUsingApp();
      notifier.useCurrentLocation();
      ref.invalidate(celestialSnapshotProvider);
      return;
    }
    if (selection.latitude == null || selection.longitude == null) return;
    await ref
        .read(prayerRecentLocationsStoreProvider)
        .save(
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
    final selectedDate = ref.watch(homeCelestialSelectedDateProvider);
    final snapshotAsync = ref.watch(
      celestialSnapshotForDateProvider(selectedDate),
    );
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final prefs = ref.watch(prayerSettingsProvider).preferences;
    final displayLocation =
        ref.watch(prayerLocationDisplayLabelProvider).value ?? prefs.location;
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateLabel = _formatCardDateLabel(
      l10n: l10n,
      selectedDate: selectedDate,
      today: today,
    );
    final collapsedHeader = widget.collapsible
        ? _CollapsibleHeader(
            title: l10n.celestialHomeCardTitle,
            subtitle: dateLabel,
            expanded: _expanded,
            onOpenExplorer: () async {
              await ref
                  .read(celestialActionServiceProvider)
                  .markExplorerOpened();
              if (!context.mounted) return;
              context.pushNamed('skyExplorer');
            },
            onToggleExpanded: () => setState(() => _expanded = !_expanded),
          )
        : null;
    final shellState = snapshotAsync.asData?.value.solarData.state;

    return _CelestialGlassShell(
      state: shellState,
      onTap: widget.collapsible
          ? null
          : () async {
              await ref
                  .read(celestialActionServiceProvider)
                  .markExplorerOpened();
              if (!context.mounted) return;
              context.pushNamed('skyExplorer');
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (collapsedHeader != null) ...[collapsedHeader],
          if (widget.collapsible && _expanded) const SizedBox(height: 12),
          if (!widget.collapsible || _expanded)
            snapshotAsync.when(
              data: (snapshot) => _CelestialCardBody(
                snapshot: snapshot,
                reduceMotion: reduceMotion,
                displayLocation: displayLocation,
                dateLabel: dateLabel,
                onPickLocation: () =>
                    _showLocationPicker(context, displayLocation),
                onPreviousDay: () {
                  ref.read(homeCelestialSelectedDateProvider.notifier).state =
                      selectedDate.subtract(const Duration(days: 1));
                },
                onNextDay: () {
                  ref.read(homeCelestialSelectedDateProvider.notifier).state =
                      selectedDate.add(const Duration(days: 1));
                },
                showOverviewHeader: !widget.collapsible,
              ),
              loading: () => const _CardSkeleton(),
              error: (_, _) => _UnavailableState(
                onPickLocation: () {
                  _showLocationPicker(context, displayLocation);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _CollapsibleHeader extends StatelessWidget {
  const _CollapsibleHeader({
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.onOpenExplorer,
    required this.onToggleExpanded,
  });

  final String title;
  final String subtitle;
  final bool expanded;
  final VoidCallback onOpenExplorer;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _celestialInk(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _celestialSubtleInk(context),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onOpenExplorer,
          tooltip: title,
          icon: Icon(
            Icons.open_in_new_rounded,
            color: _celestialSubtleInk(context),
          ),
        ),
        IconButton(
          onPressed: onToggleExpanded,
          tooltip: title,
          icon: Icon(
            expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            color: _celestialSubtleInk(context),
          ),
        ),
      ],
    );
  }
}

class _CelestialCardBody extends StatelessWidget {
  const _CelestialCardBody({
    required this.snapshot,
    required this.reduceMotion,
    required this.displayLocation,
    required this.dateLabel,
    required this.onPickLocation,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.showOverviewHeader,
  });

  final CelestialSnapshot snapshot;
  final bool reduceMotion;
  final String displayLocation;
  final String dateLabel;
  final VoidCallback onPickLocation;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final bool showOverviewHeader;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final moonVisual = moonPhaseVisualForDate(snapshot.timestamp, l10n);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showOverviewHeader) ...[
            HomeFeatureCardHeader(
              icon: Icons.wb_twilight_rounded,
              iconTint: const Color(0xFF9AB7FF),
              title: l10n.celestialHomeCardTitle,
              subtitle: snapshot.locationLabel,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onPickLocation,
                    tooltip: l10n.worshipPrayerChooseLocationTitle,
                    splashRadius: 20,
                    icon: const Icon(Icons.location_on_outlined),
                  ),
                  _SkyStateChip(state: snapshot.solarData.state),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    snapshot.locationLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _celestialInk(context),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onPickLocation,
                  tooltip: l10n.worshipPrayerChooseLocationTitle,
                  splashRadius: 20,
                  icon: const Icon(Icons.location_on_outlined),
                ),
                _SkyStateChip(state: snapshot.solarData.state),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              IconButton(
                onPressed: onPreviousDay,
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: _celestialAccent(context),
                ),
                tooltip: l10n.homePrayerPreviousDayTooltip,
              ),
              Expanded(
                child: Text(
                  dateLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _celestialInk(context),
                  ),
                ),
              ),
              IconButton(
                onPressed: onNextDay,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: _celestialAccent(context),
                ),
                tooltip: l10n.homePrayerNextDayTooltip,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _HorizonProgress(snapshot: snapshot, reduceMotion: reduceMotion),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoPill(
                  label: l10n.celestialSunriseLabel,
                  value: DateFormat.jm().format(snapshot.solarData.sunrise),
                  shellTint: const Color(0xFFE7C259),
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
                  label: l10n.celestialSunsetLabel,
                  value: DateFormat.jm().format(snapshot.solarData.sunset),
                  shellTint: const Color(0xFFE7C259),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoPill(
                  label: l10n.celestialMoonriseLabel,
                  value: snapshot.lunarData.moonrise == null
                      ? l10n.celestialUnavailableLabel
                      : DateFormat.jm().format(snapshot.lunarData.moonrise!),
                  shellTint: const Color(0xFFC2C5CC),
                  footnote: snapshot.lunarData.riseSetApproximate
                      ? l10n.celestialApproximateLabel
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoPill(
                  label: l10n.celestialMoonsetLabel,
                  value: snapshot.lunarData.moonset == null
                      ? l10n.celestialUnavailableLabel
                      : DateFormat.jm().format(snapshot.lunarData.moonset!),
                  shellTint: const Color(0xFFC2C5CC),
                  footnote: snapshot.lunarData.riseSetApproximate
                      ? l10n.celestialApproximateLabel
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoPill(
                  label: l10n.celestialMoonPhaseLabel,
                  value: snapshot.lunarData.phaseName,
                  footnote: l10n.celestialIlluminationPercentLabel(
                    snapshot.lunarData.illuminationPercent,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoPill(
                  label: l10n.celestialNextEventLabel,
                  value: l10n.celestialNextEventValue(
                    snapshot.nextEvent.label,
                    DateFormat.jm().format(snapshot.nextEvent.time),
                  ),
                  footnote: snapshot.nextEvent.relativeDescription,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: NoorGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              surfaceVariant: AppSurfaceVariant.panel,
              surfaceTintColor: const Color(0xFFD5D7DD),
              surfaceAlphaOverride: 0.10,
              includeShadow: false,
              mode: NoorLiquidGlassMode.fake,
              borderRadius: 20,
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: MoonPhaseVisual(moon: moonVisual, size: 136),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          NoorGlassCard(
            padding: const EdgeInsets.all(15),
            surfaceVariant: AppSurfaceVariant.panel,
            surfaceTintColor: const Color(0xFFF1D8AE),
            surfaceAlphaOverride: 0.12,
            includeShadow: false,
            mode: NoorLiquidGlassMode.fake,
            borderRadius: 20,
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
      ),
    );
  }
}

class _CelestialGlassShell extends StatelessWidget {
  const _CelestialGlassShell({required this.child, this.state, this.onTap});

  final Widget child;
  final CelestialSkyState? state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shellStyle = _resolveSkyShellStyle(state);
    final glass = NoorLiquidGlassContainer(
      spec: NoorLiquidGlassSpec.card(
        mode: NoorLiquidGlassMode.liquid,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        fallbackTreatment: AppSurfaceTreatment.standard,
        tintColor: shellStyle.tintColor,
        surfaceAlphaOverride: shellStyle.surfaceAlpha,
        includeShadow: true,
        borderColor: shellStyle.borderColor,
        highlightGradientColors: shellStyle.highlightGradientColors,
        highlightGradientStops: const [0.0, 0.3, 1.0],
      ).copyWith(borderRadius: 36, borderWidth: 1),
      child: child,
    );

    if (onTap == null) {
      return glass;
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(36),
        child: glass,
      ),
    );
  }
}

class _SkyShellStyle {
  const _SkyShellStyle({
    required this.tintColor,
    required this.surfaceAlpha,
    required this.borderColor,
    required this.highlightGradientColors,
  });

  final Color tintColor;
  final double surfaceAlpha;
  final Color borderColor;
  final List<Color> highlightGradientColors;
}

_SkyShellStyle _resolveSkyShellStyle(CelestialSkyState? state) {
  return switch (state) {
    CelestialSkyState.dawn => const _SkyShellStyle(
      tintColor: Color(0xFFF1CAA2),
      surfaceAlpha: 0.26,
      borderColor: Color(0x52FFF3E0),
      highlightGradientColors: <Color>[
        Color(0x34FFF6EA),
        Color(0x14F7D2B6),
        Color(0x14D7C7F2),
      ],
    ),
    CelestialSkyState.day => const _SkyShellStyle(
      tintColor: Color(0xFFE8D2A1),
      surfaceAlpha: 0.24,
      borderColor: Color(0x52FFF7E8),
      highlightGradientColors: <Color>[
        Color(0x30FFF9EA),
        Color(0x12F4E0B7),
        Color(0x16D2E7FA),
      ],
    ),
    CelestialSkyState.dusk => const _SkyShellStyle(
      tintColor: Color(0xFFBD8B8A),
      surfaceAlpha: 0.28,
      borderColor: Color(0x52F8DED7),
      highlightGradientColors: <Color>[
        Color(0x26FFE7D8),
        Color(0x16D9A5AA),
        Color(0x1A766592),
      ],
    ),
    CelestialSkyState.night => const _SkyShellStyle(
      tintColor: Color(0xFFC4D8F3),
      surfaceAlpha: 0.24,
      borderColor: Color(0x4AF6FBFF),
      highlightGradientColors: <Color>[
        Color(0x2EF5FAFF),
        Color(0x10D7EAF9),
        Color(0x14C1D9F1),
      ],
    ),
    null => const _SkyShellStyle(
      tintColor: Color(0xFFE7C98C),
      surfaceAlpha: 0.2,
      borderColor: Color(0x42FFFFFF),
      highlightGradientColors: <Color>[
        Color(0x24FFFFFF),
        Colors.transparent,
        Color(0x16E8C98F),
      ],
    ),
  };
}

class _SkyStateChip extends StatelessWidget {
  const _SkyStateChip({required this.state});

  final CelestialSkyState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (state) {
      CelestialSkyState.dawn => (
        l10n.celestialSkyStateDawn,
        const Color(0xFFFFC68A),
      ),
      CelestialSkyState.day => (
        l10n.celestialSkyStateDay,
        const Color(0xFFFFE19A),
      ),
      CelestialSkyState.dusk => (
        l10n.celestialSkyStateDusk,
        const Color(0xFFE6A3AF),
      ),
      CelestialSkyState.night => (
        l10n.celestialSkyStateNight,
        const Color(0xFF9AB7FF),
      ),
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
      gradientColors: <Color>[Color(0x26AFC4EE), Color(0x18E7C4A1)],
    );
  }
  if (minutesFromEvent <= 45) {
    return const _SolarPillTint(
      surfaceTint: Color(0xFFF0C987),
      gradientColors: <Color>[Color(0x30F8D4A2), Color(0x1EF4B78A)],
    );
  }
  return const _SolarPillTint(
    surfaceTint: Color(0xFFE6C37D),
    gradientColors: <Color>[Color(0x24F5D89C), Color(0x18FFE9BE)],
  );
}

_SolarPillTint _resolveSunsetTint(int minutesFromEvent) {
  if (minutesFromEvent < -90) {
    return const _SolarPillTint(
      surfaceTint: Color(0xFFE0AE70),
      gradientColors: <Color>[Color(0x22F0C07D), Color(0x12F4D4A0)],
    );
  }
  if (minutesFromEvent <= 50) {
    return const _SolarPillTint(
      surfaceTint: Color(0xFFD89563),
      gradientColors: <Color>[Color(0x30EAA17B), Color(0x1ECA7C78)],
    );
  }
  return const _SolarPillTint(
    surfaceTint: Color(0xFFB87F6A),
    gradientColors: <Color>[Color(0x248C667D), Color(0x186D5E88)],
  );
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.value,
    this.footnote,
    this.tint,
    this.shellTint,
  });

  final String label;
  final String value;
  final String? footnote;
  final _SolarPillTint? tint;
  final Color? shellTint;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final night = appearance?.isNightFamily == true;
    final chipTint = shellTint ?? tint?.surfaceTint ?? const Color(0xFFE7C98C);
    // Night themes keep the pill on the standard dark glass; the solar and
    // lunar tint identities only color the daylight themes.
    final innerTop = night
        ? appearance!.onSurface.withValues(alpha: 0.10)
        : Color.lerp(chipTint, Colors.white, 0.42) ?? Colors.white;
    final innerBottom = night
        ? appearance!.onSurface.withValues(alpha: 0.05)
        : Color.lerp(chipTint, const Color(0xFFF7E8CC), 0.20) ?? chipTint;
    final innerBorder = night
        ? appearance!.onSurface.withValues(alpha: 0.16)
        : Color.lerp(
                Colors.white.withValues(alpha: 0.88),
                chipTint.withValues(alpha: 0.36),
                0.40,
              ) ??
              Colors.white.withValues(alpha: 0.88);
    return NoorGlassCard(
      padding: const EdgeInsets.all(4),
      surfaceVariant: AppSurfaceVariant.pill,
      surfaceTreatment: AppSurfaceTreatment.standard,
      surfaceTintColor: chipTint,
      surfaceAlphaOverride: 0.26,
      mode: NoorLiquidGlassMode.fake,
      includeShadow: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 108),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: innerBorder),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: night
                  ? [innerTop, innerBottom]
                  : [
                      innerTop.withValues(alpha: 0.94),
                      innerBottom.withValues(alpha: 0.88),
                      if (tint != null)
                        tint!.gradientColors.last.withValues(alpha: 0.18),
                    ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color:
                      appearance?.onSurfaceSubtle ??
                      context.palette.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.titleSmall),
              if (footnote != null) ...[
                const SizedBox(height: 4),
                Text(
                  footnote!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        appearance?.onSurfaceSubtle ??
                        context.palette.onSurfaceSubtle,
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

String _formatCardDateLabel({
  required AppLocalizations l10n,
  required DateTime selectedDate,
  required DateTime today,
}) {
  if (_sameDay(selectedDate, today)) {
    return '${l10n.homePrayerDateToday} • ${DateFormat.yMMMMd().format(selectedDate)}';
  }
  final yesterday = today.subtract(const Duration(days: 1));
  if (_sameDay(selectedDate, yesterday)) {
    return '${l10n.homePrayerDateYesterday} • ${DateFormat.yMMMMd().format(selectedDate)}';
  }
  final tomorrow = today.add(const Duration(days: 1));
  if (_sameDay(selectedDate, tomorrow)) {
    return '${l10n.homePrayerDateTomorrow} • ${DateFormat.yMMMMd().format(selectedDate)}';
  }
  return DateFormat.yMMMMd().format(selectedDate);
}

bool _sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class _HorizonProgress extends StatelessWidget {
  const _HorizonProgress({required this.snapshot, required this.reduceMotion});

  final CelestialSnapshot snapshot;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = snapshot.solarData.progress.clamp(0.0, 1.0);
    final icon = snapshot.solarData.isAboveHorizon
        ? Icons.wb_sunny_rounded
        : Icons.dark_mode_rounded;
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
                  l10n.celestialSunriseTimeLabel(
                    DateFormat.jm().format(snapshot.solarData.sunrise),
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  l10n.celestialSunsetTimeLabel(
                    DateFormat.jm().format(snapshot.solarData.sunset),
                  ),
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
  const _HorizonPainter({required this.color, required this.accent});

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
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.celestialUnavailableTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.celestialUnavailableSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onPickLocation,
          icon: const Icon(Icons.place_rounded),
          label: Text(l10n.celestialChooseLocationAction),
        ),
      ],
    );
  }
}
