import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/state/user_profile_state.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/community_ocean.dart';
import '../application/ocean_drops_provider.dart';
import '../../../core/theme/app_icons.dart';

class OceanDropsPage extends ConsumerWidget {
  const OceanDropsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final profile = ref.watch(userProfileProvider);
    final personal = ref.watch(personalWaterStatsProvider);
    final community = ref.watch(communityOceanStatsProvider);
    final personalStage = ref.watch(personalWaterStageProgressProvider);
    final communityStage = ref.watch(communityOceanStageProgressProvider);
    final sourceTotals = _sourceTotals(ref.watch(oceanDropsProvider).events);
    final contributionPercent =
        CommunityOceanLogic.formatContributionPercentForLocale(
          contribution: personal.totalPersonalDrops,
          total: community.totalCommunityDrops,
          locale: locale,
        );
    final benchmarkProgress = CommunityOceanLogic.oceanBenchmarkProgress(
      community.totalCommunityDrops,
    );

    return AppPageScaffold(
      headerIcon: AppIcons.drops,
      title: l10n.oceanCommunityTitle,
      subtitle: l10n.oceanCommunitySubtitle,
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
        PersonalWaterPathCard(personal: personal, personalStage: personalStage),
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
            context,
            personalStage.currentStage.id,
            communityStage.currentStage.id,
          ),
        ),
      ],
    );
  }

  Map<String, int> _sourceTotals(List<OceanDropEvent> events) {
    final totals = <String, int>{};
    for (final event in events) {
      totals[event.sourceModule] =
          (totals[event.sourceModule] ?? 0) + event.amount;
    }
    return totals;
  }

  String _reflectionFor(
    BuildContext context,
    String personalStageId,
    String communityStageId,
  ) {
    final l10n = AppLocalizations.of(context);
    final seed =
        (personalStageId.length + communityStageId.length) %
        communityOceanReflectionLines.length;
    final lines = <String>[
      l10n.oceanReflectionLine1,
      l10n.oceanReflectionLine2,
      l10n.oceanReflectionLine3,
      l10n.oceanReflectionLine4,
    ];
    return lines[seed];
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
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
                l10n.oceanHeroGreeting(name),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.oceanHeroSubtitle,
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
                    label: l10n.oceanMetricCommunityStage,
                    value: _communityStageTitle(
                      context,
                      communityStage.currentStage.id,
                    ),
                    icon: Icons.waves_rounded,
                  ),
                  _HeroMetricChip(
                    label: l10n.oceanMetricYourWaterPath,
                    value: _personalStageTitle(
                      context,
                      personalStage.currentStage.id,
                    ),
                    icon: Icons.waterfall_chart_rounded,
                  ),
                  _HeroMetricChip(
                    label: l10n.oceanMetricDropsToday,
                    value: NumberFormat.decimalPattern(
                      locale,
                    ).format(personal.personalDropsToday),
                    icon: AppIcons.drops,
                  ),
                  _HeroMetricChip(
                    label: l10n.oceanMetricCommunityTotal,
                    value: CommunityOceanLogic.formatLargeDropCountForLocale(
                      community.totalCommunityDrops,
                      locale,
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
    final l10n = AppLocalizations.of(context);
    final stageIndex = communityOceanStages.indexOf(
      communityStage.currentStage,
    );
    final visualDepth =
        (stageIndex + communityStage.progress) / communityOceanStages.length;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.oceanSharedWatersTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            communityStage.hasReachedCurrentStage
                ? l10n.oceanSharedWatersFlowingIn(
                    _communityStageTitle(
                      context,
                      communityStage.currentStage.id,
                    ).toLowerCase(),
                  )
                : l10n.oceanSharedWatersMovingToward(
                    _communityStageTitle(
                      context,
                      communityStage.currentStage.id,
                    ),
                  ),
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
                colors: [
                  Color(0xFFE7F2F4),
                  Color(0xFFD6E7EA),
                  Color(0xFFB3CCD5),
                ],
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final nextStage = communityStage.nextStage;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.oceanCommunityStageProgressTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _KeyValueRow(
            label: l10n.oceanCurrentStageLabel,
            value: communityStage.hasReachedCurrentStage
                ? _communityStageTitle(context, communityStage.currentStage.id)
                : l10n.oceanGatheringToward(
                    _communityStageTitle(
                      context,
                      communityStage.currentStage.id,
                    ),
                  ),
          ),
          _KeyValueRow(
            label: l10n.oceanTotalCommunityDropsLabel,
            value: l10n.oceanLargeAndExactDropCount(
              CommunityOceanLogic.formatLargeDropCountForLocale(
                community.totalCommunityDrops,
                locale,
              ),
              _formatBigInt(locale, community.totalCommunityDrops),
            ),
          ),
          _KeyValueRow(
            label: l10n.oceanNextStageLabel,
            value: nextStage == null
                ? l10n.oceanOceanOfCreationReached
                : _communityStageTitle(context, nextStage.id),
          ),
          _KeyValueRow(
            label: l10n.oceanRemainingLabel,
            value: nextStage == null
                ? l10n.oceanNone
                : l10n.oceanReadableStageDistance(
                    CommunityOceanLogic.formatLargeDropCountForLocale(
                      communityStage.dropsRemainingToNext,
                      locale,
                    ),
                    CommunityOceanLogic.convertDropsToReadableWater(
                      communityStage.dropsRemainingToNext,
                    ).shortLabel,
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
                ? l10n.oceanCrossedOceanOfCreation
                : l10n.oceanProgressTowardStage(
                    CommunityOceanLogic.formatReadablePercentageForLocale(
                      communityStage.progress,
                      locale,
                    ),
                    _communityStageTitle(context, nextStage.id),
                  ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Text(
            l10n.oceanFinalBenchmarkTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _SoftBar(progress: benchmarkProgress, color: const Color(0xFF6AB3C7)),
          const SizedBox(height: 6),
          Text(
            l10n.oceanBenchmarkTowardCreation(
              CommunityOceanLogic.formatReadablePercentageForLocale(
                benchmarkProgress,
                locale,
              ),
            ),
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final personalWater = CommunityOceanLogic.convertDropsToReadableWater(
      personal.totalPersonalDrops,
    );
    final nextTarget =
        communityStage.nextThreshold ??
        communityStage.currentStage.requiredDrops;
    final towardNext = CommunityOceanLogic.formatContributionPercentForLocale(
      contribution: personal.totalPersonalDrops,
      total: nextTarget,
      locale: locale,
    );

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.oceanYourContributionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.oceanContributionSummary(
              NumberFormat.decimalPattern(
                locale,
              ).format(personal.personalDropsToday),
              CommunityOceanLogic.formatLargeDropCountForLocale(
                personal.totalPersonalDrops,
                locale,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatCard(
                label: l10n.oceanStatLifetime,
                value: _formatBigInt(locale, personal.totalPersonalDrops),
              ),
              _StatCard(
                label: l10n.oceanStatToday,
                value: NumberFormat.decimalPattern(
                  locale,
                ).format(personal.personalDropsToday),
              ),
              _StatCard(
                label: l10n.oceanStatWater,
                value: personalWater.shortLabel,
              ),
              _StatCard(
                label: l10n.oceanStatOfCommunity,
                value: contributionPercent,
              ),
              _StatCard(
                label: l10n.oceanStatTowardNextStage,
                value: towardNext,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            community.totalCommunityDrops > BigInt.zero
                ? l10n.oceanContributionQuietNote
                : l10n.oceanContributionFirstDropsNote,
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final nextStage = personalStage.nextStage;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.oceanPersonalWaterPathTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.oceanPersonalWaterPathSubtitle,
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
                        _personalStageTitle(
                          context,
                          personalStage.currentStage.id,
                        ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _personalStageDescription(
                          context,
                          personalStage.currentStage.id,
                        ),
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
                ? l10n.oceanPersonalPathComplete
                : l10n.oceanPersonalPathRemaining(
                    CommunityOceanLogic.formatLargeDropCountForLocale(
                      personal.totalPersonalDrops,
                      locale,
                    ),
                    _formatBigInt(locale, personalStage.dropsRemainingToNext),
                    _personalStageTitle(context, nextStage.id),
                  ),
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
    final l10n = AppLocalizations.of(context);
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
            l10n.oceanRealWaterScaleTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          _KeyValueRow(
            label: l10n.oceanWaterYourDropsLabel,
            value: personalWater.fullLabel,
          ),
          _KeyValueRow(
            label: l10n.oceanWaterCommunityWatersLabel,
            value: communityWater.fullLabel,
          ),
          _KeyValueRow(
            label: l10n.oceanWaterRemainingToNextStageLabel,
            value: remainingWater.fullLabel,
          ),
          _KeyValueRow(
            label: l10n.oceanWaterRemainingToCreationLabel,
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
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.oceanMilestoneExplorerTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          ...communityOceanStages.map(
            (stage) => _StageTile<CommunityOceanStage>(
              title: _communityStageTitle(context, stage.id),
              description: _communityStageDescription(context, stage.id),
              requiredDrops: stage.requiredDrops,
              isCurrent: stage.id == communityStage.currentStage.id,
              isReached: communityStage.currentDrops >= stage.requiredDrops,
              onTap: () => _showStageSheet<CommunityOceanStage>(
                context,
                title: _communityStageTitle(context, stage.id),
                description: _communityStageDescription(context, stage.id),
                requiredDrops: stage.requiredDrops,
                currentDrops: communityStage.currentDrops,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.oceanYourPathTitle,
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
                  title: _personalStageTitle(context, stage.id),
                  description: _personalStageDescription(context, stage.id),
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
                    _personalStageTitle(context, stage.id),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
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
        final l10n = AppLocalizations.of(context);
        final locale = Localizations.localeOf(context).toLanguageTag();
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
                    label: l10n.oceanRequiredDropsLabel,
                    value: l10n.oceanLargeAndExactDropCount(
                      CommunityOceanLogic.formatLargeDropCountForLocale(
                        requiredDrops,
                        locale,
                      ),
                      _formatBigInt(locale, requiredDrops),
                    ),
                  ),
                  _KeyValueRow(
                    label: l10n.oceanWaterEquivalentLabel,
                    value: water.fullLabel,
                  ),
                  _KeyValueRow(
                    label: l10n.oceanCurrentProgressLabel,
                    value: remaining == BigInt.zero
                        ? l10n.oceanStageReached
                        : l10n.oceanDropsRemain(
                            CommunityOceanLogic.formatLargeDropCountForLocale(
                              remaining,
                              locale,
                            ),
                          ),
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
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final entries = sourceTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.oceanSourceEchoTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          if (entries.isEmpty)
            Text(
              l10n.oceanSourceEchoEmpty,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            ...entries
                .take(6)
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(_sourceLabel(context, entry.key))),
                        Text(
                          l10n.oceanDropsAdded(
                            NumberFormat.decimalPattern(
                              locale,
                            ).format(entry.value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  String _sourceLabel(BuildContext context, String source) {
    final l10n = AppLocalizations.of(context);
    switch (source) {
      case oceanSourcePrayer:
        return l10n.oceanSourcePrayer;
      case oceanSourceDhikr:
        return l10n.oceanSourceDhikr;
      case oceanSourceQuran:
        return l10n.oceanSourceQuran;
      case oceanSourceLearn:
        return l10n.oceanSourceLearning;
      case oceanSourceQuiz:
        return l10n.oceanSourceQuizzes;
      case oceanSourceHabits:
        return l10n.oceanSourceHabits;
      case oceanSourceSalahTrainer:
        return l10n.oceanSourceSalahTrainer;
      case oceanSourceDua:
        return l10n.oceanSourceDua;
      case oceanSourceNotes:
        return l10n.oceanSourceReflections;
      case oceanSourceGrowth:
        return l10n.oceanSourceGrowth;
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
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
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
                    CommunityOceanLogic.formatLargeDropCountForLocale(
                      requiredDrops,
                      locale,
                    ),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCurrent
                        ? l10n.oceanStageCurrent
                        : isReached
                        ? l10n.oceanStageReached
                        : l10n.oceanStageAhead,
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
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatBigInt(String locale, BigInt value) {
  return NumberFormat.decimalPattern(
    locale,
  ).format(int.tryParse(value.toString()) ?? double.parse(value.toString()));
}

String _communityStageTitle(BuildContext context, String id) {
  final l10n = AppLocalizations.of(context);
  switch (id) {
    case 'spring':
      return l10n.oceanCommunityStageSpringTitle;
    case 'stream':
      return l10n.oceanCommunityStageStreamTitle;
    case 'pond':
      return l10n.oceanCommunityStagePondTitle;
    case 'lake':
      return l10n.oceanCommunityStageLakeTitle;
    case 'great_lake':
      return l10n.oceanCommunityStageGreatLakeTitle;
    case 'inland_sea':
      return l10n.oceanCommunityStageInlandSeaTitle;
    case 'great_waters':
      return l10n.oceanCommunityStageGreatWatersTitle;
    case 'ocean_of_creation':
      return l10n.oceanCommunityStageOceanOfCreationTitle;
    default:
      return id;
  }
}

String _communityStageDescription(BuildContext context, String id) {
  final l10n = AppLocalizations.of(context);
  switch (id) {
    case 'spring':
      return l10n.oceanCommunityStageSpringDescription;
    case 'stream':
      return l10n.oceanCommunityStageStreamDescription;
    case 'pond':
      return l10n.oceanCommunityStagePondDescription;
    case 'lake':
      return l10n.oceanCommunityStageLakeDescription;
    case 'great_lake':
      return l10n.oceanCommunityStageGreatLakeDescription;
    case 'inland_sea':
      return l10n.oceanCommunityStageInlandSeaDescription;
    case 'great_waters':
      return l10n.oceanCommunityStageGreatWatersDescription;
    case 'ocean_of_creation':
      return l10n.oceanCommunityStageOceanOfCreationDescription;
    default:
      return id;
  }
}

String _personalStageTitle(BuildContext context, String id) {
  final l10n = AppLocalizations.of(context);
  switch (id) {
    case 'drop':
      return l10n.oceanPersonalStageDropTitle;
    case 'ripple':
      return l10n.oceanPersonalStageRippleTitle;
    case 'spring':
      return l10n.oceanPersonalStageSpringTitle;
    case 'stream':
      return l10n.oceanPersonalStageStreamTitle;
    case 'brook':
      return l10n.oceanPersonalStageBrookTitle;
    case 'pond':
      return l10n.oceanPersonalStagePondTitle;
    case 'quiet_lake':
      return l10n.oceanPersonalStageQuietLakeTitle;
    case 'flowing_water':
      return l10n.oceanPersonalStageFlowingWaterTitle;
    default:
      return id;
  }
}

String _personalStageDescription(BuildContext context, String id) {
  final l10n = AppLocalizations.of(context);
  switch (id) {
    case 'drop':
      return l10n.oceanPersonalStageDropDescription;
    case 'ripple':
      return l10n.oceanPersonalStageRippleDescription;
    case 'spring':
      return l10n.oceanPersonalStageSpringDescription;
    case 'stream':
      return l10n.oceanPersonalStageStreamDescription;
    case 'brook':
      return l10n.oceanPersonalStageBrookDescription;
    case 'pond':
      return l10n.oceanPersonalStagePondDescription;
    case 'quiet_lake':
      return l10n.oceanPersonalStageQuietLakeDescription;
    case 'flowing_water':
      return l10n.oceanPersonalStageFlowingWaterDescription;
    default:
      return id;
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
  const _CommunityOceanPainter({required this.depth, required this.shimmer});

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
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF74B6CA).withValues(alpha: 0.74),
              const Color(0xFF3B7C98).withValues(alpha: 0.88),
              const Color(0xFF1E4F66),
            ],
          ).createShader(
            Rect.fromLTWH(
              0,
              waterTop - 30,
              size.width,
              size.height - waterTop + 30,
            ),
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
