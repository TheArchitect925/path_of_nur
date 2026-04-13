import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/main_page_search_launcher.dart';
import '../../../../shared/widgets/main_page_shortcut_configs.dart';
import '../../../../shared/widgets/main_page_shortcut_stack.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../analytics/domain/learn_analytics_models.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../journey/domain/family_learning_models.dart';
import '../application/learn_discovery_providers.dart';
import '../data/learn_hub_taxonomy.dart';
import '../models/learn_discovery_models.dart';
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
  bool _loggedSearchOpen = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(learnAnalyticsServiceProvider)
          .logLandingViewed(surface: 'learn_landing');
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
    final headerIconSize =
        (Theme.of(context).textTheme.titleLarge?.fontSize ?? 22) * 1.2;
    final discoveryIndex = ref.watch(learnDiscoveryIndexProvider);
    final visibilityPolicy = ref.watch(learnHubVisibilityPolicyProvider);
    final visibleActions = visibilityPolicy.isChildProfile
        ? _kidsVisibleActions(context, l10n)
        : _mainIslandActions(context, l10n);

    final searchResults =
        searchLearnDiscoveryEntries(entries: discoveryIndex, query: _query)
            .where((item) => !_isJourneyManagedDiscoveryItem(item.entry))
            .take(6)
            .toList(growable: false);
    return LearnHubPageScaffold(
      headerIcon: Icons.school_rounded,
      headerIconSize: headerIconSize,
      headerIconSpacing: 10,
      headerAlignment: AppPageHeaderAlignment.center,
      title: l10n.learnHubTitle,
      subtitle: l10n.learnHubLandingCalmSubtitle,
      quoteHeader: const LearningHubRabbiZidniIlmaHeader(),
      floatingBottom: MainPageShortcutStack(
        items: buildLearnPageShortcuts(l10n),
        openLabel: l10n.learnShortcutOpen,
        closeLabel: l10n.learnShortcutClose,
      ),
      children: [
        MainPageSearchLauncher(
          destinations: [
            MainPageSearchDestination(
              title: l10n.learnHubLandingExploreAllTitle,
              subtitle: l10n.learnHubLandingExploreAllSubtitle,
              icon: Icons.travel_explore_rounded,
              keywords: ['explore', 'browse', 'all knowledge'],
              onTap: () => context.pushNamed('learnExploreAllKnowledge'),
            ),
            ...visibleActions.map(
              (action) => MainPageSearchDestination(
                title: action.title,
                subtitle: action.subtitle,
                icon: action.icon,
                keywords: [action.title, action.subtitle],
                onTap: action.onTap,
              ),
            ),
            MainPageSearchDestination(
              title: l10n.learnNotesSectionTitle,
              subtitle: l10n.learnNotesSectionSubtitle,
              icon: Icons.notes_rounded,
              keywords: ['notes', 'saved', 'journal'],
              onTap: () => context.pushNamed('learnNotesLanding'),
            ),
            MainPageSearchDestination(
              title: l10n.batch9FaqTitle,
              subtitle: l10n.batch9FaqSubtitle,
              icon: Icons.help_outline_rounded,
              keywords: ['faq', 'questions', 'answers'],
              onTap: () => context.pushNamed('faqLanding'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.learnHubVisibleIslandsTitle,
          subtitle: visibilityPolicy.isChildProfile
              ? l10n.learnHubVisibleKidsIslandsSubtitle
              : l10n.learnHubVisibleIslandsSubtitle,
        ),
        const SizedBox(height: 10),
        SectionHubActionGrid(actions: visibleActions),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.learnHubLandingExploreAllTitle,
          subtitle: l10n.learnHubLandingExploreAllSubtitle,
        ),
        const SizedBox(height: 10),
        _ExploreAllCard(
          searchController: _searchController,
          query: _query,
          searchResults: searchResults,
          onQueryChanged: (value) => setState(() => _query = value),
          onSearchOpened: () {
            if (_loggedSearchOpen) return;
            _loggedSearchOpen = true;
            ref
                .read(learnAnalyticsServiceProvider)
                .logSearchOpened(surface: 'learn_landing');
          },
          onQuerySubmitted: (value) => ref
              .read(learnAnalyticsServiceProvider)
              .logSearchQuerySubmitted(surface: 'learn_landing', query: value),
          onClearQuery: () {
            _searchController.clear();
            setState(() => _query = '');
          },
          onOpenExploreAll: () => context.pushNamed('learnExploreAllKnowledge'),
          onOpenNotes: () => context.pushNamed('learnNotesLanding'),
          onOpenFaq: () => context.pushNamed('faqLanding'),
          onOpenLegacy: () => context.pushNamed('learnLegacy'),
          analytics: ref.read(learnAnalyticsServiceProvider),
        ),
      ],
    );
  }

  bool _isJourneyManagedDiscoveryItem(LearnDiscoveryIndexEntry entry) {
    if (entry.contentType == LearnDiscoveryContentType.path ||
        entry.contentType == LearnDiscoveryContentType.journey) {
      return false;
    }
    return entry.contentType == LearnDiscoveryContentType.hub &&
        entry.routeTarget.routeName == 'learnJourneyIslandHub';
  }
}

