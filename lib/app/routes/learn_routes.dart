import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/faq/pages/faq_category_page.dart';
import '../../features/faq/pages/faq_detail_page.dart';
import '../../features/faq/pages/faq_landing_page.dart';
import '../../features/learn/content/domain/learn_topic_category.dart';
import '../../features/learn/content/presentation/islamic_guides_page.dart';
import '../../features/learn/content/presentation/learn_content_detail_page.dart';
import '../../features/learn/content/presentation/learn_notes_landing_page.dart';
import '../../features/learn/content/presentation/quran_lessons_mapping_page.dart';
import '../../features/learn/divine_life_lessons/presentation/divine_life_lesson_detail_page.dart';
import '../../features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart';
import '../../features/learn/divine_life_lessons/presentation/divine_life_reflection_page.dart';
import '../../features/learn/dua/presentation/dua_detail_page.dart';
import '../../features/learn/dua/presentation/dua_hub_page.dart';
import '../../features/learn/hadith/application/hadith_path_quiz_service.dart';
import '../../features/learn/hadith/presentation/hadith_landing_page.dart';
import '../../features/learn/hadith/presentation/hadith_learning_path_page.dart';
import '../../features/learn/hadith/presentation/hadith_lesson_page.dart';
import '../../features/learn/hadith/presentation/hadith_quiz_session_page.dart';
import '../../features/learn/hadith/presentation/hadith_subcategory_page.dart';
import '../../features/learn/hadith/presentation/hadith_theme_page.dart';
import '../../features/learn/hadith/presentation/important_hadith_collection_page.dart';
import '../../features/learn/hadith/presentation/important_hadith_detail_page.dart';
import '../../features/learn/journey/presentation/family_learning_management_page.dart';
import '../../features/learn/journey/presentation/learn_browse_all_page.dart';
import '../../features/learn/journey/presentation/learning_journey_detail_page.dart';
import '../../features/learn/journey/presentation/learning_journey_home_page.dart';
import '../../features/learn/journey/presentation/learning_journey_island_page.dart';
import '../../features/learn/journey/presentation/learning_journey_stage_page.dart';
import '../../features/kids_arabic/presentation/kids_arabic_home_page.dart';
import '../../features/kids_arabic/presentation/kids_arabic_lesson_page.dart';
import '../../features/kids_arabic/presentation/kids_arabic_parent_dashboard_page.dart';
import '../../features/kids_arabic/presentation/kids_arabic_parent_settings_page.dart';
import '../../features/kids_arabic/presentation/kids_arabic_coloring_pages_page.dart';
import '../../features/kids_arabic/presentation/kids_arabic_coloring_viewer_page.dart';
import '../../features/kids_arabic/presentation/kids_arabic_review_page.dart';
import '../../features/kids_arabic/presentation/kids_arabic_rewards_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_category_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_drawing_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_drawing_view_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_drawings_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_landing_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_lesson_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_my_day_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_parent_dashboard_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_practice_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_rewards_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_story_player_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_story_browse_page.dart';
import '../../features/kids_dua_learning/presentation/kids_dua_stories_page.dart';
import '../../features/learn/life/baby_names/presentation/baby_name_detail_page.dart';
import '../../features/learn/life/baby_names/presentation/baby_names_browse_page.dart';
import '../../features/learn/life/baby_names/presentation/baby_names_compare_page.dart';
import '../../features/learn/life/baby_names/presentation/baby_names_favorites_page.dart';
import '../../features/learn/life/baby_names/presentation/baby_names_finder_page.dart';
import '../../features/learn/life/baby_names/presentation/baby_names_generator_page.dart';
import '../../features/learn/life/baby_names/presentation/baby_names_home_page.dart';
import '../../features/learn/life/baby_names/presentation/baby_names_meaning_explorer_page.dart';
import '../../features/learn/presentation/learn_page.dart';
import '../../features/learn/presentation/data/learn_hub_taxonomy.dart';
import '../../features/learn/presentation/pages/learning_section_landing_page.dart';
import '../../features/learn/presentation/pages/learn_category_page.dart';
import '../../features/learn/presentation/pages/learn_explore_all_knowledge_page.dart';
import '../../features/learn/presentation/pages/learn_quran_hub_page.dart';
import '../../features/learn/presentation/pages/learn_quizzes_hub_page.dart';
import '../../features/learn/presentation/pages/learn_salah_hub_page.dart';
import '../../features/learn/presentation/pages/quran_app_hub_page.dart';
import '../../features/learn/prophets/domain/prophets_tab.dart';
import '../../features/learn/prophets/presentation/prophets_page.dart';
import '../../features/learn/quran_teaching/presentation/quran_teaching_section_page.dart';
import '../../features/learn/quran_universe/presentation/knowledge_constellation_page.dart';
import '../../features/learn/quran_universe/presentation/quran_universe_page.dart';
import '../../features/learn/salah/models/salah_trainer_models.dart';
import '../../features/learn/salah/presentation/salah_guided_prayer_page.dart';
import '../../features/learn/salah/presentation/salah_prayer_detail_page.dart';
import '../../features/learn/salah/presentation/salah_surah_detail_page.dart';
import '../../features/learn/salah/presentation/wudu_guide_page.dart';
import '../../features/learn/salah/presentation/wudu_trainer_page.dart';
import '../../features/learn/trivia/presentation/trivia_home_page.dart';
import '../../features/learn/trivia/presentation/trivia_knowledge_path_detail_page.dart';
import '../../features/learn/trivia/presentation/trivia_knowledge_path_stage_page.dart';
import '../../features/learn/trivia/presentation/trivia_knowledge_paths_page.dart';
import '../../features/learn/trivia/presentation/trivia_results_page.dart';
import '../../features/learn/trivia/presentation/trivia_review_page.dart';
import '../../features/learn/trivia/presentation/trivia_session_page.dart';
import '../../features/learn/trivia/presentation/trivia_stats_page.dart';
import '../../features/learn/world/presentation/pages/world_atmosphere_layers_page.dart';
import '../../features/learn/world/presentation/pages/world_cosmic_scale_page.dart';
import '../../features/learn/world/presentation/pages/world_creation_category_page.dart';
import '../../features/learn/world/presentation/pages/world_creation_lesson_page.dart';
import '../../features/learn/world/presentation/pages/world_creation_reflection_mode_page.dart';
import '../../features/learn/world/presentation/pages/world_deep_ocean_page.dart';
import '../../features/learn/world/presentation/pages/world_explore_creation_page.dart';
import '../../features/learn/world/presentation/pages/world_muslim_scientists_page.dart';
import '../../features/learn/world/presentation/pages/world_signs_explorer_page.dart';
import '../../features/learn/world/presentation/world_landing_page.dart';
import '../../features/learn/world/presentation/world_lesson_page.dart';
import '../../features/learn/world/presentation/world_subcategory_page.dart';
import '../../features/learn/world/presentation/world_theme_page.dart';

