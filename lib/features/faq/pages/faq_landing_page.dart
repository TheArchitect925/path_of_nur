import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/display/compact_list_tile.dart';
import '../../../shared/widgets/section_title.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../models/faq_item.dart';
import '../providers/faq_providers.dart';
import '../widgets/faq_category_card.dart';
import '../widgets/faq_question_tile.dart';
import '../../../core/theme/app_icons.dart';

class FaqLandingPage extends ConsumerStatefulWidget {
  const FaqLandingPage({super.key});

  @override
  ConsumerState<FaqLandingPage> createState() => _FaqLandingPageState();
}

class _FaqLandingPageState extends ConsumerState<FaqLandingPage> {
  late final TextEditingController _searchController;
  bool _searchOpen = false;

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
    final query = _searchController.text.trim();
    final categoriesAsync = ref.watch(faqCategorySummariesProvider);
    final featuredAsync = ref.watch(featuredFaqItemsProvider);
    final searchAsync = ref.watch(
      faqSearchProvider(FaqSearchQuery(query: query)),
    );

    return LearnHubPageScaffold(
      quote: null,
      showDefaultQuote: false,
      headerIcon: AppIcons.faq,
      title: l10n.batch9FaqTitle,
      subtitle: l10n.batch9FaqSubtitle,
      headerActions: [
        IconButton(
          key: const ValueKey('faq-header-search'),
          tooltip: l10n.learningJourneyToolSearchTitle,
          onPressed: () => setState(() {
            _searchOpen = !_searchOpen;
            if (!_searchOpen) _searchController.clear();
          }),
          icon: Icon(
            _searchOpen ? Icons.search_off_rounded : Icons.search_rounded,
          ),
        ),
      ],
      children: [
        if (_searchOpen) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.batch9FaqScholarNote,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 10),
                _searchField(context),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (query.isNotEmpty)
          searchAsync.when(
            data: (results) => _searchResults(context, results, query),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _errorCard(error),
          )
        else ...[
          CompactListTile(
            title: l10n.batch9FaqBrowseAllAction,
            subtitle: l10n.batch9FaqBrowseAllSubtitle,
            leading: const Icon(Icons.travel_explore_rounded),
            onTap: () => context.pushNamed(
              'learnExploreAllKnowledge',
              queryParameters: const {'category': 'faq'},
            ),
          ),
          const SizedBox(height: 12),
          _sectionTitle(
            context,
            l10n.batch9FaqFeaturedTitle,
            l10n.batch9FaqFeaturedSubtitle,
          ),
          const SizedBox(height: 8),
          featuredAsync.when(
            data: (items) => _featuredRow(context, items),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _errorCard(error),
          ),
          const SizedBox(height: 12),
          _sectionTitle(
            context,
            l10n.batch9FaqBrowseTitle,
            l10n.batch9FaqBrowseSubtitle,
          ),
          const SizedBox(height: 8),
          categoriesAsync.when(
            data: (categories) => LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 1040
                    ? 3
                    : (width >= 620 ? 2 : 1);
                // Rows of equal-height cards that size to their content —
                // a fixed grid extent overflows the moment text wraps once
                // more than expected (large type, verbose locales).
                final rows = <Widget>[];
                for (var i = 0; i < categories.length; i += crossAxisCount) {
                  final slice = categories.skip(i).take(crossAxisCount);
                  rows.add(
                    Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final (j, summary) in slice.indexed) ...[
                              if (j > 0) const SizedBox(width: 10),
                              Expanded(
                                child: FaqCategoryCard(
                                  summary: summary,
                                  icon: _categoryIcon(summary.id),
                                  onTap: () => context.pushNamed(
                                    'faqCategory',
                                    pathParameters: {'categoryId': summary.id},
                                  ),
                                ),
                              ),
                            ],
                            for (
                              var j = slice.length;
                              j < crossAxisCount;
                              j += 1
                            ) ...[
                              const SizedBox(width: 10),
                              const Expanded(child: SizedBox.shrink()),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Column(children: rows);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _errorCard(error),
          ),
        ],
      ],
    );
  }

  Widget _searchField(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Icon(
          Icons.search_rounded,
          color: context.palette.onSurface.withValues(alpha: 0.75),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: l10n.batch9FaqSearchHint,
              isCollapsed: true,
            ),
          ),
        ),
        if (_searchController.text.isNotEmpty)
          IconButton(
            onPressed: () => setState(() => _searchController.clear()),
            icon: const Icon(Icons.close_rounded),
          ),
      ],
    );
  }

  Widget _featuredRow(BuildContext context, List<FaqItem> items) {
    final l10n = AppLocalizations.of(context);
    if (items.isEmpty) {
      return PremiumCard(child: Text(l10n.batch9FaqFeaturedEmpty));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .take(8)
            .map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 280,
                  child: FaqQuestionTile(
                    item: item,
                    onTap: () => context.pushNamed(
                      'faqDetail',
                      pathParameters: {'faqId': item.id},
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }

  Widget _searchResults(
    BuildContext context,
    List<FaqItem> results,
    String query,
  ) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          context,
          l10n.batch9FaqSearchResultsTitle,
          l10n.batch9FaqSearchResultsSubtitle,
        ),
        const SizedBox(height: 8),
        if (results.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.batch9FaqSearchEmptyTitle),
                const SizedBox(height: 6),
                Text(
                  l10n.batch9FaqSearchEmptySubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          )
        else
          ...results.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FaqQuestionTile(
                item: item,
                onTap: () => context.pushNamed(
                  'faqDetail',
                  pathParameters: {'faqId': item.id},
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title, String subtitle) {
    return SectionTitle(title: title, subtitle: subtitle);
  }

  Widget _errorCard(Object error) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(child: Text(l10n.batch9FaqLoadError(error.toString())));
  }

  IconData _categoryIcon(String categoryId) {
    switch (categoryId) {
      case 'foundations_of_islam':
        return AppIcons.mosque;
      case 'worship_and_practice':
        return Icons.front_hand_rounded;
      case 'misconceptions_about_islam':
        return Icons.lightbulb_outline_rounded;
      case 'women_in_islam':
        return Icons.groups_2_rounded;
      case 'science_and_quran':
        return Icons.travel_explore_rounded;
      case 'quran_and_revelation':
        return Icons.menu_book_rounded;
      case 'prophets_and_history':
        return Icons.history_edu_rounded;
      case 'ethics_and_lifestyle':
        return AppIcons.character;
      case 'afterlife_and_purpose':
        return Icons.nightlight_round_rounded;
      case 'islam_in_the_modern_world':
        return Icons.public_rounded;
      default:
        return AppIcons.faq;
    }
  }
}
