import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../shared/widgets/home_feature_card_header.dart';
import '../../application/historical_calendar_providers.dart';
import '../../domain/historical_event_models.dart';
import '../../presentation/history_ui_helpers.dart';

class OnThisDayHomeCard extends ConsumerStatefulWidget {
  const OnThisDayHomeCard({super.key});

  @override
  ConsumerState<OnThisDayHomeCard> createState() => _OnThisDayHomeCardState();
}

class _OnThisDayHomeCardState extends ConsumerState<OnThisDayHomeCard> {
  int _selectedMatchIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final todayAsync = ref.watch(historicalTodayProvider);

    return AppHeroGlassShell(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      tintColor: const Color(0xFFE7C98C),
      surfaceAlphaOverride: 0.2,
      radius: 36,
      borderColor: const Color(0x42FFFFFF),
      highlightGradientColors: const [
        Color(0x24FFFFFF),
        Colors.transparent,
        Color(0x16E8C98F),
      ],
      onTap: () => context.pushNamed('learnHistoryArchive'),
      child: todayAsync.when(
        data: (todayState) {
          final matches = todayState.matches;
          final currentIndex = matches.isEmpty
              ? 0
              : _selectedMatchIndex.clamp(0, matches.length - 1).toInt();
          final featured = matches.isEmpty ? null : matches[currentIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeFeatureCardHeader(
                icon: Icons.history_edu_rounded,
                title: l10n.historyOnThisDayTitle,
                subtitle: l10n.historyOnThisDaySubtitle,
                trailing: todayState.matches.isNotEmpty
                    ? TextButton(
                        onPressed: () =>
                            context.pushNamed('learnOnThisDayMatches'),
                        child: Text(
                          todayState.matches.length > 1
                              ? l10n.historyViewAllCount(
                                  todayState.matches.length,
                                )
                              : l10n.historyOpenArchiveAction,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 14),
              Text(
                formatTodayGregorianDate(context, l10n, todayState.today),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(
                formatTodayHijriDate(context, l10n, todayState.hijriToday),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (featured == null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.historyNoEventsForThisDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              if (featured == null)
                _UpcomingHistoryState(
                  l10n: l10n,
                  upcoming: todayState.nextUpcomingEvent,
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (matches.length > 1) ...[
                      Row(
                        children: [
                          IconButton(
                            onPressed: _selectedMatchIndex <= 0
                                ? null
                                : () => setState(() {
                                    _selectedMatchIndex -= 1;
                                  }),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).previousPageTooltip,
                            visualDensity: VisualDensity.compact,
                          ),
                          Expanded(
                            child: Text(
                              '${currentIndex + 1} / ${matches.length}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          IconButton(
                            onPressed: currentIndex >= matches.length - 1
                                ? null
                                : () => setState(() {
                                    _selectedMatchIndex += 1;
                                  }),
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).nextPageTooltip,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    _HistoricalEventPreview(
                      l10n: l10n,
                      event: featured.event,
                      badgeLabel: historicalMatchLabel(l10n, featured),
                    ),
                  ],
                ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 140,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => _UpcomingHistoryState(l10n: l10n, upcoming: null),
      ),
    );
  }
}

class _HistoricalEventPreview extends StatelessWidget {
  const _HistoricalEventPreview({
    required this.l10n,
    required this.event,
    required this.badgeLabel,
    this.secondaryLabel,
  });

  final AppLocalizations l10n;
  final HistoricalEvent event;
  final String badgeLabel;
  final String? secondaryLabel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        'learnHistoricalEventDetail',
        pathParameters: {'slug': event.slug},
      ),
      borderRadius: BorderRadius.circular(24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFFFFF8EE).withValues(alpha: 0.64),
          border: Border.all(
            color: const Color(0xFFE7C98C).withValues(alpha: 0.36),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Badge(label: badgeLabel),
                  if (secondaryLabel != null) _Badge(label: secondaryLabel!),
                  if (event.categories.isNotEmpty)
                    _Badge(
                      label: historicalCategoryLabel(
                        l10n,
                        event.categories.first,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                event.summaryShort,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (event.hasLocation) ...[
                const SizedBox(height: 10),
                Text(
                  event.location.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingHistoryState extends StatelessWidget {
  const _UpcomingHistoryState({required this.l10n, required this.upcoming});

  final AppLocalizations l10n;
  final HistoricalUpcomingEvent? upcoming;

  @override
  Widget build(BuildContext context) {
    if (upcoming == null) {
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

    final locale = Localizations.localeOf(context).toLanguageTag();
    return _HistoricalEventPreview(
      l10n: l10n,
      event: upcoming!.event,
      badgeLabel: l10n.historyNextUpcomingEventLabel,
      secondaryLabel: DateFormat.yMMMd(locale).format(upcoming!.occurrenceDate),
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
