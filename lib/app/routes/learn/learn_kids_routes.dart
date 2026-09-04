import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/kids/bedtime_routines/presentation/bedtime_companion_page.dart';
import '../../../features/kids/bedtime_stories/presentation/bedtime_story_detail_page.dart';
import '../../../features/kids/bedtime_stories/presentation/bedtime_story_family_mode_page.dart';
import '../../../features/kids/bedtime_stories/presentation/bedtime_story_memory_cards_page.dart';
import '../../../features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart';
import '../../../features/kids/bedtime_stories/presentation/bedtime_story_quiz_page.dart';
import '../../../features/kids/bedtime_stories/presentation/kids_hadith_stories_page.dart';
import '../../../features/kids/bedtime_stories/presentation/kids_story_library_page.dart';
import '../../../features/kids/play/presentation/kids_play_page.dart';
import '../../../features/kids/seerah/presentation/seerah_journey_page.dart';
import '../../../features/kids/seerah/presentation/seerah_journeys_page.dart';
import '../../../features/kids/seerah/presentation/seerah_node_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_coloring_pages_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_coloring_viewer_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_home_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_lesson_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_mini_phrases_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_parent_dashboard_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_parent_settings_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_practice_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_progress_map_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_reading_mode_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_review_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_rewards_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_word_lesson_page.dart';
import '../../../features/kids_arabic/presentation/kids_arabic_words_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_category_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_drawing_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_drawing_view_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_drawings_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_landing_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_lesson_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_my_day_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_parent_dashboard_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_practice_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_rewards_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_story_browse_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_story_player_page.dart';
import '../../../features/kids_dua_learning/presentation/kids_dua_stories_page.dart';
import '../../../features/learn/hadith/presentation/kids_hadith_page.dart';
import '../../../features/learn/quran/presentation/kids_quran_page.dart';
import '../../../features/learn/quran/presentation/kids_quran_surah_page.dart';
import '../../../features/learn/quran/presentation/quran_guided_passage_readiness_page.dart';
import '../../../features/learn/quran/presentation/quran_readiness_bridge_page.dart';
import '../../../features/learn/quran/presentation/quran_short_surah_readiness_page.dart';
import '../../../features/learn/quran/presentation/quran_kids_ayah_insights_page.dart';
import '../../../features/progression/presentation/learner_progression_page.dart';
import '../../../features/arabic/domain/arabic_learning_continuity_models.dart';
import '../../../features/arabic/presentation/arabic_learning_mini_assessment_page.dart';

