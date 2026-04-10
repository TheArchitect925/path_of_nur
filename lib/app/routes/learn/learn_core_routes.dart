import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/learn/analytics/application/learn_analytics_service.dart';
import '../../../features/history/presentation/history_archive_page.dart';
import '../../../features/history/presentation/history_event_detail_page.dart';
import '../../../features/history/presentation/on_this_day_matches_page.dart';
import '../../../features/learn/content/presentation/islamic_guides_page.dart';
import '../../../features/learn/content/presentation/quran_lessons_mapping_page.dart';
import '../../../features/learn/glossary/presentation/glossary_page.dart';
import '../../../features/learn/journey/presentation/family_learning_management_page.dart';
import '../../../features/learn/journey/presentation/learning_journey_detail_page.dart';
import '../../../features/learn/journey/presentation/learning_journey_home_page.dart';
import '../../../features/learn/journey/presentation/learning_journey_island_page.dart';
import '../../../features/learn/journey/presentation/learning_journey_stage_page.dart';
import '../../../features/learn/knowledge_games/content_expansion/presentation/internal_content_builder_page.dart';
import '../../../features/learn/presentation/data/learn_hub_taxonomy.dart';
import '../../../features/learn/presentation/pages/games_island_page.dart';
import '../../../features/learn/presentation/pages/learn_category_page.dart';
import '../../../features/learn/presentation/pages/learn_explore_all_knowledge_page.dart';
import '../../../features/learn/presentation/pages/learn_games_browse_all_page.dart';
import '../../../features/learn/presentation/pages/learn_quran_hub_page.dart';
import '../../../features/learn/presentation/pages/learn_self_learning_hub_page.dart';
import '../../../features/learn/presentation/pages/learning_journey_island_hub_page.dart';
import '../../../features/learn/presentation/pages/learning_section_landing_page.dart';
import '../../../features/learn/guided_paths/presentation/daily_dhikr_path_next_steps_page.dart';
import '../../../features/learn/guided_paths/presentation/foundations_path_next_steps_page.dart';
import '../../../features/learn/guided_paths/presentation/guided_learning_path_detail_page.dart';
import '../../../features/learn/guided_paths/presentation/kids_starter_path_bridge_page.dart';
import '../../../features/learn/guided_paths/presentation/kids_starter_path_next_steps_page.dart';
import '../../../features/learn/guided_paths/presentation/quran_beginner_soft_bridge_page.dart';
import '../../../features/learn/guided_paths/presentation/stories_path_bridge_page.dart';
import '../../../features/learn/guided_paths/presentation/stories_path_next_steps_page.dart';
import '../../../features/learn/quran/presentation/quran_ayah_insights_browse_page.dart';
import '../../../features/learn/quran/presentation/quran_ayah_insights_paths_page.dart';
import '../../../features/learn/quran/presentation/quran_daily_companion_page.dart';
import '../../../features/learn/quran/presentation/quran_knowledge_search_page.dart';
import '../../../features/learn/quran/presentation/quran_learning_paths_page.dart';
import '../../../features/learn/quran/presentation/quran_summary_page.dart';
import '../../../features/learn/quran/presentation/quran_surah_summary_detail_page.dart';
import '../../../features/learn/quran/presentation/quran_guided_passage_readiness_page.dart';
import '../../../features/learn/quran/presentation/quran_readiness_bridge_page.dart';
import '../../../features/learn/quran/presentation/quran_short_surah_readiness_page.dart';
import '../../../features/learn/quran_teaching/data/quran_teaching_seed_data.dart';
import '../../../features/learn/quran_teaching/presentation/quran_teaching_beginner_words_page.dart';
import '../../../features/learn/quran_teaching/presentation/quran_teaching_daily_review_page.dart';
import '../../../features/learn/quran_teaching/presentation/quran_teaching_lesson_page.dart';
import '../../../features/learn/quran_teaching/presentation/quran_teaching_module_page.dart';
import '../../../features/learn/quran_teaching/presentation/quran_teaching_section_page.dart';
import '../../../features/arabic/domain/arabic_learning_continuity_models.dart';
import '../../../features/arabic/presentation/arabic_learning_mini_assessment_page.dart';
import 'learn_route_helpers.dart';

