import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../content_linking/application/contextual_linking_providers.dart';
import '../../content_linking/presentation/contextual_related_content_section.dart';
import '../../learn/journey/data/learning_journey_localized_metadata.dart';
import '../../learn/journey/data/learning_journey_registry.dart';
import '../application/historical_calendar_providers.dart';
import '../domain/historical_event_models.dart';
import 'history_ui_helpers.dart';
import 'widgets/historical_event_list_tile.dart';

class HistoryEventDetailPage extends ConsumerWidget {
  const HistoryEventDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final eventAsync = ref.watch(historicalEventBySlugProvider(slug));

    return eventAsync.when(
      data: (event) {
        if (event == null) {
          return AppPageScaffold(
            title: l10n.historyDetailNotFoundTitle,
            subtitle: l10n.historyDetailNotFoundSubtitle,
            headerIcon: Icons.history_toggle_off_rounded,
            children: [Text(l10n.historyDetailNotFoundSubtitle)],
          );
        }
        final contextualRelatedAsync = ref.watch(
          contextualLinksForHistoricalEventProvider(event.slug),
        );
        return AppPageScaffold(
          title: event.title,
          subtitle: event.summaryShort,
          headerIcon: Icons.history_edu_rounded,
          children: [
            _HistoryHeaderCard(event: event),
            const SizedBox(height: 14),
            _HistorySectionCard(
              title: l10n.historyOverviewTitle,
              child: Text(event.summaryLong ?? event.summaryShort),
            ),
            if (event.significancePoints.isNotEmpty) ...[
              const SizedBox(height: 12),
              _HistorySectionCard(
                title: l10n.historySignificanceTitle,
                child: _BulletList(items: event.significancePoints),
              ),
            ],
            if (event.lessons.isNotEmpty) ...[
              const SizedBox(height: 12),
              _HistorySectionCard(
                title: l10n.historyLessonsTitle,
                child: _BulletList(items: event.lessons),
              ),
            ],
            if (event.relatedEntities.isNotEmpty) ...[
              const SizedBox(height: 12),
              _HistorySectionCard(
                title: l10n.historyRelatedPeopleTitle,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: event.relatedEntities
                      .map((item) => HistoricalInfoBadge(label: item))
                      .toList(growable: false),
                ),
              ),
            ],
            if (event.relatedContentHooks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _HistorySectionCard(
                title: l10n.historyRelatedContentTitle,
                child: Column(
                  children: event.relatedContentHooks
                      .map(
                        (hook) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(_historyHookTitle(context, hook)),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.pushNamed(
                            hook.routeName,
                            pathParameters: hook.pathParameters,
                            queryParameters: hook.queryParameters,
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ],
            if (contextualRelatedAsync case AsyncData(:final value)
                when value.isNotEmpty) ...[
              const SizedBox(height: 12),
              _HistorySectionCard(
                title: l10n.contextualLinksRelatedTitle,
                child: ContextualRelatedContentSection(items: value),
              ),
            ],
            if (event.sources.isNotEmpty) ...[
              const SizedBox(height: 12),
              _HistorySectionCard(
                title: l10n.historySourcesTitle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: event.sources
                      .map(
                        (source) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            source.note == null || source.note!.isEmpty
                                ? source.label
                                : '${source.label}\n${source.note!}',
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ],
          ],
        );
      },
      loading: () => AppPageScaffold(
        title: l10n.historyDetailLoadingTitle,
        subtitle: l10n.historyDetailLoadingSubtitle,
        headerIcon: Icons.history_edu_rounded,
        children: const [Center(child: CircularProgressIndicator())],
      ),
      error: (_, _) => AppPageScaffold(
        title: l10n.historyDetailNotFoundTitle,
        subtitle: l10n.historyDetailNotFoundSubtitle,
        headerIcon: Icons.history_toggle_off_rounded,
        children: [Text(l10n.historyDetailNotFoundSubtitle)],
      ),
    );
  }
}

String _historyHookTitle(
  BuildContext context,
  HistoricalRelatedContentHook hook,
) {
  if (hook.routeName == 'learnJourneyDetail') {
    final journeyId = hook.pathParameters['journeyId'];
    final journey = journeyId == null
        ? null
        : LearningJourneyRegistry.journeyById(journeyId);
    if (journey != null) {
      return localizedJourneyTitle(context, journey);
    }
  }
  return hook.label;
}

class _HistoryHeaderCard extends StatelessWidget {
  const _HistoryHeaderCard({required this.event});

  final HistoricalEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in event.categories)
                HistoricalInfoBadge(
                  label: historicalCategoryLabel(l10n, category),
                ),
              HistoricalInfoBadge(
                label: historyDateConfidenceLabel(l10n, event.dateConfidence),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _LabelValueRow(
            label: l10n.historyGregorianDateLabel,
            value: formatHistoricalGregorianDate(context, l10n, event.gregorian),
          ),
          const SizedBox(height: 10),
          _LabelValueRow(
            label: l10n.historyHijriDateLabel,
            value: event.hijri.hasMonthDay && event.hijri.year != null
                ? formatHistoricalHijriDate(context, l10n, event.hijri)
                : l10n.historyDateUnavailable,
          ),
          if (event.hasLocation) ...[
            const SizedBox(height: 10),
            _LabelValueRow(
              label: l10n.historyLocationLabel,
              value: event.location.name,
            ),
          ],
        ],
      ),
    );
  }
}

class _HistorySectionCard extends StatelessWidget {
  const _HistorySectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _LabelValueRow extends StatelessWidget {
  const _LabelValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.circle, size: 6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