List<RouteBase> buildLearnKidsRoutes() {
  return <RouteBase>[
    // "Kids Games" and "Fun Learning" were two link lists over the same six
    // destinations; both names now open the one Play page.
    GoRoute(
      path: '/learn/kids/games',
      name: 'learnKidsGames',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsPlayPage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic-learning',
      name: 'learnKidsArabicLearning',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicHomePage()),
    ),
    GoRoute(
      path: '/learn/kids/quran',
      name: 'learnKidsQuran',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsQuranPage()),
    ),
    GoRoute(
      path: '/learn/kids/quran/surah/:surahNumber',
      name: 'learnKidsQuranSurah',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsQuranSurahPage(
          surahNumber:
              int.tryParse(state.pathParameters['surahNumber'] ?? '') ?? 1,
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/hadith',
      name: 'learnKidsHadith',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsHadithPage()),
    ),
    GoRoute(
      path: '/learn/kids/hadith-stories',
      name: 'learnKidsHadithStories',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsHadithStoriesPage()),
    ),
    GoRoute(
      path: '/learn/kids/prophet-stories',
      name: 'learnKidsProphetStories',
      pageBuilder: (context, state) => const MaterialPage(
        child: KidsStoryLibraryPage(initialCollectionId: 'prophets'),
      ),
    ),
    GoRoute(
      path: '/learn/kids/fun-learning',
      name: 'learnKidsFunLearning',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsPlayPage()),
    ),
    GoRoute(
      path: '/learn/kids/quran-insights',
      name: 'kidsQuranAyahInsights',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranKidsAyahInsightsPage()),
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
      path: '/learn/kids/arabic/progress',
      name: 'kidsArabicProgressMap',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicProgressMapPage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/practice',
      name: 'kidsArabicPractice',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicPracticePage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/practice/quick',
      name: 'kidsArabicMiniAssessment',
      pageBuilder: (context, state) => const MaterialPage(
        child: ArabicLearningMiniAssessmentPage(
          audience: ArabicLearningAudience.kids,
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/arabic/words',
      name: 'kidsArabicWordsHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsArabicWordsPage()),
    ),
    GoRoute(
      path: '/learn/kids/arabic/phrases',
      name: 'kidsArabicMiniPhrases',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsArabicMiniPhrasesPage(
          initialPhraseId: state.uri.queryParameters['phrase'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/arabic/quran-readiness',
      name: 'kidsArabicQuranReadiness',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranReadinessBridgePage(
          audience: ArabicLearningAudience.kids,
          initialSnippetId: state.uri.queryParameters['snippet'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/arabic/short-surahs',
      name: 'kidsArabicShortSurahs',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranShortSurahReadinessPage(
          audience: ArabicLearningAudience.kids,
          initialSurahNumber: int.tryParse(
            state.uri.queryParameters['surah'] ?? '',
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/arabic/guided-passages',
      name: 'kidsArabicGuidedPassages',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranGuidedPassageReadinessPage(
          audience: ArabicLearningAudience.kids,
          initialPassageId: state.uri.queryParameters['passage'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/arabic/words/reading',
      name: 'kidsArabicReadingMode',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsArabicReadingModePage(
          initialWordId: state.uri.queryParameters['word'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/arabic/words/:wordId',
      name: 'kidsArabicWordLesson',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsArabicWordLessonPage(
          wordId: state.pathParameters['wordId'] ?? '',
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
    // The bedtime page was a third library over the same stories; it is now
    // the bedtime shelf of the one library.
    GoRoute(
      path: '/learn/kids/bedtime-stories',
      name: 'kidsBedtimeStories',
      pageBuilder: (context, state) => const MaterialPage(
        child: KidsStoryLibraryPage(initialCollectionId: 'bedtime'),
      ),
    ),
    GoRoute(
      path: '/learn/kids/seerah',
      name: 'kidsSeerahJourneys',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KidsSeerahJourneysPage()),
    ),
    GoRoute(
      path: '/learn/kids/seerah/:journeyId',
      name: 'kidsSeerahJourney',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsSeerahJourneyPage(
          journeyId: state.pathParameters['journeyId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/seerah/:journeyId/node/:nodeId',
      name: 'kidsSeerahNode',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsSeerahNodePage(
          journeyId: state.pathParameters['journeyId'] ?? '',
          nodeId: state.pathParameters['nodeId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/stories',
      name: 'kidsStoryLibrary',
      pageBuilder: (context, state) => MaterialPage(
        child: KidsStoryLibraryPage(
          initialCollectionId: state.uri.queryParameters['collection'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/bedtime-stories/parents',
      name: 'kidsBedtimeStoriesParentDashboard',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BedtimeStoryParentDashboardPage()),
    ),
    GoRoute(
      path: '/learn/kids/progression',
      name: 'kidsLearnerProgression',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LearnerProgressionPage()),
    ),
    GoRoute(
      path: '/learn/kids/bedtime-stories/family',
      name: 'kidsBedtimeStoriesFamilyMode',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BedtimeStoryFamilyModePage()),
    ),
    GoRoute(
      path: '/learn/kids/bedtime-stories/companion',
      name: 'kidsBedtimeCompanion',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BedtimeCompanionPage()),
    ),
    GoRoute(
      path: '/learn/kids/bedtime-stories/:storyId',
      name: 'kidsBedtimeStoryDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: BedtimeStoryDetailPage(
          storyId: state.pathParameters['storyId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/stories/:storyId',
      name: 'kidsStoryDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: BedtimeStoryDetailPage(
          storyId: state.pathParameters['storyId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/hadith-stories/:storyId',
      name: 'learnKidsHadithStoriesDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: BedtimeStoryDetailPage(
          storyId: state.pathParameters['storyId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/bedtime-stories/:storyId/quiz',
      name: 'kidsBedtimeStoryQuiz',
      pageBuilder: (context, state) => MaterialPage(
        child: BedtimeStoryQuizPage(
          storyId: state.pathParameters['storyId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/stories/:storyId/quiz',
      name: 'kidsStoryQuiz',
      pageBuilder: (context, state) => MaterialPage(
        child: BedtimeStoryQuizPage(
          storyId: state.pathParameters['storyId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/bedtime-stories/:storyId/memory',
      name: 'kidsBedtimeStoryMemory',
      pageBuilder: (context, state) => MaterialPage(
        child: BedtimeStoryMemoryCardsPage(
          storyId: state.pathParameters['storyId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/kids/stories/:storyId/memory',
      name: 'kidsStoryMemory',
      pageBuilder: (context, state) => MaterialPage(
        child: BedtimeStoryMemoryCardsPage(
          storyId: state.pathParameters['storyId'] ?? '',
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
  ];
}
