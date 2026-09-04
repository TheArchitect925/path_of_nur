import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../application/historical_calendar_providers.dart';
import 'history_ui_helpers.dart';
import 'widgets/historical_event_list_tile.dart';

class OnThisDayMatchesPage extends ConsumerWidget {
  const OnThisDayMatchesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final todayAsync = ref.watch(historicalTodayProvider);

    return AppPageScaffold(
      title: l10n.historyOnThisDayMatchesTitle,
      subtitle: l10n.historyOnThisDayMatchesSubtitle,
      children: [
        todayAsync.when(
          data: (todayState) {
            if (todayState.matches.isEmpty) {
              return _EmptyTodayMatchesState(l10n: l10n);
            }
            final featured = todayState.featuredMatch;
            final remaining = todayState.matches
                .skip(1)
                .toList(growable: false);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HistoricalEventListTile(
                  event: featured!.event,
                  match: featured,
                ),
                const SizedBox(height: 14),
                Text(
                  formatTodayGregorianDate(context, l10n, todayState.today),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  formatTodayHijriDate(context, l10n, todayState.hijriToday),
                ),
                if (remaining.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    l10n.historyAdditionalMatchesTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...remaining.map(
                    (match) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: HistoricalEventListTile(
                        event: match.event,
                        match: match,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _EmptyTodayMatchesState(l10n: l10n),
        ),
      ],
    );
  }
}

class _EmptyTodayMatchesState extends StatelessWidget {
  const _EmptyTodayMatchesState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            const Icon(Icons.history_edu_outlined, size: 42),
            const SizedBox(height: 12),
            Text(
              l10n.historyEmptyTodayTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(l10n.historyEmptyTodaySubtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