String _redirectWithQuery(String path, GoRouterState state) {
  return Uri(
    path: path,
    queryParameters: state.uri.queryParameters.isEmpty
        ? null
        : state.uri.queryParameters,
  ).toString();
}

ProphetsTab? _prophetsTabFromState(GoRouterState state) {
  final tabParam = state.uri.queryParameters['tab'];
  if (tabParam == null || tabParam.isEmpty) return null;
  for (final tab in ProphetsTab.values) {
    if (tab.name == tabParam) return tab;
  }
  return null;
}

Page<void> _prophetsHubPage(GoRouterState state) {
  String? initialProphetId;
  String? initialProphetQuizMode;
  String? initialProphetQuizDifficulty;
  final prophetParam = state.uri.queryParameters['prophet'];
  if (prophetParam != null && prophetParam.trim().isNotEmpty) {
    initialProphetId = prophetParam.trim();
  }
  final quizModeParam = state.uri.queryParameters['quizMode'];
  if (quizModeParam != null && quizModeParam.trim().isNotEmpty) {
    initialProphetQuizMode = quizModeParam.trim();
  }
  final quizDifficultyParam = state.uri.queryParameters['quizDifficulty'];
  if (quizDifficultyParam != null && quizDifficultyParam.trim().isNotEmpty) {
    initialProphetQuizDifficulty = quizDifficultyParam.trim();
  }
  return MaterialPage(
    child: ProphetsPage(
      initialTab: _prophetsTabFromState(state),
      initialProphetId: initialProphetId,
      initialQuizModeName: initialProphetQuizMode,
      initialQuizDifficultyName: initialProphetQuizDifficulty,
    ),
  );
}

