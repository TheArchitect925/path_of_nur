import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../../features/accounts_sync/application/accounts_sync_services.dart';
import '../../../features/journey/drops/application/journey_drops_providers.dart';
import '../../../features/kids/bedtime_stories/application/bedtime_story_repository.dart';
import '../../../features/kids/seerah/application/seerah_journey_repository.dart';
import '../../../features/kids_dua_learning/application/kids_dua_repository.dart';
import '../../../features/kids_dua_learning/application/kids_dua_story_repository.dart';
import '../../../features/learn/guided_paths/application/guided_learning_paths_provider.dart';
import '../../../features/learn/hadith/application/hadith_foundation_repository.dart';
import '../../../features/learn/journey/application/learning_journey_progress_provider.dart';
import '../../../features/learn/journey/data/learning_journey_registry.dart';
import '../../../features/learn/prophets/application/prophets_repository.dart';
import '../../../features/learn/quran/application/quran_ayah_action_provider.dart';
import '../../../features/learn/quran/application/quran_ayah_explanation_provider.dart';
import '../../../features/learn/quran/application/quran_personalization_provider.dart';
import '../../../features/learn/quran/application/quran_spiritual_moment_provider.dart';
import '../../../features/learn/quran/application/quran_surah_summary_provider.dart';
import '../../../features/learn/quran/domain/quran_ayah_explanation_models.dart';
import '../../../features/worship/application/dhikr_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/editorial_dashboard_models.dart';

const _editorialDashboardMetadataKey =
    'internal.editorial_dashboard.metadata.v1';

final editorialDashboardPackageInfoProvider = Provider<AsyncValue<String>>((
  ref,
) {
  final info = ref.watch(accountsSyncPackageInfoProvider);
  return info.whenData((value) => '${value.version}+${value.buildNumber}');
});

