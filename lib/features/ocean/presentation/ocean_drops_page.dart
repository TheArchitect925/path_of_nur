import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/state/user_profile_state.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/community_ocean.dart';
import '../application/ocean_drops_provider.dart';

class OceanDropsPage extends ConsumerWidget {
  const OceanDropsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final personal = ref.watch(personalWaterStatsProvider);
    final community = ref.watch(communityOceanStatsProvider);
    final personalStage = ref.watch(personalWaterStageProgressProvider);
    final communityStage = ref.watch(communityOceanStageProgressProvider);
    final sourceTotals = _sourceTotals(ref.watch(oceanDropsProvider).events);
    final contributionPercent = CommunityOceanLogic.formatContributionPercent(
      contribution: personal.totalPersonalDrops,
      total: community.totalCommunityDrops,
    );
    final benchmarkProgress = CommunityOceanLogic.oceanBenchmarkProgress(
      community.totalCommunityDrops,
    );

    return AppPageScaffold(
      headerIcon: Icons.water_drop_rounded,
      title: 'Community Ocean',
      subtitle:
          'Every act adds a drop. Together, the drops gather into an ocean.',
      children: [
        CommunityOceanHero(
          name: profile.name,
          personal: personal,
          community: community,
          personalStage: personalStage,
          communityStage: communityStage,
        ),
        const SizedBox(height: 16),
        CommunityOceanVisualCard(
          communityStage: communityStage,
          benchmarkProgress: benchmarkProgress,
        ),
        const SizedBox(height: 16),
        CommunityOceanProgressCard(
          community: community,
          communityStage: communityStage,
          benchmarkProgress: benchmarkProgress,
        ),
        const SizedBox(height: 16),
        PersonalContributionCard(
          personal: personal,
          community: community,
          communityStage: communityStage,
          contributionPercent: contributionPercent,
        ),
        const SizedBox(height: 16),
        PersonalWaterPathCard(
          personal: personal,
          personalStage: personalStage,
        ),
        const SizedBox(height: 16),
        WaterEquivalentCard(
          personal: personal,
          community: community,
          communityStage: communityStage,
        ),
        const SizedBox(height: 16),
        CommunityStageLadder(
          communityStage: communityStage,
          personalStage: personalStage,
        ),
        const SizedBox(height: 16),
        _SourceEchoCard(sourceTotals: sourceTotals),
        const SizedBox(height: 16),
        ReflectionFooter(
          reflection: _reflectionFor(
            personalStage.currentStage.title,
            communityStage.currentStage.title,
          ),
        ),
      ],
    );
  }

  Map<String, int> _sourceTotals(List<OceanDropEvent> events) {
    final totals = <String, int>{};
    for (final event in events) {
      totals[event.sourceModule] = (totals[event.sourceModule] ?? 0) + event.amount;
    }
    return totals;
  }

  String _reflectionFor(String personalStage, String communityStage) {
    final seed = (personalStage.length + communityStage.length) %
        communityOceanReflectionLines.length;
    return communityOceanReflectionLines[seed];
  }
}

class CommunityOceanHero extends StatelessWidget {
  const CommunityOceanHero({
    super.key,
    required this.name,
    required this.personal,
    required this.community,
    required this.personalStage,
    required this.communityStage,
  });

