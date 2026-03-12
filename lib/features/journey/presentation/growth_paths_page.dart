import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/premium_card.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthPathsPage extends ConsumerWidget {
  const GrowthPathsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paths = ref.watch(growthPathProgressProvider);
    final pathCopy = ref.watch(growthPathContentByIdProvider);
    final stageCopy = ref.watch(growthStageContentByNumberProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PremiumCard(
          child: Text(
            'Guided spiritual journeys help you focus on what matters now instead of managing everything at once.',
          ),
        ),
        const SizedBox(height: 12),
        ...paths.map(
          (progress) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PremiumCard(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => context.pushNamed(
                  'growthPathDetail',
                  pathParameters: {'pathId': progress.path.id},
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEADDC8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(growthPathIcon(progress.path.icon), size: 19),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                progress.path.title,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                progress.path.subtitle,
                                style: const TextStyle(color: Color(0xFF6A5A4A)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(progress.path.description),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoPill(
                          label: '${progress.completedHabits}/${progress.path.totalHabits} habits',
                        ),
                        _InfoPill(label: progress.path.estimatedCommitment),
                        _InfoPill(
                          label: pathCopy[progress.path.id]?.stageLabel ??
                              stageCopy[progress.path.stage]?.title ??
                              'Stage ${progress.path.stage}',
                        ),
                        _InfoPill(label: progress.unlocked ? 'Unlocked' : 'Locked'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pathCopy[progress.path.id]?.whyItMatters ??
                          'Consistency grows over time through steady steps.',
                      style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      progress.recommendedNextStep,
                      style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12.5),
                    ),
                    if (progress.completionCelebrationPending) ...[
                      const SizedBox(height: 6),
                      const Text(
                        'Path completed. Alhamdulillah. Open details to acknowledge completion.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(value: progress.progress),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: !progress.unlocked
                                ? null
                                : () {
                                    final controller =
                                        ref.read(growthControllerProvider.notifier);
                                    if (!progress.started) {
                                      controller.setPathStarted(
                                        progress.path.id,
                                        started: true,
                                      );
                                      return;
                                    }
                                    controller.setPathPaused(
                                      progress.path.id,
                                      paused: !progress.paused,
                                    );
                                  },
                            child: Text(
                              !progress.started
                                  ? 'Start'
                                  : progress.paused
                                  ? 'Resume'
                                  : 'Pause',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EFE4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12.2)),
    );
  }
}
