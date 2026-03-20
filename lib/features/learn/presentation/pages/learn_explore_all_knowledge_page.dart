import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/learn_hub_providers.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_hub_models.dart';
import '../widgets/learn_discovery_search_field.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class LearnExploreAllKnowledgePage extends ConsumerStatefulWidget {
  const LearnExploreAllKnowledgePage({
    super.key,
    this.initialCategoryId,
    this.initialQuery,
  });

  final LearnHubCategoryId? initialCategoryId;
  final String? initialQuery;

  @override
  ConsumerState<LearnExploreAllKnowledgePage> createState() =>
      _LearnExploreAllKnowledgePageState();
}

class _LearnExploreAllKnowledgePageState
    extends ConsumerState<LearnExploreAllKnowledgePage> {
  late final TextEditingController _searchController;
  late String _query;
  LearnHubCategoryId? _selectedCategory;
  LearnHubContentType? _selectedType;
  bool _alphabetical = false;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _selectedCategory = widget.initialCategoryId;
    _searchController = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(learnHubCategoriesProvider);
    final index = ref.watch(learnHubKnowledgeIndexProvider);
    final filtered = sortLearnHubKnowledgeItems(
      filterLearnHubKnowledgeItems(
            items: index,
            query: _query,
            categoryId: _selectedCategory,
          )
          .where((item) {
            if (_selectedType == null) {
              return item.contentType != LearnHubContentType.category;
            }
            return item.contentType == _selectedType;
          })
          .toList(growable: false),
      alphabetical: _alphabetical,
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.travel_explore_rounded,
      title: l10n.learnHubExploreAllTitle,
      subtitle: l10n.learnHubExploreAllSubtitle,
      children: [
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LearnDiscoverySearchField(
                controller: _searchController,
                hintText: l10n.learnDiscoverySearchLessonsHint,
                onChanged: (value) => setState(() => _query = value),
                onClear: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final useStackedLayout =
                      constraints.maxWidth < 360 ||
                      MediaQuery.textScalerOf(context).scale(1) > 1.15;
                  final helperText = Text(
                    l10n.learnHubExploreSearchHelper,
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                  final sortChip = FilterChip(
                    selected: _alphabetical,
                    onSelected: (value) {
                      setState(() => _alphabetical = value);
                    },
                    label: Text(l10n.learnHubSortAlphabetical),
                  );

                  if (useStackedLayout) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        helperText,
                        const SizedBox(height: 8),
                        sortChip,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: helperText),
                      const SizedBox(width: 12),
                      sortChip,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _CategoryWheel(
          categories: categories,
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = _selectedCategory == category
                  ? null
                  : category;
            });
          },
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TypeFilterChip(
                label: l10n.learnHubFilterAll,
                selected: _selectedType == null,
                onTap: () => setState(() => _selectedType = null),
              ),
              const SizedBox(width: 8),
              for (final type in [
                LearnHubContentType.lesson,
                LearnHubContentType.story,
                LearnHubContentType.quiz,
                LearnHubContentType.challenge,
                LearnHubContentType.tool,
                LearnHubContentType.note,
                LearnHubContentType.faq,
                LearnHubContentType.journey,
              ]) ...[
                _TypeFilterChip(
                  label: _contentTypeLabel(l10n, type),
                  selected: _selectedType == type,
                  onTap: () => setState(() {
                    _selectedType = _selectedType == type ? null : type;
                  }),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _query.trim().isEmpty
                      ? l10n.learnHubExploreEmptyTitle
                      : l10n.learnHubSearchEmptyTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _query.trim().isEmpty
                      ? l10n.learnHubExploreEmptySubtitle
                      : l10n.learnHubSearchEmptySubtitle,
                ),
              ],
            ),
          )
        else
          ...filtered.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ExploreKnowledgeCard(item: item),
            ),
          ),
      ],
    );
  }

  String _contentTypeLabel(
    AppLocalizations l10n,
    LearnHubContentType contentType,
  ) {
    switch (contentType) {
      case LearnHubContentType.category:
        return l10n.learnHubContentTypeCategory;
      case LearnHubContentType.subcategory:
        return l10n.learnHubContentTypeSubcategory;
      case LearnHubContentType.lesson:
        return l10n.learnHubContentTypeLesson;
      case LearnHubContentType.story:
        return l10n.learnHubContentTypeStory;
      case LearnHubContentType.quiz:
        return l10n.learnHubContentTypeQuiz;
      case LearnHubContentType.challenge:
        return l10n.learnHubContentTypeChallenge;
      case LearnHubContentType.tool:
        return l10n.learnHubContentTypeTool;
      case LearnHubContentType.note:
        return l10n.learnHubContentTypeNote;
      case LearnHubContentType.faq:
        return l10n.learnHubContentTypeFaq;
      case LearnHubContentType.journey:
        return l10n.learnHubContentTypeJourney;
    }
  }
}

