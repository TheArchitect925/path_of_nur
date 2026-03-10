import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../features/wallpaper/application/wallpaper_provider.dart';
import '../../../features/learn/content/application/learn_progress_provider.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_title.dart';
import 'widgets/journey_widgets.dart';

class JourneyPage extends ConsumerStatefulWidget {
  const JourneyPage({super.key});

  @override
  ConsumerState<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends ConsumerState<JourneyPage> {
  static const _inPageSectionIds = {
    'journey-level',
    'journey-rings',
    'journey-milestones',
    'journey-garden',
    'journey-ocean',
  };

  late final Map<String, GlobalKey> _sectionKeys = {
    for (final id in _inPageSectionIds) id: GlobalKey(),
  };

  Future<void> _scrollToSection(String sectionId) async {
    final targetContext = _sectionKeys[sectionId]?.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(journeySummaryProvider);
    final ocean = ref.watch(oceanDropsProvider);
    final wallpaper = ref.watch(wallpaperRewardSummaryProvider);
    final learn = ref.watch(learnProgressSummaryProvider);
    final mode = ref.watch(specialModeProvider);
    final weeklyReview = ref.watch(weeklyReflectionReviewSummaryProvider);
    return AppPageScaffold(
      headerIcon: Icons.route_outlined,
      title: l10n.journeyTitle,
      subtitle: l10n.journeySubtitle,
      quote: const QuranQuote(
        arabic: 'وَتَوَكَّلْتُ عَلَى اللَّهِ فَسَيَهْدِينِي',
        transliteration:
            'Wa tawakkaltu '
            'ala Allahi faya-hdeenee',
        translation: 'Trusting Allah brings steady guidance on every path.',
        surah: 3,
        verse: 159,
        locationLabel: 'Qur’an 3:159',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        if (mode.isKids)
          PremiumCard(
            child: Text(
              l10n.kidsJourneyHint,
              style: const TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
            ),
          ),
        if (mode.isKids) const SizedBox(height: 14),
        const _JourneyModeCard(),
        const SizedBox(height: 14),
        _JourneyGlassHubs(
          l10n: l10n,
          onTap: (item) {
            if (item.scrollToSectionId != null) {
              _scrollToSection(item.scrollToSectionId!);
              return;
            }
            context.pushNamed(item.routeName);
          },
          items: [
            _JourneyHubItem(
              icon: Icons.eco_outlined,
              title: l10n.journeyGrowthSectionTitle,
              subtitle: l10n.journeyStreakSectionTitle,
              routeName: 'journey',
              scrollToSectionId: 'journey-garden',
            ),
            _JourneyHubItem(
              icon: Icons.autorenew_rounded,
              title: l10n.journeyRingsSectionTitle,
              subtitle: l10n.journeyRingsSectionSubtitle,
              routeName: 'journey',
              scrollToSectionId: 'journey-rings',
            ),
            _JourneyHubItem(
              icon: Icons.workspace_premium_outlined,
              title: l10n.journeyMilestoneSectionTitle,
              subtitle: l10n.journeyUnlocksSectionTitle,
              routeName: 'journey',
              scrollToSectionId: 'journey-milestones',
            ),
            _JourneyHubItem(
              icon: Icons.water_drop_outlined,
              title: l10n.journeyOceanSectionTitle,
              subtitle: l10n.oceanTitle,
              routeName: 'oceanDrops',
            ),
          ],
        ),
        const SizedBox(height: 16),
        KeyedSubtree(
          key: _sectionKeys['journey-level'],
          child: SectionTitle(
            title: l10n.journeyLevelSectionTitle,
            subtitle: l10n.journeyLevelSectionSubtitle,
          ),
        ),
        JourneyHeroCard(
          levelText: '${l10n.levelLabel} ${summary.level}',
          xpText: '${summary.xp} XP',
          nextLevelText:
              '${summary.nextLevelXpRemaining} ${l10n.homeXpToNextLevel}',
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
          progress:
              ((summary.ringPrayer + summary.ringDhikr + summary.ringQuran) / 3)
                  .clamp(0, 1),
          sectionId: 'journey-home',
        ),
        const SizedBox(height: 18),
        KeyedSubtree(
          key: _sectionKeys['journey-rings'],
          child: SectionTitle(
            title: l10n.journeyRingsSectionTitle,
            subtitle: l10n.journeyRingsSectionSubtitle,
          ),
        ),
        JourneyDailyRingsCard(
          sectionId: 'journey-rings',
          items: [
            JourneyRingItem(
              label: l10n.journeyRingPrayer,
              progress: summary.ringPrayer,
            ),
            JourneyRingItem(
              label: l10n.journeyRingDhikr,
              progress: summary.ringDhikr,
            ),
            JourneyRingItem(
              label: l10n.journeyRingQuran,
              progress: summary.ringQuran,
            ),
            JourneyRingItem(
              label: l10n.journeyRingReflection,
              progress: summary.ringReflection,
            ),
            JourneyRingItem(
              label: l10n.journeyRingFasting,
              progress: summary.ringFasting,
            ),
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
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.journeyGraceTokenTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.journeyGraceTokenBody(
                  summary.graceTokensRemaining,
                  summary.graceTokenMonthlyAllowance,
                  summary.weeklyProtectedDays,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        KeyedSubtree(
          key: _sectionKeys['journey-milestones'],
          child: SectionTitle(
            title: l10n.journeyMilestoneSectionTitle,
            subtitle: l10n.journeyMilestoneSectionSubtitle,
          ),
        ),
        JourneyMilestonesCard(
          sectionId: 'journey-milestones',
          entries: _milestoneLabels(l10n, summary),
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.journeyUnlocksSectionTitle,
          subtitle: l10n.journeyUnlocksSectionSubtitle,
        ),
        JourneyUnlocksCard(
          sectionId: 'journey-unlocks',
          items: _unlockLabels(l10n, summary),
        ),
        const SizedBox(height: 18),
        KeyedSubtree(
          key: _sectionKeys['journey-garden'],
          child: SectionTitle(
            title: l10n.journeyGrowthSectionTitle,
            subtitle: l10n.journeyGrowthSectionSubtitle,
          ),
        ),
        JourneyGrowthPreviewCard(
          title: l10n.journeyGrowthCardTitle,
          subtitle: l10n.journeyGrowthCardSubtitle,
          sectionId: 'journey-garden',
        ),
        const SizedBox(height: 18),
        KeyedSubtree(
          key: _sectionKeys['journey-ocean'],
          child: SectionTitle(
            title: l10n.journeyOceanSectionTitle,
            subtitle: l10n.journeyOceanSectionSubtitle,
          ),
        ),
        JourneyOceanCard(
          title: l10n.journeyOceanCardTitle,
          subtitle:
              '${l10n.journeyOceanCardSubtitle}\n${l10n.oceanLocalDropsLabel}: ${ocean.totalLocalDrops}',
          sectionId: 'journey-ocean',
        ),
        const SizedBox(height: 12),
        SectionTitle(
          title: l10n.journeyMonthlyBadgesTitle,
          subtitle: l10n.journeyMonthlyBadgesSubtitle,
        ),
        PremiumCard(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: summary.monthlyBadges
                .map(
                  (badge) => TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    tween: Tween(begin: 0.96, end: badge.earned ? 1.0 : 0.98),
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      width: 154,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: badge.earned
                            ? const Color(0xFFECE4D6)
                            : const Color(0xFFF4ECE0),
                        border: Border.all(
                          color: badge.earned
                              ? const Color(0xFFAF7B35)
                              : const Color(0xFFDBC6A3),
                        ),
                        boxShadow: badge.tier >= 3
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFAF7B35,
                                  ).withValues(alpha: 0.18),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                badge.earned
                                    ? Icons.workspace_premium_rounded
                                    : Icons.workspace_premium_outlined,
                                size: 18,
                                color: badge.earned
                                    ? const Color(0xFF8C5A1A)
                                    : const Color(0xFF8F775A),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  badge.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            badge.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF6A5A4A),
                              height: 1.28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 6,
                              value: badge.progress,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.journeyBadgeTier(
                              _tierLabel(l10n, badge.tier),
                              badge.currentValue,
                              badge.goldTarget,
                            ),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF735C45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.journeyWeeklyReflectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(_weeklyHighlightLabel(l10n, weeklyReview.titleHighlight)),
              const SizedBox(height: 8),
              Text(
                l10n.journeyWeeklyReflectionStats(
                  weeklyReview.worshipCompletions,
                  weeklyReview.learningCompletions,
                  weeklyReview.journalEntries,
                  weeklyReview.favoriteReflections,
                ),
              ),
              if (weeklyReview.topTags.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.journeyWeeklyReflectionTags(
                    weeklyReview.topTags.join(', '),
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
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
                l10n.journeyRewardSummaryTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.journeyRewardSummaryBody(
                  wallpaper.unlockedCount,
                  wallpaper.totalCount,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.journeyLearnSummaryBody(
                  learn.completedCount,
                  learn.startedCount,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonal(
                onPressed: () => context.pushNamed('oceanDrops'),
                child: Text(l10n.oceanOpenPage),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.tonal(
                onPressed: () => context.pushNamed('wallpaperLibrary'),
                child: Text(l10n.wallpaperLibraryTitle),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonal(
                onPressed: () => context.pushNamed('journalTimeline'),
                child: Text(l10n.journalTitle),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.tonal(
                onPressed: () => context.pushNamed('circlesDiscovery'),
                child: Text(l10n.circlesTitle),
              ),
            ),
          ],
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

  String _milestoneLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'first7days':
        return l10n.journeyMilestoneFirst7Days;
      case 'dhikr100':
        return l10n.journeyMilestoneDhikr100;
      case 'prayerWeek':
        return l10n.journeyMilestonePrayerWeek;
      case 'learningStreak':
        return l10n.journeyMilestoneLearningStreak;
      default:
        return '';
    }
  }

  List<String> _milestoneLabels(AppLocalizations l10n, JourneySummary summary) {
    final ordered = <String>[
      ...summary.unlockedMilestoneKeys,
      ...summary.upcomingMilestoneKeys,
    ];

    if (ordered.isEmpty) {
      return [
        l10n.journeyMilestoneFirst7Days,
        l10n.journeyMilestoneDhikr100,
        l10n.journeyMilestonePrayerWeek,
        l10n.journeyMilestoneLearningStreak,
      ];
    }

    return ordered
        .map((key) => _milestoneLabel(l10n, key))
        .where((label) => label.isNotEmpty)
        .take(4)
        .toList();
  }

  List<String> _unlockLabels(AppLocalizations l10n, JourneySummary summary) {
    final ordered = <String>[
      summary.nextUnlockPreviewKey,
      ...summary.upcomingRewardKeys,
      ...summary.unlockedRewardKeys,
    ];

    final deduped = <String>{};
    final labels = <String>[];
    for (final key in ordered) {
      if (deduped.contains(key)) continue;
      deduped.add(key);
      labels.add(_unlockLabel(l10n, key));
      if (labels.length >= 4) break;
    }
    if (labels.isEmpty) labels.add(l10n.journeyUnlockFuture);
    return labels;
  }

  String _tierLabel(AppLocalizations l10n, int tier) {
    switch (tier) {
      case 4:
        return l10n.journeyTierPlatinum;
      case 3:
        return l10n.journeyTierGold;
      case 2:
        return l10n.journeyTierSilver;
      case 1:
        return l10n.journeyTierBronze;
      default:
        return l10n.journeyTierStarting;
    }
  }

  String _weeklyHighlightLabel(AppLocalizations l10n, String highlightKey) {
    switch (highlightKey) {
      case 'steady_worship':
        return l10n.journeyWeeklyHighlightWorship;
      case 'learning_growth':
        return l10n.journeyWeeklyHighlightLearning;
      case 'reflection_presence':
        return l10n.journeyWeeklyHighlightReflection;
      default:
        return l10n.journeyWeeklyHighlightSmallSteps;
    }
  }
}

class _JourneyModeCard extends ConsumerWidget {
  const _JourneyModeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(specialModeProvider);
    if (!mode.isRamadan && !mode.isLoss && !mode.isGentle) {
      return const SizedBox.shrink();
    }

    String title;
    String subtitle;

    if (mode.isRamadan) {
      title = l10n.modeRamadanJourneyTitle;
      subtitle = l10n.modeRamadanJourneySubtitle;
    } else if (mode.isLoss) {
      title = l10n.modeLossJourneyTitle;
      subtitle = l10n.modeLossJourneySubtitle;
    } else {
      title = l10n.modeGentleJourneyTitle;
      subtitle = l10n.modeGentleJourneySubtitle;
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _JourneyGlassHubs extends StatelessWidget {
  const _JourneyGlassHubs({
    required this.l10n,
    required this.items,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final List<_JourneyHubItem> items;
  final ValueChanged<_JourneyHubItem> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.journeyTitle,
          subtitle: l10n.journeySubtitle,
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map(
                (item) => _JourneyGlassHubCard(item: item, onTap: () => onTap(item)),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _JourneyGlassHubCard extends StatelessWidget {
  const _JourneyGlassHubCard({required this.item, required this.onTap});

  final _JourneyHubItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - 46) / 2,
      child: PremiumCard(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFFFFF).withValues(alpha: 0.60),
                  const Color(0xFFE9DDCD).withValues(alpha: 0.48),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icon, color: const Color(0xFF6B533B)),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, height: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JourneyHubItem {
  const _JourneyHubItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routeName,
    this.scrollToSectionId,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;
  final String? scrollToSectionId;
}
