import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
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
    final snapshotAsync = ref.watch(celestialSnapshotProvider);
    final observations = ref.watch(celestialObservationsProvider);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF08121F), Color(0xFF0C1F37), Color(0xFF09111B)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Qur’anic Sky Explorer',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              localizedAppPageDescription(
                                context,
                                AppPageDescriptionKey.celestialExplorer,
                                kidsMode: isKidsMode,
                              ),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref.invalidate(celestialSnapshotProvider),
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const TabBar(
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'Now'),
                      Tab(text: 'Explore'),
                      Tab(text: 'Journal'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
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
          ),
        ),
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                '${DateFormat.yMMMMEEEEd().format(snapshot.timestamp)} • ${snapshot.hijriDate.day} ${snapshot.hijriDate.monthName} ${snapshot.hijriDate.year} AH',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Sun',
                      headline: snapshot.solarData.state == CelestialSkyState.night
                          ? 'Below horizon'
                          : 'Visible',
                      detail:
                          'Sunrise ${DateFormat.jm().format(snapshot.solarData.sunrise)} • Sunset ${DateFormat.jm().format(snapshot.solarData.sunset)}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'Moon',
                      headline: snapshot.lunarData.phaseName,
                      detail:
                          '${snapshot.lunarData.illuminationPercent}% illumination • ${snapshot.lunarData.riseSetApproximate ? 'Rise/set approximate' : 'Rise/set calculated'}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _MetricCard(
                title: 'Upcoming',
                headline: '${snapshot.nextEvent.label} at ${DateFormat.jm().format(snapshot.nextEvent.time)}',
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => ref.read(celestialActionServiceProvider).markVerseOpened(snapshot.verseOfMoment),
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text('Reflect'),
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
                          const SnackBar(content: Text('Sky reflection saved.')),
                        );
                      }
                    },
                    icon: const Icon(Icons.bookmark_add_rounded),
                    label: const Text('Save reflection'),
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
                'Journal this moment',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'What did the sky make you notice today?',
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
                heading == null ? 'Compass unavailable' : '${heading.round()}° heading',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 14),
              _CompassBand(reading: reading),
              const SizedBox(height: 12),
              Text(
                'Positions are calculated estimates. Sensor readings may be noisy indoors.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
    if (observations.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Saved sky reflections will appear here once you begin journaling.',
            textAlign: TextAlign.center,
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${DateFormat.yMMMd().add_jm().format(item.timestamp)} • ${item.moonPhaseName}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                item.reflectionNote,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            headline,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  marker.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: marker.isVisible
                      ? const Color(0xFFFFD27A).withValues(alpha: 0.16)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(marker.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            marker.guidance,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Approximate azimuth ${marker.azimuthDegrees.round()}° • altitude ${marker.altitudeDegrees.round()}°',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
                    'N',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    reading.headingDegrees == null
                        ? 'Move slowly for heading'
                        : '${reading.headingDegrees!.round()}°',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
      ..color = Colors.white.withValues(alpha: 0.12);
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
          ..color = Colors.white.withValues(alpha: 0.2),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'The explorer could not build a sky snapshot right now. Check location settings and try again.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
