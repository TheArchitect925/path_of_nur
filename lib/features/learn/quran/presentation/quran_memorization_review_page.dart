import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../application/quran_learning_system_service.dart';
import '../application/quran_providers.dart';
import '../application/quran_reference_graph_provider.dart';
import '../domain/quran_learning_models.dart';
import '../domain/quran_reference_models.dart';
import 'quran_theme_copy.dart';
import 'widgets/quran_related_reference_detail_sheet.dart';

class QuranMemorizationReviewPage extends ConsumerWidget {
  const QuranMemorizationReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(quranMemorizationReviewEntriesProvider);
    final sections = ref.watch(quranMemorizationReviewSectionsProvider);
    final startedCount = ref.watch(quranMemorizationStartedCountProvider);
    final dueEntries = ref.watch(quranMemorizationDueProvider);

    return AppPageScaffold(
      headerIcon: Icons.repeat_rounded,
      title: l10n.quranMemorizationReviewTitle,
      subtitle: l10n.quranMemorizationReviewSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranMemorizationTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quranMemorizationReviewSummary(
                  startedCount,
                  dueEntries.length,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SummaryChip(
                    label: l10n.quranMemorizationReviewTodayTitle,
                    count: sections.reviewToday.length,
                  ),
                  _SummaryChip(
                    label: l10n.quranMemorizationReviewContinueTitle,
                    count: sections.continueReview.length,
                  ),
                  _SummaryChip(
                    label: l10n.quranMemorizationReviewRecentTitle,
                    count: sections.recentlyMemorized.length,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (entries.isEmpty)
          PremiumCard(child: Text(l10n.quranMemorizationReviewEmpty))
        else ...[
          _ReviewSection(
            title: l10n.quranMemorizationReviewContinueTitle,
            entries: sections.continueReview,
          ),
          _ReviewSection(
            title: l10n.quranMemorizationReviewTodayTitle,
            entries: sections.reviewToday,
          ),
          _ReviewSection(
            title: l10n.quranMemorizationReviewRecentTitle,
            entries: sections.recentlyMemorized,
          ),
          _ReviewSection(
            title: l10n.quranMemorizationReviewNeedsRevisionTitle,
            entries: sections.needsRevision,
          ),
          _ReviewSection(
            title: l10n.quranMemorizationReviewAllTitle,
            entries: sections.allMemorized,
          ),
        ],
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text('$label: $count'),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.title, required this.entries});

  final String title;
  final List<QuranMemorizationReviewEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewSectionHeader(title: title),
        const SizedBox(height: 8),
        ...entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MemorizationReviewCard(entry: entry),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ReviewSectionHeader extends StatelessWidget {
  const _ReviewSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _MemorizationReviewCard extends ConsumerWidget {
  const _MemorizationReviewCard({required this.entry});

  final QuranMemorizationReviewEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ayahAsync = ref.watch(
      quranAyahByReferenceProvider((entry.surahNumber, entry.ayahNumber)),
    );
    final themes = ref.watch(
      quranThemesForVerseProvider((entry.surahNumber, entry.ayahNumber)),
    );
    final contextualLinks = ref.watch(
      quranContextualKnowledgeLinksForVerseProvider((
        entry.surahNumber,
        entry.ayahNumber,
      )),
    );
    final surah = ref.watch(quranSurahMapProvider)[entry.surahNumber];

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah?.transliteratedName ?? l10n.quranUnknownSurah,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.quranReferenceViewerReferenceLabel(
                        '${entry.surahNumber}:${entry.ayahNumber}',
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(_stageLabel(l10n, entry.progress.stage)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ayahAsync.when(
            data: (ayah) => Text(
              ayah?.translation ??
                  entry.seededVerse?.translation ??
                  l10n.quranMemorizationReviewMeaningFallback,
            ),
            loading: () => const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, _) => Text(
              entry.seededVerse?.translation ??
                  l10n.quranMemorizationReviewMeaningFallback,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.quranMemorizationReviewNextReview(
              MaterialLocalizations.of(context).formatMediumDate(
                DateTime(
                  entry.progress.nextReview.year,
                  entry.progress.nextReview.month,
                  entry.progress.nextReview.day,
                ),
              ),
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.quranMemorizationReviewRhythmMeta(
              entry.progress.reviewCount,
              entry.progress.lastReviewed == null
                  ? l10n.quranMemorizationReviewNeverReviewed
                  : MaterialLocalizations.of(
                      context,
                    ).formatMediumDate(entry.progress.lastReviewed!),
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          if (themes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.quranMemorizationReviewThemesTitle,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: themes
                  .take(1)
                  .map(
                    (topic) => ActionChip(
                      label: Text(localizedQuranTopicTitle(l10n, topic.id)),
                      onPressed: () => context.pushNamed(
                        'quranTopicDetail',
                        pathParameters: {'topicId': topic.id},
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          if (contextualLinks.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.quranMemorizationReviewRelatedStudyTitle,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: contextualLinks
                  .take(2)
                  .map(
                    (link) => ActionChip(
                      label: Text(link.title),
                      onPressed: () => showQuranRelatedKnowledgeDetailSheet(
                        context,
                        link: link,
                        anchorLabel: l10n.quranReferenceViewerReferenceLabel(
                          '${entry.surahNumber}:${entry.ayahNumber}',
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  'quranReader',
                  pathParameters: {'surahNumber': entry.surahNumber.toString()},
                  queryParameters: {
                    'ayah': entry.ayahNumber.toString(),
                    'review': 'memorization',
                    'mode': QuranReaderStudyMode.memorization.wireName,
                    'reviewCount': entry.progress.reviewCount.toString(),
                    if (entry.progress.lastReviewed != null)
                      'lastReviewed': entry.progress.lastReviewed!
                          .toIso8601String(),
                  },
                ),
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(l10n.quranMemorizationReviewOpenReaderAction),
              ),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(quranMemorizationProgressProvider.notifier)
                    .markReviewed(entry.progress.verseId, success: true),
                child: Text(l10n.learnQuranHubReviewedWellAction),
              ),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(quranMemorizationProgressProvider.notifier)
                    .markReviewed(
                      entry.progress.verseId,
                      success: false,
                      targetStage: MemorizationStage.repeating,
                    ),
                child: Text(l10n.learnQuranHubNeedsRepetitionAction),
              ),
              TextButton.icon(
                onPressed: () => ref
                    .read(quranMemorizationProgressProvider.notifier)
                    .remove(entry.progress.verseId),
                icon: const Icon(Icons.remove_circle_outline_rounded),
                label: Text(l10n.quranMemorizationRemoveAction),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _stageLabel(AppLocalizations l10n, MemorizationStage stage) {
    switch (stage) {
      case MemorizationStage.newVerse:
        return l10n.learnQuranHubStageNewVerse;
      case MemorizationStage.repeating:
        return l10n.learnQuranHubStageRepeating;
      case MemorizationStage.phrasePractice:
        return l10n.learnQuranHubStagePhrasePractice;
      case MemorizationStage.hiddenRecall:
        return l10n.learnQuranHubStageHiddenRecall;
      case MemorizationStage.mastered:
        return l10n.learnQuranHubStageMastered;
    }
  }
}
