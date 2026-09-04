import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthPathDetailPage extends ConsumerWidget {
  const GrowthPathDetailPage({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final all = ref.watch(growthPathProgressProvider);
    GrowthPathProgress? progress;
    for (final item in all) {
      if (item.path.id == pathId) {
        progress = item;
        break;
      }
    }

    if (progress == null) {
      return AppPageScaffold(
        title: l10n.growthPathDetailPageTitle,
        children: [PremiumCard(child: Text(l10n.growthPathUnavailableMessage))],
      );
    }
    final p = progress;
    final habits = ref
        .watch(growthAllHabitsProvider)
        .where((h) => p.path.habitIds.contains(h.id))
        .toList();
    final journey = ref.watch(growthJourneyStatsProvider);
    final pathCopy = ref.watch(growthPathContentByIdProvider)[p.path.id];
    final stageCopy = ref.watch(
      growthStageContentByNumberProvider,
    )[p.path.stage];

    return AppPageScaffold(
      title: p.path.title,
      subtitle: p.path.subtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.path.description),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(
                    label: l10n.growthPathDifficultyValue(
                      p.path.difficulty.name,
                    ),
                  ),
                  _Pill(
                    label: l10n.growthPathCommitmentValue(
                      p.path.estimatedCommitment,
                    ),
                  ),
                  _Pill(
                    label: l10n.growthPathCompletedHabitsValue(
                      '${p.completedHabits}',
                      '${p.path.totalHabits}',
                    ),
                  ),
                  _Pill(
                    label:
                        pathCopy?.stageLabel ??
                        stageCopy?.title ??
                        l10n.growthStageValue('${p.path.stage}'),
                  ),
                  _Pill(
                    label: l10n.growthPathCurrentStreakValue(
                      l10n.homeDaysCount(journey.currentStreakDays),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                pathCopy?.whyItMatters ?? l10n.growthPathWhyItMattersFallback,
                style: const TextStyle(color: Color(0xFF6A5A4A)),
              ),
              if ((pathCopy?.milestoneNames ?? const []).isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pathCopy!.milestoneNames
                      .map((name) => _Pill(label: name))
                      .toList(),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                p.recommendedNextStep,
                style: const TextStyle(
                  color: Color(0xFF6A5A4A),
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(value: p.progress),
              ),
              if (p.completionCelebrationPending) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => ref
                            .read(growthControllerProvider.notifier)
                            .markPathCelebrated(pathId),
                        child: Text(l10n.growthPathAcknowledgeCompletionAction),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: !p.unlocked
                          ? null
                          : () {
                              final controller = ref.read(
                                growthControllerProvider.notifier,
                              );
                              if (!p.started) {
                                controller.setPathStarted(
                                  pathId,
                                  started: true,
                                );
                                return;
                              }
                              controller.setPathPaused(
                                pathId,
                                paused: !p.paused,
                              );
                            },
                      child: Text(
                        !p.started
                            ? l10n.growthPathStartAction
                            : p.paused
                            ? l10n.growthPathResumeAction
                            : l10n.growthPathPauseAction,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthPathHabitsInThisPathTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...habits.map(
                (habit) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(habit.title),
                  subtitle: Text(
                    '${habit.subtitle} · ${growthRecurrenceLabel(habit)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.pushNamed(
                    'growthHabitDetail',
                    pathParameters: {'habitId': habit.id},
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: growthNoorPillDecoration(context),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
