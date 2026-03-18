import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/prophet_image_resolver.dart';
import '../domain/prophet_entry.dart';
import 'prophets_metadata_localization.dart';

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
    final l10n = AppLocalizations.of(context);
    if (prophets.isEmpty) {
      return PremiumCard(child: Text(l10n.prophetsEmptySearch));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...prophets.map(
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
    final l10n = AppLocalizations.of(context);
    final imageAsset = resolveProphetImageAsset(prophet);
    final imageAlignment = resolveProphetImageAlignment(prophet);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StoryCardHero(
              prophet: prophet,
              imageAsset: imageAsset,
              imageAlignment: imageAlignment,
              saved: saved,
              onToggleBookmark: onToggleBookmark,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
                              prophet.honoredName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                            ),
                            Text(
                              prophet.honoredArabicName,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.onSurfaceSubtle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _MetaPill(
                        text: localizedProphetEraTitle(l10n, prophet.eraGroup),
                      ),
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
          ],
        ),
      ),
    );
  }
}

class _StoryCardHero extends StatelessWidget {
  const _StoryCardHero({
    required this.prophet,
    required this.imageAsset,
    required this.imageAlignment,
    required this.saved,
    required this.onToggleBookmark,
  });

  final ProphetEntry prophet;
  final String? imageAsset;
  final Alignment imageAlignment;
  final bool saved;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageAsset != null)
              Image.asset(
                imageAsset!,
                fit: BoxFit.cover,
                alignment: imageAlignment,
                filterQuality: FilterQuality.low,
                errorBuilder: (context, error, stackTrace) =>
                    _StoryCardImageFallback(prophet: prophet),
              )
            else
              _StoryCardImageFallback(prophet: prophet),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.56),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF201710).withValues(alpha: 0.62),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  '${prophet.timelineOrder}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                tooltip: saved
                    ? l10n.prophetsRemoveBookmark
                    : l10n.prophetsSaveBookmark,
                onPressed: onToggleBookmark,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF201710,
                  ).withValues(alpha: 0.45),
                  foregroundColor: saved
                      ? const Color(0xFFF1D29A)
                      : Colors.white,
                ),
                icon: Icon(
                  saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prophet.honoredName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prophet.eraTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryCardImageFallback extends StatelessWidget {
  const _StoryCardImageFallback({required this.prophet});

  final ProphetEntry prophet;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            prophet.eraGroup.tint.withValues(alpha: 0.94),
            const Color(0xFF2A2018),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_stories_rounded,
          size: 42,
          color: Colors.white.withValues(alpha: 0.82),
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
