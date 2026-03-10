import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/diagnostics/app_telemetry.dart';
import '../l10n/app_localizations.dart';
import '../features/journey/presentation/journey_page.dart';
import '../features/learn/presentation/learn_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/profile/presentation/profile_summary_page.dart';
import '../features/profile/presentation/settings_page.dart';
import '../features/worship/presentation/khusu_focus_page.dart';
import '../features/shared/section_detail_page.dart';
import '../features/shared/legal_info_page.dart';
import '../features/salah/presentation/salah_page.dart';
import '../features/worship/presentation/worship_page.dart';
import '../features/quran/presentation/quran_verse_page.dart';
import '../features/learn/quran/presentation/quran_bookmarks_page.dart';
import '../features/learn/quran/presentation/quran_notes_page.dart';
import '../features/learn/quran/presentation/quran_reader_page.dart';
import '../features/learn/quran/presentation/quran_search_page.dart';
import '../features/learn/quran/presentation/quran_surah_explorer_page.dart';
import '../features/learn/quran/presentation/names_of_allah_page.dart';
import '../features/learn/quran/presentation/quran_words_page.dart';
import '../features/learn/quran/presentation/quran_word_review_page.dart';
import '../features/learn/content/domain/learn_topic_category.dart';
import '../features/learn/content/presentation/learn_content_detail_page.dart';
import '../features/learn/content/presentation/learn_notes_landing_page.dart';
import '../features/learn/content/presentation/islamic_guides_page.dart';
import '../features/learn/content/presentation/quran_lessons_mapping_page.dart';
import '../features/ocean/presentation/ocean_drops_page.dart';
import '../features/wallpaper/presentation/wallpaper_library_page.dart';
import '../features/assistant/presentation/assistant_page.dart';
import '../features/circles/presentation/circle_detail_page.dart';
import '../features/circles/presentation/community_events_page.dart';
import '../features/circles/presentation/community_moderation_page.dart';
import '../features/circles/presentation/circles_discovery_page.dart';
import '../features/circles/presentation/circles_joined_page.dart';
import '../features/circles/presentation/mosque_buddy_page.dart';
import '../features/circles/presentation/nearby_mosques_page.dart';
import '../features/circles/presentation/accountability_groups_page.dart';
import '../features/circles/application/circles_provider.dart';
import '../features/journal/presentation/journal_timeline_page.dart';
import '../features/journal/presentation/journal_create_page.dart';
import '../features/learn/life/presentation/life_landing_page.dart';
import '../features/learn/life/presentation/life_lesson_page.dart';
import '../features/learn/life/presentation/life_subcategory_page.dart';
import '../features/learn/life/presentation/life_theme_page.dart';
import '../features/learn/world/presentation/world_landing_page.dart';
import '../features/learn/world/presentation/world_lesson_page.dart';
import '../features/learn/world/presentation/world_subcategory_page.dart';
import '../features/learn/world/presentation/world_theme_page.dart';
import '../features/learn/hadith/presentation/hadith_landing_page.dart';
import '../features/learn/hadith/presentation/hadith_lesson_page.dart';
import '../features/learn/hadith/presentation/hadith_subcategory_page.dart';
import '../features/learn/hadith/presentation/hadith_theme_page.dart';
import '../features/learn/hadith/presentation/important_hadith_collection_page.dart';
import '../features/learn/hadith/presentation/important_hadith_detail_page.dart';
import '../features/learn/life/baby_names/presentation/baby_name_detail_page.dart';
import '../features/learn/life/baby_names/presentation/baby_names_browse_page.dart';
import '../features/learn/life/baby_names/presentation/baby_names_compare_page.dart';
import '../features/learn/life/baby_names/presentation/baby_names_favorites_page.dart';
import '../features/learn/life/baby_names/presentation/baby_names_finder_page.dart';
import '../features/learn/life/baby_names/presentation/baby_names_home_page.dart';
import '../features/onboarding/application/onboarding_state_provider.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../shared/widgets/app_scaffold.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

enum NavTab { worship, learn, home, journey, profile }

