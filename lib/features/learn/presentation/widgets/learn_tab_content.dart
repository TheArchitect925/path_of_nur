import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/app_summary_providers.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../../shared/domain/learn_unified_models.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/learn_tab_provider.dart';
import '../../quran/presentation/quran_hub_section.dart';
import 'learn_cards.dart';

class LearnTabContent extends ConsumerWidget {
  const LearnTabContent({super.key, required this.tab});

  final LearnTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(learnSummaryProvider);
    final unified = ref.watch(learnUnifiedSummaryProvider);
    switch (tab) {
      case LearnTab.quran:
        return const _QuranTab();
      case LearnTab.life:
        return _LifeTab(l10n: l10n, summary: summary, unified: unified);
      case LearnTab.world:
        return _WorldTab(l10n: l10n, summary: summary, unified: unified);
      case LearnTab.hadith:
        return _HadithTab(l10n: l10n, summary: summary, unified: unified);
      case LearnTab.notes:
        return _NotesTab(l10n: l10n, summary: summary);
    }
  }
}

class _QuranTab extends StatelessWidget {
  const _QuranTab();

  @override
  Widget build(BuildContext context) {
    return const QuranHubSection();
  }
}

class _LifeTab extends StatelessWidget {
  const _LifeTab({
    required this.l10n,
    required this.summary,
    required this.unified,
  });

  final AppLocalizations l10n;
  final LearnSummary summary;
  final LearnUnifiedSummary unified;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnLifeSectionTitle,
          subtitle: l10n.learnLifeSectionSubtitle,
        ),
        LearnActionCard(
          title: l10n.learnLifeSectionTitle,
          subtitle: l10n.learnLifeSectionSubtitle,
          icon: Icons.family_restroom_rounded,
          onTap: () => context.pushNamed('learnLifeLanding'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: 'Islamic Guidance Hub',
          subtitle:
              'Hajj, Umrah, New/Revert Muslim support, sisters topics, and practical guides.',
          icon: Icons.library_books_outlined,
          onTap: () => context.pushNamed('islamicGuides'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: 'Quran 50 Lessons Mapping',
          subtitle:
              'Track source lesson coverage across your Learn categories.',
          icon: Icons.fact_check_outlined,
          onTap: () => context.pushNamed('quranLessonsMapping'),
        ),
        if (unified.continueItem != null) ...[
          const SizedBox(height: 12),
          LearnActionCard(
            title: l10n.learnContentContinueTitle,
            subtitle: unified.continueItem!.title,
            icon: Icons.history_edu_outlined,
            onTap: () => context.pushNamed(
              unified.continueItem!.routeName,
              pathParameters: unified.continueItem!.pathParameters,
              queryParameters: unified.continueItem!.queryParameters,
            ),
          ),
        ],
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnProgressCardTitle,
          subtitle: l10n.learnProgressCardSubtitle(
            summary.startedTopics,
            summary.completedTopics,
            summary.favoriteTopics,
          ),
          icon: Icons.insights_outlined,
          onTap: () => context.pushNamed('learnLifeLanding'),
        ),
        const SizedBox(height: 12),
        LearnTopicGrid(
          topics: [
            l10n.learnLifeMarriage,
            l10n.learnLifeParents,
            l10n.learnLifeChildren,
            l10n.learnLifeWealth,
            l10n.learnLifePatience,
            l10n.learnLifeJustice,
            l10n.learnLifeCharacter,
            l10n.learnLifeGratitude,
          ],
          onTopicTap: (topic) => context.pushNamed(
            'learnContentDetail',
            pathParameters: {
              'category': 'life',
              'topicId': _lifeTopicId(l10n, topic),
            },
          ),
        ),
      ],
    );
  }
}

class _WorldTab extends StatelessWidget {
  const _WorldTab({
    required this.l10n,
    required this.summary,
    required this.unified,
  });

  final AppLocalizations l10n;
  final LearnSummary summary;
  final LearnUnifiedSummary unified;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnWorldSectionTitle,
          subtitle: l10n.learnWorldSectionSubtitle,
        ),
        LearnActionCard(
          title: l10n.learnWorldSectionTitle,
          subtitle: l10n.learnWorldSectionSubtitle,
          icon: Icons.public_rounded,
          onTap: () => context.pushNamed('learnWorldLanding'),
        ),
        if (unified.suggestedNextItem != null) ...[
          const SizedBox(height: 12),
          LearnActionCard(
            title: l10n.lifeSuggestedNextLessonTitle,
            subtitle: unified.suggestedNextItem!.title,
            icon: Icons.auto_awesome_outlined,
            onTap: () => context.pushNamed(
              unified.suggestedNextItem!.routeName,
              pathParameters: unified.suggestedNextItem!.pathParameters,
              queryParameters: unified.suggestedNextItem!.queryParameters,
            ),
          ),
        ],
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnResumeTopicTitle,
          subtitle: summary.resumeTopicId == null
              ? l10n.learnResumeTopicSubtitleEmpty
              : l10n.learnResumeTopicSubtitle(summary.resumeTopicId!),
          icon: Icons.history_rounded,
          onTap: () => context.pushNamed('learnWorldLanding'),
        ),
        const SizedBox(height: 12),
        LearnTopicGrid(
          topics: [
            l10n.learnWorldMoon,
            l10n.learnWorldBees,
            l10n.learnWorldMountains,
            l10n.learnWorldRain,
            l10n.learnWorldOceans,
            l10n.learnWorldAnimals,
            l10n.learnWorldPlants,
            l10n.learnWorldNightDay,
          ],
          onTopicTap: (topic) => context.pushNamed(
            'worldLessonDetail',
            pathParameters: {'lessonId': _worldLessonId(l10n, topic)},
          ),
        ),
      ],
    );
  }
}

