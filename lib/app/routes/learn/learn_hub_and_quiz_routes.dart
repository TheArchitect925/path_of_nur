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
      redirect: (context, state) => learnRedirectWithQuery('/quran', state),
    ),
    GoRoute(
      path: '/learn/hub/quran/learning',
      name: 'learnQuranLearning',
      redirect: (context, state) =>
          learnRedirectWithQuery('/quran/learning', state),
    ),
    GoRoute(
      path: '/learn/hub/quranic-arabic',
      name: 'learnQuranArabic',
      redirect: (context, state) =>
          learnRedirectWithQuery('/quran/arabic', state),
    ),
    GoRoute(
      path: '/learn/prophets',
      name: 'learnProphetsHub',
      pageBuilder: (context, state) => buildProphetsHubPage(state),
    ),
    GoRoute(
      path: '/learn/hub/prophets',
      redirect: (context, state) =>
          learnRedirectWithQuery('/learn/prophets', state),
    ),
    GoRoute(
      path: '/learn/section/prophets',
      redirect: (context, state) =>
          learnRedirectWithQuery('/learn/prophets', state),
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
      redirect: (context, state) =>
          learnRedirectWithQuery('/learn/quizzes', state),
    ),
    GoRoute(
      path: '/learn/section/quizzes',
      redirect: (context, state) =>
          learnRedirectWithQuery('/learn/quizzes', state),
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
      redirect: (context, state) =>
          learnRedirectWithQuery('/learn/duas', state),
    ),
    GoRoute(
      path: '/learn/section/duas',
      redirect: (context, state) =>
          learnRedirectWithQuery('/learn/duas', state),
    ),
    GoRoute(
      path: '/learn/hub/trivia',
      name: 'learnIslamicTrivia',
      redirect: (context, state) =>
          learnRedirectWithQuery('/learn/quizzes/trivia', state),
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
