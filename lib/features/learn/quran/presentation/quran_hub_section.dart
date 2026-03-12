import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/section_title.dart';
import '../../presentation/widgets/learn_cards.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../../shared/domain/learn_unified_models.dart';
import '../application/quran_providers.dart';

class QuranHubSection extends ConsumerWidget {
  const QuranHubSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dailyVerse = ref.watch(quranDailyVerseProvider);
    final progress = ref.watch(quranContinueReadingSummaryProvider);
    final bookmarks = ref.watch(quranBookmarksProvider);
    final notes = ref.watch(quranNotesProvider);
    final wordFavorites = ref.watch(quranWordFavoritesProvider);
    final streak = ref.watch(quranReadingStreakProvider);
    final unified = ref.watch(learnUnifiedSummaryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.learnQuranSectionTitle,
          subtitle: l10n.learnQuranSectionSubtitle,
        ),
        LearnActionCard(
          title: l10n.learnQuranContinueTitle,
          subtitle: '${progress.locationLabel} • ${l10n.quranTapToResume}',
          icon: Icons.play_circle_outline_rounded,
          onTap: () => context.pushNamed(
            'quranReader',
            pathParameters: {'surahNumber': progress.surahNumber.toString()},
            queryParameters: {'ayah': progress.ayahNumber.toString()},
          ),
        ),
        if (unified.continueItem != null &&
            unified.continueItem!.domain != LearnDomainType.quran) ...[
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
          title: l10n.learnQuranDailyVerseTitle,
          subtitle: '${dailyVerse.locationLabel} • ${dailyVerse.translation}',
          icon: Icons.lightbulb_outline_rounded,
          onTap: () => context.pushNamed(
            'quranReader',
            pathParameters: {'surahNumber': dailyVerse.surahNumber.toString()},
            queryParameters: {'ayah': dailyVerse.ayahNumber.toString()},
          ),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnQuranExplorerTitle,
          subtitle: l10n.learnQuranExplorerSubtitle,
          icon: Icons.explore_outlined,
          onTap: () => context.pushNamed('quranExplorer'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.quranSearchTitle,
          subtitle: l10n.quranSearchSubtitle,
          icon: Icons.search_rounded,
          onTap: () => context.pushNamed('quranSearch'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: 'Qur’an Topics',
          subtitle:
              'Browse guidance by themes like patience, mercy, and justice.',
          icon: Icons.account_tree_outlined,
          onTap: () => context.pushNamed('quranTopicExplorer'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnQuranBookmarksTitle,
          subtitle: '${bookmarks.length} ${l10n.quranSavedLocations}',
          icon: Icons.bookmark_outline_rounded,
          onTap: () => context.pushNamed('quranBookmarks'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.quranNotesHighlightsTitle,
          subtitle: '${notes.length} ${l10n.quranSavedNotes}',
          icon: Icons.sticky_note_2_outlined,
          onTap: () => context.pushNamed('quranNotes'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.learnQuranProgressTitle,
          subtitle:
              '$streak ${l10n.homeDaysLabel} • ${l10n.quranConsistencyNote}',
          icon: Icons.local_fire_department_outlined,
          onTap: () => context.pushNamed('quranSearch'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.quranTopWordsTitle,
          subtitle: l10n.quranTopWordsSubtitle,
          icon: Icons.translate_rounded,
          onTap: () => context.pushNamed('quranTopWords'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.quranWordReviewTitle,
          subtitle: l10n.quranWordReviewHubSubtitle(wordFavorites.length),
          icon: Icons.style_outlined,
          onTap: () => context.pushNamed('quranWordReview'),
        ),
        const SizedBox(height: 12),
        LearnActionCard(
          title: l10n.quranNamesOfAllahTitle,
          subtitle: l10n.quranNamesOfAllahSubtitle,
          icon: Icons.auto_awesome_rounded,
          onTap: () => context.pushNamed('quranNamesOfAllah'),
        ),
        if (unified.suggestedNextItem != null &&
            unified.suggestedNextItem!.domain != LearnDomainType.quran) ...[
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
        if (unified.recentItems.isNotEmpty) ...[
          const SizedBox(height: 12),
          LearnActionCard(
            title: l10n.lifeRecentOpenedTitle,
            subtitle: unified.recentItems
                .take(2)
                .map((e) => e.title)
                .join(' • '),
            icon: Icons.history_toggle_off_rounded,
            onTap: () => context.pushNamed(
              unified.recentItems.first.routeName,
              pathParameters: unified.recentItems.first.pathParameters,
              queryParameters: unified.recentItems.first.queryParameters,
            ),
          ),
        ],
      ],
    );
  }
}
