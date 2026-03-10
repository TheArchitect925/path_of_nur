import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life/application/life_progress_provider.dart';
import '../../life/data/life_curriculum_data.dart';
import '../../life/domain/life_models.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_surah.dart';
import '../../world/application/world_progress_provider.dart';
import '../../world/data/world_curriculum_data.dart';
import '../../world/domain/world_models.dart';
import '../../hadith/application/hadith_progress_provider.dart';
import '../../hadith/data/hadith_curriculum_data.dart';
import '../../hadith/domain/hadith_models.dart';
import 'learn_enhancements_provider.dart';
import '../domain/learn_unified_models.dart';

const _crossDomainSuggestedPath = <LearnRelatedQuery>[
  LearnRelatedQuery(LearnDomainType.quran, '2:152'),
  LearnRelatedQuery(LearnDomainType.life, 'family-parents-honor-care'),
  LearnRelatedQuery(LearnDomainType.hadith, 'char-honesty-foundation'),
  LearnRelatedQuery(LearnDomainType.world, 'time-night-day-alternation'),
  LearnRelatedQuery(LearnDomainType.life, 'gratitude-daily-awareness'),
  LearnRelatedQuery(LearnDomainType.hadith, 'worship-intentions-weigh-actions'),
  LearnRelatedQuery(LearnDomainType.world, 'water-rain-mercy-revival'),
  LearnRelatedQuery(LearnDomainType.life, 'community-neighbor-rights'),
  LearnRelatedQuery(LearnDomainType.hadith, 'mercy-rights-of-neighbors'),
  LearnRelatedQuery(LearnDomainType.world, 'animals-bee-order-benefit'),
  LearnRelatedQuery(LearnDomainType.quran, '55:13'),
];

const _trackSuggestedPaths = <LearnTrackType, List<LearnRelatedQuery>>{
  LearnTrackType.beginner: _crossDomainSuggestedPath,
  LearnTrackType.family: <LearnRelatedQuery>[
    LearnRelatedQuery(LearnDomainType.life, 'family-parents-honor-care'),
    LearnRelatedQuery(LearnDomainType.hadith, 'family-parents-rights-and-dua'),
    LearnRelatedQuery(LearnDomainType.life, 'family-marriage-mercy'),
    LearnRelatedQuery(LearnDomainType.hadith, 'family-family-as-sacred-trust'),
    LearnRelatedQuery(LearnDomainType.quran, '4:36'),
  ],
  LearnTrackType.character: <LearnRelatedQuery>[
    LearnRelatedQuery(LearnDomainType.hadith, 'char-honesty-foundation'),
    LearnRelatedQuery(LearnDomainType.life, 'character-intention-sincerity'),
    LearnRelatedQuery(LearnDomainType.hadith, 'speech-guarding-the-tongue'),
    LearnRelatedQuery(LearnDomainType.life, 'character-humility-strength'),
    LearnRelatedQuery(LearnDomainType.quran, '2:152'),
  ],
  LearnTrackType.ramadan: <LearnRelatedQuery>[
    LearnRelatedQuery(LearnDomainType.quran, '2:152'),
    LearnRelatedQuery(LearnDomainType.hadith, 'worship-consistency-over-volume'),
    LearnRelatedQuery(LearnDomainType.life, 'gratitude-daily-awareness'),
    LearnRelatedQuery(LearnDomainType.world, 'time-night-day-alternation'),
    LearnRelatedQuery(LearnDomainType.quran, '55:13'),
  ],
  LearnTrackType.revert: <LearnRelatedQuery>[
    LearnRelatedQuery(LearnDomainType.quran, '1:1'),
    LearnRelatedQuery(LearnDomainType.hadith, 'worship-intentions-weigh-actions'),
    LearnRelatedQuery(LearnDomainType.life, 'character-intention-sincerity'),
    LearnRelatedQuery(LearnDomainType.life, 'community-neighbor-rights'),
    LearnRelatedQuery(LearnDomainType.hadith, 'speech-guarding-the-tongue'),
  ],
};

