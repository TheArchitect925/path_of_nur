import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../journey/drops/application/journey_drops_providers.dart';
import '../../journey/drops/presentation/widgets/garden_cards.dart';
import '../application/ocean_drops_provider.dart';
import '../../../core/theme/app_icons.dart';

class OceanDashboardPage extends ConsumerWidget {
  const OceanDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final oceanState = ref.watch(oceanDropsProvider);
    final dropSummary = ref.watch(journeyDropSummaryProvider);
    final gardenProgress = ref.watch(gardenProgressSummaryProvider);
    final nextGardenMilestone = ref.watch(nextGardenMilestoneProvider);

    return AppPageScaffold(
      headerIcon: AppIcons.drops,
      title: l10n.growthOceanDashboardTitle,
      subtitle: l10n.growthOceanDashboardSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.oceanTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthOceanDashboardSummary(
                  countFormat.format(dropSummary.totalDrops),
                  oceanState.totalCommunityDrops.toString(),
                ),
                style: const TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MetricPill(
                    label: l10n.growthOceanDashboardYourDrops,
                    value: countFormat.format(dropSummary.totalDrops),
                  ),
                  _MetricPill(
                    label: l10n.growthOceanDashboardToday,
                    value: countFormat.format(dropSummary.todayDrops),
                  ),
                  _MetricPill(
                    label: l10n.growthOceanDashboardCommunity,
                    value: oceanState.totalCommunityDrops.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('oceanCommunityDetails'),
                icon: const Icon(Icons.waves_rounded),
                label: Text(l10n.growthOceanDashboardOpenCommunity),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GardenEntryCard(
          summary: gardenProgress,
          nextMilestone: nextGardenMilestone,
          onTap: () => context.pushNamed('gardenPage'),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPill(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      fillColor: const Color(0xFFF3EEE6),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
