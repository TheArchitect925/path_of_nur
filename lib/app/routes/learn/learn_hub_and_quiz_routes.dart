import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/faq/pages/faq_category_page.dart';
import '../../../features/faq/pages/faq_detail_page.dart';
import '../../../features/faq/pages/faq_landing_page.dart';
import '../../../features/learn/ayah_completion/presentation/ayah_completion_home_page.dart';
import '../../../features/learn/ayah_completion/presentation/ayah_completion_pack_page.dart';
import '../../../features/learn/ayah_completion/presentation/ayah_completion_puzzle_page.dart';
import '../../../features/learn/crossword/presentation/crossword_home_page.dart';
import '../../../features/learn/crossword/presentation/crossword_pack_page.dart';
import '../../../features/learn/crossword/presentation/crossword_puzzle_page.dart';
import '../../../features/learn/dua/presentation/dua_detail_page.dart';
import '../../../features/learn/dua/presentation/dua_hub_page.dart';
import '../../../features/learn/hadith_reflection/presentation/hadith_reflection_home_page.dart';
import '../../../features/learn/hadith_reflection/presentation/hadith_reflection_pack_page.dart';
import '../../../features/learn/hadith_reflection/presentation/hadith_reflection_puzzle_page.dart';
import '../../../features/learn/knowledge_games/daily/presentation/daily_knowledge_challenge_hub_page.dart';
import '../../../features/learn/matching/presentation/matching_home_page.dart';
import '../../../features/learn/matching/presentation/matching_pack_page.dart';
import '../../../features/learn/matching/presentation/matching_puzzle_page.dart';
import '../../../features/learn/presentation/pages/learn_quizzes_hub_page.dart';
import '../../../features/learn/presentation/pages/learn_salah_hub_page.dart';
import '../../../features/learn/salah/presentation/salah_guided_prayer_page.dart';
import '../../../features/learn/salah/presentation/salah_prayer_detail_page.dart';
import '../../../features/learn/salah/presentation/salah_surah_detail_page.dart';
import '../../../features/learn/salah/presentation/wudu_guide_page.dart';
import '../../../features/learn/salah/presentation/wudu_quiz_page.dart';
import '../../../features/learn/salah/presentation/wudu_trainer_page.dart';
import '../../../features/learn/trivia/presentation/trivia_home_page.dart';
import '../../../features/learn/trivia/presentation/trivia_knowledge_path_detail_page.dart';
import '../../../features/learn/trivia/presentation/trivia_knowledge_path_stage_page.dart';
import '../../../features/learn/trivia/presentation/trivia_knowledge_paths_page.dart';
import '../../../features/learn/trivia/presentation/trivia_results_page.dart';
import '../../../features/learn/trivia/presentation/trivia_review_page.dart';
import '../../../features/learn/trivia/presentation/trivia_session_page.dart';
import '../../../features/learn/trivia/presentation/trivia_stats_page.dart';
import '../../../features/learn/word_search/presentation/word_search_home_page.dart';
import '../../../features/learn/word_search/presentation/word_search_pack_page.dart';
import '../../../features/learn/word_search/presentation/word_search_puzzle_page.dart';
import 'learn_route_helpers.dart';

