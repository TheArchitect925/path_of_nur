import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../models/faq_item.dart';

class FaqQuestionTile extends StatelessWidget {
  const FaqQuestionTile({super.key, required this.item, required this.onTap});

  final FaqItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: PremiumCard(
        surfaceVariant: AppSurfaceVariant.island,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _chip(context, _difficultyLabel(l10n, item.difficulty)),
                if (item.misconceptionTag != null)
                  _badge(
                    context,
                    item.category == 'misconceptions_about_islam'
                        ? l10n.batch9FaqBadgeClarification
                        : l10n.batch9FaqBadgeMisconception,
                  ),
                if (item.isFeatured)
                  _chip(context, l10n.batch9FaqBadgeFeatured),
              ],
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 460;
                final content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.question,
                      maxLines: compact ? 4 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.shortAnswer,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                  ],
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      content,
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: 10),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String label) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.66,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: style.decoration(radius: 999),
        child: Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, String label) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: AppColors.accentGold,
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.7,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: style.decoration(radius: 999),
        child: Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.accentGold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _difficultyLabel(AppLocalizations l10n, FaqDifficulty difficulty) {
    switch (difficulty) {
      case FaqDifficulty.beginner:
        return l10n.batch9FaqDifficultyBeginner;
      case FaqDifficulty.intermediate:
        return l10n.batch9FaqDifficultyIntermediate;
      case FaqDifficulty.advanced:
        return l10n.batch9FaqDifficultyAdvanced;
    }
  }
}
