import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../journal/application/journal_provider.dart';
import '../application/learn_notes_provider.dart';
import 'learn_notes_localizations.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../application/learn_progress_provider.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/application/quran_reflections_provider.dart';
import '../../../../core/theme/app_palette.dart';

class LearnNotesLandingPage extends ConsumerWidget {
  const LearnNotesLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quranNotes = ref.watch(quranNotesProvider);
    final quranBookmarks = ref.watch(quranBookmarksProvider);
    final quranReflections = ref.watch(quranReflectionsProvider);
    final learnSummary = ref.watch(learnProgressSummaryProvider);
    final journal = ref.watch(journalProvider);
    final unified = ref.watch(learnUnifiedSummaryProvider);
    final notesSummary = ref.watch(learnNotesSummaryProvider);

    return AppPageScaffold(
      headerIcon: Icons.sticky_note_2_outlined,
      title: l10n.learnNotesSectionTitle,
      subtitle: l10n.learnNotesSectionSubtitle,
      children: [
        PremiumCard(
          child: Text(
            l10n.learnProgressSummary(
              learnSummary.startedCount,
              learnSummary.completedCount,
              learnSummary.favoriteCount,
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.palette.onSurfaceSubtle,
            ),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnNotesCategoriesTitleText,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(l10n.learnNotesCategoriesSubtitleText),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _CategoryChip(
                    label:
                        '${l10n.learnNotesCategoryAllText} ${notesSummary.totalCount}',
                  ),
                  ...notesSummary.categoryCounts.map(
                    (item) => _CategoryChip(
                      label:
                          '${l10n.localizedLearnNoteCategory(item.category)} ${item.count}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (unified.continueItem != null)
          _EntryCard(
            title: l10n.learnContentContinueTitle,
            subtitle: unified.continueItem!.title,
            icon: Icons.history_edu_outlined,
            onTap: () => context.pushNamed(
              unified.continueItem!.routeName,
              pathParameters: unified.continueItem!.pathParameters,
              queryParameters: unified.continueItem!.queryParameters,
            ),
          ),
        if (unified.recentItems.isNotEmpty)
          _EntryCard(
            title: l10n.lifeRecentOpenedTitle,
            subtitle: unified.recentItems
                .take(2)
                .map((e) => e.title)
                .join(' • '),
            icon: Icons.history_rounded,
            onTap: () => context.pushNamed(
              unified.recentItems.first.routeName,
              pathParameters: unified.recentItems.first.pathParameters,
              queryParameters: unified.recentItems.first.queryParameters,
            ),
          ),
        _EntryCard(
          title: l10n.learnNotesBrowseAllActionText,
          subtitle: l10n.learnNotesBrowseActionSubtitleText,
          icon: Icons.library_books_outlined,
          onTap: () => context.pushNamed('learnNotesBrowseAll'),
        ),
        _EntryCard(
          title: l10n.learnNotesSavedTitle,
          subtitle: '${quranNotes.length} ${l10n.quranSavedNotes}',
          icon: Icons.notes_rounded,
          onTap: () => context.pushNamed('quranNotes'),
        ),
        _EntryCard(
          title: l10n.learnNotesQuranReflectionsTitle,
          subtitle:
              '${quranReflections.length} ${l10n.learnNotesQuranReflectionsSubtitle}',
          icon: Icons.rate_review_outlined,
          tileKey: const Key('learnNotesQuranReflectionsCard'),
          onTap: () => context.pushNamed('quranReflections'),
        ),
        _EntryCard(
          title: l10n.learnNotesJournalTitle,
          subtitle:
              '${journal.entries.length} ${l10n.learnNotesJournalSubtitle}',
          icon: Icons.auto_stories_outlined,
          tileKey: const Key('learnNotesJournalCard'),
          onTap: () => context.pushNamed('journalTimeline'),
        ),
        _EntryCard(
          title: l10n.learnNotesHighlightsTitle,
          subtitle: '${quranBookmarks.length} ${l10n.quranSavedLocations}',
          icon: Icons.highlight_alt_outlined,
          onTap: () => context.pushNamed('quranBookmarks'),
        ),
        _EntryCard(
          title: l10n.learnNotesContinueTitle,
          subtitle: l10n.learnNotesContinueSubtitle,
          icon: Icons.history_edu_outlined,
          onTap: () => context.pushNamed('quranExplorer'),
        ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    this.tileKey,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final Key? tileKey;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        child: ListTile(
          key: tileKey,
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1ECE4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
