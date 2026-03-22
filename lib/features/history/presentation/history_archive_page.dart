import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/hijri_date_utils.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../application/historical_calendar_providers.dart';
import '../domain/historical_event_models.dart';
import 'history_ui_helpers.dart';
import 'widgets/historical_event_list_tile.dart';

class HistoryArchivePage extends ConsumerStatefulWidget {
  const HistoryArchivePage({super.key});

  @override
  ConsumerState<HistoryArchivePage> createState() => _HistoryArchivePageState();
}

class _HistoryArchivePageState extends ConsumerState<HistoryArchivePage> {
  HistoricalEventCategory? _selectedCategory;
  int? _selectedGregorianMonth;
  int? _selectedHijriMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final eventsAsync = ref.watch(historicalCalendarEventsProvider);

    return AppPageScaffold(
      title: l10n.historyArchiveTitle,
      subtitle: l10n.historyArchiveSubtitle,
      headerIcon: Icons.history_edu_rounded,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => context.pushNamed('learnOnThisDayMatches'),
            icon: const Icon(Icons.today_rounded),
            label: Text(l10n.historyTodayShortcutAction),
          ),
        ),
        const SizedBox(height: 8),
        eventsAsync.when(
          data: (events) {
            final filtered = events.where((event) {
              if (_selectedCategory != null &&
                  !event.categories.contains(_selectedCategory)) {
                return false;
              }
              if (_selectedGregorianMonth != null &&
                  event.gregorian.month != _selectedGregorianMonth) {
                return false;
              }
              if (_selectedHijriMonth != null &&
                  event.hijri.month != _selectedHijriMonth) {
                return false;
              }
              return true;
            }).toList(growable: false);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ArchiveFilters(
                  selectedCategory: _selectedCategory,
                  selectedGregorianMonth: _selectedGregorianMonth,
                  selectedHijriMonth: _selectedHijriMonth,
                  onCategoryChanged: (value) {
                    setState(() => _selectedCategory = value);
                  },
                  onGregorianMonthChanged: (value) {
                    setState(() => _selectedGregorianMonth = value);
                  },
                  onHijriMonthChanged: (value) {
                    setState(() => _selectedHijriMonth = value);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.historyArchiveResultsCount(filtered.length),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Text(l10n.historyArchiveEmptyFilters),
                  )
                else
                  ...filtered.map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: HistoricalEventListTile(event: event),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(l10n.historyArchiveLoadError),
          ),
        ),
      ],
    );
  }
}

class _ArchiveFilters extends StatelessWidget {
  const _ArchiveFilters({
    required this.selectedCategory,
    required this.selectedGregorianMonth,
    required this.selectedHijriMonth,
    required this.onCategoryChanged,
    required this.onGregorianMonthChanged,
    required this.onHijriMonthChanged,
  });

  final HistoricalEventCategory? selectedCategory;
  final int? selectedGregorianMonth;
  final int? selectedHijriMonth;
  final ValueChanged<HistoricalEventCategory?> onCategoryChanged;
  final ValueChanged<int?> onGregorianMonthChanged;
  final ValueChanged<int?> onHijriMonthChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.historyArchiveFiltersTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<HistoricalEventCategory?>(
          initialValue: selectedCategory,
          decoration: InputDecoration(labelText: l10n.historyArchiveCategoryLabel),
          items: [
            DropdownMenuItem<HistoricalEventCategory?>(
              value: null,
              child: Text(l10n.historyArchiveAllCategories),
            ),
            ...HistoricalEventCategory.values.map(
              (category) => DropdownMenuItem<HistoricalEventCategory?>(
                value: category,
                child: Text(historicalCategoryLabel(l10n, category)),
              ),
            ),
          ],
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<int?>(
          initialValue: selectedGregorianMonth,
          decoration: InputDecoration(
            labelText: l10n.historyArchiveGregorianMonthLabel,
          ),
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(l10n.historyArchiveAllGregorianMonths),
            ),
            for (var month = 1; month <= 12; month++)
              DropdownMenuItem<int?>(
                value: month,
                child: Text(DateFormat.MMMM(locale).format(DateTime(2026, month))),
              ),
          ],
          onChanged: onGregorianMonthChanged,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<int?>(
          initialValue: selectedHijriMonth,
          decoration: InputDecoration(labelText: l10n.historyArchiveHijriMonthLabel),
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(l10n.historyArchiveAllHijriMonths),
            ),
            for (var month = 1; month <= 12; month++)
              DropdownMenuItem<int?>(
                value: month,
                child: Text(hijriMonthName(l10n, month)),
              ),
          ],
          onChanged: onHijriMonthChanged,
        ),
      ],
    );
  }
}
