import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts_sync/domain/accounts_sync_models.dart';
import '../../features/accounts_sync/presentation/accounts_profiles_sync_page.dart';
import '../../features/editorial_dashboard/presentation/editorial_dashboard_page.dart';
import '../../features/editorial_dashboard/presentation/editorial_dashboard_pin_page.dart';
import '../../features/editorial_dashboard/presentation/editorial_content_browser_page.dart';
import '../../features/editorial_dashboard/presentation/editorial_content_editor_page.dart';
import '../../features/home/presentation/home_edit_page.dart';
import '../../features/learn/quran/presentation/names_of_allah_page.dart';
import '../../features/learn/quran/presentation/quran_bookmarks_page.dart';
import '../../features/learn/quran/presentation/quran_focus_recitation_page.dart';
import '../../features/learn/quran/presentation/quran_memorization_review_page.dart';
import '../../features/learn/quran/presentation/quran_notes_page.dart';
import '../../features/learn/quran/application/quran_search_support.dart';
import '../../features/learn/quran/presentation/quran_reflections_page.dart';
import '../../features/learn/quran/presentation/quran_reader_page.dart';
import '../../features/learn/quran/presentation/quran_search_page.dart';
import '../../features/learn/quran/presentation/quran_surah_insight_page.dart';
import '../../features/learn/quran/presentation/quran_surah_explorer_page.dart';
import '../../features/learn/quran/presentation/quran_word_detail_page.dart';
import '../../features/learn/quran/presentation/quran_topic_explorer_page.dart';
import '../../features/learn/quran/presentation/quran_word_review_page.dart';
import '../../features/learn/quran/presentation/quran_words_page.dart';
import '../../features/learn/quran/domain/quran_reference_models.dart';
import '../../features/ocean/presentation/ocean_dashboard_page.dart';
import '../../features/ocean/presentation/ocean_drops_page.dart';
import '../../features/profile/presentation/profile_coming_soon_page.dart';
import '../../features/profile/presentation/help_guide_detail_page.dart';
import '../../features/profile/presentation/help_guide_hub_page.dart';
import '../../features/profile/presentation/profile_summary_page.dart';
import '../../features/profile/presentation/profile_whats_new_page.dart';
import '../../features/profile/presentation/settings_page.dart';
import '../../features/search/presentation/all_search_page.dart';
import '../../features/shared/attributions_licenses_page.dart';
import '../../features/shared/legal_info_page.dart';
import '../../features/worship/presentation/qibla_finder_page.dart';

String _redirectWithQuery(String path, GoRouterState state) {
  return Uri(
    path: path,
    queryParameters: state.uri.queryParameters.isEmpty
        ? null
        : state.uri.queryParameters,
  ).toString();
}

String _redirectWithPathAndQuery(String pathTemplate, GoRouterState state) {
  var path = pathTemplate;
  state.pathParameters.forEach((key, value) {
    path = path.replaceAll(':$key', value);
  });
  return _redirectWithQuery(path, state);
}

