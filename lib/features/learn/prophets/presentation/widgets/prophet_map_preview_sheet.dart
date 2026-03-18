import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/prophet_entry.dart';
import '../prophets_metadata_localization.dart';

class ProphetMapPreviewSheet extends StatelessWidget {
  const ProphetMapPreviewSheet({
    super.key,
    required this.prophet,
    required this.onOpenDetail,
  });

  final ProphetEntry prophet;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: PremiumCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prophet.honoredName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              prophet.honoredArabicName,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
            ),
            const SizedBox(height: 6),
            Text(prophet.shortSummary),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(prophet.locationLabel ?? prophet.regionLabel),
                _chip(
                  localizedProphetLocationConfidenceLabel(
                    l10n,
                    prophet.locationConfidence,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              localizedProphetLocationConfidenceGuidance(
                l10n,
                prophet.locationConfidence,
              ),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: onOpenDetail,
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(l10n.prophetsOpenFullProfile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surface.withValues(alpha: 0.34),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.35),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
