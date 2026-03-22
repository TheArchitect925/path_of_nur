import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../../shared/domain/learn_system_models.dart';
import '../application/learn_hub_providers.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_hub_models.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class LearningSectionLandingPage extends ConsumerStatefulWidget {
  const LearningSectionLandingPage({super.key});

  @override
  ConsumerState<LearningSectionLandingPage> createState() =>
      _LearningSectionLandingPageState();
}

class _LearningSectionLandingPageState
    extends ConsumerState<LearningSectionLandingPage> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
    final searchIndex = ref.watch(learnHubKnowledgeIndexProvider);
    final featuredItems = ref.watch(learnHubFeaturedItemsProvider);
    final summary = ref.watch(learnUnifiedSummaryV2Provider);
    final visibilityPolicy = ref.watch(
      activeFamilyLearningContextProvider.select((value) => value.visibilityPolicy),
    );

    final searchResults = filterLearnHubKnowledgeItems(
      items: searchIndex,
      query: _query,
    ).where((item) => item.contentType != LearnHubContentType.category)
        .where((item) => !_isJourneyManagedLearnItem(item, l10n))
        .take(6).toList(
          growable: false,
        );
    final suggestedItems = featuredItems
        .where((item) => !_isJourneyManagedLearnItem(item, l10n))
        .take(4)
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: Icons.school_rounded,
      title: l10n.learnHubTitle,
      subtitle: l10n.learnHubLandingSubtitleV3,
      quoteHeader: const LearningHubRabbiZidniIlmaHeader(),
      children: [
        _SectionHeader(
          title: l10n.learnHubSearchSectionTitle,
          subtitle: l10n.learnHubSearchSectionSubtitle,
        ),
        const SizedBox(height: 10),
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: l10n.learnHubSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.trim().isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  border: InputBorder.none,
                ),
              ),
              if (_query.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                if (searchResults.isEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l10n.learnHubSearchEmptySubtitle),
                  )
                else
                  ...searchResults.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SearchResultTile(item: item),
                    ),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (summary.continueItem != null) ...[
          _SectionHeader(
            title: l10n.learnHubContinueLearningTitle,
            subtitle: l10n.learnHubContinueLearningSubtitle,
          ),
          const SizedBox(height: 10),
          _ContinueLearningCard(item: summary.continueItem!),
          const SizedBox(height: 18),
        ],
        _SectionHeader(
          title: l10n.learnHubCategoriesSectionTitle,
          subtitle: l10n.learnHubCategoriesSectionSubtitle,
        ),
        const SizedBox(height: 10),
        SectionHubActionGrid(
          actions: [
            SectionHubAction(
              title: l10n.learnHubJourneyIslandTitle,
              subtitle: l10n.learnHubJourneyIslandSubtitle,
              icon: Icons.route_rounded,
              color: const Color(0xFFE8E3F3),
              accentColor: const Color(0xFF6D57A6),
              onTap: () => context.pushNamed('learnJourneyIslandHub'),
            ),
            SectionHubAction(
              title: l10n.learnHubExploreAllTitle,
              subtitle: l10n.learnHubExploreAllSubtitle,
              icon: Icons.travel_explore_rounded,
              color: const Color(0xFFE0EEF0),
              accentColor: const Color(0xFF2E7380),
              onTap: () => context.pushNamed('learnExploreAllKnowledge'),
            ),
            SectionHubAction(
              title: l10n.learnGamesIslandTitle,
              subtitle: l10n.learnGamesIslandLandingCardSubtitle,
              icon: Icons.sports_esports_rounded,
              color: const Color(0xFFF3E7D5),
              accentColor: const Color(0xFFB56C17),
              onTap: visibilityPolicy.isChildProfile
                  ? () => context.pushNamed('learnKidsGames')
                  : () => context.pushNamed('learnGamesIsland'),
            ),
            SectionHubAction(
              title: l10n.historyArchiveTitle,
              subtitle: l10n.historyLearnIslandSubtitle,
              icon: Icons.history_edu_rounded,
              color: const Color(0xFFECE6D9),
              accentColor: const Color(0xFF7C5F3C),
              onTap: () => context.pushNamed('learnHistoryArchive'),
            ),
            for (final category in categories)
              SectionHubAction(
                title: category.title,
                subtitle: category.subtitle,
                icon: LearnHubTaxonomy.styleFor(category.id).icon,
                color: LearnHubTaxonomy.styleFor(category.id).baseColor,
                accentColor: LearnHubTaxonomy.styleFor(category.id).accentColor,
                onTap: () => context.pushNamed(
                  category.routeTarget.routeName,
                  pathParameters: category.routeTarget.pathParameters,
                  queryParameters: category.routeTarget.queryParameters,
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.learnHubSuggestedSectionTitle,
          subtitle: l10n.learnHubSuggestedSectionSubtitle,
        ),
        const SizedBox(height: 10),
        ...suggestedItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SearchResultTile(item: item),
          ),
        ),
      ],
    );
  }

  bool _isJourneyManagedLearnItem(
    LearnHubKnowledgeItem item,
    AppLocalizations l10n,
  ) {
    if (item.contentType == LearnHubContentType.journey) {
      return true;
    }
    return LearnHubTaxonomy.subcategoryUsesJourneyRoute(
      l10n,
      item.subcategoryId,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.item});

  final LearnUnifiedContentItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: item.routeName == null
          ? null
          : () => context.pushNamed(
              item.routeName!,
              pathParameters: item.pathParameters,
              queryParameters: item.queryParameters,
            ),
      child: PremiumCard(
        child: Row(
          children: [
            const Icon(Icons.menu_book_rounded),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.summary,
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

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.item});

  final LearnHubKnowledgeItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = LearnHubTaxonomy.styleFor(item.categoryId);
    return Semantics(
      button: true,
      label: '${item.title} ${_contentTypeLabel(l10n, item.contentType)}',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.pushNamed(
          item.routeTarget.routeName,
          pathParameters: item.routeTarget.pathParameters,
          queryParameters: item.routeTarget.queryParameters,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: style.baseColor.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: style.accentColor.withValues(alpha: 0.16)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 56,
                decoration: BoxDecoration(
                  color: style.accentColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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
                    const SizedBox(height: 4),
                    Text(
                      item.summary.isEmpty ? item.subtitle : item.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: style.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _contentTypeLabel(l10n, item.contentType),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: style.accentColor,
                    fontWeight: FontWeight.w700,
                  ),
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
