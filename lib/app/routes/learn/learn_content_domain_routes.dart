import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/learn/content/presentation/learn_content_detail_page.dart';
import '../../../features/learn/content/presentation/learn_notes_browse_page.dart';
import '../../../features/learn/content/presentation/learn_notes_landing_page.dart';
import '../../../features/learn/companion_surfaces/presentation/character_companion_page.dart';
import '../../../features/learn/companion_surfaces/presentation/daily_wisdom_companion_page.dart';
import '../../../features/learn/companion_surfaces/presentation/seerah_companion_page.dart';
import '../../../features/learn/divine_life_lessons/presentation/divine_life_lesson_detail_page.dart';
import '../../../features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart';
import '../../../features/learn/divine_life_lessons/presentation/divine_life_reflection_page.dart';
import '../../../features/learn/hadith/application/hadith_path_quiz_service.dart';
import '../../../features/learn/hadith/presentation/hadith_browse_page.dart';
import '../../../features/learn/hadith/presentation/hadith_landing_page.dart';
import '../../../features/learn/hadith/presentation/hadith_learning_path_page.dart';
import '../../../features/learn/hadith/presentation/hadith_lesson_page.dart';
import '../../../features/learn/hadith/presentation/hadith_narrator_page.dart';
import '../../../features/learn/hadith/presentation/hadith_quiz_session_page.dart';
import '../../../features/learn/hadith/presentation/hadith_reader_continuity.dart';
import '../../../features/learn/hadith/presentation/hadith_search_page.dart';
import '../../../features/learn/hadith/presentation/hadith_source_browse_page.dart';
import '../../../features/learn/hadith/presentation/hadith_subcategory_page.dart';
import '../../../features/learn/hadith/presentation/hadith_theme_page.dart';
import '../../../features/learn/hadith/presentation/important_hadith_collection_page.dart';
import '../../../features/learn/hadith/presentation/important_hadith_detail_page.dart';
import '../../../features/learn/life/baby_names/presentation/baby_name_detail_page.dart';
import '../../../features/learn/life/baby_names/presentation/baby_names_browse_page.dart';
import '../../../features/learn/life/baby_names/presentation/baby_names_compare_page.dart';
import '../../../features/learn/life/baby_names/presentation/baby_names_favorites_page.dart';
import '../../../features/learn/life/baby_names/presentation/baby_names_finder_page.dart';
import '../../../features/learn/life/baby_names/presentation/baby_names_generator_page.dart';
import '../../../features/learn/life/baby_names/presentation/baby_names_home_page.dart';
import '../../../features/learn/life/baby_names/presentation/baby_names_meaning_explorer_page.dart';
import '../../../features/learn/quran_universe/presentation/knowledge_constellation_page.dart';
import '../../../features/learn/quran_universe/presentation/quran_universe_page.dart';
import '../../../features/learn/world/presentation/world_landing_page.dart';
import '../../../features/learn/world/presentation/world_lesson_page.dart';
import '../../../features/learn/world/presentation/world_subcategory_page.dart';
import '../../../features/learn/world/presentation/world_theme_page.dart';
import '../../../features/learn/world/presentation/pages/world_atmosphere_layers_page.dart';
import '../../../features/learn/world/presentation/pages/world_cosmic_scale_page.dart';
import '../../../features/learn/world/presentation/pages/world_creation_category_page.dart';
import '../../../features/learn/world/presentation/pages/world_creation_lesson_page.dart';
import '../../../features/learn/world/presentation/pages/world_creation_reflection_mode_page.dart';
import '../../../features/learn/world/presentation/pages/world_deep_ocean_page.dart';
import '../../../features/learn/world/presentation/pages/world_explore_creation_page.dart';
import '../../../features/learn/world/presentation/pages/world_muslim_scientists_page.dart';
import '../../../features/learn/world/presentation/pages/world_signs_explorer_page.dart';
import 'learn_route_helpers.dart';
import '../../../features/learn/hadith/application/hadith_search_support.dart';

