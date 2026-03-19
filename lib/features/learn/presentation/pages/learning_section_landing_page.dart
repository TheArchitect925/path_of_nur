import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../journey/application/learning_journey_progress_provider.dart';
import '../../journey/data/learning_journey_localized_metadata.dart';
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
    final continueState = ref.watch(learningJourneyContinueProvider);
    final recommendations = ref.watch(learningJourneyRecommendationsProvider);
    final journeyProgress = ref.watch(learningJourneyProgressProvider);
    final categories = ref.watch(learnHubCategoriesProvider);
    final searchIndex = ref.watch(learnHubKnowledgeIndexProvider);
    final featuredItems = ref.watch(learnHubFeaturedItemsProvider);
    final summary = ref.watch(learnUnifiedSummaryV2Provider);

    final searchResults = filterLearnHubKnowledgeItems(
      items: searchIndex,
      query: _query,
    ).where((item) => item.contentType != LearnHubContentType.category).take(6).toList(
          growable: false,
        );

    return LearnHubPageScaffold(
      headerIcon: Icons.school_rounded,
      title: l10n.learnHubTitle,
      subtitle: l10n.learnHubLandingSubtitleV3,
      quote: buildLearningCompactQuote(),
      shortcutActions: [
        if (continueState.hasJourney &&
            continueState.journey != null &&
            continueState.stage != null)
          LearnHubShortcutAction(
            label: l10n.learningJourneyCardActionContinue,
            supportingText: continueState.stage!.title,
            icon: Icons.history_edu_rounded,
            onTap: () => context.pushNamed(
              'learnJourneyStage',
              pathParameters: {
                'journeyId': continueState.journey!.id,
                'stageId': continueState.stage!.id,
              },
            ),
          ),
        LearnHubShortcutAction(
          label: l10n.learnHubExploreAllAction,
          supportingText: l10n.learnHubCategoryToolsExploreTitle,
          icon: Icons.travel_explore_rounded,
          onTap: () => context.pushNamed('learnExploreAllKnowledge'),
        ),
      ],
      children: [
        _SectionHeader(
          title: l10n.learnHubJourneysSectionTitle,
          subtitle: l10n.learnHubJourneysSectionSubtitle,
        ),
        const SizedBox(height: 10),
        _JourneySection(
          continueState: continueState,
          recommendations: recommendations,
          completedStageIds: journeyProgress.completedStageIds,
        ),
        const SizedBox(height: 18),
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
        ...featuredItems.take(4).map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SearchResultTile(item: item),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.pushNamed('learnExploreAllKnowledge'),
          child: PremiumCard(
            surfaceVariant: AppSurfaceVariant.featureTile,
            child: Row(
              children: [
                const Icon(Icons.explore_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.learnHubExploreAllAction,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.learnHubExploreAllSubtitle),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ],
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

class _JourneySection extends StatelessWidget {
  const _JourneySection({
    required this.continueState,
    required this.recommendations,
    required this.completedStageIds,
  });

  final LearningJourneyContinueState continueState;
  final LearningJourneyRecommendationSet recommendations;
  final Set<String> completedStageIds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentJourney = continueState.journey;
    final recommended = recommendations.journeys.isEmpty
        ? null
        : recommendations.journeys.first;
    return Column(
      children: [
        if (currentJourney != null)
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed(
              'learnJourneyDetail',
              pathParameters: {'journeyId': currentJourney.id},
            ),
            child: PremiumCard(
              surfaceVariant: AppSurfaceVariant.panel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.learnHubJourneysCurrentLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    localizedJourneyTitle(context, currentJourney),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(localizedJourneySubtitle(context, currentJourney)),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: journeyProgressRatio(
                      completedStageIds: completedStageIds,
                      stageIds: currentJourney.stageIds,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: continueState.stage == null
                            ? null
                            : () => context.pushNamed(
                                'learnJourneyStage',
                                pathParameters: {
                                  'journeyId': currentJourney.id,
                                  'stageId': continueState.stage!.id,
                                },
                              ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(l10n.learnHubJourneysContinueAction),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => context.pushNamed(
                          'learnJourneyDetail',
                          pathParameters: {'journeyId': currentJourney.id},
                        ),
                        icon: const Icon(Icons.route_rounded),
                        label: Text(l10n.learnHubJourneysCurrentAction),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => context.pushNamed('learnJourneyHome'),
                        icon: const Icon(Icons.swap_horiz_rounded),
                        label: Text(l10n.learnHubJourneysChangeAction),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => context.pushNamed('learnJourneyHome'),
                        icon: const Icon(Icons.grid_view_rounded),
                        label: Text(l10n.learnHubJourneysBrowseAction),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (recommended != null) ...[
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed(
              'learnJourneyDetail',
              pathParameters: {'journeyId': recommended.id},
            ),
            child: PremiumCard(
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.learnHubJourneysRecommendedLabel,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localizedJourneyTitle(context, recommended),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          localizedJourneySubtitle(context, recommended),
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
        ],
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
