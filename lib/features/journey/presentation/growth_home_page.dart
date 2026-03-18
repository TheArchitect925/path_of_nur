import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'growth_habits_page.dart';
import 'growth_journey_page.dart';
import 'growth_paths_page.dart';
import 'growth_reflection_page.dart';
import 'growth_today_page.dart';
import 'widgets/growth_segmented_control.dart';

class GrowthHomePage extends ConsumerWidget {
  const GrowthHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tab = ref.watch(growthInternalTabProvider);
    final growthVisual = ref.watch(growthGardenProgressProvider);
    final nextUnlock = ref.watch(growthNextUnlockPreviewProvider);
    final unlocked = ref.watch(growthUnlockedRewardsProvider);
    final trackedHabits = ref.watch(
      growthAllHabitsProvider.select(
        (habits) => habits
            .where(
              (habit) =>
                  habit.active &&
                  habit.showInToday &&
                  !habit.hidden &&
                  !habit.archived,
            )
            .length,
      ),
    );
    final privateMode = ref.watch(growthControllerProvider).privateMode;
    ref.watch(growthControllerProvider);
    ref.read(growthControllerProvider.notifier).refreshDailySchedules();
    final countFormat = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final islandCards = <_JourneyIslandCardData>[
      _JourneyIslandCardData(
        tab: GrowthInternalTab.today,
        title: l10n.growthTabToday,
        subtitle: l10n.growthHomeTodaySubtitle,
        icon: Icons.today_rounded,
        color: Color(0xFFE8E0CF),
        accent: Color(0xFF7A6241),
      ),
      _JourneyIslandCardData(
        tab: GrowthInternalTab.paths,
        title: l10n.growthTabPaths,
        subtitle: l10n.growthHomePathsSubtitle,
        icon: Icons.alt_route_rounded,
        color: Color(0xFFE4ECD9),
        accent: Color(0xFF597045),
      ),
      _JourneyIslandCardData(
        tab: GrowthInternalTab.habits,
        title: l10n.growthTabHabits,
        subtitle: l10n.growthHomeHabitsSubtitle,
        icon: Icons.checklist_rtl_rounded,
        color: Color(0xFFF0E2D6),
        accent: Color(0xFF8D6143),
      ),
      _JourneyIslandCardData(
        tab: GrowthInternalTab.journey,
        title: l10n.growthTabJourney,
        subtitle: l10n.growthHomeJourneySubtitle,
        icon: Icons.route_rounded,
        color: Color(0xFFE2E5F3),
        accent: Color(0xFF545E8D),
      ),
      _JourneyIslandCardData(
        tab: GrowthInternalTab.reflection,
        title: l10n.growthTabReflection,
        subtitle: l10n.growthHomeReflectionSubtitle,
        icon: Icons.auto_stories_rounded,
        color: Color(0xFFEADFEB),
        accent: Color(0xFF7D5D81),
      ),
    ];

    return AppPageScaffold(
      headerIcon: IslamicIcons.tasbih,
      title: l10n.journeyTitle,
      subtitle: l10n.growthHomeHeaderSubtitle,
      quote: const QuranQuote(
        arabic: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
        transliteration: 'Wa qul rabbi zidni ilma',
        translation: 'My Lord, increase me in knowledge.',
        surah: 20,
        verse: 114,
        locationLabel: 'Qur’an 20:114',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EEE3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                privateMode
                    ? l10n.growthHomePrivateModeTitle
                    : l10n.growthHomePublicModeTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                '${growthVisual.currentStageLabel} · ${growthVisual.stageSubtitle}',
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: growthVisual.stageProgress,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                nextUnlock == null
                    ? l10n.growthHomeAllUnlocksPresent
                    : l10n.growthHomeNextUnlock(nextUnlock.title),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF6A5A4A),
                ),
              ),
              Text(
                privateMode
                    ? l10n.growthHomeSymbolicGiftsPresent(
                        countFormat.format(unlocked.length),
                      )
                    : l10n.growthHomeCalmGiftsPresent(
                        countFormat.format(unlocked.length),
                      ),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF6A5A4A),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => context.pushNamed('growthHabitsDeepLink'),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1E8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE0C9A6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D7B9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.checklist_rtl_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.growthHomeHabitTrackerTitle,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trackedHabits == 0
                            ? l10n.growthHomeNoHabitsSelected
                            : l10n.growthHomeHabitsSelected(trackedHabits),
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6A5A4A),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
        _JourneyHomeEntryGrid(
          cards: islandCards,
          selectedTab: tab,
          onSelectTab: (next) =>
              ref.read(growthInternalTabProvider.notifier).state = next,
        ),
        const SizedBox(height: 12),
        GrowthSegmentedControl(
          selected: tab,
          onChanged: (next) =>
              ref.read(growthInternalTabProvider.notifier).state = next,
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 230),
          child: Padding(
            key: ValueKey(tab),
            padding: const EdgeInsets.only(bottom: 16),
            child: switch (tab) {
              GrowthInternalTab.today => const GrowthTodayPage(),
              GrowthInternalTab.paths => const GrowthPathsPage(),
              GrowthInternalTab.habits => const GrowthHabitsPage(),
              GrowthInternalTab.journey => const GrowthJourneyPage(),
              GrowthInternalTab.reflection => const GrowthReflectionPage(),
            },
          ),
        ),
      ],
    );
  }
}

class _JourneyHomeEntryGrid extends StatelessWidget {
  const _JourneyHomeEntryGrid({
    required this.cards,
    required this.selectedTab,
    required this.onSelectTab,
  });

  final List<_JourneyIslandCardData> cards;
  final GrowthInternalTab selectedTab;
  final ValueChanged<GrowthInternalTab> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: cards
              .map(
                (card) => _JourneyIslandCard(
                  data: card,
                  selected: selectedTab == card.tab,
                  onTap: () => onSelectTab(card.tab),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _JourneyWideEntryCard(
                title: l10n.growthHomeBrowseAllTitle,
                subtitle: l10n.growthHomeBrowseAllSubtitle,
                icon: Icons.grid_view_rounded,
                color: const Color(0xFFF4ECDF),
                accent: const Color(0xFF7C684B),
                onTap: () => onSelectTab(GrowthInternalTab.paths),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _JourneyWideEntryCard(
                title: l10n.growthHomeLegacyLearningTitle,
                subtitle: l10n.growthHomeLegacyLearningSubtitle,
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFFE7E3D7),
                accent: const Color(0xFF5F5A4F),
                onTap: () => context.pushNamed('learnLegacy'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _JourneyIslandCard extends StatelessWidget {
  const _JourneyIslandCard({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _JourneyIslandCardData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 36 - 10) / 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? data.color.withValues(alpha: 0.98) : data.color,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? data.accent.withValues(alpha: 0.55)
                  : data.accent.withValues(alpha: 0.22),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: data.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: data.accent),
              ),
              const SizedBox(height: 12),
              Text(
                data.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: data.accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF685B4D),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyWideEntryCard extends StatelessWidget {
  const _JourneyWideEntryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accent),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w700, color: accent),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12.3,
                color: Color(0xFF685B4D),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyIslandCardData {
  const _JourneyIslandCardData({
    required this.tab,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.accent,
  });

  final GrowthInternalTab tab;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color accent;
}