const _crossDomainRelatedMap = <String, List<LearnRelatedQuery>>{
  'life:gratitude-daily-awareness': [
    LearnRelatedQuery(LearnDomainType.quran, '2:152'),
    LearnRelatedQuery(LearnDomainType.hadith, 'gratitude-seeing-blessings-daily'),
    LearnRelatedQuery(LearnDomainType.world, 'water-rain-mercy-revival'),
  ],
  'life:community-neighbor-rights': [
    LearnRelatedQuery(LearnDomainType.hadith, 'mercy-rights-of-neighbors'),
    LearnRelatedQuery(LearnDomainType.world, 'world-cleanliness-public-space'),
  ],
  'life:hardship-sabr-active': [
    LearnRelatedQuery(LearnDomainType.hadith, 'hardship-sabr-with-purpose'),
    LearnRelatedQuery(LearnDomainType.world, 'time-seasons-change-reflection'),
  ],
  'world:animals-bee-order-benefit': [
    LearnRelatedQuery(LearnDomainType.quran, '16:68'),
    LearnRelatedQuery(LearnDomainType.hadith, 'world-kindness-to-animals'),
    LearnRelatedQuery(LearnDomainType.life, 'gratitude-daily-awareness'),
  ],
  'world:water-rain-mercy-revival': [
    LearnRelatedQuery(LearnDomainType.life, 'gratitude-daily-awareness'),
    LearnRelatedQuery(LearnDomainType.hadith, 'gratitude-seeing-blessings-daily'),
  ],
  'world:earth-mountains-stability-reflection': [
    LearnRelatedQuery(LearnDomainType.life, 'hardship-hope-resilience'),
    LearnRelatedQuery(LearnDomainType.hadith, 'hardship-grief-with-hope'),
  ],
  'hadith:mercy-rights-of-neighbors': [
    LearnRelatedQuery(LearnDomainType.quran, '4:36'),
    LearnRelatedQuery(LearnDomainType.life, 'community-neighbor-rights'),
    LearnRelatedQuery(LearnDomainType.world, 'world-cleanliness-public-space'),
  ],
  'hadith:gratitude-seeing-blessings-daily': [
    LearnRelatedQuery(LearnDomainType.life, 'gratitude-daily-awareness'),
    LearnRelatedQuery(LearnDomainType.world, 'water-rain-mercy-revival'),
  ],
  'hadith:worship-intentions-weigh-actions': [
    LearnRelatedQuery(LearnDomainType.quran, '98:5'),
    LearnRelatedQuery(LearnDomainType.life, 'character-intention-sincerity'),
    LearnRelatedQuery(LearnDomainType.world, 'time-lifespan-urgency-gratitude'),
  ],
  'quran:2:152': [
    LearnRelatedQuery(LearnDomainType.life, 'gratitude-daily-awareness'),
    LearnRelatedQuery(LearnDomainType.hadith, 'gratitude-seeing-blessings-daily'),
  ],
  'quran:16:68': [
    LearnRelatedQuery(LearnDomainType.world, 'animals-bee-order-benefit'),
    LearnRelatedQuery(LearnDomainType.life, 'gratitude-daily-awareness'),
  ],
  'quran:4:36': [
    LearnRelatedQuery(LearnDomainType.life, 'community-neighbor-rights'),
    LearnRelatedQuery(LearnDomainType.hadith, 'mercy-rights-of-neighbors'),
  ],
};

class LearnRelatedQuery {
  const LearnRelatedQuery(this.domain, this.lessonId);

  final LearnDomainType domain;
  final String lessonId;
}

class _ProgressValue {
  const _ProgressValue({
    required this.status,
    required this.lastOpened,
  });

  final LearnUnifiedStatus status;
  final DateTime? lastOpened;
}