final editorialDashboardDomainSectionsProvider =
    Provider<List<EditorialDashboardDomainSection>>((ref) {
      final quranManifest = ref.watch(quranAyahExplanationManifestProvider);
      final quranPackCounts = ref.watch(quranAyahExplanationPackSummaryProvider);
      final quranPackDefinitions = ref.watch(
        quranAyahExplanationPackDefinitionsProvider,
      );
      final quranSummaries = ref.watch(quranSurahSummaryListProvider);
      final quranCoverageBySurah = ref.watch(
        quranAyahExplanationCoverageBySurahProvider,
      );
      final actionRepository = ref.watch(quranAyahActionRepositoryProvider);
      final explanationEntries = ref.watch(
        quranAyahExplanationRepositoryProvider,
      ).getAll();
      final quranActionCount = explanationEntries
          .where(
            (entry) => actionRepository.actionForEntry(
                  entry,
                  languageCode: 'en',
                  preferKids: false,
                ) !=
                null,
          )
          .length;
      final quranKidsActionCount = explanationEntries
          .where(
            (entry) => actionRepository.actionForEntry(
                  entry,
                  languageCode: 'en',
                  preferKids: true,
                ) !=
                null,
          )
          .length;
      final quranDeepCount = quranManifest.where((item) => item.hasDeep).length;
      final quranReviewedCount = quranManifest
          .where(
            (item) =>
                item.reviewStatus == QuranAyahExplanationReviewStatus.reviewed ||
                item.reviewStatus == QuranAyahExplanationReviewStatus.verified,
          )
          .length;
      final quranVerifiedCount = quranManifest
          .where((item) => item.reviewStatus == QuranAyahExplanationReviewStatus.verified)
          .length;
      final quranKidsReviewedCount = quranManifest
          .where((item) => item.reviewStatus == QuranAyahExplanationReviewStatus.kidsReviewed)
          .length;
      final totalQuranAyahCount = quranSummaries.fold<int>(
        0,
        (sum, item) => sum + item.surah.verseCount,
      );
      final quranMissingAyahCount = totalQuranAyahCount - quranManifest.length;
      final quranPackItems = quranPackDefinitions.map((definition) {
        final entries = quranManifest
            .where((entry) => entry.rolloutPack == definition.pack)
            .toList(growable: false);
        final reviewed = entries
            .where(
              (entry) =>
                  entry.reviewStatus ==
                      QuranAyahExplanationReviewStatus.reviewed ||
                  entry.reviewStatus ==
                      QuranAyahExplanationReviewStatus.verified,
            )
            .length;
        final verified = entries
            .where(
              (entry) =>
                  entry.reviewStatus ==
                  QuranAyahExplanationReviewStatus.verified,
            )
            .length;
        final kidsReady = entries.where((entry) => entry.hasKids).length;
        final sourceReady = entries.where((entry) => entry.hasSourceRefs).length;
        return EditorialDashboardItem(
          domain: EditorialDashboardDomain.quran,
          id: 'quran_pack_${definition.pack.name}',
          type: EditorialDashboardItemType.pack,
          status: entries.isEmpty
              ? EditorialDashboardItemStatus.draft
              : reviewed == entries.length
              ? EditorialDashboardItemStatus.reviewed
              : EditorialDashboardItemStatus.partial,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: entries.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.reviewed,
              value: reviewed,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.verified,
              value: verified,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.kidsReady,
              value: kidsReady,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.localized,
              value: sourceReady,
            ),
          ],
          kidsSafe: kidsReady == entries.length && entries.isNotEmpty,
          kidsExpected: true,
          hasSources: sourceReady == entries.length && entries.isNotEmpty,
          sourcesExpected: true,
          localizationReady: true,
          missingContent: entries.isEmpty,
          needsReview: reviewed < entries.length,
          routeName: 'quranLearningHub',
          packId: definition.pack.name,
          searchKeywords: <String>[
            'quran pack',
            definition.pack.name,
          ],
        );
      }).toList(growable: false);

      final hadithThemes = ref.watch(hadithThemesProvider);
      final hadithCollections = ref.watch(hadithCollectionsProvider);
      final hadithEntries = ref.watch(hadithEntriesProvider);

      final prophets = ref.watch(prophetsProvider);
      final bedtimeStories = ref.watch(bedtimeStoriesProvider);
      final kidsStories = ref.watch(kidsIslamicStoriesProvider);
      final kidsSeerahRepository = ref.watch(kidsSeerahJourneyRepositoryProvider);
      final kidsSeerahJourneys = ref.watch(kidsSeerahJourneysProvider);
      final kidsSeerahStages = kidsSeerahJourneys
          .expand((journey) => kidsSeerahRepository.stagesForJourney(journey.journeyId))
          .toList(growable: false);
      final kidsSeerahNodes = kidsSeerahStages
          .expand((stage) => kidsSeerahRepository.nodesForStage(stage.stageId))
          .toList(growable: false);

      final kidsDuaCategories = ref.watch(kidsDuaCategoriesProvider);
      final kidsDuaLessons = ref.watch(kidsDuaLessonsProvider);
      final kidsDuaStories = ref.watch(kidsDuaStoriesProvider);
      final dhikrState = ref.watch(dhikrControllerProvider);

      final guidedPaths = ref.watch(guidedLearningPathsProvider);
      final guidedPathState = ref.watch(guidedLearningPathsControllerProvider);
      final localizedPaths = ref.watch(localizedGuidedLearningPathsProvider);
      final learningJourneyState = ref.watch(learningJourneyProgressProvider);
      final learningJourneys = LearningJourneyRegistry.journeys
          .where((journey) => journey.stageIds.isNotEmpty)
          .toList(growable: false);
      final completedLearningJourneyCount = learningJourneys
          .where(
            (journey) => journey.stageIds.every(
              learningJourneyState.completedStageIds.contains,
            ),
          )
          .length;

      final dropSummary = ref.watch(journeyDropSummaryProvider);
      final dropHistory = ref.watch(journeyDropHistoryProvider);
      final personalizationState = ref.watch(quranPersonalizationStateProvider);
      final spiritualMomentState = ref.watch(quranSpiritualMomentStateProvider);

      final quranItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.quran,
          id: 'quran_ayah_explanations',
          type: EditorialDashboardItemType.coverage,
          status: quranMissingAyahCount == 0
              ? EditorialDashboardItemStatus.verified
              : EditorialDashboardItemStatus.partial,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.covered,
              value: quranManifest.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.total,
              value: totalQuranAyahCount,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.missing,
              value: quranMissingAyahCount,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.reviewed,
              value: quranReviewedCount,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.verified,
              value: quranVerifiedCount,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.deep,
              value: quranDeepCount,
            ),
          ],
          kidsSafe: quranKidsReviewedCount > 0,
          kidsExpected: true,
          hasSources: quranManifest.every((item) => item.hasSourceRefs),
          sourcesExpected: true,
          missingContent: quranMissingAyahCount > 0,
          needsReview: quranReviewedCount < quranManifest.length,
          routeName: 'quranLearningHub',
          searchKeywords: const <String>[
            'ayah explanations',
            'tafsir',
            'coverage',
          ],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.quran,
          id: 'quran_explanation_rollout_packs',
          type: EditorialDashboardItemType.pack,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: quranPackDefinitions.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.covered,
              value: quranPackCounts.values.fold<int>(0, (sum, value) => sum + value),
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          hasSources: true,
          sourcesExpected: true,
          routeName: 'quranLearningHub',
          searchKeywords: const <String>['packs', 'rollout', 'editorial'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.quran,
          id: 'quran_surah_summaries',
          type: EditorialDashboardItemType.contentSet,
          status: quranSummaries.length == 114
              ? EditorialDashboardItemStatus.verified
              : EditorialDashboardItemStatus.partial,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: quranSummaries.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.total,
              value: 114,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.routes,
              value: quranSummaries.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          missingContent: quranSummaries.length < 114,
          routeName: 'quranSummaryPage',
          searchKeywords: const <String>['surah summaries', 'overview'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.quran,
          id: 'quran_explanation_surah_coverage',
          type: EditorialDashboardItemType.system,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: quranCoverageBySurah.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          hasSources: true,
          sourcesExpected: true,
          routeName: 'quranSummaryPage',
          searchKeywords: const <String>['surah coverage', 'coverage by surah'],
        ),
        ...quranPackItems,
      ];

      final hadithItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.hadith,
          id: 'hadith_themes',
          type: EditorialDashboardItemType.collection,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: hadithThemes.length,
            ),
          ],
          kidsSafe: false,
          sourcesExpected: true,
          localizationReady: true,
          searchKeywords: const <String>['themes', 'hadith topics'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.hadith,
          id: 'hadith_collections',
          type: EditorialDashboardItemType.collection,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: hadithCollections.length,
            ),
          ],
          kidsSafe: false,
          sourcesExpected: true,
          localizationReady: true,
          searchKeywords: const <String>['collections', 'books'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.hadith,
          id: 'hadith_entries',
          type: EditorialDashboardItemType.contentSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: hadithEntries.length,
            ),
          ],
          kidsSafe: false,
          sourcesExpected: true,
          localizationReady: true,
          searchKeywords: const <String>['entries', 'hadith lessons'],
        ),
      ];

      final storyItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.stories,
          id: 'story_prophets_library',
          type: EditorialDashboardItemType.contentSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: prophets.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'stories_core',
          searchKeywords: const <String>['prophets', 'stories'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.stories,
          id: 'story_bedtime_library',
          type: EditorialDashboardItemType.contentSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: bedtimeStories.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'stories_core',
          searchKeywords: const <String>['bedtime stories'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.stories,
          id: 'story_kids_library',
          type: EditorialDashboardItemType.contentSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: kidsStories.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'stories_core',
          searchKeywords: const <String>['kids stories', 'islamic stories'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.stories,
          id: 'story_kids_seerah_journey',
          type: EditorialDashboardItemType.journeySet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: kidsSeerahJourneys.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.covered,
              value: kidsSeerahStages.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.total,
              value: kidsSeerahNodes.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'stories_core',
          searchKeywords: const <String>['seerah', 'journey', 'nodes'],
        ),
      ];

      final duaDhikrItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.duasDhikr,
          id: 'dua_kids_categories',
          type: EditorialDashboardItemType.collection,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: kidsDuaCategories.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          routeName: 'kidsDuaLanding',
          packId: 'kids_dua',
          searchKeywords: const <String>['dua categories'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.duasDhikr,
          id: 'dua_kids_lessons',
          type: EditorialDashboardItemType.contentSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: kidsDuaLessons.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          routeName: 'kidsDuaLanding',
          packId: 'kids_dua',
          searchKeywords: const <String>['dua lessons'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.duasDhikr,
          id: 'dua_kids_stories',
          type: EditorialDashboardItemType.contentSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: kidsDuaStories.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          routeName: 'kidsDuaStories',
          packId: 'kids_dua',
          searchKeywords: const <String>['dua stories'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.duasDhikr,
          id: 'dhikr_tracking_system',
          type: EditorialDashboardItemType.system,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.sessions,
              value: dhikrState.recentSessions.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: dhikrState.summary.totalCount,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'dhikr_practice',
          searchKeywords: const <String>['dhikr', 'tracker'],
        ),
      ];

      final learningPathItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.learningPaths,
          id: 'guided_learning_paths',
          type: EditorialDashboardItemType.pathSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: guidedPaths.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.localized,
              value: localizedPaths.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.completed,
              value: guidedPathState.progressByPathId.values
                  .where((entry) => entry.completedAtIso != null)
                  .length,
            ),
          ],
          kidsSafe: guidedPaths.any((path) => path.audience.name == 'kids'),
          kidsExpected: true,
          localizationReady: localizedPaths.length == guidedPaths.length,
          missingContent: localizedPaths.length != guidedPaths.length,
          routeName: 'quranLearningPaths',
          packId: 'guided_paths',
          searchKeywords: const <String>['guided paths'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.learningPaths,
          id: 'learning_journeys',
          type: EditorialDashboardItemType.journeySet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: learningJourneys.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.completed,
              value: completedLearningJourneyCount,
            ),
          ],
          kidsSafe: learningJourneys.any((journey) => journey.id.contains('kids')),
          kidsExpected: true,
          localizationReady: true,
          packId: 'learning_journeys',
          searchKeywords: const <String>['learning journeys'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.learningPaths,
          id: 'learning_journey_resume_state',
          type: EditorialDashboardItemType.system,
          status: EditorialDashboardItemStatus.info,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.reviewed,
              value: learningJourneyState.startedJourneyIds.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.completed,
              value: completedLearningJourneyCount,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'learning_journeys',
          searchKeywords: const <String>['resume', 'progress'],
        ),
      ];

      final kidsContentItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.kidsContent,
          id: 'kids_quran_layer',
          type: EditorialDashboardItemType.coverage,
          status: EditorialDashboardItemStatus.partial,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.covered,
              value: quranKidsReviewedCount,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.total,
              value: quranManifest.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.kidsReady,
              value: quranManifest.where((item) => item.hasKids).length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          hasSources: true,
          sourcesExpected: true,
          localizationReady: true,
          missingContent: quranKidsReviewedCount < quranManifest.length,
          needsReview: quranKidsReviewedCount < quranManifest.length,
          routeName: 'learnKidsQuran',
          packId: 'kids_content_suite',
          searchKeywords: const <String>['kids quran', 'kids explanations'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.kidsContent,
          id: 'kids_dua_system',
          type: EditorialDashboardItemType.contentSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: kidsDuaLessons.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.covered,
              value: kidsDuaStories.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          routeName: 'kidsDuaLanding',
          packId: 'kids_content_suite',
          searchKeywords: const <String>['kids duas'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.kidsContent,
          id: 'kids_story_system',
          type: EditorialDashboardItemType.contentSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: kidsStories.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.covered,
              value: bedtimeStories.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'kids_content_suite',
          searchKeywords: const <String>['kids stories'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.kidsContent,
          id: 'kids_seerah_system',
          type: EditorialDashboardItemType.journeySet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: kidsSeerahJourneys.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.covered,
              value: kidsSeerahNodes.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'kids_content_suite',
          searchKeywords: const <String>['kids seerah'],
        ),
      ];

      final actionItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.actionsDrops,
          id: 'quran_ayah_actions',
          type: EditorialDashboardItemType.actionSet,
          status: quranActionCount == 0
              ? EditorialDashboardItemStatus.draft
              : EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: quranActionCount,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.kidsReady,
              value: quranKidsActionCount,
            ),
          ],
          kidsSafe: quranKidsActionCount > 0,
          kidsExpected: true,
          localizationReady: true,
          routeName: 'quranDailyCompanion',
          packId: 'quran_actions',
          searchKeywords: const <String>['actions', 'ocean drops'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.actionsDrops,
          id: 'ocean_drop_mappings',
          type: EditorialDashboardItemType.system,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: dropSummary.totalDrops,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.sessions,
              value: dropHistory.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'quran_actions',
          searchKeywords: const <String>['drops', 'rewards', 'ocean'],
        ),
      ];

      final recommendationItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.recommendations,
          id: 'quran_personalization_engine',
          type: EditorialDashboardItemType.engine,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: personalizationState.recentPrimaryAyahKeys.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.missing,
              value: personalizationState.dismissedAyahKeysByDateKey.values
                  .fold<int>(0, (sum, value) => sum + value.length),
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'recommendation_engines',
          searchKeywords: const <String>['personalization', 'recommendation'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.recommendations,
          id: 'spiritual_moments_engine',
          type: EditorialDashboardItemType.engine,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: spiritualMomentState.recentPrimaryAyahKeys.length,
            ),
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.missing,
              value: spiritualMomentState.dismissedAyahKeysByDateKey.values
                  .fold<int>(0, (sum, value) => sum + value.length),
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'recommendation_engines',
          searchKeywords: const <String>['spiritual moments', 'timing'],
        ),
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.recommendations,
          id: 'daily_companion_surfaces',
          type: EditorialDashboardItemType.system,
          status: EditorialDashboardItemStatus.info,
          metrics: const <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.routes,
              value: 5,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          routeName: 'quranDailyCompanion',
          packId: 'recommendation_engines',
          searchKeywords: const <String>['home', 'reader', 'journey', 'surface'],
        ),
      ];

      final localizationItems = <EditorialDashboardItem>[
        EditorialDashboardItem(
          domain: EditorialDashboardDomain.localization,
          id: 'app_supported_locales',
          type: EditorialDashboardItemType.localeSet,
          status: EditorialDashboardItemStatus.reviewed,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.entries,
              value: AppLocalizations.supportedLocales.length,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'localization_core',
          searchKeywords: const <String>['locales', 'translations'],
        ),
        const EditorialDashboardItem(
          domain: EditorialDashboardDomain.localization,
          id: 'dashboard_runtime_localization',
          type: EditorialDashboardItemType.system,
          status: EditorialDashboardItemStatus.info,
          metrics: <EditorialDashboardMetric>[
            EditorialDashboardMetric(
              type: EditorialDashboardMetricType.localized,
              value: 1,
            ),
          ],
          kidsSafe: true,
          kidsExpected: true,
          localizationReady: true,
          packId: 'localization_core',
          searchKeywords: <String>['arb', 'l10n', 'runtime'],
        ),
      ];

      return <EditorialDashboardDomainSection>[
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.quran,
          items: quranItems,
        ),
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.hadith,
          items: hadithItems,
        ),
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.stories,
          items: storyItems,
        ),
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.duasDhikr,
          items: duaDhikrItems,
        ),
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.learningPaths,
          items: learningPathItems,
        ),
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.kidsContent,
          items: kidsContentItems,
        ),
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.actionsDrops,
          items: actionItems,
        ),
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.recommendations,
          items: recommendationItems,
        ),
        EditorialDashboardDomainSection(
          domain: EditorialDashboardDomain.localization,
          items: localizationItems,
        ),
      ];
    });

