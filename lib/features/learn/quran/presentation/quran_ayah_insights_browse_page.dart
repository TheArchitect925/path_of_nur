import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../l10n/app_localizations.dart';
import '../application/quran_ayah_enrichment_provider.dart';
import '../domain/quran_ayah_enrichment_models.dart';

class QuranAyahInsightsBrowsePage extends ConsumerStatefulWidget {
  const QuranAyahInsightsBrowsePage({super.key});

  @override
  ConsumerState<QuranAyahInsightsBrowsePage> createState() =>
      _QuranAyahInsightsBrowsePageState();
}

class _QuranAyahInsightsBrowsePageState
    extends ConsumerState<QuranAyahInsightsBrowsePage> {
  String? _selectedCategoryId;
  QuranAyahEnrichmentTag? _selectedTag;
  QuranAyahEnrichmentLessonType? _selectedLessonType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(quranAyahEnrichmentBrowseCategoriesProvider);
    final availableTags = ref.watch(quranAyahEnrichmentBrowseTagsProvider);
    final filteredCategories = categories
        .where((category) {
          if (_selectedCategoryId != null &&
              category.id != _selectedCategoryId) {
            return false;
          }
          final matchingEntries = _filteredEntriesFor(
            entries: category.entries,
            selectedTag: _selectedTag,
            selectedLessonType: _selectedLessonType,
          );
          return matchingEntries.isNotEmpty;
        })
        .map(
          (category) => QuranAyahEnrichmentBrowseCategory(
            id: category.id,
            domains: category.domains,
            entries: _filteredEntriesFor(
              entries: category.entries,
              selectedTag: _selectedTag,
              selectedLessonType: _selectedLessonType,
            ),
          ),
        )
        .toList(growable: false);
    final hasActiveFilters =
        _selectedCategoryId != null ||
        _selectedTag != null ||
        _selectedLessonType != null;

    return AppPageScaffold(
      headerIcon: Icons.auto_awesome_outlined,
      title: l10n.quranAyahInsightsBrowseTitle,
      subtitle: l10n.quranAyahInsightsBrowseSubtitle,
      children: [
        if (categories.isEmpty)
          PremiumCard(child: Text(l10n.quranAyahInsightsBrowseEmpty))
        else ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranAyahInsightPathsEntryTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranAyahInsightPathsEntrySubtitle),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('quranAyahInsightsPaths'),
                  icon: const Icon(Icons.route_rounded),
                  label: Text(l10n.quranAyahInsightPathsAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BrowseFilterSection(
                  title: l10n.quranAyahInsightsBrowseFilterDomains,
                  children: [
                    _BrowseChoiceChip(
                      label: l10n.quranAyahInsightsBrowseFilterAll,
                      selected: _selectedCategoryId == null,
                      onSelected: () =>
                          setState(() => _selectedCategoryId = null),
                    ),
                    ...categories.map(
                      (category) => _BrowseChoiceChip(
                        label: _titleForCategory(l10n, category.id),
                        selected: _selectedCategoryId == category.id,
                        onSelected: () => setState(() {
                          _selectedCategoryId = category.id;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _BrowseFilterSection(
                  title: l10n.quranAyahInsightsBrowseFilterTags,
                  children: [
                    _BrowseChoiceChip(
                      label: l10n.quranAyahInsightsBrowseFilterAll,
                      selected: _selectedTag == null,
                      onSelected: () => setState(() => _selectedTag = null),
                    ),
                    ...availableTags.map(
                      (tag) => _BrowseChoiceChip(
                        label: _tagLabel(l10n, tag),
                        selected: _selectedTag == tag,
                        onSelected: () => setState(() {
                          _selectedTag = tag;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _BrowseFilterSection(
                  title: l10n.quranAyahInsightsBrowseFilterLessonType,
                  children: [
                    _BrowseChoiceChip(
                      label: l10n.quranAyahInsightsBrowseFilterAll,
                      selected: _selectedLessonType == null,
                      onSelected: () =>
                          setState(() => _selectedLessonType = null),
                    ),
                    ...QuranAyahEnrichmentLessonType.values.map(
                      (lessonType) => _BrowseChoiceChip(
                        label: _lessonTypeLabel(l10n, lessonType),
                        selected: _selectedLessonType == lessonType,
                        onSelected: () => setState(() {
                          _selectedLessonType = lessonType;
                        }),
                      ),
                    ),
                  ],
                ),
                if (hasActiveFilters) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => setState(() {
                        _selectedCategoryId = null;
                        _selectedTag = null;
                        _selectedLessonType = null;
                      }),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.quranAyahInsightsBrowseFilterClear),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (filteredCategories.isEmpty)
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.quranAyahInsightsBrowseNoResultsTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.quranAyahInsightsBrowseNoResultsSubtitle),
                ],
              ),
            )
          else
            ...filteredCategories.map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PremiumCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_titleForCategory(l10n, category.id)),
                    subtitle: Text(
                      '${_subtitleForCategory(l10n, category.id)}\n${l10n.quranAyahInsightsBrowseCount(category.count)}',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.pushNamed(
                      'quranAyahInsightsDomain',
                      pathParameters: {'domainId': category.id},
                      queryParameters: {
                        if (_selectedTag != null) 'tag': _selectedTag!.name,
                        if (_selectedLessonType != null)
                          'lessonType': _selectedLessonType!.name,
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class QuranAyahInsightsDomainPage extends ConsumerWidget {
  const QuranAyahInsightsDomainPage({super.key, required this.domainId});

  final String domainId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final category = ref.watch(
      quranAyahEnrichmentBrowseCategoryProvider(domainId),
    );

    if (category == null) {
      return AppPageScaffold(
        headerIcon: Icons.auto_awesome_outlined,
        title: l10n.quranAyahInsightsBrowseTitle,
        subtitle: l10n.quranAyahInsightsBrowseSubtitle,
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranAyahInsightsDomainEmptyTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranAyahInsightsDomainEmptySubtitle),
              ],
            ),
          ),
        ],
      );
    }

    final title = _titleForCategory(l10n, category.id);
    final selectedTag = _parseTag(
      GoRouterState.of(context).uri.queryParameters['tag'],
    );
    final selectedLessonType = _parseLessonType(
      GoRouterState.of(context).uri.queryParameters['lessonType'],
    );
    final entries = _filteredEntriesFor(
      entries: category.entries,
      selectedTag: selectedTag,
      selectedLessonType: selectedLessonType,
    );

    return AppPageScaffold(
      headerIcon: Icons.auto_awesome_outlined,
      title: title,
      subtitle: _subtitleForCategory(l10n, category.id),
      children: [
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.quranAyahInsightsBrowseCount(entries.length),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton.icon(
                onPressed: () => context.pushNamed('quranLearningHub'),
                icon: const Icon(Icons.school_rounded),
                label: Text(l10n.quranAyahInsightsBrowseHubAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (entries.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranAyahInsightsBrowseNoResultsTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranAyahInsightsBrowseNoResultsSubtitle),
              ],
            ),
          )
        else
          ...entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry.title),
                  subtitle: Text(
                    '${l10n.quranReferenceViewerReferenceLabel(entry.ref.locationLabel)} • ${_lessonTypeLabel(l10n, entry.lessonType)}\n${entry.summary}',
                  ),
                  isThreeLine: true,
                  trailing: entry.cautionLevel != QuranAyahCautionLevel.none
                      ? const Icon(Icons.info_outline_rounded)
                      : const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      openQuranReferenceLocation(context, ref: entry.ref),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BrowseFilterSection extends StatelessWidget {
  const _BrowseFilterSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}

class _BrowseChoiceChip extends StatelessWidget {
  const _BrowseChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

List<QuranAyahEnrichmentEntry> _filteredEntriesFor({
  required List<QuranAyahEnrichmentEntry> entries,
  required QuranAyahEnrichmentTag? selectedTag,
  required QuranAyahEnrichmentLessonType? selectedLessonType,
}) {
  return entries
      .where((entry) {
        if (selectedTag != null && !entry.tags.contains(selectedTag)) {
          return false;
        }
        if (selectedLessonType != null &&
            entry.lessonType != selectedLessonType) {
          return false;
        }
        return true;
      })
      .toList(growable: false);
}

QuranAyahEnrichmentTag? _parseTag(String? rawValue) {
  if (rawValue == null || rawValue.isEmpty) return null;
  for (final value in QuranAyahEnrichmentTag.values) {
    if (value.name == rawValue) return value;
  }
  return null;
}

QuranAyahEnrichmentLessonType? _parseLessonType(String? rawValue) {
  if (rawValue == null || rawValue.isEmpty) return null;
  for (final value in QuranAyahEnrichmentLessonType.values) {
    if (value.name == rawValue) return value;
  }
  return null;
}

String _titleForCategory(AppLocalizations l10n, String categoryId) {
  switch (categoryId) {
    case 'signs-in-creation':
      return l10n.quranAyahInsightsDomainSignsInCreation;
    case 'worship-remembrance':
      return l10n.quranAyahInsightsDomainWorshipRemembrance;
    case 'character-adab':
      return l10n.quranAyahInsightsDomainCharacterAdab;
    case 'tawhid-belief':
      return l10n.quranAyahInsightsDomainTawhidBelief;
    case 'akhirah-accountability':
      return l10n.quranAyahInsightsDomainAkhirahAccountability;
    case 'prophets-lessons':
      return l10n.quranAyahInsightsDomainProphetsLessons;
    case 'guidance-daily-life':
      return l10n.quranAyahInsightsDomainGuidanceDailyLife;
    default:
      return l10n.quranAyahInsightsBrowseTitle;
  }
}

String _tagLabel(AppLocalizations l10n, QuranAyahEnrichmentTag tag) {
  switch (tag) {
    case QuranAyahEnrichmentTag.sabr:
      return l10n.quranAyahInsightsBrowseTagSabr;
    case QuranAyahEnrichmentTag.shukr:
      return l10n.quranAyahInsightsBrowseTagShukr;
    case QuranAyahEnrichmentTag.tawakkul:
      return l10n.quranAyahInsightsBrowseTagTawakkul;
    case QuranAyahEnrichmentTag.mercy:
      return l10n.quranAyahInsightsBrowseTagMercy;
    case QuranAyahEnrichmentTag.repentance:
      return l10n.quranAyahInsightsBrowseTagRepentance;
    case QuranAyahEnrichmentTag.justice:
      return l10n.quranAyahInsightsBrowseTagJustice;
    case QuranAyahEnrichmentTag.sincerity:
      return l10n.quranAyahInsightsBrowseTagSincerity;
    case QuranAyahEnrichmentTag.guidance:
      return l10n.quranAyahInsightsBrowseTagGuidance;
    case QuranAyahEnrichmentTag.signs:
      return l10n.quranAyahInsightsBrowseTagSigns;
    case QuranAyahEnrichmentTag.creation:
      return l10n.quranAyahInsightsBrowseTagCreation;
    case QuranAyahEnrichmentTag.prophets:
      return l10n.quranAyahInsightsBrowseTagProphets;
    case QuranAyahEnrichmentTag.worship:
      return l10n.quranAyahInsightsBrowseTagWorship;
  }
}

String _subtitleForCategory(AppLocalizations l10n, String categoryId) {
  switch (categoryId) {
    case 'signs-in-creation':
      return l10n.quranAyahInsightsBrowseSubtitleSignsInCreation;
    case 'worship-remembrance':
      return l10n.quranAyahInsightsBrowseSubtitleWorshipRemembrance;
    case 'character-adab':
      return l10n.quranAyahInsightsBrowseSubtitleCharacterAdab;
    case 'tawhid-belief':
      return l10n.quranAyahInsightsBrowseSubtitleTawhidBelief;
    case 'akhirah-accountability':
      return l10n.quranAyahInsightsBrowseSubtitleAkhirahAccountability;
    case 'prophets-lessons':
      return l10n.quranAyahInsightsBrowseSubtitleProphetsLessons;
    case 'guidance-daily-life':
      return l10n.quranAyahInsightsBrowseSubtitleGuidanceDailyLife;
    default:
      return l10n.quranAyahInsightsBrowseSubtitle;
  }
}

String _lessonTypeLabel(
  AppLocalizations l10n,
  QuranAyahEnrichmentLessonType lessonType,
) {
  switch (lessonType) {
    case QuranAyahEnrichmentLessonType.coreLesson:
      return l10n.quranAyahInsightsBrowseLessonTypeCoreLesson;
    case QuranAyahEnrichmentLessonType.reflection:
      return l10n.quranAyahInsightsBrowseLessonTypeReflection;
    case QuranAyahEnrichmentLessonType.practicalTakeaway:
      return l10n.quranAyahInsightsBrowseLessonTypePracticalTakeaway;
    case QuranAyahEnrichmentLessonType.warning:
      return l10n.quranAyahInsightsBrowseLessonTypeWarning;
    case QuranAyahEnrichmentLessonType.reminder:
      return l10n.quranAyahInsightsBrowseLessonTypeReminder;
    case QuranAyahEnrichmentLessonType.connection:
      return l10n.quranAyahInsightsBrowseLessonTypeConnection;
  }
}
