import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../application/historical_calendar_providers.dart';
import '../../presentation/history_ui_helpers.dart';

class OnThisDayHomeCard extends ConsumerWidget {
  const OnThisDayHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final todayAsync = ref.watch(historicalTodayProvider);

    return PremiumCard(
      child: todayAsync.when(
        data: (todayState) {
          final featured = todayState.featuredMatch;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_edu_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.historyOnThisDayTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(l10n.historyOnThisDaySubtitle),
                      ],
                    ),
                  ),
                  if (todayState.matches.isNotEmpty)
                    TextButton(
                      onPressed: () => context.pushNamed('learnOnThisDayMatches'),
                      child: Text(
                        todayState.matches.length > 1
                            ? l10n.historyViewAllCount(
                                todayState.matches.length,
                              )
                            : l10n.historyOpenArchiveAction,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                formatTodayGregorianDate(context, l10n, todayState.today),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(formatTodayHijriDate(context, l10n, todayState.hijriToday)),
              const SizedBox(height: 14),
              if (featured == null)
                _EmptyHistoryState(l10n: l10n)
              else
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.pushNamed(
                    'learnHistoricalEventDetail',
                    pathParameters: {'slug': featured.event.slug},
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).colorScheme.surface.withValues(
                        alpha: 0.42,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Badge(
                              label: historicalMatchLabel(l10n, featured),
                            ),
                            if (featured.event.categories.isNotEmpty)
                              _Badge(
                                label: historicalCategoryLabel(
                                  l10n,
                                  featured.event.categories.first,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          featured.event.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          featured.event.summaryShort,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (featured.event.hasLocation) ...[
                          const SizedBox(height: 8),
                          Text(
                            featured.event.location.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 140,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => _EmptyHistoryState(l10n: l10n),
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.historyEmptyTodayTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(l10n.historyEmptyTodaySubtitle),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => context.pushNamed('learnHistoryArchive'),
          child: Text(l10n.historyOpenArchiveAction),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.12),
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
