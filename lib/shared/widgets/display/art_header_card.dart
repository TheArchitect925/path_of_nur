import 'package:flutter/material.dart';

/// Scenic art header used by hero cards across the Learn surfaces: a 4:3
/// illustration under a three-stop scrim with the title resting on the darkest
/// band. Falls back to an icon-on-tint block when the asset is missing, so a
/// stripped build never renders a broken image.
class ArtHeaderCard extends StatelessWidget {
  const ArtHeaderCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.fallbackIcon,
    required this.fallbackColor,
    this.subtitle,
    this.eyebrow,
    this.trailing,
    this.aspectRatio = 4 / 3,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.onTap,
  });

  final String imageAsset;
  final String title;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final String? subtitle;
  final String? eyebrow;
  final Widget? trailing;
  final double aspectRatio;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: borderRadius,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              errorBuilder: (context, error, stackTrace) => ArtImageFallback(
                icon: fallbackIcon,
                color: fallbackColor,
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x14000000), Color(0x2E000000), Color(0x8F000000)],
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (eyebrow != null)
                          Text(
                            eyebrow!.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                          ),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.88),
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 10),
                    trailing!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: card,
      ),
    );
  }
}

/// Small rounded art thumbnail for list rows — the illustrated counterpart of
/// [HubLeadingIcon]-style chips. Same missing-asset fallback as the header.
class ArtLeadingThumb extends StatelessWidget {
  const ArtLeadingThumb({
    super.key,
    required this.imageAsset,
    required this.fallbackIcon,
    required this.fallbackColor,
    this.size = 52,
  });

  final String imageAsset;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
          errorBuilder: (context, error, stackTrace) =>
              ArtImageFallback(icon: fallbackIcon, color: fallbackColor),
        ),
      ),
    );
  }
}

class ArtImageFallback extends StatelessWidget {
  const ArtImageFallback({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color.withValues(alpha: 0.24),
      child: Center(
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
