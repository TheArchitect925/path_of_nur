import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../application/journey_drops_providers.dart';
import 'widgets/garden_cards.dart';
import 'widgets/garden_gallery.dart';

class GardenPage extends ConsumerWidget {
  const GardenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dropSummary = ref.watch(journeyDropSummaryProvider);
    final progress = ref.watch(gardenProgressSummaryProvider);
    final nextMilestone = ref.watch(nextGardenMilestoneProvider);

    return AppPageScaffold(
      headerIcon: Icons.local_florist_rounded,
      title: l10n.gardenPageTitle,
      subtitle: l10n.gardenPageSubtitle,
      children: [
        GardenHeroCard(
          totalDrops: dropSummary.totalDrops,
          unlockedCount: progress.unlockedCount,
          totalMilestones: progress.totalMilestones,
        ),
        const SizedBox(height: 14),
        const GardenMeaningCard(),
        const SizedBox(height: 14),
        GardenNextUnlockCard(summary: progress, nextMilestone: nextMilestone),
        const SizedBox(height: 14),
        const GardenGallerySection(),
      ],
    );
  }
}
