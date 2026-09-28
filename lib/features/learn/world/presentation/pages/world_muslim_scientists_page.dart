import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../application/world_creation_provider.dart';
import '../../domain/world_creation_models.dart';
import '../../../../../l10n/app_localizations.dart';

class WorldMuslimScientistsPage extends ConsumerWidget {
  const WorldMuslimScientistsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scientists = ref.watch(worldCreationScientistsProvider);

    return AppPageScaffold(
      title: AppLocalizations.of(context).worldLandingMuslimScientistsTitle,
      subtitle: AppLocalizations.of(context).worldMuslimScientistsSubtitle,
      children: [
        ...scientists.map(
          (profile) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CompactListTile(
              title: profile.name,
              subtitle: '${profile.discipline} • ${profile.era}',
              onTap: () => _showProfileSheet(context, profile),
            ),
          ),
        ),
      ],
    );
  }

  void _showProfileSheet(BuildContext context, ScientistProfile profile) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${profile.discipline} • ${profile.era}'),
                  const SizedBox(height: 10),
                  Text(profile.summary),
                  const SizedBox(height: 10),
                  const Text(
                    'Contribution Highlights',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  ...profile.contributionHighlights.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('- $item'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Why It Matters',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(profile.whyItMatters),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.relatedTopics
                        .map((topic) => Chip(label: Text(topic)))
                        .toList(growable: false),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