extension NavTabExt on NavTab {
  String get path {
    switch (this) {
      case NavTab.worship:
        return '/worship';
      case NavTab.learn:
        return '/learn';
      case NavTab.home:
        return '/home';
      case NavTab.journey:
        return '/journey';
      case NavTab.profile:
        return '/profile';
    }
  }

  IconData get icon {
    switch (this) {
      case NavTab.worship:
        return Icons.self_improvement_rounded;
      case NavTab.learn:
        return Icons.menu_book_outlined;
      case NavTab.home:
        return Icons.home_rounded;
      case NavTab.journey:
        return Icons.route_outlined;
      case NavTab.profile:
        return Icons.person_outline_rounded;
    }
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);
  final initial = onboardingCompleted ? NavTab.home.path : '/onboarding';
  return GoRouter(
    initialLocation: initial,
    observers: [TelemetryNavigatorObserver()],
    redirect: (context, state) {
      final path = state.uri.path;
      if (path == '/quran/explorer') return '/learn/quran/explorer';
      if (path == '/quran/search') return '/learn/quran/search';

      final onOnboarding = state.matchedLocation == '/onboarding';
      if (!onboardingCompleted && !onOnboarding) {
        return '/onboarding';
      }
      if (onboardingCompleted && onOnboarding) {
        return NavTab.home.path;
      }
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 30),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).routerNotFoundTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(state.uri.toString(), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) =>
            const MaterialPage(child: OnboardingPage()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return MaterialPage(
            child: AppShellScaffold(
              currentLocation: state.uri.toString(),
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/salah-times',
            name: 'salahTimes',
            pageBuilder: (context, state) =>
                const MaterialPage(child: SalahTimesPage()),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) =>
                const MaterialPage(child: SettingsPage()),
          ),
          GoRoute(
            path: '/profile/summary',
            name: 'profileSummary',
            pageBuilder: (context, state) =>
                const MaterialPage(child: ProfileSummaryPage()),
          ),
          GoRoute(
            path: '/legal/privacy',
            name: 'privacyPolicy',
            pageBuilder: (context, state) => const MaterialPage(
              child: LegalInfoPage(kind: LegalInfoKind.privacy),
            ),
          ),
          GoRoute(
            path: '/legal/terms',
            name: 'termsUsage',
            pageBuilder: (context, state) => const MaterialPage(
              child: LegalInfoPage(kind: LegalInfoKind.terms),
            ),
          ),
          GoRoute(
            path: '/legal/support',
            name: 'supportInfo',
            pageBuilder: (context, state) => const MaterialPage(
              child: LegalInfoPage(kind: LegalInfoKind.support),
            ),
          ),
          GoRoute(
            path: '/khusu-focus',
            name: 'khusuFocus',
            pageBuilder: (context, state) =>
                const MaterialPage(child: KhusuFocusPage()),
          ),
          GoRoute(
            path: '/quran-verse',
            name: 'quranVerse',
            pageBuilder: (context, state) {
              final params = state.uri.queryParameters;
              return MaterialPage(
                child: QuranVersePage(
                  arabic: params['arabic'] ?? '',
                  transliteration: params['transliteration'] ?? '',
                  translation: params['translation'] ?? '',
                  surah: int.tryParse(params['surah'] ?? ''),
                  ayah: int.tryParse(params['ayah'] ?? ''),
                  locationLabel: params['locationLabel'],
                ),
              );
            },
          ),
          GoRoute(
            path: '/learn/quran/explorer',
            name: 'quranExplorer',
            pageBuilder: (context, state) =>
                const MaterialPage(child: QuranSurahExplorerPage()),
          ),
          GoRoute(
            path: '/learn/quran/surah/:surahNumber',
            name: 'quranReader',
            pageBuilder: (context, state) {
              final surahNumber =
                  int.tryParse(state.pathParameters['surahNumber'] ?? '') ?? 1;
              final ayah = int.tryParse(
                state.uri.queryParameters['ayah'] ?? '',
              );
              return MaterialPage(
                child: QuranReaderPage(
                  surahNumber: surahNumber,
                  initialAyah: ayah,
                ),
              );
            },
          ),
          GoRoute(
            path: '/learn/quran/bookmarks',
            name: 'quranBookmarks',
            pageBuilder: (context, state) =>
                const MaterialPage(child: QuranBookmarksPage()),
          ),
          GoRoute(
            path: '/learn/quran/notes',
            name: 'quranNotes',
            pageBuilder: (context, state) =>
                const MaterialPage(child: QuranNotesPage()),
          ),
          GoRoute(
            path: '/learn/quran/search',
            name: 'quranSearch',
            pageBuilder: (context, state) =>
                const MaterialPage(child: QuranSearchPage()),
          ),
          GoRoute(
            path: '/learn/quran/names-of-allah',
            name: 'quranNamesOfAllah',
            pageBuilder: (context, state) =>
                const MaterialPage(child: NamesOfAllahPage()),
          ),
          GoRoute(
            path: '/learn/quran/top-words',
            name: 'quranTopWords',
            pageBuilder: (context, state) =>
                const MaterialPage(child: QuranWordsPage()),
          ),
          GoRoute(
            path: '/learn/quran/word-review',
            name: 'quranWordReview',
            pageBuilder: (context, state) =>
                const MaterialPage(child: QuranWordReviewPage()),
          ),
          GoRoute(
            path: '/journey/ocean',
            name: 'oceanDrops',
            pageBuilder: (context, state) =>
                const MaterialPage(child: OceanDropsPage()),
          ),
          GoRoute(
            path: '/journey/wallpapers',
            name: 'wallpaperLibrary',
            pageBuilder: (context, state) =>
                const MaterialPage(child: WallpaperLibraryPage()),
          ),
          GoRoute(
            path: '/assistant',
            name: 'assistant',
            pageBuilder: (context, state) =>
                const MaterialPage(child: AssistantPage()),
          ),
          GoRoute(
            path: '/circles',
            name: 'circlesDiscovery',
            pageBuilder: (context, state) =>
                const MaterialPage(child: CirclesDiscoveryPage()),
          ),
          GoRoute(
            path: '/circles/joined',
            name: 'circlesJoined',
            pageBuilder: (context, state) =>
                const MaterialPage(child: CirclesJoinedPage()),
          ),
          GoRoute(
            path: '/circles/events',
            name: 'circlesEventsCalendar',
            pageBuilder: (context, state) =>
                const MaterialPage(child: CommunityEventsPage()),
          ),
          GoRoute(
            path: '/circles/mosque-buddy',
            name: 'mosqueBuddyPrefs',
            pageBuilder: (context, state) =>
                const MaterialPage(child: MosqueBuddyPage()),
          ),
          GoRoute(
            path: '/circles/moderation',
            name: 'communityModeration',
            pageBuilder: (context, state) =>
                const MaterialPage(child: CommunityModerationPage()),
          ),
          GoRoute(
            path: '/circles/accountability',
            name: 'accountabilityGroups',
            pageBuilder: (context, state) =>
                const MaterialPage(child: AccountabilityGroupsPage()),
          ),
          GoRoute(
            path: '/circles/nearby-mosques',
            name: 'nearbyMosques',
            pageBuilder: (context, state) =>
                const MaterialPage(child: NearbyMosquesPage()),
          ),
          GoRoute(
            path: '/circles/:circleId',
            name: 'circleDetail',
            pageBuilder: (context, state) {
              final circleId = state.pathParameters['circleId'] ?? '';
              final known = stagedCircles.any((item) => item.id == circleId);
              if (!known) {
                return const MaterialPage(child: CirclesDiscoveryPage());
              }
              return MaterialPage(child: CircleDetailPage(circleId: circleId));
            },
          ),
          GoRoute(
            path: '/journal',
            name: 'journalTimeline',
            pageBuilder: (context, state) =>
                const MaterialPage(child: JournalTimelinePage()),
          ),
          GoRoute(
            path: '/journal/create',
            name: 'journalCreate',
            pageBuilder: (context, state) =>
                const MaterialPage(child: JournalCreatePage()),
          ),
          GoRoute(
            path: '/learn/life',
            name: 'learnLifeLanding',
            pageBuilder: (context, state) =>
                const MaterialPage(child: LifeLandingPage()),
          ),
          GoRoute(
            path: '/learn/life/theme/:themeId',
            name: 'lifeThemeDetail',
            pageBuilder: (context, state) {
              final themeId = state.pathParameters['themeId'] ?? '';
              if (themeId.isEmpty) {
                return const MaterialPage(child: LifeLandingPage());
              }
              return MaterialPage(child: LifeThemePage(themeId: themeId));
            },
          ),
          GoRoute(
            path: '/learn/life/subcategory/:subcategoryId',
            name: 'lifeSubcategoryDetail',
            pageBuilder: (context, state) {
              final subcategoryId = state.pathParameters['subcategoryId'] ?? '';
              if (subcategoryId.isEmpty) {
                return const MaterialPage(child: LifeLandingPage());
              }
              return MaterialPage(
                child: LifeSubcategoryPage(subcategoryId: subcategoryId),
              );
            },
          ),
          GoRoute(
            path: '/learn/life/lesson/:lessonId',
            name: 'lifeLessonDetail',
            pageBuilder: (context, state) {
              final lessonId = state.pathParameters['lessonId'] ?? '';
              if (lessonId.isEmpty) {
                return const MaterialPage(child: LifeLandingPage());
              }
              return MaterialPage(child: LifeLessonPage(lessonId: lessonId));
            },
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
              ),
            ),
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
              child: BabyNameDetailPage(
                nameId: state.pathParameters['nameId'] ?? '',
              ),
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
            path: '/learn/hadith/important/:number',
            name: 'hadithImportantDetail',
            pageBuilder: (context, state) {
              final number =
                  int.tryParse(state.pathParameters['number'] ?? '') ?? 1;
              return MaterialPage(
                child: ImportantHadithDetailPage(number: number),
              );
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
                child: LearnContentDetailPage(
                  category: category,
                  topicId: topicId,
                ),
              );
            },
          ),
          GoRoute(
            path: '/section/:sectionId',
            name: 'featureSection',
            pageBuilder: (context, state) {
              final id = state.pathParameters['sectionId']!;
              final meta =
                  _sectionMeta[id] ??
                  const _SectionMeta(
                    title: 'Section',
                    subtitle: 'Detailed section placeholder view.',
                    quoteKey: 'home',
                  );

              return MaterialPage(
                child: FeatureSectionPage(
                  sectionId: id,
                  title: meta.title,
                  subtitle: meta.subtitle,
                  quote:
                      sectionQuotes[meta.quoteKey] ??
                      journeySectionQuotes[meta.quoteKey] ??
                      sectionQuotes['home']!,
                ),
              );
            },
          ),
          ...NavTab.values.map(
            (tab) => GoRoute(
              path: tab.path,
              name: tab.name,
              pageBuilder: (context, state) =>
                  MaterialPage(child: _buildTabPage(tab)),
            ),
          ),
        ],
      ),
    ],
  );
});

