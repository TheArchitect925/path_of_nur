import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../domain/prophet_entry.dart';

class ProphetsStoriesView extends StatelessWidget {
  const ProphetsStoriesView({
    super.key,
    required this.prophets,
    required this.bookmarkedIds,
    required this.onToggleBookmark,
    required this.onOpenDetail,
  });

  final List<ProphetEntry> prophets;
  final Set<String> bookmarkedIds;
  final ValueChanged<String> onToggleBookmark;
  final ValueChanged<ProphetEntry> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final saved = prophets
        .where((item) => bookmarkedIds.contains(item.id))
        .toList();
    final featured = prophets.where((item) => item.isFeatured).toList();
    final prioritizedIds = <String>{
      ...saved.map((e) => e.id),
      ...featured.map((e) => e.id),
    };
    final remaining = prophets
        .where((item) => !prioritizedIds.contains(item.id))
        .toList();

    if (prophets.isEmpty) {
      return const PremiumCard(
        child: Text(
          'No prophets match this search yet. Try another name, era, or region.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (saved.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Saved',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          ...saved.map(
            (prophet) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StoryCard(
                prophet: prophet,
                saved: true,
                onToggleBookmark: () => onToggleBookmark(prophet.id),
                onTap: () => onOpenDetail(prophet),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (featured.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Featured',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          ...featured.map(
            (prophet) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StoryCard(
                prophet: prophet,
                saved: bookmarkedIds.contains(prophet.id),
                onToggleBookmark: () => onToggleBookmark(prophet.id),
                onTap: () => onOpenDetail(prophet),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (remaining.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'All Matching',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          ...remaining.map(
            (prophet) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StoryCard(
                prophet: prophet,
                saved: bookmarkedIds.contains(prophet.id),
                onToggleBookmark: () => onToggleBookmark(prophet.id),
                onTap: () => onOpenDetail(prophet),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.prophet,
    required this.saved,
    required this.onTap,
    required this.onToggleBookmark,
  });

  final ProphetEntry prophet;
  final bool saved;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: prophet.eraGroup.tint.withValues(alpha: 0.16),
                    border: Border.all(
                      color: AppColors.accentGold.withValues(alpha: 0.38),
                    ),
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    color: prophet.eraGroup.tint,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prophet.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                      ),
                      Text(
                        prophet.arabicName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: saved ? 'Remove bookmark' : 'Save prophet',
                  onPressed: onToggleBookmark,
                  icon: Icon(
                    saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: saved
                        ? const Color(0xFF8F6A3A)
                        : AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _MetaPill(text: prophet.eraTitle),
                _MetaPill(text: prophet.regionLabel),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              prophet.shortSummary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surface.withValues(alpha: 0.32),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11.5, color: AppColors.onSurface),
      ),
    );
  }
}