  final String name;
  final PersonalWaterStats personal;
  final CommunityOceanStats community;
  final StageProgress<PersonalWaterStage> personalStage;
  final StageProgress<CommunityOceanStage> communityStage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF305D6E), Color(0xFF153040)],
        ),
      ),
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Peaceful contribution, $name',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your drops travel a personal water path while also joining something far larger than any one person can finish alone.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HeroMetricChip(
                    label: 'Community stage',
                    value: communityStage.currentStage.title,
                    icon: Icons.waves_rounded,
                  ),
                  _HeroMetricChip(
                    label: 'Your water path',
                    value: personalStage.currentStage.title,
                    icon: Icons.waterfall_chart_rounded,
                  ),
                  _HeroMetricChip(
                    label: 'Drops today',
                    value: '${personal.personalDropsToday}',
                    icon: Icons.water_drop_outlined,
                  ),
                  _HeroMetricChip(
                    label: 'Community total',
                    value: CommunityOceanLogic.formatLargeDropCount(
                      community.totalCommunityDrops,
                    ),
                    icon: Icons.public_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityOceanVisualCard extends StatelessWidget {
  const CommunityOceanVisualCard({
    super.key,
    required this.communityStage,
    required this.benchmarkProgress,
  });

  final StageProgress<CommunityOceanStage> communityStage;
  final double benchmarkProgress;

  @override
  Widget build(BuildContext context) {
    final stageIndex = communityOceanStages.indexOf(communityStage.currentStage);
    final visualDepth = (stageIndex + communityStage.progress) /
        communityOceanStages.length;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shared waters',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            communityStage.hasReachedCurrentStage
                ? 'The community is presently flowing in ${communityStage.currentStage.title.toLowerCase()}.'
                : 'The first visible gathering is still moving toward ${communityStage.currentStage.title}.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE7F2F4), Color(0xFFD6E7EA), Color(0xFFB3CCD5)],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: visualDepth.clamp(0.04, 1)),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return CustomPaint(
                    painter: _CommunityOceanPainter(
                      depth: value,
                      shimmer: benchmarkProgress.clamp(0.08, 1),
                    ),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityOceanProgressCard extends StatelessWidget {
  const CommunityOceanProgressCard({
    super.key,
    required this.community,
    required this.communityStage,
    required this.benchmarkProgress,
  });

  final CommunityOceanStats community;
  final StageProgress<CommunityOceanStage> communityStage;
  final double benchmarkProgress;

  @override
  Widget build(BuildContext context) {
    final nextStage = communityStage.nextStage;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community stage progress',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _KeyValueRow(
            label: 'Current stage',
            value: communityStage.hasReachedCurrentStage
                ? communityStage.currentStage.title
                : 'Gathering toward ${communityStage.currentStage.title}',
          ),
          _KeyValueRow(
            label: 'Total community drops',
            value:
                '${CommunityOceanLogic.formatLargeDropCount(community.totalCommunityDrops)} (${community.totalCommunityDrops})',
          ),
          _KeyValueRow(
            label: 'Next stage',
            value: nextStage?.title ?? 'Ocean of Creation reached',
          ),
          _KeyValueRow(
            label: 'Remaining',
            value: nextStage == null
                ? 'None'
                : CommunityOceanLogic.formatReadableStageDistance(
                    communityStage.dropsRemainingToNext,
                  ),
          ),
          const SizedBox(height: 10),
          _SoftBar(
            progress: communityStage.progress,
            color: const Color(0xFF4A92AE),
          ),
          const SizedBox(height: 6),
          Text(
            nextStage == null
                ? 'The community has crossed the symbolic horizon of Ocean of Creation.'
                : '${CommunityOceanLogic.formatReadablePercentage(communityStage.progress)} of the way to ${nextStage.title}.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Text(
            'Final benchmark',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _SoftBar(
            progress: benchmarkProgress,
            color: const Color(0xFF6AB3C7),
          ),
          const SizedBox(height: 6),
          Text(
            '${CommunityOceanLogic.formatReadablePercentage(benchmarkProgress)} toward Ocean of Creation.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class PersonalContributionCard extends StatelessWidget {
  const PersonalContributionCard({
    super.key,
    required this.personal,
    required this.community,
    required this.communityStage,
    required this.contributionPercent,
  });

  final PersonalWaterStats personal;
  final CommunityOceanStats community;
  final StageProgress<CommunityOceanStage> communityStage;
  final String contributionPercent;

  @override
  Widget build(BuildContext context) {
    final personalWater = CommunityOceanLogic.convertDropsToReadableWater(
      personal.totalPersonalDrops,
    );
    final nextTarget = communityStage.nextThreshold ?? communityStage.currentStage.requiredDrops;
    final towardNext = CommunityOceanLogic.formatContributionPercent(
      contribution: personal.totalPersonalDrops,
      total: nextTarget,
    );

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your contribution',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'You added ${personal.personalDropsToday} drops today. Your lifetime contribution is ${CommunityOceanLogic.formatLargeDropCount(personal.totalPersonalDrops)} drops.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatCard(label: 'Lifetime', value: '${personal.totalPersonalDrops}'),
              _StatCard(label: 'Today', value: '${personal.personalDropsToday}'),
              _StatCard(label: 'Water', value: personalWater.shortLabel),
              _StatCard(label: 'Of community', value: contributionPercent),
              _StatCard(label: 'Toward next stage', value: towardNext),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            community.totalCommunityDrops > BigInt.zero
                ? 'Your drops help move the community forward without needing to be loud to matter.'
                : 'Your first drops will help begin the visible gathering.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class PersonalWaterPathCard extends StatelessWidget {
  const PersonalWaterPathCard({
    super.key,
    required this.personal,
    required this.personalStage,
  });

  final PersonalWaterStats personal;
  final StageProgress<PersonalWaterStage> personalStage;

  @override
  Widget build(BuildContext context) {
    final nextStage = personalStage.nextStage;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal water path',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'An intimate view of your own gathering water.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE6F0F4), Color(0xFFF4F7F8)],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        personalStage.currentStage.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        personalStage.currentStage.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _PersonalPathGlyph(progress: personalStage.progress),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SoftBar(
            progress: personalStage.progress,
            color: const Color(0xFF568D9D),
          ),
          const SizedBox(height: 8),
          Text(
            nextStage == null
                ? 'Your path has reached Flowing Water and can continue deepening.'
                : '${CommunityOceanLogic.formatLargeDropCount(personal.totalPersonalDrops)} drops gathered. ${personalStage.dropsRemainingToNext} remain until ${nextStage.title}.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class WaterEquivalentCard extends StatelessWidget {
  const WaterEquivalentCard({
    super.key,
    required this.personal,
    required this.community,
    required this.communityStage,
  });

  final PersonalWaterStats personal;
  final CommunityOceanStats community;
  final StageProgress<CommunityOceanStage> communityStage;

  @override
  Widget build(BuildContext context) {
    final personalWater = CommunityOceanLogic.convertDropsToReadableWater(
      personal.totalPersonalDrops,
    );
    final communityWater = CommunityOceanLogic.convertDropsToReadableWater(
      community.totalCommunityDrops,
    );
    final remainingWater = CommunityOceanLogic.convertDropsToReadableWater(
      communityStage.dropsRemainingToNext,
    );
    final remainingToBenchmark =
        CommunityOceanLogic.oceanOfCreationBenchmark -
            community.totalCommunityDrops;
    final oceanRemainingWater = CommunityOceanLogic.convertDropsToReadableWater(
      remainingToBenchmark > BigInt.zero ? remainingToBenchmark : BigInt.zero,
    );

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real water scale',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _KeyValueRow(
            label: 'Your drops',
            value: personalWater.fullLabel,
          ),
          _KeyValueRow(
            label: 'Community waters',
            value: communityWater.fullLabel,
          ),
          _KeyValueRow(
            label: 'Remaining to next stage',
            value: remainingWater.fullLabel,
          ),
          _KeyValueRow(
            label: 'Remaining to Ocean of Creation',
            value: oceanRemainingWater.fullLabel,
          ),
        ],
      ),
    );
  }
}

class CommunityStageLadder extends StatelessWidget {
  const CommunityStageLadder({
    super.key,
    required this.communityStage,
    required this.personalStage,
  });

  final StageProgress<CommunityOceanStage> communityStage;
  final StageProgress<PersonalWaterStage> personalStage;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Milestone explorer',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          ...communityOceanStages.map(
            (stage) => _StageTile<CommunityOceanStage>(
              title: stage.title,
              description: stage.description,
              requiredDrops: stage.requiredDrops,
              isCurrent: stage.id == communityStage.currentStage.id,
              isReached:
                  communityStage.currentDrops >= stage.requiredDrops,
              onTap: () => _showStageSheet<CommunityOceanStage>(
                context,
                title: stage.title,
                description: stage.description,
                requiredDrops: stage.requiredDrops,
                currentDrops: communityStage.currentDrops,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your path',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: personalWaterStages.map((stage) {
              final reached = personalStage.currentDrops >= stage.requiredDrops;
              final isCurrent = stage.id == personalStage.currentStage.id;
              return GestureDetector(
                onTap: () => _showStageSheet<PersonalWaterStage>(
                  context,
                  title: stage.title,
                  description: stage.description,
                  requiredDrops: stage.requiredDrops,
                  currentDrops: personalStage.currentDrops,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: isCurrent
                        ? const Color(0xFFDDEEF3)
                        : reached
                            ? const Color(0xFFEAF4EE)
                            : const Color(0xFFF5F1E8),
                  ),
                  child: Text(
                    stage.title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight:
                              isCurrent ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showStageSheet<T>(
    BuildContext context, {
    required String title,
    required String description,
    required BigInt requiredDrops,
    required BigInt currentDrops,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final remaining = requiredDrops > currentDrops
            ? requiredDrops - currentDrops
            : BigInt.zero;
        final water = CommunityOceanLogic.convertDropsToReadableWater(
          requiredDrops,
        );
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PremiumCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  _KeyValueRow(
                    label: 'Required drops',
                    value:
                        '${CommunityOceanLogic.formatLargeDropCount(requiredDrops)} ($requiredDrops)',
                  ),
                  _KeyValueRow(
                    label: 'Water equivalent',
                    value: water.fullLabel,
                  ),
                  _KeyValueRow(
                    label: 'Current progress',
                    value: remaining == BigInt.zero
                        ? 'Reached'
                        : '${CommunityOceanLogic.formatLargeDropCount(remaining)} drops remain',
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

class ReflectionFooter extends StatelessWidget {
  const ReflectionFooter({super.key, required this.reflection});

  final String reflection;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Center(
        child: Text(
          reflection,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _SourceEchoCard extends StatelessWidget {
  const _SourceEchoCard({required this.sourceTotals});

  final Map<String, int> sourceTotals;

  @override
  Widget build(BuildContext context) {
    final entries = sourceTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where drops have come from',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          if (entries.isEmpty)
            Text(
              'As you pray, learn, reflect, and remember, each area will begin to leave a trace here.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            ...entries.take(6).map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(_sourceLabel(entry.key))),
                    Text('+${entry.value}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _sourceLabel(String source) {
    switch (source) {
      case oceanSourcePrayer:
        return 'Prayer';
      case oceanSourceDhikr:
        return 'Dhikr';
      case oceanSourceQuran:
        return 'Qur’an';
      case oceanSourceLearn:
        return 'Learning';
      case oceanSourceQuiz:
        return 'Quizzes';
      case oceanSourceHabits:
        return 'Habits';
      case oceanSourceSalahTrainer:
        return 'Salah trainer';
      case oceanSourceDua:
        return 'Dua';
      case oceanSourceNotes:
        return 'Reflections';
      case oceanSourceGrowth:
        return 'Growth';
      default:
        return source;
    }
  }
}

class _HeroMetricChip extends StatelessWidget {
  const _HeroMetricChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 98),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF4F7F7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _StageTile<T> extends StatelessWidget {
  const _StageTile({
    required this.title,
    required this.description,
    required this.requiredDrops,
    required this.isCurrent,
    required this.isReached,
    required this.onTap,
  });

  final String title;
  final String description;
  final BigInt requiredDrops;
  final bool isCurrent;
  final bool isReached;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = isCurrent
        ? const Color(0xFFDCEEF3)
        : isReached
            ? const Color(0xFFEAF4EE)
            : const Color(0xFFF7F3EB);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: background,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CommunityOceanLogic.formatLargeDropCount(requiredDrops),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCurrent
                        ? 'Current'
                        : isReached
                            ? 'Reached'
                            : 'Ahead',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftBar extends StatelessWidget {
  const _SoftBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: 10,
        backgroundColor: color.withValues(alpha: 0.14),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _PersonalPathGlyph extends StatelessWidget {
  const _PersonalPathGlyph({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 86,
      child: CustomPaint(
        painter: _PersonalPathPainter(progress: progress.clamp(0.03, 1)),
      ),
    );
  }
}

class _PersonalPathPainter extends CustomPainter {
  const _PersonalPathPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFFB8D9E4), Color(0xFF4A8FA5)],
      ).createShader(rect);
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = const Color(0x1F4A8FA5);

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.76)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.34,
        size.width * 0.52,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.68,
        size.height * 0.68,
        size.width * 0.86,
        size.height * 0.24,
      );

    canvas.drawPath(path, basePaint);
    final metric = path.computeMetrics().first;
    final partial = metric.extractPath(0, metric.length * progress);
    canvas.drawPath(partial, pathPaint);
  }

  @override
  bool shouldRepaint(covariant _PersonalPathPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _CommunityOceanPainter extends CustomPainter {
  const _CommunityOceanPainter({
    required this.depth,
    required this.shimmer,
  });

  final double depth;
  final double shimmer;

  @override
  void paint(Canvas canvas, Size size) {
    final skyRect = Offset.zero & size;
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE8F4F7), Color(0xFFD4E7EA), Color(0xFFC5DDE2)],
      ).createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    final sunPaint = Paint()..color = Colors.white.withValues(alpha: 0.22);
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.2),
      24 + (18 * shimmer),
      sunPaint,
    );

    final horizonY = size.height * (0.62 - (depth * 0.12));
    final shorelinePaint = Paint()
      ..color = const Color(0xFFD8D0C2)
      ..style = PaintingStyle.fill;
    final shoreline = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, horizonY + 40)
      ..quadraticBezierTo(
        size.width * 0.18,
        horizonY + 12,
        size.width * 0.36,
        horizonY + 26,
      )
      ..quadraticBezierTo(
        size.width * 0.68,
        horizonY + 44,
        size.width,
        horizonY + 14,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(shoreline, shorelinePaint);

    final waterTop = horizonY;
    final waveHeight = 10 + (depth * 18);
    final waterPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, waterTop)
      ..quadraticBezierTo(
        size.width * 0.2,
        waterTop - waveHeight,
        size.width * 0.4,
        waterTop - waveHeight * 0.35,
      )
      ..quadraticBezierTo(
        size.width * 0.66,
        waterTop + waveHeight * 0.4,
        size.width,
        waterTop - waveHeight * 0.2,
      )
      ..lineTo(size.width, size.height)
      ..close();

    final waterPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF74B6CA).withValues(alpha: 0.74),
          const Color(0xFF3B7C98).withValues(alpha: 0.88),
          const Color(0xFF1E4F66),
        ],
      ).createShader(
        Rect.fromLTWH(0, waterTop - 30, size.width, size.height - waterTop + 30),
      );
    canvas.drawPath(waterPath, waterPaint);

    final shimmerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..color = Colors.white.withValues(alpha: 0.12 + (shimmer * 0.1));
    for (var i = 0; i < 5; i += 1) {
      final y = waterTop + 22 + (i * 22);
      final startX = size.width * (0.12 + (i * 0.04));
      final endX = size.width * (0.84 - (i * 0.05));
      canvas.drawArc(
        Rect.fromPoints(Offset(startX, y), Offset(endX, y + 16)),
        math.pi,
        math.pi,
        false,
        shimmerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CommunityOceanPainter oldDelegate) {
    return oldDelegate.depth != depth || oldDelegate.shimmer != shimmer;
  }
}
