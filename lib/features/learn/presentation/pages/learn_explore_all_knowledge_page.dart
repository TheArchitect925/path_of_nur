import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../guided_paths/application/guided_learning_paths_provider.dart';
import '../application/learn_hub_providers.dart';
import '../application/learn_discovery_providers.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_discovery_models.dart';
import '../models/learn_hub_models.dart';
import '../widgets/learn_discovery_search_field.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../../../../core/theme/app_icons.dart';

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
  LearnDiscoveryContentType? _selectedType;
  LearnDiscoveryAudience? _selectedAudience;
  LearnDiscoveryDifficulty? _selectedDifficulty;
  bool _alphabetical = false;
  bool _loggedSearchOpen = false;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _selectedCategory = widget.initialCategoryId;
    _searchController = TextEditingController(text: _query);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(learnAnalyticsServiceProvider)
          .logLandingViewed(surface: 'learn_explore');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(learnAnalyticsServiceProvider);
    final categories = ref.watch(learnHubCategoriesProvider);
    final discoveryIndex = ref.watch(learnDiscoveryIndexProvider);
    final searchResults = searchLearnDiscoveryEntries(
      entries: discoveryIndex,
      query: _query,
      categoryId: _selectedCategory,
      contentType: _selectedType,
      audience: _selectedAudience,
      difficulty: _selectedDifficulty,
      alphabetical: _alphabetical,
    );
    final hasDiscoveryFilters =
        _selectedCategory != null ||
        _selectedType != null ||
        _selectedAudience != null ||
        _selectedDifficulty != null;
    final hasSearchIntent = _query.trim().isNotEmpty || hasDiscoveryFilters;
    final bucketedResults = hasSearchIntent
        ? bucketLearnDiscoveryResults(
            results: searchResults,
            allEntries: discoveryIndex,
          )
        : curatedLearnDiscoverySections(entries: discoveryIndex);

    return LearnHubPageScaffold(
      headerIcon: AppIcons.explore,
      title: l10n.learnDiscoveryExploreTitle,
      subtitle: l10n.learnDiscoveryExploreSubtitle,
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
                onTap: () {
                  if (_loggedSearchOpen) return;
                  _loggedSearchOpen = true;
                  analytics.logSearchOpened(surface: 'learn_explore');
                },
                onSubmitted: (value) => analytics.logSearchQuerySubmitted(
                  surface: 'learn_explore',
                  query: value,
                ),
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
                      analytics.logFilterApplied(
                        surface: 'learn_explore',
                        filterType: 'sort',
                        filterValue: value ? 'alphabetical' : 'ranked',
                      );
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
            analytics.logFilterApplied(
              surface: 'learn_explore',
              filterType: 'category',
              filterValue: _selectedCategory?.name ?? 'all',
            );
          },
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TypeFilterChip(
              label: l10n.learnHubFilterAll,
              selected: _selectedType == null,
              onTap: () {
                setState(() => _selectedType = null);
                analytics.logFilterApplied(
                  surface: 'learn_explore',
                  filterType: 'type',
                  filterValue: 'all',
                );
              },
            ),
            for (final type in [
              LearnDiscoveryContentType.path,
              LearnDiscoveryContentType.lesson,
              LearnDiscoveryContentType.practice,
              LearnDiscoveryContentType.reflection,
              LearnDiscoveryContentType.quiz,
              LearnDiscoveryContentType.tool,
            ])
              _TypeFilterChip(
                label: _discoveryContentTypeLabel(l10n, type),
                selected: _selectedType == type,
                onTap: () => setState(() {
                  _selectedType = _selectedType == type ? null : type;
                  analytics.logFilterApplied(
                    surface: 'learn_explore',
                    filterType: 'type',
                    filterValue: _selectedType?.name ?? 'all',
                  );
                }),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TypeFilterChip(
              label: l10n.learnHubFilterAll,
              selected: _selectedAudience == null,
              onTap: () {
                setState(() => _selectedAudience = null);
                analytics.logFilterApplied(
                  surface: 'learn_explore',
                  filterType: 'audience',
                  filterValue: 'all',
                );
              },
            ),
            for (final audience in [
              LearnDiscoveryAudience.beginner,
              LearnDiscoveryAudience.general,
              LearnDiscoveryAudience.kids,
            ])
              _TypeFilterChip(
                label: _audienceLabel(l10n, audience),
                selected: _selectedAudience == audience,
                onTap: () => setState(() {
                  _selectedAudience = _selectedAudience == audience
                      ? null
                      : audience;
                  analytics.logFilterApplied(
                    surface: 'learn_explore',
                    filterType: 'audience',
                    filterValue: _selectedAudience?.name ?? 'all',
                  );
                }),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TypeFilterChip(
              label: l10n.learnHubFilterAll,
              selected: _selectedDifficulty == null,
              onTap: () {
                setState(() => _selectedDifficulty = null);
                analytics.logFilterApplied(
                  surface: 'learn_explore',
                  filterType: 'difficulty',
                  filterValue: 'all',
                );
              },
            ),
            for (final difficulty in [
              LearnDiscoveryDifficulty.startHere,
              LearnDiscoveryDifficulty.growing,
              LearnDiscoveryDifficulty.deeper,
            ])
              _TypeFilterChip(
                label: _difficultyLabel(l10n, difficulty),
                selected: _selectedDifficulty == difficulty,
                onTap: () => setState(() {
                  _selectedDifficulty = _selectedDifficulty == difficulty
                      ? null
                      : difficulty;
                  analytics.logFilterApplied(
                    surface: 'learn_explore',
                    filterType: 'difficulty',
                    filterValue: _selectedDifficulty?.name ?? 'all',
                  );
                }),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ...(bucketedResults.isEmpty
            ? <Widget>[
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _query.trim().isEmpty
                            ? l10n.learnHubExploreEmptyTitle
                            : l10n.learnHubSearchEmptyTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _query.trim().isEmpty
                            ? l10n.learnHubExploreEmptySubtitle
                            : l10n.learnHubSearchEmptySubtitle,
                      ),
                    ],
                  ),
                ),
              ]
            : <Widget>[
                for (final section in bucketedResults)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ExploreDiscoverySection(
                      section: section,
                      analytics: analytics,
                    ),
                  ),
              ]),
      ],
    );
  }

  String _discoveryContentTypeLabel(
    AppLocalizations l10n,
    LearnDiscoveryContentType contentType,
  ) {
    switch (contentType) {
      case LearnDiscoveryContentType.path:
        return l10n.learnDiscoveryTypePath;
      case LearnDiscoveryContentType.lesson:
        return l10n.learnHubContentTypeLesson;
      case LearnDiscoveryContentType.story:
        return l10n.learnHubContentTypeStory;
      case LearnDiscoveryContentType.practice:
        return l10n.learnDiscoveryTypePractice;
      case LearnDiscoveryContentType.reflection:
        return l10n.learnDiscoveryTypeReflection;
      case LearnDiscoveryContentType.quiz:
        return l10n.learnHubContentTypeQuiz;
      case LearnDiscoveryContentType.tool:
        return l10n.learnHubContentTypeTool;
      case LearnDiscoveryContentType.note:
        return l10n.learnHubContentTypeNote;
      case LearnDiscoveryContentType.faq:
        return l10n.learnHubContentTypeFaq;
      case LearnDiscoveryContentType.journey:
        return l10n.learnHubContentTypeJourney;
      case LearnDiscoveryContentType.hub:
        return l10n.learnHubContentTypeSubcategory;
    }
  }

  String _audienceLabel(
    AppLocalizations l10n,
    LearnDiscoveryAudience audience,
  ) {
    switch (audience) {
      case LearnDiscoveryAudience.general:
        return l10n.learnDiscoveryAudienceGeneral;
      case LearnDiscoveryAudience.beginner:
        return l10n.learnTrackBeginner;
      case LearnDiscoveryAudience.kids:
        return l10n.learnHubCategoryKidsLearningTitle;
    }
  }

  String _difficultyLabel(
    AppLocalizations l10n,
    LearnDiscoveryDifficulty difficulty,
  ) {
    switch (difficulty) {
      case LearnDiscoveryDifficulty.startHere:
        return l10n.learnDiscoveryDifficultyStartHere;
      case LearnDiscoveryDifficulty.growing:
        return l10n.learnDiscoveryDifficultyGrowing;
      case LearnDiscoveryDifficulty.deeper:
        return l10n.quranLearningPathIntensityDeeper;
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

class _ExploreDiscoverySection extends StatelessWidget {
  const _ExploreDiscoverySection({
    required this.section,
    required this.analytics,
  });

  final LearnDiscoveryBucketSection section;
  final LearnAnalyticsService analytics;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _sectionTitle(l10n, section.bucket),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...section.results.map(
            (result) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ExploreDiscoveryCard(
                result: result,
                bucket: section.bucket,
                analytics: analytics,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _sectionTitle(AppLocalizations l10n, LearnDiscoveryBucket bucket) {
    switch (bucket) {
      case LearnDiscoveryBucket.bestMatch:
        return l10n.learnDiscoveryBestMatchTitle;
      case LearnDiscoveryBucket.guidedPaths:
        return l10n.learnHubGuidedPathsTitle;
      case LearnDiscoveryBucket.lessonsAndPages:
        return l10n.learnDiscoveryLessonsAndPagesTitle;
      case LearnDiscoveryBucket.kids:
        return l10n.learnDiscoveryKidsResultsTitle;
      case LearnDiscoveryBucket.related:
        return l10n.learnDiscoveryRelatedContentTitle;
      case LearnDiscoveryBucket.startHere:
        return l10n.learnDiscoveryStartHereTitle;
      case LearnDiscoveryBucket.practiceAndTools:
        return l10n.learnDiscoveryPracticeAndToolsTitle;
    }
  }
}

class _ExploreDiscoveryCard extends ConsumerWidget {
  const _ExploreDiscoveryCard({
    required this.result,
    required this.bucket,
    required this.analytics,
  });

  final LearnDiscoverySearchResult result;
  final LearnDiscoveryBucket bucket;
  final LearnAnalyticsService analytics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = result.entry;
    final style = LearnHubTaxonomy.styleFor(entry.categoryId);
    final relatedPaths = ref
        .watch(localizedGuidedLearningPathsProvider)
        .where((path) => entry.relatedPathIds.contains(path.path.id))
        .take(2)
        .toList(growable: false);

    String? progressLabel;
    if (entry.contentType == LearnDiscoveryContentType.path &&
        entry.id.startsWith('path:')) {
      final pathId = entry.id.replaceFirst('path:', '');
      final progress = ref.watch(guidedLearningPathProgressProvider(pathId));
      final localizedPath = ref.watch(
        localizedGuidedLearningPathByIdProvider(pathId),
      );
      if (localizedPath != null) {
        progressLabel = l10n.guidedLearningPathProgressValue(
          progress.completedStepIds.length,
          localizedPath.path.steps.length,
        );
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        analytics.logSearchResultOpened(
          surface: 'learn_explore',
          resultId: entry.id,
          resultType: entry.contentType.name,
          domain: entry.categoryId.name,
          routeName: entry.routeTarget.routeName,
        );
        if (bucket == LearnDiscoveryBucket.related) {
          analytics.logRelatedContentOpened(
            sourceId: 'learn_explore_related',
            targetId: entry.id,
            sourceSurface: 'learn_explore',
          );
        }
        context.pushNamed(
          entry.routeTarget.routeName,
          pathParameters: entry.routeTarget.pathParameters,
          queryParameters: entry.routeTarget.queryParameters,
        );
      },
      child: PremiumCard(
        surfaceTintColor: style.accentColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 88,
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
                        entry.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _ExploreBadge(
                        label: _contentTypeLabel(l10n, entry.contentType),
                        accentColor: style.accentColor,
                      ),
                      if (entry.startHere)
                        _ExploreBadge(
                          label: l10n.learnDiscoveryDifficultyStartHere,
                          accentColor: style.accentColor,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LearnHubTaxonomy.categoryTitle(l10n, entry.categoryId),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: style.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.summary.isEmpty ? entry.subtitle : entry.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (progressLabel != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      progressLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: style.accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (relatedPaths.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Text(
                          l10n.learnDiscoveryRelatedLabel,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        for (final path in relatedPaths)
                          Text(
                            path.title,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: style.accentColor),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _contentTypeLabel(
    AppLocalizations l10n,
    LearnDiscoveryContentType contentType,
  ) {
    switch (contentType) {
      case LearnDiscoveryContentType.path:
        return l10n.learnDiscoveryTypePath;
      case LearnDiscoveryContentType.lesson:
        return l10n.learnHubContentTypeLesson;
      case LearnDiscoveryContentType.story:
        return l10n.learnHubContentTypeStory;
      case LearnDiscoveryContentType.practice:
        return l10n.learnDiscoveryTypePractice;
      case LearnDiscoveryContentType.reflection:
        return l10n.learnDiscoveryTypeReflection;
      case LearnDiscoveryContentType.quiz:
        return l10n.learnHubContentTypeQuiz;
      case LearnDiscoveryContentType.tool:
        return l10n.learnHubContentTypeTool;
      case LearnDiscoveryContentType.note:
        return l10n.learnHubContentTypeNote;
      case LearnDiscoveryContentType.faq:
        return l10n.learnHubContentTypeFaq;
      case LearnDiscoveryContentType.journey:
        return l10n.learnHubContentTypeJourney;
      case LearnDiscoveryContentType.hub:
        return l10n.learnHubContentTypeSubcategory;
    }
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
