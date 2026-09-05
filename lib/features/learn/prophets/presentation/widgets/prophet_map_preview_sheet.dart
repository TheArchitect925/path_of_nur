import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/prophet_entry.dart';
import '../prophets_metadata_localization.dart';

class ProphetMapPreviewSheet extends StatelessWidget {
  const ProphetMapPreviewSheet({
    super.key,
    required this.prophets,
    required this.locationLabel,
    required this.onOpenDetail,
  });

  final List<ProphetEntry> prophets;
  final String locationLabel;
  final ValueChanged<ProphetEntry> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lead = prophets.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: PremiumCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prophets.length == 1 ? lead.honoredName : locationLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (prophets.length == 1)
              Text(
                lead.honoredArabicName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              )
            else
              Text(
                lead.regionLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
            const SizedBox(height: 6),
            Text(
              prophets.length == 1
                  ? lead.shortSummary
                  : prophets.map((item) => item.honoredName).join(' • '),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(context, locationLabel),
                _chip(
                  context,
                  localizedProphetLocationConfidenceLabel(
                    l10n,
                    _highestConfidence(prophets),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              localizedProphetLocationConfidenceGuidance(
                l10n,
                _highestConfidence(prophets),
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.palette.onSurfaceSubtle,
              ),
            ),
            const SizedBox(height: 10),
            if (prophets.length == 1)
              FilledButton.icon(
                onPressed: () => onOpenDetail(lead),
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(l10n.prophetsOpenFullProfile),
              )
            else
              Column(
                children: prophets
                    .map(
                      (prophet) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => onOpenDetail(prophet),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: context.palette.surface.withValues(
                                alpha: 0.28,
                              ),
                              border: Border.all(
                                color: prophet.eraGroup.tint.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prophet.honoredName,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  prophet.shortSummary,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
          ],
        ),
      ),
    );
  }

  ProphetLocationConfidence _highestConfidence(List<ProphetEntry> prophets) {
    return prophets
        .map((item) => item.locationConfidence)
        .fold(
          ProphetLocationConfidence.symbolic,
          (best, next) => next.index > best.index ? next : best,
        );
  }

  Widget _chip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.palette.surface.withValues(alpha: 0.34),
        border: Border.all(
          color: context.palette.accentSoft.withValues(alpha: 0.35),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