Widget _buildTabPage(NavTab tab) {
  switch (tab) {
    case NavTab.worship:
      return const WorshipPage();
    case NavTab.learn:
      return const LearnPage();
    case NavTab.home:
      return const HomePage();
    case NavTab.journey:
      return const JourneyPage();
    case NavTab.profile:
      return const ProfilePage();
  }
}

class _SectionMeta {
  const _SectionMeta({
    required this.title,
    required this.subtitle,
    required this.quoteKey,
  });

  final String title;
  final String subtitle;
  final String quoteKey;
}

void goToTab(BuildContext context, NavTab tab) {
  final current = GoRouterState.of(context).uri.toString();
  if (current != tab.path) {
    context.go(tab.path);
  }
}

NavTab navTabFromLocation(String location) {
  for (final tab in NavTab.values) {
    if (location.startsWith(tab.path)) {
      return tab;
    }
  }
  return NavTab.home;
}

final Map<String, _SectionMeta> _sectionMeta = {
  'prayer': const _SectionMeta(
    title: 'Prayer',
    subtitle: 'Daily prayer structure and rhythm controls.',
    quoteKey: 'prayer',
  ),
  'dhikr': const _SectionMeta(
    title: 'Dhikr',
    subtitle: 'Sacred remembrance flow and counters.',
    quoteKey: 'dhikr',
  ),
  'fasting': const _SectionMeta(
    title: 'Fasting',
    subtitle: 'Fast status tracking and reflection.',
    quoteKey: 'fasting',
  ),
  'khusu': const _SectionMeta(
    title: 'Khusū Mode',
    subtitle: 'Distraction-minimized worship focus.',
    quoteKey: 'khusu',
  ),
  'worshipSummary': const _SectionMeta(
    title: 'Daily Worship Summary',
    subtitle: 'A calm snapshot of today\'s worship rhythm.',
    quoteKey: 'prayer',
  ),
  'quickAccess': const _SectionMeta(
    title: 'Quick Access',
    subtitle: 'Fast entry points into meaningful actions.',
    quoteKey: 'khusu',
  ),
  'quran': const _SectionMeta(
    title: 'Qur’an',
    subtitle: 'Read, search, and annotate with intention.',
    quoteKey: 'learn',
  ),
  'lifeThroughQuran': const _SectionMeta(
    title: 'Life Through the Qur\'aan',
    subtitle: 'Practical lessons for this time of life.',
    quoteKey: 'learn',
  ),
  'worldThroughQuran': const _SectionMeta(
    title: 'World Through the Qur\'aan',
    subtitle: 'Contextual reflection and global reminders.',
    quoteKey: 'learn',
  ),
  'hadithLessons': const _SectionMeta(
    title: 'Hadith Lessons',
    subtitle: 'Companion narrations and core learnings.',
    quoteKey: 'learn',
  ),
  'reflections': const _SectionMeta(
    title: 'Reflections / Notes',
    subtitle: 'A grounded place to capture spiritual notes.',
    quoteKey: 'journey',
  ),
  'continueLearning': const _SectionMeta(
    title: 'Continue Learning',
    subtitle: 'Resume from your latest learning session.',
    quoteKey: 'learn',
  ),
  'home-daily-nur': const _SectionMeta(
    title: 'Daily Nur Progress',
    subtitle: 'Your daily progress snapshot.',
    quoteKey: 'home',
  ),
  'home-prayer-summary': const _SectionMeta(
    title: 'Prayer Summary',
    subtitle: 'A focused prayer check-in view.',
    quoteKey: 'prayer',
  ),
  'home-dhikr-quick': const _SectionMeta(
    title: 'Dhikr Quick Access',
    subtitle: 'Direct dhikr entry from Home.',
    quoteKey: 'dhikr',
  ),
  'home-quran-continue': const _SectionMeta(
    title: 'Continue Qur\'aan',
    subtitle: 'Resume reading and reflection.',
    quoteKey: 'learn',
  ),
  'journey-home': const _SectionMeta(
    title: 'Journey Overview',
    subtitle: 'Levels, XP, and long term markers.',
    quoteKey: 'journey-home',
  ),
  'journey-rings': const _SectionMeta(
    title: 'Daily Rings',
    subtitle: 'Habit rings and balance of effort.',
    quoteKey: 'journey-rings',
  ),
  'journey-streak': const _SectionMeta(
    title: 'Streak Summary',
    subtitle: 'Consistency as an act of soft discipline.',
    quoteKey: 'journey-streak',
  ),
  'journey-milestones': const _SectionMeta(
    title: 'Milestones',
    subtitle: 'Near milestones and growth edges.',
    quoteKey: 'journey-milestones',
  ),
  'journey-unlocks': const _SectionMeta(
    title: 'Unlocks',
    subtitle: 'Upcoming reward and next unlock states.',
    quoteKey: 'journey-unlocks',
  ),
  'journey-garden': const _SectionMeta(
    title: 'Garden / Tree / Character',
    subtitle: 'Growth systems and visual progression.',
    quoteKey: 'journey-garden',
  ),
  'journey-ocean': const _SectionMeta(
    title: 'Ocean of Drops',
    subtitle: 'Persistent drops build into spiritual presence.',
    quoteKey: 'journey-ocean',
  ),
};

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
