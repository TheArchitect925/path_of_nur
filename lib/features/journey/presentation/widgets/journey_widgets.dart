import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';

class JourneyHeroCard extends StatelessWidget {
  const JourneyHeroCard({
    super.key,
    required this.levelText,
    required this.xpText,
    required this.nextLevelText,
    required this.motivationText,
    required this.progress,
  });

  final String levelText;
  final String xpText;
  final String nextLevelText;
  final String motivationText;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MetricPill(
                icon: Icons.workspace_premium_outlined,
                label: levelText,
              ),
              const SizedBox(width: 8),
              _MetricPill(
                icon: Icons.bolt_outlined,
                label: xpText,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 8,
              backgroundColor: AppColors.surfaceSoft.withValues(alpha: 0.65),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.homeAccent),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            nextLevelText,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            motivationText,
            style: const TextStyle(color: AppColors.onSurfaceSubtle, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class JourneyLightProgressCard extends StatelessWidget {
  const JourneyLightProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.sectionId,
  });

  final String title;
  final String subtitle;
  final double progress;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: () => context.pushNamed(
          'featureSection',
          pathParameters: {'sectionId': sectionId},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Row(
              children: List.generate(
                12,
                (index) {
                  final activeCount = (progress * 12).round().clamp(0, 12);
                  final active = index < activeCount;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == 11 ? 0 : 4),
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: active
                            ? AppColors.homeAccent.withValues(alpha: 0.75)
                            : AppColors.surfaceSoft.withValues(alpha: 0.45),
                        border: Border.all(
                          color: active
                              ? AppColors.accentGoldSoft.withValues(alpha: 0.35)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.onSurfaceSubtle, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class JourneyDailyRingsCard extends StatelessWidget {
  const JourneyDailyRingsCard({
    super.key,
    required this.items,
    required this.sectionId,
  });

  final List<JourneyRingItem> items;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: () => context.pushNamed(
          'featureSection',
          pathParameters: {'sectionId': sectionId},
        ),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map(
                (item) => _RingPill(item: item),
              )
              .toList(),
        ),
      ),
    );
  }
}

class JourneyStreaksCard extends StatelessWidget {
  const JourneyStreaksCard({
    super.key,
    required this.currentTitle,
    required this.currentValue,
    required this.bestTitle,
    required this.bestValue,
    required this.weeklyLabel,
    required this.weekBars,
    required this.sectionId,
  });

  final String currentTitle;
  final String currentValue;
  final String bestTitle;
  final String bestValue;
  final String weeklyLabel;
  final List<double> weekBars;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: () => context.pushNamed(
          'featureSection',
          pathParameters: {'sectionId': sectionId},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _SmallValueCard(
                    title: currentTitle,
                    value: currentValue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SmallValueCard(
                    title: bestTitle,
                    value: bestValue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              weeklyLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceSubtle,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: weekBars
                  .map(
                    (value) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 8 + (value.clamp(0, 1) * 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.accentGold.withValues(alpha: 0.48),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class JourneyMilestonesCard extends StatelessWidget {
  const JourneyMilestonesCard({
    super.key,
    required this.entries,
    required this.sectionId,
  });

  final List<String> entries;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: () => context.pushNamed(
          'featureSection',
          pathParameters: {'sectionId': sectionId},
        ),
        child: Column(
          children: entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        size: 18,
                        color: AppColors.accentGoldSoft,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(entry)),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class JourneyUnlocksCard extends StatelessWidget {
  const JourneyUnlocksCard({
    super.key,
    required this.items,
    required this.sectionId,
  });

  final List<String> items;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: () => context.pushNamed(
          'featureSection',
          pathParameters: {'sectionId': sectionId},
        ),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.surfaceSoft.withValues(alpha: 0.42),
                    border: Border.all(
                      color: AppColors.accentGoldSoft.withValues(alpha: 0.42),
                    ),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class JourneyGrowthPreviewCard extends StatelessWidget {
  const JourneyGrowthPreviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sectionId,
  });

  final String title;
  final String subtitle;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: () => context.pushNamed(
          'featureSection',
          pathParameters: {'sectionId': sectionId},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.surfaceSoft.withValues(alpha: 0.38),
                border: Border.all(
                  color: AppColors.accentGoldSoft.withValues(alpha: 0.36),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _VisualNode(icon: Icons.park_outlined, label: 'Growth'),
                  _VisualNode(icon: Icons.account_circle_outlined, label: 'Character'),
                  _VisualNode(icon: Icons.emoji_nature_outlined, label: 'Progress'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.onSurfaceSubtle, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class JourneyOceanCard extends StatelessWidget {
  const JourneyOceanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sectionId,
  });

  final String title;
  final String subtitle;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: () => context.pushNamed(
          'featureSection',
          pathParameters: {'sectionId': sectionId},
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.homeAccent.withValues(alpha: 0.22),
              ),
              child: const Icon(Icons.water_drop_outlined, color: AppColors.accentGoldSoft),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.onSurfaceSubtle, height: 1.35),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceSubtle),
          ],
        ),
      ),
    );
  }
}

class JourneyRingItem {
  const JourneyRingItem({
    required this.label,
    required this.progress,
  });

  final String label;
  final double progress;
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surfaceSoft.withValues(alpha: 0.4),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.accentGoldSoft),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SmallValueCard extends StatelessWidget {
  const _SmallValueCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surfaceSoft.withValues(alpha: 0.4),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPill extends StatelessWidget {
  const _RingPill({required this.item});

  final JourneyRingItem item;

  @override
  Widget build(BuildContext context) {
    final int pct = (item.progress.clamp(0, 1) * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.4),
        ),
        color: AppColors.surfaceSoft.withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              value: item.progress.clamp(0, 1),
              strokeWidth: 2.2,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.homeAccent),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.label} $pct%',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _VisualNode extends StatelessWidget {
  const _VisualNode({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.accentGoldSoft, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceSubtle),
        ),
      ],
    );
  }
}
