import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_title.dart';
import 'widgets/journey_widgets.dart';

class JourneyPage extends ConsumerWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(journeySummaryProvider);
    return AppPageScaffold(
      headerIcon: Icons.route_outlined,
      title: l10n.journeyTitle,
      subtitle: l10n.journeySubtitle,
      quote: const QuranQuote(
        arabic: 'وَتَوَكَّلْتُ عَلَى اللَّهِ فَسَيَهْدِينِي',
        transliteration: 'Wa tawakkaltu ' 'ala Allahi faya-hdeenee',
        translation: 'Trusting Allah brings steady guidance on every path.',
        surah: 3,
        verse: 159,
        locationLabel: 'Qur’an 3:159',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        SectionTitle(
          title: l10n.journeyLevelSectionTitle,
          subtitle: l10n.journeyLevelSectionSubtitle,
        ),
        JourneyHeroCard(
          levelText: '${l10n.levelLabel} ${summary.level}',
          xpText: '${summary.xp} XP',
          nextLevelText: '${summary.nextLevelXpRemaining} ${l10n.homeXpToNextLevel}',
          motivationText: l10n.journeyLevelMotivation,
          progress: summary.xpProgress,
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyLightSectionTitle,
          subtitle: l10n.journeyLightSectionSubtitle,
        ),
        JourneyLightProgressCard(
          title: l10n.journeyLightCardTitle,
          subtitle: l10n.journeyLightCardSubtitle,
          progress: ((summary.ringPrayer + summary.ringDhikr + summary.ringQuran) / 3)
              .clamp(0, 1),
          sectionId: 'journey-home',
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyRingsSectionTitle,
          subtitle: l10n.journeyRingsSectionSubtitle,
        ),
        JourneyDailyRingsCard(
          sectionId: 'journey-rings',
          items: [
            JourneyRingItem(label: l10n.journeyRingPrayer, progress: summary.ringPrayer),
            JourneyRingItem(label: l10n.journeyRingDhikr, progress: summary.ringDhikr),
            JourneyRingItem(label: l10n.journeyRingQuran, progress: summary.ringQuran),
            JourneyRingItem(
              label: l10n.journeyRingReflection,
              progress: summary.ringReflection,
            ),
            JourneyRingItem(label: l10n.journeyRingFasting, progress: summary.ringFasting),
          ],
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyStreakSectionTitle,
          subtitle: l10n.journeyStreakSectionSubtitle,
        ),
        JourneyStreaksCard(
          sectionId: 'journey-streak',
          currentTitle: l10n.journeyCurrentStreakLabel,
          currentValue: '${summary.currentStreakDays} ${l10n.homeDaysLabel}',
          bestTitle: l10n.journeyBestStreakLabel,
          bestValue: '${summary.bestStreakDays} ${l10n.homeDaysLabel}',
          weeklyLabel: l10n.journeyWeeklyConsistencyLabel,
          weekBars: summary.weeklyConsistencyBars,
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyMilestoneSectionTitle,
          subtitle: l10n.journeyMilestoneSectionSubtitle,
        ),
        JourneyMilestonesCard(
          sectionId: 'journey-milestones',
          entries: [
            l10n.journeyMilestoneFirst7Days,
            l10n.journeyMilestoneDhikr100,
            l10n.journeyMilestonePrayerWeek,
            l10n.journeyMilestoneLearningStreak,
          ],
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyUnlocksSectionTitle,
          subtitle: l10n.journeyUnlocksSectionSubtitle,
        ),
        JourneyUnlocksCard(
          sectionId: 'journey-unlocks',
          items: [
            _unlockLabel(l10n, summary.nextUnlockPreviewKey),
            l10n.journeyUnlockReflection,
            l10n.journeyUnlockTheme,
            l10n.journeyUnlockFuture,
          ],
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyGrowthSectionTitle,
          subtitle: l10n.journeyGrowthSectionSubtitle,
        ),
        JourneyGrowthPreviewCard(
          title: l10n.journeyGrowthCardTitle,
          subtitle: l10n.journeyGrowthCardSubtitle,
          sectionId: 'journey-garden',
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyOceanSectionTitle,
          subtitle: l10n.journeyOceanSectionSubtitle,
        ),
        JourneyOceanCard(
          title: l10n.journeyOceanCardTitle,
          subtitle: l10n.journeyOceanCardSubtitle,
          sectionId: 'journey-ocean',
        ),
      ],
    );
  }

  String _unlockLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'wallpaper':
        return l10n.journeyUnlockWallpaper;
      case 'reflection':
        return l10n.journeyUnlockReflection;
      case 'theme':
        return l10n.journeyUnlockTheme;
      default:
        return l10n.journeyUnlockFuture;
    }
  }
}
