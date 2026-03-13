import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/premium_card.dart';
import '../application/growth_garden.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthJourneyPage extends ConsumerWidget {
  const GrowthJourneyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(growthJourneyStatsProvider);
    final activity = ref.watch(growthRecentActivityProvider);
    final privateMode = ref.watch(growthControllerProvider).privateMode;
    final growthVisual = ref.watch(growthGardenProgressProvider);
    final unlockedRewards = ref.watch(growthUnlockedRewardsProvider);
    final recentUnlocks = ref.watch(growthRecentUnlocksProvider);
    final nextUnlock = ref.watch(growthNextUnlockPreviewProvider);
    final unlockedWallpapers = unlockedRewards
        .where((reward) => reward.type == GrowthUnlockableType.wallpaper)
        .toList();
    final unlockedThemes = unlockedRewards
        .where((reward) => reward.type == GrowthUnlockableType.visualTheme)
        .toList();
    final seasonal = ref.watch(growthSeasonalContextProvider);
    final seasonalCards = ref.watch(growthActiveSeasonalJourneyCardsProvider);
    final seasonalPrompts = ref.watch(growthSeasonalReflectionPromptsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                privateMode ? 'Quiet Progress' : 'Growth Overview',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                '${growthVisual.currentStageLabel} · ${growthVisual.stageSubtitle}',
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(value: growthVisual.stageProgress),
              ),
              const SizedBox(height: 8),
              Text(
                growthVisual.recentGrowthLine,
                style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12.5),
              ),
              if (growthVisual.nextStageLabel != null)
                Text(
                  'Next stage: ${growthVisual.nextStageLabel}',
                  style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12.5),
                ),
              if (nextUnlock != null)
                Text(
                  'Next unlock: ${nextUnlock.title}',
                  style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12.5),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Unlockables', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (unlockedRewards.isEmpty)
                const Text('Unlocks appear as your path grows.')
              else ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: unlockedRewards
                      .take(8)
                      .map(
                        (unlock) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EEE3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text('${_unlockTypeLabel(unlock.type)} · ${unlock.title}'),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 8),
              if (recentUnlocks.isNotEmpty) ...[
                const Text('Recent unlocks', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                ...recentUnlocks.map(
                  (event) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(event.reward.title),
                    subtitle: Text(
                      '${event.reward.subtitle} · ${_formatDate(event.unlockedAt)}',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Unlocked Wallpapers', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (unlockedWallpapers.isEmpty)
                const Text('Wallpapers appear quietly as your progress grows.')
              else
                ...unlockedWallpapers.map(
                  (wallpaper) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(wallpaper.title),
                    subtitle: Text(
                      wallpaper.hasRealAsset
                          ? wallpaper.subtitle
                          : '${wallpaper.subtitle} · preview placeholder ready',
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Visual Themes', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (unlockedThemes.isEmpty)
                const Text('Theme accents appear through steady consistency.')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: unlockedThemes
                      .map(
                        (theme) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EEE3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(theme.title),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Seasonal Journeys', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              if (seasonalCards.isEmpty)
                const Text('No seasonal journey is active. Keep walking your steady path.')
              else ...[
                Text(
                  '${seasonal.hijriDate.day} ${seasonal.hijriDate.monthName} ${seasonal.hijriDate.year} AH',
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A5A4A)),
                ),
                const SizedBox(height: 8),
                ...seasonalCards.map(
                  (card) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text('${card.icon} ${card.title}'),
                    subtitle: Text(card.subtitle),
                  ),
                ),
                if (seasonalPrompts.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    seasonalPrompts.first,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A5A4A)),
                  ),
                ],
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Journey', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (privateMode)
                Text(
                  'Private mode is on. Visible light remains quiet while your progress continues (${stats.subtleLight}).',
                )
              else
                Text(
                  'Level ${stats.level} · ${stats.visibleLight} visible light · ${stats.nextLevelLightRemaining} light to the next stage',
                ),
              const SizedBox(height: 6),
              Text(
                stats.encouragementLine,
                style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12.5),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(value: stats.levelProgress),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(label: 'Steady days ${stats.currentStreakDays}'),
                  _Pill(label: 'Best steady run ${stats.bestStreakDays}'),
                  _Pill(label: '${stats.totalCompletedActions} acts tended'),
                  _Pill(label: '${stats.protectedDaysUsedThisWeek} gentle return day'),
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
              const Text('Weekly summary', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                'Weekly rhythm ${(stats.weeklySummary.averageCompletion * 100).round()}% · ${stats.weeklySummary.note}',
              ),
              const SizedBox(height: 8),
              Row(
                children: stats.weeklyCompletionBars
                    .map(
                      (value) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 12 + (value * 30),
                          decoration: BoxDecoration(
                            color: const Color(0xFFAF7B35).withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Monthly summary', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                '${stats.monthlySummary.strongDays} rooted days · ${(stats.monthlySummary.averageCompletion * 100).round()}% monthly rhythm',
              ),
              const SizedBox(height: 4),
              Text(stats.monthlySummary.note),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: stats.monthlyConsistencyByDay.entries
                    .map(
                      (entry) => Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Color.lerp(
                            const Color(0xFFF4ECE0),
                            const Color(0xFFAF7B35),
                            entry.value,
                          ),
                        ),
                        child: Text(
                          '${entry.key}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Category consistency', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...GrowthHabitCategory.values.map(
                (category) {
                  final value = stats.categoryProgress[category] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(growthCategoryLabel(category)),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(value: value),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Path progress', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...stats.pathProgress.map(
                (path) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(path.path.title),
                  subtitle: Text(
                    '${(path.progress * 100).round()}% complete · ${path.recommendedNextStep}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(
                    'growthPathDetail',
                    pathParameters: {'pathId': path.path.id},
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Milestones', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (stats.milestones.isEmpty)
                const Text('Milestones will appear as your consistency builds.')
              else
                ...stats.milestoneDetails.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ${item.content.title}'),
                        Text(
                          item.content.subtitle,
                          style: const TextStyle(
                            color: Color(0xFF6A5A4A),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Recent growth activity', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...activity.map(
                (item) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(item.isReflection ? Icons.menu_book : Icons.check),
                  title: Text(item.title),
                  subtitle: Text(
                    item.isEntrusted
                        ? '${item.subtitle} · entrusted quietly'
                        : item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Growth Section (Legacy)', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'All previous Growth content is preserved intact and available here.',
              ),
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('growthLegacy'),
                child: const Text('Open Legacy Growth Content'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _unlockTypeLabel(GrowthUnlockableType type) {
    switch (type) {
      case GrowthUnlockableType.wallpaper:
        return 'Wallpaper';
      case GrowthUnlockableType.gardenElement:
        return 'Visual';
      case GrowthUnlockableType.visualTheme:
        return 'Theme';
      case GrowthUnlockableType.reflectionPack:
        return 'Reflection Pack';
      case GrowthUnlockableType.milestoneTitle:
        return 'Milestone';
      case GrowthUnlockableType.seasonal:
        return 'Seasonal';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EEE3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
