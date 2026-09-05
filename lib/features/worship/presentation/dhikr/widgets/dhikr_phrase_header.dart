import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The phrase being remembered: Arabic first and largest, transliteration
/// in the serif italic, meaning beneath. Long duʿās get a smaller face and
/// a bounded scrolling block so the ring keeps its room.
class DhikrPhraseHeader extends StatelessWidget {
  const DhikrPhraseHeader({
    super.key,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.title,
    this.compact = false,
  });

  final String arabic;
  final String transliteration;
  final String translation;
  final String? title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null && title!.isNotEmpty) ...[
          Text(
            title!,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: palette.accentSoft,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            arabic,
            textAlign: TextAlign.center,
            style: AppTextStyles.quranVerse(
              size: compact ? 24 : 38,
              color: palette.onSurface,
              weight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: compact ? 6 : 8),
        Text(
          transliteration,
          textAlign: TextAlign.center,
          style: AppTextStyles.titleSerif.copyWith(
            fontSize: compact ? 15 : 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            color: palette.onSurface,
            height: 1.3,
          ),
        ),
        SizedBox(height: compact ? 4 : 6),
        Text(
          translation,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: palette.onSurfaceSubtle,
            fontSize: compact ? 13 : null,
          ),
        ),
      ],
    );
    if (!compact) return column;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 220),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: column,
      ),
    );
  }
}