List<RouteBase> buildLearnCoreRoutes() {
  return <RouteBase>[
    GoRoute(
      path: '/quran/learning',
      name: 'quranLearningHub',
      pageBuilder: (context, state) => MaterialPage(
        child: LearnQuranHubPage(
          initialTab: switch (state.uri.queryParameters['tab']) {
            'reflect' => LearnQuranHubTab.reflect,
            'paths' => LearnQuranHubTab.paths,
            'memorize' => LearnQuranHubTab.memorize,
            _ => LearnQuranHubTab.understand,
          },
        ),
      ),
    ),
    GoRoute(
      path: '/quran/insights',
      name: 'quranAyahInsightsBrowse',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranAyahInsightsBrowsePage()),
    ),
    GoRoute(
      path: '/quran/knowledge-search',
      name: 'quranKnowledgeSearch',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranKnowledgeSearchPage(
          initialQuery: state.uri.queryParameters['q'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/quran/insights/paths',
      name: 'quranAyahInsightsPaths',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranAyahInsightPathsPage()),
    ),
    GoRoute(
      path: '/quran/insights/paths/:pathId',
      name: 'quranAyahInsightsPathDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranAyahInsightPathDetailPage(
          pathId: state.pathParameters['pathId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/quran/daily',
      name: 'quranDailyCompanion',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranDailyCompanionPage()),
    ),
    GoRoute(
      path: '/quran/summary',
      name: 'quranSummaryPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranSummaryPage()),
    ),
    GoRoute(
      path: '/quran/summary/:surahNumber',
      name: 'quranSummaryDetailPage',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranSurahSummaryDetailPage(
          surahNumber:
              int.tryParse(state.pathParameters['surahNumber'] ?? '') ?? 1,
        ),
      ),
    ),
    GoRoute(
      path: '/quran/paths',
      name: 'quranLearningPaths',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranLearningPathsPage()),
    ),
    GoRoute(
      path: '/quran/paths/:pathId',
      name: 'quranLearningPathDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranLearningPathDetailPage(
          pathId: state.pathParameters['pathId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/quran/paths/:pathId/stops/:stopId',
      name: 'quranLearningPathStopDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranLearningPathStopDetailPage(
          pathId: state.pathParameters['pathId'] ?? '',
          stopId: state.pathParameters['stopId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/quran/insights/:domainId',
      name: 'quranAyahInsightsDomain',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranAyahInsightsDomainPage(
          domainId: state.pathParameters['domainId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/quran/arabic',
      name: 'quranArabic',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranTeachingSectionPage()),
    ),
    GoRoute(
      path: '/quran/arabic/module/:moduleId',
      name: 'quranArabicModule',
      pageBuilder: (context, state) {
        final module = quranTeachingCatalog.moduleById(
          state.pathParameters['moduleId'] ?? '',
        );
        return MaterialPage(
          child: module == null
              ? const QuranTeachingSectionPage()
              : QuranTeachingModulePage(module: module),
        );
      },
    ),
    GoRoute(
      path: '/quran/arabic/module/:moduleId/lesson/:lessonId',
      name: 'quranArabicLesson',
      pageBuilder: (context, state) {
        final module = quranTeachingCatalog.moduleById(
          state.pathParameters['moduleId'] ?? '',
        );
        final lesson = quranTeachingCatalog.lessonById(
          state.pathParameters['lessonId'] ?? '',
        );
        return MaterialPage(
          child: module == null || lesson == null
              ? const QuranTeachingSectionPage()
              : QuranTeachingLessonPage(lesson: lesson, module: module),
        );
      },
    ),
    GoRoute(
      path: '/quran/arabic/words',
      name: 'quranArabicWords',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranTeachingBeginnerWordsPage(
          initialWordId: state.uri.queryParameters['word'],
        ),
      ),
    ),
    GoRoute(
      path: '/quran/arabic/review',
      name: 'quranArabicDailyReview',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranTeachingDailyReviewPage()),
    ),
    GoRoute(
      path: '/quran/arabic/readiness',
      name: 'quranArabicReadiness',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranReadinessBridgePage(
          audience: ArabicLearningAudience.adult,
          initialSnippetId: state.uri.queryParameters['snippet'],
        ),
      ),
    ),
    GoRoute(
      path: '/quran/arabic/short-surahs',
      name: 'quranArabicShortSurahs',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranShortSurahReadinessPage(
          audience: ArabicLearningAudience.adult,
          initialSurahNumber: int.tryParse(
            state.uri.queryParameters['surah'] ?? '',
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/quran/arabic/guided-passages',
      name: 'quranArabicGuidedPassages',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranGuidedPassageReadinessPage(
          audience: ArabicLearningAudience.adult,
          initialPassageId: state.uri.queryParameters['passage'],
        ),
      ),
    ),
    GoRoute(
      path: '/quran/arabic/practice',
      name: 'quranArabicMiniAssessment',
      pageBuilder: (context, state) => const MaterialPage(
        child: ArabicLearningMiniAssessmentPage(
          audience: ArabicLearningAudience.adult,
        ),
      ),
    ),
    GoRoute(
      path: '/learn/legacy',
      name: 'learnLegacy',
      // Compatibility surface retained for hidden catalog items and older
      // Learning Journey metadata that still reference the original library.
      pageBuilder: (context, state) {
        const analytics = LearnAnalyticsService();
        analytics.logLegacyRouteOpened(
          routeKey: '/learn/legacy',
          matchedLocation: state.matchedLocation,
        );
        return const MaterialPage(child: LearnSelfLearningHubPage());
      },
    ),
    GoRoute(
      path: '/learn/journey-home',
      name: 'learnJourneyHome',
      pageBuilder: (context, state) {
        const analytics = LearnAnalyticsService();
        analytics.logLegacyRouteOpened(
          routeKey: '/learn/journey-home',
          matchedLocation: state.matchedLocation,
        );
        return const MaterialPage(child: LearningJourneyHomePage());
      },
    ),
    GoRoute(
      path: '/learn/learning-journey',
      name: 'learnJourneyIslandHub',
      pageBuilder: (context, state) {
        const analytics = LearnAnalyticsService();
        analytics.logLegacyRouteOpened(
          routeKey: '/learn/learning-journey',
          matchedLocation: state.matchedLocation,
        );
        return const MaterialPage(child: LearningJourneyIslandHubPage());
      },
    ),
    GoRoute(
      path: '/learn/paths/foundations/next',
      name: 'learnFoundationsNextSteps',
      pageBuilder: (context, state) =>
          const MaterialPage(child: FoundationsPathNextStepsPage()),
    ),
    GoRoute(
      path: '/learn/paths/daily-dhikr/next',
      name: 'learnDailyDhikrNextSteps',
      pageBuilder: (context, state) =>
          const MaterialPage(child: DailyDhikrPathNextStepsPage()),
    ),
    GoRoute(
      path: '/learn/paths/quran-beginner/bridge',
      name: 'learnQuranBeginnerSoftBridge',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranBeginnerSoftBridgePage()),
    ),
    GoRoute(
      path: '/learn/paths/kids-starter/bridge',
      name: 'learnKidsStarterBridge',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsStarterPathBridgePage()),
    ),
    GoRoute(
      path: '/learn/paths/kids-starter/next',
      name: 'learnKidsStarterNextSteps',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsStarterPathNextStepsPage()),
    ),
    GoRoute(
      path: '/learn/paths/stories/bridge',
      name: 'learnStoriesPathBridge',
      pageBuilder: (context, state) =>
          const MaterialPage(child: StoriesPathBridgePage()),
    ),
    GoRoute(
      path: '/learn/paths/stories/next',
      name: 'learnStoriesPathNextSteps',
      pageBuilder: (context, state) =>
          const MaterialPage(child: StoriesPathNextStepsPage()),
    ),
    GoRoute(
      path: '/learn/paths/:pathId',
      name: 'learnGuidedPathDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: GuidedLearningPathDetailPage(
          pathId: state.pathParameters['pathId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/glossary',
      name: 'learnGlossary',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GlossaryPage()),
    ),
    GoRoute(
      path: '/learn/island/:islandId',
      name: 'learnJourneyIsland',
      pageBuilder: (context, state) => MaterialPage(
        child: LearningJourneyIslandPage(
          islandId: state.pathParameters['islandId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/journey/:journeyId',
      name: 'learnJourneyDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: LearningJourneyDetailPage(
          journeyId: state.pathParameters['journeyId'] ?? '',
          currentStageId: state.uri.queryParameters['currentStage'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/journey/:journeyId/stage/:stageId',
      name: 'learnJourneyStage',
      pageBuilder: (context, state) => MaterialPage(
        child: LearningJourneyStagePage(
          journeyId: state.pathParameters['journeyId'] ?? '',
          stageId: state.pathParameters['stageId'] ?? '',
          learnTogetherChildProfileId:
              state.uri.queryParameters['learnTogetherChildProfileId'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/browse',
      name: 'learnJourneyBrowse',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/explore',
        state: state,
        aliasPath: '/learn/browse',
        routeFamily: 'learn_explore',
      ),
    ),
    GoRoute(
      path: '/learn/explore',
      name: 'learnExploreAllKnowledge',
      pageBuilder: (context, state) => MaterialPage(
        child: LearnExploreAllKnowledgePage(
          initialCategoryId: LearnHubTaxonomy.categoryFromSlug(
            state.uri.queryParameters['category'] ?? '',
          ),
          initialQuery: state.uri.queryParameters['q'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/history',
      name: 'learnHistoryArchive',
      pageBuilder: (context, state) =>
          const MaterialPage(child: HistoryArchivePage()),
    ),
    GoRoute(
      path: '/learn/history/today',
      name: 'learnOnThisDayMatches',
      pageBuilder: (context, state) =>
          const MaterialPage(child: OnThisDayMatchesPage()),
    ),
    GoRoute(
      path: '/learn/history/event/:slug',
      name: 'learnHistoricalEventDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: HistoryEventDetailPage(slug: state.pathParameters['slug'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/learn/games',
      name: 'learnGamesIsland',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GamesIslandPage()),
    ),
    GoRoute(
      path: '/learn/games/browse',
      name: 'learnGamesBrowseAll',
      pageBuilder: (context, state) => MaterialPage(
        child: LearnGamesBrowseAllPage(
          initialQuery: state.uri.queryParameters['q'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/games/:sectionId',
      name: 'learnGamesSection',
      pageBuilder: (context, state) => MaterialPage(
        child: GamesIslandPage(
          initialSectionId: state.pathParameters['sectionId'],
        ),
      ),
    ),
    if (kDebugMode)
      GoRoute(
        path: '/learn/games/internal/content-builder',
        name: 'learnInternalContentBuilder',
        pageBuilder: (context, state) =>
            const MaterialPage(child: InternalContentBuilderPage()),
      ),
    GoRoute(
      path: '/learn/category/:categoryId',
      name: 'learnHubCategory',
      pageBuilder: (context, state) {
        final categoryId = LearnHubTaxonomy.categoryFromSlug(
          state.pathParameters['categoryId'] ?? '',
        );
        if (categoryId == null) {
          return const MaterialPage(child: LearningSectionLandingPage());
        }
        return MaterialPage(
          child: LearnCategoryPage(
            categoryId: categoryId,
            initialSubcategoryId: state.uri.queryParameters['sub'],
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/family',
      name: 'learnFamilyManagement',
      pageBuilder: (context, state) =>
          const MaterialPage(child: FamilyLearningManagementPage()),
    ),
    GoRoute(
      path: '/learn/guides',
      name: 'islamicGuides',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicGuidesPage()),
    ),
    GoRoute(
      path: '/learn/guides/quran-lessons-mapping',
      name: 'quranLessonsMapping',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranLessonsMappingPage()),
    ),
  ];
}
