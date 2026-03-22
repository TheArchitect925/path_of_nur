import 'package:flutter/material.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/bedtime_story_media_resolver.dart';
import '../domain/bedtime_story_models.dart';

class BedtimeStoryCoverCard extends StatelessWidget {
  const BedtimeStoryCoverCard({
    super.key,
    required this.story,
    required this.media,
    this.height = 220,
    this.overlayTitle,
    this.overlayChips = const <Widget>[],
  });

  final BedtimeStorySeed story;
  final BedtimeStoryResolvedMedia media;
  final double height;
  final String? overlayTitle;
  final List<Widget> overlayChips;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final artPath = media.backdrop.resolvedAssetPath ?? media.cover.resolvedAssetPath;
    final hasArtwork = artPath != null;

    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.island,
      padding: EdgeInsets.zero,
      child: Container(
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFFFFF8EF),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (artPath != null)
              Image.asset(
                artPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _FallbackArtwork(
                    hasArtwork: false,
                    title: overlayTitle ?? story.shortTitle,
                  );
                },
              )
            else
              _FallbackArtwork(
                hasArtwork: false,
                title: overlayTitle ?? story.shortTitle,
              ),
            if (hasArtwork) Container(color: const Color(0x663A3026)),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MediaChip(
                        label: media.audio.isAvailable
                            ? l10n.bedtimeStoriesAudioReadyBadge
                            : l10n.bedtimeStoriesReadAlongBadge,
                      ),
                      _MediaChip(
                        label: l10n.bedtimeStoriesIncludedOfflineBadge,
                      ),
                      if (!media.hasAnyArtwork)
                        _MediaChip(
                          label: l10n.bedtimeStoriesArtComingSoonBadge,
                        ),
                      ...overlayChips,
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    overlayTitle ?? story.shortTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: hasArtwork ? Colors.white : null,
                      fontWeight: FontWeight.w800,
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

class _FallbackArtwork extends StatelessWidget {
  const _FallbackArtwork({required this.hasArtwork, required this.title});

  final bool hasArtwork;
  final String title;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFFFF7EB), Color(0xFFF5EADA), Color(0xFFE7D9C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_stories_rounded, size: 56, color: Color(0xFF7B624A)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF6F5842),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaChip extends StatelessWidget {
  const _MediaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xCCFFF8EF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
