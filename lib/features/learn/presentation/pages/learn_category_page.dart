import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../application/learn_hub_providers.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_hub_models.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../../../../shared/widgets/section_title.dart';

class LearnCategoryPage extends ConsumerWidget {
  const LearnCategoryPage({
    super.key,
    required this.categoryId,
    this.initialSubcategoryId,
    this.useSelectedSubcategoryHeader = false,
    this.showSiblingSubcategories = true,
  });

  final LearnHubCategoryId categoryId;
  final String? initialSubcategoryId;
  final bool useSelectedSubcategoryHeader;
  final bool showSiblingSubcategories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(learnHubCategoriesProvider);
    final category = categories.firstWhere((item) => item.id == categoryId);
    final style = LearnHubTaxonomy.styleFor(categoryId);
    final knowledgeItems = ref.watch(learnHubKnowledgeIndexProvider);
    final subcategories = ref
        .watch(learnHubSubcategoriesProvider)
        .where((item) => item.categoryId == categoryId)
        .toList(growable: false);
    final selectedSubcategory = _selectedSubcategory(subcategories);
    final pageTitle =
        useSelectedSubcategoryHeader && selectedSubcategory != null
        ? selectedSubcategory.title
        : category.title;
    final pageSubtitle =
        useSelectedSubcategoryHeader && selectedSubcategory != null
        ? selectedSubcategory.subtitle
        : category.subtitle;
    final shouldUseDedicatedRouteForSelection =
        selectedSubcategory != null &&
        _shouldOpenDedicatedRoute(selectedSubcategory, knowledgeItems);
    final showKnowledgeSection =
        categoryId != LearnHubCategoryId.foundations ||
        (initialSubcategoryId != null && initialSubcategoryId!.isNotEmpty);
    final filteredItems = knowledgeItems
        .where((item) => item.categoryId == categoryId)
        .where((item) => item.contentType != LearnHubContentType.category)
        .where((item) => item.contentType != LearnHubContentType.subcategory)
        .where(
          (item) => !LearnHubTaxonomy.subcategoryUsesJourneyRoute(
            l10n,
            item.subcategoryId,
          ),
        )
        .where(
          (item) =>
              initialSubcategoryId == null ||
              initialSubcategoryId!.isEmpty ||
              item.subcategoryId == initialSubcategoryId,
        )
        .where((_) => !shouldUseDedicatedRouteForSelection)
        .take(16)
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: style.icon,
      title: pageTitle,
      subtitle: pageSubtitle,
      children: [
        if (showSiblingSubcategories && subcategories.isNotEmpty) ...[
          SectionTitle(
            title: l10n.learnHubSubcategoriesSectionTitle,
            subtitle: l10n.learnHubSubcategoriesSectionSubtitle,
          ),
          const SizedBox(height: 10),
          SectionHubActionGrid(
            actions: [
              for (final subcategory in subcategories)
                SectionHubAction(
                  title: subcategory.title,
                  subtitle: subcategory.subtitle,
                  icon: style.icon,
                  color: style.baseColor,
                  accentColor: style.accentColor,
                  onTap: () => _openSubcategory(
                    context,
                    subcategory: subcategory,
                    knowledgeItems: knowledgeItems,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
        ],
        if (showKnowledgeSection) ...[
          SectionTitle(
            title: l10n.learnHubKnowledgeSectionTitle,
            subtitle: l10n.learnHubKnowledgeSectionSubtitle,
          ),
          const SizedBox(height: 10),
          if (filteredItems.isEmpty)
            selectedSubcategory != null &&
                    !_hasListableItemsForSubcategory(
                      knowledgeItems,
                      selectedSubcategory.id,
                    )
                ? _DedicatedSubcategoryCard(
                    subcategory: selectedSubcategory,
                    accentColor: style.accentColor,
                  )
                : PremiumCard(
                    surfaceTintColor: style.accentColor,
                    child: Text(l10n.learnHubCategoryEmptyState),
                  )
          else
            ...filteredItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _KnowledgeListCard(item: item),
              ),
            ),
        ],
      ],
    );
  }

