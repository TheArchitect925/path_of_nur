import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../garden/application/garden_service.dart';
import '../../garden/presentation/widgets/garden_vista/garden_element_strings.dart';
import '../application/growth_garden.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import '../drops/application/journey_drops_providers.dart';
import '../drops/presentation/widgets/garden_cards.dart';
import '../xp/presentation/widgets/journey_xp_progress_card.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthJourneyPage extends ConsumerWidget {
  const GrowthJourneyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(growthJourneyStatsProvider);
    final activity = ref.watch(growthRecentActivityProvider);
    final privateMode = ref.watch(growthControllerProvider).privateMode;
    final growthVisual = ref.watch(growthGardenProgressProvider);
    final canonicalGarden = ref.watch(activeGardenStateProvider);
    final unlockedRewards = ref.watch(growthUnlockedRewardsProvider);
    final recentUnlocks = ref.watch(growthRecentUnlocksProvider);
    final nextUnlock = ref.watch(growthNextUnlockPreviewProvider);
    final gardenProgress = ref.watch(gardenProgressSummaryProvider);
    final nextGardenMilestone = ref.watch(nextGardenMilestoneProvider);
    final unlockedWallpapers = unlockedRewards
        .where((reward) => reward.type == GrowthUnlockableType.wallpaper)
        .toList();
    final unlockedThemes = unlockedRewards
        .where((reward) => reward.type == GrowthUnlockableType.visualTheme)
        .toList();
    final seasonal = ref.watch(growthSeasonalContextProvider);
    final seasonalCards = ref.watch(growthActiveSeasonalJourneyCardsProvider);
    final seasonalPrompts = ref.watch(growthSeasonalReflectionPromptsProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                privateMode
                    ? l10n.growthJourneyQuietProgressTitle
                    : l10n.growthJourneyOverviewTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              // Canonical stage + maturity from GardenService, so this card
              // and the Garden itself always name the same stage.
              Text(
                '${GardenElementStrings.stageTitle(l10n, canonicalGarden.currentVisualStage.stageId)} · '
                '${l10n.gardenPageMaturityValue('${canonicalGarden.maturityPercent}')}',
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: canonicalGarden.progressToNextStage,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                growthVisual.recentGrowthLine,
                style: TextStyle(
                  color: growthNoorSubtleTextColor(context),
                  fontSize: 12.5,
                ),
              ),
              if (growthVisual.nextStageLabel != null)
                Text(
                  l10n.growthJourneyNextStageValue(
                    growthVisual.nextStageLabel!,
                  ),
                  style: TextStyle(
                    color: growthNoorSubtleTextColor(context),
                    fontSize: 12.5,
                  ),
                ),
              if (nextUnlock != null)
                Text(
                  l10n.growthJourneyNextUnlockValue(nextUnlock.title),
                  style: TextStyle(
                    color: growthNoorSubtleTextColor(context),
                    fontSize: 12.5,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const JourneyXpProgressCard(),
        const SizedBox(height: 12),
        GardenEntryCard(
          summary: gardenProgress,
          nextMilestone: nextGardenMilestone,
          onTap: () => context.pushNamed('gardenPage'),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthJourneyUnlockablesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (unlockedRewards.isEmpty)
                Text(l10n.growthJourneyUnlocksAppear)
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
                          decoration: growthNoorPillDecoration(context),
                          child: Text(
                            l10n.growthJourneyUnlockTypeValue(
                              _unlockTypeLabel(unlock.type, l10n),
                              unlock.title,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 8),
              if (recentUnlocks.isNotEmpty) ...[
                Text(
                  l10n.growthJourneyRecentUnlocksTitle,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                ...recentUnlocks.map(
                  (event) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(event.reward.title),
                    subtitle: Text(
                      l10n.growthJourneyUnlockEventValue(
                        event.reward.subtitle,
                        _formatDate(event.unlockedAt, locale),
                      ),
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
              Text(
                l10n.growthJourneyUnlockedWallpapersTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (unlockedWallpapers.isEmpty)
                Text(l10n.growthJourneyWallpapersAppear)
              else
                ...unlockedWallpapers.map(
                  (wallpaper) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(wallpaper.title),
                    subtitle: Text(
                      wallpaper.hasRealAsset
                          ? wallpaper.subtitle
                          : l10n.growthJourneyPreviewPlaceholderReady(
                              wallpaper.subtitle,
                            ),
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
              Text(
                l10n.growthJourneyVisualThemesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (unlockedThemes.isEmpty)
                Text(l10n.growthJourneyThemesAppear)
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
                          decoration: growthNoorPillDecoration(context),
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
              Text(
                l10n.growthJourneySeasonalJourneysTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              if (seasonalCards.isEmpty)
                Text(l10n.growthJourneyNoSeasonalJourney)
              else ...[
                Text(
                  l10n.growthJourneyHijriDateValue(
                    countFormat.format(seasonal.hijriDate.day),
                    seasonal.hijriDate.monthName,
                    countFormat.format(seasonal.hijriDate.year),
                  ),
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6A5A4A),
                  ),
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
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF6A5A4A),
                    ),
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
              Text(
                l10n.growthJourneyMainJourneyTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (privateMode)
                Text(
                  l10n.growthJourneyPrivateModeSummary(
                    countFormat.format(stats.subtleLight),
                  ),
                )
              else
                Text(
                  l10n.growthJourneyLevelSummary(
                    countFormat.format(stats.level),
                    countFormat.format(stats.visibleLight),
                    countFormat.format(stats.nextLevelLightRemaining),
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                stats.encouragementLine,
                style: const TextStyle(
                  color: Color(0xFF6A5A4A),
                  fontSize: 12.5,
                ),
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
                  _Pill(
                    label: l10n.growthJourneySteadyDaysPill(
                      countFormat.format(stats.currentStreakDays),
                    ),
                  ),
                  _Pill(
                    label: l10n.growthJourneyBestSteadyRunPill(
                      countFormat.format(stats.bestStreakDays),
                    ),
                  ),
                  _Pill(
                    label: l10n.growthJourneyActsTendedPill(
                      countFormat.format(stats.totalCompletedActions),
                    ),
                  ),
                  _Pill(
                    label: l10n.growthJourneyGentleReturnDayPill(
                      stats.protectedDaysUsedThisWeek,
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
                l10n.growthJourneyWeeklySummaryTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthJourneyWeeklyRhythmSummary(
                  countFormat.format(
                    (stats.weeklySummary.averageCompletion * 100).round(),
                  ),
                  stats.weeklySummary.note,
                ),
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
                            color: const Color(
                              0xFFAF7B35,
                            ).withValues(alpha: 0.55),
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
              Text(
                l10n.growthJourneyMonthlySummaryTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthJourneyMonthlyRhythmSummary(
                  countFormat.format(stats.monthlySummary.strongDays),
                  countFormat.format(
                    (stats.monthlySummary.averageCompletion * 100).round(),
                  ),
                ),
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
              Text(
                l10n.growthJourneyCategoryConsistencyTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...GrowthHabitCategory.values.map((category) {
                final value = stats.categoryProgress[category] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(growthCategoryLocalizedLabel(category, l10n)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(value: value),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthJourneyPathProgressTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...stats.pathProgress.map(
                (path) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(path.path.title),
                  subtitle: Text(
                    l10n.growthJourneyPathProgressValue(
                      countFormat.format((path.progress * 100).round()),
                      path.recommendedNextStep,
                    ),
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
              Text(
                l10n.growthJourneyMilestonesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (stats.milestones.isEmpty)
                Text(l10n.growthJourneyMilestonesAppear)
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
              Text(
                l10n.growthJourneyRecentGrowthActivityTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...activity.map(
                (item) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    item.isReflection ? Icons.menu_book : Icons.check,
                  ),
                  title: Text(item.title),
                  subtitle: Text(
                    item.isEntrusted
                        ? l10n.growthJourneyEntrustedQuietly(item.subtitle)
                        : item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _unlockTypeLabel(GrowthUnlockableType type, AppLocalizations l10n) {
    switch (type) {
      case GrowthUnlockableType.wallpaper:
        return l10n.growthUnlockTypeWallpaper;
      case GrowthUnlockableType.gardenElement:
        return l10n.growthUnlockTypeVisual;
      case GrowthUnlockableType.visualTheme:
        return l10n.growthUnlockTypeTheme;
      case GrowthUnlockableType.reflectionPack:
        return l10n.growthUnlockTypeReflectionPack;
      case GrowthUnlockableType.milestoneTitle:
        return l10n.growthUnlockTypeMilestone;
      case GrowthUnlockableType.seasonal:
        return l10n.growthUnlockTypeSeasonal;
    }
  }

  String _formatDate(DateTime date, String locale) {
    return DateFormat.yMMMd(locale).format(date);
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