class _HadithTab extends StatelessWidget {
  const _HadithTab({
    required this.l10n,
    required this.summary,
    required this.unified,
  });

  final AppLocalizations l10n;
  final LearnSummary summary;
  final LearnUnifiedSummary unified;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnHadithSectionTitle,
          subtitle: l10n.learnHadithSectionSubtitle,
        ),
        LearnActionCard(
          title: l10n.learnHadithSectionTitle,
          subtitle: l10n.learnHadithSectionSubtitle,
          icon: Icons.menu_book_rounded,
          onTap: () => context.pushNamed('learnHadithLanding'),
        ),
        if (unified.recentItems.isNotEmpty) ...[
          const SizedBox(height: 12),
          LearnActionCard(
            title: l10n.lifeRecentOpenedTitle,
            subtitle: unified.recentItems.first.title,
            icon: Icons.history_toggle_off_rounded,
            onTap: () => context.pushNamed(
              unified.recentItems.first.routeName,
              pathParameters: unified.recentItems.first.pathParameters,
              queryParameters: unified.recentItems.first.queryParameters,
            ),
          ),
        ],
        const SizedBox(height: 12),
        LearnActionCard(
          title: '50 Important Ahadith',
          subtitle: 'Study the source-based hadith collection in one place.',
          icon: Icons.library_books_outlined,
          onTap: () => context.pushNamed('learnHadithImportant'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnContentFavoritesTitle,
          subtitle: l10n.learnContentFavoritesSubtitle(summary.favoriteTopics),
          icon: Icons.favorite_border,
          onTap: () => context.pushNamed('learnHadithLanding'),
        ),
        const SizedBox(height: 12),
        LearnTopicGrid(
          topics: [
            l10n.learnHadithCharacterTitle,
            l10n.learnHadithWorshipTitle,
            l10n.learnHadithFamilyTitle,
            l10n.learnHadithLifeLessonsTitle,
            l10n.learnHadithWorldLessonsTitle,
            l10n.learnContentContinueTitle,
          ],
          onTopicTap: (topic) => context.pushNamed(
            'hadithLessonDetail',
            pathParameters: {'lessonId': _hadithLessonId(l10n, topic)},
          ),
        ),
      ],
    );
  }
}

class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.l10n, required this.summary});

  final AppLocalizations l10n;
  final LearnSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnNotesSectionTitle,
          subtitle: l10n.learnNotesSectionSubtitle,
        ),
        PremiumCard(
          child: Text(
            l10n.learnProgressSummary(
              summary.startedTopics,
              summary.completedTopics,
              summary.favoriteTopics,
            ),
          ),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnNotesSectionTitle,
          subtitle: l10n.learnNotesSectionSubtitle,
          icon: Icons.sticky_note_2_outlined,
          onTap: () => context.pushNamed('learnNotesLanding'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnNotesSavedTitle,
          subtitle: l10n.learnNotesSavedSubtitle,
          icon: Icons.sticky_note_2_outlined,
          onTap: () => context.pushNamed('learnNotesLanding'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnNotesReflectionsTitle,
          subtitle: l10n.learnNotesReflectionsSubtitle,
          icon: Icons.rate_review_outlined,
          onTap: () => context.pushNamed('learnNotesLanding'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnNotesHighlightsTitle,
          subtitle: l10n.learnNotesHighlightsSubtitle,
          icon: Icons.highlight_alt_outlined,
          onTap: () => context.pushNamed('learnNotesLanding'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnNotesContinueTitle,
          subtitle: l10n.learnNotesContinueSubtitle,
          icon: Icons.history_edu_outlined,
          onTap: () => context.pushNamed('learnNotesLanding'),
        ),
      ],
    );
  }
}

String _lifeTopicId(AppLocalizations l10n, String topic) {
  if (topic == l10n.learnLifeMarriage) return 'marriage';
  if (topic == l10n.learnLifeParents) return 'parents';
  if (topic == l10n.learnLifeChildren) return 'children';
  if (topic == l10n.learnLifeWealth) return 'wealth';
  if (topic == l10n.learnLifePatience) return 'patience';
  if (topic == l10n.learnLifeJustice) return 'justice';
  if (topic == l10n.learnLifeCharacter) return 'character';
  return 'gratitude';
}

String _worldLessonId(AppLocalizations l10n, String topic) {
  if (topic == l10n.learnWorldMoon) return 'celestial-moon-measure-time';
  if (topic == l10n.learnWorldBees) return 'animals-bee-order-benefit';
  if (topic == l10n.learnWorldMountains) {
    return 'earth-mountains-stability-reflection';
  }
  if (topic == l10n.learnWorldRain) return 'water-rain-mercy-revival';
  if (topic == l10n.learnWorldOceans) return 'water-seas-vastness-boundary';
  if (topic == l10n.learnWorldAnimals) return 'animals-birds-motion-trust';
  if (topic == l10n.learnWorldPlants) return 'plants-seeds-hidden-growth';
  return 'time-night-day-alternation';
}

String _hadithLessonId(AppLocalizations l10n, String topic) {
  if (topic == l10n.learnHadithCharacterTitle) return 'char-honesty-foundation';
  if (topic == l10n.learnHadithWorshipTitle) {
    return 'worship-intentions-weigh-actions';
  }
  if (topic == l10n.learnHadithFamilyTitle) return 'family-honoring-parents';
  if (topic == l10n.learnHadithLifeLessonsTitle) return 'life-value-of-time';
  if (topic == l10n.learnHadithWorldLessonsTitle) {
    return 'world-kindness-to-animals';
  }
  return 'worship-consistency-small-deeds';
}
