import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/bedtime_story_progress_service.dart';
import '../application/bedtime_story_repository.dart';
import '../domain/bedtime_story_models.dart';
import '../../../../core/theme/app_icons.dart';

class KidsHadithStoriesPage extends ConsumerWidget {
  const KidsHadithStoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stories = ref.watch(kidsHadithStoriesProvider);

    return LearnHubPageScaffold(
      showDefaultQuote: false,
      headerIcon: AppIcons.hadith,
      title: l10n.kidsHadithStoriesPageTitleText,
      subtitle: l10n.kidsHadithStoriesPageSubtitleText,
      children: [
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.island,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsHadithStoriesHeroTitleText,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(l10n.kidsHadithStoriesHeroSubtitleText),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (stories.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsHadithStoriesEmptyTitleText,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.kidsHadithStoriesEmptySubtitleText),
              ],
            ),
          )
        else
          ...stories.map(
            (story) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _KidsHadithStoryTile(story: story),
            ),
          ),
      ],
    );
  }
}

class _KidsHadithStoryTile extends ConsumerWidget {
  const _KidsHadithStoryTile({required this.story});

  final BedtimeStorySeed story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(
      bedtimeStoryProgressProvider.select(
        (value) =>
            value.storyProgressById[story.id] ?? const BedtimeStoryProgress(),
      ),
    );

    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: InkWell(
        onTap: () => context.pushNamed(
          'learnKidsHadithStoriesDetail',
          pathParameters: {'storyId': story.id},
        ),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFF6EEE2),
                    ),
                    child: const Icon(Icons.auto_stories_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.shortTitle,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story.summary.isNotEmpty
                              ? story.summary
                              : story.lesson,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if ((story.hadithReference ?? '').trim().isNotEmpty)
                Text(
                  '${l10n.kidsHadithStoriesSourceLabelText}: ${story.hadithReference}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _InfoChip(
                    label: _statusLabel(l10n, progress.completionState),
                  ),
                  if ((story.hadithQuote ?? '').trim().isNotEmpty)
                    _InfoChip(label: l10n.kidsHadithStoriesHadithChipText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(
    AppLocalizations l10n,
    BedtimeStoryCompletionState state,
  ) {
    switch (state) {
      case BedtimeStoryCompletionState.notStarted:
        return l10n.kidsHadithStoriesStatusReadyText;
      case BedtimeStoryCompletionState.inProgress:
        return l10n.kidsHadithStoriesStatusContinueText;
      case BedtimeStoryCompletionState.completed:
        return l10n.kidsHadithStoriesStatusReadAgainText;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFF5EEE5),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
