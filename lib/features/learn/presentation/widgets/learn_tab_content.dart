import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/learn_tab_provider.dart';
import 'learn_cards.dart';

class LearnTabContent extends StatelessWidget {
  const LearnTabContent({
    super.key,
    required this.tab,
  });

  final LearnTab tab;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (tab) {
      case LearnTab.quran:
        return _QuranTab(l10n: l10n);
      case LearnTab.life:
        return _LifeTab(l10n: l10n);
      case LearnTab.world:
        return _WorldTab(l10n: l10n);
      case LearnTab.hadith:
        return _HadithTab(l10n: l10n);
      case LearnTab.notes:
        return _NotesTab(l10n: l10n);
    }
  }
}

class _QuranTab extends StatelessWidget {
  const _QuranTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnQuranSectionTitle,
          subtitle: l10n.learnQuranSectionSubtitle,
        ),
        LearnActionCard(
          title: l10n.learnQuranContinueTitle,
          subtitle: l10n.learnQuranContinueSubtitle,
          icon: Icons.play_circle_outline_rounded,
          sectionId: 'continueLearning',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnQuranDailyVerseTitle,
          subtitle: l10n.learnQuranDailyVerseSubtitle,
          icon: Icons.lightbulb_outline_rounded,
          sectionId: 'quran',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnQuranExplorerTitle,
          subtitle: l10n.learnQuranExplorerSubtitle,
          icon: Icons.explore_outlined,
          sectionId: 'quran',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnQuranBookmarksTitle,
          subtitle: l10n.learnQuranBookmarksSubtitle,
          icon: Icons.bookmark_outline_rounded,
          sectionId: 'quran',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnQuranProgressTitle,
          subtitle: l10n.learnQuranProgressSubtitle,
          icon: Icons.local_fire_department_outlined,
          sectionId: 'continueLearning',
        ),
      ],
    );
  }
}

class _LifeTab extends StatelessWidget {
  const _LifeTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnLifeSectionTitle,
          subtitle: l10n.learnLifeSectionSubtitle,
        ),
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
        ),
      ],
    );
  }
}

class _WorldTab extends StatelessWidget {
  const _WorldTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnWorldSectionTitle,
          subtitle: l10n.learnWorldSectionSubtitle,
        ),
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
        ),
      ],
    );
  }
}

class _HadithTab extends StatelessWidget {
  const _HadithTab({required this.l10n});

  final AppLocalizations l10n;

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
          title: l10n.learnHadithLifeLessonsTitle,
          subtitle: l10n.learnHadithLifeLessonsSubtitle,
          icon: Icons.menu_book_outlined,
          sectionId: 'hadithLessons',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnHadithWorldLessonsTitle,
          subtitle: l10n.learnHadithWorldLessonsSubtitle,
          icon: Icons.public_outlined,
          sectionId: 'hadithLessons',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnHadithCharacterTitle,
          subtitle: l10n.learnHadithCharacterSubtitle,
          icon: Icons.diversity_1_outlined,
          sectionId: 'hadithLessons',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnHadithWorshipTitle,
          subtitle: l10n.learnHadithWorshipSubtitle,
          icon: Icons.self_improvement_outlined,
          sectionId: 'hadithLessons',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnHadithFamilyTitle,
          subtitle: l10n.learnHadithFamilySubtitle,
          icon: Icons.home_outlined,
          sectionId: 'hadithLessons',
        ),
      ],
    );
  }
}

class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnNotesSectionTitle,
          subtitle: l10n.learnNotesSectionSubtitle,
        ),
        LearnActionCard(
          title: l10n.learnNotesSavedTitle,
          subtitle: l10n.learnNotesSavedSubtitle,
          icon: Icons.sticky_note_2_outlined,
          sectionId: 'reflections',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnNotesReflectionsTitle,
          subtitle: l10n.learnNotesReflectionsSubtitle,
          icon: Icons.rate_review_outlined,
          sectionId: 'reflections',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnNotesHighlightsTitle,
          subtitle: l10n.learnNotesHighlightsSubtitle,
          icon: Icons.highlight_alt_outlined,
          sectionId: 'reflections',
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnNotesContinueTitle,
          subtitle: l10n.learnNotesContinueSubtitle,
          icon: Icons.history_edu_outlined,
          sectionId: 'continueLearning',
        ),
      ],
    );
  }
}