class EditorialDashboardMetadataController
    extends StateNotifier<Map<String, EditorialDashboardMetadataEntry>> {
  EditorialDashboardMetadataController(this._store)
    : super(_load(_store.getJsonMap(_editorialDashboardMetadataKey)));

  final LocalStore _store;

  static Map<String, EditorialDashboardMetadataEntry> _load(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return <String, EditorialDashboardMetadataEntry>{};
    final result = <String, EditorialDashboardMetadataEntry>{};
    for (final entry in json.entries) {
      if (entry.value is Map<String, dynamic>) {
        result[entry.key] = EditorialDashboardMetadataEntry.fromJson(
          entry.value as Map<String, dynamic>,
        );
        continue;
      }
      if (entry.value is Map) {
        result[entry.key] = EditorialDashboardMetadataEntry.fromJson(
          Map<String, dynamic>.from(entry.value as Map),
        );
      }
    }
    return result;
  }

  void _persist() {
    _store.setJsonMap(
      _editorialDashboardMetadataKey,
      <String, dynamic>{
        for (final entry in state.entries) entry.key: entry.value.toJson(),
      },
    );
  }

  void setReadiness(String itemId, EditorialReadinessState readiness) {
    final updated = (state[itemId] ?? const EditorialDashboardMetadataEntry())
        .copyWith(
          readinessOverride: readiness,
          updatedAtIso: DateTime.now().toIso8601String(),
        );
    state = <String, EditorialDashboardMetadataEntry>{...state, itemId: updated};
    _persist();
  }

  void saveNote(String itemId, String note) {
    final normalized = note.trim();
    final updated = (state[itemId] ?? const EditorialDashboardMetadataEntry())
        .copyWith(
          note: normalized.isEmpty ? null : normalized,
          clearNote: normalized.isEmpty,
          updatedAtIso: DateTime.now().toIso8601String(),
        );
    state = <String, EditorialDashboardMetadataEntry>{...state, itemId: updated};
    _persist();
  }
}