List<RouteBase> buildCoreSupportRoutes() {
  return <RouteBase>[
    // /salah-times merged into the Salah Hub's Times tab
    // (calm-navigation Phase 3b); the name stays for notification deep links.
    GoRoute(
      path: '/salah-times',
      name: 'salahTimes',
      redirect: (context, state) => '/worship/prayer',
    ),
    GoRoute(
      path: '/home/edit',
      name: 'homeEdit',
      pageBuilder: (context, state) =>
          const MaterialPage(child: HomeEditPage()),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SettingsPage()),
    ),
    GoRoute(
      path: '/settings/account-sync',
      name: 'settingsAccountSync',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.accountSync),
      ),
    ),
    GoRoute(
      path: '/settings/appearance',
      name: 'settingsAppearance',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.appearance),
      ),
    ),
    GoRoute(
      path: '/settings/prayer-worship',
      name: 'settingsPrayerWorship',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.prayerWorship),
      ),
    ),
    GoRoute(
      path: '/settings/learning',
      name: 'settingsLearning',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.learning),
      ),
    ),
    GoRoute(
      path: '/settings/notifications-reminders',
      name: 'settingsNotificationsReminders',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.notificationsReminders),
      ),
    ),
    GoRoute(
      path: '/settings/widgets-watch',
      name: 'settingsWidgetsWatch',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.widgetsWatch),
      ),
    ),
    GoRoute(
      path: '/settings/language-downloads',
      name: 'settingsLanguageDownloads',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.languageDownloads),
      ),
    ),
    GoRoute(
      path: '/settings/privacy-data',
      name: 'settingsPrivacyData',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.privacyData),
      ),
    ),
    GoRoute(
      path: '/settings/about',
      name: 'settingsAbout',
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingsPage(category: SettingsCategory.about),
      ),
    ),
    GoRoute(
      path: '/search',
      name: 'allSearch',
      pageBuilder: (context, state) => MaterialPage(
        child: AllSearchPage(
          initialQuery: state.uri.queryParameters['q'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/search',
      redirect: (context, state) => _redirectWithQuery('/search', state),
    ),
    GoRoute(
      path: '/internal/editorial/pin',
      name: 'editorialDashboardPin',
      pageBuilder: (context, state) =>
          const MaterialPage(child: EditorialDashboardPinPage()),
    ),
    GoRoute(
      path: '/internal/editorial',
      name: 'editorialDashboard',
      pageBuilder: (context, state) =>
          const MaterialPage(child: EditorialDashboardPage()),
    ),
    GoRoute(
      path: '/internal/editorial/content/:contentType',
      name: 'editorialContentBrowser',
      pageBuilder: (context, state) {
        final type = editorialContentTypeFromRouteSegment(
          state.pathParameters['contentType'] ?? '',
        );
        return MaterialPage(
          child: type == null
              ? const EditorialDashboardPage()
              : EditorialContentBrowserPage(contentType: type),
        );
      },
    ),
    GoRoute(
      path: '/internal/editorial/content/:contentType/edit',
      name: 'editorialContentEditor',
      pageBuilder: (context, state) {
        final type = editorialContentTypeFromRouteSegment(
          state.pathParameters['contentType'] ?? '',
        );
        final contentId = state.uri.queryParameters['id'] ?? '';
        return MaterialPage(
          child: type == null || contentId.isEmpty
              ? const EditorialDashboardPage()
              : EditorialContentEditorPage(
                  contentType: type,
                  contentId: contentId,
                ),
        );
      },
    ),
    GoRoute(
      path: '/settings/help-guide',
      name: 'settingsHelpGuide',
      pageBuilder: (context, state) =>
          const MaterialPage(child: HelpGuideHubPage()),
    ),
    GoRoute(
      path: '/settings/help-guide/:guideId',
      name: 'settingsHelpGuideDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: HelpGuideDetailPage(
          guideId: state.pathParameters['guideId'] ?? '',
        ),
      ),
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
      path: '/accounts-sync/backup/remote-restore',
      name: 'remoteBackupRestorePreview',
      pageBuilder: (context, state) => MaterialPage(
        child: RemoteRestorePreviewPage(
          preview: state.extra! as RestorePreview,
        ),
      ),
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
      path: '/settings/summary',
      name: 'profileSummary',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ProfileSummaryPage()),
    ),
    GoRoute(
      path: '/profile/summary',
      redirect: (context, state) =>
          _redirectWithQuery('/settings/summary', state),
    ),
    GoRoute(
      path: '/settings/whats-new',
      name: 'profileWhatsNew',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ProfileWhatsNewPage()),
    ),
    GoRoute(
      path: '/profile/whats-new',
      redirect: (context, state) =>
          _redirectWithQuery('/settings/whats-new', state),
    ),
    GoRoute(
      path: '/settings/coming-soon',
      name: 'profileComingSoon',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ProfileComingSoonPage()),
    ),
    GoRoute(
      path: '/profile/coming-soon',
      redirect: (context, state) =>
          _redirectWithQuery('/settings/coming-soon', state),
    ),
    GoRoute(
      path: '/legal/privacy',
      name: 'privacyPolicy',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LegalInfoPage(kind: LegalInfoKind.privacy)),
    ),
    GoRoute(
      path: '/legal/terms',
      name: 'termsUsage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LegalInfoPage(kind: LegalInfoKind.terms)),
    ),
    GoRoute(
      path: '/legal/support',
      name: 'supportInfo',
      pageBuilder: (context, state) =>
          const MaterialPage(child: LegalInfoPage(kind: LegalInfoKind.support)),
    ),
    GoRoute(
      path: '/legal/attributions',
      name: 'attributionsLicenses',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AttributionsLicensesPage()),
    ),
    // Khushu focus was cut from the IA (calm-navigation Phase 3b) — the
    // built-but-unwired KhusuSection stays parked for a future revival.
    GoRoute(
      path: '/khusu-focus',
      name: 'khusuFocus',
      redirect: (context, state) => '/worship',
    ),
    GoRoute(
      path: '/qibla-finder',
      name: 'qiblaFinder',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QiblaFinderPage()),
    ),
    GoRoute(
      path: '/quran/explorer',
      name: 'quranExplorer',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranSurahExplorerPage()),
    ),
    GoRoute(
      path: '/learn/quran/explorer',
      redirect: (context, state) =>
          _redirectWithQuery('/quran/explorer', state),
    ),
    GoRoute(
      path: '/quran/surah-insights',
      name: 'quranSurahInsightsBrowse',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranSurahInsightsBrowsePage()),
    ),
    GoRoute(
      path: '/quran/surah/:surahNumber/insights',
      name: 'quranSurahInsights',
      pageBuilder: (context, state) {
        final surahNumber =
            int.tryParse(state.pathParameters['surahNumber'] ?? '') ?? 1;
        return MaterialPage(
          child: QuranSurahInsightPage(surahNumber: surahNumber),
        );
      },
    ),
    GoRoute(
      path: '/quran/focus-recitation',
      name: 'quranFocusRecitation',
      pageBuilder: (context, state) {
        final surahNumber = int.tryParse(
          state.uri.queryParameters['surah'] ?? '',
        );
        final ayahNumber = int.tryParse(
          state.uri.queryParameters['ayah'] ?? '',
        );
        return MaterialPage(
          child: QuranFocusRecitationPage(
            initialSurahNumber: surahNumber,
            initialAyahNumber: ayahNumber,
          ),
        );
      },
    ),
    GoRoute(
      path: '/quran/surah/:surahNumber',
      name: 'quranReader',
      pageBuilder: (context, state) {
        final surahNumber =
            int.tryParse(state.pathParameters['surahNumber'] ?? '') ?? 1;
        final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
        final endAyah = int.tryParse(
          state.uri.queryParameters['endAyah'] ?? '',
        );
        final journeyId = state.uri.queryParameters['journeyId'];
        final stageId = state.uri.queryParameters['stageId'];
        final topicId = state.uri.queryParameters['topicId'];
        final mode = QuranReaderStudyMode.tryParse(
          state.uri.queryParameters['mode'],
        );
        final searchQuery = state.uri.queryParameters['search']?.trim();
        final searchField = QuranSearchMatchFieldX.fromWireValue(
          state.uri.queryParameters['searchField'],
        );
        final review = state.uri.queryParameters['review'];
        final memorizationReviewCount = int.tryParse(
          state.uri.queryParameters['reviewCount'] ?? '',
        );
        final memorizationLastReviewed = DateTime.tryParse(
          state.uri.queryParameters['lastReviewed'] ?? '',
        );
        final autoPlay = switch ((state.uri.queryParameters['autoplay'] ?? '')
            .toLowerCase()) {
          '1' || 'true' || 'yes' => true,
          _ => false,
        };
        final autoPlayFocusedSelectionLoop =
            state.uri.queryParameters['playback'] == 'selectionLoop';
        return MaterialPage(
          child: QuranReaderPage(
            surahNumber: surahNumber,
            initialAyah: ayah,
            endAyah: endAyah,
            autoPlay: autoPlay,
            autoPlayFocusedSelectionLoop: autoPlayFocusedSelectionLoop,
            learningJourneyId: journeyId,
            learningJourneyStageId: stageId,
            highlightedTopicId: topicId,
            memorizationReviewMode: review == 'memorization',
            studyMode: mode,
            memorizationReviewCount: memorizationReviewCount,
            memorizationLastReviewed: memorizationLastReviewed,
            initialSearchQuery: searchQuery?.isEmpty ?? true
                ? null
                : searchQuery,
            initialSearchField: searchField,
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/quran/surah/:surahNumber',
      redirect: (context, state) =>
          _redirectWithPathAndQuery('/quran/surah/:surahNumber', state),
    ),
    GoRoute(
      path: '/quran/review',
      name: 'quranMemorizationReview',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranMemorizationReviewPage()),
    ),
    GoRoute(
      path: '/learn/quran/review',
      redirect: (context, state) => _redirectWithQuery('/quran/review', state),
    ),
    GoRoute(
      path: '/quran/bookmarks',
      name: 'quranBookmarks',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranBookmarksPage()),
    ),
    GoRoute(
      path: '/learn/quran/bookmarks',
      redirect: (context, state) =>
          _redirectWithQuery('/quran/bookmarks', state),
    ),
    GoRoute(
      path: '/quran/notes',
      name: 'quranNotes',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranNotesPage()),
    ),
    GoRoute(
      path: '/learn/quran/notes',
      redirect: (context, state) => _redirectWithQuery('/quran/notes', state),
    ),
    GoRoute(
      path: '/quran/reflections',
      name: 'quranReflections',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranReflectionsPage()),
    ),
    GoRoute(
      path: '/quran/reflections/:reflectionId',
      name: 'quranReflectionDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranReflectionDetailPage(
          reflectionId: state.pathParameters['reflectionId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quran/reflections',
      redirect: (context, state) =>
          _redirectWithQuery('/quran/reflections', state),
    ),
    GoRoute(
      path: '/quran/search',
      name: 'quranSearch',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranSearchPage(
          initialQuery: state.uri.queryParameters['q'] ?? '',
          initialSearchType: QuranSearchTypeX.fromWireValue(
            state.uri.queryParameters['type'],
          ),
          initialFieldFilter: QuranSearchFieldFilterX.fromWireValue(
            state.uri.queryParameters['field'],
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quran/search',
      redirect: (context, state) => _redirectWithQuery('/quran/search', state),
    ),
    GoRoute(
      path: '/quran/topics',
      name: 'quranTopicExplorer',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranTopicExplorerPage()),
    ),
    GoRoute(
      path: '/learn/quran/topics',
      redirect: (context, state) => _redirectWithQuery('/quran/topics', state),
    ),
    GoRoute(
      path: '/quran/topics/:topicId',
      name: 'quranTopicDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranTopicExplorerPage(topicId: state.pathParameters['topicId']),
      ),
    ),
    GoRoute(
      path: '/learn/quran/topics/:topicId',
      redirect: (context, state) =>
          _redirectWithPathAndQuery('/quran/topics/:topicId', state),
    ),
    GoRoute(
      path: '/quran/names-of-allah',
      name: 'quranNamesOfAllah',
      pageBuilder: (context, state) =>
          const MaterialPage(child: NamesOfAllahPage()),
    ),
    GoRoute(
      path: '/learn/quran/names-of-allah',
      redirect: (context, state) =>
          _redirectWithQuery('/quran/names-of-allah', state),
    ),
    GoRoute(
      path: '/quran/top-words',
      name: 'quranTopWords',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranWordsPage()),
    ),
    GoRoute(
      path: '/learn/quran/top-words',
      redirect: (context, state) =>
          _redirectWithQuery('/quran/top-words', state),
    ),
    GoRoute(
      path: '/quran/top-words/:rank',
      name: 'quranTopWordDetail',
      pageBuilder: (context, state) => MaterialPage(
        child: QuranWordDetailPage(
          rank: int.tryParse(state.pathParameters['rank'] ?? '') ?? 0,
        ),
      ),
    ),
    GoRoute(
      path: '/learn/quran/top-words/:rank',
      redirect: (context, state) =>
          _redirectWithPathAndQuery('/quran/top-words/:rank', state),
    ),
    GoRoute(
      path: '/quran/word-review',
      name: 'quranWordReview',
      pageBuilder: (context, state) =>
          const MaterialPage(child: QuranWordReviewPage()),
    ),
    GoRoute(
      path: '/learn/quran/word-review',
      redirect: (context, state) =>
          _redirectWithQuery('/quran/word-review', state),
    ),
    GoRoute(
      path: '/journey/ocean',
      name: 'oceanDrops',
      pageBuilder: (context, state) =>
          const MaterialPage(child: OceanDashboardPage()),
    ),
    GoRoute(
      path: '/journey/ocean/community',
      name: 'oceanCommunityDetails',
      pageBuilder: (context, state) =>
          const MaterialPage(child: OceanDropsPage()),
    ),
  ];
}
