import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_verse_content.dart';
import '../../creation_challenges/application/creation_challenge_services.dart';
import '../../creation_challenges/domain/creation_challenge_models.dart';
import '../application/celestial_services.dart';
import '../domain/celestial_models.dart';

class CelestialExplorerPage extends ConsumerStatefulWidget {
  const CelestialExplorerPage({super.key});

  @override
  ConsumerState<CelestialExplorerPage> createState() => _CelestialExplorerPageState();
}

class _CelestialExplorerPageState extends ConsumerState<CelestialExplorerPage> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(celestialActionServiceProvider).markExplorerOpened();
      ref.read(creationChallengeServiceProvider.notifier).processEvidence(
        CreationChallengeEvidence(
          ruleType: CreationChallengeRuleType.openExplorer,
          source: CreationExplorerMode.skyExplorer,
          occurredAt: DateTime.now(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final l10n = AppLocalizations.of(context);
    final snapshotAsync = ref.watch(celestialSnapshotProvider);
    final observations = ref.watch(celestialObservationsProvider);
    final tabContentHeight = math.max(
      520.0,
      MediaQuery.sizeOf(context).height - 300,
    );

    return DefaultTabController(
      length: 3,
      child: AppPageScaffold(
        headerIcon: Icons.wb_twilight_rounded,
        title: l10n.celestialExplorerPageTitle,
        subtitle: localizedAppPageDescription(
          context,
          AppPageDescriptionKey.celestialExplorer,
          kidsMode: isKidsMode,
        ),
        headerActions: [
          IconButton(
            onPressed: () => ref.invalidate(celestialSnapshotProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
        children: [
          const _ExplorerTabBar(),
          const SizedBox(height: 12),
          SizedBox(
            height: tabContentHeight,
            child: snapshotAsync.when(
              data: (snapshot) => TabBarView(
                children: [
                  _OverviewTab(
                    snapshot: snapshot,
                    noteController: _noteController,
                  ),
                  _ExploreTab(snapshot: snapshot),
                  _JournalTab(
                    observations: observations,
                    onDelete: (id) async {
                      await ref.read(celestialObservationsProvider.notifier).remove(id);
                    },
                    onFavorite: (id) async {
                      await ref.read(celestialObservationsProvider.notifier).toggleFavorite(id);
                    },
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (_, _) => const _ExplorerUnavailable(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplorerTabBar extends StatelessWidget {
  const _ExplorerTabBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return Container(
      decoration: surfaceStyle.decoration(radius: 18),
      padding: const EdgeInsets.all(6),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.accentGold.withValues(alpha: 0.16),
          border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.18)),
        ),
        labelColor: AppColors.onSurface,
        unselectedLabelColor: AppColors.onSurfaceSubtle,
        labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(text: l10n.celestialTabNow),
          Tab(text: l10n.celestialTabExplore),
          Tab(text: l10n.celestialTabJournal),
        ],
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({
    required this.snapshot,
    required this.noteController,
  });

  final CelestialSnapshot snapshot;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 140),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.locationLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${DateFormat.yMMMMEEEEd().format(snapshot.timestamp)} • ${snapshot.hijriDate.day} ${snapshot.hijriDate.monthName} ${snapshot.hijriDate.year} AH',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: l10n.celestialSunLabel,
                      headline: snapshot.solarData.state == CelestialSkyState.night
                          ? l10n.celestialBelowHorizonLabel
                          : l10n.celestialVisibleLabel,
                      detail: l10n.celestialSunriseSunsetDetail(
                        DateFormat.jm().format(snapshot.solarData.sunrise),
                        DateFormat.jm().format(snapshot.solarData.sunset),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: l10n.celestialMoonLabel,
                      headline: snapshot.lunarData.phaseName,
                      detail: l10n.celestialMoonDetail(
                        snapshot.lunarData.illuminationPercent,
                        snapshot.lunarData.riseSetApproximate
                            ? l10n.celestialRiseSetApproximate
                            : l10n.celestialRiseSetCalculated,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _MetricCard(
                title: l10n.celestialUpcomingLabel,
                headline: l10n.celestialUpcomingHeadline(
                  snapshot.nextEvent.label,
                  DateFormat.jm().format(snapshot.nextEvent.time),
                ),
                detail: snapshot.nextEvent.relativeDescription,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
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
                arabicBaseSize: 27,
              ),
              const SizedBox(height: 10),
              Text(
                snapshot.verseOfMoment.shortReflection,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => ref.read(celestialActionServiceProvider).markVerseOpened(snapshot.verseOfMoment),
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: Text(l10n.celestialReflectAction),
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      final note = noteController.text.trim();
                      if (note.isEmpty) return;
                      await ref.read(celestialActionServiceProvider).saveObservation(
                            snapshot: snapshot,
                            verse: snapshot.verseOfMoment,
                            note: note,
                          );
                      noteController.clear();
                      ref.read(celestialObservationsProvider.notifier).reload();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.celestialReflectionSaved),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.bookmark_add_rounded),
                    label: Text(l10n.celestialSaveReflectionAction),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.celestialJournalMomentTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                minLines: 3,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: l10n.celestialJournalPromptHint,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExploreTab extends ConsumerWidget {
  const _ExploreTab({required this.snapshot});

  final CelestialSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final heading = ref.watch(celestialCompassHeadingProvider).value;
    final reading = ref.read(celestialCalculationServiceProvider).buildDirectionalReading(
          snapshot: snapshot,
          headingDegrees: heading,
        );

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 140),
      children: [
        PremiumCard(
          child: Column(
            children: [
              Text(
                heading == null
                    ? l10n.celestialCompassUnavailable
                    : l10n.celestialCompassHeading('${heading.round()}°'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              _CompassBand(reading: reading),
              const SizedBox(height: 12),
              Text(
                l10n.celestialPositionEstimateNotice,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _DirectionalInfoCard(marker: reading.sun),
        const SizedBox(height: 12),
        _DirectionalInfoCard(marker: reading.moon),
      ],
    );
  }
}

class _JournalTab extends StatelessWidget {
  const _JournalTab({
    required this.observations,
    required this.onDelete,
    required this.onFavorite,
  });

  final List<CelestialObservation> observations;
  final Future<void> Function(String id) onDelete;
  final Future<void> Function(String id) onFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (observations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 140),
          child: PremiumCard(
            child: Text(
              l10n.celestialJournalEmptyState,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceSubtle,
              ),
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 140),
      itemBuilder: (context, index) {
        final item = observations[index];
        return PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.locationLabel,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${DateFormat.yMMMd().add_jm().format(item.timestamp)} • ${item.moonPhaseName}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceSubtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onFavorite(item.id);
                    },
                    icon: Icon(
                      item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onDelete(item.id);
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.verseReference,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.reflectionNote,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemCount: observations.length,
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.headline,
    required this.detail,
  });

  final String title;
  final String headline;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(14),
      surfaceVariant: AppSurfaceVariant.pill,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 4),
          Text(headline, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionalInfoCard extends StatelessWidget {
  const _DirectionalInfoCard({required this.marker});

  final CelestialDirectionMarker marker;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  marker.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: marker.isVisible
                      ? const Color(0xFFFFD27A).withValues(alpha: 0.16)
                      : Theme.of(context).colorScheme.surface.withValues(alpha: 0.52),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  marker.status,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(marker.guidance, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            l10n.celestialApproximatePositionLabel(
              marker.azimuthDegrees.round(),
              marker.altitudeDegrees.round(),
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassBand extends StatelessWidget {
  const _CompassBand({required this.reading});

  final CelestialDirectionalReading reading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 180,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, 180),
                painter: _CompassPainter(reading: reading),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.celestialCompassNorthLabel,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    reading.headingDegrees == null
                        ? l10n.celestialMoveSlowlyForHeading
                        : '${reading.headingDegrees!.round()}°',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  const _CompassPainter({required this.reading});

  final CelestialDirectionalReading reading;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.36;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.onSurfaceSubtle.withValues(alpha: 0.18);
    canvas.drawCircle(center, radius, ringPaint);

    for (var i = 0; i < 12; i += 1) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final outer = Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius);
      final inner = Offset(center.dx + math.cos(angle) * (radius - 10), center.dy + math.sin(angle) * (radius - 10));
      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..strokeWidth = 1.2
          ..color = AppColors.onSurfaceSubtle.withValues(alpha: 0.28),
      );
    }

    _drawMarker(canvas, center, radius, reading.sun, const Color(0xFFFFD27A));
    _drawMarker(canvas, center, radius - 20, reading.moon, const Color(0xFFC9D9FF));
  }

  void _drawMarker(
    Canvas canvas,
    Offset center,
    double radius,
    CelestialDirectionMarker marker,
    Color color,
  ) {
    final angle = (marker.azimuthDegrees - 90) * math.pi / 180;
    final point = Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius);
    final paint = Paint()..color = color.withValues(alpha: marker.isVisible ? 0.95 : 0.45);
    canvas.drawCircle(point, 7, paint);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter oldDelegate) => true;
}

class _ExplorerUnavailable extends StatelessWidget {
  const _ExplorerUnavailable();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 140),
        child: PremiumCard(
          child: Text(
            l10n.celestialExplorerUnavailable,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceSubtle,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