final editorialDashboardMetadataProvider = StateNotifierProvider<
  EditorialDashboardMetadataController,
  Map<String, EditorialDashboardMetadataEntry>
>((ref) {
  return EditorialDashboardMetadataController(ref.watch(localStoreProvider));
});

final editorialDashboardScoredItemsProvider =
    Provider<List<EditorialScoredItem>>((ref) {
      final sections = ref.watch(editorialDashboardDomainSectionsProvider);
      final metadata = ref.watch(editorialDashboardMetadataProvider);
      final now = DateTime.now();
      return sections
          .expand((section) => section.items)
          .map((item) {
            final entry = metadata[item.id];
            final effectiveLastUpdatedIso =
                entry?.updatedAtIso ?? item.lastUpdatedIso;
            final quality = _scoreItem(
              item,
              now: now,
              lastUpdatedIso: effectiveLastUpdatedIso,
            );
            return EditorialScoredItem(
              item: item,
              quality: quality,
              readiness: entry?.readinessOverride ?? quality.readiness,
              note: entry?.note,
              lastUpdatedIso: effectiveLastUpdatedIso,
            );
          })
          .toList(growable: false);
    });

final editorialDashboardScoredSectionsProvider =
    Provider<List<EditorialDashboardDomainSection>>((ref) {
      final scoredItems = ref.watch(editorialDashboardScoredItemsProvider);
      return EditorialDashboardDomain.values.map((domain) {
        return EditorialDashboardDomainSection(
          domain: domain,
          items: scoredItems
              .where((item) => item.item.domain == domain)
              .map((item) => item.item)
              .toList(growable: false),
        );
      }).where((section) => section.items.isNotEmpty).toList(growable: false);
    });