  LearnHubSubcategoryDescriptor? _selectedSubcategory(
    List<LearnHubSubcategoryDescriptor> subcategories,
  ) {
    final target = initialSubcategoryId;
    if (target == null || target.isEmpty) {
      return null;
    }
    for (final item in subcategories) {
      if (item.id == target) {
        return item;
      }
    }
    return null;
  }

  bool _hasListableItemsForSubcategory(
    List<LearnHubKnowledgeItem> items,
    String subcategoryId,
  ) {
    return items.any(
      (item) =>
          item.categoryId == categoryId &&
          item.subcategoryId == subcategoryId &&
          switch (item.contentType) {
            LearnHubContentType.lesson ||
            LearnHubContentType.story ||
            LearnHubContentType.quiz ||
            LearnHubContentType.challenge ||
            LearnHubContentType.note ||
            LearnHubContentType.faq => true,
            LearnHubContentType.category ||
            LearnHubContentType.subcategory ||
            LearnHubContentType.tool ||
            LearnHubContentType.journey => false,
          },
    );
  }

  void _openSubcategory(
    BuildContext context, {
    required LearnHubSubcategoryDescriptor subcategory,
    required List<LearnHubKnowledgeItem> knowledgeItems,
  }) {
    if (!_shouldOpenDedicatedRoute(subcategory, knowledgeItems)) {
      context.pushNamed(
        'learnHubCategory',
        pathParameters: {
          'categoryId': LearnHubTaxonomy.categorySlug(categoryId),
        },
        queryParameters: {'sub': subcategory.id},
      );
      return;
    }

    context.pushNamed(
      subcategory.routeTarget.routeName,
      pathParameters: subcategory.routeTarget.pathParameters,
      queryParameters: subcategory.routeTarget.queryParameters,
    );
  }

  bool _shouldOpenDedicatedRoute(
    LearnHubSubcategoryDescriptor subcategory,
    List<LearnHubKnowledgeItem> knowledgeItems,
  ) {
    if (LearnHubTaxonomy.shouldPreferDedicatedRouteTarget(
      subcategory.routeTarget,
    )) {
      return true;
    }
    return !_hasListableItemsForSubcategory(knowledgeItems, subcategory.id);
  }
}

class _KnowledgeListCard extends StatelessWidget {
  const _KnowledgeListCard({required this.item});

  final LearnHubKnowledgeItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = LearnHubTaxonomy.styleFor(item.categoryId);
    return Semantics(
      button: true,
      label: '${item.title} ${_contentTypeLabel(l10n, item.contentType)}',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.pushNamed(
          item.routeTarget.routeName,
          pathParameters: item.routeTarget.pathParameters,
          queryParameters: item.routeTarget.queryParameters,
        ),
        child: PremiumCard(
          surfaceTintColor: style.accentColor,
          surfaceVariant: AppSurfaceVariant.card,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 56,
                decoration: BoxDecoration(
                  color: style.accentColor.withValues(alpha: 0.85),
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
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        _BadgeChip(
                          label: _contentTypeLabel(l10n, item.contentType),
                          accentColor: style.accentColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subcategoryTitle == null
                          ? LearnHubTaxonomy.categoryTitle(
                              l10n,
                              item.categoryId,
                            )
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
      ),
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

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: accentColor,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: style
          .decoration(radius: 999, includeShadow: false)
          .copyWith(
            border: Border.all(color: accentColor.withValues(alpha: 0.22)),
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

class _DedicatedSubcategoryCard extends StatelessWidget {
  const _DedicatedSubcategoryCard({
    required this.subcategory,
    required this.accentColor,
  });

  final LearnHubSubcategoryDescriptor subcategory;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.pushNamed(
        subcategory.routeTarget.routeName,
        pathParameters: subcategory.routeTarget.pathParameters,
        queryParameters: subcategory.routeTarget.queryParameters,
      ),
      child: PremiumCard(
        surfaceTintColor: accentColor,
        surfaceVariant: AppSurfaceVariant.card,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subcategory.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(subcategory.subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
