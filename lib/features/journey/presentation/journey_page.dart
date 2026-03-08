import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_title.dart';
import 'widgets/journey_widgets.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          levelText: l10n.journeyLevelValue,
          xpText: l10n.journeyXpValue,
          nextLevelText: l10n.journeyNextLevelText,
          motivationText: l10n.journeyLevelMotivation,
          progress: 0.81,
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyLightSectionTitle,
          subtitle: l10n.journeyLightSectionSubtitle,
        ),
        JourneyLightProgressCard(
          title: l10n.journeyLightCardTitle,
          subtitle: l10n.journeyLightCardSubtitle,
          progress: 0.68,
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
            JourneyRingItem(label: l10n.journeyRingPrayer, progress: 0.64),
            JourneyRingItem(label: l10n.journeyRingDhikr, progress: 0.47),
            JourneyRingItem(label: l10n.journeyRingQuran, progress: 0.35),
            JourneyRingItem(label: l10n.journeyRingReflection, progress: 0.29),
            JourneyRingItem(label: l10n.journeyRingFasting, progress: 0.16),
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
          currentValue: l10n.journeyCurrentStreakValue,
          bestTitle: l10n.journeyBestStreakLabel,
          bestValue: l10n.journeyBestStreakValue,
          weeklyLabel: l10n.journeyWeeklyConsistencyLabel,
          weekBars: const [0.55, 0.72, 0.48, 0.9, 0.67, 0.4, 0.78],
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
            l10n.journeyUnlockWallpaper,
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
}
