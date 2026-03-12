import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/segmented_pill_control.dart';
import '../../application/world_creation_provider.dart';
import '../../data/world_creation_data.dart';
import '../../domain/world_creation_models.dart';
import '../widgets/world_creation_cards.dart';

enum _ExploreTab { challenges, capture, gallery, guided, night, seasonal }

class WorldExploreCreationPage extends ConsumerStatefulWidget {
  const WorldExploreCreationPage({super.key});

  @override
  ConsumerState<WorldExploreCreationPage> createState() =>
      _WorldExploreCreationPageState();
}

class _WorldExploreCreationPageState
    extends ConsumerState<WorldExploreCreationPage> {
  _ExploreTab _tab = _ExploreTab.challenges;

  final _photoPathController = TextEditingController();
  final _locationController = TextEditingController();
  final _reflectionController = TextEditingController();
  final _verseReferenceController = TextEditingController(text: '3:190');
  final _verseSnapshotController = TextEditingController();
  WorldCreationCategoryId _captureCategory =
      WorldCreationCategoryId.reflectionSigns;

  @override
  void dispose() {
    _photoPathController.dispose();
    _locationController.dispose();
    _reflectionController.dispose();
    _verseReferenceController.dispose();
    _verseSnapshotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(worldCreationProgressProvider);
    final notifier = ref.read(worldCreationProgressProvider.notifier);
    final challenges = ref.watch(worldCreationChallengesProvider);
    final seasonal = ref.watch(worldCreationSeasonalChallengesProvider);
    final achievements = ref.watch(worldCreationAchievementsProvider);

    return AppPageScaffold(
      headerIcon: Icons.travel_explore_rounded,
      title: 'Explore Creation',
      subtitle: 'Observe -> Capture -> Connect Verse -> Reflect -> Save',
      children: [
        SegmentedPillControl<_ExploreTab>(
          items: _ExploreTab.values,
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
              _pill('Challenges', '${state.completedChallengeIds.length}'),
              _pill('Observations', '${state.observations.length}'),
              _pill('Guided sessions', '${state.guidedModeSessions}'),
              _pill('Night sessions', '${state.nightModeSessions}'),
            ],
          ),
        ),
        if (achievements.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Achievements',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: achievements
                      .map(
                        (item) => Chip(
                          label: Text(item),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        if (_tab == _ExploreTab.challenges)
          ...challenges.map(
            (challenge) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ChallengeCard(
                challenge: challenge,
                completed: state.completedChallengeIds.contains(challenge.id),
                onComplete: () => notifier.completeChallenge(challenge.id),
                onCapture: () {
                  setState(() {
                    _tab = _ExploreTab.capture;
                    _captureCategory = challenge.category;
                    _verseReferenceController.text =
                        challenge.verseReference.referenceLabel;
                    _verseSnapshotController.text =
                        'Qur\'an ${challenge.verseReference.referenceLabel}';
                  });
                },
              ),
            ),
          ),
        if (_tab == _ExploreTab.capture) _captureView(context),
        if (_tab == _ExploreTab.gallery) _galleryView(context),
        if (_tab == _ExploreTab.guided) _guidedModeView(context),
        if (_tab == _ExploreTab.night) _nightModeView(context),
        if (_tab == _ExploreTab.seasonal)
          ...seasonal.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _seasonLabel(entry.key),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ...entry.value
                        .take(3)
                        .map(
                          (challenge) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text('• ${challenge.title}'),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _captureView(BuildContext context) {
    final notifier = ref.read(worldCreationProgressProvider.notifier);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Capture a Sign',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use a local photo path for now, then connect a verse and write a private reflection.',
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _photoPathController,
            decoration: const InputDecoration(
              labelText: 'Photo path (optional)',
              hintText: '/path/to/image.jpg',
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<WorldCreationCategoryId>(
            initialValue: _captureCategory,
            decoration: const InputDecoration(labelText: 'Category'),
            items: WorldCreationCategoryId.values
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(_categoryLabel(item)),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _captureCategory = value);
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location name (optional)',
              hintText: 'Park, coast, rooftop, trail...',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Verse reference',
              hintText: 'e.g. 3:190',
            ),
            controller: _verseReferenceController,
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Verse text snapshot',
              hintText: 'Short verse text or label',
            ),
            controller: _verseSnapshotController,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _reflectionController,
            maxLines: 4,
            minLines: 3,
            decoration: const InputDecoration(
              labelText: 'Reflection',
              hintText: 'What did you observe? What did it teach you?',
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () {
              notifier.addObservation(
                category: _captureCategory,
                verseReference: _verseReferenceController.text,
                verseTextSnapshot: _verseSnapshotController.text,
                reflection: _reflectionController.text,
                imagePath: _photoPathController.text,
                locationName: _locationController.text,
                tags: [_captureCategory.name],
              );
              _reflectionController.clear();
              _photoPathController.clear();
              _locationController.clear();
              _verseSnapshotController.clear();
              setState(() => _tab = _ExploreTab.gallery);
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save to My Signs of Creation'),
          ),
        ],
      ),
    );
  }

  Widget _galleryView(BuildContext context) {
    final state = ref.watch(worldCreationProgressProvider);
    final notifier = ref.read(worldCreationProgressProvider.notifier);

    if (state.observations.isEmpty) {
      return const PremiumCard(
        child: Text(
          'No observations yet. Capture your first sign of creation.',
        ),
      );
    }

    return Column(
      children: state.observations
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GalleryTile(
                title:
                    '${_categoryLabel(item.category)} • ${item.verseReference}',
                subtitle:
                    '${item.userReflection}\n${item.optionalLocationName ?? 'Private location'} • ${item.createdAtIso.split('T').first}',
                favorite: item.isFavorite,
                onTap: () => _showObservationSheet(context, item, notifier),
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _guidedModeView(BuildContext context) {
    final notifier = ref.read(worldCreationProgressProvider.notifier);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Guided Explore Mode',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Look up at the sky. Notice cloud movement. Observe textures in the earth. Listen for birds. Notice water, wind, and light.',
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () {
              notifier.markGuidedModeSession();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Guided session logged.')),
              );
            },
            icon: const Icon(Icons.play_circle_outline_rounded),
            label: const Text('Start guided session'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.pushNamed('worldSignsExplorer'),
            icon: const Icon(Icons.hub_outlined),
            label: const Text('Open Signs Explorer'),
          ),
        ],
      ),
    );
  }

  Widget _nightModeView(BuildContext context) {
    final notifier = ref.read(worldCreationProgressProvider.notifier);
    return PremiumCard(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E2738), Color(0xFF162334)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Night Sky Mode',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Focus on stars, moon, darkness, and scale. Observe quietly and reflect on humility.',
              style: TextStyle(color: Color(0xFFE7E9F2)),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {
                    notifier.markNightModeSession();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Night session logged.')),
                    );
                  },
                  icon: const Icon(Icons.nights_stay_rounded),
                  label: const Text('Start night session'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed('worldCosmicScale'),
                  icon: const Icon(Icons.straighten_rounded),
                  label: const Text('Cosmic scale'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed('worldDeepOcean'),
                  icon: const Icon(Icons.water_rounded),
                  label: const Text('Deep ocean'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showObservationSheet(
    BuildContext context,
    CreationObservation observation,
    WorldCreationProgressNotifier notifier,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_categoryLabel(observation.category)} • ${observation.verseReference}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(observation.userReflection),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {
                        notifier.toggleObservationFavorite(observation.id);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        observation.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                      ),
                      label: Text(
                        observation.isFavorite ? 'Unfavorite' : 'Favorite',
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        notifier.deleteObservation(observation.id);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _pill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF3E8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCEB07D)),
      ),
      child: Text('$label: $value'),
    );
  }

  String _tabLabel(_ExploreTab tab) {
    switch (tab) {
      case _ExploreTab.challenges:
        return 'Challenges';
      case _ExploreTab.capture:
        return 'Capture';
      case _ExploreTab.gallery:
        return 'Gallery';
      case _ExploreTab.guided:
        return 'Guided';
      case _ExploreTab.night:
        return 'Night';
      case _ExploreTab.seasonal:
        return 'Seasonal';
    }
  }

  String _categoryLabel(WorldCreationCategoryId id) {
    final category = worldCreationCategoryById(id);
    return category?.title ?? id.name;
  }

  String _seasonLabel(String key) {
    switch (key) {
      case 'spring':
        return 'Spring observations';
      case 'summer':
        return 'Summer observations';
      case 'autumn':
        return 'Autumn observations';
      case 'winter':
        return 'Winter observations';
      default:
        return 'All-season observations';
    }
  }
}
