import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/circles_provider.dart';

class NearbyMosquesPage extends ConsumerWidget {
  const NearbyMosquesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(circlesProvider);
    final mosques = ref.watch(nearbyMosquesProvider);
    final selected = ref.watch(selectedMosqueProvider);
    final notifier = ref.read(circlesProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.location_city_outlined,
      title: l10n.circlesNearbyMosquesTitle,
      subtitle: l10n.circlesNearbyMosquesSubtitle,
      children: [
        if (selected != null)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.circlesMosqueSelected,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text('${selected.name} • ${selected.city}'),
                const SizedBox(height: 8),
                ...selected.timetable.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(entry.key)),
                        Text(entry.value),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (selected != null) const SizedBox(height: 12),
        ...mosques.map(
          (mosque) {
            final imported = state.importedMosqueIds.contains(mosque.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mosque.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text('${mosque.city} • ${mosque.distanceKm.toStringAsFixed(1)} km'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: () => notifier.toggleMosqueImported(
                              mosque.id,
                            ),
                            child: Text(
                              imported
                                  ? l10n.circlesImported
                                  : l10n.circlesImportTimetable,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: imported
                                ? () => notifier.selectMosque(mosque.id)
                                : null,
                            child: Text(l10n.circlesOpen),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
