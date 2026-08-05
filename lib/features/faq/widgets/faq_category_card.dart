import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../models/faq_item.dart';

class FaqCategoryCard extends StatelessWidget {
  const FaqCategoryCard({
    super.key,
    required this.summary,
    required this.icon,
    required this.onTap,
  });

  final FaqCategorySummary summary;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pillStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: PremiumCard(
        surfaceVariant: AppSurfaceVariant.island,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: pillStyle.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: pillStyle.borderColor),
                  ),
                  child: Icon(icon, color: AppColors.accentGold),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.onSurfaceSubtle,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              summary.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              summary.subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(
                  context,
                  l10n.batch9FaqQuestionCount(summary.questionCount),
                ),
                if (summary.featuredCount > 0)
                  _chip(
                    context,
                    l10n.batch9FaqFeaturedCount(summary.featuredCount),
                  ),
              ],
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
}
