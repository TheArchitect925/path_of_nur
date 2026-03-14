import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_quote_block.dart';
import '../../../journal/application/journal_provider.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../application/learn_progress_provider.dart';
import '../../quran/application/quran_providers.dart';

class LearnNotesLandingPage extends ConsumerWidget {
  const LearnNotesLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quranNotes = ref.watch(quranNotesProvider);
    final quranBookmarks = ref.watch(quranBookmarksProvider);
    final learnSummary = ref.watch(learnProgressSummaryProvider);
    final journal = ref.watch(journalProvider);
    final unified = ref.watch(learnUnifiedSummaryProvider);

    return AppPageScaffold(
      headerIcon: Icons.sticky_note_2_outlined,
      title: l10n.learnNotesSectionTitle,
      subtitle: l10n.learnNotesSectionSubtitle,
      quotePool: reflectionFocusedQuotePool,
      children: [
        PremiumCard(
          child: Text(
            l10n.learnProgressSummary(
              learnSummary.startedCount,
              learnSummary.completedCount,
              learnSummary.favoriteCount,
            ),
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
            subtitle: unified.recentItems.take(2).map((e) => e.title).join(' • '),
            icon: Icons.history_rounded,
            onTap: () => context.pushNamed(
              unified.recentItems.first.routeName,
              pathParameters: unified.recentItems.first.pathParameters,
              queryParameters: unified.recentItems.first.queryParameters,
            ),
          ),
        _EntryCard(
          title: l10n.learnNotesSavedTitle,
          subtitle: '${quranNotes.length} ${l10n.quranSavedNotes}',
          icon: Icons.notes_rounded,
          onTap: () => context.pushNamed('quranNotes'),
        ),
        _EntryCard(
          title: l10n.learnNotesReflectionsTitle,
          subtitle: '${journal.entries.length} ${l10n.learnNotesReflectionsSubtitle}',
          icon: Icons.rate_review_outlined,
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
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

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
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