LearnTopicCategory _learnTopicCategoryFromParam(String value) {
  switch (value) {
    case 'world':
      return LearnTopicCategory.world;
    case 'hadith':
      return LearnTopicCategory.hadith;
    case 'life':
    default:
      return LearnTopicCategory.life;
  }
}

SalahPrayerId _parsePrayerId(String value) {
  for (final item in SalahPrayerId.values) {
    if (item.name == value) return item;
  }
  return SalahPrayerId.fajr;
}

List<RouteBase> buildLearnRoutes() {
  return <RouteBase>[
    GoRoute(
      path: '/quran/learning',
      name: 'quranLearningHub',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LearnQuranHubPage()),
    ),
    GoRoute(
      path: '/quran/arabic',
      name: 'quranArabic',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranTeachingSectionPage()),
    ),
    GoRoute(
      path: '/learn/legacy',
      name: 'learnLegacy',
      pageBuilder: (context, state) => const MaterialPage(child: LearnPage()),
    ),
    GoRoute(
      path: '/learn/journey-home',
      name: 'learnJourneyHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LearningJourneyHomePage()),
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
      path: '/learn/kids/arabic',
      name: 'kidsArabicHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicHomePage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/lesson/:letterId',
      name: 'kidsArabicLesson',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsArabicLessonPage(
          letterId: state.pathParameters['letterId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/arabic/review',
      name: 'kidsArabicReview',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicReviewPage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/rewards',
      name: 'kidsArabicRewards',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicRewardsPage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/parent',
      name: 'kidsArabicParentDashboard',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicParentDashboardPage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/parent/settings',
      name: 'kidsArabicParentSettings',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicParentSettingsPage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/coloring',
      name: 'kidsArabicColoringPages',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicColoringPagesPage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/coloring/:pageId',
      name: 'kidsArabicColoringViewer',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsArabicColoringViewerPage(
          pageId: state.pathParameters['pageId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/dua',
      name: 'kidsDuaLanding',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsDuaLandingPage()),
    ),
    GoRoute(
      path: '/learn/kids/dua/category/:categoryId',
      name: 'kidsDuaCategory',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsDuaCategoryPage(
          categoryId: state.pathParameters['categoryId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/dua/lesson/:lessonId',
      name: 'kidsDuaLesson',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsDuaLessonPage(
          lessonId: state.pathParameters['lessonId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/dua/my-day',
      name: 'kidsDuaMyDay',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsDuaMyDayPage()),
    ),
    GoRoute(
      path: '/learn/kids/dua/stories',
      name: 'kidsDuaStories',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsDuaStoriesPage()),
    ),
    GoRoute(
      path: '/learn/kids/dua/stories/browse',
      name: 'kidsDuaStoriesBrowse',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsDuaStoryBrowsePage(
          category: state.uri.queryParameters['category'] ?? 'all_stories',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/dua/stories/:storyId',
      name: 'kidsDuaStoryPlayer',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsDuaStoryPlayerPage(
          storyId: state.pathParameters['storyId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/dua/draw/:lessonId',
      name: 'kidsDuaDrawing',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsDuaDrawingPage(
          lessonId: state.pathParameters['lessonId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/dua/drawings',
      name: 'kidsDuaDrawings',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsDuaDrawingsPage()),
    ),
    GoRoute(
      path: '/learn/kids/dua/drawings/:drawingId',
      name: 'kidsDuaDrawingViewer',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsDuaDrawingViewPage(
          drawingId: state.pathParameters['drawingId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/dua/practice',
      name: 'kidsDuaPractice',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsDuaPracticePage()),
    ),
    GoRoute(
      path: '/learn/kids/dua/rewards',
      name: 'kidsDuaRewards',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsDuaRewardsPage()),
    ),
    GoRoute(
      path: '/learn/kids/dua/parent',
      name: 'kidsDuaParentDashboard',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsDuaParentDashboardPage()),
    ),
    GoRoute(
      path: '/learn/hub/quran',
      name: 'learnQuranHub',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranAppHubPage()),
    ),
    GoRoute(
      path: '/learn/hub/quran/learning',
      name: 'learnQuranLearning',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LearnQuranHubPage()),
    ),
    GoRoute(
      path: '/learn/hub/quranic-arabic',
      name: 'learnQuranArabic',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranTeachingSectionPage()),
    ),
    GoRoute(
      path: '/learn/prophets',
      name: 'learnProphetsHub',
      pageBuilder: (context, state) => _prophetsHubPage(state),
    ),
    GoRoute(
      path: '/learn/hub/prophets',
      redirect: (context, state) =>
          _redirectWithQuery('/learn/prophets', state),
    ),
    GoRoute(
      path: '/learn/section/prophets',
      redirect: (context, state) =>
          _redirectWithQuery('/learn/prophets', state),
    ),
    GoRoute(
      path: '/learn/quizzes',
      name: 'learnQuizzesHub',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LearnQuizzesHubPage()),
    ),
    GoRoute(
      path: '/learn/hub/quizzes',
      redirect: (context, state) => _redirectWithQuery('/learn/quizzes', state),
    ),
    GoRoute(
      path: '/learn/section/quizzes',
      redirect: (context, state) => _redirectWithQuery('/learn/quizzes', state),
    ),
    GoRoute(
      path: '/learn/duas',
      name: 'learnDuaHub',
      pageBuilder: (context, state) => const MaterialPage(
        child: DuaHubPage(entryContext: DuaHubEntryContext.learn),
      ),
    ),
    GoRoute(
      path: '/learn/hub/duas',
      redirect: (context, state) => _redirectWithQuery('/learn/duas', state),
    ),
    GoRoute(
      path: '/learn/section/duas',
      redirect: (context, state) => _redirectWithQuery('/learn/duas', state),
    ),
    GoRoute(
      path: '/learn/hub/trivia',
      name: 'learnIslamicTrivia',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaHomePage()),
    ),
    GoRoute(
      path: '/learn/hub/trivia/paths',
      name: 'learnTriviaKnowledgePaths',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaKnowledgePathsPage()),
    ),
    GoRoute(
      path: '/learn/hub/trivia/paths/:pathId',
      name: 'learnTriviaKnowledgePathDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: IslamicTriviaKnowledgePathDetailPage(
          pathId: state.pathParameters['pathId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/paths/:pathId/stages/:stageId',
      name: 'learnTriviaKnowledgePathStage',
      pageBuilder: (context, state) => MaterialPage(
        child: IslamicTriviaKnowledgePathStagePage(
          pathId: state.pathParameters['pathId'] ?? '',
          stageId: state.pathParameters['stageId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/session',
      name: 'learnTriviaSession',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaSessionPage()),
    ),
    GoRoute(
      path: '/learn/hub/trivia/results',
      name: 'learnTriviaResults',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaResultsPage()),
    ),
    GoRoute(
      path: '/learn/hub/trivia/review',
      name: 'learnTriviaReview',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaReviewPage()),
    ),
    GoRoute(
      path: '/learn/hub/trivia/stats',
      name: 'learnTriviaStats',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaStatsPage()),
    ),
    GoRoute(
      path: '/learn/hub/salah',
      name: 'learnSalahHub',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LearnSalahHubPage()),
    ),
    GoRoute(
      path: '/learn/salah/prayer/:prayerId',
      name: 'learnSalahPrayerDetail',
      pageBuilder: (context, state) {
        final prayerId = _parsePrayerId(state.pathParameters['prayerId'] ?? '');
        return MaterialPage(
          child: SalahPrayerDetailPage(
            prayerId: prayerId,
            focusSteps: state.uri.queryParameters['focus'] == 'steps',
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/salah/guided/:prayerId',
      name: 'learnSalahGuidedPrayer',
      pageBuilder: (context, state) {
        final prayerId = _parsePrayerId(state.pathParameters['prayerId'] ?? '');
        return MaterialPage(child: SalahGuidedPrayerPage(prayerId: prayerId));
      },
    ),
    GoRoute(
      path: '/learn/salah/surah/:surahId',
      name: 'learnSalahSurahDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: SalahSurahDetailPage(
          surahId: state.pathParameters['surahId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quran/universe',
      name: 'quranUniverse',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranUniversePage()),
    ),
    GoRoute(
      path: '/learn/quran/constellation',
      name: 'knowledgeConstellation',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KnowledgeConstellationPage()),
    ),
    GoRoute(
      path: '/learn/salah/wudu',
      name: 'learnWuduGuide',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WuduGuidePage()),
    ),
    GoRoute(
      path: '/learn/salah/wudu/trainer',
      name: 'learnWuduTrainer',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WuduTrainerPage()),
    ),
    GoRoute(
      path: '/learn/faq',
      name: 'faqLanding',
      pageBuilder: (context, state) =>
          const MaterialPage(child: FaqLandingPage()),
    ),
    GoRoute(
      path: '/learn/section/faq',
      redirect: (context, state) => _redirectWithQuery('/learn/faq', state),
    ),
    GoRoute(
      path: '/learn/faq/category/:categoryId',
      name: 'faqCategory',
      pageBuilder: (context, state) => MaterialPage(
        child: FaqCategoryPage(
          categoryId: state.pathParameters['categoryId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/faq/item/:faqId',
      name: 'faqDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: FaqDetailPage(faqId: state.pathParameters['faqId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/learn/duas/:duaId',
      name: 'learnDuaDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: DuaDetailPage(duaId: state.pathParameters['duaId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/learn/life',
      name: 'learnLifeLanding',
      pageBuilder: (context, state) => MaterialPage(
        child: DivineLifeLessonsPage(
          initialThemeId: state.uri.queryParameters['themeId'],
          initialSituationId: state.uri.queryParameters['situationId'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/life/theme/:themeId',
      name: 'lifeThemeDetail',
      pageBuilder: (context, state) {
        final themeId = state.pathParameters['themeId'] ?? '';
        if (themeId.isEmpty) {
          return const MaterialPage(child: DivineLifeLessonsPage());
        }
        return MaterialPage(
          child: DivineLifeLessonsPage(
            initialThemeId: themeId,
            initialTab: DivineLifeTab.themes,
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/life/subcategory/:subcategoryId',
      name: 'lifeSubcategoryDetail',
      pageBuilder: (context, state) {
        final subcategoryId = state.pathParameters['subcategoryId'] ?? '';
        if (subcategoryId.isEmpty) {
          return const MaterialPage(child: DivineLifeLessonsPage());
        }
        return MaterialPage(
          child: DivineLifeLessonsPage(
            initialSituationId: subcategoryId,
            initialTab: DivineLifeTab.situations,
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/life/lesson/:lessonId',
      name: 'lifeLessonDetail',
      pageBuilder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        if (lessonId.isEmpty) {
          return const MaterialPage(child: DivineLifeLessonsPage());
        }
        return MaterialPage(
          child: DivineLifeLessonDetailPage(lessonId: lessonId),
        );
      },
    ),
    GoRoute(
      path: '/learn/life/reflection',
      name: 'divineLifeReflection',
      pageBuilder: (context, state) => MaterialPage(
        child: DivineLifeReflectionPage(
          initialLessonId: state.uri.queryParameters['lessonId'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/life/family/baby-names',
      name: 'babyNamesHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BabyNamesHomePage()),
    ),
    GoRoute(
      path: '/learn/life/family/baby-names/browse',
      name: 'babyNamesBrowse',
      pageBuilder: (context, state) => MaterialPage(
        child: BabyNamesBrowsePage(
          collectionId: state.uri.queryParameters['collection'],
          meaningTheme: state.uri.queryParameters['theme'],
          startingLetter: state.uri.queryParameters['letter'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/life/family/baby-names/meaning-explorer',
      name: 'babyNamesMeaningExplorer',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BabyNamesMeaningExplorerPage()),
    ),
    GoRoute(
      path: '/learn/life/family/baby-names/generator',
      name: 'babyNamesGenerator',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BabyNamesGeneratorPage()),
    ),
    GoRoute(
      path: '/learn/life/family/baby-names/finder',
      name: 'babyNamesFinder',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BabyNamesFinderPage()),
    ),
    GoRoute(
      path: '/learn/life/family/baby-names/favorites',
      name: 'babyNamesFavorites',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BabyNamesFavoritesPage()),
    ),
    GoRoute(
      path: '/learn/life/family/baby-names/compare',
      name: 'babyNamesCompare',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BabyNamesComparePage()),
    ),
    GoRoute(
      path: '/learn/life/family/baby-names/name/:nameId',
      name: 'babyNameDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: BabyNameDetailPage(nameId: state.pathParameters['nameId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/learn/world',
      name: 'learnWorldLanding',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorldLandingPage()),
    ),
    GoRoute(
      path: '/learn/world/theme/:themeId',
      name: 'worldThemeDetail',
      pageBuilder: (context, state) {
        final themeId = state.pathParameters['themeId'] ?? '';
        if (themeId.isEmpty) {
          return const MaterialPage(child: WorldLandingPage());
        }
        return MaterialPage(child: WorldThemePage(themeId: themeId));
      },
    ),
    GoRoute(
      path: '/learn/world/subcategory/:subcategoryId',
      name: 'worldSubcategoryDetail',
      pageBuilder: (context, state) {
        final subcategoryId = state.pathParameters['subcategoryId'] ?? '';
        if (subcategoryId.isEmpty) {
          return const MaterialPage(child: WorldLandingPage());
        }
        return MaterialPage(
          child: WorldSubcategoryPage(subcategoryId: subcategoryId),
        );
      },
    ),
    GoRoute(
      path: '/learn/world/lesson/:lessonId',
      name: 'worldLessonDetail',
      pageBuilder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        if (lessonId.isEmpty) {
          return const MaterialPage(child: WorldLandingPage());
        }
        return MaterialPage(child: WorldLessonPage(lessonId: lessonId));
      },
    ),
    GoRoute(
      path: '/learn/world/creation/category/:categoryName',
      name: 'worldCreationCategory',
      pageBuilder: (context, state) {
        final categoryName = state.pathParameters['categoryName'] ?? '';
        if (categoryName.isEmpty) {
          return const MaterialPage(child: WorldLandingPage());
        }
        return MaterialPage(
          child: WorldCreationCategoryPage(categoryName: categoryName),
        );
      },
    ),
    GoRoute(
      path: '/learn/world/creation/lesson/:lessonId',
      name: 'worldCreationLessonDetail',
      pageBuilder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        if (lessonId.isEmpty) {
          return const MaterialPage(child: WorldLandingPage());
        }
        return MaterialPage(child: WorldCreationLessonPage(lessonId: lessonId));
      },
    ),
    GoRoute(
      path: '/learn/world/explore-creation',
      name: 'worldExploreCreation',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorldExploreCreationPage()),
    ),
    GoRoute(
      path: '/learn/world/signs-explorer',
      name: 'worldSignsExplorer',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorldSignsExplorerPage()),
    ),
    GoRoute(
      path: '/learn/world/cosmic-scale',
      name: 'worldCosmicScale',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorldCosmicScalePage()),
    ),
    GoRoute(
      path: '/learn/world/deep-ocean',
      name: 'worldDeepOcean',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorldDeepOceanPage()),
    ),
    GoRoute(
      path: '/learn/world/atmosphere-layers',
      name: 'worldAtmosphereLayers',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorldAtmosphereLayersPage()),
    ),
    GoRoute(
      path: '/learn/world/reflection-mode',
      name: 'worldCreationReflectionMode',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorldCreationReflectionModePage()),
    ),
    GoRoute(
      path: '/learn/world/muslim-scientists',
      name: 'worldMuslimScientists',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorldMuslimScientistsPage()),
    ),
    GoRoute(
      path: '/learn/hadith',
      name: 'learnHadithLanding',
      pageBuilder: (context, state) =>
          const MaterialPage(child: HadithLandingPage()),
    ),
    GoRoute(
      path: '/learn/hadith/theme/:themeId',
      name: 'hadithThemeDetail',
      pageBuilder: (context, state) {
        final themeId = state.pathParameters['themeId'] ?? '';
        if (themeId.isEmpty) {
          return const MaterialPage(child: HadithLandingPage());
        }
        return MaterialPage(child: HadithThemePage(themeId: themeId));
      },
    ),
    GoRoute(
      path: '/learn/hadith/subcategory/:subcategoryId',
      name: 'hadithSubcategoryDetail',
      pageBuilder: (context, state) {
        final subcategoryId = state.pathParameters['subcategoryId'] ?? '';
        if (subcategoryId.isEmpty) {
          return const MaterialPage(child: HadithLandingPage());
        }
        return MaterialPage(
          child: HadithSubcategoryPage(subcategoryId: subcategoryId),
        );
      },
    ),
    GoRoute(
      path: '/learn/hadith/lesson/:lessonId',
      name: 'hadithLessonDetail',
      pageBuilder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        if (lessonId.isEmpty) {
          return const MaterialPage(child: HadithLandingPage());
        }
        return MaterialPage(child: HadithLessonPage(lessonId: lessonId));
      },
    ),
    GoRoute(
      path: '/learn/hadith/important',
      name: 'learnHadithImportant',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ImportantHadithCollectionPage()),
    ),
    GoRoute(
      path: '/learn/hadith/path/:pathId',
      name: 'hadithPathDetail',
      pageBuilder: (context, state) {
        final pathId = state.pathParameters['pathId'] ?? '';
        if (pathId.isEmpty) {
          return const MaterialPage(child: HadithLandingPage());
        }
        return MaterialPage(child: HadithLearningPathPage(pathId: pathId));
      },
    ),
    GoRoute(
      path: '/learn/hadith/path/:pathId/chapter/:chapterId/quiz',
      name: 'hadithChapterQuiz',
      pageBuilder: (context, state) {
        final pathId = state.pathParameters['pathId'] ?? '';
        final chapterId = state.pathParameters['chapterId'] ?? '';
        if (pathId.isEmpty || chapterId.isEmpty) {
          return const MaterialPage(child: HadithLandingPage());
        }
        return MaterialPage(
          child: HadithQuizSessionPage.chapter(
            pathId: pathId,
            chapterId: chapterId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/hadith/review/quiz',
      name: 'hadithReviewQuiz',
      pageBuilder: (context, state) {
        final mode = state.uri.queryParameters['mode'] ?? 'random';
        final themeId = state.uri.queryParameters['themeId'];
        final pathId = state.uri.queryParameters['pathId'];
        final reviewMode = switch (mode) {
          'theme' => HadithReviewQuizMode.byTheme,
          'path' => HadithReviewQuizMode.byPath,
          'weekly' => HadithReviewQuizMode.weekly,
          _ => HadithReviewQuizMode.random,
        };
        return MaterialPage(
          child: HadithQuizSessionPage.review(
            reviewMode: reviewMode,
            themeId: themeId,
            pathId: pathId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/hadith/important/:number',
      name: 'hadithImportantDetail',
      pageBuilder: (context, state) {
        final number = int.tryParse(state.pathParameters['number'] ?? '') ?? 1;
        return MaterialPage(child: ImportantHadithDetailPage(number: number));
      },
    ),
    GoRoute(
      path: '/learn/notes',
      name: 'learnNotesLanding',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LearnNotesLandingPage()),
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
    GoRoute(
      path: '/learn/content/:category/:topicId',
      name: 'learnContentDetail',
      pageBuilder: (context, state) {
        final categoryParam = state.pathParameters['category'] ?? 'life';
        final topicId = state.pathParameters['topicId'] ?? '';
        final category = _learnTopicCategoryFromParam(categoryParam);
        return MaterialPage(
          child: LearnContentDetailPage(category: category, topicId: topicId),
        );
      },
    ),
  ];
}