List<RouteBase> buildLearnContentDomainRoutes() {
  return <RouteBase>[
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
      path: '/learn/life',
      name: 'learnLifeLanding',
      pageBuilder: (context, state) => MaterialPage(
        child: DivineLifeLessonsPage(
          initialThemeId: state.uri.queryParameters['themeId'],
          initialSituationId: state.uri.queryParameters['situationId'],
          section: state.uri.queryParameters['section'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/seerah',
      name: 'learnSeerahCompanion',
      pageBuilder: (context, state) => MaterialPage(
        child: SeerahCompanionPage(
          initialFocus: state.uri.queryParameters['focus'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/character',
      name: 'learnCharacterCompanion',
      pageBuilder: (context, state) => MaterialPage(
        child: CharacterCompanionPage(
          initialFocus: state.uri.queryParameters['focus'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/daily-wisdom',
      name: 'learnDailyWisdomCompanion',
      pageBuilder: (context, state) => MaterialPage(
        child: DailyWisdomCompanionPage(
          initialFocus: state.uri.queryParameters['focus'],
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
      pageBuilder: (context, state) => MaterialPage(
        child: WorldLandingPage(section: state.uri.queryParameters['section']),
      ),
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
      pageBuilder: (context, state) => MaterialPage(
        child: HadithLandingPage(
          initialTabName: state.uri.queryParameters['section'],
        ),
      ),
    ),
    GoRoute(
      path: '/learn/hadith/browse',
      name: 'hadithBrowse',
      pageBuilder: (context, state) =>
          const MaterialPage(child: HadithBrowsePage()),
    ),
    GoRoute(
      path: '/learn/hadith/search',
      name: 'hadithSearch',
      pageBuilder: (context, state) => MaterialPage(
        child: HadithSearchPage(
          initialQuery: state.uri.queryParameters['q'] ?? '',
          initialFilter: HadithSearchFilterX.fromWireValue(
            state.uri.queryParameters['filter'],
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/learn/hadith/sources',
      name: 'hadithSourceBrowse',
      pageBuilder: (context, state) =>
          const MaterialPage(child: HadithSourceBrowsePage()),
    ),
    GoRoute(
      path: '/learn/hadith/source/:sourceId',
      name: 'hadithSourceDetail',
      pageBuilder: (context, state) {
        final sourceId = state.pathParameters['sourceId'] ?? '';
        if (sourceId.isEmpty) {
          return const MaterialPage(child: HadithSourceBrowsePage());
        }
        return MaterialPage(child: HadithSourceBrowsePage(sourceId: sourceId));
      },
    ),
    GoRoute(
      path: '/learn/hadith/source/:sourceId/chapter/:chapterId',
      name: 'hadithSourceChapterDetail',
      pageBuilder: (context, state) {
        final sourceId = state.pathParameters['sourceId'] ?? '';
        final chapterId = state.pathParameters['chapterId'] ?? '';
        if (sourceId.isEmpty || chapterId.isEmpty) {
          return const MaterialPage(child: HadithSourceBrowsePage());
        }
        return MaterialPage(
          child: HadithSourceBrowsePage(
            sourceId: sourceId,
            chapterId: chapterId,
          ),
        );
      },
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
      path: '/learn/hadith/collection/:collectionId',
      name: 'hadithCollectionDetail',
      pageBuilder: (context, state) {
        final collectionId = state.pathParameters['collectionId'] ?? '';
        if (collectionId.isEmpty) {
          return const MaterialPage(child: HadithLandingPage());
        }
        return MaterialPage(
          child: HadithCollectionPage(collectionId: collectionId),
        );
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
          child: HadithCollectionPage(collectionId: subcategoryId),
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
        return MaterialPage(
          child: HadithLessonPage(
            lessonId: lessonId,
            laneContext: switch (state.extra) {
              final HadithReaderLaneContext lane => lane,
              _ => null,
            },
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/hadith/narrator/:narratorId',
      name: 'hadithNarratorDetail',
      pageBuilder: (context, state) {
        final narratorId = state.pathParameters['narratorId'] ?? '';
        if (narratorId.isEmpty) {
          return const MaterialPage(child: HadithLandingPage());
        }
        return MaterialPage(child: HadithNarratorPage(narratorId: narratorId));
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
      path: '/learn/notes/browse',
      name: 'learnNotesBrowseAll',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LearnNotesBrowsePage()),
    ),
    GoRoute(
      path: '/learn/content/:category/:topicId',
      name: 'learnContentDetail',
      pageBuilder: (context, state) {
        final categoryParam = state.pathParameters['category'] ?? 'life';
        final topicId = state.pathParameters['topicId'] ?? '';
        final category = learnTopicCategoryFromParam(categoryParam);
        return MaterialPage(
          child: LearnContentDetailPage(category: category, topicId: topicId),
        );
      },
    ),
  ];
}