final learnUnifiedSummaryProvider = Provider<LearnUnifiedSummary>((ref) {
  final quranContinue = ref.watch(quranContinueReadingSummaryProvider);
  final quranRecent = ref.watch(quranRecentReadingsProvider);
  final quranSurahMap = ref.watch(quranSurahMapProvider);
  final quranDailyVerse = ref.watch(quranDailyVerseProvider);
  final quranStreak = ref.watch(quranReadingStreakProvider);
  final quranProgress = ref.watch(quranReadingProgressProvider);
  final quranSurahs = ref.watch(quranSurahListProvider);

  final lifeSummary = ref.watch(lifeProgressSummaryProvider);
  final lifeState = ref.watch(lifeProgressProvider);

  final worldSummary = ref.watch(worldProgressSummaryProvider);
  final worldState = ref.watch(worldProgressProvider);

  final hadithSummary = ref.watch(hadithProgressSummaryProvider);
  final hadithState = ref.watch(hadithProgressProvider);
  final qualityState = ref.watch(learnQualityProvider);
  final selectedTrack = ref.watch(learnTrackProvider);
  final trackTitles = ref.watch(learnTrackTitlesProvider);
  final bundles = ref.watch(learnBundlesProvider);
  final quranNotes = ref.watch(quranNotesProvider);

  final installedBundleIds = bundles
      .where((bundle) => bundle.installed)
      .map((bundle) => bundle.id)
      .toSet();
  final quranEnabled = installedBundleIds.contains('quran-core');
  final lifeEnabled = installedBundleIds.contains('life-curriculum');
  final worldEnabled = installedBundleIds.contains('world-curriculum');
  final hadithEnabled = installedBundleIds.contains('hadith-curriculum');

  final quranContinueProgress = _ProgressValue(
    status: LearnUnifiedStatus.inProgress,
    lastOpened: DateTime.tryParse(
      ref.watch(quranReadingProgressProvider).updatedAtIso,
    ),
  );

  final lifeProgressById = <String, _ProgressValue>{};
  for (final entry in lifeState.lessonProgressById.entries) {
    lifeProgressById[entry.key] = _ProgressValue(
      status: _mapLifeStatus(entry.value.status),
      lastOpened: DateTime.tryParse(entry.value.lastOpenedIso ?? ''),
    );
  }

  final worldProgressById = <String, _ProgressValue>{};
  for (final entry in worldState.lessonProgressById.entries) {
    worldProgressById[entry.key] = _ProgressValue(
      status: _mapWorldStatus(entry.value.status),
      lastOpened: DateTime.tryParse(entry.value.lastOpenedIso ?? ''),
    );
  }

  final hadithProgressById = <String, _ProgressValue>{};
  for (final entry in hadithState.lessonProgressById.entries) {
    hadithProgressById[entry.key] = _ProgressValue(
      status: _mapHadithStatus(entry.value.status),
      lastOpened: DateTime.tryParse(entry.value.lastOpenedIso ?? ''),
    );
  }

  LearnUnifiedLessonRef? lifeContinue = _lessonRef(
    domain: LearnDomainType.life,
    lessonId: lifeSummary.continueLessonId,
    progressById: lifeProgressById,
    qualityState: qualityState,
  );
  LearnUnifiedLessonRef? worldContinue = _lessonRef(
    domain: LearnDomainType.world,
    lessonId: worldSummary.continueLessonId,
    progressById: worldProgressById,
    qualityState: qualityState,
  );
  LearnUnifiedLessonRef? hadithContinue = _lessonRef(
    domain: LearnDomainType.hadith,
    lessonId: hadithSummary.continueLessonId,
    progressById: hadithProgressById,
    qualityState: qualityState,
  );

  final quranContinueItem = _quranRefFromLocation(
    surahNumber: quranContinue.surahNumber,
    ayahNumber: quranContinue.ayahNumber,
    surahMap: quranSurahMap,
    progress: quranContinueProgress,
    qualityState: qualityState,
  );

  LearnUnifiedLessonRef? notesContinueItem;
  if (quranNotes.isNotEmpty) {
    final latest = quranNotes.first;
    notesContinueItem = LearnUnifiedLessonRef(
      domain: LearnDomainType.notes,
      lessonId: latest.id,
      title: latest.text.trim().isEmpty
          ? 'Qur\'an note ${latest.surahNumber}:${latest.ayahNumber}'
          : latest.text.split('\n').first.trim(),
      subtitle: 'Linked to Qur\'an ${latest.surahNumber}:${latest.ayahNumber}',
      routeName: 'quranReader',
      pathParameters: {'surahNumber': latest.surahNumber.toString()},
      queryParameters: {'ayah': latest.ayahNumber.toString()},
      lastOpened: DateTime.tryParse(latest.createdAtIso),
      status: LearnUnifiedStatus.inProgress,
      quality: qualityState.byLessonKey['notes:${latest.id}'] ??
          LearnCompletionQuality.reflected,
    );
  }

  if (!lifeEnabled) lifeContinue = null;
  if (!worldEnabled) worldContinue = null;
  if (!hadithEnabled) hadithContinue = null;

  final continueCandidates = [
    if (quranEnabled) quranContinueItem,
    if (lifeEnabled) lifeContinue,
    if (worldEnabled) worldContinue,
    if (hadithEnabled) hadithContinue,
    notesContinueItem,
  ].whereType<LearnUnifiedLessonRef>().toList()
    ..sort((a, b) {
      return _continueScore(
        item: b,
        selectedTrack: selectedTrack,
      ).compareTo(
        _continueScore(item: a, selectedTrack: selectedTrack),
      );
    });

  LearnUnifiedLessonRef? continueItem =
      continueCandidates.isEmpty ? null : continueCandidates.first;
  final continueReason = continueItem == null
      ? 'Start your first lesson to build momentum.'
      : _buildContinueReason(
          continueItem,
          selectedTrack: selectedTrack,
        );

  LearnUnifiedLessonRef? suggestedNext;
  final selectedPath =
      _trackSuggestedPaths[selectedTrack] ?? _crossDomainSuggestedPath;
  for (final key in selectedPath) {
    final item = _lookupItem(
      domain: key.domain,
      lessonId: key.lessonId,
      lifeProgressById: lifeProgressById,
      worldProgressById: worldProgressById,
      hadithProgressById: hadithProgressById,
      quranSurahMap: quranSurahMap,
      quranContinueProgress: quranContinueProgress,
      qualityState: qualityState,
    );
    if (!_isDomainEnabled(item?.domain, quranEnabled, lifeEnabled, worldEnabled, hadithEnabled)) {
      continue;
    }
    if (item != null && item.status != LearnUnifiedStatus.completed) {
      suggestedNext = item;
      break;
    }
  }
  if (continueItem != null && suggestedNext != null) {
    final continueKey = '${continueItem.domain.name}:${continueItem.lessonId}';
    final suggestedKey = '${suggestedNext.domain.name}:${suggestedNext.lessonId}';
    if (continueKey == suggestedKey) {
      suggestedNext = null;
      for (final key in selectedPath) {
        final item = _lookupItem(
          domain: key.domain,
          lessonId: key.lessonId,
          lifeProgressById: lifeProgressById,
          worldProgressById: worldProgressById,
          hadithProgressById: hadithProgressById,
          quranSurahMap: quranSurahMap,
          quranContinueProgress: quranContinueProgress,
          qualityState: qualityState,
        );
        if (!_isDomainEnabled(item?.domain, quranEnabled, lifeEnabled, worldEnabled, hadithEnabled)) {
          continue;
        }
        if (item == null || item.status == LearnUnifiedStatus.completed) {
          continue;
        }
        final itemKey = '${item.domain.name}:${item.lessonId}';
        if (itemKey != continueKey) {
          suggestedNext = item;
          break;
        }
      }
    }
  }

  final quranRecentItems = quranRecent
      .map(
        (reading) => _quranRefFromLocation(
          surahNumber: reading.surahNumber,
          ayahNumber: reading.ayahNumber,
          surahMap: quranSurahMap,
          progress: _ProgressValue(
            status: LearnUnifiedStatus.inProgress,
            lastOpened: DateTime.tryParse(reading.openedAtIso),
          ),
          qualityState: qualityState,
        ),
      )
      .whereType<LearnUnifiedLessonRef>()
      .toList();

  final recentItems = [
    if (quranEnabled) ...quranRecentItems,
    if (lifeEnabled) ...lifeState.recentLessonIds.map(
      (id) => _lessonRef(
        domain: LearnDomainType.life,
        lessonId: id,
        progressById: lifeProgressById,
        qualityState: qualityState,
      ),
    ),
    if (worldEnabled) ...worldState.recentLessonIds.map(
      (id) => _lessonRef(
        domain: LearnDomainType.world,
        lessonId: id,
        progressById: worldProgressById,
        qualityState: qualityState,
      ),
    ),
    if (hadithEnabled) ...hadithState.recentLessonIds.map(
      (id) => _lessonRef(
        domain: LearnDomainType.hadith,
        lessonId: id,
        progressById: hadithProgressById,
        qualityState: qualityState,
      ),
    ),
    ...quranNotes.take(4).map(
      (note) => LearnUnifiedLessonRef(
        domain: LearnDomainType.notes,
        lessonId: note.id,
        title: note.text.trim().isEmpty
            ? 'Qur\'an note ${note.surahNumber}:${note.ayahNumber}'
            : note.text.split('\n').first.trim(),
        subtitle: 'Linked to Qur\'an ${note.surahNumber}:${note.ayahNumber}',
        routeName: 'quranReader',
        pathParameters: {'surahNumber': note.surahNumber.toString()},
        queryParameters: {'ayah': note.ayahNumber.toString()},
        lastOpened: DateTime.tryParse(note.createdAtIso),
        status: LearnUnifiedStatus.inProgress,
        quality: qualityState.byLessonKey['notes:${note.id}'] ??
            LearnCompletionQuality.reflected,
      ),
    ),
  ].whereType<LearnUnifiedLessonRef>().toList()
    ..sort((a, b) {
      final aTime = a.lastOpened ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.lastOpened ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

  final dedupedRecent = <LearnUnifiedLessonRef>[];
  final seenKeys = <String>{};
  for (final item in recentItems) {
    final key = '${item.domain.name}:${item.lessonId}';
    if (seenKeys.add(key)) {
      dedupedRecent.add(item);
    }
    if (dedupedRecent.length >= 8) break;
  }

  final featuredItems = [
    if (quranEnabled)
      _quranRefFromLocation(
        surahNumber: quranDailyVerse.surahNumber,
        ayahNumber: quranDailyVerse.ayahNumber,
        surahMap: quranSurahMap,
        progress: _ProgressValue(
          status: LearnUnifiedStatus.inProgress,
          lastOpened: DateTime.now(),
        ),
        qualityState: qualityState,
      ),
    if (lifeEnabled)
      _lessonRef(
        domain: LearnDomainType.life,
        lessonId: lifeCurriculum.featuredLessonId,
        progressById: lifeProgressById,
        qualityState: qualityState,
      ),
    if (worldEnabled)
      _lessonRef(
        domain: LearnDomainType.world,
        lessonId: worldCurriculum.featuredLessonId,
        progressById: worldProgressById,
        qualityState: qualityState,
      ),
    if (hadithEnabled)
      _lessonRef(
        domain: LearnDomainType.hadith,
        lessonId: hadithCurriculum.featuredLessonId,
        progressById: hadithProgressById,
        qualityState: qualityState,
      ),
  ].whereType<LearnUnifiedLessonRef>().toList();

  if (continueItem == null && suggestedNext != null) {
    continueItem = suggestedNext;
  } else if (continueItem == null && featuredItems.isNotEmpty) {
    continueItem = featuredItems.first;
  }

  if (dedupedRecent.isEmpty && continueItem != null) {
    dedupedRecent.add(continueItem);
  }

  var totalQuranAyahs = 0;
  for (final surah in quranSurahs) {
    totalQuranAyahs += surah.verseCount;
  }
  var completedQuranAyahs = 0;
  for (final surah in quranSurahs) {
    if (surah.number < quranProgress.surahNumber) {
      completedQuranAyahs += surah.verseCount;
      continue;
    }
    if (surah.number == quranProgress.surahNumber) {
      completedQuranAyahs += quranProgress.ayahNumber.clamp(0, surah.verseCount);
      break;
    }
  }

  final domainProgress = [
    if (quranEnabled)
      LearnDomainProgressSummary(
        domain: LearnDomainType.quran,
        totalLessons: totalQuranAyahs <= 0 ? 1 : totalQuranAyahs,
        inProgressLessons: quranStreak > 0 ? 1 : 0,
        completedLessons: completedQuranAyahs.clamp(
          0,
          totalQuranAyahs <= 0 ? 1 : totalQuranAyahs,
        ),
      )
    else
      const LearnDomainProgressSummary(
        domain: LearnDomainType.quran,
        totalLessons: 0,
        inProgressLessons: 0,
        completedLessons: 0,
      ),
    LearnDomainProgressSummary(
      domain: LearnDomainType.life,
      totalLessons: lifeEnabled ? lifeSummary.totalLessons : 0,
      inProgressLessons: lifeEnabled ? lifeSummary.inProgressCount : 0,
      completedLessons: lifeEnabled ? lifeSummary.completedCount : 0,
    ),
    LearnDomainProgressSummary(
      domain: LearnDomainType.world,
      totalLessons: worldEnabled ? worldSummary.totalLessons : 0,
      inProgressLessons: worldEnabled ? worldSummary.inProgressCount : 0,
      completedLessons: worldEnabled ? worldSummary.completedCount : 0,
    ),
    LearnDomainProgressSummary(
      domain: LearnDomainType.hadith,
      totalLessons: hadithEnabled ? hadithSummary.totalLessons : 0,
      inProgressLessons: hadithEnabled ? hadithSummary.inProgressCount : 0,
      completedLessons: hadithEnabled ? hadithSummary.completedCount : 0,
    ),
    LearnDomainProgressSummary(
      domain: LearnDomainType.notes,
      totalLessons: quranNotes.length,
      inProgressLessons: quranNotes.isEmpty ? 0 : 1,
      completedLessons: 0,
    ),
  ];

  final overallTotal = domainProgress.fold<int>(
    0,
    (sum, item) => sum + item.totalLessons,
  );
  final overallInProgress = domainProgress.fold<int>(
    0,
    (sum, item) => sum + item.inProgressLessons,
  );
  final overallCompleted = domainProgress.fold<int>(
    0,
    (sum, item) => sum + item.completedLessons,
  );

  return LearnUnifiedSummary(
    continueItem: continueItem,
    suggestedNextItem: suggestedNext,
    recentItems: dedupedRecent,
    featuredItems: featuredItems,
    domainProgress: domainProgress,
    overallTotalLessons: overallTotal,
    overallInProgressLessons: overallInProgress,
    overallCompletedLessons: overallCompleted,
    selectedTrack: selectedTrack,
    trackTitle: trackTitles[selectedTrack] ?? selectedTrack.name,
    continueReason: continueReason,
  );
});

final learnCrossDomainRelatedProvider =
    Provider.family<List<LearnUnifiedLessonRef>, LearnRelatedQuery>((ref, key) {
  final lifeState = ref.watch(lifeProgressProvider);
  final worldState = ref.watch(worldProgressProvider);
  final hadithState = ref.watch(hadithProgressProvider);
  final qualityState = ref.watch(learnQualityProvider);
  final quranProgress = _ProgressValue(
    status: LearnUnifiedStatus.inProgress,
    lastOpened: DateTime.tryParse(
      ref.watch(quranReadingProgressProvider).updatedAtIso,
    ),
  );
  final quranSurahMap = ref.watch(quranSurahMapProvider);

  final lifeProgressById = <String, _ProgressValue>{};
  for (final entry in lifeState.lessonProgressById.entries) {
    lifeProgressById[entry.key] = _ProgressValue(
      status: _mapLifeStatus(entry.value.status),
      lastOpened: DateTime.tryParse(entry.value.lastOpenedIso ?? ''),
    );
  }
  final worldProgressById = <String, _ProgressValue>{};
  for (final entry in worldState.lessonProgressById.entries) {
    worldProgressById[entry.key] = _ProgressValue(
      status: _mapWorldStatus(entry.value.status),
      lastOpened: DateTime.tryParse(entry.value.lastOpenedIso ?? ''),
    );
  }
  final hadithProgressById = <String, _ProgressValue>{};
  for (final entry in hadithState.lessonProgressById.entries) {
    hadithProgressById[entry.key] = _ProgressValue(
      status: _mapHadithStatus(entry.value.status),
      lastOpened: DateTime.tryParse(entry.value.lastOpenedIso ?? ''),
    );
  }

  final mapKey = '${key.domain.name}:${key.lessonId}';
  final candidates = _crossDomainRelatedMap[mapKey] ?? const <LearnRelatedQuery>[];

  final output = <LearnUnifiedLessonRef>[];
  for (final candidate in candidates) {
    final item = _lookupItem(
      domain: candidate.domain,
      lessonId: candidate.lessonId,
      lifeProgressById: lifeProgressById,
      worldProgressById: worldProgressById,
      hadithProgressById: hadithProgressById,
      quranSurahMap: quranSurahMap,
      quranContinueProgress: quranProgress,
      qualityState: qualityState,
    );
    if (item != null) output.add(item);
  }
  return output;
});

final learnLessonCitationsProvider =
    Provider.family<List<LearnCitation>, LearnRelatedQuery>((ref, key) {
  switch (key.domain) {
    case LearnDomainType.quran:
      return [
        LearnCitation(
          sourceTitle: 'Qur\'an Arabic Text',
          qualityBadge: 'Primary',
          confidenceNote:
              'Canonical source text with direct reading linkage in-app.',
          reference: key.lessonId,
        ),
        const LearnCitation(
          sourceTitle: 'In-app Translation Layers',
          qualityBadge: 'Secondary',
          confidenceNote:
              'Translation wording varies by edition; use as study support.',
        ),
      ];
    case LearnDomainType.life:
      final lesson = lifeLessonById(key.lessonId);
      if (lesson == null) return const [];
      return [
        LearnCitation(
          sourceTitle: 'Life Curriculum: Qur\'anic Theme Synthesis',
          qualityBadge: 'Core',
          confidenceNote:
              'Structured educational summary anchored to Qur\'anic values.',
          reference: lesson.id,
        ),
        ...lesson.comparativeInsights.map(
          (item) => LearnCitation(
            sourceTitle: item.tradition,
            qualityBadge: item.referenceNote == null ? 'Medium' : 'Cross-ref',
            confidenceNote:
                'Comparative note used for thematic learning, not doctrinal equivalence.',
            reference: item.referenceNote,
          ),
        ),
      ];
    case LearnDomainType.world:
      final lesson = worldLessonById(key.lessonId);
      if (lesson == null) return const [];
      return [
        LearnCitation(
          sourceTitle: 'World Curriculum: Reflective Observation Layer',
          qualityBadge: 'Core',
          confidenceNote:
              'Observation prompts are pedagogical aids anchored to Qur\'anic signs.',
          reference: lesson.id,
        ),
        ...lesson.comparativeInsights.map(
          (item) => LearnCitation(
            sourceTitle: item.tradition,
            qualityBadge: item.referenceNote == null ? 'Medium' : 'Cross-ref',
            confidenceNote:
                'Comparative insight is thematic and intentionally non-polemical.',
            reference: item.referenceNote,
          ),
        ),
      ];
    case LearnDomainType.hadith:
      final lesson = hadithLessonById(key.lessonId);
      if (lesson == null) return const [];
      return [
        LearnCitation(
          sourceTitle: 'Hadith Curriculum: Thematic Study Layer',
          qualityBadge: 'Core',
          confidenceNote:
              'Lesson language is educational and defers detailed grading to specialist study.',
          reference: lesson.id,
        ),
        LearnCitation(
          sourceTitle: 'Related Qur\'anic Themes',
          qualityBadge: 'Cross-ref',
          confidenceNote:
              'Qur\'anic alignment note for thematic grounding and context.',
          reference: lesson.quranicConnection,
        ),
        ...lesson.comparativeInsights.map(
          (item) => LearnCitation(
            sourceTitle: item.tradition,
            qualityBadge: item.referenceNote == null ? 'Medium' : 'Cross-ref',
            confidenceNote:
                'Comparative summary is provided as moral resonance, not equivalence.',
            reference: item.referenceNote,
          ),
        ),
      ];
    case LearnDomainType.notes:
      return const [
        LearnCitation(
          sourceTitle: 'Personal Notes and Reflections',
          qualityBadge: 'Personal',
          confidenceNote:
              'User-authored entries. Validate externally before using as source claims.',
        ),
      ];
  }
});

LearnUnifiedStatus _mapLifeStatus(LifeLessonStatus status) {
  switch (status) {
    case LifeLessonStatus.notStarted:
      return LearnUnifiedStatus.notStarted;
    case LifeLessonStatus.inProgress:
      return LearnUnifiedStatus.inProgress;
    case LifeLessonStatus.completed:
      return LearnUnifiedStatus.completed;
  }
}

LearnUnifiedStatus _mapWorldStatus(WorldLessonStatus status) {
  switch (status) {
    case WorldLessonStatus.notStarted:
      return LearnUnifiedStatus.notStarted;
    case WorldLessonStatus.inProgress:
      return LearnUnifiedStatus.inProgress;
    case WorldLessonStatus.completed:
      return LearnUnifiedStatus.completed;
  }
}

LearnUnifiedStatus _mapHadithStatus(HadithLessonStatus status) {
  switch (status) {
    case HadithLessonStatus.notStarted:
      return LearnUnifiedStatus.notStarted;
    case HadithLessonStatus.inProgress:
      return LearnUnifiedStatus.inProgress;
    case HadithLessonStatus.completed:
      return LearnUnifiedStatus.completed;
  }
}

LearnUnifiedLessonRef? _lessonRef({
  required LearnDomainType domain,
  required String? lessonId,
  required Map<String, _ProgressValue> progressById,
  required LearnQualityState qualityState,
}) {
  if (lessonId == null || lessonId.isEmpty) return null;

  final progress = progressById[lessonId];

  switch (domain) {
    case LearnDomainType.quran:
      return null;
    case LearnDomainType.life:
      final lesson = lifeLessonById(lessonId);
      if (lesson == null) return null;
      return LearnUnifiedLessonRef(
        domain: domain,
        lessonId: lessonId,
        title: lesson.title,
        subtitle: lesson.subtitle,
        routeName: 'lifeLessonDetail',
        pathParameters: {'lessonId': lessonId},
        lastOpened: progress?.lastOpened,
        status: progress?.status ?? LearnUnifiedStatus.notStarted,
        quality: qualityState.byLessonKey['${domain.name}:$lessonId'] ??
            LearnCompletionQuality.notRead,
      );
    case LearnDomainType.world:
      final lesson = worldLessonById(lessonId);
      if (lesson == null) return null;
      return LearnUnifiedLessonRef(
        domain: domain,
        lessonId: lessonId,
        title: lesson.title,
        subtitle: lesson.subtitle,
        routeName: 'worldLessonDetail',
        pathParameters: {'lessonId': lessonId},
        lastOpened: progress?.lastOpened,
        status: progress?.status ?? LearnUnifiedStatus.notStarted,
        quality: qualityState.byLessonKey['${domain.name}:$lessonId'] ??
            LearnCompletionQuality.notRead,
      );
    case LearnDomainType.hadith:
      final lesson = hadithLessonById(lessonId);
      if (lesson == null) return null;
      return LearnUnifiedLessonRef(
        domain: domain,
        lessonId: lessonId,
        title: lesson.title,
        subtitle: lesson.subtitle,
        routeName: 'hadithLessonDetail',
        pathParameters: {'lessonId': lessonId},
        lastOpened: progress?.lastOpened,
        status: progress?.status ?? LearnUnifiedStatus.notStarted,
        quality: qualityState.byLessonKey['${domain.name}:$lessonId'] ??
            LearnCompletionQuality.notRead,
      );
    case LearnDomainType.notes:
      return null;
  }
}

String learnDomainLabelKey(LearnDomainType domain) {
  switch (domain) {
    case LearnDomainType.quran:
      return 'quran';
    case LearnDomainType.life:
      return 'life';
    case LearnDomainType.world:
      return 'world';
    case LearnDomainType.hadith:
      return 'hadith';
    case LearnDomainType.notes:
      return 'notes';
  }
}

LearnUnifiedLessonRef? _quranRefFromLocation({
  required int surahNumber,
  required int ayahNumber,
  required Map<int, QuranSurah> surahMap,
  required _ProgressValue progress,
  required LearnQualityState qualityState,
}) {
  final surah = surahMap[surahNumber];
  if (surah == null) return null;
  final title = '${surah.transliteratedName} $surahNumber:$ayahNumber';
  final subtitle = '${surah.englishName} • ${surah.arabicName}';
  return LearnUnifiedLessonRef(
    domain: LearnDomainType.quran,
    lessonId: '$surahNumber:$ayahNumber',
    title: title,
    subtitle: subtitle,
    routeName: 'quranReader',
    pathParameters: {'surahNumber': surahNumber.toString()},
    queryParameters: {'ayah': ayahNumber.toString()},
    lastOpened: progress.lastOpened,
    status: progress.status,
    quality: qualityState.byLessonKey['quran:$surahNumber:$ayahNumber'] ??
        LearnCompletionQuality.notRead,
  );
}

LearnRelatedQuery learnKeyFromLesson({
  required LearnDomainType domain,
  required String lessonId,
}) {
  return LearnRelatedQuery(domain, lessonId);
}

LearnUnifiedLessonRef? _lookupItem({
  required LearnDomainType domain,
  required String lessonId,
  required Map<String, _ProgressValue> lifeProgressById,
  required Map<String, _ProgressValue> worldProgressById,
  required Map<String, _ProgressValue> hadithProgressById,
  required Map<int, QuranSurah> quranSurahMap,
  required _ProgressValue quranContinueProgress,
  required LearnQualityState qualityState,
}) {
  switch (domain) {
    case LearnDomainType.quran:
      final parsed = _parseQuranId(lessonId);
      if (parsed == null) return null;
      return _quranRefFromLocation(
        surahNumber: parsed.$1,
        ayahNumber: parsed.$2,
        surahMap: quranSurahMap,
        progress: quranContinueProgress,
        qualityState: qualityState,
      );
    case LearnDomainType.life:
      return _lessonRef(
        domain: domain,
        lessonId: lessonId,
        progressById: lifeProgressById,
        qualityState: qualityState,
      );
    case LearnDomainType.world:
      return _lessonRef(
        domain: domain,
        lessonId: lessonId,
        progressById: worldProgressById,
        qualityState: qualityState,
      );
    case LearnDomainType.hadith:
      return _lessonRef(
        domain: domain,
        lessonId: lessonId,
        progressById: hadithProgressById,
        qualityState: qualityState,
      );
    case LearnDomainType.notes:
      return null;
  }
}

double _continueScore({
  required LearnUnifiedLessonRef item,
  required LearnTrackType selectedTrack,
}) {
  final now = DateTime.now();
  final openedAt = item.lastOpened ?? DateTime.fromMillisecondsSinceEpoch(0);
  final recencyHours = now.difference(openedAt).inMinutes / 60.0;
  final recencyWeight = 60 / (1 + (recencyHours / 8).clamp(0, 120));

  final statusWeight = switch (item.status) {
    LearnUnifiedStatus.inProgress => 22.0,
    LearnUnifiedStatus.completed => 6.0,
    LearnUnifiedStatus.notStarted => 2.0,
  };

  final qualityWeight = switch (item.quality) {
    LearnCompletionQuality.notRead => 0.0,
    LearnCompletionQuality.read => 5.0,
    LearnCompletionQuality.reflected => 9.0,
    LearnCompletionQuality.applied => 12.0,
  };

  final trackBonus = _trackDomainWeight(
    track: selectedTrack,
    domain: item.domain,
  );

  return recencyWeight + statusWeight + qualityWeight + trackBonus;
}

double _trackDomainWeight({
  required LearnTrackType track,
  required LearnDomainType domain,
}) {
  switch (track) {
    case LearnTrackType.beginner:
      return switch (domain) {
        LearnDomainType.quran => 9,
        LearnDomainType.life => 8,
        LearnDomainType.hadith => 7,
        LearnDomainType.world => 6,
        LearnDomainType.notes => 5,
      };
    case LearnTrackType.family:
      return switch (domain) {
        LearnDomainType.life => 10,
        LearnDomainType.hadith => 8,
        LearnDomainType.quran => 7,
        LearnDomainType.world => 5,
        LearnDomainType.notes => 6,
      };
    case LearnTrackType.character:
      return switch (domain) {
        LearnDomainType.hadith => 10,
        LearnDomainType.life => 9,
        LearnDomainType.quran => 7,
        LearnDomainType.world => 4,
        LearnDomainType.notes => 5,
      };
    case LearnTrackType.ramadan:
      return switch (domain) {
        LearnDomainType.quran => 11,
        LearnDomainType.hadith => 8,
        LearnDomainType.life => 7,
        LearnDomainType.world => 5,
        LearnDomainType.notes => 6,
      };
    case LearnTrackType.revert:
      return switch (domain) {
        LearnDomainType.quran => 10,
        LearnDomainType.life => 8,
        LearnDomainType.hadith => 8,
        LearnDomainType.world => 4,
        LearnDomainType.notes => 6,
      };
  }
}

bool _isDomainEnabled(
  LearnDomainType? domain,
  bool quranEnabled,
  bool lifeEnabled,
  bool worldEnabled,
  bool hadithEnabled,
) {
  if (domain == null) return false;
  return switch (domain) {
    LearnDomainType.quran => quranEnabled,
    LearnDomainType.life => lifeEnabled,
    LearnDomainType.world => worldEnabled,
    LearnDomainType.hadith => hadithEnabled,
    LearnDomainType.notes => true,
  };
}

String _buildContinueReason(
  LearnUnifiedLessonRef item, {
  required LearnTrackType selectedTrack,
}) {
  final reasons = <String>[];
  if (item.lastOpened != null &&
      DateTime.now().difference(item.lastOpened!).inHours < 30) {
    reasons.add('Recent activity');
  }
  if (item.status == LearnUnifiedStatus.inProgress) {
    reasons.add('In progress');
  }
  if (_trackDomainWeight(track: selectedTrack, domain: item.domain) >= 8) {
    reasons.add('Aligned with ${selectedTrack.name} track');
  }
  if (item.quality == LearnCompletionQuality.reflected ||
      item.quality == LearnCompletionQuality.applied) {
    reasons.add('Strong reflection quality');
  }
  if (reasons.isEmpty) {
    reasons.add('Balanced by recency and learning intent');
  }
  return reasons.take(2).join(' • ');
}

(int, int)? _parseQuranId(String id) {
  final parts = id.split(':');
  if (parts.length != 2) return null;
  final surah = int.tryParse(parts[0]);
  final ayah = int.tryParse(parts[1]);
  if (surah == null || ayah == null) return null;
  return (surah, ayah);
}