final editorialDashboardPackHealthProvider =
    Provider<List<EditorialPackHealth>>((ref) {
      final scoredItems = ref.watch(editorialDashboardScoredItemsProvider);
      final grouped = <String, List<EditorialScoredItem>>{};
      for (final item in scoredItems) {
        final packId = item.item.packId;
        if (packId == null || packId.isEmpty) continue;
        grouped.putIfAbsent(packId, () => <EditorialScoredItem>[]).add(item);
      }
      final result = <EditorialPackHealth>[];
      for (final entry in grouped.entries) {
        final items = entry.value;
        final total = items.length;
        if (total == 0) continue;
        final reviewed = items
            .where(
              (item) =>
                  item.readiness == EditorialReadinessState.reviewed ||
                  item.readiness == EditorialReadinessState.verified ||
                  item.readiness == EditorialReadinessState.launchReady,
            )
            .length;
        final verified = items
            .where(
              (item) =>
                  item.readiness == EditorialReadinessState.verified ||
                  item.readiness == EditorialReadinessState.launchReady,
            )
            .length;
        final missingRequired = items
            .where(
              (item) =>
                  item.item.missingContent ||
                  item.quality.issues.any(
                    (issue) =>
                        issue.code == EditorialIssueCode.missingContent ||
                        issue.code == EditorialIssueCode.lowCoverage,
                  ),
            )
            .length;
        final kidsPercent =
            ((items.where((item) => item.item.kidsSafe).length / total) * 100)
                .round();
        final sourcePercent =
            ((items.where((item) => item.item.hasSources).length / total) * 100)
                .round();
        final localizationPercent = ((items
                    .where((item) => item.item.localizationReady)
                    .length /
                total) *
            100)
            .round();
        final overall =
            (items.fold<int>(0, (sum, item) => sum + item.quality.score) / total)
                .round();
        final readiness = overall >= 92 && missingRequired == 0
            ? EditorialReadinessState.launchReady
            : overall >= 80
            ? EditorialReadinessState.reviewed
            : overall >= 65
            ? EditorialReadinessState.draft
            : EditorialReadinessState.needsRevision;
        result.add(
          EditorialPackHealth(
            domain: items.first.item.domain,
            packId: entry.key,
            totalItems: total,
            reviewedItems: reviewed,
            verifiedItems: verified,
            missingRequiredFieldsCount: missingRequired,
            kidsSafeCoveragePercent: kidsPercent,
            sourceCoveragePercent: sourcePercent,
            localizationCoveragePercent: localizationPercent,
            readiness: readiness,
            overallScore: overall,
          ),
        );
      }
      result.sort((a, b) => a.packId.compareTo(b.packId));
      return result;
    });