class _CategoryWheel extends StatelessWidget {
  const _CategoryWheel({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<LearnHubCategoryDescriptor> categories;
  final LearnHubCategoryId? selectedCategory;
  final ValueChanged<LearnHubCategoryId> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnHubCategoryWheelTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(l10n.learnHubCategoryWheelSubtitle),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final size = math.min(constraints.maxWidth, 320.0);
              final center = size / 2;
              final radius = size * 0.34;
              return SizedBox(
                width: size,
                height: size,
                child: Stack(
                  children: [
                    Align(
                      child: Container(
                        width: size * 0.34,
                        height: size * 0.34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppSurfaceTheme.adaptiveColor(
                            context,
                            Theme.of(context).colorScheme.surface,
                            alpha: 0.55,
                            solidAlphaWhenDisabled: 0.96,
                          ),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.learnHubWheelCenterLabel,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    for (var i = 0; i < categories.length; i += 1)
                      Builder(
                        builder: (context) {
                          final angle =
                              (-math.pi / 2) +
                              (2 * math.pi * i / categories.length);
                          final dx = center + radius * math.cos(angle) - 42;
                          final dy = center + radius * math.sin(angle) - 42;
                          final category = categories[i];
                          final style = LearnHubTaxonomy.styleFor(category.id);
                          final selected = selectedCategory == category.id;
                          return Positioned(
                            left: dx,
                            top: dy,
                            child: GestureDetector(
                              onTap: () => onCategorySelected(category.id),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 84,
                                height: 84,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: style.baseColor.withValues(
                                    alpha: selected ? 0.96 : 0.86,
                                  ),
                                  border: Border.all(
                                    color: style.accentColor.withValues(
                                      alpha: selected ? 0.92 : 0.32,
                                    ),
                                    width: selected ? 2.0 : 1.0,
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: style.accentColor.withValues(
                                              alpha: 0.18,
                                            ),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      style.icon,
                                      size: 18,
                                      color: style.accentColor,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      category.title,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: style.accentColor,
                                            height: 1.15,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TypeFilterChip extends StatelessWidget {
  const _TypeFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      label: Text(label),
    );
  }
}

class _ExploreKnowledgeCard extends StatelessWidget {
  const _ExploreKnowledgeCard({required this.item});

  final LearnHubKnowledgeItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = LearnHubTaxonomy.styleFor(item.categoryId);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.pushNamed(
        item.routeTarget.routeName,
        pathParameters: item.routeTarget.pathParameters,
        queryParameters: item.routeTarget.queryParameters,
      ),
      child: PremiumCard(
        surfaceTintColor: style.accentColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 70,
              decoration: BoxDecoration(
                color: style.accentColor.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _ExploreBadge(
                        label: switch (item.contentType) {
                          LearnHubContentType.category =>
                            l10n.learnHubContentTypeCategory,
                          LearnHubContentType.subcategory =>
                            l10n.learnHubContentTypeSubcategory,
                          LearnHubContentType.lesson =>
                            l10n.learnHubContentTypeLesson,
                          LearnHubContentType.story =>
                            l10n.learnHubContentTypeStory,
                          LearnHubContentType.quiz =>
                            l10n.learnHubContentTypeQuiz,
                          LearnHubContentType.challenge =>
                            l10n.learnHubContentTypeChallenge,
                          LearnHubContentType.tool =>
                            l10n.learnHubContentTypeTool,
                          LearnHubContentType.note =>
                            l10n.learnHubContentTypeNote,
                          LearnHubContentType.faq =>
                            l10n.learnHubContentTypeFaq,
                          LearnHubContentType.journey =>
                            l10n.learnHubContentTypeJourney,
                        },
                        accentColor: style.accentColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subcategoryTitle == null
                        ? LearnHubTaxonomy.categoryTitle(l10n, item.categoryId)
                        : '${LearnHubTaxonomy.categoryTitle(l10n, item.categoryId)} • ${item.subcategoryTitle}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: style.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.summary.isEmpty ? item.subtitle : item.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreBadge extends StatelessWidget {
  const _ExploreBadge({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppSurfaceTheme.adaptiveColor(
          context,
          accentColor,
          alpha: 0.12,
          solidAlphaWhenDisabled: 0.20,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppSurfaceTheme.adaptiveColor(
            context,
            accentColor,
            alpha: 0.25,
            solidAlphaWhenDisabled: 0.34,
          ),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: accentColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
