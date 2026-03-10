import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/wallpaper_provider.dart';

class WallpaperLibraryPage extends ConsumerWidget {
  const WallpaperLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(wallpaperProvider);
    final notifier = ref.read(wallpaperProvider.notifier);
    final categories = ref.watch(wallpaperCategoriesProvider);
    final wallpapers = ref.watch(filteredWallpapersProvider);
    final rewards = ref.watch(wallpaperRewardSummaryProvider);
    final stories = ref.watch(wallpaperStoryCardsProvider);

    return AppPageScaffold(
      headerIcon: Icons.wallpaper_rounded,
      title: l10n.wallpaperLibraryTitle,
      subtitle: l10n.wallpaperLibrarySubtitle,
      children: [
        PremiumCard(
          child: Text(
            l10n.wallpaperRewardSummary(
              rewards.unlockedCount,
              rewards.totalCount,
              rewards.nextRewardHint,
            ),
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.wallpaperStoryCardsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              ...stories
                  .take(4)
                  .map(
                    (story) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: story.unlocked
                            ? const Color(0xFFEAF4E6)
                            : const Color(0xFFF6EFE5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.wallpaperStoryHint(story.rewardHint),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.wallpaperStoryProgress(
                              story.minLevel,
                              story.currentLevel,
                              story.requiredCompletedTopics,
                              story.currentLearnCompletions,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (story.requiredMilestoneKey != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              l10n.wallpaperStoryMilestone(
                                story.requiredMilestoneKey!,
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories
                .map(
                  (category) => ChoiceChip(
                    label: Text(category),
                    selected: state.selectedCategory == category,
                    onSelected: (_) => notifier.selectCategory(category),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: wallpapers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final item = wallpapers[index];
            final unlocked = state.unlockedIds.contains(item.id);
            final selected = state.selectedId == item.id;
            return PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            item.assetPath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) =>
                                Container(color: const Color(0xFFE5DDD2)),
                          ),
                          if (!unlocked)
                            Container(
                              color: Colors.black.withValues(alpha: 0.35),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${l10n.levelLabel} ${item.minLevel}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    item.rewardHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: unlocked
                          ? () => notifier.select(item.id)
                          : null,
                      child: Text(
                        selected ? l10n.wallpaperSelected : l10n.wallpaperApply,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
