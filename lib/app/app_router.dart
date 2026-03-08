import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/journey/presentation/journey_page.dart';
import '../features/learn/presentation/learn_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/worship/presentation/khusu_focus_page.dart';
import '../features/shared/section_detail_page.dart';
import '../features/salah/presentation/salah_page.dart';
import '../features/worship/presentation/worship_page.dart';
import '../features/quran/presentation/quran_verse_page.dart';
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
  final initial = NavTab.home.path;
  return GoRouter(
    initialLocation: initial,
    routes: [
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
                const MaterialPage(child: ProfilePage()),
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