List<RouteBase> buildLearnHubAndQuizRoutes() {
  return <RouteBase>[
    GoRoute(
      path: '/learn/hub/quran',
      name: 'learnQuranHub',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/quran',
        state: state,
        aliasPath: '/learn/hub/quran',
        routeFamily: 'quran',
      ),
    ),
    GoRoute(
      path: '/learn/hub/quran/learning',
      name: 'learnQuranLearning',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/quran/learning',
        state: state,
        aliasPath: '/learn/hub/quran/learning',
        routeFamily: 'quran',
      ),
    ),
    GoRoute(
      path: '/learn/hub/quranic-arabic',
      name: 'learnQuranArabic',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/quran/arabic',
        state: state,
        aliasPath: '/learn/hub/quranic-arabic',
        routeFamily: 'quran',
      ),
    ),
    GoRoute(
      path: '/learn/prophets',
      name: 'learnProphetsHub',
      pageBuilder: (context, state) => buildProphetsHubPage(state),
    ),
    GoRoute(
      path: '/learn/hub/prophets',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/prophets',
        state: state,
        aliasPath: '/learn/hub/prophets',
        routeFamily: 'stories',
      ),
    ),
    GoRoute(
      path: '/learn/section/prophets',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/prophets',
        state: state,
        aliasPath: '/learn/section/prophets',
        routeFamily: 'stories',
      ),
    ),
    GoRoute(
      path: '/learn/quizzes',
      name: 'learnQuizzesHub',
      pageBuilder: (context, state) => MaterialPage(
        child: LearnQuizzesHubPage(
          initialFilter: learnQuizFilterFromQuery(
            state.uri.queryParameters['filter'],
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/trivia',
      name: 'learnQuizzesTriviaHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaHomePage()),
    ),
    GoRoute(
      path: '/learn/quizzes/trivia/paths',
      name: 'learnTriviaKnowledgePaths',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaKnowledgePathsPage()),
    ),
    GoRoute(
      path: '/learn/quizzes/trivia/paths/:pathId',
      name: 'learnTriviaKnowledgePathDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: IslamicTriviaKnowledgePathDetailPage(
          pathId: state.pathParameters['pathId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/trivia/paths/:pathId/stages/:stageId',
      name: 'learnTriviaKnowledgePathStage',
      pageBuilder: (context, state) => MaterialPage(
        child: IslamicTriviaKnowledgePathStagePage(
          pathId: state.pathParameters['pathId'] ?? '',
          stageId: state.pathParameters['stageId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/trivia/session',
      name: 'learnTriviaSession',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaSessionPage()),
    ),
    GoRoute(
      path: '/learn/quizzes/trivia/results',
      name: 'learnTriviaResults',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaResultsPage()),
    ),
    GoRoute(
      path: '/learn/quizzes/trivia/review',
      name: 'learnTriviaReview',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaReviewPage()),
    ),
    GoRoute(
      path: '/learn/quizzes/trivia/stats',
      name: 'learnTriviaStats',
      pageBuilder: (context, state) =>
          const MaterialPage(child: IslamicTriviaStatsPage()),
    ),
    GoRoute(
      path: '/learn/quizzes/daily-challenge',
      name: 'learnDailyKnowledgeHub',
      pageBuilder: (context, state) =>
          const MaterialPage(child: DailyKnowledgeChallengeHubPage()),
    ),
    GoRoute(
      path: '/learn/quizzes/crossword',
      name: 'learnCrosswordHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: CrosswordHomePage()),
    ),
    GoRoute(
      path: '/learn/quizzes/crossword/pack/:packId',
      name: 'learnCrosswordPack',
      pageBuilder: (context, state) => MaterialPage(
        child: CrosswordPackPage(packId: state.pathParameters['packId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/crossword/daily',
      name: 'learnCrosswordDaily',
      pageBuilder: (context, state) =>
          const MaterialPage(child: CrosswordPuzzlePage(dailyMode: true)),
    ),
    GoRoute(
      path: '/learn/quizzes/crossword/puzzle/:puzzleId',
      name: 'learnCrosswordPuzzle',
      pageBuilder: (context, state) => MaterialPage(
        child: CrosswordPuzzlePage(
          puzzleId: state.pathParameters['puzzleId'] ?? '',
          packId: state.uri.queryParameters['pack'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/word-search',
      name: 'learnWordSearchHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WordSearchHomePage()),
    ),
    GoRoute(
      path: '/learn/quizzes/word-search/pack/:packId',
      name: 'learnWordSearchPack',
      pageBuilder: (context, state) => MaterialPage(
        child: WordSearchPackPage(packId: state.pathParameters['packId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/word-search/daily',
      name: 'learnWordSearchDaily',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WordSearchPuzzlePage(dailyMode: true)),
    ),
    GoRoute(
      path: '/learn/quizzes/word-search/puzzle/:puzzleId',
      name: 'learnWordSearchPuzzle',
      pageBuilder: (context, state) => MaterialPage(
        child: WordSearchPuzzlePage(
          puzzleId: state.pathParameters['puzzleId'] ?? '',
          packId: state.uri.queryParameters['pack'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/matching',
      name: 'learnMatchingHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: MatchingHomePage()),
    ),
    GoRoute(
      path: '/learn/quizzes/matching/pack/:packId',
      name: 'learnMatchingPack',
      pageBuilder: (context, state) => MaterialPage(
        child: MatchingPackPage(packId: state.pathParameters['packId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/matching/daily',
      name: 'learnMatchingDaily',
      pageBuilder: (context, state) =>
          const MaterialPage(child: MatchingPuzzlePage(dailyMode: true)),
    ),
    GoRoute(
      path: '/learn/quizzes/matching/puzzle/:puzzleId',
      name: 'learnMatchingPuzzle',
      pageBuilder: (context, state) => MaterialPage(
        child: MatchingPuzzlePage(
          puzzleId: state.pathParameters['puzzleId'] ?? '',
          packId: state.uri.queryParameters['pack'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/ayah-completion',
      name: 'learnAyahCompletionHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AyahCompletionHomePage()),
    ),
    GoRoute(
      path: '/learn/quizzes/ayah-completion/pack/:packId',
      name: 'learnAyahCompletionPack',
      pageBuilder: (context, state) => MaterialPage(
        child: AyahCompletionPackPage(
          packId: state.pathParameters['packId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/ayah-completion/daily',
      name: 'learnAyahCompletionDaily',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AyahCompletionPuzzlePage(dailyMode: true)),
    ),
    GoRoute(
      path: '/learn/quizzes/ayah-completion/puzzle/:puzzleId',
      name: 'learnAyahCompletionPuzzle',
      pageBuilder: (context, state) => MaterialPage(
        child: AyahCompletionPuzzlePage(
          puzzleId: state.pathParameters['puzzleId'] ?? '',
          packId: state.uri.queryParameters['pack'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/hadith-reflection',
      name: 'learnHadithReflectionHome',
      pageBuilder: (context, state) =>
          const MaterialPage(child: HadithReflectionHomePage()),
    ),
    GoRoute(
      path: '/learn/quizzes/hadith-reflection/pack/:packId',
      name: 'learnHadithReflectionPack',
      pageBuilder: (context, state) => MaterialPage(
        child: HadithReflectionPackPage(
          packId: state.pathParameters['packId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/hadith-reflection/daily',
      name: 'learnHadithReflectionDaily',
      pageBuilder: (context, state) => const MaterialPage(
        child: HadithReflectionPuzzlePage(dailyMode: true),
      ),
    ),
    GoRoute(
      path: '/learn/quizzes/hadith-reflection/puzzle/:puzzleId',
      name: 'learnHadithReflectionPuzzle',
      pageBuilder: (context, state) => MaterialPage(
        child: HadithReflectionPuzzlePage(
          puzzleId: state.pathParameters['puzzleId'] ?? '',
          packId: state.uri.queryParameters['pack'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/hub/quizzes',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/quizzes',
        state: state,
        aliasPath: '/learn/hub/quizzes',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/section/quizzes',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/quizzes',
        state: state,
        aliasPath: '/learn/section/quizzes',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/duas',
      name: 'learnDuaHub',
      pageBuilder: (context, state) => MaterialPage(
        child: DuaHubPage(
          initialQuery: state.uri.queryParameters['q'] ?? '',
          section: state.uri.queryParameters['section'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/hub/duas',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/duas',
        state: state,
        aliasPath: '/learn/hub/duas',
        routeFamily: 'worship',
      ),
    ),
    GoRoute(
      path: '/learn/section/duas',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/duas',
        state: state,
        aliasPath: '/learn/section/duas',
        routeFamily: 'worship',
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia',
      name: 'learnIslamicTrivia',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/quizzes/trivia',
        state: state,
        aliasPath: '/learn/hub/trivia',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/paths',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/quizzes/trivia/paths',
        state: state,
        aliasPath: '/learn/hub/trivia/paths',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/paths/:pathId',
      redirect: (context, state) => learnCompatibilityRedirectWithPathAndQuery(
        canonicalPathTemplate: '/learn/quizzes/trivia/paths/:pathId',
        state: state,
        aliasPath: '/learn/hub/trivia/paths/:pathId',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/paths/:pathId/stages/:stageId',
      redirect: (context, state) => learnCompatibilityRedirectWithPathAndQuery(
        canonicalPathTemplate:
            '/learn/quizzes/trivia/paths/:pathId/stages/:stageId',
        state: state,
        aliasPath: '/learn/hub/trivia/paths/:pathId/stages/:stageId',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/session',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/quizzes/trivia/session',
        state: state,
        aliasPath: '/learn/hub/trivia/session',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/results',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/quizzes/trivia/results',
        state: state,
        aliasPath: '/learn/hub/trivia/results',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/review',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/quizzes/trivia/review',
        state: state,
        aliasPath: '/learn/hub/trivia/review',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/hub/trivia/stats',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/quizzes/trivia/stats',
        state: state,
        aliasPath: '/learn/hub/trivia/stats',
        routeFamily: 'games',
      ),
    ),
    GoRoute(
      path: '/learn/salah',
      name: 'learnSalahHub',
      pageBuilder: (context, state) => MaterialPage(
        child: LearnSalahHubPage(section: state.uri.queryParameters['section']),
      ),
    ),
    GoRoute(
      path: '/learn/hub/salah',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/salah',
        state: state,
        aliasPath: '/learn/hub/salah',
        routeFamily: 'worship',
      ),
    ),
    GoRoute(
      path: '/learn/section/salah',
      redirect: (context, state) => learnCompatibilityRedirect(
        canonicalPath: '/learn/salah',
        state: state,
        aliasPath: '/learn/section/salah',
        routeFamily: 'worship',
      ),
    ),
    GoRoute(
      path: '/learn/salah/prayer/:prayerId',
      name: 'learnSalahPrayerDetail',
      pageBuilder: (context, state) {
        final prayerId = parsePrayerId(state.pathParameters['prayerId'] ?? '');
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
        final prayerId = parsePrayerId(state.pathParameters['prayerId'] ?? '');
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
      path: '/learn/salah/wudu/quiz',
      name: 'learnWuduQuiz',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WuduQuizPage()),
    ),
    GoRoute(
      path: '/learn/faq',
      name: 'faqLanding',
      pageBuilder: (context, state) =>
          const MaterialPage(child: FaqLandingPage()),
    ),
    GoRoute(
      path: '/learn/section/faq',
      redirect: (context, state) => learnRedirectWithQuery('/learn/faq', state),
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
  ];
}
