import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_header.dart';
import '../../shared/presentation/learning_references.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/hadith_foundation_repository.dart';

class HadithThemePage extends ConsumerWidget {
  const HadithThemePage({super.key, required this.themeId});

  final String themeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(hadithThemeByIdProvider(themeId));
    if (theme == null) {
      return AppPageScaffold(
        headerIcon: Icons.menu_book_rounded,
        title: 'Hadith',
        subtitle: 'Theme not found',
        children: const [
          PremiumCard(child: Text('The requested theme was not found.')),
        ],
      );
    }

    final entries = ref.watch(hadithEntriesForThemeProvider(theme.id));
    final savedIds = ref.watch(hadithSavedIdsProvider);
    final savedNotifier = ref.read(hadithSavedIdsProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.auto_stories_rounded,
      title: theme.title,
      subtitle: theme.subtitle,
      children: [
        LearningHeader(
          title: theme.title,
          summary: theme.description,
          chips: ['${entries.length} hadith', 'Theme'],
        ),
        const SizedBox(height: 10),
        LearningSection(
          title: 'Related Qur’an Anchors',
          child: LearningReferences(
            items: theme.quranAnchors
                .map(
                  (anchor) => LearningReferenceItem(
                    sourceTitle: anchor.surahName,
                    sourceNumber: anchor.surahNumber,
                    rangeOrSection: anchor.verseRange,
                    label: anchor.label,
                  ),
                )
                .toList(growable: false),
          ),
        ),
        LearningSection(
          title: 'Hadith in This Theme',
          child: Column(
            children: entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _HadithPreviewCard(
                      entryId: entry.id,
                      title: entry.title,
                      excerpt: entry.excerpt,
                      sourceCollection: entry.displaySourceCollection,
                      sourceReference: entry.displaySourceReference,
                      grading: entry.grading,
                      quranConnectionCount: entry.quranConnections.length,
                      tags: entry.tags,
                      isSaved: savedIds.contains(entry.id),
                      onToggleSaved: () => savedNotifier.toggle(entry.id),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _HadithPreviewCard extends StatelessWidget {
  const _HadithPreviewCard({
    required this.entryId,
    required this.title,
    required this.excerpt,
    required this.sourceCollection,
    required this.sourceReference,
    required this.grading,
    required this.quranConnectionCount,
    required this.tags,
    required this.isSaved,
    required this.onToggleSaved,
  });

  final String entryId;
  final String title;
  final String excerpt;
  final String sourceCollection;
  final String? sourceReference;
  final String grading;
  final int quranConnectionCount;
  final List<String> tags;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.pushNamed(
        'hadithLessonDetail',
        pathParameters: {'lessonId': entryId},
      ),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggleSaved,
                  tooltip: isSaved
                      ? l10n.accessibilityRemoveFromSaved
                      : l10n.accessibilitySaveHadith,
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isSaved
                        ? AppColors.onSurface
                        : AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
            Text(excerpt),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _badge(sourceCollection),
                if (sourceReference != null) _badge(sourceReference!),
                _badge(grading),
                if (quranConnectionCount > 0)
                  _badge('Qur’an connections: $quranConnectionCount'),
                ...tags.take(3).map(_badge),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.30),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11.5)),
    );
  }
}