final learnHubVisibilityPolicyProvider =
    Provider<FamilyLearningVisibilityPolicy>(
      (ref) => ref.watch(
        activeFamilyLearningContextProvider.select(
          (value) => value.visibilityPolicy,
        ),
      ),
    );

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

class _ExploreAllCard extends StatelessWidget {
  const _ExploreAllCard({
    required this.searchController,
    required this.query,
    required this.searchResults,
    required this.onQueryChanged,
    required this.onSearchOpened,
    required this.onQuerySubmitted,
    required this.onClearQuery,
    required this.onOpenExploreAll,
    required this.onOpenNotes,
    required this.onOpenFaq,
    required this.onOpenLegacy,
    required this.analytics,
  });

  final TextEditingController searchController;
  final String query;
  final List<LearnDiscoverySearchResult> searchResults;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSearchOpened;
  final ValueChanged<String> onQuerySubmitted;
  final VoidCallback onClearQuery;
  final VoidCallback onOpenExploreAll;
  final VoidCallback onOpenNotes;
  final VoidCallback onOpenFaq;
  final VoidCallback onOpenLegacy;
  final LearnAnalyticsService analytics;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppHeroGlassShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnHubLandingExploreAllTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(l10n.learnHubLandingExploreAllSubtitle),
          const SizedBox(height: 10),
          TextField(
            controller: searchController,
            onChanged: onQueryChanged,
            onTap: onSearchOpened,
            onSubmitted: onQuerySubmitted,
            decoration: InputDecoration(
              hintText: l10n.learnHubSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.trim().isEmpty
                  ? null
                  : IconButton(
                      onPressed: onClearQuery,
                      icon: const Icon(Icons.close_rounded),
                    ),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.learnHubExploreQuickAccessTitle,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppLayeredGlassPillButton(
                onPressed: () {
                  analytics.logExploreSectionOpened(
                    sectionId: 'quick_access_explore_all',
                    sourceSurface: 'learn_landing',
                  );
                  onOpenExploreAll();
                },
                leading: const Icon(Icons.travel_explore_rounded, size: 18),
                label: l10n.learnHubLandingExploreAllAction,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.learnHubExploreSupportTitle,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppLayeredGlassPillButton(
                onPressed: () {
                  analytics.logExploreSectionOpened(
                    sectionId: 'support_notes',
                    sourceSurface: 'learn_landing',
                  );
                  onOpenNotes();
                },
                leading: const Icon(Icons.sticky_note_2_outlined, size: 18),
                label: l10n.learnHubCategoryNotesTitle,
              ),
              AppLayeredGlassPillButton(
                onPressed: () {
                  analytics.logExploreSectionOpened(
                    sectionId: 'support_faq',
                    sourceSurface: 'learn_landing',
                  );
                  onOpenFaq();
                },
                leading: const Icon(Icons.help_outline_rounded, size: 18),
                label: l10n.learnHubCategoryFaqTitle,
              ),
              AppLayeredGlassPillButton(
                onPressed: () {
                  analytics.logLegacyRouteOpened(
                    routeKey: '/learn/legacy',
                    matchedLocation: '/learn/legacy',
                  );
                  onOpenLegacy();
                },
                leading: const Icon(Icons.library_books_rounded, size: 18),
                label: l10n.learnHubLandingLibraryAction,
              ),
            ],
          ),
          if (query.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.learnHubExploreSearchResultsTitle,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (searchResults.isEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.learnHubSearchEmptySubtitle),
              )
            else
              ...searchResults.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SearchResultTile(
                    result: item,
                    analytics: analytics,
                    sourceSurface: 'learn_landing',
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

extension on _LearningSectionLandingPageState {
  List<SectionHubAction> _mainIslandActions(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final analytics = ref.read(learnAnalyticsServiceProvider);
    final foundationsStyle = LearnHubTaxonomy.styleFor(
      LearnHubCategoryId.foundations,
    );
    final quranStyle = LearnHubTaxonomy.styleFor(
      LearnHubCategoryId.quranHadith,
    );
    final storiesStyle = LearnHubTaxonomy.styleFor(
      LearnHubCategoryId.prophetsStories,
    );
    final gamesStyle = LearnHubTaxonomy.styleFor(
      LearnHubCategoryId.quizzesChallenges,
    );

    return [
      SectionHubAction(
        title: l10n.learnHubMainIslandLearningPathTitle,
        subtitle: l10n.learnHubMainIslandLearningPathSubtitle,
        icon: foundationsStyle.icon,
        color: foundationsStyle.baseColor,
        accentColor: foundationsStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'island_learning_path',
            sourceSurface: 'learn_landing_islands',
            domain: 'journeys',
            audience: LearnAnalyticsAudience.beginner,
          );
          context.pushNamed('learnJourneyIslandHub');
        },
      ),
      SectionHubAction(
        title: l10n.learnHubMainIslandSelfLearningTitle,
        subtitle: l10n.learnHubMainIslandSelfLearningSubtitle,
        icon: quranStyle.icon,
        color: quranStyle.baseColor,
        accentColor: quranStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'island_self_learning',
            sourceSurface: 'learn_landing_islands',
            domain: 'self_learning',
          );
          context.pushNamed('learnLegacy');
        },
      ),
      SectionHubAction(
        title: l10n.learnHubMainIslandQuizzesGamesTitle,
        subtitle: l10n.learnHubMainIslandQuizzesGamesSubtitle,
        icon: Icons.sports_esports_rounded,
        color: gamesStyle.baseColor,
        accentColor: gamesStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'island_quizzes_games',
            sourceSurface: 'learn_landing_islands',
            domain: 'quizzes_games',
          );
          context.pushNamed('learnQuizzesHub');
        },
      ),
      SectionHubAction(
        title: l10n.learnHubMainIslandKidsLearningTitle,
        subtitle: l10n.learnHubMainIslandKidsLearningSubtitle,
        icon: storiesStyle.icon,
        color: storiesStyle.baseColor,
        accentColor: storiesStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'island_kids_learning',
            sourceSurface: 'learn_landing_islands',
            domain: 'kids',
            audience: LearnAnalyticsAudience.kids,
          );
          context.pushNamed(
            'learnHubCategory',
            pathParameters: {'categoryId': 'kids-learning'},
          );
        },
      ),
    ];
  }

  List<SectionHubAction> _kidsVisibleActions(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final analytics = ref.read(learnAnalyticsServiceProvider);
    final kidsStyle = LearnHubTaxonomy.styleFor(
      LearnHubCategoryId.kidsLearning,
    );
    final gamesStyle = LearnHubTaxonomy.styleFor(
      LearnHubCategoryId.quizzesChallenges,
    );
    return [
      SectionHubAction(
        title: l10n.learnHubSubcategoryKidsQuranTitle,
        subtitle: l10n.learnHubSubcategoryKidsQuranSubtitle,
        icon: Icons.menu_book_rounded,
        color: kidsStyle.baseColor,
        accentColor: kidsStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'kids_island_quran',
            sourceSurface: 'learn_landing_islands',
            domain: 'kids',
            audience: LearnAnalyticsAudience.kids,
          );
          context.pushNamed('learnKidsQuran');
        },
      ),
      SectionHubAction(
        title: l10n.learnHubSubcategoryKidsArabicLearningTitle,
        subtitle: l10n.learnHubSubcategoryKidsArabicLearningSubtitle,
        icon: Icons.translate_rounded,
        color: kidsStyle.baseColor,
        accentColor: kidsStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'kids_island_arabic',
            sourceSurface: 'learn_landing_islands',
            domain: 'kids',
            audience: LearnAnalyticsAudience.kids,
          );
          context.pushNamed('learnKidsArabicLearning');
        },
      ),
      SectionHubAction(
        title: l10n.learnHubSubcategoryKidsStoriesTitle,
        subtitle: l10n.learnHubSubcategoryKidsStoriesSubtitle,
        icon: Icons.auto_stories_rounded,
        color: kidsStyle.baseColor,
        accentColor: kidsStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'kids_island_stories',
            sourceSurface: 'learn_landing_islands',
            domain: 'stories',
            audience: LearnAnalyticsAudience.kids,
          );
          context.pushNamed('kidsStoryLibrary');
        },
      ),
      SectionHubAction(
        title: l10n.learnHubSubcategoryKidsHadithTitle,
        subtitle: l10n.learnHubSubcategoryKidsHadithSubtitle,
        icon: Icons.menu_book_outlined,
        color: kidsStyle.baseColor,
        accentColor: kidsStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'kids_island_hadith',
            sourceSurface: 'learn_landing_islands',
            domain: 'kids',
            audience: LearnAnalyticsAudience.kids,
          );
          context.pushNamed('learnKidsHadith');
        },
      ),
      SectionHubAction(
        title: l10n.learnHubSubcategoryKidsGamesTitle,
        subtitle: l10n.learnHubSubcategoryKidsGamesSubtitle,
        icon: Icons.sports_esports_rounded,
        color: gamesStyle.baseColor,
        accentColor: gamesStyle.accentColor,
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'kids_island_games',
            sourceSurface: 'learn_landing_islands',
            domain: 'games',
            audience: LearnAnalyticsAudience.kids,
          );
          context.pushNamed('learnKidsGames');
        },
      ),
      SectionHubAction(
        title: l10n.learnHubLandingExploreAllTitle,
        subtitle: l10n.learnHubLandingExploreAllSubtitle,
        icon: Icons.travel_explore_rounded,
        color: const Color(0xFFE0EEF0),
        accentColor: const Color(0xFF2E7380),
        onTap: () {
          analytics.logPrimaryCardOpened(
            cardId: 'kids_island_explore_all',
            sourceSurface: 'learn_landing_islands',
            domain: 'explore',
            audience: LearnAnalyticsAudience.kids,
          );
          context.pushNamed('learnExploreAllKnowledge');
        },
      ),
    ];
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.result,
    required this.analytics,
    required this.sourceSurface,
  });

  final LearnDiscoverySearchResult result;
  final LearnAnalyticsService analytics;
  final String sourceSurface;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = result.entry;
    final style = LearnHubTaxonomy.styleFor(item.categoryId);
    return Semantics(
      button: true,
      label: '${item.title} ${_contentTypeLabel(l10n, item.contentType)}',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          analytics.logSearchResultOpened(
            surface: sourceSurface,
            resultId: item.id,
            resultType: item.contentType.name,
            domain: item.categoryId.name,
            routeName: item.routeTarget.routeName,
          );
          context.pushNamed(
            item.routeTarget.routeName,
            pathParameters: item.routeTarget.pathParameters,
            queryParameters: item.routeTarget.queryParameters,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: style.baseColor.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: style.accentColor.withValues(alpha: 0.16),
            ),
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
                      LearnHubTaxonomy.categoryTitle(l10n, item.categoryId),
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
