import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/learn_tab_provider.dart';
import '../content/application/learn_progress_provider.dart';
import '../shared/application/learn_enhancements_provider.dart';
import '../shared/application/learn_unified_provider.dart';
import '../shared/domain/learn_unified_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';
import 'widgets/learn_segmented_control.dart';
import 'widgets/learn_tab_content.dart';

class LearnPage extends ConsumerWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activeTab = ref.watch(learnTabProvider);
    final mode = ref.watch(specialModeProvider);
    final learnProgress = ref.watch(learnProgressSummaryProvider);
    final unified = ref.watch(learnUnifiedSummaryProvider);
    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: l10n.learnTitle,
      subtitle: l10n.learnSubtitle,
      quote: const QuranQuote(
        arabic: 'وَاقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
        transliteration: 'Waqra bi-ismi rabbika alladhi khalaq',
        translation: 'Read in the name of your Lord who created everything.',
        surah: 96,
        verse: 1,
        locationLabel: 'Qur’an 96:1',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        if (mode.isKids)
          PremiumCard(
            child: Text(
              l10n.kidsLearnHint,
              style: const TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
            ),
          ),
        if (mode.isKids) const SizedBox(height: 12),
        const _LearnModeCard(),
        const SizedBox(height: 12),
        const _TrackSelectorCard(),
        const SizedBox(height: 12),
        PremiumCard(
          child: Text(
            l10n.learnProgressSummary(
              learnProgress.startedCount,
              learnProgress.completedCount,
              learnProgress.favoriteCount,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _UnifiedLearnOverviewCard(summary: unified),
        const SizedBox(height: 12),
        const _BundleManagerCard(),
        const SizedBox(height: 12),
        LearnSegmentedControl(
          selected: activeTab,
          onChanged: (tab) => ref.read(learnTabProvider.notifier).state = tab,
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Padding(
            key: ValueKey(activeTab),
            padding: const EdgeInsets.only(bottom: 16),
            child: LearnTabContent(tab: activeTab),
          ),
        ),
      ],
    );
  }
}

class _LearnModeCard extends ConsumerWidget {
  const _LearnModeCard();

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
      title = l10n.modeRamadanLearnTitle;
      subtitle = l10n.modeRamadanLearnSubtitle;
    } else if (mode.isLoss) {
      title = l10n.modeLossLearnTitle;
      subtitle = l10n.modeLossLearnSubtitle;
    } else {
      title = l10n.modeGentleLearnTitle;
      subtitle = l10n.modeGentleLearnSubtitle;
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

class _UnifiedLearnOverviewCard extends StatelessWidget {
  const _UnifiedLearnOverviewCard({required this.summary});

  final LearnUnifiedSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnContentContinueTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (summary.continueItem != null)
            ListTile(
              onTap: () => context.pushNamed(
                summary.continueItem!.routeName,
                pathParameters: summary.continueItem!.pathParameters,
                queryParameters: summary.continueItem!.queryParameters,
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(summary.continueItem!.title),
              subtitle: Text(
                '${summary.continueItem!.subtitle}\n${l10n.learnContinueReasonWithTrack(_trackLabel(l10n, summary.selectedTrack))}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
            )
          else
            Text(l10n.learnResumeTopicSubtitleEmpty),
          const SizedBox(height: 10),
          if (summary.suggestedNextItem != null)
            ListTile(
              onTap: () => context.pushNamed(
                summary.suggestedNextItem!.routeName,
                pathParameters: summary.suggestedNextItem!.pathParameters,
                queryParameters: summary.suggestedNextItem!.queryParameters,
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.lifeSuggestedNextLessonTitle),
              subtitle: Text(
                '${summary.suggestedNextItem!.title} • ${_trackLabel(l10n, summary.selectedTrack)}',
              ),
              trailing: const Icon(Icons.auto_awesome_outlined),
            ),
          const SizedBox(height: 8),
          Text(
            l10n.learnContentThemesTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: Text(l10n.learnQuranSectionTitle),
                onPressed: () => context.pushNamed('quranExplorer'),
              ),
              ActionChip(
                label: Text(l10n.learnLifeSectionTitle),
                onPressed: () => context.pushNamed('learnLifeLanding'),
              ),
              ActionChip(
                label: Text(l10n.learnWorldSectionTitle),
                onPressed: () => context.pushNamed('learnWorldLanding'),
              ),
              ActionChip(
                label: Text(l10n.learnHadithSectionTitle),
                onPressed: () => context.pushNamed('learnHadithLanding'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(
              l10n.lifeRecentOpenedTitle,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            initiallyExpanded: false,
            children: [
              if (summary.recentItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: summary.recentItems
                        .take(4)
                        .map(
                          (item) => ActionChip(
                            label: Text(item.title),
                            onPressed: () => context.pushNamed(
                              item.routeName,
                              pathParameters: item.pathParameters,
                              queryParameters: item.queryParameters,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(l10n.learnResumeTopicSubtitleEmpty),
                  ),
                ),
              if (summary.featuredItems.isNotEmpty)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.lifeFeaturedLessonTitle),
                  subtitle: Text(summary.featuredItems.first.title),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(
                    summary.featuredItems.first.routeName,
                    pathParameters: summary.featuredItems.first.pathParameters,
                    queryParameters: summary.featuredItems.first.queryParameters,
                  ),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.learnNotesSectionTitle),
                subtitle: Text(l10n.learnNotesSectionSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed('learnNotesLanding'),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${summary.overallCompletedLessons}/${summary.overallTotalLessons}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: summary.overallCompletionRatio,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackSelectorCard extends ConsumerWidget {
  const _TrackSelectorCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTrack = ref.watch(learnTrackProvider);
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnTrackSelectorTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: LearnTrackType.values
                .map(
                  (track) => ChoiceChip(
                    label: Text(_trackLabel(l10n, track)),
                    selected: selectedTrack == track,
                    onSelected: (_) =>
                        ref.read(learnTrackProvider.notifier).setTrack(track),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BundleManagerCard extends ConsumerWidget {
  const _BundleManagerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bundles = ref.watch(learnBundlesProvider);
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnBundleManagerTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.learnBundleManagerSubtitle,
            style: const TextStyle(color: Color(0xFF6A5A4A)),
          ),
          const SizedBox(height: 10),
          ...bundles.map(
            (bundle) => SwitchListTile.adaptive(
              value: bundle.installed,
              contentPadding: EdgeInsets.zero,
              title: Text(bundle.title),
              subtitle: Text(
                '${bundle.description}\n${bundle.sizeLabel} • v${bundle.version}',
              ),
              isThreeLine: true,
              onChanged: (_) => ref
                  .read(learnBundlesProvider.notifier)
                  .toggleInstalled(bundle.id),
            ),
          ),
        ],
      ),
    );
  }
}

String _trackLabel(AppLocalizations l10n, LearnTrackType track) {
  switch (track) {
    case LearnTrackType.beginner:
      return l10n.learnTrackBeginner;
    case LearnTrackType.family:
      return l10n.learnTrackFamily;
    case LearnTrackType.character:
      return l10n.learnTrackCharacter;
    case LearnTrackType.ramadan:
      return l10n.learnTrackRamadan;
    case LearnTrackType.revert:
      return l10n.learnTrackRevert;
  }
}
