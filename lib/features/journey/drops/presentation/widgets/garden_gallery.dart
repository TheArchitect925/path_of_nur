import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/journey_drops_providers.dart';
import '../../domain/garden_asset_paths.dart';
import '../../domain/journey_drops_models.dart';
import '../garden_image_viewer_page.dart';

class GardenGallery extends ConsumerWidget {
  const GardenGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const GardenGallerySection();
  }
}

class GardenGallerySection extends ConsumerWidget {
  const GardenGallerySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(journeyDropSummaryProvider);
    final milestones = ref.watch(gardenMilestonesProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.gardenGalleryTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.gardenGallerySubtitle,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A5A4A)),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: milestones.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              final milestone = milestones[index];
              final unlocked = milestone.isUnlocked(summary.totalDrops);
              return GardenGalleryTile(
                milestone: milestone,
                unlocked: unlocked,
                title: gardenTitleForKey(l10n, milestone.titleKey),
                requiredDropsLabel: countFormat.format(milestone.requiredDrops),
                progressLabel: l10n.gardenGalleryTileProgressValue(
                  countFormat.format(summary.totalDrops),
                  countFormat.format(milestone.requiredDrops),
                ),
                onTap: unlocked
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                GardenImageViewerPage(milestone: milestone),
                          ),
                        );
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class GardenGalleryTile extends StatelessWidget {
  const GardenGalleryTile({
    super.key,
    required this.milestone,
    required this.unlocked,
    required this.title,
    required this.requiredDropsLabel,
    required this.progressLabel,
    this.onTap,
  });

  final GardenMilestone milestone;
  final bool unlocked;
  final String title;
  final String requiredDropsLabel;
  final String progressLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tile = Container(
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFFF5EEE3) : const Color(0xFFF3EEE8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: unlocked ? const Color(0xFFE0C38D) : const Color(0xFFD8D0C4),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Milestone art is a reward: a locked tile shows a plain
                  // covered panel, never a blurred glimpse of the artwork.
                  if (unlocked)
                    _GardenMilestoneArtwork(milestone: milestone)
                  else
                    const _GardenLockedPanel(),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1A16).withValues(alpha: 0.56),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Icon(
                        unlocked
                            ? Icons.visibility_rounded
                            : Icons.lock_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    unlocked
                        ? l10n.gardenGalleryUnlocked
                        : l10n.gardenGalleryLockedAtValue(requiredDropsLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A5A4A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!unlocked)
                    Text(
                      progressLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6A5A4A),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return tile;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: tile,
      ),
    );
  }
}

/// Stands in for milestone art that has not been earned yet — a quiet
/// covered panel, with no trace of the image behind it.
class _GardenLockedPanel extends StatelessWidget {
  const _GardenLockedPanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE9E2D6), Color(0xFFD9D0C2)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.spa_outlined,
          size: 30,
          color: const Color(0xFF6A5A4A).withValues(alpha: 0.32),
        ),
      ),
    );
  }
}

/// Earned milestone art. Locked tiles use [_GardenLockedPanel] instead, so
/// this never has to dim or obscure anything.
class _GardenMilestoneArtwork extends StatelessWidget {
  const _GardenMilestoneArtwork({required this.milestone});

  final GardenMilestone milestone;

  @override
  Widget build(BuildContext context) {
    final path = gardenImageAssetPath(milestone.imageAsset);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const _GardenArtworkFallback();
          },
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFF1E1915).withValues(alpha: 0.18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GardenArtworkFallback extends StatelessWidget {
  const _GardenArtworkFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Color(0xFFE7D7AE), Color(0xFF8BA06B)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.local_florist_rounded,
          size: 40,
          color: const Color(0xFF2C2318),
        ),
      ),
    );
  }
}

String gardenTitleForKey(AppLocalizations l10n, String key) {
  return switch (key) {
    'gardenMilestoneTitle1' => l10n.gardenMilestoneTitle1,
    'gardenMilestoneTitle2' => l10n.gardenMilestoneTitle2,
    'gardenMilestoneTitle3' => l10n.gardenMilestoneTitle3,
    'gardenMilestoneTitle4' => l10n.gardenMilestoneTitle4,
    'gardenMilestoneTitle5' => l10n.gardenMilestoneTitle5,
    'gardenMilestoneTitle6' => l10n.gardenMilestoneTitle6,
    'gardenMilestoneTitle7' => l10n.gardenMilestoneTitle7,
    'gardenMilestoneTitle8' => l10n.gardenMilestoneTitle8,
    'gardenMilestoneTitle9' => l10n.gardenMilestoneTitle9,
    'gardenMilestoneTitle10' => l10n.gardenMilestoneTitle10,
    _ => key,
  };
}

String gardenDescriptionForKey(AppLocalizations l10n, String key) {
  return switch (key) {
    'gardenMilestoneDescription1' => l10n.gardenMilestoneDescription1,
    'gardenMilestoneDescription2' => l10n.gardenMilestoneDescription2,
    'gardenMilestoneDescription3' => l10n.gardenMilestoneDescription3,
    'gardenMilestoneDescription4' => l10n.gardenMilestoneDescription4,
    'gardenMilestoneDescription5' => l10n.gardenMilestoneDescription5,
    'gardenMilestoneDescription6' => l10n.gardenMilestoneDescription6,
    'gardenMilestoneDescription7' => l10n.gardenMilestoneDescription7,
    'gardenMilestoneDescription8' => l10n.gardenMilestoneDescription8,
    'gardenMilestoneDescription9' => l10n.gardenMilestoneDescription9,
    'gardenMilestoneDescription10' => l10n.gardenMilestoneDescription10,
    _ => key,
  };
}
