import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/ocean_drops_provider.dart';

class OceanDropsPage extends ConsumerWidget {
  const OceanDropsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(oceanDropsProvider);
    final history = ref.watch(oceanGroupedHistoryProvider);
    final milestones = ref.watch(oceanMilestoneThresholdsProvider);
    final progression = ref.watch(oceanProgressionMapProvider);
    final timeline = ref.watch(oceanHistoricalTimelineProvider);

    final sourceTotals = <OceanDropSource, int>{};
    for (final event in state.events) {
      sourceTotals[event.source] =
          (sourceTotals[event.source] ?? 0) + event.drops;
    }

    final nextMilestone = milestones.firstWhere(
      (value) => value > state.totalLocalDrops,
      orElse: () => milestones.last,
    );

    return AppPageScaffold(
      headerIcon: Icons.water_drop_outlined,
      title: l10n.oceanTitle,
      subtitle: l10n.oceanSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.oceanLocalDropsLabel}: ${state.totalLocalDrops}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.oceanStageLabel(_stageLabel(l10n, state.symbolicStage)),
              ),
              const SizedBox(height: 8),
              Text('${l10n.oceanTodayDropsLabel}: ${state.todayDrops}'),
              Text('${l10n.oceanWeekDropsLabel}: ${state.weekDrops}'),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (state.totalLocalDrops / nextMilestone)
                      .clamp(0, 1)
                      .toDouble(),
                  minHeight: 9,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.oceanNextMilestone(nextMilestone)),
              const SizedBox(height: 8),
              Text(
                l10n.oceanCommunityPlaceholder(state.communityPlaceholderDrops),
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
                l10n.oceanSourcesTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              if (sourceTotals.isEmpty)
                Text(l10n.oceanNoSourceData)
              else
                ...sourceTotals.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(_sourceLabel(l10n, entry.key))),
                        Text('+${entry.value}'),
                      ],
                    ),
                  ),
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
                l10n.oceanProgressionMapTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: progression
                    .map(
                      (item) => Container(
                        width: 100,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.reached
                              ? const Color(0xFFE9F5E7)
                              : const Color(0xFFF8F2E9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: item.reached
                                ? const Color(0xFF79A678)
                                : const Color(0xFFD7C4A8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.threshold}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                minHeight: 6,
                                value: item.reached ? 1 : item.progressToNext,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.oceanHistoryTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              if (timeline.isEmpty)
                Text(l10n.oceanNoSourceData)
              else
                ...timeline.map(
                  (entry) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7EFE3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.oceanTimelineSources(entry.sources.length),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text('+${entry.totalDrops}'),
                      ],
                    ),
                  ),
                ),
              if (history.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.oceanRecentDaysLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                ...history.entries
                    .take(3)
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(entry.key)),
                            Text(
                              '+${entry.value.values.fold<int>(0, (sum, value) => sum + value)}',
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _stageLabel(AppLocalizations l10n, String stage) {
    switch (stage) {
      case 'stream':
        return l10n.oceanStageStream;
      case 'flowing':
        return l10n.oceanStageFlowing;
      case 'rising':
        return l10n.oceanStageRising;
      case 'vast':
        return l10n.oceanStageVast;
      case 'spring':
      default:
        return l10n.oceanStageSpring;
    }
  }

  String _sourceLabel(AppLocalizations l10n, OceanDropSource source) {
    switch (source) {
      case OceanDropSource.prayer:
        return l10n.oceanSourcePrayer;
      case OceanDropSource.dhikr:
        return l10n.oceanSourceDhikr;
      case OceanDropSource.fasting:
        return l10n.oceanSourceFasting;
      case OceanDropSource.quran:
        return l10n.oceanSourceQuran;
      case OceanDropSource.reflection:
        return l10n.oceanSourceReflection;
      case OceanDropSource.learning:
        return l10n.oceanSourceLearning;
      case OceanDropSource.milestone:
        return l10n.oceanSourceMilestone;
    }
  }
}
