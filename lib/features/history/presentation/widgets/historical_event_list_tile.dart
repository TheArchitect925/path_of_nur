import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../domain/historical_event_models.dart';
import '../history_ui_helpers.dart';

class HistoricalEventListTile extends StatelessWidget {
  const HistoricalEventListTile({super.key, required this.event, this.match});

  final HistoricalEvent event;
  final HistoricalTodayMatch? match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.pushNamed(
        'learnHistoricalEventDetail',
        pathParameters: {'slug': event.slug},
      ),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (match != null)
                  HistoricalInfoBadge(
                    label: historicalMatchLabel(l10n, match!),
                  ),
                for (final category in event.categories.take(2))
                  HistoricalInfoBadge(
                    label: historicalCategoryLabel(l10n, category),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              event.title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              event.summaryShort,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(
              formatHistoricalGregorianDate(context, l10n, event.gregorian),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (event.hijri.hasMonthDay && event.hijri.year != null)
              Text(
                formatHistoricalHijriDate(context, l10n, event.hijri),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (event.hasLocation) ...[
              const SizedBox(height: 6),
              Text(
                event.location.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HistoricalInfoBadge extends StatelessWidget {
  const HistoricalInfoBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
