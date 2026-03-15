import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts_sync/presentation/accounts_profiles_sync_page.dart';
import '../../features/learn/quran/presentation/names_of_allah_page.dart';
import '../../features/learn/quran/presentation/quran_bookmarks_page.dart';
import '../../features/learn/quran/presentation/quran_notes_page.dart';
import '../../features/learn/quran/presentation/quran_reader_page.dart';
import '../../features/learn/quran/presentation/quran_search_page.dart';
import '../../features/learn/quran/presentation/quran_surah_explorer_page.dart';
import '../../features/learn/quran/presentation/quran_topic_explorer_page.dart';
import '../../features/learn/quran/presentation/quran_word_review_page.dart';
import '../../features/learn/quran/presentation/quran_words_page.dart';
import '../../features/ocean/presentation/ocean_drops_page.dart';
import '../../features/profile/presentation/profile_coming_soon_page.dart';
import '../../features/profile/presentation/profile_summary_page.dart';
import '../../features/profile/presentation/profile_whats_new_page.dart';
import '../../features/profile/presentation/settings_page.dart';
import '../../features/quran/presentation/quran_verse_page.dart';
import '../../features/salah/presentation/salah_page.dart';
import '../../features/shared/attributions_licenses_page.dart';
import '../../features/shared/legal_info_page.dart';
import '../../features/worship/presentation/khusu_focus_page.dart';
import '../../features/worship/presentation/qibla_finder_page.dart';

List<RouteBase> buildCoreSupportRoutes() {
  return <RouteBase>[
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
      path: '/accounts-sync',
      name: 'accountsSync',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AccountsProfilesSyncPage()),
    ),
    GoRoute(
      path: '/accounts-sync/profiles',
      name: 'profilesInAccount',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ProfilesInAccountPage()),
    ),
    GoRoute(
      path: '/accounts-sync/accounts',
      name: 'signedInAccounts',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SignedInAccountsPage()),
    ),
    GoRoute(
      path: '/accounts-sync/shared-device',
      name: 'sharedDeviceSafety',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SharedDeviceSafetyPage()),
    ),
    GoRoute(
      path: '/accounts-sync/devices',
      name: 'connectedDevices',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ConnectedDevicesPage()),
    ),
    GoRoute(
      path: '/accounts-sync/backup',
      name: 'backupRestore',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BackupRestoreHomePage()),
    ),
    GoRoute(
      path: '/accounts-sync/backup/export',
      name: 'backupExport',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BackupExportFlowPage()),
    ),
    GoRoute(
      path: '/accounts-sync/backup/import',
      name: 'backupImport',
      pageBuilder: (context, state) =>
          const MaterialPage(child: BackupImportFlowPage()),
    ),
    GoRoute(
      path: '/accounts-sync/sync-details',
      name: 'syncDetails',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SyncDetailsPage()),
    ),
    GoRoute(
      path: '/profile/summary',
      name: 'profileSummary',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ProfileSummaryPage()),
    ),
    GoRoute(
      path: '/profile/whats-new',
      name: 'profileWhatsNew',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ProfileWhatsNewPage()),
    ),
    GoRoute(
      path: '/profile/coming-soon',
      name: 'profileComingSoon',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ProfileComingSoonPage()),
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
      path: '/legal/attributions',
      name: 'attributionsLicenses',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AttributionsLicensesPage()),
    ),
    GoRoute(
      path: '/khusu-focus',
      name: 'khusuFocus',
      pageBuilder: (context, state) =>
          const MaterialPage(child: KhusuFocusPage()),
    ),
    GoRoute(
      path: '/qibla-finder',
      name: 'qiblaFinder',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QiblaFinderPage()),
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
        final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
        final endAyah = int.tryParse(state.uri.queryParameters['endAyah'] ?? '');
        final autoPlay = switch ((state.uri.queryParameters['autoplay'] ?? '')
            .toLowerCase()) {
          '1' || 'true' || 'yes' => true,
          _ => false,
        };
        return MaterialPage(
          child: QuranReaderPage(
            surahNumber: surahNumber,
            initialAyah: ayah,
            endAyah: endAyah,
            autoPlay: autoPlay,
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
      path: '/learn/quran/topics',
      name: 'quranTopicExplorer',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranTopicExplorerPage()),
    ),
    GoRoute(
      path: '/learn/quran/topics/:topicId',
      name: 'quranTopicDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranTopicExplorerPage(
          topicId: state.pathParameters['topicId'],
        ),
      ),
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
  ];
}
