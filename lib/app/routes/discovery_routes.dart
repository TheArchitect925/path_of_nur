import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/assistant/presentation/assistant_page.dart';
import '../../features/celestial/presentation/celestial_explorer_page.dart';
import '../../features/circles/application/circles_provider.dart';
import '../../features/circles/presentation/accountability_groups_page.dart';
import '../../features/circles/presentation/circle_detail_page.dart';
import '../../features/circles/presentation/circles_discovery_page.dart';
import '../../features/circles/presentation/circles_joined_page.dart';
import '../../features/circles/presentation/community_events_page.dart';
import '../../features/circles/presentation/community_moderation_page.dart';
import '../../features/circles/presentation/mosque_buddy_page.dart';
import '../../features/circles/presentation/nearby_mosques_page.dart';
import '../../features/creation_challenges/presentation/creation_challenges_page.dart';
import '../../features/creation_explorer/presentation/creation_explorer_page.dart';
import '../../features/journal/presentation/journal_create_page.dart';
import '../../features/journal/presentation/journal_entry_detail_page.dart';
import '../../features/journal/presentation/journal_timeline_page.dart';

List<RouteBase> buildDiscoveryRoutes() {
  return <RouteBase>[
    GoRoute(
      path: '/assistant',
      name: 'assistant',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AssistantPage()),
    ),
    GoRoute(
      path: '/sky-explorer',
      name: 'skyExplorer',
      pageBuilder: (context, state) =>
          const MaterialPage(child: CelestialExplorerPage()),
    ),
    GoRoute(
      path: '/explore/creation',
      name: 'creationExplorer',
      pageBuilder: (context, state) =>
          const MaterialPage(child: CreationExplorerPage()),
    ),
    GoRoute(
      path: '/explore/challenges',
      name: 'creationChallenges',
      pageBuilder: (context, state) =>
          const MaterialPage(child: CreationChallengesPage()),
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
      path: '/journal/entry/:entryId',
      name: 'journalEntryDetail',
      pageBuilder: (context, state) {
        final entryId = state.pathParameters['entryId'] ?? '';
        return MaterialPage(child: JournalEntryDetailPage(entryId: entryId));
      },
    ),
  ];
}