final editorialDashboardReviewQueuesProvider =
    Provider<List<EditorialReviewQueue>>((ref) {
      final scoredItems = ref.watch(editorialDashboardScoredItemsProvider);
      final now = DateTime.now();

      List<EditorialReviewQueueItem> build(
        EditorialTriageCategory category,
        bool Function(EditorialScoredItem item) predicate,
      ) {
        return scoredItems
            .where(predicate)
            .map(
              (item) => EditorialReviewQueueItem(
                category: category,
                scoredItem: item,
              ),
            )
            .toList(growable: false)
          ..sort(
            (a, b) => a.scoredItem.quality.score.compareTo(
              b.scoredItem.quality.score,
            ),
          );
      }

      return <EditorialReviewQueue>[
        EditorialReviewQueue(
          category: EditorialTriageCategory.criticalIssues,
          items: build(
            EditorialTriageCategory.criticalIssues,
            (item) => item.quality.priority == EditorialPriorityLevel.critical,
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.needsReview,
          items: build(
            EditorialTriageCategory.needsReview,
            (item) => item.item.needsReview,
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.kidsSafetyGaps,
          items: build(
            EditorialTriageCategory.kidsSafetyGaps,
            (item) => item.item.kidsExpected && !item.item.kidsSafe,
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.missingLocalization,
          items: build(
            EditorialTriageCategory.missingLocalization,
            (item) => item.item.localizationExpected && !item.item.localizationReady,
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.missingSourceMetadata,
          items: build(
            EditorialTriageCategory.missingSourceMetadata,
            (item) => item.item.sourcesExpected && !item.item.hasSources,
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.incompleteContentPacks,
          items: build(
            EditorialTriageCategory.incompleteContentPacks,
            (item) => item.item.type == EditorialDashboardItemType.pack &&
                item.quality.score < 85,
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.lowQuality,
          items: build(
            EditorialTriageCategory.lowQuality,
            (item) => item.quality.band == EditorialScoreBand.weak,
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.readyForVerification,
          items: build(
            EditorialTriageCategory.readyForVerification,
            (item) =>
                item.quality.score >= 88 &&
                item.readiness == EditorialReadinessState.reviewed,
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.recentlyUpdated,
          items: build(
            EditorialTriageCategory.recentlyUpdated,
            (item) {
              final updated = DateTime.tryParse(item.lastUpdatedIso ?? '');
              return updated != null &&
                  now.difference(updated).inDays <= 7;
            },
          ),
        ),
        EditorialReviewQueue(
          category: EditorialTriageCategory.staleContent,
          items: build(
            EditorialTriageCategory.staleContent,
            (item) =>
                item.quality.issues.any(
                  (issue) => issue.code == EditorialIssueCode.staleContent,
                ),
          ),
        ),
      ];
    });

final editorialDashboardTriageSummaryProvider =
    Provider<EditorialTriageSummary>((ref) {
      final queues = ref.watch(editorialDashboardReviewQueuesProvider);
      int count(EditorialTriageCategory category) {
        for (final queue in queues) {
          if (queue.category == category) return queue.count;
        }
        return 0;
      }

      final scoredItems = ref.watch(editorialDashboardScoredItemsProvider);
      final highPriority = scoredItems
          .where(
            (item) =>
                item.quality.priority == EditorialPriorityLevel.high ||
                item.quality.priority == EditorialPriorityLevel.critical,
          )
          .length;

      return EditorialTriageSummary(
        criticalIssuesCount: count(EditorialTriageCategory.criticalIssues),
        highPriorityCount: highPriority,
        kidsSafetyGapCount: count(EditorialTriageCategory.kidsSafetyGaps),
        missingSourceCount: count(
          EditorialTriageCategory.missingSourceMetadata,
        ),
        localizationGapCount: count(
          EditorialTriageCategory.missingLocalization,
        ),
        incompletePackCount: count(
          EditorialTriageCategory.incompleteContentPacks,
        ),
        readyForVerificationCount: count(
          EditorialTriageCategory.readyForVerification,
        ),
        recentlyUpdatedCount: count(EditorialTriageCategory.recentlyUpdated),
        staleCount: count(EditorialTriageCategory.staleContent),
      );
    });

EditorialQualityScore _scoreItem(
  EditorialDashboardItem item, {
  required DateTime now,
  String? lastUpdatedIso,
}) {
  var score = 100;
  final positives = <String>[];
  final penalties = <String>[];
  final issues = <EditorialIssue>[];

  void reward(bool condition, String reason) {
    if (condition) positives.add(reason);
  }

  void penalize(
    bool condition, {
    required EditorialIssueCode code,
    required EditorialPriorityLevel priority,
    required int penalty,
    required String detail,
  }) {
    if (!condition) return;
    score -= penalty;
    penalties.add(detail);
    issues.add(
      EditorialIssue(
        code: code,
        priority: priority,
        penalty: penalty,
        detail: detail,
      ),
    );
  }

  reward(item.kidsSafe, 'Kids-safe coverage is present.');
  reward(item.hasSources, 'Source metadata is present.');
  reward(item.localizationReady, 'Localization is ready.');
  reward(
    item.status == EditorialDashboardItemStatus.reviewed ||
        item.status == EditorialDashboardItemStatus.verified,
    'Review state is already advanced.',
  );

  penalize(
    item.missingContent,
    code: EditorialIssueCode.missingContent,
    priority: EditorialPriorityLevel.critical,
    penalty: 35,
    detail: 'Required content is still missing.',
  );
  penalize(
    item.kidsExpected && !item.kidsSafe,
    code: EditorialIssueCode.missingKids,
    priority: EditorialPriorityLevel.high,
    penalty: 22,
    detail: 'Kids-safe coverage is expected here but missing.',
  );
  penalize(
    item.sourcesExpected && !item.hasSources,
    code: EditorialIssueCode.missingSourceRef,
    priority: EditorialPriorityLevel.high,
    penalty: 18,
    detail: 'Source metadata is expected but missing.',
  );
  penalize(
    item.localizationExpected && !item.localizationReady,
    code: EditorialIssueCode.missingLocalization,
    priority: EditorialPriorityLevel.high,
    penalty: 16,
    detail: 'Localization readiness is missing.',
  );
  penalize(
    item.needsReview,
    code: EditorialIssueCode.needsReview,
    priority: EditorialPriorityLevel.high,
    penalty: 18,
    detail: 'This item still needs editorial review.',
  );
  penalize(
    item.status == EditorialDashboardItemStatus.draft,
    code: EditorialIssueCode.draftOnly,
    priority: EditorialPriorityLevel.high,
    penalty: 20,
    detail: 'This item is still only in draft state.',
  );
  penalize(
    item.status == EditorialDashboardItemStatus.partial,
    code: EditorialIssueCode.weakPackCoverage,
    priority: EditorialPriorityLevel.medium,
    penalty: 10,
    detail: 'This item is only partially complete.',
  );
  penalize(
    item.routeName == null &&
        item.type != EditorialDashboardItemType.system &&
        item.type != EditorialDashboardItemType.engine,
    code: EditorialIssueCode.incompleteRouteMetadata,
    priority: EditorialPriorityLevel.medium,
    penalty: 8,
    detail: 'No route is attached for direct inspection.',
  );

  final covered = item.metricValue(EditorialDashboardMetricType.covered);
  final total = item.metricValue(EditorialDashboardMetricType.total);
  if (total > 0 && covered < total) {
    penalize(
      true,
      code: EditorialIssueCode.lowCoverage,
      priority: total - covered > (total / 2)
          ? EditorialPriorityLevel.critical
          : EditorialPriorityLevel.medium,
      penalty: total - covered > (total / 2) ? 24 : 12,
      detail: 'Coverage is still incomplete for this item.',
    );
  }

  if (item.id == 'quran_ayah_actions' &&
      item.metricValue(EditorialDashboardMetricType.entries) == 0) {
    penalize(
      true,
      code: EditorialIssueCode.missingActionMapping,
      priority: EditorialPriorityLevel.high,
      penalty: 20,
      detail: 'No ayah action mappings are available yet.',
    );
  }

  if ((item.id == 'quran_personalization_engine' ||
          item.id == 'spiritual_moments_engine') &&
      item.metricValue(EditorialDashboardMetricType.entries) == 0) {
    penalize(
      true,
      code: EditorialIssueCode.missingRecommendationTags,
      priority: EditorialPriorityLevel.medium,
      penalty: 14,
      detail: 'Recommendation signals are too light to support strong triage.',
    );
  }

  final updated = DateTime.tryParse(lastUpdatedIso ?? item.lastUpdatedIso ?? '');
  if (updated != null && now.difference(updated).inDays > 60) {
    penalize(
      true,
      code: EditorialIssueCode.staleContent,
      priority: EditorialPriorityLevel.low,
      penalty: 6,
      detail: 'This item has not been updated recently.',
    );
  }

  if (item.status == EditorialDashboardItemStatus.info) {
    penalize(
      true,
      code: EditorialIssueCode.infoOnly,
      priority: EditorialPriorityLevel.low,
      penalty: 4,
      detail: 'This item is informational rather than fully reviewable content.',
    );
  }

  if (score < 0) score = 0;

  final priority = issues.any(
        (issue) => issue.priority == EditorialPriorityLevel.critical,
      )
      ? EditorialPriorityLevel.critical
      : issues.any((issue) => issue.priority == EditorialPriorityLevel.high)
      ? EditorialPriorityLevel.high
      : issues.any((issue) => issue.priority == EditorialPriorityLevel.medium)
      ? EditorialPriorityLevel.medium
      : EditorialPriorityLevel.low;

  final readiness = score >= 94 &&
          !item.missingContent &&
          !item.needsReview &&
          item.status == EditorialDashboardItemStatus.verified
      ? EditorialReadinessState.launchReady
      : item.status == EditorialDashboardItemStatus.verified
      ? EditorialReadinessState.verified
      : item.status == EditorialDashboardItemStatus.reviewed && score >= 75
      ? EditorialReadinessState.reviewed
      : item.status == EditorialDashboardItemStatus.draft
      ? EditorialReadinessState.draft
      : item.missingContent
      ? EditorialReadinessState.notStarted
      : score < 70
      ? EditorialReadinessState.needsRevision
      : EditorialReadinessState.draft;

  return EditorialQualityScore(
    score: score,
    priority: priority,
    readiness: readiness,
    positiveReasons: positives,
    penaltyReasons: penalties,
    issues: issues,
  );
}
