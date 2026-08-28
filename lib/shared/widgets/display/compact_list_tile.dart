import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../premium_card.dart';

/// Row-height glass tile for dense collections (surah lists, duas, hadith,
/// names). Pairs with [PremiumCardDensity.tile] so long lists stay scannable
/// instead of stacking full-size cards.
class CompactListTile extends StatelessWidget {
  const CompactListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.surfaceTintColor,
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 2,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? surfaceTintColor;
  final int titleMaxLines;
  final int subtitleMaxLines;

  @override
  Widget build(BuildContext context) {
    final subtitleText = subtitle;
    return PremiumCard(
      density: PremiumCardDensity.tile,
      onTap: onTap,
      surfaceTintColor: surfaceTintColor,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.s),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (subtitleText != null && subtitleText.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitleText,
                    maxLines: subtitleMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.s),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Standard leading ornament for [CompactListTile]: a small rounded badge
/// holding an ordinal or a short Arabic glyph, tinted from the theme accent.
class CompactTileBadge extends StatelessWidget {
  const CompactTileBadge({
    super.key,
    required this.label,
    this.textStyle,
    this.size = 40,
  });

  final String label;
  final TextStyle? textStyle;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size / 3),
      ),
      child: Text(
        label,
        style:
            textStyle ??
            Theme.of(context).textTheme.labelLarge?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
      ),
    );
  }
}
